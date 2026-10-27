-- =============================================================================
-- SIFUS · ETL operacional (public) → estrella (analytics)
--
-- Estrategia: recarga completa e idempotente de los hechos. A la escala de un
-- estudio de cohorte (cientos a pocos miles de participantes) es más simple y
-- auditable que una carga incremental. Ejecutar:  CALL analytics.refresh_all();
--
-- Las llaves JSON de subscaleScores coinciden con la salida de
-- @sifus/core/src/instruments (fuente única de la lógica de puntuación).
-- =============================================================================

CREATE OR REPLACE PROCEDURE analytics.refresh_all()
LANGUAGE plpgsql AS $$
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
