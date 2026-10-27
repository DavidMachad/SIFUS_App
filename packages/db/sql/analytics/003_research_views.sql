-- =============================================================================
-- SIFUS · Vistas para investigación y tableros de control
--
--  mv_phase_snapshot        Una fila por participante y fase: indicadores clave
--                           físicos, mentales, sociales y espirituales + la
--                           adherencia y el bienestar diario del periodo previo.
--  v_change_from_baseline   Cambio absoluto, relativo y estandarizado vs. base,
--                           orientado según la dirección de mejora de la medida.
--  v_adherence_by_band      Adherencia por ruta del día (¿el algoritmo protege
--                           la continuidad cuando hay vulnerabilidad?).
--  v_measure_reliability    Insumos para calibrar el MDC con datos propios.
-- =============================================================================

SET search_path = analytics;

-- Fecha de cada fase por participante (la de la medición más temprana).
CREATE OR REPLACE VIEW v_phase_window AS
WITH phase_dates AS (
  SELECT participant_key, phase_key, min(d.full_date) AS phase_date
  FROM fact_assessment_measure f JOIN dim_date d USING (date_key)
  GROUP BY participant_key, phase_key
)
SELECT pd.participant_key, pd.phase_key, ph.phase_code, ph.phase_order,
       lag(pd.phase_date) OVER w AS window_start,  -- exclusivo
       pd.phase_date              AS window_end     -- inclusivo
FROM phase_dates pd JOIN dim_phase ph USING (phase_key)
WINDOW w AS (PARTITION BY pd.participant_key ORDER BY ph.phase_order);

DROP MATERIALIZED VIEW IF EXISTS mv_phase_snapshot CASCADE;
CREATE MATERIALIZED VIEW mv_phase_snapshot AS
WITH m AS (
  SELECT f.participant_key, f.phase_key, dm.measure_code, f.value
  FROM fact_assessment_measure f JOIN dim_measure dm USING (measure_key)
  WHERE f.is_valid
),
pivot AS (
  SELECT participant_key, phase_key,
    max(value) FILTER (WHERE measure_code = 'WEIGHT_KG')            AS weight_kg,
    max(value) FILTER (WHERE measure_code = 'BMI')                  AS bmi,
    max(value) FILTER (WHERE measure_code = 'BODY_FAT_PCT')         AS body_fat_pct,
    max(value) FILTER (WHERE measure_code = 'PERIM_WAIST')          AS waist_cm,
    max(value) FILTER (WHERE measure_code = 'PERIM_HIP')            AS hip_cm,
    max(value) FILTER (WHERE measure_code = 'PERIM_ARM_FLEXED')     AS arm_flexed_cm,
    max(value) FILTER (WHERE measure_code = 'PERIM_THIGH')          AS thigh_cm,
    max(value) FILTER (WHERE measure_code = 'PERIM_CALF')           AS calf_cm,
    max(value) FILTER (WHERE measure_code = 'WAIST_HEIGHT_RATIO')   AS waist_height_ratio,
    max(value) FILTER (WHERE measure_code = 'FMS_TOTAL')            AS fms_total,
    max(value) FILTER (WHERE measure_code = 'GRIP_DOMINANT_KG')     AS grip_dominant_kg,
    max(value) FILTER (WHERE measure_code = 'GRIP_RELATIVE')        AS grip_relative,
    max(value) FILTER (WHERE measure_code = 'SIT_REACH_FOOTLINE_CM') AS sit_reach_cm,
    max(value) FILTER (WHERE measure_code = 'SQUAT_1RM_REL')        AS squat_1rm_rel,
    max(value) FILTER (WHERE measure_code = 'BENCH_1RM_REL')        AS bench_1rm_rel,
    max(value) FILTER (WHERE measure_code = 'PSS10_TOTAL')          AS pss10,
    max(value) FILTER (WHERE measure_code = 'GHQ12_GHQ')            AS ghq12,
    max(value) FILTER (WHERE measure_code = 'MSPSS_TOTAL')          AS mspss,
    max(value) FILTER (WHERE measure_code = 'SRPB_TOTAL')           AS srpb,
    max(value) FILTER (WHERE measure_code = 'SRPB_MEANING')         AS srpb_meaning,
    max(value) FILTER (WHERE measure_code = 'WHO5_PCT')             AS who5,
    max(value) FILTER (WHERE measure_code = 'PSQI_GLOBAL')          AS psqi,
    max(value) FILTER (WHERE measure_code = 'IPAQ_MET_MIN')         AS ipaq_met_min,
    max(value) FILTER (WHERE measure_code = 'MEDAS_NORMALIZED')     AS medas,
    max(value) FILTER (WHERE measure_code = 'FACIT_SP_TOTAL')       AS facit_sp,
    max(value) FILTER (WHERE measure_code = 'STEPS_MEAN')           AS steps_mean,
    max(value) FILTER (WHERE measure_code = 'RESTING_HR_MEAN')      AS resting_hr_mean,
    max(value) FILTER (WHERE measure_code = 'WELLBEING_INDEX_MEAN') AS wellbeing_index_mean
  FROM m GROUP BY participant_key, phase_key
)
SELECT p.*, dp.research_code, dp.setting, dp.age_group, dp.sex_for_reference, dp.cohort,
       w.phase_code, w.phase_order, w.window_start, w.window_end,
       -- Adherencia del periodo previo a la valoración.
       adh.missions_assigned, adh.missions_completed,
       round(adh.missions_completed::numeric / nullif(adh.missions_assigned, 0), 3) AS adherence_rate,
       adh.recovery_missions_completed,
       wb.days_checked_in, wb.mean_sleep_hours, wb.mean_daily_stress,
       round(wb.recovery_days::numeric / nullif(wb.days_checked_in, 0), 3) AS recovery_day_share,
       lo.lore_entries, lo.mean_coherence,
       gu.guild_contribution_total,
       rf.red_flag_events
FROM pivot p
JOIN dim_participant dp USING (participant_key)
JOIN v_phase_window w USING (participant_key, phase_key)
LEFT JOIN LATERAL (
  SELECT sum(assigned_count) AS missions_assigned, sum(completed_count) AS missions_completed,
         sum(completed_count) FILTER (WHERE mi.category IN ('RECOVERY','MINDFULNESS')) AS recovery_missions_completed
  FROM fact_mission_adherence a JOIN dim_date d USING (date_key) JOIN dim_mission mi USING (mission_key)
  WHERE a.participant_key = p.participant_key
    AND d.full_date > w.window_start AND d.full_date <= w.window_end
) adh ON true
LEFT JOIN LATERAL (
  SELECT count(*) AS days_checked_in, round(avg(sleep_hours), 2) AS mean_sleep_hours,
         round(avg(perceived_stress), 2) AS mean_daily_stress,
         count(*) FILTER (WHERE b.band_code = 'RECOVERY') AS recovery_days
  FROM fact_daily_wellbeing f JOIN dim_date d USING (date_key) LEFT JOIN dim_readiness_band b USING (band_key)
  WHERE f.participant_key = p.participant_key
    AND d.full_date > w.window_start AND d.full_date <= w.window_end
) wb ON true
LEFT JOIN LATERAL (
  SELECT count(*) AS lore_entries, round(avg(coherence_rating), 2) AS mean_coherence
  FROM fact_lore_reflection l JOIN dim_date d USING (date_key)
  WHERE l.participant_key = p.participant_key
    AND d.full_date > w.window_start AND d.full_date <= w.window_end
) lo ON true
LEFT JOIN LATERAL (
  SELECT sum(value) AS guild_contribution_total
  FROM fact_guild_contribution g JOIN dim_date d USING (date_key)
  WHERE g.participant_key = p.participant_key
    AND d.full_date > w.window_start AND d.full_date <= w.window_end
) gu ON true
LEFT JOIN LATERAL (
  SELECT count(*) AS red_flag_events
  FROM fact_red_flag_event r JOIN dim_date d USING (date_key)
  WHERE r.participant_key = p.participant_key AND r.level IN ('ELEVATED', 'CRISIS')
    AND d.full_date > w.window_start AND d.full_date <= w.window_end
) rf ON true;

CREATE UNIQUE INDEX ON mv_phase_snapshot (participant_key, phase_key);

-- Cambio respecto a la línea de base para TODAS las medidas.
--  oriented_change > 0 significa mejora según la dirección de la medida
--  (NULL para medidas sin dirección normativa como peso o IMC).
--  standardized_change = cambio / DE de la línea de base de la cohorte
--  (tamaño del efecto tipo d de Cohen para muestras relacionadas, aproximado).
CREATE OR REPLACE VIEW v_change_from_baseline AS
WITH base AS (
  SELECT f.participant_key, f.measure_key, f.value AS baseline_value
  FROM fact_assessment_measure f JOIN dim_phase ph USING (phase_key)
  WHERE ph.phase_code = 'BASELINE' AND f.is_valid
),
base_sd AS (
  SELECT measure_key, stddev_samp(baseline_value) AS sd FROM base GROUP BY measure_key
)
SELECT dp.research_code, dp.setting, dp.age_group, dp.sex_for_reference,
       dm.measure_code, dm.name_es, dm.unit, di.health_domain, dm.capacity,
       ph.phase_code, ph.phase_order,
       b.baseline_value, f.value AS phase_value,
       f.value - b.baseline_value AS abs_change,
       round(100 * (f.value - b.baseline_value) / nullif(b.baseline_value, 0), 2) AS pct_change,
       CASE WHEN dm.improvement_direction <> 0
            THEN dm.improvement_direction * (f.value - b.baseline_value) END AS oriented_change,
       round((f.value - b.baseline_value) / nullif(sd.sd, 0), 3) AS standardized_change,
       CASE WHEN dm.mdc IS NOT NULL THEN abs(f.value - b.baseline_value) >= dm.mdc END AS exceeds_mdc
FROM fact_assessment_measure f
JOIN base b USING (participant_key, measure_key)
JOIN base_sd sd USING (measure_key)
JOIN dim_participant dp USING (participant_key)
JOIN dim_measure dm USING (measure_key)
JOIN dim_instrument di USING (instrument_key)
JOIN dim_phase ph USING (phase_key)
WHERE f.is_valid AND ph.phase_code <> 'BASELINE';

-- ¿Cómo se sostiene la adherencia en cada ruta? Hipótesis del proyecto: ofrecer
-- recuperación en días vulnerables mantiene la continuidad en vez de cortarla.
CREATE OR REPLACE VIEW v_adherence_by_band AS
SELECT dp.setting, dp.age_group, b.band_code, mi.category,
       count(*) AS missions_assigned,
       sum(a.completed_count) AS missions_completed,
       round(avg(a.completed_count), 3) AS completion_rate,
       round(avg(a.adapted_count), 3) AS adaptation_rate,
       round(avg(a.reported_rpe), 2) AS mean_reported_rpe
FROM fact_mission_adherence a
JOIN dim_participant dp USING (participant_key)
JOIN dim_readiness_band b USING (band_key)
JOIN dim_mission mi USING (mission_key)
GROUP BY dp.setting, dp.age_group, b.band_code, mi.category;

-- Insumo para calibrar dim_measure.mdc: DE de la línea de base por medida.
-- Con el ICC de un test-retest propio:  SEM = DE·√(1−ICC);  MDC95 = 1.96·√2·SEM.
CREATE OR REPLACE VIEW v_measure_reliability AS
SELECT dm.measure_code, dm.unit, count(*) AS n_baseline,
       round(avg(f.value), 3) AS baseline_mean,
       round(stddev_samp(f.value), 3) AS baseline_sd,
       dm.mdc, dm.mdc_source
FROM fact_assessment_measure f
JOIN dim_measure dm USING (measure_key)
JOIN dim_phase ph USING (phase_key)
WHERE ph.phase_code = 'BASELINE' AND f.is_valid
GROUP BY dm.measure_code, dm.unit, dm.mdc, dm.mdc_source;

-- Monitoreo de seguridad para el comité de ética: activaciones por nivel y
-- tiempo hasta el primer contacto humano. Celdas pequeñas se suprimen en el tablero.
CREATE OR REPLACE VIEW v_safety_monitoring AS
SELECT d.year, d.month, dp.setting, r.level,
       count(*) AS events,
       round(avg(r.hours_to_professional_contact), 1) AS mean_hours_to_contact,
       round(percentile_cont(0.9) WITHIN GROUP (ORDER BY r.hours_to_professional_contact)::numeric, 1) AS p90_hours_to_contact,
       count(*) FILTER (WHERE r.hours_to_professional_contact IS NULL AND NOT r.resolved) AS open_without_contact
FROM fact_red_flag_event r
JOIN dim_date d USING (date_key)
JOIN dim_participant dp USING (participant_key)
GROUP BY d.year, d.month, dp.setting, r.level;

-- Rol de solo lectura para salubristas / herramientas de BI (Metabase, Power BI…).
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'sifus_researcher') THEN
    CREATE ROLE sifus_researcher NOLOGIN;
  END IF;
END $$;
GRANT USAGE ON SCHEMA analytics TO sifus_researcher;
GRANT SELECT ON ALL TABLES IN SCHEMA analytics TO sifus_researcher;
REVOKE ALL ON SCHEMA public FROM sifus_researcher;
