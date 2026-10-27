import React, { useReducer, useState } from 'react';
import { StepShell } from './components/StepShell';
import { draftReducer, initialDraft, type CharacterDraft } from './state/characterDraft';
import { toOnboardingPayload, type OnboardingPayload } from './state/payload';
import { validateStep, type StepId } from './state/validation';
import { BodyStatsStep } from './steps/BodyStatsStep';
import { HistoryStep } from './steps/HistoryStep';
import { IdentityStep } from './steps/IdentityStep';
import { JourneyStep } from './steps/JourneyStep';
import { LoreStep } from './steps/LoreStep';
import { RhythmStep } from './steps/RhythmStep';
import { SummaryStep } from './steps/SummaryStep';
import type { StepProps } from './steps/types';

interface StepDef {
  id: StepId;
  title: string;
  subtitle: string;
  Component: React.ComponentType<StepProps>;
  /** Si existe, el capítulo se puede posponer (se vuelve misión secundaria). */
  skipPatch?: Partial<CharacterDraft>;
}

const STEPS: StepDef[] = [
  { id: 'identity', title: '¿Quién es tu personaje?', subtitle: 'Toda gran historia empieza con un nombre. No hay forma correcta de ser.', Component: IdentityStep },
  { id: 'rhythm', title: 'Tu ritmo vital', subtitle: 'Cómo descansas y cómo te sientes cambia lo que tu cuerpo necesita. Aquí no hay respuestas malas.', Component: RhythmStep },
  { id: 'journey', title: 'Tu historial de aventuras', subtitle: 'Cada punto de partida es válido. Ajustaremos las misiones a tu realidad.', Component: JourneyStep },
  { id: 'history', title: 'Cicatrices y hábitos', subtitle: 'Tu historia también es parte de tu fuerza. Nos ayuda a cuidarte mientras avanzas.', Component: HistoryStep },
  { id: 'body', title: 'Atributos de tu cuerpo', subtitle: 'Tu punto de partida, para compararte solo contigo.', Component: BodyStatsStep, skipPatch: { measurementMode: 'LATER' } },
  { id: 'lore', title: 'Tu lore', subtitle: 'Tu propósito y tus fortalezas guían la historia que vas a escribir.', Component: LoreStep, skipPatch: {} },
  { id: 'summary', title: 'Tu personaje está listo', subtitle: 'Este es tu punto de partida. Desde aquí, todo es avance.', Component: SummaryStep },
];

interface Props {
  /** Envía el payload al backend (POST /onboarding). */
  onComplete: (payload: OnboardingPayload) => Promise<void>;
}

/**
 * Creador de Personaje: reemplaza el formulario clínico de anamnesis por la
 * creación de un perfil de jugador, recolectando los mismos datos con rigor
 * (rangos plausibles, protocolo ISAK, fuente de la medición).
 */
export function CharacterCreatorScreen({ onComplete }: Props) {
  const [draft, dispatch] = useReducer(draftReducer, initialDraft);
  const [index, setIndex] = useState(0);
  const [attempted, setAttempted] = useState<Set<StepId>>(new Set());
  const [submitting, setSubmitting] = useState(false);

  const step = STEPS[index]!;
  const full = validateStep(step.id, draft);
  // Avisos siempre visibles; errores solo tras intentar avanzar (no regañar antes de tiempo).
  const shown = attempted.has(step.id) ? full : { errors: {}, warnings: full.warnings };
  const isLast = index === STEPS.length - 1;

  const goNext = async () => {
    if (Object.keys(full.errors).length > 0) {
      setAttempted((s) => new Set(s).add(step.id));
      return;
    }
    if (!isLast) return setIndex((i) => i + 1);
    setSubmitting(true);
    try {
      await onComplete(toOnboardingPayload(draft));
    } finally {
      setSubmitting(false);
    }
  };

  const skip = step.skipPatch
    ? () => {
        dispatch({ type: 'set', patch: step.skipPatch! });
        setIndex((i) => i + 1);
      }
    : undefined;

  const { Component } = step;
  return (
    <StepShell
      chapter={`Capítulo ${index + 1} de ${STEPS.length}`}
      title={step.title}
      subtitle={step.subtitle}
      progress={(index + 1) / STEPS.length}
      canGoBack={index > 0}
      onBack={() => setIndex((i) => Math.max(0, i - 1))}
      onNext={goNext}
      onSkip={skip}
      nextLabel={isLast ? (submitting ? 'Creando…' : 'Comenzar mi aventura') : 'Continuar'}
      nextDisabled={submitting}
    >
      <Component draft={draft} dispatch={dispatch} validation={shown} />
    </StepShell>
  );
}
