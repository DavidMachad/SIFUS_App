import React, { useEffect, useRef } from 'react';
import { Animated, Pressable, StyleSheet, Text, View } from 'react-native';
import { theme } from '../onboarding/components/theme';
import type { BarTone } from './dashboardModel';

const ARCHETYPE_EMOJI = { EXPLORER: '🧭', GUARDIAN: '🛡️', SAGE: '🌿', ARTISAN: '🪶', WAYFARER: '🥾' } as const;
const AURA: Record<BarTone, string> = { DISCOVERING: '#E9E4DA', RECHARGING: '#DCE8F3', BALANCED: '#DCEDE7', RADIANT: '#F6E7D2' };

/**
 * Avatar interactivo: el "aura" respira al ritmo de la energía (más lenta y
 * calmada al recargar). Tocarlo abre el detalle de atributos. No representa
 * forma corporal ni peso: solo arquetipo y estado de energía.
 */
export function Avatar({ archetype, name, tone, onPress }: {
  archetype: keyof typeof ARCHETYPE_EMOJI;
  name: string;
  tone: BarTone;
  onPress: () => void;
}) {
  const breath = useRef(new Animated.Value(0)).current;
  useEffect(() => {
    const duration = tone === 'RECHARGING' ? 3200 : tone === 'RADIANT' ? 1600 : 2400;
    const loop = Animated.loop(Animated.sequence([
      Animated.timing(breath, { toValue: 1, duration, useNativeDriver: true }),
      Animated.timing(breath, { toValue: 0, duration, useNativeDriver: true }),
    ]));
    loop.start();
    return () => loop.stop();
  }, [tone, breath]);
  const scale = breath.interpolate({ inputRange: [0, 1], outputRange: [1, 1.08] });

  return (
    <Pressable onPress={onPress} accessibilityRole="button" accessibilityLabel={`${name}. Toca para ver tus atributos`} style={styles.wrap}>
      <Animated.View style={[styles.aura, { backgroundColor: AURA[tone], transform: [{ scale }] }]} />
      <View style={styles.core}>
        <Text style={styles.emoji}>{ARCHETYPE_EMOJI[archetype]}</Text>
      </View>
      <Text style={styles.name}>{name}</Text>
    </Pressable>
  );
}

const SIZE = 132;
const styles = StyleSheet.create({
  wrap: { alignItems: 'center', justifyContent: 'center', height: SIZE + 40 },
  aura: { position: 'absolute', top: 0, width: SIZE, height: SIZE, borderRadius: SIZE / 2 },
  core: {
    width: SIZE - 36, height: SIZE - 36, borderRadius: (SIZE - 36) / 2, marginTop: 18, backgroundColor: theme.color.surface,
    alignItems: 'center', justifyContent: 'center', borderWidth: 2, borderColor: theme.color.border,
  },
  emoji: { fontSize: 44 },
  name: { marginTop: theme.space(2), fontSize: theme.font.subtitle, fontWeight: '700', color: theme.color.ink },
});
