import { describe, expect, it } from 'vitest';
import { assessRedFlags, buildDailyPlan, canResumeGamification, resourcesFor, selectLorePrompt } from '../src';

describe('Protocolo de Banderas Rojas', () => {
  it('sin indicadores → juego completo', () => {
    const r = assessRedFlags({ ghq12: { ghqScore: 1, daysAgo: 3 }, who5: { pct: 72, daysAgo: 3 } });
    expect(r.level).toBe('NONE');
    expect(r.gamificationMode).toBe('FULL');
  });

  it('GHQ-12 sobre el corte de tamizaje → modo suave, sin pausa', () => {
    const r = assessRedFlags({ ghq12: { ghqScore: 5, daysAgo: 3 } });
    expect(r.level).toBe('WATCH');
    expect(r.gamificationMode).toBe('GENTLE');
  });

  it('distrés severo → pausa del juego, recursos y pregunta de seguridad', () => {
    const r = assessRedFlags({ ghq12: { ghqScore: 10, daysAgo: 1 } });
    expect(r.level).toBe('ELEVATED');
    expect(r.gamificationMode).toBe('PAUSED');
    expect(r.showCrisisResources).toBe(true);
    expect(r.requiresSafetyScreen).toBe(true);
  });

  it('PSS-10 alto solo es WATCH; combinado con distrés es ELEVATED', () => {
    expect(assessRedFlags({ pss10: { total: 30, daysAgo: 2 } }).level).toBe('WATCH');
    expect(assessRedFlags({ pss10: { total: 30, daysAgo: 2 }, who5: { pct: 44, daysAgo: 2 } }).level).toBe('ELEVATED');
  });

  it('cualquier respuesta positiva a la pregunta de seguridad o pedir ayuda → CRISIS', () => {
    expect(assessRedFlags({ safetyScreen: { selfHarmThoughts: 1, daysAgo: 0 } }).level).toBe('CRISIS');
    expect(assessRedFlags({ helpRequested: true }).level).toBe('CRISIS');
  });

  it('3 días seguidos de estrés extremo con ánimo muy bajo → ELEVATED', () => {
    const recentCheckIns = [0, 1, 2].map((d) => ({ daysAgo: d, perceivedStress: 10, mood: 1 }));
    expect(assessRedFlags({ recentCheckIns }).level).toBe('ELEVATED');
  });

  it('datos vencidos no disparan banderas', () => {
    expect(assessRedFlags({ ghq12: { ghqScore: 11, daysAgo: 90 } }).level).toBe('NONE');
  });

  it('la pausa no se levanta solo por el paso del tiempo', () => {
    expect(canResumeGamification({ openedDaysAgo: 30, professionalFollowUpRecorded: false, currentLevel: 'ELEVATED' })).toBe(false);
    expect(canResumeGamification({ openedDaysAgo: 8, professionalFollowUpRecorded: false, currentLevel: 'WATCH' })).toBe(true);
    expect(canResumeGamification({ openedDaysAgo: 1, professionalFollowUpRecorded: true, currentLevel: 'ELEVATED' })).toBe(true);
  });

  it('el plan en pausa no tiene XP, ni retos, ni gremio', () => {
    const redFlag = assessRedFlags({ ghq12: { ghqScore: 10, daysAgo: 1 } });
    const plan = buildDailyPlan(
      { date: '2026-10-27', sleepHours: 8, perceivedStress: 3, feelsIsolated: true },
      { userId: 'u', ageYears: 30, experience: 'ADVANCED', weeksInProgram: 20, avgSessionMinutes: 60, redFlag },
    );
    expect(plan.gamificationMode).toBe('PAUSED');
    expect(plan.band).toBe('RECOVERY');
    expect(plan.missions).toHaveLength(1);
    expect(plan.missions[0]!.xp).toBe(0);
    expect(plan.checkInXp).toBe(0);
    expect(plan.safetyFlags).toContain('WELLBEING_SUPPORT_OFFER');
  });

  it('recursos: emergencias primero', () => {
    expect(resourcesFor('05001')[0]!.contact).toBe('123');
  });
});

describe('Vulnerabilidad con datos pasivos y orientación espiritual', () => {
  const ctx = { userId: 'u', ageYears: 30, experience: 'INTERMEDIATE' as const, weeksInProgram: 10, avgSessionMinutes: 45 };
  const day = { date: '2026-10-27', sleepHours: 7.5, perceivedStress: 3 };

  it('HRV suprimida bloquea la alta intensidad aunque el autorreporte sea bueno', () => {
    const plan = buildDailyPlan(day, { ...ctx, passive: { hrvZ: -1.6 } });
    expect(plan.blockedIntensities).toContain('HIGH');
    expect(plan.reasonCodes).toContain('HRV_SUPPRESSED');
  });

  it('HRV baja + FC reposo alta + sueño corto del sensor → Recuperación con higiene del sueño o respiración', () => {
    const plan = buildDailyPlan(day, { ...ctx, passive: { hrvZ: -1.8, restingHrDeltaBpm: 7, sleepHours: 5.5 } });
    expect(plan.band).toBe('RECOVERY');
    const codes = plan.missions.map((m) => m.template.code);
    expect(codes.some((c) => ['REC_SLEEP_HYGIENE_15', 'MIND_BREATH_478_5', 'MIND_COHERENT_BREATH_8', 'REC_MINDFUL_WALK_20', 'REC_DAYLIGHT_WALK_20'].includes(c))).toBe(true);
  });

  it('una HRV alta no "borra" un autorreporte de estrés alto', () => {
    const plan = buildDailyPlan({ ...day, perceivedStress: 9 }, { ...ctx, passive: { hrvZ: 2 } });
    expect(plan.blockedIntensities).toContain('HIGH');
  });

  it('la orientación cambia el lenguaje de las misiones y de la bitácora, no el ejercicio', () => {
    const t = buildDailyPlan({ ...day, perceivedStress: 9, sleepHours: 5 }, { ...ctx, spiritualOrientation: 'THEOLOGICAL' });
    const s = buildDailyPlan({ ...day, perceivedStress: 9, sleepHours: 5 }, { ...ctx, spiritualOrientation: 'SECULAR_PURPOSE' });
    expect(t.missions.map((m) => m.template.code)).toEqual(s.missions.map((m) => m.template.code));
    expect(t.missions.find((m) => m.slot === 'LORE')!.prompt!.code).toBe('TH_GEN');
    expect(s.missions.find((m) => m.slot === 'LORE')!.prompt!.code).toBe('SE_GEN');
    expect(selectLorePrompt('NATURE', 'EXPANSION', true).code).toBe('NA_ACH');
  });
});

import { patternsBlockedByInjuries } from '../src';
describe('Lesiones del onboarding', () => {
  it('una lesión activa de rodilla bloquea sentadilla, zancada y paso de valla; una resuelta no', () => {
    expect(patternsBlockedByInjuries([{ region: 'KNEE', status: 'ACTIVE' }])).toEqual(['DEEP_SQUAT', 'HURDLE_STEP', 'INLINE_LUNGE']);
    expect(patternsBlockedByInjuries([{ region: 'KNEE', status: 'RESOLVED' }])).toEqual([]);
    expect(patternsBlockedByInjuries([{ region: 'SHOULDER', status: 'RECOVERING', currentPain: 4 }])).toContain('SHOULDER_MOBILITY');
  });
});
