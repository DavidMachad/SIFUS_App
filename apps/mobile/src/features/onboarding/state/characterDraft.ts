import {
  isakFinalValue,
  needsThirdTrial,
  type BodyRegion,
  type InjuryStatus,
  type SpiritualOrientation,
  type TrainingExperience,
  type ViaStrength,
} from '@sifus/core';

/**
 * Estado del Creador de Personaje (onboarding). Lógica pura, sin React, para
 * poder probarla y reutilizarla (p. ej. en el modo evaluador de la web).
 *
 * Principio anti-fricción: casi todo es opcional. Lo que se omite no bloquea:
 * se convierte en una "misión secundaria" que da XP al completarse después.
 */

export type AvatarArchetype = 'EXPLORER' | 'GUARDIAN' | 'SAGE' | 'ARTISAN' | 'WAYFARER';
export type SexForReference = 'FEMALE' | 'MALE' | 'INTERSEX' | 'UNDISCLOSED';
export type ImplementationSetting = 'EDUCATIONAL' | 'WORKPLACE' | 'COMMUNITY' | 'HEALTHCARE';
export type TrainingModality =
  | 'STRENGTH_TRAINING' | 'CALISTHENICS' | 'FUNCTIONAL' | 'CARDIO_ENDURANCE'
  | 'SPORTS' | 'DANCE' | 'YOGA_PILATES' | 'WALKING' | 'OTHER';
export type PurposeTheme =
  | 'FAMILY' | 'HEALING' | 'STRESS_RELEASE' | 'SELF_CARE' | 'COMMUNITY' | 'FAITH_SPIRITUALITY' | 'AUTONOMY' | 'OTHER';

export type SmokingStatus = 'NEVER' | 'FORMER' | 'CURRENT' | 'UNDISCLOSED';

export interface InjuryDraft {
  region: BodyRegion;
  status: InjuryStatus;
  /** Dolor al moverse 0–10. */
  currentPain?: number;
}

/**
 * Tamizaje previo a la actividad física, adaptado de las preguntas generales
 * del PAR-Q+ (versión vigente a verificar). Un "sí" no excluye a nadie: solo
 * exige aval profesional antes de la alta intensidad.
 */
export const READINESS_SCREEN_QUESTIONS = [
  { id: 'heartCondition', text: '¿Algún profesional de la salud te ha dicho que tienes una condición del corazón o presión arterial alta?' },
  { id: 'chestPain', text: '¿Sientes dolor en el pecho en reposo, en tus actividades diarias o al hacer ejercicio?' },
  { id: 'dizziness', text: '¿Has perdido el equilibrio por mareo o has perdido el conocimiento en los últimos 12 meses?' },
  { id: 'chronicCondition', text: '¿Tienes otra condición crónica diagnosticada (p. ej. diabetes, asma, enfermedad renal)?' },
  { id: 'medication', text: '¿Tomas actualmente medicamentos para una condición crónica?' },
  { id: 'pregnancy', text: '¿Estás en embarazo o tuviste un parto en los últimos 6 meses?' },
] as const;
export type ReadinessScreenId = (typeof READINESS_SCREEN_QUESTIONS)[number]['id'];

export const PERIMETER_SITES = ['CHEST', 'ARM_RELAXED', 'ARM_FLEXED_TENSED', 'WAIST', 'HIP', 'THIGH_MID', 'CALF_MAX'] as const;
export type PerimeterSite = (typeof PERIMETER_SITES)[number];

/**
 * ¿Quién mide?
 *  EVALUATOR: sesión presencial con evaluador SIFUS → línea de base oficial
 *             (2 tomas por perímetro, criterio ISAK).
 *  SELF:      autorreporte → personaliza el juego, no entra a la evidencia.
 *  LATER:     se convierte en misión secundaria.
 */
export type MeasurementMode = 'EVALUATOR' | 'SELF' | 'LATER';

export interface CharacterDraft {
  // Paso 1 · Identidad del personaje
  displayName: string;
  archetype?: AvatarArchetype;
  birthDate?: string; // YYYY-MM-DD
  sexForReference: SexForReference;
  setting?: ImplementationSetting;

  // Paso 2 · Ritmo vital (anamnesis fisiológica)
  sleepHoursNight?: number;
  sleepQuality?: number;
  perceivedStress?: number;
  waterIntakeLiters?: number;

  // Paso 3 · Historial de aventuras (entrenamiento)
  trainingExperience?: TrainingExperience;
  weeklyFrequency?: number;
  avgSessionMinutes?: number;
  preferredModalities: TrainingModality[];
  perceivedBarriers: string[];

  // Paso 4 · Antecedentes y hábitos
  readinessScreen: Partial<Record<ReadinessScreenId, boolean>>;
  injuries: InjuryDraft[];
  smokingStatus: SmokingStatus;
  sittingHoursPerDay?: number;
  screenMinutesBeforeBed?: number;

  // Paso 5 · Atributos del cuerpo (ficha de valoración)
  measurementMode: MeasurementMode;
  heightCm?: number;
  weightKg?: number;
  /** Tomas por sitio. En modo SELF basta una; en EVALUATOR, 2 (o 3 si difieren). */
  perimeterTrials: Partial<Record<PerimeterSite, number[]>>;

  // Paso 6 · Lore (propósito, orientación espiritual y fortalezas)
  spiritualOrientation?: SpiritualOrientation;
  purposeStatement?: string;
  purposeTheme?: PurposeTheme;
  strengths: ViaStrength[];
}

export const MAX_EQUIPPED_STRENGTHS = 5;

export const initialDraft: CharacterDraft = {
  displayName: '',
  sexForReference: 'UNDISCLOSED',
  preferredModalities: [],
  perceivedBarriers: [],
  readinessScreen: {},
  injuries: [],
  smokingStatus: 'UNDISCLOSED',
  measurementMode: 'LATER',
  perimeterTrials: {},
  strengths: [],
};

export type DraftAction =
  | { type: 'set'; patch: Partial<CharacterDraft> }
  | { type: 'toggleModality'; modality: TrainingModality }
  | { type: 'toggleBarrier'; barrier: string }
  | { type: 'toggleStrength'; strength: ViaStrength }
  | { type: 'setScreen'; id: ReadinessScreenId; value: boolean }
  | { type: 'addInjury'; injury: InjuryDraft }
  | { type: 'updateInjury'; index: number; patch: Partial<InjuryDraft> }
  | { type: 'removeInjury'; index: number }
  | { type: 'setPerimeterTrial'; site: PerimeterSite; index: number; value: number | undefined };

const toggle = <T,>(list: T[], item: T): T[] => (list.includes(item) ? list.filter((x) => x !== item) : [...list, item]);

export function draftReducer(state: CharacterDraft, action: DraftAction): CharacterDraft {
  switch (action.type) {
    case 'set':
      return { ...state, ...action.patch };
    case 'toggleModality':
      return { ...state, preferredModalities: toggle(state.preferredModalities, action.modality) };
    case 'toggleBarrier':
      return { ...state, perceivedBarriers: toggle(state.perceivedBarriers, action.barrier) };
    case 'toggleStrength': {
      const equipped = state.strengths.includes(action.strength);
      if (!equipped && state.strengths.length >= MAX_EQUIPPED_STRENGTHS) return state;
      return { ...state, strengths: toggle(state.strengths, action.strength) };
    }
    case 'setScreen':
      return { ...state, readinessScreen: { ...state.readinessScreen, [action.id]: action.value } };
    case 'addInjury':
      return { ...state, injuries: [...state.injuries, action.injury] };
    case 'updateInjury':
      return { ...state, injuries: state.injuries.map((inj, i) => (i === action.index ? { ...inj, ...action.patch } : inj)) };
    case 'removeInjury':
      return { ...state, injuries: state.injuries.filter((_, i) => i !== action.index) };
    case 'setPerimeterTrial': {
      const trials = [...(state.perimeterTrials[action.site] ?? [])];
      if (action.value === undefined) trials.splice(action.index, 1);
      else trials[action.index] = action.value;
      return { ...state, perimeterTrials: { ...state.perimeterTrials, [action.site]: trials.filter((v) => v !== undefined) } };
    }
  }
}

/** Valor final por sitio (media de 2 / mediana de 3, criterio ISAK). */
export function perimeterValue(trials: number[] | undefined): number | undefined {
  return trials && trials.length > 0 ? isakFinalValue(trials) : undefined;
}

/** En modo evaluador, ¿hace falta una 3.ª toma porque las dos primeras difieren > 1%? */
export function requiresThirdTrial(trials: number[] | undefined): boolean {
  return Boolean(trials && trials.length === 2 && needsThirdTrial(trials[0]!, trials[1]!));
}

export function ageFromBirthDate(birthDate: string, today = new Date()): number {
  const [y, m, d] = birthDate.split('-').map(Number) as [number, number, number];
  let age = today.getFullYear() - y;
  if (today.getMonth() + 1 < m || (today.getMonth() + 1 === m && today.getDate() < d)) age--;
  return age;
}

/** Un "sí" en el tamizaje exige aval profesional antes de la alta intensidad. */
export const requiresMedicalClearance = (d: CharacterDraft) => Object.values(d.readinessScreen).some(Boolean);
