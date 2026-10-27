import { InstrumentValidationError, round } from './common';

/**
 * Cálculos antropométricos para el análisis de investigación.
 *
 * Nota de diseño empático: estos índices alimentan los tableros del equipo de
 * salud, pero la interfaz del jugador NO muestra categorías de IMC ni etiquetas
 * de peso. El progreso del personaje se expresa en capacidades funcionales.
 */
export const ANTHROPOMETRY_SCORING_VERSION = 'anthropometry@1.0.0';

export function bmi(weightKg: number, heightCm: number): number {
  if (!(weightKg > 0) || !(heightCm > 0)) throw new InstrumentValidationError('IMC', 'peso y estatura deben ser positivos');
  return round(weightKg / (heightCm / 100) ** 2, 2);
}

export const waistHipRatio = (waistCm: number, hipCm: number): number => round(waistCm / hipCm, 3);

/** Índice cintura/estatura; ≥0.5 se usa como marcador de riesgo cardiometabólico. */
export const waistHeightRatio = (waistCm: number, heightCm: number): number => round(waistCm / heightCm, 3);

/**
 * Valor final de una medida repetida (criterio ISAK): media si hay 2 tomas,
 * mediana si hay 3. Se recomienda una 3.ª toma cuando las dos primeras
 * difieren más que la tolerancia (p. ej. 1% en perímetros).
 */
export function isakFinalValue(trials: number[]): number {
  if (trials.length === 0) throw new InstrumentValidationError('ISAK', 'se requiere al menos una toma');
  if (trials.length === 1) return trials[0]!;
  if (trials.length === 2) return round((trials[0]! + trials[1]!) / 2, 1);
  const sorted = [...trials].sort((a, b) => a - b);
  return sorted[Math.floor(sorted.length / 2)]!;
}

export function needsThirdTrial(first: number, second: number, tolerancePct = 1): boolean {
  const mean = (first + second) / 2;
  return (Math.abs(first - second) / mean) * 100 > tolerancePct;
}

/**
 * Error técnico de medida (ETM) intra-evaluador para pares de tomas:
 * ETM = √(Σd² / 2n); ETM% = ETM / media × 100. Insumo de control de calidad
 * del equipo evaluador y del cálculo del MDC.
 */
export function technicalErrorOfMeasurement(pairs: Array<[number, number]>): { tem: number; temPct: number } {
  if (pairs.length === 0) throw new InstrumentValidationError('ETM', 'se requieren pares de mediciones');
  const sumSq = pairs.reduce((s, [a, b]) => s + (a - b) ** 2, 0);
  const tem = Math.sqrt(sumSq / (2 * pairs.length));
  const mean = pairs.reduce((s, [a, b]) => s + a + b, 0) / (2 * pairs.length);
  return { tem: round(tem, 3), temPct: round((tem / mean) * 100, 2) };
}
