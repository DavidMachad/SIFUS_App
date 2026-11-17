import {
  assessRedFlags,
  moodTo5,
  validatePracticeRecord,
  type DailyPulse,
  type PracticeRecord,
  type RedFlagAssessment,
} from '@sifus/core';
import type { OnboardingPayload } from '../features/onboarding/state/payload';

/**
 * Estado local de la app (modo demo). Lógica pura: el reducer no toca React
 * ni almacenamiento, para poder probarlo.
 */
export interface DailyCheckIn extends DailyPulse {
  sleepHours: number;
  /** 1–10. */
  perceivedStress: number;
}

export interface AppState {
  version: 1;
  player: OnboardingPayload | null;
  checkIns: DailyCheckIn[];
  practices: PracticeRecord[];
  /** Estaciones en las que la persona declaró «ya puedo enseñarla». */
  teachDeclared: number[];
  /** Veces que llevó una práctica a otra persona (halo de servicio). */
  serviceCount: number;
  helpRequested: boolean;
  /** true si el estado proviene de los datos de ejemplo. */
  isDemo: boolean;
}

export const initialState: AppState = {
  version: 1,
  player: null,
  checkIns: [],
  practices: [],
  teachDeclared: [],
  serviceCount: 0,
  helpRequested: false,
  isDemo: false,
};

export type Action =
  | { type: 'createPlayer'; player: OnboardingPayload }
  | { type: 'checkIn'; entry: DailyCheckIn }
  | { type: 'recordPractice'; record: PracticeRecord }
  | { type: 'declareTeach'; stationId: number }
  | { type: 'shareService' }
  | { type: 'requestHelp' }
  | { type: 'closeHelp' }
  | { type: 'load'; state: AppState }
  | { type: 'reset' };

export function reducer(s: AppState, a: Action): AppState {
  switch (a.type) {
    case 'createPlayer':
      return { ...s, player: a.player, isDemo: false };
    case 'checkIn':
      // Un registro por día: el nuevo reemplaza al del mismo día.
      return { ...s, checkIns: [...s.checkIns.filter((c) => c.date !== a.entry.date), a.entry] };
    case 'recordPractice':
      return { ...s, practices: [...s.practices, validatePracticeRecord(a.record)] };
    case 'declareTeach':
      return s.teachDeclared.includes(a.stationId) ? s : { ...s, teachDeclared: [...s.teachDeclared, a.stationId] };
    case 'shareService':
      return { ...s, serviceCount: s.serviceCount + 1 };
    case 'requestHelp':
      return { ...s, helpRequested: true };
    case 'closeHelp':
      return { ...s, helpRequested: false };
    case 'load':
      return a.state;
    case 'reset':
      return initialState;
  }
}

export const todayIso = (d = new Date()) => {
  const local = new Date(d.getTime() - d.getTimezoneOffset() * 60_000);
  return local.toISOString().slice(0, 10);
};

const daysAgo = (date: string, today: string) => Math.round((Date.parse(today) - Date.parse(date)) / 86_400_000);

/** Protocolo de Banderas Rojas con lo que la app sabe localmente. */
export function safetyFor(s: AppState, today: string): RedFlagAssessment {
  return assessRedFlags({
    helpRequested: s.helpRequested,
    recentCheckIns: s.checkIns
      .map((c) => ({ daysAgo: daysAgo(c.date, today), perceivedStress: c.perceivedStress, mood: moodTo5(c.mood) }))
      .filter((c) => c.daysAgo >= 0 && c.daysAgo <= 14),
  });
}

// --- Persistencia (solo web; en el teléfono queda en memoria hasta añadir almacenamiento seguro) ---

const KEY = 'sifus.demo.state.v1';

export function loadState(): AppState | null {
  try {
    const raw = globalThis.localStorage?.getItem(KEY);
    if (!raw) return null;
    const parsed = JSON.parse(raw) as AppState;
    return parsed?.version === 1 ? parsed : null;
  } catch {
    return null;
  }
}

export function saveState(s: AppState): void {
  try {
    globalThis.localStorage?.setItem(KEY, JSON.stringify(s));
  } catch {
    /* almacenamiento bloqueado: la app sigue funcionando en memoria */
  }
}
