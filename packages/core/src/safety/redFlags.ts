/**
 * Protocolo de Banderas Rojas (Red Flag Protocol).
 *
 * Cuando los instrumentos indican distrés severo o riesgo, la app deja de ser
 * un juego: se pausa la capa de gamificación (XP, rachas, barra de vida, metas
 * de gremio) y se muestran primero recursos de ayuda y rutas de derivación.
 *
 * Límites honestos del tamizaje:
 *  - GHQ-12, PSS-10 y WHO-5 NO preguntan por ideación suicida. Por eso, ante
 *    distrés severo se activa una pregunta de seguridad (tipo ítem 9 del
 *    PHQ-9), formulada con cuidado y con opción de no responder.
 *  - Los umbrales "severos" no tienen un corte universal: son provisionales,
 *    configurables y deben ser aprobados por el componente clínico del
 *    proyecto y el comité de ética.
 *  - Esta lógica NO diagnostica. Su única función es no dejar sola a una
 *    persona que puede estar en riesgo.
 */
export const RED_FLAG_PROTOCOL_VERSION = 'red-flag@1.0.0-provisional';

export type RedFlagLevel = 'NONE' | 'WATCH' | 'ELEVATED' | 'CRISIS';
export type GamificationMode = 'FULL' | 'GENTLE' | 'PAUSED';

export type RedFlagTrigger =
  | 'SELF_HARM_THOUGHTS_REPORTED'
  | 'HELP_REQUESTED'
  | 'WHO5_LIKELY_DEPRESSION'
  | 'GHQ12_SEVERE'
  | 'PSS10_HIGH_WITH_DISTRESS'
  | 'SUSTAINED_ACUTE_DISTRESS'
  | 'GHQ12_ABOVE_SCREENING'
  | 'WHO5_LOW'
  | 'PSS10_HIGH';

export interface RedFlagInput {
  ghq12?: { ghqScore: number; daysAgo: number };
  pss10?: { total: number; daysAgo: number };
  who5?: { pct: number; daysAgo: number };
  /** Últimos check-ins, el más reciente primero. */
  recentCheckIns?: { daysAgo: number; perceivedStress: number; mood?: number }[];
  /** Pregunta de seguridad: 0 nunca, 1 varios días, 2 más de la mitad, 3 casi todos. */
  safetyScreen?: { selfHarmThoughts: number | 'DECLINED'; daysAgo: number };
  /** La persona tocó "Necesito ayuda ahora". */
  helpRequested?: boolean;
}

export const RED_FLAG_CONFIG = {
  validityDays: 30,
  ghqScreening: 4,
  ghqSevere: 9,
  who5Low: 50,
  who5LikelyDepression: 28,
  pssHigh: 27,
  acuteStress: 9,
  acuteMoodMax: 1,
  acuteDays: 3,
  safetyScreenValidityDays: 14,
} as const;

export interface RedFlagAssessment {
  level: RedFlagLevel;
  triggers: RedFlagTrigger[];
  gamificationMode: GamificationMode;
  /** Mostrar la pregunta de seguridad (si no hay una reciente). */
  requiresSafetyScreen: boolean;
  /** Avisar al equipo de cuidado asignado (sujeto al consentimiento). */
  notifyCareTeam: boolean;
  showCrisisResources: boolean;
  protocolVersion: string;
}

const MODE: Record<RedFlagLevel, GamificationMode> = { NONE: 'FULL', WATCH: 'GENTLE', ELEVATED: 'PAUSED', CRISIS: 'PAUSED' };

export function assessRedFlags(i: RedFlagInput): RedFlagAssessment {
  const C = RED_FLAG_CONFIG;
  const fresh = <T extends { daysAgo: number }>(x: T | undefined, days: number = C.validityDays) => (x && x.daysAgo <= days ? x : undefined);
  const ghq = fresh(i.ghq12);
  const pss = fresh(i.pss10);
  const who5 = fresh(i.who5);
  const screen = fresh(i.safetyScreen, C.safetyScreenValidityDays);

  const crisis: RedFlagTrigger[] = [];
  const elevated: RedFlagTrigger[] = [];
  const watch: RedFlagTrigger[] = [];

  if (i.helpRequested) crisis.push('HELP_REQUESTED');
  if (screen && typeof screen.selfHarmThoughts === 'number' && screen.selfHarmThoughts >= 1) crisis.push('SELF_HARM_THOUGHTS_REPORTED');

  const distress = (ghq && ghq.ghqScore >= C.ghqScreening) || (who5 && who5.pct <= C.who5Low);
  if (who5 && who5.pct <= C.who5LikelyDepression) elevated.push('WHO5_LIKELY_DEPRESSION');
  if (ghq && ghq.ghqScore >= C.ghqSevere) elevated.push('GHQ12_SEVERE');
  if (pss && pss.total >= C.pssHigh && distress) elevated.push('PSS10_HIGH_WITH_DISTRESS');

  const recent = [...(i.recentCheckIns ?? [])].sort((a, b) => a.daysAgo - b.daysAgo);
  let acute = 0;
  for (const [idx, c] of recent.entries()) {
    if (c.daysAgo !== idx || c.perceivedStress < C.acuteStress || (c.mood ?? 5) > C.acuteMoodMax) break;
    acute++;
  }
  if (acute >= C.acuteDays) elevated.push('SUSTAINED_ACUTE_DISTRESS');

  if (ghq && ghq.ghqScore >= C.ghqScreening && ghq.ghqScore < C.ghqSevere) watch.push('GHQ12_ABOVE_SCREENING');
  if (who5 && who5.pct <= C.who5Low && who5.pct > C.who5LikelyDepression) watch.push('WHO5_LOW');
  if (pss && pss.total >= C.pssHigh && !distress) watch.push('PSS10_HIGH');

  const level: RedFlagLevel = crisis.length ? 'CRISIS' : elevated.length ? 'ELEVATED' : watch.length ? 'WATCH' : 'NONE';
  return {
    level,
    triggers: [...crisis, ...elevated, ...watch],
    gamificationMode: MODE[level],
    requiresSafetyScreen: level === 'ELEVATED' && !screen,
    notifyCareTeam: level === 'CRISIS' || level === 'ELEVATED',
    showCrisisResources: level === 'CRISIS' || level === 'ELEVATED',
    protocolVersion: RED_FLAG_PROTOCOL_VERSION,
  };
}

/**
 * La pausa NUNCA se levanta solo por tiempo. Se reanuda la gamificación si:
 *  - un profesional registró el contacto/seguimiento, o
 *  - pasaron ≥ 7 días y una nueva evaluación ya no muestra el nivel que la activó.
 */
export function canResumeGamification(e: {
  openedDaysAgo: number;
  professionalFollowUpRecorded: boolean;
  currentLevel: RedFlagLevel;
}): boolean {
  if (e.professionalFollowUpRecorded) return e.currentLevel !== 'CRISIS';
  return e.openedDaysAgo >= 7 && (e.currentLevel === 'NONE' || e.currentLevel === 'WATCH');
}
