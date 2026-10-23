import { describe, it, expect } from 'vitest';
import { readFileSync, existsSync } from 'node:fs';
import { evaluate, Constants } from '../src/extractors/asm/constants';
import { parseSymbols, fileOffset } from '../src/extractors/sym';
import { parse, detect } from '../src/lib/save/parse';
import { write } from '../src/lib/save/write';
import { verify, fixChecksums, wramOffset } from '../src/lib/save/copies';
import { idToIndex, indexToId } from '../src/lib/save/tables';
import {
  stats,
  calcStat,
  expAtLevel,
  maxPP,
  hpDV,
  gender,
  ability,
  foldPokerus,
} from '../src/lib/save/mechanics';
import { encode, decode } from '../src/lib/save/text';
import { container } from '../src/lib/save/container';
import { savemonChecksum, setLE16, le16, equal } from '../src/lib/save/bytes';
import { recordOffset } from '../src/lib/save/boxes';
import { template } from '../src/lib/save/mon';
import { validate } from '../src/lib/save/validate';
import { migrate } from '../src/lib/save/migrate';
import { fixture, emptySave, game } from './fixture';
const errors = (m: ReturnType<typeof parse>) => validate(m).filter((d) => d.severity === 'ERROR');

describe('source and layout', () => {
  it('evaluates integer arithmetic with RGBDS precedence', () => {
    expect(evaluate('($ff + 1) >> 2 | %11', () => 0)).toBe(67);
    expect(evaluate('-15 * 3 + 8 / 3', () => 0)).toBe(-43);
    expect(evaluate('50 percent', () => 0)).toBe(127);
    expect(() => evaluate('process.exit()', () => 0)).toThrow();
  });
  it('handles constants, skipped slots, aliases, enums and signed steps', () => {
    const c = new Constants();
    c.parse(
      'const_def 1\nconst A\nconst_skip 2\nconst B\nN EQU const_value\nOFF EQUS "(B - A)"\nenum_start 7, -1\nenum X\nenum Y',
      'sample.asm',
    );
    expect([c.get('A'), c.get('B'), c.get('N'), c.get('OFF'), c.get('X'), c.get('Y')]).toEqual([
      1, 4, 5, 3, 7, 6,
    ]);
    expect(c.provenance.B).toBe('sample.asm:4');
    expect(() => c.parse('const ???', 'broken')).toThrow('broken:1');
  });
  it('derives addresses and struct lengths from symbols', () => {
    expect(fileOffset(parseSymbols('01:a009 sSaveData').sSaveData)).toBe(0x2009);
    expect(game.layout.party.size).toBe(50);
    expect(game.layout.boxed.STRUCT_LENGTH).toBe(57);
    expect(game.layout.newbox.size).toBe(33);
    expect(
      game.species
        .filter((s) => ['MEOWTH', 'MEOWTH_ALOLAN', 'MEOWTH_GALARIAN'].includes(s.const))
        .map((s) => s.index),
    ).toHaveLength(3);
    expect(game.species).toHaveLength(game.layout.constants.NUM_POKEMON);
    expect(game.species[0].name).toBe('BULBASAUR');
    expect(game.species[0].sprite).toMatch(/^BULBASAUR\//);
    expect(game.species.find((s) => s.const === 'MEOWTH_GALARIAN')?.name).toBe('MEOWTH');
    expect(game.characters).toHaveLength(4);
  });
});
describe('mechanics and byte codecs', () => {
  it('uses all six integer growth curves including level one', () => {
    expect(game.growth.map((g) => expAtLevel(g, 1))).toEqual([0, 0, 0, 0, 0, 0]);
    expect(game.growth.map((g) => expAtLevel(g, 100))).toEqual([
      1000000, 849970, 949930, 1059860, 800000, 1250000,
    ]);
    for (const g of game.growth)
      for (let n = 2; n <= 100; n++)
        expect(expAtLevel(g, n)).toBeGreaterThanOrEqual(expAtLevel(g, n - 1));
  });
  it('matches stat, HP-DV and max-PP boundary vectors', () => {
    expect(calcStat(45, 15, 0, 100, true)).toBe(230);
    expect(calcStat(45, 15, 65535, 100, true)).toBe(293);
    expect(calcStat(255, 15, 65535, 100, false)).toBe(608);
    expect(hpDV([15, 14, 13, 12])).toBe(10);
    expect([5, 10, 35, 40].map((b) => [0, 1, 2, 3].map((u) => maxPP(b, u)))).toEqual([
      [5, 6, 7, 8],
      [10, 12, 14, 16],
      [35, 42, 49, 56],
      [40, 47, 54, 61],
    ]);
    const s = game.species[0];
    expect(ability(s, 0, 0)).toBe(s.abilities[0]);
    expect(ability(s, 3, 4)).toBe(0);
    expect(gender({ ...s, gender: 255 }, true)).toBe('Genderless');
    expect(foldPokerus(0x52)).toBe(0x12);
    expect(foldPokerus(0x40)).toBe(0x10);
  });
  it('encodes text tokens and does not mutate input', () => {
    const raw = encode('A<PK><MN>', 11, 10, game.charmap),
      copy = raw.slice();
    expect(decode(raw, game.charmap)).toBe('A<PK><MN>');
    expect(raw).toEqual(copy);
    expect(() => encode('123', 11, 7, game.charmap, game.keyboard)).toThrow();
    expect(() => encode('ABCDEFGHIJK', 11, 10, game.charmap)).toThrow();
  });
  it('allocates IDs beyond 255 without freeing live entries', () => {
    const p = game.layout.tables.mon,
      b = new Uint8Array(p.size);
    const id = indexToId(b, 495, p);
    expect(id).toBe(1);
    expect(b[0]).toBe(1);
    expect(indexToId(b, 495, p)).toBe(1);
    expect(idToIndex(b, id, p)).toBe(495);
    expect(idToIndex(b, 253, p)).toBe(0xfffd);
    for (let i = 2; i <= p.entries; i++) indexToId(b, i, p);
    expect(() => indexToId(b, 496, p)).toThrow('table full');
  });
  it('checks record weights and section boundaries', () => {
    const b = new Uint8Array(57);
    expect(savemonChecksum(b)).toBe(127);
    b[0] = 1;
    expect(savemonChecksum(b)).toBe(182);
    b[54] = 1;
    expect(savemonChecksum(b)).toBe(183);
    const l = game.layout;
    expect(recordOffset(l, 1, 144)).toBe(l.sram.sBoxMons1B);
    expect(recordOffset(l, 2, 254)).toBe(l.sram.sBoxMons2B + 110 * 57);
    expect(() => recordOffset(l, 1, 255)).toThrow();
  });
});
describe('save read/write transactions', () => {
  it('round trips Phantump, Trevenant, Horn Leech, ability slots and expanded Dex flags', () => {
    expect(game.layout.constants.SAVE_FORMAT_VERSION).toBe(4);
    expect(game.species).toHaveLength(498);
    // Later builds append moves (441 Grass Knot, 442 Heavy Slam); indices never shift.
    expect(game.moves).toHaveLength(game.layout.constants.NUM_ATTACKS);
    expect(game.moves.length).toBeGreaterThanOrEqual(440);
    const horn = game.moves.find((move) => move.const === 'HORN_LEECH')!;
    const reference = JSON.parse(readFileSync(new URL('../../tools/testdata/phantump_trevenant.json', import.meta.url), 'utf8'));
    expect(horn).toMatchObject({ index: 440, power: 75, accuracy: 100, pp: 10, category: 0 });
    for (const constant of ['PHANTUMP', 'TREVENANT']) {
      const species = game.species.find((entry) => entry.const === constant)!;
      if (constant === 'PHANTUMP') expect(species.evolutions).toEqual([
        expect.objectContaining({ args: [32], target: 498 }),
      ]);
      expect(species.levelMoves).toContainEqual({ level: 28, move: horn.index });
      expect(species.abilities.map((id) => game.abilities.find((a) => a.index === id)?.const))
        .toEqual(['NATURAL_CURE', 'FRISK', 'HARVEST']);
      expect(species.tutor.map((id) => game.moves.find((move) => move.index === id)?.const))
        .toEqual(expect.arrayContaining(['GIGA_DRAIN', 'SEED_BOMB', 'TRICK', 'TRICK_ROOM']));
      expect(species.eggMoves.map((id) => game.moves.find((move) => move.index === id)?.const))
        .toEqual(expect.arrayContaining(['DISABLE', 'SUCKER_PUNCH']));
      const supported = [...species.levelMoves.map((row) => row.move), ...species.tmhm, ...species.eggMoves, ...species.tutor]
        .map((id) => game.moves.find((move) => move.index === id)?.const);
      expect(supported).toEqual(expect.arrayContaining(reference.species[constant].expected));
      for (const slot of [1, 2, 3]) {
        const model = parse(fixture(), game);
        const mon = model.party[0];
        mon.species = species.index;
        mon.moves = [horn.index, 0, 0, 0];
        mon.pp = [10, 0, 0, 0];
        mon.ups = [0, 0, 0, 0];
        mon.personality = (mon.personality & 159) | (slot << 5);
        mon.shiny = slot === 3;
        const boxed = template(game, model.player, true, model.rules);
        Object.assign(boxed, { species: species.index, moves: [...mon.moves], pp: [...mon.pp],
          ups: [...mon.ups], personality: mon.personality, shiny: mon.shiny });
        model.boxes[24].slots[19] = boxed;
        model.dex.seen[species.index - 1] = true;
        model.dex.caught[species.index - 1] = true;
        const bytes = write(model), reread = parse(bytes, game);
        expect(errors(reread)).toEqual([]);
        expect(reread.party[0]).toMatchObject({ species: species.index, moves: mon.moves, shiny: mon.shiny });
        expect(reread.boxes[24].slots[19]).toMatchObject({ species: species.index, moves: mon.moves, shiny: mon.shiny });
        expect(ability(species, (reread.party[0].personality >>> 5) & 3, model.rules)).toBe(species.abilities[slot - 1]);
        expect(reread.dex.seen[species.index - 1]).toBe(true);
        expect(reread.dex.caught[species.index - 1]).toBe(true);
        expect(verify(bytes, game.layout, game.layout.main).valid).toBe(true);
        expect(verify(bytes, game.layout, game.layout.backup).valid).toBe(true);
      }
    }
  });
  it('retains and detects format-3 saves without rewriting them as format 4', () => {
    const old = JSON.parse(readFileSync(new URL('../static/gamedata/c1a7287b.json', import.meta.url), 'utf8'));
    expect(old.layout.constants.SAVE_FORMAT_VERSION).toBe(3);
    expect(old.species).toHaveLength(496);
    const bytes = fixture(old);
    expect(detect(bytes, [game, old])).toBe(old);
    expect(write(parse(bytes, old))).toEqual(bytes);
    const result = migrate(parse(bytes, old), parse(emptySave(), game));
    expect(errors(parse(result.bytes, game))).toEqual([]);
    expect(result.bytes[game.layout.sram.sSaveVersion]).toBe(4);
  });
  it('round trips Jirachi and every October move in party and boxed records', () => {
    const jirachi = game.species.find((s) => s.const === 'JIRACHI')!;
    expect(jirachi.index).toBe(496);
    const additions = game.moves.filter((m) => m.index > 421 && m.index <= 439);
    expect(additions).toHaveLength(18);
    expect(game.moves.find((m) => m.const === 'DOOM_DESIRE')).toMatchObject({ power: 160, accuracy: 100 });
    for (let i = 0; i < additions.length; i += 4) {
      const model = parse(fixture(), game);
      const moves = additions.slice(i, i + 4).map((m) => m.index);
      while (moves.length < 4) moves.push(0);
      const mon = model.party[0];
      mon.species = jirachi.index;
      mon.moves = moves;
      mon.ups = [0, 1, 2, 3];
      mon.pp = moves.map((id, slot) => id ? maxPP(game.moves[id - 1].pp, mon.ups[slot]) : 0);
      const boxed = template(game, model.player, true, 0);
      boxed.species = jirachi.index;
      boxed.moves = [...moves];
      boxed.ups = [...mon.ups];
      model.boxes[24].slots[19] = boxed;
      const reread = parse(write(model), game);
      expect(errors(reread)).toEqual([]);
      expect(reread.party[0].species).toBe(jirachi.index);
      expect(reread.party[0].moves).toEqual(moves);
      expect(reread.party[0].pp).toEqual(mon.pp);
      expect(reread.boxes[24].slots[19]?.species).toBe(jirachi.index);
      expect(reread.boxes[24].slots[19]?.moves).toEqual(moves);
    }
  });
  it('rejects truncated saves and preserves supported trailers', () => {
    expect(() => container(new Uint8Array(32768))).toThrow('MBC30');
    expect(() => container(new Uint8Array(65534))).toThrow();
    expect(container(emptySave()).trailer).toHaveLength(48);
  });
  it('round trips clean data byte-for-byte without input mutation', () => {
    const b = fixture(),
      before = b.slice(),
      m = parse(b, game);
    expect(errors(m)).toEqual([]);
    expect(write(m)).toEqual(b);
    expect(b).toEqual(before);
    expect(detect(b, [game])).toBe(game);
  });
  it('preserves unknown bytes on edits, mirrors copies and keeps the RTC', () => {
    const b = fixture(),
      m = parse(b, game);
    m.player.money = 999999;
    m.party[0].nickname = 'CRIMSON';
    const edited = write(m),
      reread = parse(edited, game);
    expect(reread.player.money).toBe(999999);
    expect(reread.party[0].nickname).toBe('CRIMSON');
    expect(edited[60000]).toBe(0x9a);
    expect(edited.slice(65536)).toEqual(b.slice(65536));
    expect(errors(reread)).toEqual([]);
    expect(verify(edited, game.layout, game.layout.main).valid).toBe(true);
    expect(verify(edited, game.layout, game.layout.backup).valid).toBe(true);
    expect(edited.slice(game.layout.sram.sNewBox1, game.layout.sram.sNewBoxEnd)).toEqual(
      edited.slice(game.layout.sram.sBackupNewBox1, game.layout.sram.sBackupNewBoxEnd),
    );
  });
  it('uses the game recovery decision table and repairs both copies', () => {
    const b = fixture(),
      l = game.layout;
    b[l.main.start] ^= 1;
    let m = parse(b, game);
    expect(m.copies.source).toBe('backup');
    expect(errors(m)).toEqual([]);
    const repaired = write(m);
    expect(parse(repaired, game).copies.main.valid).toBe(true);
    const mid = fixture();
    mid[l.sram.sWritingBackup] = 1;
    mid[l.sram.sNewBox1 + l.newbox.Theme] = 1;
    m = parse(mid, game);
    expect(m.boxes[0].theme).toBe(1);
    expect(parse(write(m), game).boxes[0].theme).toBe(1);
    b[l.backup.start] ^= 1;
    expect(parse(b, game).copies.source).toBeNull();
    expect(() => write(parse(b, game))).toThrow('Neither');
  });
  it('detects Bad Eggs, duplicate pointers, invalid tables and bags', () => {
    const b = fixture(),
      l = game.layout;
    b[recordOffset(l, 1, 1)] ^= 1;
    const bad = parse(b, game);
    expect(errors(bad).some((d) => d.message.includes('Bad Egg'))).toBe(true);
    expect(() => write(bad)).toThrow('Bad Egg');
    bad.boxes[0].slots[0] = null;
    expect(errors(parse(write(bad), game))).toEqual([]);
    const m = parse(fixture(), game);
    m.boxes[0].slots[1] = structuredClone(m.boxes[0].slots[0]);
    expect(errors(m).some((d) => d.message.includes('Duplicate PokeDB'))).toBe(true);
    const corrupt = fixture();
    corrupt[l.main.monTable]++;
    fixChecksums(corrupt, l);
    expect(errors(parse(corrupt, game)).some((d) => d.message.includes('UsedSlots'))).toBe(true);
    const bag = parse(fixture(), game);
    bag.bag.items = [
      { item: game.items.find((i) => i.pocket === l.constants.BALL)!.index, quantity: 100 },
    ];
    expect(errors(bag).length).toBeGreaterThan(0);
  });
  it('randomized semantic edits survive reparse, including high IDs and both pools', () => {
    let seed = 713;
    const rand = (n: number) => {
      seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0;
      return seed % n;
    };
    const initial = fixture();
    for (let i = 0; i < 80; i++) {
      const m = parse(initial, game),
        mon = m.party[0],
        s = game.species[rand(game.species.length)];
      mon.species = s.index;
      mon.level = 1 + rand(100);
      mon.exp = expAtLevel(game.growth[s.growth], mon.level);
      mon.dvs = Array.from({ length: 4 }, () => rand(16));
      mon.statExp = Array.from({ length: 5 }, () => rand(65536));
      mon.shiny = !!rand(2);
      mon.male = !!rand(2);
      mon.egg = !!rand(2);
      mon.hpType = game.types[rand(game.types.length)].index;
      mon.personality = ((1 + rand(3)) << 5) | rand(game.balls.length);
      mon.moves = Array.from({ length: 4 }, () => 1 + rand(game.moves.length));
      mon.ups = [0, 1, 2, 3];
      mon.pp = mon.moves.map((n, j) => maxPP(game.moves[n - 1].pp, mon.ups[j]));
      const boxed = template(game, m.player, true, 0);
      boxed.species = s.index;
      boxed.moves = [...mon.moves];
      boxed.ups = [...mon.ups];
      boxed.shiny = true;
      boxed.hpType = mon.hpType;
      boxed.pointer = { pool: 2, entry: 144 + rand(100) };
      m.boxes[24].slots[19] = boxed;
      const output = write(m),
        reread = parse(output, game);
      expect(errors(reread)).toEqual([]);
      const a = reread.party[0];
      for (const key of [
        'species',
        'level',
        'exp',
        'dvs',
        'statExp',
        'shiny',
        'male',
        'egg',
        'hpType',
        'personality',
        'moves',
        'ups',
      ] as const)
        expect(a[key]).toEqual(mon[key]);
      expect(reread.boxes[24].slots[19]?.moves).toEqual(mon.moves);
      expect(reread.boxes[24].slots[19]?.pointer?.pool).toBe(2);
      expect(write(reread)).toEqual(output);
    }
  }, 30000);
});
describe('historical fixtures (when present locally)', () => {
  const profilePath = new URL('../static/gamedata/5dc51b77.json', import.meta.url);
  it('keeps distinct layout hashes without relying on the version byte', () => {
    if (!existsSync(profilePath)) return;
    const old = JSON.parse(readFileSync(profilePath, 'utf8'));
    const previous = JSON.parse(readFileSync(new URL('../static/gamedata/06c4a7bb.json', import.meta.url), 'utf8'));
    expect(old.layout.constants.SAVE_FORMAT_VERSION).toBe(
      previous.layout.constants.SAVE_FORMAT_VERSION,
    );
    expect(old.layout.layoutHash).not.toBe(previous.layout.layoutHash);
    expect(old.layout.layoutHash).not.toBe(game.layout.layoutHash);
  });
  for (const name of [
    'pokecrystal.sav.before-elemental-sphere-20260909-2005.bak',
    'pokecrystal.sav.before-key-item-fix-20260909-2008.bak',
  ])
    it.skipIf(!existsSync(new URL(`../../${name}`, import.meta.url)))(
      `historical save: ${name}`,
      () => {
        const path = new URL(`../../${name}`, import.meta.url);
        const old = JSON.parse(readFileSync(profilePath, 'utf8')),
          b = new Uint8Array(readFileSync(path)),
          data = detect(b, [game, old]);
        expect(data?.layout.build).toBe(old.layout.build);
        const m = parse(b, data!);
        expect(m.party[0].species).toBe(159);
        expect(m.party[0].level).toBe(100);
        if (name.includes('key-item-fix')) {
          // This fixture predates the pocket fix: ELEMENTAL_SPHERE is incorrectly in Items.
          expect(errors(m).map((d) => d.message)).toEqual(['Invalid items item 191.']);
          m.bag.items = m.bag.items.filter((s) => s.item !== 191);
          m.bag.key.push({ item: 191, quantity: 1 });
          expect(errors(parse(write(m), old))).toEqual([]);
        } else {
          expect(errors(m)).toEqual([]);
          expect(write(m)).toEqual(b);
        }
      },
    );
});
describe('developer tools', () => {
  it('creates blank party mail and mirrors its payload', () => {
    const m = parse(fixture(), game),
      mail = game.items.find((i) => i.mail)!;
    m.party[0].item = mail.index;
    const b = write(m),
      l = game.layout,
      length = l.sram.sPartyMon1MailEnd - l.sram.sPartyMon1Mail;
    expect(b.slice(l.sram.sPartyMail, l.sram.sPartyMail + length)).toEqual(
      b.slice(l.sram.sPartyMailBackup, l.sram.sPartyMailBackup + length),
    );
    expect(b[l.sram.sPartyMon1MailType]).toBe(mail.index);
    expect(b[l.sram.sPartyMon1MailMessage]).toBe(game.charmap['@']);
    expect(errors(parse(b, game))).toEqual([]);
  });
  it('migrates roster and inventories by constants into a valid target template', () => {
    const source = parse(fixture(), game);
    source.party[0].nickname = 'MIGRATED';
    source.player.money = 456789;
    const target = parse(emptySave(), game),
      result = migrate(source, target),
      reread = parse(result.bytes, game);
    expect(reread.party[0].nickname).toBe('MIGRATED');
    expect(reread.player.money).toBe(456789);
    expect(reread.boxes[0].slots[0]?.species).toBe(1);
    expect(errors(reread)).toEqual([]);
    expect(result.report).toHaveLength(2);
  });
  it('detects the retained Jirachi format-2 layout and migrates it into format 4', () => {
    const old = JSON.parse(readFileSync(new URL('../static/gamedata/c1a7287b-v2.json', import.meta.url), 'utf8'));
    const bytes = fixture(old);
    expect(old.layout.constants.SAVE_FORMAT_VERSION).toBe(2);
    expect(game.layout.constants.SAVE_FORMAT_VERSION).toBe(4);
    expect(detect(bytes, [game, old])).toBe(old);
    const source = parse(bytes, old);
    source.party[0].species = old.species.find((s: { const: string }) => s.const === 'JIRACHI').index;
    source.party[0].moves = ['DOOM_DESIRE', 'METEOR_MASH', 'PSYSHOCK', 'RECYCLE'].map(
      (constant) => old.moves.find((m: { const: string }) => m.const === constant).index,
    );
    source.party[0].ups = [0, 0, 0, 0];
    source.party[0].pp = source.party[0].moves.map((id) => old.moves[id - 1].pp);
    const result = migrate(source, parse(emptySave(), game));
    const reread = parse(result.bytes, game);
    expect(errors(reread)).toEqual([]);
    expect(reread.party[0].species).toBe(496);
    expect(reread.party[0].moves).toEqual(source.party[0].moves);
    expect(result.bytes[game.layout.sram.sSaveVersion]).toBe(4);
  });
  it('saves an event flag and preserves unrelated bits', () => {
    const m = parse(fixture(), game),
      f = game.flags.find((f) => f.kind === 'event')!;
    m.flags[f.const] = true;
    const reread = parse(write(m), game);
    expect(reread.flags[f.const]).toBe(true);
  });
  it('writes counted pockets and TM quantities without crossing field boundaries', () => {
    const m = parse(fixture(), game),
      c = game.layout.constants;
    for (const [key, pocket, max] of [
      ['items', c.ITEM, c.MAX_ITEMS],
      ['balls', c.BALL, c.MAX_BALLS],
      ['key', c.KEY_ITEM, c.MAX_KEY_ITEMS],
      ['pc', c.ITEM, c.MAX_PC_ITEMS],
    ] as const) {
      m.bag[key] = game.items
        .filter((x) => x.index > 0 && x.index < 255 && x.pocket === pocket)
        .slice(0, max)
        .map((x) => ({ item: x.index, quantity: key === 'key' ? 1 : 99 }));
    }
    m.tms.fill(1);
    const read = parse(write(m), game);
    expect(read.bag).toEqual(m.bag);
    expect(read.tms).toEqual(m.tms);
    expect(errors(read)).toEqual([]);
  });
  it('engine badge and gameplay-rule flags persist alongside structured controls', () => {
    const m = parse(fixture(), game),
      badge = game.flags.find((f) => f.symbol === 'wJohtoBadges')!,
      rule = game.flags.find((f) => f.symbol === 'wGameplayRules')!;
    m.flags[badge.const] = true;
    m.flags[rule.const] = true;
    const read = parse(write(m), game);
    expect(read.flags[badge.const]).toBe(true);
    expect(read.rules & rule.mask).toBe(rule.mask);
  });
  it('box moves preserve the record and both snapshot pointer maps', () => {
    const m = parse(fixture(), game),
      original = m.boxes[0].slots[0]!;
    m.boxes[24].slots[19] = original;
    m.boxes[0].slots[0] = null;
    const read = parse(write(m), game);
    expect(read.boxes[0].slots[0]).toBeNull();
    expect(read.boxes[24].slots[19]?.pointer).toEqual(original.pointer);
    expect(read.boxes[24].slots[19]?.raw).toEqual(original.raw);
  });
});
