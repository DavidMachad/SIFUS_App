import React from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { theme } from '../onboarding/components/theme';
import type { AttributeView } from './dashboardModel';

/** Los 5 atributos ("stats"). Tocar uno muestra de qué instrumentos se compone. */
export function AttributeGrid({ attributes, onSelect }: { attributes: AttributeView[]; onSelect: (a: AttributeView) => void }) {
  return (
    <View style={styles.grid}>
      {attributes.map((a) => (
        <Pressable
          key={a.domain}
          onPress={() => onSelect(a)}
          style={styles.card}
          accessibilityRole="button"
          accessibilityLabel={`${a.label}: ${a.display}`}
        >
          <Text style={styles.emoji}>{a.emoji}</Text>
          <Text style={styles.label} numberOfLines={2}>{a.label}</Text>
          <Text style={[styles.value, a.score === null && styles.pending]}>{a.display}</Text>
          <View style={styles.coverageTrack}>
            <View style={[styles.coverageFill, { width: `${Math.round(a.coverage * 100)}%` }]} />
          </View>
        </Pressable>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: theme.space(2) },
  card: {
    flexBasis: '47%', flexGrow: 1, backgroundColor: theme.color.surface, borderRadius: theme.radius.md,
    borderWidth: 1, borderColor: theme.color.border, padding: theme.space(3), gap: theme.space(1),
  },
  emoji: { fontSize: 20 },
  label: { fontSize: theme.font.small, color: theme.color.inkSoft },
  value: { fontSize: 22, fontWeight: '800', color: theme.color.ink },
  pending: { fontSize: theme.font.body, color: theme.color.inkSoft, fontWeight: '600' },
  coverageTrack: { height: 4, borderRadius: 2, backgroundColor: theme.color.border },
  coverageFill: { height: '100%', borderRadius: 2, backgroundColor: theme.color.primary },
});
