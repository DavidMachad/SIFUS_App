export const DAY_MS = 86_400_000;
export const toDate = (isoDay: string) => new Date(`${isoDay}T00:00:00.000Z`);
export const isoDay = (d: Date) => d.toISOString().slice(0, 10);
export const daysBetween = (from: Date, to: Date) => Math.floor((to.getTime() - from.getTime()) / DAY_MS);
export const addDays = (d: Date, n: number) => new Date(d.getTime() + n * DAY_MS);
