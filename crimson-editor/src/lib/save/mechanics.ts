import type { GameData, Species } from '../gamedata/model';
export const hpDV = (d: number[]) =>
  ((d[0] & 1) << 3) | ((d[1] & 1) << 2) | ((d[2] & 1) << 1) | (d[3] & 1);
export const maxPP = (base: number, ups: number) =>
  Math.min(63, base + Math.min(7, Math.floor(base / 5)) * ups);
export function calcStat(base: number, dv: number, statExp: number, level: number, hp: boolean) {
  const sq = Math.max(1, Math.min(255, Math.ceil(Math.sqrt(statExp))));
  return Math.min(
    999,
    Math.floor((((base + dv) * 2 + Math.floor(sq / 4)) * level) / 100) + (hp ? level + 10 : 5),
  );
}
export function stats(s: Species, d: number[], ex: number[], level: number, rules: number) {
  const base = rules & 2 ? s.originalStats : s.stats;
  const dvs = [hpDV(d), ...d.slice(0, 3), d[3], d[3]];
  return base.map((b, i) => calcStat(b, dvs[i], ex[Math.min(i, 4)], level, i === 0));
}
export function expAtLevel(g: GameData['growth'][number], n: number) {
  return n <= 1 ? 0 : Math.floor((g.a * n ** 3) / g.b) + g.c * n * n + g.d * n - g.e;
}
export function gender(s: Species, male: boolean) {
  return s.gender === 255
    ? 'Genderless'
    : s.gender === 0
      ? 'Male'
      : s.gender === 254
        ? 'Female'
        : male
          ? 'Male'
          : 'Female';
}
export const ability = (s: Species, slot: number, rules: number) =>
  rules & 4 ? 0 : s.abilities[Math.max(0, slot - 1)] || s.abilities[0];
export const foldPokerus = (v: number) => {
  if (v >= 64) {
    v &= 63;
    if (v < 16) v |= 16;
  }
  return v;
};
export const unownLetter = (d: number[]) =>
  Math.floor((((d[0] & 6) << 5) | ((d[1] & 6) << 3) | ((d[2] & 6) << 1) | ((d[3] & 6) >>> 1)) / 10);
