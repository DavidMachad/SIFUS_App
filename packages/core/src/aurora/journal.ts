import {
  AURORA_KNOWN_PRACTICES,
  AURORA_PRACTICES_IN_BOOK,
  AURORA_STATIONS,
  findPractice,
  type AuroraGear,
  type AuroraStation,
  type MeasureDirection,
} from './stations';

/**
 * El registro de 1 a 10 y lo que se construye con él (manifiesto §1 y §2,
 * «hito transversal»): niveles por estación, equipo, barras y curva personal.
 *
 * Todo se calcula desde el historial acumulado, así que por construcción
 * NUNCA se retrocede de nivel ni se pierde equipo («el invierno también es
 * parte del camino»).
 */
export const AURORA_JOURNAL_VERSION = 'aurora-journal@0.1.0-provisional';

export interface PracticeRecord {
  practiceCode: string;
  /** Fecha local ISO (YYYY-MM-DD). */
  date: string;
  /** 1–10 antes de la práctica. */
  before: number;
  /** 1–10 después de la práctica. */
  after: number;
}

/** Registro diario de 1 a 10 que alimenta las barras de energía y de ánimo. */
export interface DailyPulse {
  date: string;
  /** 1–10. */
  energy: number;
  /** 1–10. */
  mood: number;
}

export class AuroraRecordError extends Error {}

const isScore = (v: number) => Number.isInteger(v) && v >= 1 && v <= 10;

export function validatePracticeRecord(r: PracticeRecord): PracticeRecord {
  if (!findPractice(r.practiceCode)) throw new AuroraRecordError(`Práctica desconocida: ${r.practiceCode}`);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(r.date)) throw new AuroraRecordError('La fecha debe ser YYYY-MM-DD');
  if (!isScore(r.before) || !isScore(r.after)) throw new AuroraRecordError('El registro va de 1 a 10');
  return r;
}

// --- Niveles -------------------------------------------------------------------

export type StationLevel = 'NONE' | 'APPRENTICE' | 'PRACTITIONER' | 'CHAMPION';

export const STATION_LEVEL_LABELS: Record<StationLevel, string> = {
  NONE: 'Por descubrir',
  APPRENTICE: 'Aprendiz',
  PRACTITIONER: 'Practicante',
  CHAMPION: 'Campeón',
};

/** Días distintos con registro de una misma práctica para completar «la práctica de 7 días». */
export const PRACTITIONER_DAYS = 7;

const LEVEL_RANK: Record<StationLevel, number> = { NONE: 0, APPRENTICE: 1, PRACTITIONER: 2, CHAMPION: 3 };

/**
 * - Aprendiz: hizo el ejercicio al menos una vez.
 * - Practicante: registró una práctica de la estación en 7 días distintos.
 *   No se exige que sean consecutivos: una semana sin practicar no reinicia nada.
 * - Campeón: es Practicante y declaró que la práctica ya es parte de su vida y
 *   puede enseñarla (`teachDeclared`). Es autodeclarado, como en el libro.
 */
export function stationLevel(station: AuroraStation, records: PracticeRecord[], teachDeclared = false): StationLevel {
  const codes = new Set(station.practices.map((p) => p.code));
  const mine = records.filter((r) => codes.has(r.practiceCode));
  if (mine.length === 0) return 'NONE';
  const daysByPractice = new Map<string, Set<string>>();
  for (const r of mine) {
    const days = daysByPractice.get(r.practiceCode) ?? new Set<string>();
    days.add(r.date);
    daysByPractice.set(r.practiceCode, days);
  }
  const practitioner = [...daysByPractice.values()].some((d) => d.size >= PRACTITIONER_DAYS);
  if (!practitioner) return 'APPRENTICE';
  return teachDeclared ? 'CHAMPION' : 'PRACTITIONER';
}

export const atLeast = (level: StationLevel, min: StationLevel) => LEVEL_RANK[level] >= LEVEL_RANK[min];

// --- Progreso del viaje ----------------------------------------------------------

export interface StationProgress {
  station: AuroraStation;
  level: StationLevel;
  /** Días distintos registrados en la práctica más constante (hacia los 7). */
  bestPracticeDays: number;
  recordCount: number;
}

export interface UnlockedGear extends AuroraGear {
  stationId: number;
  /** La constancia lo refina: 1 Aprendiz, 2 Practicante, 3 Campeón. */
  refinement: 1 | 2 | 3;
}

export interface JourneyProgress {
  stations: StationProgress[];
  /** Primera estación (en orden del libro) que aún no llega a Practicante. */
  currentStation: AuroraStation;
  practicesLived: number;
  practicesKnown: number;
  practicesInBook: number;
  gear: UnlockedGear[];
  /** Personas a las que se llevó una práctica (halo de servicio). */
  serviceCount: number;
}

export function journeyProgress(
  records: PracticeRecord[],
  teachDeclared: number[] = [],
  serviceCount = 0,
): JourneyProgress {
  const stations = AURORA_STATIONS.map((station): StationProgress => {
    const codes = new Set(station.practices.map((p) => p.code));
    const mine = records.filter((r) => codes.has(r.practiceCode));
    const days = new Map<string, Set<string>>();
    for (const r of mine) days.set(r.practiceCode, (days.get(r.practiceCode) ?? new Set()).add(r.date));
    return {
      station,
      level: stationLevel(station, records, teachDeclared.includes(station.id)),
      bestPracticeDays: Math.max(0, ...[...days.values()].map((d) => d.size)),
      recordCount: mine.length,
    };
  });

  const current = stations.find((s) => !atLeast(s.level, 'PRACTITIONER')) ?? stations[stations.length - 1]!;
  const gear = stations.flatMap((s) =>
    s.level === 'NONE'
      ? []
      : s.station.gear
          // El halo solo aparece cuando de verdad se ha servido a alguien.
          .filter((g) => g.kind !== 'HALO' || serviceCount > 0)
          .map((g): UnlockedGear => ({ ...g, stationId: s.station.id, refinement: LEVEL_RANK[s.level] as 1 | 2 | 3 })),
  );

  return {
    stations,
    currentStation: current.station,
    practicesLived: new Set(records.map((r) => r.practiceCode)).size,
    practicesKnown: AURORA_KNOWN_PRACTICES,
    practicesInBook: AURORA_PRACTICES_IN_BOOK,
    gear,
    serviceCount,
  };
}

// --- Curva personal ---------------------------------------------------------------

export interface CurvePoint {
  date: string;
  before: number;
  after: number;
  /** after − before. */
  change: number;
}

export type ChangeReading = 'TOWARD_BETTER' | 'TOWARD_WORSE' | 'NO_CHANGE' | 'NEUTRAL';

export interface PracticeCurve {
  practiceCode: string;
  points: CurvePoint[];
  /** Media de (después − antes); null sin registros. */
  meanChange: number | null;
  /**
   * Lectura descriptiva del cambio medio según la dirección de la medida.
   * Es autorregistro de la persona, no una medida clínica: no se habla de "mejoría".
   */
  reading: ChangeReading | null;
}

export function readChange(change: number, direction: MeasureDirection): ChangeReading {
  if (direction === 'NEUTRAL') return 'NEUTRAL';
  if (Math.abs(change) < 0.5) return 'NO_CHANGE';
  const better = direction === 'LOWER_IS_BETTER' ? change < 0 : change > 0;
  return better ? 'TOWARD_BETTER' : 'TOWARD_WORSE';
}

export function practiceCurve(practiceCode: string, records: PracticeRecord[], lastN = 14): PracticeCurve {
  const found = findPractice(practiceCode);
  const points = records
    .filter((r) => r.practiceCode === practiceCode)
    .sort((a, b) => a.date.localeCompare(b.date))
    .slice(-lastN)
    .map((r) => ({ date: r.date, before: r.before, after: r.after, change: r.after - r.before }));
  if (points.length === 0 || !found) return { practiceCode, points, meanChange: null, reading: null };
  const meanChange = Math.round((points.reduce((s, p) => s + p.change, 0) / points.length) * 10) / 10;
  return { practiceCode, points, meanChange, reading: readChange(meanChange, found.practice.measure.direction) };
}

// --- Barras de energía y ánimo -------------------------------------------------------

export interface PulseBars {
  /** 0–100 o null si no hay registros recientes. */
  energy: number | null;
  mood: number | null;
  /** Registros usados (de los últimos `windowDays` días). */
  basis: number;
}

const daysBetween = (a: string, b: string) => Math.round((Date.parse(b) - Date.parse(a)) / 86_400_000);

/**
 * Barras = media de los registros 1–10 de los últimos 3 días, llevada a 0–100.
 * Bajan si el registro baja (mal sueño, estrés sostenido, mala alimentación se
 * reflejan en cómo la persona se califica), y suben en cuanto se recupera.
 * Provisional: la ventana y la escala deben validarse con el equipo.
 */
export function pulseBars(pulses: DailyPulse[], today: string, windowDays = 3): PulseBars {
  const recent = pulses.filter((p) => {
    const d = daysBetween(p.date, today);
    return d >= 0 && d < windowDays;
  });
  if (recent.length === 0) return { energy: null, mood: null, basis: 0 };
  const mean = (k: 'energy' | 'mood') => recent.reduce((s, p) => s + p[k], 0) / recent.length;
  // 1 → 10 %, 10 → 100 %: un registro de 1 nunca deja la barra "vacía".
  return { energy: Math.round(mean('energy') * 10), mood: Math.round(mean('mood') * 10), basis: recent.length };
}

/**
 * El Protocolo de Banderas Rojas usa ánimo en escala 1–5. Conversión provisional
 * desde 1–10 (1–2 → 1, 3–4 → 2 …), pendiente de aprobación clínica.
 */
export const moodTo5 = (mood10: number) => Math.min(5, Math.max(1, Math.ceil(mood10 / 2)));
