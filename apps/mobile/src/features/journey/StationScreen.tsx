import React from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import {
  AURORA_STEPS,
  atLeast,
  PRACTITIONER_DAYS,
  practiceCurve,
  STATION_LEVEL_LABELS,
  type PracticeRecord,
  type StationProgress,
} from '@sifus/core';
import { theme } from '../onboarding/components/theme';
import { Button, Card, kit, Pill, SectionTitle } from '../../ui/kit';
import { CurveChart } from './CurveChart';
import { GEAR_EMOJI, LEVEL_TONE, STATION_EMOJI } from './visuals';

/** Una estación del libro con sus 5 pasos, sus prácticas, su curva y su equipo. */
export function StationScreen({ progress, records, onPractice, onDeclareTeach, onShareService, onBack }: {
  progress: StationProgress;
  records: PracticeRecord[];
  onPractice: (code: string) => void;
  onDeclareTeach: () => void;
  onShareService: () => void;
  onBack: () => void;
}) {
  const { station, level, bestPracticeDays } = progress;

  return (
    <ScrollView contentContainerStyle={styles.root}>
      <Pressable onPress={onBack} accessibilityRole="button" hitSlop={8}><Text style={styles.back}>← Volver al viaje</Text></Pressable>

      <View style={styles.hero}>
        <Text style={styles.emoji}>{STATION_EMOJI[station.id]}</Text>
        <View style={{ flex: 1, gap: 4 }}>
          <Text style={kit.small}>Estación {station.id} de 8</Text>
          <Text style={styles.title} accessibilityRole="header">{station.title}</Text>
          <Pill label={STATION_LEVEL_LABELS[level]} tone={LEVEL_TONE[level]} />
        </View>
      </View>

      <Card>
        <Text style={styles.stepTag}>1 · Atender</Text>
        <Text style={kit.body}>{station.story}</Text>
        <Text style={styles.stepTag}>2 · Comprender</Text>
        <Text style={[kit.body, { fontStyle: 'italic' }]}>«{station.idea}»</Text>
        <Text style={kit.small}>El relato completo y sus fuentes llegarán con el texto del libro.</Text>
      </Card>

      <SectionTitle>3 · Experimentar</SectionTitle>
      {station.practices.map((p) => {
        const curve = practiceCurve(p.code, records);
        return (
          <Card key={p.code}>
            <View style={styles.rowBetween}>
              <View style={{ flex: 1 }}>
                <Text style={kit.strong}>{p.name}{p.quick ? ' · 1 min' : ''}</Text>
                <Text style={kit.small}>Se mide: {p.measure.label} (1 a 10)</Text>
              </View>
              <Button label="Practicar" onPress={() => onPractice(p.code)} />
            </View>
            {curve.points.length > 0 && <CurveChart curve={curve} height={72} />}
          </Card>
        );
      })}

      <SectionTitle>4 · Repetir</SectionTitle>
      <Card>
        <Text style={kit.body}>Practica en {PRACTITIONER_DAYS} días distintos para llegar a Practicante. No tienen que ser seguidos: si una semana no puedes, no pierdes nada.</Text>
        <View style={styles.dots} accessibilityLabel={`${Math.min(bestPracticeDays, PRACTITIONER_DAYS)} de ${PRACTITIONER_DAYS} días`}>
          {Array.from({ length: PRACTITIONER_DAYS }, (_, i) => (
            <View key={i} style={[styles.dot, i < bestPracticeDays && styles.dotOn]} />
          ))}
        </View>
      </Card>

      <SectionTitle>5 · Integrar</SectionTitle>
      <Card>
        <Text style={kit.body}>Al cerrar la estación: ¿qué te llevas?, ¿cuánto te movió de 1 a 10?, ¿qué cambiarías? Escríbelo en tu bitácora (lore).</Text>
        {level === 'PRACTITIONER' && (
          <Button label="Esta práctica ya es parte de mi vida y puedo enseñarla" kind="secondary" onPress={onDeclareTeach} />
        )}
        {station.id === 8 && atLeast(level, 'APPRENTICE') && (
          <Button label="Llevé una práctica a otra persona" kind="secondary" onPress={onShareService} />
        )}
      </Card>

      {station.gear.length > 0 && (
        <>
          <SectionTitle>Lo que desbloquea</SectionTitle>
          <View style={styles.gearRow}>
            {station.gear.map((g) => (
              <Card key={g.id} style={[styles.gear, level === 'NONE' && { opacity: 0.45 }]}>
                <Text style={{ fontSize: 26 }}>{level === 'NONE' ? '🔒' : GEAR_EMOJI[g.id]}</Text>
                <Text style={kit.strong}>{g.name}</Text>
                <Text style={kit.small}>{g.meaning}</Text>
              </Card>
            ))}
          </View>
        </>
      )}
      <Text style={kit.small}>Pasos guiados según los cinco pasos del libro: {AURORA_STEPS.map((s) => s.title).join(' · ')}.</Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  root: { padding: theme.space(5), gap: theme.space(3) },
  back: { color: theme.color.primary, fontWeight: '700' },
  hero: { flexDirection: 'row', gap: theme.space(4), alignItems: 'center' },
  emoji: { fontSize: 48 },
  title: { fontSize: theme.font.title, fontWeight: '800', color: theme.color.ink },
  stepTag: { fontSize: 12, fontWeight: '800', color: theme.color.primary, textTransform: 'uppercase', letterSpacing: 0.5 },
  rowBetween: { flexDirection: 'row', alignItems: 'center', gap: theme.space(3) },
  dots: { flexDirection: 'row', gap: 8 },
  dot: { width: 22, height: 22, borderRadius: 11, borderWidth: 2, borderColor: theme.color.primary },
  dotOn: { backgroundColor: theme.color.primary },
  gearRow: { flexDirection: 'row', flexWrap: 'wrap', gap: theme.space(2) },
  gear: { flexBasis: '47%', flexGrow: 1, alignItems: 'flex-start' },
});
