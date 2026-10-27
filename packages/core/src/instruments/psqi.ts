import { InstrumentValidationError, type ScoredInstrument } from './common';

/**
 * Índice de Calidad de Sueño de Pittsburgh (PSQI; Buysse et al., 1989).
 * 7 componentes (0–3) → puntaje global 0–21; > 5 = mala calidad de sueño.
 */
export const PSQI_SCORING_VERSION = 'psqi@1.0.0';

export interface PsqiInput {
  /** P1: hora de acostarse "HH:MM". */
  bedtime: string;
  /** P2: minutos para dormirse. */
  sleepLatencyMinutes: number;
  /** P3: hora de levantarse "HH:MM". */
  wakeTime: string;
  /** P4: horas de sueño efectivo. */
  hoursSlept: number;
  /** P5a–P5j: frecuencia de problemas (0–3). 5a = no dormirse en 30 min. */
  disturbances: { a: number; b: number; c: number; d: number; e: number; f: number; g: number; h: number; i: number; j?: number };
  /** P6: calidad subjetiva (0 muy buena – 3 muy mala). */
  subjectiveQuality: number;
  /** P7: uso de medicación para dormir (0–3). */
  sleepMedication: number;
  /** P8: dificultad para mantenerse despierto (0–3). */
  daytimeSleepiness: number;
  /** P9: problemas de ánimo para hacer las cosas (0–3). */
  daytimeEnthusiasm: number;
}

export type PsqiComponents = {
  c1Quality: number; c2Latency: number; c3Duration: number; c4Efficiency: number;
  c5Disturbances: number; c6Medication: number; c7DaytimeDysfunction: number; efficiencyPct: number;
};

export interface PsqiResult extends ScoredInstrument<PsqiComponents> {
  poorSleep: boolean;
}

const minutesOf = (hhmm: string) => {
  const m = /^(\d{1,2}):(\d{2})$/.exec(hhmm);
  if (!m) throw new InstrumentValidationError('PSQI', `hora "${hhmm}" no es HH:MM`);
  return Number(m[1]) * 60 + Number(m[2]);
};
const check03 = (name: string, v: number) => {
  if (!Number.isInteger(v) || v < 0 || v > 3) throw new InstrumentValidationError('PSQI', `${name} = ${v} fuera de [0, 3]`);
  return v;
};
const band = (sum: number, cuts: [number, number, number]) => (sum === 0 ? 0 : sum <= cuts[0] ? 1 : sum <= cuts[1] ? 2 : 3);

export function scorePsqi(p: PsqiInput): PsqiResult {
  const c1 = check03('P6', p.subjectiveQuality);

  const latencyScore = p.sleepLatencyMinutes <= 15 ? 0 : p.sleepLatencyMinutes <= 30 ? 1 : p.sleepLatencyMinutes <= 60 ? 2 : 3;
  const c2 = band(latencyScore + check03('P5a', p.disturbances.a), [2, 4, 6]);

  const c3 = p.hoursSlept > 7 ? 0 : p.hoursSlept >= 6 ? 1 : p.hoursSlept >= 5 ? 2 : 3;

  let inBedMin = minutesOf(p.wakeTime) - minutesOf(p.bedtime);
  if (inBedMin <= 0) inBedMin += 24 * 60; // cruza la medianoche
  const efficiencyPct = Math.min(100, ((p.hoursSlept * 60) / inBedMin) * 100);
  const c4 = efficiencyPct >= 85 ? 0 : efficiencyPct >= 75 ? 1 : efficiencyPct >= 65 ? 2 : 3;

  const d = p.disturbances;
  const distSum = (['b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'] as const).reduce((s, k) => s + check03(`P5${k}`, d[k]), 0) + (d.j !== undefined ? check03('P5j', d.j) : 0);
  const c5 = band(distSum, [9, 18, 27]);

  const c6 = check03('P7', p.sleepMedication);
  const c7 = band(check03('P8', p.daytimeSleepiness) + check03('P9', p.daytimeEnthusiasm), [2, 4, 6]);

  const total = c1 + c2 + c3 + c4 + c5 + c6 + c7;
  return {
    totalScore: total,
    poorSleep: total > 5,
    subscaleScores: {
      c1Quality: c1, c2Latency: c2, c3Duration: c3, c4Efficiency: c4,
      c5Disturbances: c5, c6Medication: c6, c7DaytimeDysfunction: c7,
      efficiencyPct: Math.round(efficiencyPct * 10) / 10,
    },
    scoringMethod: 'Suma de 7 componentes 0–3 (global 0–21); >5 mala calidad',
    scoringVersion: PSQI_SCORING_VERSION,
  };
}
