-- CreateEnum
CREATE TYPE "DocumentType" AS ENUM ('CC', 'TI', 'CE', 'PASSPORT', 'PPT');

-- CreateEnum
CREATE TYPE "AccessPurpose" AS ENUM ('CLINICAL_REPORT', 'CRISIS_RESPONSE', 'ACCOUNT_RECOVERY', 'DATA_SUBJECT_REQUEST', 'LEGAL_OBLIGATION');

-- CreateTable
CREATE TABLE "identities" (
    "subjectId" TEXT NOT NULL,
    "emailBlindIndex" TEXT NOT NULL,
    "emailCiphertext" TEXT NOT NULL,
    "fullNameCiphertext" TEXT NOT NULL,
    "documentType" "DocumentType",
    "documentBlindIndex" TEXT,
    "documentCiphertext" TEXT,
    "phoneCiphertext" TEXT,
    "birthDateCiphertext" TEXT NOT NULL,
    "keyVersion" INTEGER NOT NULL DEFAULT 1,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "erasedAt" TIMESTAMP(3),

    CONSTRAINT "identities_pkey" PRIMARY KEY ("subjectId")
);

-- CreateTable
CREATE TABLE "guardians" (
    "id" TEXT NOT NULL,
    "subjectId" TEXT NOT NULL,
    "fullNameCiphertext" TEXT NOT NULL,
    "documentCiphertext" TEXT NOT NULL,
    "phoneCiphertext" TEXT NOT NULL,
    "relationship" TEXT NOT NULL,

    CONSTRAINT "guardians_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "identity_access_log" (
    "id" TEXT NOT NULL,
    "subjectId" TEXT NOT NULL,
    "accessedBy" TEXT NOT NULL,
    "purpose" "AccessPurpose" NOT NULL,
    "justificationRef" TEXT,
    "accessedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "identity_access_log_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "identities_emailBlindIndex_key" ON "identities"("emailBlindIndex");

-- CreateIndex
CREATE UNIQUE INDEX "identities_documentBlindIndex_key" ON "identities"("documentBlindIndex");

-- CreateIndex
CREATE UNIQUE INDEX "guardians_subjectId_key" ON "guardians"("subjectId");

-- CreateIndex
CREATE INDEX "identity_access_log_subjectId_accessedAt_idx" ON "identity_access_log"("subjectId", "accessedAt");

-- AddForeignKey
ALTER TABLE "guardians" ADD CONSTRAINT "guardians_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "identities"("subjectId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "identity_access_log" ADD CONSTRAINT "identity_access_log_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "identities"("subjectId") ON DELETE RESTRICT ON UPDATE CASCADE;
