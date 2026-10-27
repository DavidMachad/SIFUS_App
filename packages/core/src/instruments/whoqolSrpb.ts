import { InstrumentValidationError, round, type ScoredInstrument } from './common';

/**
 * WHOQOL-SRPB (OMS): 32 ítems, 8 facetas × 4 ítems, respuesta 1–5.
 * Cada faceta se puntúa como suma de sus 4 ítems (4–20); el total se reporta
 * como la media de las 8 facetas (4–20) para mantener la escala del WHOQOL.
 *
 * La asignación ítem→faceta y los ítems de redacción negativa dependen de la
 * versión validada en español que adopte el equipo; por eso la entrada llega
 * ya agrupada por faceta y los ítems inversos se declaran explícitamente.
 * Verificar contra el manual oficial antes de la recolección.
 */
export const SRPB_SCORING_VERSION = 'whoqol-srpb@1.0.0';

export const SRPB_FACETS = [
  'spiritualConnection',
  'meaningAndPurpose',
  'awe',
  'wholeness',
  'spiritualStrength',
  'innerPeace',
  'hope',
  'faith',
] as const;
export type SrpbFacet = (typeof SRPB_FACETS)[number];

export type SrpbResponses = Record<SrpbFacet, [number, number, number, number]>;
/** Posiciones (0–3) de ítems inversos dentro de cada faceta. */
export type SrpbReversedItems = Partial<Record<SrpbFacet, number[]>>;

export function scoreWhoqolSrpb(
  responses: SrpbResponses,
  reversed: SrpbReversedItems = {},
): ScoredInstrument<Record<SrpbFacet, number>> {
  const facetScores = {} as Record<SrpbFacet, number>;
  for (const facet of SRPB_FACETS) {
    const items = responses[facet];
    if (!items || items.length !== 4) {
      throw new InstrumentValidationError('WHOQOL-SRPB', `la faceta ${facet} requiere 4 ítems`);
    }
    facetScores[facet] = items.reduce((sum, v, idx) => {
      if (!Number.isInteger(v) || v < 1 || v > 5) {
        throw new InstrumentValidationError('WHOQOL-SRPB', `${facet}[${idx}] = ${v} fuera de rango [1, 5]`);
      }
      return sum + (reversed[facet]?.includes(idx) ? 6 - v : v);
    }, 0);
  }
  const total = SRPB_FACETS.reduce((s, f) => s + facetScores[f], 0) / SRPB_FACETS.length;
  return {
    totalScore: round(total),
    subscaleScores: facetScores,
    scoringMethod: 'Facetas = suma 4 ítems (4–20); total = media de facetas',
    scoringVersion: SRPB_SCORING_VERSION,
  };
}
