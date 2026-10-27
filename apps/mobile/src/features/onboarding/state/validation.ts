import { ageFromBirthDate, PERIMETER_SITES, type CharacterDraft, type PerimeterSite } from './characterDraft';

/**
 * Validación por paso. Dos niveles:
 *  - error:   impide avanzar (dato imposible o requerido para el algoritmo).
 *  - warning: dato posible pero inusual; se pide confirmar, nunca se juzga.
 * Los rangos plausibles coinciden con dim_measure.valid_min/valid_max del
 * esquema analítico, para que lo que la app acepta sea lo que la ciencia usa.
 */

export type StepId = 'identity' | 'rhythm' | 'journey' | 'history' | 'body' | 'lore' | 'summary';
export interface StepValidation {
  errors: Record<string, string>;
  warnings: Record<string, string>;
}

const PERIMETER_RANGES: Record<PerimeterSite, [number, number]> = {
  CHEST: [50, 200],
  ARM_RELAXED: [15, 70],
  ARM_FLEXED_TENSED: [15, 75],
  WAIST: [40, 200],
  HIP: [50, 200],
  THIGH_MID: [25, 110],
  CALF_MAX: [20, 70],
};

const outside = (v: number | undefined, min: number, max: number) => v !== undefined && (v < min || v > max);

export function validateStep(step: StepId, d: CharacterDraft, today = new Date()): StepValidation {
  const errors: Record<string, string> = {};
  const warnings: Record<string, string> = {};

  switch (step) {
    case 'identity': {
      if (d.displayName.trim().length < 2) errors.displayName = 'Tu personaje necesita un nombre (al menos 2 letras).';
      if (!d.archetype) errors.archetype = 'Elige el arquetipo con el que más te identificas hoy. Podrás cambiarlo.';
      if (!d.setting) errors.setting = '¿Dónde vives tu aventura? Nos ayuda a encontrar tu gremio.';
      if (!d.birthDate || !/^\d{4}-\d{2}-\d{2}$/.test(d.birthDate)) {
        errors.birthDate = 'Necesitamos tu fecha de nacimiento para adaptar las misiones a tu etapa de vida.';
      } else {
        const age = ageFromBirthDate(d.birthDate, today);
        if (age < 10 || age > 110) errors.birthDate = 'Revisa la fecha: parece fuera de rango.';
        else if (age < 18) warnings.birthDate = 'Como eres menor de edad, pediremos el consentimiento de tu acudiente.';
      }
      break;
    }
    case 'rhythm': {
      if (d.sleepHoursNight === undefined) errors.sleepHoursNight = 'Cuéntanos cuánto duermes: es clave para cuidar tu recuperación.';
      else if (outside(d.sleepHoursNight, 0, 16)) errors.sleepHoursNight = 'Ingresa un valor entre 0 y 16 horas.';
      else if (d.sleepHoursNight < 5) warnings.sleepHoursNight = 'Dormir poco es más común de lo que parece. Lo tendremos en cuenta para cuidarte.';
      if (d.perceivedStress === undefined) errors.perceivedStress = 'Elige un nivel de estrés del 1 al 10. No hay respuestas incorrectas.';
      if (outside(d.waterIntakeLiters, 0, 10)) errors.waterIntakeLiters = 'Ingresa un valor entre 0 y 10 litros.';
      break;
    }
    case 'journey': {
      if (!d.trainingExperience) errors.trainingExperience = 'Elige tu punto de partida; todos son válidos.';
      if (d.weeklyFrequency === undefined) errors.weeklyFrequency = '¿Cuántas veces a la semana te mueves hoy? Cero también es una respuesta válida.';
      else if (outside(d.weeklyFrequency, 0, 14)) errors.weeklyFrequency = 'Ingresa entre 0 y 14 sesiones.';
      if (d.avgSessionMinutes === undefined) errors.avgSessionMinutes = '¿Cuánto tiempo tienes por sesión? Ajustaremos las misiones a ese tiempo.';
      else if (outside(d.avgSessionMinutes, 5, 240)) errors.avgSessionMinutes = 'Ingresa entre 5 y 240 minutos.';
      break;
    }
    case 'history': {
      if (outside(d.sittingHoursPerDay, 0, 24)) errors.sittingHoursPerDay = 'Ingresa entre 0 y 24 horas.';
      d.injuries.forEach((inj, i) => {
        if (outside(inj.currentPain, 0, 10)) errors[`injury.${i}`] = 'El dolor va de 0 a 10.';
      });
      if (Object.values(d.readinessScreen).some(Boolean)) {
        warnings.readinessScreen = 'Gracias por contarnos. Podrás empezar con misiones suaves; para la alta intensidad pediremos el visto bueno de un profesional.';
      }
      break;
    }
    case 'body': {
      if (d.measurementMode === 'LATER') break; // se convierte en misión secundaria
      if (outside(d.heightCm, 100, 230)) errors.heightCm = 'La estatura va en centímetros (100–230).';
      if (outside(d.weightKg, 25, 300)) errors.weightKg = 'El peso va en kilogramos (25–300).';
      if (d.measurementMode === 'EVALUATOR') {
        if (d.heightCm === undefined) errors.heightCm = 'En la valoración presencial la estatura es obligatoria.';
        if (d.weightKg === undefined) errors.weightKg = 'En la valoración presencial el peso es obligatorio.';
      }
      for (const site of PERIMETER_SITES) {
        const trials = d.perimeterTrials[site] ?? [];
        const [min, max] = PERIMETER_RANGES[site];
        if (trials.some((t) => outside(t, min, max))) errors[`perimeter.${site}`] = `Valor fuera de rango (${min}–${max} cm).`;
        if (d.measurementMode === 'EVALUATOR' && trials.length === 1) {
          warnings[`perimeter.${site}`] = 'Protocolo ISAK: registra una segunda toma.';
        }
      }
      break;
    }
    case 'lore': {
      if (!d.spiritualOrientation) errors.spiritualOrientation = 'Elige lo que más te conecta; puedes cambiarlo cuando quieras.';
      if (d.purposeStatement && d.purposeStatement.length > 280) errors.purposeStatement = 'Máximo 280 caracteres: una frase que te acompañe.';
      break;
    }
    case 'summary':
      break;
  }
  return { errors, warnings };
}

export const canAdvance = (step: StepId, d: CharacterDraft) => Object.keys(validateStep(step, d).errors).length === 0;
