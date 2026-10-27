import { assertComplete, type ItemResponses, type ScoredInstrument } from './common';

/**
 * Cuestionario de Salud General, 12 ítems (Goldberg & Williams, 1988).
 * Codificación de entrada 0–3, donde 0 es siempre la opción más favorable
 * (el orden de las opciones del cuestionario ya resuelve los ítems positivos
 * y negativos). Se reportan ambos métodos:
 *   - GHQ (0-0-1-1): total 0–12, el usado para tamizaje.
 *   - Likert (0-1-2-3): total 0–36, mejor para análisis de cambio.
 *
 * El punto de corte de tamizaje varía según población y validación local
 * (≥3 o ≥4 son frecuentes); por eso es un parámetro, no una constante. Un
 * resultado sobre el corte NO es un diagnóstico: en la app solo activa la
 * oferta de acompañamiento profesional.
 */
export const GHQ12_SCORING_VERSION = 'ghq12@1.0.0';
export const GHQ12_DEFAULT_CUTOFF = 4;

export interface Ghq12Result extends ScoredInstrument<{ likert: number }> {
  aboveScreeningCutoff: boolean;
}

export function scoreGhq12(responses: ItemResponses, cutoff = GHQ12_DEFAULT_CUTOFF): Ghq12Result {
  assertComplete('GHQ-12', responses, 12, 0, 3);
  let ghq = 0;
  let likert = 0;
  for (let i = 1; i <= 12; i++) {
    const v = responses[i]!;
    likert += v;
    if (v >= 2) ghq += 1;
  }
  return {
    totalScore: ghq,
    subscaleScores: { likert },
    aboveScreeningCutoff: ghq >= cutoff,
    scoringMethod: 'GHQ 0-0-1-1 (total) + Likert 0-3 (subescala)',
    scoringVersion: GHQ12_SCORING_VERSION,
  };
}
