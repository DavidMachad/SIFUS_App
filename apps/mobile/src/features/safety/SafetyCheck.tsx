import React from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { theme } from '../onboarding/components/theme';

/**
 * Pregunta de seguridad del Protocolo de Banderas Rojas (formato tipo ítem 9
 * del PHQ-9). Solo se muestra cuando el nivel es ELEVATED y no hay una
 * respuesta reciente. La redacción definitiva debe aprobarla el componente
 * clínico y el comité de ética. Responder es opcional.
 */
export const SAFETY_CHECK_OPTIONS = [
  { value: 0, label: 'Nunca' },
  { value: 1, label: 'Varios días' },
  { value: 2, label: 'Más de la mitad de los días' },
  { value: 3, label: 'Casi todos los días' },
] as const;

export function SafetyCheck({ onAnswer }: { onAnswer: (v: 0 | 1 | 2 | 3 | 'DECLINED') => void }) {
  return (
    <View style={styles.card}>
      <Text style={styles.intro}>Queremos asegurarnos de que estés bien. Esta pregunta nos ayuda a acompañarte mejor.</Text>
      <Text style={styles.q} accessibilityRole="header">
        En las últimas dos semanas, ¿con qué frecuencia has tenido pensamientos de que estarías mejor muerto/a o de hacerte daño de alguna manera?
      </Text>
      {SAFETY_CHECK_OPTIONS.map((o) => (
        <Pressable key={o.value} onPress={() => onAnswer(o.value)} style={styles.opt} accessibilityRole="button">
          <Text style={styles.optText}>{o.label}</Text>
        </Pressable>
      ))}
      <Pressable onPress={() => onAnswer('DECLINED')} accessibilityRole="button">
        <Text style={styles.decline}>Prefiero no responder</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: theme.color.surface, borderRadius: theme.radius.lg, padding: theme.space(5), gap: theme.space(3) },
  intro: { color: theme.color.inkSoft, fontSize: theme.font.body },
  q: { color: theme.color.ink, fontSize: theme.font.subtitle, fontWeight: '600', lineHeight: 24 },
  opt: { padding: theme.space(3), borderRadius: theme.radius.md, borderWidth: 1.5, borderColor: theme.color.border },
  optText: { fontSize: theme.font.body, color: theme.color.ink },
  decline: { color: theme.color.inkSoft, textDecorationLine: 'underline', fontSize: theme.font.small, textAlign: 'center' },
});
