import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { AURORA_STATIONS, type UnlockedGear } from '@sifus/core';
import { theme } from '../onboarding/components/theme';
import { GEAR_EMOJI } from '../journey/visuals';
import { Card, kit, SectionTitle } from '../../ui/kit';

const REFINEMENT = { 1: 'Recién forjado', 2: 'Refinado', 3: 'Maestro' } as const;

/** El equipo del avatar: cada objeto simboliza algo que la persona ya entrenó en su cuerpo. */
export function EquipmentShelf({ gear }: { gear: UnlockedGear[] }) {
  const all = AURORA_STATIONS.flatMap((s) => s.gear.map((g) => ({ ...g, stationId: s.id })));
  return (
    <View style={{ gap: theme.space(2) }}>
      <SectionTitle>Tu equipo</SectionTitle>
      <Text style={kit.small}>El avatar crece con lo que practicas en tu vida real, nunca con lo que compras.</Text>
      <View style={styles.grid}>
        {all.map((g) => {
          const got = gear.find((x) => x.id === g.id);
          return (
            <Card key={g.id} style={[styles.item, !got && styles.locked]}>
              <Text style={{ fontSize: 26 }}>{got ? GEAR_EMOJI[g.id] : '🔒'}</Text>
              <Text style={kit.strong}>{g.name}</Text>
              <Text style={kit.small}>{got ? REFINEMENT[got.refinement] : `Estación ${g.stationId}`}</Text>
            </Card>
          );
        })}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: theme.space(2) },
  item: { flexBasis: '30%', flexGrow: 1, alignItems: 'center', gap: 2, padding: theme.space(3) },
  locked: { opacity: 0.5 },
});
