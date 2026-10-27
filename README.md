# SIFUS · Aplicación de bienestar integral gamificada

**Semillero de Investigación en Funcionalidad, Movimiento y Salud — Universidad de Antioquia**

> La salud es un estado de bienestar físico, mental, social y espiritual, no solo la ausencia de enfermedad.
> El sistema no penaliza la debilidad: usa la vulnerabilidad como punto de partida.

Este repositorio contiene la arquitectura de datos, los modelos de base de datos y el código base de la aplicación.
Cada decisión técnica sirve a la vez a dos públicos:
- **la persona que juega**, para que se sienta acompañada y no juzgada;
- **el equipo de salud pública**, que necesita datos auditables, reproducibles y seguros para generar evidencia.

Documentos complementarios:
- [`docs/SECURITY.md`](docs/SECURITY.md): privacidad, cifrado, HIPAA, RGPD y Ley 1581.
- [`docs/CLINICAL_SAFETY.md`](docs/CLINICAL_SAFETY.md): Protocolo de Banderas Rojas, validación cruzada, Índice de Vida y exportación clínica.

---

## 1. Mecánicas core → dónde viven en el código

| Mecánica | Lógica pura (`packages/core`) | Datos (`packages/db`) | Interfaz (`apps/mobile`) / servicio (`apps/api`) |
|---|---|---|---|
| **Creador de Personaje adaptativo** | `vulnerability/fromAnamnesis.ts`, `vulnerability/injuries.ts`, `spirituality/orientation.ts` | `Anamnesis`, `ClinicalHistory`, `InjuryRecord`, `PlayerProfile.spiritualOrientation` | `features/onboarding/` (7 capítulos) |
| **Avatar e Índice de Vida (0–100)** | `wellbeing/wellbeingIndex.ts` (5 atributos) | `WellbeingIndexSnapshot` | `features/dashboard/` · `WellbeingService` |
| **Mapeo de Vulnerabilidad Activa** | `vulnerability/readiness.ts`, `planner.ts` (estrés, sueño, fatiga, **HRV, FC en reposo, sueño pasivo**) | `DailyCheckIn`, `DailyPlan`, `PassiveDailySummary` | `DailyPlanService`, `PassiveDataService` |
| **Árbol de Habilidades Funcionales** | `skill-tree/progression.ts` | `SkillProgress`, `XpEvent` | — |
| **Gremios (MSPSS)** | `guilds/matching.ts`, `instruments/mspss.ts` | `Guild*`, `GuildMembership.matchSnapshot` | — |
| **Bitácora Espiritual (Lore)** | `spirituality/orientation.ts` (preguntas de logro, gratitud y pausa por orientación) | `LoreEntry` (contenido **cifrado**) | Espacio `LORE` del plan |
| **Protocolo de Banderas Rojas** | `safety/redFlags.ts`, `safety/crisisResources.ts` | `RedFlagEvent` | `features/safety/` · `RedFlagService` |
| **Validación cruzada / sesgos** | `wellbeing/crossValidation.ts` | `WellbeingIndexSnapshot.consistencyFlags` | `WellbeingService` |
| **Privacidad (PII ↔ UUID)** | — | `packages/identity-vault` (base separada) | `IdentityVaultService`, `security/fieldEncryption.ts` (AES-256-GCM) |
| **Exportación clínica** | `clinical/{norms,terminology,report,fhir}.ts` | `ReferenceNorm`, `ClinicalExport` | `ClinicalExportService` (PDF + FHIR R4) |

### Índice de Vida Consolidado: 5 atributos

| Atributo | Componentes que puntúan | Notas |
|---|---|---|
| 🧠 Mente & Emoción | WHO-5 · GHQ-12 (Likert) · Micro-PANAS (I-PANAS-SF, media 7 días) | El autorreporte diario se pondera según la validación cruzada |
| 💪 Cuerpo & Vitalidad | IPAQ-SF · pasos (sensor) · FMS · prensión (percentil) · 1RM relativo (percentil) · índice cintura/estatura | Prensión y 1RM solo cuentan con una norma cargada |
| 🌙 Restauración | PSQI · AIS · PSS-10 · HRV (z personal de 7 días) · sueño (sensor) | HRV: SDNN (Apple) y RMSSD (Health Connect) nunca se mezclan |
| 🥗 Estilo de Vida | MEDAS (ítem de vino excluido) | Requiere adaptación cultural para Colombia |
| ✨ Propósito & Espiritualidad | FACIT-Sp-12 (u -8 si la orientación es secular) · PIL · SWBS (total o existencial) | El VIA **personaliza** pero no puntúa; JAREL queda registrado sin puntuación (licencia) |

Reglas comunes:
- cada componente tiene una ventana de vigencia;
- sin datos suficientes **no hay número**: la app invita a descubrirlo;
- versión `wellbeing-index@1.0.0-provisional`, pendiente de validación psicométrica.

---

## 2. Estructura del proyecto

```
sifus-app/
├── packages/
│   ├── core/                          ← Lógica de dominio PURA (sin BD ni UI): fuente única de verdad
│   │   ├── src/instruments/           Puntuación versionada de 18 instrumentos:
│   │   │                              PSS-10 GHQ-12 MSPSS WHOQOL-SRPB VIA FMS 1RM antropometría
│   │   │                              WHO-5 I-PANAS-SF IPAQ-SF PSQI AIS MEDAS FACIT-Sp SWBS PIL
│   │   ├── src/vulnerability/         Mapeo de Vulnerabilidad Activa (+ datos pasivos, lesiones)
│   │   ├── src/wellbeing/             Índice de Vida 0–100 · validación cruzada antimanipulación
│   │   ├── src/safety/                Protocolo de Banderas Rojas · recursos de crisis
│   │   ├── src/spirituality/          Filtro de orientación · preguntas de la bitácora
│   │   ├── src/passive/               Apple Health / Health Connect → métricas canónicas · línea de base personal
│   │   ├── src/guilds/                Emparejamiento de gremios según el MSPSS
│   │   ├── src/clinical/              Normas y percentiles · LOINC/SNOMED CT · informe · FHIR R4
│   │   ├── src/skill-tree/            XP de práctica + hitos evaluados (MDC)
│   │   └── test/                      88 pruebas
│   ├── db/                            BASE DE SALUD (sin PII)
│   │   ├── prisma/schema.prisma       Esquema operacional con UUID
│   │   ├── sql/analytics/             Esquema en estrella + ETL + vistas de investigación y seguridad
│   │   └── sql/fixtures/              Cohorte SINTÉTICA
│   └── identity-vault/                BÓVEDA DE IDENTIDAD (PII cifrada, otra base de datos)
│
├── apps/
│   ├── mobile/                        React Native (Expo)
│   │   ├── src/features/onboarding/   Creador de Personaje (7 capítulos)
│   │   ├── src/features/dashboard/    Avatar + barra de vida + 5 atributos
│   │   └── src/features/safety/       Botón de ayuda · panel de apoyo · pregunta de seguridad
│   ├── api/
│   │   ├── src/security/              AES-256-GCM con cifrado de sobre · índice ciego
│   │   ├── src/modules/               daily-plan · passive · wellbeing · safety · identity · clinical-export
│   │   ├── assets/fonts/              DejaVu (Unicode en el PDF clínico)
│   │   └── test/                      Cifrado · PDF · integración contra PostgreSQL real
│   └── research-dashboard/            Consultas para salubristas (solo `analytics`)
└── docs/                              SECURITY.md · CLINICAL_SAFETY.md
```

**Escalabilidad hacia los paneles de investigación:**
- `@sifus/core` es reutilizable en la app (incluso sin conexión), la API, el ETL y los paneles.
- Tres zonas de datos con credenciales distintas:
  - identidad (PII);
  - salud (UUID);
  - `analytics` (`researchCode`, rol de solo lectura `sifus_researcher`).
- Un instrumento nuevo requiere tres cambios:
  - un archivo en `core/src/instruments`;
  - un valor en el enum `Instrument`;
  - filas en `dim_measure` y `map_questionnaire_measure`.

  Con eso, el ETL y las vistas lo recogen sin más cambios.

---

## 3. Modelo de datos

**Base de salud** (`packages/db/prisma/schema.prisma`, sin PII):

| Área | Modelos |
|---|---|
| Sujeto y consentimiento | `User` (UUID), `ResearchConsent` (investigación, datos pasivos, alertas al equipo, exportación clínica), `PlayerProfile` (año de nacimiento, orientación espiritual) |
| Anamnesis | `Anamnesis` (+ hábitos: tabaco, horas sentado, pantallas), `ClinicalHistory` (notas cifradas), `InjuryRecord`, `ProfileSideQuest`, `DailyCheckIn` |
| Tests | `Assessment` (fuente `EVALUATOR`/`SELF_REPORTED`), antropometría, perímetros, FMS, dinamometría, Wells & Dillon, 1RM/5RM, `QuestionnaireAdministration` (18 instrumentos + pregunta de seguridad), `ViaStrengthScore` |
| Juego | `MissionTemplate`, `DailyPlan` (versión + entradas), `DailyMission`, `SkillProgress`, `XpEvent`, `PlayerStrength`, `LoreEntry` (cifrada) |
| Comunidad | `Guild`, `GuildMembership` (+ emparejamiento MSPSS), `GuildQuest`, `GuildQuestContribution`, `GuildEncouragement` |
| eHealth | `PassiveDailySummary`, `WellbeingIndexSnapshot`, `RedFlagEvent`, `ReferenceNorm`, `ClinicalExport` |

**Bóveda de identidad** (`packages/identity-vault`):
- `Identity`: correo, nombre, documento, teléfono y fecha de nacimiento, todos cifrados; el correo y el documento con índices ciegos.
- `Guardian`: acudiente de participantes menores de edad.
- `IdentityAccessLog`: registro de cada acceso a la PII.

**Esquema en estrella** (`analytics`):

| Tipo | Tablas |
|---|---|
| Hechos | `fact_assessment_measure` (participante × fase × medida), `fact_daily_wellbeing`, `fact_mission_adherence`, `fact_lore_reflection`, `fact_guild_contribution`, `fact_passive_daily`, `fact_wellbeing_index`, `fact_red_flag_event` |
| Dimensiones | `dim_measure`, que incluye el atributo del índice y el código LOINC |

Vistas:
- `mv_phase_snapshot`: una fila por participante y fase que cruza antropometría, condición física, salud mental y espiritual, sensores, índice, adherencia y eventos de seguridad.
- `v_change_from_baseline`, `v_adherence_by_band` y `v_safety_monitoring` (para el comité de ética).

---

## 4. Algoritmo de Mapeo de Vulnerabilidad Activa (v1.0.0)

| Señal | Regla | Puntos |
|---|---|---|
| Sueño (autorreporte) | Déficit frente al mínimo del grupo de edad: > 2 h / > 1 h / > 0 h | 3 / 2 / 1 |
| Calidad del sueño | ≤ 2 de 5 | 1 |
| Estrés percibido 1–10 (premisa del cortisol) | ≥ 8 / ≥ 6 | 3 / 2 |
| Estrés + falta de sueño | Ambos presentes | +1 |
| PSS-10 reciente | ≥ 27 (≤ 45 días) | 1 |
| Fatiga mental / física | ≥ 8 / ≥ 6 | 2 / 1 |
| Ánimo | ≤ 2 de 5 | 1 |
| **HRV (sensor)** | z de ln(HRV) ≤ −1 frente a la línea de base de 28 días | 2 |
| **FC en reposo (sensor)** | ≥ +5 lpm sobre la media personal | 1 |
| **Sueño (sensor)** | Déficit > 1 h, solo si el autorreporte no lo marcó | 2 |

Rutas según el puntaje:
- **≥ 5 → Recuperación:** se bloquean la intensidad moderada y la alta; RPE ≤ 3.
- **2–4 → Equilibrio:** se bloquea la alta intensidad; RPE ≤ 6.
- **< 2 → Expansión.**

**Techos:**
- dolor;
- carga acumulada y retorno gradual;
- semanas de base para principiantes;
- aval médico pendiente;
- patrones FMS dolorosos o **lesiones activas**;
- **bandera roja** (la ruta pasa a Recuperación y el juego se pausa).

**Misiones de recuperación según la señal dominante:**
- estrés → respiración o meditación;
- sueño → higiene del sueño o luz natural;
- fatiga mental → caminata consciente o en la naturaleza;
- fisiología (HRV/FC) → respiración coherente;
- dolor → movilidad articular.

El lenguaje de las misiones y de la bitácora se adapta a la orientación espiritual; el ejercicio es el mismo.

---

## 5. Puesta en marcha

```bash
npm install
cp packages/db/.env.example packages/db/.env                       # DATABASE_URL
cp packages/identity-vault/.env.example packages/identity-vault/.env # IDENTITY_DATABASE_URL (otra base)
npm run db:migrate && npm run vault:migrate
npm run db:seed
npm run analytics:apply && npm run analytics:refresh
npm test && npm run typecheck
# Integración contra PostgreSQL real (ambas variables definidas):
npm run test:integration
```

---

## 6. Pendientes que requieren decisión del equipo SIFUS

1. **Umbrales clínicos:**
   - cortes del GHQ-12 (tamizaje y "severo"), PSS-10 y WHO-5 según la validación colombiana;
   - redacción de la pregunta de seguridad;
   - verificación de las líneas de crisis.

   Ver `docs/CLINICAL_SAFETY.md`.
2. **Terminología:** verificar los códigos LOINC y SNOMED CT marcados `PENDING_VERIFICATION` y buscar los códigos de panel de cada cuestionario.
3. **Normas poblacionales** de prensión y 1RM para los percentiles (`reference_norms`), preferiblemente colombianas.
4. **MDC por medida** con un test-retest propio (`v_measure_reliability`).
5. **Validación psicométrica** del Índice de Vida antes de usarlo como desenlace.
6. **Licencias:** VIA-IS, SWBS, JAREL, FACIT-Sp, PSQI; adaptación cultural del MEDAS.
7. **Comité de ética y cumplimiento normativo:**
   - consentimientos diferenciados;
   - registro de las bases ante la SIC;
   - KMS de producción.

   Ver `docs/SECURITY.md`.
