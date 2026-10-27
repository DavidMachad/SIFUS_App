import React from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import type { BodyRegion, InjuryStatus } from '@sifus/core';
import { ChoiceCards, type Choice } from '../components/ChoiceCards';
import { FieldMessage } from '../components/FieldMessage';
import { InfoNote } from '../components/InfoNote';
import { NumberField } from '../components/NumberField';
import { ScalePicker } from '../components/ScalePicker';
import { theme } from '../components/theme';
import { READINESS_SCREEN_QUESTIONS, type SmokingStatus } from '../state/characterDraft';
import type { StepProps } from './types';

const REGIONS: Choice<BodyRegion>[] = [
  { value: 'NECK', title: 'Cuello' }, { value: 'SHOULDER', title: 'Hombro' }, { value: 'ELBOW', title: 'Codo' },
  { value: 'WRIST_HAND', title: 'Muñeca / mano' }, { value: 'UPPER_BACK', title: 'Espalda alta' }, { value: 'LOWER_BACK', title: 'Espalda baja' },
  { value: 'HIP', title: 'Cadera' }, { value: 'KNEE', title: 'Rodilla' }, { value: 'ANKLE_FOOT', title: 'Tobillo / pie' }, { value: 'OTHER', title: 'Otra' },
];
const STATUS: Choice<InjuryStatus>[] = [
  { value: 'ACTIVE', title: 'Me limita hoy' },
  { value: 'RECOVERING', title: 'Me estoy recuperando' },
  { value: 'RESOLVED', title: 'Ya sanó' },
];
const SMOKING: Choice<SmokingStatus>[] = [
  { value: 'NEVER', title: 'Nunca he fumado' }, { value: 'FORMER', title: 'Fumaba, ya no' },
  { value: 'CURRENT', title: 'Fumo actualmente' }, { value: 'UNDISCLOSED', title: 'Prefiero no decir' },
];

/**
 * Capítulo 4 · Cicatrices y bitácora de viaje: antecedentes, lesiones y hábitos.
 * Las lesiones ACTIVAS bloquean automáticamente la carga en los patrones de
 * movimiento de esa región (@sifus/core patternsBlockedByInjuries).
 */
export function HistoryStep({ draft, dispatch, validation: v }: StepProps) {
  const set = (patch: Partial<typeof draft>) => dispatch({ type: 'set', patch });
  return (
    <View style={styles.gap}>
      <Text style={styles.section}>Antes de empezar a moverte</Text>
      {READINESS_SCREEN_QUESTIONS.map((q) => (
        <View key={q.id} style={styles.question}>
          <Text style={styles.qText}>{q.text}</Text>
          <ChoiceCards
            compact
            choices={[{ value: 'yes', title: 'Sí' }, { value: 'no', title: 'No' }]}
            selected={draft.readinessScreen[q.id] === undefined ? undefined : draft.readinessScreen[q.id] ? 'yes' : 'no'}
            onSelect={(val) => dispatch({ type: 'setScreen', id: q.id, value: val === 'yes' })}
            accessibilityLabel={q.text}
          />
        </View>
      ))}
      <FieldMessage warning={v.warnings.readinessScreen} />

      <Text style={styles.section}>Lesiones o molestias</Text>
      <Text style={styles.hint}>Así cuidamos esas zonas: no te propondremos carga allí mientras sanan.</Text>
      {draft.injuries.map((inj, i) => (
        <View key={i} style={styles.injury}>
          <ChoiceCards compact choices={REGIONS} selected={inj.region} onSelect={(region) => dispatch({ type: 'updateInjury', index: i, patch: { region } })} accessibilityLabel="Región" />
          <ChoiceCards compact choices={STATUS} selected={inj.status} onSelect={(status) => dispatch({ type: 'updateInjury', index: i, patch: { status } })} accessibilityLabel="Estado" />
          {inj.status !== 'RESOLVED' && (
            <ScalePicker
              label="Dolor al moverte"
              min={0} max={10}
              value={inj.currentPain}
              onChange={(currentPain) => dispatch({ type: 'updateInjury', index: i, patch: { currentPain } })}
              minLabel="Sin dolor" maxLabel="El peor imaginable"
            />
          )}
          <FieldMessage error={v.errors[`injury.${i}`]} />
          <Pressable onPress={() => dispatch({ type: 'removeInjury', index: i })} accessibilityRole="button">
            <Text style={styles.link}>Quitar</Text>
          </Pressable>
        </View>
      ))}
      <Pressable
        onPress={() => dispatch({ type: 'addInjury', injury: { region: 'KNEE', status: 'ACTIVE' } })}
        style={styles.addBtn}
        accessibilityRole="button"
      >
        <Text style={styles.addText}>+ Agregar lesión o molestia</Text>
      </Pressable>

      <Text style={styles.section}>Hábitos de hoy</Text>
      <ChoiceCards compact choices={SMOKING} selected={draft.smokingStatus} onSelect={(smokingStatus) => set({ smokingStatus })} accessibilityLabel="Tabaco" />
      <NumberField
        label="¿Cuántas horas pasas sentado/a en un día típico?"
        unit="horas" value={draft.sittingHoursPerDay}
        onChange={(sittingHoursPerDay) => set({ sittingHoursPerDay })}
        error={v.errors.sittingHoursPerDay}
      />
      <NumberField
        label="¿Cuántos minutos usas pantallas antes de dormir?"
        unit="min" decimals={0} value={draft.screenMinutesBeforeBed}
        onChange={(screenMinutesBeforeBed) => set({ screenMinutesBeforeBed })}
        hint="Opcional. Ayuda a proponerte misiones de higiene del sueño."
      />
      <InfoNote title="¿Quién ve esta información?">
        Solo tú y el equipo de salud asignado. Se guarda separada de tu nombre y cifrada. Medicamentos, cirugías y
        otros antecedentes los puedes completar después, como misiones secundarias.
      </InfoNote>
    </View>
  );
}

const styles = StyleSheet.create({
  gap: { gap: theme.space(3) },
  section: { fontSize: theme.font.subtitle, fontWeight: '700', color: theme.color.ink, marginTop: theme.space(2) },
  hint: { fontSize: theme.font.small, color: theme.color.inkSoft },
  question: { gap: theme.space(2), paddingVertical: theme.space(1) },
  qText: { fontSize: theme.font.body, color: theme.color.ink },
  injury: { backgroundColor: theme.color.surface, borderRadius: theme.radius.md, borderWidth: 1, borderColor: theme.color.border, padding: theme.space(3), gap: theme.space(2) },
  link: { color: theme.color.primary, fontSize: theme.font.small, textDecorationLine: 'underline' },
  addBtn: { padding: theme.space(3), borderRadius: theme.radius.md, borderWidth: 1.5, borderStyle: 'dashed', borderColor: theme.color.primary, alignItems: 'center' },
  addText: { color: theme.color.primary, fontWeight: '600' },
});
