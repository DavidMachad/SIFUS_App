import React from 'react';
import { StyleSheet, Text } from 'react-native';
import { theme } from './theme';

/** Error (impide avanzar) o aviso (solo informa). Siempre en tono amable. */
export function FieldMessage({ error, warning }: { error?: string; warning?: string }) {
  if (error) return <Text style={[styles.text, { color: theme.color.error }]} accessibilityLiveRegion="polite">{error}</Text>;
  if (warning) return <Text style={[styles.text, { color: theme.color.info }]} accessibilityLiveRegion="polite">{warning}</Text>;
  return null;
}

const styles = StyleSheet.create({ text: { fontSize: theme.font.small, marginTop: 4 } });
