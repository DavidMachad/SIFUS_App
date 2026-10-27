/** Respuestas por ítem, numeradas desde 1 tal como aparecen en el instrumento. */
export type ItemResponses = Record<number, number>;

export interface ScoredInstrument<TSub = Record<string, number>> {
  totalScore: number;
  subscaleScores?: TSub;
  scoringMethod: string;
  scoringVersion: string;
}

export class InstrumentValidationError extends Error {
  constructor(instrument: string, detail: string) {
    super(`${instrument}: ${detail}`);
    this.name = 'InstrumentValidationError';
  }
}

/**
 * Verifica que estén todos los ítems y en rango. Los instrumentos validados no
 * se puntúan con datos faltantes: un total parcial no es comparable.
 */
export function assertComplete(
  instrument: string,
  responses: ItemResponses,
  itemCount: number,
  min: number,
  max: number,
): void {
  for (let i = 1; i <= itemCount; i++) {
    const v = responses[i];
    if (v === undefined || v === null) {
      throw new InstrumentValidationError(instrument, `falta el ítem ${i}`);
    }
    if (!Number.isInteger(v) || v < min || v > max) {
      throw new InstrumentValidationError(instrument, `ítem ${i} = ${v} fuera de rango [${min}, ${max}]`);
    }
  }
}

export const round = (n: number, decimals = 2): number => {
  const f = 10 ** decimals;
  return Math.round(n * f) / f;
};
