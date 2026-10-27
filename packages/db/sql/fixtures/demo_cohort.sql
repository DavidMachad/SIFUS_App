-- =============================================================================
-- Cohorte SINTÉTICA de demostración (no son datos reales). Sirve para probar el
-- ETL y prototipar tableros. 3 personas: 2 con consentimiento de investigación
-- y 1 que solo usa la app (debe quedar FUERA del esquema analytics).
-- =============================================================================
BEGIN;
INSERT INTO users (id, role, "researchCode", "updatedAt") VALUES
  ('u1', 'PARTICIPANT', 'SIFUS-DEMO-001', now()),
  ('u2', 'PARTICIPANT', 'SIFUS-DEMO-002', now()),
  ('u3', 'PARTICIPANT', 'SIFUS-DEMO-003', now()),
  ('ev', 'EVALUATOR',   'SIFUS-EVAL-01',  now());

INSERT INTO research_consents (id, "userId", scope, "documentVersion", "allowsPassiveData") VALUES
  ('c1', 'u1', 'RESEARCH_DEIDENTIFIED', 'CI-v1', true),
  ('c2', 'u2', 'RESEARCH_DEIDENTIFIED', 'CI-v1', false),
  ('c3', 'u3', 'APP_ONLY', 'CI-v1', true);

INSERT INTO player_profiles (id, "userId", "displayName", archetype, "birthYear", "sexForReference", setting, "municipalityCode", "spiritualOrientation", "onboardingCompletedAt", "updatedAt") VALUES
  ('p1', 'u1', 'Ceiba',  'GUARDIAN', 1990, 'FEMALE', 'WORKPLACE',   '05001', 'THEOLOGICAL', '2026-08-01', now()),
  ('p2', 'u2', 'Cóndor', 'EXPLORER', 2005, 'MALE',   'EDUCATIONAL', '05001', 'NATURE', '2026-08-01', now()),
  ('p3', 'u3', 'Río',    'SAGE',     1980, 'UNDISCLOSED', 'COMMUNITY', '05088', 'MINDFULNESS', '2026-08-01', now());

INSERT INTO anamneses (id, "userId", "sleepHoursNight", "perceivedStress", "trainingExperience", "weeklyFrequency", "avgSessionMinutes", "preferredModalities", "recordedAt") VALUES
  ('a1', 'u1', 5.5, 8, 'BEGINNER', 1, 30, '{FUNCTIONAL}', '2026-08-01'),
  ('a2', 'u2', 7.0, 5, 'INTERMEDIATE', 3, 45, '{CALISTHENICS,STRENGTH_TRAINING}', '2026-08-01'),
  ('a3', 'u3', 7.0, 3, 'NONE', 0, 20, '{WALKING}', '2026-08-01');

-- Valoraciones: base, mes 1, mes 2 (evaluador) + un autorreporte que NO debe contar.
INSERT INTO assessments (id, "userId", "evaluatorId", phase, source, "assessedAt", "protocolVersion") VALUES
  ('s1b', 'u1', 'ev', 'BASELINE', 'EVALUATOR', '2026-08-02', 'SIFUS-PROT-v1'),
  ('s1m1','u1', 'ev', 'MONTH_1',  'EVALUATOR', '2026-09-01', 'SIFUS-PROT-v1'),
  ('s1m2','u1', 'ev', 'MONTH_2',  'EVALUATOR', '2026-10-01', 'SIFUS-PROT-v1'),
  ('s1self','u1', NULL, 'BASELINE', 'SELF_REPORTED', '2026-08-01', 'SELF_REPORT'),
  ('s2b', 'u2', 'ev', 'BASELINE', 'EVALUATOR', '2026-08-02', 'SIFUS-PROT-v1'),
  ('s2m2','u2', 'ev', 'MONTH_2',  'EVALUATOR', '2026-10-01', 'SIFUS-PROT-v1'),
  ('s3b', 'u3', 'ev', 'BASELINE', 'EVALUATOR', '2026-08-02', 'SIFUS-PROT-v1');

INSERT INTO anthropometric_records (id, "assessmentId", "heightCm", "weightKg") VALUES
  ('ar1','s1b',160,72), ('ar2','s1m1',160,71.2), ('ar3','s1m2',160,70.1), ('ar4','s1self',162,68),
  ('ar5','s2b',178,70), ('ar6','s2m2',178,71.5), ('ar7','s3b',170,80);

INSERT INTO perimeter_measurements (id, "assessmentId", site, side, "trialsCm", "valueCm") VALUES
  ('pm1','s1b','WAIST','NOT_APPLICABLE','{88.0,88.4}',88.2), ('pm2','s1b','HIP','NOT_APPLICABLE','{104,104}',104),
  ('pm3','s1m1','WAIST','NOT_APPLICABLE','{86.9,87.1}',87.0), ('pm4','s1m1','HIP','NOT_APPLICABLE','{103.5,103.5}',103.5),
  ('pm5','s1m2','WAIST','NOT_APPLICABLE','{85.0,85.4}',85.2), ('pm6','s1m2','HIP','NOT_APPLICABLE','{103,103}',103),
  ('pm7','s1b','ARM_RELAXED','RIGHT','{29,29}',29), ('pm8','s1b','ARM_RELAXED','LEFT','{28.5,28.5}',28.5),
  ('pm9','s1self','WAIST','NOT_APPLICABLE','{80}',80),
  ('pm10','s2b','WAIST','NOT_APPLICABLE','{76,76}',76), ('pm11','s2m2','WAIST','NOT_APPLICABLE','{76.5,76.5}',76.5);

INSERT INTO dynamometry_tests (id, "assessmentId", hand, "isDominant", "trialsKg", "bestKg") VALUES
  ('d1','s1b','RIGHT',true,'{24,25,24.5}',25), ('d2','s1m2','RIGHT',true,'{28,29,28}',29),
  ('d3','s2b','RIGHT',true,'{42,43,42}',43),  ('d4','s2m2','RIGHT',true,'{45,46,45}',46);

INSERT INTO flexibility_tests (id, "assessmentId", "trialsCm", "bestCm", "footLineAtCm") VALUES
  ('f1','s1b','{20,21}',21,23), ('f2','s1m2','{25,26}',26,23);

INSERT INTO strength_tests (id, "assessmentId", exercise, protocol, "loadKg", reps, formula, "estimated1RmKg", "techniqueValid") VALUES
  ('st1','s2b','DEEP_SQUAT','ESTIMATED_FROM_SUBMAX',60,5,'BRZYCKI',67.5,true),
  ('st2','s2m2','DEEP_SQUAT','ESTIMATED_FROM_SUBMAX',70,5,'BRZYCKI',78.8,true),
  ('st3','s2m2','BENCH_PRESS','DIRECT_5RM',50,5,'BRZYCKI',56.3,false);

INSERT INTO fms_screens (id, "assessmentId", "totalScore", "hasAsymmetry", "hasPain", "scoringVersion") VALUES
  ('fm1','s1b',12,true,false,'fms@1.0.0'), ('fm2','s1m2',15,false,false,'fms@1.0.0');
INSERT INTO fms_pattern_scores (id, "screenId", pattern, "leftScore", "rightScore", "singleScore", "finalScore") VALUES
  ('fp1','fm1','HURDLE_STEP',2,1,NULL,1), ('fp2','fm1','DEEP_SQUAT',NULL,NULL,1,1);

INSERT INTO questionnaire_administrations (id, "userId", "assessmentId", phase, instrument, "instrumentVersion", "itemResponses", "totalScore", "subscaleScores", "scoringMethod", "scoringVersion", "completedAt") VALUES
  ('q1','u1','s1b',NULL,'PSS_10','PSS-10 es-CO','{}',29,NULL,'sum','pss10@1.0.0','2026-08-02'),
  ('q2','u1',NULL,'MONTH_1','PSS_10','PSS-10 es-CO','{}',24,NULL,'sum','pss10@1.0.0','2026-09-02'),
  ('q3','u1','s1m2',NULL,'PSS_10','PSS-10 es-CO','{}',19,NULL,'sum','pss10@1.0.0','2026-10-01'),
  ('q4','u1','s1b',NULL,'MSPSS','MSPSS es','{}',3.2,'{"family":4.5,"friends":2.25,"significantOther":2.75}','mean','mspss@1.0.0','2026-08-02'),
  ('q5','u1','s1m2',NULL,'MSPSS','MSPSS es','{}',4.6,'{"family":5,"friends":4.5,"significantOther":4.25}','mean','mspss@1.0.0','2026-10-01'),
  ('q6','u1','s1b',NULL,'GHQ_12','GHQ-12 es','{}',5,'{"likert":20}','GHQ','ghq12@1.0.0','2026-08-02'),
  ('q7','u1','s1b',NULL,'WHOQOL_SRPB','SRPB es','{}',13.5,'{"meaningAndPurpose":12,"hope":14}','facets','whoqol-srpb@1.0.0','2026-08-02'),
  ('q8','u1','s1m2',NULL,'WHOQOL_SRPB','SRPB es','{}',15.25,'{"meaningAndPurpose":16,"hope":16}','facets','whoqol-srpb@1.0.0','2026-10-01'),
  ('q9','u2','s2b',NULL,'PSS_10','PSS-10 es-CO','{}',15,NULL,'sum','pss10@1.0.0','2026-08-02'),
  ('q10','u2','s2m2',NULL,'PSS_10','PSS-10 es-CO','{}',16,NULL,'sum','pss10@1.0.0','2026-10-01'),
  ('q11','u2','s2b',NULL,'VIA_IS','VIA-72 es','{}',NULL,NULL,'VIA','via@1.0.0','2026-08-02'),
  ('q12','u3','s3b',NULL,'PSS_10','PSS-10 es-CO','{}',10,NULL,'sum','pss10@1.0.0','2026-08-02'),
  ('q13','u1','s1b',NULL,'WHO_5','WHO-5 es','{}',40,'{"raw":10}','x4','who5@1.0.0','2026-08-02'),
  ('q14','u1','s1m2',NULL,'WHO_5','WHO-5 es','{}',64,'{"raw":16}','x4','who5@1.0.0','2026-10-01'),
  ('q15','u1','s1b',NULL,'PSQI','PSQI es','{}',11,'{}','components','psqi@1.0.0','2026-08-02'),
  ('q16','u1','s1m2',NULL,'PSQI','PSQI es','{}',7,'{}','components','psqi@1.0.0','2026-10-01'),
  ('q17','u1','s1b',NULL,'FACIT_SP_12','FACIT-Sp-12 es','{}',30,'{"meaning":10,"peace":8,"faith":12}','sum','facit-sp-12@1.0.0','2026-08-02'),
  ('q18','u1','s1m2',NULL,'FACIT_SP_12','FACIT-Sp-12 es','{}',36,'{"meaning":12,"peace":11,"faith":13}','sum','facit-sp-12@1.0.0','2026-10-01'),
  ('q19','u1','s1b',NULL,'MEDAS','MEDAS-CO v0','{}',6,'{"maxScore":13,"normalized":46.2}','sum13','medas@1.0.0','2026-08-02'),
  ('q20','u1','s1m2',NULL,'MEDAS','MEDAS-CO v0','{}',8,'{"maxScore":13,"normalized":61.5}','sum13','medas@1.0.0','2026-10-01');
INSERT INTO via_strength_scores (id, "administrationId", strength, score, rank) VALUES
  ('v1','q11','CURIOSITY',4.6,1), ('v2','q11','TEAMWORK',4.4,2);

INSERT INTO mission_templates (id, code, title, description, category, intensity, "durationMinutes", "capacityXp", "loadedPatterns") VALUES
  ('mt1','REC_JOINT_MOBILITY_10','Ritual de articulaciones','-','RECOVERY','LIGHT',10,'{"MOBILITY":25}','{}'),
  ('mt2','STR_FULL_BODY_30','Forja exprés','-','STRENGTH','HIGH',30,'{"STRENGTH":30}','{DEEP_SQUAT}'),
  ('mt3','LORE_PURPOSE_CHECK_2','Bitácora','-','LORE','RESTORATIVE',2,'{}','{}');

-- 60 días de check-ins y planes para u1 y u2.
INSERT INTO daily_check_ins (id, "userId", date, "sleepHours", "perceivedStress", mood)
SELECT 'ci-' || u || '-' || g, u, date '2026-08-03' + g,
       CASE WHEN u = 'u1' THEN 5.5 + (g / 60.0) * 1.5 ELSE 7 END,
       CASE WHEN u = 'u1' THEN greatest(3, 8 - g / 12) ELSE 5 END, 3
FROM unnest(ARRAY['u1','u2']) u, generate_series(0, 59) g;

INSERT INTO daily_plans (id, "userId", date, "checkInId", band, "loadScore", "rpeCap", "blockedIntensities", "reasonCodes", "safetyFlags", "algorithmVersion", "inputSnapshot")
SELECT 'pl-' || c.id, c."userId", c.date, c.id,
       CASE WHEN c."perceivedStress" >= 8 THEN 'RECOVERY' WHEN c."perceivedStress" >= 6 THEN 'BALANCE' ELSE 'EXPANSION' END::"ReadinessBand",
       c."perceivedStress" / 2.0, 6, '{}', '{}', '{}', 'vulnerability-map@1.0.0', '{}'
FROM daily_check_ins c;

INSERT INTO daily_missions (id, "planId", "templateId", slot, status, "xpAwarded")
SELECT 'dm-' || p.id, p.id, CASE WHEN p.band = 'EXPANSION' THEN 'mt2' ELSE 'mt1' END, 'MAIN',
       (CASE WHEN extract(dow FROM p.date) IN (0, 6) THEN 'SKIPPED' ELSE 'COMPLETED' END)::"MissionStatus", 30
FROM daily_plans p;

INSERT INTO lore_entries (id, "userId", moment, "promptCode", "purposeTheme", "contentCiphertext", "hasGratitude", "coherenceRating", "strengthsUsed", "orientation", "createdAt")
SELECT 'lo-' || g, 'u1', 'AFTER_TRAINING', 'TH_GRA', 'FAMILY', 'v1.CIFRADO-DE-PRUEBA', g % 2 = 0, 3 + (g % 3), '{PERSEVERANCE}', 'THEOLOGICAL', date '2026-08-05' + g * 3
FROM generate_series(0, 18) g;

-- Datos pasivos de u1 (con consentimiento) y u3 (APP_ONLY: no debe llegar a analytics).
INSERT INTO passive_daily_summaries (id, "userId", date, metric, value, "sampleCount", platform, "deviceModel")
SELECT 'ps-' || u || '-' || m || '-' || g, u, date '2026-07-20' + g, m::"PassiveMetric",
       CASE m WHEN 'STEPS' THEN 4500 + g * 40 WHEN 'RESTING_HR_BPM' THEN 72 - g * 0.08 ELSE 330 + g * 1.2 END,
       CASE m WHEN 'STEPS' THEN 1 ELSE 24 END, 'APPLE_HEALTH', 'Watch7,1'
FROM unnest(ARRAY['u1','u3']) u, unnest(ARRAY['STEPS','RESTING_HR_BPM','SLEEP_ASLEEP_MIN']) m, generate_series(0, 75) g;

INSERT INTO wellbeing_index_snapshots (id, "userId", date, index, status, "mindScore", "bodyScore", "restorationScore", "lifestyleScore", "purposeScore", breakdown, confidence, "selfReportReliability", "consistencyFlags", version)
SELECT 'wi-' || g, 'u1', date '2026-07-25' + g, 45 + g / 4, 'OK', 40 + g / 3, 50, 35 + g / 3, 46 + g / 5, 60, '{}', 0.7, 1, '{}', 'wellbeing-index@1.0.0-provisional'
FROM generate_series(0, 70) g;

INSERT INTO red_flag_events (id, "userId", "openedAt", level, triggers, "gamificationMode", "protocolVersion", "careTeamNotifiedAt", "professionalContactAt", "resolvedAt", resolution)
VALUES ('rf1', 'u1', '2026-08-03 10:00', 'ELEVATED', '{PSS10_HIGH_WITH_DISTRESS}', 'PAUSED', 'red-flag@1.0.0-provisional',
        '2026-08-03 10:01', '2026-08-03 16:30', '2026-08-12 09:00', 'SUPPORTED_AND_STABLE');
COMMIT;
