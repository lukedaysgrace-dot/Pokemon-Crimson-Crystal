import type { GameData } from '../gamedata/model';
import type { SaveModel } from './model';
import { semantic } from './model';
import { container } from './container';
import { selectCopy, wramOffset } from './copies';
import { be16, be24 } from './bytes';
import { decode } from './text';
import { parseMon } from './mon';
import { recordOffset } from './boxes';
import { validate } from './validate';
export function detect(input: Uint8Array, bundles: GameData[]): GameData | null {
  container(input);
  const candidates = bundles
    .map((data, i) => {
      const l = data.layout,
        c = selectCopy(input, l);
      return {
        data,
        score:
          (c.main.valid ? 4 : 0) +
          (c.backup.valid ? 4 : 0) +
          (c.main.checks ? 1 : 0) +
          (c.backup.checks ? 1 : 0),
        valid: c.source,
        i,
      };
    })
    .filter((e) => e.valid)
    .sort((a, b) => b.score - a.score || a.i - b.i);
  return candidates[0]?.data || null;
}
export function parse(input: Uint8Array, data: GameData): SaveModel {
  container(input);
  const original = new Uint8Array(input),
    l = data.layout,
    copies = selectCopy(original, l),
    c = l.constants;
  const r = copies.source === 'backup' ? l.backup : l.main,
    o = (n: string) => wramOffset(l, r, n),
    b = original;
  const monTable = b.slice(r.monTable, r.monTable + l.tables.mon.size),
    moveTable = b.slice(r.moveTable, r.moveTable + l.tables.move.size);
  const readText = (name: string, size: number) =>
    decode(b.slice(o(name), o(name) + size), data.charmap);
  const party = Array.from({ length: Math.min(b[o('wPartyCount')], c.PARTY_LENGTH) }, (_, i) => {
    const p = o('wPartyMon1') + i * l.party.size;
    return parseMon(
      b.slice(p, p + l.party.size),
      data,
      false,
      monTable,
      moveTable,
      decode(
        b.slice(
          o('wPartyMonNicknames') + i * c.MON_NAME_LENGTH,
          o('wPartyMonNicknames') + (i + 1) * c.MON_NAME_LENGTH,
        ),
        data.charmap,
      ),
      decode(
        b.slice(o('wPartyMonOT') + i * c.NAME_LENGTH, o('wPartyMonOT') + (i + 1) * c.NAME_LENGTH),
        data.charmap,
      ),
      b[o('wPartySpecies') + i] === l.tables.mon.reservedMin,
    );
  });
  const boxes = Array.from({ length: c.NUM_BOXES }, (_, i) => {
    const start = copies.snapshot + i * l.newbox.size,
      raw = b.slice(start, start + l.newbox.size);
    return {
      raw: Array.from(raw),
      name: decode(raw.slice(l.newbox.Name, l.newbox.Theme), data.charmap),
      theme: raw[l.newbox.Theme],
      slots: Array.from({ length: c.MONS_PER_BOX }, (_, slot) => {
        const entry = raw[slot];
        if (!entry || entry > c.MONDB_ENTRIES) return null;
        const pool = 1 + ((raw[l.newbox.Banks + (slot >>> 3)] >>> (slot & 7)) & 1),
          p = recordOffset(l, pool, entry);
        const mon = parseMon(
          b.slice(p, p + l.boxed.STRUCT_LENGTH),
          data,
          true,
          monTable,
          moveTable,
        );
        mon.pointer = { pool, entry };
        return mon;
      }),
    };
  });
  const bag: SaveModel['bag'] = {};
  for (const [key, count, sym, limit] of [
    ['items', 'wNumItems', 'wItems', 'MAX_ITEMS'],
    ['balls', 'wNumBalls', 'wBalls', 'MAX_BALLS'],
    ['key', 'wNumKeyItems', 'wKeyItems', 'MAX_KEY_ITEMS'],
    ['pc', 'wNumPCItems', 'wPCItems', 'MAX_PC_ITEMS'],
  ]) {
    bag[key] = Array.from({ length: Math.min(b[o(count)], c[limit]) }, (_, i) => ({
      item: b[o(sym) + i * (key === 'key' ? 1 : 2)],
      quantity: key === 'key' ? 1 : b[o(sym) + i * 2 + 1],
    }));
  }
  const bitArray = (name: string) =>
    Array.from({ length: c.NUM_POKEMON }, (_, i) => !!(b[o(name) + (i >>> 3)] & (1 << (i & 7))));
  const flags = Object.fromEntries(
    data.flags.map((f) => [f.const, !!(b[o(f.symbol) + f.offset] & f.mask)]),
  );
  const daycare: SaveModel['daycare'] = [
    ['wBreedMon1Stats', 'wBreedMon1Nick', 'wBreedMon1OT', 'wDayCareMan'],
    ['wBreedMon2Stats', 'wBreedMon2Nick', 'wBreedMon2OT', 'wDayCareLady'],
    ['wEggMon', 'wEggNick', 'wEggOT', ''],
  ].map(([symbol, nick, ot, active]) => ({
    symbol,
    nicknameSymbol: nick || undefined,
    otSymbol: ot || undefined,
    active: active ? !!(b[o(active)] & 1) : !!(b[o('wDayCareMan')] & 0x40),
    mon: parseMon(
      b.slice(o(symbol), o(symbol) + l.party.End),
      data,
      false,
      monTable,
      moveTable,
      nick ? readText(nick, c.MON_NAME_LENGTH) : '',
      ot ? readText(ot, c.NAME_LENGTH) : '',
      !active,
    ),
  }));
  const model: SaveModel = {
    original,
    data,
    copies,
    diagnostics: [],
    party,
    boxes,
    player: {
      name: readText('wPlayerName', c.NAME_LENGTH),
      rival: readText('wRivalName', c.NAME_LENGTH),
      id: be16(b, o('wPlayerID')),
      money: be24(b, o('wMoney')),
      momsMoney: be24(b, o('wMomsMoney')),
      coins: be16(b, o('wCoins')),
      character: b[l.sram.sCrystalData],
      blueCard: b[o('wBlueCardBalance')],
    },
    bag,
    tms: Array.from(b.slice(o('wTMsHMs'), o('wTMsHMsEnd'))),
    dex: { caught: bitArray('wPokedexCaught'), seen: bitArray('wPokedexSeen') },
    rules: b[o('wGameplayRules')],
    badges: be16(b, o('wJohtoBadges')),
    hardMode: !!(b[o('wStatusFlags2')] & 8),
    flags,
    daycare,
    debugCharacters: false,
    baseline: '',
  };
  model.baseline = semantic(model);
  model.diagnostics = validate(model);
  return model;
}
