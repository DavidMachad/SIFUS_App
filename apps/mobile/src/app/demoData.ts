import type { PracticeRecord } from '@sifus/core';
import type { OnboardingPayload } from '../features/onboarding/state/payload';
import { initialState, type AppState, type DailyCheckIn } from './store';

/**
 * Personaje y registros SINTÉTICOS para recorrer la app sin llenar el
 * onboarding. No representan a ninguna persona real.
 */
const shift = (today: string, n: number) => new Date(Date.parse(today) - n * 86_400_000).toISOString().slice(0, 10);

export function demoState(today: string): AppState {
  const player: OnboardingPayload = {
    identity: { birthDate: '1998-04-12' },
    profile: {
      displayName: 'Ceiba',
      archetype: 'SAGE',
      birthYear: 1998,
      spiritualOrientation: 'MINDFULNESS',
      sexForReference: 'FEMALE',
      setting: 'EDUCATIONAL',
      purposeStatement: 'Estar bien para acompañar a mi familia.',
    },
    anamnesis: {
      phase: 'BASELINE',
      sleepHoursNight: 6.5,
      sleepQuality: 3,
      perceivedStress: 6,
      trainingExperience: 'BEGINNER',
      weeklyFrequency: 2,
      avgSessionMinutes: 30,
      preferredModalities: [],
      perceivedBarriers: [],
      smokingStatus: 'NEVER',
    },
    clinical: { requiresMedicalClearance: false, readinessScreen: {}, injuries: [] },
    bodyAssessment: null,
    strengths: [],
    pendingSideQuests: ['BODY_COMPOSITION'],
  };

  // 8 días de respiración 4-6 (→ Practicante en la estación 1), 2 de percepción.
  const tension = [8, 7, 8, 6, 7, 6, 5, 6, 5, 5];
  const practices: PracticeRecord[] = [
    ...[11, 10, 9, 7, 6, 4, 2, 1].map((d, i) => ({
      practiceCode: 'S1_BREATH_4_6', date: shift(today, d), before: tension[i]!, after: Math.max(1, tension[i]! - 3 + (i % 2)),
    })),
    { practiceCode: 'S2_FIRST_TIME_SENSES', date: shift(today, 3), before: 4, after: 7 },
    { practiceCode: 'S2_FIRST_TIME_SENSES', date: shift(today, 1), before: 5, after: 7 },
  ];

  // Registro diario de los últimos 6 días (hoy queda por hacer).
  const checkIns: DailyCheckIn[] = [6, 5, 4, 3, 2, 1].map((d, i) => ({
    date: shift(today, d),
    sleepHours: [6, 7, 5.5, 7, 6.5, 7.5][i]!,
    perceivedStress: [6, 5, 7, 5, 4, 4][i]!,
    energy: [5, 6, 4, 6, 7, 7][i]!,
    mood: [6, 6, 5, 7, 7, 8][i]!,
  }));

  return { ...initialState, player, practices, checkIns, isDemo: true };
}
