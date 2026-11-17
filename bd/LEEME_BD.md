# Bases de datos de SIFUS — cómo restaurarlas

Generadas el 2026-11-16 desde `main` (commit 7970a08) con PostgreSQL 16.
Funcionan en PostgreSQL 14 o superior.

## Archivos

| Archivo | Base que debes crear | Contenido |
|---|---|---|
| `sifus.sql` | **`sifus`** | Base de salud: 35 tablas de la app (esquema `public`), esquema de investigación `analytics` (22 tablas y vistas, ETL), catálogo de 22 misiones. **Sin personas.** |
| `sifus_identity.sql` | **`sifus_identity`** | Bóveda de identidad (PII cifrada). Vacía. |
| `sifus_con_demo.sql` | `sifus` (en lugar de `sifus.sql`) | Igual que `sifus.sql`, más una cohorte **ficticia** de 3 personas para probar tableros. No es data real. |

Usa `sifus.sql` **o** `sifus_con_demo.sql`, no los dos en la misma base.

## Restaurar (terminal)

```bash
createdb sifus
createdb sifus_identity
psql -d sifus          -f sifus.sql            # o: -f sifus_con_demo.sql
psql -d sifus_identity -f sifus_identity.sql
psql -d sifus -c "CALL analytics.refresh_all();"   # recalcula el esquema de investigación
```

Con usuario y servidor: `psql -h localhost -U postgres -d sifus -f sifus.sql`.

En **pgAdmin**: crea las dos bases (clic derecho en *Databases* → *Create*), luego abre cada una con
*Query Tool*, carga el archivo `.sql` correspondiente y ejecútalo (F5). No uses *Restore*: estos archivos
son SQL plano, no formato custom.

## Conectar la app

```
# packages/db/.env
DATABASE_URL="postgresql://USUARIO:CLAVE@localhost:5432/sifus?schema=public"
# packages/identity-vault/.env
IDENTITY_DATABASE_URL="postgresql://USUARIO:CLAVE@localhost:5432/sifus_identity?schema=public"
```

Las bases incluyen el historial de migraciones de Prisma, así que `npx prisma migrate deploy` las reconoce
como al día.

## Notas

- Los archivos no traen dueños ni permisos: los objetos quedan a nombre del usuario que restaura.
- Rol opcional de solo lectura para investigadores:
  ```sql
  CREATE ROLE sifus_researcher NOLOGIN;
  GRANT USAGE ON SCHEMA analytics TO sifus_researcher;
  GRANT SELECT ON ALL TABLES IN SCHEMA analytics TO sifus_researcher;
  ```
- En producción, `sifus` y `sifus_identity` deben vivir en servidores o cuentas distintas, con
  credenciales distintas (ver `docs/SECURITY.md`). En tu computador, para desarrollo, pueden estar juntas.
