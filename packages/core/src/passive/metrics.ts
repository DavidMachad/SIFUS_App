/**
 * Métricas pasivas canónicas. Cada plataforma se traduce a este vocabulario
 * ANTES de guardar, sin mezclar constructos distintos:
 *  - Apple Health entrega HRV como SDNN; Health Connect como RMSSD. No son
 *    intercambiables: se guardan como métricas distintas y la línea de base
 *    personal se calcula por separado para cada una.
 */
export type PassiveMetric =
  | 'HRV_RMSSD_MS'
  | 'HRV_SDNN_MS'
  | 'RESTING_HR_BPM'
  | 'STEPS'
  | 'SLEEP_ASLEEP_MIN'
  | 'SLEEP_DEEP_MIN'
  | 'SLEEP_REM_MIN'
  | 'SLEEP_AWAKE_MIN'
  | 'SLEEP_IN_BED_MIN';

export type PassivePlatform = 'APPLE_HEALTH' | 'HEALTH_CONNECT' | 'MANUAL_DEVICE';

export interface PlatformMapping {
  platform: PassivePlatform;
  sourceType: string;
  /** Para tipos categóricos (fases de sueño): valor de la plataforma. */
  sourceValue?: string;
  metric: PassiveMetric;
  unit: string;
}

/** Tabla de traducción plataforma → métrica canónica. */
export const PLATFORM_MAPPINGS: PlatformMapping[] = [
  { platform: 'APPLE_HEALTH', sourceType: 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN', metric: 'HRV_SDNN_MS', unit: 'ms' },
  { platform: 'APPLE_HEALTH', sourceType: 'HKQuantityTypeIdentifierRestingHeartRate', metric: 'RESTING_HR_BPM', unit: 'count/min' },
  { platform: 'APPLE_HEALTH', sourceType: 'HKQuantityTypeIdentifierStepCount', metric: 'STEPS', unit: 'count' },
  { platform: 'APPLE_HEALTH', sourceType: 'HKCategoryTypeIdentifierSleepAnalysis', sourceValue: 'asleepCore', metric: 'SLEEP_ASLEEP_MIN', unit: 'min' },
  { platform: 'APPLE_HEALTH', sourceType: 'HKCategoryTypeIdentifierSleepAnalysis', sourceValue: 'asleepUnspecified', metric: 'SLEEP_ASLEEP_MIN', unit: 'min' },
  { platform: 'APPLE_HEALTH', sourceType: 'HKCategoryTypeIdentifierSleepAnalysis', sourceValue: 'asleepDeep', metric: 'SLEEP_DEEP_MIN', unit: 'min' },
  { platform: 'APPLE_HEALTH', sourceType: 'HKCategoryTypeIdentifierSleepAnalysis', sourceValue: 'asleepREM', metric: 'SLEEP_REM_MIN', unit: 'min' },
  { platform: 'APPLE_HEALTH', sourceType: 'HKCategoryTypeIdentifierSleepAnalysis', sourceValue: 'awake', metric: 'SLEEP_AWAKE_MIN', unit: 'min' },
  { platform: 'APPLE_HEALTH', sourceType: 'HKCategoryTypeIdentifierSleepAnalysis', sourceValue: 'inBed', metric: 'SLEEP_IN_BED_MIN', unit: 'min' },
  { platform: 'HEALTH_CONNECT', sourceType: 'HeartRateVariabilityRmssdRecord', metric: 'HRV_RMSSD_MS', unit: 'ms' },
  { platform: 'HEALTH_CONNECT', sourceType: 'RestingHeartRateRecord', metric: 'RESTING_HR_BPM', unit: 'bpm' },
  { platform: 'HEALTH_CONNECT', sourceType: 'StepsRecord', metric: 'STEPS', unit: 'count' },
  { platform: 'HEALTH_CONNECT', sourceType: 'SleepSessionRecord', sourceValue: 'STAGE_TYPE_SLEEPING', metric: 'SLEEP_ASLEEP_MIN', unit: 'min' },
  { platform: 'HEALTH_CONNECT', sourceType: 'SleepSessionRecord', sourceValue: 'STAGE_TYPE_LIGHT', metric: 'SLEEP_ASLEEP_MIN', unit: 'min' },
  { platform: 'HEALTH_CONNECT', sourceType: 'SleepSessionRecord', sourceValue: 'STAGE_TYPE_DEEP', metric: 'SLEEP_DEEP_MIN', unit: 'min' },
  { platform: 'HEALTH_CONNECT', sourceType: 'SleepSessionRecord', sourceValue: 'STAGE_TYPE_REM', metric: 'SLEEP_REM_MIN', unit: 'min' },
  { platform: 'HEALTH_CONNECT', sourceType: 'SleepSessionRecord', sourceValue: 'STAGE_TYPE_AWAKE', metric: 'SLEEP_AWAKE_MIN', unit: 'min' },
];

export function mapPlatformSample(platform: PassivePlatform, sourceType: string, sourceValue?: string): PlatformMapping | undefined {
  return PLATFORM_MAPPINGS.find(
    (m) => m.platform === platform && m.sourceType === sourceType && (m.sourceValue === undefined || m.sourceValue === sourceValue),
  );
}

/** Rangos fisiológicamente plausibles: lo que cae fuera se descarta como artefacto. */
export const PLAUSIBLE_RANGES: Record<PassiveMetric, [number, number]> = {
  HRV_RMSSD_MS: [3, 300],
  HRV_SDNN_MS: [3, 300],
  RESTING_HR_BPM: [30, 120],
  STEPS: [0, 80_000],
  SLEEP_ASLEEP_MIN: [0, 16 * 60],
  SLEEP_DEEP_MIN: [0, 6 * 60],
  SLEEP_REM_MIN: [0, 6 * 60],
  SLEEP_AWAKE_MIN: [0, 12 * 60],
  SLEEP_IN_BED_MIN: [0, 18 * 60],
};

export const isPlausible = (metric: PassiveMetric, value: number) =>
  Number.isFinite(value) && value >= PLAUSIBLE_RANGES[metric][0] && value <= PLAUSIBLE_RANGES[metric][1];

/** Sueño total de una noche a partir de sus fases. */
export function totalSleepMinutes(byMetric: Partial<Record<PassiveMetric, number>>): number | undefined {
  const parts = [byMetric.SLEEP_ASLEEP_MIN, byMetric.SLEEP_DEEP_MIN, byMetric.SLEEP_REM_MIN];
  if (parts.every((p) => p === undefined)) return undefined;
  return parts.reduce<number>((s, p) => s + (p ?? 0), 0);
}
