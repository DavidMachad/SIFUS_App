import type { FmsPattern } from '../domain/enums';
import { FMS_PATTERNS } from '../domain/enums';
import { InstrumentValidationError } from './common';

/**
 * Functional Movement Screen (Cook, Burton & Hoogenboom, 2006).
 * 7 patrones, 0–3 cada uno, total 0–21.
 *  - Patrones bilaterales: la puntuación final es el lado MÁS BAJO; una
 *    diferencia entre lados se registra como asimetría.
 *  - Pruebas de despeje (impingement de hombro, extensión y flexión espinal):
 *    si hay dolor, el patrón asociado puntúa 0.
 *  - 0 = dolor → derivar a valoración profesional; no se carga ese patrón.
 *
 * El corte ≤14 como "riesgo de lesión" tiene evidencia inconsistente; aquí no
 * se usa para etiquetar, sino para priorizar misiones correctivas.
 */
export const FMS_SCORING_VERSION = 'fms@1.0.0';

const BILATERAL: ReadonlySet<FmsPattern> = new Set([
  'HURDLE_STEP',
  'INLINE_LUNGE',
  'SHOULDER_MOBILITY',
  'ACTIVE_STRAIGHT_LEG_RAISE',
  'ROTARY_STABILITY',
]);

/** Patrones que tienen prueba de despeje asociada. */
const CLEARED_BY: Partial<Record<FmsPattern, string>> = {
  SHOULDER_MOBILITY: 'Despeje de hombro (impingement)',
  TRUNK_STABILITY_PUSH_UP: 'Despeje de extensión espinal',
  ROTARY_STABILITY: 'Despeje de flexión espinal',
};

export interface FmsPatternInput {
  left?: number;
  right?: number;
  single?: number;
  clearingTestPain?: boolean;
}

export interface FmsPatternResult extends FmsPatternInput {
  pattern: FmsPattern;
  finalScore: number;
  asymmetric: boolean;
  painful: boolean;
}

export interface FmsResult {
  totalScore: number;
  patterns: FmsPatternResult[];
  hasAsymmetry: boolean;
  hasPain: boolean;
  painfulPatterns: FmsPattern[];
  asymmetricPatterns: FmsPattern[];
  /** Patrones con 1: prioridad para misiones correctivas de movilidad/control. */
  priorityPatterns: FmsPattern[];
  scoringVersion: string;
}

const checkScore = (pattern: FmsPattern, side: string, v: number | undefined): number => {
  if (v === undefined || !Number.isInteger(v) || v < 0 || v > 3) {
    throw new InstrumentValidationError('FMS', `${pattern} (${side}) = ${v} fuera de rango [0, 3]`);
  }
  return v;
};

export function scoreFms(input: Record<FmsPattern, FmsPatternInput>): FmsResult {
  const patterns: FmsPatternResult[] = FMS_PATTERNS.map((pattern) => {
    const p = input[pattern];
    if (!p) throw new InstrumentValidationError('FMS', `falta el patrón ${pattern}`);
    if (p.clearingTestPain && !CLEARED_BY[pattern]) {
      throw new InstrumentValidationError('FMS', `${pattern} no tiene prueba de despeje asociada`);
    }

    let raw: number;
    let asymmetric = false;
    if (BILATERAL.has(pattern)) {
      const l = checkScore(pattern, 'izquierdo', p.left);
      const r = checkScore(pattern, 'derecho', p.right);
      raw = Math.min(l, r);
      asymmetric = l !== r;
    } else {
      raw = checkScore(pattern, 'único', p.single);
    }
    const finalScore = p.clearingTestPain ? 0 : raw;
    return { pattern, ...p, finalScore, asymmetric, painful: finalScore === 0 };
  });

  const pick = (pred: (p: FmsPatternResult) => boolean) => patterns.filter(pred).map((p) => p.pattern);
  return {
    totalScore: patterns.reduce((s, p) => s + p.finalScore, 0),
    patterns,
    hasAsymmetry: patterns.some((p) => p.asymmetric),
    hasPain: patterns.some((p) => p.painful),
    painfulPatterns: pick((p) => p.painful),
    asymmetricPatterns: pick((p) => p.asymmetric),
    priorityPatterns: pick((p) => p.finalScore === 1),
    scoringVersion: FMS_SCORING_VERSION,
  };
}
