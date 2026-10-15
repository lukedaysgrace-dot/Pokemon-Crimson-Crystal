import type { GameData, Layout } from '../gamedata/model';
import type { Mon } from './model';
import { be16, be24, le16, setBE16, setBE24, setLE16, savemonChecksum } from './bytes';
import { idToIndex, indexToId } from './tables';
import { decode, encode } from './text';
import { foldPokerus, stats, maxPP, expAtLevel } from './mechanics';

function fields(l: Layout, box: boolean) {
  const p = l.party,
    b = l.boxed;
  return box
    ? {
        Species: b.SPECIES,
        Item: b.ITEM,
        Moves: b.MOVES,
        ID: b.ID,
        Exp: b.EXP,
        StatExp: b.STAT_EXP,
        DVs: b.DVS,
        PP: b.MOVES_HI,
        Happiness: b.HAPPINESS,
        PokerusStatus: b.PKRUS,
        CaughtData: b.CAUGHTDATA,
        Level: b.LEVEL,
        Personality: b.PERSONALITY,
      }
    : p;
}
export function parseMon(
  raw: Uint8Array,
  g: GameData,
  box: boolean,
  monTable: Uint8Array,
  moveTable: Uint8Array,
  nickname = '',
  ot = '',
  egg = false,
): Mon {
  const l = g.layout,
    f = fields(l, box),
    b = l.boxed;
  const pp = Array.from(raw.slice(f.PP, f.PP + 4));
  const flags = raw[box ? b.PKRUS : l.party.Unused] || 0;
  const moves = Array.from(raw.slice(f.Moves, f.Moves + 4)).map((n, i) =>
    box
      ? (((pp[i] & 63) === 63 ? 255 : pp[i] & 63) << 8) | n
      : (idToIndex(moveTable, n, l.tables.move) ?? -1),
  );
  return {
    raw: Array.from(raw),
    species: box ? le16(raw, f.Species) : (idToIndex(monTable, raw[f.Species], l.tables.mon) ?? -1),
    item: raw[f.Item],
    moves,
    pp: box
      ? moves.map((n, i) => maxPP(g.moves.find((m) => m.index === n)?.pp || 0, pp[i] >>> 6))
      : pp.map((n) => n & 63),
    ups: pp.map((n) => n >>> 6),
    id: be16(raw, f.ID),
    exp: be24(raw, f.Exp),
    statExp: Array.from({ length: 5 }, (_, i) => be16(raw, f.StatExp + i * 2)),
    dvs: [raw[f.DVs] >>> 4, raw[f.DVs] & 15, raw[f.DVs + 1] >>> 4, raw[f.DVs + 1] & 15],
    happiness: raw[f.Happiness],
    pokerus: raw[f.PokerusStatus] & (box ? 63 : 255),
    caught: Array.from(raw.slice(f.CaughtData, f.CaughtData + 2)),
    level: raw[f.Level],
    personality: raw[f.Personality],
    hpType: box ? (raw[b.FLAGS] >>> 1) & 31 : raw[l.party.HiddenPowerType],
    shiny: !!(flags & 128),
    male: !!(flags & 64),
    egg: box ? !!(raw[b.FLAGS] & 1) : egg,
    nickname: box ? decode(raw.slice(b.NICKNAME, b.NICKNAME + b.NAME_LENGTH), g.charmap) : nickname,
    ot: box ? decode(raw.slice(b.OT, b.OT + b.NAME_LENGTH), g.charmap) : ot,
    hp: box || raw.length <= l.party.HP ? 0 : be16(raw, l.party.HP),
    status: box ? 0 : raw[l.party.Status] || 0,
    stats:
      box || raw.length <= l.party.MaxHP
        ? []
        : Array.from({ length: 6 }, (_, i) => be16(raw, l.party.MaxHP + 2 * i)),
    bad: box && le16(raw, b.CHECKSUM) !== savemonChecksum(raw, b.CHECKSUM),
  };
}
export function encodeMon(
  m: Mon,
  g: GameData,
  box: boolean,
  monTable: Uint8Array,
  moveTable: Uint8Array,
  rules: number,
  original?: Mon,
): Uint8Array {
  const l = g.layout,
    b = l.boxed,
    f = fields(l, box);
  const raw = Uint8Array.from(m.raw),
    species = g.species.find((s) => s.index === m.species);
  if (!species) throw new Error(`Unknown species ${m.species}`);
  if (box) setLE16(raw, f.Species, m.species);
  else raw[f.Species] = indexToId(monTable, m.species, l.tables.mon);
  raw[f.Item] = m.item;
  m.moves.forEach((n, i) => {
    raw[f.Moves + i] = box ? n & 255 : indexToId(moveTable, n, l.tables.move);
    raw[f.PP + i] = (m.ups[i] << 6) | (box ? (n >>> 8) & 63 : m.pp[i]);
  });
  setBE16(raw, f.ID, m.id);
  setBE24(raw, f.Exp, m.exp);
  m.statExp.forEach((n, i) => setBE16(raw, f.StatExp + 2 * i, n));
  raw[f.DVs] = (m.dvs[0] << 4) | m.dvs[1];
  raw[f.DVs + 1] = (m.dvs[2] << 4) | m.dvs[3];
  raw[f.Happiness] = m.happiness;
  raw[f.PokerusStatus] = box
    ? foldPokerus(m.pokerus) | (m.shiny ? 128 : 0) | (m.male ? 64 : 0)
    : m.pokerus;
  raw.set(m.caught, f.CaughtData);
  raw[f.Level] = m.level;
  raw[f.Personality] = m.personality;
  if (box) {
    raw[b.FLAGS] = (raw[b.FLAGS] & 192) | (m.hpType << 1) | Number(m.egg);
    if (!original || m.nickname !== original.nickname)
      raw.set(encode(m.nickname, b.NAME_LENGTH, b.NAME_LENGTH, g.charmap), b.NICKNAME);
    if (!original || m.ot !== original.ot)
      raw.set(encode(m.ot, b.NAME_LENGTH, b.NAME_LENGTH, g.charmap), b.OT);
    setLE16(raw, b.CHECKSUM, savemonChecksum(raw, b.CHECKSUM));
  } else {
    raw[l.party.HiddenPowerType] = m.hpType;
    if (raw.length > l.party.Unused)
      raw[l.party.Unused] = (raw[l.party.Unused] & 63) | (m.shiny ? 128 : 0) | (m.male ? 64 : 0);
    if (raw.length >= l.party.size) {
      raw[l.party.Status] = m.status;
      const calculated = m.keepStats ? m.stats : stats(species, m.dvs, m.statExp, m.level, rules);
      const needsStats =
        !original ||
        original.species !== m.species ||
        original.level !== m.level ||
        JSON.stringify(original.dvs) !== JSON.stringify(m.dvs) ||
        JSON.stringify(original.statExp) !== JSON.stringify(m.statExp) ||
        JSON.stringify(original.stats) !== JSON.stringify(m.stats) ||
        !original.stats.length;
      if (needsStats || m.keepStats)
        calculated.forEach((n, i) => setBE16(raw, l.party.MaxHP + i * 2, n));
      const max = needsStats ? calculated[0] : m.stats[0];
      const hp =
        needsStats && original && original.stats[0] && m.hp === original.hp
          ? Math.min(max, Math.ceil((original.hp * max) / original.stats[0]))
          : Math.min(m.hp, max);
      setBE16(raw, l.party.HP, hp);
    }
  }
  return raw;
}
export function template(
  g: GameData,
  player: { name: string; id: number },
  box: boolean,
  rules: number,
): Mon {
  const s = g.species[0],
    l = g.layout,
    level = 5;
  const moves = s.levelMoves
    .filter((m) => m.level <= level)
    .slice(-4)
    .map((m) => m.move);
  while (moves.length < 4) moves.push(0);
  const m: Mon = {
    raw: Array(box ? l.boxed.STRUCT_LENGTH : l.party.size).fill(0),
    species: s.index,
    item: 0,
    moves,
    ups: [0, 0, 0, 0],
    pp: moves.map((n) => g.moves.find((x) => x.index === n)?.pp || 0),
    id: player.id,
    exp: expAtLevel(g.growth[s.growth], level),
    statExp: [0, 0, 0, 0, 0],
    dvs: [15, 15, 15, 15],
    happiness: 70,
    pokerus: 0,
    caught: [0, l.constants.GIFT_LOCATION],
    level,
    personality: 32,
    hpType: 0,
    shiny: false,
    male: true,
    egg: false,
    nickname: s.name,
    ot: player.name,
    hp: 0,
    status: 0,
    stats: [],
    bad: false,
  };
  m.stats = stats(s, m.dvs, m.statExp, level, rules);
  m.hp = m.stats[0];
  return m;
}
