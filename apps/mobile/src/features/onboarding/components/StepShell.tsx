import React from 'react';
import { KeyboardAvoidingView, Platform, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { theme } from './theme';

interface Props {
  chapter: string; // "Capítulo 2 de 6"
  title: string;
  subtitle: string;
  progress: number; // 0–1
  canGoBack: boolean;
  nextLabel?: string;
  nextDisabled?: boolean;
  onBack: () => void;
  onNext: () => void;
  /** Ofrece "completar después" sin culpa: lo omitido se vuelve misión secundaria. */
  onSkip?: () => void;
  children: React.ReactNode;
}

/** Marco común de cada capítulo: barra de XP de creación + navegación. */
export function StepShell(p: Props) {
  return (
    <KeyboardAvoidingView style={styles.root} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <View style={styles.header}>
        <Text style={styles.chapter}>{p.chapter}</Text>
        <View
          style={styles.track}
          accessibilityRole="progressbar"
          accessibilityValue={{ min: 0, max: 100, now: Math.round(p.progress * 100) }}
          accessibilityLabel="Progreso de creación del personaje"
        >
          <View style={[styles.fill, { width: `${Math.round(p.progress * 100)}%` }]} />
        </View>
      </View>

      <ScrollView contentContainerStyle={styles.body} keyboardShouldPersistTaps="handled">
        <Text style={styles.title} accessibilityRole="header">{p.title}</Text>
        <Text style={styles.subtitle}>{p.subtitle}</Text>
        {p.children}
      </ScrollView>

      <View style={styles.footer}>
        {p.canGoBack ? (
          <Pressable onPress={p.onBack} style={styles.secondary} accessibilityRole="button">
            <Text style={styles.secondaryText}>Atrás</Text>
          </Pressable>
        ) : <View style={styles.secondary} />}
        {p.onSkip && (
          <Pressable onPress={p.onSkip} accessibilityRole="button" accessibilityHint="Lo podrás completar luego como misión secundaria">
            <Text style={styles.skip}>Completar después</Text>
          </Pressable>
        )}
        <Pressable
          onPress={p.onNext}
          disabled={p.nextDisabled}
          style={[styles.primary, p.nextDisabled && styles.disabled]}
          accessibilityRole="button"
          accessibilityState={{ disabled: !!p.nextDisabled }}
        >
          <Text style={styles.primaryText}>{p.nextLabel ?? 'Continuar'}</Text>
        </Pressable>
      </View>
    </KeyboardAvoidingView>
  );
}

const { color, space, radius, font } = theme;
const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: color.bg },
  header: { paddingHorizontal: space(5), paddingTop: space(4), gap: space(2) },
  chapter: { color: color.inkSoft, fontSize: font.small, letterSpacing: 0.5, textTransform: 'uppercase' },
  track: { height: 8, borderRadius: 4, backgroundColor: color.accentSoft, overflow: 'hidden' },
  fill: { height: '100%', backgroundColor: color.accent },
  body: { padding: space(5), gap: space(4) },
  title: { fontSize: font.title, fontWeight: '700', color: color.ink },
  subtitle: { fontSize: font.body, color: color.inkSoft, lineHeight: 22 },
  footer: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
    padding: space(4), borderTopWidth: 1, borderTopColor: color.border, backgroundColor: color.surface,
  },
  primary: { backgroundColor: color.primary, paddingVertical: space(3), paddingHorizontal: space(6), borderRadius: radius.lg },
  primaryText: { color: '#fff', fontWeight: '700', fontSize: font.body },
  disabled: { opacity: 0.4 },
  secondary: { minWidth: 72, paddingVertical: space(3) },
  secondaryText: { color: color.primary, fontSize: font.body },
  skip: { color: color.inkSoft, fontSize: font.small, textDecorationLine: 'underline' },
});
