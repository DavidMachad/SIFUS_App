import React, { useState } from 'react';
import { Text } from 'react-native';
import { NumberField } from '../onboarding/components/NumberField';
import { ScalePicker } from '../onboarding/components/ScalePicker';
import type { DailyCheckIn } from '../../app/store';
import { Button, Card, kit, SectionTitle } from '../../ui/kit';

/** Registro de hoy (≤ 30 s): sueño, estrés, energía y ánimo de 1 a 10. */
export function CheckInCard({ today, onSave }: { today: string; onSave: (c: DailyCheckIn) => void }) {
  const [sleepHours, setSleep] = useState<number>();
  const [perceivedStress, setStress] = useState<number>();
  const [energy, setEnergy] = useState<number>();
  const [mood, setMood] = useState<number>();
  const sleepOk = sleepHours !== undefined && sleepHours >= 0 && sleepHours <= 16;
  const ready = sleepOk && perceivedStress !== undefined && energy !== undefined && mood !== undefined;

  return (
    <Card tone="primary">
      <SectionTitle>¿Cómo llegas hoy?</SectionTitle>
      <Text style={kit.small}>Tu registro de 1 a 10 ajusta tus misiones y tus barras. Aquí no hay respuestas malas.</Text>
      <NumberField label="¿Cuántas horas dormiste anoche?" unit="horas" value={sleepHours} onChange={setSleep} placeholder="7"
        error={sleepHours !== undefined && !sleepOk ? 'Escribe un valor entre 0 y 16 horas' : undefined} />
      <ScalePicker label="Estrés" min={1} max={10} value={perceivedStress} onChange={setStress} minLabel="Muy poco" maxLabel="Muchísimo" />
      <ScalePicker label="Energía" min={1} max={10} value={energy} onChange={setEnergy} minLabel="Agotado/a" maxLabel="Con mucha energía" />
      <ScalePicker label="Ánimo" min={1} max={10} value={mood} onChange={setMood} minLabel="Muy bajo" maxLabel="Muy bueno" />
      <Button label="Guardar mi registro" disabled={!ready}
        onPress={() => onSave({ date: today, sleepHours: sleepHours!, perceivedStress: perceivedStress!, energy: energy!, mood: mood! })} />
    </Card>
  );
}
