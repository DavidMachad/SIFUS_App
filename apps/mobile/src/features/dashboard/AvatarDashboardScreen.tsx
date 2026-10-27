import React, { useMemo, useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { COMPONENTS, type CrisisResource, type GamificationMode, type WellbeingIndexResult } from '@sifus/core';
import { theme } from '../onboarding/components/theme';
import { HelpButton } from '../safety/HelpButton';
import { SafetyCheck } from '../safety/SafetyCheck';
import { SupportPanel } from '../safety/SupportPanel';
import { AttributeGrid } from './AttributeGrid';
import { Avatar } from './Avatar';
import { buildDashboardView, QUEST_FOR_COMPONENT, type AttributeView } from './dashboardModel';
import { LifeBar } from './LifeBar';

interface Props {
  player: { name: string; archetype: 'EXPLORER' | 'GUARDIAN' | 'SAGE' | 'ARTISAN' | 'WAYFARER' };
  index: WellbeingIndexResult | null;
  safety: { mode: GamificationMode; crisis: boolean; resources: CrisisResource[]; requiresSafetyScreen: boolean };
  onRequestHelp: () => void;
  onContactCareTeam: () => void;
  onSafetyAnswer: (v: 0 | 1 | 2 | 3 | 'DECLINED') => void;
  onStartQuest: (key: string) => void;
}

/**
 * Panel principal: Avatar + barra de vida (Índice 0–100) + 5 atributos.
 * Con bandera roja ELEVATED/CRISIS, el apoyo humano reemplaza al juego.
 */
export function AvatarDashboardScreen(p: Props) {
  const view = useMemo(() => buildDashboardView(p.index, p.safety.mode), [p.index, p.safety.mode]);
  const [selected, setSelected] = useState<AttributeView | null>(null);
  const domain = selected ? p.index?.domains.find((d) => d.domain === selected.domain) : undefined;

  return (
    <ScrollView contentContainerStyle={styles.root}>
      <HelpButton onPress={p.onRequestHelp} />

      {view.mode === 'SUPPORT' ? (
        <>
          {p.safety.requiresSafetyScreen && <SafetyCheck onAnswer={p.onSafetyAnswer} />}
          <SupportPanel resources={p.safety.resources} crisis={p.safety.crisis} onContactCareTeam={p.onContactCareTeam} />
        </>
      ) : (
        <>
          <Avatar archetype={p.player.archetype} name={p.player.name} tone={view.bar.tone} onPress={() => setSelected(view.attributes[0] ?? null)} />
          <LifeBar value={view.bar.value} tone={view.bar.tone} caption={view.bar.caption} />
          <AttributeGrid attributes={view.attributes} onSelect={setSelected} />

          {selected && domain && (
            <View style={styles.detail}>
              <Text style={styles.detailTitle}>{selected.emoji} {selected.label}</Text>
              {domain.components.map((c) => (
                <Text key={c.key} style={styles.detailRow}>• {COMPONENTS[c.key].rationale} → {Math.round(c.normalized)}</Text>
              ))}
              {domain.missing.map((k) => (
                <Text key={k} style={styles.detailMissing}>○ {QUEST_FOR_COMPONENT[k].title}</Text>
              ))}
              <Pressable onPress={() => setSelected(null)} accessibilityRole="button"><Text style={styles.link}>Cerrar</Text></Pressable>
            </View>
          )}

          {view.quests.length > 0 && (
            <View style={styles.quests}>
              <Text style={styles.section}>Misiones para conocerte mejor</Text>
              {view.quests.map((q) => (
                <Pressable key={q.key} onPress={() => p.onStartQuest(q.key)} style={styles.quest} accessibilityRole="button">
                  <Text style={styles.questTitle}>{q.title}</Text>
                  {q.minutes && <Text style={styles.questMeta}>{q.minutes} min</Text>}
                </Pressable>
              ))}
            </View>
          )}
          {p.index && p.index.confidence < 0.6 && view.bar.value !== null && (
            <Text style={styles.confidence}>Tu barra se basa en información parcial ({Math.round(p.index.confidence * 100)} %). Se vuelve más precisa con cada misión de evaluación.</Text>
          )}
        </>
      )}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  root: { padding: theme.space(5), gap: theme.space(4), backgroundColor: theme.color.bg },
  section: { fontSize: theme.font.subtitle, fontWeight: '700', color: theme.color.ink },
  detail: { backgroundColor: theme.color.surface, borderRadius: theme.radius.md, padding: theme.space(4), gap: theme.space(1), borderWidth: 1, borderColor: theme.color.primary },
  detailTitle: { fontWeight: '700', fontSize: theme.font.body, color: theme.color.ink, marginBottom: theme.space(1) },
  detailRow: { fontSize: theme.font.small, color: theme.color.ink },
  detailMissing: { fontSize: theme.font.small, color: theme.color.inkSoft },
  link: { color: theme.color.primary, marginTop: theme.space(2) },
  quests: { gap: theme.space(2) },
  quest: { flexDirection: 'row', justifyContent: 'space-between', padding: theme.space(3), borderRadius: theme.radius.md, backgroundColor: theme.color.primarySoft },
  questTitle: { color: theme.color.ink, fontWeight: '600', flexShrink: 1 },
  questMeta: { color: theme.color.inkSoft, fontSize: theme.font.small },
  confidence: { fontSize: theme.font.small, color: theme.color.inkSoft },
});
