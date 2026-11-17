--
-- PostgreSQL database dump
--


-- Dumped from database version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: analytics; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA analytics;


--
-- Name: AssessmentPhase; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AssessmentPhase" AS ENUM (
    'BASELINE',
    'MONTH_1',
    'MONTH_2',
    'MONTH_3',
    'MONTH_6',
    'FOLLOW_UP'
);


--
-- Name: AvatarArchetype; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AvatarArchetype" AS ENUM (
    'EXPLORER',
    'GUARDIAN',
    'SAGE',
    'ARTISAN',
    'WAYFARER'
);


--
-- Name: BodyFatMethod; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."BodyFatMethod" AS ENUM (
    'BIA',
    'SKINFOLDS',
    'DXA',
    'OTHER'
);


--
-- Name: BodyRegion; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."BodyRegion" AS ENUM (
    'NECK',
    'SHOULDER',
    'ELBOW',
    'WRIST_HAND',
    'UPPER_BACK',
    'LOWER_BACK',
    'HIP',
    'KNEE',
    'ANKLE_FOOT',
    'OTHER'
);


--
-- Name: BodySide; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."BodySide" AS ENUM (
    'LEFT',
    'RIGHT',
    'NOT_APPLICABLE'
);


--
-- Name: ConsentScope; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ConsentScope" AS ENUM (
    'APP_ONLY',
    'RESEARCH_DEIDENTIFIED'
);


--
-- Name: ExportFormat; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ExportFormat" AS ENUM (
    'PDF_CLINICAL_REPORT',
    'FHIR_R4_BUNDLE'
);


--
-- Name: FmsPattern; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."FmsPattern" AS ENUM (
    'DEEP_SQUAT',
    'HURDLE_STEP',
    'INLINE_LUNGE',
    'SHOULDER_MOBILITY',
    'ACTIVE_STRAIGHT_LEG_RAISE',
    'TRUNK_STABILITY_PUSH_UP',
    'ROTARY_STABILITY'
);


--
-- Name: FunctionalCapacity; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."FunctionalCapacity" AS ENUM (
    'STRENGTH',
    'ENDURANCE',
    'MOBILITY',
    'BALANCE',
    'COORDINATION',
    'AGILITY',
    'PROPRIOCEPTION'
);


--
-- Name: GamificationMode; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."GamificationMode" AS ENUM (
    'FULL',
    'GENTLE',
    'PAUSED'
);


--
-- Name: GuildRole; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."GuildRole" AS ENUM (
    'MEMBER',
    'MENTOR',
    'FACILITATOR'
);


--
-- Name: GuildType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."GuildType" AS ENUM (
    'EDUCATIONAL',
    'WORKPLACE',
    'COMMUNITY',
    'SHARED_BARRIER'
);


--
-- Name: Hand; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Hand" AS ENUM (
    'LEFT',
    'RIGHT'
);


--
-- Name: ImplementationSetting; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ImplementationSetting" AS ENUM (
    'EDUCATIONAL',
    'WORKPLACE',
    'COMMUNITY',
    'HEALTHCARE'
);


--
-- Name: InjuryStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."InjuryStatus" AS ENUM (
    'ACTIVE',
    'RECOVERING',
    'RESOLVED'
);


--
-- Name: Instrument; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Instrument" AS ENUM (
    'PSS_10',
    'VIA_IS',
    'GHQ_12',
    'MSPSS',
    'WHOQOL_SRPB',
    'PIL',
    'WHO_5',
    'I_PANAS_SF',
    'IPAQ_SF',
    'PSQI',
    'AIS',
    'MEDAS',
    'FACIT_SP_12',
    'SWBS',
    'JAREL',
    'SAFETY_SCREEN'
);


--
-- Name: LoreMoment; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."LoreMoment" AS ENUM (
    'BEFORE_TRAINING',
    'AFTER_TRAINING',
    'FREE'
);


--
-- Name: MeasurementSource; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."MeasurementSource" AS ENUM (
    'EVALUATOR',
    'SELF_REPORTED'
);


--
-- Name: MissionCategory; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."MissionCategory" AS ENUM (
    'RECOVERY',
    'MINDFULNESS',
    'FUNCTIONAL',
    'STRENGTH',
    'CONDITIONING',
    'COMMUNITY',
    'LORE'
);


--
-- Name: MissionIntensity; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."MissionIntensity" AS ENUM (
    'RESTORATIVE',
    'LIGHT',
    'MODERATE',
    'HIGH'
);


--
-- Name: MissionSlot; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."MissionSlot" AS ENUM (
    'MAIN',
    'RECOVERY',
    'COMMUNITY',
    'LORE'
);


--
-- Name: MissionStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."MissionStatus" AS ENUM (
    'ASSIGNED',
    'IN_PROGRESS',
    'COMPLETED',
    'ADAPTED',
    'SKIPPED'
);


--
-- Name: OneRmFormula; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."OneRmFormula" AS ENUM (
    'BRZYCKI',
    'EPLEY',
    'LOMBARDI',
    'NONE'
);


--
-- Name: PassiveMetric; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PassiveMetric" AS ENUM (
    'HRV_RMSSD_MS',
    'HRV_SDNN_MS',
    'RESTING_HR_BPM',
    'STEPS',
    'SLEEP_ASLEEP_MIN',
    'SLEEP_DEEP_MIN',
    'SLEEP_REM_MIN',
    'SLEEP_AWAKE_MIN',
    'SLEEP_IN_BED_MIN'
);


--
-- Name: PassivePlatform; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PassivePlatform" AS ENUM (
    'APPLE_HEALTH',
    'HEALTH_CONNECT',
    'MANUAL_DEVICE'
);


--
-- Name: PerimeterSite; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PerimeterSite" AS ENUM (
    'CHEST',
    'ARM_RELAXED',
    'ARM_FLEXED_TENSED',
    'WAIST',
    'HIP',
    'THIGH_MID',
    'CALF_MAX'
);


--
-- Name: ProfileSideQuestKey; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ProfileSideQuestKey" AS ENUM (
    'MEDICAL_CONDITIONS',
    'MEDICATIONS',
    'SURGICAL_HISTORY',
    'INJURY_HISTORY',
    'FOOD_AVERSIONS',
    'HORMONAL_CONTRACEPTION',
    'MENSTRUAL_CYCLE',
    'BODY_COMPOSITION'
);


--
-- Name: PurposeTheme; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PurposeTheme" AS ENUM (
    'FAMILY',
    'HEALING',
    'STRESS_RELEASE',
    'SELF_CARE',
    'COMMUNITY',
    'FAITH_SPIRITUALITY',
    'AUTONOMY',
    'OTHER'
);


--
-- Name: ReadinessBand; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ReadinessBand" AS ENUM (
    'RECOVERY',
    'BALANCE',
    'EXPANSION'
);


--
-- Name: RedFlagLevel; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."RedFlagLevel" AS ENUM (
    'NONE',
    'WATCH',
    'ELEVATED',
    'CRISIS'
);


--
-- Name: SexForReference; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."SexForReference" AS ENUM (
    'FEMALE',
    'MALE',
    'INTERSEX',
    'UNDISCLOSED'
);


--
-- Name: SmokingStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."SmokingStatus" AS ENUM (
    'NEVER',
    'FORMER',
    'CURRENT',
    'UNDISCLOSED'
);


--
-- Name: SpiritualOrientation; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."SpiritualOrientation" AS ENUM (
    'THEOLOGICAL',
    'MINDFULNESS',
    'NATURE',
    'SECULAR_PURPOSE'
);


--
-- Name: StrengthExercise; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."StrengthExercise" AS ENUM (
    'DEEP_SQUAT',
    'BENCH_PRESS',
    'DEADLIFT',
    'OVERHEAD_PRESS',
    'BENT_OVER_ROW',
    'LEG_PRESS'
);


--
-- Name: StrengthTestProtocol; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."StrengthTestProtocol" AS ENUM (
    'DIRECT_1RM',
    'DIRECT_5RM',
    'ESTIMATED_FROM_SUBMAX'
);


--
-- Name: TrainingExperience; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."TrainingExperience" AS ENUM (
    'NONE',
    'BEGINNER',
    'INTERMEDIATE',
    'ADVANCED'
);


--
-- Name: TrainingModality; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."TrainingModality" AS ENUM (
    'STRENGTH_TRAINING',
    'CALISTHENICS',
    'FUNCTIONAL',
    'CARDIO_ENDURANCE',
    'SPORTS',
    'DANCE',
    'YOGA_PILATES',
    'WALKING',
    'OTHER'
);


--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserRole" AS ENUM (
    'PARTICIPANT',
    'EVALUATOR',
    'RESEARCHER',
    'ADMIN'
);


--
-- Name: ViaStrength; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ViaStrength" AS ENUM (
    'CREATIVITY',
    'CURIOSITY',
    'JUDGMENT',
    'LOVE_OF_LEARNING',
    'PERSPECTIVE',
    'BRAVERY',
    'PERSEVERANCE',
    'HONESTY',
    'ZEST',
    'LOVE',
    'KINDNESS',
    'SOCIAL_INTELLIGENCE',
    'TEAMWORK',
    'FAIRNESS',
    'LEADERSHIP',
    'FORGIVENESS',
    'HUMILITY',
    'PRUDENCE',
    'SELF_REGULATION',
    'APPRECIATION_OF_BEAUTY',
    'GRATITUDE',
    'HOPE',
    'HUMOR',
    'SPIRITUALITY'
);


--
-- Name: XpSource; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."XpSource" AS ENUM (
    'MISSION',
    'CHECK_IN',
    'ASSESSMENT_MILESTONE',
    'LORE_ENTRY',
    'GUILD_QUEST',
    'SIDE_QUEST'
);


--
-- Name: refresh_all(); Type: PROCEDURE; Schema: analytics; Owner: -
--

CREATE PROCEDURE analytics.refresh_all()
    LANGUAGE plpgsql
    AS $$
BEGIN
  SET LOCAL search_path = analytics, public;

  -- ---------------------------------------------------------------------------
  -- 0. Participantes elegibles: consentimiento de investigación vigente.
  -- ---------------------------------------------------------------------------
  CREATE TEMP TABLE eligible ON COMMIT DROP AS
  SELECT DISTINCT ON (u.id) u.id AS user_id, u."researchCode" AS research_code,
         c."allowsPassiveData" AS allows_passive
  FROM public.users u
  JOIN public.research_consents c ON c."userId" = u.id
  WHERE c.scope = 'RESEARCH_DEIDENTIFIED' AND c."revokedAt" IS NULL
    AND u.role = 'PARTICIPANT'
  ORDER BY u.id, c."acceptedAt" DESC;

  TRUNCATE fact_assessment_measure, fact_daily_wellbeing, fact_mission_adherence,
           fact_lore_reflection, fact_guild_contribution, fact_passive_daily,
           fact_wellbeing_index, fact_red_flag_event;
  -- Quien revoca su consentimiento sale también de la dimensión.
  DELETE FROM dim_participant dp
  WHERE NOT EXISTS (SELECT 1 FROM eligible e WHERE e.research_code = dp.research_code);

  -- ---------------------------------------------------------------------------
  -- 1. Dimensiones dinámicas
  -- ---------------------------------------------------------------------------
  INSERT INTO dim_participant AS d (research_code, sex_for_reference, age_at_enrollment, age_group,
                                    setting, municipality_code, baseline_experience, spiritual_orientation,
                                    avatar_archetype, enrollment_date, cohort)
  SELECT e.research_code,
         p."sexForReference"::text,
         age_years,
         CASE WHEN age_years < 18 THEN 'ADOLESCENT' WHEN age_years >= 60 THEN 'OLDER_ADULT' ELSE 'ADULT' END,
         p.setting::text,
         p."municipalityCode",
         (SELECT a."trainingExperience"::text FROM public.anamneses a
           WHERE a."userId" = e.user_id ORDER BY a."recordedAt" LIMIT 1),
         p."spiritualOrientation"::text,
         p.archetype::text,
         enrolled::date,
         to_char(enrolled, 'YYYY-MM')
  FROM eligible e
  JOIN public.player_profiles p ON p."userId" = e.user_id
  CROSS JOIN LATERAL (SELECT coalesce(p."onboardingCompletedAt", p."createdAt") AS enrolled) en
  -- Solo se conoce el año de nacimiento (de-identificación): edad aproximada ±1 año.
  CROSS JOIN LATERAL (SELECT (extract(year FROM enrolled) - p."birthYear")::smallint AS age_years) ag
  ON CONFLICT (research_code) DO UPDATE SET
    sex_for_reference = excluded.sex_for_reference, age_at_enrollment = excluded.age_at_enrollment,
    age_group = excluded.age_group, setting = excluded.setting,
    municipality_code = excluded.municipality_code, baseline_experience = excluded.baseline_experience,
    avatar_archetype = excluded.avatar_archetype, enrollment_date = excluded.enrollment_date,
    spiritual_orientation = excluded.spiritual_orientation,
    cohort = excluded.cohort, loaded_at = now();

  INSERT INTO dim_mission (code, title, category, intensity, duration_minutes)
  SELECT code, title, category::text, intensity::text, "durationMinutes" FROM public.mission_templates
  ON CONFLICT (code) DO UPDATE SET title = excluded.title, category = excluded.category,
    intensity = excluded.intensity, duration_minutes = excluded.duration_minutes;

  INSERT INTO dim_guild (source_id, guild_type, setting, municipality_code)
  SELECT id, type::text, setting::text, "municipalityCode" FROM public.guilds
  ON CONFLICT (source_id) DO UPDATE SET guild_type = excluded.guild_type, setting = excluded.setting,
    municipality_code = excluded.municipality_code;

  -- ---------------------------------------------------------------------------
  -- 2. fact_assessment_measure: todas las pruebas en formato largo
  -- ---------------------------------------------------------------------------
  -- Solo valoraciones tomadas por evaluador SIFUS (el autorreporte no es evidencia).
  CREATE TEMP VIEW eval_assessments AS
  SELECT * FROM public.assessments WHERE source = 'EVALUATOR';

  CREATE TEMP TABLE raw_measure (
    user_id text, phase text, measured_on date, measure_code text, value numeric,
    technique_valid boolean, protocol_version text
  ) ON COMMIT DROP;

  -- 2a. Antropometría base e índices derivados
  INSERT INTO raw_measure
  SELECT a."userId", a.phase::text, a."assessedAt"::date, m.code, m.val, true, a."protocolVersion"
  FROM eval_assessments a
  JOIN public.anthropometric_records r ON r."assessmentId" = a.id
  LEFT JOIN public.perimeter_measurements w ON w."assessmentId" = a.id AND w.site = 'WAIST'
  LEFT JOIN public.perimeter_measurements h ON h."assessmentId" = a.id AND h.site = 'HIP'
  CROSS JOIN LATERAL (VALUES
    ('HEIGHT_CM', r."heightCm"),
    ('WEIGHT_KG', r."weightKg"),
    ('BMI', round(r."weightKg" / power(r."heightCm" / 100.0, 2), 2)),
    ('BODY_FAT_PCT', r."bodyFatPct"),
    ('WAIST_HIP_RATIO', round(w."valueCm" / nullif(h."valueCm", 0), 3)),
    ('WAIST_HEIGHT_RATIO', round(w."valueCm" / r."heightCm", 3))
  ) AS m(code, val)
  WHERE m.val IS NOT NULL;

  -- 2b. Perímetros. Sitios bilaterales: se usa el lado derecho por convención
  -- ISAK; si solo hay izquierdo, se usa ese.
  INSERT INTO raw_measure
  SELECT DISTINCT ON (a.id, pm.site)
         a."userId", a.phase::text, a."assessedAt"::date,
         CASE pm.site::text
           WHEN 'CHEST' THEN 'PERIM_CHEST' WHEN 'ARM_RELAXED' THEN 'PERIM_ARM_RELAXED'
           WHEN 'ARM_FLEXED_TENSED' THEN 'PERIM_ARM_FLEXED' WHEN 'WAIST' THEN 'PERIM_WAIST'
           WHEN 'HIP' THEN 'PERIM_HIP' WHEN 'THIGH_MID' THEN 'PERIM_THIGH' WHEN 'CALF_MAX' THEN 'PERIM_CALF'
         END,
         pm."valueCm", true, a."protocolVersion"
  FROM eval_assessments a
  JOIN public.perimeter_measurements pm ON pm."assessmentId" = a.id
  ORDER BY a.id, pm.site, (pm.side = 'RIGHT') DESC, (pm.side = 'NOT_APPLICABLE') DESC;

  -- 2c. FMS
  INSERT INTO raw_measure
  SELECT a."userId", a.phase::text, a."assessedAt"::date, m.code, m.val, true, a."protocolVersion"
  FROM eval_assessments a
  JOIN public.fms_screens f ON f."assessmentId" = a.id
  CROSS JOIN LATERAL (
    SELECT count(*) FILTER (WHERE p."leftScore" IS DISTINCT FROM p."rightScore"
                              AND p."leftScore" IS NOT NULL AND p."rightScore" IS NOT NULL) AS asym,
           count(*) FILTER (WHERE p."clearingTestPain" OR p."finalScore" = 0) AS pain
    FROM public.fms_pattern_scores p WHERE p."screenId" = f.id
  ) agg
  CROSS JOIN LATERAL (VALUES
    ('FMS_TOTAL', f."totalScore"::numeric),
    ('FMS_ASYMMETRY_COUNT', agg.asym::numeric),
    ('FMS_PAIN_COUNT', agg.pain::numeric)
  ) AS m(code, val);

  -- 2d. Dinamometría (mejor intento) y prensión relativa
  INSERT INTO raw_measure
  SELECT a."userId", a.phase::text, a."assessedAt"::date,
         CASE WHEN d."isDominant" THEN 'GRIP_DOMINANT_KG' ELSE 'GRIP_NONDOMINANT_KG' END,
         d."bestKg", true, a."protocolVersion"
  FROM eval_assessments a JOIN public.dynamometry_tests d ON d."assessmentId" = a.id;

  INSERT INTO raw_measure
  SELECT a."userId", a.phase::text, a."assessedAt"::date, 'GRIP_RELATIVE',
         round(d."bestKg" / r."weightKg", 3), true, a."protocolVersion"
  FROM eval_assessments a
  JOIN public.dynamometry_tests d ON d."assessmentId" = a.id AND d."isDominant"
  JOIN public.anthropometric_records r ON r."assessmentId" = a.id;

  -- 2e. Wells & Dillon normalizado a la línea de los pies (comparable entre cajones)
  INSERT INTO raw_measure
  SELECT DISTINCT ON (a.id)
         a."userId", a.phase::text, a."assessedAt"::date, 'SIT_REACH_FOOTLINE_CM',
         f."bestCm" - f."footLineAtCm", true, a."protocolVersion"
  FROM eval_assessments a JOIN public.flexibility_tests f ON f."assessmentId" = a.id
  WHERE f."testName" = 'WELLS_DILLON'
  ORDER BY a.id, f."bestCm" DESC;

  -- 2f. Fuerza máxima: se toma el mayor 1RM (estimado o directo) por ejercicio;
  -- los intentos con técnica no válida se cargan como is_valid = false.
  INSERT INTO raw_measure
  SELECT a."userId", a.phase::text, a."assessedAt"::date, m.code, m.val, s.valid, a."protocolVersion"
  FROM eval_assessments a
  JOIN LATERAL (
    SELECT st.exercise, max(st."estimated1RmKg") AS one_rm, bool_and(st."techniqueValid") AS valid
    FROM public.strength_tests st
    WHERE st."assessmentId" = a.id AND st.exercise IN ('DEEP_SQUAT', 'BENCH_PRESS')
    GROUP BY st.exercise
  ) s ON true
  LEFT JOIN public.anthropometric_records r ON r."assessmentId" = a.id
  CROSS JOIN LATERAL (VALUES
    (CASE s.exercise WHEN 'DEEP_SQUAT' THEN 'SQUAT_1RM_KG' ELSE 'BENCH_1RM_KG' END, s.one_rm),
    (CASE s.exercise WHEN 'DEEP_SQUAT' THEN 'SQUAT_1RM_REL' ELSE 'BENCH_1RM_REL' END,
       round(s.one_rm / nullif(r."weightKg", 0), 3))
  ) AS m(code, val)
  WHERE m.val IS NOT NULL;

  -- 2g. Cuestionarios (puntaje total + subescalas). Si una fase tiene varias
  -- aplicaciones del mismo instrumento, se conserva la más reciente.
  CREATE TEMP TABLE latest_q ON COMMIT DROP AS
  SELECT DISTINCT ON (q."userId", coalesce(a.phase, q.phase), q.instrument)
         q.*, coalesce(a.phase, q.phase)::text AS eff_phase, a."protocolVersion" AS protocol_version
  FROM public.questionnaire_administrations q
  LEFT JOIN public.assessments a ON a.id = q."assessmentId"
  WHERE coalesce(a.phase, q.phase) IS NOT NULL
  ORDER BY q."userId", coalesce(a.phase, q.phase), q.instrument, q."completedAt" DESC;

  -- Cada instrumento → sus medidas según analytics.map_questionnaire_measure.
  INSERT INTO raw_measure
  SELECT q."userId", q.eff_phase, q."completedAt"::date, mq.measure_code,
         CASE WHEN mq.json_key IS NULL THEN q."totalScore"
              ELSE (q."subscaleScores"->>mq.json_key)::numeric END,
         true, q."instrumentVersion"
  FROM latest_q q
  JOIN map_questionnaire_measure mq ON mq.instrument = q.instrument::text
  WHERE CASE WHEN mq.json_key IS NULL THEN q."totalScore"
             ELSE (q."subscaleScores"->>mq.json_key)::numeric END IS NOT NULL;

  INSERT INTO raw_measure
  SELECT q."userId", q.eff_phase, q."completedAt"::date, 'VIA_' || v.strength::text, v.score, true, q."instrumentVersion"
  FROM latest_q q JOIN public.via_strength_scores v ON v."administrationId" = q.id
  WHERE q.instrument = 'VIA_IS';

  -- 2g'. Sensores e Índice de Vida alrededor de cada valoración: media de los
  -- 14 días previos (inclusive), solo con ≥ 7 días con dato y con
  -- consentimiento de datos pasivos.
  -- Primero, una fila por persona y día; sueño total = ligero/core + profundo + REM.
  CREATE TEMP TABLE passive_day ON COMMIT DROP AS
  SELECT ps."userId" AS user_id, ps.date,
         max(ps.value) FILTER (WHERE ps.metric = 'STEPS')          AS steps,
         max(ps.value) FILTER (WHERE ps.metric = 'RESTING_HR_BPM') AS resting_hr,
         sum(ps.value) FILTER (WHERE ps.metric IN ('SLEEP_ASLEEP_MIN','SLEEP_DEEP_MIN','SLEEP_REM_MIN')) / 60.0 AS sleep_hours
  FROM public.passive_daily_summaries ps
  JOIN eligible e ON e.user_id = ps."userId" AND e.allows_passive
  GROUP BY ps."userId", ps.date;

  INSERT INTO raw_measure
  SELECT a."userId", a.phase::text, a."assessedAt"::date, m.code, round(avg(m.val), 2), true, 'PASSIVE-14D'
  FROM eval_assessments a
  JOIN passive_day pd ON pd.user_id = a."userId" AND pd.date BETWEEN a."assessedAt"::date - 13 AND a."assessedAt"::date
  CROSS JOIN LATERAL (VALUES ('STEPS_MEAN', pd.steps), ('RESTING_HR_MEAN', pd.resting_hr), ('SLEEP_HOURS_MEAN', pd.sleep_hours)) AS m(code, val)
  WHERE m.val IS NOT NULL
  GROUP BY a."userId", a.phase, a."assessedAt", m.code
  HAVING count(*) >= 7;

  INSERT INTO raw_measure
  SELECT a."userId", a.phase::text, a."assessedAt"::date, 'WELLBEING_INDEX_MEAN', round(avg(w.index), 1), true, max(w.version)
  FROM eval_assessments a
  JOIN public.wellbeing_index_snapshots w
    ON w."userId" = a."userId" AND w.date BETWEEN a."assessedAt"::date - 13 AND a."assessedAt"::date AND w.index IS NOT NULL
  GROUP BY a."userId", a.phase, a."assessedAt"
  HAVING count(*) >= 7;

  -- 2h. Carga final con validación de rango plausible.
  INSERT INTO fact_assessment_measure
  SELECT DISTINCT ON (dp.participant_key, ph.phase_key, dm.measure_key)
         dp.participant_key, ph.phase_key, dm.measure_key, to_char(r.measured_on, 'YYYYMMDD')::int,
         r.value,
         r.technique_valid AND r.value BETWEEN coalesce(dm.valid_min, r.value) AND coalesce(dm.valid_max, r.value),
         r.protocol_version
  FROM raw_measure r
  JOIN eligible e ON e.user_id = r.user_id
  JOIN dim_participant dp ON dp.research_code = e.research_code
  JOIN dim_phase ph ON ph.phase_code = r.phase
  JOIN dim_measure dm ON dm.measure_code = r.measure_code
  ORDER BY dp.participant_key, ph.phase_key, dm.measure_key, r.measured_on DESC;

  -- ---------------------------------------------------------------------------
  -- 3. fact_daily_wellbeing: check-in + decisión del algoritmo
  -- ---------------------------------------------------------------------------
  INSERT INTO fact_daily_wellbeing
  SELECT dp.participant_key, to_char(coalesce(c.date, pl.date), 'YYYYMMDD')::int, b.band_key,
         c."sleepHours", c."sleepQuality", c."perceivedStress", c."mentalFatigue",
         c."physicalFatigue", c."painLevel", c.mood, c."feelsIsolated",
         pl."loadScore", pl."rpeCap", pl."reasonCodes", pl."safetyFlags", pl."algorithmVersion"
  FROM public.daily_check_ins c
  FULL JOIN public.daily_plans pl ON pl."checkInId" = c.id
  JOIN eligible e ON e.user_id = coalesce(c."userId", pl."userId")
  JOIN dim_participant dp ON dp.research_code = e.research_code
  LEFT JOIN dim_readiness_band b ON b.band_code = pl.band::text;

  -- ---------------------------------------------------------------------------
  -- 4. fact_mission_adherence
  -- ---------------------------------------------------------------------------
  INSERT INTO fact_mission_adherence
  SELECT m.id, dp.participant_key, to_char(pl.date, 'YYYYMMDD')::int, dmi.mission_key, b.band_key,
         m.slot::text, 1,
         (m.status IN ('COMPLETED', 'ADAPTED'))::int,
         (m.status = 'ADAPTED')::int,
         (m.status = 'SKIPPED')::int,
         m."reportedRpe", m."actualMinutes", m."xpAwarded"
  FROM public.daily_missions m
  JOIN public.daily_plans pl ON pl.id = m."planId"
  JOIN public.mission_templates t ON t.id = m."templateId"
  JOIN eligible e ON e.user_id = pl."userId"
  JOIN dim_participant dp ON dp.research_code = e.research_code
  JOIN dim_mission dmi ON dmi.code = t.code
  JOIN dim_readiness_band b ON b.band_code = pl.band::text;

  -- ---------------------------------------------------------------------------
  -- 5. fact_lore_reflection (sin texto libre)
  -- ---------------------------------------------------------------------------
  INSERT INTO fact_lore_reflection
  SELECT l.id, dp.participant_key, to_char(l."createdAt", 'YYYYMMDD')::int, l.moment::text,
         l."purposeTheme"::text, l."coherenceRating", l."strengthsUsed"::text[],
         l."dailyMissionId" IS NOT NULL
  FROM public.lore_entries l
  JOIN eligible e ON e.user_id = l."userId"
  JOIN dim_participant dp ON dp.research_code = e.research_code;

  -- ---------------------------------------------------------------------------
  -- 6. fact_guild_contribution
  -- ---------------------------------------------------------------------------
  INSERT INTO fact_guild_contribution
  SELECT gc.id, dp.participant_key, dg.guild_key, to_char(gc."createdAt", 'YYYYMMDD')::int, gq.metric, gc.value
  FROM public.guild_quest_contributions gc
  JOIN public.guild_quests gq ON gq.id = gc."questId"
  JOIN public.guild_memberships gm ON gm.id = gc."membershipId"
  JOIN eligible e ON e.user_id = gm."userId"
  JOIN dim_participant dp ON dp.research_code = e.research_code
  JOIN dim_guild dg ON dg.source_id = gq."guildId";

  -- ---------------------------------------------------------------------------
  -- 7. fact_passive_daily (solo con consentimiento de datos pasivos)
  -- ---------------------------------------------------------------------------
  INSERT INTO fact_passive_daily
  SELECT dp.participant_key, to_char(ps.date, 'YYYYMMDD')::int, ps.metric::text, ps.value,
         ps."sampleCount", ps.platform::text, ps."deviceModel"
  FROM public.passive_daily_summaries ps
  JOIN eligible e ON e.user_id = ps."userId" AND e.allows_passive
  JOIN dim_participant dp ON dp.research_code = e.research_code;

  -- ---------------------------------------------------------------------------
  -- 8. fact_wellbeing_index
  -- ---------------------------------------------------------------------------
  INSERT INTO fact_wellbeing_index
  SELECT dp.participant_key, to_char(w.date, 'YYYYMMDD')::int, w.index,
         w."mindScore", w."bodyScore", w."restorationScore", w."lifestyleScore", w."purposeScore",
         w.confidence, w."selfReportReliability", cardinality(w."consistencyFlags"), w.version
  FROM public.wellbeing_index_snapshots w
  JOIN eligible e ON e.user_id = w."userId"
  JOIN dim_participant dp ON dp.research_code = e.research_code;

  -- ---------------------------------------------------------------------------
  -- 9. fact_red_flag_event (monitoreo de seguridad; sin notas clínicas)
  -- ---------------------------------------------------------------------------
  INSERT INTO fact_red_flag_event
  SELECT r.id, dp.participant_key, to_char(r."openedAt", 'YYYYMMDD')::int, r.level::text, r.triggers,
         round(extract(epoch FROM r."professionalContactAt" - r."openedAt") / 3600.0, 1),
         r."resolvedAt" IS NOT NULL, r."protocolVersion"
  FROM public.red_flag_events r
  JOIN eligible e ON e.user_id = r."userId"
  JOIN dim_participant dp ON dp.research_code = e.research_code;

  REFRESH MATERIALIZED VIEW analytics.mv_phase_snapshot;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dim_date; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.dim_date (
    date_key integer NOT NULL,
    full_date date NOT NULL,
    year smallint NOT NULL,
    quarter smallint NOT NULL,
    month smallint NOT NULL,
    iso_week smallint NOT NULL,
    iso_dow smallint NOT NULL,
    is_weekend boolean NOT NULL,
    academic_term text NOT NULL
);


--
-- Name: dim_guild; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.dim_guild (
    guild_key integer NOT NULL,
    source_id text NOT NULL,
    guild_type text NOT NULL,
    setting text NOT NULL,
    municipality_code text
);


--
-- Name: dim_guild_guild_key_seq; Type: SEQUENCE; Schema: analytics; Owner: -
--

CREATE SEQUENCE analytics.dim_guild_guild_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_guild_guild_key_seq; Type: SEQUENCE OWNED BY; Schema: analytics; Owner: -
--

ALTER SEQUENCE analytics.dim_guild_guild_key_seq OWNED BY analytics.dim_guild.guild_key;


--
-- Name: dim_instrument; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.dim_instrument (
    instrument_key smallint NOT NULL,
    code text NOT NULL,
    name_es text NOT NULL,
    health_domain text NOT NULL,
    reference text,
    CONSTRAINT dim_instrument_health_domain_check CHECK ((health_domain = ANY (ARRAY['PHYSICAL'::text, 'MENTAL'::text, 'SOCIAL'::text, 'SPIRITUAL'::text, 'LIFESTYLE'::text])))
);


--
-- Name: dim_measure; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.dim_measure (
    measure_key integer NOT NULL,
    measure_code text NOT NULL,
    instrument_key smallint NOT NULL,
    name_es text NOT NULL,
    unit text NOT NULL,
    improvement_direction smallint NOT NULL,
    capacity text,
    valid_min numeric,
    valid_max numeric,
    mdc numeric,
    mdc_source text,
    wellbeing_domain text,
    loinc_code text,
    loinc_status text,
    CONSTRAINT dim_measure_improvement_direction_check CHECK ((improvement_direction = ANY (ARRAY['-1'::integer, 0, 1]))),
    CONSTRAINT dim_measure_loinc_status_check CHECK ((loinc_status = ANY (ARRAY['VERIFIED'::text, 'PENDING_VERIFICATION'::text])))
);


--
-- Name: dim_measure_measure_key_seq; Type: SEQUENCE; Schema: analytics; Owner: -
--

CREATE SEQUENCE analytics.dim_measure_measure_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_measure_measure_key_seq; Type: SEQUENCE OWNED BY; Schema: analytics; Owner: -
--

ALTER SEQUENCE analytics.dim_measure_measure_key_seq OWNED BY analytics.dim_measure.measure_key;


--
-- Name: dim_mission; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.dim_mission (
    mission_key integer NOT NULL,
    code text NOT NULL,
    title text NOT NULL,
    category text NOT NULL,
    intensity text NOT NULL,
    duration_minutes smallint NOT NULL
);


--
-- Name: dim_mission_mission_key_seq; Type: SEQUENCE; Schema: analytics; Owner: -
--

CREATE SEQUENCE analytics.dim_mission_mission_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_mission_mission_key_seq; Type: SEQUENCE OWNED BY; Schema: analytics; Owner: -
--

ALTER SEQUENCE analytics.dim_mission_mission_key_seq OWNED BY analytics.dim_mission.mission_key;


--
-- Name: dim_participant; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.dim_participant (
    participant_key integer NOT NULL,
    research_code text NOT NULL,
    sex_for_reference text NOT NULL,
    age_at_enrollment smallint,
    age_group text NOT NULL,
    setting text NOT NULL,
    municipality_code text,
    baseline_experience text,
    spiritual_orientation text,
    avatar_archetype text,
    enrollment_date date,
    cohort text,
    loaded_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: dim_participant_participant_key_seq; Type: SEQUENCE; Schema: analytics; Owner: -
--

CREATE SEQUENCE analytics.dim_participant_participant_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_participant_participant_key_seq; Type: SEQUENCE OWNED BY; Schema: analytics; Owner: -
--

ALTER SEQUENCE analytics.dim_participant_participant_key_seq OWNED BY analytics.dim_participant.participant_key;


--
-- Name: dim_phase; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.dim_phase (
    phase_key smallint NOT NULL,
    phase_code text NOT NULL,
    phase_order smallint NOT NULL,
    nominal_week smallint NOT NULL,
    label_es text NOT NULL
);


--
-- Name: dim_readiness_band; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.dim_readiness_band (
    band_key smallint NOT NULL,
    band_code text NOT NULL,
    label_es text NOT NULL,
    band_order smallint NOT NULL
);


--
-- Name: fact_assessment_measure; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.fact_assessment_measure (
    participant_key integer NOT NULL,
    phase_key smallint NOT NULL,
    measure_key integer NOT NULL,
    date_key integer NOT NULL,
    value numeric NOT NULL,
    is_valid boolean NOT NULL,
    protocol_version text
);


--
-- Name: fact_daily_wellbeing; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.fact_daily_wellbeing (
    participant_key integer NOT NULL,
    date_key integer NOT NULL,
    band_key smallint,
    sleep_hours numeric(3,1),
    sleep_quality smallint,
    perceived_stress smallint,
    mental_fatigue smallint,
    physical_fatigue smallint,
    pain_level smallint,
    mood smallint,
    feels_isolated boolean,
    load_score numeric(4,1),
    rpe_cap smallint,
    reason_codes text[],
    safety_flags text[],
    algorithm_version text
);


--
-- Name: fact_guild_contribution; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.fact_guild_contribution (
    contribution_id text NOT NULL,
    participant_key integer NOT NULL,
    guild_key integer NOT NULL,
    date_key integer NOT NULL,
    metric text NOT NULL,
    value integer NOT NULL
);


--
-- Name: fact_lore_reflection; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.fact_lore_reflection (
    lore_entry_id text NOT NULL,
    participant_key integer NOT NULL,
    date_key integer NOT NULL,
    moment text NOT NULL,
    purpose_theme text NOT NULL,
    coherence_rating smallint NOT NULL,
    strengths_used text[] NOT NULL,
    linked_to_mission boolean NOT NULL
);


--
-- Name: fact_mission_adherence; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.fact_mission_adherence (
    daily_mission_id text NOT NULL,
    participant_key integer NOT NULL,
    date_key integer NOT NULL,
    mission_key integer NOT NULL,
    band_key smallint NOT NULL,
    slot text NOT NULL,
    assigned_count smallint DEFAULT 1 NOT NULL,
    completed_count smallint NOT NULL,
    adapted_count smallint NOT NULL,
    skipped_count smallint NOT NULL,
    reported_rpe smallint,
    actual_minutes smallint,
    xp_awarded integer NOT NULL
);


--
-- Name: fact_passive_daily; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.fact_passive_daily (
    participant_key integer NOT NULL,
    date_key integer NOT NULL,
    metric text NOT NULL,
    value numeric NOT NULL,
    sample_count integer NOT NULL,
    platform text NOT NULL,
    device_model text
);


--
-- Name: fact_red_flag_event; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.fact_red_flag_event (
    red_flag_event_id text NOT NULL,
    participant_key integer NOT NULL,
    date_key integer NOT NULL,
    level text NOT NULL,
    triggers text[] NOT NULL,
    hours_to_professional_contact numeric,
    resolved boolean NOT NULL,
    protocol_version text
);


--
-- Name: fact_wellbeing_index; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.fact_wellbeing_index (
    participant_key integer NOT NULL,
    date_key integer NOT NULL,
    wellbeing_index smallint,
    mind_score numeric(4,1),
    body_score numeric(4,1),
    restoration_score numeric(4,1),
    lifestyle_score numeric(4,1),
    purpose_score numeric(4,1),
    confidence numeric(3,2),
    self_report_reliability numeric(3,2),
    consistency_flag_count smallint,
    index_version text
);


--
-- Name: map_questionnaire_measure; Type: TABLE; Schema: analytics; Owner: -
--

CREATE TABLE analytics.map_questionnaire_measure (
    instrument text NOT NULL,
    json_key text,
    measure_code text NOT NULL
);


--
-- Name: v_phase_window; Type: VIEW; Schema: analytics; Owner: -
--

CREATE VIEW analytics.v_phase_window AS
 WITH phase_dates AS (
         SELECT f.participant_key,
            f.phase_key,
            min(d.full_date) AS phase_date
           FROM (analytics.fact_assessment_measure f
             JOIN analytics.dim_date d USING (date_key))
          GROUP BY f.participant_key, f.phase_key
        )
 SELECT pd.participant_key,
    pd.phase_key,
    ph.phase_code,
    ph.phase_order,
    lag(pd.phase_date) OVER w AS window_start,
    pd.phase_date AS window_end
   FROM (phase_dates pd
     JOIN analytics.dim_phase ph USING (phase_key))
  WINDOW w AS (PARTITION BY pd.participant_key ORDER BY ph.phase_order);


--
-- Name: mv_phase_snapshot; Type: MATERIALIZED VIEW; Schema: analytics; Owner: -
--

CREATE MATERIALIZED VIEW analytics.mv_phase_snapshot AS
 WITH m AS (
         SELECT f.participant_key,
            f.phase_key,
            dm.measure_code,
            f.value
           FROM (analytics.fact_assessment_measure f
             JOIN analytics.dim_measure dm USING (measure_key))
          WHERE f.is_valid
        ), pivot AS (
         SELECT m.participant_key,
            m.phase_key,
            max(m.value) FILTER (WHERE (m.measure_code = 'WEIGHT_KG'::text)) AS weight_kg,
            max(m.value) FILTER (WHERE (m.measure_code = 'BMI'::text)) AS bmi,
            max(m.value) FILTER (WHERE (m.measure_code = 'BODY_FAT_PCT'::text)) AS body_fat_pct,
            max(m.value) FILTER (WHERE (m.measure_code = 'PERIM_WAIST'::text)) AS waist_cm,
            max(m.value) FILTER (WHERE (m.measure_code = 'PERIM_HIP'::text)) AS hip_cm,
            max(m.value) FILTER (WHERE (m.measure_code = 'PERIM_ARM_FLEXED'::text)) AS arm_flexed_cm,
            max(m.value) FILTER (WHERE (m.measure_code = 'PERIM_THIGH'::text)) AS thigh_cm,
            max(m.value) FILTER (WHERE (m.measure_code = 'PERIM_CALF'::text)) AS calf_cm,
            max(m.value) FILTER (WHERE (m.measure_code = 'WAIST_HEIGHT_RATIO'::text)) AS waist_height_ratio,
            max(m.value) FILTER (WHERE (m.measure_code = 'FMS_TOTAL'::text)) AS fms_total,
            max(m.value) FILTER (WHERE (m.measure_code = 'GRIP_DOMINANT_KG'::text)) AS grip_dominant_kg,
            max(m.value) FILTER (WHERE (m.measure_code = 'GRIP_RELATIVE'::text)) AS grip_relative,
            max(m.value) FILTER (WHERE (m.measure_code = 'SIT_REACH_FOOTLINE_CM'::text)) AS sit_reach_cm,
            max(m.value) FILTER (WHERE (m.measure_code = 'SQUAT_1RM_REL'::text)) AS squat_1rm_rel,
            max(m.value) FILTER (WHERE (m.measure_code = 'BENCH_1RM_REL'::text)) AS bench_1rm_rel,
            max(m.value) FILTER (WHERE (m.measure_code = 'PSS10_TOTAL'::text)) AS pss10,
            max(m.value) FILTER (WHERE (m.measure_code = 'GHQ12_GHQ'::text)) AS ghq12,
            max(m.value) FILTER (WHERE (m.measure_code = 'MSPSS_TOTAL'::text)) AS mspss,
            max(m.value) FILTER (WHERE (m.measure_code = 'SRPB_TOTAL'::text)) AS srpb,
            max(m.value) FILTER (WHERE (m.measure_code = 'SRPB_MEANING'::text)) AS srpb_meaning,
            max(m.value) FILTER (WHERE (m.measure_code = 'WHO5_PCT'::text)) AS who5,
            max(m.value) FILTER (WHERE (m.measure_code = 'PSQI_GLOBAL'::text)) AS psqi,
            max(m.value) FILTER (WHERE (m.measure_code = 'IPAQ_MET_MIN'::text)) AS ipaq_met_min,
            max(m.value) FILTER (WHERE (m.measure_code = 'MEDAS_NORMALIZED'::text)) AS medas,
            max(m.value) FILTER (WHERE (m.measure_code = 'FACIT_SP_TOTAL'::text)) AS facit_sp,
            max(m.value) FILTER (WHERE (m.measure_code = 'STEPS_MEAN'::text)) AS steps_mean,
            max(m.value) FILTER (WHERE (m.measure_code = 'RESTING_HR_MEAN'::text)) AS resting_hr_mean,
            max(m.value) FILTER (WHERE (m.measure_code = 'WELLBEING_INDEX_MEAN'::text)) AS wellbeing_index_mean
           FROM m
          GROUP BY m.participant_key, m.phase_key
        )
 SELECT p.participant_key,
    p.phase_key,
    p.weight_kg,
    p.bmi,
    p.body_fat_pct,
    p.waist_cm,
    p.hip_cm,
    p.arm_flexed_cm,
    p.thigh_cm,
    p.calf_cm,
    p.waist_height_ratio,
    p.fms_total,
    p.grip_dominant_kg,
    p.grip_relative,
    p.sit_reach_cm,
    p.squat_1rm_rel,
    p.bench_1rm_rel,
    p.pss10,
    p.ghq12,
    p.mspss,
    p.srpb,
    p.srpb_meaning,
    p.who5,
    p.psqi,
    p.ipaq_met_min,
    p.medas,
    p.facit_sp,
    p.steps_mean,
    p.resting_hr_mean,
    p.wellbeing_index_mean,
    dp.research_code,
    dp.setting,
    dp.age_group,
    dp.sex_for_reference,
    dp.cohort,
    w.phase_code,
    w.phase_order,
    w.window_start,
    w.window_end,
    adh.missions_assigned,
    adh.missions_completed,
    round(((adh.missions_completed)::numeric / (NULLIF(adh.missions_assigned, 0))::numeric), 3) AS adherence_rate,
    adh.recovery_missions_completed,
    wb.days_checked_in,
    wb.mean_sleep_hours,
    wb.mean_daily_stress,
    round(((wb.recovery_days)::numeric / (NULLIF(wb.days_checked_in, 0))::numeric), 3) AS recovery_day_share,
    lo.lore_entries,
    lo.mean_coherence,
    gu.guild_contribution_total,
    rf.red_flag_events
   FROM (((((((pivot p
     JOIN analytics.dim_participant dp USING (participant_key))
     JOIN analytics.v_phase_window w USING (participant_key, phase_key))
     LEFT JOIN LATERAL ( SELECT sum(a.assigned_count) AS missions_assigned,
            sum(a.completed_count) AS missions_completed,
            sum(a.completed_count) FILTER (WHERE (mi.category = ANY (ARRAY['RECOVERY'::text, 'MINDFULNESS'::text]))) AS recovery_missions_completed
           FROM ((analytics.fact_mission_adherence a
             JOIN analytics.dim_date d USING (date_key))
             JOIN analytics.dim_mission mi USING (mission_key))
          WHERE ((a.participant_key = p.participant_key) AND (d.full_date > w.window_start) AND (d.full_date <= w.window_end))) adh ON (true))
     LEFT JOIN LATERAL ( SELECT count(*) AS days_checked_in,
            round(avg(f.sleep_hours), 2) AS mean_sleep_hours,
            round(avg(f.perceived_stress), 2) AS mean_daily_stress,
            count(*) FILTER (WHERE (b.band_code = 'RECOVERY'::text)) AS recovery_days
           FROM ((analytics.fact_daily_wellbeing f
             JOIN analytics.dim_date d USING (date_key))
             LEFT JOIN analytics.dim_readiness_band b USING (band_key))
          WHERE ((f.participant_key = p.participant_key) AND (d.full_date > w.window_start) AND (d.full_date <= w.window_end))) wb ON (true))
     LEFT JOIN LATERAL ( SELECT count(*) AS lore_entries,
            round(avg(l.coherence_rating), 2) AS mean_coherence
           FROM (analytics.fact_lore_reflection l
             JOIN analytics.dim_date d USING (date_key))
          WHERE ((l.participant_key = p.participant_key) AND (d.full_date > w.window_start) AND (d.full_date <= w.window_end))) lo ON (true))
     LEFT JOIN LATERAL ( SELECT sum(g.value) AS guild_contribution_total
           FROM (analytics.fact_guild_contribution g
             JOIN analytics.dim_date d USING (date_key))
          WHERE ((g.participant_key = p.participant_key) AND (d.full_date > w.window_start) AND (d.full_date <= w.window_end))) gu ON (true))
     LEFT JOIN LATERAL ( SELECT count(*) AS red_flag_events
           FROM (analytics.fact_red_flag_event r
             JOIN analytics.dim_date d USING (date_key))
          WHERE ((r.participant_key = p.participant_key) AND (r.level = ANY (ARRAY['ELEVATED'::text, 'CRISIS'::text])) AND (d.full_date > w.window_start) AND (d.full_date <= w.window_end))) rf ON (true))
  WITH NO DATA;


--
-- Name: v_adherence_by_band; Type: VIEW; Schema: analytics; Owner: -
--

CREATE VIEW analytics.v_adherence_by_band AS
 SELECT dp.setting,
    dp.age_group,
    b.band_code,
    mi.category,
    count(*) AS missions_assigned,
    sum(a.completed_count) AS missions_completed,
    round(avg(a.completed_count), 3) AS completion_rate,
    round(avg(a.adapted_count), 3) AS adaptation_rate,
    round(avg(a.reported_rpe), 2) AS mean_reported_rpe
   FROM (((analytics.fact_mission_adherence a
     JOIN analytics.dim_participant dp USING (participant_key))
     JOIN analytics.dim_readiness_band b USING (band_key))
     JOIN analytics.dim_mission mi USING (mission_key))
  GROUP BY dp.setting, dp.age_group, b.band_code, mi.category;


--
-- Name: v_change_from_baseline; Type: VIEW; Schema: analytics; Owner: -
--

CREATE VIEW analytics.v_change_from_baseline AS
 WITH base AS (
         SELECT f_1.participant_key,
            f_1.measure_key,
            f_1.value AS baseline_value
           FROM (analytics.fact_assessment_measure f_1
             JOIN analytics.dim_phase ph_1 USING (phase_key))
          WHERE ((ph_1.phase_code = 'BASELINE'::text) AND f_1.is_valid)
        ), base_sd AS (
         SELECT base.measure_key,
            stddev_samp(base.baseline_value) AS sd
           FROM base
          GROUP BY base.measure_key
        )
 SELECT dp.research_code,
    dp.setting,
    dp.age_group,
    dp.sex_for_reference,
    dm.measure_code,
    dm.name_es,
    dm.unit,
    di.health_domain,
    dm.capacity,
    ph.phase_code,
    ph.phase_order,
    b.baseline_value,
    f.value AS phase_value,
    (f.value - b.baseline_value) AS abs_change,
    round((((100)::numeric * (f.value - b.baseline_value)) / NULLIF(b.baseline_value, (0)::numeric)), 2) AS pct_change,
        CASE
            WHEN (dm.improvement_direction <> 0) THEN ((dm.improvement_direction)::numeric * (f.value - b.baseline_value))
            ELSE NULL::numeric
        END AS oriented_change,
    round(((f.value - b.baseline_value) / NULLIF(sd.sd, (0)::numeric)), 3) AS standardized_change,
        CASE
            WHEN (dm.mdc IS NOT NULL) THEN (abs((f.value - b.baseline_value)) >= dm.mdc)
            ELSE NULL::boolean
        END AS exceeds_mdc
   FROM ((((((analytics.fact_assessment_measure f
     JOIN base b USING (participant_key, measure_key))
     JOIN base_sd sd USING (measure_key))
     JOIN analytics.dim_participant dp USING (participant_key))
     JOIN analytics.dim_measure dm USING (measure_key))
     JOIN analytics.dim_instrument di USING (instrument_key))
     JOIN analytics.dim_phase ph USING (phase_key))
  WHERE (f.is_valid AND (ph.phase_code <> 'BASELINE'::text));


--
-- Name: v_measure_reliability; Type: VIEW; Schema: analytics; Owner: -
--

CREATE VIEW analytics.v_measure_reliability AS
 SELECT dm.measure_code,
    dm.unit,
    count(*) AS n_baseline,
    round(avg(f.value), 3) AS baseline_mean,
    round(stddev_samp(f.value), 3) AS baseline_sd,
    dm.mdc,
    dm.mdc_source
   FROM ((analytics.fact_assessment_measure f
     JOIN analytics.dim_measure dm USING (measure_key))
     JOIN analytics.dim_phase ph USING (phase_key))
  WHERE ((ph.phase_code = 'BASELINE'::text) AND f.is_valid)
  GROUP BY dm.measure_code, dm.unit, dm.mdc, dm.mdc_source;


--
-- Name: v_safety_monitoring; Type: VIEW; Schema: analytics; Owner: -
--

CREATE VIEW analytics.v_safety_monitoring AS
 SELECT d.year,
    d.month,
    dp.setting,
    r.level,
    count(*) AS events,
    round(avg(r.hours_to_professional_contact), 1) AS mean_hours_to_contact,
    round((percentile_cont((0.9)::double precision) WITHIN GROUP (ORDER BY ((r.hours_to_professional_contact)::double precision)))::numeric, 1) AS p90_hours_to_contact,
    count(*) FILTER (WHERE ((r.hours_to_professional_contact IS NULL) AND (NOT r.resolved))) AS open_without_contact
   FROM ((analytics.fact_red_flag_event r
     JOIN analytics.dim_date d USING (date_key))
     JOIN analytics.dim_participant dp USING (participant_key))
  GROUP BY d.year, d.month, dp.setting, r.level;


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Name: anamneses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.anamneses (
    id text NOT NULL,
    "userId" text NOT NULL,
    phase public."AssessmentPhase" DEFAULT 'BASELINE'::public."AssessmentPhase" NOT NULL,
    "recordedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "sleepHoursNight" numeric(3,1) NOT NULL,
    "sleepQuality" integer,
    "perceivedStress" integer NOT NULL,
    "waterIntakeLiters" numeric(3,1),
    "trainingExperience" public."TrainingExperience" NOT NULL,
    "trainingMonths" integer,
    "weeklyFrequency" integer NOT NULL,
    "avgSessionMinutes" integer NOT NULL,
    "preferredModalities" public."TrainingModality"[],
    "perceivedBarriers" text[],
    "smokingStatus" public."SmokingStatus" DEFAULT 'UNDISCLOSED'::public."SmokingStatus" NOT NULL,
    "sittingHoursPerDay" numeric(3,1),
    "screenMinutesBeforeBed" integer
);


--
-- Name: anthropometric_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.anthropometric_records (
    id text NOT NULL,
    "assessmentId" text NOT NULL,
    "heightCm" numeric(5,1) NOT NULL,
    "weightKg" numeric(5,2) NOT NULL,
    "bodyFatPct" numeric(4,1),
    "bodyFatMethod" public."BodyFatMethod",
    "equationName" text
);


--
-- Name: assessments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessments (
    id text NOT NULL,
    "userId" text NOT NULL,
    "evaluatorId" text,
    phase public."AssessmentPhase" NOT NULL,
    "assessedAt" timestamp(3) without time zone NOT NULL,
    location text,
    source public."MeasurementSource" DEFAULT 'EVALUATOR'::public."MeasurementSource" NOT NULL,
    "protocolVersion" text NOT NULL,
    conditions jsonb DEFAULT '{}'::jsonb NOT NULL,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: clinical_exports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clinical_exports (
    id text NOT NULL,
    "userId" text NOT NULL,
    format public."ExportFormat" NOT NULL,
    "requestedBy" text NOT NULL,
    recipient text,
    "periodFrom" date NOT NULL,
    "periodTo" date NOT NULL,
    sha256 text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: clinical_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clinical_histories (
    id text NOT NULL,
    "userId" text NOT NULL,
    "medicalConditions" text[],
    medications text[],
    "surgicalHistory" text[],
    "notesCiphertext" text,
    "foodAversions" text[],
    "usesHormonalContraception" boolean,
    "requiresMedicalClearance" boolean DEFAULT false NOT NULL,
    "clearanceGrantedAt" timestamp(3) without time zone,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: daily_check_ins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_check_ins (
    id text NOT NULL,
    "userId" text NOT NULL,
    date date NOT NULL,
    "sleepHours" numeric(3,1) NOT NULL,
    "sleepQuality" integer,
    "perceivedStress" integer NOT NULL,
    "mentalFatigue" integer,
    "physicalFatigue" integer,
    "painLevel" integer,
    "painRegion" text,
    mood integer,
    "feelsIsolated" boolean,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: daily_missions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_missions (
    id text NOT NULL,
    "planId" text NOT NULL,
    "templateId" text NOT NULL,
    slot public."MissionSlot" NOT NULL,
    status public."MissionStatus" DEFAULT 'ASSIGNED'::public."MissionStatus" NOT NULL,
    "startedAt" timestamp(3) without time zone,
    "completedAt" timestamp(3) without time zone,
    "reportedRpe" integer,
    "actualMinutes" integer,
    "xpAwarded" integer DEFAULT 0 NOT NULL,
    "adaptationNote" text
);


--
-- Name: daily_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_plans (
    id text NOT NULL,
    "userId" text NOT NULL,
    date date NOT NULL,
    "checkInId" text,
    band public."ReadinessBand" NOT NULL,
    "loadScore" numeric(4,1) NOT NULL,
    "rpeCap" integer NOT NULL,
    "blockedIntensities" public."MissionIntensity"[],
    "reasonCodes" text[],
    "safetyFlags" text[],
    "algorithmVersion" text NOT NULL,
    "inputSnapshot" jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: dynamometry_tests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dynamometry_tests (
    id text NOT NULL,
    "assessmentId" text NOT NULL,
    hand public."Hand" NOT NULL,
    "isDominant" boolean NOT NULL,
    "trialsKg" numeric(4,1)[],
    "bestKg" numeric(4,1) NOT NULL,
    device text,
    protocol text DEFAULT 'Southampton'::text NOT NULL
);


--
-- Name: flexibility_tests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flexibility_tests (
    id text NOT NULL,
    "assessmentId" text NOT NULL,
    "testName" text DEFAULT 'WELLS_DILLON'::text NOT NULL,
    "trialsCm" numeric(4,1)[],
    "bestCm" numeric(4,1) NOT NULL,
    "footLineAtCm" numeric(4,1) NOT NULL
);


--
-- Name: fms_pattern_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fms_pattern_scores (
    id text NOT NULL,
    "screenId" text NOT NULL,
    pattern public."FmsPattern" NOT NULL,
    "leftScore" integer,
    "rightScore" integer,
    "singleScore" integer,
    "clearingTestPain" boolean DEFAULT false NOT NULL,
    "finalScore" integer NOT NULL
);


--
-- Name: fms_screens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fms_screens (
    id text NOT NULL,
    "assessmentId" text NOT NULL,
    "totalScore" integer NOT NULL,
    "hasAsymmetry" boolean NOT NULL,
    "hasPain" boolean NOT NULL,
    "scoringVersion" text NOT NULL
);


--
-- Name: guild_encouragements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guild_encouragements (
    id text NOT NULL,
    "guildId" text NOT NULL,
    "senderId" text NOT NULL,
    "recipientId" text,
    "messageCode" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: guild_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guild_memberships (
    id text NOT NULL,
    "guildId" text NOT NULL,
    "userId" text NOT NULL,
    role public."GuildRole" DEFAULT 'MEMBER'::public."GuildRole" NOT NULL,
    "matchSnapshot" jsonb,
    alias text,
    "joinedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "leftAt" timestamp(3) without time zone
);


--
-- Name: guild_quest_contributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guild_quest_contributions (
    id text NOT NULL,
    "questId" text NOT NULL,
    "membershipId" text NOT NULL,
    value integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: guild_quests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guild_quests (
    id text NOT NULL,
    "guildId" text NOT NULL,
    title text NOT NULL,
    metric text NOT NULL,
    "targetValue" integer NOT NULL,
    "startsAt" timestamp(3) without time zone NOT NULL,
    "endsAt" timestamp(3) without time zone NOT NULL,
    "completedAt" timestamp(3) without time zone
);


--
-- Name: guilds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guilds (
    id text NOT NULL,
    name text NOT NULL,
    type public."GuildType" NOT NULL,
    setting public."ImplementationSetting" NOT NULL,
    description text,
    "anonymousByDefault" boolean DEFAULT false NOT NULL,
    "municipalityCode" character varying(5),
    "maxMembers" integer DEFAULT 12 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: injury_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.injury_records (
    id text NOT NULL,
    "userId" text NOT NULL,
    region public."BodyRegion" NOT NULL,
    side public."BodySide" DEFAULT 'NOT_APPLICABLE'::public."BodySide" NOT NULL,
    status public."InjuryStatus" NOT NULL,
    "occurredYear" integer,
    "hadSurgery" boolean DEFAULT false NOT NULL,
    "currentPain" integer,
    "reportedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: lore_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lore_entries (
    id text NOT NULL,
    "userId" text NOT NULL,
    "dailyMissionId" text,
    moment public."LoreMoment" NOT NULL,
    "promptCode" text NOT NULL,
    "purposeTheme" public."PurposeTheme" NOT NULL,
    "contentCiphertext" text,
    "hasGratitude" boolean DEFAULT false NOT NULL,
    "achievementRef" text,
    orientation public."SpiritualOrientation",
    "coherenceRating" integer NOT NULL,
    "strengthsUsed" public."ViaStrength"[],
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: mission_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mission_templates (
    id text NOT NULL,
    code text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    category public."MissionCategory" NOT NULL,
    intensity public."MissionIntensity" NOT NULL,
    "durationMinutes" integer NOT NULL,
    "capacityXp" jsonb NOT NULL,
    "loadedPatterns" public."FmsPattern"[],
    "minAgeYears" integer,
    "maxAgeYears" integer,
    contraindications text,
    active boolean DEFAULT true NOT NULL,
    version integer DEFAULT 1 NOT NULL
);


--
-- Name: passive_daily_summaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.passive_daily_summaries (
    id text NOT NULL,
    "userId" text NOT NULL,
    date date NOT NULL,
    metric public."PassiveMetric" NOT NULL,
    value numeric(8,2) NOT NULL,
    "sampleCount" integer NOT NULL,
    platform public."PassivePlatform" NOT NULL,
    "deviceModel" text,
    "syncedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: perimeter_measurements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.perimeter_measurements (
    id text NOT NULL,
    "assessmentId" text NOT NULL,
    site public."PerimeterSite" NOT NULL,
    side public."BodySide" DEFAULT 'NOT_APPLICABLE'::public."BodySide" NOT NULL,
    "trialsCm" numeric(5,1)[],
    "valueCm" numeric(5,1) NOT NULL
);


--
-- Name: player_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.player_profiles (
    id text NOT NULL,
    "userId" text NOT NULL,
    "displayName" text NOT NULL,
    archetype public."AvatarArchetype" NOT NULL,
    "avatarConfig" jsonb DEFAULT '{}'::jsonb NOT NULL,
    "birthYear" integer NOT NULL,
    "sexForReference" public."SexForReference" DEFAULT 'UNDISCLOSED'::public."SexForReference" NOT NULL,
    "genderIdentity" text,
    setting public."ImplementationSetting" NOT NULL,
    "municipalityCode" character varying(5),
    "purposeStatement" text,
    "spiritualOrientation" public."SpiritualOrientation" DEFAULT 'SECULAR_PURPOSE'::public."SpiritualOrientation" NOT NULL,
    "totalXp" integer DEFAULT 0 NOT NULL,
    "playerLevel" integer DEFAULT 1 NOT NULL,
    "coherenceStreak" integer DEFAULT 0 NOT NULL,
    "graceDaysAvailable" integer DEFAULT 2 NOT NULL,
    "onboardingCompletedAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: player_strengths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.player_strengths (
    id text NOT NULL,
    "userId" text NOT NULL,
    strength public."ViaStrength" NOT NULL,
    "fromVia" boolean DEFAULT false NOT NULL,
    "equippedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: profile_side_quests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profile_side_quests (
    id text NOT NULL,
    "userId" text NOT NULL,
    key public."ProfileSideQuestKey" NOT NULL,
    "completedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "xpAwarded" integer DEFAULT 0 NOT NULL
);


--
-- Name: questionnaire_administrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questionnaire_administrations (
    id text NOT NULL,
    "userId" text NOT NULL,
    "assessmentId" text,
    phase public."AssessmentPhase",
    instrument public."Instrument" NOT NULL,
    "instrumentVersion" text NOT NULL,
    language text DEFAULT 'es-CO'::text NOT NULL,
    "itemResponses" jsonb NOT NULL,
    "totalScore" numeric(6,2),
    "subscaleScores" jsonb,
    "scoringMethod" text NOT NULL,
    "scoringVersion" text NOT NULL,
    "startedAt" timestamp(3) without time zone,
    "completedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: red_flag_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.red_flag_events (
    id text NOT NULL,
    "userId" text NOT NULL,
    "openedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    level public."RedFlagLevel" NOT NULL,
    triggers text[],
    "gamificationMode" public."GamificationMode" NOT NULL,
    "protocolVersion" text NOT NULL,
    "careTeamNotifiedAt" timestamp(3) without time zone,
    "professionalContactAt" timestamp(3) without time zone,
    "followUpNotesCiphertext" text,
    "resolvedAt" timestamp(3) without time zone,
    resolution text
);


--
-- Name: reference_norms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reference_norms (
    id text NOT NULL,
    "measureCode" text NOT NULL,
    sex text NOT NULL,
    "ageMin" integer NOT NULL,
    "ageMax" integer NOT NULL,
    method jsonb NOT NULL,
    citation text NOT NULL,
    population text NOT NULL,
    "loadedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: research_consents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.research_consents (
    id text NOT NULL,
    "userId" text NOT NULL,
    scope public."ConsentScope" NOT NULL,
    "documentVersion" text NOT NULL,
    "acceptedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "revokedAt" timestamp(3) without time zone,
    "guardianConsentAt" timestamp(3) without time zone,
    "allowsCareTeamAlerts" boolean DEFAULT true NOT NULL,
    "allowsClinicalExport" boolean DEFAULT false NOT NULL,
    "allowsPassiveData" boolean DEFAULT false NOT NULL
);


--
-- Name: skill_progress; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skill_progress (
    id text NOT NULL,
    "userId" text NOT NULL,
    capacity public."FunctionalCapacity" NOT NULL,
    xp integer DEFAULT 0 NOT NULL,
    level integer DEFAULT 1 NOT NULL,
    "evaluatedMilestones" integer DEFAULT 0 NOT NULL,
    "lastMilestoneAt" timestamp(3) without time zone
);


--
-- Name: strength_tests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strength_tests (
    id text NOT NULL,
    "assessmentId" text NOT NULL,
    exercise public."StrengthExercise" NOT NULL,
    protocol public."StrengthTestProtocol" NOT NULL,
    "loadKg" numeric(5,1) NOT NULL,
    reps integer NOT NULL,
    formula public."OneRmFormula" DEFAULT 'NONE'::public."OneRmFormula" NOT NULL,
    "estimated1RmKg" numeric(5,1) NOT NULL,
    rpe numeric(3,1),
    "techniqueValid" boolean DEFAULT true NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text NOT NULL,
    role public."UserRole" DEFAULT 'PARTICIPANT'::public."UserRole" NOT NULL,
    "researchCode" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: via_strength_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.via_strength_scores (
    id text NOT NULL,
    "administrationId" text NOT NULL,
    strength public."ViaStrength" NOT NULL,
    score numeric(3,2) NOT NULL,
    rank integer NOT NULL
);


--
-- Name: wellbeing_index_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wellbeing_index_snapshots (
    id text NOT NULL,
    "userId" text NOT NULL,
    date date NOT NULL,
    index integer,
    status text NOT NULL,
    "mindScore" numeric(4,1),
    "bodyScore" numeric(4,1),
    "restorationScore" numeric(4,1),
    "lifestyleScore" numeric(4,1),
    "purposeScore" numeric(4,1),
    breakdown jsonb NOT NULL,
    confidence numeric(3,2) NOT NULL,
    "selfReportReliability" numeric(3,2) NOT NULL,
    "consistencyFlags" text[],
    version text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: xp_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.xp_events (
    id text NOT NULL,
    "userId" text NOT NULL,
    source public."XpSource" NOT NULL,
    "sourceId" text,
    capacity public."FunctionalCapacity",
    amount integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: dim_guild guild_key; Type: DEFAULT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_guild ALTER COLUMN guild_key SET DEFAULT nextval('analytics.dim_guild_guild_key_seq'::regclass);


--
-- Name: dim_measure measure_key; Type: DEFAULT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_measure ALTER COLUMN measure_key SET DEFAULT nextval('analytics.dim_measure_measure_key_seq'::regclass);


--
-- Name: dim_mission mission_key; Type: DEFAULT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_mission ALTER COLUMN mission_key SET DEFAULT nextval('analytics.dim_mission_mission_key_seq'::regclass);


--
-- Name: dim_participant participant_key; Type: DEFAULT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_participant ALTER COLUMN participant_key SET DEFAULT nextval('analytics.dim_participant_participant_key_seq'::regclass);


--
-- Data for Name: dim_date; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.dim_date (date_key, full_date, year, quarter, month, iso_week, iso_dow, is_weekend, academic_term) FROM stdin;
20240101	2024-01-01	2024	1	1	1	1	f	2024-1
20240102	2024-01-02	2024	1	1	1	2	f	2024-1
20240103	2024-01-03	2024	1	1	1	3	f	2024-1
20240104	2024-01-04	2024	1	1	1	4	f	2024-1
20240105	2024-01-05	2024	1	1	1	5	f	2024-1
20240106	2024-01-06	2024	1	1	1	6	t	2024-1
20240107	2024-01-07	2024	1	1	1	7	t	2024-1
20240108	2024-01-08	2024	1	1	2	1	f	2024-1
20240109	2024-01-09	2024	1	1	2	2	f	2024-1
20240110	2024-01-10	2024	1	1	2	3	f	2024-1
20240111	2024-01-11	2024	1	1	2	4	f	2024-1
20240112	2024-01-12	2024	1	1	2	5	f	2024-1
20240113	2024-01-13	2024	1	1	2	6	t	2024-1
20240114	2024-01-14	2024	1	1	2	7	t	2024-1
20240115	2024-01-15	2024	1	1	3	1	f	2024-1
20240116	2024-01-16	2024	1	1	3	2	f	2024-1
20240117	2024-01-17	2024	1	1	3	3	f	2024-1
20240118	2024-01-18	2024	1	1	3	4	f	2024-1
20240119	2024-01-19	2024	1	1	3	5	f	2024-1
20240120	2024-01-20	2024	1	1	3	6	t	2024-1
20240121	2024-01-21	2024	1	1	3	7	t	2024-1
20240122	2024-01-22	2024	1	1	4	1	f	2024-1
20240123	2024-01-23	2024	1	1	4	2	f	2024-1
20240124	2024-01-24	2024	1	1	4	3	f	2024-1
20240125	2024-01-25	2024	1	1	4	4	f	2024-1
20240126	2024-01-26	2024	1	1	4	5	f	2024-1
20240127	2024-01-27	2024	1	1	4	6	t	2024-1
20240128	2024-01-28	2024	1	1	4	7	t	2024-1
20240129	2024-01-29	2024	1	1	5	1	f	2024-1
20240130	2024-01-30	2024	1	1	5	2	f	2024-1
20240131	2024-01-31	2024	1	1	5	3	f	2024-1
20240201	2024-02-01	2024	1	2	5	4	f	2024-1
20240202	2024-02-02	2024	1	2	5	5	f	2024-1
20240203	2024-02-03	2024	1	2	5	6	t	2024-1
20240204	2024-02-04	2024	1	2	5	7	t	2024-1
20240205	2024-02-05	2024	1	2	6	1	f	2024-1
20240206	2024-02-06	2024	1	2	6	2	f	2024-1
20240207	2024-02-07	2024	1	2	6	3	f	2024-1
20240208	2024-02-08	2024	1	2	6	4	f	2024-1
20240209	2024-02-09	2024	1	2	6	5	f	2024-1
20240210	2024-02-10	2024	1	2	6	6	t	2024-1
20240211	2024-02-11	2024	1	2	6	7	t	2024-1
20240212	2024-02-12	2024	1	2	7	1	f	2024-1
20240213	2024-02-13	2024	1	2	7	2	f	2024-1
20240214	2024-02-14	2024	1	2	7	3	f	2024-1
20240215	2024-02-15	2024	1	2	7	4	f	2024-1
20240216	2024-02-16	2024	1	2	7	5	f	2024-1
20240217	2024-02-17	2024	1	2	7	6	t	2024-1
20240218	2024-02-18	2024	1	2	7	7	t	2024-1
20240219	2024-02-19	2024	1	2	8	1	f	2024-1
20240220	2024-02-20	2024	1	2	8	2	f	2024-1
20240221	2024-02-21	2024	1	2	8	3	f	2024-1
20240222	2024-02-22	2024	1	2	8	4	f	2024-1
20240223	2024-02-23	2024	1	2	8	5	f	2024-1
20240224	2024-02-24	2024	1	2	8	6	t	2024-1
20240225	2024-02-25	2024	1	2	8	7	t	2024-1
20240226	2024-02-26	2024	1	2	9	1	f	2024-1
20240227	2024-02-27	2024	1	2	9	2	f	2024-1
20240228	2024-02-28	2024	1	2	9	3	f	2024-1
20240229	2024-02-29	2024	1	2	9	4	f	2024-1
20240301	2024-03-01	2024	1	3	9	5	f	2024-1
20240302	2024-03-02	2024	1	3	9	6	t	2024-1
20240303	2024-03-03	2024	1	3	9	7	t	2024-1
20240304	2024-03-04	2024	1	3	10	1	f	2024-1
20240305	2024-03-05	2024	1	3	10	2	f	2024-1
20240306	2024-03-06	2024	1	3	10	3	f	2024-1
20240307	2024-03-07	2024	1	3	10	4	f	2024-1
20240308	2024-03-08	2024	1	3	10	5	f	2024-1
20240309	2024-03-09	2024	1	3	10	6	t	2024-1
20240310	2024-03-10	2024	1	3	10	7	t	2024-1
20240311	2024-03-11	2024	1	3	11	1	f	2024-1
20240312	2024-03-12	2024	1	3	11	2	f	2024-1
20240313	2024-03-13	2024	1	3	11	3	f	2024-1
20240314	2024-03-14	2024	1	3	11	4	f	2024-1
20240315	2024-03-15	2024	1	3	11	5	f	2024-1
20240316	2024-03-16	2024	1	3	11	6	t	2024-1
20240317	2024-03-17	2024	1	3	11	7	t	2024-1
20240318	2024-03-18	2024	1	3	12	1	f	2024-1
20240319	2024-03-19	2024	1	3	12	2	f	2024-1
20240320	2024-03-20	2024	1	3	12	3	f	2024-1
20240321	2024-03-21	2024	1	3	12	4	f	2024-1
20240322	2024-03-22	2024	1	3	12	5	f	2024-1
20240323	2024-03-23	2024	1	3	12	6	t	2024-1
20240324	2024-03-24	2024	1	3	12	7	t	2024-1
20240325	2024-03-25	2024	1	3	13	1	f	2024-1
20240326	2024-03-26	2024	1	3	13	2	f	2024-1
20240327	2024-03-27	2024	1	3	13	3	f	2024-1
20240328	2024-03-28	2024	1	3	13	4	f	2024-1
20240329	2024-03-29	2024	1	3	13	5	f	2024-1
20240330	2024-03-30	2024	1	3	13	6	t	2024-1
20240331	2024-03-31	2024	1	3	13	7	t	2024-1
20240401	2024-04-01	2024	2	4	14	1	f	2024-1
20240402	2024-04-02	2024	2	4	14	2	f	2024-1
20240403	2024-04-03	2024	2	4	14	3	f	2024-1
20240404	2024-04-04	2024	2	4	14	4	f	2024-1
20240405	2024-04-05	2024	2	4	14	5	f	2024-1
20240406	2024-04-06	2024	2	4	14	6	t	2024-1
20240407	2024-04-07	2024	2	4	14	7	t	2024-1
20240408	2024-04-08	2024	2	4	15	1	f	2024-1
20240409	2024-04-09	2024	2	4	15	2	f	2024-1
20240410	2024-04-10	2024	2	4	15	3	f	2024-1
20240411	2024-04-11	2024	2	4	15	4	f	2024-1
20240412	2024-04-12	2024	2	4	15	5	f	2024-1
20240413	2024-04-13	2024	2	4	15	6	t	2024-1
20240414	2024-04-14	2024	2	4	15	7	t	2024-1
20240415	2024-04-15	2024	2	4	16	1	f	2024-1
20240416	2024-04-16	2024	2	4	16	2	f	2024-1
20240417	2024-04-17	2024	2	4	16	3	f	2024-1
20240418	2024-04-18	2024	2	4	16	4	f	2024-1
20240419	2024-04-19	2024	2	4	16	5	f	2024-1
20240420	2024-04-20	2024	2	4	16	6	t	2024-1
20240421	2024-04-21	2024	2	4	16	7	t	2024-1
20240422	2024-04-22	2024	2	4	17	1	f	2024-1
20240423	2024-04-23	2024	2	4	17	2	f	2024-1
20240424	2024-04-24	2024	2	4	17	3	f	2024-1
20240425	2024-04-25	2024	2	4	17	4	f	2024-1
20240426	2024-04-26	2024	2	4	17	5	f	2024-1
20240427	2024-04-27	2024	2	4	17	6	t	2024-1
20240428	2024-04-28	2024	2	4	17	7	t	2024-1
20240429	2024-04-29	2024	2	4	18	1	f	2024-1
20240430	2024-04-30	2024	2	4	18	2	f	2024-1
20240501	2024-05-01	2024	2	5	18	3	f	2024-1
20240502	2024-05-02	2024	2	5	18	4	f	2024-1
20240503	2024-05-03	2024	2	5	18	5	f	2024-1
20240504	2024-05-04	2024	2	5	18	6	t	2024-1
20240505	2024-05-05	2024	2	5	18	7	t	2024-1
20240506	2024-05-06	2024	2	5	19	1	f	2024-1
20240507	2024-05-07	2024	2	5	19	2	f	2024-1
20240508	2024-05-08	2024	2	5	19	3	f	2024-1
20240509	2024-05-09	2024	2	5	19	4	f	2024-1
20240510	2024-05-10	2024	2	5	19	5	f	2024-1
20240511	2024-05-11	2024	2	5	19	6	t	2024-1
20240512	2024-05-12	2024	2	5	19	7	t	2024-1
20240513	2024-05-13	2024	2	5	20	1	f	2024-1
20240514	2024-05-14	2024	2	5	20	2	f	2024-1
20240515	2024-05-15	2024	2	5	20	3	f	2024-1
20240516	2024-05-16	2024	2	5	20	4	f	2024-1
20240517	2024-05-17	2024	2	5	20	5	f	2024-1
20240518	2024-05-18	2024	2	5	20	6	t	2024-1
20240519	2024-05-19	2024	2	5	20	7	t	2024-1
20240520	2024-05-20	2024	2	5	21	1	f	2024-1
20240521	2024-05-21	2024	2	5	21	2	f	2024-1
20240522	2024-05-22	2024	2	5	21	3	f	2024-1
20240523	2024-05-23	2024	2	5	21	4	f	2024-1
20240524	2024-05-24	2024	2	5	21	5	f	2024-1
20240525	2024-05-25	2024	2	5	21	6	t	2024-1
20240526	2024-05-26	2024	2	5	21	7	t	2024-1
20240527	2024-05-27	2024	2	5	22	1	f	2024-1
20240528	2024-05-28	2024	2	5	22	2	f	2024-1
20240529	2024-05-29	2024	2	5	22	3	f	2024-1
20240530	2024-05-30	2024	2	5	22	4	f	2024-1
20240531	2024-05-31	2024	2	5	22	5	f	2024-1
20240601	2024-06-01	2024	2	6	22	6	t	2024-1
20240602	2024-06-02	2024	2	6	22	7	t	2024-1
20240603	2024-06-03	2024	2	6	23	1	f	2024-1
20240604	2024-06-04	2024	2	6	23	2	f	2024-1
20240605	2024-06-05	2024	2	6	23	3	f	2024-1
20240606	2024-06-06	2024	2	6	23	4	f	2024-1
20240607	2024-06-07	2024	2	6	23	5	f	2024-1
20240608	2024-06-08	2024	2	6	23	6	t	2024-1
20240609	2024-06-09	2024	2	6	23	7	t	2024-1
20240610	2024-06-10	2024	2	6	24	1	f	2024-1
20240611	2024-06-11	2024	2	6	24	2	f	2024-1
20240612	2024-06-12	2024	2	6	24	3	f	2024-1
20240613	2024-06-13	2024	2	6	24	4	f	2024-1
20240614	2024-06-14	2024	2	6	24	5	f	2024-1
20240615	2024-06-15	2024	2	6	24	6	t	2024-1
20240616	2024-06-16	2024	2	6	24	7	t	2024-1
20240617	2024-06-17	2024	2	6	25	1	f	2024-1
20240618	2024-06-18	2024	2	6	25	2	f	2024-1
20240619	2024-06-19	2024	2	6	25	3	f	2024-1
20240620	2024-06-20	2024	2	6	25	4	f	2024-1
20240621	2024-06-21	2024	2	6	25	5	f	2024-1
20240622	2024-06-22	2024	2	6	25	6	t	2024-1
20240623	2024-06-23	2024	2	6	25	7	t	2024-1
20240624	2024-06-24	2024	2	6	26	1	f	2024-1
20240625	2024-06-25	2024	2	6	26	2	f	2024-1
20240626	2024-06-26	2024	2	6	26	3	f	2024-1
20240627	2024-06-27	2024	2	6	26	4	f	2024-1
20240628	2024-06-28	2024	2	6	26	5	f	2024-1
20240629	2024-06-29	2024	2	6	26	6	t	2024-1
20240630	2024-06-30	2024	2	6	26	7	t	2024-1
20240701	2024-07-01	2024	3	7	27	1	f	2024-2
20240702	2024-07-02	2024	3	7	27	2	f	2024-2
20240703	2024-07-03	2024	3	7	27	3	f	2024-2
20240704	2024-07-04	2024	3	7	27	4	f	2024-2
20240705	2024-07-05	2024	3	7	27	5	f	2024-2
20240706	2024-07-06	2024	3	7	27	6	t	2024-2
20240707	2024-07-07	2024	3	7	27	7	t	2024-2
20240708	2024-07-08	2024	3	7	28	1	f	2024-2
20240709	2024-07-09	2024	3	7	28	2	f	2024-2
20240710	2024-07-10	2024	3	7	28	3	f	2024-2
20240711	2024-07-11	2024	3	7	28	4	f	2024-2
20240712	2024-07-12	2024	3	7	28	5	f	2024-2
20240713	2024-07-13	2024	3	7	28	6	t	2024-2
20240714	2024-07-14	2024	3	7	28	7	t	2024-2
20240715	2024-07-15	2024	3	7	29	1	f	2024-2
20240716	2024-07-16	2024	3	7	29	2	f	2024-2
20240717	2024-07-17	2024	3	7	29	3	f	2024-2
20240718	2024-07-18	2024	3	7	29	4	f	2024-2
20240719	2024-07-19	2024	3	7	29	5	f	2024-2
20240720	2024-07-20	2024	3	7	29	6	t	2024-2
20240721	2024-07-21	2024	3	7	29	7	t	2024-2
20240722	2024-07-22	2024	3	7	30	1	f	2024-2
20240723	2024-07-23	2024	3	7	30	2	f	2024-2
20240724	2024-07-24	2024	3	7	30	3	f	2024-2
20240725	2024-07-25	2024	3	7	30	4	f	2024-2
20240726	2024-07-26	2024	3	7	30	5	f	2024-2
20240727	2024-07-27	2024	3	7	30	6	t	2024-2
20240728	2024-07-28	2024	3	7	30	7	t	2024-2
20240729	2024-07-29	2024	3	7	31	1	f	2024-2
20240730	2024-07-30	2024	3	7	31	2	f	2024-2
20240731	2024-07-31	2024	3	7	31	3	f	2024-2
20240801	2024-08-01	2024	3	8	31	4	f	2024-2
20240802	2024-08-02	2024	3	8	31	5	f	2024-2
20240803	2024-08-03	2024	3	8	31	6	t	2024-2
20240804	2024-08-04	2024	3	8	31	7	t	2024-2
20240805	2024-08-05	2024	3	8	32	1	f	2024-2
20240806	2024-08-06	2024	3	8	32	2	f	2024-2
20240807	2024-08-07	2024	3	8	32	3	f	2024-2
20240808	2024-08-08	2024	3	8	32	4	f	2024-2
20240809	2024-08-09	2024	3	8	32	5	f	2024-2
20240810	2024-08-10	2024	3	8	32	6	t	2024-2
20240811	2024-08-11	2024	3	8	32	7	t	2024-2
20240812	2024-08-12	2024	3	8	33	1	f	2024-2
20240813	2024-08-13	2024	3	8	33	2	f	2024-2
20240814	2024-08-14	2024	3	8	33	3	f	2024-2
20240815	2024-08-15	2024	3	8	33	4	f	2024-2
20240816	2024-08-16	2024	3	8	33	5	f	2024-2
20240817	2024-08-17	2024	3	8	33	6	t	2024-2
20240818	2024-08-18	2024	3	8	33	7	t	2024-2
20240819	2024-08-19	2024	3	8	34	1	f	2024-2
20240820	2024-08-20	2024	3	8	34	2	f	2024-2
20240821	2024-08-21	2024	3	8	34	3	f	2024-2
20240822	2024-08-22	2024	3	8	34	4	f	2024-2
20240823	2024-08-23	2024	3	8	34	5	f	2024-2
20240824	2024-08-24	2024	3	8	34	6	t	2024-2
20240825	2024-08-25	2024	3	8	34	7	t	2024-2
20240826	2024-08-26	2024	3	8	35	1	f	2024-2
20240827	2024-08-27	2024	3	8	35	2	f	2024-2
20240828	2024-08-28	2024	3	8	35	3	f	2024-2
20240829	2024-08-29	2024	3	8	35	4	f	2024-2
20240830	2024-08-30	2024	3	8	35	5	f	2024-2
20240831	2024-08-31	2024	3	8	35	6	t	2024-2
20240901	2024-09-01	2024	3	9	35	7	t	2024-2
20240902	2024-09-02	2024	3	9	36	1	f	2024-2
20240903	2024-09-03	2024	3	9	36	2	f	2024-2
20240904	2024-09-04	2024	3	9	36	3	f	2024-2
20240905	2024-09-05	2024	3	9	36	4	f	2024-2
20240906	2024-09-06	2024	3	9	36	5	f	2024-2
20240907	2024-09-07	2024	3	9	36	6	t	2024-2
20240908	2024-09-08	2024	3	9	36	7	t	2024-2
20240909	2024-09-09	2024	3	9	37	1	f	2024-2
20240910	2024-09-10	2024	3	9	37	2	f	2024-2
20240911	2024-09-11	2024	3	9	37	3	f	2024-2
20240912	2024-09-12	2024	3	9	37	4	f	2024-2
20240913	2024-09-13	2024	3	9	37	5	f	2024-2
20240914	2024-09-14	2024	3	9	37	6	t	2024-2
20240915	2024-09-15	2024	3	9	37	7	t	2024-2
20240916	2024-09-16	2024	3	9	38	1	f	2024-2
20240917	2024-09-17	2024	3	9	38	2	f	2024-2
20240918	2024-09-18	2024	3	9	38	3	f	2024-2
20240919	2024-09-19	2024	3	9	38	4	f	2024-2
20240920	2024-09-20	2024	3	9	38	5	f	2024-2
20240921	2024-09-21	2024	3	9	38	6	t	2024-2
20240922	2024-09-22	2024	3	9	38	7	t	2024-2
20240923	2024-09-23	2024	3	9	39	1	f	2024-2
20240924	2024-09-24	2024	3	9	39	2	f	2024-2
20240925	2024-09-25	2024	3	9	39	3	f	2024-2
20240926	2024-09-26	2024	3	9	39	4	f	2024-2
20240927	2024-09-27	2024	3	9	39	5	f	2024-2
20240928	2024-09-28	2024	3	9	39	6	t	2024-2
20240929	2024-09-29	2024	3	9	39	7	t	2024-2
20240930	2024-09-30	2024	3	9	40	1	f	2024-2
20241001	2024-10-01	2024	4	10	40	2	f	2024-2
20241002	2024-10-02	2024	4	10	40	3	f	2024-2
20241003	2024-10-03	2024	4	10	40	4	f	2024-2
20241004	2024-10-04	2024	4	10	40	5	f	2024-2
20241005	2024-10-05	2024	4	10	40	6	t	2024-2
20241006	2024-10-06	2024	4	10	40	7	t	2024-2
20241007	2024-10-07	2024	4	10	41	1	f	2024-2
20241008	2024-10-08	2024	4	10	41	2	f	2024-2
20241009	2024-10-09	2024	4	10	41	3	f	2024-2
20241010	2024-10-10	2024	4	10	41	4	f	2024-2
20241011	2024-10-11	2024	4	10	41	5	f	2024-2
20241012	2024-10-12	2024	4	10	41	6	t	2024-2
20241013	2024-10-13	2024	4	10	41	7	t	2024-2
20241014	2024-10-14	2024	4	10	42	1	f	2024-2
20241015	2024-10-15	2024	4	10	42	2	f	2024-2
20241016	2024-10-16	2024	4	10	42	3	f	2024-2
20241017	2024-10-17	2024	4	10	42	4	f	2024-2
20241018	2024-10-18	2024	4	10	42	5	f	2024-2
20241019	2024-10-19	2024	4	10	42	6	t	2024-2
20241020	2024-10-20	2024	4	10	42	7	t	2024-2
20241021	2024-10-21	2024	4	10	43	1	f	2024-2
20241022	2024-10-22	2024	4	10	43	2	f	2024-2
20241023	2024-10-23	2024	4	10	43	3	f	2024-2
20241024	2024-10-24	2024	4	10	43	4	f	2024-2
20241025	2024-10-25	2024	4	10	43	5	f	2024-2
20241026	2024-10-26	2024	4	10	43	6	t	2024-2
20241027	2024-10-27	2024	4	10	43	7	t	2024-2
20241028	2024-10-28	2024	4	10	44	1	f	2024-2
20241029	2024-10-29	2024	4	10	44	2	f	2024-2
20241030	2024-10-30	2024	4	10	44	3	f	2024-2
20241031	2024-10-31	2024	4	10	44	4	f	2024-2
20241101	2024-11-01	2024	4	11	44	5	f	2024-2
20241102	2024-11-02	2024	4	11	44	6	t	2024-2
20241103	2024-11-03	2024	4	11	44	7	t	2024-2
20241104	2024-11-04	2024	4	11	45	1	f	2024-2
20241105	2024-11-05	2024	4	11	45	2	f	2024-2
20241106	2024-11-06	2024	4	11	45	3	f	2024-2
20241107	2024-11-07	2024	4	11	45	4	f	2024-2
20241108	2024-11-08	2024	4	11	45	5	f	2024-2
20241109	2024-11-09	2024	4	11	45	6	t	2024-2
20241110	2024-11-10	2024	4	11	45	7	t	2024-2
20241111	2024-11-11	2024	4	11	46	1	f	2024-2
20241112	2024-11-12	2024	4	11	46	2	f	2024-2
20241113	2024-11-13	2024	4	11	46	3	f	2024-2
20241114	2024-11-14	2024	4	11	46	4	f	2024-2
20241115	2024-11-15	2024	4	11	46	5	f	2024-2
20241116	2024-11-16	2024	4	11	46	6	t	2024-2
20241117	2024-11-17	2024	4	11	46	7	t	2024-2
20241118	2024-11-18	2024	4	11	47	1	f	2024-2
20241119	2024-11-19	2024	4	11	47	2	f	2024-2
20241120	2024-11-20	2024	4	11	47	3	f	2024-2
20241121	2024-11-21	2024	4	11	47	4	f	2024-2
20241122	2024-11-22	2024	4	11	47	5	f	2024-2
20241123	2024-11-23	2024	4	11	47	6	t	2024-2
20241124	2024-11-24	2024	4	11	47	7	t	2024-2
20241125	2024-11-25	2024	4	11	48	1	f	2024-2
20241126	2024-11-26	2024	4	11	48	2	f	2024-2
20241127	2024-11-27	2024	4	11	48	3	f	2024-2
20241128	2024-11-28	2024	4	11	48	4	f	2024-2
20241129	2024-11-29	2024	4	11	48	5	f	2024-2
20241130	2024-11-30	2024	4	11	48	6	t	2024-2
20241201	2024-12-01	2024	4	12	48	7	t	2024-2
20241202	2024-12-02	2024	4	12	49	1	f	2024-2
20241203	2024-12-03	2024	4	12	49	2	f	2024-2
20241204	2024-12-04	2024	4	12	49	3	f	2024-2
20241205	2024-12-05	2024	4	12	49	4	f	2024-2
20241206	2024-12-06	2024	4	12	49	5	f	2024-2
20241207	2024-12-07	2024	4	12	49	6	t	2024-2
20241208	2024-12-08	2024	4	12	49	7	t	2024-2
20241209	2024-12-09	2024	4	12	50	1	f	2024-2
20241210	2024-12-10	2024	4	12	50	2	f	2024-2
20241211	2024-12-11	2024	4	12	50	3	f	2024-2
20241212	2024-12-12	2024	4	12	50	4	f	2024-2
20241213	2024-12-13	2024	4	12	50	5	f	2024-2
20241214	2024-12-14	2024	4	12	50	6	t	2024-2
20241215	2024-12-15	2024	4	12	50	7	t	2024-2
20241216	2024-12-16	2024	4	12	51	1	f	2024-2
20241217	2024-12-17	2024	4	12	51	2	f	2024-2
20241218	2024-12-18	2024	4	12	51	3	f	2024-2
20241219	2024-12-19	2024	4	12	51	4	f	2024-2
20241220	2024-12-20	2024	4	12	51	5	f	2024-2
20241221	2024-12-21	2024	4	12	51	6	t	2024-2
20241222	2024-12-22	2024	4	12	51	7	t	2024-2
20241223	2024-12-23	2024	4	12	52	1	f	2024-2
20241224	2024-12-24	2024	4	12	52	2	f	2024-2
20241225	2024-12-25	2024	4	12	52	3	f	2024-2
20241226	2024-12-26	2024	4	12	52	4	f	2024-2
20241227	2024-12-27	2024	4	12	52	5	f	2024-2
20241228	2024-12-28	2024	4	12	52	6	t	2024-2
20241229	2024-12-29	2024	4	12	52	7	t	2024-2
20241230	2024-12-30	2024	4	12	1	1	f	2024-2
20241231	2024-12-31	2024	4	12	1	2	f	2024-2
20250101	2025-01-01	2025	1	1	1	3	f	2025-1
20250102	2025-01-02	2025	1	1	1	4	f	2025-1
20250103	2025-01-03	2025	1	1	1	5	f	2025-1
20250104	2025-01-04	2025	1	1	1	6	t	2025-1
20250105	2025-01-05	2025	1	1	1	7	t	2025-1
20250106	2025-01-06	2025	1	1	2	1	f	2025-1
20250107	2025-01-07	2025	1	1	2	2	f	2025-1
20250108	2025-01-08	2025	1	1	2	3	f	2025-1
20250109	2025-01-09	2025	1	1	2	4	f	2025-1
20250110	2025-01-10	2025	1	1	2	5	f	2025-1
20250111	2025-01-11	2025	1	1	2	6	t	2025-1
20250112	2025-01-12	2025	1	1	2	7	t	2025-1
20250113	2025-01-13	2025	1	1	3	1	f	2025-1
20250114	2025-01-14	2025	1	1	3	2	f	2025-1
20250115	2025-01-15	2025	1	1	3	3	f	2025-1
20250116	2025-01-16	2025	1	1	3	4	f	2025-1
20250117	2025-01-17	2025	1	1	3	5	f	2025-1
20250118	2025-01-18	2025	1	1	3	6	t	2025-1
20250119	2025-01-19	2025	1	1	3	7	t	2025-1
20250120	2025-01-20	2025	1	1	4	1	f	2025-1
20250121	2025-01-21	2025	1	1	4	2	f	2025-1
20250122	2025-01-22	2025	1	1	4	3	f	2025-1
20250123	2025-01-23	2025	1	1	4	4	f	2025-1
20250124	2025-01-24	2025	1	1	4	5	f	2025-1
20250125	2025-01-25	2025	1	1	4	6	t	2025-1
20250126	2025-01-26	2025	1	1	4	7	t	2025-1
20250127	2025-01-27	2025	1	1	5	1	f	2025-1
20250128	2025-01-28	2025	1	1	5	2	f	2025-1
20250129	2025-01-29	2025	1	1	5	3	f	2025-1
20250130	2025-01-30	2025	1	1	5	4	f	2025-1
20250131	2025-01-31	2025	1	1	5	5	f	2025-1
20250201	2025-02-01	2025	1	2	5	6	t	2025-1
20250202	2025-02-02	2025	1	2	5	7	t	2025-1
20250203	2025-02-03	2025	1	2	6	1	f	2025-1
20250204	2025-02-04	2025	1	2	6	2	f	2025-1
20250205	2025-02-05	2025	1	2	6	3	f	2025-1
20250206	2025-02-06	2025	1	2	6	4	f	2025-1
20250207	2025-02-07	2025	1	2	6	5	f	2025-1
20250208	2025-02-08	2025	1	2	6	6	t	2025-1
20250209	2025-02-09	2025	1	2	6	7	t	2025-1
20250210	2025-02-10	2025	1	2	7	1	f	2025-1
20250211	2025-02-11	2025	1	2	7	2	f	2025-1
20250212	2025-02-12	2025	1	2	7	3	f	2025-1
20250213	2025-02-13	2025	1	2	7	4	f	2025-1
20250214	2025-02-14	2025	1	2	7	5	f	2025-1
20250215	2025-02-15	2025	1	2	7	6	t	2025-1
20250216	2025-02-16	2025	1	2	7	7	t	2025-1
20250217	2025-02-17	2025	1	2	8	1	f	2025-1
20250218	2025-02-18	2025	1	2	8	2	f	2025-1
20250219	2025-02-19	2025	1	2	8	3	f	2025-1
20250220	2025-02-20	2025	1	2	8	4	f	2025-1
20250221	2025-02-21	2025	1	2	8	5	f	2025-1
20250222	2025-02-22	2025	1	2	8	6	t	2025-1
20250223	2025-02-23	2025	1	2	8	7	t	2025-1
20250224	2025-02-24	2025	1	2	9	1	f	2025-1
20250225	2025-02-25	2025	1	2	9	2	f	2025-1
20250226	2025-02-26	2025	1	2	9	3	f	2025-1
20250227	2025-02-27	2025	1	2	9	4	f	2025-1
20250228	2025-02-28	2025	1	2	9	5	f	2025-1
20250301	2025-03-01	2025	1	3	9	6	t	2025-1
20250302	2025-03-02	2025	1	3	9	7	t	2025-1
20250303	2025-03-03	2025	1	3	10	1	f	2025-1
20250304	2025-03-04	2025	1	3	10	2	f	2025-1
20250305	2025-03-05	2025	1	3	10	3	f	2025-1
20250306	2025-03-06	2025	1	3	10	4	f	2025-1
20250307	2025-03-07	2025	1	3	10	5	f	2025-1
20250308	2025-03-08	2025	1	3	10	6	t	2025-1
20250309	2025-03-09	2025	1	3	10	7	t	2025-1
20250310	2025-03-10	2025	1	3	11	1	f	2025-1
20250311	2025-03-11	2025	1	3	11	2	f	2025-1
20250312	2025-03-12	2025	1	3	11	3	f	2025-1
20250313	2025-03-13	2025	1	3	11	4	f	2025-1
20250314	2025-03-14	2025	1	3	11	5	f	2025-1
20250315	2025-03-15	2025	1	3	11	6	t	2025-1
20250316	2025-03-16	2025	1	3	11	7	t	2025-1
20250317	2025-03-17	2025	1	3	12	1	f	2025-1
20250318	2025-03-18	2025	1	3	12	2	f	2025-1
20250319	2025-03-19	2025	1	3	12	3	f	2025-1
20250320	2025-03-20	2025	1	3	12	4	f	2025-1
20250321	2025-03-21	2025	1	3	12	5	f	2025-1
20250322	2025-03-22	2025	1	3	12	6	t	2025-1
20250323	2025-03-23	2025	1	3	12	7	t	2025-1
20250324	2025-03-24	2025	1	3	13	1	f	2025-1
20250325	2025-03-25	2025	1	3	13	2	f	2025-1
20250326	2025-03-26	2025	1	3	13	3	f	2025-1
20250327	2025-03-27	2025	1	3	13	4	f	2025-1
20250328	2025-03-28	2025	1	3	13	5	f	2025-1
20250329	2025-03-29	2025	1	3	13	6	t	2025-1
20250330	2025-03-30	2025	1	3	13	7	t	2025-1
20250331	2025-03-31	2025	1	3	14	1	f	2025-1
20250401	2025-04-01	2025	2	4	14	2	f	2025-1
20250402	2025-04-02	2025	2	4	14	3	f	2025-1
20250403	2025-04-03	2025	2	4	14	4	f	2025-1
20250404	2025-04-04	2025	2	4	14	5	f	2025-1
20250405	2025-04-05	2025	2	4	14	6	t	2025-1
20250406	2025-04-06	2025	2	4	14	7	t	2025-1
20250407	2025-04-07	2025	2	4	15	1	f	2025-1
20250408	2025-04-08	2025	2	4	15	2	f	2025-1
20250409	2025-04-09	2025	2	4	15	3	f	2025-1
20250410	2025-04-10	2025	2	4	15	4	f	2025-1
20250411	2025-04-11	2025	2	4	15	5	f	2025-1
20250412	2025-04-12	2025	2	4	15	6	t	2025-1
20250413	2025-04-13	2025	2	4	15	7	t	2025-1
20250414	2025-04-14	2025	2	4	16	1	f	2025-1
20250415	2025-04-15	2025	2	4	16	2	f	2025-1
20250416	2025-04-16	2025	2	4	16	3	f	2025-1
20250417	2025-04-17	2025	2	4	16	4	f	2025-1
20250418	2025-04-18	2025	2	4	16	5	f	2025-1
20250419	2025-04-19	2025	2	4	16	6	t	2025-1
20250420	2025-04-20	2025	2	4	16	7	t	2025-1
20250421	2025-04-21	2025	2	4	17	1	f	2025-1
20250422	2025-04-22	2025	2	4	17	2	f	2025-1
20250423	2025-04-23	2025	2	4	17	3	f	2025-1
20250424	2025-04-24	2025	2	4	17	4	f	2025-1
20250425	2025-04-25	2025	2	4	17	5	f	2025-1
20250426	2025-04-26	2025	2	4	17	6	t	2025-1
20250427	2025-04-27	2025	2	4	17	7	t	2025-1
20250428	2025-04-28	2025	2	4	18	1	f	2025-1
20250429	2025-04-29	2025	2	4	18	2	f	2025-1
20250430	2025-04-30	2025	2	4	18	3	f	2025-1
20250501	2025-05-01	2025	2	5	18	4	f	2025-1
20250502	2025-05-02	2025	2	5	18	5	f	2025-1
20250503	2025-05-03	2025	2	5	18	6	t	2025-1
20250504	2025-05-04	2025	2	5	18	7	t	2025-1
20250505	2025-05-05	2025	2	5	19	1	f	2025-1
20250506	2025-05-06	2025	2	5	19	2	f	2025-1
20250507	2025-05-07	2025	2	5	19	3	f	2025-1
20250508	2025-05-08	2025	2	5	19	4	f	2025-1
20250509	2025-05-09	2025	2	5	19	5	f	2025-1
20250510	2025-05-10	2025	2	5	19	6	t	2025-1
20250511	2025-05-11	2025	2	5	19	7	t	2025-1
20250512	2025-05-12	2025	2	5	20	1	f	2025-1
20250513	2025-05-13	2025	2	5	20	2	f	2025-1
20250514	2025-05-14	2025	2	5	20	3	f	2025-1
20250515	2025-05-15	2025	2	5	20	4	f	2025-1
20250516	2025-05-16	2025	2	5	20	5	f	2025-1
20250517	2025-05-17	2025	2	5	20	6	t	2025-1
20250518	2025-05-18	2025	2	5	20	7	t	2025-1
20250519	2025-05-19	2025	2	5	21	1	f	2025-1
20250520	2025-05-20	2025	2	5	21	2	f	2025-1
20250521	2025-05-21	2025	2	5	21	3	f	2025-1
20250522	2025-05-22	2025	2	5	21	4	f	2025-1
20250523	2025-05-23	2025	2	5	21	5	f	2025-1
20250524	2025-05-24	2025	2	5	21	6	t	2025-1
20250525	2025-05-25	2025	2	5	21	7	t	2025-1
20250526	2025-05-26	2025	2	5	22	1	f	2025-1
20250527	2025-05-27	2025	2	5	22	2	f	2025-1
20250528	2025-05-28	2025	2	5	22	3	f	2025-1
20250529	2025-05-29	2025	2	5	22	4	f	2025-1
20250530	2025-05-30	2025	2	5	22	5	f	2025-1
20250531	2025-05-31	2025	2	5	22	6	t	2025-1
20250601	2025-06-01	2025	2	6	22	7	t	2025-1
20250602	2025-06-02	2025	2	6	23	1	f	2025-1
20250603	2025-06-03	2025	2	6	23	2	f	2025-1
20250604	2025-06-04	2025	2	6	23	3	f	2025-1
20250605	2025-06-05	2025	2	6	23	4	f	2025-1
20250606	2025-06-06	2025	2	6	23	5	f	2025-1
20250607	2025-06-07	2025	2	6	23	6	t	2025-1
20250608	2025-06-08	2025	2	6	23	7	t	2025-1
20250609	2025-06-09	2025	2	6	24	1	f	2025-1
20250610	2025-06-10	2025	2	6	24	2	f	2025-1
20250611	2025-06-11	2025	2	6	24	3	f	2025-1
20250612	2025-06-12	2025	2	6	24	4	f	2025-1
20250613	2025-06-13	2025	2	6	24	5	f	2025-1
20250614	2025-06-14	2025	2	6	24	6	t	2025-1
20250615	2025-06-15	2025	2	6	24	7	t	2025-1
20250616	2025-06-16	2025	2	6	25	1	f	2025-1
20250617	2025-06-17	2025	2	6	25	2	f	2025-1
20250618	2025-06-18	2025	2	6	25	3	f	2025-1
20250619	2025-06-19	2025	2	6	25	4	f	2025-1
20250620	2025-06-20	2025	2	6	25	5	f	2025-1
20250621	2025-06-21	2025	2	6	25	6	t	2025-1
20250622	2025-06-22	2025	2	6	25	7	t	2025-1
20250623	2025-06-23	2025	2	6	26	1	f	2025-1
20250624	2025-06-24	2025	2	6	26	2	f	2025-1
20250625	2025-06-25	2025	2	6	26	3	f	2025-1
20250626	2025-06-26	2025	2	6	26	4	f	2025-1
20250627	2025-06-27	2025	2	6	26	5	f	2025-1
20250628	2025-06-28	2025	2	6	26	6	t	2025-1
20250629	2025-06-29	2025	2	6	26	7	t	2025-1
20250630	2025-06-30	2025	2	6	27	1	f	2025-1
20250701	2025-07-01	2025	3	7	27	2	f	2025-2
20250702	2025-07-02	2025	3	7	27	3	f	2025-2
20250703	2025-07-03	2025	3	7	27	4	f	2025-2
20250704	2025-07-04	2025	3	7	27	5	f	2025-2
20250705	2025-07-05	2025	3	7	27	6	t	2025-2
20250706	2025-07-06	2025	3	7	27	7	t	2025-2
20250707	2025-07-07	2025	3	7	28	1	f	2025-2
20250708	2025-07-08	2025	3	7	28	2	f	2025-2
20250709	2025-07-09	2025	3	7	28	3	f	2025-2
20250710	2025-07-10	2025	3	7	28	4	f	2025-2
20250711	2025-07-11	2025	3	7	28	5	f	2025-2
20250712	2025-07-12	2025	3	7	28	6	t	2025-2
20250713	2025-07-13	2025	3	7	28	7	t	2025-2
20250714	2025-07-14	2025	3	7	29	1	f	2025-2
20250715	2025-07-15	2025	3	7	29	2	f	2025-2
20250716	2025-07-16	2025	3	7	29	3	f	2025-2
20250717	2025-07-17	2025	3	7	29	4	f	2025-2
20250718	2025-07-18	2025	3	7	29	5	f	2025-2
20250719	2025-07-19	2025	3	7	29	6	t	2025-2
20250720	2025-07-20	2025	3	7	29	7	t	2025-2
20250721	2025-07-21	2025	3	7	30	1	f	2025-2
20250722	2025-07-22	2025	3	7	30	2	f	2025-2
20250723	2025-07-23	2025	3	7	30	3	f	2025-2
20250724	2025-07-24	2025	3	7	30	4	f	2025-2
20250725	2025-07-25	2025	3	7	30	5	f	2025-2
20250726	2025-07-26	2025	3	7	30	6	t	2025-2
20250727	2025-07-27	2025	3	7	30	7	t	2025-2
20250728	2025-07-28	2025	3	7	31	1	f	2025-2
20250729	2025-07-29	2025	3	7	31	2	f	2025-2
20250730	2025-07-30	2025	3	7	31	3	f	2025-2
20250731	2025-07-31	2025	3	7	31	4	f	2025-2
20250801	2025-08-01	2025	3	8	31	5	f	2025-2
20250802	2025-08-02	2025	3	8	31	6	t	2025-2
20250803	2025-08-03	2025	3	8	31	7	t	2025-2
20250804	2025-08-04	2025	3	8	32	1	f	2025-2
20250805	2025-08-05	2025	3	8	32	2	f	2025-2
20250806	2025-08-06	2025	3	8	32	3	f	2025-2
20250807	2025-08-07	2025	3	8	32	4	f	2025-2
20250808	2025-08-08	2025	3	8	32	5	f	2025-2
20250809	2025-08-09	2025	3	8	32	6	t	2025-2
20250810	2025-08-10	2025	3	8	32	7	t	2025-2
20250811	2025-08-11	2025	3	8	33	1	f	2025-2
20250812	2025-08-12	2025	3	8	33	2	f	2025-2
20250813	2025-08-13	2025	3	8	33	3	f	2025-2
20250814	2025-08-14	2025	3	8	33	4	f	2025-2
20250815	2025-08-15	2025	3	8	33	5	f	2025-2
20250816	2025-08-16	2025	3	8	33	6	t	2025-2
20250817	2025-08-17	2025	3	8	33	7	t	2025-2
20250818	2025-08-18	2025	3	8	34	1	f	2025-2
20250819	2025-08-19	2025	3	8	34	2	f	2025-2
20250820	2025-08-20	2025	3	8	34	3	f	2025-2
20250821	2025-08-21	2025	3	8	34	4	f	2025-2
20250822	2025-08-22	2025	3	8	34	5	f	2025-2
20250823	2025-08-23	2025	3	8	34	6	t	2025-2
20250824	2025-08-24	2025	3	8	34	7	t	2025-2
20250825	2025-08-25	2025	3	8	35	1	f	2025-2
20250826	2025-08-26	2025	3	8	35	2	f	2025-2
20250827	2025-08-27	2025	3	8	35	3	f	2025-2
20250828	2025-08-28	2025	3	8	35	4	f	2025-2
20250829	2025-08-29	2025	3	8	35	5	f	2025-2
20250830	2025-08-30	2025	3	8	35	6	t	2025-2
20250831	2025-08-31	2025	3	8	35	7	t	2025-2
20250901	2025-09-01	2025	3	9	36	1	f	2025-2
20250902	2025-09-02	2025	3	9	36	2	f	2025-2
20250903	2025-09-03	2025	3	9	36	3	f	2025-2
20250904	2025-09-04	2025	3	9	36	4	f	2025-2
20250905	2025-09-05	2025	3	9	36	5	f	2025-2
20250906	2025-09-06	2025	3	9	36	6	t	2025-2
20250907	2025-09-07	2025	3	9	36	7	t	2025-2
20250908	2025-09-08	2025	3	9	37	1	f	2025-2
20250909	2025-09-09	2025	3	9	37	2	f	2025-2
20250910	2025-09-10	2025	3	9	37	3	f	2025-2
20250911	2025-09-11	2025	3	9	37	4	f	2025-2
20250912	2025-09-12	2025	3	9	37	5	f	2025-2
20250913	2025-09-13	2025	3	9	37	6	t	2025-2
20250914	2025-09-14	2025	3	9	37	7	t	2025-2
20250915	2025-09-15	2025	3	9	38	1	f	2025-2
20250916	2025-09-16	2025	3	9	38	2	f	2025-2
20250917	2025-09-17	2025	3	9	38	3	f	2025-2
20250918	2025-09-18	2025	3	9	38	4	f	2025-2
20250919	2025-09-19	2025	3	9	38	5	f	2025-2
20250920	2025-09-20	2025	3	9	38	6	t	2025-2
20250921	2025-09-21	2025	3	9	38	7	t	2025-2
20250922	2025-09-22	2025	3	9	39	1	f	2025-2
20250923	2025-09-23	2025	3	9	39	2	f	2025-2
20250924	2025-09-24	2025	3	9	39	3	f	2025-2
20250925	2025-09-25	2025	3	9	39	4	f	2025-2
20250926	2025-09-26	2025	3	9	39	5	f	2025-2
20250927	2025-09-27	2025	3	9	39	6	t	2025-2
20250928	2025-09-28	2025	3	9	39	7	t	2025-2
20250929	2025-09-29	2025	3	9	40	1	f	2025-2
20250930	2025-09-30	2025	3	9	40	2	f	2025-2
20251001	2025-10-01	2025	4	10	40	3	f	2025-2
20251002	2025-10-02	2025	4	10	40	4	f	2025-2
20251003	2025-10-03	2025	4	10	40	5	f	2025-2
20251004	2025-10-04	2025	4	10	40	6	t	2025-2
20251005	2025-10-05	2025	4	10	40	7	t	2025-2
20251006	2025-10-06	2025	4	10	41	1	f	2025-2
20251007	2025-10-07	2025	4	10	41	2	f	2025-2
20251008	2025-10-08	2025	4	10	41	3	f	2025-2
20251009	2025-10-09	2025	4	10	41	4	f	2025-2
20251010	2025-10-10	2025	4	10	41	5	f	2025-2
20251011	2025-10-11	2025	4	10	41	6	t	2025-2
20251012	2025-10-12	2025	4	10	41	7	t	2025-2
20251013	2025-10-13	2025	4	10	42	1	f	2025-2
20251014	2025-10-14	2025	4	10	42	2	f	2025-2
20251015	2025-10-15	2025	4	10	42	3	f	2025-2
20251016	2025-10-16	2025	4	10	42	4	f	2025-2
20251017	2025-10-17	2025	4	10	42	5	f	2025-2
20251018	2025-10-18	2025	4	10	42	6	t	2025-2
20251019	2025-10-19	2025	4	10	42	7	t	2025-2
20251020	2025-10-20	2025	4	10	43	1	f	2025-2
20251021	2025-10-21	2025	4	10	43	2	f	2025-2
20251022	2025-10-22	2025	4	10	43	3	f	2025-2
20251023	2025-10-23	2025	4	10	43	4	f	2025-2
20251024	2025-10-24	2025	4	10	43	5	f	2025-2
20251025	2025-10-25	2025	4	10	43	6	t	2025-2
20251026	2025-10-26	2025	4	10	43	7	t	2025-2
20251027	2025-10-27	2025	4	10	44	1	f	2025-2
20251028	2025-10-28	2025	4	10	44	2	f	2025-2
20251029	2025-10-29	2025	4	10	44	3	f	2025-2
20251030	2025-10-30	2025	4	10	44	4	f	2025-2
20251031	2025-10-31	2025	4	10	44	5	f	2025-2
20251101	2025-11-01	2025	4	11	44	6	t	2025-2
20251102	2025-11-02	2025	4	11	44	7	t	2025-2
20251103	2025-11-03	2025	4	11	45	1	f	2025-2
20251104	2025-11-04	2025	4	11	45	2	f	2025-2
20251105	2025-11-05	2025	4	11	45	3	f	2025-2
20251106	2025-11-06	2025	4	11	45	4	f	2025-2
20251107	2025-11-07	2025	4	11	45	5	f	2025-2
20251108	2025-11-08	2025	4	11	45	6	t	2025-2
20251109	2025-11-09	2025	4	11	45	7	t	2025-2
20251110	2025-11-10	2025	4	11	46	1	f	2025-2
20251111	2025-11-11	2025	4	11	46	2	f	2025-2
20251112	2025-11-12	2025	4	11	46	3	f	2025-2
20251113	2025-11-13	2025	4	11	46	4	f	2025-2
20251114	2025-11-14	2025	4	11	46	5	f	2025-2
20251115	2025-11-15	2025	4	11	46	6	t	2025-2
20251116	2025-11-16	2025	4	11	46	7	t	2025-2
20251117	2025-11-17	2025	4	11	47	1	f	2025-2
20251118	2025-11-18	2025	4	11	47	2	f	2025-2
20251119	2025-11-19	2025	4	11	47	3	f	2025-2
20251120	2025-11-20	2025	4	11	47	4	f	2025-2
20251121	2025-11-21	2025	4	11	47	5	f	2025-2
20251122	2025-11-22	2025	4	11	47	6	t	2025-2
20251123	2025-11-23	2025	4	11	47	7	t	2025-2
20251124	2025-11-24	2025	4	11	48	1	f	2025-2
20251125	2025-11-25	2025	4	11	48	2	f	2025-2
20251126	2025-11-26	2025	4	11	48	3	f	2025-2
20251127	2025-11-27	2025	4	11	48	4	f	2025-2
20251128	2025-11-28	2025	4	11	48	5	f	2025-2
20251129	2025-11-29	2025	4	11	48	6	t	2025-2
20251130	2025-11-30	2025	4	11	48	7	t	2025-2
20251201	2025-12-01	2025	4	12	49	1	f	2025-2
20251202	2025-12-02	2025	4	12	49	2	f	2025-2
20251203	2025-12-03	2025	4	12	49	3	f	2025-2
20251204	2025-12-04	2025	4	12	49	4	f	2025-2
20251205	2025-12-05	2025	4	12	49	5	f	2025-2
20251206	2025-12-06	2025	4	12	49	6	t	2025-2
20251207	2025-12-07	2025	4	12	49	7	t	2025-2
20251208	2025-12-08	2025	4	12	50	1	f	2025-2
20251209	2025-12-09	2025	4	12	50	2	f	2025-2
20251210	2025-12-10	2025	4	12	50	3	f	2025-2
20251211	2025-12-11	2025	4	12	50	4	f	2025-2
20251212	2025-12-12	2025	4	12	50	5	f	2025-2
20251213	2025-12-13	2025	4	12	50	6	t	2025-2
20251214	2025-12-14	2025	4	12	50	7	t	2025-2
20251215	2025-12-15	2025	4	12	51	1	f	2025-2
20251216	2025-12-16	2025	4	12	51	2	f	2025-2
20251217	2025-12-17	2025	4	12	51	3	f	2025-2
20251218	2025-12-18	2025	4	12	51	4	f	2025-2
20251219	2025-12-19	2025	4	12	51	5	f	2025-2
20251220	2025-12-20	2025	4	12	51	6	t	2025-2
20251221	2025-12-21	2025	4	12	51	7	t	2025-2
20251222	2025-12-22	2025	4	12	52	1	f	2025-2
20251223	2025-12-23	2025	4	12	52	2	f	2025-2
20251224	2025-12-24	2025	4	12	52	3	f	2025-2
20251225	2025-12-25	2025	4	12	52	4	f	2025-2
20251226	2025-12-26	2025	4	12	52	5	f	2025-2
20251227	2025-12-27	2025	4	12	52	6	t	2025-2
20251228	2025-12-28	2025	4	12	52	7	t	2025-2
20251229	2025-12-29	2025	4	12	1	1	f	2025-2
20251230	2025-12-30	2025	4	12	1	2	f	2025-2
20251231	2025-12-31	2025	4	12	1	3	f	2025-2
20260101	2026-01-01	2026	1	1	1	4	f	2026-1
20260102	2026-01-02	2026	1	1	1	5	f	2026-1
20260103	2026-01-03	2026	1	1	1	6	t	2026-1
20260104	2026-01-04	2026	1	1	1	7	t	2026-1
20260105	2026-01-05	2026	1	1	2	1	f	2026-1
20260106	2026-01-06	2026	1	1	2	2	f	2026-1
20260107	2026-01-07	2026	1	1	2	3	f	2026-1
20260108	2026-01-08	2026	1	1	2	4	f	2026-1
20260109	2026-01-09	2026	1	1	2	5	f	2026-1
20260110	2026-01-10	2026	1	1	2	6	t	2026-1
20260111	2026-01-11	2026	1	1	2	7	t	2026-1
20260112	2026-01-12	2026	1	1	3	1	f	2026-1
20260113	2026-01-13	2026	1	1	3	2	f	2026-1
20260114	2026-01-14	2026	1	1	3	3	f	2026-1
20260115	2026-01-15	2026	1	1	3	4	f	2026-1
20260116	2026-01-16	2026	1	1	3	5	f	2026-1
20260117	2026-01-17	2026	1	1	3	6	t	2026-1
20260118	2026-01-18	2026	1	1	3	7	t	2026-1
20260119	2026-01-19	2026	1	1	4	1	f	2026-1
20260120	2026-01-20	2026	1	1	4	2	f	2026-1
20260121	2026-01-21	2026	1	1	4	3	f	2026-1
20260122	2026-01-22	2026	1	1	4	4	f	2026-1
20260123	2026-01-23	2026	1	1	4	5	f	2026-1
20260124	2026-01-24	2026	1	1	4	6	t	2026-1
20260125	2026-01-25	2026	1	1	4	7	t	2026-1
20260126	2026-01-26	2026	1	1	5	1	f	2026-1
20260127	2026-01-27	2026	1	1	5	2	f	2026-1
20260128	2026-01-28	2026	1	1	5	3	f	2026-1
20260129	2026-01-29	2026	1	1	5	4	f	2026-1
20260130	2026-01-30	2026	1	1	5	5	f	2026-1
20260131	2026-01-31	2026	1	1	5	6	t	2026-1
20260201	2026-02-01	2026	1	2	5	7	t	2026-1
20260202	2026-02-02	2026	1	2	6	1	f	2026-1
20260203	2026-02-03	2026	1	2	6	2	f	2026-1
20260204	2026-02-04	2026	1	2	6	3	f	2026-1
20260205	2026-02-05	2026	1	2	6	4	f	2026-1
20260206	2026-02-06	2026	1	2	6	5	f	2026-1
20260207	2026-02-07	2026	1	2	6	6	t	2026-1
20260208	2026-02-08	2026	1	2	6	7	t	2026-1
20260209	2026-02-09	2026	1	2	7	1	f	2026-1
20260210	2026-02-10	2026	1	2	7	2	f	2026-1
20260211	2026-02-11	2026	1	2	7	3	f	2026-1
20260212	2026-02-12	2026	1	2	7	4	f	2026-1
20260213	2026-02-13	2026	1	2	7	5	f	2026-1
20260214	2026-02-14	2026	1	2	7	6	t	2026-1
20260215	2026-02-15	2026	1	2	7	7	t	2026-1
20260216	2026-02-16	2026	1	2	8	1	f	2026-1
20260217	2026-02-17	2026	1	2	8	2	f	2026-1
20260218	2026-02-18	2026	1	2	8	3	f	2026-1
20260219	2026-02-19	2026	1	2	8	4	f	2026-1
20260220	2026-02-20	2026	1	2	8	5	f	2026-1
20260221	2026-02-21	2026	1	2	8	6	t	2026-1
20260222	2026-02-22	2026	1	2	8	7	t	2026-1
20260223	2026-02-23	2026	1	2	9	1	f	2026-1
20260224	2026-02-24	2026	1	2	9	2	f	2026-1
20260225	2026-02-25	2026	1	2	9	3	f	2026-1
20260226	2026-02-26	2026	1	2	9	4	f	2026-1
20260227	2026-02-27	2026	1	2	9	5	f	2026-1
20260228	2026-02-28	2026	1	2	9	6	t	2026-1
20260301	2026-03-01	2026	1	3	9	7	t	2026-1
20260302	2026-03-02	2026	1	3	10	1	f	2026-1
20260303	2026-03-03	2026	1	3	10	2	f	2026-1
20260304	2026-03-04	2026	1	3	10	3	f	2026-1
20260305	2026-03-05	2026	1	3	10	4	f	2026-1
20260306	2026-03-06	2026	1	3	10	5	f	2026-1
20260307	2026-03-07	2026	1	3	10	6	t	2026-1
20260308	2026-03-08	2026	1	3	10	7	t	2026-1
20260309	2026-03-09	2026	1	3	11	1	f	2026-1
20260310	2026-03-10	2026	1	3	11	2	f	2026-1
20260311	2026-03-11	2026	1	3	11	3	f	2026-1
20260312	2026-03-12	2026	1	3	11	4	f	2026-1
20260313	2026-03-13	2026	1	3	11	5	f	2026-1
20260314	2026-03-14	2026	1	3	11	6	t	2026-1
20260315	2026-03-15	2026	1	3	11	7	t	2026-1
20260316	2026-03-16	2026	1	3	12	1	f	2026-1
20260317	2026-03-17	2026	1	3	12	2	f	2026-1
20260318	2026-03-18	2026	1	3	12	3	f	2026-1
20260319	2026-03-19	2026	1	3	12	4	f	2026-1
20260320	2026-03-20	2026	1	3	12	5	f	2026-1
20260321	2026-03-21	2026	1	3	12	6	t	2026-1
20260322	2026-03-22	2026	1	3	12	7	t	2026-1
20260323	2026-03-23	2026	1	3	13	1	f	2026-1
20260324	2026-03-24	2026	1	3	13	2	f	2026-1
20260325	2026-03-25	2026	1	3	13	3	f	2026-1
20260326	2026-03-26	2026	1	3	13	4	f	2026-1
20260327	2026-03-27	2026	1	3	13	5	f	2026-1
20260328	2026-03-28	2026	1	3	13	6	t	2026-1
20260329	2026-03-29	2026	1	3	13	7	t	2026-1
20260330	2026-03-30	2026	1	3	14	1	f	2026-1
20260331	2026-03-31	2026	1	3	14	2	f	2026-1
20260401	2026-04-01	2026	2	4	14	3	f	2026-1
20260402	2026-04-02	2026	2	4	14	4	f	2026-1
20260403	2026-04-03	2026	2	4	14	5	f	2026-1
20260404	2026-04-04	2026	2	4	14	6	t	2026-1
20260405	2026-04-05	2026	2	4	14	7	t	2026-1
20260406	2026-04-06	2026	2	4	15	1	f	2026-1
20260407	2026-04-07	2026	2	4	15	2	f	2026-1
20260408	2026-04-08	2026	2	4	15	3	f	2026-1
20260409	2026-04-09	2026	2	4	15	4	f	2026-1
20260410	2026-04-10	2026	2	4	15	5	f	2026-1
20260411	2026-04-11	2026	2	4	15	6	t	2026-1
20260412	2026-04-12	2026	2	4	15	7	t	2026-1
20260413	2026-04-13	2026	2	4	16	1	f	2026-1
20260414	2026-04-14	2026	2	4	16	2	f	2026-1
20260415	2026-04-15	2026	2	4	16	3	f	2026-1
20260416	2026-04-16	2026	2	4	16	4	f	2026-1
20260417	2026-04-17	2026	2	4	16	5	f	2026-1
20260418	2026-04-18	2026	2	4	16	6	t	2026-1
20260419	2026-04-19	2026	2	4	16	7	t	2026-1
20260420	2026-04-20	2026	2	4	17	1	f	2026-1
20260421	2026-04-21	2026	2	4	17	2	f	2026-1
20260422	2026-04-22	2026	2	4	17	3	f	2026-1
20260423	2026-04-23	2026	2	4	17	4	f	2026-1
20260424	2026-04-24	2026	2	4	17	5	f	2026-1
20260425	2026-04-25	2026	2	4	17	6	t	2026-1
20260426	2026-04-26	2026	2	4	17	7	t	2026-1
20260427	2026-04-27	2026	2	4	18	1	f	2026-1
20260428	2026-04-28	2026	2	4	18	2	f	2026-1
20260429	2026-04-29	2026	2	4	18	3	f	2026-1
20260430	2026-04-30	2026	2	4	18	4	f	2026-1
20260501	2026-05-01	2026	2	5	18	5	f	2026-1
20260502	2026-05-02	2026	2	5	18	6	t	2026-1
20260503	2026-05-03	2026	2	5	18	7	t	2026-1
20260504	2026-05-04	2026	2	5	19	1	f	2026-1
20260505	2026-05-05	2026	2	5	19	2	f	2026-1
20260506	2026-05-06	2026	2	5	19	3	f	2026-1
20260507	2026-05-07	2026	2	5	19	4	f	2026-1
20260508	2026-05-08	2026	2	5	19	5	f	2026-1
20260509	2026-05-09	2026	2	5	19	6	t	2026-1
20260510	2026-05-10	2026	2	5	19	7	t	2026-1
20260511	2026-05-11	2026	2	5	20	1	f	2026-1
20260512	2026-05-12	2026	2	5	20	2	f	2026-1
20260513	2026-05-13	2026	2	5	20	3	f	2026-1
20260514	2026-05-14	2026	2	5	20	4	f	2026-1
20260515	2026-05-15	2026	2	5	20	5	f	2026-1
20260516	2026-05-16	2026	2	5	20	6	t	2026-1
20260517	2026-05-17	2026	2	5	20	7	t	2026-1
20260518	2026-05-18	2026	2	5	21	1	f	2026-1
20260519	2026-05-19	2026	2	5	21	2	f	2026-1
20260520	2026-05-20	2026	2	5	21	3	f	2026-1
20260521	2026-05-21	2026	2	5	21	4	f	2026-1
20260522	2026-05-22	2026	2	5	21	5	f	2026-1
20260523	2026-05-23	2026	2	5	21	6	t	2026-1
20260524	2026-05-24	2026	2	5	21	7	t	2026-1
20260525	2026-05-25	2026	2	5	22	1	f	2026-1
20260526	2026-05-26	2026	2	5	22	2	f	2026-1
20260527	2026-05-27	2026	2	5	22	3	f	2026-1
20260528	2026-05-28	2026	2	5	22	4	f	2026-1
20260529	2026-05-29	2026	2	5	22	5	f	2026-1
20260530	2026-05-30	2026	2	5	22	6	t	2026-1
20260531	2026-05-31	2026	2	5	22	7	t	2026-1
20260601	2026-06-01	2026	2	6	23	1	f	2026-1
20260602	2026-06-02	2026	2	6	23	2	f	2026-1
20260603	2026-06-03	2026	2	6	23	3	f	2026-1
20260604	2026-06-04	2026	2	6	23	4	f	2026-1
20260605	2026-06-05	2026	2	6	23	5	f	2026-1
20260606	2026-06-06	2026	2	6	23	6	t	2026-1
20260607	2026-06-07	2026	2	6	23	7	t	2026-1
20260608	2026-06-08	2026	2	6	24	1	f	2026-1
20260609	2026-06-09	2026	2	6	24	2	f	2026-1
20260610	2026-06-10	2026	2	6	24	3	f	2026-1
20260611	2026-06-11	2026	2	6	24	4	f	2026-1
20260612	2026-06-12	2026	2	6	24	5	f	2026-1
20260613	2026-06-13	2026	2	6	24	6	t	2026-1
20260614	2026-06-14	2026	2	6	24	7	t	2026-1
20260615	2026-06-15	2026	2	6	25	1	f	2026-1
20260616	2026-06-16	2026	2	6	25	2	f	2026-1
20260617	2026-06-17	2026	2	6	25	3	f	2026-1
20260618	2026-06-18	2026	2	6	25	4	f	2026-1
20260619	2026-06-19	2026	2	6	25	5	f	2026-1
20260620	2026-06-20	2026	2	6	25	6	t	2026-1
20260621	2026-06-21	2026	2	6	25	7	t	2026-1
20260622	2026-06-22	2026	2	6	26	1	f	2026-1
20260623	2026-06-23	2026	2	6	26	2	f	2026-1
20260624	2026-06-24	2026	2	6	26	3	f	2026-1
20260625	2026-06-25	2026	2	6	26	4	f	2026-1
20260626	2026-06-26	2026	2	6	26	5	f	2026-1
20260627	2026-06-27	2026	2	6	26	6	t	2026-1
20260628	2026-06-28	2026	2	6	26	7	t	2026-1
20260629	2026-06-29	2026	2	6	27	1	f	2026-1
20260630	2026-06-30	2026	2	6	27	2	f	2026-1
20260701	2026-07-01	2026	3	7	27	3	f	2026-2
20260702	2026-07-02	2026	3	7	27	4	f	2026-2
20260703	2026-07-03	2026	3	7	27	5	f	2026-2
20260704	2026-07-04	2026	3	7	27	6	t	2026-2
20260705	2026-07-05	2026	3	7	27	7	t	2026-2
20260706	2026-07-06	2026	3	7	28	1	f	2026-2
20260707	2026-07-07	2026	3	7	28	2	f	2026-2
20260708	2026-07-08	2026	3	7	28	3	f	2026-2
20260709	2026-07-09	2026	3	7	28	4	f	2026-2
20260710	2026-07-10	2026	3	7	28	5	f	2026-2
20260711	2026-07-11	2026	3	7	28	6	t	2026-2
20260712	2026-07-12	2026	3	7	28	7	t	2026-2
20260713	2026-07-13	2026	3	7	29	1	f	2026-2
20260714	2026-07-14	2026	3	7	29	2	f	2026-2
20260715	2026-07-15	2026	3	7	29	3	f	2026-2
20260716	2026-07-16	2026	3	7	29	4	f	2026-2
20260717	2026-07-17	2026	3	7	29	5	f	2026-2
20260718	2026-07-18	2026	3	7	29	6	t	2026-2
20260719	2026-07-19	2026	3	7	29	7	t	2026-2
20260720	2026-07-20	2026	3	7	30	1	f	2026-2
20260721	2026-07-21	2026	3	7	30	2	f	2026-2
20260722	2026-07-22	2026	3	7	30	3	f	2026-2
20260723	2026-07-23	2026	3	7	30	4	f	2026-2
20260724	2026-07-24	2026	3	7	30	5	f	2026-2
20260725	2026-07-25	2026	3	7	30	6	t	2026-2
20260726	2026-07-26	2026	3	7	30	7	t	2026-2
20260727	2026-07-27	2026	3	7	31	1	f	2026-2
20260728	2026-07-28	2026	3	7	31	2	f	2026-2
20260729	2026-07-29	2026	3	7	31	3	f	2026-2
20260730	2026-07-30	2026	3	7	31	4	f	2026-2
20260731	2026-07-31	2026	3	7	31	5	f	2026-2
20260801	2026-08-01	2026	3	8	31	6	t	2026-2
20260802	2026-08-02	2026	3	8	31	7	t	2026-2
20260803	2026-08-03	2026	3	8	32	1	f	2026-2
20260804	2026-08-04	2026	3	8	32	2	f	2026-2
20260805	2026-08-05	2026	3	8	32	3	f	2026-2
20260806	2026-08-06	2026	3	8	32	4	f	2026-2
20260807	2026-08-07	2026	3	8	32	5	f	2026-2
20260808	2026-08-08	2026	3	8	32	6	t	2026-2
20260809	2026-08-09	2026	3	8	32	7	t	2026-2
20260810	2026-08-10	2026	3	8	33	1	f	2026-2
20260811	2026-08-11	2026	3	8	33	2	f	2026-2
20260812	2026-08-12	2026	3	8	33	3	f	2026-2
20260813	2026-08-13	2026	3	8	33	4	f	2026-2
20260814	2026-08-14	2026	3	8	33	5	f	2026-2
20260815	2026-08-15	2026	3	8	33	6	t	2026-2
20260816	2026-08-16	2026	3	8	33	7	t	2026-2
20260817	2026-08-17	2026	3	8	34	1	f	2026-2
20260818	2026-08-18	2026	3	8	34	2	f	2026-2
20260819	2026-08-19	2026	3	8	34	3	f	2026-2
20260820	2026-08-20	2026	3	8	34	4	f	2026-2
20260821	2026-08-21	2026	3	8	34	5	f	2026-2
20260822	2026-08-22	2026	3	8	34	6	t	2026-2
20260823	2026-08-23	2026	3	8	34	7	t	2026-2
20260824	2026-08-24	2026	3	8	35	1	f	2026-2
20260825	2026-08-25	2026	3	8	35	2	f	2026-2
20260826	2026-08-26	2026	3	8	35	3	f	2026-2
20260827	2026-08-27	2026	3	8	35	4	f	2026-2
20260828	2026-08-28	2026	3	8	35	5	f	2026-2
20260829	2026-08-29	2026	3	8	35	6	t	2026-2
20260830	2026-08-30	2026	3	8	35	7	t	2026-2
20260831	2026-08-31	2026	3	8	36	1	f	2026-2
20260901	2026-09-01	2026	3	9	36	2	f	2026-2
20260902	2026-09-02	2026	3	9	36	3	f	2026-2
20260903	2026-09-03	2026	3	9	36	4	f	2026-2
20260904	2026-09-04	2026	3	9	36	5	f	2026-2
20260905	2026-09-05	2026	3	9	36	6	t	2026-2
20260906	2026-09-06	2026	3	9	36	7	t	2026-2
20260907	2026-09-07	2026	3	9	37	1	f	2026-2
20260908	2026-09-08	2026	3	9	37	2	f	2026-2
20260909	2026-09-09	2026	3	9	37	3	f	2026-2
20260910	2026-09-10	2026	3	9	37	4	f	2026-2
20260911	2026-09-11	2026	3	9	37	5	f	2026-2
20260912	2026-09-12	2026	3	9	37	6	t	2026-2
20260913	2026-09-13	2026	3	9	37	7	t	2026-2
20260914	2026-09-14	2026	3	9	38	1	f	2026-2
20260915	2026-09-15	2026	3	9	38	2	f	2026-2
20260916	2026-09-16	2026	3	9	38	3	f	2026-2
20260917	2026-09-17	2026	3	9	38	4	f	2026-2
20260918	2026-09-18	2026	3	9	38	5	f	2026-2
20260919	2026-09-19	2026	3	9	38	6	t	2026-2
20260920	2026-09-20	2026	3	9	38	7	t	2026-2
20260921	2026-09-21	2026	3	9	39	1	f	2026-2
20260922	2026-09-22	2026	3	9	39	2	f	2026-2
20260923	2026-09-23	2026	3	9	39	3	f	2026-2
20260924	2026-09-24	2026	3	9	39	4	f	2026-2
20260925	2026-09-25	2026	3	9	39	5	f	2026-2
20260926	2026-09-26	2026	3	9	39	6	t	2026-2
20260927	2026-09-27	2026	3	9	39	7	t	2026-2
20260928	2026-09-28	2026	3	9	40	1	f	2026-2
20260929	2026-09-29	2026	3	9	40	2	f	2026-2
20260930	2026-09-30	2026	3	9	40	3	f	2026-2
20261001	2026-10-01	2026	4	10	40	4	f	2026-2
20261002	2026-10-02	2026	4	10	40	5	f	2026-2
20261003	2026-10-03	2026	4	10	40	6	t	2026-2
20261004	2026-10-04	2026	4	10	40	7	t	2026-2
20261005	2026-10-05	2026	4	10	41	1	f	2026-2
20261006	2026-10-06	2026	4	10	41	2	f	2026-2
20261007	2026-10-07	2026	4	10	41	3	f	2026-2
20261008	2026-10-08	2026	4	10	41	4	f	2026-2
20261009	2026-10-09	2026	4	10	41	5	f	2026-2
20261010	2026-10-10	2026	4	10	41	6	t	2026-2
20261011	2026-10-11	2026	4	10	41	7	t	2026-2
20261012	2026-10-12	2026	4	10	42	1	f	2026-2
20261013	2026-10-13	2026	4	10	42	2	f	2026-2
20261014	2026-10-14	2026	4	10	42	3	f	2026-2
20261015	2026-10-15	2026	4	10	42	4	f	2026-2
20261016	2026-10-16	2026	4	10	42	5	f	2026-2
20261017	2026-10-17	2026	4	10	42	6	t	2026-2
20261018	2026-10-18	2026	4	10	42	7	t	2026-2
20261019	2026-10-19	2026	4	10	43	1	f	2026-2
20261020	2026-10-20	2026	4	10	43	2	f	2026-2
20261021	2026-10-21	2026	4	10	43	3	f	2026-2
20261022	2026-10-22	2026	4	10	43	4	f	2026-2
20261023	2026-10-23	2026	4	10	43	5	f	2026-2
20261024	2026-10-24	2026	4	10	43	6	t	2026-2
20261025	2026-10-25	2026	4	10	43	7	t	2026-2
20261026	2026-10-26	2026	4	10	44	1	f	2026-2
20261027	2026-10-27	2026	4	10	44	2	f	2026-2
20261028	2026-10-28	2026	4	10	44	3	f	2026-2
20261029	2026-10-29	2026	4	10	44	4	f	2026-2
20261030	2026-10-30	2026	4	10	44	5	f	2026-2
20261031	2026-10-31	2026	4	10	44	6	t	2026-2
20261101	2026-11-01	2026	4	11	44	7	t	2026-2
20261102	2026-11-02	2026	4	11	45	1	f	2026-2
20261103	2026-11-03	2026	4	11	45	2	f	2026-2
20261104	2026-11-04	2026	4	11	45	3	f	2026-2
20261105	2026-11-05	2026	4	11	45	4	f	2026-2
20261106	2026-11-06	2026	4	11	45	5	f	2026-2
20261107	2026-11-07	2026	4	11	45	6	t	2026-2
20261108	2026-11-08	2026	4	11	45	7	t	2026-2
20261109	2026-11-09	2026	4	11	46	1	f	2026-2
20261110	2026-11-10	2026	4	11	46	2	f	2026-2
20261111	2026-11-11	2026	4	11	46	3	f	2026-2
20261112	2026-11-12	2026	4	11	46	4	f	2026-2
20261113	2026-11-13	2026	4	11	46	5	f	2026-2
20261114	2026-11-14	2026	4	11	46	6	t	2026-2
20261115	2026-11-15	2026	4	11	46	7	t	2026-2
20261116	2026-11-16	2026	4	11	47	1	f	2026-2
20261117	2026-11-17	2026	4	11	47	2	f	2026-2
20261118	2026-11-18	2026	4	11	47	3	f	2026-2
20261119	2026-11-19	2026	4	11	47	4	f	2026-2
20261120	2026-11-20	2026	4	11	47	5	f	2026-2
20261121	2026-11-21	2026	4	11	47	6	t	2026-2
20261122	2026-11-22	2026	4	11	47	7	t	2026-2
20261123	2026-11-23	2026	4	11	48	1	f	2026-2
20261124	2026-11-24	2026	4	11	48	2	f	2026-2
20261125	2026-11-25	2026	4	11	48	3	f	2026-2
20261126	2026-11-26	2026	4	11	48	4	f	2026-2
20261127	2026-11-27	2026	4	11	48	5	f	2026-2
20261128	2026-11-28	2026	4	11	48	6	t	2026-2
20261129	2026-11-29	2026	4	11	48	7	t	2026-2
20261130	2026-11-30	2026	4	11	49	1	f	2026-2
20261201	2026-12-01	2026	4	12	49	2	f	2026-2
20261202	2026-12-02	2026	4	12	49	3	f	2026-2
20261203	2026-12-03	2026	4	12	49	4	f	2026-2
20261204	2026-12-04	2026	4	12	49	5	f	2026-2
20261205	2026-12-05	2026	4	12	49	6	t	2026-2
20261206	2026-12-06	2026	4	12	49	7	t	2026-2
20261207	2026-12-07	2026	4	12	50	1	f	2026-2
20261208	2026-12-08	2026	4	12	50	2	f	2026-2
20261209	2026-12-09	2026	4	12	50	3	f	2026-2
20261210	2026-12-10	2026	4	12	50	4	f	2026-2
20261211	2026-12-11	2026	4	12	50	5	f	2026-2
20261212	2026-12-12	2026	4	12	50	6	t	2026-2
20261213	2026-12-13	2026	4	12	50	7	t	2026-2
20261214	2026-12-14	2026	4	12	51	1	f	2026-2
20261215	2026-12-15	2026	4	12	51	2	f	2026-2
20261216	2026-12-16	2026	4	12	51	3	f	2026-2
20261217	2026-12-17	2026	4	12	51	4	f	2026-2
20261218	2026-12-18	2026	4	12	51	5	f	2026-2
20261219	2026-12-19	2026	4	12	51	6	t	2026-2
20261220	2026-12-20	2026	4	12	51	7	t	2026-2
20261221	2026-12-21	2026	4	12	52	1	f	2026-2
20261222	2026-12-22	2026	4	12	52	2	f	2026-2
20261223	2026-12-23	2026	4	12	52	3	f	2026-2
20261224	2026-12-24	2026	4	12	52	4	f	2026-2
20261225	2026-12-25	2026	4	12	52	5	f	2026-2
20261226	2026-12-26	2026	4	12	52	6	t	2026-2
20261227	2026-12-27	2026	4	12	52	7	t	2026-2
20261228	2026-12-28	2026	4	12	53	1	f	2026-2
20261229	2026-12-29	2026	4	12	53	2	f	2026-2
20261230	2026-12-30	2026	4	12	53	3	f	2026-2
20261231	2026-12-31	2026	4	12	53	4	f	2026-2
20270101	2027-01-01	2027	1	1	53	5	f	2027-1
20270102	2027-01-02	2027	1	1	53	6	t	2027-1
20270103	2027-01-03	2027	1	1	53	7	t	2027-1
20270104	2027-01-04	2027	1	1	1	1	f	2027-1
20270105	2027-01-05	2027	1	1	1	2	f	2027-1
20270106	2027-01-06	2027	1	1	1	3	f	2027-1
20270107	2027-01-07	2027	1	1	1	4	f	2027-1
20270108	2027-01-08	2027	1	1	1	5	f	2027-1
20270109	2027-01-09	2027	1	1	1	6	t	2027-1
20270110	2027-01-10	2027	1	1	1	7	t	2027-1
20270111	2027-01-11	2027	1	1	2	1	f	2027-1
20270112	2027-01-12	2027	1	1	2	2	f	2027-1
20270113	2027-01-13	2027	1	1	2	3	f	2027-1
20270114	2027-01-14	2027	1	1	2	4	f	2027-1
20270115	2027-01-15	2027	1	1	2	5	f	2027-1
20270116	2027-01-16	2027	1	1	2	6	t	2027-1
20270117	2027-01-17	2027	1	1	2	7	t	2027-1
20270118	2027-01-18	2027	1	1	3	1	f	2027-1
20270119	2027-01-19	2027	1	1	3	2	f	2027-1
20270120	2027-01-20	2027	1	1	3	3	f	2027-1
20270121	2027-01-21	2027	1	1	3	4	f	2027-1
20270122	2027-01-22	2027	1	1	3	5	f	2027-1
20270123	2027-01-23	2027	1	1	3	6	t	2027-1
20270124	2027-01-24	2027	1	1	3	7	t	2027-1
20270125	2027-01-25	2027	1	1	4	1	f	2027-1
20270126	2027-01-26	2027	1	1	4	2	f	2027-1
20270127	2027-01-27	2027	1	1	4	3	f	2027-1
20270128	2027-01-28	2027	1	1	4	4	f	2027-1
20270129	2027-01-29	2027	1	1	4	5	f	2027-1
20270130	2027-01-30	2027	1	1	4	6	t	2027-1
20270131	2027-01-31	2027	1	1	4	7	t	2027-1
20270201	2027-02-01	2027	1	2	5	1	f	2027-1
20270202	2027-02-02	2027	1	2	5	2	f	2027-1
20270203	2027-02-03	2027	1	2	5	3	f	2027-1
20270204	2027-02-04	2027	1	2	5	4	f	2027-1
20270205	2027-02-05	2027	1	2	5	5	f	2027-1
20270206	2027-02-06	2027	1	2	5	6	t	2027-1
20270207	2027-02-07	2027	1	2	5	7	t	2027-1
20270208	2027-02-08	2027	1	2	6	1	f	2027-1
20270209	2027-02-09	2027	1	2	6	2	f	2027-1
20270210	2027-02-10	2027	1	2	6	3	f	2027-1
20270211	2027-02-11	2027	1	2	6	4	f	2027-1
20270212	2027-02-12	2027	1	2	6	5	f	2027-1
20270213	2027-02-13	2027	1	2	6	6	t	2027-1
20270214	2027-02-14	2027	1	2	6	7	t	2027-1
20270215	2027-02-15	2027	1	2	7	1	f	2027-1
20270216	2027-02-16	2027	1	2	7	2	f	2027-1
20270217	2027-02-17	2027	1	2	7	3	f	2027-1
20270218	2027-02-18	2027	1	2	7	4	f	2027-1
20270219	2027-02-19	2027	1	2	7	5	f	2027-1
20270220	2027-02-20	2027	1	2	7	6	t	2027-1
20270221	2027-02-21	2027	1	2	7	7	t	2027-1
20270222	2027-02-22	2027	1	2	8	1	f	2027-1
20270223	2027-02-23	2027	1	2	8	2	f	2027-1
20270224	2027-02-24	2027	1	2	8	3	f	2027-1
20270225	2027-02-25	2027	1	2	8	4	f	2027-1
20270226	2027-02-26	2027	1	2	8	5	f	2027-1
20270227	2027-02-27	2027	1	2	8	6	t	2027-1
20270228	2027-02-28	2027	1	2	8	7	t	2027-1
20270301	2027-03-01	2027	1	3	9	1	f	2027-1
20270302	2027-03-02	2027	1	3	9	2	f	2027-1
20270303	2027-03-03	2027	1	3	9	3	f	2027-1
20270304	2027-03-04	2027	1	3	9	4	f	2027-1
20270305	2027-03-05	2027	1	3	9	5	f	2027-1
20270306	2027-03-06	2027	1	3	9	6	t	2027-1
20270307	2027-03-07	2027	1	3	9	7	t	2027-1
20270308	2027-03-08	2027	1	3	10	1	f	2027-1
20270309	2027-03-09	2027	1	3	10	2	f	2027-1
20270310	2027-03-10	2027	1	3	10	3	f	2027-1
20270311	2027-03-11	2027	1	3	10	4	f	2027-1
20270312	2027-03-12	2027	1	3	10	5	f	2027-1
20270313	2027-03-13	2027	1	3	10	6	t	2027-1
20270314	2027-03-14	2027	1	3	10	7	t	2027-1
20270315	2027-03-15	2027	1	3	11	1	f	2027-1
20270316	2027-03-16	2027	1	3	11	2	f	2027-1
20270317	2027-03-17	2027	1	3	11	3	f	2027-1
20270318	2027-03-18	2027	1	3	11	4	f	2027-1
20270319	2027-03-19	2027	1	3	11	5	f	2027-1
20270320	2027-03-20	2027	1	3	11	6	t	2027-1
20270321	2027-03-21	2027	1	3	11	7	t	2027-1
20270322	2027-03-22	2027	1	3	12	1	f	2027-1
20270323	2027-03-23	2027	1	3	12	2	f	2027-1
20270324	2027-03-24	2027	1	3	12	3	f	2027-1
20270325	2027-03-25	2027	1	3	12	4	f	2027-1
20270326	2027-03-26	2027	1	3	12	5	f	2027-1
20270327	2027-03-27	2027	1	3	12	6	t	2027-1
20270328	2027-03-28	2027	1	3	12	7	t	2027-1
20270329	2027-03-29	2027	1	3	13	1	f	2027-1
20270330	2027-03-30	2027	1	3	13	2	f	2027-1
20270331	2027-03-31	2027	1	3	13	3	f	2027-1
20270401	2027-04-01	2027	2	4	13	4	f	2027-1
20270402	2027-04-02	2027	2	4	13	5	f	2027-1
20270403	2027-04-03	2027	2	4	13	6	t	2027-1
20270404	2027-04-04	2027	2	4	13	7	t	2027-1
20270405	2027-04-05	2027	2	4	14	1	f	2027-1
20270406	2027-04-06	2027	2	4	14	2	f	2027-1
20270407	2027-04-07	2027	2	4	14	3	f	2027-1
20270408	2027-04-08	2027	2	4	14	4	f	2027-1
20270409	2027-04-09	2027	2	4	14	5	f	2027-1
20270410	2027-04-10	2027	2	4	14	6	t	2027-1
20270411	2027-04-11	2027	2	4	14	7	t	2027-1
20270412	2027-04-12	2027	2	4	15	1	f	2027-1
20270413	2027-04-13	2027	2	4	15	2	f	2027-1
20270414	2027-04-14	2027	2	4	15	3	f	2027-1
20270415	2027-04-15	2027	2	4	15	4	f	2027-1
20270416	2027-04-16	2027	2	4	15	5	f	2027-1
20270417	2027-04-17	2027	2	4	15	6	t	2027-1
20270418	2027-04-18	2027	2	4	15	7	t	2027-1
20270419	2027-04-19	2027	2	4	16	1	f	2027-1
20270420	2027-04-20	2027	2	4	16	2	f	2027-1
20270421	2027-04-21	2027	2	4	16	3	f	2027-1
20270422	2027-04-22	2027	2	4	16	4	f	2027-1
20270423	2027-04-23	2027	2	4	16	5	f	2027-1
20270424	2027-04-24	2027	2	4	16	6	t	2027-1
20270425	2027-04-25	2027	2	4	16	7	t	2027-1
20270426	2027-04-26	2027	2	4	17	1	f	2027-1
20270427	2027-04-27	2027	2	4	17	2	f	2027-1
20270428	2027-04-28	2027	2	4	17	3	f	2027-1
20270429	2027-04-29	2027	2	4	17	4	f	2027-1
20270430	2027-04-30	2027	2	4	17	5	f	2027-1
20270501	2027-05-01	2027	2	5	17	6	t	2027-1
20270502	2027-05-02	2027	2	5	17	7	t	2027-1
20270503	2027-05-03	2027	2	5	18	1	f	2027-1
20270504	2027-05-04	2027	2	5	18	2	f	2027-1
20270505	2027-05-05	2027	2	5	18	3	f	2027-1
20270506	2027-05-06	2027	2	5	18	4	f	2027-1
20270507	2027-05-07	2027	2	5	18	5	f	2027-1
20270508	2027-05-08	2027	2	5	18	6	t	2027-1
20270509	2027-05-09	2027	2	5	18	7	t	2027-1
20270510	2027-05-10	2027	2	5	19	1	f	2027-1
20270511	2027-05-11	2027	2	5	19	2	f	2027-1
20270512	2027-05-12	2027	2	5	19	3	f	2027-1
20270513	2027-05-13	2027	2	5	19	4	f	2027-1
20270514	2027-05-14	2027	2	5	19	5	f	2027-1
20270515	2027-05-15	2027	2	5	19	6	t	2027-1
20270516	2027-05-16	2027	2	5	19	7	t	2027-1
20270517	2027-05-17	2027	2	5	20	1	f	2027-1
20270518	2027-05-18	2027	2	5	20	2	f	2027-1
20270519	2027-05-19	2027	2	5	20	3	f	2027-1
20270520	2027-05-20	2027	2	5	20	4	f	2027-1
20270521	2027-05-21	2027	2	5	20	5	f	2027-1
20270522	2027-05-22	2027	2	5	20	6	t	2027-1
20270523	2027-05-23	2027	2	5	20	7	t	2027-1
20270524	2027-05-24	2027	2	5	21	1	f	2027-1
20270525	2027-05-25	2027	2	5	21	2	f	2027-1
20270526	2027-05-26	2027	2	5	21	3	f	2027-1
20270527	2027-05-27	2027	2	5	21	4	f	2027-1
20270528	2027-05-28	2027	2	5	21	5	f	2027-1
20270529	2027-05-29	2027	2	5	21	6	t	2027-1
20270530	2027-05-30	2027	2	5	21	7	t	2027-1
20270531	2027-05-31	2027	2	5	22	1	f	2027-1
20270601	2027-06-01	2027	2	6	22	2	f	2027-1
20270602	2027-06-02	2027	2	6	22	3	f	2027-1
20270603	2027-06-03	2027	2	6	22	4	f	2027-1
20270604	2027-06-04	2027	2	6	22	5	f	2027-1
20270605	2027-06-05	2027	2	6	22	6	t	2027-1
20270606	2027-06-06	2027	2	6	22	7	t	2027-1
20270607	2027-06-07	2027	2	6	23	1	f	2027-1
20270608	2027-06-08	2027	2	6	23	2	f	2027-1
20270609	2027-06-09	2027	2	6	23	3	f	2027-1
20270610	2027-06-10	2027	2	6	23	4	f	2027-1
20270611	2027-06-11	2027	2	6	23	5	f	2027-1
20270612	2027-06-12	2027	2	6	23	6	t	2027-1
20270613	2027-06-13	2027	2	6	23	7	t	2027-1
20270614	2027-06-14	2027	2	6	24	1	f	2027-1
20270615	2027-06-15	2027	2	6	24	2	f	2027-1
20270616	2027-06-16	2027	2	6	24	3	f	2027-1
20270617	2027-06-17	2027	2	6	24	4	f	2027-1
20270618	2027-06-18	2027	2	6	24	5	f	2027-1
20270619	2027-06-19	2027	2	6	24	6	t	2027-1
20270620	2027-06-20	2027	2	6	24	7	t	2027-1
20270621	2027-06-21	2027	2	6	25	1	f	2027-1
20270622	2027-06-22	2027	2	6	25	2	f	2027-1
20270623	2027-06-23	2027	2	6	25	3	f	2027-1
20270624	2027-06-24	2027	2	6	25	4	f	2027-1
20270625	2027-06-25	2027	2	6	25	5	f	2027-1
20270626	2027-06-26	2027	2	6	25	6	t	2027-1
20270627	2027-06-27	2027	2	6	25	7	t	2027-1
20270628	2027-06-28	2027	2	6	26	1	f	2027-1
20270629	2027-06-29	2027	2	6	26	2	f	2027-1
20270630	2027-06-30	2027	2	6	26	3	f	2027-1
20270701	2027-07-01	2027	3	7	26	4	f	2027-2
20270702	2027-07-02	2027	3	7	26	5	f	2027-2
20270703	2027-07-03	2027	3	7	26	6	t	2027-2
20270704	2027-07-04	2027	3	7	26	7	t	2027-2
20270705	2027-07-05	2027	3	7	27	1	f	2027-2
20270706	2027-07-06	2027	3	7	27	2	f	2027-2
20270707	2027-07-07	2027	3	7	27	3	f	2027-2
20270708	2027-07-08	2027	3	7	27	4	f	2027-2
20270709	2027-07-09	2027	3	7	27	5	f	2027-2
20270710	2027-07-10	2027	3	7	27	6	t	2027-2
20270711	2027-07-11	2027	3	7	27	7	t	2027-2
20270712	2027-07-12	2027	3	7	28	1	f	2027-2
20270713	2027-07-13	2027	3	7	28	2	f	2027-2
20270714	2027-07-14	2027	3	7	28	3	f	2027-2
20270715	2027-07-15	2027	3	7	28	4	f	2027-2
20270716	2027-07-16	2027	3	7	28	5	f	2027-2
20270717	2027-07-17	2027	3	7	28	6	t	2027-2
20270718	2027-07-18	2027	3	7	28	7	t	2027-2
20270719	2027-07-19	2027	3	7	29	1	f	2027-2
20270720	2027-07-20	2027	3	7	29	2	f	2027-2
20270721	2027-07-21	2027	3	7	29	3	f	2027-2
20270722	2027-07-22	2027	3	7	29	4	f	2027-2
20270723	2027-07-23	2027	3	7	29	5	f	2027-2
20270724	2027-07-24	2027	3	7	29	6	t	2027-2
20270725	2027-07-25	2027	3	7	29	7	t	2027-2
20270726	2027-07-26	2027	3	7	30	1	f	2027-2
20270727	2027-07-27	2027	3	7	30	2	f	2027-2
20270728	2027-07-28	2027	3	7	30	3	f	2027-2
20270729	2027-07-29	2027	3	7	30	4	f	2027-2
20270730	2027-07-30	2027	3	7	30	5	f	2027-2
20270731	2027-07-31	2027	3	7	30	6	t	2027-2
20270801	2027-08-01	2027	3	8	30	7	t	2027-2
20270802	2027-08-02	2027	3	8	31	1	f	2027-2
20270803	2027-08-03	2027	3	8	31	2	f	2027-2
20270804	2027-08-04	2027	3	8	31	3	f	2027-2
20270805	2027-08-05	2027	3	8	31	4	f	2027-2
20270806	2027-08-06	2027	3	8	31	5	f	2027-2
20270807	2027-08-07	2027	3	8	31	6	t	2027-2
20270808	2027-08-08	2027	3	8	31	7	t	2027-2
20270809	2027-08-09	2027	3	8	32	1	f	2027-2
20270810	2027-08-10	2027	3	8	32	2	f	2027-2
20270811	2027-08-11	2027	3	8	32	3	f	2027-2
20270812	2027-08-12	2027	3	8	32	4	f	2027-2
20270813	2027-08-13	2027	3	8	32	5	f	2027-2
20270814	2027-08-14	2027	3	8	32	6	t	2027-2
20270815	2027-08-15	2027	3	8	32	7	t	2027-2
20270816	2027-08-16	2027	3	8	33	1	f	2027-2
20270817	2027-08-17	2027	3	8	33	2	f	2027-2
20270818	2027-08-18	2027	3	8	33	3	f	2027-2
20270819	2027-08-19	2027	3	8	33	4	f	2027-2
20270820	2027-08-20	2027	3	8	33	5	f	2027-2
20270821	2027-08-21	2027	3	8	33	6	t	2027-2
20270822	2027-08-22	2027	3	8	33	7	t	2027-2
20270823	2027-08-23	2027	3	8	34	1	f	2027-2
20270824	2027-08-24	2027	3	8	34	2	f	2027-2
20270825	2027-08-25	2027	3	8	34	3	f	2027-2
20270826	2027-08-26	2027	3	8	34	4	f	2027-2
20270827	2027-08-27	2027	3	8	34	5	f	2027-2
20270828	2027-08-28	2027	3	8	34	6	t	2027-2
20270829	2027-08-29	2027	3	8	34	7	t	2027-2
20270830	2027-08-30	2027	3	8	35	1	f	2027-2
20270831	2027-08-31	2027	3	8	35	2	f	2027-2
20270901	2027-09-01	2027	3	9	35	3	f	2027-2
20270902	2027-09-02	2027	3	9	35	4	f	2027-2
20270903	2027-09-03	2027	3	9	35	5	f	2027-2
20270904	2027-09-04	2027	3	9	35	6	t	2027-2
20270905	2027-09-05	2027	3	9	35	7	t	2027-2
20270906	2027-09-06	2027	3	9	36	1	f	2027-2
20270907	2027-09-07	2027	3	9	36	2	f	2027-2
20270908	2027-09-08	2027	3	9	36	3	f	2027-2
20270909	2027-09-09	2027	3	9	36	4	f	2027-2
20270910	2027-09-10	2027	3	9	36	5	f	2027-2
20270911	2027-09-11	2027	3	9	36	6	t	2027-2
20270912	2027-09-12	2027	3	9	36	7	t	2027-2
20270913	2027-09-13	2027	3	9	37	1	f	2027-2
20270914	2027-09-14	2027	3	9	37	2	f	2027-2
20270915	2027-09-15	2027	3	9	37	3	f	2027-2
20270916	2027-09-16	2027	3	9	37	4	f	2027-2
20270917	2027-09-17	2027	3	9	37	5	f	2027-2
20270918	2027-09-18	2027	3	9	37	6	t	2027-2
20270919	2027-09-19	2027	3	9	37	7	t	2027-2
20270920	2027-09-20	2027	3	9	38	1	f	2027-2
20270921	2027-09-21	2027	3	9	38	2	f	2027-2
20270922	2027-09-22	2027	3	9	38	3	f	2027-2
20270923	2027-09-23	2027	3	9	38	4	f	2027-2
20270924	2027-09-24	2027	3	9	38	5	f	2027-2
20270925	2027-09-25	2027	3	9	38	6	t	2027-2
20270926	2027-09-26	2027	3	9	38	7	t	2027-2
20270927	2027-09-27	2027	3	9	39	1	f	2027-2
20270928	2027-09-28	2027	3	9	39	2	f	2027-2
20270929	2027-09-29	2027	3	9	39	3	f	2027-2
20270930	2027-09-30	2027	3	9	39	4	f	2027-2
20271001	2027-10-01	2027	4	10	39	5	f	2027-2
20271002	2027-10-02	2027	4	10	39	6	t	2027-2
20271003	2027-10-03	2027	4	10	39	7	t	2027-2
20271004	2027-10-04	2027	4	10	40	1	f	2027-2
20271005	2027-10-05	2027	4	10	40	2	f	2027-2
20271006	2027-10-06	2027	4	10	40	3	f	2027-2
20271007	2027-10-07	2027	4	10	40	4	f	2027-2
20271008	2027-10-08	2027	4	10	40	5	f	2027-2
20271009	2027-10-09	2027	4	10	40	6	t	2027-2
20271010	2027-10-10	2027	4	10	40	7	t	2027-2
20271011	2027-10-11	2027	4	10	41	1	f	2027-2
20271012	2027-10-12	2027	4	10	41	2	f	2027-2
20271013	2027-10-13	2027	4	10	41	3	f	2027-2
20271014	2027-10-14	2027	4	10	41	4	f	2027-2
20271015	2027-10-15	2027	4	10	41	5	f	2027-2
20271016	2027-10-16	2027	4	10	41	6	t	2027-2
20271017	2027-10-17	2027	4	10	41	7	t	2027-2
20271018	2027-10-18	2027	4	10	42	1	f	2027-2
20271019	2027-10-19	2027	4	10	42	2	f	2027-2
20271020	2027-10-20	2027	4	10	42	3	f	2027-2
20271021	2027-10-21	2027	4	10	42	4	f	2027-2
20271022	2027-10-22	2027	4	10	42	5	f	2027-2
20271023	2027-10-23	2027	4	10	42	6	t	2027-2
20271024	2027-10-24	2027	4	10	42	7	t	2027-2
20271025	2027-10-25	2027	4	10	43	1	f	2027-2
20271026	2027-10-26	2027	4	10	43	2	f	2027-2
20271027	2027-10-27	2027	4	10	43	3	f	2027-2
20271028	2027-10-28	2027	4	10	43	4	f	2027-2
20271029	2027-10-29	2027	4	10	43	5	f	2027-2
20271030	2027-10-30	2027	4	10	43	6	t	2027-2
20271031	2027-10-31	2027	4	10	43	7	t	2027-2
20271101	2027-11-01	2027	4	11	44	1	f	2027-2
20271102	2027-11-02	2027	4	11	44	2	f	2027-2
20271103	2027-11-03	2027	4	11	44	3	f	2027-2
20271104	2027-11-04	2027	4	11	44	4	f	2027-2
20271105	2027-11-05	2027	4	11	44	5	f	2027-2
20271106	2027-11-06	2027	4	11	44	6	t	2027-2
20271107	2027-11-07	2027	4	11	44	7	t	2027-2
20271108	2027-11-08	2027	4	11	45	1	f	2027-2
20271109	2027-11-09	2027	4	11	45	2	f	2027-2
20271110	2027-11-10	2027	4	11	45	3	f	2027-2
20271111	2027-11-11	2027	4	11	45	4	f	2027-2
20271112	2027-11-12	2027	4	11	45	5	f	2027-2
20271113	2027-11-13	2027	4	11	45	6	t	2027-2
20271114	2027-11-14	2027	4	11	45	7	t	2027-2
20271115	2027-11-15	2027	4	11	46	1	f	2027-2
20271116	2027-11-16	2027	4	11	46	2	f	2027-2
20271117	2027-11-17	2027	4	11	46	3	f	2027-2
20271118	2027-11-18	2027	4	11	46	4	f	2027-2
20271119	2027-11-19	2027	4	11	46	5	f	2027-2
20271120	2027-11-20	2027	4	11	46	6	t	2027-2
20271121	2027-11-21	2027	4	11	46	7	t	2027-2
20271122	2027-11-22	2027	4	11	47	1	f	2027-2
20271123	2027-11-23	2027	4	11	47	2	f	2027-2
20271124	2027-11-24	2027	4	11	47	3	f	2027-2
20271125	2027-11-25	2027	4	11	47	4	f	2027-2
20271126	2027-11-26	2027	4	11	47	5	f	2027-2
20271127	2027-11-27	2027	4	11	47	6	t	2027-2
20271128	2027-11-28	2027	4	11	47	7	t	2027-2
20271129	2027-11-29	2027	4	11	48	1	f	2027-2
20271130	2027-11-30	2027	4	11	48	2	f	2027-2
20271201	2027-12-01	2027	4	12	48	3	f	2027-2
20271202	2027-12-02	2027	4	12	48	4	f	2027-2
20271203	2027-12-03	2027	4	12	48	5	f	2027-2
20271204	2027-12-04	2027	4	12	48	6	t	2027-2
20271205	2027-12-05	2027	4	12	48	7	t	2027-2
20271206	2027-12-06	2027	4	12	49	1	f	2027-2
20271207	2027-12-07	2027	4	12	49	2	f	2027-2
20271208	2027-12-08	2027	4	12	49	3	f	2027-2
20271209	2027-12-09	2027	4	12	49	4	f	2027-2
20271210	2027-12-10	2027	4	12	49	5	f	2027-2
20271211	2027-12-11	2027	4	12	49	6	t	2027-2
20271212	2027-12-12	2027	4	12	49	7	t	2027-2
20271213	2027-12-13	2027	4	12	50	1	f	2027-2
20271214	2027-12-14	2027	4	12	50	2	f	2027-2
20271215	2027-12-15	2027	4	12	50	3	f	2027-2
20271216	2027-12-16	2027	4	12	50	4	f	2027-2
20271217	2027-12-17	2027	4	12	50	5	f	2027-2
20271218	2027-12-18	2027	4	12	50	6	t	2027-2
20271219	2027-12-19	2027	4	12	50	7	t	2027-2
20271220	2027-12-20	2027	4	12	51	1	f	2027-2
20271221	2027-12-21	2027	4	12	51	2	f	2027-2
20271222	2027-12-22	2027	4	12	51	3	f	2027-2
20271223	2027-12-23	2027	4	12	51	4	f	2027-2
20271224	2027-12-24	2027	4	12	51	5	f	2027-2
20271225	2027-12-25	2027	4	12	51	6	t	2027-2
20271226	2027-12-26	2027	4	12	51	7	t	2027-2
20271227	2027-12-27	2027	4	12	52	1	f	2027-2
20271228	2027-12-28	2027	4	12	52	2	f	2027-2
20271229	2027-12-29	2027	4	12	52	3	f	2027-2
20271230	2027-12-30	2027	4	12	52	4	f	2027-2
20271231	2027-12-31	2027	4	12	52	5	f	2027-2
20280101	2028-01-01	2028	1	1	52	6	t	2028-1
20280102	2028-01-02	2028	1	1	52	7	t	2028-1
20280103	2028-01-03	2028	1	1	1	1	f	2028-1
20280104	2028-01-04	2028	1	1	1	2	f	2028-1
20280105	2028-01-05	2028	1	1	1	3	f	2028-1
20280106	2028-01-06	2028	1	1	1	4	f	2028-1
20280107	2028-01-07	2028	1	1	1	5	f	2028-1
20280108	2028-01-08	2028	1	1	1	6	t	2028-1
20280109	2028-01-09	2028	1	1	1	7	t	2028-1
20280110	2028-01-10	2028	1	1	2	1	f	2028-1
20280111	2028-01-11	2028	1	1	2	2	f	2028-1
20280112	2028-01-12	2028	1	1	2	3	f	2028-1
20280113	2028-01-13	2028	1	1	2	4	f	2028-1
20280114	2028-01-14	2028	1	1	2	5	f	2028-1
20280115	2028-01-15	2028	1	1	2	6	t	2028-1
20280116	2028-01-16	2028	1	1	2	7	t	2028-1
20280117	2028-01-17	2028	1	1	3	1	f	2028-1
20280118	2028-01-18	2028	1	1	3	2	f	2028-1
20280119	2028-01-19	2028	1	1	3	3	f	2028-1
20280120	2028-01-20	2028	1	1	3	4	f	2028-1
20280121	2028-01-21	2028	1	1	3	5	f	2028-1
20280122	2028-01-22	2028	1	1	3	6	t	2028-1
20280123	2028-01-23	2028	1	1	3	7	t	2028-1
20280124	2028-01-24	2028	1	1	4	1	f	2028-1
20280125	2028-01-25	2028	1	1	4	2	f	2028-1
20280126	2028-01-26	2028	1	1	4	3	f	2028-1
20280127	2028-01-27	2028	1	1	4	4	f	2028-1
20280128	2028-01-28	2028	1	1	4	5	f	2028-1
20280129	2028-01-29	2028	1	1	4	6	t	2028-1
20280130	2028-01-30	2028	1	1	4	7	t	2028-1
20280131	2028-01-31	2028	1	1	5	1	f	2028-1
20280201	2028-02-01	2028	1	2	5	2	f	2028-1
20280202	2028-02-02	2028	1	2	5	3	f	2028-1
20280203	2028-02-03	2028	1	2	5	4	f	2028-1
20280204	2028-02-04	2028	1	2	5	5	f	2028-1
20280205	2028-02-05	2028	1	2	5	6	t	2028-1
20280206	2028-02-06	2028	1	2	5	7	t	2028-1
20280207	2028-02-07	2028	1	2	6	1	f	2028-1
20280208	2028-02-08	2028	1	2	6	2	f	2028-1
20280209	2028-02-09	2028	1	2	6	3	f	2028-1
20280210	2028-02-10	2028	1	2	6	4	f	2028-1
20280211	2028-02-11	2028	1	2	6	5	f	2028-1
20280212	2028-02-12	2028	1	2	6	6	t	2028-1
20280213	2028-02-13	2028	1	2	6	7	t	2028-1
20280214	2028-02-14	2028	1	2	7	1	f	2028-1
20280215	2028-02-15	2028	1	2	7	2	f	2028-1
20280216	2028-02-16	2028	1	2	7	3	f	2028-1
20280217	2028-02-17	2028	1	2	7	4	f	2028-1
20280218	2028-02-18	2028	1	2	7	5	f	2028-1
20280219	2028-02-19	2028	1	2	7	6	t	2028-1
20280220	2028-02-20	2028	1	2	7	7	t	2028-1
20280221	2028-02-21	2028	1	2	8	1	f	2028-1
20280222	2028-02-22	2028	1	2	8	2	f	2028-1
20280223	2028-02-23	2028	1	2	8	3	f	2028-1
20280224	2028-02-24	2028	1	2	8	4	f	2028-1
20280225	2028-02-25	2028	1	2	8	5	f	2028-1
20280226	2028-02-26	2028	1	2	8	6	t	2028-1
20280227	2028-02-27	2028	1	2	8	7	t	2028-1
20280228	2028-02-28	2028	1	2	9	1	f	2028-1
20280229	2028-02-29	2028	1	2	9	2	f	2028-1
20280301	2028-03-01	2028	1	3	9	3	f	2028-1
20280302	2028-03-02	2028	1	3	9	4	f	2028-1
20280303	2028-03-03	2028	1	3	9	5	f	2028-1
20280304	2028-03-04	2028	1	3	9	6	t	2028-1
20280305	2028-03-05	2028	1	3	9	7	t	2028-1
20280306	2028-03-06	2028	1	3	10	1	f	2028-1
20280307	2028-03-07	2028	1	3	10	2	f	2028-1
20280308	2028-03-08	2028	1	3	10	3	f	2028-1
20280309	2028-03-09	2028	1	3	10	4	f	2028-1
20280310	2028-03-10	2028	1	3	10	5	f	2028-1
20280311	2028-03-11	2028	1	3	10	6	t	2028-1
20280312	2028-03-12	2028	1	3	10	7	t	2028-1
20280313	2028-03-13	2028	1	3	11	1	f	2028-1
20280314	2028-03-14	2028	1	3	11	2	f	2028-1
20280315	2028-03-15	2028	1	3	11	3	f	2028-1
20280316	2028-03-16	2028	1	3	11	4	f	2028-1
20280317	2028-03-17	2028	1	3	11	5	f	2028-1
20280318	2028-03-18	2028	1	3	11	6	t	2028-1
20280319	2028-03-19	2028	1	3	11	7	t	2028-1
20280320	2028-03-20	2028	1	3	12	1	f	2028-1
20280321	2028-03-21	2028	1	3	12	2	f	2028-1
20280322	2028-03-22	2028	1	3	12	3	f	2028-1
20280323	2028-03-23	2028	1	3	12	4	f	2028-1
20280324	2028-03-24	2028	1	3	12	5	f	2028-1
20280325	2028-03-25	2028	1	3	12	6	t	2028-1
20280326	2028-03-26	2028	1	3	12	7	t	2028-1
20280327	2028-03-27	2028	1	3	13	1	f	2028-1
20280328	2028-03-28	2028	1	3	13	2	f	2028-1
20280329	2028-03-29	2028	1	3	13	3	f	2028-1
20280330	2028-03-30	2028	1	3	13	4	f	2028-1
20280331	2028-03-31	2028	1	3	13	5	f	2028-1
20280401	2028-04-01	2028	2	4	13	6	t	2028-1
20280402	2028-04-02	2028	2	4	13	7	t	2028-1
20280403	2028-04-03	2028	2	4	14	1	f	2028-1
20280404	2028-04-04	2028	2	4	14	2	f	2028-1
20280405	2028-04-05	2028	2	4	14	3	f	2028-1
20280406	2028-04-06	2028	2	4	14	4	f	2028-1
20280407	2028-04-07	2028	2	4	14	5	f	2028-1
20280408	2028-04-08	2028	2	4	14	6	t	2028-1
20280409	2028-04-09	2028	2	4	14	7	t	2028-1
20280410	2028-04-10	2028	2	4	15	1	f	2028-1
20280411	2028-04-11	2028	2	4	15	2	f	2028-1
20280412	2028-04-12	2028	2	4	15	3	f	2028-1
20280413	2028-04-13	2028	2	4	15	4	f	2028-1
20280414	2028-04-14	2028	2	4	15	5	f	2028-1
20280415	2028-04-15	2028	2	4	15	6	t	2028-1
20280416	2028-04-16	2028	2	4	15	7	t	2028-1
20280417	2028-04-17	2028	2	4	16	1	f	2028-1
20280418	2028-04-18	2028	2	4	16	2	f	2028-1
20280419	2028-04-19	2028	2	4	16	3	f	2028-1
20280420	2028-04-20	2028	2	4	16	4	f	2028-1
20280421	2028-04-21	2028	2	4	16	5	f	2028-1
20280422	2028-04-22	2028	2	4	16	6	t	2028-1
20280423	2028-04-23	2028	2	4	16	7	t	2028-1
20280424	2028-04-24	2028	2	4	17	1	f	2028-1
20280425	2028-04-25	2028	2	4	17	2	f	2028-1
20280426	2028-04-26	2028	2	4	17	3	f	2028-1
20280427	2028-04-27	2028	2	4	17	4	f	2028-1
20280428	2028-04-28	2028	2	4	17	5	f	2028-1
20280429	2028-04-29	2028	2	4	17	6	t	2028-1
20280430	2028-04-30	2028	2	4	17	7	t	2028-1
20280501	2028-05-01	2028	2	5	18	1	f	2028-1
20280502	2028-05-02	2028	2	5	18	2	f	2028-1
20280503	2028-05-03	2028	2	5	18	3	f	2028-1
20280504	2028-05-04	2028	2	5	18	4	f	2028-1
20280505	2028-05-05	2028	2	5	18	5	f	2028-1
20280506	2028-05-06	2028	2	5	18	6	t	2028-1
20280507	2028-05-07	2028	2	5	18	7	t	2028-1
20280508	2028-05-08	2028	2	5	19	1	f	2028-1
20280509	2028-05-09	2028	2	5	19	2	f	2028-1
20280510	2028-05-10	2028	2	5	19	3	f	2028-1
20280511	2028-05-11	2028	2	5	19	4	f	2028-1
20280512	2028-05-12	2028	2	5	19	5	f	2028-1
20280513	2028-05-13	2028	2	5	19	6	t	2028-1
20280514	2028-05-14	2028	2	5	19	7	t	2028-1
20280515	2028-05-15	2028	2	5	20	1	f	2028-1
20280516	2028-05-16	2028	2	5	20	2	f	2028-1
20280517	2028-05-17	2028	2	5	20	3	f	2028-1
20280518	2028-05-18	2028	2	5	20	4	f	2028-1
20280519	2028-05-19	2028	2	5	20	5	f	2028-1
20280520	2028-05-20	2028	2	5	20	6	t	2028-1
20280521	2028-05-21	2028	2	5	20	7	t	2028-1
20280522	2028-05-22	2028	2	5	21	1	f	2028-1
20280523	2028-05-23	2028	2	5	21	2	f	2028-1
20280524	2028-05-24	2028	2	5	21	3	f	2028-1
20280525	2028-05-25	2028	2	5	21	4	f	2028-1
20280526	2028-05-26	2028	2	5	21	5	f	2028-1
20280527	2028-05-27	2028	2	5	21	6	t	2028-1
20280528	2028-05-28	2028	2	5	21	7	t	2028-1
20280529	2028-05-29	2028	2	5	22	1	f	2028-1
20280530	2028-05-30	2028	2	5	22	2	f	2028-1
20280531	2028-05-31	2028	2	5	22	3	f	2028-1
20280601	2028-06-01	2028	2	6	22	4	f	2028-1
20280602	2028-06-02	2028	2	6	22	5	f	2028-1
20280603	2028-06-03	2028	2	6	22	6	t	2028-1
20280604	2028-06-04	2028	2	6	22	7	t	2028-1
20280605	2028-06-05	2028	2	6	23	1	f	2028-1
20280606	2028-06-06	2028	2	6	23	2	f	2028-1
20280607	2028-06-07	2028	2	6	23	3	f	2028-1
20280608	2028-06-08	2028	2	6	23	4	f	2028-1
20280609	2028-06-09	2028	2	6	23	5	f	2028-1
20280610	2028-06-10	2028	2	6	23	6	t	2028-1
20280611	2028-06-11	2028	2	6	23	7	t	2028-1
20280612	2028-06-12	2028	2	6	24	1	f	2028-1
20280613	2028-06-13	2028	2	6	24	2	f	2028-1
20280614	2028-06-14	2028	2	6	24	3	f	2028-1
20280615	2028-06-15	2028	2	6	24	4	f	2028-1
20280616	2028-06-16	2028	2	6	24	5	f	2028-1
20280617	2028-06-17	2028	2	6	24	6	t	2028-1
20280618	2028-06-18	2028	2	6	24	7	t	2028-1
20280619	2028-06-19	2028	2	6	25	1	f	2028-1
20280620	2028-06-20	2028	2	6	25	2	f	2028-1
20280621	2028-06-21	2028	2	6	25	3	f	2028-1
20280622	2028-06-22	2028	2	6	25	4	f	2028-1
20280623	2028-06-23	2028	2	6	25	5	f	2028-1
20280624	2028-06-24	2028	2	6	25	6	t	2028-1
20280625	2028-06-25	2028	2	6	25	7	t	2028-1
20280626	2028-06-26	2028	2	6	26	1	f	2028-1
20280627	2028-06-27	2028	2	6	26	2	f	2028-1
20280628	2028-06-28	2028	2	6	26	3	f	2028-1
20280629	2028-06-29	2028	2	6	26	4	f	2028-1
20280630	2028-06-30	2028	2	6	26	5	f	2028-1
20280701	2028-07-01	2028	3	7	26	6	t	2028-2
20280702	2028-07-02	2028	3	7	26	7	t	2028-2
20280703	2028-07-03	2028	3	7	27	1	f	2028-2
20280704	2028-07-04	2028	3	7	27	2	f	2028-2
20280705	2028-07-05	2028	3	7	27	3	f	2028-2
20280706	2028-07-06	2028	3	7	27	4	f	2028-2
20280707	2028-07-07	2028	3	7	27	5	f	2028-2
20280708	2028-07-08	2028	3	7	27	6	t	2028-2
20280709	2028-07-09	2028	3	7	27	7	t	2028-2
20280710	2028-07-10	2028	3	7	28	1	f	2028-2
20280711	2028-07-11	2028	3	7	28	2	f	2028-2
20280712	2028-07-12	2028	3	7	28	3	f	2028-2
20280713	2028-07-13	2028	3	7	28	4	f	2028-2
20280714	2028-07-14	2028	3	7	28	5	f	2028-2
20280715	2028-07-15	2028	3	7	28	6	t	2028-2
20280716	2028-07-16	2028	3	7	28	7	t	2028-2
20280717	2028-07-17	2028	3	7	29	1	f	2028-2
20280718	2028-07-18	2028	3	7	29	2	f	2028-2
20280719	2028-07-19	2028	3	7	29	3	f	2028-2
20280720	2028-07-20	2028	3	7	29	4	f	2028-2
20280721	2028-07-21	2028	3	7	29	5	f	2028-2
20280722	2028-07-22	2028	3	7	29	6	t	2028-2
20280723	2028-07-23	2028	3	7	29	7	t	2028-2
20280724	2028-07-24	2028	3	7	30	1	f	2028-2
20280725	2028-07-25	2028	3	7	30	2	f	2028-2
20280726	2028-07-26	2028	3	7	30	3	f	2028-2
20280727	2028-07-27	2028	3	7	30	4	f	2028-2
20280728	2028-07-28	2028	3	7	30	5	f	2028-2
20280729	2028-07-29	2028	3	7	30	6	t	2028-2
20280730	2028-07-30	2028	3	7	30	7	t	2028-2
20280731	2028-07-31	2028	3	7	31	1	f	2028-2
20280801	2028-08-01	2028	3	8	31	2	f	2028-2
20280802	2028-08-02	2028	3	8	31	3	f	2028-2
20280803	2028-08-03	2028	3	8	31	4	f	2028-2
20280804	2028-08-04	2028	3	8	31	5	f	2028-2
20280805	2028-08-05	2028	3	8	31	6	t	2028-2
20280806	2028-08-06	2028	3	8	31	7	t	2028-2
20280807	2028-08-07	2028	3	8	32	1	f	2028-2
20280808	2028-08-08	2028	3	8	32	2	f	2028-2
20280809	2028-08-09	2028	3	8	32	3	f	2028-2
20280810	2028-08-10	2028	3	8	32	4	f	2028-2
20280811	2028-08-11	2028	3	8	32	5	f	2028-2
20280812	2028-08-12	2028	3	8	32	6	t	2028-2
20280813	2028-08-13	2028	3	8	32	7	t	2028-2
20280814	2028-08-14	2028	3	8	33	1	f	2028-2
20280815	2028-08-15	2028	3	8	33	2	f	2028-2
20280816	2028-08-16	2028	3	8	33	3	f	2028-2
20280817	2028-08-17	2028	3	8	33	4	f	2028-2
20280818	2028-08-18	2028	3	8	33	5	f	2028-2
20280819	2028-08-19	2028	3	8	33	6	t	2028-2
20280820	2028-08-20	2028	3	8	33	7	t	2028-2
20280821	2028-08-21	2028	3	8	34	1	f	2028-2
20280822	2028-08-22	2028	3	8	34	2	f	2028-2
20280823	2028-08-23	2028	3	8	34	3	f	2028-2
20280824	2028-08-24	2028	3	8	34	4	f	2028-2
20280825	2028-08-25	2028	3	8	34	5	f	2028-2
20280826	2028-08-26	2028	3	8	34	6	t	2028-2
20280827	2028-08-27	2028	3	8	34	7	t	2028-2
20280828	2028-08-28	2028	3	8	35	1	f	2028-2
20280829	2028-08-29	2028	3	8	35	2	f	2028-2
20280830	2028-08-30	2028	3	8	35	3	f	2028-2
20280831	2028-08-31	2028	3	8	35	4	f	2028-2
20280901	2028-09-01	2028	3	9	35	5	f	2028-2
20280902	2028-09-02	2028	3	9	35	6	t	2028-2
20280903	2028-09-03	2028	3	9	35	7	t	2028-2
20280904	2028-09-04	2028	3	9	36	1	f	2028-2
20280905	2028-09-05	2028	3	9	36	2	f	2028-2
20280906	2028-09-06	2028	3	9	36	3	f	2028-2
20280907	2028-09-07	2028	3	9	36	4	f	2028-2
20280908	2028-09-08	2028	3	9	36	5	f	2028-2
20280909	2028-09-09	2028	3	9	36	6	t	2028-2
20280910	2028-09-10	2028	3	9	36	7	t	2028-2
20280911	2028-09-11	2028	3	9	37	1	f	2028-2
20280912	2028-09-12	2028	3	9	37	2	f	2028-2
20280913	2028-09-13	2028	3	9	37	3	f	2028-2
20280914	2028-09-14	2028	3	9	37	4	f	2028-2
20280915	2028-09-15	2028	3	9	37	5	f	2028-2
20280916	2028-09-16	2028	3	9	37	6	t	2028-2
20280917	2028-09-17	2028	3	9	37	7	t	2028-2
20280918	2028-09-18	2028	3	9	38	1	f	2028-2
20280919	2028-09-19	2028	3	9	38	2	f	2028-2
20280920	2028-09-20	2028	3	9	38	3	f	2028-2
20280921	2028-09-21	2028	3	9	38	4	f	2028-2
20280922	2028-09-22	2028	3	9	38	5	f	2028-2
20280923	2028-09-23	2028	3	9	38	6	t	2028-2
20280924	2028-09-24	2028	3	9	38	7	t	2028-2
20280925	2028-09-25	2028	3	9	39	1	f	2028-2
20280926	2028-09-26	2028	3	9	39	2	f	2028-2
20280927	2028-09-27	2028	3	9	39	3	f	2028-2
20280928	2028-09-28	2028	3	9	39	4	f	2028-2
20280929	2028-09-29	2028	3	9	39	5	f	2028-2
20280930	2028-09-30	2028	3	9	39	6	t	2028-2
20281001	2028-10-01	2028	4	10	39	7	t	2028-2
20281002	2028-10-02	2028	4	10	40	1	f	2028-2
20281003	2028-10-03	2028	4	10	40	2	f	2028-2
20281004	2028-10-04	2028	4	10	40	3	f	2028-2
20281005	2028-10-05	2028	4	10	40	4	f	2028-2
20281006	2028-10-06	2028	4	10	40	5	f	2028-2
20281007	2028-10-07	2028	4	10	40	6	t	2028-2
20281008	2028-10-08	2028	4	10	40	7	t	2028-2
20281009	2028-10-09	2028	4	10	41	1	f	2028-2
20281010	2028-10-10	2028	4	10	41	2	f	2028-2
20281011	2028-10-11	2028	4	10	41	3	f	2028-2
20281012	2028-10-12	2028	4	10	41	4	f	2028-2
20281013	2028-10-13	2028	4	10	41	5	f	2028-2
20281014	2028-10-14	2028	4	10	41	6	t	2028-2
20281015	2028-10-15	2028	4	10	41	7	t	2028-2
20281016	2028-10-16	2028	4	10	42	1	f	2028-2
20281017	2028-10-17	2028	4	10	42	2	f	2028-2
20281018	2028-10-18	2028	4	10	42	3	f	2028-2
20281019	2028-10-19	2028	4	10	42	4	f	2028-2
20281020	2028-10-20	2028	4	10	42	5	f	2028-2
20281021	2028-10-21	2028	4	10	42	6	t	2028-2
20281022	2028-10-22	2028	4	10	42	7	t	2028-2
20281023	2028-10-23	2028	4	10	43	1	f	2028-2
20281024	2028-10-24	2028	4	10	43	2	f	2028-2
20281025	2028-10-25	2028	4	10	43	3	f	2028-2
20281026	2028-10-26	2028	4	10	43	4	f	2028-2
20281027	2028-10-27	2028	4	10	43	5	f	2028-2
20281028	2028-10-28	2028	4	10	43	6	t	2028-2
20281029	2028-10-29	2028	4	10	43	7	t	2028-2
20281030	2028-10-30	2028	4	10	44	1	f	2028-2
20281031	2028-10-31	2028	4	10	44	2	f	2028-2
20281101	2028-11-01	2028	4	11	44	3	f	2028-2
20281102	2028-11-02	2028	4	11	44	4	f	2028-2
20281103	2028-11-03	2028	4	11	44	5	f	2028-2
20281104	2028-11-04	2028	4	11	44	6	t	2028-2
20281105	2028-11-05	2028	4	11	44	7	t	2028-2
20281106	2028-11-06	2028	4	11	45	1	f	2028-2
20281107	2028-11-07	2028	4	11	45	2	f	2028-2
20281108	2028-11-08	2028	4	11	45	3	f	2028-2
20281109	2028-11-09	2028	4	11	45	4	f	2028-2
20281110	2028-11-10	2028	4	11	45	5	f	2028-2
20281111	2028-11-11	2028	4	11	45	6	t	2028-2
20281112	2028-11-12	2028	4	11	45	7	t	2028-2
20281113	2028-11-13	2028	4	11	46	1	f	2028-2
20281114	2028-11-14	2028	4	11	46	2	f	2028-2
20281115	2028-11-15	2028	4	11	46	3	f	2028-2
20281116	2028-11-16	2028	4	11	46	4	f	2028-2
20281117	2028-11-17	2028	4	11	46	5	f	2028-2
20281118	2028-11-18	2028	4	11	46	6	t	2028-2
20281119	2028-11-19	2028	4	11	46	7	t	2028-2
20281120	2028-11-20	2028	4	11	47	1	f	2028-2
20281121	2028-11-21	2028	4	11	47	2	f	2028-2
20281122	2028-11-22	2028	4	11	47	3	f	2028-2
20281123	2028-11-23	2028	4	11	47	4	f	2028-2
20281124	2028-11-24	2028	4	11	47	5	f	2028-2
20281125	2028-11-25	2028	4	11	47	6	t	2028-2
20281126	2028-11-26	2028	4	11	47	7	t	2028-2
20281127	2028-11-27	2028	4	11	48	1	f	2028-2
20281128	2028-11-28	2028	4	11	48	2	f	2028-2
20281129	2028-11-29	2028	4	11	48	3	f	2028-2
20281130	2028-11-30	2028	4	11	48	4	f	2028-2
20281201	2028-12-01	2028	4	12	48	5	f	2028-2
20281202	2028-12-02	2028	4	12	48	6	t	2028-2
20281203	2028-12-03	2028	4	12	48	7	t	2028-2
20281204	2028-12-04	2028	4	12	49	1	f	2028-2
20281205	2028-12-05	2028	4	12	49	2	f	2028-2
20281206	2028-12-06	2028	4	12	49	3	f	2028-2
20281207	2028-12-07	2028	4	12	49	4	f	2028-2
20281208	2028-12-08	2028	4	12	49	5	f	2028-2
20281209	2028-12-09	2028	4	12	49	6	t	2028-2
20281210	2028-12-10	2028	4	12	49	7	t	2028-2
20281211	2028-12-11	2028	4	12	50	1	f	2028-2
20281212	2028-12-12	2028	4	12	50	2	f	2028-2
20281213	2028-12-13	2028	4	12	50	3	f	2028-2
20281214	2028-12-14	2028	4	12	50	4	f	2028-2
20281215	2028-12-15	2028	4	12	50	5	f	2028-2
20281216	2028-12-16	2028	4	12	50	6	t	2028-2
20281217	2028-12-17	2028	4	12	50	7	t	2028-2
20281218	2028-12-18	2028	4	12	51	1	f	2028-2
20281219	2028-12-19	2028	4	12	51	2	f	2028-2
20281220	2028-12-20	2028	4	12	51	3	f	2028-2
20281221	2028-12-21	2028	4	12	51	4	f	2028-2
20281222	2028-12-22	2028	4	12	51	5	f	2028-2
20281223	2028-12-23	2028	4	12	51	6	t	2028-2
20281224	2028-12-24	2028	4	12	51	7	t	2028-2
20281225	2028-12-25	2028	4	12	52	1	f	2028-2
20281226	2028-12-26	2028	4	12	52	2	f	2028-2
20281227	2028-12-27	2028	4	12	52	3	f	2028-2
20281228	2028-12-28	2028	4	12	52	4	f	2028-2
20281229	2028-12-29	2028	4	12	52	5	f	2028-2
20281230	2028-12-30	2028	4	12	52	6	t	2028-2
20281231	2028-12-31	2028	4	12	52	7	t	2028-2
20290101	2029-01-01	2029	1	1	1	1	f	2029-1
20290102	2029-01-02	2029	1	1	1	2	f	2029-1
20290103	2029-01-03	2029	1	1	1	3	f	2029-1
20290104	2029-01-04	2029	1	1	1	4	f	2029-1
20290105	2029-01-05	2029	1	1	1	5	f	2029-1
20290106	2029-01-06	2029	1	1	1	6	t	2029-1
20290107	2029-01-07	2029	1	1	1	7	t	2029-1
20290108	2029-01-08	2029	1	1	2	1	f	2029-1
20290109	2029-01-09	2029	1	1	2	2	f	2029-1
20290110	2029-01-10	2029	1	1	2	3	f	2029-1
20290111	2029-01-11	2029	1	1	2	4	f	2029-1
20290112	2029-01-12	2029	1	1	2	5	f	2029-1
20290113	2029-01-13	2029	1	1	2	6	t	2029-1
20290114	2029-01-14	2029	1	1	2	7	t	2029-1
20290115	2029-01-15	2029	1	1	3	1	f	2029-1
20290116	2029-01-16	2029	1	1	3	2	f	2029-1
20290117	2029-01-17	2029	1	1	3	3	f	2029-1
20290118	2029-01-18	2029	1	1	3	4	f	2029-1
20290119	2029-01-19	2029	1	1	3	5	f	2029-1
20290120	2029-01-20	2029	1	1	3	6	t	2029-1
20290121	2029-01-21	2029	1	1	3	7	t	2029-1
20290122	2029-01-22	2029	1	1	4	1	f	2029-1
20290123	2029-01-23	2029	1	1	4	2	f	2029-1
20290124	2029-01-24	2029	1	1	4	3	f	2029-1
20290125	2029-01-25	2029	1	1	4	4	f	2029-1
20290126	2029-01-26	2029	1	1	4	5	f	2029-1
20290127	2029-01-27	2029	1	1	4	6	t	2029-1
20290128	2029-01-28	2029	1	1	4	7	t	2029-1
20290129	2029-01-29	2029	1	1	5	1	f	2029-1
20290130	2029-01-30	2029	1	1	5	2	f	2029-1
20290131	2029-01-31	2029	1	1	5	3	f	2029-1
20290201	2029-02-01	2029	1	2	5	4	f	2029-1
20290202	2029-02-02	2029	1	2	5	5	f	2029-1
20290203	2029-02-03	2029	1	2	5	6	t	2029-1
20290204	2029-02-04	2029	1	2	5	7	t	2029-1
20290205	2029-02-05	2029	1	2	6	1	f	2029-1
20290206	2029-02-06	2029	1	2	6	2	f	2029-1
20290207	2029-02-07	2029	1	2	6	3	f	2029-1
20290208	2029-02-08	2029	1	2	6	4	f	2029-1
20290209	2029-02-09	2029	1	2	6	5	f	2029-1
20290210	2029-02-10	2029	1	2	6	6	t	2029-1
20290211	2029-02-11	2029	1	2	6	7	t	2029-1
20290212	2029-02-12	2029	1	2	7	1	f	2029-1
20290213	2029-02-13	2029	1	2	7	2	f	2029-1
20290214	2029-02-14	2029	1	2	7	3	f	2029-1
20290215	2029-02-15	2029	1	2	7	4	f	2029-1
20290216	2029-02-16	2029	1	2	7	5	f	2029-1
20290217	2029-02-17	2029	1	2	7	6	t	2029-1
20290218	2029-02-18	2029	1	2	7	7	t	2029-1
20290219	2029-02-19	2029	1	2	8	1	f	2029-1
20290220	2029-02-20	2029	1	2	8	2	f	2029-1
20290221	2029-02-21	2029	1	2	8	3	f	2029-1
20290222	2029-02-22	2029	1	2	8	4	f	2029-1
20290223	2029-02-23	2029	1	2	8	5	f	2029-1
20290224	2029-02-24	2029	1	2	8	6	t	2029-1
20290225	2029-02-25	2029	1	2	8	7	t	2029-1
20290226	2029-02-26	2029	1	2	9	1	f	2029-1
20290227	2029-02-27	2029	1	2	9	2	f	2029-1
20290228	2029-02-28	2029	1	2	9	3	f	2029-1
20290301	2029-03-01	2029	1	3	9	4	f	2029-1
20290302	2029-03-02	2029	1	3	9	5	f	2029-1
20290303	2029-03-03	2029	1	3	9	6	t	2029-1
20290304	2029-03-04	2029	1	3	9	7	t	2029-1
20290305	2029-03-05	2029	1	3	10	1	f	2029-1
20290306	2029-03-06	2029	1	3	10	2	f	2029-1
20290307	2029-03-07	2029	1	3	10	3	f	2029-1
20290308	2029-03-08	2029	1	3	10	4	f	2029-1
20290309	2029-03-09	2029	1	3	10	5	f	2029-1
20290310	2029-03-10	2029	1	3	10	6	t	2029-1
20290311	2029-03-11	2029	1	3	10	7	t	2029-1
20290312	2029-03-12	2029	1	3	11	1	f	2029-1
20290313	2029-03-13	2029	1	3	11	2	f	2029-1
20290314	2029-03-14	2029	1	3	11	3	f	2029-1
20290315	2029-03-15	2029	1	3	11	4	f	2029-1
20290316	2029-03-16	2029	1	3	11	5	f	2029-1
20290317	2029-03-17	2029	1	3	11	6	t	2029-1
20290318	2029-03-18	2029	1	3	11	7	t	2029-1
20290319	2029-03-19	2029	1	3	12	1	f	2029-1
20290320	2029-03-20	2029	1	3	12	2	f	2029-1
20290321	2029-03-21	2029	1	3	12	3	f	2029-1
20290322	2029-03-22	2029	1	3	12	4	f	2029-1
20290323	2029-03-23	2029	1	3	12	5	f	2029-1
20290324	2029-03-24	2029	1	3	12	6	t	2029-1
20290325	2029-03-25	2029	1	3	12	7	t	2029-1
20290326	2029-03-26	2029	1	3	13	1	f	2029-1
20290327	2029-03-27	2029	1	3	13	2	f	2029-1
20290328	2029-03-28	2029	1	3	13	3	f	2029-1
20290329	2029-03-29	2029	1	3	13	4	f	2029-1
20290330	2029-03-30	2029	1	3	13	5	f	2029-1
20290331	2029-03-31	2029	1	3	13	6	t	2029-1
20290401	2029-04-01	2029	2	4	13	7	t	2029-1
20290402	2029-04-02	2029	2	4	14	1	f	2029-1
20290403	2029-04-03	2029	2	4	14	2	f	2029-1
20290404	2029-04-04	2029	2	4	14	3	f	2029-1
20290405	2029-04-05	2029	2	4	14	4	f	2029-1
20290406	2029-04-06	2029	2	4	14	5	f	2029-1
20290407	2029-04-07	2029	2	4	14	6	t	2029-1
20290408	2029-04-08	2029	2	4	14	7	t	2029-1
20290409	2029-04-09	2029	2	4	15	1	f	2029-1
20290410	2029-04-10	2029	2	4	15	2	f	2029-1
20290411	2029-04-11	2029	2	4	15	3	f	2029-1
20290412	2029-04-12	2029	2	4	15	4	f	2029-1
20290413	2029-04-13	2029	2	4	15	5	f	2029-1
20290414	2029-04-14	2029	2	4	15	6	t	2029-1
20290415	2029-04-15	2029	2	4	15	7	t	2029-1
20290416	2029-04-16	2029	2	4	16	1	f	2029-1
20290417	2029-04-17	2029	2	4	16	2	f	2029-1
20290418	2029-04-18	2029	2	4	16	3	f	2029-1
20290419	2029-04-19	2029	2	4	16	4	f	2029-1
20290420	2029-04-20	2029	2	4	16	5	f	2029-1
20290421	2029-04-21	2029	2	4	16	6	t	2029-1
20290422	2029-04-22	2029	2	4	16	7	t	2029-1
20290423	2029-04-23	2029	2	4	17	1	f	2029-1
20290424	2029-04-24	2029	2	4	17	2	f	2029-1
20290425	2029-04-25	2029	2	4	17	3	f	2029-1
20290426	2029-04-26	2029	2	4	17	4	f	2029-1
20290427	2029-04-27	2029	2	4	17	5	f	2029-1
20290428	2029-04-28	2029	2	4	17	6	t	2029-1
20290429	2029-04-29	2029	2	4	17	7	t	2029-1
20290430	2029-04-30	2029	2	4	18	1	f	2029-1
20290501	2029-05-01	2029	2	5	18	2	f	2029-1
20290502	2029-05-02	2029	2	5	18	3	f	2029-1
20290503	2029-05-03	2029	2	5	18	4	f	2029-1
20290504	2029-05-04	2029	2	5	18	5	f	2029-1
20290505	2029-05-05	2029	2	5	18	6	t	2029-1
20290506	2029-05-06	2029	2	5	18	7	t	2029-1
20290507	2029-05-07	2029	2	5	19	1	f	2029-1
20290508	2029-05-08	2029	2	5	19	2	f	2029-1
20290509	2029-05-09	2029	2	5	19	3	f	2029-1
20290510	2029-05-10	2029	2	5	19	4	f	2029-1
20290511	2029-05-11	2029	2	5	19	5	f	2029-1
20290512	2029-05-12	2029	2	5	19	6	t	2029-1
20290513	2029-05-13	2029	2	5	19	7	t	2029-1
20290514	2029-05-14	2029	2	5	20	1	f	2029-1
20290515	2029-05-15	2029	2	5	20	2	f	2029-1
20290516	2029-05-16	2029	2	5	20	3	f	2029-1
20290517	2029-05-17	2029	2	5	20	4	f	2029-1
20290518	2029-05-18	2029	2	5	20	5	f	2029-1
20290519	2029-05-19	2029	2	5	20	6	t	2029-1
20290520	2029-05-20	2029	2	5	20	7	t	2029-1
20290521	2029-05-21	2029	2	5	21	1	f	2029-1
20290522	2029-05-22	2029	2	5	21	2	f	2029-1
20290523	2029-05-23	2029	2	5	21	3	f	2029-1
20290524	2029-05-24	2029	2	5	21	4	f	2029-1
20290525	2029-05-25	2029	2	5	21	5	f	2029-1
20290526	2029-05-26	2029	2	5	21	6	t	2029-1
20290527	2029-05-27	2029	2	5	21	7	t	2029-1
20290528	2029-05-28	2029	2	5	22	1	f	2029-1
20290529	2029-05-29	2029	2	5	22	2	f	2029-1
20290530	2029-05-30	2029	2	5	22	3	f	2029-1
20290531	2029-05-31	2029	2	5	22	4	f	2029-1
20290601	2029-06-01	2029	2	6	22	5	f	2029-1
20290602	2029-06-02	2029	2	6	22	6	t	2029-1
20290603	2029-06-03	2029	2	6	22	7	t	2029-1
20290604	2029-06-04	2029	2	6	23	1	f	2029-1
20290605	2029-06-05	2029	2	6	23	2	f	2029-1
20290606	2029-06-06	2029	2	6	23	3	f	2029-1
20290607	2029-06-07	2029	2	6	23	4	f	2029-1
20290608	2029-06-08	2029	2	6	23	5	f	2029-1
20290609	2029-06-09	2029	2	6	23	6	t	2029-1
20290610	2029-06-10	2029	2	6	23	7	t	2029-1
20290611	2029-06-11	2029	2	6	24	1	f	2029-1
20290612	2029-06-12	2029	2	6	24	2	f	2029-1
20290613	2029-06-13	2029	2	6	24	3	f	2029-1
20290614	2029-06-14	2029	2	6	24	4	f	2029-1
20290615	2029-06-15	2029	2	6	24	5	f	2029-1
20290616	2029-06-16	2029	2	6	24	6	t	2029-1
20290617	2029-06-17	2029	2	6	24	7	t	2029-1
20290618	2029-06-18	2029	2	6	25	1	f	2029-1
20290619	2029-06-19	2029	2	6	25	2	f	2029-1
20290620	2029-06-20	2029	2	6	25	3	f	2029-1
20290621	2029-06-21	2029	2	6	25	4	f	2029-1
20290622	2029-06-22	2029	2	6	25	5	f	2029-1
20290623	2029-06-23	2029	2	6	25	6	t	2029-1
20290624	2029-06-24	2029	2	6	25	7	t	2029-1
20290625	2029-06-25	2029	2	6	26	1	f	2029-1
20290626	2029-06-26	2029	2	6	26	2	f	2029-1
20290627	2029-06-27	2029	2	6	26	3	f	2029-1
20290628	2029-06-28	2029	2	6	26	4	f	2029-1
20290629	2029-06-29	2029	2	6	26	5	f	2029-1
20290630	2029-06-30	2029	2	6	26	6	t	2029-1
20290701	2029-07-01	2029	3	7	26	7	t	2029-2
20290702	2029-07-02	2029	3	7	27	1	f	2029-2
20290703	2029-07-03	2029	3	7	27	2	f	2029-2
20290704	2029-07-04	2029	3	7	27	3	f	2029-2
20290705	2029-07-05	2029	3	7	27	4	f	2029-2
20290706	2029-07-06	2029	3	7	27	5	f	2029-2
20290707	2029-07-07	2029	3	7	27	6	t	2029-2
20290708	2029-07-08	2029	3	7	27	7	t	2029-2
20290709	2029-07-09	2029	3	7	28	1	f	2029-2
20290710	2029-07-10	2029	3	7	28	2	f	2029-2
20290711	2029-07-11	2029	3	7	28	3	f	2029-2
20290712	2029-07-12	2029	3	7	28	4	f	2029-2
20290713	2029-07-13	2029	3	7	28	5	f	2029-2
20290714	2029-07-14	2029	3	7	28	6	t	2029-2
20290715	2029-07-15	2029	3	7	28	7	t	2029-2
20290716	2029-07-16	2029	3	7	29	1	f	2029-2
20290717	2029-07-17	2029	3	7	29	2	f	2029-2
20290718	2029-07-18	2029	3	7	29	3	f	2029-2
20290719	2029-07-19	2029	3	7	29	4	f	2029-2
20290720	2029-07-20	2029	3	7	29	5	f	2029-2
20290721	2029-07-21	2029	3	7	29	6	t	2029-2
20290722	2029-07-22	2029	3	7	29	7	t	2029-2
20290723	2029-07-23	2029	3	7	30	1	f	2029-2
20290724	2029-07-24	2029	3	7	30	2	f	2029-2
20290725	2029-07-25	2029	3	7	30	3	f	2029-2
20290726	2029-07-26	2029	3	7	30	4	f	2029-2
20290727	2029-07-27	2029	3	7	30	5	f	2029-2
20290728	2029-07-28	2029	3	7	30	6	t	2029-2
20290729	2029-07-29	2029	3	7	30	7	t	2029-2
20290730	2029-07-30	2029	3	7	31	1	f	2029-2
20290731	2029-07-31	2029	3	7	31	2	f	2029-2
20290801	2029-08-01	2029	3	8	31	3	f	2029-2
20290802	2029-08-02	2029	3	8	31	4	f	2029-2
20290803	2029-08-03	2029	3	8	31	5	f	2029-2
20290804	2029-08-04	2029	3	8	31	6	t	2029-2
20290805	2029-08-05	2029	3	8	31	7	t	2029-2
20290806	2029-08-06	2029	3	8	32	1	f	2029-2
20290807	2029-08-07	2029	3	8	32	2	f	2029-2
20290808	2029-08-08	2029	3	8	32	3	f	2029-2
20290809	2029-08-09	2029	3	8	32	4	f	2029-2
20290810	2029-08-10	2029	3	8	32	5	f	2029-2
20290811	2029-08-11	2029	3	8	32	6	t	2029-2
20290812	2029-08-12	2029	3	8	32	7	t	2029-2
20290813	2029-08-13	2029	3	8	33	1	f	2029-2
20290814	2029-08-14	2029	3	8	33	2	f	2029-2
20290815	2029-08-15	2029	3	8	33	3	f	2029-2
20290816	2029-08-16	2029	3	8	33	4	f	2029-2
20290817	2029-08-17	2029	3	8	33	5	f	2029-2
20290818	2029-08-18	2029	3	8	33	6	t	2029-2
20290819	2029-08-19	2029	3	8	33	7	t	2029-2
20290820	2029-08-20	2029	3	8	34	1	f	2029-2
20290821	2029-08-21	2029	3	8	34	2	f	2029-2
20290822	2029-08-22	2029	3	8	34	3	f	2029-2
20290823	2029-08-23	2029	3	8	34	4	f	2029-2
20290824	2029-08-24	2029	3	8	34	5	f	2029-2
20290825	2029-08-25	2029	3	8	34	6	t	2029-2
20290826	2029-08-26	2029	3	8	34	7	t	2029-2
20290827	2029-08-27	2029	3	8	35	1	f	2029-2
20290828	2029-08-28	2029	3	8	35	2	f	2029-2
20290829	2029-08-29	2029	3	8	35	3	f	2029-2
20290830	2029-08-30	2029	3	8	35	4	f	2029-2
20290831	2029-08-31	2029	3	8	35	5	f	2029-2
20290901	2029-09-01	2029	3	9	35	6	t	2029-2
20290902	2029-09-02	2029	3	9	35	7	t	2029-2
20290903	2029-09-03	2029	3	9	36	1	f	2029-2
20290904	2029-09-04	2029	3	9	36	2	f	2029-2
20290905	2029-09-05	2029	3	9	36	3	f	2029-2
20290906	2029-09-06	2029	3	9	36	4	f	2029-2
20290907	2029-09-07	2029	3	9	36	5	f	2029-2
20290908	2029-09-08	2029	3	9	36	6	t	2029-2
20290909	2029-09-09	2029	3	9	36	7	t	2029-2
20290910	2029-09-10	2029	3	9	37	1	f	2029-2
20290911	2029-09-11	2029	3	9	37	2	f	2029-2
20290912	2029-09-12	2029	3	9	37	3	f	2029-2
20290913	2029-09-13	2029	3	9	37	4	f	2029-2
20290914	2029-09-14	2029	3	9	37	5	f	2029-2
20290915	2029-09-15	2029	3	9	37	6	t	2029-2
20290916	2029-09-16	2029	3	9	37	7	t	2029-2
20290917	2029-09-17	2029	3	9	38	1	f	2029-2
20290918	2029-09-18	2029	3	9	38	2	f	2029-2
20290919	2029-09-19	2029	3	9	38	3	f	2029-2
20290920	2029-09-20	2029	3	9	38	4	f	2029-2
20290921	2029-09-21	2029	3	9	38	5	f	2029-2
20290922	2029-09-22	2029	3	9	38	6	t	2029-2
20290923	2029-09-23	2029	3	9	38	7	t	2029-2
20290924	2029-09-24	2029	3	9	39	1	f	2029-2
20290925	2029-09-25	2029	3	9	39	2	f	2029-2
20290926	2029-09-26	2029	3	9	39	3	f	2029-2
20290927	2029-09-27	2029	3	9	39	4	f	2029-2
20290928	2029-09-28	2029	3	9	39	5	f	2029-2
20290929	2029-09-29	2029	3	9	39	6	t	2029-2
20290930	2029-09-30	2029	3	9	39	7	t	2029-2
20291001	2029-10-01	2029	4	10	40	1	f	2029-2
20291002	2029-10-02	2029	4	10	40	2	f	2029-2
20291003	2029-10-03	2029	4	10	40	3	f	2029-2
20291004	2029-10-04	2029	4	10	40	4	f	2029-2
20291005	2029-10-05	2029	4	10	40	5	f	2029-2
20291006	2029-10-06	2029	4	10	40	6	t	2029-2
20291007	2029-10-07	2029	4	10	40	7	t	2029-2
20291008	2029-10-08	2029	4	10	41	1	f	2029-2
20291009	2029-10-09	2029	4	10	41	2	f	2029-2
20291010	2029-10-10	2029	4	10	41	3	f	2029-2
20291011	2029-10-11	2029	4	10	41	4	f	2029-2
20291012	2029-10-12	2029	4	10	41	5	f	2029-2
20291013	2029-10-13	2029	4	10	41	6	t	2029-2
20291014	2029-10-14	2029	4	10	41	7	t	2029-2
20291015	2029-10-15	2029	4	10	42	1	f	2029-2
20291016	2029-10-16	2029	4	10	42	2	f	2029-2
20291017	2029-10-17	2029	4	10	42	3	f	2029-2
20291018	2029-10-18	2029	4	10	42	4	f	2029-2
20291019	2029-10-19	2029	4	10	42	5	f	2029-2
20291020	2029-10-20	2029	4	10	42	6	t	2029-2
20291021	2029-10-21	2029	4	10	42	7	t	2029-2
20291022	2029-10-22	2029	4	10	43	1	f	2029-2
20291023	2029-10-23	2029	4	10	43	2	f	2029-2
20291024	2029-10-24	2029	4	10	43	3	f	2029-2
20291025	2029-10-25	2029	4	10	43	4	f	2029-2
20291026	2029-10-26	2029	4	10	43	5	f	2029-2
20291027	2029-10-27	2029	4	10	43	6	t	2029-2
20291028	2029-10-28	2029	4	10	43	7	t	2029-2
20291029	2029-10-29	2029	4	10	44	1	f	2029-2
20291030	2029-10-30	2029	4	10	44	2	f	2029-2
20291031	2029-10-31	2029	4	10	44	3	f	2029-2
20291101	2029-11-01	2029	4	11	44	4	f	2029-2
20291102	2029-11-02	2029	4	11	44	5	f	2029-2
20291103	2029-11-03	2029	4	11	44	6	t	2029-2
20291104	2029-11-04	2029	4	11	44	7	t	2029-2
20291105	2029-11-05	2029	4	11	45	1	f	2029-2
20291106	2029-11-06	2029	4	11	45	2	f	2029-2
20291107	2029-11-07	2029	4	11	45	3	f	2029-2
20291108	2029-11-08	2029	4	11	45	4	f	2029-2
20291109	2029-11-09	2029	4	11	45	5	f	2029-2
20291110	2029-11-10	2029	4	11	45	6	t	2029-2
20291111	2029-11-11	2029	4	11	45	7	t	2029-2
20291112	2029-11-12	2029	4	11	46	1	f	2029-2
20291113	2029-11-13	2029	4	11	46	2	f	2029-2
20291114	2029-11-14	2029	4	11	46	3	f	2029-2
20291115	2029-11-15	2029	4	11	46	4	f	2029-2
20291116	2029-11-16	2029	4	11	46	5	f	2029-2
20291117	2029-11-17	2029	4	11	46	6	t	2029-2
20291118	2029-11-18	2029	4	11	46	7	t	2029-2
20291119	2029-11-19	2029	4	11	47	1	f	2029-2
20291120	2029-11-20	2029	4	11	47	2	f	2029-2
20291121	2029-11-21	2029	4	11	47	3	f	2029-2
20291122	2029-11-22	2029	4	11	47	4	f	2029-2
20291123	2029-11-23	2029	4	11	47	5	f	2029-2
20291124	2029-11-24	2029	4	11	47	6	t	2029-2
20291125	2029-11-25	2029	4	11	47	7	t	2029-2
20291126	2029-11-26	2029	4	11	48	1	f	2029-2
20291127	2029-11-27	2029	4	11	48	2	f	2029-2
20291128	2029-11-28	2029	4	11	48	3	f	2029-2
20291129	2029-11-29	2029	4	11	48	4	f	2029-2
20291130	2029-11-30	2029	4	11	48	5	f	2029-2
20291201	2029-12-01	2029	4	12	48	6	t	2029-2
20291202	2029-12-02	2029	4	12	48	7	t	2029-2
20291203	2029-12-03	2029	4	12	49	1	f	2029-2
20291204	2029-12-04	2029	4	12	49	2	f	2029-2
20291205	2029-12-05	2029	4	12	49	3	f	2029-2
20291206	2029-12-06	2029	4	12	49	4	f	2029-2
20291207	2029-12-07	2029	4	12	49	5	f	2029-2
20291208	2029-12-08	2029	4	12	49	6	t	2029-2
20291209	2029-12-09	2029	4	12	49	7	t	2029-2
20291210	2029-12-10	2029	4	12	50	1	f	2029-2
20291211	2029-12-11	2029	4	12	50	2	f	2029-2
20291212	2029-12-12	2029	4	12	50	3	f	2029-2
20291213	2029-12-13	2029	4	12	50	4	f	2029-2
20291214	2029-12-14	2029	4	12	50	5	f	2029-2
20291215	2029-12-15	2029	4	12	50	6	t	2029-2
20291216	2029-12-16	2029	4	12	50	7	t	2029-2
20291217	2029-12-17	2029	4	12	51	1	f	2029-2
20291218	2029-12-18	2029	4	12	51	2	f	2029-2
20291219	2029-12-19	2029	4	12	51	3	f	2029-2
20291220	2029-12-20	2029	4	12	51	4	f	2029-2
20291221	2029-12-21	2029	4	12	51	5	f	2029-2
20291222	2029-12-22	2029	4	12	51	6	t	2029-2
20291223	2029-12-23	2029	4	12	51	7	t	2029-2
20291224	2029-12-24	2029	4	12	52	1	f	2029-2
20291225	2029-12-25	2029	4	12	52	2	f	2029-2
20291226	2029-12-26	2029	4	12	52	3	f	2029-2
20291227	2029-12-27	2029	4	12	52	4	f	2029-2
20291228	2029-12-28	2029	4	12	52	5	f	2029-2
20291229	2029-12-29	2029	4	12	52	6	t	2029-2
20291230	2029-12-30	2029	4	12	52	7	t	2029-2
20291231	2029-12-31	2029	4	12	1	1	f	2029-2
20300101	2030-01-01	2030	1	1	1	2	f	2030-1
20300102	2030-01-02	2030	1	1	1	3	f	2030-1
20300103	2030-01-03	2030	1	1	1	4	f	2030-1
20300104	2030-01-04	2030	1	1	1	5	f	2030-1
20300105	2030-01-05	2030	1	1	1	6	t	2030-1
20300106	2030-01-06	2030	1	1	1	7	t	2030-1
20300107	2030-01-07	2030	1	1	2	1	f	2030-1
20300108	2030-01-08	2030	1	1	2	2	f	2030-1
20300109	2030-01-09	2030	1	1	2	3	f	2030-1
20300110	2030-01-10	2030	1	1	2	4	f	2030-1
20300111	2030-01-11	2030	1	1	2	5	f	2030-1
20300112	2030-01-12	2030	1	1	2	6	t	2030-1
20300113	2030-01-13	2030	1	1	2	7	t	2030-1
20300114	2030-01-14	2030	1	1	3	1	f	2030-1
20300115	2030-01-15	2030	1	1	3	2	f	2030-1
20300116	2030-01-16	2030	1	1	3	3	f	2030-1
20300117	2030-01-17	2030	1	1	3	4	f	2030-1
20300118	2030-01-18	2030	1	1	3	5	f	2030-1
20300119	2030-01-19	2030	1	1	3	6	t	2030-1
20300120	2030-01-20	2030	1	1	3	7	t	2030-1
20300121	2030-01-21	2030	1	1	4	1	f	2030-1
20300122	2030-01-22	2030	1	1	4	2	f	2030-1
20300123	2030-01-23	2030	1	1	4	3	f	2030-1
20300124	2030-01-24	2030	1	1	4	4	f	2030-1
20300125	2030-01-25	2030	1	1	4	5	f	2030-1
20300126	2030-01-26	2030	1	1	4	6	t	2030-1
20300127	2030-01-27	2030	1	1	4	7	t	2030-1
20300128	2030-01-28	2030	1	1	5	1	f	2030-1
20300129	2030-01-29	2030	1	1	5	2	f	2030-1
20300130	2030-01-30	2030	1	1	5	3	f	2030-1
20300131	2030-01-31	2030	1	1	5	4	f	2030-1
20300201	2030-02-01	2030	1	2	5	5	f	2030-1
20300202	2030-02-02	2030	1	2	5	6	t	2030-1
20300203	2030-02-03	2030	1	2	5	7	t	2030-1
20300204	2030-02-04	2030	1	2	6	1	f	2030-1
20300205	2030-02-05	2030	1	2	6	2	f	2030-1
20300206	2030-02-06	2030	1	2	6	3	f	2030-1
20300207	2030-02-07	2030	1	2	6	4	f	2030-1
20300208	2030-02-08	2030	1	2	6	5	f	2030-1
20300209	2030-02-09	2030	1	2	6	6	t	2030-1
20300210	2030-02-10	2030	1	2	6	7	t	2030-1
20300211	2030-02-11	2030	1	2	7	1	f	2030-1
20300212	2030-02-12	2030	1	2	7	2	f	2030-1
20300213	2030-02-13	2030	1	2	7	3	f	2030-1
20300214	2030-02-14	2030	1	2	7	4	f	2030-1
20300215	2030-02-15	2030	1	2	7	5	f	2030-1
20300216	2030-02-16	2030	1	2	7	6	t	2030-1
20300217	2030-02-17	2030	1	2	7	7	t	2030-1
20300218	2030-02-18	2030	1	2	8	1	f	2030-1
20300219	2030-02-19	2030	1	2	8	2	f	2030-1
20300220	2030-02-20	2030	1	2	8	3	f	2030-1
20300221	2030-02-21	2030	1	2	8	4	f	2030-1
20300222	2030-02-22	2030	1	2	8	5	f	2030-1
20300223	2030-02-23	2030	1	2	8	6	t	2030-1
20300224	2030-02-24	2030	1	2	8	7	t	2030-1
20300225	2030-02-25	2030	1	2	9	1	f	2030-1
20300226	2030-02-26	2030	1	2	9	2	f	2030-1
20300227	2030-02-27	2030	1	2	9	3	f	2030-1
20300228	2030-02-28	2030	1	2	9	4	f	2030-1
20300301	2030-03-01	2030	1	3	9	5	f	2030-1
20300302	2030-03-02	2030	1	3	9	6	t	2030-1
20300303	2030-03-03	2030	1	3	9	7	t	2030-1
20300304	2030-03-04	2030	1	3	10	1	f	2030-1
20300305	2030-03-05	2030	1	3	10	2	f	2030-1
20300306	2030-03-06	2030	1	3	10	3	f	2030-1
20300307	2030-03-07	2030	1	3	10	4	f	2030-1
20300308	2030-03-08	2030	1	3	10	5	f	2030-1
20300309	2030-03-09	2030	1	3	10	6	t	2030-1
20300310	2030-03-10	2030	1	3	10	7	t	2030-1
20300311	2030-03-11	2030	1	3	11	1	f	2030-1
20300312	2030-03-12	2030	1	3	11	2	f	2030-1
20300313	2030-03-13	2030	1	3	11	3	f	2030-1
20300314	2030-03-14	2030	1	3	11	4	f	2030-1
20300315	2030-03-15	2030	1	3	11	5	f	2030-1
20300316	2030-03-16	2030	1	3	11	6	t	2030-1
20300317	2030-03-17	2030	1	3	11	7	t	2030-1
20300318	2030-03-18	2030	1	3	12	1	f	2030-1
20300319	2030-03-19	2030	1	3	12	2	f	2030-1
20300320	2030-03-20	2030	1	3	12	3	f	2030-1
20300321	2030-03-21	2030	1	3	12	4	f	2030-1
20300322	2030-03-22	2030	1	3	12	5	f	2030-1
20300323	2030-03-23	2030	1	3	12	6	t	2030-1
20300324	2030-03-24	2030	1	3	12	7	t	2030-1
20300325	2030-03-25	2030	1	3	13	1	f	2030-1
20300326	2030-03-26	2030	1	3	13	2	f	2030-1
20300327	2030-03-27	2030	1	3	13	3	f	2030-1
20300328	2030-03-28	2030	1	3	13	4	f	2030-1
20300329	2030-03-29	2030	1	3	13	5	f	2030-1
20300330	2030-03-30	2030	1	3	13	6	t	2030-1
20300331	2030-03-31	2030	1	3	13	7	t	2030-1
20300401	2030-04-01	2030	2	4	14	1	f	2030-1
20300402	2030-04-02	2030	2	4	14	2	f	2030-1
20300403	2030-04-03	2030	2	4	14	3	f	2030-1
20300404	2030-04-04	2030	2	4	14	4	f	2030-1
20300405	2030-04-05	2030	2	4	14	5	f	2030-1
20300406	2030-04-06	2030	2	4	14	6	t	2030-1
20300407	2030-04-07	2030	2	4	14	7	t	2030-1
20300408	2030-04-08	2030	2	4	15	1	f	2030-1
20300409	2030-04-09	2030	2	4	15	2	f	2030-1
20300410	2030-04-10	2030	2	4	15	3	f	2030-1
20300411	2030-04-11	2030	2	4	15	4	f	2030-1
20300412	2030-04-12	2030	2	4	15	5	f	2030-1
20300413	2030-04-13	2030	2	4	15	6	t	2030-1
20300414	2030-04-14	2030	2	4	15	7	t	2030-1
20300415	2030-04-15	2030	2	4	16	1	f	2030-1
20300416	2030-04-16	2030	2	4	16	2	f	2030-1
20300417	2030-04-17	2030	2	4	16	3	f	2030-1
20300418	2030-04-18	2030	2	4	16	4	f	2030-1
20300419	2030-04-19	2030	2	4	16	5	f	2030-1
20300420	2030-04-20	2030	2	4	16	6	t	2030-1
20300421	2030-04-21	2030	2	4	16	7	t	2030-1
20300422	2030-04-22	2030	2	4	17	1	f	2030-1
20300423	2030-04-23	2030	2	4	17	2	f	2030-1
20300424	2030-04-24	2030	2	4	17	3	f	2030-1
20300425	2030-04-25	2030	2	4	17	4	f	2030-1
20300426	2030-04-26	2030	2	4	17	5	f	2030-1
20300427	2030-04-27	2030	2	4	17	6	t	2030-1
20300428	2030-04-28	2030	2	4	17	7	t	2030-1
20300429	2030-04-29	2030	2	4	18	1	f	2030-1
20300430	2030-04-30	2030	2	4	18	2	f	2030-1
20300501	2030-05-01	2030	2	5	18	3	f	2030-1
20300502	2030-05-02	2030	2	5	18	4	f	2030-1
20300503	2030-05-03	2030	2	5	18	5	f	2030-1
20300504	2030-05-04	2030	2	5	18	6	t	2030-1
20300505	2030-05-05	2030	2	5	18	7	t	2030-1
20300506	2030-05-06	2030	2	5	19	1	f	2030-1
20300507	2030-05-07	2030	2	5	19	2	f	2030-1
20300508	2030-05-08	2030	2	5	19	3	f	2030-1
20300509	2030-05-09	2030	2	5	19	4	f	2030-1
20300510	2030-05-10	2030	2	5	19	5	f	2030-1
20300511	2030-05-11	2030	2	5	19	6	t	2030-1
20300512	2030-05-12	2030	2	5	19	7	t	2030-1
20300513	2030-05-13	2030	2	5	20	1	f	2030-1
20300514	2030-05-14	2030	2	5	20	2	f	2030-1
20300515	2030-05-15	2030	2	5	20	3	f	2030-1
20300516	2030-05-16	2030	2	5	20	4	f	2030-1
20300517	2030-05-17	2030	2	5	20	5	f	2030-1
20300518	2030-05-18	2030	2	5	20	6	t	2030-1
20300519	2030-05-19	2030	2	5	20	7	t	2030-1
20300520	2030-05-20	2030	2	5	21	1	f	2030-1
20300521	2030-05-21	2030	2	5	21	2	f	2030-1
20300522	2030-05-22	2030	2	5	21	3	f	2030-1
20300523	2030-05-23	2030	2	5	21	4	f	2030-1
20300524	2030-05-24	2030	2	5	21	5	f	2030-1
20300525	2030-05-25	2030	2	5	21	6	t	2030-1
20300526	2030-05-26	2030	2	5	21	7	t	2030-1
20300527	2030-05-27	2030	2	5	22	1	f	2030-1
20300528	2030-05-28	2030	2	5	22	2	f	2030-1
20300529	2030-05-29	2030	2	5	22	3	f	2030-1
20300530	2030-05-30	2030	2	5	22	4	f	2030-1
20300531	2030-05-31	2030	2	5	22	5	f	2030-1
20300601	2030-06-01	2030	2	6	22	6	t	2030-1
20300602	2030-06-02	2030	2	6	22	7	t	2030-1
20300603	2030-06-03	2030	2	6	23	1	f	2030-1
20300604	2030-06-04	2030	2	6	23	2	f	2030-1
20300605	2030-06-05	2030	2	6	23	3	f	2030-1
20300606	2030-06-06	2030	2	6	23	4	f	2030-1
20300607	2030-06-07	2030	2	6	23	5	f	2030-1
20300608	2030-06-08	2030	2	6	23	6	t	2030-1
20300609	2030-06-09	2030	2	6	23	7	t	2030-1
20300610	2030-06-10	2030	2	6	24	1	f	2030-1
20300611	2030-06-11	2030	2	6	24	2	f	2030-1
20300612	2030-06-12	2030	2	6	24	3	f	2030-1
20300613	2030-06-13	2030	2	6	24	4	f	2030-1
20300614	2030-06-14	2030	2	6	24	5	f	2030-1
20300615	2030-06-15	2030	2	6	24	6	t	2030-1
20300616	2030-06-16	2030	2	6	24	7	t	2030-1
20300617	2030-06-17	2030	2	6	25	1	f	2030-1
20300618	2030-06-18	2030	2	6	25	2	f	2030-1
20300619	2030-06-19	2030	2	6	25	3	f	2030-1
20300620	2030-06-20	2030	2	6	25	4	f	2030-1
20300621	2030-06-21	2030	2	6	25	5	f	2030-1
20300622	2030-06-22	2030	2	6	25	6	t	2030-1
20300623	2030-06-23	2030	2	6	25	7	t	2030-1
20300624	2030-06-24	2030	2	6	26	1	f	2030-1
20300625	2030-06-25	2030	2	6	26	2	f	2030-1
20300626	2030-06-26	2030	2	6	26	3	f	2030-1
20300627	2030-06-27	2030	2	6	26	4	f	2030-1
20300628	2030-06-28	2030	2	6	26	5	f	2030-1
20300629	2030-06-29	2030	2	6	26	6	t	2030-1
20300630	2030-06-30	2030	2	6	26	7	t	2030-1
20300701	2030-07-01	2030	3	7	27	1	f	2030-2
20300702	2030-07-02	2030	3	7	27	2	f	2030-2
20300703	2030-07-03	2030	3	7	27	3	f	2030-2
20300704	2030-07-04	2030	3	7	27	4	f	2030-2
20300705	2030-07-05	2030	3	7	27	5	f	2030-2
20300706	2030-07-06	2030	3	7	27	6	t	2030-2
20300707	2030-07-07	2030	3	7	27	7	t	2030-2
20300708	2030-07-08	2030	3	7	28	1	f	2030-2
20300709	2030-07-09	2030	3	7	28	2	f	2030-2
20300710	2030-07-10	2030	3	7	28	3	f	2030-2
20300711	2030-07-11	2030	3	7	28	4	f	2030-2
20300712	2030-07-12	2030	3	7	28	5	f	2030-2
20300713	2030-07-13	2030	3	7	28	6	t	2030-2
20300714	2030-07-14	2030	3	7	28	7	t	2030-2
20300715	2030-07-15	2030	3	7	29	1	f	2030-2
20300716	2030-07-16	2030	3	7	29	2	f	2030-2
20300717	2030-07-17	2030	3	7	29	3	f	2030-2
20300718	2030-07-18	2030	3	7	29	4	f	2030-2
20300719	2030-07-19	2030	3	7	29	5	f	2030-2
20300720	2030-07-20	2030	3	7	29	6	t	2030-2
20300721	2030-07-21	2030	3	7	29	7	t	2030-2
20300722	2030-07-22	2030	3	7	30	1	f	2030-2
20300723	2030-07-23	2030	3	7	30	2	f	2030-2
20300724	2030-07-24	2030	3	7	30	3	f	2030-2
20300725	2030-07-25	2030	3	7	30	4	f	2030-2
20300726	2030-07-26	2030	3	7	30	5	f	2030-2
20300727	2030-07-27	2030	3	7	30	6	t	2030-2
20300728	2030-07-28	2030	3	7	30	7	t	2030-2
20300729	2030-07-29	2030	3	7	31	1	f	2030-2
20300730	2030-07-30	2030	3	7	31	2	f	2030-2
20300731	2030-07-31	2030	3	7	31	3	f	2030-2
20300801	2030-08-01	2030	3	8	31	4	f	2030-2
20300802	2030-08-02	2030	3	8	31	5	f	2030-2
20300803	2030-08-03	2030	3	8	31	6	t	2030-2
20300804	2030-08-04	2030	3	8	31	7	t	2030-2
20300805	2030-08-05	2030	3	8	32	1	f	2030-2
20300806	2030-08-06	2030	3	8	32	2	f	2030-2
20300807	2030-08-07	2030	3	8	32	3	f	2030-2
20300808	2030-08-08	2030	3	8	32	4	f	2030-2
20300809	2030-08-09	2030	3	8	32	5	f	2030-2
20300810	2030-08-10	2030	3	8	32	6	t	2030-2
20300811	2030-08-11	2030	3	8	32	7	t	2030-2
20300812	2030-08-12	2030	3	8	33	1	f	2030-2
20300813	2030-08-13	2030	3	8	33	2	f	2030-2
20300814	2030-08-14	2030	3	8	33	3	f	2030-2
20300815	2030-08-15	2030	3	8	33	4	f	2030-2
20300816	2030-08-16	2030	3	8	33	5	f	2030-2
20300817	2030-08-17	2030	3	8	33	6	t	2030-2
20300818	2030-08-18	2030	3	8	33	7	t	2030-2
20300819	2030-08-19	2030	3	8	34	1	f	2030-2
20300820	2030-08-20	2030	3	8	34	2	f	2030-2
20300821	2030-08-21	2030	3	8	34	3	f	2030-2
20300822	2030-08-22	2030	3	8	34	4	f	2030-2
20300823	2030-08-23	2030	3	8	34	5	f	2030-2
20300824	2030-08-24	2030	3	8	34	6	t	2030-2
20300825	2030-08-25	2030	3	8	34	7	t	2030-2
20300826	2030-08-26	2030	3	8	35	1	f	2030-2
20300827	2030-08-27	2030	3	8	35	2	f	2030-2
20300828	2030-08-28	2030	3	8	35	3	f	2030-2
20300829	2030-08-29	2030	3	8	35	4	f	2030-2
20300830	2030-08-30	2030	3	8	35	5	f	2030-2
20300831	2030-08-31	2030	3	8	35	6	t	2030-2
20300901	2030-09-01	2030	3	9	35	7	t	2030-2
20300902	2030-09-02	2030	3	9	36	1	f	2030-2
20300903	2030-09-03	2030	3	9	36	2	f	2030-2
20300904	2030-09-04	2030	3	9	36	3	f	2030-2
20300905	2030-09-05	2030	3	9	36	4	f	2030-2
20300906	2030-09-06	2030	3	9	36	5	f	2030-2
20300907	2030-09-07	2030	3	9	36	6	t	2030-2
20300908	2030-09-08	2030	3	9	36	7	t	2030-2
20300909	2030-09-09	2030	3	9	37	1	f	2030-2
20300910	2030-09-10	2030	3	9	37	2	f	2030-2
20300911	2030-09-11	2030	3	9	37	3	f	2030-2
20300912	2030-09-12	2030	3	9	37	4	f	2030-2
20300913	2030-09-13	2030	3	9	37	5	f	2030-2
20300914	2030-09-14	2030	3	9	37	6	t	2030-2
20300915	2030-09-15	2030	3	9	37	7	t	2030-2
20300916	2030-09-16	2030	3	9	38	1	f	2030-2
20300917	2030-09-17	2030	3	9	38	2	f	2030-2
20300918	2030-09-18	2030	3	9	38	3	f	2030-2
20300919	2030-09-19	2030	3	9	38	4	f	2030-2
20300920	2030-09-20	2030	3	9	38	5	f	2030-2
20300921	2030-09-21	2030	3	9	38	6	t	2030-2
20300922	2030-09-22	2030	3	9	38	7	t	2030-2
20300923	2030-09-23	2030	3	9	39	1	f	2030-2
20300924	2030-09-24	2030	3	9	39	2	f	2030-2
20300925	2030-09-25	2030	3	9	39	3	f	2030-2
20300926	2030-09-26	2030	3	9	39	4	f	2030-2
20300927	2030-09-27	2030	3	9	39	5	f	2030-2
20300928	2030-09-28	2030	3	9	39	6	t	2030-2
20300929	2030-09-29	2030	3	9	39	7	t	2030-2
20300930	2030-09-30	2030	3	9	40	1	f	2030-2
20301001	2030-10-01	2030	4	10	40	2	f	2030-2
20301002	2030-10-02	2030	4	10	40	3	f	2030-2
20301003	2030-10-03	2030	4	10	40	4	f	2030-2
20301004	2030-10-04	2030	4	10	40	5	f	2030-2
20301005	2030-10-05	2030	4	10	40	6	t	2030-2
20301006	2030-10-06	2030	4	10	40	7	t	2030-2
20301007	2030-10-07	2030	4	10	41	1	f	2030-2
20301008	2030-10-08	2030	4	10	41	2	f	2030-2
20301009	2030-10-09	2030	4	10	41	3	f	2030-2
20301010	2030-10-10	2030	4	10	41	4	f	2030-2
20301011	2030-10-11	2030	4	10	41	5	f	2030-2
20301012	2030-10-12	2030	4	10	41	6	t	2030-2
20301013	2030-10-13	2030	4	10	41	7	t	2030-2
20301014	2030-10-14	2030	4	10	42	1	f	2030-2
20301015	2030-10-15	2030	4	10	42	2	f	2030-2
20301016	2030-10-16	2030	4	10	42	3	f	2030-2
20301017	2030-10-17	2030	4	10	42	4	f	2030-2
20301018	2030-10-18	2030	4	10	42	5	f	2030-2
20301019	2030-10-19	2030	4	10	42	6	t	2030-2
20301020	2030-10-20	2030	4	10	42	7	t	2030-2
20301021	2030-10-21	2030	4	10	43	1	f	2030-2
20301022	2030-10-22	2030	4	10	43	2	f	2030-2
20301023	2030-10-23	2030	4	10	43	3	f	2030-2
20301024	2030-10-24	2030	4	10	43	4	f	2030-2
20301025	2030-10-25	2030	4	10	43	5	f	2030-2
20301026	2030-10-26	2030	4	10	43	6	t	2030-2
20301027	2030-10-27	2030	4	10	43	7	t	2030-2
20301028	2030-10-28	2030	4	10	44	1	f	2030-2
20301029	2030-10-29	2030	4	10	44	2	f	2030-2
20301030	2030-10-30	2030	4	10	44	3	f	2030-2
20301031	2030-10-31	2030	4	10	44	4	f	2030-2
20301101	2030-11-01	2030	4	11	44	5	f	2030-2
20301102	2030-11-02	2030	4	11	44	6	t	2030-2
20301103	2030-11-03	2030	4	11	44	7	t	2030-2
20301104	2030-11-04	2030	4	11	45	1	f	2030-2
20301105	2030-11-05	2030	4	11	45	2	f	2030-2
20301106	2030-11-06	2030	4	11	45	3	f	2030-2
20301107	2030-11-07	2030	4	11	45	4	f	2030-2
20301108	2030-11-08	2030	4	11	45	5	f	2030-2
20301109	2030-11-09	2030	4	11	45	6	t	2030-2
20301110	2030-11-10	2030	4	11	45	7	t	2030-2
20301111	2030-11-11	2030	4	11	46	1	f	2030-2
20301112	2030-11-12	2030	4	11	46	2	f	2030-2
20301113	2030-11-13	2030	4	11	46	3	f	2030-2
20301114	2030-11-14	2030	4	11	46	4	f	2030-2
20301115	2030-11-15	2030	4	11	46	5	f	2030-2
20301116	2030-11-16	2030	4	11	46	6	t	2030-2
20301117	2030-11-17	2030	4	11	46	7	t	2030-2
20301118	2030-11-18	2030	4	11	47	1	f	2030-2
20301119	2030-11-19	2030	4	11	47	2	f	2030-2
20301120	2030-11-20	2030	4	11	47	3	f	2030-2
20301121	2030-11-21	2030	4	11	47	4	f	2030-2
20301122	2030-11-22	2030	4	11	47	5	f	2030-2
20301123	2030-11-23	2030	4	11	47	6	t	2030-2
20301124	2030-11-24	2030	4	11	47	7	t	2030-2
20301125	2030-11-25	2030	4	11	48	1	f	2030-2
20301126	2030-11-26	2030	4	11	48	2	f	2030-2
20301127	2030-11-27	2030	4	11	48	3	f	2030-2
20301128	2030-11-28	2030	4	11	48	4	f	2030-2
20301129	2030-11-29	2030	4	11	48	5	f	2030-2
20301130	2030-11-30	2030	4	11	48	6	t	2030-2
20301201	2030-12-01	2030	4	12	48	7	t	2030-2
20301202	2030-12-02	2030	4	12	49	1	f	2030-2
20301203	2030-12-03	2030	4	12	49	2	f	2030-2
20301204	2030-12-04	2030	4	12	49	3	f	2030-2
20301205	2030-12-05	2030	4	12	49	4	f	2030-2
20301206	2030-12-06	2030	4	12	49	5	f	2030-2
20301207	2030-12-07	2030	4	12	49	6	t	2030-2
20301208	2030-12-08	2030	4	12	49	7	t	2030-2
20301209	2030-12-09	2030	4	12	50	1	f	2030-2
20301210	2030-12-10	2030	4	12	50	2	f	2030-2
20301211	2030-12-11	2030	4	12	50	3	f	2030-2
20301212	2030-12-12	2030	4	12	50	4	f	2030-2
20301213	2030-12-13	2030	4	12	50	5	f	2030-2
20301214	2030-12-14	2030	4	12	50	6	t	2030-2
20301215	2030-12-15	2030	4	12	50	7	t	2030-2
20301216	2030-12-16	2030	4	12	51	1	f	2030-2
20301217	2030-12-17	2030	4	12	51	2	f	2030-2
20301218	2030-12-18	2030	4	12	51	3	f	2030-2
20301219	2030-12-19	2030	4	12	51	4	f	2030-2
20301220	2030-12-20	2030	4	12	51	5	f	2030-2
20301221	2030-12-21	2030	4	12	51	6	t	2030-2
20301222	2030-12-22	2030	4	12	51	7	t	2030-2
20301223	2030-12-23	2030	4	12	52	1	f	2030-2
20301224	2030-12-24	2030	4	12	52	2	f	2030-2
20301225	2030-12-25	2030	4	12	52	3	f	2030-2
20301226	2030-12-26	2030	4	12	52	4	f	2030-2
20301227	2030-12-27	2030	4	12	52	5	f	2030-2
20301228	2030-12-28	2030	4	12	52	6	t	2030-2
20301229	2030-12-29	2030	4	12	52	7	t	2030-2
20301230	2030-12-30	2030	4	12	1	1	f	2030-2
20301231	2030-12-31	2030	4	12	1	2	f	2030-2
20310101	2031-01-01	2031	1	1	1	3	f	2031-1
20310102	2031-01-02	2031	1	1	1	4	f	2031-1
20310103	2031-01-03	2031	1	1	1	5	f	2031-1
20310104	2031-01-04	2031	1	1	1	6	t	2031-1
20310105	2031-01-05	2031	1	1	1	7	t	2031-1
20310106	2031-01-06	2031	1	1	2	1	f	2031-1
20310107	2031-01-07	2031	1	1	2	2	f	2031-1
20310108	2031-01-08	2031	1	1	2	3	f	2031-1
20310109	2031-01-09	2031	1	1	2	4	f	2031-1
20310110	2031-01-10	2031	1	1	2	5	f	2031-1
20310111	2031-01-11	2031	1	1	2	6	t	2031-1
20310112	2031-01-12	2031	1	1	2	7	t	2031-1
20310113	2031-01-13	2031	1	1	3	1	f	2031-1
20310114	2031-01-14	2031	1	1	3	2	f	2031-1
20310115	2031-01-15	2031	1	1	3	3	f	2031-1
20310116	2031-01-16	2031	1	1	3	4	f	2031-1
20310117	2031-01-17	2031	1	1	3	5	f	2031-1
20310118	2031-01-18	2031	1	1	3	6	t	2031-1
20310119	2031-01-19	2031	1	1	3	7	t	2031-1
20310120	2031-01-20	2031	1	1	4	1	f	2031-1
20310121	2031-01-21	2031	1	1	4	2	f	2031-1
20310122	2031-01-22	2031	1	1	4	3	f	2031-1
20310123	2031-01-23	2031	1	1	4	4	f	2031-1
20310124	2031-01-24	2031	1	1	4	5	f	2031-1
20310125	2031-01-25	2031	1	1	4	6	t	2031-1
20310126	2031-01-26	2031	1	1	4	7	t	2031-1
20310127	2031-01-27	2031	1	1	5	1	f	2031-1
20310128	2031-01-28	2031	1	1	5	2	f	2031-1
20310129	2031-01-29	2031	1	1	5	3	f	2031-1
20310130	2031-01-30	2031	1	1	5	4	f	2031-1
20310131	2031-01-31	2031	1	1	5	5	f	2031-1
20310201	2031-02-01	2031	1	2	5	6	t	2031-1
20310202	2031-02-02	2031	1	2	5	7	t	2031-1
20310203	2031-02-03	2031	1	2	6	1	f	2031-1
20310204	2031-02-04	2031	1	2	6	2	f	2031-1
20310205	2031-02-05	2031	1	2	6	3	f	2031-1
20310206	2031-02-06	2031	1	2	6	4	f	2031-1
20310207	2031-02-07	2031	1	2	6	5	f	2031-1
20310208	2031-02-08	2031	1	2	6	6	t	2031-1
20310209	2031-02-09	2031	1	2	6	7	t	2031-1
20310210	2031-02-10	2031	1	2	7	1	f	2031-1
20310211	2031-02-11	2031	1	2	7	2	f	2031-1
20310212	2031-02-12	2031	1	2	7	3	f	2031-1
20310213	2031-02-13	2031	1	2	7	4	f	2031-1
20310214	2031-02-14	2031	1	2	7	5	f	2031-1
20310215	2031-02-15	2031	1	2	7	6	t	2031-1
20310216	2031-02-16	2031	1	2	7	7	t	2031-1
20310217	2031-02-17	2031	1	2	8	1	f	2031-1
20310218	2031-02-18	2031	1	2	8	2	f	2031-1
20310219	2031-02-19	2031	1	2	8	3	f	2031-1
20310220	2031-02-20	2031	1	2	8	4	f	2031-1
20310221	2031-02-21	2031	1	2	8	5	f	2031-1
20310222	2031-02-22	2031	1	2	8	6	t	2031-1
20310223	2031-02-23	2031	1	2	8	7	t	2031-1
20310224	2031-02-24	2031	1	2	9	1	f	2031-1
20310225	2031-02-25	2031	1	2	9	2	f	2031-1
20310226	2031-02-26	2031	1	2	9	3	f	2031-1
20310227	2031-02-27	2031	1	2	9	4	f	2031-1
20310228	2031-02-28	2031	1	2	9	5	f	2031-1
20310301	2031-03-01	2031	1	3	9	6	t	2031-1
20310302	2031-03-02	2031	1	3	9	7	t	2031-1
20310303	2031-03-03	2031	1	3	10	1	f	2031-1
20310304	2031-03-04	2031	1	3	10	2	f	2031-1
20310305	2031-03-05	2031	1	3	10	3	f	2031-1
20310306	2031-03-06	2031	1	3	10	4	f	2031-1
20310307	2031-03-07	2031	1	3	10	5	f	2031-1
20310308	2031-03-08	2031	1	3	10	6	t	2031-1
20310309	2031-03-09	2031	1	3	10	7	t	2031-1
20310310	2031-03-10	2031	1	3	11	1	f	2031-1
20310311	2031-03-11	2031	1	3	11	2	f	2031-1
20310312	2031-03-12	2031	1	3	11	3	f	2031-1
20310313	2031-03-13	2031	1	3	11	4	f	2031-1
20310314	2031-03-14	2031	1	3	11	5	f	2031-1
20310315	2031-03-15	2031	1	3	11	6	t	2031-1
20310316	2031-03-16	2031	1	3	11	7	t	2031-1
20310317	2031-03-17	2031	1	3	12	1	f	2031-1
20310318	2031-03-18	2031	1	3	12	2	f	2031-1
20310319	2031-03-19	2031	1	3	12	3	f	2031-1
20310320	2031-03-20	2031	1	3	12	4	f	2031-1
20310321	2031-03-21	2031	1	3	12	5	f	2031-1
20310322	2031-03-22	2031	1	3	12	6	t	2031-1
20310323	2031-03-23	2031	1	3	12	7	t	2031-1
20310324	2031-03-24	2031	1	3	13	1	f	2031-1
20310325	2031-03-25	2031	1	3	13	2	f	2031-1
20310326	2031-03-26	2031	1	3	13	3	f	2031-1
20310327	2031-03-27	2031	1	3	13	4	f	2031-1
20310328	2031-03-28	2031	1	3	13	5	f	2031-1
20310329	2031-03-29	2031	1	3	13	6	t	2031-1
20310330	2031-03-30	2031	1	3	13	7	t	2031-1
20310331	2031-03-31	2031	1	3	14	1	f	2031-1
20310401	2031-04-01	2031	2	4	14	2	f	2031-1
20310402	2031-04-02	2031	2	4	14	3	f	2031-1
20310403	2031-04-03	2031	2	4	14	4	f	2031-1
20310404	2031-04-04	2031	2	4	14	5	f	2031-1
20310405	2031-04-05	2031	2	4	14	6	t	2031-1
20310406	2031-04-06	2031	2	4	14	7	t	2031-1
20310407	2031-04-07	2031	2	4	15	1	f	2031-1
20310408	2031-04-08	2031	2	4	15	2	f	2031-1
20310409	2031-04-09	2031	2	4	15	3	f	2031-1
20310410	2031-04-10	2031	2	4	15	4	f	2031-1
20310411	2031-04-11	2031	2	4	15	5	f	2031-1
20310412	2031-04-12	2031	2	4	15	6	t	2031-1
20310413	2031-04-13	2031	2	4	15	7	t	2031-1
20310414	2031-04-14	2031	2	4	16	1	f	2031-1
20310415	2031-04-15	2031	2	4	16	2	f	2031-1
20310416	2031-04-16	2031	2	4	16	3	f	2031-1
20310417	2031-04-17	2031	2	4	16	4	f	2031-1
20310418	2031-04-18	2031	2	4	16	5	f	2031-1
20310419	2031-04-19	2031	2	4	16	6	t	2031-1
20310420	2031-04-20	2031	2	4	16	7	t	2031-1
20310421	2031-04-21	2031	2	4	17	1	f	2031-1
20310422	2031-04-22	2031	2	4	17	2	f	2031-1
20310423	2031-04-23	2031	2	4	17	3	f	2031-1
20310424	2031-04-24	2031	2	4	17	4	f	2031-1
20310425	2031-04-25	2031	2	4	17	5	f	2031-1
20310426	2031-04-26	2031	2	4	17	6	t	2031-1
20310427	2031-04-27	2031	2	4	17	7	t	2031-1
20310428	2031-04-28	2031	2	4	18	1	f	2031-1
20310429	2031-04-29	2031	2	4	18	2	f	2031-1
20310430	2031-04-30	2031	2	4	18	3	f	2031-1
20310501	2031-05-01	2031	2	5	18	4	f	2031-1
20310502	2031-05-02	2031	2	5	18	5	f	2031-1
20310503	2031-05-03	2031	2	5	18	6	t	2031-1
20310504	2031-05-04	2031	2	5	18	7	t	2031-1
20310505	2031-05-05	2031	2	5	19	1	f	2031-1
20310506	2031-05-06	2031	2	5	19	2	f	2031-1
20310507	2031-05-07	2031	2	5	19	3	f	2031-1
20310508	2031-05-08	2031	2	5	19	4	f	2031-1
20310509	2031-05-09	2031	2	5	19	5	f	2031-1
20310510	2031-05-10	2031	2	5	19	6	t	2031-1
20310511	2031-05-11	2031	2	5	19	7	t	2031-1
20310512	2031-05-12	2031	2	5	20	1	f	2031-1
20310513	2031-05-13	2031	2	5	20	2	f	2031-1
20310514	2031-05-14	2031	2	5	20	3	f	2031-1
20310515	2031-05-15	2031	2	5	20	4	f	2031-1
20310516	2031-05-16	2031	2	5	20	5	f	2031-1
20310517	2031-05-17	2031	2	5	20	6	t	2031-1
20310518	2031-05-18	2031	2	5	20	7	t	2031-1
20310519	2031-05-19	2031	2	5	21	1	f	2031-1
20310520	2031-05-20	2031	2	5	21	2	f	2031-1
20310521	2031-05-21	2031	2	5	21	3	f	2031-1
20310522	2031-05-22	2031	2	5	21	4	f	2031-1
20310523	2031-05-23	2031	2	5	21	5	f	2031-1
20310524	2031-05-24	2031	2	5	21	6	t	2031-1
20310525	2031-05-25	2031	2	5	21	7	t	2031-1
20310526	2031-05-26	2031	2	5	22	1	f	2031-1
20310527	2031-05-27	2031	2	5	22	2	f	2031-1
20310528	2031-05-28	2031	2	5	22	3	f	2031-1
20310529	2031-05-29	2031	2	5	22	4	f	2031-1
20310530	2031-05-30	2031	2	5	22	5	f	2031-1
20310531	2031-05-31	2031	2	5	22	6	t	2031-1
20310601	2031-06-01	2031	2	6	22	7	t	2031-1
20310602	2031-06-02	2031	2	6	23	1	f	2031-1
20310603	2031-06-03	2031	2	6	23	2	f	2031-1
20310604	2031-06-04	2031	2	6	23	3	f	2031-1
20310605	2031-06-05	2031	2	6	23	4	f	2031-1
20310606	2031-06-06	2031	2	6	23	5	f	2031-1
20310607	2031-06-07	2031	2	6	23	6	t	2031-1
20310608	2031-06-08	2031	2	6	23	7	t	2031-1
20310609	2031-06-09	2031	2	6	24	1	f	2031-1
20310610	2031-06-10	2031	2	6	24	2	f	2031-1
20310611	2031-06-11	2031	2	6	24	3	f	2031-1
20310612	2031-06-12	2031	2	6	24	4	f	2031-1
20310613	2031-06-13	2031	2	6	24	5	f	2031-1
20310614	2031-06-14	2031	2	6	24	6	t	2031-1
20310615	2031-06-15	2031	2	6	24	7	t	2031-1
20310616	2031-06-16	2031	2	6	25	1	f	2031-1
20310617	2031-06-17	2031	2	6	25	2	f	2031-1
20310618	2031-06-18	2031	2	6	25	3	f	2031-1
20310619	2031-06-19	2031	2	6	25	4	f	2031-1
20310620	2031-06-20	2031	2	6	25	5	f	2031-1
20310621	2031-06-21	2031	2	6	25	6	t	2031-1
20310622	2031-06-22	2031	2	6	25	7	t	2031-1
20310623	2031-06-23	2031	2	6	26	1	f	2031-1
20310624	2031-06-24	2031	2	6	26	2	f	2031-1
20310625	2031-06-25	2031	2	6	26	3	f	2031-1
20310626	2031-06-26	2031	2	6	26	4	f	2031-1
20310627	2031-06-27	2031	2	6	26	5	f	2031-1
20310628	2031-06-28	2031	2	6	26	6	t	2031-1
20310629	2031-06-29	2031	2	6	26	7	t	2031-1
20310630	2031-06-30	2031	2	6	27	1	f	2031-1
20310701	2031-07-01	2031	3	7	27	2	f	2031-2
20310702	2031-07-02	2031	3	7	27	3	f	2031-2
20310703	2031-07-03	2031	3	7	27	4	f	2031-2
20310704	2031-07-04	2031	3	7	27	5	f	2031-2
20310705	2031-07-05	2031	3	7	27	6	t	2031-2
20310706	2031-07-06	2031	3	7	27	7	t	2031-2
20310707	2031-07-07	2031	3	7	28	1	f	2031-2
20310708	2031-07-08	2031	3	7	28	2	f	2031-2
20310709	2031-07-09	2031	3	7	28	3	f	2031-2
20310710	2031-07-10	2031	3	7	28	4	f	2031-2
20310711	2031-07-11	2031	3	7	28	5	f	2031-2
20310712	2031-07-12	2031	3	7	28	6	t	2031-2
20310713	2031-07-13	2031	3	7	28	7	t	2031-2
20310714	2031-07-14	2031	3	7	29	1	f	2031-2
20310715	2031-07-15	2031	3	7	29	2	f	2031-2
20310716	2031-07-16	2031	3	7	29	3	f	2031-2
20310717	2031-07-17	2031	3	7	29	4	f	2031-2
20310718	2031-07-18	2031	3	7	29	5	f	2031-2
20310719	2031-07-19	2031	3	7	29	6	t	2031-2
20310720	2031-07-20	2031	3	7	29	7	t	2031-2
20310721	2031-07-21	2031	3	7	30	1	f	2031-2
20310722	2031-07-22	2031	3	7	30	2	f	2031-2
20310723	2031-07-23	2031	3	7	30	3	f	2031-2
20310724	2031-07-24	2031	3	7	30	4	f	2031-2
20310725	2031-07-25	2031	3	7	30	5	f	2031-2
20310726	2031-07-26	2031	3	7	30	6	t	2031-2
20310727	2031-07-27	2031	3	7	30	7	t	2031-2
20310728	2031-07-28	2031	3	7	31	1	f	2031-2
20310729	2031-07-29	2031	3	7	31	2	f	2031-2
20310730	2031-07-30	2031	3	7	31	3	f	2031-2
20310731	2031-07-31	2031	3	7	31	4	f	2031-2
20310801	2031-08-01	2031	3	8	31	5	f	2031-2
20310802	2031-08-02	2031	3	8	31	6	t	2031-2
20310803	2031-08-03	2031	3	8	31	7	t	2031-2
20310804	2031-08-04	2031	3	8	32	1	f	2031-2
20310805	2031-08-05	2031	3	8	32	2	f	2031-2
20310806	2031-08-06	2031	3	8	32	3	f	2031-2
20310807	2031-08-07	2031	3	8	32	4	f	2031-2
20310808	2031-08-08	2031	3	8	32	5	f	2031-2
20310809	2031-08-09	2031	3	8	32	6	t	2031-2
20310810	2031-08-10	2031	3	8	32	7	t	2031-2
20310811	2031-08-11	2031	3	8	33	1	f	2031-2
20310812	2031-08-12	2031	3	8	33	2	f	2031-2
20310813	2031-08-13	2031	3	8	33	3	f	2031-2
20310814	2031-08-14	2031	3	8	33	4	f	2031-2
20310815	2031-08-15	2031	3	8	33	5	f	2031-2
20310816	2031-08-16	2031	3	8	33	6	t	2031-2
20310817	2031-08-17	2031	3	8	33	7	t	2031-2
20310818	2031-08-18	2031	3	8	34	1	f	2031-2
20310819	2031-08-19	2031	3	8	34	2	f	2031-2
20310820	2031-08-20	2031	3	8	34	3	f	2031-2
20310821	2031-08-21	2031	3	8	34	4	f	2031-2
20310822	2031-08-22	2031	3	8	34	5	f	2031-2
20310823	2031-08-23	2031	3	8	34	6	t	2031-2
20310824	2031-08-24	2031	3	8	34	7	t	2031-2
20310825	2031-08-25	2031	3	8	35	1	f	2031-2
20310826	2031-08-26	2031	3	8	35	2	f	2031-2
20310827	2031-08-27	2031	3	8	35	3	f	2031-2
20310828	2031-08-28	2031	3	8	35	4	f	2031-2
20310829	2031-08-29	2031	3	8	35	5	f	2031-2
20310830	2031-08-30	2031	3	8	35	6	t	2031-2
20310831	2031-08-31	2031	3	8	35	7	t	2031-2
20310901	2031-09-01	2031	3	9	36	1	f	2031-2
20310902	2031-09-02	2031	3	9	36	2	f	2031-2
20310903	2031-09-03	2031	3	9	36	3	f	2031-2
20310904	2031-09-04	2031	3	9	36	4	f	2031-2
20310905	2031-09-05	2031	3	9	36	5	f	2031-2
20310906	2031-09-06	2031	3	9	36	6	t	2031-2
20310907	2031-09-07	2031	3	9	36	7	t	2031-2
20310908	2031-09-08	2031	3	9	37	1	f	2031-2
20310909	2031-09-09	2031	3	9	37	2	f	2031-2
20310910	2031-09-10	2031	3	9	37	3	f	2031-2
20310911	2031-09-11	2031	3	9	37	4	f	2031-2
20310912	2031-09-12	2031	3	9	37	5	f	2031-2
20310913	2031-09-13	2031	3	9	37	6	t	2031-2
20310914	2031-09-14	2031	3	9	37	7	t	2031-2
20310915	2031-09-15	2031	3	9	38	1	f	2031-2
20310916	2031-09-16	2031	3	9	38	2	f	2031-2
20310917	2031-09-17	2031	3	9	38	3	f	2031-2
20310918	2031-09-18	2031	3	9	38	4	f	2031-2
20310919	2031-09-19	2031	3	9	38	5	f	2031-2
20310920	2031-09-20	2031	3	9	38	6	t	2031-2
20310921	2031-09-21	2031	3	9	38	7	t	2031-2
20310922	2031-09-22	2031	3	9	39	1	f	2031-2
20310923	2031-09-23	2031	3	9	39	2	f	2031-2
20310924	2031-09-24	2031	3	9	39	3	f	2031-2
20310925	2031-09-25	2031	3	9	39	4	f	2031-2
20310926	2031-09-26	2031	3	9	39	5	f	2031-2
20310927	2031-09-27	2031	3	9	39	6	t	2031-2
20310928	2031-09-28	2031	3	9	39	7	t	2031-2
20310929	2031-09-29	2031	3	9	40	1	f	2031-2
20310930	2031-09-30	2031	3	9	40	2	f	2031-2
20311001	2031-10-01	2031	4	10	40	3	f	2031-2
20311002	2031-10-02	2031	4	10	40	4	f	2031-2
20311003	2031-10-03	2031	4	10	40	5	f	2031-2
20311004	2031-10-04	2031	4	10	40	6	t	2031-2
20311005	2031-10-05	2031	4	10	40	7	t	2031-2
20311006	2031-10-06	2031	4	10	41	1	f	2031-2
20311007	2031-10-07	2031	4	10	41	2	f	2031-2
20311008	2031-10-08	2031	4	10	41	3	f	2031-2
20311009	2031-10-09	2031	4	10	41	4	f	2031-2
20311010	2031-10-10	2031	4	10	41	5	f	2031-2
20311011	2031-10-11	2031	4	10	41	6	t	2031-2
20311012	2031-10-12	2031	4	10	41	7	t	2031-2
20311013	2031-10-13	2031	4	10	42	1	f	2031-2
20311014	2031-10-14	2031	4	10	42	2	f	2031-2
20311015	2031-10-15	2031	4	10	42	3	f	2031-2
20311016	2031-10-16	2031	4	10	42	4	f	2031-2
20311017	2031-10-17	2031	4	10	42	5	f	2031-2
20311018	2031-10-18	2031	4	10	42	6	t	2031-2
20311019	2031-10-19	2031	4	10	42	7	t	2031-2
20311020	2031-10-20	2031	4	10	43	1	f	2031-2
20311021	2031-10-21	2031	4	10	43	2	f	2031-2
20311022	2031-10-22	2031	4	10	43	3	f	2031-2
20311023	2031-10-23	2031	4	10	43	4	f	2031-2
20311024	2031-10-24	2031	4	10	43	5	f	2031-2
20311025	2031-10-25	2031	4	10	43	6	t	2031-2
20311026	2031-10-26	2031	4	10	43	7	t	2031-2
20311027	2031-10-27	2031	4	10	44	1	f	2031-2
20311028	2031-10-28	2031	4	10	44	2	f	2031-2
20311029	2031-10-29	2031	4	10	44	3	f	2031-2
20311030	2031-10-30	2031	4	10	44	4	f	2031-2
20311031	2031-10-31	2031	4	10	44	5	f	2031-2
20311101	2031-11-01	2031	4	11	44	6	t	2031-2
20311102	2031-11-02	2031	4	11	44	7	t	2031-2
20311103	2031-11-03	2031	4	11	45	1	f	2031-2
20311104	2031-11-04	2031	4	11	45	2	f	2031-2
20311105	2031-11-05	2031	4	11	45	3	f	2031-2
20311106	2031-11-06	2031	4	11	45	4	f	2031-2
20311107	2031-11-07	2031	4	11	45	5	f	2031-2
20311108	2031-11-08	2031	4	11	45	6	t	2031-2
20311109	2031-11-09	2031	4	11	45	7	t	2031-2
20311110	2031-11-10	2031	4	11	46	1	f	2031-2
20311111	2031-11-11	2031	4	11	46	2	f	2031-2
20311112	2031-11-12	2031	4	11	46	3	f	2031-2
20311113	2031-11-13	2031	4	11	46	4	f	2031-2
20311114	2031-11-14	2031	4	11	46	5	f	2031-2
20311115	2031-11-15	2031	4	11	46	6	t	2031-2
20311116	2031-11-16	2031	4	11	46	7	t	2031-2
20311117	2031-11-17	2031	4	11	47	1	f	2031-2
20311118	2031-11-18	2031	4	11	47	2	f	2031-2
20311119	2031-11-19	2031	4	11	47	3	f	2031-2
20311120	2031-11-20	2031	4	11	47	4	f	2031-2
20311121	2031-11-21	2031	4	11	47	5	f	2031-2
20311122	2031-11-22	2031	4	11	47	6	t	2031-2
20311123	2031-11-23	2031	4	11	47	7	t	2031-2
20311124	2031-11-24	2031	4	11	48	1	f	2031-2
20311125	2031-11-25	2031	4	11	48	2	f	2031-2
20311126	2031-11-26	2031	4	11	48	3	f	2031-2
20311127	2031-11-27	2031	4	11	48	4	f	2031-2
20311128	2031-11-28	2031	4	11	48	5	f	2031-2
20311129	2031-11-29	2031	4	11	48	6	t	2031-2
20311130	2031-11-30	2031	4	11	48	7	t	2031-2
20311201	2031-12-01	2031	4	12	49	1	f	2031-2
20311202	2031-12-02	2031	4	12	49	2	f	2031-2
20311203	2031-12-03	2031	4	12	49	3	f	2031-2
20311204	2031-12-04	2031	4	12	49	4	f	2031-2
20311205	2031-12-05	2031	4	12	49	5	f	2031-2
20311206	2031-12-06	2031	4	12	49	6	t	2031-2
20311207	2031-12-07	2031	4	12	49	7	t	2031-2
20311208	2031-12-08	2031	4	12	50	1	f	2031-2
20311209	2031-12-09	2031	4	12	50	2	f	2031-2
20311210	2031-12-10	2031	4	12	50	3	f	2031-2
20311211	2031-12-11	2031	4	12	50	4	f	2031-2
20311212	2031-12-12	2031	4	12	50	5	f	2031-2
20311213	2031-12-13	2031	4	12	50	6	t	2031-2
20311214	2031-12-14	2031	4	12	50	7	t	2031-2
20311215	2031-12-15	2031	4	12	51	1	f	2031-2
20311216	2031-12-16	2031	4	12	51	2	f	2031-2
20311217	2031-12-17	2031	4	12	51	3	f	2031-2
20311218	2031-12-18	2031	4	12	51	4	f	2031-2
20311219	2031-12-19	2031	4	12	51	5	f	2031-2
20311220	2031-12-20	2031	4	12	51	6	t	2031-2
20311221	2031-12-21	2031	4	12	51	7	t	2031-2
20311222	2031-12-22	2031	4	12	52	1	f	2031-2
20311223	2031-12-23	2031	4	12	52	2	f	2031-2
20311224	2031-12-24	2031	4	12	52	3	f	2031-2
20311225	2031-12-25	2031	4	12	52	4	f	2031-2
20311226	2031-12-26	2031	4	12	52	5	f	2031-2
20311227	2031-12-27	2031	4	12	52	6	t	2031-2
20311228	2031-12-28	2031	4	12	52	7	t	2031-2
20311229	2031-12-29	2031	4	12	1	1	f	2031-2
20311230	2031-12-30	2031	4	12	1	2	f	2031-2
20311231	2031-12-31	2031	4	12	1	3	f	2031-2
20320101	2032-01-01	2032	1	1	1	4	f	2032-1
20320102	2032-01-02	2032	1	1	1	5	f	2032-1
20320103	2032-01-03	2032	1	1	1	6	t	2032-1
20320104	2032-01-04	2032	1	1	1	7	t	2032-1
20320105	2032-01-05	2032	1	1	2	1	f	2032-1
20320106	2032-01-06	2032	1	1	2	2	f	2032-1
20320107	2032-01-07	2032	1	1	2	3	f	2032-1
20320108	2032-01-08	2032	1	1	2	4	f	2032-1
20320109	2032-01-09	2032	1	1	2	5	f	2032-1
20320110	2032-01-10	2032	1	1	2	6	t	2032-1
20320111	2032-01-11	2032	1	1	2	7	t	2032-1
20320112	2032-01-12	2032	1	1	3	1	f	2032-1
20320113	2032-01-13	2032	1	1	3	2	f	2032-1
20320114	2032-01-14	2032	1	1	3	3	f	2032-1
20320115	2032-01-15	2032	1	1	3	4	f	2032-1
20320116	2032-01-16	2032	1	1	3	5	f	2032-1
20320117	2032-01-17	2032	1	1	3	6	t	2032-1
20320118	2032-01-18	2032	1	1	3	7	t	2032-1
20320119	2032-01-19	2032	1	1	4	1	f	2032-1
20320120	2032-01-20	2032	1	1	4	2	f	2032-1
20320121	2032-01-21	2032	1	1	4	3	f	2032-1
20320122	2032-01-22	2032	1	1	4	4	f	2032-1
20320123	2032-01-23	2032	1	1	4	5	f	2032-1
20320124	2032-01-24	2032	1	1	4	6	t	2032-1
20320125	2032-01-25	2032	1	1	4	7	t	2032-1
20320126	2032-01-26	2032	1	1	5	1	f	2032-1
20320127	2032-01-27	2032	1	1	5	2	f	2032-1
20320128	2032-01-28	2032	1	1	5	3	f	2032-1
20320129	2032-01-29	2032	1	1	5	4	f	2032-1
20320130	2032-01-30	2032	1	1	5	5	f	2032-1
20320131	2032-01-31	2032	1	1	5	6	t	2032-1
20320201	2032-02-01	2032	1	2	5	7	t	2032-1
20320202	2032-02-02	2032	1	2	6	1	f	2032-1
20320203	2032-02-03	2032	1	2	6	2	f	2032-1
20320204	2032-02-04	2032	1	2	6	3	f	2032-1
20320205	2032-02-05	2032	1	2	6	4	f	2032-1
20320206	2032-02-06	2032	1	2	6	5	f	2032-1
20320207	2032-02-07	2032	1	2	6	6	t	2032-1
20320208	2032-02-08	2032	1	2	6	7	t	2032-1
20320209	2032-02-09	2032	1	2	7	1	f	2032-1
20320210	2032-02-10	2032	1	2	7	2	f	2032-1
20320211	2032-02-11	2032	1	2	7	3	f	2032-1
20320212	2032-02-12	2032	1	2	7	4	f	2032-1
20320213	2032-02-13	2032	1	2	7	5	f	2032-1
20320214	2032-02-14	2032	1	2	7	6	t	2032-1
20320215	2032-02-15	2032	1	2	7	7	t	2032-1
20320216	2032-02-16	2032	1	2	8	1	f	2032-1
20320217	2032-02-17	2032	1	2	8	2	f	2032-1
20320218	2032-02-18	2032	1	2	8	3	f	2032-1
20320219	2032-02-19	2032	1	2	8	4	f	2032-1
20320220	2032-02-20	2032	1	2	8	5	f	2032-1
20320221	2032-02-21	2032	1	2	8	6	t	2032-1
20320222	2032-02-22	2032	1	2	8	7	t	2032-1
20320223	2032-02-23	2032	1	2	9	1	f	2032-1
20320224	2032-02-24	2032	1	2	9	2	f	2032-1
20320225	2032-02-25	2032	1	2	9	3	f	2032-1
20320226	2032-02-26	2032	1	2	9	4	f	2032-1
20320227	2032-02-27	2032	1	2	9	5	f	2032-1
20320228	2032-02-28	2032	1	2	9	6	t	2032-1
20320229	2032-02-29	2032	1	2	9	7	t	2032-1
20320301	2032-03-01	2032	1	3	10	1	f	2032-1
20320302	2032-03-02	2032	1	3	10	2	f	2032-1
20320303	2032-03-03	2032	1	3	10	3	f	2032-1
20320304	2032-03-04	2032	1	3	10	4	f	2032-1
20320305	2032-03-05	2032	1	3	10	5	f	2032-1
20320306	2032-03-06	2032	1	3	10	6	t	2032-1
20320307	2032-03-07	2032	1	3	10	7	t	2032-1
20320308	2032-03-08	2032	1	3	11	1	f	2032-1
20320309	2032-03-09	2032	1	3	11	2	f	2032-1
20320310	2032-03-10	2032	1	3	11	3	f	2032-1
20320311	2032-03-11	2032	1	3	11	4	f	2032-1
20320312	2032-03-12	2032	1	3	11	5	f	2032-1
20320313	2032-03-13	2032	1	3	11	6	t	2032-1
20320314	2032-03-14	2032	1	3	11	7	t	2032-1
20320315	2032-03-15	2032	1	3	12	1	f	2032-1
20320316	2032-03-16	2032	1	3	12	2	f	2032-1
20320317	2032-03-17	2032	1	3	12	3	f	2032-1
20320318	2032-03-18	2032	1	3	12	4	f	2032-1
20320319	2032-03-19	2032	1	3	12	5	f	2032-1
20320320	2032-03-20	2032	1	3	12	6	t	2032-1
20320321	2032-03-21	2032	1	3	12	7	t	2032-1
20320322	2032-03-22	2032	1	3	13	1	f	2032-1
20320323	2032-03-23	2032	1	3	13	2	f	2032-1
20320324	2032-03-24	2032	1	3	13	3	f	2032-1
20320325	2032-03-25	2032	1	3	13	4	f	2032-1
20320326	2032-03-26	2032	1	3	13	5	f	2032-1
20320327	2032-03-27	2032	1	3	13	6	t	2032-1
20320328	2032-03-28	2032	1	3	13	7	t	2032-1
20320329	2032-03-29	2032	1	3	14	1	f	2032-1
20320330	2032-03-30	2032	1	3	14	2	f	2032-1
20320331	2032-03-31	2032	1	3	14	3	f	2032-1
20320401	2032-04-01	2032	2	4	14	4	f	2032-1
20320402	2032-04-02	2032	2	4	14	5	f	2032-1
20320403	2032-04-03	2032	2	4	14	6	t	2032-1
20320404	2032-04-04	2032	2	4	14	7	t	2032-1
20320405	2032-04-05	2032	2	4	15	1	f	2032-1
20320406	2032-04-06	2032	2	4	15	2	f	2032-1
20320407	2032-04-07	2032	2	4	15	3	f	2032-1
20320408	2032-04-08	2032	2	4	15	4	f	2032-1
20320409	2032-04-09	2032	2	4	15	5	f	2032-1
20320410	2032-04-10	2032	2	4	15	6	t	2032-1
20320411	2032-04-11	2032	2	4	15	7	t	2032-1
20320412	2032-04-12	2032	2	4	16	1	f	2032-1
20320413	2032-04-13	2032	2	4	16	2	f	2032-1
20320414	2032-04-14	2032	2	4	16	3	f	2032-1
20320415	2032-04-15	2032	2	4	16	4	f	2032-1
20320416	2032-04-16	2032	2	4	16	5	f	2032-1
20320417	2032-04-17	2032	2	4	16	6	t	2032-1
20320418	2032-04-18	2032	2	4	16	7	t	2032-1
20320419	2032-04-19	2032	2	4	17	1	f	2032-1
20320420	2032-04-20	2032	2	4	17	2	f	2032-1
20320421	2032-04-21	2032	2	4	17	3	f	2032-1
20320422	2032-04-22	2032	2	4	17	4	f	2032-1
20320423	2032-04-23	2032	2	4	17	5	f	2032-1
20320424	2032-04-24	2032	2	4	17	6	t	2032-1
20320425	2032-04-25	2032	2	4	17	7	t	2032-1
20320426	2032-04-26	2032	2	4	18	1	f	2032-1
20320427	2032-04-27	2032	2	4	18	2	f	2032-1
20320428	2032-04-28	2032	2	4	18	3	f	2032-1
20320429	2032-04-29	2032	2	4	18	4	f	2032-1
20320430	2032-04-30	2032	2	4	18	5	f	2032-1
20320501	2032-05-01	2032	2	5	18	6	t	2032-1
20320502	2032-05-02	2032	2	5	18	7	t	2032-1
20320503	2032-05-03	2032	2	5	19	1	f	2032-1
20320504	2032-05-04	2032	2	5	19	2	f	2032-1
20320505	2032-05-05	2032	2	5	19	3	f	2032-1
20320506	2032-05-06	2032	2	5	19	4	f	2032-1
20320507	2032-05-07	2032	2	5	19	5	f	2032-1
20320508	2032-05-08	2032	2	5	19	6	t	2032-1
20320509	2032-05-09	2032	2	5	19	7	t	2032-1
20320510	2032-05-10	2032	2	5	20	1	f	2032-1
20320511	2032-05-11	2032	2	5	20	2	f	2032-1
20320512	2032-05-12	2032	2	5	20	3	f	2032-1
20320513	2032-05-13	2032	2	5	20	4	f	2032-1
20320514	2032-05-14	2032	2	5	20	5	f	2032-1
20320515	2032-05-15	2032	2	5	20	6	t	2032-1
20320516	2032-05-16	2032	2	5	20	7	t	2032-1
20320517	2032-05-17	2032	2	5	21	1	f	2032-1
20320518	2032-05-18	2032	2	5	21	2	f	2032-1
20320519	2032-05-19	2032	2	5	21	3	f	2032-1
20320520	2032-05-20	2032	2	5	21	4	f	2032-1
20320521	2032-05-21	2032	2	5	21	5	f	2032-1
20320522	2032-05-22	2032	2	5	21	6	t	2032-1
20320523	2032-05-23	2032	2	5	21	7	t	2032-1
20320524	2032-05-24	2032	2	5	22	1	f	2032-1
20320525	2032-05-25	2032	2	5	22	2	f	2032-1
20320526	2032-05-26	2032	2	5	22	3	f	2032-1
20320527	2032-05-27	2032	2	5	22	4	f	2032-1
20320528	2032-05-28	2032	2	5	22	5	f	2032-1
20320529	2032-05-29	2032	2	5	22	6	t	2032-1
20320530	2032-05-30	2032	2	5	22	7	t	2032-1
20320531	2032-05-31	2032	2	5	23	1	f	2032-1
20320601	2032-06-01	2032	2	6	23	2	f	2032-1
20320602	2032-06-02	2032	2	6	23	3	f	2032-1
20320603	2032-06-03	2032	2	6	23	4	f	2032-1
20320604	2032-06-04	2032	2	6	23	5	f	2032-1
20320605	2032-06-05	2032	2	6	23	6	t	2032-1
20320606	2032-06-06	2032	2	6	23	7	t	2032-1
20320607	2032-06-07	2032	2	6	24	1	f	2032-1
20320608	2032-06-08	2032	2	6	24	2	f	2032-1
20320609	2032-06-09	2032	2	6	24	3	f	2032-1
20320610	2032-06-10	2032	2	6	24	4	f	2032-1
20320611	2032-06-11	2032	2	6	24	5	f	2032-1
20320612	2032-06-12	2032	2	6	24	6	t	2032-1
20320613	2032-06-13	2032	2	6	24	7	t	2032-1
20320614	2032-06-14	2032	2	6	25	1	f	2032-1
20320615	2032-06-15	2032	2	6	25	2	f	2032-1
20320616	2032-06-16	2032	2	6	25	3	f	2032-1
20320617	2032-06-17	2032	2	6	25	4	f	2032-1
20320618	2032-06-18	2032	2	6	25	5	f	2032-1
20320619	2032-06-19	2032	2	6	25	6	t	2032-1
20320620	2032-06-20	2032	2	6	25	7	t	2032-1
20320621	2032-06-21	2032	2	6	26	1	f	2032-1
20320622	2032-06-22	2032	2	6	26	2	f	2032-1
20320623	2032-06-23	2032	2	6	26	3	f	2032-1
20320624	2032-06-24	2032	2	6	26	4	f	2032-1
20320625	2032-06-25	2032	2	6	26	5	f	2032-1
20320626	2032-06-26	2032	2	6	26	6	t	2032-1
20320627	2032-06-27	2032	2	6	26	7	t	2032-1
20320628	2032-06-28	2032	2	6	27	1	f	2032-1
20320629	2032-06-29	2032	2	6	27	2	f	2032-1
20320630	2032-06-30	2032	2	6	27	3	f	2032-1
20320701	2032-07-01	2032	3	7	27	4	f	2032-2
20320702	2032-07-02	2032	3	7	27	5	f	2032-2
20320703	2032-07-03	2032	3	7	27	6	t	2032-2
20320704	2032-07-04	2032	3	7	27	7	t	2032-2
20320705	2032-07-05	2032	3	7	28	1	f	2032-2
20320706	2032-07-06	2032	3	7	28	2	f	2032-2
20320707	2032-07-07	2032	3	7	28	3	f	2032-2
20320708	2032-07-08	2032	3	7	28	4	f	2032-2
20320709	2032-07-09	2032	3	7	28	5	f	2032-2
20320710	2032-07-10	2032	3	7	28	6	t	2032-2
20320711	2032-07-11	2032	3	7	28	7	t	2032-2
20320712	2032-07-12	2032	3	7	29	1	f	2032-2
20320713	2032-07-13	2032	3	7	29	2	f	2032-2
20320714	2032-07-14	2032	3	7	29	3	f	2032-2
20320715	2032-07-15	2032	3	7	29	4	f	2032-2
20320716	2032-07-16	2032	3	7	29	5	f	2032-2
20320717	2032-07-17	2032	3	7	29	6	t	2032-2
20320718	2032-07-18	2032	3	7	29	7	t	2032-2
20320719	2032-07-19	2032	3	7	30	1	f	2032-2
20320720	2032-07-20	2032	3	7	30	2	f	2032-2
20320721	2032-07-21	2032	3	7	30	3	f	2032-2
20320722	2032-07-22	2032	3	7	30	4	f	2032-2
20320723	2032-07-23	2032	3	7	30	5	f	2032-2
20320724	2032-07-24	2032	3	7	30	6	t	2032-2
20320725	2032-07-25	2032	3	7	30	7	t	2032-2
20320726	2032-07-26	2032	3	7	31	1	f	2032-2
20320727	2032-07-27	2032	3	7	31	2	f	2032-2
20320728	2032-07-28	2032	3	7	31	3	f	2032-2
20320729	2032-07-29	2032	3	7	31	4	f	2032-2
20320730	2032-07-30	2032	3	7	31	5	f	2032-2
20320731	2032-07-31	2032	3	7	31	6	t	2032-2
20320801	2032-08-01	2032	3	8	31	7	t	2032-2
20320802	2032-08-02	2032	3	8	32	1	f	2032-2
20320803	2032-08-03	2032	3	8	32	2	f	2032-2
20320804	2032-08-04	2032	3	8	32	3	f	2032-2
20320805	2032-08-05	2032	3	8	32	4	f	2032-2
20320806	2032-08-06	2032	3	8	32	5	f	2032-2
20320807	2032-08-07	2032	3	8	32	6	t	2032-2
20320808	2032-08-08	2032	3	8	32	7	t	2032-2
20320809	2032-08-09	2032	3	8	33	1	f	2032-2
20320810	2032-08-10	2032	3	8	33	2	f	2032-2
20320811	2032-08-11	2032	3	8	33	3	f	2032-2
20320812	2032-08-12	2032	3	8	33	4	f	2032-2
20320813	2032-08-13	2032	3	8	33	5	f	2032-2
20320814	2032-08-14	2032	3	8	33	6	t	2032-2
20320815	2032-08-15	2032	3	8	33	7	t	2032-2
20320816	2032-08-16	2032	3	8	34	1	f	2032-2
20320817	2032-08-17	2032	3	8	34	2	f	2032-2
20320818	2032-08-18	2032	3	8	34	3	f	2032-2
20320819	2032-08-19	2032	3	8	34	4	f	2032-2
20320820	2032-08-20	2032	3	8	34	5	f	2032-2
20320821	2032-08-21	2032	3	8	34	6	t	2032-2
20320822	2032-08-22	2032	3	8	34	7	t	2032-2
20320823	2032-08-23	2032	3	8	35	1	f	2032-2
20320824	2032-08-24	2032	3	8	35	2	f	2032-2
20320825	2032-08-25	2032	3	8	35	3	f	2032-2
20320826	2032-08-26	2032	3	8	35	4	f	2032-2
20320827	2032-08-27	2032	3	8	35	5	f	2032-2
20320828	2032-08-28	2032	3	8	35	6	t	2032-2
20320829	2032-08-29	2032	3	8	35	7	t	2032-2
20320830	2032-08-30	2032	3	8	36	1	f	2032-2
20320831	2032-08-31	2032	3	8	36	2	f	2032-2
20320901	2032-09-01	2032	3	9	36	3	f	2032-2
20320902	2032-09-02	2032	3	9	36	4	f	2032-2
20320903	2032-09-03	2032	3	9	36	5	f	2032-2
20320904	2032-09-04	2032	3	9	36	6	t	2032-2
20320905	2032-09-05	2032	3	9	36	7	t	2032-2
20320906	2032-09-06	2032	3	9	37	1	f	2032-2
20320907	2032-09-07	2032	3	9	37	2	f	2032-2
20320908	2032-09-08	2032	3	9	37	3	f	2032-2
20320909	2032-09-09	2032	3	9	37	4	f	2032-2
20320910	2032-09-10	2032	3	9	37	5	f	2032-2
20320911	2032-09-11	2032	3	9	37	6	t	2032-2
20320912	2032-09-12	2032	3	9	37	7	t	2032-2
20320913	2032-09-13	2032	3	9	38	1	f	2032-2
20320914	2032-09-14	2032	3	9	38	2	f	2032-2
20320915	2032-09-15	2032	3	9	38	3	f	2032-2
20320916	2032-09-16	2032	3	9	38	4	f	2032-2
20320917	2032-09-17	2032	3	9	38	5	f	2032-2
20320918	2032-09-18	2032	3	9	38	6	t	2032-2
20320919	2032-09-19	2032	3	9	38	7	t	2032-2
20320920	2032-09-20	2032	3	9	39	1	f	2032-2
20320921	2032-09-21	2032	3	9	39	2	f	2032-2
20320922	2032-09-22	2032	3	9	39	3	f	2032-2
20320923	2032-09-23	2032	3	9	39	4	f	2032-2
20320924	2032-09-24	2032	3	9	39	5	f	2032-2
20320925	2032-09-25	2032	3	9	39	6	t	2032-2
20320926	2032-09-26	2032	3	9	39	7	t	2032-2
20320927	2032-09-27	2032	3	9	40	1	f	2032-2
20320928	2032-09-28	2032	3	9	40	2	f	2032-2
20320929	2032-09-29	2032	3	9	40	3	f	2032-2
20320930	2032-09-30	2032	3	9	40	4	f	2032-2
20321001	2032-10-01	2032	4	10	40	5	f	2032-2
20321002	2032-10-02	2032	4	10	40	6	t	2032-2
20321003	2032-10-03	2032	4	10	40	7	t	2032-2
20321004	2032-10-04	2032	4	10	41	1	f	2032-2
20321005	2032-10-05	2032	4	10	41	2	f	2032-2
20321006	2032-10-06	2032	4	10	41	3	f	2032-2
20321007	2032-10-07	2032	4	10	41	4	f	2032-2
20321008	2032-10-08	2032	4	10	41	5	f	2032-2
20321009	2032-10-09	2032	4	10	41	6	t	2032-2
20321010	2032-10-10	2032	4	10	41	7	t	2032-2
20321011	2032-10-11	2032	4	10	42	1	f	2032-2
20321012	2032-10-12	2032	4	10	42	2	f	2032-2
20321013	2032-10-13	2032	4	10	42	3	f	2032-2
20321014	2032-10-14	2032	4	10	42	4	f	2032-2
20321015	2032-10-15	2032	4	10	42	5	f	2032-2
20321016	2032-10-16	2032	4	10	42	6	t	2032-2
20321017	2032-10-17	2032	4	10	42	7	t	2032-2
20321018	2032-10-18	2032	4	10	43	1	f	2032-2
20321019	2032-10-19	2032	4	10	43	2	f	2032-2
20321020	2032-10-20	2032	4	10	43	3	f	2032-2
20321021	2032-10-21	2032	4	10	43	4	f	2032-2
20321022	2032-10-22	2032	4	10	43	5	f	2032-2
20321023	2032-10-23	2032	4	10	43	6	t	2032-2
20321024	2032-10-24	2032	4	10	43	7	t	2032-2
20321025	2032-10-25	2032	4	10	44	1	f	2032-2
20321026	2032-10-26	2032	4	10	44	2	f	2032-2
20321027	2032-10-27	2032	4	10	44	3	f	2032-2
20321028	2032-10-28	2032	4	10	44	4	f	2032-2
20321029	2032-10-29	2032	4	10	44	5	f	2032-2
20321030	2032-10-30	2032	4	10	44	6	t	2032-2
20321031	2032-10-31	2032	4	10	44	7	t	2032-2
20321101	2032-11-01	2032	4	11	45	1	f	2032-2
20321102	2032-11-02	2032	4	11	45	2	f	2032-2
20321103	2032-11-03	2032	4	11	45	3	f	2032-2
20321104	2032-11-04	2032	4	11	45	4	f	2032-2
20321105	2032-11-05	2032	4	11	45	5	f	2032-2
20321106	2032-11-06	2032	4	11	45	6	t	2032-2
20321107	2032-11-07	2032	4	11	45	7	t	2032-2
20321108	2032-11-08	2032	4	11	46	1	f	2032-2
20321109	2032-11-09	2032	4	11	46	2	f	2032-2
20321110	2032-11-10	2032	4	11	46	3	f	2032-2
20321111	2032-11-11	2032	4	11	46	4	f	2032-2
20321112	2032-11-12	2032	4	11	46	5	f	2032-2
20321113	2032-11-13	2032	4	11	46	6	t	2032-2
20321114	2032-11-14	2032	4	11	46	7	t	2032-2
20321115	2032-11-15	2032	4	11	47	1	f	2032-2
20321116	2032-11-16	2032	4	11	47	2	f	2032-2
20321117	2032-11-17	2032	4	11	47	3	f	2032-2
20321118	2032-11-18	2032	4	11	47	4	f	2032-2
20321119	2032-11-19	2032	4	11	47	5	f	2032-2
20321120	2032-11-20	2032	4	11	47	6	t	2032-2
20321121	2032-11-21	2032	4	11	47	7	t	2032-2
20321122	2032-11-22	2032	4	11	48	1	f	2032-2
20321123	2032-11-23	2032	4	11	48	2	f	2032-2
20321124	2032-11-24	2032	4	11	48	3	f	2032-2
20321125	2032-11-25	2032	4	11	48	4	f	2032-2
20321126	2032-11-26	2032	4	11	48	5	f	2032-2
20321127	2032-11-27	2032	4	11	48	6	t	2032-2
20321128	2032-11-28	2032	4	11	48	7	t	2032-2
20321129	2032-11-29	2032	4	11	49	1	f	2032-2
20321130	2032-11-30	2032	4	11	49	2	f	2032-2
20321201	2032-12-01	2032	4	12	49	3	f	2032-2
20321202	2032-12-02	2032	4	12	49	4	f	2032-2
20321203	2032-12-03	2032	4	12	49	5	f	2032-2
20321204	2032-12-04	2032	4	12	49	6	t	2032-2
20321205	2032-12-05	2032	4	12	49	7	t	2032-2
20321206	2032-12-06	2032	4	12	50	1	f	2032-2
20321207	2032-12-07	2032	4	12	50	2	f	2032-2
20321208	2032-12-08	2032	4	12	50	3	f	2032-2
20321209	2032-12-09	2032	4	12	50	4	f	2032-2
20321210	2032-12-10	2032	4	12	50	5	f	2032-2
20321211	2032-12-11	2032	4	12	50	6	t	2032-2
20321212	2032-12-12	2032	4	12	50	7	t	2032-2
20321213	2032-12-13	2032	4	12	51	1	f	2032-2
20321214	2032-12-14	2032	4	12	51	2	f	2032-2
20321215	2032-12-15	2032	4	12	51	3	f	2032-2
20321216	2032-12-16	2032	4	12	51	4	f	2032-2
20321217	2032-12-17	2032	4	12	51	5	f	2032-2
20321218	2032-12-18	2032	4	12	51	6	t	2032-2
20321219	2032-12-19	2032	4	12	51	7	t	2032-2
20321220	2032-12-20	2032	4	12	52	1	f	2032-2
20321221	2032-12-21	2032	4	12	52	2	f	2032-2
20321222	2032-12-22	2032	4	12	52	3	f	2032-2
20321223	2032-12-23	2032	4	12	52	4	f	2032-2
20321224	2032-12-24	2032	4	12	52	5	f	2032-2
20321225	2032-12-25	2032	4	12	52	6	t	2032-2
20321226	2032-12-26	2032	4	12	52	7	t	2032-2
20321227	2032-12-27	2032	4	12	53	1	f	2032-2
20321228	2032-12-28	2032	4	12	53	2	f	2032-2
20321229	2032-12-29	2032	4	12	53	3	f	2032-2
20321230	2032-12-30	2032	4	12	53	4	f	2032-2
20321231	2032-12-31	2032	4	12	53	5	f	2032-2
\.


--
-- Data for Name: dim_guild; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.dim_guild (guild_key, source_id, guild_type, setting, municipality_code) FROM stdin;
\.


--
-- Data for Name: dim_instrument; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.dim_instrument (instrument_key, code, name_es, health_domain, reference) FROM stdin;
1	ANTHROPOMETRY	Valoración antropométrica	PHYSICAL	ISAK
2	PERIMETERS	Perímetros corporales	PHYSICAL	ISAK
3	FMS	Functional Movement Screen	PHYSICAL	Cook, Burton & Hoogenboom 2006
4	DYNAMOMETRY	Dinamometría de prensión manual	PHYSICAL	Roberts et al. 2011 (protocolo Southampton)
5	WELLS_DILLON	Test de flexibilidad de Wells & Dillon	PHYSICAL	Wells & Dillon 1952
6	STRENGTH_RM	Fuerza máxima estimada (1RM/5RM)	PHYSICAL	Brzycki 1993; Epley 1985
7	PSS_10	Escala de Estrés Percibido	MENTAL	Cohen, Kamarck & Mermelstein 1983
8	GHQ_12	Cuestionario de Salud General	MENTAL	Goldberg & Williams 1988
9	MSPSS	Apoyo Social Percibido Multidimensional	SOCIAL	Zimet et al. 1988
10	WHOQOL_SRPB	WHOQOL Espiritualidad, Religiosidad y Creencias Personales	SPIRITUAL	WHOQOL SRPB Group 2006
11	VIA_IS	Inventario VIA de Fortalezas	SPIRITUAL	Peterson & Seligman 2004
12	PIL	Test de Propósito en la Vida	SPIRITUAL	Crumbaugh & Maholick 1964
13	WHO_5	Índice de Bienestar OMS-5	MENTAL	Topp et al. 2015
14	I_PANAS_SF	Afecto positivo y negativo (I-PANAS-SF)	MENTAL	Thompson 2007
15	IPAQ_SF	Cuestionario Internacional de Actividad Física (corto)	PHYSICAL	Craig et al. 2003
16	PSQI	Índice de Calidad de Sueño de Pittsburgh	MENTAL	Buysse et al. 1989
17	AIS	Escala Atenas de Insomnio	MENTAL	Soldatos et al. 2000
18	MEDAS	Adherencia a dieta mediterránea (adaptada)	LIFESTYLE	Schröder et al. 2011
19	FACIT_SP_12	Bienestar espiritual FACIT-Sp	SPIRITUAL	Peterman et al. 2002
20	SWBS	Escala de Bienestar Espiritual	SPIRITUAL	Paloutzian & Ellison 1982
21	PASSIVE	Sensores (Apple Health / Health Connect)	PHYSICAL	Agregado diario en dispositivo
22	WELLBEING_INDEX	Índice de Vida Consolidado (provisional)	MENTAL	SIFUS wellbeing-index@1.0.0-provisional
\.


--
-- Data for Name: dim_measure; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.dim_measure (measure_key, measure_code, instrument_key, name_es, unit, improvement_direction, capacity, valid_min, valid_max, mdc, mdc_source, wellbeing_domain, loinc_code, loinc_status) FROM stdin;
4	BODY_FAT_PCT	1	Masa grasa	%	0	\N	2	70	\N	\N	\N	\N	\N
5	WAIST_HIP_RATIO	2	Índice cintura/cadera	ratio	-1	\N	0.5	1.5	\N	\N	\N	\N	\N
6	WAIST_HEIGHT_RATIO	2	Índice cintura/estatura	ratio	-1	\N	0.3	1.0	\N	\N	BODY	\N	\N
7	PERIM_CHEST	2	Perímetro de pecho	cm	0	\N	50	200	\N	\N	\N	\N	\N
8	PERIM_ARM_RELAXED	2	Perímetro de brazo relajado	cm	0	\N	15	70	\N	\N	\N	\N	\N
9	PERIM_ARM_FLEXED	2	Perímetro de brazo contraído	cm	1	STRENGTH	15	75	\N	\N	\N	\N	\N
11	PERIM_HIP	2	Perímetro de cadera	cm	0	\N	50	200	\N	\N	\N	\N	\N
12	PERIM_THIGH	2	Perímetro de muslo medio	cm	0	\N	25	110	\N	\N	\N	\N	\N
13	PERIM_CALF	2	Perímetro de pantorrilla	cm	1	\N	20	70	\N	\N	\N	\N	\N
14	FMS_TOTAL	3	FMS puntaje total	pts 0–21	1	MOBILITY	0	21	\N	\N	BODY	\N	\N
15	FMS_ASYMMETRY_COUNT	3	FMS número de asimetrías	n	-1	COORDINATION	0	5	\N	\N	\N	\N	\N
16	FMS_PAIN_COUNT	3	FMS patrones con dolor	n	-1	\N	0	7	\N	\N	\N	\N	\N
17	GRIP_DOMINANT_KG	4	Prensión mano dominante (mejor)	kg	1	STRENGTH	2	100	\N	\N	BODY	\N	\N
18	GRIP_NONDOMINANT_KG	4	Prensión mano no dominante (mejor)	kg	1	STRENGTH	2	100	\N	\N	\N	\N	\N
1	HEIGHT_CM	1	Estatura	cm	0	\N	100	230	\N	\N	\N	8302-2	VERIFIED
2	WEIGHT_KG	1	Masa corporal	kg	0	\N	25	300	\N	\N	\N	29463-7	VERIFIED
3	BMI	1	Índice de masa corporal	kg/m²	0	\N	10	80	\N	\N	\N	39156-5	VERIFIED
10	PERIM_WAIST	2	Perímetro de cintura	cm	-1	\N	40	200	\N	\N	BODY	8280-0	PENDING_VERIFICATION
19	GRIP_RELATIVE	4	Prensión dominante / masa corporal	kg/kg	1	STRENGTH	0.02	1.5	\N	\N	BODY	\N	\N
20	SIT_REACH_FOOTLINE_CM	5	Wells & Dillon relativo a la línea de los pies	cm	1	MOBILITY	-40	40	\N	\N	\N	\N	\N
21	SQUAT_1RM_KG	6	Sentadilla profunda 1RM (estimado)	kg	1	STRENGTH	0	400	\N	\N	\N	\N	\N
22	SQUAT_1RM_REL	6	Sentadilla 1RM / masa corporal	kg/kg	1	STRENGTH	0	4	\N	\N	BODY	\N	\N
23	BENCH_1RM_KG	6	Press de banca 1RM (estimado)	kg	1	STRENGTH	0	300	\N	\N	\N	\N	\N
24	BENCH_1RM_REL	6	Press de banca 1RM / masa corporal	kg/kg	1	STRENGTH	0	3	\N	\N	BODY	\N	\N
25	PSS10_TOTAL	7	PSS-10 puntaje total	pts 0–40	-1	\N	0	40	\N	\N	RESTORATION	\N	\N
26	GHQ12_GHQ	8	GHQ-12 (método GHQ 0-0-1-1)	pts 0–12	-1	\N	0	12	\N	\N	MIND	\N	\N
27	GHQ12_LIKERT	8	GHQ-12 (método Likert 0-3)	pts 0–36	-1	\N	0	36	\N	\N	MIND	\N	\N
28	MSPSS_TOTAL	9	MSPSS media total	media 1–7	1	\N	1	7	\N	\N	\N	\N	\N
29	MSPSS_FAMILY	9	MSPSS familia	media 1–7	1	\N	1	7	\N	\N	\N	\N	\N
30	MSPSS_FRIENDS	9	MSPSS amigos	media 1–7	1	\N	1	7	\N	\N	\N	\N	\N
31	MSPSS_SIGNIFICANT_OTHER	9	MSPSS otra persona significativa	media 1–7	1	\N	1	7	\N	\N	\N	\N	\N
32	SRPB_TOTAL	10	WHOQOL-SRPB media de facetas	pts 4–20	1	\N	4	20	\N	\N	PURPOSE	\N	\N
33	SRPB_SPIRITUAL_CONNECTION	10	SRPB conexión espiritual	pts 4–20	1	\N	4	20	\N	\N	PURPOSE	\N	\N
34	SRPB_MEANING	10	SRPB sentido y propósito	pts 4–20	1	\N	4	20	\N	\N	PURPOSE	\N	\N
35	SRPB_AWE	10	SRPB asombro	pts 4–20	1	\N	4	20	\N	\N	PURPOSE	\N	\N
36	SRPB_WHOLENESS	10	SRPB integración	pts 4–20	1	\N	4	20	\N	\N	PURPOSE	\N	\N
37	SRPB_SPIRITUAL_STRENGTH	10	SRPB fortaleza espiritual	pts 4–20	1	\N	4	20	\N	\N	PURPOSE	\N	\N
38	SRPB_INNER_PEACE	10	SRPB paz interior	pts 4–20	1	\N	4	20	\N	\N	PURPOSE	\N	\N
39	SRPB_HOPE	10	SRPB esperanza y optimismo	pts 4–20	1	\N	4	20	\N	\N	PURPOSE	\N	\N
40	SRPB_FAITH	10	SRPB fe	pts 4–20	1	\N	4	20	\N	\N	PURPOSE	\N	\N
41	PIL_TOTAL	12	Propósito en la vida total	pts 20–140	1	\N	20	140	\N	\N	PURPOSE	\N	\N
42	WHO5_PCT	13	WHO-5 bienestar	% 0–100	1	\N	0	100	\N	\N	MIND	\N	\N
43	PANAS_PA	14	Afecto positivo	pts 5–25	1	\N	5	25	\N	\N	MIND	\N	\N
44	PANAS_NA	14	Afecto negativo	pts 5–25	-1	\N	5	25	\N	\N	MIND	\N	\N
45	PANAS_BALANCE	14	Balance afectivo (PA − NA)	pts −20–20	1	\N	-20	20	\N	\N	MIND	\N	\N
46	IPAQ_MET_MIN	15	Actividad física	MET-min/sem	1	ENDURANCE	0	20000	\N	\N	BODY	\N	\N
47	IPAQ_SITTING_MIN	15	Tiempo sentado	min/día	-1	\N	0	1440	\N	\N	BODY	\N	\N
48	PSQI_GLOBAL	16	PSQI global	pts 0–21	-1	\N	0	21	\N	\N	RESTORATION	\N	\N
49	AIS_TOTAL	17	Escala Atenas de Insomnio	pts 0–24	-1	\N	0	24	\N	\N	RESTORATION	\N	\N
50	MEDAS_NORMALIZED	18	MEDAS normalizado	% 0–100	1	\N	0	100	\N	\N	LIFESTYLE	\N	\N
51	FACIT_SP_TOTAL	19	FACIT-Sp total	pts	1	\N	0	48	\N	\N	PURPOSE	\N	\N
52	FACIT_SP_MEANING	19	FACIT-Sp significado	pts 0–16	1	\N	0	16	\N	\N	PURPOSE	\N	\N
53	FACIT_SP_PEACE	19	FACIT-Sp paz	pts 0–16	1	\N	0	16	\N	\N	PURPOSE	\N	\N
54	FACIT_SP_FAITH	19	FACIT-Sp fe	pts 0–16	1	\N	0	16	\N	\N	PURPOSE	\N	\N
55	SWBS_TOTAL	20	SWBS total	pts 20–120	1	\N	20	120	\N	\N	PURPOSE	\N	\N
56	SWBS_EXISTENTIAL	20	SWBS bienestar existencial	pts 10–60	1	\N	10	60	\N	\N	PURPOSE	\N	\N
60	WELLBEING_INDEX_MEAN	22	Índice de Vida (media del periodo)	0–100	1	\N	0	100	\N	\N	\N	\N	\N
57	STEPS_MEAN	21	Pasos diarios (media del periodo)	pasos/día	1	ENDURANCE	0	80000	\N	\N	BODY	55423-8	PENDING_VERIFICATION
58	RESTING_HR_MEAN	21	FC en reposo (media del periodo)	lpm	-1	\N	30	120	\N	\N	RESTORATION	40443-4	PENDING_VERIFICATION
59	SLEEP_HOURS_MEAN	21	Sueño por sensor (media del periodo)	h	0	\N	0	16	\N	\N	RESTORATION	93832-4	PENDING_VERIFICATION
61	VIA_CREATIVITY	11	VIA Creativity	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
62	VIA_CURIOSITY	11	VIA Curiosity	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
63	VIA_JUDGMENT	11	VIA Judgment	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
64	VIA_LOVE_OF_LEARNING	11	VIA Love Of Learning	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
65	VIA_PERSPECTIVE	11	VIA Perspective	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
66	VIA_BRAVERY	11	VIA Bravery	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
67	VIA_PERSEVERANCE	11	VIA Perseverance	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
68	VIA_HONESTY	11	VIA Honesty	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
69	VIA_ZEST	11	VIA Zest	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
70	VIA_LOVE	11	VIA Love	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
71	VIA_KINDNESS	11	VIA Kindness	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
72	VIA_SOCIAL_INTELLIGENCE	11	VIA Social Intelligence	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
73	VIA_TEAMWORK	11	VIA Teamwork	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
74	VIA_FAIRNESS	11	VIA Fairness	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
75	VIA_LEADERSHIP	11	VIA Leadership	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
76	VIA_FORGIVENESS	11	VIA Forgiveness	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
77	VIA_HUMILITY	11	VIA Humility	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
78	VIA_PRUDENCE	11	VIA Prudence	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
79	VIA_SELF_REGULATION	11	VIA Self Regulation	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
80	VIA_APPRECIATION_OF_BEAUTY	11	VIA Appreciation Of Beauty	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
81	VIA_GRATITUDE	11	VIA Gratitude	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
82	VIA_HOPE	11	VIA Hope	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
83	VIA_HUMOR	11	VIA Humor	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
84	VIA_SPIRITUALITY	11	VIA Spirituality	media 1–5	0	\N	1	5	\N	\N	\N	\N	\N
\.


--
-- Data for Name: dim_mission; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.dim_mission (mission_key, code, title, category, intensity, duration_minutes) FROM stdin;
1	REC_JOINT_MOBILITY_10	Ritual de articulaciones	RECOVERY	LIGHT	10
2	REC_MOBILITY_FLOW_20	Flujo de movilidad	RECOVERY	LIGHT	20
3	REC_SHOULDER_RESET_12	Hombros libres	RECOVERY	LIGHT	12
4	REC_CORE_CONTROL_12	Centro estable	RECOVERY	LIGHT	12
5	REC_DAYLIGHT_WALK_20	Caminata con luz natural	RECOVERY	LIGHT	20
6	REC_NATURE_WALK_25	Sendero verde	RECOVERY	LIGHT	25
7	REC_MINDFUL_WALK_20	Caminata consciente	RECOVERY	LIGHT	20
8	REC_SLEEP_HYGIENE_15	Ritual de higiene del sueño	RECOVERY	RESTORATIVE	15
9	MIND_BREATH_478_5	Respiración 4-7-8	MINDFULNESS	RESTORATIVE	5
10	MIND_BODY_SCAN_10	Escaneo corporal	MINDFULNESS	RESTORATIVE	10
11	MIND_COHERENT_BREATH_8	Respiración coherente	MINDFULNESS	RESTORATIVE	8
12	FUN_BALANCE_CIRCUIT_20	Circuito de equilibrio	FUNCTIONAL	LIGHT	20
13	FUN_DAILY_LIFE_25	Fuerza para la vida diaria	FUNCTIONAL	MODERATE	25
14	FUN_AGILITY_LADDER_25	Pies ligeros	FUNCTIONAL	MODERATE	25
15	CON_INTERVAL_WALK_30	Caminata por intervalos	CONDITIONING	MODERATE	30
16	STR_SQUAT_PRESS_40	Forja: sentadilla y empuje	STRENGTH	HIGH	40
17	STR_FULL_BODY_30	Forja exprés de cuerpo completo	STRENGTH	HIGH	30
18	CON_HIIT_20	Ráfaga	CONDITIONING	HIGH	20
19	COM_WALK_TOGETHER_20	Caminemos juntos	COMMUNITY	LIGHT	20
20	COM_ENCOURAGE_GUILD_2	Enciende una antorcha	COMMUNITY	RESTORATIVE	2
21	LORE_PURPOSE_CHECK_2	Bitácora: ¿para qué me muevo hoy?	LORE	RESTORATIVE	2
22	LORE_GENTLE_DAY_2	Bitácora: lo que hoy me sostiene	LORE	RESTORATIVE	2
\.


--
-- Data for Name: dim_participant; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.dim_participant (participant_key, research_code, sex_for_reference, age_at_enrollment, age_group, setting, municipality_code, baseline_experience, spiritual_orientation, avatar_archetype, enrollment_date, cohort, loaded_at) FROM stdin;
\.


--
-- Data for Name: dim_phase; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.dim_phase (phase_key, phase_code, phase_order, nominal_week, label_es) FROM stdin;
1	BASELINE	1	0	Línea de base
2	MONTH_1	2	4	Mes 1
3	MONTH_2	3	8	Mes 2
4	MONTH_3	4	13	Mes 3
5	MONTH_6	5	26	Mes 6
6	FOLLOW_UP	6	52	Seguimiento
\.


--
-- Data for Name: dim_readiness_band; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.dim_readiness_band (band_key, band_code, label_es, band_order) FROM stdin;
1	RECOVERY	Ruta de Recuperación	1
2	BALANCE	Ruta de Equilibrio	2
3	EXPANSION	Ruta de Expansión	3
\.


--
-- Data for Name: fact_assessment_measure; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.fact_assessment_measure (participant_key, phase_key, measure_key, date_key, value, is_valid, protocol_version) FROM stdin;
\.


--
-- Data for Name: fact_daily_wellbeing; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.fact_daily_wellbeing (participant_key, date_key, band_key, sleep_hours, sleep_quality, perceived_stress, mental_fatigue, physical_fatigue, pain_level, mood, feels_isolated, load_score, rpe_cap, reason_codes, safety_flags, algorithm_version) FROM stdin;
\.


--
-- Data for Name: fact_guild_contribution; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.fact_guild_contribution (contribution_id, participant_key, guild_key, date_key, metric, value) FROM stdin;
\.


--
-- Data for Name: fact_lore_reflection; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.fact_lore_reflection (lore_entry_id, participant_key, date_key, moment, purpose_theme, coherence_rating, strengths_used, linked_to_mission) FROM stdin;
\.


--
-- Data for Name: fact_mission_adherence; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.fact_mission_adherence (daily_mission_id, participant_key, date_key, mission_key, band_key, slot, assigned_count, completed_count, adapted_count, skipped_count, reported_rpe, actual_minutes, xp_awarded) FROM stdin;
\.


--
-- Data for Name: fact_passive_daily; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.fact_passive_daily (participant_key, date_key, metric, value, sample_count, platform, device_model) FROM stdin;
\.


--
-- Data for Name: fact_red_flag_event; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.fact_red_flag_event (red_flag_event_id, participant_key, date_key, level, triggers, hours_to_professional_contact, resolved, protocol_version) FROM stdin;
\.


--
-- Data for Name: fact_wellbeing_index; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.fact_wellbeing_index (participant_key, date_key, wellbeing_index, mind_score, body_score, restoration_score, lifestyle_score, purpose_score, confidence, self_report_reliability, consistency_flag_count, index_version) FROM stdin;
\.


--
-- Data for Name: map_questionnaire_measure; Type: TABLE DATA; Schema: analytics; Owner: -
--

COPY analytics.map_questionnaire_measure (instrument, json_key, measure_code) FROM stdin;
PSS_10	\N	PSS10_TOTAL
GHQ_12	\N	GHQ12_GHQ
GHQ_12	likert	GHQ12_LIKERT
MSPSS	\N	MSPSS_TOTAL
MSPSS	family	MSPSS_FAMILY
MSPSS	friends	MSPSS_FRIENDS
MSPSS	significantOther	MSPSS_SIGNIFICANT_OTHER
WHOQOL_SRPB	\N	SRPB_TOTAL
WHOQOL_SRPB	spiritualConnection	SRPB_SPIRITUAL_CONNECTION
WHOQOL_SRPB	meaningAndPurpose	SRPB_MEANING
WHOQOL_SRPB	awe	SRPB_AWE
WHOQOL_SRPB	wholeness	SRPB_WHOLENESS
WHOQOL_SRPB	spiritualStrength	SRPB_SPIRITUAL_STRENGTH
WHOQOL_SRPB	innerPeace	SRPB_INNER_PEACE
WHOQOL_SRPB	hope	SRPB_HOPE
WHOQOL_SRPB	faith	SRPB_FAITH
PIL	\N	PIL_TOTAL
WHO_5	\N	WHO5_PCT
I_PANAS_SF	\N	PANAS_BALANCE
I_PANAS_SF	positiveAffect	PANAS_PA
I_PANAS_SF	negativeAffect	PANAS_NA
IPAQ_SF	\N	IPAQ_MET_MIN
IPAQ_SF	sittingMinutesPerDay	IPAQ_SITTING_MIN
PSQI	\N	PSQI_GLOBAL
AIS	\N	AIS_TOTAL
MEDAS	normalized	MEDAS_NORMALIZED
FACIT_SP_12	\N	FACIT_SP_TOTAL
FACIT_SP_12	meaning	FACIT_SP_MEANING
FACIT_SP_12	peace	FACIT_SP_PEACE
FACIT_SP_12	faith	FACIT_SP_FAITH
SWBS	\N	SWBS_TOTAL
SWBS	existential	SWBS_EXISTENTIAL
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
ce59ffeb-7eea-4207-8dcf-df41daf540c8	27e99a45744e3257be839df2bfe85018dd9d27aded59a85119836cacd4705a13	2026-11-16 20:18:28.862596+00	20261027134306_init	\N	\N	2026-11-16 20:18:28.780885+00	1
\.


--
-- Data for Name: anamneses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.anamneses (id, "userId", phase, "recordedAt", "sleepHoursNight", "sleepQuality", "perceivedStress", "waterIntakeLiters", "trainingExperience", "trainingMonths", "weeklyFrequency", "avgSessionMinutes", "preferredModalities", "perceivedBarriers", "smokingStatus", "sittingHoursPerDay", "screenMinutesBeforeBed") FROM stdin;
\.


--
-- Data for Name: anthropometric_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.anthropometric_records (id, "assessmentId", "heightCm", "weightKg", "bodyFatPct", "bodyFatMethod", "equationName") FROM stdin;
\.


--
-- Data for Name: assessments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assessments (id, "userId", "evaluatorId", phase, "assessedAt", location, source, "protocolVersion", conditions, notes, "createdAt") FROM stdin;
\.


--
-- Data for Name: clinical_exports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.clinical_exports (id, "userId", format, "requestedBy", recipient, "periodFrom", "periodTo", sha256, "createdAt") FROM stdin;
\.


--
-- Data for Name: clinical_histories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.clinical_histories (id, "userId", "medicalConditions", medications, "surgicalHistory", "notesCiphertext", "foodAversions", "usesHormonalContraception", "requiresMedicalClearance", "clearanceGrantedAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: daily_check_ins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.daily_check_ins (id, "userId", date, "sleepHours", "sleepQuality", "perceivedStress", "mentalFatigue", "physicalFatigue", "painLevel", "painRegion", mood, "feelsIsolated", "createdAt") FROM stdin;
\.


--
-- Data for Name: daily_missions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.daily_missions (id, "planId", "templateId", slot, status, "startedAt", "completedAt", "reportedRpe", "actualMinutes", "xpAwarded", "adaptationNote") FROM stdin;
\.


--
-- Data for Name: daily_plans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.daily_plans (id, "userId", date, "checkInId", band, "loadScore", "rpeCap", "blockedIntensities", "reasonCodes", "safetyFlags", "algorithmVersion", "inputSnapshot", "createdAt") FROM stdin;
\.


--
-- Data for Name: dynamometry_tests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dynamometry_tests (id, "assessmentId", hand, "isDominant", "trialsKg", "bestKg", device, protocol) FROM stdin;
\.


--
-- Data for Name: flexibility_tests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.flexibility_tests (id, "assessmentId", "testName", "trialsCm", "bestCm", "footLineAtCm") FROM stdin;
\.


--
-- Data for Name: fms_pattern_scores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fms_pattern_scores (id, "screenId", pattern, "leftScore", "rightScore", "singleScore", "clearingTestPain", "finalScore") FROM stdin;
\.


--
-- Data for Name: fms_screens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fms_screens (id, "assessmentId", "totalScore", "hasAsymmetry", "hasPain", "scoringVersion") FROM stdin;
\.


--
-- Data for Name: guild_encouragements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guild_encouragements (id, "guildId", "senderId", "recipientId", "messageCode", "createdAt") FROM stdin;
\.


--
-- Data for Name: guild_memberships; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guild_memberships (id, "guildId", "userId", role, "matchSnapshot", alias, "joinedAt", "leftAt") FROM stdin;
\.


--
-- Data for Name: guild_quest_contributions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guild_quest_contributions (id, "questId", "membershipId", value, "createdAt") FROM stdin;
\.


--
-- Data for Name: guild_quests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guild_quests (id, "guildId", title, metric, "targetValue", "startsAt", "endsAt", "completedAt") FROM stdin;
\.


--
-- Data for Name: guilds; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guilds (id, name, type, setting, description, "anonymousByDefault", "municipalityCode", "maxMembers", "createdAt") FROM stdin;
\.


--
-- Data for Name: injury_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.injury_records (id, "userId", region, side, status, "occurredYear", "hadSurgery", "currentPain", "reportedAt") FROM stdin;
\.


--
-- Data for Name: lore_entries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lore_entries (id, "userId", "dailyMissionId", moment, "promptCode", "purposeTheme", "contentCiphertext", "hasGratitude", "achievementRef", orientation, "coherenceRating", "strengthsUsed", "createdAt") FROM stdin;
\.


--
-- Data for Name: mission_templates; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mission_templates (id, code, title, description, category, intensity, "durationMinutes", "capacityXp", "loadedPatterns", "minAgeYears", "maxAgeYears", contraindications, active, version) FROM stdin;
884411cd-a6b9-4986-a703-bc2308a36ccd	REC_JOINT_MOBILITY_10	Ritual de articulaciones	Círculos lentos de tobillo, cadera, columna, hombros y cuello. 10 minutos, sin prisa.	RECOVERY	LIGHT	10	{"MOBILITY": 25, "PROPRIOCEPTION": 10}	{}	\N	\N	\N	t	1
65e22c78-ccd8-4a60-9ed3-025c2685ccf7	REC_MOBILITY_FLOW_20	Flujo de movilidad	Secuencia suave de movilidad de cadera y columna torácica, respirando por la nariz.	RECOVERY	LIGHT	20	{"BALANCE": 10, "MOBILITY": 30}	{}	\N	\N	\N	t	1
2db408d2-655b-40e9-90bd-16ed54a53f61	REC_SHOULDER_RESET_12	Hombros libres	Movilidad escapular y torácica guiada para recuperar rango sin carga.	RECOVERY	LIGHT	12	{"MOBILITY": 25, "COORDINATION": 10}	{}	\N	\N	\N	t	1
0a637dd3-0257-4ccb-81a4-da60367d5013	REC_CORE_CONTROL_12	Centro estable	Control motor de tronco en el suelo: dead bug y bird dog lentos, sin dolor.	RECOVERY	LIGHT	12	{"BALANCE": 15, "COORDINATION": 15, "PROPRIOCEPTION": 10}	{}	\N	\N	\N	t	1
0dfb1dc6-1a22-4b6b-a3b4-2d7be2f044fa	REC_DAYLIGHT_WALK_20	Caminata con luz natural	Camina 20 minutos a ritmo conversacional, idealmente de día: la luz ayuda a ordenar el sueño.	RECOVERY	LIGHT	20	{"BALANCE": 5, "ENDURANCE": 25}	{}	\N	\N	\N	t	1
0dcb460a-374c-41c9-a8c3-751a786b86c9	REC_NATURE_WALK_25	Sendero verde	Camina en un parque o zona verde, atento a lo que ves, oyes y hueles. Sin pantalla.	RECOVERY	LIGHT	25	{"ENDURANCE": 25, "PROPRIOCEPTION": 10}	{}	\N	\N	\N	t	1
180aac26-fb5e-49d7-839b-e4c75cbe0593	REC_MINDFUL_WALK_20	Caminata consciente	Camina despacio sincronizando pasos y respiración: 4 pasos al inhalar, 6 al exhalar.	RECOVERY	LIGHT	20	{"BALANCE": 10, "ENDURANCE": 15, "PROPRIOCEPTION": 10}	{}	\N	\N	\N	t	1
8c2151c1-cfde-4271-8427-9b6f35bf75cd	REC_SLEEP_HYGIENE_15	Ritual de higiene del sueño	Esta noche: pantallas fuera 60 min antes, luz tenue, 10 min de estiramiento suave en la cama y la misma hora de acostarte.	RECOVERY	RESTORATIVE	15	{"MOBILITY": 15, "PROPRIOCEPTION": 15}	{}	\N	\N	\N	t	1
010e0c21-8a61-4e58-bf6b-20a309e1f9ff	MIND_BREATH_478_5	Respiración 4-7-8	Inhala 4 s, sostén 7 s, exhala 8 s. Cuatro ciclos, sentado o acostado.	MINDFULNESS	RESTORATIVE	5	{"PROPRIOCEPTION": 15}	{}	\N	\N	\N	t	1
96214c49-e733-44d6-ac91-af1f1e549c49	MIND_BODY_SCAN_10	Escaneo corporal	Recorre tu cuerpo con la atención, de pies a cabeza, notando sin juzgar.	MINDFULNESS	RESTORATIVE	10	{"PROPRIOCEPTION": 20}	{}	\N	\N	\N	t	1
e15c4607-5a87-499d-b6ac-6a7877302e6a	MIND_COHERENT_BREATH_8	Respiración coherente	Cinco respiraciones por minuto durante 8 minutos. Calma el sistema nervioso.	MINDFULNESS	RESTORATIVE	8	{"ENDURANCE": 5, "PROPRIOCEPTION": 15}	{}	\N	\N	\N	t	1
bce86392-bbc2-4a09-bca4-8d013b3ff4b0	FUN_BALANCE_CIRCUIT_20	Circuito de equilibrio	Apoyo unipodal, marcha en línea y alcances multidireccionales. Ten una pared cerca.	FUNCTIONAL	LIGHT	20	{"BALANCE": 25, "COORDINATION": 5, "PROPRIOCEPTION": 15}	{}	\N	\N	\N	t	1
e622e3ec-17f8-4c73-93e2-bd2eec8c173e	FUN_DAILY_LIFE_25	Fuerza para la vida diaria	Sentarse y levantarse, cargar, empujar y alcanzar: patrones de la vida cotidiana con peso corporal.	FUNCTIONAL	MODERATE	25	{"BALANCE": 10, "STRENGTH": 20, "COORDINATION": 10}	{DEEP_SQUAT,INLINE_LUNGE}	\N	\N	\N	t	1
f17f1f92-e70a-499a-ab76-454870fa3712	FUN_AGILITY_LADDER_25	Pies ligeros	Patrones de agilidad y cambios de dirección a intensidad moderada.	FUNCTIONAL	MODERATE	25	{"AGILITY": 25, "COORDINATION": 15}	{HURDLE_STEP,INLINE_LUNGE}	12	\N	\N	t	1
a9d45402-fcfe-4e73-bccc-4b2eb32cbfc5	CON_INTERVAL_WALK_30	Caminata por intervalos	Alterna 3 min de paso rápido con 2 min de paso cómodo, seis veces.	CONDITIONING	MODERATE	30	{"ENDURANCE": 35}	{}	\N	\N	\N	t	1
1e024d09-1fb8-4638-8448-5130c71ff1b2	STR_SQUAT_PRESS_40	Forja: sentadilla y empuje	Sentadilla profunda y press con carga progresiva (RPE 7–8), técnica primero.	STRENGTH	HIGH	40	{"STRENGTH": 40, "COORDINATION": 5}	{DEEP_SQUAT,TRUNK_STABILITY_PUSH_UP,SHOULDER_MOBILITY}	14	\N	\N	t	1
1923c4a0-b9e8-4349-bfb8-8ab3a9bac5b4	STR_FULL_BODY_30	Forja exprés de cuerpo completo	Cuatro ejercicios compuestos en circuito, carga exigente pero con técnica impecable.	STRENGTH	HIGH	30	{"STRENGTH": 30, "ENDURANCE": 10}	{DEEP_SQUAT,INLINE_LUNGE,TRUNK_STABILITY_PUSH_UP}	14	\N	\N	t	1
7ceb3cc1-d0cd-44f5-aff8-5443e8955856	CON_HIIT_20	Ráfaga	Intervalos de alta intensidad 30/30 con ejercicios de peso corporal.	CONDITIONING	HIGH	20	{"AGILITY": 15, "ENDURANCE": 25}	{DEEP_SQUAT,HURDLE_STEP}	14	\N	\N	t	1
52afeca6-c7dc-41a8-a778-14f3d459f11e	COM_WALK_TOGETHER_20	Caminemos juntos	Invita a alguien de tu gremio, familia o barrio a caminar 20 minutos.	COMMUNITY	LIGHT	20	{"ENDURANCE": 20}	{}	\N	\N	\N	t	1
c63f3b44-0816-48ac-aa8a-c92f2fff5e10	COM_ENCOURAGE_GUILD_2	Enciende una antorcha	Envía un mensaje de ánimo a tu gremio. A veces cuidarte empieza por cuidar a otro.	COMMUNITY	RESTORATIVE	2	{}	{}	\N	\N	\N	t	1
212d7972-ad5b-41b3-9233-becf405c6618	LORE_PURPOSE_CHECK_2	Bitácora: ¿para qué me muevo hoy?	Una frase que conecte tu movimiento de hoy con tu propósito.	LORE	RESTORATIVE	2	{}	{}	\N	\N	\N	t	1
1e2bf820-de19-44bc-aac2-bb5fbf7d26bd	LORE_GENTLE_DAY_2	Bitácora: lo que hoy me sostiene	¿Qué fortaleza tuya te acompañó hoy, aunque el día fuera pesado?	LORE	RESTORATIVE	2	{}	{}	\N	\N	\N	t	1
\.


--
-- Data for Name: passive_daily_summaries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.passive_daily_summaries (id, "userId", date, metric, value, "sampleCount", platform, "deviceModel", "syncedAt") FROM stdin;
\.


--
-- Data for Name: perimeter_measurements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.perimeter_measurements (id, "assessmentId", site, side, "trialsCm", "valueCm") FROM stdin;
\.


--
-- Data for Name: player_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.player_profiles (id, "userId", "displayName", archetype, "avatarConfig", "birthYear", "sexForReference", "genderIdentity", setting, "municipalityCode", "purposeStatement", "spiritualOrientation", "totalXp", "playerLevel", "coherenceStreak", "graceDaysAvailable", "onboardingCompletedAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: player_strengths; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.player_strengths (id, "userId", strength, "fromVia", "equippedAt") FROM stdin;
\.


--
-- Data for Name: profile_side_quests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profile_side_quests (id, "userId", key, "completedAt", "xpAwarded") FROM stdin;
\.


--
-- Data for Name: questionnaire_administrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.questionnaire_administrations (id, "userId", "assessmentId", phase, instrument, "instrumentVersion", language, "itemResponses", "totalScore", "subscaleScores", "scoringMethod", "scoringVersion", "startedAt", "completedAt") FROM stdin;
\.


--
-- Data for Name: red_flag_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.red_flag_events (id, "userId", "openedAt", level, triggers, "gamificationMode", "protocolVersion", "careTeamNotifiedAt", "professionalContactAt", "followUpNotesCiphertext", "resolvedAt", resolution) FROM stdin;
\.


--
-- Data for Name: reference_norms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reference_norms (id, "measureCode", sex, "ageMin", "ageMax", method, citation, population, "loadedAt") FROM stdin;
\.


--
-- Data for Name: research_consents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.research_consents (id, "userId", scope, "documentVersion", "acceptedAt", "revokedAt", "guardianConsentAt", "allowsCareTeamAlerts", "allowsClinicalExport", "allowsPassiveData") FROM stdin;
\.


--
-- Data for Name: skill_progress; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.skill_progress (id, "userId", capacity, xp, level, "evaluatedMilestones", "lastMilestoneAt") FROM stdin;
\.


--
-- Data for Name: strength_tests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.strength_tests (id, "assessmentId", exercise, protocol, "loadKg", reps, formula, "estimated1RmKg", rpe, "techniqueValid") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, role, "researchCode", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: via_strength_scores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.via_strength_scores (id, "administrationId", strength, score, rank) FROM stdin;
\.


--
-- Data for Name: wellbeing_index_snapshots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.wellbeing_index_snapshots (id, "userId", date, index, status, "mindScore", "bodyScore", "restorationScore", "lifestyleScore", "purposeScore", breakdown, confidence, "selfReportReliability", "consistencyFlags", version, "createdAt") FROM stdin;
\.


--
-- Data for Name: xp_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.xp_events (id, "userId", source, "sourceId", capacity, amount, "createdAt") FROM stdin;
\.


--
-- Name: dim_guild_guild_key_seq; Type: SEQUENCE SET; Schema: analytics; Owner: -
--

SELECT pg_catalog.setval('analytics.dim_guild_guild_key_seq', 1, false);


--
-- Name: dim_measure_measure_key_seq; Type: SEQUENCE SET; Schema: analytics; Owner: -
--

SELECT pg_catalog.setval('analytics.dim_measure_measure_key_seq', 84, true);


--
-- Name: dim_mission_mission_key_seq; Type: SEQUENCE SET; Schema: analytics; Owner: -
--

SELECT pg_catalog.setval('analytics.dim_mission_mission_key_seq', 22, true);


--
-- Name: dim_participant_participant_key_seq; Type: SEQUENCE SET; Schema: analytics; Owner: -
--

SELECT pg_catalog.setval('analytics.dim_participant_participant_key_seq', 1, false);


--
-- Name: dim_date dim_date_full_date_key; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_date
    ADD CONSTRAINT dim_date_full_date_key UNIQUE (full_date);


--
-- Name: dim_date dim_date_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_date
    ADD CONSTRAINT dim_date_pkey PRIMARY KEY (date_key);


--
-- Name: dim_guild dim_guild_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_guild
    ADD CONSTRAINT dim_guild_pkey PRIMARY KEY (guild_key);


--
-- Name: dim_guild dim_guild_source_id_key; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_guild
    ADD CONSTRAINT dim_guild_source_id_key UNIQUE (source_id);


--
-- Name: dim_instrument dim_instrument_code_key; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_instrument
    ADD CONSTRAINT dim_instrument_code_key UNIQUE (code);


--
-- Name: dim_instrument dim_instrument_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_instrument
    ADD CONSTRAINT dim_instrument_pkey PRIMARY KEY (instrument_key);


--
-- Name: dim_measure dim_measure_measure_code_key; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_measure
    ADD CONSTRAINT dim_measure_measure_code_key UNIQUE (measure_code);


--
-- Name: dim_measure dim_measure_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_measure
    ADD CONSTRAINT dim_measure_pkey PRIMARY KEY (measure_key);


--
-- Name: dim_mission dim_mission_code_key; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_mission
    ADD CONSTRAINT dim_mission_code_key UNIQUE (code);


--
-- Name: dim_mission dim_mission_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_mission
    ADD CONSTRAINT dim_mission_pkey PRIMARY KEY (mission_key);


--
-- Name: dim_participant dim_participant_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_participant
    ADD CONSTRAINT dim_participant_pkey PRIMARY KEY (participant_key);


--
-- Name: dim_participant dim_participant_research_code_key; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_participant
    ADD CONSTRAINT dim_participant_research_code_key UNIQUE (research_code);


--
-- Name: dim_phase dim_phase_phase_code_key; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_phase
    ADD CONSTRAINT dim_phase_phase_code_key UNIQUE (phase_code);


--
-- Name: dim_phase dim_phase_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_phase
    ADD CONSTRAINT dim_phase_pkey PRIMARY KEY (phase_key);


--
-- Name: dim_readiness_band dim_readiness_band_band_code_key; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_readiness_band
    ADD CONSTRAINT dim_readiness_band_band_code_key UNIQUE (band_code);


--
-- Name: dim_readiness_band dim_readiness_band_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_readiness_band
    ADD CONSTRAINT dim_readiness_band_pkey PRIMARY KEY (band_key);


--
-- Name: fact_assessment_measure fact_assessment_measure_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_assessment_measure
    ADD CONSTRAINT fact_assessment_measure_pkey PRIMARY KEY (participant_key, phase_key, measure_key);


--
-- Name: fact_daily_wellbeing fact_daily_wellbeing_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_daily_wellbeing
    ADD CONSTRAINT fact_daily_wellbeing_pkey PRIMARY KEY (participant_key, date_key);


--
-- Name: fact_guild_contribution fact_guild_contribution_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_guild_contribution
    ADD CONSTRAINT fact_guild_contribution_pkey PRIMARY KEY (contribution_id);


--
-- Name: fact_lore_reflection fact_lore_reflection_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_lore_reflection
    ADD CONSTRAINT fact_lore_reflection_pkey PRIMARY KEY (lore_entry_id);


--
-- Name: fact_mission_adherence fact_mission_adherence_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_mission_adherence
    ADD CONSTRAINT fact_mission_adherence_pkey PRIMARY KEY (daily_mission_id);


--
-- Name: fact_passive_daily fact_passive_daily_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_passive_daily
    ADD CONSTRAINT fact_passive_daily_pkey PRIMARY KEY (participant_key, date_key, metric);


--
-- Name: fact_red_flag_event fact_red_flag_event_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_red_flag_event
    ADD CONSTRAINT fact_red_flag_event_pkey PRIMARY KEY (red_flag_event_id);


--
-- Name: fact_wellbeing_index fact_wellbeing_index_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_wellbeing_index
    ADD CONSTRAINT fact_wellbeing_index_pkey PRIMARY KEY (participant_key, date_key);


--
-- Name: map_questionnaire_measure map_questionnaire_measure_pkey; Type: CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.map_questionnaire_measure
    ADD CONSTRAINT map_questionnaire_measure_pkey PRIMARY KEY (instrument, measure_code);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: anamneses anamneses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anamneses
    ADD CONSTRAINT anamneses_pkey PRIMARY KEY (id);


--
-- Name: anthropometric_records anthropometric_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anthropometric_records
    ADD CONSTRAINT anthropometric_records_pkey PRIMARY KEY (id);


--
-- Name: assessments assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT assessments_pkey PRIMARY KEY (id);


--
-- Name: clinical_exports clinical_exports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clinical_exports
    ADD CONSTRAINT clinical_exports_pkey PRIMARY KEY (id);


--
-- Name: clinical_histories clinical_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clinical_histories
    ADD CONSTRAINT clinical_histories_pkey PRIMARY KEY (id);


--
-- Name: daily_check_ins daily_check_ins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_check_ins
    ADD CONSTRAINT daily_check_ins_pkey PRIMARY KEY (id);


--
-- Name: daily_missions daily_missions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_missions
    ADD CONSTRAINT daily_missions_pkey PRIMARY KEY (id);


--
-- Name: daily_plans daily_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_plans
    ADD CONSTRAINT daily_plans_pkey PRIMARY KEY (id);


--
-- Name: dynamometry_tests dynamometry_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dynamometry_tests
    ADD CONSTRAINT dynamometry_tests_pkey PRIMARY KEY (id);


--
-- Name: flexibility_tests flexibility_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flexibility_tests
    ADD CONSTRAINT flexibility_tests_pkey PRIMARY KEY (id);


--
-- Name: fms_pattern_scores fms_pattern_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fms_pattern_scores
    ADD CONSTRAINT fms_pattern_scores_pkey PRIMARY KEY (id);


--
-- Name: fms_screens fms_screens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fms_screens
    ADD CONSTRAINT fms_screens_pkey PRIMARY KEY (id);


--
-- Name: guild_encouragements guild_encouragements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_encouragements
    ADD CONSTRAINT guild_encouragements_pkey PRIMARY KEY (id);


--
-- Name: guild_memberships guild_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_memberships
    ADD CONSTRAINT guild_memberships_pkey PRIMARY KEY (id);


--
-- Name: guild_quest_contributions guild_quest_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_quest_contributions
    ADD CONSTRAINT guild_quest_contributions_pkey PRIMARY KEY (id);


--
-- Name: guild_quests guild_quests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_quests
    ADD CONSTRAINT guild_quests_pkey PRIMARY KEY (id);


--
-- Name: guilds guilds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guilds
    ADD CONSTRAINT guilds_pkey PRIMARY KEY (id);


--
-- Name: injury_records injury_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.injury_records
    ADD CONSTRAINT injury_records_pkey PRIMARY KEY (id);


--
-- Name: lore_entries lore_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lore_entries
    ADD CONSTRAINT lore_entries_pkey PRIMARY KEY (id);


--
-- Name: mission_templates mission_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mission_templates
    ADD CONSTRAINT mission_templates_pkey PRIMARY KEY (id);


--
-- Name: passive_daily_summaries passive_daily_summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passive_daily_summaries
    ADD CONSTRAINT passive_daily_summaries_pkey PRIMARY KEY (id);


--
-- Name: perimeter_measurements perimeter_measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.perimeter_measurements
    ADD CONSTRAINT perimeter_measurements_pkey PRIMARY KEY (id);


--
-- Name: player_profiles player_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_profiles
    ADD CONSTRAINT player_profiles_pkey PRIMARY KEY (id);


--
-- Name: player_strengths player_strengths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_strengths
    ADD CONSTRAINT player_strengths_pkey PRIMARY KEY (id);


--
-- Name: profile_side_quests profile_side_quests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profile_side_quests
    ADD CONSTRAINT profile_side_quests_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_administrations questionnaire_administrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaire_administrations
    ADD CONSTRAINT questionnaire_administrations_pkey PRIMARY KEY (id);


--
-- Name: red_flag_events red_flag_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.red_flag_events
    ADD CONSTRAINT red_flag_events_pkey PRIMARY KEY (id);


--
-- Name: reference_norms reference_norms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_norms
    ADD CONSTRAINT reference_norms_pkey PRIMARY KEY (id);


--
-- Name: research_consents research_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_consents
    ADD CONSTRAINT research_consents_pkey PRIMARY KEY (id);


--
-- Name: skill_progress skill_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_progress
    ADD CONSTRAINT skill_progress_pkey PRIMARY KEY (id);


--
-- Name: strength_tests strength_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strength_tests
    ADD CONSTRAINT strength_tests_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: via_strength_scores via_strength_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.via_strength_scores
    ADD CONSTRAINT via_strength_scores_pkey PRIMARY KEY (id);


--
-- Name: wellbeing_index_snapshots wellbeing_index_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wellbeing_index_snapshots
    ADD CONSTRAINT wellbeing_index_snapshots_pkey PRIMARY KEY (id);


--
-- Name: xp_events xp_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xp_events
    ADD CONSTRAINT xp_events_pkey PRIMARY KEY (id);


--
-- Name: ix_fam_measure; Type: INDEX; Schema: analytics; Owner: -
--

CREATE INDEX ix_fam_measure ON analytics.fact_assessment_measure USING btree (measure_key, phase_key);


--
-- Name: ix_fdw_date; Type: INDEX; Schema: analytics; Owner: -
--

CREATE INDEX ix_fdw_date ON analytics.fact_daily_wellbeing USING btree (date_key);


--
-- Name: ix_flr_participant_date; Type: INDEX; Schema: analytics; Owner: -
--

CREATE INDEX ix_flr_participant_date ON analytics.fact_lore_reflection USING btree (participant_key, date_key);


--
-- Name: ix_fma_participant_date; Type: INDEX; Schema: analytics; Owner: -
--

CREATE INDEX ix_fma_participant_date ON analytics.fact_mission_adherence USING btree (participant_key, date_key);


--
-- Name: mv_phase_snapshot_participant_key_phase_key_idx; Type: INDEX; Schema: analytics; Owner: -
--

CREATE UNIQUE INDEX mv_phase_snapshot_participant_key_phase_key_idx ON analytics.mv_phase_snapshot USING btree (participant_key, phase_key);


--
-- Name: anamneses_userId_phase_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "anamneses_userId_phase_idx" ON public.anamneses USING btree ("userId", phase);


--
-- Name: anthropometric_records_assessmentId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "anthropometric_records_assessmentId_key" ON public.anthropometric_records USING btree ("assessmentId");


--
-- Name: assessments_phase_assessedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "assessments_phase_assessedAt_idx" ON public.assessments USING btree (phase, "assessedAt");


--
-- Name: assessments_userId_phase_source_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "assessments_userId_phase_source_key" ON public.assessments USING btree ("userId", phase, source);


--
-- Name: clinical_exports_userId_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "clinical_exports_userId_createdAt_idx" ON public.clinical_exports USING btree ("userId", "createdAt");


--
-- Name: clinical_histories_userId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "clinical_histories_userId_key" ON public.clinical_histories USING btree ("userId");


--
-- Name: daily_check_ins_userId_date_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "daily_check_ins_userId_date_key" ON public.daily_check_ins USING btree ("userId", date);


--
-- Name: daily_missions_status_completedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "daily_missions_status_completedAt_idx" ON public.daily_missions USING btree (status, "completedAt");


--
-- Name: daily_plans_band_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX daily_plans_band_date_idx ON public.daily_plans USING btree (band, date);


--
-- Name: daily_plans_checkInId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "daily_plans_checkInId_key" ON public.daily_plans USING btree ("checkInId");


--
-- Name: daily_plans_userId_date_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "daily_plans_userId_date_key" ON public.daily_plans USING btree ("userId", date);


--
-- Name: dynamometry_tests_assessmentId_hand_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "dynamometry_tests_assessmentId_hand_key" ON public.dynamometry_tests USING btree ("assessmentId", hand);


--
-- Name: fms_pattern_scores_screenId_pattern_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "fms_pattern_scores_screenId_pattern_key" ON public.fms_pattern_scores USING btree ("screenId", pattern);


--
-- Name: fms_screens_assessmentId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "fms_screens_assessmentId_key" ON public.fms_screens USING btree ("assessmentId");


--
-- Name: guild_encouragements_guildId_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "guild_encouragements_guildId_createdAt_idx" ON public.guild_encouragements USING btree ("guildId", "createdAt");


--
-- Name: guild_memberships_guildId_userId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "guild_memberships_guildId_userId_key" ON public.guild_memberships USING btree ("guildId", "userId");


--
-- Name: guild_quest_contributions_questId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "guild_quest_contributions_questId_idx" ON public.guild_quest_contributions USING btree ("questId");


--
-- Name: guild_quests_guildId_endsAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "guild_quests_guildId_endsAt_idx" ON public.guild_quests USING btree ("guildId", "endsAt");


--
-- Name: guilds_type_setting_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX guilds_type_setting_idx ON public.guilds USING btree (type, setting);


--
-- Name: injury_records_userId_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "injury_records_userId_status_idx" ON public.injury_records USING btree ("userId", status);


--
-- Name: lore_entries_dailyMissionId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "lore_entries_dailyMissionId_key" ON public.lore_entries USING btree ("dailyMissionId");


--
-- Name: lore_entries_userId_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "lore_entries_userId_createdAt_idx" ON public.lore_entries USING btree ("userId", "createdAt");


--
-- Name: mission_templates_code_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX mission_templates_code_key ON public.mission_templates USING btree (code);


--
-- Name: passive_daily_summaries_metric_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX passive_daily_summaries_metric_date_idx ON public.passive_daily_summaries USING btree (metric, date);


--
-- Name: passive_daily_summaries_userId_date_metric_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "passive_daily_summaries_userId_date_metric_key" ON public.passive_daily_summaries USING btree ("userId", date, metric);


--
-- Name: perimeter_measurements_assessmentId_site_side_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "perimeter_measurements_assessmentId_site_side_key" ON public.perimeter_measurements USING btree ("assessmentId", site, side);


--
-- Name: player_profiles_setting_municipalityCode_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "player_profiles_setting_municipalityCode_idx" ON public.player_profiles USING btree (setting, "municipalityCode");


--
-- Name: player_profiles_userId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "player_profiles_userId_key" ON public.player_profiles USING btree ("userId");


--
-- Name: player_strengths_userId_strength_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "player_strengths_userId_strength_key" ON public.player_strengths USING btree ("userId", strength);


--
-- Name: profile_side_quests_userId_key_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "profile_side_quests_userId_key_key" ON public.profile_side_quests USING btree ("userId", key);


--
-- Name: questionnaire_administrations_userId_instrument_completedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "questionnaire_administrations_userId_instrument_completedAt_idx" ON public.questionnaire_administrations USING btree ("userId", instrument, "completedAt");


--
-- Name: red_flag_events_level_resolvedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "red_flag_events_level_resolvedAt_idx" ON public.red_flag_events USING btree (level, "resolvedAt");


--
-- Name: red_flag_events_userId_openedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "red_flag_events_userId_openedAt_idx" ON public.red_flag_events USING btree ("userId", "openedAt");


--
-- Name: reference_norms_measureCode_sex_ageMin_ageMax_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "reference_norms_measureCode_sex_ageMin_ageMax_idx" ON public.reference_norms USING btree ("measureCode", sex, "ageMin", "ageMax");


--
-- Name: research_consents_userId_scope_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "research_consents_userId_scope_idx" ON public.research_consents USING btree ("userId", scope);


--
-- Name: skill_progress_userId_capacity_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "skill_progress_userId_capacity_key" ON public.skill_progress USING btree ("userId", capacity);


--
-- Name: strength_tests_assessmentId_exercise_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "strength_tests_assessmentId_exercise_idx" ON public.strength_tests USING btree ("assessmentId", exercise);


--
-- Name: users_researchCode_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "users_researchCode_key" ON public.users USING btree ("researchCode");


--
-- Name: via_strength_scores_administrationId_strength_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "via_strength_scores_administrationId_strength_key" ON public.via_strength_scores USING btree ("administrationId", strength);


--
-- Name: wellbeing_index_snapshots_userId_date_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "wellbeing_index_snapshots_userId_date_key" ON public.wellbeing_index_snapshots USING btree ("userId", date);


--
-- Name: xp_events_userId_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "xp_events_userId_createdAt_idx" ON public.xp_events USING btree ("userId", "createdAt");


--
-- Name: dim_measure dim_measure_instrument_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.dim_measure
    ADD CONSTRAINT dim_measure_instrument_key_fkey FOREIGN KEY (instrument_key) REFERENCES analytics.dim_instrument(instrument_key);


--
-- Name: fact_assessment_measure fact_assessment_measure_date_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_assessment_measure
    ADD CONSTRAINT fact_assessment_measure_date_key_fkey FOREIGN KEY (date_key) REFERENCES analytics.dim_date(date_key);


--
-- Name: fact_assessment_measure fact_assessment_measure_measure_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_assessment_measure
    ADD CONSTRAINT fact_assessment_measure_measure_key_fkey FOREIGN KEY (measure_key) REFERENCES analytics.dim_measure(measure_key);


--
-- Name: fact_assessment_measure fact_assessment_measure_participant_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_assessment_measure
    ADD CONSTRAINT fact_assessment_measure_participant_key_fkey FOREIGN KEY (participant_key) REFERENCES analytics.dim_participant(participant_key);


--
-- Name: fact_assessment_measure fact_assessment_measure_phase_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_assessment_measure
    ADD CONSTRAINT fact_assessment_measure_phase_key_fkey FOREIGN KEY (phase_key) REFERENCES analytics.dim_phase(phase_key);


--
-- Name: fact_daily_wellbeing fact_daily_wellbeing_band_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_daily_wellbeing
    ADD CONSTRAINT fact_daily_wellbeing_band_key_fkey FOREIGN KEY (band_key) REFERENCES analytics.dim_readiness_band(band_key);


--
-- Name: fact_daily_wellbeing fact_daily_wellbeing_date_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_daily_wellbeing
    ADD CONSTRAINT fact_daily_wellbeing_date_key_fkey FOREIGN KEY (date_key) REFERENCES analytics.dim_date(date_key);


--
-- Name: fact_daily_wellbeing fact_daily_wellbeing_participant_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_daily_wellbeing
    ADD CONSTRAINT fact_daily_wellbeing_participant_key_fkey FOREIGN KEY (participant_key) REFERENCES analytics.dim_participant(participant_key);


--
-- Name: fact_guild_contribution fact_guild_contribution_date_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_guild_contribution
    ADD CONSTRAINT fact_guild_contribution_date_key_fkey FOREIGN KEY (date_key) REFERENCES analytics.dim_date(date_key);


--
-- Name: fact_guild_contribution fact_guild_contribution_guild_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_guild_contribution
    ADD CONSTRAINT fact_guild_contribution_guild_key_fkey FOREIGN KEY (guild_key) REFERENCES analytics.dim_guild(guild_key);


--
-- Name: fact_guild_contribution fact_guild_contribution_participant_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_guild_contribution
    ADD CONSTRAINT fact_guild_contribution_participant_key_fkey FOREIGN KEY (participant_key) REFERENCES analytics.dim_participant(participant_key);


--
-- Name: fact_lore_reflection fact_lore_reflection_date_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_lore_reflection
    ADD CONSTRAINT fact_lore_reflection_date_key_fkey FOREIGN KEY (date_key) REFERENCES analytics.dim_date(date_key);


--
-- Name: fact_lore_reflection fact_lore_reflection_participant_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_lore_reflection
    ADD CONSTRAINT fact_lore_reflection_participant_key_fkey FOREIGN KEY (participant_key) REFERENCES analytics.dim_participant(participant_key);


--
-- Name: fact_mission_adherence fact_mission_adherence_band_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_mission_adherence
    ADD CONSTRAINT fact_mission_adherence_band_key_fkey FOREIGN KEY (band_key) REFERENCES analytics.dim_readiness_band(band_key);


--
-- Name: fact_mission_adherence fact_mission_adherence_date_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_mission_adherence
    ADD CONSTRAINT fact_mission_adherence_date_key_fkey FOREIGN KEY (date_key) REFERENCES analytics.dim_date(date_key);


--
-- Name: fact_mission_adherence fact_mission_adherence_mission_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_mission_adherence
    ADD CONSTRAINT fact_mission_adherence_mission_key_fkey FOREIGN KEY (mission_key) REFERENCES analytics.dim_mission(mission_key);


--
-- Name: fact_mission_adherence fact_mission_adherence_participant_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_mission_adherence
    ADD CONSTRAINT fact_mission_adherence_participant_key_fkey FOREIGN KEY (participant_key) REFERENCES analytics.dim_participant(participant_key);


--
-- Name: fact_passive_daily fact_passive_daily_date_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_passive_daily
    ADD CONSTRAINT fact_passive_daily_date_key_fkey FOREIGN KEY (date_key) REFERENCES analytics.dim_date(date_key);


--
-- Name: fact_passive_daily fact_passive_daily_participant_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_passive_daily
    ADD CONSTRAINT fact_passive_daily_participant_key_fkey FOREIGN KEY (participant_key) REFERENCES analytics.dim_participant(participant_key);


--
-- Name: fact_red_flag_event fact_red_flag_event_date_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_red_flag_event
    ADD CONSTRAINT fact_red_flag_event_date_key_fkey FOREIGN KEY (date_key) REFERENCES analytics.dim_date(date_key);


--
-- Name: fact_red_flag_event fact_red_flag_event_participant_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_red_flag_event
    ADD CONSTRAINT fact_red_flag_event_participant_key_fkey FOREIGN KEY (participant_key) REFERENCES analytics.dim_participant(participant_key);


--
-- Name: fact_wellbeing_index fact_wellbeing_index_date_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_wellbeing_index
    ADD CONSTRAINT fact_wellbeing_index_date_key_fkey FOREIGN KEY (date_key) REFERENCES analytics.dim_date(date_key);


--
-- Name: fact_wellbeing_index fact_wellbeing_index_participant_key_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.fact_wellbeing_index
    ADD CONSTRAINT fact_wellbeing_index_participant_key_fkey FOREIGN KEY (participant_key) REFERENCES analytics.dim_participant(participant_key);


--
-- Name: map_questionnaire_measure map_questionnaire_measure_measure_code_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: -
--

ALTER TABLE ONLY analytics.map_questionnaire_measure
    ADD CONSTRAINT map_questionnaire_measure_measure_code_fkey FOREIGN KEY (measure_code) REFERENCES analytics.dim_measure(measure_code);


--
-- Name: anamneses anamneses_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anamneses
    ADD CONSTRAINT "anamneses_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: anthropometric_records anthropometric_records_assessmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.anthropometric_records
    ADD CONSTRAINT "anthropometric_records_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES public.assessments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: assessments assessments_evaluatorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT "assessments_evaluatorId_fkey" FOREIGN KEY ("evaluatorId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: assessments assessments_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessments
    ADD CONSTRAINT "assessments_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: clinical_exports clinical_exports_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clinical_exports
    ADD CONSTRAINT "clinical_exports_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: clinical_histories clinical_histories_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clinical_histories
    ADD CONSTRAINT "clinical_histories_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: daily_check_ins daily_check_ins_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_check_ins
    ADD CONSTRAINT "daily_check_ins_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: daily_missions daily_missions_planId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_missions
    ADD CONSTRAINT "daily_missions_planId_fkey" FOREIGN KEY ("planId") REFERENCES public.daily_plans(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: daily_missions daily_missions_templateId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_missions
    ADD CONSTRAINT "daily_missions_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES public.mission_templates(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: daily_plans daily_plans_checkInId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_plans
    ADD CONSTRAINT "daily_plans_checkInId_fkey" FOREIGN KEY ("checkInId") REFERENCES public.daily_check_ins(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: daily_plans daily_plans_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_plans
    ADD CONSTRAINT "daily_plans_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dynamometry_tests dynamometry_tests_assessmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dynamometry_tests
    ADD CONSTRAINT "dynamometry_tests_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES public.assessments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: flexibility_tests flexibility_tests_assessmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flexibility_tests
    ADD CONSTRAINT "flexibility_tests_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES public.assessments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fms_pattern_scores fms_pattern_scores_screenId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fms_pattern_scores
    ADD CONSTRAINT "fms_pattern_scores_screenId_fkey" FOREIGN KEY ("screenId") REFERENCES public.fms_screens(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fms_screens fms_screens_assessmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fms_screens
    ADD CONSTRAINT "fms_screens_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES public.assessments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: guild_encouragements guild_encouragements_guildId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_encouragements
    ADD CONSTRAINT "guild_encouragements_guildId_fkey" FOREIGN KEY ("guildId") REFERENCES public.guilds(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: guild_encouragements guild_encouragements_senderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_encouragements
    ADD CONSTRAINT "guild_encouragements_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: guild_memberships guild_memberships_guildId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_memberships
    ADD CONSTRAINT "guild_memberships_guildId_fkey" FOREIGN KEY ("guildId") REFERENCES public.guilds(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: guild_memberships guild_memberships_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_memberships
    ADD CONSTRAINT "guild_memberships_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: guild_quest_contributions guild_quest_contributions_membershipId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_quest_contributions
    ADD CONSTRAINT "guild_quest_contributions_membershipId_fkey" FOREIGN KEY ("membershipId") REFERENCES public.guild_memberships(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: guild_quest_contributions guild_quest_contributions_questId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_quest_contributions
    ADD CONSTRAINT "guild_quest_contributions_questId_fkey" FOREIGN KEY ("questId") REFERENCES public.guild_quests(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: guild_quests guild_quests_guildId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guild_quests
    ADD CONSTRAINT "guild_quests_guildId_fkey" FOREIGN KEY ("guildId") REFERENCES public.guilds(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: injury_records injury_records_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.injury_records
    ADD CONSTRAINT "injury_records_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lore_entries lore_entries_dailyMissionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lore_entries
    ADD CONSTRAINT "lore_entries_dailyMissionId_fkey" FOREIGN KEY ("dailyMissionId") REFERENCES public.daily_missions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: lore_entries lore_entries_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lore_entries
    ADD CONSTRAINT "lore_entries_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: passive_daily_summaries passive_daily_summaries_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passive_daily_summaries
    ADD CONSTRAINT "passive_daily_summaries_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: perimeter_measurements perimeter_measurements_assessmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.perimeter_measurements
    ADD CONSTRAINT "perimeter_measurements_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES public.assessments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: player_profiles player_profiles_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_profiles
    ADD CONSTRAINT "player_profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: player_strengths player_strengths_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.player_strengths
    ADD CONSTRAINT "player_strengths_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: profile_side_quests profile_side_quests_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profile_side_quests
    ADD CONSTRAINT "profile_side_quests_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: questionnaire_administrations questionnaire_administrations_assessmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaire_administrations
    ADD CONSTRAINT "questionnaire_administrations_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES public.assessments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: questionnaire_administrations questionnaire_administrations_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaire_administrations
    ADD CONSTRAINT "questionnaire_administrations_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: red_flag_events red_flag_events_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.red_flag_events
    ADD CONSTRAINT "red_flag_events_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: research_consents research_consents_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.research_consents
    ADD CONSTRAINT "research_consents_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: skill_progress skill_progress_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skill_progress
    ADD CONSTRAINT "skill_progress_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: strength_tests strength_tests_assessmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strength_tests
    ADD CONSTRAINT "strength_tests_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES public.assessments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: via_strength_scores via_strength_scores_administrationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.via_strength_scores
    ADD CONSTRAINT "via_strength_scores_administrationId_fkey" FOREIGN KEY ("administrationId") REFERENCES public.questionnaire_administrations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wellbeing_index_snapshots wellbeing_index_snapshots_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wellbeing_index_snapshots
    ADD CONSTRAINT "wellbeing_index_snapshots_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: xp_events xp_events_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xp_events
    ADD CONSTRAINT "xp_events_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mv_phase_snapshot; Type: MATERIALIZED VIEW DATA; Schema: analytics; Owner: -
--

REFRESH MATERIALIZED VIEW analytics.mv_phase_snapshot;


--
-- PostgreSQL database dump complete
--


