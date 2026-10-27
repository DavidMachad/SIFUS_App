import { InstrumentValidationError, round } from './common';

/**
 * Estimación de 1RM a partir de una serie submáxima.
 *  - Brzycki (1993): 1RM = carga × 36 / (37 − reps)
 *  - Epley (1985):   1RM = carga × (1 + reps / 30)
 *  - Lombardi (1989): 1RM = carga × reps^0.10
 * La precisión cae al aumentar las repeticiones; por encima de 10 la
 * estimación se marca como de baja confianza (no se descarta: se informa).
 * Para 5RM directo, reps = 5.
 */
export const ONE_RM_SCORING_VERSION = 'one-rm@1.0.0';

export type OneRmFormula = 'BRZYCKI' | 'EPLEY' | 'LOMBARDI';

export interface OneRmEstimate {
  estimated1RmKg: number;
  formula: OneRmFormula | 'NONE';
  lowConfidence: boolean;
}

export const MAX_RELIABLE_REPS = 10;

export function estimateOneRm(loadKg: number, reps: number, formula: OneRmFormula = 'BRZYCKI'): OneRmEstimate {
  if (!(loadKg > 0)) throw new InstrumentValidationError('1RM', `carga inválida: ${loadKg}`);
  if (!Number.isInteger(reps) || reps < 1 || reps > 30) {
    throw new InstrumentValidationError('1RM', `repeticiones inválidas: ${reps}`);
  }
  if (reps === 1) return { estimated1RmKg: round(loadKg, 1), formula: 'NONE', lowConfidence: false };

  let value: number;
  switch (formula) {
    case 'BRZYCKI':
      value = (loadKg * 36) / (37 - reps);
      break;
    case 'EPLEY':
      value = loadKg * (1 + reps / 30);
      break;
    case 'LOMBARDI':
      value = loadKg * reps ** 0.1;
      break;
  }
  return { estimated1RmKg: round(value, 1), formula, lowConfidence: reps > MAX_RELIABLE_REPS };
}

/** Fuerza relativa (1RM / masa corporal): compara mejor entre personas y fases. */
export function relativeStrength(oneRmKg: number, bodyMassKg: number): number {
  return round(oneRmKg / bodyMassKg, 3);
}
