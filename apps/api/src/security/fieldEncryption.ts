import { createCipheriv, createDecipheriv, createHmac, randomBytes } from 'node:crypto';

/**
 * Cifrado de campos a nivel de aplicación — AES-256-GCM con cifrado de sobre.
 *
 *   KEK (llave maestra) ── vive en un KMS (AWS KMS, GCP KMS, Azure Key Vault o
 *        │                  HashiCorp Vault). NUNCA en la base de datos ni en el código.
 *        └─ envuelve ─▶ DEK (llave de datos, 256 bits, una por registro)
 *                          └─ cifra ─▶ campo (AES-256-GCM, IV de 96 bits)
 *
 * - GCM da confidencialidad e integridad: un texto cifrado manipulado no descifra.
 * - AAD (datos asociados) = "<tabla>.<campo>:<subjectId>". Copiar un texto cifrado
 *   a otro registro o a otro campo hace fallar el descifrado.
 * - keyVersion permite rotar la KEK: lo nuevo usa la versión vigente y lo antiguo
 *   se re-envuelve por lotes.
 * - El cifrado en reposo del disco (AES-256 del proveedor de nube) y TLS 1.3 en
 *   tránsito son capas ADICIONALES, no sustitutos: protegen contra robo del disco
 *   o espionaje de red, pero no contra un volcado de la base o un DBA curioso.
 *
 * Formato serializado (ASCII, apto para columnas text):
 *   v1.<keyVersion>.<dek envuelta b64>.<iv b64>.<tag b64>.<ciphertext b64>
 */

export interface KeyEncryptionProvider {
  currentVersion(): number;
  wrap(dek: Buffer, version: number): Promise<Buffer>;
  unwrap(wrapped: Buffer, version: number): Promise<Buffer>;
}

const b64 = (b: Buffer) => b.toString('base64');
const unb64 = (s: string) => Buffer.from(s, 'base64');

export class FieldCipher {
  constructor(private readonly kek: KeyEncryptionProvider) {}

  async encrypt(plaintext: string, aad: string): Promise<string> {
    const version = this.kek.currentVersion();
    const dek = randomBytes(32);
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', dek, iv);
    cipher.setAAD(Buffer.from(aad, 'utf8'));
    const ct = Buffer.concat([cipher.update(plaintext, 'utf8'), cipher.final()]);
    const tag = cipher.getAuthTag();
    const wrapped = await this.kek.wrap(dek, version);
    dek.fill(0);
    return ['v1', version, b64(wrapped), b64(iv), b64(tag), b64(ct)].join('.');
  }

  async decrypt(envelope: string, aad: string): Promise<string> {
    const [fmt, version, wrapped, iv, tag, ct] = envelope.split('.');
    if (fmt !== 'v1' || !version || !wrapped || !iv || !tag || ct === undefined) throw new Error('Sobre cifrado con formato inválido');
    const dek = await this.kek.unwrap(unb64(wrapped), Number(version));
    try {
      const decipher = createDecipheriv('aes-256-gcm', dek, unb64(iv));
      decipher.setAAD(Buffer.from(aad, 'utf8'));
      decipher.setAuthTag(unb64(tag));
      return Buffer.concat([decipher.update(unb64(ct)), decipher.final()]).toString('utf8');
    } finally {
      dek.fill(0);
    }
  }
}

/** AAD canónica: ata el texto cifrado a su tabla, campo y sujeto. */
export const aadFor = (table: string, field: string, subjectId: string) => `${table}.${field}:${subjectId}`;

/**
 * Índice ciego (blind index) para buscar PII sin guardarla en claro:
 * HMAC-SHA256 con una llave distinta de la de cifrado.
 */
export function blindIndex(value: string, hmacKey: Buffer): string {
  return createHmac('sha256', hmacKey).update(value.trim().toLowerCase().normalize('NFC')).digest('hex');
}

/**
 * Proveedor local SOLO para desarrollo y pruebas: envuelve la DEK con
 * AES-256-GCM usando llaves en memoria. En producción se reemplaza por el KMS.
 */
export class LocalDevKekProvider implements KeyEncryptionProvider {
  constructor(private readonly keys: Map<number, Buffer>, private readonly version: number) {
    for (const k of keys.values()) if (k.length !== 32) throw new Error('La KEK debe tener 256 bits');
  }
  currentVersion() {
    return this.version;
  }
  async wrap(dek: Buffer, version: number) {
    const key = this.keys.get(version);
    if (!key) throw new Error(`KEK v${version} no disponible`);
    const iv = randomBytes(12);
    const c = createCipheriv('aes-256-gcm', key, iv);
    const ct = Buffer.concat([c.update(dek), c.final()]);
    return Buffer.concat([iv, c.getAuthTag(), ct]);
  }
  async unwrap(wrapped: Buffer, version: number) {
    const key = this.keys.get(version);
    if (!key) throw new Error(`KEK v${version} no disponible`);
    const d = createDecipheriv('aes-256-gcm', key, wrapped.subarray(0, 12));
    d.setAuthTag(wrapped.subarray(12, 28));
    return Buffer.concat([d.update(wrapped.subarray(28)), d.final()]);
  }
}
