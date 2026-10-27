import { randomBytes } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { aadFor, blindIndex, FieldCipher, LocalDevKekProvider } from '../src/security/fieldEncryption';

const keys = new Map([[1, randomBytes(32)], [2, randomBytes(32)]]);
const cipher = new FieldCipher(new LocalDevKekProvider(keys, 2));
const aad = aadFor('lore_entries', 'contentCiphertext', 'b0d5c7e2-0000-4000-8000-000000000001');

describe('Cifrado de campos AES-256-GCM', () => {
  it('cifra y descifra (incluye tildes y ñ)', async () => {
    const env = await cipher.encrypt('Hoy agradezco a mi mamá y a la montaña', aad);
    expect(env.startsWith('v1.2.')).toBe(true);
    expect(env).not.toContain('mamá');
    expect(await cipher.decrypt(env, aad)).toBe('Hoy agradezco a mi mamá y a la montaña');
  });

  it('dos cifrados del mismo texto son distintos (IV y DEK aleatorios)', async () => {
    expect(await cipher.encrypt('x', aad)).not.toBe(await cipher.encrypt('x', aad));
  });

  it('falla si el texto cifrado se mueve a otro sujeto o campo (AAD)', async () => {
    const env = await cipher.encrypt('secreto', aad);
    await expect(cipher.decrypt(env, aadFor('lore_entries', 'contentCiphertext', 'otro-sujeto'))).rejects.toThrow();
    await expect(cipher.decrypt(env, aadFor('clinical_histories', 'notesCiphertext', 'b0d5c7e2-0000-4000-8000-000000000001'))).rejects.toThrow();
  });

  it('detecta manipulación (integridad GCM)', async () => {
    const env = await cipher.encrypt('secreto', aad);
    const parts = env.split('.');
    const ct = Buffer.from(parts[5]!, 'base64');
    ct[0] = ct[0]! ^ 0xff;
    parts[5] = ct.toString('base64');
    await expect(cipher.decrypt(parts.join('.'), aad)).rejects.toThrow();
  });

  it('descifra registros con una versión anterior de la KEK (rotación)', async () => {
    const old = await new FieldCipher(new LocalDevKekProvider(keys, 1)).encrypt('antiguo', aad);
    expect(await cipher.decrypt(old, aad)).toBe('antiguo');
  });

  it('índice ciego estable e insensible a mayúsculas, sin revelar el valor', () => {
    const k = randomBytes(32);
    expect(blindIndex('Persona@UdeA.edu.co ', k)).toBe(blindIndex('persona@udea.edu.co', k));
    expect(blindIndex('persona@udea.edu.co', k)).toMatch(/^[0-9a-f]{64}$/);
  });
});
