import { assertComplete, round, type ItemResponses, type ScoredInstrument } from './common';

/**
 * Escala Multidimensional de Apoyo Social Percibido (Zimet et al., 1988).
 * 12 ítems, 1 (muy en desacuerdo) – 7 (muy de acuerdo). Puntajes = medias.
 *   Otra persona significativa: 1, 2, 5, 10
 *   Familia:                    3, 4, 8, 11
 *   Amigos:                     6, 7, 9, 12
 * Bandas descriptivas habituales: 1–2.9 bajo, 3–5 moderado, 5.1–7 alto.
 */
export const MSPSS_SCORING_VERSION = 'mspss@1.0.0';

const SUBSCALES = {
  significantOther: [1, 2, 5, 10],
  family: [3, 4, 8, 11],
  friends: [6, 7, 9, 12],
} as const;

export type MspssSubscales = Record<keyof typeof SUBSCALES, number>;
export type SupportBand = 'LOW' | 'MODERATE' | 'HIGH';

export interface MspssResult extends ScoredInstrument<MspssSubscales> {
  band: SupportBand;
}

export function scoreMspss(responses: ItemResponses): MspssResult {
  assertComplete('MSPSS', responses, 12, 1, 7);
  const mean = (items: readonly number[]) =>
    round(items.reduce((s, i) => s + responses[i]!, 0) / items.length);

  const subscaleScores: MspssSubscales = {
    significantOther: mean(SUBSCALES.significantOther),
    family: mean(SUBSCALES.family),
    friends: mean(SUBSCALES.friends),
  };
  const total = mean([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
  return {
    totalScore: total,
    subscaleScores,
    band: supportBand(total),
    scoringMethod: 'Media de ítems (1–7) total y por fuente',
    scoringVersion: MSPSS_SCORING_VERSION,
  };
}

export function supportBand(mean: number): SupportBand {
  if (mean < 3) return 'LOW';
  if (mean <= 5) return 'MODERATE';
  return 'HIGH';
}
