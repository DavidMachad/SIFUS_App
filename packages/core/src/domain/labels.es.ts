import type { FunctionalCapacity, ReadinessBand, ViaStrength } from './enums';

export const CAPACITY_LABELS: Record<FunctionalCapacity, string> = {
  STRENGTH: 'Fuerza',
  ENDURANCE: 'Resistencia',
  MOBILITY: 'Movilidad',
  BALANCE: 'Equilibrio',
  COORDINATION: 'Coordinación',
  AGILITY: 'Agilidad',
  PROPRIOCEPTION: 'Propiocepción',
};

export const BAND_LABELS: Record<ReadinessBand, string> = {
  RECOVERY: 'Ruta de Recuperación',
  BALANCE: 'Ruta de Equilibrio',
  EXPANSION: 'Ruta de Expansión',
};

export const VIA_LABELS: Record<ViaStrength, string> = {
  CREATIVITY: 'Creatividad',
  CURIOSITY: 'Curiosidad',
  JUDGMENT: 'Juicio',
  LOVE_OF_LEARNING: 'Amor por el aprendizaje',
  PERSPECTIVE: 'Perspectiva',
  BRAVERY: 'Valentía',
  PERSEVERANCE: 'Perseverancia',
  HONESTY: 'Honestidad',
  ZEST: 'Vitalidad',
  LOVE: 'Amor',
  KINDNESS: 'Bondad',
  SOCIAL_INTELLIGENCE: 'Inteligencia social',
  TEAMWORK: 'Trabajo en equipo',
  FAIRNESS: 'Equidad',
  LEADERSHIP: 'Liderazgo',
  FORGIVENESS: 'Perdón',
  HUMILITY: 'Humildad',
  PRUDENCE: 'Prudencia',
  SELF_REGULATION: 'Autorregulación',
  APPRECIATION_OF_BEAUTY: 'Apreciación de la belleza',
  GRATITUDE: 'Gratitud',
  HOPE: 'Esperanza',
  HUMOR: 'Humor',
  SPIRITUALITY: 'Espiritualidad',
};
