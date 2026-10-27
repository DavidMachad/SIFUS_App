import { describe, expect, it } from 'vitest';
import {
  assertClinicalLanguage,
  buildClinicalReport,
  ClinicalLanguageError,
  compareToNorm,
  normalCdf,
  recommendGuild,
  toFhirObservation,
  type ReferenceNorm,
} from '../src';

const gripNorm: ReferenceNorm = {
  measureCode: 'GRIP_DOMINANT_KG', sex: 'FEMALE', ageMin: 25, ageMax: 39,
  method: { kind: 'NORMAL', mean: 30, sd: 5 }, citation: 'NORMA SINTÉTICA DE PRUEBA',
};

describe('Normas y percentiles', () => {
  it('Φ(z) correcta', () => {
    expect(normalCdf(0)).toBeCloseTo(0.5, 6);
    expect(normalCdf(1.96)).toBeCloseTo(0.975, 3);
  });
  it('percentil, z y T frente a la norma', () => {
    const c = compareToNorm(35, gripNorm);
    expect(c.zScore).toBe(1);
    expect(c.tScore).toBe(60);
    expect(c.percentile).toBeCloseTo(84.1, 1);
  });
  it('interpola tablas de percentiles', () => {
    const n: ReferenceNorm = { ...gripNorm, method: { kind: 'PERCENTILE_TABLE', points: [{ p: 25, value: 26 }, { p: 50, value: 30 }, { p: 75, value: 34 }] } };
    expect(compareToNorm(32, n).percentile).toBe(62.5);
  });
});

describe('Informe clínico', () => {
  const report = buildClinicalReport({
    subjectLabel: 'SIFUS-000123', sex: 'FEMALE', ageYears: 32, norms: [gripNorm], generatedAt: '2026-10-27',
    rows: [
      { measureCode: 'GRIP_DOMINANT_KG', baseline: { value: 25, date: '2026-08-02' }, current: { value: 29, date: '2026-10-01' }, mdc: 3 },
      { measureCode: 'PSS10_TOTAL', baseline: { value: 29, date: '2026-08-02' }, current: { value: 27, date: '2026-10-01' }, mdc: 4 },
      { measureCode: 'WEIGHT_KG', baseline: { value: 72, date: '2026-08-02' }, current: { value: 70.1, date: '2026-10-01' } },
    ],
  });

  it('cambio vs. línea de base, cambio estandarizado y percentiles', () => {
    const grip = report.rows.find((r) => r.measure.code === 'GRIP_DOMINANT_KG')!;
    expect(grip.change).toBe(4);
    expect(grip.standardizedChange).toBe(0.8);
    expect(grip.trend).toBe('IMPROVED');
    expect(grip.baselineNorm!.percentile).toBeLessThan(grip.currentNorm!.percentile);
  });

  it('un cambio menor que el MDC es "sin cambio relevante"; el peso no tiene dirección normativa', () => {
    expect(report.rows.find((r) => r.measure.code === 'PSS10_TOTAL')!.trend).toBe('STABLE');
    expect(report.rows.find((r) => r.measure.code === 'WEIGHT_KG')!.trend).toBe('NOT_DIRECTIONAL');
    expect(report.rows.find((r) => r.measure.code === 'PSS10_TOTAL')!.interpretation).toBe('Estrés percibido alto');
  });

  it('el texto clínico rechaza terminología de juego', () => {
    expect(() => assertClinicalLanguage('El paciente subió de nivel y ganó 30 XP')).toThrow(ClinicalLanguageError);
    expect(() => assertClinicalLanguage(report.notes.join(' ') + report.rows.map((r) => r.measure.label + (r.interpretation ?? '')).join(' '))).not.toThrow();
  });
});

describe('FHIR', () => {
  it('Observation con código local + LOINC, categoría vital-signs y UCUM', () => {
    const o = toFhirObservation('Patient/9b1c…', 'WEIGHT_KG', 70.1, '2026-10-01');
    expect(o.code.coding.map((c) => c.code)).toEqual(['WEIGHT_KG', '29463-7', '27113001']);
    expect(o.category[0]!.coding[0]!.code).toBe('vital-signs');
    expect(o.valueQuantity.code).toBe('kg');
    expect(JSON.stringify(o)).not.toContain('PENDING');
  });
});

describe('Gremios según MSPSS', () => {
  it('apoyo global bajo → grupo pequeño facilitado', () => {
    const r = recommendGuild({ mspss: { total: 2.4, family: 3, friends: 2, significantOther: 2.2 }, setting: 'EDUCATIONAL' });
    expect(r.facilitation).toBe('FACILITATOR_LED');
    expect(r.maxSize).toBe(8);
  });
  it('barrera compartida → gremio anónimo de pares', () => {
    const r = recommendGuild({ mspss: { total: 4.5, family: 5, friends: 4, significantOther: 4.5 }, setting: 'WORKPLACE', sharedBarrier: 'CARE_DUTIES' });
    expect(r.guildType).toBe('SHARED_BARRIER');
    expect(r.anonymous).toBe(true);
  });
  it('apoyo alto → rol de mentor/a', () => {
    expect(recommendGuild({ mspss: { total: 6.2, family: 6, friends: 6.5, significantOther: 6 }, setting: 'COMMUNITY' }).suggestedRole).toBe('MENTOR');
  });
});
