import { InstrumentValidationError, type ScoredInstrument } from './common';

/**
 * MEDAS — Mediterranean Diet Adherence Screener, 14 ítems (Schröder et al., 2011;
 * PREDIMED). Cada ítem vale 1 si se cumple el criterio.
 *
 * Decisiones de salud pública documentadas:
 *  - El ítem 8 (vino ≥ 7 copas/semana) se EXCLUYE por defecto: no es ético
 *    promover el consumo de alcohol desde una intervención de salud. El puntaje
 *    queda 0–13 y se reporta también normalizado a 0–100.
 *  - El MEDAS no está validado en población colombiana; ítems como aceite de
 *    oliva o frutos secos requieren adaptación cultural antes de usar el puntaje
 *    como evidencia. Se versiona la adaptación en instrumentVersion.
 *  - Corte habitual: ≥ 9/14 = buena adherencia (se escala a ≥ 9/14 × 13 cuando
 *    se excluye el vino).
 */
export const MEDAS_SCORING_VERSION = 'medas@1.0.0';
export const MEDAS_WINE_ITEM = 8;

export interface MedasResult extends ScoredInstrument<{ maxScore: number; normalized: number }> {
  goodAdherence: boolean;
}

/** criteriaMet[i] = true si se cumple el criterio del ítem i (1–14). */
export function scoreMedas(criteriaMet: Record<number, boolean>, opts: { excludeWineItem?: boolean } = {}): MedasResult {
  const excludeWine = opts.excludeWineItem ?? true;
  const items = Array.from({ length: 14 }, (_, k) => k + 1).filter((i) => !(excludeWine && i === MEDAS_WINE_ITEM));
  let score = 0;
  for (const i of items) {
    const v = criteriaMet[i];
    if (typeof v !== 'boolean') throw new InstrumentValidationError('MEDAS', `falta el ítem ${i}`);
    if (v) score++;
  }
  const maxScore = items.length;
  const normalized = Math.round((score / maxScore) * 1000) / 10;
  return {
    totalScore: score,
    subscaleScores: { maxScore, normalized },
    goodAdherence: score >= (9 / 14) * maxScore,
    scoringMethod: excludeWine ? 'Suma 13 ítems (vino excluido)' : 'Suma 14 ítems',
    scoringVersion: MEDAS_SCORING_VERSION,
  };
}
