import type { PassiveMetric as DbPassiveMetric, PrismaClient } from '@prisma/client';
import {
  isPlausible,
  mapPlatformSample,
  personalBaseline,
  totalSleepMinutes,
  zFromBaseline,
  type PassiveMetric,
  type PassivePlatform,
  type PlayerContext,
} from '@sifus/core';
import { requireConsent } from '../../shared/consent';
import { addDays, isoDay, toDate } from '../../shared/dates';

/** Resumen diario calculado EN EL DISPOSITIVO (las muestras crudas no se suben). */
export interface DeviceDailySummary {
  date: string;
  platform: PassivePlatform;
  sourceType: string;
  sourceValue?: string;
  value: number;
  sampleCount: number;
  deviceModel?: string;
}

const SUMMED: ReadonlySet<PassiveMetric> = new Set(['STEPS', 'SLEEP_ASLEEP_MIN', 'SLEEP_DEEP_MIN', 'SLEEP_REM_MIN', 'SLEEP_AWAKE_MIN', 'SLEEP_IN_BED_MIN']);

export class PassiveDataService {
  constructor(private readonly db: PrismaClient) {}

  /**
   * Ingesta desde Apple Health / Health Connect. Requiere consentimiento
   * explícito de datos pasivos. Descarta (y reporta) lo no mapeable o
   * fisiológicamente imposible en vez de guardarlo.
   */
  async ingest(userId: string, items: DeviceDailySummary[]) {
    await requireConsent(this.db, userId, 'allowsPassiveData');
    const rejected: { item: DeviceDailySummary; reason: string }[] = [];
    const acc = new Map<string, { date: string; metric: PassiveMetric; value: number; n: number; platform: PassivePlatform; deviceModel?: string }>();

    for (const it of items) {
      const map = mapPlatformSample(it.platform, it.sourceType, it.sourceValue);
      if (!map) { rejected.push({ item: it, reason: 'TIPO_NO_SOPORTADO' }); continue; }
      if (!isPlausible(map.metric, it.value)) { rejected.push({ item: it, reason: 'FUERA_DE_RANGO_FISIOLOGICO' }); continue; }
      const key = `${it.date}|${map.metric}`;
      const prev = acc.get(key);
      if (!prev) { acc.set(key, { date: it.date, metric: map.metric, value: it.value, n: it.sampleCount, platform: it.platform, deviceModel: it.deviceModel }); continue; }
      // Fases que mapean a la misma métrica se suman; HRV/FC se promedian ponderando por muestras.
      if (SUMMED.has(map.metric)) prev.value += it.value;
      else prev.value = (prev.value * prev.n + it.value * it.sampleCount) / (prev.n + it.sampleCount);
      prev.n += it.sampleCount;
    }

    for (const r of acc.values()) {
      const data = { value: Math.round(r.value * 100) / 100, sampleCount: r.n, platform: r.platform, deviceModel: r.deviceModel ?? null, syncedAt: new Date() };
      await this.db.passiveDailySummary.upsert({
        where: { userId_date_metric: { userId, date: toDate(r.date), metric: r.metric as DbPassiveMetric } },
        create: { userId, date: toDate(r.date), metric: r.metric as DbPassiveMetric, ...data },
        update: data,
      });
    }
    return { accepted: acc.size, rejected };
  }

  /** Serie diaria de una métrica en [from, to]. */
  async series(userId: string, metrics: PassiveMetric[], from: Date, to: Date) {
    const rows = await this.db.passiveDailySummary.findMany({
      where: { userId, metric: { in: metrics as DbPassiveMetric[] }, date: { gte: from, lte: to } },
      orderBy: { date: 'asc' },
    });
    return rows.map((r) => ({ date: isoDay(r.date), metric: r.metric as PassiveMetric, value: Number(r.value) }));
  }

  /**
   * Contexto pasivo para el algoritmo de vulnerabilidad: HRV y FC frente a la
   * línea de base personal (≥ 14 días) y sueño total de anoche.
   * Usa RMSSD si existe; si no, SDNN. Nunca mezcla ambos en una misma línea de base.
   */
  async readinessContext(userId: string, today: string): Promise<PlayerContext['passive']> {
    const t = toDate(today);
    const rows = await this.series(
      userId,
      ['HRV_RMSSD_MS', 'HRV_SDNN_MS', 'RESTING_HR_BPM', 'SLEEP_ASLEEP_MIN', 'SLEEP_DEEP_MIN', 'SLEEP_REM_MIN'],
      addDays(t, -28), t,
    );
    const of = (m: PassiveMetric) => rows.filter((r) => r.metric === m);
    const hrvMetric: PassiveMetric = of('HRV_RMSSD_MS').length >= of('HRV_SDNN_MS').length ? 'HRV_RMSSD_MS' : 'HRV_SDNN_MS';
    const out: NonNullable<PlayerContext['passive']> = {};

    const hrv = of(hrvMetric);
    const hrvToday = hrv.find((r) => r.date === today);
    const hrvBase = personalBaseline(hrv, today, { log: true });
    if (hrvToday && hrvBase) out.hrvZ = zFromBaseline(hrvToday.value, hrvBase) ?? undefined;

    const rhr = of('RESTING_HR_BPM');
    const rhrToday = rhr.find((r) => r.date === today);
    const rhrBase = personalBaseline(rhr, today);
    if (rhrToday && rhrBase) out.restingHrDeltaBpm = Math.round((rhrToday.value - rhrBase.mean) * 10) / 10;

    const night = Object.fromEntries(rows.filter((r) => r.date === today && r.metric.startsWith('SLEEP_')).map((r) => [r.metric, r.value]));
    const total = totalSleepMinutes(night);
    if (total !== undefined) out.sleepHours = Math.round((total / 60) * 10) / 10;

    return Object.keys(out).length ? out : undefined;
  }
}
