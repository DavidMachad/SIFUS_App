# Privacidad, seguridad y cumplimiento normativo

> **Alcance honesto.** El código implementa los *controles técnicos* que exigen
> HIPAA, el RGPD y la Ley 1581 de 2012. El *cumplimiento* además requiere
> controles organizacionales que el software no puede garantizar por sí solo:
> análisis de riesgos, oficial de protección de datos, contratos con encargados
> (BAA en EE. UU., artículo 28 del RGPD, contratos de transmisión según la Ley
> 1581), capacitación, gestión de incidentes y auditorías.
> Ninguna línea de este repositorio debe presentarse como "certificación".

## 1. Marco aplicable

| Norma | ¿Aplica a SIFUS? | Implicaciones principales |
|---|---|---|
| **Ley 1581 de 2012 + Decreto 1377 de 2013 (Colombia)** | **Sí, siempre** | Los datos de salud son *sensibles*: requieren autorización previa, expresa e informada; finalidad específica; derechos de conocer, actualizar, rectificar y suprimir (ARCO); registro de bases de datos ante la SIC. |
| **Resolución 8430 de 1993** | Sí (investigación en salud) | Consentimiento informado, aval del comité de ética, protección de menores (asentimiento + acudiente). |
| **Ley 2015 de 2020 (HCE interoperable)** | Si se integra con IPS/EPS | Interoperabilidad de la historia clínica electrónica → exportación FHIR. |
| **RGPD (UE)** | Solo si hay participantes en la UE o servicios dirigidos a ellos | Base jurídica (art. 9.2.a, consentimiento explícito), minimización, seudonimización, portabilidad, notificación de brechas en 72 h. |
| **HIPAA (EE. UU.)** | Solo si SIFUS actúa como (o para) una *covered entity* estadounidense | Security Rule: cifrado, control de acceso, auditoría. Safe Harbor para desidentificar. |

Se diseña para el **marco más exigente de los tres**, de modo que el sistema no
deba rehacerse si cambia el alcance.

## 2. Desacoplamiento de PII (UUID)

```
┌──────────────────────────┐        subjectId (UUID v4)        ┌─────────────────────────────┐
│ BÓVEDA DE IDENTIDAD      │ ───────────────────────────────── │ BASE DE SALUD               │
│ packages/identity-vault  │   sin llave foránea física        │ packages/db                 │
│ correo, nombre, documento│                                   │ anamnesis, tests, misiones, │
│ teléfono, fecha de       │                                   │ datos pasivos, índice,      │
│ nacimiento, acudiente    │                                   │ banderas rojas              │
│ (todo cifrado + índices  │                                   │ (sin PII; año de nacimiento)│
│  ciegos HMAC)            │                                   └──────────────┬──────────────┘
└──────────┬───────────────┘                                                  │ ETL (solo consentimiento
           │ IdentityAccessLog                                                │ de investigación)
           │ (propósito + justificación                                       ▼
           │  de cada re-identificación)                       ┌─────────────────────────────┐
                                                               │ ESQUEMA ANALYTICS           │
                                                               │ researchCode (3.er id)      │
                                                               │ sin texto libre             │
                                                               └─────────────────────────────┘
```

- **Tres identificadores:** el UUID operacional, el `researchCode` de
  investigación y la PII cifrada. Ninguna vía de datos los contiene a los tres
  juntos, salvo la re-identificación auditada.
- **Credenciales y llaves distintas** para cada base. El servicio de analítica
  no tiene credenciales de la bóveda.
- **Desidentificación tipo HIPAA Safe Harbor** en la base de salud:
  - solo se guarda el año de nacimiento (`birthYear`);
  - no hay nombres, correos, teléfonos ni documentos;
  - `municipalityCode` es una cuasi-identificación: en tableros, se agregan los municipios con menos de 20 000 habitantes o con n < 5.
- **Re-identificación** (`IdentityVaultService.reidentify`): exige propósito
  (`CLINICAL_REPORT`, `CRISIS_RESPONSE`, `DATA_SUBJECT_REQUEST`…) y una
  referencia que la justifique, y queda en `identity_access_log`.
- **Supresión** (`erase`): borra la PII y conserva el UUID. Así, los datos de salud quedan anónimos y la integridad estadística del estudio se mantiene.

## 3. Cifrado

| Capa | Mecanismo | Dónde |
|---|---|---|
| En tránsito | TLS 1.3 (mínimo 1.2) con suites AES-256-GCM, HSTS y *certificate pinning* en la app | Balanceador, API, conexiones a PostgreSQL (`sslmode=verify-full`) |
| En reposo (disco) | AES-256 del proveedor (volúmenes, copias de seguridad, *snapshots*) con llaves de cliente (CMK) | Infraestructura |
| En reposo (aplicación) | **AES-256-GCM con cifrado de sobre** | `apps/api/src/security/fieldEncryption.ts` |
| Búsqueda de PII | Índice ciego HMAC-SHA256 (llave distinta) | Correo y documento en la bóveda |
| En el dispositivo | Keychain (iOS) / Keystore (Android); SQLite cifrada para modo sin conexión | App móvil |

Se cifran a nivel de aplicación:
- toda la PII;
- `LoreEntry.contentCiphertext` (reflexiones y gratitud);
- `ClinicalHistory.notesCiphertext`;
- `RedFlagEvent.followUpNotesCiphertext`.

El AAD liga cada texto cifrado a su tabla, campo y sujeto, así que un texto cifrado copiado a otro registro no descifra.

**Gestión de llaves.**
- La KEK vive en un KMS (AWS KMS, GCP KMS, Azure Key Vault o Vault) y nunca está en el código ni en la base.
- Rotación anual o ante incidente: `keyVersion` permite convivir con versiones anteriores y re-envolver por lotes.
- `LocalDevKekProvider` es **solo para desarrollo y pruebas**.

## 4. Minimización y retención

- **Datos pasivos:**
  - solo se suben **agregados diarios**, calculados en el dispositivo; nunca las muestras latido a latido ni las fases de sueño minuto a minuto;
  - se exige un consentimiento específico (`allowsPassiveData`), independiente del de investigación.
- **Texto libre:** nunca llega a `analytics`.
- **Retención propuesta** (a aprobar por el comité):
  - datos de investigación: la duración del estudio + 5 años, seudonimizados;
  - PII: hasta la revocación o el fin del estudio;
  - registros de auditoría: 6 años.

## 5. Control de acceso y auditoría

- Roles: `PARTICIPANT`, `EVALUATOR`, `RESEARCHER` (solo `analytics`), `ADMIN`.
- Recomendado: *row-level security* en PostgreSQL para `clinical_histories`, `injury_records` y `red_flag_events`, de modo que solo accedan la persona y su equipo asignado.
- Auditoría: `identity_access_log`, `clinical_exports` (con SHA-256 del documento emitido) y `red_flag_events`.

## 6. Incidentes

| Marco | Notificación |
|---|---|
| Ley 1581 | A la SIC dentro de los 15 días hábiles siguientes a la detección (Circular Externa SIC 002 de 2015 — verificar la versión vigente) |
| RGPD | A la autoridad en 72 h; a los titulares si hay alto riesgo |
| HIPAA | A los afectados en ≤ 60 días |

## 7. Lista de verificación previa a producción

- [ ] KMS real configurado; llaves de salud, identidad e índice ciego separadas.
- [ ] Bases de salud e identidad en instancias o cuentas distintas.
- [ ] TLS `verify-full` en todas las conexiones a bases de datos.
- [ ] Registro de las bases de datos ante la SIC (RNBD).
- [ ] Política de tratamiento de datos publicada; aviso de privacidad en la app.
- [ ] Pruebas de penetración (OWASP MASVS para la app móvil).
- [ ] Contratos con encargados (nube, mensajería del equipo de cuidado).
