-- ¿Se asocia la mejora en fuerza de prensión con la disminución del estrés
-- percibido (PSS-10) entre la línea de base y el mes 2? Por entorno.
SELECT g.setting,
       count(*)                                         AS n,
       round(avg(g.abs_change), 2)                      AS mean_grip_change_kg,
       round(avg(p.oriented_change), 2)                 AS mean_pss10_improvement,
       round(corr(g.abs_change, p.oriented_change)::numeric, 3) AS pearson_r
FROM analytics.v_change_from_baseline g
JOIN analytics.v_change_from_baseline p
  ON p.research_code = g.research_code AND p.phase_code = g.phase_code
WHERE g.measure_code = 'GRIP_DOMINANT_KG'
  AND p.measure_code = 'PSS10_TOTAL'
  AND g.phase_code = 'MONTH_2'
GROUP BY g.setting
HAVING count(*) >= 5;  -- supresión de celdas pequeñas
