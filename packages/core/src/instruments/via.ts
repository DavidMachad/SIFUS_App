import { VIA_STRENGTHS, type ViaStrength } from '../domain/enums';
import { InstrumentValidationError, round } from './common';

/**
 * Inventario VIA de Fortalezas. La puntuación oficial la entrega el VIA
 * Institute; aquí se reciben las medias por fortaleza (1–5) y se ordenan.
 * Las 5 primeras son las "fortalezas distintivas" que el jugador puede equipar
 * como habilidades pasivas: el desarrollo parte de lo que la persona ya hace bien.
 */
export const VIA_SCORING_VERSION = 'via@1.0.0';

export interface RankedStrength {
  strength: ViaStrength;
  score: number;
  rank: number;
}

export function rankViaStrengths(scores: Record<ViaStrength, number>): RankedStrength[] {
  for (const s of VIA_STRENGTHS) {
    const v = scores[s];
    if (v === undefined || v < 1 || v > 5) {
      throw new InstrumentValidationError('VIA-IS', `${s} = ${v} fuera de rango [1, 5]`);
    }
  }
  return [...VIA_STRENGTHS]
    .map((strength) => ({ strength, score: round(scores[strength]) }))
    // Desempate estable por orden de la clasificación para que sea reproducible.
    .sort((a, b) => b.score - a.score || VIA_STRENGTHS.indexOf(a.strength) - VIA_STRENGTHS.indexOf(b.strength))
    .map((s, i) => ({ ...s, rank: i + 1 }));
}

export function signatureStrengths(scores: Record<ViaStrength, number>, n = 5): ViaStrength[] {
  return rankViaStrengths(scores).slice(0, n).map((s) => s.strength);
}
