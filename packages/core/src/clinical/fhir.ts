import { LOCAL_SYSTEM, measureByCode, type Coding } from './terminology';

/**
 * Exportación FHIR R4 (Observation) para interoperabilidad con historias
 * clínicas electrónicas (alineado con la Ley 2015 de 2020 de interoperabilidad
 * de la HCE en Colombia). El sujeto es una referencia seudónima: la
 * re-identificación ocurre solo en el sistema receptor autorizado.
 */
export interface FhirObservation {
  resourceType: 'Observation';
  status: 'final';
  category: { coding: Coding[] }[];
  code: { coding: Coding[]; text: string };
  subject: { reference: string };
  effectiveDateTime: string;
  valueQuantity: { value: number; unit: string; system: 'http://unitsofmeasure.org'; code: string };
}

const CATEGORY_SYSTEM = 'http://terminology.hl7.org/CodeSystem/observation-category';
const SURVEY_CODES = new Set(['PSS10_TOTAL', 'GHQ12_GHQ', 'WHO5_PCT', 'PSQI_GLOBAL', 'AIS_TOTAL', 'MSPSS_TOTAL', 'MEDAS_NORMALIZED', 'FACIT_SP_TOTAL', 'PIL_TOTAL', 'SWBS_TOTAL', 'IPAQ_MET_MIN']);
const VITAL_CODES = new Set(['HEIGHT_CM', 'WEIGHT_KG', 'BMI', 'RESTING_HR_BPM']);

export function toFhirObservation(subjectRef: string, measureCode: string, value: number, date: string): FhirObservation {
  const m = measureByCode(measureCode);
  if (!m) throw new Error(`Medida sin definición clínica: ${measureCode}`);
  const coding: Coding[] = [{ system: LOCAL_SYSTEM, code: m.code, display: m.label }];
  // Los códigos estándar viajan sin el campo interno "status".
  for (const c of [m.loinc, m.snomed]) if (c) coding.push({ system: c.system, code: c.code, display: c.display });
  const category = SURVEY_CODES.has(m.code) ? 'survey' : VITAL_CODES.has(m.code) ? 'vital-signs' : 'exam';
  return {
    resourceType: 'Observation',
    status: 'final',
    category: [{ coding: [{ system: CATEGORY_SYSTEM, code: category, display: category }] }],
    code: { coding, text: m.label },
    subject: { reference: subjectRef },
    effectiveDateTime: date,
    valueQuantity: { value, unit: m.unit, system: 'http://unitsofmeasure.org', code: m.ucum ?? '1' },
  };
}

export function toFhirBundle(subjectRef: string, rows: { measureCode: string; value: number; date: string }[]) {
  return {
    resourceType: 'Bundle' as const,
    type: 'collection' as const,
    entry: rows.map((r) => ({ resource: toFhirObservation(subjectRef, r.measureCode, r.value, r.date) })),
  };
}
