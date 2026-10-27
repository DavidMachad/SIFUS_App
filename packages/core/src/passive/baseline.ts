import { round } from '../instruments/common';

/**
 * Línea de base personal móvil para métricas pasivas.
 *
 * La HRV y la FC en reposo varían mucho entre personas; solo tienen sentido
 * comparadas con uno mismo. Se usa la práctica habitual en monitoreo de la
 * recuperación (p. ej. Plews et al.): media y DE móviles de los últimos 28
 * días, excluyendo el día evaluado, y ln(HRV) porque su distribución es
 * asimétrica. Con menos de 14 días válidos NO se emite juicio (dato inmaduro).
 */
export interface DailyValue {
  date: string; // YYYY-MM-DD
  value: number;
}

export interface PersonalBaseline {
  mean: number;
  sd: number;
  n: number;
  logTransformed: boolean;
}

export const BASELINE_WINDOW_DAYS = 28;
export const BASELINE_MIN_DAYS = 14;

const DAY = 86_400_000;
const toTime = (d: string) => Date.parse(`${d}T00:00:00Z`);

export function personalBaseline(
  history: DailyValue[],
  today: string,
  opts: { log?: boolean; windowDays?: number; minDays?: number } = {},
): PersonalBaseline | null {
  const window = opts.windowDays ?? BASELINE_WINDOW_DAYS;
  const t = toTime(today);
  const vals = history
    .filter((h) => {
      const age = (t - toTime(h.date)) / DAY;
      return age >= 1 && age <= window && h.value > 0;
    })
    .map((h) => (opts.log ? Math.log(h.value) : h.value));
  if (vals.length < (opts.minDays ?? BASELINE_MIN_DAYS)) return null;
  const mean = vals.reduce((a, b) => a + b, 0) / vals.length;
  const sd = Math.sqrt(vals.reduce((s, v) => s + (v - mean) ** 2, 0) / (vals.length - 1));
  return { mean: round(mean, 4), sd: round(sd, 4), n: vals.length, logTransformed: Boolean(opts.log) };
}

/** Puntaje z del valor de hoy frente a la línea de base personal. */
export function zFromBaseline(value: number, b: PersonalBaseline): number | null {
  if (b.sd <= 0) return null;
  const x = b.logTransformed ? Math.log(value) : value;
  return round((x - b.mean) / b.sd, 2);
}
