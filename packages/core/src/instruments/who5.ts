import { assertComplete, type ItemResponses, type ScoredInstrument } from './common';

/**
 * Índice de Bienestar OMS-5 (WHO-5; Topp et al., 2015). 5 ítems, 0–5, recuerdo
 * de 2 semanas. Puntaje bruto 0–25 × 4 = porcentaje 0–100 (mayor = mejor).
 *  - ≤ 50 (bruto < 13): bienestar bajo → sugerir tamizaje de depresión.
 *  - ≤ 28 (bruto ≤ 7): probable depresión → derivación profesional.
 * Son umbrales de TAMIZAJE, no diagnósticos.
 */
export const WHO5_SCORING_VERSION = 'who5@1.0.0';
export type Who5Band = 'ADEQUATE' | 'LOW_WELLBEING' | 'LIKELY_DEPRESSION';

export interface Who5Result extends ScoredInstrument<{ raw: number }> {
  band: Who5Band;
}

export function scoreWho5(responses: ItemResponses): Who5Result {
  assertComplete('WHO-5', responses, 5, 0, 5);
  const raw = [1, 2, 3, 4, 5].reduce((s, i) => s + responses[i]!, 0);
  const pct = raw * 4;
  return {
    totalScore: pct,
    subscaleScores: { raw },
    band: pct <= 28 ? 'LIKELY_DEPRESSION' : pct <= 50 ? 'LOW_WELLBEING' : 'ADEQUATE',
    scoringMethod: 'Bruto 0–25 × 4 = 0–100',
    scoringVersion: WHO5_SCORING_VERSION,
  };
}
