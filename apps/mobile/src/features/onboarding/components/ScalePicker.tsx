import React from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { theme } from './theme';

interface Props {
  label: string;
  min: number;
  max: number;
  value?: number;
  onChange: (v: number) => void;
  /** Anclas verbales en los extremos (escalas tipo Likert/NRS). */
  minLabel: string;
  maxLabel: string;
  /** Texto para lectores de pantalla por valor, p. ej. "7: estrés alto". */
  describe?: (v: number) => string;
}

/**
 * Escala discreta con botones grandes. Se prefiere a un slider: es más precisa
 * para registrar datos, más accesible y no sugiere un valor inicial (evita el
 * sesgo de anclaje que produce un slider ya posicionado).
 */
export function ScalePicker({ label, min, max, value, onChange, minLabel, maxLabel, describe }: Props) {
  const values = Array.from({ length: max - min + 1 }, (_, i) => min + i);
  return (
    <View accessibilityRole="radiogroup" accessibilityLabel={label} style={{ gap: theme.space(2) }}>
      <Text style={styles.label}>{label}</Text>
      <View style={styles.row}>
        {values.map((v) => {
          const selected = v === value;
          return (
            <Pressable
              key={v}
              onPress={() => onChange(v)}
              style={[styles.dot, selected && styles.dotSelected]}
              accessibilityRole="radio"
              accessibilityState={{ checked: selected }}
              accessibilityLabel={describe ? describe(v) : String(v)}
              hitSlop={4}
            >
              <Text style={[styles.dotText, selected && styles.dotTextSelected]}>{v}</Text>
            </Pressable>
          );
        })}
      </View>
      <View style={styles.anchors}>
        <Text style={styles.anchor}>{minLabel}</Text>
        <Text style={styles.anchor}>{maxLabel}</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  label: { fontSize: theme.font.body, fontWeight: '600', color: theme.color.ink },
  row: { flexDirection: 'row', flexWrap: 'wrap', gap: theme.space(1.5) },
  dot: {
    width: 40, height: 40, borderRadius: 20, alignItems: 'center', justifyContent: 'center',
    borderWidth: 1.5, borderColor: theme.color.border, backgroundColor: theme.color.surface,
  },
  dotSelected: { backgroundColor: theme.color.primary, borderColor: theme.color.primary },
  dotText: { color: theme.color.ink, fontWeight: '600' },
  dotTextSelected: { color: '#fff' },
  anchors: { flexDirection: 'row', justifyContent: 'space-between' },
  anchor: { fontSize: theme.font.small, color: theme.color.inkSoft },
});
