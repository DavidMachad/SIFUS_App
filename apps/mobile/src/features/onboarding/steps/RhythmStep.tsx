import React from 'react';
import { StyleSheet, View } from 'react-native';
import { FieldMessage } from '../components/FieldMessage';
import { InfoNote } from '../components/InfoNote';
import { NumberField } from '../components/NumberField';
import { ScalePicker } from '../components/ScalePicker';
import { theme } from '../components/theme';
import type { StepProps } from './types';

const stressWord = (v: number) => (v <= 3 ? 'bajo' : v <= 5 ? 'moderado' : v <= 7 ? 'elevado' : 'alto');

/** Capítulo 2 · Ritmo vital: sueño, estrés e hidratación (anamnesis fisiológica). */
export function RhythmStep({ draft, dispatch, validation: v }: StepProps) {
  const set = (patch: Partial<typeof draft>) => dispatch({ type: 'set', patch });
  return (
    <View style={styles.gap}>
      <NumberField
        label="¿Cuántas horas duermes en una noche habitual?"
        unit="horas"
        value={draft.sleepHoursNight}
        onChange={(sleepHoursNight) => set({ sleepHoursNight })}
        placeholder="7"
        error={v.errors.sleepHoursNight}
        warning={v.warnings.sleepHoursNight}
      />
      <ScalePicker
        label="¿Qué tan reparador sientes tu sueño?"
        min={1}
        max={5}
        value={draft.sleepQuality}
        onChange={(sleepQuality) => set({ sleepQuality })}
        minLabel="Nada reparador"
        maxLabel="Muy reparador"
      />

      <ScalePicker
        label="En las últimas semanas, ¿cuánto estrés has sentido?"
        min={1}
        max={10}
        value={draft.perceivedStress}
        onChange={(perceivedStress) => set({ perceivedStress })}
        minLabel="Muy poco"
        maxLabel="Muchísimo"
        describe={(n) => `${n}: estrés ${stressWord(n)}`}
      />
      <FieldMessage error={v.errors.perceivedStress} />
      <InfoNote title="¿Por qué importa el estrés para entrenar?">
        Cuando el estrés se sostiene, el cuerpo mantiene elevado el cortisol, una hormona que dificulta la recuperación
        muscular. Por eso, en tus días más cargados, el juego no te pedirá más esfuerzo: te propondrá misiones de
        recuperación. Reconocer cómo estás es el primer paso del entrenamiento.
      </InfoNote>

      <NumberField
        label="¿Cuánta agua tomas al día, aproximadamente?"
        unit="litros"
        value={draft.waterIntakeLiters}
        onChange={(waterIntakeLiters) => set({ waterIntakeLiters })}
        placeholder="1,5"
        hint="Opcional. Un vaso grande son unos 0,25 litros."
        error={v.errors.waterIntakeLiters}
      />
    </View>
  );
}

const styles = StyleSheet.create({ gap: { gap: theme.space(5) } });
