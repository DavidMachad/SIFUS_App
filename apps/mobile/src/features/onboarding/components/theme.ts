/** Paleta cálida y de alto contraste (WCAG AA). Sin rojos de "alarma" en datos personales. */
export const theme = {
  color: {
    bg: '#FBF8F3',
    surface: '#FFFFFF',
    ink: '#1F2A2E',
    inkSoft: '#56656B',
    primary: '#2F6F5E', // verde bosque: crecimiento
    primarySoft: '#DCEDE7',
    accent: '#C9822B', // ámbar: logro
    accentSoft: '#F6E7D2',
    info: '#3A5F8A',
    infoSoft: '#E3ECF6',
    border: '#E3DED5',
    error: '#9A3B2E',
  },
  radius: { sm: 8, md: 14, lg: 22 },
  space: (n: number) => n * 4,
  font: { title: 26, subtitle: 18, body: 16, small: 13 },
} as const;
