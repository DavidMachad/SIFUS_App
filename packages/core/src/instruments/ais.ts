import { assertComplete, type ItemResponses, type ScoredInstrument } from './common';

/**
 * Escala Atenas de Insomnio (AIS-8; Soldatos et al., 2000). 8 ítems 0–3,
 * total 0–24. Punto de corte ≥ 6 (Soldatos et al., 2003) sugiere insomnio.
 * Alternativa breve al PSQI para seguimientos frecuentes.
 */
export const AIS_SCORING_VERSION = 'ais8@1.0.0';

export interface AisResult extends ScoredInstrument<never> {
  suggestsInsomnia: boolean;
}

export function scoreAis(responses: ItemResponses, cutoff = 6): AisResult {
  assertComplete('AIS', responses, 8, 0, 3);
  const total = [1, 2, 3, 4, 5, 6, 7, 8].reduce((s, i) => s + responses[i]!, 0);
  return { totalScore: total, suggestsInsomnia: total >= cutoff, scoringMethod: 'Suma 0–24', scoringVersion: AIS_SCORING_VERSION };
}
