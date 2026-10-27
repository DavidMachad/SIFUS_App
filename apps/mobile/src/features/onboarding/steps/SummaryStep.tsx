import React, { useMemo } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { BAND_LABELS, CAPACITY_LABELS, FUNCTIONAL_CAPACITIES, VIA_LABELS } from '@sifus/core';
import { theme } from '../components/theme';
import { initialStats, previewDayOnePlan } from '../state/payload';
import type { StepProps } from './types';

/** Capítulo 6 · Ficha del personaje + vista previa de la primera misión. */
export function SummaryStep({ draft }: StepProps) {
  const stats = initialStats(draft);
  const plan = useMemo(() => previewDayOnePlan(draft), [draft]);

  return (
    <View style={styles.gap}>
      <View style={styles.card}>
        <Text style={styles.name}>{draft.displayName}</Text>
        <Text style={styles.meta}>Nivel {stats.level} · {stats.storyXp} XP de historia</Text>
        {draft.purposeStatement ? <Text style={styles.purpose}>“{draft.purposeStatement}”</Text> : null}

        <Text style={styles.section}>Árbol de habilidades</Text>
        {FUNCTIONAL_CAPACITIES.map((c) => (
          <View key={c} style={styles.statRow}>
            <Text style={styles.statLabel}>{CAPACITY_LABELS[c]}</Text>
            <Text style={styles.statValue}>Nv. {stats.capacities[c]}</Text>
          </View>
        ))}
        <Text style={styles.hint}>Todas parten del mismo punto. Lo que importa es tu propio camino.</Text>

        {draft.strengths.length > 0 && (
          <>
            <Text style={styles.section}>Habilidades pasivas</Text>
            <Text style={styles.body}>{draft.strengths.map((s) => VIA_LABELS[s]).join(' · ')}</Text>
          </>
        )}
      </View>

      <View style={[styles.card, styles.planCard]}>
        <Text style={styles.section}>Tu primera jornada: {BAND_LABELS[plan.band]}</Text>
        <Text style={styles.body}>{plan.message}</Text>
        {plan.missions.map((m) => (
          <View key={m.template.code} style={styles.mission}>
            <Text style={styles.missionTitle}>{m.template.title} · {m.template.durationMinutes} min · +{m.xp} XP</Text>
            <Text style={styles.hint}>{m.rationale}</Text>
          </View>
        ))}
        {plan.unlockHint && <Text style={styles.hint}>{plan.unlockHint}</Text>}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  gap: { gap: theme.space(4) },
  card: {
    backgroundColor: theme.color.surface, borderRadius: theme.radius.lg, padding: theme.space(5),
    borderWidth: 1, borderColor: theme.color.border, gap: theme.space(2),
  },
  planCard: { backgroundColor: theme.color.primarySoft, borderColor: theme.color.primary },
  name: { fontSize: theme.font.title, fontWeight: '800', color: theme.color.ink },
  meta: { color: theme.color.accent, fontWeight: '700' },
  purpose: { fontStyle: 'italic', color: theme.color.inkSoft },
  section: { fontSize: theme.font.subtitle, fontWeight: '700', color: theme.color.ink, marginTop: theme.space(2) },
  statRow: { flexDirection: 'row', justifyContent: 'space-between' },
  statLabel: { color: theme.color.ink },
  statValue: { color: theme.color.primary, fontWeight: '700' },
  body: { color: theme.color.ink, lineHeight: 21 },
  hint: { color: theme.color.inkSoft, fontSize: theme.font.small },
  mission: { paddingVertical: theme.space(2), borderTopWidth: 1, borderTopColor: theme.color.border, gap: 2 },
  missionTitle: { fontWeight: '600', color: theme.color.ink },
});
