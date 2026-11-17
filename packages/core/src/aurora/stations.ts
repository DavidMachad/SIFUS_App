/**
 * El viaje de Aurora — catálogo de estaciones (fuente: docs/MANIFIESTO_AURORA.md).
 *
 * Solo contiene lo que el manifiesto ya documenta. El libro tiene 21 prácticas;
 * aquí están las 15 nombradas en el manifiesto. Las demás llegarán con el texto
 * del autor (ver §4 «Lo que falta para seguir»): no se inventa contenido del libro.
 */

/** Dirección "deseable" del cambio en la medida 1–10. NEUTRAL: ningún valor es mejor (p. ej. qué eje estuvo activo). */
export type MeasureDirection = 'LOWER_IS_BETTER' | 'HIGHER_IS_BETTER' | 'NEUTRAL';

export interface AuroraMeasure {
  label: string;
  direction: MeasureDirection;
}

export interface AuroraPractice {
  code: string;
  name: string;
  /** Lo que la persona se califica de 1 a 10 antes y después. */
  measure: AuroraMeasure;
  /** Práctica de un minuto, disponible como «poción de acceso rápido». */
  quick?: boolean;
  /** Guía corta y genérica. El texto completo es del libro y está pendiente. */
  guide?: string;
}

export type GearKind = 'OBJECT' | 'EQUIPMENT' | 'HALO';

export interface AuroraGear {
  id: string;
  name: string;
  kind: GearKind;
  /** Qué representa en la vida real. */
  meaning: string;
}

export interface AuroraStation {
  id: number;
  part: 1 | 2 | 3;
  title: string;
  story: string;
  idea: string;
  practices: AuroraPractice[];
  gear: AuroraGear[];
}

export interface AuroraPart {
  id: 1 | 2 | 3;
  title: string;
  tagline: string;
}

export const AURORA_MOTTO = 'Hay que estar bien para poder servir.';

/** Total de prácticas del libro (manifiesto §1). */
export const AURORA_PRACTICES_IN_BOOK = 21;

export const AURORA_PARTS: AuroraPart[] = [
  { id: 1, title: 'Reconocer el caos', tagline: 'Aprender a notar lo que pasa por dentro.' },
  { id: 2, title: 'Transformar', tagline: 'Convertir lo que notaste en hábitos que te sostienen.' },
  { id: 3, title: 'Sostener y servir', tagline: 'Ya equipado, cuidar a otros sin dejar de cuidarte.' },
];

/** Los cinco pasos de cada estación. */
export const AURORA_STEPS = [
  { key: 'ATTEND', title: 'Atender', inApp: 'Un relato breve para empezar la estación' },
  { key: 'UNDERSTAND', title: 'Comprender', inApp: 'Una explicación corta, con las fuentes a la vista' },
  { key: 'EXPERIENCE', title: 'Experimentar', inApp: 'La práctica guiada, con su registro antes y después' },
  { key: 'REPEAT', title: 'Repetir', inApp: 'La misión de 7 días y su curva personal' },
  { key: 'INTEGRATE', title: 'Integrar', inApp: 'La entrada de lore y el cierre de la estación' },
] as const;

const tension: AuroraMeasure = { label: 'Tensión', direction: 'LOWER_IS_BETTER' };
const presence: AuroraMeasure = { label: 'Presencia', direction: 'HIGHER_IS_BETTER' };
const energy: AuroraMeasure = { label: 'Energía', direction: 'HIGHER_IS_BETTER' };
const sustainedIntention: AuroraMeasure = { label: 'Qué tanto se sostuvo la intención', direction: 'HIGHER_IS_BETTER' };
const accompanying: AuroraMeasure = { label: 'Cómo me sentí acompañando', direction: 'HIGHER_IS_BETTER' };

export const AURORA_STATIONS: AuroraStation[] = [
  {
    id: 1, part: 1, title: 'Respiración',
    story: 'Descubrir en el pilates y el yoga que respirar da fuerza; el niño que «atrapó el viento con la nariz».',
    idea: 'La respiración es el control remoto del sistema nervioso.',
    practices: [
      { code: 'S1_BREATH_4_6', name: 'Respiración 4-6', measure: tension, quick: true,
        guide: 'Inhala por la nariz contando 4 y exhala despacio contando 6. Repite durante un minuto.' },
      { code: 'S1_RECOGNIZE', name: 'Reconocer', measure: tension },
    ],
    gear: [
      { id: 'AIR_THREAD', name: 'Hilo de aire', kind: 'OBJECT', meaning: 'Tu respiración como recurso' },
    ],
  },
  {
    id: 2, part: 1, title: 'Percepción',
    story: 'El charco: el primo que lo salvó de ahogarse.',
    idea: 'No vemos el mundo como es, sino como nuestro estado lo permite.',
    practices: [
      { code: 'S2_SUBTRACTION', name: 'La resta', measure: presence },
      { code: 'S2_FIRST_TIME_SENSES', name: 'Los sentidos como primera vez', measure: presence, quick: true,
        guide: 'Escaneo del instante: nombra algo que ves, algo que oyes y algo que sientes en el cuerpo, como si fuera la primera vez.' },
    ],
    gear: [
      { id: 'HELMET', name: 'Casco', kind: 'EQUIPMENT', meaning: 'Percepción: el lente que comprende' },
    ],
  },
  {
    id: 3, part: 1, title: 'Clima emocional',
    story: 'Dos años de encierro; la lentejuela en el mueble; el niño sin mamá.',
    idea: 'Ninguna emoción es enemiga; lo que daña es quedarse atrapado.',
    practices: [
      { code: 'S3_COMPASS', name: 'La brújula', measure: { label: 'Intensidad de la emoción', direction: 'NEUTRAL' } },
      { code: 'S3_SOUL_BAROMETER', name: 'Barómetro del alma', measure: { label: 'Ánimo', direction: 'HIGHER_IS_BETTER' } },
    ],
    gear: [
      { id: 'SHIELD', name: 'Escudo', kind: 'EQUIPMENT', meaning: 'Regulación emocional' },
      { id: 'COMPASS', name: 'Brújula', kind: 'OBJECT', meaning: 'Orientarte dentro de tus emociones' },
    ],
  },
  {
    id: 4, part: 2, title: 'Metabolismo',
    story: 'La gimnasia, las lesiones y comer en ollas; Óscar, el maestro de 60 años.',
    idea: 'El metabolismo es el fuego que permite servir; la dosis es personal.',
    practices: [
      { code: 'S4_FUNCTIONAL_EVAL', name: 'Evaluación funcional', measure: energy },
    ],
    gear: [
      { id: 'ARMOR', name: 'Armadura', kind: 'EQUIPMENT', meaning: 'Estructura: fuerza y músculo funcional' },
    ],
  },
  {
    id: 5, part: 2, title: 'Hábito y ocio',
    story: 'La universidad que rechazaba y terminó dando vida; cambiar el vapeo por zanahoria.',
    idea: 'Cada acción es un paso en el sendero; el ocio es campo fértil.',
    practices: [
      { code: 'S5_LEISURE_MANDALA', name: 'Mandala del ocio', measure: { label: 'Energía que deja la actividad', direction: 'HIGHER_IS_BETTER' } },
      { code: 'S5_BEAN_JARS', name: 'Frascos de fríjoles', measure: { label: 'Energía que deja la actividad', direction: 'HIGHER_IS_BETTER' } },
    ],
    gear: [
      { id: 'SHOES', name: 'Zapatos', kind: 'EQUIPMENT', meaning: 'Hábitos: el sendero que se hace caminando' },
      { id: 'SEED', name: 'Semilla', kind: 'OBJECT', meaning: 'Lo pequeño que, sostenido, crece' },
    ],
  },
  {
    id: 6, part: 2, title: 'Los dos ejes',
    story: 'Fábula: el niño que quería ser héroe.',
    idea: 'La vida tiene un eje horizontal (tiempo) y uno vertical (profundidad).',
    practices: [
      { code: 'S6_LIFELINE', name: 'Línea de vida', measure: { label: 'Eje más activo del día', direction: 'NEUTRAL' } },
      { code: 'S6_NIGHT_QUESTIONS', name: 'Tres preguntas nocturnas', measure: { label: 'Eje más activo del día', direction: 'NEUTRAL' } },
    ],
    gear: [],
  },
  {
    id: 7, part: 3, title: 'Intención',
    story: 'La infancia, el padre y la promesa a la madre a los 12 años.',
    idea: 'Un deseo se enciende; una intención se sostiene; un hábito la vuelve materia.',
    practices: [
      { code: 'S7_MORNING_INTENTION', name: 'Intención matinal', measure: sustainedIntention },
      { code: 'S7_ATTEMPTS_NOTEBOOK', name: 'Libreta de intentos', measure: sustainedIntention },
    ],
    gear: [
      { id: 'WEAPON', name: 'Arma', kind: 'EQUIPMENT', meaning: 'La intención que dirige la energía del día' },
    ],
  },
  {
    id: 8, part: 3, title: 'Comunidad',
    story: 'Cuidar a la abuela; visitar hospitales.',
    idea: 'Cuidarte es fortalecer el eslabón que sostiene a los tuyos.',
    practices: [
      { code: 'S8_VISIT_REALITY', name: 'Visitar la realidad', measure: accompanying },
      { code: 'S8_BE_CONTAINER', name: 'Ser contenedor', measure: accompanying },
    ],
    gear: [
      { id: 'COMPANION', name: 'Mascota que acompaña', kind: 'EQUIPMENT', meaning: 'Comunidad: nadie juega solo' },
      { id: 'SERVICE_HALO', name: 'Halo de servicio', kind: 'HALO', meaning: 'Crece cuando llevas una práctica a otra persona' },
    ],
  },
];

const PRACTICE_INDEX = new Map(
  AURORA_STATIONS.flatMap((s) => s.practices.map((p) => [p.code, { practice: p, station: s }] as const)),
);

export function findPractice(code: string): { practice: AuroraPractice; station: AuroraStation } | undefined {
  return PRACTICE_INDEX.get(code);
}

export function findStation(id: number): AuroraStation | undefined {
  return AURORA_STATIONS.find((s) => s.id === id);
}

export const AURORA_KNOWN_PRACTICES = AURORA_STATIONS.reduce((n, s) => n + s.practices.length, 0);
