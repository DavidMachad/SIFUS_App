import type { ReadinessBand } from '../domain/enums';

/**
 * Filtro de espiritualidad/propósito del Creador de Personaje.
 *
 * La espiritualidad se entiende como búsqueda de sentido, coherencia y
 * conexión; no presupone una religión. La orientación elegida adapta:
 *  1. QUÉ instrumento se aplica (y qué subescala cuenta en el índice),
 *  2. el lenguaje de las misiones de recuperación,
 *  3. las preguntas de la Bitácora.
 * Nunca cambia el plan físico ni la seguridad. Se puede cambiar cuando se quiera.
 */
export const SPIRITUAL_ORIENTATIONS = ['THEOLOGICAL', 'MINDFULNESS', 'NATURE', 'SECULAR_PURPOSE'] as const;
export type SpiritualOrientation = (typeof SPIRITUAL_ORIENTATIONS)[number];

export const ORIENTATION_LABELS: Record<SpiritualOrientation, { title: string; description: string }> = {
  THEOLOGICAL: { title: 'Fe y vida espiritual', description: 'Mi fe o mi relación con Dios me sostiene.' },
  MINDFULNESS: { title: 'Meditación y consciencia plena', description: 'Me ayuda estar presente, respirar y observar.' },
  NATURE: { title: 'Conexión con la naturaleza', description: 'Me renuevo en contacto con la tierra, el agua, el monte.' },
  SECULAR_PURPOSE: { title: 'Propósito de vida', description: 'Me mueven mis valores, mis metas y las personas que quiero.' },
};

export interface OrientationProfile {
  /** Instrumentos de propósito/espiritualidad a ofrecer como misión de evaluación. */
  instruments: ('FACIT_SP_12' | 'SWBS' | 'PIL' | 'VIA_IS')[];
  /** FACIT-Sp: incluir la subescala de Fe (12) o solo Significado + Paz (8). */
  facitIncludeFaith: boolean;
  /** SWBS: total (religioso + existencial) o solo existencial. */
  swbsScope: 'TOTAL' | 'EXISTENTIAL_ONLY';
}

export const ORIENTATION_PROFILES: Record<SpiritualOrientation, OrientationProfile> = {
  THEOLOGICAL: { instruments: ['FACIT_SP_12', 'SWBS', 'VIA_IS'], facitIncludeFaith: true, swbsScope: 'TOTAL' },
  MINDFULNESS: { instruments: ['FACIT_SP_12', 'PIL', 'VIA_IS'], facitIncludeFaith: false, swbsScope: 'EXISTENTIAL_ONLY' },
  NATURE: { instruments: ['FACIT_SP_12', 'PIL', 'VIA_IS'], facitIncludeFaith: false, swbsScope: 'EXISTENTIAL_ONLY' },
  SECULAR_PURPOSE: { instruments: ['PIL', 'FACIT_SP_12', 'VIA_IS'], facitIncludeFaith: false, swbsScope: 'EXISTENTIAL_ONLY' },
};

/** Porcentaje del rango, según la orientación, para el Índice de Vida. */
export function facitPct(total: number, includeFaith: boolean): number {
  return (total / (includeFaith ? 48 : 32)) * 100;
}
export function swbsPct(scores: { religious: number; existential: number }, scope: OrientationProfile['swbsScope']): number {
  return scope === 'TOTAL'
    ? ((scores.religious + scores.existential - 20) / 100) * 100
    : ((scores.existential - 10) / 50) * 100;
}

export interface LorePrompt {
  code: string;
  text: string;
}

/**
 * Preguntas de la Bitácora: micro-registros (≤ 1 min) que vinculan el logro
 * físico con el propósito, los valores y la gratitud.
 */
const PROMPTS: Record<SpiritualOrientation, Record<'ACHIEVEMENT' | 'GRATITUDE' | 'GENTLE', LorePrompt>> = {
  THEOLOGICAL: {
    ACHIEVEMENT: { code: 'TH_ACH', text: 'Hoy tu cuerpo logró algo nuevo. ¿Cómo se conecta con tu fe o con lo que crees?' },
    GRATITUDE: { code: 'TH_GRA', text: '¿Por qué das gracias hoy?' },
    GENTLE: { code: 'TH_GEN', text: 'En un día pesado, ¿qué te sostuvo? Puedes escribirlo como una oración, si quieres.' },
  },
  MINDFULNESS: {
    ACHIEVEMENT: { code: 'MI_ACH', text: '¿Qué notaste en tu cuerpo y en tu mente al lograr el reto de hoy?' },
    GRATITUDE: { code: 'MI_GRA', text: 'Nombra tres cosas pequeñas que hoy agradeces.' },
    GENTLE: { code: 'MI_GEN', text: 'Respira tres veces. ¿Qué necesitas en este momento?' },
  },
  NATURE: {
    ACHIEVEMENT: { code: 'NA_ACH', text: '¿Qué te enseñó tu cuerpo hoy, como la quebrada que sigue su cauce?' },
    GRATITUDE: { code: 'NA_GRA', text: '¿Qué parte de la naturaleza te acompañó hoy?' },
    GENTLE: { code: 'NA_GEN', text: 'Hasta los árboles descansan en su estación. ¿Qué te pide hoy tu cuerpo?' },
  },
  SECULAR_PURPOSE: {
    ACHIEVEMENT: { code: 'SE_ACH', text: '¿A qué valor o meta tuya le aportó el logro de hoy?' },
    GRATITUDE: { code: 'SE_GRA', text: '¿A quién o a qué le agradeces hoy?' },
    GENTLE: { code: 'SE_GEN', text: 'Aun en un día difícil, ¿qué hiciste hoy que se parece a quien quieres ser?' },
  },
};

export function selectLorePrompt(o: SpiritualOrientation, band: ReadinessBand, hadAchievement: boolean): LorePrompt {
  if (band === 'RECOVERY') return PROMPTS[o].GENTLE;
  return hadAchievement ? PROMPTS[o].ACHIEVEMENT : PROMPTS[o].GRATITUDE;
}
