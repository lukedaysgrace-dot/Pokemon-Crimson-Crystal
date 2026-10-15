import type { SaveModel, Diagnostic, Mon } from './model';
import { wramOffset } from './copies';
import { le16 } from './bytes';
import { encode } from './text';
import { maxPP, stats, expAtLevel } from './mechanics';
import { recordOffset } from './boxes';
export function validate(m: SaveModel): Diagnostic[] {
  const out: Diagnostic[] = [],
    l = m.data.layout,
    c = l.constants,
    b = m.original,
    copies = m.copies;
  const r = copies.source === 'backup' ? l.backup : l.main,
    o = (s: string) => wramOffset(l, r, s);
  const add = (severity: Diagnostic['severity'], message: string, symbol: string, offset: number) =>
    out.push({ severity, message, symbol, offset });
  if (!copies.source) {
    add(
      'ERROR',
      'Neither save copy validates for this build. Select the exact build profile; editing is disabled.',
      'sSaveVersion',
      l.sram.sSaveVersion,
    );
    return out;
  }
  for (const kind of ['main', 'backup'] as const) {
    const v = copies[kind];
    add(
      v.valid ? 'INFO' : 'WARN',
      `${kind}: game checksum ${v.storedGame.toString(16)}/${v.game.toString(16)}, move checksum ${v.storedMove.toString(16)}/${v.move.toString(16)}; ${v.valid ? 'valid' : 'will be repaired on export'}`,
      kind === 'main' ? 'sChecksum' : 'sBackupChecksum',
      l[kind].checksum,
    );
  }
  if (b.length > 65536 && b.length !== 65584)
    add(
      'WARN',
      `Unrecognized ${b.length - 65536}-byte RTC trailer; preserved verbatim.`,
      'RTC',
      65536,
    );
  for (let bank = 0; bank < 8; bank++)
    if (b.slice(bank * 8192, (bank + 1) * 8192).every((v) => v === 0))
      add('INFO', `SRAM bank ${bank} is all zero.`, 'SRAM', bank * 8192);
  if (![0, 1].includes(b[l.sram.sWritingBackup]))
    add('ERROR', 'Invalid save phase.', 'sWritingBackup', l.sram.sWritingBackup);
  const differences = (a: number, d: number, size: number) => {
    let n = 0;
    for (let i = 0; i < size; i++) if (b[a + i] !== b[d + i]) n++;
    return n;
  };
  const gameDiff = differences(l.main.start, l.backup.start, l.main.end - l.main.start),
    boxDiff = differences(l.sram.sNewBox1, l.sram.sBackupNewBox1, c.NUM_BOXES * l.newbox.size);
  if (gameDiff)
    add(
      'WARN',
      `${gameDiff} differing bytes between game copies; ${copies.source} is authoritative.`,
      'sSaveData',
      r.start,
    );
  if (boxDiff)
    add(
      'WARN',
      `${boxDiff} differing bytes between box snapshots; game selects ${copies.snapshot === l.sram.sNewBox1 ? 'active' : 'backup'}.`,
      'sNewBox1',
      copies.snapshot,
    );
  for (const kind of ['mon', 'move'] as const) {
    const p = l.tables[kind],
      start = kind === 'mon' ? r.monTable : r.moveTable,
      entries = Array.from({ length: p.entries }, (_, i) => le16(b, start + 2 + i * 2)),
      live = entries.filter(Boolean);
    if (b[start] !== live.length)
      add(
        'ERROR',
        `UsedSlots ${b[start]} differs from ${live.length} occupied entries.`,
        kind + ' table',
        start,
      );
    if (new Set(live).size !== live.length)
      add('ERROR', 'Duplicate conversion table indexes.', kind + ' table', start);
    if (live.some((n) => n > (kind === 'mon' ? c.NUM_POKEMON : c.NUM_ATTACKS)))
      add('ERROR', 'Unknown conversion table index.', kind + ' table', start);
    add(
      'INFO',
      `${p.entries - live.length} free ${kind} conversion slots.`,
      kind + ' table',
      start,
    );
  }
  const range = (v: number, min: number, max: number, field: string, offset: number) => {
    if (!Number.isInteger(v) || v < min || v > max)
      add('ERROR', `${field}: expected integer ${min}–${max}, got ${v}.`, field, offset);
  };
  const name = (
    s: string,
    size: number,
    max: number,
    field: string,
    offset: number,
    box = false,
  ) => {
    try {
      encode(
        s,
        size,
        max,
        m.data.charmap,
        m.debugCharacters ? undefined : box ? m.data.boxKeyboard : m.data.keyboard,
      );
    } catch (e) {
      add('ERROR', `${field}: ${String(e)}`, field, offset);
    }
  };
  const checkMon = (mon: Mon, field: string, offset: number, box: boolean, names = true) => {
    const s = m.data.species.find((s) => s.index === mon.species);
    if (mon.bad) {
      add(
        'ERROR',
        'Bad Egg: record checksum mismatch; inspect or delete this slot.',
        field,
        offset,
      );
      return;
    }
    if (!s) {
      add('ERROR', `Unknown species index ${mon.species}.`, field, offset);
      return;
    }
    range(mon.level, 1, 100, field + ' level', offset);
    range(mon.item, 0, 254, field + ' item', offset);
    range(mon.id, 0, 65535, field + ' OT ID', offset);
    range(mon.exp, 0, 0xffffff, field + ' experience', offset);
    range(mon.happiness, 0, 255, field + ' happiness', offset);
    range(mon.pokerus, 0, box ? 63 : 255, field + ' Pokérus', offset);
    range(mon.personality, 0, 255, field + ' personality', offset);
    if (
      mon.moves.length !== 4 ||
      mon.ups.length !== 4 ||
      mon.pp.length !== 4 ||
      mon.dvs.length !== 4 ||
      mon.statExp.length !== 5 ||
      mon.caught.length !== 2
    )
      add('ERROR', 'Malformed Pokémon array lengths.', field, offset);
    mon.dvs.forEach((n) => range(n, 0, 15, field + ' DV', offset));
    mon.statExp.forEach((n) => range(n, 0, 65535, field + ' Stat Exp', offset));
    mon.caught.forEach((n) => range(n, 0, 255, field + ' caught data', offset));
    const held = m.data.items.find((i) => i.index === mon.item);
    if (mon.item && (!held || [c.KEY_ITEM, c.TM_HM].includes(held.pocket)))
      add('ERROR', 'Invalid held item pocket.', field, offset);
    // Existing party mail and its untouched SRAM payload are allowed; new mail is blocked by the writer.
    if (box && held?.mail) add('ERROR', 'Boxed Pokémon cannot hold mail.', field, offset);
    mon.moves.forEach((n, i) => {
      const move = m.data.moves.find((x) => x.index === n);
      range(mon.ups[i], 0, 3, field + ' PP Ups', offset);
      if (n && !move) add('ERROR', `Unknown move index ${n}.`, field, offset);
      if (!box)
        range(mon.pp[i], 0, maxPP(move?.pp || 0, mon.ups[i]), field + ` PP ${i + 1}`, offset);
      if (
        n &&
        ![...s.tmhm, ...s.tutor, ...s.eggMoves, ...s.levelMoves.map((x) => x.move)].includes(n)
      )
        add('INFO', `${move?.name || n} is outside this species' learnsets.`, field, offset);
    });
    if (mon.hpType && !m.data.types.some((t) => t.index === mon.hpType))
      add('ERROR', 'Unknown Hidden Power type.', field, offset);
    if ((mon.personality & 31) >= m.data.balls.length)
      add('ERROR', 'Unknown caught ball.', field, offset);
    if (names) {
      name(
        mon.nickname,
        box ? l.boxed.NAME_LENGTH : c.MON_NAME_LENGTH,
        c.MON_NAME_LENGTH - 1,
        field + ' nickname',
        offset,
        box,
      );
      name(
        mon.ot,
        box ? l.boxed.NAME_LENGTH : c.NAME_LENGTH,
        box ? l.boxed.NAME_LENGTH : c.NAME_LENGTH - 1,
        field + ' OT',
        offset,
        box,
      );
    }
    const expected = expAtLevel(m.data.growth[s.growth], mon.level),
      next = expAtLevel(m.data.growth[s.growth], mon.level + 1);
    if (mon.exp < expected || (mon.level < 100 && mon.exp >= next))
      add('WARN', 'Experience is outside this level band.', field, offset);
    if (!box && mon.raw.length >= l.party.size) {
      range(mon.hp, 0, mon.stats[0] || 999, field + ' HP', offset);
      range(mon.status, 0, 127, field + ' status', offset);
      if (
        JSON.stringify(mon.stats) !==
        JSON.stringify(stats(s, mon.dvs, mon.statExp, mon.level, m.rules))
      )
        add('WARN', 'Stored stats differ from the current species/rules formula.', field, offset);
      const count = m.badges.toString(2).replaceAll('0', '').length,
        cap = m.data.caps[Math.min(count, m.data.caps.length - 1)];
      if (m.hardMode && cap && mon.level > cap)
        add('WARN', `Level exceeds Hard Mode cap ${cap}.`, field, offset);
      if (!mon.hp && mon.status) add('WARN', 'Fainted Pokémon has status.', field, offset);
    }
    if (!s.abilities[Math.max(0, ((mon.personality >>> 5) & 3) - 1)])
      add('INFO', 'Ability slot falls back to ability 1.', field, offset);
  };
  if (m.party.length > c.PARTY_LENGTH)
    add('ERROR', 'Party exceeds capacity.', 'wPartyCount', o('wPartyCount'));
  if (b[o('wPartyCount')] > c.PARTY_LENGTH || b[o('wPartySpecies') + b[o('wPartyCount')]] !== 255)
    add('ERROR', 'Party count/species terminator is invalid.', 'wPartySpecies', o('wPartySpecies'));
  m.party.forEach((mon, i) =>
    checkMon(mon, `Party ${i + 1}`, o('wPartyMon1') + i * l.party.size, false),
  );
  const pointers = new Set<string>();
  m.boxes.forEach((box, i) => {
    const offset = copies.snapshot + i * l.newbox.size;
    name(
      box.name,
      l.newbox.Theme - l.newbox.Name,
      l.newbox.Theme - l.newbox.Name - 1,
      `Box ${i + 1}`,
      offset,
      true,
    );
    if (!m.data.themes.some((t) => t.index === box.theme))
      add('ERROR', 'Unknown box theme.', 'Box theme', offset);
    box.slots.forEach((mon, slot) => {
      if (!mon) {
        if (box.raw[slot] > c.MONDB_ENTRIES)
          add('WARN', 'Invalid box entry treated as empty by game.', `Box ${i + 1}`, offset + slot);
        return;
      }
      const ptr = mon.pointer,
        key = ptr ? `${ptr.pool}:${ptr.entry}` : '';
      if (key && pointers.has(key))
        add('ERROR', `Duplicate PokeDB pointer ${key}.`, 'Box pointer', offset + slot);
      if (key) pointers.add(key);
      checkMon(
        mon,
        `Box ${i + 1} slot ${slot + 1}`,
        ptr ? recordOffset(l, ptr.pool, ptr.entry) : offset + slot,
        true,
      );
    });
  });
  m.daycare
    .filter((d) => d.active)
    .forEach((d) => checkMon(d.mon, d.symbol, o(d.symbol), false, !!d.nicknameSymbol));
  const pockets: Record<string, [string, string, number | null]> = {
    items: ['wNumItems', 'MAX_ITEMS', c.ITEM],
    balls: ['wNumBalls', 'MAX_BALLS', c.BALL],
    key: ['wNumKeyItems', 'MAX_KEY_ITEMS', c.KEY_ITEM],
    pc: ['wNumPCItems', 'MAX_PC_ITEMS', null],
  };
  for (const [key, [symbol, limit, pocket]] of Object.entries(pockets)) {
    const stacks = m.bag[key];
    range(stacks.length, 0, c[limit], key + ' count', o(symbol));
    if (new Set(stacks.map((s) => s.item)).size !== stacks.length)
      add('ERROR', 'Duplicate bag stacks.', symbol, o(symbol));
    for (const stack of stacks) {
      const item = m.data.items.find((i) => i.index === stack.item);
      if (!item || !stack.item || stack.item === 255 || (pocket !== null && item.pocket !== pocket))
        add('ERROR', `Invalid ${key} item ${stack.item}.`, symbol, o(symbol));
      range(stack.quantity, 1, key === 'key' ? 1 : 99, key + ' quantity', o(symbol));
    }
  }
  m.tms.forEach((n) => range(n, 0, 1, 'TM/HM quantity', o('wTMsHMs')));
  name(m.player.name, c.NAME_LENGTH, c.PLAYER_NAME_LENGTH - 1, 'Player name', o('wPlayerName'));
  name(m.player.rival, c.NAME_LENGTH, c.PLAYER_NAME_LENGTH - 1, 'Rival name', o('wRivalName'));
  range(m.player.money, 0, c.MAX_MONEY, 'Money', o('wMoney'));
  range(m.player.momsMoney, 0, c.MAX_MONEY, 'Mom money', o('wMomsMoney'));
  range(m.player.coins, 0, c.MAX_COINS, 'Coins', o('wCoins'));
  range(m.player.id, 0, 65535, 'Player ID', o('wPlayerID'));
  range(m.player.blueCard, 0, 255, 'Blue Card', o('wBlueCardBalance'));
  range(m.rules, 0, 7, 'Gameplay rules', o('wGameplayRules'));
  range(m.badges, 0, 65535, 'Badges', o('wJohtoBadges'));
  if (!m.data.characters.some((ch) => ch.index === m.player.character))
    add('ERROR', 'Unknown player character.', 'sCrystalData', l.sram.sCrystalData);
  const owned = [
    ...m.party,
    ...m.boxes.flatMap((box) => box.slots.filter((mon): mon is Mon => !!mon)),
  ];
  for (const mon of owned)
    if (
      !mon.egg &&
      mon.species > 0 &&
      mon.species <= c.NUM_POKEMON &&
      !m.dex.caught[mon.species - 1]
    )
      add(
        'INFO',
        `Owned species ${mon.species} is not marked caught.`,
        'wPokedexCaught',
        o('wPokedexCaught') + ((mon.species - 1) >>> 3),
      );
  return out;
}
