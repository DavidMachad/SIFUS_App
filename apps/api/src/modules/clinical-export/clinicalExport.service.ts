import { createHash, randomUUID } from 'node:crypto';
import type { Assessment, Instrument, PrismaClient } from '@prisma/client';
import { buildClinicalReport, toFhirBundle, type ReferenceNorm, type ReportInputRow } from '@sifus/core';
import { requireConsent } from '../../shared/consent';
import { isoDay } from '../../shared/dates';
import type { IdentityVaultService } from '../identity/identityVault.service';
import { renderClinicalReportPdf } from './clinicalReportPdf';

type FullAssessment = Assessment & {
  anthropometry: { heightCm: unknown; weightKg: unknown } | null;
  perimeters: { site: string; valueCm: unknown }[];
  dynamometry: { isDominant: boolean; bestKg: unknown }[];
  flexibility: { bestCm: unknown; footLineAtCm: unknown }[];
  strengthTests: { exercise: string; estimated1RmKg: unknown; techniqueValid: boolean }[];
  fmsScreen: { totalScore: number } | null;
};

/** Instrumento → código de medida clínica (y llave de subescala si aplica). */
const QUESTIONNAIRE_MEASURES: { instrument: Instrument; code: string; key?: string }[] = [
  { instrument: 'PSS_10', code: 'PSS10_TOTAL' },
  { instrument: 'GHQ_12', code: 'GHQ12_GHQ' },
  { instrument: 'WHO_5', code: 'WHO5_PCT' },
  { instrument: 'PSQI', code: 'PSQI_GLOBAL' },
  { instrument: 'AIS', code: 'AIS_TOTAL' },
  { instrument: 'MSPSS', code: 'MSPSS_TOTAL' },
  { instrument: 'IPAQ_SF', code: 'IPAQ_MET_MIN' },
  { instrument: 'MEDAS', code: 'MEDAS_NORMALIZED', key: 'normalized' },
  { instrument: 'FACIT_SP_12', code: 'FACIT_SP_TOTAL' },
  { instrument: 'PIL', code: 'PIL_TOTAL' },
  { instrument: 'SWBS', code: 'SWBS_TOTAL' },
];

/** Medidas derivadas de una valoración presencial. */
function assessmentMeasures(a: FullAssessment): Record<string, number> {
  const out: Record<string, number> = {};
  const n = (v: unknown) => Number(v);
  const height = a.anthropometry ? n(a.anthropometry.heightCm) : undefined;
  const weight = a.anthropometry ? n(a.anthropometry.weightKg) : undefined;
  if (weight !== undefined) out.WEIGHT_KG = weight;
  if (weight && height) out.BMI = Math.round((weight / (height / 100) ** 2) * 100) / 100;
  const waist = a.perimeters.find((p) => p.site === 'WAIST');
  const hip = a.perimeters.find((p) => p.site === 'HIP');
  if (waist) out.PERIM_WAIST = n(waist.valueCm);
  if (hip) out.PERIM_HIP = n(hip.valueCm);
  if (waist && height) out.WAIST_HEIGHT_RATIO = Math.round((n(waist.valueCm) / height) * 1000) / 1000;
  const grip = a.dynamometry.find((d) => d.isDominant);
  if (grip) out.GRIP_DOMINANT_KG = n(grip.bestKg);
  if (a.flexibility.length) out.SIT_REACH_FOOTLINE_CM = Math.max(...a.flexibility.map((f) => n(f.bestCm) - n(f.footLineAtCm)));
  const squats = a.strengthTests.filter((t) => t.exercise === 'DEEP_SQUAT' && t.techniqueValid);
  if (squats.length && weight) out.SQUAT_1RM_REL = Math.round((Math.max(...squats.map((t) => n(t.estimated1RmKg))) / weight) * 1000) / 1000;
  if (a.fmsScreen) out.FMS_TOTAL = a.fmsScreen.totalScore;
  return out;
}

export class ClinicalExportService {
  constructor(
    private readonly db: PrismaClient,
    private readonly vault: IdentityVaultService,
    /** Cambio mínimo detectable calibrado por medida (de analytics.dim_measure). */
    private readonly mdcByMeasure: Record<string, number> = {},
  ) {}

  async exportPdf(userId: string, opts: { requestedBy: string; recipient?: string; identified?: boolean; now?: Date }) {
    await requireConsent(this.db, userId, 'allowsClinicalExport');
    const now = opts.now ?? new Date();
    const exportId = randomUUID();
    const { rows, profile, user } = await this.gatherRows(userId);
    const norms = await this.loadNorms();
    const report = buildClinicalReport({
      subjectLabel: user.researchCode,
      sex: profile.sexForReference,
      ageYears: now.getUTCFullYear() - profile.birthYear,
      rows,
      norms,
      generatedAt: isoDay(now),
    });
    // La identificación nominal solo se obtiene de la Bóveda, con propósito auditado.
    const identity = opts.identified ? await this.vault.reidentify(userId, opts.requestedBy, 'CLINICAL_REPORT', exportId) : undefined;
    const { pdf, sha256 } = await renderClinicalReportPdf(report, identity);
    await this.db.clinicalExport.create({
      data: {
        id: exportId, userId, format: 'PDF_CLINICAL_REPORT', requestedBy: opts.requestedBy, recipient: opts.recipient ?? null,
        periodFrom: new Date(report.period.from || isoDay(now)), periodTo: new Date(report.period.to || isoDay(now)), sha256,
      },
    });
    return { exportId, pdf, sha256 };
  }

  /** Paquete FHIR R4 con los valores más recientes; sujeto seudónimo. */
  async exportFhir(userId: string, opts: { requestedBy: string; recipient?: string }) {
    await requireConsent(this.db, userId, 'allowsClinicalExport');
    const { rows } = await this.gatherRows(userId);
    const current = rows.filter((r) => r.current).map((r) => ({ measureCode: r.measureCode, value: r.current!.value, date: r.current!.date }));
    const bundle = toFhirBundle(`Patient/${userId}`, current);
    const json = JSON.stringify(bundle);
    const sha256 = createHash('sha256').update(json).digest('hex');
    const dates = current.map((c) => c.date).sort();
    await this.db.clinicalExport.create({
      data: {
        userId, format: 'FHIR_R4_BUNDLE', requestedBy: opts.requestedBy, recipient: opts.recipient ?? null,
        periodFrom: new Date(dates[0] ?? isoDay(new Date())), periodTo: new Date(dates[dates.length - 1] ?? isoDay(new Date())), sha256,
      },
    });
    return { bundle, sha256 };
  }

  /** Línea de base (primera valoración del evaluador) frente a la más reciente. */
  private async gatherRows(userId: string) {
    const [user, profile, assessments] = await Promise.all([
      this.db.user.findUniqueOrThrow({ where: { id: userId } }),
      this.db.playerProfile.findUniqueOrThrow({ where: { userId } }),
      this.db.assessment.findMany({
        where: { userId, source: 'EVALUATOR' },
        orderBy: { assessedAt: 'asc' },
        include: { anthropometry: true, perimeters: true, dynamometry: true, flexibility: true, strengthTests: true, fmsScreen: true },
      }),
    ]);
    const rows: ReportInputRow[] = [];
    const first = assessments[0];
    const last = assessments.length > 1 ? assessments[assessments.length - 1] : undefined;
    if (first) {
      const base = assessmentMeasures(first as FullAssessment);
      const cur = last ? assessmentMeasures(last as FullAssessment) : {};
      for (const code of new Set([...Object.keys(base), ...Object.keys(cur)])) {
        rows.push({
          measureCode: code,
          baseline: base[code] !== undefined ? { value: base[code]!, date: isoDay(first.assessedAt) } : undefined,
          current: cur[code] !== undefined && last ? { value: cur[code]!, date: isoDay(last.assessedAt) } : undefined,
          mdc: this.mdcByMeasure[code],
        });
      }
    }
    for (const q of QUESTIONNAIRE_MEASURES) {
      const all = await this.db.questionnaireAdministration.findMany({ where: { userId, instrument: q.instrument }, orderBy: { completedAt: 'asc' } });
      const val = (a: (typeof all)[number]) =>
        q.key ? Number((a.subscaleScores as Record<string, unknown> | null)?.[q.key]) : Number(a.totalScore);
      const valid = all.filter((a) => Number.isFinite(val(a)));
      if (!valid.length) continue;
      const b = valid[0]!;
      const c = valid.length > 1 ? valid[valid.length - 1]! : undefined;
      rows.push({
        measureCode: q.code,
        baseline: { value: val(b), date: isoDay(b.completedAt) },
        current: c ? { value: val(c), date: isoDay(c.completedAt) } : undefined,
        mdc: this.mdcByMeasure[q.code],
      });
    }
    return { rows, profile, user };
  }

  private async loadNorms(): Promise<ReferenceNorm[]> {
    const rows = await this.db.referenceNorm.findMany();
    return rows.map((r) => ({
      measureCode: r.measureCode, sex: r.sex as ReferenceNorm['sex'], ageMin: r.ageMin, ageMax: r.ageMax,
      method: r.method as unknown as ReferenceNorm['method'], citation: r.citation,
    }));
  }
}
