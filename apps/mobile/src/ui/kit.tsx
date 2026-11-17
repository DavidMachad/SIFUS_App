import React from 'react';
import { Pressable, StyleSheet, Text, View, type StyleProp, type ViewStyle } from 'react-native';
import { theme } from '../features/onboarding/components/theme';

/** Piezas visuales compartidas por Inicio, Viaje y Avatar. */

export function Card({ children, style, tone = 'plain' }: { children: React.ReactNode; style?: StyleProp<ViewStyle>; tone?: 'plain' | 'primary' | 'accent' | 'info' }) {
  return <View style={[styles.card, toneStyle[tone], style]}>{children}</View>;
}

export function SectionTitle({ children, action }: { children: React.ReactNode; action?: { label: string; onPress: () => void } }) {
  return (
    <View style={styles.sectionRow}>
      <Text style={styles.section} accessibilityRole="header">{children}</Text>
      {action && (
        <Pressable onPress={action.onPress} accessibilityRole="button" hitSlop={8}>
          <Text style={styles.link}>{action.label}</Text>
        </Pressable>
      )}
    </View>
  );
}

export function Button({ label, onPress, kind = 'primary', disabled }: { label: string; onPress: () => void; kind?: 'primary' | 'secondary'; disabled?: boolean }) {
  return (
    <Pressable
      onPress={onPress}
      disabled={disabled}
      accessibilityRole="button"
      accessibilityState={{ disabled: !!disabled }}
      style={({ pressed }) => [styles.btn, kind === 'secondary' && styles.btnSecondary, (pressed || disabled) && { opacity: 0.6 }]}
    >
      <Text style={[styles.btnText, kind === 'secondary' && styles.btnTextSecondary]}>{label}</Text>
    </Pressable>
  );
}

export function Pill({ label, tone = 'primary' }: { label: string; tone?: 'primary' | 'accent' | 'muted' }) {
  const t = { primary: [theme.color.primarySoft, theme.color.primary], accent: [theme.color.accentSoft, '#8A5A1C'], muted: [theme.color.border, theme.color.inkSoft] }[tone];
  return (
    <View style={[styles.pill, { backgroundColor: t[0] }]}>
      <Text style={[styles.pillText, { color: t[1] }]}>{label}</Text>
    </View>
  );
}

/** Barra horizontal 0–100. Sin rojo: lo bajo es "recargando", no "perdiendo". */
export function Meter({ label, value, color, caption }: { label: string; value: number | null; color: string; caption?: string }) {
  return (
    <View
      style={{ gap: 6 }}
      accessibilityRole="progressbar"
      accessibilityLabel={label}
      accessibilityValue={value === null ? { text: 'Sin registro reciente' } : { min: 0, max: 100, now: value }}
    >
      <View style={styles.sectionRow}>
        <Text style={styles.meterLabel}>{label}</Text>
        <Text style={[styles.meterValue, { color: value === null ? theme.color.inkSoft : color }]}>{value === null ? '—' : value}</Text>
      </View>
      <View style={styles.track}>
        <View style={{ height: '100%', borderRadius: 6, width: `${value ?? 100}%`, backgroundColor: color, opacity: value === null ? 0.18 : 1 }} />
      </View>
      {caption ? <Text style={styles.small}>{caption}</Text> : null}
    </View>
  );
}

export const kit = StyleSheet.create({
  small: { fontSize: theme.font.small, color: theme.color.inkSoft, lineHeight: 18 },
  body: { fontSize: theme.font.body, color: theme.color.ink, lineHeight: 22 },
  strong: { fontWeight: '700', color: theme.color.ink },
});

const toneStyle = StyleSheet.create({
  plain: {},
  primary: { backgroundColor: theme.color.primarySoft, borderColor: theme.color.primary },
  accent: { backgroundColor: theme.color.accentSoft, borderColor: theme.color.accent },
  info: { backgroundColor: theme.color.infoSoft, borderColor: theme.color.info },
});

const styles = StyleSheet.create({
  card: { backgroundColor: theme.color.surface, borderRadius: theme.radius.lg, borderWidth: 1, borderColor: theme.color.border, padding: theme.space(4), gap: theme.space(2) },
  sectionRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'baseline', gap: theme.space(2) },
  section: { fontSize: theme.font.subtitle, fontWeight: '800', color: theme.color.ink, flexShrink: 1 },
  link: { color: theme.color.primary, fontWeight: '700', fontSize: theme.font.small },
  btn: { backgroundColor: theme.color.primary, borderRadius: 999, paddingVertical: theme.space(3), paddingHorizontal: theme.space(5), alignItems: 'center' },
  btnSecondary: { backgroundColor: 'transparent', borderWidth: 1.5, borderColor: theme.color.primary },
  btnText: { color: '#fff', fontWeight: '800', fontSize: theme.font.body },
  btnTextSecondary: { color: theme.color.primary },
  pill: { alignSelf: 'flex-start', borderRadius: 999, paddingHorizontal: 10, paddingVertical: 3 },
  pillText: { fontSize: 12, fontWeight: '700' },
  meterLabel: { fontWeight: '700', color: theme.color.ink, fontSize: theme.font.body },
  meterValue: { fontWeight: '800', fontSize: 20 },
  track: { height: 12, borderRadius: 6, backgroundColor: theme.color.accentSoft, overflow: 'hidden' },
  small: { fontSize: theme.font.small, color: theme.color.inkSoft, lineHeight: 18 },
});
