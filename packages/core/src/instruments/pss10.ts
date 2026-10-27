import { assertComplete, type ItemResponses, type ScoredInstrument } from './common';

/**
 * Escala de Estrés Percibido, 10 ítems (Cohen, Kamarck & Mermelstein, 1983).
 * Respuestas 0 (nunca) – 4 (muy a menudo). Los ítems 4, 5, 7 y 8 están
 * formulados en positivo y se invierten. Total 0–40; mayor = más estrés.
 *
 * Las bandas 0–13 / 14–26 / 27–40 son una convención descriptiva frecuente, no
 * puntos de corte clínicos: en la app se usan solo para modular la carga, nunca
 * para etiquetar a la persona.
 */
export const PSS10_SCORING_VERSION = 'pss10@1.0.0';
const REVERSED_ITEMS = new Set([4, 5, 7, 8]);

export type Pss10Band = 'LOW' | 'MODERATE' | 'HIGH';

export interface Pss10Result extends ScoredInstrument<never> {
  band: Pss10Band;
}

export function scorePss10(responses: ItemResponses): Pss10Result {
  assertComplete('PSS-10', responses, 10, 0, 4);
  let total = 0;
  for (let i = 1; i <= 10; i++) {
    const v = responses[i]!;
    total += REVERSED_ITEMS.has(i) ? 4 - v : v;
  }
  return {
    totalScore: total,
    band: pss10Band(total),
    scoringMethod: 'Suma 0–40, ítems 4,5,7,8 invertidos',
    scoringVersion: PSS10_SCORING_VERSION,
  };
}

export function pss10Band(total: number): Pss10Band {
  if (total >= 27) return 'HIGH';
  if (total >= 14) return 'MODERATE';
  return 'LOW';
}
