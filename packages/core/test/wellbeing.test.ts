import { describe, expect, it } from 'vitest';
import {
  computeWellbeingIndex,
  crossValidate,
  personalBaseline,
  questionnaireResponseQuality,
  zFromBaseline,
  mapPlatformSample,
  type ComponentInput,
} from '../src';

const D = '2026-10-27';
const full: ComponentInput[] = [
  { key: 'WHO5_PCT', value: 64, measuredOn: '2026-10-20' },
  { key: 'GHQ12_LIKERT', value: 12, measuredOn: '2026-10-10' },
  { key: 'PANAS_BALANCE_7D', value: 8, measuredOn: D },
  { key: 'IPAQ_MET_MIN', value: 1200, measuredOn: '2026-10-10' },
  { key: 'STEPS_7D', value: 6500, measuredOn: D },
  { key: 'FMS_TOTAL', value: 14, measuredOn: '2026-10-01' },
  { key: 'PSS10_TOTAL', value: 18, measuredOn: '2026-10-10' },
  { key: 'PSQI_GLOBAL', value: 7, measuredOn: '2026-10-10' },
  { key: 'HRV_Z_7D', value: -0.5, measuredOn: D },
  { key: 'PASSIVE_SLEEP_HOURS_7D', value: 6.5, measuredOn: D },
  { key: 'MEDAS_NORMALIZED', value: 54, measuredOn: '2026-10-01' },
  { key: 'FACIT_SP_PCT', value: 70, measuredOn: '2026-10-01' },
  { key: 'PIL_TOTAL', value: 110, measuredOn: '2026-10-01' },
];

describe('Índice de Vida Consolidado', () => {
  it('calcula 5 atributos y un índice 0–100', () => {
    const r = computeWellbeingIndex(full, { date: D, ageYears: 30 });
    expect(r.status).toBe('OK');
    expect(r.domains.every((d) => d.score !== null)).toBe(true);
    expect(r.index).toBeGreaterThan(0);
    expect(r.index).toBeLessThanOrEqual(100);
    const lifestyle = r.domains.find((d) => d.domain === 'LIFESTYLE')!;
    expect(lifestyle.score).toBe(54);
  });

  it('descarta datos vencidos y no inventa un número con poca información', () => {
    const stale = full.map((c) => ({ ...c, measuredOn: '2026-01-01' }));
    const r = computeWellbeingIndex(stale, { date: D, ageYears: 30 });
    expect(r.status).toBe('INSUFFICIENT_DATA');
    expect(r.index).toBeNull();
  });

  it('el autorreporte diario pierde peso si la validación cruzada detecta inconsistencias', () => {
    const onlyMind: ComponentInput[] = [
      { key: 'WHO5_PCT', value: 40, measuredOn: D },
      { key: 'PANAS_BALANCE_7D', value: 20, measuredOn: D },
    ];
    const trusted = computeWellbeingIndex(onlyMind, { date: D, ageYears: 30, selfReportReliability: 1 });
    const doubted = computeWellbeingIndex(onlyMind, { date: D, ageYears: 30, selfReportReliability: 0.5 });
    const mind = (x: typeof trusted) => x.domains.find((d) => d.domain === 'MIND')!.score!;
    expect(mind(doubted)).toBeLessThan(mind(trusted));
  });

  it('los pasos se puntúan según la edad (meseta 7 000 en ≥ 60 años)', () => {
    const steps = [{ key: 'STEPS_7D' as const, value: 7000, measuredOn: D }];
    const young = computeWellbeingIndex(steps, { date: D, ageYears: 30 }).domains.find((d) => d.domain === 'BODY')!;
    const older = computeWellbeingIndex(steps, { date: D, ageYears: 65 }).domains.find((d) => d.domain === 'BODY')!;
    expect(older.components[0]!.normalized).toBe(100);
    expect(young.components[0]!.normalized).toBeLessThan(100);
  });
});

describe('Validación cruzada y calidad de respuesta', () => {
  const days = (n: number, d: object) => Array.from({ length: n }, (_, i) => ({ date: `2026-10-${String(20 + i).padStart(2, '0')}`, ...d }));

  it('detecta sueño autorreportado muy superior al del sensor', () => {
    const r = crossValidate(days(4, { selfSleepHours: 8, passiveSleepHours: 5.5 }));
    expect(r.flags).toContain('SLEEP_SELF_REPORT_EXCEEDS_PASSIVE');
    expect(r.selfReportReliability).toBe(0.75);
    expect(r.gentlePrompt).toMatch(/No hay respuestas correctas/);
  });

  it('detecta afecto muy favorable con tensión fisiológica sostenida', () => {
    const r = crossValidate(days(3, { panasBalance: 15, selfStress: 2, hrvZ: -2, restingHrDeltaBpm: 8 }));
    expect(r.flags).toContain('FAVORABLE_AFFECT_WITH_PHYSIOLOGICAL_STRAIN');
  });

  it('NUNCA marca un autorreporte de malestar aunque el sensor esté bien (asimetría de seguridad)', () => {
    const r = crossValidate(days(7, { panasBalance: -15, selfStress: 9, hrvZ: 1, restingHrDeltaBpm: -3, selfSleepHours: 4, passiveSleepHours: 7 }));
    expect(r.flags).toEqual([]);
    expect(r.selfReportReliability).toBe(1);
  });

  it('respuestas idénticas en un cuestionario con ítems invertidos y respuestas demasiado rápidas', () => {
    expect(questionnaireResponseQuality({ itemResponses: Array(10).fill(2), reversedItemIndexes: [3, 4, 6, 7], totalSeconds: 8 }))
      .toEqual(['QUESTIONNAIRE_STRAIGHTLINING', 'QUESTIONNAIRE_TOO_FAST']);
  });
});

describe('Datos pasivos', () => {
  it('traduce plataformas sin mezclar SDNN (Apple) con RMSSD (Health Connect)', () => {
    expect(mapPlatformSample('APPLE_HEALTH', 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN')!.metric).toBe('HRV_SDNN_MS');
    expect(mapPlatformSample('HEALTH_CONNECT', 'HeartRateVariabilityRmssdRecord')!.metric).toBe('HRV_RMSSD_MS');
    expect(mapPlatformSample('HEALTH_CONNECT', 'SleepSessionRecord', 'STAGE_TYPE_DEEP')!.metric).toBe('SLEEP_DEEP_MIN');
  });

  it('línea de base personal: exige ≥ 14 días y excluye el día evaluado', () => {
    const hist = Array.from({ length: 20 }, (_, i) => ({ date: `2026-10-${String(i + 7).padStart(2, '0')}`, value: 50 + (i % 5) }));
    const b = personalBaseline(hist, D, { log: true })!;
    expect(b.n).toBe(20);
    expect(zFromBaseline(30, b)!).toBeLessThan(-2);
    expect(personalBaseline(hist.slice(0, 10), D)).toBeNull();
  });
});
