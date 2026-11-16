# Aurora → App: lenguaje común y revisión por módulos

> Fuente: *Aurora — Lo esencial para el equipo de la app* (Arley Alexis Cano Jaramillo, 10 nov 2026).
> Propósito de este documento: que el equipo y el código hablen el mismo idioma que el libro, y llevar un
> registro de la revisión módulo por módulo de lo que ya está construido.

Regla de oro: **cuando el libro y el código no coinciden, manda el libro**, salvo en seguridad, privacidad
y rigor científico, donde se toma lo más exigente de los dos.

---

## 1. Glosario: del libro al código

| Término de Aurora | Qué significa en el libro | Lo que existe hoy en el código | Estado |
|---|---|---|---|
| **Estación** | Cada uno de los 8 capítulos del viaje (Respiración … Comunidad), agrupados en 3 partes | No existe | 🔴 Falta |
| **Práctica** | Ejercicio del libro que se vive en el cuerpo; 21 en total, cada una con su registro | "Misión" (`MissionTemplate`, 22 misiones genéricas que no salen del libro) | 🟠 Renombrar y reemplazar el contenido |
| **Práctica de 7 días** | La fase *Repetir*: 7 días con tabla de registro | No existe (las misiones son diarias y sueltas) | 🔴 Falta |
| **Registro 1 a 10** | Antes y después de cada práctica: tensión, ánimo, energía o presencia | Solo hay un check-in diario de estrés 1–10; nada antes/después de una práctica | 🔴 Falta (es el puente libro ↔ app) |
| **Cinco pasos** | Atender · Comprender · Experimentar · Repetir · Integrar | No existe como estructura | 🔴 Falta |
| **Niveles: Aprendiz · Practicante · Campeón** | Por práctica/capítulo; nunca se baja de nivel («el invierno también es parte del camino») | Niveles numéricos por capacidad a partir de XP (`skill-tree/progression.ts`); tampoco bajan | 🟠 Reemplazar el modelo |
| **Atributos** | Las 5 capacidades del cap. 4: fuerza, resistencia, velocidad, flexibilidad, coordinación. Suben con la evaluación funcional cada 4 semanas | 7 capacidades: fuerza, resistencia, movilidad, equilibrio, coordinación, agilidad, propiocepción | 🟠 Decidir |
| **Atributos base** | Vitalidad, Inteligencia, Fuerza, Destreza: de ellos dependen las barras | No existe | 🔴 Falta / decidir |
| **Rueda de equilibrio** | 4–5 capacidades en una rueda para ver cuál está más baja | No existe (hay 5 atributos del Índice de Vida en tarjetas) | 🟠 Adaptar |
| **Barra de vida** | Energía física: sueño, alimentación, movimiento (cap. 4) | "Índice de Vida 0–100" con 18 instrumentos | 🟠 Simplificar / decidir |
| **Barra de maná (barra azul)** | Atención y ánimo (caps. 2 y 3) | Dentro del mismo Índice de Vida (atributo Mente & Emoción) | 🟠 Separar |
| **Barra anímica** | Promedio semanal de ánimo y energía del registro 1–10 | No existe con esa fórmula | 🟠 Decidir |
| **Equipo (objetos simbólicos)** | Cada práctica completada desbloquea un objeto: «hilo de aire», «brújula», «semilla»… La constancia lo «refina» | No existe | 🔴 Falta |
| **Halo de servicio** | Crece cuando la persona lleva una práctica a otra (cap. 8) | Parcial: gremios y mensajes de ánimo | 🟠 Adaptar |
| **Pociones de acceso rápido** | Prácticas de un minuto: respiración 4-6, escaneo del instante | Hay respiración 4-7-8 y escaneo corporal (no las del libro) | 🟠 Cambiar por las del libro |
| **Bitácora** | Preguntas de *Integrar* + poema de cierre | "Lore" con preguntas por orientación espiritual | 🟡 Renombrar y alinear preguntas |
| **Evaluación funcional de 6 pruebas** | Cada 4 semanas; de ella suben los atributos | FMS, prensión, Wells & Dillon, 1RM/5RM, perímetros en fases base/mes 1/mes 2 | 🟠 Falta saber cuáles son las 6 |
| **Tu voz en este libro** | QR por capítulo: ¿qué te llevas?, ¿cuánto te movió (1–10)?, ¿qué cambiarías? | No existe | 🔴 Falta |

Leyenda: 🔴 no existe · 🟠 existe pero distinto al libro · 🟡 cambio menor · 🟢 alineado.

### Vocabulario que el código debe dejar de usar

| Hoy | Aurora |
|---|---|
| Misión | Práctica |
| Lore | Bitácora |
| Gremio | Comunidad (nombre a decidir) |
| Personaje / jugador | Por decidir: «tu avatar», «tú» |
| XP | No aparece en el libro; el progreso son **prácticas vividas** («Llevas 9 de 21 prácticas») |
| Ruta de Recuperación / Equilibrio / Expansión | Por decidir (no está en el libro) |

---

## 2. Cuidados que la app hereda del libro

| Cuidado | Lo que pide el libro | Estado en el código |
|---|---|---|
| Seguridad física | Cuestionario tipo PAR-Q antes de la evaluación; detenerse ante dolor, mareo o falta de aire | 🟢 Tamizaje en el onboarding; dolor bloquea carga. Falta el aviso «detente si…» dentro de cada práctica |
| Salud mental | Acompaña, no diagnostica; varios días de ánimo muy bajo → líneas de ayuda con cuidado | 🟢 Protocolo de Banderas Rojas (más amplio que lo que pide el libro: revisar si se simplifica) |
| Privacidad | Registros de cada persona; investigación solo con consentimiento y anonimización (Ley 1581) | 🟢 Bóveda de identidad, consentimientos separados, analítica seudonimizada |
| Honestidad científica | No promete curas | 🟢 Lenguaje de tamizaje; revisar textos de prácticas |
| Derechos | Libro registrado ante la DNDA; acuerdo escrito del equipo sobre uso del contenido | ⚪ No es código: pendiente del equipo |
| Independencia | Libro y app son un proyecto personal del equipo, **no de la universidad** | 🔴 **Conflicto:** el código menciona a la Universidad de Antioquia (encabezado del PDF clínico, línea de Bienestar UdeA, dominio `sifus.udea.edu.co`, README) |
| Arte propio | El juego de referencia solo inspira mecánicas; nombre, logo, personajes, íconos y arte deben ser 100 % propios | 🟢 No se usan nombres ni arte de terceros |

---

## 3. Módulos a revisar, uno por uno

Orden propuesto: primero lo que define el lenguaje y el núcleo del libro; después lo que ya está construido.

| # | Módulo | Qué decidir | Código afectado |
|---|---|---|---|
| 1 | **Identidad del proyecto** | Nombre de la app (¿Aurora? ¿SIFUS?), retirar referencias a la universidad, vocabulario prohibido | Todo el repo (textos) |
| 2 | **Estaciones y prácticas** | Catálogo de las 8 estaciones y 21 prácticas; qué se mide en cada una; estructura de 5 pasos | Nuevo `core/src/aurora/`, reemplaza `missionCatalog.ts` |
| 3 | **Registro 1 a 10** | Antes/después por práctica; curva personal; tabla de 7 días | Nuevo modelo de datos + UI |
| 4 | **Niveles y equipo** | Aprendiz/Practicante/Campeón; objetos simbólicos y su «refinamiento»; halo de servicio | Reemplaza `skill-tree/progression.ts` |
| 5 | **Avatar: atributos, rueda y barras** | 5 atributos del cap. 4 vs. 4 atributos base; barra de vida, barra azul, barra anímica; qué pasa con el Índice de Vida 0–100 | `wellbeing/`, `features/dashboard/` |
| 6 | **Evaluación funcional (cada 4 semanas)** | Cuáles son las 6 pruebas; cómo suben los atributos; qué hacer con FMS, 1RM, perímetros, cuestionarios | `instruments/`, `Assessment` |
| 7 | **Creador de personaje (onboarding)** | Qué preguntas quedan, en lenguaje del libro | `features/onboarding/` |
| 8 | **Plan del día (vulnerabilidad)** | Cómo recomienda prácticas del libro según el registro 1–10 y el descanso | `vulnerability/` |
| 9 | **Comunidad y halo de servicio** | Gremios vs. «nadie juega solo»; llevar una práctica a otra persona | `guilds/`, modelos `Guild*` |
| 10 | **Bitácora** | Preguntas de *Integrar* y poema de cierre por estación | `spirituality/`, `LoreEntry` |
| 11 | **Cuidados (seguridad y salud mental)** | Mantener o simplificar el protocolo actual; avisos dentro de cada práctica | `safety/`, `features/safety/` |
| 12 | **Tu voz en este libro** | Las 3 preguntas por capítulo; consentimiento para investigación | Nuevo |
| 13 | **Investigación y exportaciones** | Si el esquema analítico, el informe clínico y FHIR siguen en el alcance del proyecto personal | `db/sql/analytics`, `clinical/`, `clinical-export/` |

### Registro de decisiones

| Fecha | Módulo | Decisión |
|---|---|---|
| — | — | — |
