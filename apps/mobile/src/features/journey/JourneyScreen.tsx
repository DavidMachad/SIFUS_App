import React from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { AURORA_PARTS, STATION_LEVEL_LABELS, type JourneyProgress } from '@sifus/core';
import { theme } from '../onboarding/components/theme';
import { Card, kit, Pill } from '../../ui/kit';
import { LEVEL_TONE, STATION_EMOJI } from './visuals';

/** El mapa del viaje: 3 partes, 8 estaciones, en el orden del libro. */
export function JourneyScreen({ journey, onOpenStation }: { journey: JourneyProgress; onOpenStation: (id: number) => void }) {
  return (
    <ScrollView contentContainerStyle={styles.root}>
      <Text style={styles.title} accessibilityRole="header">Tu viaje por Aurora</Text>
      <Text style={kit.body}>
        Aurora no se lee: se recorre. Llevas {journey.practicesLived} de {journey.practicesKnown} prácticas disponibles
        ({journey.practicesInBook} en el libro completo).
      </Text>

      {AURORA_PARTS.map((part) => (
        <View key={part.id} style={{ gap: theme.space(2) }}>
          <Text style={styles.part}>Parte {part.id} · {part.title}</Text>
          <Text style={kit.small}>{part.tagline}</Text>
          {journey.stations.filter((s) => s.station.part === part.id).map((s) => {
            const current = s.station.id === journey.currentStation.id;
            return (
              <Pressable key={s.station.id} onPress={() => onOpenStation(s.station.id)} accessibilityRole="button"
                accessibilityLabel={`Estación ${s.station.id}, ${s.station.title}, ${STATION_LEVEL_LABELS[s.level]}`}>
                <Card style={[styles.station, current && styles.current]}>
                  <Text style={styles.emoji}>{STATION_EMOJI[s.station.id]}</Text>
                  <View style={{ flex: 1, gap: 2 }}>
                    <Text style={kit.strong}>{s.station.id}. {s.station.title}{current ? '  · aquí vas' : ''}</Text>
                    <Text style={kit.small} numberOfLines={2}>{s.station.idea}</Text>
                  </View>
                  <Pill label={STATION_LEVEL_LABELS[s.level]} tone={LEVEL_TONE[s.level]} />
                </Card>
              </Pressable>
            );
          })}
          {part.id === 2 && (
            <Card tone="info">
              <Text style={kit.strong}>Coloquio I · La gente está solita</Text>
              <Text style={kit.small}>El puente hacia la tercera parte: nadie llega solo a la comunidad.</Text>
            </Card>
          )}
        </View>
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  root: { padding: theme.space(5), gap: theme.space(4) },
  title: { fontSize: theme.font.title, fontWeight: '800', color: theme.color.ink },
  part: { fontSize: theme.font.subtitle, fontWeight: '800', color: theme.color.primary, marginTop: theme.space(2) },
  station: { flexDirection: 'row', alignItems: 'center', gap: theme.space(3) },
  current: { borderColor: theme.color.accent, borderWidth: 2 },
  emoji: { fontSize: 28 },
});
