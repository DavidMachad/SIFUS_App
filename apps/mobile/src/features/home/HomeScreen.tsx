import React from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { AURORA_MOTTO, AURORA_STATIONS, BAND_LABELS, resourcesFor, STATION_LEVEL_LABELS } from '@sifus/core';
import type { HomeModel } from '../../app/selectors';
import type { DailyCheckIn } from '../../app/store';
import { theme } from '../onboarding/components/theme';
import { SupportPanel } from '../safety/SupportPanel';
import { CurveChart } from '../journey/CurveChart';
import { GEAR_EMOJI, STATION_EMOJI } from '../journey/visuals';
import { Button, Card, kit, Meter, Pill, SectionTitle } from '../../ui/kit';
import { CheckInCard } from './CheckInCard';

const QUICK = AURORA_STATIONS.flatMap((s) => s.practices.filter((p) => p.quick).map((p) => ({ p, s })));
const longDate = (iso: string) => capitalize(
  new Date(`${iso}T12:00:00`).toLocaleDateString('es-CO', { weekday: 'long', day: 'numeric', month: 'long' }));
const capitalize = (s: string) => s.charAt(0).toUpperCase() + s.slice(1);

/**
 * Inicio: lo primero que ve la persona. Une el viaje de Aurora (estación,
 * prácticas, equipo) con el acompañamiento diario (registro, barras, plan).
 */
export function HomeScreen({ model, playerName, isDemo, hasPlayer, onCreatePlayer, onExploreDemo, onCheckIn, onPractice, onOpenStation, onGoJourney, onCloseHelp }: {
  model: HomeModel;
  playerName: string | null;
  isDemo: boolean;
  hasPlayer: boolean;
  onCreatePlayer: () => void;
  onExploreDemo: () => void;
  onCheckIn: (c: DailyCheckIn) => void;
  onPractice: (code: string) => void;
  onOpenStation: (id: number) => void;
  onGoJourney: () => void;
  onCloseHelp: () => void;
}) {
  const { journey, bars, plan, safety, todayCheckIn } = model;
  const mode = safety.gamificationMode;
  const current = journey.stations.find((s) => s.station.id === journey.currentStation.id)!;

  if (mode === 'PAUSED') {
    return (
      <ScrollView contentContainerStyle={styles.root}>
        <SupportPanel resources={resourcesFor()} crisis={safety.level === 'CRISIS'} onContactCareTeam={() => undefined} />
        {/* Solo si la pausa vino del botón de ayuda: la que viene del registro no se levanta sola (ver canResumeGamification). */}
        {safety.triggers.every((t) => t === 'HELP_REQUESTED') && (
          <Button label="Volver al inicio" kind="secondary" onPress={onCloseHelp} />
        )}
      </ScrollView>
    );
  }

  return (
    <ScrollView contentContainerStyle={styles.root}>
      <View style={{ gap: 4 }}>
        <Text style={styles.date}>{longDate(model.today)}</Text>
        <Text style={styles.hello} accessibilityRole="header">{playerName ? `Hola, ${playerName}` : 'Bienvenido/a a SIFUS'}</Text>
        <Text style={styles.motto}>«{AURORA_MOTTO}»</Text>
        {isDemo && <Pill label="Datos de ejemplo" tone="accent" />}
      </View>

      {!hasPlayer && (
        <Card tone="accent">
          <Text style={styles.cardTitle}>Empieza tu viaje</Text>
          <Text style={kit.body}>
            Crea tu personaje en 7 capítulos cortos. Así las misiones se ajustan a tu sueño, tu estrés y tu historia.
            También puedes recorrer el viaje de Aurora sin crearlo.
          </Text>
          <View style={styles.row}>
            <Button label="Crear mi personaje" onPress={onCreatePlayer} />
            <Button label="Explorar con datos de ejemplo" kind="secondary" onPress={onExploreDemo} />
          </View>
        </Card>
      )}

      {/* Resumen del viaje */}
      <View style={styles.tiles}>
        <Tile label="Estación actual" value={`${current.station.id} de 8`} hint={current.station.title} />
        <Tile label="Prácticas vividas" value={`${journey.practicesLived} de ${journey.practicesKnown}`} hint={`${journey.practicesInBook} en el libro`} />
        <Tile label="Equipo" value={String(journey.gear.length)} hint={journey.gear.length ? journey.gear.map((g) => GEAR_EMOJI[g.id]).join(' ') : 'Por desbloquear'} />
        <Tile label="Registro de hoy" value={todayCheckIn ? 'Listo' : 'Pendiente'} hint={todayCheckIn ? '¡Gracias por contarnos!' : '30 segundos'} />
      </View>

      {/* Barras */}
      <Card>
        <SectionTitle>Tus barras</SectionTitle>
        <Meter label="Energía" value={bars.energy} color={theme.color.primary} />
        <Meter label="Ánimo" value={bars.mood} color={theme.color.info} />
        <Text style={kit.small}>
          {bars.basis === 0
            ? 'Se encienden con tu registro diario de 1 a 10.'
            : mode === 'GENTLE'
              ? 'Hoy la barra no importa tanto como tú. Avanza a tu ritmo.'
              : `Promedio de tus últimos ${bars.basis} registro${bars.basis === 1 ? '' : 's'}. Bajan con el mal sueño o el estrés sostenido, y suben cuando te recuperas.`}
        </Text>
      </Card>

      {!todayCheckIn && <CheckInCard today={model.today} onSave={onCheckIn} />}

      {/* Plan del día */}
      {plan && (
        <Card>
          <SectionTitle>Tu plan de hoy</SectionTitle>
          <Pill label={BAND_LABELS[plan.band]} />
          <Text style={kit.body}>{plan.message}</Text>
          {plan.missions.map((m) => (
            <View key={m.slot + m.template.code} style={styles.mission}>
              <Text style={kit.strong}>{m.template.title}</Text>
              <Text style={kit.small}>{m.template.durationMinutes} min{mode === 'FULL' && m.xp ? ` · +${m.xp} XP` : ''} · {m.rationale}</Text>
            </View>
          ))}
          {!todayCheckIn && <Text style={kit.small}>Plan provisional con tus datos iniciales: se ajusta cuando haces el registro de hoy.</Text>}
        </Card>
      )}

      {/* Pociones */}
      <SectionTitle>Pociones de acceso rápido</SectionTitle>
      <View style={styles.row}>
        {QUICK.map(({ p, s }) => (
          <Pressable key={p.code} onPress={() => onPractice(p.code)} accessibilityRole="button" style={styles.potion}>
            <Text style={{ fontSize: 24 }}>{STATION_EMOJI[s.id]}</Text>
            <Text style={kit.strong}>{p.name}</Text>
            <Text style={kit.small}>1 minuto · mide {p.measure.label.toLowerCase()}</Text>
          </Pressable>
        ))}
      </View>

      {/* Viaje */}
      <SectionTitle action={{ label: 'Ver el mapa', onPress: onGoJourney }}>Continúa tu viaje</SectionTitle>
      <Pressable onPress={() => onOpenStation(current.station.id)} accessibilityRole="button">
        <Card style={styles.stationCard}>
          <Text style={{ fontSize: 40 }}>{STATION_EMOJI[current.station.id]}</Text>
          <View style={{ flex: 1, gap: 4 }}>
            <Text style={kit.small}>Estación {current.station.id} · Parte {current.station.part}</Text>
            <Text style={styles.cardTitle}>{current.station.title}</Text>
            <Text style={kit.small}>«{current.station.idea}»</Text>
            <Pill label={STATION_LEVEL_LABELS[current.level]} tone={current.level === 'NONE' ? 'muted' : 'primary'} />
          </View>
        </Card>
      </Pressable>

      {model.lastCurve && model.lastCurve.points.length > 0 && (
        <Card>
          <SectionTitle>Tu curva</SectionTitle>
          <CurveChart curve={model.lastCurve} />
        </Card>
      )}
    </ScrollView>
  );
}

function Tile({ label, value, hint }: { label: string; value: string; hint: string }) {
  return (
    <View style={styles.tile}>
      <Text style={kit.small}>{label}</Text>
      <Text style={styles.tileValue}>{value}</Text>
      <Text style={kit.small} numberOfLines={1}>{hint}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { padding: theme.space(5), gap: theme.space(4) },
  date: { color: theme.color.inkSoft },
  hello: { fontSize: 30, fontWeight: '800', color: theme.color.ink },
  motto: { fontStyle: 'italic', color: theme.color.primary, fontSize: theme.font.body },
  cardTitle: { fontSize: theme.font.subtitle, fontWeight: '800', color: theme.color.ink },
  row: { flexDirection: 'row', flexWrap: 'wrap', gap: theme.space(2) },
  tiles: { flexDirection: 'row', flexWrap: 'wrap', gap: theme.space(2) },
  tile: { flexBasis: '47%', flexGrow: 1, backgroundColor: theme.color.surface, borderRadius: theme.radius.md, borderWidth: 1, borderColor: theme.color.border, padding: theme.space(3), gap: 2 },
  tileValue: { fontSize: 22, fontWeight: '800', color: theme.color.ink },
  mission: { borderTopWidth: 1, borderTopColor: theme.color.border, paddingTop: theme.space(2), gap: 2 },
  potion: { flexBasis: '47%', flexGrow: 1, backgroundColor: theme.color.primarySoft, borderRadius: theme.radius.md, padding: theme.space(3), gap: 2 },
  stationCard: { flexDirection: 'row', gap: theme.space(3), alignItems: 'center', borderColor: theme.color.accent, borderWidth: 2 },
});
