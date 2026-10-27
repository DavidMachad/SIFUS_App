import {
  buildDailyPlan,
  checkInFromAnamnesis,
  contextFromAnamnesis,
  FUNCTIONAL_CAPACITIES,
  patternsBlockedByInjuries,
  type DailyPlan,
  type FunctionalCapacity,
} from '@sifus/core';
import { ageFromBirthDate, PERIMETER_SITES, perimeterValue, requiresMedicalClearance, type CharacterDraft } from './characterDraft';

/** Cuerpo de POST /onboarding. El backend lo traduce a los modelos Prisma. */
export interface OnboardingPayload {
  /**
   * Va SOLO a la Bóveda de Identidad (PII). El backend guarda en la base de
   * salud únicamente el año de nacimiento.
   */
  identity: { birthDate: string };
  profile: {
    displayName: string;
    archetype: NonNullable<CharacterDraft['archetype']>;
    birthYear: number;
    spiritualOrientation: NonNullable<CharacterDraft['spiritualOrientation']>;
    sexForReference: CharacterDraft['sexForReference'];
    setting: NonNullable<CharacterDraft['setting']>;
    purposeStatement?: string;
  };
  anamnesis: {
    phase: 'BASELINE';
    sleepHoursNight: number;
    sleepQuality?: number;
    perceivedStress: number;
    waterIntakeLiters?: number;
    trainingExperience: NonNullable<CharacterDraft['trainingExperience']>;
    weeklyFrequency: number;
    avgSessionMinutes: number;
    preferredModalities: CharacterDraft['preferredModalities'];
    perceivedBarriers: string[];
    smokingStatus: CharacterDraft['smokingStatus'];
    sittingHoursPerDay?: number;
    screenMinutesBeforeBed?: number;
  };
  clinical: {
    requiresMedicalClearance: boolean;
    readinessScreen: CharacterDraft['readinessScreen'];
    injuries: CharacterDraft['injuries'];
  };
  /** null cuando la persona eligió "más tarde" (queda como misión secundaria). */
  bodyAssessment: null | {
    phase: 'BASELINE';
    source: 'EVALUATOR' | 'SELF_REPORTED';
    protocolVersion: string;
    heightCm?: number;
    weightKg?: number;
    perimeters: { site: string; side: 'RIGHT' | 'NOT_APPLICABLE'; trialsCm: number[]; valueCm: number }[];
  };
  strengths: CharacterDraft['strengths'];
  pendingSideQuests: string[];
}

const BILATERAL_SITES = new Set(['ARM_RELAXED', 'ARM_FLEXED_TENSED', 'THIGH_MID', 'CALF_MAX']);
export const EVALUATOR_PROTOCOL_VERSION = 'SIFUS-PROT-v1';

/** Precondición: todos los pasos validados (validateStep sin errores). */
export function toOnboardingPayload(d: CharacterDraft): OnboardingPayload {
  const perimeters = PERIMETER_SITES.flatMap((site) => {
    const trials = d.perimeterTrials[site];
    const valueCm = perimeterValue(trials);
    if (!trials || valueCm === undefined) return [];
    // Convención ISAK: perímetros bilaterales en el lado derecho.
    return [{ site, side: BILATERAL_SITES.has(site) ? ('RIGHT' as const) : ('NOT_APPLICABLE' as const), trialsCm: trials, valueCm }];
  });

  // Lo sensible que no se completó hoy queda como misión secundaria.
  const pendingSideQuests: string[] = ['MEDICATIONS', 'SURGICAL_HISTORY', 'FOOD_AVERSIONS'];
  if (Object.keys(d.readinessScreen).length === 0) pendingSideQuests.push('MEDICAL_CONDITIONS');
  if (d.measurementMode === 'LATER' || d.heightCm === undefined) pendingSideQuests.push('BODY_COMPOSITION');

  return {
    identity: { birthDate: d.birthDate! },
    profile: {
      displayName: d.displayName.trim(),
      archetype: d.archetype!,
      birthYear: Number(d.birthDate!.slice(0, 4)),
      spiritualOrientation: d.spiritualOrientation!,
      sexForReference: d.sexForReference,
      setting: d.setting!,
      purposeStatement: d.purposeStatement?.trim() || undefined,
    },
    anamnesis: {
      phase: 'BASELINE',
      sleepHoursNight: d.sleepHoursNight!,
      sleepQuality: d.sleepQuality,
      perceivedStress: d.perceivedStress!,
      waterIntakeLiters: d.waterIntakeLiters,
      trainingExperience: d.trainingExperience!,
      weeklyFrequency: d.weeklyFrequency!,
      avgSessionMinutes: d.avgSessionMinutes!,
      preferredModalities: d.preferredModalities,
      perceivedBarriers: d.perceivedBarriers,
      smokingStatus: d.smokingStatus,
      sittingHoursPerDay: d.sittingHoursPerDay,
      screenMinutesBeforeBed: d.screenMinutesBeforeBed,
    },
    clinical: {
      requiresMedicalClearance: requiresMedicalClearance(d),
      readinessScreen: d.readinessScreen,
      injuries: d.injuries,
    },
    bodyAssessment:
      d.measurementMode === 'LATER'
        ? null
        : {
            phase: 'BASELINE',
            source: d.measurementMode === 'EVALUATOR' ? 'EVALUATOR' : 'SELF_REPORTED',
            protocolVersion: d.measurementMode === 'EVALUATOR' ? EVALUATOR_PROTOCOL_VERSION : 'SELF_REPORT',
            heightCm: d.heightCm,
            weightKg: d.weightKg,
            perimeters,
          },
    strengths: d.strengths,
    pendingSideQuests,
  };
}

/**
 * Estadísticas iniciales del personaje. Todas las capacidades parten en
 * nivel 1: el punto de partida no se califica, se reconoce.
 * La experiencia previa se refleja como "XP de historia", no como ventaja.
 */
export function initialStats(d: CharacterDraft): { level: number; storyXp: number; capacities: Record<FunctionalCapacity, number> } {
  const storyXp = { NONE: 0, BEGINNER: 20, INTERMEDIATE: 40, ADVANCED: 60 }[d.trainingExperience ?? 'NONE'];
  const capacities = Object.fromEntries(FUNCTIONAL_CAPACITIES.map((c) => [c, 1])) as Record<FunctionalCapacity, number>;
  return { level: 1, storyXp, capacities };
}

/** Vista previa del plan del Día 1, calculada localmente con @sifus/core. */
export function previewDayOnePlan(d: CharacterDraft, userId = 'preview', today = new Date()): DailyPlan {
  const isoToday = today.toISOString().slice(0, 10);
  const anamnesis = {
    sleepHoursNight: d.sleepHoursNight!,
    perceivedStress: d.perceivedStress!,
    trainingExperience: d.trainingExperience!,
    avgSessionMinutes: d.avgSessionMinutes!,
  };
  return buildDailyPlan(
    checkInFromAnamnesis(anamnesis, isoToday),
    contextFromAnamnesis(anamnesis, {
      userId,
      ageYears: ageFromBirthDate(d.birthDate!, today),
      equippedStrengths: d.strengths,
      spiritualOrientation: d.spiritualOrientation,
      requiresMedicalClearance: requiresMedicalClearance(d),
      fms: { painfulPatterns: patternsBlockedByInjuries(d.injuries), priorityPatterns: [] },
    }),
  );
}
