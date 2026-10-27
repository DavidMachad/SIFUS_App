import { InstrumentValidationError, type ScoredInstrument } from './common';

/**
 * "Micro-PANAS": se implementa el I-PANAS-SF (Thompson, 2007), la forma breve
 * internacional validada de 10 ítems (1 = nunca – 5 = siempre), aplicada como
 * evaluación ecológica momentánea (EMA) diaria de ≤ 30 s.
 *  - Afecto positivo (PA): activo, decidido, atento, inspirado, alerta (5–25)
 *  - Afecto negativo (NA): alterado, hostil, avergonzado, nervioso, temeroso (5–25)
 *  - Balance afectivo = PA − NA (−20 a +20)
 * Al ser autorreporte diario, su peso en el Índice de Vida está acotado y se
 * contrasta con los datos pasivos (ver crossValidation).
 */
export const PANAS_SCORING_VERSION = 'i-panas-sf@1.0.0';

export const PANAS_POSITIVE = ['active', 'determined', 'attentive', 'inspired', 'alert'] as const;
export const PANAS_NEGATIVE = ['upset', 'hostile', 'ashamed', 'nervous', 'afraid'] as const;
export type PanasItem = (typeof PANAS_POSITIVE)[number] | (typeof PANAS_NEGATIVE)[number];

export interface PanasResult extends ScoredInstrument<{ positiveAffect: number; negativeAffect: number }> {
  /** PA − NA. */
  totalScore: number;
}

export function scorePanas(responses: Record<PanasItem, number>): PanasResult {
  const sum = (items: readonly PanasItem[]) =>
    items.reduce((s, k) => {
      const v = responses[k];
      if (!Number.isInteger(v) || v < 1 || v > 5) throw new InstrumentValidationError('I-PANAS-SF', `${k} = ${v} fuera de rango [1, 5]`);
      return s + v;
    }, 0);
  const positiveAffect = sum(PANAS_POSITIVE);
  const negativeAffect = sum(PANAS_NEGATIVE);
  return {
    totalScore: positiveAffect - negativeAffect,
    subscaleScores: { positiveAffect, negativeAffect },
    scoringMethod: 'PA y NA = suma 5 ítems (5–25); total = PA − NA',
    scoringVersion: PANAS_SCORING_VERSION,
  };
}
