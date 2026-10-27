/**
 * Enums de dominio. Reflejan los enums de packages/db/prisma/schema.prisma,
 * pero sin depender de Prisma: así @sifus/core corre igual en el servidor, en
 * la app móvil (modo sin conexión) y en las pruebas.
 */

export const FUNCTIONAL_CAPACITIES = [
  'STRENGTH',
  'ENDURANCE',
  'MOBILITY',
  'BALANCE',
  'COORDINATION',
  'AGILITY',
  'PROPRIOCEPTION',
] as const;
export type FunctionalCapacity = (typeof FUNCTIONAL_CAPACITIES)[number];

export const FMS_PATTERNS = [
  'DEEP_SQUAT',
  'HURDLE_STEP',
  'INLINE_LUNGE',
  'SHOULDER_MOBILITY',
  'ACTIVE_STRAIGHT_LEG_RAISE',
  'TRUNK_STABILITY_PUSH_UP',
  'ROTARY_STABILITY',
] as const;
export type FmsPattern = (typeof FMS_PATTERNS)[number];

export type TrainingExperience = 'NONE' | 'BEGINNER' | 'INTERMEDIATE' | 'ADVANCED';

export type ReadinessBand = 'RECOVERY' | 'BALANCE' | 'EXPANSION';

/** Ordenadas de menor a mayor exigencia. */
export const MISSION_INTENSITIES = ['RESTORATIVE', 'LIGHT', 'MODERATE', 'HIGH'] as const;
export type MissionIntensity = (typeof MISSION_INTENSITIES)[number];

export type MissionCategory =
  | 'RECOVERY'
  | 'MINDFULNESS'
  | 'FUNCTIONAL'
  | 'STRENGTH'
  | 'CONDITIONING'
  | 'COMMUNITY'
  | 'LORE';

export type MissionSlot = 'MAIN' | 'RECOVERY' | 'COMMUNITY' | 'LORE';

export const VIA_STRENGTHS = [
  'CREATIVITY',
  'CURIOSITY',
  'JUDGMENT',
  'LOVE_OF_LEARNING',
  'PERSPECTIVE',
  'BRAVERY',
  'PERSEVERANCE',
  'HONESTY',
  'ZEST',
  'LOVE',
  'KINDNESS',
  'SOCIAL_INTELLIGENCE',
  'TEAMWORK',
  'FAIRNESS',
  'LEADERSHIP',
  'FORGIVENESS',
  'HUMILITY',
  'PRUDENCE',
  'SELF_REGULATION',
  'APPRECIATION_OF_BEAUTY',
  'GRATITUDE',
  'HOPE',
  'HUMOR',
  'SPIRITUALITY',
] as const;
export type ViaStrength = (typeof VIA_STRENGTHS)[number];

export type AgeGroup = 'ADOLESCENT' | 'ADULT' | 'OLDER_ADULT';

export function ageGroupOf(ageYears: number): AgeGroup {
  if (ageYears < 18) return 'ADOLESCENT';
  if (ageYears >= 60) return 'OLDER_ADULT';
  return 'ADULT';
}
