-- =============================================================================
-- SIFUS · Esquema analítico en estrella (schema "analytics")
--
-- Propósito: que el equipo de salud pública pueda cruzar, por participante y
-- fase (línea de base, mes 1, mes 2...), los cambios antropométricos y
-- condicionales con los indicadores de salud mental, social y espiritual, y
-- con la adherencia a las misiones.
--
-- Reglas de gobernanza:
--  * Solo entran participantes con consentimiento RESEARCH_DEIDENTIFIED vigente.
--  * La llave del participante es su research_code seudónimo; no hay email,
--    nombre ni texto libre (la Bitácora solo exporta tema y coherencia).
--  * Toda medida lleva unidad, dominio de salud y dirección de mejora, para que
--    los tableros no interpreten mal una disminución (p. ej. cintura o PSS-10).
--
-- Hechos (grano):
--   fact_assessment_measure  participante × fase × medida
--   fact_daily_wellbeing     participante × día (check-in + decisión del algoritmo)
--   fact_mission_adherence   misión asignada (participante × día × misión)
--   fact_lore_reflection     entrada de bitácora
--   fact_guild_contribution  aporte a una meta colectiva
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS analytics;
SET search_path = analytics;

-- -----------------------------------------------------------------------------
-- DIMENSIONES
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS dim_date (
  date_key      integer PRIMARY KEY,           -- yyyymmdd
  full_date     date    NOT NULL UNIQUE,
  year          smallint NOT NULL,
  quarter       smallint NOT NULL,
  month         smallint NOT NULL,
  iso_week      smallint NOT NULL,
  iso_dow       smallint NOT NULL,             -- 1 = lunes
  is_weekend    boolean NOT NULL,
  -- Semestre académico: útil en entornos educativos (periodos de exámenes = estrés).
  academic_term text NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_participant (
  participant_key       serial PRIMARY KEY,
  research_code         text NOT NULL UNIQUE,
  sex_for_reference     text NOT NULL,
  age_at_enrollment     smallint,
  age_group             text NOT NULL,         -- ADOLESCENT | ADULT | OLDER_ADULT
  setting               text NOT NULL,         -- EDUCATIONAL | WORKPLACE | COMMUNITY | HEALTHCARE
  municipality_code     text,                  -- DIVIPOLA
  baseline_experience   text,                  -- TrainingExperience en la línea de base
  spiritual_orientation text,                  -- filtro de propósito del onboarding
  avatar_archetype      text,
  enrollment_date       date,
  cohort                text,                  -- p. ej. "2026-08" (mes de ingreso)
  -- Tipo 1 en el MVP: se sobrescribe en cada refresco. Si el estudio requiere
  -- historial de cambios (p. ej. cambio de entorno), migrar a SCD tipo 2.
  loaded_at             timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS dim_phase (
  phase_key     smallint PRIMARY KEY,
  phase_code    text NOT NULL UNIQUE,
  phase_order   smallint NOT NULL,
  nominal_week  smallint NOT NULL,             -- semana teórica desde la línea de base
  label_es      text NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_instrument (
  instrument_key smallint PRIMARY KEY,
  code           text NOT NULL UNIQUE,
  name_es        text NOT NULL,
  health_domain  text NOT NULL CHECK (health_domain IN ('PHYSICAL','MENTAL','SOCIAL','SPIRITUAL','LIFESTYLE')),
  reference      text
);

CREATE TABLE IF NOT EXISTS dim_measure (
  measure_key           serial PRIMARY KEY,
  measure_code          text NOT NULL UNIQUE,
  instrument_key        smallint NOT NULL REFERENCES dim_instrument,
  name_es               text NOT NULL,
  unit                  text NOT NULL,
  -- +1: mayor es mejor (prensión, apoyo social) · -1: menor es mejor (PSS-10,
  -- GHQ-12) · 0: sin dirección normativa (peso, perímetros: depende del objetivo
  -- individual; se interpreta con el equipo y nunca se gamifica como "bajar").
  improvement_direction smallint NOT NULL CHECK (improvement_direction IN (-1, 0, 1)),
  capacity              text,                  -- FunctionalCapacity del árbol de habilidades, si aplica
  valid_min             numeric,
  valid_max             numeric,
  -- Cambio mínimo detectable (MDC95 = 1.96·√2·SEM). NULL hasta calibrarlo con
  -- el test-retest propio del equipo SIFUS; ver v_measure_reliability.
  mdc                   numeric,
  mdc_source            text,
  -- Atributo del Índice de Vida al que aporta (MIND, BODY, RESTORATION, LIFESTYLE, PURPOSE).
  wellbeing_domain      text,
  -- Terminología (ver @sifus/core/clinical/terminology.ts).
  loinc_code            text,
  loinc_status          text CHECK (loinc_status IN ('VERIFIED','PENDING_VERIFICATION'))
);

CREATE TABLE IF NOT EXISTS dim_mission (
  mission_key      serial PRIMARY KEY,
  code             text NOT NULL UNIQUE,
  title            text NOT NULL,
  category         text NOT NULL,
  intensity        text NOT NULL,
  duration_minutes smallint NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_readiness_band (
  band_key   smallint PRIMARY KEY,
  band_code  text NOT NULL UNIQUE,
  label_es   text NOT NULL,
  band_order smallint NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_guild (
  guild_key         serial PRIMARY KEY,
  source_id         text NOT NULL UNIQUE,
  guild_type        text NOT NULL,
  setting           text NOT NULL,
  municipality_code text
);

-- -----------------------------------------------------------------------------
-- HECHOS
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS fact_assessment_measure (
  participant_key integer  NOT NULL REFERENCES dim_participant,
  phase_key       smallint NOT NULL REFERENCES dim_phase,
  measure_key     integer  NOT NULL REFERENCES dim_measure,
  date_key        integer  NOT NULL REFERENCES dim_date,
  value           numeric  NOT NULL,
  is_valid        boolean  NOT NULL,           -- dentro del rango plausible y técnica válida
  protocol_version text,
  PRIMARY KEY (participant_key, phase_key, measure_key)
);

CREATE TABLE IF NOT EXISTS fact_daily_wellbeing (
  participant_key  integer  NOT NULL REFERENCES dim_participant,
  date_key         integer  NOT NULL REFERENCES dim_date,
  band_key         smallint REFERENCES dim_readiness_band,
  sleep_hours      numeric(3,1),
  sleep_quality    smallint,
  perceived_stress smallint,
  mental_fatigue   smallint,
  physical_fatigue smallint,
  pain_level       smallint,
  mood             smallint,
  feels_isolated   boolean,
  load_score       numeric(4,1),
  rpe_cap          smallint,
  reason_codes     text[],
  safety_flags     text[],
  algorithm_version text,
  PRIMARY KEY (participant_key, date_key)
);

CREATE TABLE IF NOT EXISTS fact_mission_adherence (
  daily_mission_id text PRIMARY KEY,            -- degenerate dimension
  participant_key  integer  NOT NULL REFERENCES dim_participant,
  date_key         integer  NOT NULL REFERENCES dim_date,
  mission_key      integer  NOT NULL REFERENCES dim_mission,
  band_key         smallint NOT NULL REFERENCES dim_readiness_band,
  slot             text     NOT NULL,
  assigned_count   smallint NOT NULL DEFAULT 1,
  completed_count  smallint NOT NULL,           -- COMPLETED o ADAPTED
  adapted_count    smallint NOT NULL,
  skipped_count    smallint NOT NULL,
  reported_rpe     smallint,
  actual_minutes   smallint,
  xp_awarded       integer  NOT NULL
);

CREATE TABLE IF NOT EXISTS fact_lore_reflection (
  lore_entry_id     text PRIMARY KEY,
  participant_key   integer  NOT NULL REFERENCES dim_participant,
  date_key          integer  NOT NULL REFERENCES dim_date,
  moment            text     NOT NULL,
  purpose_theme     text     NOT NULL,
  coherence_rating  smallint NOT NULL,
  strengths_used    text[]   NOT NULL,
  linked_to_mission boolean  NOT NULL
);

-- Grano: participante × día × métrica pasiva (solo con consentimiento de datos pasivos).
CREATE TABLE IF NOT EXISTS fact_passive_daily (
  participant_key integer NOT NULL REFERENCES dim_participant,
  date_key        integer NOT NULL REFERENCES dim_date,
  metric          text    NOT NULL,
  value           numeric NOT NULL,
  sample_count    integer NOT NULL,
  platform        text    NOT NULL,
  device_model    text,
  PRIMARY KEY (participant_key, date_key, metric)
);

-- Grano: participante × día. Índice de Vida y sus 5 atributos.
CREATE TABLE IF NOT EXISTS fact_wellbeing_index (
  participant_key         integer NOT NULL REFERENCES dim_participant,
  date_key                integer NOT NULL REFERENCES dim_date,
  wellbeing_index         smallint,           -- NULL = datos insuficientes
  mind_score              numeric(4,1),
  body_score              numeric(4,1),
  restoration_score       numeric(4,1),
  lifestyle_score         numeric(4,1),
  purpose_score           numeric(4,1),
  confidence              numeric(3,2),
  self_report_reliability numeric(3,2),
  consistency_flag_count  smallint,
  index_version           text,
  PRIMARY KEY (participant_key, date_key)
);

-- Monitoreo de seguridad (para el comité de ética / DSMB): sin texto clínico.
CREATE TABLE IF NOT EXISTS fact_red_flag_event (
  red_flag_event_id         text PRIMARY KEY,
  participant_key           integer NOT NULL REFERENCES dim_participant,
  date_key                  integer NOT NULL REFERENCES dim_date,
  level                     text    NOT NULL,
  triggers                  text[]  NOT NULL,
  hours_to_professional_contact numeric,
  resolved                  boolean NOT NULL,
  protocol_version          text
);

CREATE TABLE IF NOT EXISTS fact_guild_contribution (
  contribution_id text PRIMARY KEY,
  participant_key integer NOT NULL REFERENCES dim_participant,
  guild_key       integer NOT NULL REFERENCES dim_guild,
  date_key        integer NOT NULL REFERENCES dim_date,
  metric          text    NOT NULL,
  value           integer NOT NULL
);

CREATE INDEX IF NOT EXISTS ix_fam_measure ON fact_assessment_measure (measure_key, phase_key);
CREATE INDEX IF NOT EXISTS ix_fdw_date ON fact_daily_wellbeing (date_key);
CREATE INDEX IF NOT EXISTS ix_fma_participant_date ON fact_mission_adherence (participant_key, date_key);
CREATE INDEX IF NOT EXISTS ix_flr_participant_date ON fact_lore_reflection (participant_key, date_key);

-- -----------------------------------------------------------------------------
-- DATOS SEMILLA DE DIMENSIONES ESTÁTICAS
-- -----------------------------------------------------------------------------

INSERT INTO dim_date
SELECT to_char(d, 'YYYYMMDD')::int,
       d::date,
       extract(year FROM d), extract(quarter FROM d), extract(month FROM d),
       extract(week FROM d), extract(isodow FROM d), extract(isodow FROM d) IN (6, 7),
       extract(year FROM d) || CASE WHEN extract(month FROM d) <= 6 THEN '-1' ELSE '-2' END
FROM generate_series('2024-01-01'::date, '2032-12-31'::date, interval '1 day') AS d
ON CONFLICT DO NOTHING;

INSERT INTO dim_phase VALUES
  (1, 'BASELINE',  1,  0, 'Línea de base'),
  (2, 'MONTH_1',   2,  4, 'Mes 1'),
  (3, 'MONTH_2',   3,  8, 'Mes 2'),
  (4, 'MONTH_3',   4, 13, 'Mes 3'),
  (5, 'MONTH_6',   5, 26, 'Mes 6'),
  (6, 'FOLLOW_UP', 6, 52, 'Seguimiento')
ON CONFLICT DO NOTHING;

INSERT INTO dim_readiness_band VALUES
  (1, 'RECOVERY',  'Ruta de Recuperación', 1),
  (2, 'BALANCE',   'Ruta de Equilibrio',   2),
  (3, 'EXPANSION', 'Ruta de Expansión',    3)
ON CONFLICT DO NOTHING;

INSERT INTO dim_instrument VALUES
  (1,  'ANTHROPOMETRY', 'Valoración antropométrica',             'PHYSICAL',  'ISAK'),
  (2,  'PERIMETERS',    'Perímetros corporales',                 'PHYSICAL',  'ISAK'),
  (3,  'FMS',           'Functional Movement Screen',            'PHYSICAL',  'Cook, Burton & Hoogenboom 2006'),
  (4,  'DYNAMOMETRY',   'Dinamometría de prensión manual',       'PHYSICAL',  'Roberts et al. 2011 (protocolo Southampton)'),
  (5,  'WELLS_DILLON',  'Test de flexibilidad de Wells & Dillon','PHYSICAL',  'Wells & Dillon 1952'),
  (6,  'STRENGTH_RM',   'Fuerza máxima estimada (1RM/5RM)',      'PHYSICAL',  'Brzycki 1993; Epley 1985'),
  (7,  'PSS_10',        'Escala de Estrés Percibido',            'MENTAL',    'Cohen, Kamarck & Mermelstein 1983'),
  (8,  'GHQ_12',        'Cuestionario de Salud General',         'MENTAL',    'Goldberg & Williams 1988'),
  (9,  'MSPSS',         'Apoyo Social Percibido Multidimensional','SOCIAL',   'Zimet et al. 1988'),
  (10, 'WHOQOL_SRPB',   'WHOQOL Espiritualidad, Religiosidad y Creencias Personales', 'SPIRITUAL', 'WHOQOL SRPB Group 2006'),
  (11, 'VIA_IS',        'Inventario VIA de Fortalezas',          'SPIRITUAL', 'Peterson & Seligman 2004'),
  (12, 'PIL',           'Test de Propósito en la Vida',          'SPIRITUAL', 'Crumbaugh & Maholick 1964'),
  (13, 'WHO_5',         'Índice de Bienestar OMS-5',             'MENTAL',    'Topp et al. 2015'),
  (14, 'I_PANAS_SF',    'Afecto positivo y negativo (I-PANAS-SF)','MENTAL',   'Thompson 2007'),
  (15, 'IPAQ_SF',       'Cuestionario Internacional de Actividad Física (corto)', 'PHYSICAL', 'Craig et al. 2003'),
  (16, 'PSQI',          'Índice de Calidad de Sueño de Pittsburgh','MENTAL',  'Buysse et al. 1989'),
  (17, 'AIS',           'Escala Atenas de Insomnio',             'MENTAL',    'Soldatos et al. 2000'),
  (18, 'MEDAS',         'Adherencia a dieta mediterránea (adaptada)', 'LIFESTYLE', 'Schröder et al. 2011'),
  (19, 'FACIT_SP_12',   'Bienestar espiritual FACIT-Sp',         'SPIRITUAL', 'Peterman et al. 2002'),
  (20, 'SWBS',          'Escala de Bienestar Espiritual',        'SPIRITUAL', 'Paloutzian & Ellison 1982'),
  (21, 'PASSIVE',       'Sensores (Apple Health / Health Connect)', 'PHYSICAL', 'Agregado diario en dispositivo'),
  (22, 'WELLBEING_INDEX','Índice de Vida Consolidado (provisional)', 'MENTAL', 'SIFUS wellbeing-index@1.0.0-provisional')
ON CONFLICT DO NOTHING;

INSERT INTO dim_measure (measure_code, instrument_key, name_es, unit, improvement_direction, capacity, valid_min, valid_max) VALUES
  -- Antropometría: dirección 0 → la interpretación depende del objetivo de cada persona.
  ('HEIGHT_CM',          1, 'Estatura',                         'cm',    0, NULL, 100, 230),
  ('WEIGHT_KG',          1, 'Masa corporal',                    'kg',    0, NULL, 25, 300),
  ('BMI',                1, 'Índice de masa corporal',          'kg/m²', 0, NULL, 10, 80),
  ('BODY_FAT_PCT',       1, 'Masa grasa',                       '%',     0, NULL, 2, 70),
  ('WAIST_HIP_RATIO',    2, 'Índice cintura/cadera',            'ratio', -1, NULL, 0.5, 1.5),
  ('WAIST_HEIGHT_RATIO', 2, 'Índice cintura/estatura',          'ratio', -1, NULL, 0.3, 1.0),
  ('PERIM_CHEST',        2, 'Perímetro de pecho',               'cm',    0, NULL, 50, 200),
  ('PERIM_ARM_RELAXED',  2, 'Perímetro de brazo relajado',      'cm',    0, NULL, 15, 70),
  ('PERIM_ARM_FLEXED',   2, 'Perímetro de brazo contraído',     'cm',    1, 'STRENGTH', 15, 75),
  ('PERIM_WAIST',        2, 'Perímetro de cintura',             'cm',    -1, NULL, 40, 200),
  ('PERIM_HIP',          2, 'Perímetro de cadera',              'cm',    0, NULL, 50, 200),
  ('PERIM_THIGH',        2, 'Perímetro de muslo medio',         'cm',    0, NULL, 25, 110),
  ('PERIM_CALF',         2, 'Perímetro de pantorrilla',         'cm',    1, NULL, 20, 70),
  -- FMS
  ('FMS_TOTAL',          3, 'FMS puntaje total',                'pts 0–21', 1, 'MOBILITY', 0, 21),
  ('FMS_ASYMMETRY_COUNT',3, 'FMS número de asimetrías',         'n',     -1, 'COORDINATION', 0, 5),
  ('FMS_PAIN_COUNT',     3, 'FMS patrones con dolor',           'n',     -1, NULL, 0, 7),
  -- Dinamometría
  ('GRIP_DOMINANT_KG',   4, 'Prensión mano dominante (mejor)',  'kg',    1, 'STRENGTH', 2, 100),
  ('GRIP_NONDOMINANT_KG',4, 'Prensión mano no dominante (mejor)','kg',   1, 'STRENGTH', 2, 100),
  ('GRIP_RELATIVE',      4, 'Prensión dominante / masa corporal','kg/kg', 1, 'STRENGTH', 0.02, 1.5),
  -- Flexibilidad: normalizada respecto a la línea de los pies (0 = alcanza los pies).
  ('SIT_REACH_FOOTLINE_CM', 5, 'Wells & Dillon relativo a la línea de los pies', 'cm', 1, 'MOBILITY', -40, 40),
  -- Fuerza máxima
  ('SQUAT_1RM_KG',       6, 'Sentadilla profunda 1RM (estimado)','kg',   1, 'STRENGTH', 0, 400),
  ('SQUAT_1RM_REL',      6, 'Sentadilla 1RM / masa corporal',   'kg/kg', 1, 'STRENGTH', 0, 4),
  ('BENCH_1RM_KG',       6, 'Press de banca 1RM (estimado)',    'kg',    1, 'STRENGTH', 0, 300),
  ('BENCH_1RM_REL',      6, 'Press de banca 1RM / masa corporal','kg/kg',1, 'STRENGTH', 0, 3),
  -- Psicosociales y espirituales
  ('PSS10_TOTAL',        7, 'PSS-10 puntaje total',             'pts 0–40', -1, NULL, 0, 40),
  ('GHQ12_GHQ',          8, 'GHQ-12 (método GHQ 0-0-1-1)',      'pts 0–12', -1, NULL, 0, 12),
  ('GHQ12_LIKERT',       8, 'GHQ-12 (método Likert 0-3)',       'pts 0–36', -1, NULL, 0, 36),
  ('MSPSS_TOTAL',        9, 'MSPSS media total',                'media 1–7', 1, NULL, 1, 7),
  ('MSPSS_FAMILY',       9, 'MSPSS familia',                    'media 1–7', 1, NULL, 1, 7),
  ('MSPSS_FRIENDS',      9, 'MSPSS amigos',                     'media 1–7', 1, NULL, 1, 7),
  ('MSPSS_SIGNIFICANT_OTHER', 9, 'MSPSS otra persona significativa', 'media 1–7', 1, NULL, 1, 7),
  ('SRPB_TOTAL',         10, 'WHOQOL-SRPB media de facetas',    'pts 4–20', 1, NULL, 4, 20),
  ('SRPB_SPIRITUAL_CONNECTION', 10, 'SRPB conexión espiritual', 'pts 4–20', 1, NULL, 4, 20),
  ('SRPB_MEANING',       10, 'SRPB sentido y propósito',        'pts 4–20', 1, NULL, 4, 20),
  ('SRPB_AWE',           10, 'SRPB asombro',                    'pts 4–20', 1, NULL, 4, 20),
  ('SRPB_WHOLENESS',     10, 'SRPB integración',                'pts 4–20', 1, NULL, 4, 20),
  ('SRPB_SPIRITUAL_STRENGTH', 10, 'SRPB fortaleza espiritual',  'pts 4–20', 1, NULL, 4, 20),
  ('SRPB_INNER_PEACE',   10, 'SRPB paz interior',               'pts 4–20', 1, NULL, 4, 20),
  ('SRPB_HOPE',          10, 'SRPB esperanza y optimismo',      'pts 4–20', 1, NULL, 4, 20),
  ('SRPB_FAITH',         10, 'SRPB fe',                         'pts 4–20', 1, NULL, 4, 20),
  ('PIL_TOTAL',          12, 'Propósito en la vida total',      'pts 20–140', 1, NULL, 20, 140)
ON CONFLICT DO NOTHING;

INSERT INTO dim_measure (measure_code, instrument_key, name_es, unit, improvement_direction, capacity, valid_min, valid_max) VALUES
  ('WHO5_PCT',          13, 'WHO-5 bienestar',                 '% 0–100',   1, NULL, 0, 100),
  ('PANAS_PA',          14, 'Afecto positivo',                 'pts 5–25',  1, NULL, 5, 25),
  ('PANAS_NA',          14, 'Afecto negativo',                 'pts 5–25', -1, NULL, 5, 25),
  ('PANAS_BALANCE',     14, 'Balance afectivo (PA − NA)',      'pts −20–20', 1, NULL, -20, 20),
  ('IPAQ_MET_MIN',      15, 'Actividad física',                'MET-min/sem', 1, 'ENDURANCE', 0, 20000),
  ('IPAQ_SITTING_MIN',  15, 'Tiempo sentado',                  'min/día',  -1, NULL, 0, 1440),
  ('PSQI_GLOBAL',       16, 'PSQI global',                     'pts 0–21', -1, NULL, 0, 21),
  ('AIS_TOTAL',         17, 'Escala Atenas de Insomnio',       'pts 0–24', -1, NULL, 0, 24),
  ('MEDAS_NORMALIZED',  18, 'MEDAS normalizado',               '% 0–100',   1, NULL, 0, 100),
  ('FACIT_SP_TOTAL',    19, 'FACIT-Sp total',                  'pts',       1, NULL, 0, 48),
  ('FACIT_SP_MEANING',  19, 'FACIT-Sp significado',            'pts 0–16',  1, NULL, 0, 16),
  ('FACIT_SP_PEACE',    19, 'FACIT-Sp paz',                    'pts 0–16',  1, NULL, 0, 16),
  ('FACIT_SP_FAITH',    19, 'FACIT-Sp fe',                     'pts 0–16',  1, NULL, 0, 16),
  ('SWBS_TOTAL',        20, 'SWBS total',                      'pts 20–120', 1, NULL, 20, 120),
  ('SWBS_EXISTENTIAL',  20, 'SWBS bienestar existencial',      'pts 10–60', 1, NULL, 10, 60),
  ('STEPS_MEAN',        21, 'Pasos diarios (media del periodo)', 'pasos/día', 1, 'ENDURANCE', 0, 80000),
  ('RESTING_HR_MEAN',   21, 'FC en reposo (media del periodo)', 'lpm',     -1, NULL, 30, 120),
  ('SLEEP_HOURS_MEAN',  21, 'Sueño por sensor (media del periodo)', 'h',     0, NULL, 0, 16),
  ('WELLBEING_INDEX_MEAN', 22, 'Índice de Vida (media del periodo)', '0–100', 1, NULL, 0, 100)
ON CONFLICT DO NOTHING;

-- Atributo del Índice de Vida y terminología por medida.
UPDATE dim_measure SET wellbeing_domain = CASE
  WHEN measure_code IN ('WHO5_PCT','GHQ12_GHQ','GHQ12_LIKERT','PANAS_PA','PANAS_NA','PANAS_BALANCE') THEN 'MIND'
  WHEN measure_code IN ('IPAQ_MET_MIN','IPAQ_SITTING_MIN','FMS_TOTAL','GRIP_DOMINANT_KG','GRIP_RELATIVE','SQUAT_1RM_REL','BENCH_1RM_REL','WAIST_HEIGHT_RATIO','PERIM_WAIST','STEPS_MEAN') THEN 'BODY'
  WHEN measure_code IN ('PSQI_GLOBAL','AIS_TOTAL','PSS10_TOTAL','SLEEP_HOURS_MEAN','RESTING_HR_MEAN') THEN 'RESTORATION'
  WHEN measure_code IN ('MEDAS_NORMALIZED') THEN 'LIFESTYLE'
  WHEN measure_code LIKE 'FACIT_SP%' OR measure_code LIKE 'SWBS%' OR measure_code LIKE 'SRPB%' OR measure_code = 'PIL_TOTAL' THEN 'PURPOSE'
END;
UPDATE dim_measure m SET loinc_code = t.code, loinc_status = t.status
FROM (VALUES ('HEIGHT_CM','8302-2','VERIFIED'), ('WEIGHT_KG','29463-7','VERIFIED'), ('BMI','39156-5','VERIFIED'),
             ('PERIM_WAIST','8280-0','PENDING_VERIFICATION'), ('STEPS_MEAN','55423-8','PENDING_VERIFICATION'),
             ('RESTING_HR_MEAN','40443-4','PENDING_VERIFICATION'), ('SLEEP_HOURS_MEAN','93832-4','PENDING_VERIFICATION')) AS t(measure, code, status)
WHERE m.measure_code = t.measure;

-- Correspondencia instrumento → medida, usada por el ETL para los cuestionarios.
-- json_key NULL = totalScore; si no, la llave en subscaleScores.
CREATE TABLE IF NOT EXISTS map_questionnaire_measure (
  instrument   text NOT NULL,
  json_key     text,
  measure_code text NOT NULL REFERENCES dim_measure (measure_code),
  PRIMARY KEY (instrument, measure_code)
);
INSERT INTO map_questionnaire_measure VALUES
  ('PSS_10', NULL, 'PSS10_TOTAL'),
  ('GHQ_12', NULL, 'GHQ12_GHQ'), ('GHQ_12', 'likert', 'GHQ12_LIKERT'),
  ('MSPSS', NULL, 'MSPSS_TOTAL'), ('MSPSS', 'family', 'MSPSS_FAMILY'), ('MSPSS', 'friends', 'MSPSS_FRIENDS'),
  ('MSPSS', 'significantOther', 'MSPSS_SIGNIFICANT_OTHER'),
  ('WHOQOL_SRPB', NULL, 'SRPB_TOTAL'), ('WHOQOL_SRPB', 'spiritualConnection', 'SRPB_SPIRITUAL_CONNECTION'),
  ('WHOQOL_SRPB', 'meaningAndPurpose', 'SRPB_MEANING'), ('WHOQOL_SRPB', 'awe', 'SRPB_AWE'),
  ('WHOQOL_SRPB', 'wholeness', 'SRPB_WHOLENESS'), ('WHOQOL_SRPB', 'spiritualStrength', 'SRPB_SPIRITUAL_STRENGTH'),
  ('WHOQOL_SRPB', 'innerPeace', 'SRPB_INNER_PEACE'), ('WHOQOL_SRPB', 'hope', 'SRPB_HOPE'), ('WHOQOL_SRPB', 'faith', 'SRPB_FAITH'),
  ('PIL', NULL, 'PIL_TOTAL'),
  ('WHO_5', NULL, 'WHO5_PCT'),
  ('I_PANAS_SF', NULL, 'PANAS_BALANCE'), ('I_PANAS_SF', 'positiveAffect', 'PANAS_PA'), ('I_PANAS_SF', 'negativeAffect', 'PANAS_NA'),
  ('IPAQ_SF', NULL, 'IPAQ_MET_MIN'), ('IPAQ_SF', 'sittingMinutesPerDay', 'IPAQ_SITTING_MIN'),
  ('PSQI', NULL, 'PSQI_GLOBAL'),
  ('AIS', NULL, 'AIS_TOTAL'),
  ('MEDAS', 'normalized', 'MEDAS_NORMALIZED'),
  ('FACIT_SP_12', NULL, 'FACIT_SP_TOTAL'), ('FACIT_SP_12', 'meaning', 'FACIT_SP_MEANING'),
  ('FACIT_SP_12', 'peace', 'FACIT_SP_PEACE'), ('FACIT_SP_12', 'faith', 'FACIT_SP_FAITH'),
  ('SWBS', NULL, 'SWBS_TOTAL'), ('SWBS', 'existential', 'SWBS_EXISTENTIAL')
ON CONFLICT DO NOTHING;

-- Una medida por cada una de las 24 fortalezas VIA (media 1–5).
INSERT INTO dim_measure (measure_code, instrument_key, name_es, unit, improvement_direction, valid_min, valid_max)
SELECT 'VIA_' || s, 11, 'VIA ' || initcap(replace(s, '_', ' ')), 'media 1–5', 0, 1, 5
FROM unnest(ARRAY['CREATIVITY','CURIOSITY','JUDGMENT','LOVE_OF_LEARNING','PERSPECTIVE','BRAVERY',
                  'PERSEVERANCE','HONESTY','ZEST','LOVE','KINDNESS','SOCIAL_INTELLIGENCE','TEAMWORK',
                  'FAIRNESS','LEADERSHIP','FORGIVENESS','HUMILITY','PRUDENCE','SELF_REGULATION',
                  'APPRECIATION_OF_BEAUTY','GRATITUDE','HOPE','HUMOR','SPIRITUALITY']) AS s
ON CONFLICT DO NOTHING;
