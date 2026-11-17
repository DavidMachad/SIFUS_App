import { describe, expect, it } from 'vitest';
import { demoState } from '../demoData';
import { homeModel } from '../selectors';
import { initialState, reducer, safetyFor } from '../store';

const T = '2026-11-16';

describe('estado de la app', () => {
  it('sin personaje el inicio igual funciona: estación 1, sin plan', () => {
    const m = homeModel(initialState, T);
    expect(m.journey.currentStation.id).toBe(1);
    expect(m.plan).toBeNull();
    expect(m.bars.energy).toBeNull();
  });

  it('un registro por día: el nuevo reemplaza al del mismo día', () => {
    const e = { date: T, sleepHours: 7, perceivedStress: 4, energy: 6, mood: 7 };
    const s = reducer(reducer(initialState, { type: 'checkIn', entry: e }), { type: 'checkIn', entry: { ...e, energy: 3 } });
    expect(s.checkIns).toHaveLength(1);
    expect(s.checkIns[0]!.energy).toBe(3);
  });

  it('rechaza registros de práctica fuera de 1–10', () => {
    expect(() => reducer(initialState, { type: 'recordPractice', record: { practiceCode: 'S1_BREATH_4_6', date: T, before: 0, after: 5 } })).toThrow();
  });

  it('datos de ejemplo: Practicante en respiración, equipo y plan del día', () => {
    const m = homeModel(demoState(T), T);
    expect(m.journey.stations[0]!.level).toBe('PRACTITIONER');
    expect(m.journey.currentStation.id).toBe(2);
    expect(m.journey.gear.map((g) => g.id)).toContain('AIR_THREAD');
    expect(m.plan?.missions.length).toBeGreaterThan(0);
    expect(m.bars.energy).not.toBeNull();
  });

  it('el botón de ayuda pausa el juego; ánimo muy bajo y estrés alto 3 días seguidos también', () => {
    expect(safetyFor(reducer(initialState, { type: 'requestHelp' }), T).gamificationMode).toBe('PAUSED');
    const hard = [0, 1, 2].map((d) => ({ date: `2026-11-${16 - d}`, sleepHours: 5, perceivedStress: 9, energy: 2, mood: 1 }));
    expect(safetyFor({ ...initialState, checkIns: hard }, T).gamificationMode).toBe('PAUSED');
  });
});
