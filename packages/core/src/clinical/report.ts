import { round } from '../instruments/common';
import { compareToNorm, findNorm, type NormComparison, type ReferenceNorm } from './norms';
import { measureByCode, type ClinicalMeasure } from './terminology';

/**
 * Modelo del informe clínico para profesionales de la salud.
 * Sin terminología de videojuego: el informe habla de puntajes, cambios y
 * percentiles, nunca de niveles, XP, misiones o avatares (ver
 * assertClinicalLanguage, que se ejecuta sobre todo el texto generado).
 */
export interface MeasurePoint {
  value: number;
  date: string;
}

export interface ReportInputRow {
  measureCode: string;
  baseline?: MeasurePoint;
  current?: MeasurePoint;
  /** Cambio mínimo detectable, si está calibrado. */
  mdc?: number;
}

export interface ReportRow {
  measure: ClinicalMeasure;
  baseline?: MeasurePoint;
  current?: MeasurePoint;
  change: number | null;
  changePct: number | null;
  /** Cambio en unidades de DE de la norma (si hay norma normal). */
  standardizedChange: number | null;
  /** true/false si hay MDC; null si no está calibrado. */
  exceedsMdc: boolean | null;
  /**
   * IMPROVED/WORSENED solo cuando el cambio supera el MDC calibrado.
   * Sin MDC: FAVORABLE_UNCONFIRMED / UNFAVORABLE_UNCONFIRMED (dirección del
   * cambio bruto, sin afirmar que excede el error de medición).
   */
  trend: 'IMPROVED' | 'WORSENED' | 'FAVORABLE_UNCONFIRMED' | 'UNFAVORABLE_UNCONFIRMED' | 'STABLE' | 'NOT_DIRECTIONAL' | 'INSUFFICIENT';
  baselineNorm: NormComparison | null;
  currentNorm: NormComparison | null;
  interpretation: string | null;
}

export interface ClinicalReport {
  subjectLabel: string;
  sex: 'FEMALE' | 'MALE' | 'INTERSEX' | 'UNDISCLOSED';
  ageYears: number;
  period: { from: string; to: string };
  rows: ReportRow[];
  notes: string[];
  generatedAt: string;
}

export function buildClinicalReport(input: {
  subjectLabel: string;
  sex: ClinicalReport['sex'];
  ageYears: number;
  rows: ReportInputRow[];
  norms: ReferenceNorm[];
  generatedAt: string;
}): ClinicalReport {
  const normSex = input.sex === 'FEMALE' || input.sex === 'MALE' ? input.sex : 'ANY';
  const rows: ReportRow[] = input.rows.flatMap((r) => {
    const measure = measureByCode(r.measureCode);
    if (!measure) return [];
    const norm = findNorm(input.norms, r.measureCode, normSex, input.ageYears);
    const change = r.baseline && r.current ? round(r.current.value - r.baseline.value, 2) : null;
    const exceedsMdc = change !== null && r.mdc ? Math.abs(change) >= r.mdc : null;
    let trend: ReportRow['trend'] = 'INSUFFICIENT';
    if (change !== null) {
      if (measure.direction === 0) trend = 'NOT_DIRECTIONAL';
      else if (exceedsMdc === false || change === 0) trend = 'STABLE';
      else if (exceedsMdc === null) trend = change * measure.direction > 0 ? 'FAVORABLE_UNCONFIRMED' : 'UNFAVORABLE_UNCONFIRMED';
      else trend = change * measure.direction > 0 ? 'IMPROVED' : 'WORSENED';
    }
    return [{
      measure,
      baseline: r.baseline,
      current: r.current,
      change,
      // El % de cambio solo tiene sentido con una línea de base positiva (p. ej.
      // Wells & Dillon puede ser negativo o cero).
      changePct: change !== null && r.baseline!.value > 0 ? round((change / r.baseline!.value) * 100, 1) : null,
      standardizedChange: change !== null && norm?.method.kind === 'NORMAL' ? round(change / norm.method.sd, 2) : null,
      exceedsMdc,
      trend,
      baselineNorm: r.baseline && norm ? compareToNorm(r.baseline.value, norm) : null,
      currentNorm: r.current && norm ? compareToNorm(r.current.value, norm) : null,
      interpretation: r.current && measure.interpret ? measure.interpret(r.current.value) : null,
    }];
  });

  const dates = rows.flatMap((r) => [r.baseline?.date, r.current?.date]).filter(Boolean).sort() as string[];
  const notes = [
    'Los puntajes de tamizaje no constituyen diagnóstico; requieren valoración clínica.',
    'Cambio con significado clínico: solo se califica como mejoría o empeoramiento cuando supera el cambio mínimo detectable calibrado; si no hay MDC, se reporta el cambio bruto.',
    'Los percentiles se calculan frente a la norma citada para sexo y edad; "sin norma" indica que no hay referencia cargada.',
  ];
  if (rows.some((r) => r.measure.loinc?.status === 'PENDING_VERIFICATION')) {
    notes.push('Algunos códigos LOINC están pendientes de verificación terminológica y se marcan con (*).');
  }
  return {
    subjectLabel: input.subjectLabel,
    sex: input.sex,
    ageYears: input.ageYears,
    period: { from: dates[0] ?? '', to: dates[dates.length - 1] ?? '' },
    rows,
    notes,
    generatedAt: input.generatedAt,
  };
}

/** Términos del juego que NUNCA deben aparecer en un documento clínico. */
const GAME_TERMS = /\b(xp|nivel(es)?|misi(o|ó)n(es)?|avatar|gremio(s)?|barra de vida|lore|racha|personaje|jugador(a)?|level|quest|guild|player)\b/i;

export class ClinicalLanguageError extends Error {}

export function assertClinicalLanguage(text: string): void {
  const m = GAME_TERMS.exec(text);
  if (m) throw new ClinicalLanguageError(`El informe clínico contiene terminología de juego: "${m[0]}"`);
}

const TREND_ES: Record<ReportRow['trend'], string> = {
  IMPROVED: 'Mejoría (supera el MDC)', WORSENED: 'Empeoramiento (supera el MDC)',
  FAVORABLE_UNCONFIRMED: 'Cambio favorable (MDC no calibrado)', UNFAVORABLE_UNCONFIRMED: 'Cambio desfavorable (MDC no calibrado)',
  STABLE: 'Sin cambio relevante (< MDC)', NOT_DIRECTIONAL: 'Cambio sin dirección normativa', INSUFFICIENT: 'Datos insuficientes',
};
export const trendLabel = (t: ReportRow['trend']) => TREND_ES[t];
