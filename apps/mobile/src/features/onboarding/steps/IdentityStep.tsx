import React from 'react';
import { StyleSheet, Text, TextInput, View } from 'react-native';
import { ChoiceCards, type Choice } from '../components/ChoiceCards';
import { FieldMessage } from '../components/FieldMessage';
import { InfoNote } from '../components/InfoNote';
import { theme } from '../components/theme';
import type { AvatarArchetype, ImplementationSetting, SexForReference } from '../state/characterDraft';
import type { StepProps } from './types';

const ARCHETYPES: Choice<AvatarArchetype>[] = [
  { value: 'EXPLORER', emoji: '🧭', title: 'Explorador/a', description: 'Te mueve la curiosidad y el aire libre.' },
  { value: 'GUARDIAN', emoji: '🛡️', title: 'Guardián/a', description: 'Te cuidas para cuidar a los tuyos.' },
  { value: 'SAGE', emoji: '🌿', title: 'Sabio/a', description: 'Buscas calma, respiración y autoconocimiento.' },
  { value: 'ARTISAN', emoji: '🪶', title: 'Artesano/a', description: 'Disfrutas la técnica y la precisión del movimiento.' },
  { value: 'WAYFARER', emoji: '🥾', title: 'Caminante', description: 'Avanzas paso a paso, con constancia.' },
];

const SETTINGS: Choice<ImplementationSetting>[] = [
  { value: 'EDUCATIONAL', title: 'Universidad / colegio' },
  { value: 'WORKPLACE', title: 'Lugar de trabajo' },
  { value: 'COMMUNITY', title: 'Barrio / comunidad' },
  { value: 'HEALTHCARE', title: 'Servicio de salud' },
];

const SEX: Choice<SexForReference>[] = [
  { value: 'FEMALE', title: 'Femenino' },
  { value: 'MALE', title: 'Masculino' },
  { value: 'INTERSEX', title: 'Intersexual' },
  { value: 'UNDISCLOSED', title: 'Prefiero no decir' },
];

/** Capítulo 1 · ¿Quién es tu personaje? */
export function IdentityStep({ draft, dispatch, validation: v }: StepProps) {
  const set = (patch: Partial<typeof draft>) => dispatch({ type: 'set', patch });
  return (
    <View style={styles.gap}>
      <View>
        <Text style={styles.label}>Nombre de tu personaje</Text>
        <TextInput
          value={draft.displayName}
          onChangeText={(displayName) => set({ displayName })}
          placeholder="Ej.: Ceiba, Cóndor, Quebrada…"
          maxLength={24}
          style={styles.input}
          accessibilityLabel="Nombre de tu personaje"
        />
        <FieldMessage error={v.errors.displayName} />
      </View>

      <Text style={styles.label}>Arquetipo</Text>
      <ChoiceCards
        choices={ARCHETYPES}
        selected={draft.archetype}
        onSelect={(archetype) => set({ archetype })}
        accessibilityLabel="Arquetipo del personaje"
      />
      <FieldMessage error={v.errors.archetype} />

      <View>
        <Text style={styles.label}>Fecha de nacimiento</Text>
        <TextInput
          value={draft.birthDate ?? ''}
          onChangeText={(t) => set({ birthDate: t.trim() || undefined })}
          placeholder="AAAA-MM-DD"
          keyboardType="numbers-and-punctuation"
          maxLength={10}
          style={styles.input}
          accessibilityLabel="Fecha de nacimiento, formato año, mes, día"
        />
        <FieldMessage error={v.errors.birthDate} warning={v.warnings.birthDate} />
      </View>

      <Text style={styles.label}>¿Dónde vives tu aventura?</Text>
      <ChoiceCards compact choices={SETTINGS} selected={draft.setting} onSelect={(setting) => set({ setting })} accessibilityLabel="Entorno" />
      <FieldMessage error={v.errors.setting} />

      <Text style={styles.label}>Sexo registrado (opcional)</Text>
      <ChoiceCards compact choices={SEX} selected={draft.sexForReference} onSelect={(sexForReference) => set({ sexForReference })} accessibilityLabel="Sexo registrado" />
      <InfoNote title="¿Por qué te preguntamos esto?">
        Algunas pruebas, como la fuerza de prensión o el porcentaje de grasa, usan ecuaciones de referencia distintas
        según el sexo registrado. No define tu identidad ni cambia cómo te trata el juego. Puedes no responder.
      </InfoNote>
    </View>
  );
}

const styles = StyleSheet.create({
  gap: { gap: theme.space(3) },
  label: { fontSize: theme.font.body, fontWeight: '600', color: theme.color.ink, marginBottom: theme.space(1) },
  input: {
    backgroundColor: theme.color.surface, borderWidth: 1.5, borderColor: theme.color.border,
    borderRadius: theme.radius.sm, padding: theme.space(3), fontSize: theme.font.subtitle, color: theme.color.ink,
  },
});
