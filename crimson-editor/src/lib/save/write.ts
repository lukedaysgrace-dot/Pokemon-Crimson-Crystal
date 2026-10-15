import type { SaveModel } from './model';
import { semantic } from './model';
import { validate } from './validate';
import { parse } from './parse';
import { fixChecksums, wramOffset } from './copies';
import { encodeMon } from './mon';
import { recordOffset } from './boxes';
import { encode } from './text';
import { setBE16, setBE24 } from './bytes';
import { blankMail } from './mail';

const same = (a: unknown, b: unknown) => JSON.stringify(a) === JSON.stringify(b);
/** Transactional: writes into a fresh buffer and verifies it before returning. */
export function write(m: SaveModel): Uint8Array {
  const errors = validate(m).filter((d) => d.severity === 'ERROR');
  if (errors.length) throw new Error(errors.map((d) => d.message).join('\n'));
  const b = new Uint8Array(m.original),
    g = m.data,
    l = g.layout,
    c = l.constants;
  const r = m.copies.source === 'backup' ? l.backup : l.main,
    o = (s: string) => wramOffset(l, r, s);
  const cleanCopies =
    m.copies.main.valid &&
    m.copies.backup.valid &&
    b[l.sram.sWritingBackup] === 0 &&
    same(
      Array.from(b.slice(l.main.options, l.main.check1)),
      Array.from(b.slice(l.backup.options, l.backup.check1)),
    ) &&
    same(
      Array.from(b.slice(l.main.start, l.main.end)),
      Array.from(b.slice(l.backup.start, l.backup.end)),
    ) &&
    same(
      Array.from(b.slice(l.main.moveTable, l.main.moveTable + l.tables.move.size)),
      Array.from(b.slice(l.backup.moveTable, l.backup.moveTable + l.tables.move.size)),
    ) &&
    same(
      Array.from(b.slice(l.sram.sNewBox1, l.sram.sNewBoxEnd)),
      Array.from(b.slice(l.sram.sBackupNewBox1, l.sram.sBackupNewBoxEnd)),
    );
  if (semantic(m) === m.baseline && cleanCopies) return b;
  const old = parse(m.original, g);
  const monTable = b.slice(r.monTable, r.monTable + l.tables.mon.size),
    moveTable = b.slice(r.moveTable, r.moveTable + l.tables.move.size);
  const text = (value: string, before: string, symbol: string, size: number, max: number) => {
    if (value !== before) b.set(encode(value, size, max, g.charmap), o(symbol));
  };
  text(m.player.name, old.player.name, 'wPlayerName', c.NAME_LENGTH, c.PLAYER_NAME_LENGTH - 1);
  text(m.player.rival, old.player.rival, 'wRivalName', c.NAME_LENGTH, c.PLAYER_NAME_LENGTH - 1);
  setBE16(b, o('wPlayerID'), m.player.id);
  setBE24(b, o('wMoney'), m.player.money);
  setBE24(b, o('wMomsMoney'), m.player.momsMoney);
  setBE16(b, o('wCoins'), m.player.coins);
  b[o('wBlueCardBalance')] = m.player.blueCard;
  // Flags first; structured controls below take precedence for overlapping bits.
  for (const flag of g.flags)
    if (m.flags[flag.const] !== old.flags[flag.const]) {
      const p = o(flag.symbol) + flag.offset;
      b[p] = (b[p] & ~flag.mask) | (m.flags[flag.const] ? flag.mask : 0);
    }
  if (m.rules !== old.rules) b[o('wGameplayRules')] = m.rules;
  if (m.badges !== old.badges) setBE16(b, o('wJohtoBadges'), m.badges);
  if (m.hardMode !== old.hardMode)
    b[o('wStatusFlags2')] = (b[o('wStatusFlags2')] & ~8) | (m.hardMode ? 8 : 0);
  const effectiveRules = b[o('wGameplayRules')];
  b[o('wPartyCount')] = m.party.length;
  m.party.forEach((mon, i) => {
    const before = old.party[i];
    if (!same(mon, before) || effectiveRules !== old.rules) {
      const raw = encodeMon(
        mon,
        g,
        false,
        monTable,
        moveTable,
        effectiveRules,
        effectiveRules !== old.rules ? undefined : before,
      );
      b.set(raw, o('wPartyMon1') + i * l.party.size);
      if (!before || mon.nickname !== before.nickname)
        b.set(
          encode(mon.nickname, c.MON_NAME_LENGTH, c.MON_NAME_LENGTH - 1, g.charmap),
          o('wPartyMonNicknames') + i * c.MON_NAME_LENGTH,
        );
      if (!before || mon.ot !== before.ot)
        b.set(
          encode(mon.ot, c.NAME_LENGTH, c.NAME_LENGTH - 1, g.charmap),
          o('wPartyMonOT') + i * c.NAME_LENGTH,
        );
      b[o('wPartySpecies') + i] = mon.egg ? l.tables.mon.reservedMin : raw[l.party.Species];
    }
    if (g.items.find((x) => x.index === mon.item)?.mail) {
      const mailSize = l.sram.sPartyMon1MailEnd - l.sram.sPartyMon1Mail;
      const previous = old.party.findIndex((x) => same(x.raw, mon.raw) && x.item === mon.item);
      const payload =
        previous >= 0
          ? m.original.slice(
              l.sram.sPartyMailBackup + previous * mailSize,
              l.sram.sPartyMailBackup + (previous + 1) * mailSize,
            )
          : blankMail(g, mon, b[o('wPartyMon1') + i * l.party.size + l.party.Species]);
      for (const start of [l.sram.sPartyMail, l.sram.sPartyMailBackup])
        b.set(payload, start + i * mailSize);
    }
  });
  b[o('wPartySpecies') + m.party.length] = 255;
  m.daycare.forEach((d, i) => {
    if (!d.active || same(d, old.daycare[i])) return;
    if (g.items.find((i) => i.index === d.mon.item)?.mail && old.daycare[i].mon.item !== d.mon.item)
      throw new Error('Daycare Pokémon cannot be assigned new mail.');
    b.set(
      encodeMon(d.mon, g, false, monTable, moveTable, m.rules, old.daycare[i].mon),
      o(d.symbol),
    );
    if (d.nicknameSymbol)
      text(
        d.mon.nickname,
        old.daycare[i].mon.nickname,
        d.nicknameSymbol,
        c.MON_NAME_LENGTH,
        c.MON_NAME_LENGTH - 1,
      );
    if (d.otSymbol)
      text(d.mon.ot, old.daycare[i].mon.ot, d.otSymbol, c.NAME_LENGTH, c.NAME_LENGTH - 1);
  });
  for (const [key, count, sym] of [
    ['items', 'wNumItems', 'wItems'],
    ['balls', 'wNumBalls', 'wBalls'],
    ['key', 'wNumKeyItems', 'wKeyItems'],
    ['pc', 'wNumPCItems', 'wPCItems'],
  ]) {
    if (same(m.bag[key], old.bag[key])) continue;
    const stride = key === 'key' ? 1 : 2;
    b[o(count)] = m.bag[key].length;
    m.bag[key].forEach((s, i) => {
      b[o(sym) + i * stride] = s.item;
      if (stride === 2) b[o(sym) + i * stride + 1] = s.quantity;
    });
    b[o(sym) + m.bag[key].length * stride] = 255;
  }
  if (!same(m.tms, old.tms)) b.set(m.tms, o('wTMsHMs'));
  for (const kind of ['caught', 'seen'] as const)
    m.dex[kind].forEach((v, i) => {
      const p = o(kind === 'caught' ? 'wPokedexCaught' : 'wPokedexSeen') + (i >>> 3),
        mask = 1 << (i & 7);
      b[p] = (b[p] & ~mask) | (v ? mask : 0);
    });
  const occupied = new Set<string>();
  // Reserve both snapshots, including entries no longer in the effective view.
  for (const snapshot of [l.sram.sNewBox1, l.sram.sBackupNewBox1])
    for (let i = 0; i < c.NUM_BOXES; i++)
      for (let j = 0; j < c.MONS_PER_BOX; j++) {
        const p = snapshot + i * l.newbox.size,
          e = b[p + j];
        if (e && e <= c.MONDB_ENTRIES)
          occupied.add(`${1 + ((b[p + l.newbox.Banks + (j >>> 3)] >>> (j & 7)) & 1)}:${e}`);
      }
  const allocate = () => {
    for (const pool of [1, 2])
      for (let entry = 1; entry <= c.MONDB_ENTRIES; entry++)
        if (!occupied.has(`${pool}:${entry}`)) {
          occupied.add(`${pool}:${entry}`);
          return { pool, entry };
        }
    throw new Error('PokeDB is full; save in-game to free orphaned records.');
  };
  m.boxes.forEach((box, i) => {
    const raw = Uint8Array.from(box.raw),
      before = old.boxes[i];
    if (box.name !== before.name)
      raw.set(
        encode(
          box.name,
          l.newbox.Theme - l.newbox.Name,
          l.newbox.Theme - l.newbox.Name - 1,
          g.charmap,
        ),
        l.newbox.Name,
      );
    raw[l.newbox.Theme] = box.theme;
    box.slots.forEach((mon, j) => {
      const bit = 1 << (j & 7),
        byte = l.newbox.Banks + (j >>> 3);
      if (!mon) {
        if (before.slots[j]) raw[j] = 0;
        return;
      }
      const pointer = mon.pointer || allocate(),
        p = recordOffset(l, pointer.pool, pointer.entry);
      // Locate original by physical pointer, so moving a slot does not rewrite it.
      const originalMon =
        old.boxes
          .flatMap((x) => x.slots)
          .find((x) => x?.pointer?.entry === pointer.entry && x?.pointer?.pool === pointer.pool) ||
        undefined;
      if (!same(mon, originalMon))
        b.set(encodeMon(mon, g, true, monTable, moveTable, m.rules, originalMon), p);
      raw[j] = pointer.entry;
      raw[byte] = (raw[byte] & ~bit) | (pointer.pool === 2 ? bit : 0);
    });
    b.set(raw, l.sram.sNewBox1 + i * l.newbox.size);
    b.set(raw, l.sram.sBackupNewBox1 + i * l.newbox.size);
  });
  b.set(monTable, r.monTable);
  b.set(moveTable, r.moveTable);
  const saved = b.slice(r.start, r.end),
    options = b.slice(r.options, r.check1);
  for (const dest of [l.main, l.backup]) {
    b.set(saved, dest.start);
    b.set(options, dest.options);
    b.set(monTable, dest.monTable);
    b.set(moveTable, dest.moveTable);
    b[dest.check1] = c.SAVE_CHECK_VALUE_1;
    b[dest.check2] = c.SAVE_CHECK_VALUE_2;
  }
  b[l.sram.sCrystalData] = m.player.character;
  b[l.sram.sWritingBackup] = 0;
  fixChecksums(b, l);
  const reparsed = parse(b, g),
    failures = reparsed.diagnostics.filter((d) => d.severity === 'ERROR');
  if (failures.length)
    throw new Error(`Output verification failed: ${failures.map((d) => d.message).join('; ')}`);
  return b;
}
