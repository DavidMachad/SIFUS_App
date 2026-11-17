import React, { useEffect, useRef, useState } from 'react';
import { Animated, ScrollView, StyleSheet, Text, View } from 'react-native';
import { findPractice, type PracticeRecord } from '@sifus/core';
import { ScalePicker } from '../onboarding/components/ScalePicker';
import { theme } from '../onboarding/components/theme';
import { Button, Card, kit } from '../../ui/kit';

type Phase = 'BEFORE' | 'PRACTICE' | 'AFTER' | 'DONE';

/**
 * Una práctica con su registro de 1 a 10 antes y después (paso 3, Experimentar).
 * Cuidado físico: siempre recuerda detenerse ante dolor, mareo o falta de aire.
 */
export function PracticeSession({ practiceCode, today, onSave, onClose }: {
  practiceCode: string;
  today: string;
  onSave: (r: PracticeRecord) => void;
  onClose: () => void;
}) {
  const found = findPractice(practiceCode);
  const [phase, setPhase] = useState<Phase>('BEFORE');
  const [before, setBefore] = useState<number>();
  const [after, setAfter] = useState<number>();
  if (!found) return null;
  const { practice, station } = found;
  const label = practice.measure.label.toLowerCase();

  return (
    <ScrollView contentContainerStyle={styles.root}>
      <Text style={kit.small}>Estación {station.id} · {station.title}</Text>
      <Text style={styles.title} accessibilityRole="header">{practice.name}</Text>

      {phase === 'BEFORE' && (
        <Card>
          <ScalePicker label={`Antes de empezar, ¿cómo está tu ${label}?`} min={1} max={10} value={before} onChange={setBefore} minLabel="1" maxLabel="10" />
          <Button label="Empezar la práctica" onPress={() => setPhase('PRACTICE')} disabled={before === undefined} />
        </Card>
      )}

      {phase === 'PRACTICE' && (
        <Card tone="primary">
          {practiceCode === 'S1_BREATH_4_6' ? <BreathGuide /> : null}
          <Text style={kit.body}>
            {practice.guide ?? 'Sigue la práctica tal como la propone el libro Aurora. La guía paso a paso llegará a la app con el texto del autor.'}
          </Text>
          <Text style={kit.small}>Si sientes dolor, mareo o falta de aire, detente. Tu cuerpo manda.</Text>
          <Button label="Terminé" onPress={() => setPhase('AFTER')} />
        </Card>
      )}

      {phase === 'AFTER' && (
        <Card>
          <ScalePicker label={`Ahora, ¿cómo está tu ${label}?`} min={1} max={10} value={after} onChange={setAfter} minLabel="1" maxLabel="10" />
          <Button
            label="Guardar mi registro"
            disabled={after === undefined}
            onPress={() => {
              onSave({ practiceCode, date: today, before: before!, after: after! });
              setPhase('DONE');
            }}
          />
        </Card>
      )}

      {phase === 'DONE' && (
        <Card tone="accent">
          <Text style={styles.done}>Registrado: {before} → {after}</Text>
          <Text style={kit.body}>Cada registro dibuja tu curva. Un patrón visto es un patrón que puedes transformar.</Text>
        </Card>
      )}

      <Button label={phase === 'DONE' ? 'Volver' : 'Cancelar'} kind="secondary" onPress={onClose} />
    </ScrollView>
  );
}

/** Círculo que crece 4 s (inhalar) y se encoge 6 s (exhalar). */
function BreathGuide() {
  const v = useRef(new Animated.Value(0)).current;
  const [cue, setCue] = useState('Inhala… 4');
  useEffect(() => {
    let alive = true;
    const cycle = () => {
      if (!alive) return;
      setCue('Inhala… 4');
      Animated.timing(v, { toValue: 1, duration: 4000, useNativeDriver: true }).start(() => {
        if (!alive) return;
        setCue('Exhala… 6');
        Animated.timing(v, { toValue: 0, duration: 6000, useNativeDriver: true }).start(cycle);
      });
    };
    cycle();
    return () => { alive = false; v.stopAnimation(); };
  }, [v]);
  const scale = v.interpolate({ inputRange: [0, 1], outputRange: [0.6, 1] });
  return (
    <View style={styles.breathWrap} accessibilityLiveRegion="polite">
      <Animated.View style={[styles.breath, { transform: [{ scale }] }]} />
      <Text style={styles.cue}>{cue}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { padding: theme.space(5), gap: theme.space(4) },
  title: { fontSize: theme.font.title, fontWeight: '800', color: theme.color.ink },
  done: { fontSize: 22, fontWeight: '800', color: theme.color.ink },
  breathWrap: { alignItems: 'center', justifyContent: 'center', height: 170 },
  breath: { position: 'absolute', width: 150, height: 150, borderRadius: 75, backgroundColor: '#BFDCD2' },
  cue: { fontSize: 20, fontWeight: '800', color: theme.color.primary },
});
