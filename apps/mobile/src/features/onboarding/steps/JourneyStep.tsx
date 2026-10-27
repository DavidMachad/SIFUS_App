import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import type { TrainingExperience } from '@sifus/core';
import { ChoiceCards, type Choice } from '../components/ChoiceCards';
import { FieldMessage } from '../components/FieldMessage';
import { NumberField } from '../components/NumberField';
import { theme } from '../components/theme';
import type { TrainingModality } from '../state/characterDraft';
import type { StepProps } from './types';

const EXPERIENCE: Choice<TrainingExperience>[] = [
  { value: 'NONE', emoji: '🌱', title: 'Estoy empezando', description: 'Aún no entreno de forma regular. ¡El mejor punto para comenzar!' },
  { value: 'BEGINNER', emoji: '🌿', title: 'Menos de 6 meses', description: 'Ya di los primeros pasos.' },
  { value: 'INTERMEDIATE', emoji: '🌳', title: '6 meses a 2 años', description: 'Tengo una rutina en marcha.' },
  { value: 'ADVANCED', emoji: '🏔️', title: 'Más de 2 años', description: 'El entrenamiento es parte de mi vida.' },
];

const MODALITIES: Choice<TrainingModality>[] = [
  { value: 'STRENGTH_TRAINING', title: 'Musculación' },
  { value: 'CALISTHENICS', title: 'Calistenia' },
  { value: 'FUNCTIONAL', title: 'Funcional' },
  { value: 'CARDIO_ENDURANCE', title: 'Cardio / resistencia' },
  { value: 'WALKING', title: 'Caminar' },
  { value: 'DANCE', title: 'Baile' },
  { value: 'YOGA_PILATES', title: 'Yoga / pilates' },
  { value: 'SPORTS', title: 'Deportes' },
];

// Barreras = determinantes sociales. Se registran para entender, no para juzgar.
const BARRIERS: Choice<string>[] = [
  { value: 'TIME', title: 'Falta de tiempo' },
  { value: 'COST', title: 'Costos' },
  { value: 'SAFE_SPACES', title: 'Pocos espacios seguros' },
  { value: 'CARE_DUTIES', title: 'Cuido a otras personas' },
  { value: 'PAIN_OR_CONDITION', title: 'Dolor o condición de salud' },
  { value: 'MOTIVATION', title: 'Motivación' },
  { value: 'COMPANY', title: 'No tengo con quién' },
  { value: 'TRANSPORT', title: 'Transporte' },
];

/** Capítulo 3 · Historial de aventuras (experiencia de entrenamiento). */
export function JourneyStep({ draft, dispatch, validation: v }: StepProps) {
  const set = (patch: Partial<typeof draft>) => dispatch({ type: 'set', patch });
  return (
    <View style={styles.gap}>
      <Text style={styles.label}>¿Cuánto camino llevas entrenando?</Text>
      <ChoiceCards
        choices={EXPERIENCE}
        selected={draft.trainingExperience}
        onSelect={(trainingExperience) => set({ trainingExperience })}
        accessibilityLabel="Experiencia de entrenamiento"
      />
      <FieldMessage error={v.errors.trainingExperience} />

      <NumberField
        label="¿Cuántos días a la semana te mueves hoy?"
        unit="días"
        decimals={0}
        value={draft.weeklyFrequency}
        onChange={(weeklyFrequency) => set({ weeklyFrequency })}
        placeholder="0"
        error={v.errors.weeklyFrequency}
      />
      <NumberField
        label="¿De cuánto tiempo dispones por sesión?"
        unit="minutos"
        decimals={0}
        value={draft.avgSessionMinutes}
        onChange={(avgSessionMinutes) => set({ avgSessionMinutes })}
        placeholder="30"
        hint="Tus misiones se ajustarán a este tiempo. Diez minutos también cuentan."
        error={v.errors.avgSessionMinutes}
      />

      <Text style={styles.label}>¿Qué te gusta hacer? (opcional)</Text>
      <ChoiceCards
        compact multiple
        choices={MODALITIES}
        selected={draft.preferredModalities}
        onSelect={(modality) => dispatch({ type: 'toggleModality', modality })}
        accessibilityLabel="Modalidades preferidas"
      />

      <Text style={styles.label}>¿Qué obstáculos encuentras hoy? (opcional)</Text>
      <Text style={styles.hint}>Saberlo nos ayuda a diseñar misiones y gremios que de verdad se adapten a tu realidad.</Text>
      <ChoiceCards
        compact multiple
        choices={BARRIERS}
        selected={draft.perceivedBarriers}
        onSelect={(barrier) => dispatch({ type: 'toggleBarrier', barrier })}
        accessibilityLabel="Barreras percibidas"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  gap: { gap: theme.space(4) },
  label: { fontSize: theme.font.body, fontWeight: '600', color: theme.color.ink },
  hint: { fontSize: theme.font.small, color: theme.color.inkSoft, marginTop: -theme.space(2) },
});
