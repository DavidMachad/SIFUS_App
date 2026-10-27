import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { theme } from '../onboarding/components/theme';
import type { BarTone } from './dashboardModel';

/** Sin rojo en ningún tono: un índice bajo es "recargando", no "perdiendo". */
const TONE_COLOR: Record<BarTone, string> = {
  DISCOVERING: '#B9B3A8',
  RECHARGING: '#5B8DB8',
  BALANCED: '#2F6F5E',
  RADIANT: '#C9822B',
};

export function LifeBar({ value, tone, caption }: { value: number | null; tone: BarTone; caption: string }) {
  const pct = value ?? 0;
  return (
    <View
      style={styles.wrap}
      accessibilityRole="progressbar"
      accessibilityLabel="Índice de Vida"
      accessibilityValue={value === null ? { text: 'Por descubrir' } : { min: 0, max: 100, now: value }}
    >
      <View style={styles.row}>
        <Text style={styles.title}>Energía vital</Text>
        <Text style={[styles.value, { color: TONE_COLOR[tone] }]}>{value === null ? '¿?' : value}</Text>
      </View>
      <View style={styles.track}>
        <View style={[styles.fill, { width: `${value === null ? 100 : pct}%`, backgroundColor: TONE_COLOR[tone], opacity: value === null ? 0.25 : 1 }]} />
      </View>
      <Text style={styles.caption}>{caption}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  wrap: { gap: theme.space(2) },
  row: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'baseline' },
  title: { fontSize: theme.font.subtitle, fontWeight: '700', color: theme.color.ink },
  value: { fontSize: 28, fontWeight: '800' },
  track: { height: 16, borderRadius: 8, backgroundColor: theme.color.accentSoft, overflow: 'hidden' },
  fill: { height: '100%', borderRadius: 8 },
  caption: { fontSize: theme.font.small, color: theme.color.inkSoft, lineHeight: 18 },
});
