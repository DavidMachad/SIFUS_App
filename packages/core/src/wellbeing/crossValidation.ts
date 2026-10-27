/**
 * Detección de sesgos y validación cruzada autorreporte ↔ datos pasivos.
 *
 * Objetivo: que la "barra de vida" refleje el bienestar y no el deseo de
 * subirla. Principios éticos implementados:
 *  1. Una inconsistencia NO es una acusación: los sensores fallan (reloj mal
 *     puesto, batería), y el alcohol, la enfermedad o un turno nocturno alteran
 *     la fisiología. Las banderas solo bajan el PESO del autorreporte en el
 *     índice e invitan a una conversación amable.
 *  2. ASIMETRÍA DE SEGURIDAD: un autorreporte de malestar nunca se descarta por
 *     lo que diga un sensor. Esta función solo evalúa autorreportes FAVORABLES
 *     que el cuerpo no respalda; el protocolo de banderas rojas usa siempre el
 *     autorreporte crudo.
 *  3. Nada aquí se muestra como "trampa" a la persona ni resta XP.
 */

export interface DayEvidence {
  date: string;
  /** Autorreporte. */
  selfSleepHours?: number;
  selfStress?: number; // 1–10
  panasBalance?: number; // PA − NA (−20..20)
  /** Pasivo. */
  passiveSleepHours?: number;
  hrvZ?: number; // z frente a la línea de base personal (ln HRV)
  restingHrDeltaBpm?: number; // FC reposo − media personal
}

export interface ResponseQualityInput {
  itemResponses: number[];
  /** Índices (base 0) de ítems invertidos: responder igual en todos es incoherente. */
  reversedItemIndexes: number[];
  totalSeconds?: number;
}

export type ConsistencyFlag =
  | 'SLEEP_SELF_REPORT_EXCEEDS_PASSIVE'
  | 'FAVORABLE_AFFECT_WITH_PHYSIOLOGICAL_STRAIN'
  | 'QUESTIONNAIRE_STRAIGHTLINING'
  | 'QUESTIONNAIRE_TOO_FAST';

export interface ConsistencyReport {
  flags: ConsistencyFlag[];
  /** Multiplicador (0.5–1) del peso del autorreporte diario en el índice. */
  selfReportReliability: number;
  daysCompared: number;
  /** Mensaje para la persona: curiosidad, no sospecha. */
  gentlePrompt: string | null;
}

export const CROSS_VALIDATION_CONFIG = {
  sleepDiscrepancyHours: 1.5,
  strainHrvZ: -1.5,
  strainRhrDelta: 5,
  favorableBalance: 10,
  favorableStressMax: 3,
  minDaysFlagged: 3,
  windowDays: 7,
  minSecondsPerItem: 1.5,
} as const;

export function crossValidate(days: DayEvidence[]): ConsistencyReport {
  const C = CROSS_VALIDATION_CONFIG;
  const recent = [...days].sort((a, b) => b.date.localeCompare(a.date)).slice(0, C.windowDays);
  const flags: ConsistencyFlag[] = [];

  const sleepPairs = recent.filter((d) => d.selfSleepHours !== undefined && d.passiveSleepHours !== undefined);
  const sleepOver = sleepPairs.filter((d) => d.selfSleepHours! - d.passiveSleepHours! > C.sleepDiscrepancyHours).length;
  if (sleepOver >= C.minDaysFlagged) flags.push('SLEEP_SELF_REPORT_EXCEEDS_PASSIVE');

  const strainDays = recent.filter((d) => {
    const favorable = (d.panasBalance ?? -99) >= C.favorableBalance && (d.selfStress ?? 99) <= C.favorableStressMax;
    const strain = (d.hrvZ ?? 0) <= C.strainHrvZ && (d.restingHrDeltaBpm ?? 0) >= C.strainRhrDelta;
    return favorable && strain;
  }).length;
  if (strainDays >= C.minDaysFlagged) flags.push('FAVORABLE_AFFECT_WITH_PHYSIOLOGICAL_STRAIN');

  const selfReportReliability = Math.max(0.5, 1 - 0.25 * flags.length);
  return {
    flags,
    selfReportReliability,
    daysCompared: Math.max(sleepPairs.length, recent.filter((d) => d.hrvZ !== undefined).length),
    gentlePrompt: flags.length
      ? 'Tu cuerpo y tu reporte cuentan historias un poco distintas estos días. ¿Quieres revisar juntos cómo has descansado? No hay respuestas correctas.'
      : null,
  };
}

/** Calidad de respuesta de un cuestionario (respuesta descuidada). */
export function questionnaireResponseQuality(q: ResponseQualityInput): ConsistencyFlag[] {
  const flags: ConsistencyFlag[] = [];
  const allSame = q.itemResponses.length > 3 && q.itemResponses.every((v) => v === q.itemResponses[0]);
  if (allSame && q.reversedItemIndexes.length > 0) flags.push('QUESTIONNAIRE_STRAIGHTLINING');
  if (q.totalSeconds !== undefined && q.totalSeconds / q.itemResponses.length < CROSS_VALIDATION_CONFIG.minSecondsPerItem) {
    flags.push('QUESTIONNAIRE_TOO_FAST');
  }
  return flags;
}
