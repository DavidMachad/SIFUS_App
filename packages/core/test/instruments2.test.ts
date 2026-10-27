import { describe, expect, it } from 'vitest';
import {
  InstrumentValidationError,
  scoreAis,
  scoreFacitSp,
  scoreIpaqShort,
  scoreMedas,
  scorePanas,
  scorePil,
  scorePsqi,
  scoreSwbs,
  scoreWho5,
} from '../src';

const items = (n: number, v: number | ((i: number) => number)) =>
  Object.fromEntries(Array.from({ length: n }, (_, k) => [k + 1, typeof v === 'function' ? v(k + 1) : v]));

describe('WHO-5', () => {
  it('bruto × 4 y bandas de tamizaje', () => {
    expect(scoreWho5(items(5, 5)).totalScore).toBe(100);
    expect(scoreWho5(items(5, 1)).band).toBe('LIKELY_DEPRESSION'); // 20
    expect(scoreWho5(items(5, (i) => (i <= 2 ? 3 : 2))).band).toBe('LOW_WELLBEING'); // 12 → 48
    expect(scoreWho5(items(5, 3)).band).toBe('ADEQUATE'); // 60
  });
});

describe('I-PANAS-SF (Micro-PANAS)', () => {
  it('PA, NA y balance', () => {
    const r = scorePanas({ active: 4, determined: 4, attentive: 3, inspired: 3, alert: 4, upset: 1, hostile: 1, ashamed: 1, nervous: 2, afraid: 1 });
    expect(r.subscaleScores).toEqual({ positiveAffect: 18, negativeAffect: 6 });
    expect(r.totalScore).toBe(12);
  });
});

describe('IPAQ-SF', () => {
  it('MET-min con truncado a 180 min y episodios < 10 min = 0', () => {
    const r = scoreIpaqShort({ vigorousDays: 0, vigorousMinutesPerDay: 0, moderateDays: 2, moderateMinutesPerDay: 200, walkingDays: 7, walkingMinutesPerDay: 5 });
    expect(r.totalScore).toBe(4 * 180 * 2); // la caminata (< 10 min) no cuenta
  });
  it('categorías oficiales', () => {
    expect(scoreIpaqShort({ vigorousDays: 3, vigorousMinutesPerDay: 70, moderateDays: 0, moderateMinutesPerDay: 0, walkingDays: 0, walkingMinutesPerDay: 0 }).category).toBe('HIGH'); // 1680
    expect(scoreIpaqShort({ vigorousDays: 0, vigorousMinutesPerDay: 0, moderateDays: 0, moderateMinutesPerDay: 0, walkingDays: 5, walkingMinutesPerDay: 30 }).category).toBe('MODERATE');
    expect(scoreIpaqShort({ vigorousDays: 0, vigorousMinutesPerDay: 0, moderateDays: 0, moderateMinutesPerDay: 0, walkingDays: 2, walkingMinutesPerDay: 20 }).category).toBe('LOW');
  });
});

describe('PSQI', () => {
  const base = {
    bedtime: '23:00', sleepLatencyMinutes: 10, wakeTime: '07:00', hoursSlept: 7.5,
    disturbances: { a: 0, b: 0, c: 0, d: 0, e: 0, f: 0, g: 0, h: 0, i: 0 },
    subjectiveQuality: 0, sleepMedication: 0, daytimeSleepiness: 0, daytimeEnthusiasm: 0,
  };
  it('buen dormidor → 0; cruza la medianoche correctamente', () => {
    const r = scorePsqi(base);
    expect(r.totalScore).toBe(0);
    expect(r.subscaleScores!.efficiencyPct).toBe(93.8);
  });
  it('mal dormidor > 5', () => {
    const r = scorePsqi({ ...base, sleepLatencyMinutes: 45, hoursSlept: 5.5, subjectiveQuality: 2, disturbances: { ...base.disturbances, a: 2, b: 2, c: 1 }, daytimeSleepiness: 2 });
    // C1=2, C2: 2+2=4→2, C3: 5.5→2, C4: 5.5/8=69%→2, C5: 3→1, C6=0, C7: 2→1
    expect(r.totalScore).toBe(10);
    expect(r.poorSleep).toBe(true);
  });
});

describe('AIS, MEDAS, PIL', () => {
  it('AIS corte ≥ 6', () => expect(scoreAis(items(8, (i) => (i <= 6 ? 1 : 0))).suggestsInsomnia).toBe(true));
  it('MEDAS excluye el ítem del vino por defecto', () => {
    const all = Object.fromEntries(Array.from({ length: 14 }, (_, k) => [k + 1, true]));
    const r = scoreMedas(all);
    expect(r.totalScore).toBe(13);
    expect(r.subscaleScores!.normalized).toBe(100);
    expect(scoreMedas(all, { excludeWineItem: false }).totalScore).toBe(14);
  });
  it('PIL bandas', () => {
    expect(scorePil(items(20, 4)).band).toBe('LACK_OF_MEANING'); // 80
    expect(scorePil(items(20, 6)).band).toBe('MEANING_PRESENT'); // 120
  });
});

describe('FACIT-Sp-12 y filtro de orientación', () => {
  it('invierte 4 y 8; Sp-8 para orientación secular', () => {
    const r = scoreFacitSp(items(12, (i) => ([4, 8].includes(i) ? 0 : 4)));
    expect(r.totalScore).toBe(48);
    const s = scoreFacitSp(items(8, (i) => ([4, 8].includes(i) ? 0 : 4)), { includeFaith: false });
    expect(s.version).toBe('FACIT-Sp-8');
    expect(s.totalScore).toBe(32);
    expect(s.subscaleScores!.faith).toBeNull();
  });
  it('prorrateo FACIT con > 50 % de ítems; rechaza con ≤ 50 %', () => {
    const r = items(12, 2);
    delete r[2];
    expect(scoreFacitSp(r).subscaleScores!.meaning).toBe(8); // (2+2+2)·4/3
    delete r[3];
    expect(() => scoreFacitSp(r)).toThrow(InstrumentValidationError);
  });
});

describe('SWBS', () => {
  it('ítems negativos invertidos; RWB impares, EWB pares', () => {
    const r = scoreSwbs(items(20, 6));
    // 9 invertidos (6→1) y 11 directos (6) = 9 + 66 = 75
    expect(r.totalScore).toBe(75);
    expect(r.subscaleScores!.religious + r.subscaleScores!.existential).toBe(75);
  });
});
