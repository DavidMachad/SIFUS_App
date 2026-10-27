import type { PrismaClient, RedFlagEvent } from '@prisma/client';
import {
  assessRedFlags,
  canResumeGamification,
  resourcesFor,
  type CrisisResource,
  type RedFlagAssessment,
  type RedFlagLevel,
} from '@sifus/core';
import { aadFor, type FieldCipher } from '../../security/fieldEncryption';
import { activeConsent } from '../../shared/consent';
import { daysBetween } from '../../shared/dates';

/**
 * Canal hacia el equipo de cuidado (correo institucional, panel del
 * facilitador, SMS). Solo recibe el id del evento y el nivel: los detalles
 * clínicos se consultan dentro del sistema, con control de acceso.
 */
export interface CareTeamNotifier {
  notify(event: { eventId: string; level: RedFlagLevel; openedAt: Date }): Promise<void>;
}

const RANK: Record<RedFlagLevel, number> = { NONE: 0, WATCH: 1, ELEVATED: 2, CRISIS: 3 };

export interface SafetyStatus {
  assessment: RedFlagAssessment;
  openEvent: RedFlagEvent | null;
  resources: CrisisResource[];
}

export class RedFlagService {
  constructor(
    private readonly db: PrismaClient,
    private readonly notifier: CareTeamNotifier,
    private readonly cipher: FieldCipher,
  ) {}

  /**
   * Evalúa el protocolo con los datos más recientes. Se llama después de cada
   * cuestionario, cada check-in y cada pregunta de seguridad.
   */
  async evaluate(userId: string, now = new Date(), opts: { helpRequested?: boolean } = {}): Promise<SafetyStatus> {
    const assessment = await this.rawAssessment(userId, now, opts);
    let openEvent = await this.db.redFlagEvent.findFirst({ where: { userId, resolvedAt: null }, orderBy: { openedAt: 'desc' } });

    // Abrir (o escalar) un evento solo para ELEVATED/CRISIS.
    if (RANK[assessment.level] >= RANK.ELEVATED && (!openEvent || RANK[assessment.level] > RANK[openEvent.level])) {
      openEvent = await this.db.redFlagEvent.create({
        data: {
          userId, level: assessment.level, triggers: assessment.triggers,
          gamificationMode: assessment.gamificationMode, protocolVersion: assessment.protocolVersion,
        },
      });
      const consent = await activeConsent(this.db, userId);
      if (assessment.notifyCareTeam && consent?.allowsCareTeamAlerts) {
        await this.notifier.notify({ eventId: openEvent.id, level: assessment.level, openedAt: openEvent.openedAt });
        openEvent = await this.db.redFlagEvent.update({ where: { id: openEvent.id }, data: { careTeamNotifiedAt: new Date() } });
      }
    }

    // Mientras haya un evento abierto, la pausa se mantiene aunque los datos mejoren.
    const effective: RedFlagAssessment = openEvent && RANK[openEvent.level] > RANK[assessment.level]
      ? { ...assessment, level: openEvent.level, gamificationMode: 'PAUSED', showCrisisResources: true }
      : assessment;

    const profile = await this.db.playerProfile.findUnique({ where: { userId }, select: { municipalityCode: true } });
    return {
      assessment: effective,
      openEvent,
      resources: effective.showCrisisResources ? resourcesFor(profile?.municipalityCode ?? undefined) : [],
    };
  }

  /** Nivel según los datos actuales, sin el arrastre de un evento abierto. */
  private async rawAssessment(userId: string, now: Date, opts: { helpRequested?: boolean }): Promise<RedFlagAssessment> {
    const latest = (instrument: 'GHQ_12' | 'PSS_10' | 'WHO_5' | 'SAFETY_SCREEN') =>
      this.db.questionnaireAdministration.findFirst({ where: { userId, instrument }, orderBy: { completedAt: 'desc' } });
    const [ghq, pss, who5, screen, checkIns] = await Promise.all([
      latest('GHQ_12'), latest('PSS_10'), latest('WHO_5'), latest('SAFETY_SCREEN'),
      this.db.dailyCheckIn.findMany({ where: { userId }, orderBy: { date: 'desc' }, take: 7 }),
    ]);
    const ago = (d: Date) => daysBetween(d, now);
    const screenAnswer = (screen?.itemResponses as { selfHarmThoughts?: number | 'DECLINED' } | null)?.selfHarmThoughts;

    return assessRedFlags({
      ghq12: ghq?.totalScore != null ? { ghqScore: Number(ghq.totalScore), daysAgo: ago(ghq.completedAt) } : undefined,
      pss10: pss?.totalScore != null ? { total: Number(pss.totalScore), daysAgo: ago(pss.completedAt) } : undefined,
      who5: who5?.totalScore != null ? { pct: Number(who5.totalScore), daysAgo: ago(who5.completedAt) } : undefined,
      safetyScreen: screen && screenAnswer !== undefined ? { selfHarmThoughts: screenAnswer, daysAgo: ago(screen.completedAt) } : undefined,
      recentCheckIns: checkIns.map((c) => ({ daysAgo: ago(c.date), perceivedStress: c.perceivedStress, mood: c.mood ?? undefined })),
      helpRequested: opts.helpRequested,
    });
  }

  /** Botón "Necesito ayuda ahora": siempre visible, incluso en modo de juego completo. */
  requestHelp(userId: string) {
    return this.evaluate(userId, new Date(), { helpRequested: true });
  }

  /** Registro del primer contacto humano por el profesional (notas cifradas). */
  async recordProfessionalContact(eventId: string, notes: string) {
    const ev = await this.db.redFlagEvent.findUniqueOrThrow({ where: { id: eventId } });
    return this.db.redFlagEvent.update({
      where: { id: eventId },
      data: {
        professionalContactAt: ev.professionalContactAt ?? new Date(),
        followUpNotesCiphertext: await this.cipher.encrypt(notes, aadFor('red_flag_events', 'followUpNotes', ev.userId)),
      },
    });
  }

  /** Cierre: solo si se cumplen las condiciones de canResumeGamification. */
  async tryResolve(eventId: string, resolution: string, now = new Date()): Promise<boolean> {
    const ev = await this.db.redFlagEvent.findUniqueOrThrow({ where: { id: eventId } });
    const current = await this.rawAssessment(ev.userId, now, {});
    const ok = canResumeGamification({
      openedDaysAgo: daysBetween(ev.openedAt, now),
      professionalFollowUpRecorded: Boolean(ev.professionalContactAt),
      currentLevel: current.level,
    });
    if (ok) await this.db.redFlagEvent.update({ where: { id: eventId }, data: { resolvedAt: now, resolution } });
    return ok;
  }
}
