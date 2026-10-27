import { describe, expect, it } from 'vitest';
import { computeWellbeingIndex } from '@sifus/core';
import { buildDashboardView } from '../dashboardModel';

const D = '2026-10-27';
const result = computeWellbeingIndex(
  [
    { key: 'WHO5_PCT', value: 24, measuredOn: D },
    { key: 'PSS10_TOTAL', value: 30, measuredOn: D },
    { key: 'STEPS_7D', value: 3000, measuredOn: D },
    { key: 'MEDAS_NORMALIZED', value: 40, measuredOn: D },
  ],
  { date: D, ageYears: 30 },
);

describe('Panel del avatar', () => {
  it('índice bajo = "recargando" (azul), nunca un estado de pérdida', () => {
    const v = buildDashboardView(result, 'FULL');
    expect(v.bar.tone).toBe('RECHARGING');
    expect(v.bar.caption).toMatch(/recargando/);
    expect(v.showStreaks).toBe(true);
  });

  it('sin datos suficientes no muestra número y propone primero lo rápido', () => {
    const v = buildDashboardView(computeWellbeingIndex([], { date: D, ageYears: 30 }), 'FULL');
    expect(v.bar.value).toBeNull();
    expect(v.bar.tone).toBe('DISCOVERING');
    expect(v.quests[0]!.kind).toBe('DAILY');
    expect(v.quests.every((q) => q.kind !== 'EVALUATOR')).toBe(true);
  });

  it('modo GENTLE: sin rachas ni comparaciones', () => {
    const v = buildDashboardView(result, 'GENTLE');
    expect(v.showStreaks).toBe(false);
    expect(v.bar.caption).toMatch(/a tu ritmo/);
  });

  it('modo PAUSED: barra oculta, sin pedir evaluaciones, ayuda siempre visible', () => {
    const v = buildDashboardView(result, 'PAUSED');
    expect(v.mode).toBe('SUPPORT');
    expect(v.bar.visible).toBe(false);
    expect(v.quests).toEqual([]);
    expect(v.showHelpButton).toBe(true);
  });
});
