import React, { useEffect, useState } from 'react';
import { StyleSheet, Text, TextInput, View } from 'react-native';
import { FieldMessage } from './FieldMessage';
import { theme } from './theme';

interface Props {
  label: string;
  unit: string;
  value?: number;
  onChange: (v: number | undefined) => void;
  decimals?: number;
  placeholder?: string;
  error?: string;
  warning?: string;
  hint?: string;
}

/** Campo numérico que acepta coma o punto decimal (uso habitual en Colombia). */
export function NumberField({ label, unit, value, onChange, decimals = 1, placeholder, error, warning, hint }: Props) {
  const [text, setText] = useState(value?.toString().replace('.', ',') ?? '');
  useEffect(() => {
    if (value === undefined) setText('');
  }, [value]);

  const handle = (raw: string) => {
    setText(raw);
    const normalized = raw.replace(',', '.').trim();
    if (normalized === '') return onChange(undefined);
    const n = Number(normalized);
    if (Number.isFinite(n)) onChange(Number(n.toFixed(decimals)));
  };

  return (
    <View style={{ gap: theme.space(1) }}>
      <Text style={styles.label}>{label}</Text>
      {hint && <Text style={styles.hint}>{hint}</Text>}
      <View style={[styles.inputRow, error ? styles.inputError : null]}>
        <TextInput
          value={text}
          onChangeText={handle}
          keyboardType="decimal-pad"
          placeholder={placeholder}
          style={styles.input}
          accessibilityLabel={`${label} en ${unit}`}
        />
        <Text style={styles.unit}>{unit}</Text>
      </View>
      <FieldMessage error={error} warning={warning} />
    </View>
  );
}

const styles = StyleSheet.create({
  label: { fontSize: theme.font.body, fontWeight: '600', color: theme.color.ink },
  hint: { fontSize: theme.font.small, color: theme.color.inkSoft },
  inputRow: {
    flexDirection: 'row', alignItems: 'center', backgroundColor: theme.color.surface,
    borderWidth: 1.5, borderColor: theme.color.border, borderRadius: theme.radius.sm, paddingHorizontal: theme.space(3),
  },
  inputError: { borderColor: theme.color.error },
  input: { flex: 1, fontSize: theme.font.subtitle, paddingVertical: theme.space(2.5), color: theme.color.ink },
  unit: { color: theme.color.inkSoft, fontSize: theme.font.body },
});
