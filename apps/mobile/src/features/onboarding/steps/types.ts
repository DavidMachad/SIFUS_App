import type { Dispatch } from 'react';
import type { CharacterDraft, DraftAction } from '../state/characterDraft';
import type { StepValidation } from '../state/validation';

export interface StepProps {
  draft: CharacterDraft;
  dispatch: Dispatch<DraftAction>;
  /** Solo se muestran después del primer intento de avanzar (no regañar antes de tiempo). */
  validation: StepValidation;
}
