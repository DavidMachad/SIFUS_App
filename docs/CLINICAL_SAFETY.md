# Rigor clínico y Protocolo de Banderas Rojas

## 1. Protocolo de Banderas Rojas

Código: `packages/core/src/safety/redFlags.ts` (lógica pura, versionada) y
`apps/api/src/modules/safety/redFlag.service.ts` (eventos, avisos, cierre).

| Nivel | Disparadores (v1.0.0, **provisionales**) | Juego | Acción |
|---|---|---|---|
| `NONE` | — | Completo | — |
| `WATCH` | GHQ-12 ≥ 4 · WHO-5 ≤ 50 · PSS-10 ≥ 27 sin otros indicadores | **Suave**: sin rachas ni comparaciones | Oferta de apoyo visible |
| `ELEVATED` | WHO-5 ≤ 28 · GHQ-12 ≥ 9 · PSS-10 ≥ 27 con distrés · 3 días seguidos con estrés ≥ 9 y ánimo 1/5 | **Pausado**: sin XP, barra ni metas | Recursos de ayuda, pregunta de seguridad y aviso al equipo de cuidado* |
| `CRISIS` | Cualquier respuesta ≥ 1 en la pregunta de seguridad · botón «Necesito ayuda ahora» | **Pausado** | Emergencias (123) primero y aviso inmediato al equipo* |

\* Solo si la persona autorizó `allowsCareTeamAlerts`. La notificación lleva
únicamente el id del evento y el nivel; los detalles se consultan dentro del
sistema.

**Principios:**
1. **Asimetría de seguridad.**
   - Un autorreporte de malestar nunca se descarta porque un sensor diga lo contrario.
   - La validación cruzada solo cuestiona los autorreportes *favorables* que el cuerpo no respalda.
2. **La pausa no expira sola.** Se levanta con:
   - el contacto profesional registrado, o
   - ≥ 7 días más una nueva evaluación por debajo de los umbrales (`canResumeGamification`).
3. **Límites del tamizaje.** GHQ-12, PSS-10 y WHO-5 no preguntan por ideación suicida. Por eso, en `ELEVATED`, se ofrece una pregunta de seguridad (tipo ítem 9 del PHQ-9), siempre con la opción «prefiero no responder».
4. **Nada de esto es diagnóstico.**

**Decisiones pendientes del componente clínico y del comité de ética:**
- [ ] Umbrales definitivos: el corte severo del GHQ-12 (no existe uno universal) y los cortes validados en Colombia.
- [ ] Redacción final de la pregunta de seguridad y su flujo de respuesta.
- [ ] Tiempo máximo hasta el primer contacto humano. Se mide en `analytics.v_safety_monitoring`; propuesta: ≤ 24 h hábiles para ELEVATED y ≤ 1 h para CRISIS.
- [ ] Verificar y fechar cada línea en `crisisResources.ts` (123; 192 opción 4; Bienestar UdeA).
- [ ] Ruta de derivación: EPS, IPS universitaria y línea departamental.

## 2. Validación cruzada y detección de sesgos

`packages/core/src/wellbeing/crossValidation.ts`.

| Detección | Regla | Efecto |
|---|---|---|
| Sueño autorreportado > sensor + 1,5 h | ≥ 3 de 7 días | Peso del autorreporte × 0,75 |
| Afecto muy favorable (balance PANAS ≥ 10, estrés ≤ 3) con tensión fisiológica (z de ln HRV ≤ −1,5 **y** FC en reposo ≥ +5 lpm) | ≥ 3 de 7 días | Peso × 0,75 (acumulable hasta un mínimo de 0,5) |
| Respuestas idénticas en un cuestionario con ítems invertidos | — | Bandera de calidad del dato |
| < 1,5 s por ítem | — | Bandera de calidad del dato |

Las banderas no restan XP ni se muestran como «trampa». La persona recibe una
invitación amable a revisar su descanso.

## 3. Índice de Vida Consolidado (0–100)

Construcción documentada en `packages/core/src/wellbeing/wellbeingIndex.ts`:
- **componentes:** cada uno normalizado a 0–100, con su ventana de vigencia;
- **atributos:** media ponderada de sus componentes, con cobertura mínima del 25 %;
- **índice:** media de los atributos, y solo se calcula con ≥ 3 de 5.

Desviaciones deliberadas de la especificación:
- El **Inventario VIA** no puntúa: describe un perfil de fortalezas, no un nivel de bienestar. Personaliza el lenguaje del juego.
- **JAREL y SWBS** son instrumentos con licencia. SWBS está implementado con los ítems inversos marcados «verificar contra el manual»; JAREL queda registrado como instrumento, pero sin puntuación hasta tener la licencia y el manual.
- **MEDAS** excluye el ítem de vino por defecto y requiere adaptación cultural para Colombia.
- **Prensión y 1RM** entran como percentil solo si hay una norma poblacional cargada. No se inventan anclas.

**Antes de usar el índice como desenlace de investigación, hay que validarlo en la cohorte:**
- consistencia interna entre atributos;
- validez convergente con el WHOQOL-BREF;
- sensibilidad al cambio y MDC del propio índice.

Por eso su versión es `-provisional`.

## 4. Exportación clínica e interoperabilidad

**PDF (`clinicalReportPdf.ts`):**
- puntajes brutos de la línea de base y actuales, cambio absoluto y porcentual (este último solo con base > 0);
- cambio estandarizado y percentiles frente a la norma citada;
- interpretación de tamizaje en lenguaje clínico.

Además:
- **Lenguaje clínico:** todo el texto pasa por `assertClinicalLanguage`; si aparece terminología de juego, el documento no se emite.
- **Clasificación del cambio:** «Mejoría» o «Empeoramiento» solo se usan cuando el cambio supera el MDC calibrado. Si no hay MDC, se reporta «Cambio favorable/desfavorable (MDC no calibrado)».

**FHIR R4 (`fhir.ts`):** recursos `Observation` con código local + LOINC/SNOMED CT, unidades UCUM y sujeto seudónimo.

**Terminología (`terminology.ts`):**
- solo los códigos del perfil FHIR Vital Signs están marcados `VERIFIED`;
- el resto son `PENDING_VERIFICATION` (marcados con * en el PDF);
- **antes de producción**, cada código debe confirmarse en loinc.org o en el navegador de SNOMED CT;
- también hay que buscar los códigos de panel LOINC de WHO-5, PSS-10, PSQI, etc.

**Auditoría:** cada exportación queda en `clinical_exports`, con el SHA-256 del documento. Si es identificada, también en `identity_access_log`.
