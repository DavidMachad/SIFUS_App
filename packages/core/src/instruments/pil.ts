import { assertComplete, type ItemResponses, type ScoredInstrument } from './common';

/**
 * Test de Propósito en la Vida (PIL; Crumbaugh & Maholick, 1964). 20 ítems
 * 1–7, total 20–140 (mayor = más sentido). Las respuestas deben llegar ya
 * codificadas con 7 = polo de mayor sentido (algunos ítems presentan los
 * anclajes en orden inverso en el formulario impreso).
 * Interpretación descriptiva frecuente: < 90 falta de sentido; 90–105 zona
 * indefinida; > 105 presencia de sentido.
 */
export const PIL_SCORING_VERSION = 'pil@1.0.0';
export type PilBand = 'LACK_OF_MEANING' | 'INDETERMINATE' | 'MEANING_PRESENT';

export function scorePil(responses: ItemResponses): ScoredInstrument<never> & { band: PilBand } {
  assertComplete('PIL', responses, 20, 1, 7);
  const total = Array.from({ length: 20 }, (_, k) => responses[k + 1]!).reduce((a, b) => a + b, 0);
  return {
    totalScore: total,
    band: total < 90 ? 'LACK_OF_MEANING' : total <= 105 ? 'INDETERMINATE' : 'MEANING_PRESENT',
    scoringMethod: 'Suma 20–140',
    scoringVersion: PIL_SCORING_VERSION,
  };
}
