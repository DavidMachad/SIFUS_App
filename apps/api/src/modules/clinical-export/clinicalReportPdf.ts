import { createHash } from 'node:crypto';
import { existsSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import PDFDocument from 'pdfkit';
import { assertClinicalLanguage, trendLabel, type ClinicalReport, type ReportRow } from '@sifus/core';

/**
 * Informe clínico en PDF para profesionales de la salud.
 *  - Lenguaje exclusivamente clínico: todo el texto pasa por
 *    assertClinicalLanguage() antes de escribirse (si aparece "nivel", "XP",
 *    "misión"… la generación falla, no se emite un documento contaminado).
 *  - Puntajes brutos, cambio frente a la línea de base, cambio estandarizado y
 *    percentiles con la norma citada; códigos LOINC (marcados * si están
 *    pendientes de verificación).
 *  - Devuelve el SHA-256 del documento para la auditoría (ClinicalExport).
 */
export interface PdfIdentity {
  /** Solo si la persona autorizó la exportación identificada (re-identificación auditada). */
  fullName: string;
  document?: string;
}

const FONT_DIR = process.env.SIFUS_FONT_DIR ?? join(dirname(fileURLToPath(import.meta.url)), '../../../assets/fonts');
const UNICODE_FONT = { regular: join(FONT_DIR, 'DejaVuSans.ttf'), bold: join(FONT_DIR, 'DejaVuSans-Bold.ttf') };

/** Sin fuente Unicode, las fuentes PDF estándar (WinAnsi) no tienen →, ≥, ≤, −. */
const toWinAnsi = (s: string) => s.replace(/→/g, '->').replace(/≥/g, '>=').replace(/≤/g, '<=').replace(/−/g, '-').replace(/²/g, '2');

const fmt = (v: number | null | undefined, d = 1) =>
  v === null || v === undefined ? '—' : v.toLocaleString('es-CO', { maximumFractionDigits: d, minimumFractionDigits: 0 });
const signed = (v: number | null, d = 1) => (v === null ? '—' : `${v > 0 ? '+' : ''}${fmt(v, d)}`);

export async function renderClinicalReportPdf(report: ClinicalReport, identity?: PdfIdentity): Promise<{ pdf: Buffer; sha256: string }> {
  const doc = new PDFDocument({ size: 'LETTER', margin: 48, info: { Title: 'Informe de seguimiento funcional y psicosocial', Author: 'SIFUS — Universidad de Antioquia' } });
  const unicode = existsSync(UNICODE_FONT.regular) && existsSync(UNICODE_FONT.bold);
  if (unicode) {
    doc.registerFont('Body', UNICODE_FONT.regular);
    doc.registerFont('Body-Bold', UNICODE_FONT.bold);
  }
  const REG = unicode ? 'Body' : 'Helvetica';
  const BOLD = unicode ? 'Body-Bold' : 'Helvetica-Bold';
  const enc = unicode ? (s: string) => s : toWinAnsi;
  const chunks: Buffer[] = [];
  doc.on('data', (c: Buffer) => chunks.push(c));
  const done = new Promise<Buffer>((resolve) => doc.on('end', () => resolve(Buffer.concat(chunks))));

  const text = (s: string, opts?: PDFKit.Mixins.TextOptions) => {
    assertClinicalLanguage(s);
    doc.text(enc(s), opts);
  };

  // --- Encabezado ---------------------------------------------------------------
  doc.font(BOLD).fontSize(14);
  text('Informe de seguimiento funcional y psicosocial');
  doc.font(REG).fontSize(9).fillColor('#444');
  text('Semillero de Investigación en Funcionalidad, Movimiento y Salud (SIFUS) — Universidad de Antioquia');
  doc.moveDown(0.6).fillColor('#000').fontSize(10);
  text(identity ? `Paciente: ${identity.fullName}${identity.document ? ` · Documento: ${identity.document}` : ''}` : `Código seudónimo: ${report.subjectLabel}`);
  const sexEs = { FEMALE: 'Femenino', MALE: 'Masculino', INTERSEX: 'Intersexual', UNDISCLOSED: 'No informado' }[report.sex];
  text(`Sexo registrado: ${sexEs} · Edad aproximada: ${report.ageYears} años`);
  text(`Periodo: ${report.period.from} a ${report.period.to} · Generado: ${report.generatedAt}`);
  doc.moveDown(0.8);

  // --- Tabla --------------------------------------------------------------------
  const cols = [
    { title: 'Medida', w: 150 },
    { title: 'Línea de base', w: 62 },
    { title: 'Actual', w: 52 },
    { title: 'Cambio', w: 52 },
    { title: 'Cambio (DE)', w: 48 },
    { title: 'Percentil base → actual', w: 70 },
    { title: 'Evolución', w: 82 },
  ];
  const x0 = doc.page.margins.left;
  const drawRow = (cells: string[], bold = false, shade = false) => {
    const y = doc.y;
    doc.font(bold ? BOLD : REG).fontSize(7.5);
    cells = cells.map(enc);
    const heights = cells.map((c, i) => doc.heightOfString(c, { width: cols[i]!.w - 6 }));
    const h = Math.max(...heights) + 6;
    if (y + h > doc.page.height - doc.page.margins.bottom - 60) {
      doc.addPage();
      return drawRow(cells, bold, shade);
    }
    if (shade) doc.rect(x0, y, cols.reduce((s, c) => s + c.w, 0), h).fill('#EEF2F1').fillColor('#000');
    let x = x0;
    cells.forEach((c, i) => {
      assertClinicalLanguage(c);
      doc.text(c, x + 3, y + 3, { width: cols[i]!.w - 6 });
      x += cols[i]!.w;
    });
    doc.y = y + h;
    doc.x = x0;
  };

  drawRow(cols.map((c) => c.title), true, true);
  for (const r of report.rows) drawRow(rowCells(r));
  doc.moveDown(0.8);

  // --- Interpretaciones ---------------------------------------------------------
  const interp = report.rows.filter((r) => r.interpretation);
  if (interp.length) {
    doc.font(BOLD).fontSize(10);
    text('Interpretación de instrumentos (valor actual)');
    doc.font(REG).fontSize(9);
    for (const r of interp) text(`• ${r.measure.label}: ${r.interpretation}`);
    doc.moveDown(0.6);
  }

  const norms = [...new Set(report.rows.flatMap((r) => (r.currentNorm ? [r.currentNorm.citation] : [])))];
  if (norms.length) {
    doc.font(BOLD).fontSize(10);
    text('Normas de referencia');
    doc.font(REG).fontSize(8);
    for (const n of norms) text(`• ${n}`);
    doc.moveDown(0.6);
  }

  doc.font(BOLD).fontSize(10);
  text('Notas metodológicas');
  doc.font(REG).fontSize(8).fillColor('#333');
  for (const n of report.notes) text(`• ${n}`);
  text('• Códigos: LOINC entre corchetes; (*) pendiente de verificación terminológica.');
  doc.end();

  const pdf = await done;
  return { pdf, sha256: createHash('sha256').update(pdf).digest('hex') };
}

function rowCells(r: ReportRow): string[] {
  const code = r.measure.loinc ? ` [LOINC ${r.measure.loinc.code}${r.measure.loinc.status === 'PENDING_VERIFICATION' ? '*' : ''}]` : '';
  const pct = r.baselineNorm || r.currentNorm
    ? `P${fmt(r.baselineNorm?.percentile, 0)} → P${fmt(r.currentNorm?.percentile, 0)}`
    : 'Sin norma';
  return [
    `${r.measure.label}\n${r.measure.unit}${code}`,
    r.baseline ? `${fmt(r.baseline.value, 2)}\n${r.baseline.date}` : '—',
    r.current ? `${fmt(r.current.value, 2)}\n${r.current.date}` : '—',
    r.changePct !== null ? `${signed(r.change, 2)}\n(${signed(r.changePct)} %)` : signed(r.change, 2),
    signed(r.standardizedChange, 2),
    pct,
    trendLabel(r.trend),
  ];
}
