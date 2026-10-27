-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('PARTICIPANT', 'EVALUATOR', 'RESEARCHER', 'ADMIN');

-- CreateEnum
CREATE TYPE "SexForReference" AS ENUM ('FEMALE', 'MALE', 'INTERSEX', 'UNDISCLOSED');

-- CreateEnum
CREATE TYPE "ImplementationSetting" AS ENUM ('EDUCATIONAL', 'WORKPLACE', 'COMMUNITY', 'HEALTHCARE');

-- CreateEnum
CREATE TYPE "ConsentScope" AS ENUM ('APP_ONLY', 'RESEARCH_DEIDENTIFIED');

-- CreateEnum
CREATE TYPE "SpiritualOrientation" AS ENUM ('THEOLOGICAL', 'MINDFULNESS', 'NATURE', 'SECULAR_PURPOSE');

-- CreateEnum
CREATE TYPE "SmokingStatus" AS ENUM ('NEVER', 'FORMER', 'CURRENT', 'UNDISCLOSED');

-- CreateEnum
CREATE TYPE "InjuryStatus" AS ENUM ('ACTIVE', 'RECOVERING', 'RESOLVED');

-- CreateEnum
CREATE TYPE "BodyRegion" AS ENUM ('NECK', 'SHOULDER', 'ELBOW', 'WRIST_HAND', 'UPPER_BACK', 'LOWER_BACK', 'HIP', 'KNEE', 'ANKLE_FOOT', 'OTHER');

-- CreateEnum
CREATE TYPE "PassiveMetric" AS ENUM ('HRV_RMSSD_MS', 'HRV_SDNN_MS', 'RESTING_HR_BPM', 'STEPS', 'SLEEP_ASLEEP_MIN', 'SLEEP_DEEP_MIN', 'SLEEP_REM_MIN', 'SLEEP_AWAKE_MIN', 'SLEEP_IN_BED_MIN');

-- CreateEnum
CREATE TYPE "PassivePlatform" AS ENUM ('APPLE_HEALTH', 'HEALTH_CONNECT', 'MANUAL_DEVICE');

-- CreateEnum
CREATE TYPE "RedFlagLevel" AS ENUM ('NONE', 'WATCH', 'ELEVATED', 'CRISIS');

-- CreateEnum
CREATE TYPE "GamificationMode" AS ENUM ('FULL', 'GENTLE', 'PAUSED');

-- CreateEnum
CREATE TYPE "ExportFormat" AS ENUM ('PDF_CLINICAL_REPORT', 'FHIR_R4_BUNDLE');

-- CreateEnum
CREATE TYPE "AvatarArchetype" AS ENUM ('EXPLORER', 'GUARDIAN', 'SAGE', 'ARTISAN', 'WAYFARER');

-- CreateEnum
CREATE TYPE "TrainingExperience" AS ENUM ('NONE', 'BEGINNER', 'INTERMEDIATE', 'ADVANCED');

-- CreateEnum
CREATE TYPE "TrainingModality" AS ENUM ('STRENGTH_TRAINING', 'CALISTHENICS', 'FUNCTIONAL', 'CARDIO_ENDURANCE', 'SPORTS', 'DANCE', 'YOGA_PILATES', 'WALKING', 'OTHER');

-- CreateEnum
CREATE TYPE "ProfileSideQuestKey" AS ENUM ('MEDICAL_CONDITIONS', 'MEDICATIONS', 'SURGICAL_HISTORY', 'INJURY_HISTORY', 'FOOD_AVERSIONS', 'HORMONAL_CONTRACEPTION', 'MENSTRUAL_CYCLE', 'BODY_COMPOSITION');

-- CreateEnum
CREATE TYPE "MeasurementSource" AS ENUM ('EVALUATOR', 'SELF_REPORTED');

-- CreateEnum
CREATE TYPE "AssessmentPhase" AS ENUM ('BASELINE', 'MONTH_1', 'MONTH_2', 'MONTH_3', 'MONTH_6', 'FOLLOW_UP');

-- CreateEnum
CREATE TYPE "PerimeterSite" AS ENUM ('CHEST', 'ARM_RELAXED', 'ARM_FLEXED_TENSED', 'WAIST', 'HIP', 'THIGH_MID', 'CALF_MAX');

-- CreateEnum
CREATE TYPE "BodySide" AS ENUM ('LEFT', 'RIGHT', 'NOT_APPLICABLE');

-- CreateEnum
CREATE TYPE "BodyFatMethod" AS ENUM ('BIA', 'SKINFOLDS', 'DXA', 'OTHER');

-- CreateEnum
CREATE TYPE "FmsPattern" AS ENUM ('DEEP_SQUAT', 'HURDLE_STEP', 'INLINE_LUNGE', 'SHOULDER_MOBILITY', 'ACTIVE_STRAIGHT_LEG_RAISE', 'TRUNK_STABILITY_PUSH_UP', 'ROTARY_STABILITY');

-- CreateEnum
CREATE TYPE "Hand" AS ENUM ('LEFT', 'RIGHT');

-- CreateEnum
CREATE TYPE "StrengthExercise" AS ENUM ('DEEP_SQUAT', 'BENCH_PRESS', 'DEADLIFT', 'OVERHEAD_PRESS', 'BENT_OVER_ROW', 'LEG_PRESS');

-- CreateEnum
CREATE TYPE "StrengthTestProtocol" AS ENUM ('DIRECT_1RM', 'DIRECT_5RM', 'ESTIMATED_FROM_SUBMAX');

-- CreateEnum
CREATE TYPE "OneRmFormula" AS ENUM ('BRZYCKI', 'EPLEY', 'LOMBARDI', 'NONE');

-- CreateEnum
CREATE TYPE "Instrument" AS ENUM ('PSS_10', 'VIA_IS', 'GHQ_12', 'MSPSS', 'WHOQOL_SRPB', 'PIL', 'WHO_5', 'I_PANAS_SF', 'IPAQ_SF', 'PSQI', 'AIS', 'MEDAS', 'FACIT_SP_12', 'SWBS', 'JAREL', 'SAFETY_SCREEN');

-- CreateEnum
CREATE TYPE "ViaStrength" AS ENUM ('CREATIVITY', 'CURIOSITY', 'JUDGMENT', 'LOVE_OF_LEARNING', 'PERSPECTIVE', 'BRAVERY', 'PERSEVERANCE', 'HONESTY', 'ZEST', 'LOVE', 'KINDNESS', 'SOCIAL_INTELLIGENCE', 'TEAMWORK', 'FAIRNESS', 'LEADERSHIP', 'FORGIVENESS', 'HUMILITY', 'PRUDENCE', 'SELF_REGULATION', 'APPRECIATION_OF_BEAUTY', 'GRATITUDE', 'HOPE', 'HUMOR', 'SPIRITUALITY');

-- CreateEnum
CREATE TYPE "FunctionalCapacity" AS ENUM ('STRENGTH', 'ENDURANCE', 'MOBILITY', 'BALANCE', 'COORDINATION', 'AGILITY', 'PROPRIOCEPTION');

-- CreateEnum
CREATE TYPE "ReadinessBand" AS ENUM ('RECOVERY', 'BALANCE', 'EXPANSION');

-- CreateEnum
CREATE TYPE "MissionIntensity" AS ENUM ('RESTORATIVE', 'LIGHT', 'MODERATE', 'HIGH');

-- CreateEnum
CREATE TYPE "MissionCategory" AS ENUM ('RECOVERY', 'MINDFULNESS', 'FUNCTIONAL', 'STRENGTH', 'CONDITIONING', 'COMMUNITY', 'LORE');

-- CreateEnum
CREATE TYPE "MissionSlot" AS ENUM ('MAIN', 'RECOVERY', 'COMMUNITY', 'LORE');

-- CreateEnum
CREATE TYPE "MissionStatus" AS ENUM ('ASSIGNED', 'IN_PROGRESS', 'COMPLETED', 'ADAPTED', 'SKIPPED');

-- CreateEnum
CREATE TYPE "XpSource" AS ENUM ('MISSION', 'CHECK_IN', 'ASSESSMENT_MILESTONE', 'LORE_ENTRY', 'GUILD_QUEST', 'SIDE_QUEST');

-- CreateEnum
CREATE TYPE "GuildType" AS ENUM ('EDUCATIONAL', 'WORKPLACE', 'COMMUNITY', 'SHARED_BARRIER');

-- CreateEnum
CREATE TYPE "GuildRole" AS ENUM ('MEMBER', 'MENTOR', 'FACILITATOR');

-- CreateEnum
CREATE TYPE "PurposeTheme" AS ENUM ('FAMILY', 'HEALING', 'STRESS_RELEASE', 'SELF_CARE', 'COMMUNITY', 'FAITH_SPIRITUALITY', 'AUTONOMY', 'OTHER');

-- CreateEnum
CREATE TYPE "LoreMoment" AS ENUM ('BEFORE_TRAINING', 'AFTER_TRAINING', 'FREE');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'PARTICIPANT',
    "researchCode" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "research_consents" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "scope" "ConsentScope" NOT NULL,
    "documentVersion" TEXT NOT NULL,
    "acceptedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revokedAt" TIMESTAMP(3),
    "guardianConsentAt" TIMESTAMP(3),
    "allowsCareTeamAlerts" BOOLEAN NOT NULL DEFAULT true,
    "allowsClinicalExport" BOOLEAN NOT NULL DEFAULT false,
    "allowsPassiveData" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "research_consents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "player_profiles" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "archetype" "AvatarArchetype" NOT NULL,
    "avatarConfig" JSONB NOT NULL DEFAULT '{}',
    "birthYear" INTEGER NOT NULL,
    "sexForReference" "SexForReference" NOT NULL DEFAULT 'UNDISCLOSED',
    "genderIdentity" TEXT,
    "setting" "ImplementationSetting" NOT NULL,
    "municipalityCode" VARCHAR(5),
    "purposeStatement" TEXT,
    "spiritualOrientation" "SpiritualOrientation" NOT NULL DEFAULT 'SECULAR_PURPOSE',
    "totalXp" INTEGER NOT NULL DEFAULT 0,
    "playerLevel" INTEGER NOT NULL DEFAULT 1,
    "coherenceStreak" INTEGER NOT NULL DEFAULT 0,
    "graceDaysAvailable" INTEGER NOT NULL DEFAULT 2,
    "onboardingCompletedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "player_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "anamneses" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "phase" "AssessmentPhase" NOT NULL DEFAULT 'BASELINE',
    "recordedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sleepHoursNight" DECIMAL(3,1) NOT NULL,
    "sleepQuality" INTEGER,
    "perceivedStress" INTEGER NOT NULL,
    "waterIntakeLiters" DECIMAL(3,1),
    "trainingExperience" "TrainingExperience" NOT NULL,
    "trainingMonths" INTEGER,
    "weeklyFrequency" INTEGER NOT NULL,
    "avgSessionMinutes" INTEGER NOT NULL,
    "preferredModalities" "TrainingModality"[],
    "perceivedBarriers" TEXT[],
    "smokingStatus" "SmokingStatus" NOT NULL DEFAULT 'UNDISCLOSED',
    "sittingHoursPerDay" DECIMAL(3,1),
    "screenMinutesBeforeBed" INTEGER,

    CONSTRAINT "anamneses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "clinical_histories" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "medicalConditions" TEXT[],
    "medications" TEXT[],
    "surgicalHistory" TEXT[],
    "notesCiphertext" TEXT,
    "foodAversions" TEXT[],
    "usesHormonalContraception" BOOLEAN,
    "requiresMedicalClearance" BOOLEAN NOT NULL DEFAULT false,
    "clearanceGrantedAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "clinical_histories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "injury_records" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "region" "BodyRegion" NOT NULL,
    "side" "BodySide" NOT NULL DEFAULT 'NOT_APPLICABLE',
    "status" "InjuryStatus" NOT NULL,
    "occurredYear" INTEGER,
    "hadSurgery" BOOLEAN NOT NULL DEFAULT false,
    "currentPain" INTEGER,
    "reportedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "injury_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profile_side_quests" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "key" "ProfileSideQuestKey" NOT NULL,
    "completedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "xpAwarded" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "profile_side_quests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "daily_check_ins" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "sleepHours" DECIMAL(3,1) NOT NULL,
    "sleepQuality" INTEGER,
    "perceivedStress" INTEGER NOT NULL,
    "mentalFatigue" INTEGER,
    "physicalFatigue" INTEGER,
    "painLevel" INTEGER,
    "painRegion" TEXT,
    "mood" INTEGER,
    "feelsIsolated" BOOLEAN,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "daily_check_ins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assessments" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "evaluatorId" TEXT,
    "phase" "AssessmentPhase" NOT NULL,
    "assessedAt" TIMESTAMP(3) NOT NULL,
    "location" TEXT,
    "source" "MeasurementSource" NOT NULL DEFAULT 'EVALUATOR',
    "protocolVersion" TEXT NOT NULL,
    "conditions" JSONB NOT NULL DEFAULT '{}',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "assessments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "anthropometric_records" (
    "id" TEXT NOT NULL,
    "assessmentId" TEXT NOT NULL,
    "heightCm" DECIMAL(5,1) NOT NULL,
    "weightKg" DECIMAL(5,2) NOT NULL,
    "bodyFatPct" DECIMAL(4,1),
    "bodyFatMethod" "BodyFatMethod",
    "equationName" TEXT,

    CONSTRAINT "anthropometric_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "perimeter_measurements" (
    "id" TEXT NOT NULL,
    "assessmentId" TEXT NOT NULL,
    "site" "PerimeterSite" NOT NULL,
    "side" "BodySide" NOT NULL DEFAULT 'NOT_APPLICABLE',
    "trialsCm" DECIMAL(5,1)[],
    "valueCm" DECIMAL(5,1) NOT NULL,

    CONSTRAINT "perimeter_measurements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fms_screens" (
    "id" TEXT NOT NULL,
    "assessmentId" TEXT NOT NULL,
    "totalScore" INTEGER NOT NULL,
    "hasAsymmetry" BOOLEAN NOT NULL,
    "hasPain" BOOLEAN NOT NULL,
    "scoringVersion" TEXT NOT NULL,

    CONSTRAINT "fms_screens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fms_pattern_scores" (
    "id" TEXT NOT NULL,
    "screenId" TEXT NOT NULL,
    "pattern" "FmsPattern" NOT NULL,
    "leftScore" INTEGER,
    "rightScore" INTEGER,
    "singleScore" INTEGER,
    "clearingTestPain" BOOLEAN NOT NULL DEFAULT false,
    "finalScore" INTEGER NOT NULL,

    CONSTRAINT "fms_pattern_scores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dynamometry_tests" (
    "id" TEXT NOT NULL,
    "assessmentId" TEXT NOT NULL,
    "hand" "Hand" NOT NULL,
    "isDominant" BOOLEAN NOT NULL,
    "trialsKg" DECIMAL(4,1)[],
    "bestKg" DECIMAL(4,1) NOT NULL,
    "device" TEXT,
    "protocol" TEXT NOT NULL DEFAULT 'Southampton',

    CONSTRAINT "dynamometry_tests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "flexibility_tests" (
    "id" TEXT NOT NULL,
    "assessmentId" TEXT NOT NULL,
    "testName" TEXT NOT NULL DEFAULT 'WELLS_DILLON',
    "trialsCm" DECIMAL(4,1)[],
    "bestCm" DECIMAL(4,1) NOT NULL,
    "footLineAtCm" DECIMAL(4,1) NOT NULL,

    CONSTRAINT "flexibility_tests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "strength_tests" (
    "id" TEXT NOT NULL,
    "assessmentId" TEXT NOT NULL,
    "exercise" "StrengthExercise" NOT NULL,
    "protocol" "StrengthTestProtocol" NOT NULL,
    "loadKg" DECIMAL(5,1) NOT NULL,
    "reps" INTEGER NOT NULL,
    "formula" "OneRmFormula" NOT NULL DEFAULT 'NONE',
    "estimated1RmKg" DECIMAL(5,1) NOT NULL,
    "rpe" DECIMAL(3,1),
    "techniqueValid" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "strength_tests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "questionnaire_administrations" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "assessmentId" TEXT,
    "phase" "AssessmentPhase",
    "instrument" "Instrument" NOT NULL,
    "instrumentVersion" TEXT NOT NULL,
    "language" TEXT NOT NULL DEFAULT 'es-CO',
    "itemResponses" JSONB NOT NULL,
    "totalScore" DECIMAL(6,2),
    "subscaleScores" JSONB,
    "scoringMethod" TEXT NOT NULL,
    "scoringVersion" TEXT NOT NULL,
    "startedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "questionnaire_administrations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "via_strength_scores" (
    "id" TEXT NOT NULL,
    "administrationId" TEXT NOT NULL,
    "strength" "ViaStrength" NOT NULL,
    "score" DECIMAL(3,2) NOT NULL,
    "rank" INTEGER NOT NULL,

    CONSTRAINT "via_strength_scores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "player_strengths" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "strength" "ViaStrength" NOT NULL,
    "fromVia" BOOLEAN NOT NULL DEFAULT false,
    "equippedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "player_strengths_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "skill_progress" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "capacity" "FunctionalCapacity" NOT NULL,
    "xp" INTEGER NOT NULL DEFAULT 0,
    "level" INTEGER NOT NULL DEFAULT 1,
    "evaluatedMilestones" INTEGER NOT NULL DEFAULT 0,
    "lastMilestoneAt" TIMESTAMP(3),

    CONSTRAINT "skill_progress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "xp_events" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "source" "XpSource" NOT NULL,
    "sourceId" TEXT,
    "capacity" "FunctionalCapacity",
    "amount" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "xp_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mission_templates" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "category" "MissionCategory" NOT NULL,
    "intensity" "MissionIntensity" NOT NULL,
    "durationMinutes" INTEGER NOT NULL,
    "capacityXp" JSONB NOT NULL,
    "loadedPatterns" "FmsPattern"[],
    "minAgeYears" INTEGER,
    "maxAgeYears" INTEGER,
    "contraindications" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "version" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "mission_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "daily_plans" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "checkInId" TEXT,
    "band" "ReadinessBand" NOT NULL,
    "loadScore" DECIMAL(4,1) NOT NULL,
    "rpeCap" INTEGER NOT NULL,
    "blockedIntensities" "MissionIntensity"[],
    "reasonCodes" TEXT[],
    "safetyFlags" TEXT[],
    "algorithmVersion" TEXT NOT NULL,
    "inputSnapshot" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "daily_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "daily_missions" (
    "id" TEXT NOT NULL,
    "planId" TEXT NOT NULL,
    "templateId" TEXT NOT NULL,
    "slot" "MissionSlot" NOT NULL,
    "status" "MissionStatus" NOT NULL DEFAULT 'ASSIGNED',
    "startedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "reportedRpe" INTEGER,
    "actualMinutes" INTEGER,
    "xpAwarded" INTEGER NOT NULL DEFAULT 0,
    "adaptationNote" TEXT,

    CONSTRAINT "daily_missions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lore_entries" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "dailyMissionId" TEXT,
    "moment" "LoreMoment" NOT NULL,
    "promptCode" TEXT NOT NULL,
    "purposeTheme" "PurposeTheme" NOT NULL,
    "contentCiphertext" TEXT,
    "hasGratitude" BOOLEAN NOT NULL DEFAULT false,
    "achievementRef" TEXT,
    "orientation" "SpiritualOrientation",
    "coherenceRating" INTEGER NOT NULL,
    "strengthsUsed" "ViaStrength"[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lore_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "guilds" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "GuildType" NOT NULL,
    "setting" "ImplementationSetting" NOT NULL,
    "description" TEXT,
    "anonymousByDefault" BOOLEAN NOT NULL DEFAULT false,
    "municipalityCode" VARCHAR(5),
    "maxMembers" INTEGER NOT NULL DEFAULT 12,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "guilds_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "guild_memberships" (
    "id" TEXT NOT NULL,
    "guildId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "role" "GuildRole" NOT NULL DEFAULT 'MEMBER',
    "matchSnapshot" JSONB,
    "alias" TEXT,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "leftAt" TIMESTAMP(3),

    CONSTRAINT "guild_memberships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "guild_quests" (
    "id" TEXT NOT NULL,
    "guildId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "metric" TEXT NOT NULL,
    "targetValue" INTEGER NOT NULL,
    "startsAt" TIMESTAMP(3) NOT NULL,
    "endsAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "guild_quests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "guild_quest_contributions" (
    "id" TEXT NOT NULL,
    "questId" TEXT NOT NULL,
    "membershipId" TEXT NOT NULL,
    "value" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "guild_quest_contributions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "guild_encouragements" (
    "id" TEXT NOT NULL,
    "guildId" TEXT NOT NULL,
    "senderId" TEXT NOT NULL,
    "recipientId" TEXT,
    "messageCode" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "guild_encouragements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "passive_daily_summaries" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "metric" "PassiveMetric" NOT NULL,
    "value" DECIMAL(8,2) NOT NULL,
    "sampleCount" INTEGER NOT NULL,
    "platform" "PassivePlatform" NOT NULL,
    "deviceModel" TEXT,
    "syncedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "passive_daily_summaries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wellbeing_index_snapshots" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "index" INTEGER,
    "status" TEXT NOT NULL,
    "mindScore" DECIMAL(4,1),
    "bodyScore" DECIMAL(4,1),
    "restorationScore" DECIMAL(4,1),
    "lifestyleScore" DECIMAL(4,1),
    "purposeScore" DECIMAL(4,1),
    "breakdown" JSONB NOT NULL,
    "confidence" DECIMAL(3,2) NOT NULL,
    "selfReportReliability" DECIMAL(3,2) NOT NULL,
    "consistencyFlags" TEXT[],
    "version" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "wellbeing_index_snapshots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "red_flag_events" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "openedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "level" "RedFlagLevel" NOT NULL,
    "triggers" TEXT[],
    "gamificationMode" "GamificationMode" NOT NULL,
    "protocolVersion" TEXT NOT NULL,
    "careTeamNotifiedAt" TIMESTAMP(3),
    "professionalContactAt" TIMESTAMP(3),
    "followUpNotesCiphertext" TEXT,
    "resolvedAt" TIMESTAMP(3),
    "resolution" TEXT,

    CONSTRAINT "red_flag_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reference_norms" (
    "id" TEXT NOT NULL,
    "measureCode" TEXT NOT NULL,
    "sex" TEXT NOT NULL,
    "ageMin" INTEGER NOT NULL,
    "ageMax" INTEGER NOT NULL,
    "method" JSONB NOT NULL,
    "citation" TEXT NOT NULL,
    "population" TEXT NOT NULL,
    "loadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reference_norms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "clinical_exports" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "format" "ExportFormat" NOT NULL,
    "requestedBy" TEXT NOT NULL,
    "recipient" TEXT,
    "periodFrom" DATE NOT NULL,
    "periodTo" DATE NOT NULL,
    "sha256" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "clinical_exports_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_researchCode_key" ON "users"("researchCode");

-- CreateIndex
CREATE INDEX "research_consents_userId_scope_idx" ON "research_consents"("userId", "scope");

-- CreateIndex
CREATE UNIQUE INDEX "player_profiles_userId_key" ON "player_profiles"("userId");

-- CreateIndex
CREATE INDEX "player_profiles_setting_municipalityCode_idx" ON "player_profiles"("setting", "municipalityCode");

-- CreateIndex
CREATE INDEX "anamneses_userId_phase_idx" ON "anamneses"("userId", "phase");

-- CreateIndex
CREATE UNIQUE INDEX "clinical_histories_userId_key" ON "clinical_histories"("userId");

-- CreateIndex
CREATE INDEX "injury_records_userId_status_idx" ON "injury_records"("userId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "profile_side_quests_userId_key_key" ON "profile_side_quests"("userId", "key");

-- CreateIndex
CREATE UNIQUE INDEX "daily_check_ins_userId_date_key" ON "daily_check_ins"("userId", "date");

-- CreateIndex
CREATE INDEX "assessments_phase_assessedAt_idx" ON "assessments"("phase", "assessedAt");

-- CreateIndex
CREATE UNIQUE INDEX "assessments_userId_phase_source_key" ON "assessments"("userId", "phase", "source");

-- CreateIndex
CREATE UNIQUE INDEX "anthropometric_records_assessmentId_key" ON "anthropometric_records"("assessmentId");

-- CreateIndex
CREATE UNIQUE INDEX "perimeter_measurements_assessmentId_site_side_key" ON "perimeter_measurements"("assessmentId", "site", "side");

-- CreateIndex
CREATE UNIQUE INDEX "fms_screens_assessmentId_key" ON "fms_screens"("assessmentId");

-- CreateIndex
CREATE UNIQUE INDEX "fms_pattern_scores_screenId_pattern_key" ON "fms_pattern_scores"("screenId", "pattern");

-- CreateIndex
CREATE UNIQUE INDEX "dynamometry_tests_assessmentId_hand_key" ON "dynamometry_tests"("assessmentId", "hand");

-- CreateIndex
CREATE INDEX "strength_tests_assessmentId_exercise_idx" ON "strength_tests"("assessmentId", "exercise");

-- CreateIndex
CREATE INDEX "questionnaire_administrations_userId_instrument_completedAt_idx" ON "questionnaire_administrations"("userId", "instrument", "completedAt");

-- CreateIndex
CREATE UNIQUE INDEX "via_strength_scores_administrationId_strength_key" ON "via_strength_scores"("administrationId", "strength");

-- CreateIndex
CREATE UNIQUE INDEX "player_strengths_userId_strength_key" ON "player_strengths"("userId", "strength");

-- CreateIndex
CREATE UNIQUE INDEX "skill_progress_userId_capacity_key" ON "skill_progress"("userId", "capacity");

-- CreateIndex
CREATE INDEX "xp_events_userId_createdAt_idx" ON "xp_events"("userId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "mission_templates_code_key" ON "mission_templates"("code");

-- CreateIndex
CREATE UNIQUE INDEX "daily_plans_checkInId_key" ON "daily_plans"("checkInId");

-- CreateIndex
CREATE INDEX "daily_plans_band_date_idx" ON "daily_plans"("band", "date");

-- CreateIndex
CREATE UNIQUE INDEX "daily_plans_userId_date_key" ON "daily_plans"("userId", "date");

-- CreateIndex
CREATE INDEX "daily_missions_status_completedAt_idx" ON "daily_missions"("status", "completedAt");

-- CreateIndex
CREATE UNIQUE INDEX "lore_entries_dailyMissionId_key" ON "lore_entries"("dailyMissionId");

-- CreateIndex
CREATE INDEX "lore_entries_userId_createdAt_idx" ON "lore_entries"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "guilds_type_setting_idx" ON "guilds"("type", "setting");

-- CreateIndex
CREATE UNIQUE INDEX "guild_memberships_guildId_userId_key" ON "guild_memberships"("guildId", "userId");

-- CreateIndex
CREATE INDEX "guild_quests_guildId_endsAt_idx" ON "guild_quests"("guildId", "endsAt");

-- CreateIndex
CREATE INDEX "guild_quest_contributions_questId_idx" ON "guild_quest_contributions"("questId");

-- CreateIndex
CREATE INDEX "guild_encouragements_guildId_createdAt_idx" ON "guild_encouragements"("guildId", "createdAt");

-- CreateIndex
CREATE INDEX "passive_daily_summaries_metric_date_idx" ON "passive_daily_summaries"("metric", "date");

-- CreateIndex
CREATE UNIQUE INDEX "passive_daily_summaries_userId_date_metric_key" ON "passive_daily_summaries"("userId", "date", "metric");

-- CreateIndex
CREATE UNIQUE INDEX "wellbeing_index_snapshots_userId_date_key" ON "wellbeing_index_snapshots"("userId", "date");

-- CreateIndex
CREATE INDEX "red_flag_events_level_resolvedAt_idx" ON "red_flag_events"("level", "resolvedAt");

-- CreateIndex
CREATE INDEX "red_flag_events_userId_openedAt_idx" ON "red_flag_events"("userId", "openedAt");

-- CreateIndex
CREATE INDEX "reference_norms_measureCode_sex_ageMin_ageMax_idx" ON "reference_norms"("measureCode", "sex", "ageMin", "ageMax");

-- CreateIndex
CREATE INDEX "clinical_exports_userId_createdAt_idx" ON "clinical_exports"("userId", "createdAt");

-- AddForeignKey
ALTER TABLE "research_consents" ADD CONSTRAINT "research_consents_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "player_profiles" ADD CONSTRAINT "player_profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anamneses" ADD CONSTRAINT "anamneses_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "clinical_histories" ADD CONSTRAINT "clinical_histories_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "injury_records" ADD CONSTRAINT "injury_records_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profile_side_quests" ADD CONSTRAINT "profile_side_quests_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "daily_check_ins" ADD CONSTRAINT "daily_check_ins_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assessments" ADD CONSTRAINT "assessments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assessments" ADD CONSTRAINT "assessments_evaluatorId_fkey" FOREIGN KEY ("evaluatorId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anthropometric_records" ADD CONSTRAINT "anthropometric_records_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES "assessments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "perimeter_measurements" ADD CONSTRAINT "perimeter_measurements_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES "assessments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fms_screens" ADD CONSTRAINT "fms_screens_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES "assessments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fms_pattern_scores" ADD CONSTRAINT "fms_pattern_scores_screenId_fkey" FOREIGN KEY ("screenId") REFERENCES "fms_screens"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dynamometry_tests" ADD CONSTRAINT "dynamometry_tests_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES "assessments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "flexibility_tests" ADD CONSTRAINT "flexibility_tests_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES "assessments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "strength_tests" ADD CONSTRAINT "strength_tests_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES "assessments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "questionnaire_administrations" ADD CONSTRAINT "questionnaire_administrations_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "questionnaire_administrations" ADD CONSTRAINT "questionnaire_administrations_assessmentId_fkey" FOREIGN KEY ("assessmentId") REFERENCES "assessments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "via_strength_scores" ADD CONSTRAINT "via_strength_scores_administrationId_fkey" FOREIGN KEY ("administrationId") REFERENCES "questionnaire_administrations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "player_strengths" ADD CONSTRAINT "player_strengths_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "skill_progress" ADD CONSTRAINT "skill_progress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "xp_events" ADD CONSTRAINT "xp_events_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "daily_plans" ADD CONSTRAINT "daily_plans_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "daily_plans" ADD CONSTRAINT "daily_plans_checkInId_fkey" FOREIGN KEY ("checkInId") REFERENCES "daily_check_ins"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "daily_missions" ADD CONSTRAINT "daily_missions_planId_fkey" FOREIGN KEY ("planId") REFERENCES "daily_plans"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "daily_missions" ADD CONSTRAINT "daily_missions_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "mission_templates"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lore_entries" ADD CONSTRAINT "lore_entries_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lore_entries" ADD CONSTRAINT "lore_entries_dailyMissionId_fkey" FOREIGN KEY ("dailyMissionId") REFERENCES "daily_missions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "guild_memberships" ADD CONSTRAINT "guild_memberships_guildId_fkey" FOREIGN KEY ("guildId") REFERENCES "guilds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "guild_memberships" ADD CONSTRAINT "guild_memberships_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "guild_quests" ADD CONSTRAINT "guild_quests_guildId_fkey" FOREIGN KEY ("guildId") REFERENCES "guilds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "guild_quest_contributions" ADD CONSTRAINT "guild_quest_contributions_questId_fkey" FOREIGN KEY ("questId") REFERENCES "guild_quests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "guild_quest_contributions" ADD CONSTRAINT "guild_quest_contributions_membershipId_fkey" FOREIGN KEY ("membershipId") REFERENCES "guild_memberships"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "guild_encouragements" ADD CONSTRAINT "guild_encouragements_guildId_fkey" FOREIGN KEY ("guildId") REFERENCES "guilds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "guild_encouragements" ADD CONSTRAINT "guild_encouragements_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "passive_daily_summaries" ADD CONSTRAINT "passive_daily_summaries_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wellbeing_index_snapshots" ADD CONSTRAINT "wellbeing_index_snapshots_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "red_flag_events" ADD CONSTRAINT "red_flag_events_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "clinical_exports" ADD CONSTRAINT "clinical_exports_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
