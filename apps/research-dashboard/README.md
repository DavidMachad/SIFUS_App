# Tablero de investigación SIFUS

Espacio reservado para el panel de control de salubristas e investigadores.
Se conecta **solo** al esquema `analytics` con el rol de solo lectura
`sifus_researcher` (sin acceso al esquema operacional `public`).

## Opciones de implementación

| Fase | Herramienta | Por qué |
|------|-------------|---------|
| Piloto (recomendado) | Metabase o Power BI sobre `analytics` | Cero código; los salubristas construyen sus propios tableros. |
| Escalamiento | Next.js en `apps/research-dashboard` | Vistas a la medida, exportaciones reproducibles y control de acceso por cohorte. |
| Análisis inferencial | R / Python leyendo `mv_phase_snapshot` | Modelos mixtos para medidas repetidas (base, mes 1, mes 2). |

## Fuentes de datos

- `analytics.mv_phase_snapshot`: una fila por participante y fase. Es la tabla de trabajo principal.
- `analytics.v_change_from_baseline`: cambio absoluto, relativo, orientado y estandarizado.
- `analytics.v_adherence_by_band`: adherencia según la ruta del día.
- `analytics.v_measure_reliability`: insumos para calibrar el MDC.

Las consultas de ejemplo están en `queries/`.

## Reglas de uso

1. Nunca se cruzan datos de `analytics` con identificadores directos.
2. Celdas con n < 5 se suprimen en tableros compartidos (riesgo de reidentificación).
3. Cada tablero declara la versión del algoritmo (`algorithm_version`) y del protocolo de medición que cubre.
