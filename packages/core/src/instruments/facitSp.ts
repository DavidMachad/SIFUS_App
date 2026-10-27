import { InstrumentValidationError, round, type ScoredInstrument } from './common';

/**
 * FACIT-Sp-12 (Peterman et al., 2002). 12 ítems, 0 (nada) – 4 (muchísimo).
 * Ítems 4 y 8 invertidos. Subescalas:
 *   Significado (Meaning): 2, 3, 5, 8      (0–16)
 *   Paz (Peace):           1, 4, 6, 7      (0–16)
 *   Fe (Faith):            9, 10, 11, 12   (0–16)
 * Total 0–48. Prorrateo oficial FACIT: si se respondió más del 50 % de los
 * ítems de una subescala, subescala = suma × nº ítems / nº respondidos.
 *
 * Filtro de orientación espiritual: para personas de orientación secular se
 * reporta el FACIT-Sp-8 (Significado + Paz, 0–32), práctica usada en la
 * literatura para no imponer un marco de fe. Los ítems 11–12 aluden a
 * "enfermedad": en población general se usa la redacción adaptada aprobada.
 */
export const FACIT_SP_SCORING_VERSION = 'facit-sp-12@1.0.0';

const SUBSCALES = { meaning: [2, 3, 5, 8], peace: [1, 4, 6, 7], faith: [9, 10, 11, 12] } as const;
const REVERSED = new Set([4, 8]);

export type FacitSubscales = { meaning: number; peace: number; faith: number | null; meaningPeace: number };

export interface FacitSpResult extends ScoredInstrument<FacitSubscales> {
  /** FACIT-Sp-12 si includeFaith; si no, FACIT-Sp-8. */
  version: 'FACIT-Sp-12' | 'FACIT-Sp-8';
  maxScore: 48 | 32;
}

export function scoreFacitSp(responses: Partial<Record<number, number>>, opts: { includeFaith?: boolean } = {}): FacitSpResult {
  const includeFaith = opts.includeFaith ?? true;
  const sub = (items: readonly number[], name: string) => {
    const answered = items.filter((i) => responses[i] !== undefined);
    if (answered.length <= items.length / 2) {
      throw new InstrumentValidationError('FACIT-Sp', `subescala ${name}: se requieren más del 50 % de los ítems`);
    }
    const sum = answered.reduce((s, i) => {
      const v = responses[i]!;
      if (!Number.isInteger(v) || v < 0 || v > 4) throw new InstrumentValidationError('FACIT-Sp', `ítem ${i} = ${v} fuera de [0, 4]`);
      return s + (REVERSED.has(i) ? 4 - v : v);
    }, 0);
    return round((sum * items.length) / answered.length, 2);
  };
  const meaning = sub(SUBSCALES.meaning, 'Significado');
  const peace = sub(SUBSCALES.peace, 'Paz');
  const faith = includeFaith ? sub(SUBSCALES.faith, 'Fe') : null;
  const meaningPeace = round(meaning + peace, 2);
  return {
    totalScore: faith === null ? meaningPeace : round(meaningPeace + faith, 2),
    subscaleScores: { meaning, peace, faith, meaningPeace },
    version: includeFaith ? 'FACIT-Sp-12' : 'FACIT-Sp-8',
    maxScore: includeFaith ? 48 : 32,
    scoringMethod: 'Suma con ítems 4 y 8 invertidos; prorrateo FACIT >50 %',
    scoringVersion: FACIT_SP_SCORING_VERSION,
  };
}
