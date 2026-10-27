import React, { useState } from 'react';
import { SafeAreaView, Text } from 'react-native';
import { CharacterCreatorScreen } from '../features/onboarding/CharacterCreatorScreen';
import type { OnboardingPayload } from '../features/onboarding/state/payload';

const API_URL = process.env.EXPO_PUBLIC_API_URL ?? 'http://localhost:3000';

async function submitOnboarding(payload: OnboardingPayload): Promise<void> {
  const res = await fetch(`${API_URL}/onboarding`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error(`No pudimos guardar tu personaje (${res.status}). Intenta de nuevo.`);
}

export default function App() {
  const [done, setDone] = useState(false);
  return (
    <SafeAreaView style={{ flex: 1 }}>
      {done ? (
        <Text style={{ padding: 24, fontSize: 18 }}>¡Tu aventura comienza hoy! (Siguiente: pantalla de Misiones del Día)</Text>
      ) : (
        <CharacterCreatorScreen onComplete={async (p) => { await submitOnboarding(p); setDone(true); }} />
      )}
    </SafeAreaView>
  );
}
