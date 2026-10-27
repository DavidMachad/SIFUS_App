/**
 * Recursos de ayuda en crisis y rutas de derivación.
 *
 * ⚠️ VERIFICAR ANTES DE PRODUCCIÓN: los números y horarios cambian. El equipo
 * SIFUS debe confirmar cada línea con la Secretaría de Salud correspondiente
 * y registrar la fecha de verificación. Un recurso sin verificar se muestra
 * DESPUÉS de los verificados, nunca como único recurso.
 */
export interface CrisisResource {
  id: string;
  name: string;
  contact: string;
  kind: 'EMERGENCY' | 'MENTAL_HEALTH_LINE' | 'INSTITUTIONAL' | 'CARE_TEAM';
  scope: 'NATIONAL' | 'DEPARTMENT' | 'MUNICIPALITY' | 'INSTITUTION';
  /** Código DIVIPOLA cuando el alcance es local. */
  divipola?: string;
  available: string;
  verifiedOn: string | null;
}

export const CRISIS_RESOURCES_CO: CrisisResource[] = [
  { id: 'co-123', name: 'Línea de emergencias', contact: '123', kind: 'EMERGENCY', scope: 'NATIONAL', available: '24/7', verifiedOn: null },
  { id: 'co-192-4', name: 'Línea de salud mental (Ministerio de Salud)', contact: '192, opción 4', kind: 'MENTAL_HEALTH_LINE', scope: 'NATIONAL', available: '24/7', verifiedOn: null },
  { id: 'udea-bienestar', name: 'Bienestar Universitario UdeA — atención psicológica', contact: 'Configurar canal institucional', kind: 'INSTITUTIONAL', scope: 'INSTITUTION', available: 'Horario institucional', verifiedOn: null },
  { id: 'sifus-care-team', name: 'Tu facilitador/a SIFUS', contact: 'Mensaje dentro de la app', kind: 'CARE_TEAM', scope: 'INSTITUTION', available: 'Respuesta en ≤ 24 h hábiles', verifiedOn: null },
];

/** Emergencias primero; luego verificados; luego lo local antes de lo general. */
export function resourcesFor(divipola?: string, list: CrisisResource[] = CRISIS_RESOURCES_CO): CrisisResource[] {
  const scopeRank = { MUNICIPALITY: 0, DEPARTMENT: 1, INSTITUTION: 2, NATIONAL: 3 } as const;
  return list
    .filter((r) => !r.divipola || r.divipola === divipola || (r.scope === 'DEPARTMENT' && divipola?.startsWith(r.divipola)))
    .sort((a, b) =>
      Number(b.kind === 'EMERGENCY') - Number(a.kind === 'EMERGENCY') ||
      Number(Boolean(b.verifiedOn)) - Number(Boolean(a.verifiedOn)) ||
      scopeRank[a.scope] - scopeRank[b.scope],
    );
}
