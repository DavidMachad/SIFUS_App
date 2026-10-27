import React, { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { theme } from './theme';

/** "¿Por qué te preguntamos esto?": transparencia sobre el uso de cada dato. */
export function InfoNote({ title, children }: { title: string; children: string }) {
  const [open, setOpen] = useState(false);
  return (
    <View style={styles.box}>
      <Pressable onPress={() => setOpen((o) => !o)} accessibilityRole="button" accessibilityState={{ expanded: open }}>
        <Text style={styles.title}>{open ? '▾' : '▸'} {title}</Text>
      </Pressable>
      {open && <Text style={styles.body}>{children}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  box: { backgroundColor: theme.color.infoSoft, borderRadius: theme.radius.md, padding: theme.space(3) },
  title: { color: theme.color.info, fontWeight: '600', fontSize: theme.font.small },
  body: { color: theme.color.ink, fontSize: theme.font.small, marginTop: theme.space(2), lineHeight: 19 },
});
