import { PrismaClient } from '@prisma/client';
import { MISSION_CATALOG } from '@sifus/core';

/** Siembra el catálogo de misiones desde @sifus/core (fuente única). */
async function main() {
  const db = new PrismaClient();
  for (const m of MISSION_CATALOG) {
    const data = {
      title: m.title,
      description: m.description,
      category: m.category,
      intensity: m.intensity,
      durationMinutes: m.durationMinutes,
      capacityXp: m.capacityXp,
      loadedPatterns: m.loadedPatterns,
      minAgeYears: m.minAgeYears,
      maxAgeYears: m.maxAgeYears,
    };
    await db.missionTemplate.upsert({ where: { code: m.code }, create: { code: m.code, ...data }, update: data });
  }
  console.log(`Catálogo sembrado: ${MISSION_CATALOG.length} misiones`);
  await db.$disconnect();
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
