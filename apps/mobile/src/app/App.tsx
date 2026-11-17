import React, { useEffect, useMemo, useReducer, useState } from 'react';
import { Pressable, SafeAreaView, StyleSheet, Text, View } from 'react-native';
import { computeWellbeingIndex, resourcesFor } from '@sifus/core';
import { EquipmentShelf } from '../features/avatar/EquipmentShelf';
import { AvatarDashboardScreen } from '../features/dashboard/AvatarDashboardScreen';
import { HomeScreen } from '../features/home/HomeScreen';
import { JourneyScreen } from '../features/journey/JourneyScreen';
import { PracticeSession } from '../features/journey/PracticeSession';
import { StationScreen } from '../features/journey/StationScreen';
import { CharacterCreatorScreen } from '../features/onboarding/CharacterCreatorScreen';
import { theme } from '../features/onboarding/components/theme';
import type { OnboardingPayload } from '../features/onboarding/state/payload';
import { HelpButton } from '../features/safety/HelpButton';
import { Button, Card, kit, Meter } from '../ui/kit';
import { demoState } from './demoData';
import { homeModel } from './selectors';
import { initialState, loadState, reducer, saveState, todayIso } from './store';

/**
 * Sin EXPO_PUBLIC_API_URL la app corre en MODO DEMO LOCAL: no envía datos a
 * ningún servidor y calcula todo en el dispositivo con @sifus/core.
 */
const API_URL = process.env.EXPO_PUBLIC_API_URL;

async function submitOnboarding(payload: OnboardingPayload): Promise<void> {
  if (!API_URL) return;
  const res = await fetch(`${API_URL}/onboarding`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error(`No pudimos guardar tu personaje (${res.status}). Intenta de nuevo.`);
}

type Tab = 'HOME' | 'JOURNEY' | 'AVATAR';
type Overlay = null | { kind: 'ONBOARDING' } | { kind: 'STATION'; id: number } | { kind: 'PRACTICE'; code: string; from: Overlay };

const TABS: { key: Tab; label: string; icon: string }[] = [
  { key: 'HOME', label: 'Inicio', icon: '🏠' },
  { key: 'JOURNEY', label: 'Viaje', icon: '🗺️' },
  { key: 'AVATAR', label: 'Avatar', icon: '🧙' },
];

/**
 * Estructura: barra superior (marca + «Necesito ayuda ahora», siempre visible),
 * contenido, y pestañas Inicio · Viaje · Avatar. La app abre en el Inicio.
 */
export default function App() {
  const [state, dispatch] = useReducer(reducer, initialState, () => loadState() ?? initialState);
  const [tab, setTab] = useState<Tab>('HOME');
  const [overlay, setOverlay] = useState<Overlay>(null);
  useEffect(() => saveState(state), [state]);

  const today = todayIso();
  const model = useMemo(() => homeModel(state, today), [state, today]);
  const paused = model.safety.gamificationMode === 'PAUSED';

  const goTab = (t: Tab) => { setOverlay(null); setTab(t); };
  const openPractice = (code: string) => setOverlay((o) => ({ kind: 'PRACTICE', code, from: o }));
  const openStation = (id: number) => setOverlay({ kind: 'STATION', id });

  let content: React.ReactNode;
  if (overlay?.kind === 'ONBOARDING') {
    content = (
      <CharacterCreatorScreen
        onComplete={async (p) => {
          await submitOnboarding(p);
          dispatch({ type: 'createPlayer', player: p });
          goTab('HOME');
        }}
      />
    );
  } else if (overlay?.kind === 'PRACTICE' && !paused) {
    content = (
      <PracticeSession
        practiceCode={overlay.code}
        today={today}
        onSave={(record) => dispatch({ type: 'recordPractice', record })}
        onClose={() => setOverlay(overlay.from)}
      />
    );
  } else if (overlay?.kind === 'STATION' && !paused) {
    const progress = model.journey.stations.find((s) => s.station.id === overlay.id)!;
    content = (
      <StationScreen
        progress={progress}
        records={state.practices}
        onPractice={openPractice}
        onDeclareTeach={() => dispatch({ type: 'declareTeach', stationId: overlay.id })}
        onShareService={() => dispatch({ type: 'shareService' })}
        onBack={() => goTab('JOURNEY')}
      />
    );
  } else if (tab === 'JOURNEY' && !paused) {
    content = <JourneyScreen journey={model.journey} onOpenStation={openStation} />;
  } else if (tab === 'AVATAR' && !paused) {
    content = state.player ? (
      <AvatarDashboardScreen
        hideHelpButton
        player={{ name: state.player.profile.displayName, archetype: state.player.profile.archetype }}
        index={computeWellbeingIndex([], { date: today, ageYears: Number(today.slice(0, 4)) - state.player.profile.birthYear })}
        safety={{ mode: model.safety.gamificationMode, crisis: false, resources: resourcesFor(), requiresSafetyScreen: false }}
        onRequestHelp={() => dispatch({ type: 'requestHelp' })}
        onContactCareTeam={() => undefined}
        onSafetyAnswer={() => undefined}
        onStartQuest={() => undefined}
        footer={
          <>
            <Card>
              <Meter label="Energía" value={model.bars.energy} color={theme.color.primary} />
              <Meter label="Ánimo" value={model.bars.mood} color={theme.color.info} />
            </Card>
            <EquipmentShelf gear={model.journey.gear} />
          </>
        }
      />
    ) : (
      <View style={styles.pad}>
        <Card tone="accent">
          <Text style={kit.strong}>Aún no tienes personaje</Text>
          <Text style={kit.body}>Créalo para ver tu avatar, tus atributos y tu equipo.</Text>
          <Button label="Crear mi personaje" onPress={() => setOverlay({ kind: 'ONBOARDING' })} />
        </Card>
        <EquipmentShelf gear={model.journey.gear} />
      </View>
    );
  } else {
    content = (
      <HomeScreen
        model={model}
        playerName={state.player?.profile.displayName ?? null}
        isDemo={state.isDemo}
        hasPlayer={!!state.player}
        onCreatePlayer={() => setOverlay({ kind: 'ONBOARDING' })}
        onExploreDemo={() => dispatch({ type: 'load', state: demoState(today) })}
        onCheckIn={(entry) => dispatch({ type: 'checkIn', entry })}
        onPractice={openPractice}
        onOpenStation={openStation}
        onGoJourney={() => goTab('JOURNEY')}
        onCloseHelp={() => dispatch({ type: 'closeHelp' })}
      />
    );
  }

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.frame}>
        <View style={styles.topBar}>
          <Pressable onPress={() => goTab('HOME')} accessibilityRole="button" accessibilityLabel="Ir al inicio">
            <Text style={styles.brand}>SIFUS <Text style={styles.brandSoft}>· Aurora</Text></Text>
          </Pressable>
          <View style={styles.topActions}>
            {(state.player || state.isDemo) && overlay === null && (
              <Pressable onPress={() => dispatch({ type: 'reset' })} accessibilityRole="button" hitSlop={8}>
                <Text style={styles.reset}>Reiniciar</Text>
              </Pressable>
            )}
            <HelpButton onPress={() => { goTab('HOME'); dispatch({ type: 'requestHelp' }); }} />
          </View>
        </View>

        <View style={{ flex: 1 }}>{content}</View>

        {overlay?.kind !== 'ONBOARDING' && (
          <View style={styles.tabBar} accessibilityRole="tablist">
            {TABS.map((t) => {
              const active = overlay === null ? tab === t.key : t.key === 'JOURNEY';
              return (
                <Pressable key={t.key} onPress={() => goTab(t.key)} style={styles.tab}
                  accessibilityRole="tab" accessibilityState={{ selected: active }}>
                  <Text style={{ fontSize: 20 }}>{t.icon}</Text>
                  <Text style={[styles.tabLabel, active && styles.tabActive]}>{t.label}</Text>
                </Pressable>
              );
            })}
          </View>
        )}
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: theme.color.bg },
  // En el navegador la app se centra con ancho de tableta.
  frame: { flex: 1, width: '100%', maxWidth: 760, alignSelf: 'center', backgroundColor: theme.color.bg },
  pad: { padding: theme.space(5), gap: theme.space(3) },
  topBar: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingHorizontal: theme.space(4), paddingVertical: theme.space(2), borderBottomWidth: 1, borderBottomColor: theme.color.border, gap: theme.space(2) },
  brand: { fontSize: 20, fontWeight: '900', color: theme.color.primary },
  brandSoft: { color: theme.color.accent, fontWeight: '700' },
  topActions: { flexDirection: 'row', alignItems: 'center', gap: theme.space(3) },
  reset: { color: theme.color.inkSoft, fontSize: theme.font.small, textDecorationLine: 'underline' },
  tabBar: { flexDirection: 'row', borderTopWidth: 1, borderTopColor: theme.color.border, backgroundColor: theme.color.surface },
  tab: { flex: 1, alignItems: 'center', paddingVertical: theme.space(2), gap: 2 },
  tabLabel: { fontSize: 12, color: theme.color.inkSoft, fontWeight: '600' },
  tabActive: { color: theme.color.primary, fontWeight: '800' },
});
