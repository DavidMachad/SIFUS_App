import { assertComplete, type ItemResponses, type ScoredInstrument } from './common';

/**
 * Escala de Bienestar Espiritual (SWBS; Paloutzian & Ellison, 1982).
 * 20 ítems, 1–6 codificados de modo que 6 = mayor bienestar tras invertir los
 * ítems de redacción negativa. Subescalas:
 *   Bienestar religioso (RWB): ítems impares (10–60)
 *   Bienestar existencial (EWB): ítems pares (10–60)
 * Total 20–120. Para orientación secular se recomienda reportar solo EWB.
 * Instrumento con licencia: verificar los ítems inversos contra el manual
 * licenciado de la versión en español antes de recolectar.
 * (JAREL no se puntúa aquí por la misma razón; se puede registrar como
 * QuestionnaireAdministration con su propia lógica cuando se licencie.)
 */
export const SWBS_SCORING_VERSION = 'swbs@1.0.0';
export const SWBS_REVERSED_ITEMS = [1, 2, 5, 6, 9, 12, 13, 16, 18];

export function scoreSwbs(responses: ItemResponses, reversed: number[] = SWBS_REVERSED_ITEMS): ScoredInstrument<{ religious: number; existential: number }> {
  assertComplete('SWBS', responses, 20, 1, 6);
  const rev = new Set(reversed);
  let religious = 0;
  let existential = 0;
  for (let i = 1; i <= 20; i++) {
    const v = rev.has(i) ? 7 - responses[i]! : responses[i]!;
    if (i % 2 === 1) religious += v;
    else existential += v;
  }
  return {
    totalScore: religious + existential,
    subscaleScores: { religious, existential },
    scoringMethod: 'Suma con ítems negativos invertidos; RWB impares, EWB pares',
    scoringVersion: SWBS_SCORING_VERSION,
  };
}
