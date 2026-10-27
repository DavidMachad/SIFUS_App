/**
 * Vinculación terminológica para interoperabilidad (LOINC / SNOMED CT).
 *
 * Política de verificación: un código equivocado en un informe clínico es peor
 * que no tener código. Por eso cada vínculo declara su estado:
 *  - VERIFIED: código del perfil FHIR R4 Vital Signs (de uso obligatorio y
 *    estable).
 *  - PENDING_VERIFICATION: código propuesto; el equipo debe confirmarlo en
 *    loinc.org / el navegador de SNOMED CT y registrar la fecha. Hasta entonces
 *    el exportador FHIR lo emite junto al código local, nunca solo.
 *  - Sin código estándar: se usa el sistema local SIFUS (siempre presente).
 * Varios instrumentos (WHO-5, PSS-10, FACIT-Sp…) pueden tener códigos de panel
 * en LOINC: deben buscarse y verificarse antes de publicarse.
 */
export const LOCAL_SYSTEM = 'https://sifus.udea.edu.co/fhir/CodeSystem/measures';
export const LOINC_SYSTEM = 'http://loinc.org';
export const SNOMED_SYSTEM = 'http://snomed.info/sct';

export type BindingStatus = 'VERIFIED' | 'PENDING_VERIFICATION';

export interface Coding {
  system: string;
  code: string;
  display: string;
  status?: BindingStatus;
}

export interface ClinicalMeasure {
  code: string; // código local (= dim_measure.measure_code)
  label: string; // nombre clínico en español, sin lenguaje de juego
  unit: string;
  ucum?: string;
  /** +1 mayor es mejor; −1 menor es mejor; 0 sin dirección normativa. */
  direction: -1 | 0 | 1;
  loinc?: Coding;
  snomed?: Coding;
  interpret?: (v: number) => string;
}

const L = (code: string, display: string, status: BindingStatus): Coding => ({ system: LOINC_SYSTEM, code, display, status });
const S = (code: string, display: string, status: BindingStatus): Coding => ({ system: SNOMED_SYSTEM, code, display, status });

export const CLINICAL_MEASURES: ClinicalMeasure[] = [
  { code: 'HEIGHT_CM', label: 'Estatura', unit: 'cm', ucum: 'cm', direction: 0, loinc: L('8302-2', 'Body height', 'VERIFIED'), snomed: S('50373000', 'Body height measure', 'PENDING_VERIFICATION') },
  { code: 'WEIGHT_KG', label: 'Masa corporal', unit: 'kg', ucum: 'kg', direction: 0, loinc: L('29463-7', 'Body weight', 'VERIFIED'), snomed: S('27113001', 'Body weight', 'PENDING_VERIFICATION') },
  { code: 'BMI', label: 'Índice de masa corporal', unit: 'kg/m²', ucum: 'kg/m2', direction: 0, loinc: L('39156-5', 'Body mass index (BMI) [Ratio]', 'VERIFIED') },
  { code: 'PERIM_WAIST', label: 'Perímetro de cintura', unit: 'cm', ucum: 'cm', direction: -1, loinc: L('8280-0', 'Waist Circumference at umbilicus by Tape measure', 'PENDING_VERIFICATION'), snomed: S('276361009', 'Waist circumference', 'PENDING_VERIFICATION') },
  { code: 'PERIM_HIP', label: 'Perímetro de cadera', unit: 'cm', ucum: 'cm', direction: 0 },
  { code: 'WAIST_HEIGHT_RATIO', label: 'Índice cintura/estatura', unit: 'razón', ucum: '1', direction: -1, interpret: (v) => (v >= 0.5 ? '≥ 0,5: marcador de riesgo cardiometabólico' : '< 0,5') },
  { code: 'GRIP_DOMINANT_KG', label: 'Fuerza de prensión manual, mano dominante', unit: 'kg', ucum: 'kg', direction: 1 },
  { code: 'SIT_REACH_FOOTLINE_CM', label: 'Flexibilidad (Wells & Dillon), relativa a la línea de los pies', unit: 'cm', ucum: 'cm', direction: 1 },
  { code: 'SQUAT_1RM_REL', label: 'Sentadilla profunda, 1RM estimado / masa corporal', unit: 'kg/kg', ucum: 'kg/kg', direction: 1 },
  { code: 'FMS_TOTAL', label: 'Functional Movement Screen, puntaje total', unit: 'puntos 0–21', ucum: '{score}', direction: 1 },
  { code: 'IPAQ_MET_MIN', label: 'Actividad física (IPAQ-SF)', unit: 'MET-min/semana', ucum: '{MET}.min/wk', direction: 1 },
  { code: 'STEPS_7D', label: 'Pasos diarios, media de 7 días', unit: 'pasos/día', ucum: '/d', direction: 1, loinc: L('55423-8', 'Number of steps in unspecified time Pedometer', 'PENDING_VERIFICATION') },
  { code: 'RESTING_HR_BPM', label: 'Frecuencia cardíaca en reposo', unit: 'lpm', ucum: '/min', direction: -1, loinc: L('40443-4', 'Heart rate --resting', 'PENDING_VERIFICATION') },
  { code: 'HRV_SDNN_MS', label: 'Variabilidad de la frecuencia cardíaca (SDNN)', unit: 'ms', ucum: 'ms', direction: 1, loinc: L('80404-7', 'R-R interval.standard deviation (Heart rate variability)', 'PENDING_VERIFICATION') },
  { code: 'HRV_RMSSD_MS', label: 'Variabilidad de la frecuencia cardíaca (RMSSD)', unit: 'ms', ucum: 'ms', direction: 1 },
  { code: 'SLEEP_HOURS_7D', label: 'Duración del sueño (sensor), media de 7 días', unit: 'h', ucum: 'h', direction: 0, loinc: L('93832-4', 'Sleep duration', 'PENDING_VERIFICATION') },
  { code: 'PSS10_TOTAL', label: 'Estrés percibido (PSS-10)', unit: 'puntos 0–40', ucum: '{score}', direction: -1, interpret: (v) => (v >= 27 ? 'Estrés percibido alto' : v >= 14 ? 'Estrés percibido moderado' : 'Estrés percibido bajo') },
  { code: 'GHQ12_GHQ', label: 'Salud general (GHQ-12, método GHQ)', unit: 'puntos 0–12', ucum: '{score}', direction: -1, interpret: (v) => (v >= 4 ? 'Por encima del punto de corte de tamizaje (≥ 4)' : 'Por debajo del punto de corte de tamizaje') },
  { code: 'WHO5_PCT', label: 'Bienestar (WHO-5)', unit: '% 0–100', ucum: '%', direction: 1, interpret: (v) => (v <= 28 ? '≤ 28: sugiere evaluación de depresión' : v <= 50 ? '≤ 50: bienestar bajo' : 'Bienestar adecuado') },
  { code: 'PSQI_GLOBAL', label: 'Calidad del sueño (PSQI)', unit: 'puntos 0–21', ucum: '{score}', direction: -1, interpret: (v) => (v > 5 ? '> 5: mala calidad de sueño' : 'Buena calidad de sueño') },
  { code: 'AIS_TOTAL', label: 'Insomnio (Escala Atenas)', unit: 'puntos 0–24', ucum: '{score}', direction: -1, interpret: (v) => (v >= 6 ? '≥ 6: sugiere insomnio' : 'Sin indicación de insomnio') },
  { code: 'MSPSS_TOTAL', label: 'Apoyo social percibido (MSPSS)', unit: 'media 1–7', ucum: '{score}', direction: 1, interpret: (v) => (v < 3 ? 'Apoyo bajo' : v <= 5 ? 'Apoyo moderado' : 'Apoyo alto') },
  { code: 'MEDAS_NORMALIZED', label: 'Adherencia a dieta mediterránea (MEDAS adaptado)', unit: '% del máximo', ucum: '%', direction: 1 },
  { code: 'FACIT_SP_TOTAL', label: 'Bienestar espiritual (FACIT-Sp)', unit: 'puntos', ucum: '{score}', direction: 1 },
  { code: 'PIL_TOTAL', label: 'Propósito en la vida (PIL)', unit: 'puntos 20–140', ucum: '{score}', direction: 1, interpret: (v) => (v < 90 ? '< 90: falta de sentido' : v <= 105 ? '90–105: zona indefinida' : '> 105: presencia de sentido') },
  { code: 'SWBS_TOTAL', label: 'Bienestar espiritual (SWBS)', unit: 'puntos 20–120', ucum: '{score}', direction: 1 },
];

export const measureByCode = (code: string) => CLINICAL_MEASURES.find((m) => m.code === code);
