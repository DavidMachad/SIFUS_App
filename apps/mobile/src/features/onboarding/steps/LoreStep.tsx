import React from 'react';
import { StyleSheet, Text, TextInput, View } from 'react-native';
import {
  ORIENTATION_LABELS,
  ORIENTATION_PROFILES,
  SPIRITUAL_ORIENTATIONS,
  VIA_LABELS,
  VIA_STRENGTHS,
  type SpiritualOrientation,
  type ViaStrength,
} from '@sifus/core';
import { ChoiceCards, type Choice } from '../components/ChoiceCards';
import { FieldMessage } from '../components/FieldMessage';
import { InfoNote } from '../components/InfoNote';
import { theme } from '../components/theme';
import { MAX_EQUIPPED_STRENGTHS, type PurposeTheme } from '../state/characterDraft';
import type { StepProps } from './types';

const THEMES: Choice<PurposeTheme>[] = [
  { value: 'FAMILY', title: 'Mi familia' },
  { value: 'HEALING', title: 'Sanar' },
  { value: 'STRESS_RELEASE', title: 'Liberar tensión' },
  { value: 'SELF_CARE', title: 'Cuidarme' },
  { value: 'AUTONOMY', title: 'Valerme por mí' },
  { value: 'COMMUNITY', title: 'Mi comunidad' },
  { value: 'FAITH_SPIRITUALITY', title: 'Mi fe / espiritualidad' },
  { value: 'OTHER', title: 'Otro' },
];

const ORIENTATIONS: Choice<SpiritualOrientation>[] = SPIRITUAL_ORIENTATIONS.map((o) => ({
  value: o,
  title: ORIENTATION_LABELS[o].title,
  description: ORIENTATION_LABELS[o].description,
  emoji: { THEOLOGICAL: '🕊️', MINDFULNESS: '🪷', NATURE: '🌳', SECULAR_PURPOSE: '🧭' }[o],
}));

const INSTRUMENT_NAMES = { FACIT_SP_12: 'bienestar espiritual (FACIT-Sp)', SWBS: 'bienestar espiritual (SWBS)', PIL: 'propósito en la vida (PIL)', VIA_IS: 'fortalezas (VIA)' } as const;

const STRENGTH_CHOICES: Choice<ViaStrength>[] = VIA_STRENGTHS.map((s) => ({ value: s, title: VIA_LABELS[s] }));

/** Capítulo 5 · Tu lore: propósito y fortalezas (habilidades pasivas). */
export function LoreStep({ draft, dispatch, validation: v }: StepProps) {
  const set = (patch: Partial<typeof draft>) => dispatch({ type: 'set', patch });
  return (
    <View style={styles.gap}>
      <Text style={styles.label}>¿Qué te conecta con algo más grande que tú?</Text>
      <ChoiceCards
        choices={ORIENTATIONS}
        selected={draft.spiritualOrientation}
        onSelect={(spiritualOrientation) => set({ spiritualOrientation })}
        accessibilityLabel="Orientación espiritual o de propósito"
      />
      <FieldMessage error={v.errors.spiritualOrientation} />
      {draft.spiritualOrientation && (
        <InfoNote title="¿Qué cambia con tu elección?">
          {`Tus reflexiones y algunas misiones de calma usarán un lenguaje acorde con lo que te conecta. Más adelante te invitaremos a responder: ${ORIENTATION_PROFILES[draft.spiritualOrientation].instruments.map((i) => INSTRUMENT_NAMES[i]).join(', ')}. ${ORIENTATION_PROFILES[draft.spiritualOrientation].facitIncludeFaith ? '' : 'Las preguntas sobre fe no se te harán. '}Tu plan físico y tu seguridad no cambian. Puedes cambiar esta opción cuando quieras.`}
        </InfoNote>
      )}

      <Text style={styles.label}>¿Para qué te mueves? ¿Qué te gustaría que el movimiento traiga a tu vida?</Text>
      <ChoiceCards compact choices={THEMES} selected={draft.purposeTheme} onSelect={(purposeTheme) => set({ purposeTheme })} accessibilityLabel="Tema de tu propósito" />
      <TextInput
        value={draft.purposeStatement ?? ''}
        onChangeText={(purposeStatement) => set({ purposeStatement })}
        placeholder="Ej.: Quiero tener energía para jugar con mis hijos."
        multiline
        maxLength={280}
        style={styles.textarea}
        accessibilityLabel="Tu propósito en una frase"
      />
      <FieldMessage error={v.errors.purposeStatement} />

      <Text style={styles.label}>
        Equipa hasta {MAX_EQUIPPED_STRENGTHS} fortalezas ({draft.strengths.length}/{MAX_EQUIPPED_STRENGTHS})
      </Text>
      <Text style={styles.hint}>¿Qué cualidades te describen mejor? Serán tus habilidades pasivas: el juego te hablará desde ellas.</Text>
      <ChoiceCards
        compact multiple
        choices={STRENGTH_CHOICES}
        selected={draft.strengths}
        onSelect={(strength) => dispatch({ type: 'toggleStrength', strength })}
        accessibilityLabel="Fortalezas del carácter"
      />
      <InfoNote title="Sobre las fortalezas">
        Son las 24 fortalezas del carácter de la clasificación VIA. Más adelante podrás responder el inventario
        completo (misión secundaria) y descubrir tus fortalezas distintivas con mayor precisión.
      </InfoNote>
    </View>
  );
}

const styles = StyleSheet.create({
  gap: { gap: theme.space(4) },
  label: { fontSize: theme.font.body, fontWeight: '600', color: theme.color.ink },
  hint: { fontSize: theme.font.small, color: theme.color.inkSoft, marginTop: -theme.space(2) },
  textarea: {
    minHeight: 88, textAlignVertical: 'top', backgroundColor: theme.color.surface, borderWidth: 1.5,
    borderColor: theme.color.border, borderRadius: theme.radius.sm, padding: theme.space(3),
    fontSize: theme.font.body, color: theme.color.ink,
  },
});
