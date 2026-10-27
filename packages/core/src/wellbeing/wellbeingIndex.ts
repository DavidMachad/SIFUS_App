import { round } from '../instruments/common';

/**
 * Índice de Vida Consolidado (0–100): la "barra de vida/energía" del avatar.
 *
 * Construcción (v1, PROVISIONAL):
 *   componente → puntaje 0–100 orientado (100 = situación más favorable)
 *   atributo   = media ponderada de sus componentes vigentes
 *   índice     = media de los atributos con cobertura suficiente
 *
 * Reglas de rigor:
 *  - Vigencia: cada componente caduca según la ventana de recuerdo de su
 *    instrumento (p. ej. WHO-5 = 2 semanas). Un dato vencido no se usa.
 *  - Cobertura: un atributo requiere ≥ 25 % de su peso disponible; el índice
 *    requiere ≥ 3 de 5 atributos. Si no, se muestra "faltan datos" (y se
 *    invita a una misión de evaluación), nunca un número inventado.
 *  - Antimanipulación: los autorreportes diarios pesan poco y su peso se
 *    multiplica por la confiabilidad que calcula crossValidate().
 *  - Las métricas físicas sin norma de referencia (prensión, 1RM) solo entran
 *    como percentil frente a una norma poblacional cargada por el equipo; sin
 *    norma, no entran (no se inventan anclajes).
 *  - El inventario VIA describe un perfil de fortalezas, no un nivel de
 *    bienestar ("más" no es "mejor"): personaliza el juego pero NO puntúa.
 *
 * Este índice es una herramienta motivacional y de seguimiento. Antes de
 * usarlo como desenlace de investigación requiere validación psicométrica
 * en la cohorte SIFUS (consistencia interna, validez convergente con
 * WHOQOL-BREF, sensibilidad al cambio). Por eso su versión es "-provisional".
 */
export const WELLBEING_INDEX_VERSION = 'wellbeing-index@1.0.0-provisional';

export const DOMAINS = ['MIND', 'BODY', 'RESTORATION', 'LIFESTYLE', 'PURPOSE'] as const;
export type WellbeingDomain = (typeof DOMAINS)[number];

export const DOMAIN_LABELS: Record<WellbeingDomain, string> = {
  MIND: 'Mente & Emoción',
  BODY: 'Cuerpo & Vitalidad',
  RESTORATION: 'Restauración',
  LIFESTYLE: 'Estilo de Vida',
  PURPOSE: 'Propósito & Espiritualidad',
};

export type ComponentKey =
  | 'WHO5_PCT'
  | 'GHQ12_LIKERT'
  | 'PANAS_BALANCE_7D'
  | 'IPAQ_MET_MIN'
  | 'STEPS_7D'
  | 'FMS_TOTAL'
  | 'GRIP_PERCENTILE'
  | 'STRENGTH_REL_PERCENTILE'
  | 'WAIST_HEIGHT_RATIO'
  | 'PSQI_GLOBAL'
  | 'AIS_TOTAL'
  | 'PSS10_TOTAL'
  | 'HRV_Z_7D'
  | 'PASSIVE_SLEEP_HOURS_7D'
  | 'MEDAS_NORMALIZED'
  | 'FACIT_SP_PCT'
  | 'PIL_TOTAL'
  | 'SWBS_PCT';

export type ComponentSource = 'VALIDATED_INSTRUMENT' | 'EVALUATOR_TEST' | 'PASSIVE' | 'DAILY_SELF_REPORT';

export interface ScoringContext {
  ageYears: number;
}

interface ComponentDef {
  domain: WellbeingDomain;
  weight: number;
  validityDays: number;
  source: ComponentSource;
  /** Valor crudo → 0–100 orientado. */
  normalize: (raw: number, ctx: ScoringContext) => number;
  rationale: string;
}

const clamp = (v: number) => Math.max(0, Math.min(100, v));
/** Lineal entre dos anclas (a → 0, b → 100); si a > b, la escala es inversa. */
const linear = (a: number, b: number) => (x: number) => clamp(((x - a) / (b - a)) * 100);

/** Pasos: beneficio en mortalidad con meseta ~8 000 (< 60 años) y ~7 000 (≥ 60) (Paluch et al., 2022). */
function stepsScore(steps: number, ctx: ScoringContext): number {
  const plateau = ctx.ageYears >= 60 ? 7000 : 8000;
  return linear(2000, plateau)(steps);
}

/** Sueño: 100 dentro del rango recomendado por edad; penaliza el déficit más que el exceso. */
function sleepHoursScore(h: number, ctx: ScoringContext): number {
  const [lo, hi] = ctx.ageYears < 18 ? [8, 10] : ctx.ageYears >= 65 ? [7, 8] : [7, 9];
  if (h < lo) return clamp(100 - (lo - h) * 25);
  if (h > hi + 1) return clamp(100 - (h - hi - 1) * 15);
  return 100;
}

export const COMPONENTS: Record<ComponentKey, ComponentDef> = {
  // --- Mente & Emoción
  WHO5_PCT: { domain: 'MIND', weight: 0.4, validityDays: 21, source: 'VALIDATED_INSTRUMENT', normalize: linear(0, 100), rationale: 'WHO-5 ya está en 0–100.' },
  GHQ12_LIKERT: { domain: 'MIND', weight: 0.3, validityDays: 35, source: 'VALIDATED_INSTRUMENT', normalize: linear(36, 0), rationale: 'Likert 0–36, invertido.' },
  PANAS_BALANCE_7D: { domain: 'MIND', weight: 0.3, validityDays: 7, source: 'DAILY_SELF_REPORT', normalize: linear(-20, 20), rationale: 'Balance afectivo medio de 7 días.' },
  // --- Cuerpo & Vitalidad
  IPAQ_MET_MIN: {
    domain: 'BODY', weight: 0.25, validityDays: 35, source: 'VALIDATED_INSTRUMENT',
    normalize: (x) => (x <= 600 ? (x / 600) * 50 : clamp(50 + ((x - 600) / 2400) * 50)),
    rationale: '600 MET-min/sem ≈ mínimo recomendado (50); 3 000 ≈ actividad alta (100).',
  },
  STEPS_7D: { domain: 'BODY', weight: 0.2, validityDays: 7, source: 'PASSIVE', normalize: stepsScore, rationale: 'Meseta de beneficio según edad.' },
  FMS_TOTAL: { domain: 'BODY', weight: 0.15, validityDays: 120, source: 'EVALUATOR_TEST', normalize: linear(0, 21), rationale: 'FMS 0–21.' },
  GRIP_PERCENTILE: { domain: 'BODY', weight: 0.15, validityDays: 120, source: 'EVALUATOR_TEST', normalize: linear(0, 100), rationale: 'Percentil frente a norma por sexo y edad.' },
  STRENGTH_REL_PERCENTILE: { domain: 'BODY', weight: 0.1, validityDays: 120, source: 'EVALUATOR_TEST', normalize: linear(0, 100), rationale: 'Percentil de 1RM relativo.' },
  WAIST_HEIGHT_RATIO: {
    domain: 'BODY', weight: 0.15, validityDays: 120, source: 'EVALUATOR_TEST', normalize: (x) => (x <= 0.5 ? 100 : linear(0.7, 0.5)(x)),
    rationale: 'ICE ≤ 0,5 sin riesgo cardiometabólico adicional. Peso bajo a propósito y ajustable a 0 por el equipo.',
  },
  // --- Restauración
  PSQI_GLOBAL: { domain: 'RESTORATION', weight: 0.15, validityDays: 35, source: 'VALIDATED_INSTRUMENT', normalize: linear(21, 0), rationale: 'PSQI 0–21, invertido.' },
  AIS_TOTAL: { domain: 'RESTORATION', weight: 0.15, validityDays: 35, source: 'VALIDATED_INSTRUMENT', normalize: linear(24, 0), rationale: 'AIS 0–24, invertido.' },
  PSS10_TOTAL: { domain: 'RESTORATION', weight: 0.25, validityDays: 35, source: 'VALIDATED_INSTRUMENT', normalize: linear(40, 0), rationale: 'PSS-10 0–40, invertido.' },
  HRV_Z_7D: {
    domain: 'RESTORATION', weight: 0.2, validityDays: 7, source: 'PASSIVE', normalize: (z) => clamp(50 + 20 * z),
    rationale: 'z de ln(HRV) frente a la línea de base personal: 0 → 50; ±2,5 DE → extremos.',
  },
  PASSIVE_SLEEP_HOURS_7D: { domain: 'RESTORATION', weight: 0.2, validityDays: 7, source: 'PASSIVE', normalize: sleepHoursScore, rationale: 'Rango recomendado por edad.' },
  // --- Estilo de Vida
  MEDAS_NORMALIZED: { domain: 'LIFESTYLE', weight: 1, validityDays: 60, source: 'VALIDATED_INSTRUMENT', normalize: linear(0, 100), rationale: 'MEDAS normalizado (vino excluido).' },
  // --- Propósito & Espiritualidad
  FACIT_SP_PCT: { domain: 'PURPOSE', weight: 0.4, validityDays: 60, source: 'VALIDATED_INSTRUMENT', normalize: linear(0, 100), rationale: 'FACIT-Sp-12 o -8 como % del máximo, según orientación.' },
  PIL_TOTAL: { domain: 'PURPOSE', weight: 0.3, validityDays: 90, source: 'VALIDATED_INSTRUMENT', normalize: linear(20, 140), rationale: 'PIL 20–140.' },
  SWBS_PCT: { domain: 'PURPOSE', weight: 0.3, validityDays: 90, source: 'VALIDATED_INSTRUMENT', normalize: linear(0, 100), rationale: 'SWBS total o EWB (secular) como % del rango.' },
};

export interface ComponentInput {
  key: ComponentKey;
  value: number;
  /** Fecha de la medición (YYYY-MM-DD). */
  measuredOn: string;
}

export interface DomainScore {
  domain: WellbeingDomain;
  label: string;
  score: number | null;
  coverage: number;
  components: { key: ComponentKey; normalized: number; effectiveWeight: number }[];
  missing: ComponentKey[];
}

export interface WellbeingIndexResult {
  index: number | null;
  status: 'OK' | 'INSUFFICIENT_DATA';
  domains: DomainScore[];
  /** Cobertura media de los atributos válidos (0–1): qué tan completo es el dato. */
  confidence: number;
  version: string;
  computedFor: string;
}

export const MIN_DOMAIN_COVERAGE = 0.25;
export const MIN_VALID_DOMAINS = 3;

const DAY = 86_400_000;
const ageDays = (from: string, to: string) => (Date.parse(`${to}T00:00:00Z`) - Date.parse(`${from}T00:00:00Z`)) / DAY;

export function computeWellbeingIndex(
  inputs: ComponentInput[],
  ctx: ScoringContext & { date: string; selfReportReliability?: number },
  componentWeights: Partial<Record<ComponentKey, number>> = {},
): WellbeingIndexResult {
  // El dato vigente más reciente por componente.
  const latest = new Map<ComponentKey, ComponentInput>();
  for (const i of inputs) {
    const def = COMPONENTS[i.key];
    const age = ageDays(i.measuredOn, ctx.date);
    if (age < 0 || age > def.validityDays || !Number.isFinite(i.value)) continue;
    const prev = latest.get(i.key);
    if (!prev || prev.measuredOn < i.measuredOn) latest.set(i.key, i);
  }

  const domains: DomainScore[] = DOMAINS.map((domain) => {
    const keys = (Object.keys(COMPONENTS) as ComponentKey[]).filter((k) => COMPONENTS[k].domain === domain);
    const nominal = (k: ComponentKey) => componentWeights[k] ?? COMPONENTS[k].weight;
    const totalWeight = keys.reduce((s, k) => s + nominal(k), 0);
    const parts = keys.flatMap((k) => {
      const input = latest.get(k);
      if (!input) return [];
      const def = COMPONENTS[k];
      const reliability = def.source === 'DAILY_SELF_REPORT' ? (ctx.selfReportReliability ?? 1) : 1;
      return [{ key: k, normalized: round(def.normalize(input.value, ctx), 1), effectiveWeight: nominal(k) * reliability }];
    });
    const present = parts.reduce((s, p) => s + p.effectiveWeight, 0);
    const coverage = totalWeight > 0 ? round(present / totalWeight, 2) : 0;
    const score = coverage >= MIN_DOMAIN_COVERAGE && present > 0
      ? round(parts.reduce((s, p) => s + p.normalized * p.effectiveWeight, 0) / present, 1)
      : null;
    return {
      domain,
      label: DOMAIN_LABELS[domain],
      score,
      coverage,
      components: parts,
      missing: keys.filter((k) => !latest.has(k)),
    };
  });

  const valid = domains.filter((d) => d.score !== null);
  const ok = valid.length >= MIN_VALID_DOMAINS;
  return {
    index: ok ? Math.round(valid.reduce((s, d) => s + d.score!, 0) / valid.length) : null,
    status: ok ? 'OK' : 'INSUFFICIENT_DATA',
    domains,
    confidence: valid.length ? round(valid.reduce((s, d) => s + d.coverage, 0) / valid.length, 2) : 0,
    version: WELLBEING_INDEX_VERSION,
    computedFor: ctx.date,
  };
}
