import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { ChoiceCards, type Choice } from '../components/ChoiceCards';
import { FieldMessage } from '../components/FieldMessage';
import { InfoNote } from '../components/InfoNote';
import { NumberField } from '../components/NumberField';
import { theme } from '../components/theme';
import {
  PERIMETER_SITES,
  perimeterValue,
  requiresThirdTrial,
  type MeasurementMode,
  type PerimeterSite,
} from '../state/characterDraft';
import type { StepProps } from './types';

const MODES: Choice<MeasurementMode>[] = [
  { value: 'EVALUATOR', emoji: '📏', title: 'Estoy con mi evaluador/a SIFUS', description: 'Toma oficial con protocolo: será tu línea de base.' },
  { value: 'SELF', emoji: '🪞', title: 'Me mido yo', description: 'Sirve para personalizar tu juego. La toma oficial será con tu evaluador/a.' },
  { value: 'LATER', emoji: '⏳', title: 'Más adelante', description: 'Queda como misión secundaria. Nada de esto te impide empezar.' },
];

const SITE_INFO: Record<PerimeterSite, { label: string; how: string }> = {
  CHEST: { label: 'Pecho', how: 'A la altura del esternón, al final de una exhalación normal.' },
  ARM_RELAXED: { label: 'Brazo relajado', how: 'Punto medio entre hombro y codo, brazo colgando.' },
  ARM_FLEXED_TENSED: { label: 'Brazo contraído', how: 'Máximo perímetro con el codo flexionado y el bíceps contraído.' },
  WAIST: { label: 'Cintura', how: 'Perímetro más estrecho entre la última costilla y la cresta ilíaca.' },
  HIP: { label: 'Cadera', how: 'Máximo perímetro de los glúteos, pies juntos.' },
  THIGH_MID: { label: 'Muslo medio', how: 'Punto medio entre el pliegue inguinal y la rótula.' },
  CALF_MAX: { label: 'Pantorrilla', how: 'Máximo perímetro, peso distribuido en ambos pies.' },
};

/**
 * Capítulo 4 · Atributos del cuerpo (ficha de valoración).
 *
 * Decisiones de diseño empático:
 *  - No se muestra IMC ni categorías de peso: los datos alimentan la evidencia
 *    científica y personalizan el juego, pero el personaje no se "califica".
 *  - En modo evaluador se piden 2 tomas por perímetro (criterio ISAK) y una 3.ª
 *    solo si difieren más de 1%.
 */
export function BodyStatsStep({ draft, dispatch, validation: v }: StepProps) {
  const set = (patch: Partial<typeof draft>) => dispatch({ type: 'set', patch });
  const isEvaluator = draft.measurementMode === 'EVALUATOR';

  return (
    <View style={styles.gap}>
      <ChoiceCards
        choices={MODES}
        selected={draft.measurementMode}
        onSelect={(measurementMode) => set({ measurementMode })}
        accessibilityLabel="¿Quién toma las medidas?"
      />

      {draft.measurementMode !== 'LATER' && (
        <>
          <InfoNote title="¿Para qué usamos estas medidas?">
            Para ver cómo cambia tu cuerpo con el tiempo comparándote solo contigo, y para que el equipo de
            investigación SIFUS (si lo autorizas) estudie el efecto del programa. Tu personaje no gana ni pierde
            puntos por tu peso o tus medidas: sube de nivel por lo que tu cuerpo puede hacer.
          </InfoNote>

          <View style={styles.row}>
            <View style={styles.half}>
              <NumberField label="Estatura" unit="cm" value={draft.heightCm} onChange={(heightCm) => set({ heightCm })} placeholder="165" error={v.errors.heightCm} />
            </View>
            <View style={styles.half}>
              <NumberField label="Peso" unit="kg" decimals={2} value={draft.weightKg} onChange={(weightKg) => set({ weightKg })} placeholder="65" error={v.errors.weightKg} />
            </View>
          </View>

          <Text style={styles.section}>Perímetros {isEvaluator ? '(cinta métrica, 2 tomas)' : '(opcional)'}</Text>
          {PERIMETER_SITES.map((site) => (
            <PerimeterRow key={site} site={site} {...{ draft, dispatch, validation: v }} isEvaluator={isEvaluator} />
          ))}
        </>
      )}
    </View>
  );
}

function PerimeterRow({ site, draft, dispatch, validation: v, isEvaluator }: StepProps & { site: PerimeterSite; isEvaluator: boolean }) {
  const trials = draft.perimeterTrials[site] ?? [];
  const slots = isEvaluator ? (requiresThirdTrial(trials) || trials.length === 3 ? 3 : 2) : 1;
  const final = perimeterValue(trials);
  const info = SITE_INFO[site];
  const setTrial = (index: number, value: number | undefined) => dispatch({ type: 'setPerimeterTrial', site, index, value });

  return (
    <View style={styles.perimeter}>
      <Text style={styles.siteLabel}>{info.label}</Text>
      <Text style={styles.how}>{info.how}</Text>
      <View style={styles.row}>
        {Array.from({ length: slots }, (_, i) => (
          <View key={i} style={styles.trial}>
            <NumberField
              label={isEvaluator ? `Toma ${i + 1}` : 'Medida'}
              unit="cm"
              value={trials[i]}
              onChange={(val) => setTrial(i, val)}
            />
          </View>
        ))}
      </View>
      {isEvaluator && requiresThirdTrial(trials) && (
        <Text style={styles.note}>Las dos tomas difieren más de 1 %: registra una tercera (se usará la mediana).</Text>
      )}
      {isEvaluator && final !== undefined && trials.length >= 2 && (
        <Text style={styles.note}>Valor final: {final.toString().replace('.', ',')} cm</Text>
      )}
      <FieldMessage error={v.errors[`perimeter.${site}`]} warning={v.warnings[`perimeter.${site}`]} />
    </View>
  );
}

const styles = StyleSheet.create({
  gap: { gap: theme.space(4) },
  row: { flexDirection: 'row', gap: theme.space(3) },
  half: { flex: 1 },
  trial: { flex: 1 },
  section: { fontSize: theme.font.subtitle, fontWeight: '700', color: theme.color.ink, marginTop: theme.space(2) },
  perimeter: {
    backgroundColor: theme.color.surface, borderRadius: theme.radius.md, padding: theme.space(3),
    borderWidth: 1, borderColor: theme.color.border, gap: theme.space(1),
  },
  siteLabel: { fontSize: theme.font.body, fontWeight: '700', color: theme.color.ink },
  how: { fontSize: theme.font.small, color: theme.color.inkSoft },
  note: { fontSize: theme.font.small, color: theme.color.info },
});
