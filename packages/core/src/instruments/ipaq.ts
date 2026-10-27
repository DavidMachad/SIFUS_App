import { InstrumentValidationError, type ScoredInstrument } from './common';

/**
 * IPAQ versión corta, últimos 7 días (protocolo de puntuación IPAQ, 2005).
 *  - MET: caminata 3.3, moderada 4.0, vigorosa 8.0.
 *  - Limpieza: episodios < 10 min = 0; > 180 min/día se trunca a 180;
 *    se excluye el caso si caminata + moderada + vigorosa > 960 min/día.
 *  - Categorías: ALTA, MODERADA, BAJA según los criterios oficiales.
 * El tiempo sentado se reporta aparte (sedentarismo), no suma MET.
 */
export const IPAQ_SCORING_VERSION = 'ipaq-sf@1.0.0';

export interface IpaqInput {
  vigorousDays: number;
  vigorousMinutesPerDay: number;
  moderateDays: number;
  moderateMinutesPerDay: number;
  walkingDays: number;
  walkingMinutesPerDay: number;
  sittingMinutesPerDay?: number;
}

export type IpaqCategory = 'LOW' | 'MODERATE' | 'HIGH';

export interface IpaqResult extends ScoredInstrument<{ walkingMet: number; moderateMet: number; vigorousMet: number; sittingMinutesPerDay: number | null }> {
  /** MET-min/semana. */
  totalScore: number;
  category: IpaqCategory;
}

const clean = (min: number) => (min < 10 ? 0 : Math.min(min, 180));

export function scoreIpaqShort(i: IpaqInput): IpaqResult {
  for (const k of ['vigorousDays', 'moderateDays', 'walkingDays'] as const) {
    if (!Number.isInteger(i[k]) || i[k] < 0 || i[k] > 7) throw new InstrumentValidationError('IPAQ', `${k} = ${i[k]} fuera de [0, 7]`);
  }
  const vigMin = i.vigorousDays ? clean(i.vigorousMinutesPerDay) : 0;
  const modMin = i.moderateDays ? clean(i.moderateMinutesPerDay) : 0;
  const walkMin = i.walkingDays ? clean(i.walkingMinutesPerDay) : 0;
  if (i.vigorousMinutesPerDay + i.moderateMinutesPerDay + i.walkingMinutesPerDay > 960) {
    throw new InstrumentValidationError('IPAQ', 'más de 960 min/día de actividad: caso excluido por el protocolo');
  }
  const vigorousMet = 8.0 * vigMin * i.vigorousDays;
  const moderateMet = 4.0 * modMin * i.moderateDays;
  const walkingMet = 3.3 * walkMin * i.walkingDays;
  const total = Math.round(vigorousMet + moderateMet + walkingMet);

  const activeDays = Math.min(7, (vigMin ? i.vigorousDays : 0) + (modMin ? i.moderateDays : 0) + (walkMin ? i.walkingDays : 0));
  let category: IpaqCategory = 'LOW';
  if ((i.vigorousDays >= 3 && vigorousMet >= 1500) || (activeDays >= 7 && total >= 3000)) {
    category = 'HIGH';
  } else if (
    (i.vigorousDays >= 3 && vigMin >= 20) ||
    (modMin >= 30 ? i.moderateDays : 0) + (walkMin >= 30 ? i.walkingDays : 0) >= 5 ||
    (activeDays >= 5 && total >= 600)
  ) {
    category = 'MODERATE';
  }
  return {
    totalScore: total,
    category,
    subscaleScores: {
      walkingMet: Math.round(walkingMet),
      moderateMet: Math.round(moderateMet),
      vigorousMet: Math.round(vigorousMet),
      sittingMinutesPerDay: i.sittingMinutesPerDay ?? null,
    },
    scoringMethod: 'MET-min/semana (3.3/4.0/8.0), truncado 180 min, categorías IPAQ 2005',
    scoringVersion: IPAQ_SCORING_VERSION,
  };
}
