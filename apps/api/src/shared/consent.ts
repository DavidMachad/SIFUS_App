import type { PrismaClient, ResearchConsent } from '@prisma/client';

export class ConsentRequiredError extends Error {
  constructor(what: string) {
    super(`Se requiere consentimiento para: ${what}`);
    this.name = 'ConsentRequiredError';
  }
}

/** Consentimiento vigente más reciente (cualquier alcance). */
export async function activeConsent(db: PrismaClient, userId: string): Promise<ResearchConsent | null> {
  return db.researchConsent.findFirst({ where: { userId, revokedAt: null }, orderBy: { acceptedAt: 'desc' } });
}

export async function requireConsent(
  db: PrismaClient,
  userId: string,
  flag: 'allowsPassiveData' | 'allowsClinicalExport' | 'allowsCareTeamAlerts',
): Promise<void> {
  const c = await activeConsent(db, userId);
  if (!c?.[flag]) throw new ConsentRequiredError(flag);
}
