import React from 'react';
import { Pressable, StyleSheet, Text } from 'react-native';
import { theme } from '../onboarding/components/theme';

/**
 * "Necesito ayuda ahora": visible en TODAS las pantallas y modos. Un toque
 * activa el nivel CRISIS del protocolo (recursos + aviso al equipo de cuidado
 * si la persona lo autorizó). No pide confirmaciones ni explicaciones.
 */
export function HelpButton({ onPress }: { onPress: () => void }) {
  return (
    <Pressable
      onPress={onPress}
      style={styles.btn}
      accessibilityRole="button"
      accessibilityLabel="Necesito ayuda ahora"
      accessibilityHint="Muestra líneas de ayuda y avisa a tu equipo de cuidado"
      hitSlop={8}
    >
      <Text style={styles.text}>Necesito ayuda ahora</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  btn: { alignSelf: 'flex-end', paddingVertical: theme.space(2), paddingHorizontal: theme.space(3), borderRadius: 999, backgroundColor: theme.color.infoSoft, borderWidth: 1, borderColor: theme.color.info },
  text: { color: theme.color.info, fontWeight: '700', fontSize: theme.font.small },
});
