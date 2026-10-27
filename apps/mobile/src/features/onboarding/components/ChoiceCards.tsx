import React from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { theme } from './theme';

export interface Choice<T extends string> {
  value: T;
  title: string;
  description?: string;
  emoji?: string;
}

interface Props<T extends string> {
  choices: Choice<T>[];
  selected: T[] | T | undefined;
  onSelect: (v: T) => void;
  multiple?: boolean;
  compact?: boolean;
  accessibilityLabel: string;
}

/** Tarjetas de elección (únicas o múltiples). En modo compacto, chips. */
export function ChoiceCards<T extends string>({ choices, selected, onSelect, multiple, compact, accessibilityLabel }: Props<T>) {
  const isSelected = (v: T) => (Array.isArray(selected) ? selected.includes(v) : selected === v);
  return (
    <View
      style={compact ? styles.chips : styles.cards}
      accessibilityRole={multiple ? undefined : 'radiogroup'}
      accessibilityLabel={accessibilityLabel}
    >
      {choices.map((c) => {
        const on = isSelected(c.value);
        return (
          <Pressable
            key={c.value}
            onPress={() => onSelect(c.value)}
            style={[compact ? styles.chip : styles.card, on && styles.on]}
            accessibilityRole={multiple ? 'checkbox' : 'radio'}
            accessibilityState={{ checked: on }}
          >
            <Text style={[styles.title, on && styles.onText]}>
              {c.emoji ? `${c.emoji}  ` : ''}{c.title}
            </Text>
            {!compact && c.description && <Text style={[styles.desc, on && styles.onText]}>{c.description}</Text>}
          </Pressable>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  cards: { gap: theme.space(2) },
  chips: { flexDirection: 'row', flexWrap: 'wrap', gap: theme.space(2) },
  card: {
    padding: theme.space(4), borderRadius: theme.radius.md, borderWidth: 1.5,
    borderColor: theme.color.border, backgroundColor: theme.color.surface, gap: theme.space(1),
  },
  chip: {
    paddingVertical: theme.space(2), paddingHorizontal: theme.space(3), borderRadius: 999,
    borderWidth: 1.5, borderColor: theme.color.border, backgroundColor: theme.color.surface,
  },
  on: { backgroundColor: theme.color.primarySoft, borderColor: theme.color.primary },
  title: { fontSize: theme.font.body, fontWeight: '600', color: theme.color.ink },
  desc: { fontSize: theme.font.small, color: theme.color.inkSoft, lineHeight: 18 },
  onText: { color: theme.color.ink },
});
