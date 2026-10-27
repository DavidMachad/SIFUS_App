import { supportBand, type MspssSubscales, type SupportBand } from '../instruments/mspss';

/**
 * Asignación a gremios basada en el MSPSS (Zimet et al., 1988).
 * El perfil de apoyo por fuente (familia, amigos, otra persona significativa)
 * orienta QUÉ tipo de tejido conviene fortalecer:
 *  - Apoyo global bajo → grupo pequeño facilitado por un profesional SIFUS.
 *  - Amigos bajo       → gremio de pares en su propio entorno (aula, oficina, barrio).
 *  - Familia bajo      → retos que se pueden hacer con otras personas cercanas
 *                        o un mentor par.
 *  - Apoyo alto        → puede ser mentor/a de otras personas (rol protector).
 * La asignación es una sugerencia; la persona decide.
 */
export type GuildType = 'EDUCATIONAL' | 'WORKPLACE' | 'COMMUNITY' | 'SHARED_BARRIER';
export type Setting = 'EDUCATIONAL' | 'WORKPLACE' | 'COMMUNITY' | 'HEALTHCARE';

export interface GuildRecommendation {
  guildType: GuildType;
  facilitation: 'FACILITATOR_LED' | 'PEER_WITH_MENTOR' | 'PEER';
  suggestedRole: 'MEMBER' | 'MENTOR';
  anonymous: boolean;
  maxSize: number;
  supportProfile: Record<keyof MspssSubscales | 'total', SupportBand>;
  rationale: string;
  suggestedQuests: string[];
}

const settingToGuild = (s: Setting): GuildType => (s === 'HEALTHCARE' ? 'COMMUNITY' : s);

export function recommendGuild(input: {
  mspss: MspssSubscales & { total: number };
  setting: Setting;
  sharedBarrier?: string; // p. ej. 'PAIN_OR_CONDITION', 'CARE_DUTIES'
}): GuildRecommendation {
  const { mspss } = input;
  const profile = {
    total: supportBand(mspss.total),
    family: supportBand(mspss.family),
    friends: supportBand(mspss.friends),
    significantOther: supportBand(mspss.significantOther),
  };

  if (profile.total === 'LOW') {
    return {
      guildType: input.sharedBarrier ? 'SHARED_BARRIER' : settingToGuild(input.setting),
      facilitation: 'FACILITATOR_LED', suggestedRole: 'MEMBER', anonymous: Boolean(input.sharedBarrier), maxSize: 8,
      supportProfile: profile,
      rationale: 'Un grupo pequeño y acompañado por el equipo SIFUS para empezar a tejer red con calma.',
      suggestedQuests: ['RECOVERY_MISSIONS', 'ENCOURAGEMENTS_SENT', 'ACTIVE_MINUTES'],
    };
  }
  if (input.sharedBarrier === 'PAIN_OR_CONDITION' || input.sharedBarrier === 'CARE_DUTIES') {
    return {
      guildType: 'SHARED_BARRIER', facilitation: 'PEER_WITH_MENTOR', suggestedRole: 'MEMBER', anonymous: true, maxSize: 10,
      supportProfile: profile,
      rationale: 'Personas que viven una barrera parecida a la tuya, con alias si lo prefieres.',
      suggestedQuests: ['ACTIVE_MINUTES', 'LORE_ENTRIES'],
    };
  }
  if (profile.friends === 'LOW' || profile.family === 'LOW') {
    return {
      guildType: settingToGuild(input.setting), facilitation: 'PEER_WITH_MENTOR', suggestedRole: 'MEMBER', anonymous: false, maxSize: 12,
      supportProfile: profile,
      rationale: profile.friends === 'LOW'
        ? 'Un gremio con personas de tu propio entorno para moverse juntos.'
        : 'Retos que puedes compartir con otras personas cercanas, con un mentor par que acompaña.',
      suggestedQuests: ['WALK_TOGETHER', 'ACTIVE_MINUTES'],
    };
  }
  return {
    guildType: settingToGuild(input.setting), facilitation: 'PEER',
    suggestedRole: profile.total === 'HIGH' ? 'MENTOR' : 'MEMBER', anonymous: false, maxSize: 12,
    supportProfile: profile,
    rationale: profile.total === 'HIGH'
      ? 'Tu red de apoyo es fuerte: puedes ser mentor/a de otras personas que están empezando.'
      : 'Un gremio de tu entorno para sostener la constancia juntos.',
    suggestedQuests: ['ACTIVE_MINUTES', 'ENCOURAGEMENTS_SENT'],
  };
}
