import type { ComponentKey, GamificationMode, WellbeingDomain, WellbeingIndexResult } from '@sifus/core';

/**
 * Modelo de vista del panel principal (lógica pura, sin React).
 *
 * Decisiones de diseño empático para la "barra de vida":
 *  - Nunca hay "game over" ni colores de alarma: un índice bajo se muestra en
 *    azul sereno como "recargando", no en rojo como "perdiendo".
 *  - Sin datos suficientes no hay número: se invita a descubrirlo.
 *  - En modo GENTLE (bandera roja de vigilancia) desaparecen las comparaciones
 *    y las cifras de racha; en modo PAUSED la barra se oculta y el apoyo
 *    humano ocupa el primer lugar.
 */
export type DashboardMode = 'GAME' | 'GENTLE' | 'SUPPORT';
export type BarTone = 'RECHARGING' | 'BALANCED' | 'RADIANT' | 'DISCOVERING';

export interface AttributeView {
  domain: WellbeingDomain;
  label: string;
  emoji: string;
  score: number | null;
  /** Texto: número o "Por descubrir". */
  display: string;
  coverage: number;
}

export interface QuestSuggestion {
  key: ComponentKey;
  title: string;
  minutes: number | null;
  kind: 'QUESTIONNAIRE' | 'EVALUATOR' | 'DEVICE' | 'DAILY';
}

export interface DashboardView {
  mode: DashboardMode;
  bar: { visible: boolean; value: number | null; tone: BarTone; caption: string };
  attributes: AttributeView[];
  /** Misiones de evaluación sugeridas para completar el perfil (máx. 3). */
  quests: QuestSuggestion[];
  showStreaks: boolean;
  /** Siempre true: el botón de ayuda nunca desaparece. */
  showHelpButton: true;
}

const EMOJI: Record<WellbeingDomain, string> = { MIND: '🧠', BODY: '💪', RESTORATION: '🌙', LIFESTYLE: '🥗', PURPOSE: '✨' };

export const QUEST_FOR_COMPONENT: Record<ComponentKey, Omit<QuestSuggestion, 'key'>> = {
  WHO5_PCT: { title: 'Responde el WHO-5', minutes: 2, kind: 'QUESTIONNAIRE' },
  GHQ12_LIKERT: { title: 'Responde el GHQ-12', minutes: 3, kind: 'QUESTIONNAIRE' },
  PANAS_BALANCE_7D: { title: 'Registra tu ánimo del día (30 s)', minutes: 1, kind: 'DAILY' },
  IPAQ_MET_MIN: { title: 'Cuéntanos tu actividad de la semana (IPAQ)', minutes: 3, kind: 'QUESTIONNAIRE' },
  STEPS_7D: { title: 'Conecta Apple Health o Health Connect', minutes: null, kind: 'DEVICE' },
  FMS_TOTAL: { title: 'Agenda tu valoración de movimiento (FMS)', minutes: null, kind: 'EVALUATOR' },
  GRIP_PERCENTILE: { title: 'Mide tu fuerza de agarre con tu evaluador/a', minutes: null, kind: 'EVALUATOR' },
  STRENGTH_REL_PERCENTILE: { title: 'Prueba de fuerza con tu evaluador/a', minutes: null, kind: 'EVALUATOR' },
  WAIST_HEIGHT_RATIO: { title: 'Toma de medidas con tu evaluador/a', minutes: null, kind: 'EVALUATOR' },
  PSQI_GLOBAL: { title: 'Responde sobre tu sueño (PSQI)', minutes: 5, kind: 'QUESTIONNAIRE' },
  AIS_TOTAL: { title: 'Responde la escala de insomnio (AIS)', minutes: 2, kind: 'QUESTIONNAIRE' },
  PSS10_TOTAL: { title: 'Responde la escala de estrés (PSS-10)', minutes: 3, kind: 'QUESTIONNAIRE' },
  HRV_Z_7D: { title: 'Usa tu reloj al dormir para medir tu recuperación', minutes: null, kind: 'DEVICE' },
  PASSIVE_SLEEP_HOURS_7D: { title: 'Conecta el registro de sueño de tu dispositivo', minutes: null, kind: 'DEVICE' },
  MEDAS_NORMALIZED: { title: 'Cuéntanos de tu alimentación (MEDAS)', minutes: 4, kind: 'QUESTIONNAIRE' },
  FACIT_SP_PCT: { title: 'Explora tu bienestar espiritual (FACIT-Sp)', minutes: 4, kind: 'QUESTIONNAIRE' },
  PIL_TOTAL: { title: 'Explora tu propósito de vida (PIL)', minutes: 6, kind: 'QUESTIONNAIRE' },
  SWBS_PCT: { title: 'Explora tu bienestar espiritual (SWBS)', minutes: 5, kind: 'QUESTIONNAIRE' },
};

/** Prioridad: lo rápido y autónomo primero; lo presencial al final. */
const KIND_ORDER = { DAILY: 0, QUESTIONNAIRE: 1, DEVICE: 2, EVALUATOR: 3 } as const;

export function toneFor(index: number | null): BarTone {
  if (index === null) return 'DISCOVERING';
  if (index < 40) return 'RECHARGING';
  if (index < 70) return 'BALANCED';
  return 'RADIANT';
}

const CAPTION: Record<BarTone, string> = {
  DISCOVERING: 'Estamos descubriendo tu energía. Completa una misión de evaluación para encender tu barra.',
  RECHARGING: 'Tu energía se está recargando. Cuidarte hoy es avanzar.',
  BALANCED: 'Tu energía está en equilibrio. Cada pequeño paso suma.',
  RADIANT: 'Tu energía brilla. Compártela con tu gremio.',
};

export function buildDashboardView(result: WellbeingIndexResult | null, mode: GamificationMode): DashboardView {
  const dashMode: DashboardMode = mode === 'PAUSED' ? 'SUPPORT' : mode === 'GENTLE' ? 'GENTLE' : 'GAME';
  const index = result?.status === 'OK' ? result.index : null;
  const tone = toneFor(index);

  const attributes: AttributeView[] = (result?.domains ?? []).map((d) => ({
    domain: d.domain,
    label: d.label,
    emoji: EMOJI[d.domain],
    score: d.score === null ? null : Math.round(d.score),
    display: d.score === null ? 'Por descubrir' : String(Math.round(d.score)),
    coverage: d.coverage,
  }));

  const quests = (result?.domains ?? [])
    .flatMap((d) => d.missing)
    .map((key) => ({ key, ...QUEST_FOR_COMPONENT[key] }))
    .sort((a, b) => KIND_ORDER[a.kind] - KIND_ORDER[b.kind] || (a.minutes ?? 99) - (b.minutes ?? 99))
    .slice(0, 3);

  return {
    mode: dashMode,
    bar: {
      visible: dashMode !== 'SUPPORT',
      value: index,
      tone,
      caption: dashMode === 'GENTLE' ? 'Hoy la barra no importa tanto como tú. Avanza a tu ritmo.' : CAPTION[tone],
    },
    attributes,
    // En SUPPORT no se proponen evaluaciones: no es momento de pedir datos.
    quests: dashMode === 'SUPPORT' ? [] : quests,
    showStreaks: dashMode === 'GAME',
    showHelpButton: true,
  };
}
