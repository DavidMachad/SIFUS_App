-- Dosis-respuesta: terciles de adherencia a las misiones vs. cambio en la
-- cintura, la prensión y el sentido de vida (WHOQOL-SRPB) al mes 2.
WITH m2 AS (
  SELECT s.research_code, s.adherence_rate,
         ntile(3) OVER (ORDER BY s.adherence_rate) AS adherence_tercile
  FROM analytics.mv_phase_snapshot s
  WHERE s.phase_code = 'MONTH_2' AND s.adherence_rate IS NOT NULL
)
SELECT m2.adherence_tercile,
       round(min(m2.adherence_rate), 2) AS from_rate,
       round(max(m2.adherence_rate), 2) AS to_rate,
       round(avg(c.abs_change) FILTER (WHERE c.measure_code = 'PERIM_WAIST'), 2)      AS waist_change_cm,
       round(avg(c.abs_change) FILTER (WHERE c.measure_code = 'GRIP_DOMINANT_KG'), 2) AS grip_change_kg,
       round(avg(c.abs_change) FILTER (WHERE c.measure_code = 'SRPB_MEANING'), 2)     AS meaning_change,
       count(DISTINCT m2.research_code) AS n
FROM m2
JOIN analytics.v_change_from_baseline c ON c.research_code = m2.research_code AND c.phase_code = 'MONTH_2'
GROUP BY m2.adherence_tercile
ORDER BY 1;
