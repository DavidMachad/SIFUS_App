import type { Instrument, Prisma, PrismaClient } from '@prisma/client';
import {
  compareToNorm,
  computeWellbeingIndex,
  crossValidate,
  facitPct,
  findNorm,
  ORIENTATION_PROFILES,
  swbsPct,
  totalSleepMinutes,
  type ComponentInput,
  type DayEvidence,
  type ReferenceNorm,
  type WellbeingIndexResult,
} from '@sifus/core';
import { addDays, isoDay, toDate } from '../../shared/dates';
import type { PassiveDataService } from '../passive/passive.service';

/**
 * Calcula y guarda el Índice de Vida Consolidado del día.
 * Reúne: cuestionarios validados (vigentes), pruebas del evaluador, datos
 * pasivos de 7 días y el Micro-PANAS de 7 días; aplica la validación cruzada
 * para ponderar el autorreporte; persiste un snapshot auditable.
 */
export class WellbeingService {
  constructor(private readonly db: PrismaClient, private readonly passive: PassiveDataService) {}

  async computeAndStore(userId: string, date: string): Promise<WellbeingIndexResult> {
    const today = toDate(date);
    const weekAgo = addDays(today, -6);
    const profile = await this.db.playerProfile.findUniqueOrThrow({ where: { userId } });
    const ageYears = today.getUTCFullYear() - profile.birthYear;
    const orientation = ORIENTATION_PROFILES[profile.spiritualOrientation];
    const inputs: ComponentInput[] = [];
    const push = (key: ComponentInput['key'], value: number | null | undefined, on: Date) => {
      if (value !== null && value !== undefined && Number.isFinite(value)) inputs.push({ key, value, measuredOn: isoDay(on) });
    };

    // --- Cuestionarios validados (el más reciente de cada uno) ---------------------
    const latest = (instrument: Instrument) =>
      this.db.questionnaireAdministration.findFirst({ where: { userId, instrument }, orderBy: { completedAt: 'desc' } });
    const [who5, ghq, ipaq, psqi, ais, pss, medas, facit, pil, swbs] = await Promise.all(
      (['WHO_5', 'GHQ_12', 'IPAQ_SF', 'PSQI', 'AIS', 'PSS_10', 'MEDAS', 'FACIT_SP_12', 'PIL', 'SWBS'] as Instrument[]).map(latest),
    );
    // null/ausente → undefined (ojo: Number(null) sería 0).
    const sub = (q: { subscaleScores: Prisma.JsonValue } | null, k: string): number | undefined => {
      const v = q?.subscaleScores && typeof q.subscaleScores === 'object' ? (q.subscaleScores as Record<string, unknown>)[k] : undefined;
      return typeof v === 'number' && Number.isFinite(v) ? v : undefined;
    };
    if (who5) push('WHO5_PCT', Number(who5.totalScore), who5.completedAt);
    if (ghq) push('GHQ12_LIKERT', sub(ghq, 'likert'), ghq.completedAt);
    if (ipaq) push('IPAQ_MET_MIN', Number(ipaq.totalScore), ipaq.completedAt);
    if (psqi) push('PSQI_GLOBAL', Number(psqi.totalScore), psqi.completedAt);
    if (ais) push('AIS_TOTAL', Number(ais.totalScore), ais.completedAt);
    if (pss) push('PSS10_TOTAL', Number(pss.totalScore), pss.completedAt);
    if (medas) push('MEDAS_NORMALIZED', sub(medas, 'normalized'), medas.completedAt);
    if (facit) {
      // La versión aplicada (12 u 8 ítems) depende de la orientación espiritual.
      const hasFaith = sub(facit, 'faith') !== undefined;
      push('FACIT_SP_PCT', facitPct(Number(facit.totalScore), hasFaith && orientation.facitIncludeFaith), facit.completedAt);
    }
    if (pil) push('PIL_TOTAL', Number(pil.totalScore), pil.completedAt);
    if (swbs) {
      const r = sub(swbs, 'religious');
      const e = sub(swbs, 'existential');
      if (r !== undefined && e !== undefined) push('SWBS_PCT', swbsPct({ religious: r, existential: e }, orientation.swbsScope), swbs.completedAt);
    }

    // --- Pruebas del evaluador (solo fuente EVALUATOR) ----------------------------
    const lastAssessment = await this.db.assessment.findFirst({
      where: { userId, source: 'EVALUATOR' },
      orderBy: { assessedAt: 'desc' },
      include: { fmsScreen: true, dynamometry: true, anthropometry: true, perimeters: true, strengthTests: true },
    });
    if (lastAssessment) {
      const on = lastAssessment.assessedAt;
      const norms = await this.loadNorms();
      const sex = profile.sexForReference === 'FEMALE' || profile.sexForReference === 'MALE' ? profile.sexForReference : 'ANY';
      if (lastAssessment.fmsScreen) push('FMS_TOTAL', lastAssessment.fmsScreen.totalScore, on);
      const grip = lastAssessment.dynamometry.find((d) => d.isDominant);
      const gripNorm = findNorm(norms, 'GRIP_DOMINANT_KG', sex, ageYears);
      if (grip && gripNorm) push('GRIP_PERCENTILE', compareToNorm(Number(grip.bestKg), gripNorm).percentile, on);
      const weight = lastAssessment.anthropometry ? Number(lastAssessment.anthropometry.weightKg) : undefined;
      const squat = lastAssessment.strengthTests.filter((t) => t.exercise === 'DEEP_SQUAT' && t.techniqueValid);
      const squatNorm = findNorm(norms, 'SQUAT_1RM_REL', sex, ageYears);
      if (squat.length && weight && squatNorm) {
        const rel = Math.max(...squat.map((t) => Number(t.estimated1RmKg))) / weight;
        push('STRENGTH_REL_PERCENTILE', compareToNorm(rel, squatNorm).percentile, on);
      }
      const waist = lastAssessment.perimeters.find((p) => p.site === 'WAIST');
      if (waist && lastAssessment.anthropometry) push('WAIST_HEIGHT_RATIO', Number(waist.valueCm) / Number(lastAssessment.anthropometry.heightCm), on);
    }

    // --- Pasivos y autorreporte diario de 7 días --------------------------------
    const passiveRows = await this.passive.series(
      userId, ['STEPS', 'SLEEP_ASLEEP_MIN', 'SLEEP_DEEP_MIN', 'SLEEP_REM_MIN'], weekAgo, today,
    );
    const mean = (xs: number[]) => (xs.length ? xs.reduce((a, b) => a + b, 0) / xs.length : undefined);
    const steps = passiveRows.filter((r) => r.metric === 'STEPS').map((r) => r.value);
    if (steps.length >= 4) push('STEPS_7D', mean(steps), today);
    const nights = new Map<string, Record<string, number>>();
    for (const r of passiveRows.filter((x) => x.metric.startsWith('SLEEP_'))) {
      nights.set(r.date, { ...(nights.get(r.date) ?? {}), [r.metric]: r.value });
    }
    const sleepHoursByDate = new Map([...nights].map(([d, m]) => [d, (totalSleepMinutes(m) ?? 0) / 60]));
    if (sleepHoursByDate.size >= 4) push('PASSIVE_SLEEP_HOURS_7D', mean([...sleepHoursByDate.values()]), today);

    const hrvZs: { date: string; z: number }[] = [];
    for (let i = 0; i < 7; i++) {
      const d = isoDay(addDays(today, -i));
      const ctx = await this.passive.readinessContext(userId, d);
      if (ctx?.hrvZ !== undefined) hrvZs.push({ date: d, z: ctx.hrvZ });
    }
    if (hrvZs.length >= 4) push('HRV_Z_7D', mean(hrvZs.map((h) => h.z)), today);

    const [panas, checkIns] = await Promise.all([
      this.db.questionnaireAdministration.findMany({ where: { userId, instrument: 'I_PANAS_SF', completedAt: { gte: weekAgo } } }),
      this.db.dailyCheckIn.findMany({ where: { userId, date: { gte: weekAgo, lte: today } } }),
    ]);
    if (panas.length >= 3) push('PANAS_BALANCE_7D', mean(panas.map((p) => Number(p.totalScore))), today);

    // --- Validación cruzada autorreporte ↔ sensores -----------------------------
    const evidence: DayEvidence[] = checkIns.map((c) => {
      const d = isoDay(c.date);
      const p = panas.find((x) => isoDay(x.completedAt) === d);
      return {
        date: d,
        selfSleepHours: Number(c.sleepHours),
        selfStress: c.perceivedStress,
        panasBalance: p ? Number(p.totalScore) : undefined,
        passiveSleepHours: sleepHoursByDate.get(d),
        hrvZ: hrvZs.find((h) => h.date === d)?.z,
      };
    });
    const consistency = crossValidate(evidence);

    const result = computeWellbeingIndex(inputs, { date, ageYears, selfReportReliability: consistency.selfReportReliability });
    const dom = (k: string) => result.domains.find((d) => d.domain === k)?.score ?? null;
    const data = {
      index: result.index,
      status: result.status,
      mindScore: dom('MIND'), bodyScore: dom('BODY'), restorationScore: dom('RESTORATION'),
      lifestyleScore: dom('LIFESTYLE'), purposeScore: dom('PURPOSE'),
      breakdown: result.domains as unknown as Prisma.InputJsonValue,
      confidence: result.confidence,
      selfReportReliability: consistency.selfReportReliability,
      consistencyFlags: consistency.flags,
      version: result.version,
    };
    await this.db.wellbeingIndexSnapshot.upsert({
      where: { userId_date: { userId, date: today } },
      create: { userId, date: today, ...data },
      update: data,
    });
    return result;
  }

  private async loadNorms(): Promise<ReferenceNorm[]> {
    const rows = await this.db.referenceNorm.findMany();
    return rows.map((r) => ({
      measureCode: r.measureCode,
      sex: r.sex as ReferenceNorm['sex'],
      ageMin: r.ageMin,
      ageMax: r.ageMax,
      method: r.method as unknown as ReferenceNorm['method'],
      citation: r.citation,
    }));
  }
}
