import React, { useState } from 'react';
import { SafeAreaView } from 'react-native';
import { computeWellbeingIndex, resourcesFor, type GamificationMode } from '@sifus/core';
import { AvatarDashboardScreen } from '../features/dashboard/AvatarDashboardScreen';
import { CharacterCreatorScreen } from '../features/onboarding/CharacterCreatorScreen';
import type { OnboardingPayload } from '../features/onboarding/state/payload';

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

export default function App() {
  const [player, setPlayer] = useState<OnboardingPayload | null>(null);
  const [mode, setMode] = useState<GamificationMode>('FULL');
  const [crisis, setCrisis] = useState(false);

  if (!player) {
    return (
      <SafeAreaView style={{ flex: 1 }}>
        <CharacterCreatorScreen onComplete={async (p) => { await submitOnboarding(p); setPlayer(p); }} />
      </SafeAreaView>
    );
  }

  const today = new Date().toISOString().slice(0, 10);
  // Recién creado el personaje aún no hay instrumentos: el índice queda "por descubrir".
  const index = computeWellbeingIndex([], { date: today, ageYears: Number(today.slice(0, 4)) - player.profile.birthYear });

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <AvatarDashboardScreen
        player={{ name: player.profile.displayName, archetype: player.profile.archetype }}
        index={index}
        safety={{ mode, crisis, resources: mode === 'PAUSED' ? resourcesFor() : [], requiresSafetyScreen: false }}
        onRequestHelp={() => { setMode('PAUSED'); setCrisis(true); }}
        onContactCareTeam={() => undefined}
        onSafetyAnswer={() => undefined}
        onStartQuest={() => undefined}
      />
    </SafeAreaView>
  );
}
