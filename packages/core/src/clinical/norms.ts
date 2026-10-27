import { round } from '../instruments/common';

/**
 * Normas de referencia poblacionales para expresar percentiles.
 * El código NO trae valores normativos: el equipo SIFUS carga normas
 * publicadas (idealmente colombianas o latinoamericanas) con su cita. Sin
 * norma aplicable, el informe dice "sin norma de referencia" en vez de
 * inventar un percentil.
 */
export type NormMethod =
  | { kind: 'NORMAL'; mean: number; sd: number }
  | { kind: 'PERCENTILE_TABLE'; points: { p: number; value: number }[] };

export interface ReferenceNorm {
  measureCode: string;
  sex: 'FEMALE' | 'MALE' | 'ANY';
  ageMin: number;
  ageMax: number;
  method: NormMethod;
  citation: string;
}

/** Φ(z) con la aproximación de Abramowitz-Stegun 26.2.17 (error < 7.5e-8). */
export function normalCdf(z: number): number {
  const t = 1 / (1 + 0.2316419 * Math.abs(z));
  const d = 0.3989422804014327 * Math.exp((-z * z) / 2);
  const p = d * t * (0.31938153 + t * (-0.356563782 + t * (1.781477937 + t * (-1.821255978 + t * 1.330274429))));
  return z >= 0 ? 1 - p : p;
}

export function findNorm(norms: ReferenceNorm[], measureCode: string, sex: string, age: number): ReferenceNorm | undefined {
  const candidates = norms.filter((n) => n.measureCode === measureCode && age >= n.ageMin && age <= n.ageMax);
  return candidates.find((n) => n.sex === sex) ?? candidates.find((n) => n.sex === 'ANY');
}

export interface NormComparison {
  percentile: number;
  zScore: number | null;
  /** T = 50 + 10z (solo con norma normal). */
  tScore: number | null;
  citation: string;
}

export function compareToNorm(value: number, norm: ReferenceNorm): NormComparison {
  if (norm.method.kind === 'NORMAL') {
    const z = (value - norm.method.mean) / norm.method.sd;
    return { percentile: round(normalCdf(z) * 100, 1), zScore: round(z, 2), tScore: round(50 + 10 * z, 1), citation: norm.citation };
  }
  const pts = [...norm.method.points].sort((a, b) => a.value - b.value);
  let percentile: number;
  if (value <= pts[0]!.value) percentile = pts[0]!.p;
  else if (value >= pts[pts.length - 1]!.value) percentile = pts[pts.length - 1]!.p;
  else {
    const hi = pts.findIndex((x) => x.value >= value);
    const a = pts[hi - 1]!;
    const b = pts[hi]!;
    percentile = a.p + ((value - a.value) / (b.value - a.value)) * (b.p - a.p);
  }
  return { percentile: round(percentile, 1), zScore: null, tScore: null, citation: norm.citation };
}
