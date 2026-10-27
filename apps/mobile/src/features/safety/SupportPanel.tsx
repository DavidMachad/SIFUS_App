import React from 'react';
import { Linking, Pressable, StyleSheet, Text, View } from 'react-native';
import type { CrisisResource } from '@sifus/core';
import { theme } from '../onboarding/components/theme';

/** Convierte "192, opción 4" en un enlace tel: marcable (solo los dígitos iniciales). */
const telHref = (contact: string) => {
  const m = /^\+?[\d\s]+/.exec(contact);
  return m ? `tel:${m[0].replace(/\s/g, '')}` : null;
};

/**
 * Panel de apoyo (modo SUPPORT del panel principal y nivel CRISIS).
 * Lenguaje humano, sin términos de juego, sin números de índice. Emergencias
 * primero; luego líneas de salud mental; luego el equipo SIFUS.
 */
export function SupportPanel({ resources, crisis, onContactCareTeam }: {
  resources: CrisisResource[];
  crisis: boolean;
  onContactCareTeam: () => void;
}) {
  return (
    <View style={styles.card} accessibilityLiveRegion="polite">
      <Text style={styles.title} accessibilityRole="header">
        {crisis ? 'No estás solo/a. Busquemos ayuda ahora.' : 'Estamos contigo'}
      </Text>
      <Text style={styles.body}>
        {crisis
          ? 'Si estás en peligro inmediato, llama a la línea de emergencias. También puedes hablar ahora con una línea de salud mental.'
          : 'Notamos que estos días han sido difíciles. Por ahora pausamos los retos del juego: lo importante eres tú. Estas personas pueden acompañarte.'}
      </Text>
      {resources.map((r) => {
        const href = r.kind === 'CARE_TEAM' ? null : telHref(r.contact);
        return (
          <Pressable
            key={r.id}
            onPress={() => (r.kind === 'CARE_TEAM' ? onContactCareTeam() : href && Linking.openURL(href))}
            style={[styles.resource, r.kind === 'EMERGENCY' && styles.emergency]}
            accessibilityRole={href ? 'link' : 'button'}
            accessibilityLabel={`${r.name}: ${r.contact}. ${r.available}`}
          >
            <Text style={styles.resName}>{r.name}</Text>
            <Text style={styles.resContact}>{r.contact} · {r.available}</Text>
          </Pressable>
        );
      })}
      <Text style={styles.note}>Tu equipo SIFUS ya fue avisado si así lo autorizaste. Te contactarán pronto.</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: theme.color.surface, borderRadius: theme.radius.lg, padding: theme.space(5), gap: theme.space(3), borderWidth: 1.5, borderColor: theme.color.info },
  title: { fontSize: theme.font.title, fontWeight: '800', color: theme.color.ink },
  body: { fontSize: theme.font.body, color: theme.color.ink, lineHeight: 22 },
  resource: { padding: theme.space(4), borderRadius: theme.radius.md, backgroundColor: theme.color.infoSoft, gap: 2 },
  emergency: { backgroundColor: theme.color.accentSoft, borderWidth: 1.5, borderColor: theme.color.accent },
  resName: { fontWeight: '700', color: theme.color.ink, fontSize: theme.font.body },
  resContact: { color: theme.color.inkSoft, fontSize: theme.font.small },
  note: { fontSize: theme.font.small, color: theme.color.inkSoft },
});
