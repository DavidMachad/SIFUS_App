import { FUNCTIONAL_CAPACITIES, type FunctionalCapacity } from '../domain/enums';

/**
 * Árbol de Habilidades Funcionales.
 *
 * Dos fuentes de progreso por capacidad, deliberadamente separadas:
 *  1. XP de práctica (misiones): premia la constancia. Nunca disminuye: no hay
 *     castigo por pausar, enfermarse o vivir una mala semana.
 *  2. Hitos evaluados (valoraciones presenciales): premian una mejora real
 *     respecto a la PROPIA línea de base, mayor que el cambio mínimo detectable
 *     (MDC). No se compara a la persona con normas poblacionales en la interfaz:
 *     cada quien parte de donde está.
 */

export type SkillState = Record<FunctionalCapacity, { xp: number; level: number; milestones: number }>;

/** Curva suave: el nivel n requiere 50·(n−1)² XP (nivel 2 = 50, nivel 5 = 800). */
export function levelForXp(xp: number): number {
  return Math.floor(Math.sqrt(Math.max(0, xp) / 50)) + 1;
}

export function xpForLevel(level: number): number {
  return 50 * (level - 1) ** 2;
}

export function emptySkillState(): SkillState {
  return Object.fromEntries(FUNCTIONAL_CAPACITIES.map((c) => [c, { xp: 0, level: 1, milestones: 0 }])) as SkillState;
}

export interface LevelUp {
  capacity: FunctionalCapacity;
  from: number;
  to: number;
}

export function applyCapacityXp(
  state: SkillState,
  gained: Partial<Record<FunctionalCapacity, number>>,
): { state: SkillState; levelUps: LevelUp[] } {
  const next = Object.fromEntries(
    Object.entries(state).map(([cap, s]) => [cap, { ...s }]),
  ) as SkillState;
  const levelUps: LevelUp[] = [];
  for (const [cap, amount] of Object.entries(gained) as [FunctionalCapacity, number][]) {
    if (!amount || amount <= 0) continue;
    const s = next[cap];
    const before = s.level;
    s.xp += amount;
    s.level = levelForXp(s.xp);
    if (s.level > before) levelUps.push({ capacity: cap, from: before, to: s.level });
  }
  return { state: next, levelUps };
}

export interface MeasureComparison {
  measureCode: string;
  capacity: FunctionalCapacity;
  baseline: number;
  current: number;
  /** +1 si mayor es mejor, −1 si menor es mejor. */
  direction: 1 | -1;
  /** Cambio mínimo detectable; si falta, no se otorga hito (rigor ante todo). */
  mdc?: number;
}

export interface Milestone {
  measureCode: string;
  capacity: FunctionalCapacity;
  improvement: number;
}

/** Hitos de evaluación: mejora orientada ≥ MDC respecto a la línea de base. */
export function evaluateMilestones(comparisons: MeasureComparison[]): Milestone[] {
  return comparisons.flatMap((c) => {
    if (c.mdc === undefined || c.mdc <= 0) return [];
    const improvement = (c.current - c.baseline) * c.direction;
    return improvement >= c.mdc ? [{ measureCode: c.measureCode, capacity: c.capacity, improvement }] : [];
  });
}
