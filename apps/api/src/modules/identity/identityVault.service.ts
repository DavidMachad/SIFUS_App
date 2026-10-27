import { randomUUID } from 'node:crypto';
import { PrismaClient as IdentityClient, type AccessPurpose } from '@sifus/identity-client';
import { aadFor, blindIndex, type FieldCipher } from '../../security/fieldEncryption';

/**
 * Cliente de la Bóveda de Identidad (base de datos separada).
 * Es el ÚNICO componente con credenciales para leer PII. Toda lectura de PII
 * exige un propósito y queda registrada (IdentityAccessLog).
 */
export class IdentityVaultService {
  constructor(
    private readonly vault: IdentityClient,
    private readonly cipher: FieldCipher,
    private readonly blindIndexKey: Buffer,
  ) {}

  /** Alta: devuelve el subjectId (UUID) que será User.id en la base de salud. */
  async register(input: { email: string; fullName: string; birthDate: string; phone?: string; documentType?: 'CC' | 'TI' | 'CE' | 'PASSPORT' | 'PPT'; documentNumber?: string }): Promise<string> {
    const subjectId = randomUUID();
    const enc = (field: string, v: string) => this.cipher.encrypt(v, aadFor('identities', field, subjectId));
    await this.vault.identity.create({
      data: {
        subjectId,
        emailBlindIndex: blindIndex(input.email, this.blindIndexKey),
        emailCiphertext: await enc('email', input.email.trim().toLowerCase()),
        fullNameCiphertext: await enc('fullName', input.fullName),
        birthDateCiphertext: await enc('birthDate', input.birthDate),
        phoneCiphertext: input.phone ? await enc('phone', input.phone) : null,
        documentType: input.documentType ?? null,
        documentBlindIndex: input.documentNumber ? blindIndex(input.documentNumber, this.blindIndexKey) : null,
        documentCiphertext: input.documentNumber ? await enc('document', input.documentNumber) : null,
      },
    });
    return subjectId;
  }

  async findSubjectByEmail(email: string): Promise<string | null> {
    const row = await this.vault.identity.findUnique({ where: { emailBlindIndex: blindIndex(email, this.blindIndexKey) }, select: { subjectId: true } });
    return row?.subjectId ?? null;
  }

  /** Re-identificación auditada: solo con propósito y referencia que la justifique. */
  async reidentify(subjectId: string, accessedBy: string, purpose: AccessPurpose, justificationRef: string): Promise<{ fullName: string; document?: string }> {
    const id = await this.vault.identity.findUniqueOrThrow({ where: { subjectId } });
    if (id.erasedAt) throw new Error('Identidad suprimida por solicitud del titular');
    await this.vault.identityAccessLog.create({ data: { subjectId, accessedBy, purpose, justificationRef } });
    const dec = (field: string, v: string) => this.cipher.decrypt(v, aadFor('identities', field, subjectId));
    return {
      fullName: await dec('fullName', id.fullNameCiphertext),
      document: id.documentCiphertext ? await dec('document', id.documentCiphertext) : undefined,
    };
  }

  /** Derecho de supresión: se borra la PII; los datos de salud quedan anónimos. */
  async erase(subjectId: string, requestedBy: string): Promise<void> {
    await this.vault.$transaction([
      this.vault.identityAccessLog.create({ data: { subjectId, accessedBy: requestedBy, purpose: 'DATA_SUBJECT_REQUEST', justificationRef: 'ERASURE' } }),
      this.vault.guardian.deleteMany({ where: { subjectId } }),
      this.vault.identity.update({
        where: { subjectId },
        data: {
          emailBlindIndex: `erased:${subjectId}`, emailCiphertext: '', fullNameCiphertext: '', birthDateCiphertext: '',
          phoneCiphertext: null, documentBlindIndex: null, documentCiphertext: null, erasedAt: new Date(),
        },
      }),
    ]);
  }
}
