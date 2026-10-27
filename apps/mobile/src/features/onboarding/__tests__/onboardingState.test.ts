import { describe, expect, it } from 'vitest';
import { draftReducer, initialDraft, MAX_EQUIPPED_STRENGTHS, type CharacterDraft } from '../state/characterDraft';
import { previewDayOnePlan, toOnboardingPayload } from '../state/payload';
import { canAdvance, validateStep } from '../state/validation';

const TODAY = new Date('2026-10-27T12:00:00');

const complete: CharacterDraft = {
  ...initialDraft,
  displayName: 'Ceiba',
  archetype: 'GUARDIAN',
  birthDate: '1990-03-10',
  setting: 'WORKPLACE',
  sleepHoursNight: 5.5,
  perceivedStress: 8,
  trainingExperience: 'BEGINNER',
  weeklyFrequency: 1,
  avgSessionMinutes: 30,
  spiritualOrientation: 'MINDFULNESS',
  readinessScreen: { heartCondition: false, chestPain: false },
  injuries: [{ region: 'KNEE', status: 'ACTIVE', currentPain: 5 }],
  measurementMode: 'EVALUATOR',
  heightCm: 160,
  weightKg: 72,
  perimeterTrials: { WAIST: [88.0, 88.4], ARM_RELAXED: [29, 29] },
  strengths: ['PERSEVERANCE', 'HOPE'],
};

describe('Creador de Personaje — estado y validación', () => {
  it('los capítulos requeridos bloquean el avance con mensajes amables', () => {
    const v = validateStep('rhythm', initialDraft, TODAY);
    expect(Object.keys(v.errors)).toEqual(['sleepHoursNight', 'perceivedStress']);
    expect(v.errors.perceivedStress).toMatch(/No hay respuestas incorrectas/);
  });

  it('"Más adelante" en medidas no bloquea y crea una misión secundaria', () => {
    const d = { ...complete, measurementMode: 'LATER' as const, heightCm: undefined, weightKg: undefined };
    expect(canAdvance('body', d)).toBe(true);
    const payload = toOnboardingPayload(d);
    expect(payload.bodyAssessment).toBeNull();
    expect(payload.pendingSideQuests).toContain('BODY_COMPOSITION');
  });

  it('en modo evaluador exige estatura y peso y pide la 2.ª toma ISAK', () => {
    const d = { ...complete, heightCm: undefined, perimeterTrials: { WAIST: [88] } };
    const v = validateStep('body', d, TODAY);
    expect(v.errors.heightCm).toBeDefined();
    expect(v.warnings['perimeter.WAIST']).toMatch(/segunda toma/);
  });

  it('rechaza valores imposibles con los mismos rangos del esquema analítico', () => {
    expect(validateStep('body', { ...complete, heightCm: 1.6 }, TODAY).errors.heightCm).toMatch(/centímetros/);
  });

  it('menores de edad: aviso de consentimiento del acudiente', () => {
    expect(validateStep('identity', { ...complete, birthDate: '2011-01-01' }, TODAY).warnings.birthDate).toMatch(/acudiente/);
  });

  it('no permite equipar más de 5 fortalezas', () => {
    let d = initialDraft;
    for (const s of ['HOPE', 'ZEST', 'LOVE', 'HUMOR', 'KINDNESS', 'GRATITUDE'] as const) {
      d = draftReducer(d, { type: 'toggleStrength', strength: s });
    }
    expect(d.strengths).toHaveLength(MAX_EQUIPPED_STRENGTHS);
  });

  it('el payload marca la fuente y calcula el valor ISAK por perímetro', () => {
    const p = toOnboardingPayload(complete);
    expect(p.bodyAssessment?.source).toBe('EVALUATOR');
    const waist = p.bodyAssessment!.perimeters.find((x) => x.site === 'WAIST')!;
    expect(waist.valueCm).toBe(88.2);
    expect(p.bodyAssessment!.perimeters.find((x) => x.site === 'ARM_RELAXED')!.side).toBe('RIGHT');
    expect(toOnboardingPayload({ ...complete, measurementMode: 'SELF' }).bodyAssessment?.source).toBe('SELF_REPORTED');
  });

  it('la vista previa del Día 1 aplica el algoritmo de vulnerabilidad a la anamnesis', () => {
    const plan = previewDayOnePlan(complete, 'preview', TODAY);
    expect(plan.band).toBe('RECOVERY'); // estrés 8 + 5,5 h de sueño
    expect(plan.message).toMatch(/perseverancia/i);
  });
});

describe('Onboarding adaptativo', () => {
  it('la fecha exacta va solo a identidad; la base de salud recibe el año', () => {
    const p = toOnboardingPayload(complete);
    expect(p.identity.birthDate).toBe('1990-03-10');
    expect(p.profile.birthYear).toBe(1990);
    expect(JSON.stringify(p.profile)).not.toContain('1990-03-10');
  });

  it('un "sí" en el tamizaje exige aval antes de la alta intensidad', () => {
    const d = { ...complete, readinessScreen: { chestPain: true } };
    expect(toOnboardingPayload(d).clinical.requiresMedicalClearance).toBe(true);
    expect(previewDayOnePlan({ ...d, perceivedStress: 2, sleepHoursNight: 8 }, 'p', TODAY).blockedIntensities).toContain('HIGH');
  });

  it('la lesión de rodilla bloquea desde el día 1 las misiones que cargan la rodilla', () => {
    const plan = previewDayOnePlan({ ...complete, perceivedStress: 2, sleepHoursNight: 8 }, 'p', TODAY);
    for (const m of plan.missions) expect(m.template.loadedPatterns).not.toContain('DEEP_SQUAT');
  });

  it('la orientación es obligatoria en el capítulo de lore y adapta la bitácora', () => {
    expect(validateStep('lore', { ...complete, spiritualOrientation: undefined }, TODAY).errors.spiritualOrientation).toBeDefined();
    const plan = previewDayOnePlan(complete, 'p', TODAY);
    expect(plan.missions.find((m) => m.slot === 'LORE')!.prompt!.code.startsWith('MI_')).toBe(true);
  });
});
