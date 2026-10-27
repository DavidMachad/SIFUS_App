/**
 * Prueba de integración contra PostgreSQL real (dos bases: salud e identidad).
 * Se omite si no hay DATABASE_URL e IDENTITY_DATABASE_URL.
 */
import { randomBytes } from 'node:crypto';
import { PrismaClient } from '@prisma/client';
import { PrismaClient as IdentityClient } from '@sifus/identity-client';
import { MISSION_CATALOG } from '@sifus/core';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { ClinicalExportService } from '../src/modules/clinical-export/clinicalExport.service';
import { DailyPlanService } from '../src/modules/daily-plan/dailyPlan.service';
import { IdentityVaultService } from '../src/modules/identity/identityVault.service';
import { PassiveDataService, type DeviceDailySummary } from '../src/modules/passive/passive.service';
import { RedFlagService, type CareTeamNotifier } from '../src/modules/safety/redFlag.service';
import { WellbeingService } from '../src/modules/wellbeing/wellbeing.service';
import { FieldCipher, LocalDevKekProvider } from '../src/security/fieldEncryption';
import { addDays, isoDay } from '../src/shared/dates';

const enabled = Boolean(process.env.DATABASE_URL && process.env.IDENTITY_DATABASE_URL);

describe.skipIf(!enabled)('Flujo completo SIFUS (integración)', () => {
  const db = new PrismaClient();
  const vaultDb = new IdentityClient();
  const cipher = new FieldCipher(new LocalDevKekProvider(new Map([[1, randomBytes(32)]]), 1));
  const vault = new IdentityVaultService(vaultDb, cipher, randomBytes(32));
  const notified: string[] = [];
  const notifier: CareTeamNotifier = { notify: async (e) => void notified.push(`${e.level}:${e.eventId}`) };
  const passive = new PassiveDataService(db);
  const safety = new RedFlagService(db, notifier, cipher);
  const plans = new DailyPlanService(db, passive, safety);
  const wellbeing = new WellbeingService(db, passive);
  const exporter = new ClinicalExportService(db, vault, { GRIP_DOMINANT_KG: 3, PSS10_TOTAL: 4 });
  const TODAY = '2026-10-27';
  let subjectId = '';

  beforeAll(async () => {
    for (const m of MISSION_CATALOG) {
      const data = { title: m.title, description: m.description, category: m.category, intensity: m.intensity, durationMinutes: m.durationMinutes, capacityXp: m.capacityXp, loadedPatterns: m.loadedPatterns };
      await db.missionTemplate.upsert({ where: { code: m.code }, create: { code: m.code, ...data }, update: data });
    }
    // 1. Alta: la PII va a la bóveda; la base de salud solo recibe el UUID.
    subjectId = await vault.register({ email: `persona.${Date.now()}@udea.edu.co`, fullName: 'Persona de Prueba', birthDate: '1994-05-12', documentType: 'CC', documentNumber: `${Date.now()}` });
    await db.user.create({ data: { id: subjectId, researchCode: `SIFUS-IT-${Date.now()}` } });
    await db.researchConsent.create({ data: { userId: subjectId, scope: 'RESEARCH_DEIDENTIFIED', documentVersion: 'CI-v2', allowsPassiveData: true, allowsClinicalExport: true } });
    await db.playerProfile.create({ data: { userId: subjectId, displayName: 'Ceiba', archetype: 'GUARDIAN', birthYear: 1994, sexForReference: 'FEMALE', setting: 'WORKPLACE', spiritualOrientation: 'THEOLOGICAL', onboardingCompletedAt: new Date('2026-08-01') } });
    await db.anamnesis.create({ data: { userId: subjectId, sleepHoursNight: 7, perceivedStress: 4, trainingExperience: 'INTERMEDIATE', weeklyFrequency: 3, avgSessionMinutes: 45 } });
    await db.injuryRecord.create({ data: { userId: subjectId, region: 'KNEE', side: 'RIGHT', status: 'ACTIVE', currentPain: 4 } });
    // Valoraciones presenciales (base y mes 2) + cuestionarios para el informe.
    const base = await db.assessment.create({ data: { userId: subjectId, phase: 'BASELINE', assessedAt: new Date('2026-08-02'), protocolVersion: 'SIFUS-PROT-v1' } });
    const m2 = await db.assessment.create({ data: { userId: subjectId, phase: 'MONTH_2', assessedAt: new Date('2026-10-01'), protocolVersion: 'SIFUS-PROT-v1' } });
    for (const [a, w, waist, grip] of [[base, 72, 88.2, 25], [m2, 70.1, 85.2, 29]] as const) {
      await db.anthropometricRecord.create({ data: { assessmentId: a.id, heightCm: 160, weightKg: w } });
      await db.perimeterMeasurement.create({ data: { assessmentId: a.id, site: 'WAIST', trialsCm: [waist, waist], valueCm: waist } });
      await db.dynamometryTest.create({ data: { assessmentId: a.id, hand: 'RIGHT', isDominant: true, trialsKg: [grip], bestKg: grip } });
    }
    for (const [d, pss] of [['2026-08-02', 29], ['2026-10-01', 19]] as const) {
      await db.questionnaireAdministration.create({ data: { userId: subjectId, instrument: 'PSS_10', instrumentVersion: 'PSS-10 es-CO', itemResponses: {}, totalScore: pss, scoringMethod: 'sum', scoringVersion: 'pss10@1.0.0', completedAt: new Date(d) } });
    }
  });

  afterAll(async () => {
    await db.$disconnect();
    await vaultDb.$disconnect();
  });

  it('2. ingiere Apple Health y rechaza tipos no soportados y valores imposibles', async () => {
    const items: DeviceDailySummary[] = [];
    for (let i = 28; i >= 0; i--) {
      const date = isoDay(addDays(new Date(`${TODAY}T00:00:00Z`), -i));
      const hrv = i === 0 ? 22 : 48 + (i % 4); // hoy: HRV claramente baja
      items.push({ date, platform: 'APPLE_HEALTH', sourceType: 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN', value: hrv, sampleCount: 5 });
      items.push({ date, platform: 'APPLE_HEALTH', sourceType: 'HKQuantityTypeIdentifierRestingHeartRate', value: i === 0 ? 66 : 58, sampleCount: 1 });
      items.push({ date, platform: 'APPLE_HEALTH', sourceType: 'HKQuantityTypeIdentifierStepCount', value: 7000, sampleCount: 1 });
      items.push({ date, platform: 'APPLE_HEALTH', sourceType: 'HKCategoryTypeIdentifierSleepAnalysis', sourceValue: 'asleepCore', value: 250, sampleCount: 1 });
      items.push({ date, platform: 'APPLE_HEALTH', sourceType: 'HKCategoryTypeIdentifierSleepAnalysis', sourceValue: 'asleepDeep', value: 60, sampleCount: 1 });
      items.push({ date, platform: 'APPLE_HEALTH', sourceType: 'HKCategoryTypeIdentifierSleepAnalysis', sourceValue: 'asleepREM', value: 90, sampleCount: 1 });
    }
    items.push({ date: TODAY, platform: 'APPLE_HEALTH', sourceType: 'HKQuantityTypeIdentifierBloodGlucose', value: 90, sampleCount: 1 });
    items.push({ date: TODAY, platform: 'APPLE_HEALTH', sourceType: 'HKQuantityTypeIdentifierRestingHeartRate', value: 400, sampleCount: 1 });
    const r = await passive.ingest(subjectId, items);
    expect(r.rejected.map((x) => x.reason).sort()).toEqual(['FUERA_DE_RANGO_FISIOLOGICO', 'TIPO_NO_SOPORTADO']);
    const ctx = await passive.readinessContext(subjectId, TODAY);
    expect(ctx!.hrvZ!).toBeLessThan(-1);
    expect(ctx!.restingHrDeltaBpm).toBe(8);
    expect(ctx!.sleepHours).toBe(6.7); // 250 + 60 + 90 min
  });

  it('3. buen autorreporte + HRV baja + rodilla lesionada → sin alta intensidad ni carga de rodilla, lenguaje de fe', async () => {
    const plan = await plans.submitCheckIn(subjectId, { date: TODAY, sleepHours: 8, perceivedStress: 3 });
    expect(plan.reasonCodes).toEqual(expect.arrayContaining(['HRV_SUPPRESSED', 'RESTING_HR_ELEVATED']));
    expect(plan.blockedIntensities).toContain('HIGH');
    for (const m of plan.missions) expect(m.template.loadedPatterns).not.toContain('DEEP_SQUAT');
    expect(plan.missions.find((m) => m.slot === 'LORE')!.prompt!.code.startsWith('TH_')).toBe(true);
    expect(plan.gamificationMode).toBe('FULL');
  });

  it('4. GHQ-12 severo → evento de bandera roja, aviso al equipo y plan en pausa sin XP', async () => {
    await db.questionnaireAdministration.create({ data: { userId: subjectId, instrument: 'GHQ_12', instrumentVersion: 'GHQ-12 es', itemResponses: {}, totalScore: 10, subscaleScores: { likert: 30 }, scoringMethod: 'GHQ', scoringVersion: 'ghq12@1.0.0', completedAt: new Date(`${TODAY}T08:00:00Z`) } });
    const status = await safety.evaluate(subjectId, new Date(`${TODAY}T09:00:00Z`));
    expect(status.assessment.level).toBe('ELEVATED');
    expect(status.openEvent?.careTeamNotifiedAt).toBeTruthy();
    expect(notified).toHaveLength(1);
    expect(status.resources[0]!.contact).toBe('123');
    const plan = await plans.submitCheckIn(subjectId, { date: TODAY, sleepHours: 8, perceivedStress: 3 });
    expect(plan.gamificationMode).toBe('PAUSED');
    expect(plan.missions.every((m) => m.xp === 0)).toBe(true);
    // Re-evaluar no abre un segundo evento ni vuelve a notificar.
    await safety.evaluate(subjectId, new Date(`${TODAY}T10:00:00Z`));
    expect(await db.redFlagEvent.count({ where: { userId: subjectId } })).toBe(1);
    // No se puede cerrar sin contacto humano ni mejoría.
    expect(await safety.tryResolve(status.openEvent!.id, 'X', new Date(`${TODAY}T11:00:00Z`))).toBe(false);
    await safety.recordProfessionalContact(status.openEvent!.id, 'Llamada de acompañamiento; remitida a su EPS.');
    const ev = await db.redFlagEvent.findUniqueOrThrow({ where: { id: status.openEvent!.id } });
    expect(ev.followUpNotesCiphertext).not.toContain('EPS');
  });

  it('5. calcula y guarda el Índice de Vida con sus atributos', async () => {
    const r = await wellbeing.computeAndStore(subjectId, TODAY);
    const snap = await db.wellbeingIndexSnapshot.findUniqueOrThrow({ where: { userId_date: { userId: subjectId, date: new Date(TODAY) } } });
    expect(snap.version).toBe(r.version);
    expect(r.domains.find((d) => d.domain === 'BODY')!.components.map((c) => c.key)).toEqual(expect.arrayContaining(['STEPS_7D', 'WAIST_HEIGHT_RATIO']));
    expect(r.domains.find((d) => d.domain === 'RESTORATION')!.score).not.toBeNull();
  });

  it('6. informe PDF identificado: re-identificación auditada en la bóveda y huella SHA-256', async () => {
    const out = await exporter.exportPdf(subjectId, { requestedBy: 'prof-uuid-1', recipient: 'IPS Universitaria', identified: true });
    expect(out.pdf.subarray(0, 5).toString()).toBe('%PDF-');
    const audit = await db.clinicalExport.findUniqueOrThrow({ where: { id: out.exportId } });
    expect(audit.sha256).toBe(out.sha256);
    const log = await vaultDb.identityAccessLog.findMany({ where: { subjectId } });
    expect(log.map((l) => [l.purpose, l.justificationRef])).toEqual([['CLINICAL_REPORT', out.exportId]]);
  });

  it('7. paquete FHIR con sujeto seudónimo', async () => {
    const { bundle } = await exporter.exportFhir(subjectId, { requestedBy: 'prof-uuid-1' });
    expect(bundle.entry.length).toBeGreaterThan(0);
    expect(JSON.stringify(bundle)).not.toContain('Persona de Prueba');
  });

  it('8. supresión de identidad: la PII desaparece y los datos de salud siguen siendo usables', async () => {
    await vault.erase(subjectId, 'dpo-uuid');
    await expect(vault.reidentify(subjectId, 'prof-uuid-1', 'CLINICAL_REPORT', 'x')).rejects.toThrow(/suprimida/);
    expect(await db.dailyPlan.count({ where: { userId: subjectId } })).toBe(1);
  });
});
