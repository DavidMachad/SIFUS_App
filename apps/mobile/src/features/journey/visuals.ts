import type { StationLevel } from '@sifus/core';

/** Íconos genéricos (emoji del sistema): el arte propio de la app llegará después. */
export const STATION_EMOJI: Record<number, string> = { 1: '🌬️', 2: '👁️', 3: '🧭', 4: '🔥', 5: '👣', 6: '✳️', 7: '🎯', 8: '🤝' };

export const GEAR_EMOJI: Record<string, string> = {
  AIR_THREAD: '🪡', HELMET: '⛑️', SHIELD: '🛡️', COMPASS: '🧭', ARMOR: '🦺', SHOES: '👟', SEED: '🌱', WEAPON: '🏹', COMPANION: '🐕', SERVICE_HALO: '😇',
};

export const LEVEL_TONE: Record<StationLevel, 'muted' | 'primary' | 'accent'> = {
  NONE: 'muted', APPRENTICE: 'primary', PRACTITIONER: 'primary', CHAMPION: 'accent',
};
