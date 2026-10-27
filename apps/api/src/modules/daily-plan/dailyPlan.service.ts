import type { Prisma, PrismaClient } from '@prisma/client';
import {
  buildDailyPlan,
  GHQ12_DEFAULT_CUTOFF,
  patternsBlockedByInjuries,
  type DailyCheckInInput,
  type DailyPlan,
  type FmsPattern,
  type PlayerContext,
  type ViaStrength,
} from '@sifus/core';

import { DAY_MS, daysBetween, toDate } from '../../shared/dates';
import type { PassiveDataService } from '../passive/passive.service';
import type { RedFlagService } from '../safety/redFlag.service';

/**
 * Orquesta el Mapeo de Vulnerabilidad Activa contra la base operacional:
 *  1. guarda el check-in,
 *  2. arma el PlayerContext (anamnesis, instrumentos, historial reciente),
 *  3. ejecuta el algoritmo puro de @sifus/core,
 *  4. persiste el plan con su versión e insumos (auditable y reproducible).
 *
 * La lógica de decisión NO vive aquí: este servicio solo lee y escribe.
 */
export class DailyPlanService {
  constructor(
    private readonly db: PrismaClient,
    private readonly passive: PassiveDataService,
    private readonly safety: RedFlagService,
  ) {}

  async submitCheckIn(userId: string, input: DailyCheckInInput): Promise<DailyPlan> {
    const date = toDate(input.date);
    const checkIn = await this.db.dailyCheckIn.upsert({
      where: { userId_date: { userId, date } },
      create: { userId, ...this.checkInData(input), date },
      update: this.checkInData(input),
    });

    // El protocolo de banderas rojas se evalúa ANTES de decidir el plan.
    const { assessment: redFlag } = await this.safety.evaluate(userId);
    const ctx = await this.buildContext(userId, date);
    ctx.redFlag = redFlag;
    ctx.passive = await this.passive.readinessContext(userId, input.date).catch(() => undefined);
    const plan = buildDailyPlan(input, ctx);
    await this.persist(plan, checkIn.id);
    return plan;
  }

  private checkInData(c: DailyCheckInInput) {
    return {
      sleepHours: c.sleepHours,
      sleepQuality: c.sleepQuality,
      perceivedStress: c.perceivedStress,
      mentalFatigue: c.mentalFatigue,
      physicalFatigue: c.physicalFatigue,
      painLevel: c.painLevel,
      mood: c.mood,
      feelsIsolated: c.feelsIsolated,
    };
  }

  async buildContext(userId: string, today: Date): Promise<PlayerContext> {
    const [profile, anamnesis, clinical, pss, ghq, mspss, fms, recentPlans, strengths, injuries] = await Promise.all([
      this.db.playerProfile.findUniqueOrThrow({ where: { userId } }),
      this.db.anamnesis.findFirstOrThrow({ where: { userId }, orderBy: { recordedAt: 'desc' } }),
      this.db.clinicalHistory.findUnique({ where: { userId } }),
      this.latestQuestionnaire(userId, 'PSS_10'),
      this.latestQuestionnaire(userId, 'GHQ_12'),
      this.latestQuestionnaire(userId, 'MSPSS'),
      this.db.fmsScreen.findFirst({
        where: { assessment: { userId } },
        orderBy: { assessment: { assessedAt: 'desc' } },
        include: { patterns: true },
      }),
      this.db.dailyPlan.findMany({
        where: { userId, date: { gte: new Date(today.getTime() - 7 * DAY_MS), lt: today } },
        orderBy: { date: 'desc' },
        include: { missions: { include: { template: true } } },
      }),
      this.db.playerStrength.findMany({ where: { userId }, orderBy: { equippedAt: 'asc' } }),
      this.db.injuryRecord.findMany({ where: { userId, status: { not: 'RESOLVED' } } }),
    ]);

    const enrolled = profile.onboardingCompletedAt ?? profile.createdAt;

    return {
      userId,
      // Solo se conoce el año de nacimiento (de-identificación): ±1 año.
      ageYears: today.getUTCFullYear() - profile.birthYear,
      spiritualOrientation: profile.spiritualOrientation,
      experience: anamnesis.trainingExperience,
      weeksInProgram: Math.floor(daysBetween(enrolled, today) / 7),
      avgSessionMinutes: anamnesis.avgSessionMinutes,
      requiresMedicalClearance: Boolean(clinical?.requiresMedicalClearance && !clinical.clearanceGrantedAt),
      latestPss10: pss?.totalScore != null
        ? { total: Number(pss.totalScore), daysAgo: daysBetween(pss.completedAt, today) }
        : undefined,
      latestGhq12: ghq?.totalScore != null
        ? { aboveCutoff: Number(ghq.totalScore) >= GHQ12_DEFAULT_CUTOFF, daysAgo: daysBetween(ghq.completedAt, today) }
        : undefined,
      mspssMean: mspss?.totalScore != null ? Number(mspss.totalScore) : undefined,
      fms: {
        // Patrón doloroso en el FMS o región con lesión activa → sin carga.
        painfulPatterns: [...new Set([
          ...(fms?.patterns.filter((p) => p.finalScore === 0).map((p) => p.pattern as FmsPattern) ?? []),
          ...patternsBlockedByInjuries(injuries),
        ])],
        priorityPatterns: fms?.patterns.filter((p) => p.finalScore === 1).map((p) => p.pattern as FmsPattern) ?? [],
      },
      recentDays: recentPlans.map((p) => ({
        daysAgo: daysBetween(p.date, today),
        band: p.band,
        highIntensityCompleted: p.missions.some(
          (m) => m.template.intensity === 'HIGH' && (m.status === 'COMPLETED' || m.status === 'ADAPTED'),
        ),
      })),
      equippedStrengths: strengths.map((s) => s.strength as ViaStrength),
    };
  }

  private latestQuestionnaire(userId: string, instrument: 'PSS_10' | 'GHQ_12' | 'MSPSS') {
    return this.db.questionnaireAdministration.findFirst({
      where: { userId, instrument },
      orderBy: { completedAt: 'desc' },
    });
  }

  private async persist(plan: DailyPlan, checkInId: string): Promise<void> {
    const templates = await this.db.missionTemplate.findMany({
      where: { code: { in: plan.missions.map((m) => m.template.code) } },
      select: { id: true, code: true },
    });
    const idByCode = new Map(templates.map((t) => [t.code, t.id]));
    const date = toDate(plan.date);

    const data = {
      checkInId,
      band: plan.band,
      loadScore: plan.loadScore,
      rpeCap: plan.rpeCap,
      blockedIntensities: plan.blockedIntensities,
      reasonCodes: plan.reasonCodes,
      safetyFlags: plan.safetyFlags,
      algorithmVersion: plan.algorithmVersion,
      inputSnapshot: plan.inputSnapshot as unknown as Prisma.InputJsonValue,
    };

    await this.db.$transaction(async (tx) => {
      // Si la persona corrige su check-in el mismo día, el plan se recalcula.
      // Las misiones ya completadas se conservan: su esfuerzo no se borra.
      const saved = await tx.dailyPlan.upsert({
        where: { userId_date: { userId: plan.userId, date } },
        create: { userId: plan.userId, date, ...data },
        update: data,
      });
      await tx.dailyMission.deleteMany({ where: { planId: saved.id, status: 'ASSIGNED' } });
      await tx.dailyMission.createMany({
        data: plan.missions.map((m) => {
          const templateId = idByCode.get(m.template.code);
          if (!templateId) throw new Error(`Misión ${m.template.code} no existe en mission_templates (correr seed)`);
          return { planId: saved.id, templateId, slot: m.slot };
        }),
      });
      const alreadyRewarded = await tx.xpEvent.findFirst({ where: { source: 'CHECK_IN', sourceId: checkInId } });
      if (!alreadyRewarded) {
        await tx.xpEvent.create({
          data: { userId: plan.userId, source: 'CHECK_IN', sourceId: checkInId, amount: plan.checkInXp },
        });
      }
    });
  }
}
