import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { findPractice, type ChangeReading, type PracticeCurve } from '@sifus/core';
import { theme } from '../onboarding/components/theme';
import { kit } from '../../ui/kit';

const BEFORE = '#B9B3A8';
const AFTER = theme.color.primary;

const READING_TEXT: Record<ChangeReading, string> = {
  TOWARD_BETTER: 'En promedio, después de practicar te calificas mejor que antes.',
  TOWARD_WORSE: 'En promedio, después de practicar te calificas un poco peor. Vale la pena comentarlo con tu facilitador/a.',
  NO_CHANGE: 'Por ahora, antes y después se parecen. Un patrón visto es un patrón que puedes transformar.',
  NEUTRAL: 'Aquí ningún valor es mejor que otro: la curva es para que veas tu patrón.',
};

/**
 * Curva personal: barras pareadas antes (gris) / después (verde) por día.
 * Es autorregistro: se describe el patrón, no se habla de "mejoría clínica".
 */
export function CurveChart({ curve, height = 96 }: { curve: PracticeCurve; height?: number }) {
  const found = findPractice(curve.practiceCode);
  if (!found || curve.points.length === 0) return null;
  const { measure } = found.practice;
  const sign = (n: number) => (n > 0 ? `+${n}` : String(n));

  return (
    <View style={{ gap: theme.space(2) }}>
      <Text style={kit.small}>
        {found.practice.name} · {measure.label} (1 a 10) · {curve.points.length} registro{curve.points.length === 1 ? '' : 's'}
      </Text>
      <View style={[styles.plot, { height }]} accessibilityLabel={`Curva de ${measure.label}: ${curve.points.map((p) => `${p.before} a ${p.after}`).join(', ')}`}>
        {curve.points.map((p) => (
          <View key={`${p.date}-${p.before}-${p.after}`} style={styles.day}>
            <View style={styles.pair}>
              <View style={[styles.bar, { height: (p.before / 10) * height, backgroundColor: BEFORE }]} />
              <View style={[styles.bar, { height: (p.after / 10) * height, backgroundColor: AFTER }]} />
            </View>
          </View>
        ))}
      </View>
      <View style={styles.axis}>
        <Text style={kit.small}>{curve.points[0]!.date.slice(5)}</Text>
        <Text style={kit.small}>{curve.points.at(-1)!.date.slice(5)}</Text>
      </View>
      <View style={styles.legend}>
        <View style={[styles.swatch, { backgroundColor: BEFORE }]} /><Text style={kit.small}>Antes</Text>
        <View style={[styles.swatch, { backgroundColor: AFTER }]} /><Text style={kit.small}>Después</Text>
        {curve.meanChange !== null && <Text style={[kit.small, kit.strong]}>  Cambio medio: {sign(curve.meanChange)}</Text>}
      </View>
      {curve.reading && <Text style={kit.small}>{READING_TEXT[curve.reading]}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  plot: { flexDirection: 'row', alignItems: 'flex-end', gap: 6, borderBottomWidth: 1, borderBottomColor: theme.color.border },
  day: { flex: 1, maxWidth: 28, alignItems: 'center' },
  pair: { flexDirection: 'row', alignItems: 'flex-end', gap: 2, width: '100%' },
  bar: { flex: 1, borderTopLeftRadius: 3, borderTopRightRadius: 3, minHeight: 2 },
  axis: { flexDirection: 'row', justifyContent: 'space-between' },
  legend: { flexDirection: 'row', alignItems: 'center', gap: 6, flexWrap: 'wrap' },
  swatch: { width: 10, height: 10, borderRadius: 2 },
});
