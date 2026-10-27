import { writeFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { buildClinicalReport, ClinicalLanguageError, type ClinicalReport } from '@sifus/core';
import { renderClinicalReportPdf } from '../src/modules/clinical-export/clinicalReportPdf';

export const demoReport = buildClinicalReport({
  subjectLabel: 'SIFUS-DEMO-001', sex: 'FEMALE', ageYears: 36, generatedAt: '2026-10-27',
  norms: [{ measureCode: 'GRIP_DOMINANT_KG', sex: 'FEMALE', ageMin: 30, ageMax: 39, method: { kind: 'NORMAL', mean: 30, sd: 5 }, citation: 'NORMA SINTÉTICA DE DEMOSTRACIÓN — reemplazar por norma publicada' }],
  rows: [
    { measureCode: 'WEIGHT_KG', baseline: { value: 72, date: '2026-08-02' }, current: { value: 70.1, date: '2026-10-01' } },
    { measureCode: 'PERIM_WAIST', baseline: { value: 88.2, date: '2026-08-02' }, current: { value: 85.2, date: '2026-10-01' }, mdc: 1.5 },
    { measureCode: 'WAIST_HEIGHT_RATIO', baseline: { value: 0.551, date: '2026-08-02' }, current: { value: 0.533, date: '2026-10-01' } },
    { measureCode: 'GRIP_DOMINANT_KG', baseline: { value: 25, date: '2026-08-02' }, current: { value: 29, date: '2026-10-01' }, mdc: 3 },
    { measureCode: 'SIT_REACH_FOOTLINE_CM', baseline: { value: -2, date: '2026-08-02' }, current: { value: 3, date: '2026-10-01' } },
    { measureCode: 'FMS_TOTAL', baseline: { value: 12, date: '2026-08-02' }, current: { value: 15, date: '2026-10-01' } },
    { measureCode: 'PSS10_TOTAL', baseline: { value: 29, date: '2026-08-02' }, current: { value: 19, date: '2026-10-01' }, mdc: 4 },
    { measureCode: 'WHO5_PCT', baseline: { value: 40, date: '2026-08-02' }, current: { value: 64, date: '2026-10-01' }, mdc: 10 },
    { measureCode: 'PSQI_GLOBAL', baseline: { value: 11, date: '2026-08-02' }, current: { value: 7, date: '2026-10-01' }, mdc: 3 },
    { measureCode: 'MSPSS_TOTAL', baseline: { value: 3.2, date: '2026-08-02' }, current: { value: 4.6, date: '2026-10-01' } },
    { measureCode: 'FACIT_SP_TOTAL', baseline: { value: 30, date: '2026-08-02' }, current: { value: 36, date: '2026-10-01' } },
    { measureCode: 'STEPS_7D', baseline: { value: 4760, date: '2026-08-02' }, current: { value: 7160, date: '2026-10-01' } },
  ],
});

describe('Informe clínico PDF', () => {
  it('genera un PDF válido con su SHA-256', async () => {
    const { pdf, sha256 } = await renderClinicalReportPdf(demoReport);
    expect(pdf.subarray(0, 5).toString()).toBe('%PDF-');
    expect(sha256).toMatch(/^[0-9a-f]{64}$/);
    if (process.env.WRITE_SAMPLE_PDF) writeFileSync(process.env.WRITE_SAMPLE_PDF, pdf);
  });

  it('se niega a emitir un informe con terminología de juego', async () => {
    const contaminated: ClinicalReport = { ...demoReport, notes: [...demoReport.notes, 'La paciente subió al nivel 5 del árbol.'] };
    await expect(renderClinicalReportPdf(contaminated)).rejects.toThrow(ClinicalLanguageError);
  });
});
