import {
  buildDailyPlan,
  checkInFromAnamnesis,
  contextFromAnamnesis,
  journeyProgress,
  practiceCurve,
  pulseBars,
  type DailyPlan,
  type JourneyProgress,
  type PracticeCurve,
  type PulseBars,
  type RedFlagAssessment,
} from '@sifus/core';
import { safetyFor, type AppState, type DailyCheckIn } from './store';

/** Todo lo que el Inicio necesita, derivado del estado (sin React). */
export interface HomeModel {
  today: string;
  journey: JourneyProgress;
  bars: PulseBars;
  todayCheckIn: DailyCheckIn | null;
  plan: DailyPlan | null;
  safety: RedFlagAssessment;
  /** Curva de la práctica registrada más recientemente. */
  lastCurve: PracticeCurve | null;
}

export function homeModel(s: AppState, today: string): HomeModel {
  const safety = safetyFor(s, today);
  const todayCheckIn = s.checkIns.find((c) => c.date === today) ?? null;
  const last = [...s.practices].sort((a, b) => a.date.localeCompare(b.date)).at(-1);

  let plan: DailyPlan | null = null;
  if (s.player) {
    const a = s.player.anamnesis;
    const checkIn = todayCheckIn
      ? { date: today, sleepHours: todayCheckIn.sleepHours, perceivedStress: todayCheckIn.perceivedStress }
      : checkInFromAnamnesis(a, today);
    plan = buildDailyPlan(
      checkIn,
      contextFromAnamnesis(a, {
        userId: s.isDemo ? 'demo' : 'local',
        ageYears: Number(today.slice(0, 4)) - s.player.profile.birthYear,
        spiritualOrientation: s.player.profile.spiritualOrientation,
        equippedStrengths: s.player.strengths,
        requiresMedicalClearance: s.player.clinical.requiresMedicalClearance,
        redFlag: safety,
      }),
    );
  }

  return {
    today,
    journey: journeyProgress(s.practices, s.teachDeclared, s.serviceCount),
    bars: pulseBars(s.checkIns, today),
    todayCheckIn,
    plan,
    safety,
    lastCurve: last ? practiceCurve(last.practiceCode, s.practices) : null,
  };
}
