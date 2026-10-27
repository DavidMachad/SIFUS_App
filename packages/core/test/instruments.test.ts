import { describe, expect, it } from 'vitest';
import {
  applyCapacityXp,
  bmi,
  emptySkillState,
  estimateOneRm,
  evaluateMilestones,
  InstrumentValidationError,
  isakFinalValue,
  levelForXp,
  rankViaStrengths,
  scoreFms,
  scoreGhq12,
  scoreMspss,
  scorePss10,
  scoreWhoqolSrpb,
  technicalErrorOfMeasurement,
  VIA_STRENGTHS,
  waistHeightRatio,
  type FmsPatternInput,
  type FmsPattern,
} from '../src';

const items = (n: number, value: number | ((i: number) => number)) =>
  Object.fromEntries(Array.from({ length: n }, (_, k) => [k + 1, typeof value === 'function' ? value(k + 1) : value]));

describe('PSS-10', () => {
  it('invierte los ítems 4, 5, 7 y 8', () => {
    // Todo en 4: 6 ítems directos × 4 + 4 inversos × 0 = 24
    expect(scorePss10(items(10, 4)).totalScore).toBe(24);
    // Máximo estrés: directos 4, inversos 0 → 40
    expect(scorePss10(items(10, (i) => ([4, 5, 7, 8].includes(i) ? 0 : 4))).totalScore).toBe(40);
  });
  it('no puntúa con ítems faltantes', () => {
    const r = items(10, 2);
    delete r[3];
    expect(() => scorePss10(r)).toThrow(InstrumentValidationError);
  });
});

describe('GHQ-12', () => {
  it('reporta método GHQ (0-0-1-1) y Likert', () => {
    const r = scoreGhq12(items(12, (i) => (i <= 4 ? 2 : 1)));
    expect(r.totalScore).toBe(4);
    expect(r.subscaleScores?.likert).toBe(4 * 2 + 8 * 1);
    expect(r.aboveScreeningCutoff).toBe(true);
    expect(scoreGhq12(items(12, (i) => (i <= 4 ? 2 : 1)), 5).aboveScreeningCutoff).toBe(false);
  });
});

describe('MSPSS', () => {
  it('calcula las tres fuentes de apoyo con los ítems correctos', () => {
    // Familia (3,4,8,11) = 7; el resto = 1
    const r = scoreMspss(items(12, (i) => ([3, 4, 8, 11].includes(i) ? 7 : 1)));
    expect(r.subscaleScores).toEqual({ significantOther: 1, family: 7, friends: 1 });
    expect(r.totalScore).toBe(3);
    expect(r.band).toBe('MODERATE');
  });
});

describe('WHOQOL-SRPB', () => {
  it('facetas 4–20 y total como media de facetas, con ítems inversos declarados', () => {
    const facets = ['spiritualConnection', 'meaningAndPurpose', 'awe', 'wholeness', 'spiritualStrength', 'innerPeace', 'hope', 'faith'] as const;
    const responses = Object.fromEntries(facets.map((f) => [f, [5, 5, 5, 5]])) as never;
    expect(scoreWhoqolSrpb(responses).totalScore).toBe(20);
    const r = scoreWhoqolSrpb(responses, { hope: [0] });
    expect(r.subscaleScores!.hope).toBe(16);
  });
});

describe('VIA', () => {
  it('ordena las 24 fortalezas con desempate estable', () => {
    const scores = Object.fromEntries(VIA_STRENGTHS.map((s) => [s, 3])) as Record<(typeof VIA_STRENGTHS)[number], number>;
    scores.HOPE = 4.8;
    scores.KINDNESS = 4.5;
    const ranked = rankViaStrengths(scores);
    expect(ranked).toHaveLength(24);
    expect(ranked.slice(0, 3).map((r) => r.strength)).toEqual(['HOPE', 'KINDNESS', 'CREATIVITY']);
  });
});

describe('FMS', () => {
  const all = (score: number): Record<FmsPattern, FmsPatternInput> => ({
    DEEP_SQUAT: { single: score },
    HURDLE_STEP: { left: score, right: score },
    INLINE_LUNGE: { left: score, right: score },
    SHOULDER_MOBILITY: { left: score, right: score },
    ACTIVE_STRAIGHT_LEG_RAISE: { left: score, right: score },
    TRUNK_STABILITY_PUSH_UP: { single: score },
    ROTARY_STABILITY: { left: score, right: score },
  });

  it('total 0–21 usando el lado más bajo y detectando asimetrías', () => {
    const input = all(3);
    input.HURDLE_STEP = { left: 3, right: 1 };
    const r = scoreFms(input);
    expect(r.totalScore).toBe(19);
    expect(r.asymmetricPatterns).toEqual(['HURDLE_STEP']);
    expect(r.priorityPatterns).toEqual(['HURDLE_STEP']);
  });

  it('dolor en la prueba de despeje lleva el patrón a 0', () => {
    const input = all(2);
    input.SHOULDER_MOBILITY = { left: 2, right: 2, clearingTestPain: true };
    const r = scoreFms(input);
    expect(r.totalScore).toBe(12);
    expect(r.painfulPatterns).toEqual(['SHOULDER_MOBILITY']);
  });

  it('rechaza despeje en un patrón que no lo tiene', () => {
    const input = all(2);
    input.DEEP_SQUAT = { single: 2, clearingTestPain: true };
    expect(() => scoreFms(input)).toThrow(InstrumentValidationError);
  });
});

describe('Fuerza y antropometría', () => {
  it('Brzycki y Epley; 5RM y advertencia sobre 10 repeticiones', () => {
    expect(estimateOneRm(100, 5, 'BRZYCKI').estimated1RmKg).toBe(112.5);
    expect(estimateOneRm(100, 5, 'EPLEY').estimated1RmKg).toBe(116.7);
    expect(estimateOneRm(80, 1).formula).toBe('NONE');
    expect(estimateOneRm(50, 12).lowConfidence).toBe(true);
  });

  it('IMC, cintura/estatura y valor final ISAK', () => {
    expect(bmi(70, 175)).toBe(22.86);
    expect(waistHeightRatio(80, 160)).toBe(0.5);
    expect(isakFinalValue([80.1, 80.5])).toBe(80.3);
    expect(isakFinalValue([80.1, 81.2, 80.4])).toBe(80.4);
  });

  it('error técnico de medida', () => {
    const { tem } = technicalErrorOfMeasurement([[80, 81], [70, 70], [90, 89]]);
    expect(tem).toBeCloseTo(Math.sqrt(2 / 6), 3);
  });
});

describe('Árbol de habilidades', () => {
  it('la XP solo suma y produce subidas de nivel', () => {
    expect(levelForXp(0)).toBe(1);
    expect(levelForXp(50)).toBe(2);
    const { state, levelUps } = applyCapacityXp(emptySkillState(), { MOBILITY: 60, STRENGTH: 10 });
    expect(state.MOBILITY.level).toBe(2);
    expect(levelUps).toEqual([{ capacity: 'MOBILITY', from: 1, to: 2 }]);
  });

  it('un hito evaluado exige superar el MDC en la dirección de mejora', () => {
    const m = evaluateMilestones([
      { measureCode: 'GRIP_DOMINANT_KG', capacity: 'STRENGTH', baseline: 30, current: 34, direction: 1, mdc: 3 },
      { measureCode: 'SIT_REACH_FOOTLINE_CM', capacity: 'MOBILITY', baseline: 2, current: 3, direction: 1, mdc: 2.5 },
      { measureCode: 'FMS_TOTAL', capacity: 'MOBILITY', baseline: 12, current: 16, direction: 1 }, // sin MDC calibrado
    ]);
    expect(m.map((x) => x.measureCode)).toEqual(['GRIP_DOMINANT_KG']);
  });
});
