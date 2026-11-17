import { describe, expect, it } from 'vitest';
import {
  AURORA_STATIONS,
  AuroraRecordError,
  journeyProgress,
  moodTo5,
  practiceCurve,
  pulseBars,
  stationLevel,
  validatePracticeRecord,
  type PracticeRecord,
} from '../src';

const rec = (date: string, code = 'S1_BREATH_4_6', before = 7, after = 4): PracticeRecord => ({ practiceCode: code, date, before, after });
const days = (n: number, code?: string) => Array.from({ length: n }, (_, i) => rec(`2026-11-${String(i + 1).padStart(2, '0')}`, code));
const s1 = AURORA_STATIONS[0]!;

describe('catálogo de Aurora', () => {
  it('8 estaciones en 3 partes, en el orden del libro', () => {
    expect(AURORA_STATIONS.map((s) => s.id)).toEqual([1, 2, 3, 4, 5, 6, 7, 8]);
    expect(AURORA_STATIONS.map((s) => s.part)).toEqual([1, 1, 1, 2, 2, 2, 3, 3]);
  });
  it('códigos de práctica únicos', () => {
    const codes = AURORA_STATIONS.flatMap((s) => s.practices.map((p) => p.code));
    expect(new Set(codes).size).toBe(codes.length);
  });
});

describe('registro de 1 a 10', () => {
  it('rechaza valores fuera de 1–10 y prácticas desconocidas', () => {
    expect(() => validatePracticeRecord(rec('2026-11-01', 'S1_BREATH_4_6', 0, 5))).toThrow(AuroraRecordError);
    expect(() => validatePracticeRecord(rec('2026-11-01', 'S1_BREATH_4_6', 5, 11))).toThrow(AuroraRecordError);
    expect(() => validatePracticeRecord(rec('2026-11-01', 'NOPE'))).toThrow(AuroraRecordError);
    expect(validatePracticeRecord(rec('2026-11-01'))).toBeTruthy();
  });
});

describe('niveles por estación', () => {
  it('sin registros → por descubrir; uno → Aprendiz', () => {
    expect(stationLevel(s1, [])).toBe('NONE');
    expect(stationLevel(s1, [rec('2026-11-01')])).toBe('APPRENTICE');
  });
  it('7 días distintos de una práctica → Practicante (no exige días seguidos)', () => {
    const scattered = ['01', '03', '05', '09', '15', '20', '28'].map((d) => rec(`2026-11-${d}`));
    expect(stationLevel(s1, scattered)).toBe('PRACTITIONER');
  });
  it('repetir el mismo día no cuenta como otro día', () => {
    expect(stationLevel(s1, Array.from({ length: 10 }, () => rec('2026-11-01')))).toBe('APPRENTICE');
  });
  it('Campeón exige ser Practicante además de declararlo', () => {
    expect(stationLevel(s1, [rec('2026-11-01')], true)).toBe('APPRENTICE');
    expect(stationLevel(s1, days(7), true)).toBe('CHAMPION');
  });
  it('nunca se retrocede: más registros (aunque sean peores) no bajan el nivel', () => {
    const bad = [...days(7), rec('2026-12-20', 'S1_BREATH_4_6', 3, 9)];
    expect(stationLevel(s1, bad)).toBe('PRACTITIONER');
  });
});

describe('progreso del viaje', () => {
  it('la estación actual es la primera que aún no llega a Practicante', () => {
    expect(journeyProgress([]).currentStation.id).toBe(1);
    expect(journeyProgress(days(7)).currentStation.id).toBe(2);
  });
  it('el equipo se desbloquea con la estación y se refina con el nivel', () => {
    const p = journeyProgress(days(7));
    expect(p.gear.map((g) => g.id)).toEqual(['AIR_THREAD']);
    expect(p.gear[0]!.refinement).toBe(2);
  });
  it('el halo de servicio solo aparece cuando se llevó una práctica a otra persona', () => {
    const r = [rec('2026-11-01', 'S8_VISIT_REALITY', 5, 7)];
    expect(journeyProgress(r).gear.some((g) => g.id === 'SERVICE_HALO')).toBe(false);
    expect(journeyProgress(r, [], 1).gear.some((g) => g.id === 'SERVICE_HALO')).toBe(true);
  });
  it('cuenta prácticas vividas, no registros', () => {
    expect(journeyProgress(days(5)).practicesLived).toBe(1);
  });
});

describe('curva personal', () => {
  it('tensión que baja tras la práctica se lee hacia lo deseado', () => {
    const c = practiceCurve('S1_BREATH_4_6', days(3));
    expect(c.meanChange).toBe(-3);
    expect(c.reading).toBe('TOWARD_BETTER');
  });
  it('medidas neutrales no se califican', () => {
    expect(practiceCurve('S6_LIFELINE', [rec('2026-11-01', 'S6_LIFELINE', 3, 8)]).reading).toBe('NEUTRAL');
  });
  it('sin registros no hay lectura', () => {
    expect(practiceCurve('S2_SUBTRACTION', []).reading).toBeNull();
  });
});

describe('barras de energía y ánimo', () => {
  it('media de los últimos 3 días en 0–100; nada si no hay registros recientes', () => {
    const b = pulseBars([
      { date: '2026-11-16', energy: 6, mood: 8 },
      { date: '2026-11-15', energy: 4, mood: 6 },
      { date: '2026-11-10', energy: 1, mood: 1 },
    ], '2026-11-16');
    expect(b).toEqual({ energy: 50, mood: 70, basis: 2 });
    expect(pulseBars([], '2026-11-16').energy).toBeNull();
  });
  it('conversión de ánimo a la escala 1–5 del protocolo de seguridad', () => {
    expect([1, 2, 3, 9, 10].map(moodTo5)).toEqual([1, 1, 2, 5, 5]);
  });
});
