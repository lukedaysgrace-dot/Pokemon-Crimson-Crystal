import { createHash } from 'node:crypto';
import { fileOffset, type SymbolAddress } from './sym';
import type { Constants } from './asm/constants';
import type { Layout, Region } from '../lib/gamedata/model';
export function createLayout(
  symbols: Record<string, SymbolAddress>,
  c: Constants,
  build: string,
  date: string,
  romHash: string,
): Layout {
  const sram: Record<string, number> = {},
    wram: Record<string, number> = {};
  for (const [name, value] of Object.entries(symbols)) {
    if (name.startsWith('s') && value.bank < 8 && value.address >= 0xa000 && value.address < 0xc000)
      sram[name] = fileOffset(value);
    if (name.startsWith('w')) wram[name] = value.address;
  }
  const s = (n: string) => {
    if (!(n in sram)) throw new Error(`missing SRAM symbol ${n}`);
    return sram[n];
  };
  const w = (n: string) => {
    if (!(n in wram)) throw new Error(`missing WRAM symbol ${n}`);
    return wram[n];
  };
  const assert = (ok: boolean, msg: string) => {
    if (!ok) throw new Error(`layout: ${msg}`);
  };
  const region = (p: string): Region => ({
    options: s(`${p}Options`),
    check1: s(`${p}CheckValue1`),
    start: s(`${p}SaveData`),
    end: s(`${p}SaveDataEnd`),
    gameEnd: s(`${p}GameDataEnd`),
    monTable: s(`${p}PokemonIndexTable`),
    moveTable: s(`${p}MoveIndexTable`),
    convChecksum: s(`${p}ConversionTableChecksum`),
    checksum: s(`${p}Checksum`),
    check2: s(`${p}CheckValue2`),
  });
  const main = region('s'),
    backup = region('sBackup');
  for (const [a, b] of [
    ['options', 'check1'],
    ['start', 'end'],
    ['start', 'gameEnd'],
    ['monTable', 'convChecksum'],
    ['end', 'checksum'],
  ] as const)
    assert(
      main[b] - main[a] === backup[b] - backup[a] && main[b] > main[a],
      `mirrored ${a}/${b} spans`,
    );
  for (const r of [main, backup])
    assert(r.check2 === r.checksum + 2, 'check value 2 must follow checksum');
  assert(
    w('wPlayerDataEnd') === w('wCurMapData') && w('wCurMapDataEnd') === w('wPokemonData'),
    'WRAM blocks not contiguous',
  );
  assert(
    main.gameEnd - main.start === w('wPokemonDataEnd') - w('wPlayerData'),
    'WRAM/SRAM spans differ',
  );
  assert(s('sNewBoxEnd') === s('sBackupNewBox1'), 'snapshots not contiguous');
  const nb = s('sNewBox2') - s('sNewBox1');
  assert(s('sNewBoxEnd') - s('sNewBox1') === nb * c.get('NUM_BOXES'), 'active box size');
  assert(
    s('sBackupNewBoxEnd') - s('sBackupNewBox1') === nb * c.get('NUM_BOXES'),
    'backup box size',
  );
  for (const pool of [1, 2])
    for (const section of ['A', 'B', 'C']) {
      const count = c.get(`MONDB_ENTRIES_${section}`);
      if (!count) continue;
      const a = s(`sBoxMons${pool}${section}`),
        b = s(`sBoxMons${pool}${section}End`);
      assert(
        b - a === count * c.get('SAVEMON_STRUCT_LENGTH') &&
          Math.floor(a / 8192) === Math.floor((b - 1) / 8192),
        `PokeDB ${pool}${section} span`,
      );
    }
  const party: Record<string, number> = {},
    boxed: Record<string, number> = {},
    newbox: Record<string, number> = {};
  for (const [name, addr] of Object.entries(wram))
    if (name.startsWith('wPartyMon1')) party[name.slice(10)] = addr - w('wPartyMon1');
  party.size = w('wPartyMon2') - w('wPartyMon1');
  for (const name of new Set([...Object.keys(c.values), ...c.expressions.keys()]))
    if (name.startsWith('SAVEMON_')) boxed[name.slice(8)] = c.get(name);
  for (const suffix of ['Entries', 'Banks', 'Name', 'Theme', 'End'])
    newbox[suffix] = s(`sNewBox1${suffix}`) - s('sNewBox1');
  newbox.size = nb;
  const table = (kind: string, start: string) => ({
    entries: c.get(`${kind}_TABLE_ENTRIES`),
    reservedMin: c.get(`${kind}_TABLE_MINIMUM_RESERVED_INDEX`),
    size: w(`${start}End`) - w(start),
  });
  const tables = {
    mon: table('MON', 'wPokemonIndexTable'),
    move: table('MOVE', 'wMoveIndexTable'),
  };
  assert(tables.mon.size === 256 && tables.move.size === 512, 'unexpected conversion table sizes');
  const wanted = [
    'SAVE_FORMAT_VERSION',
    'SAVE_CHECK_VALUE_1',
    'SAVE_CHECK_VALUE_2',
    'NUM_POKEMON',
    'NUM_ATTACKS',
    'NUM_BOXES',
    'MONS_PER_BOX',
    'MONDB_ENTRIES',
    'MONDB_ENTRIES_A',
    'MONDB_ENTRIES_B',
    'MONDB_ENTRIES_C',
    'PARTY_LENGTH',
    'PLAYER_NAME_LENGTH',
    'MON_NAME_LENGTH',
    'NAME_LENGTH',
    'MAX_ITEMS',
    'MAX_KEY_ITEMS',
    'MAX_BALLS',
    'MAX_PC_ITEMS',
    'NUM_TMS',
    'NUM_HMS',
    'TM01',
    'HM01',
    'NUM_EVENTS',
    'MAX_MONEY',
    'MAX_COINS',
    'ITEM',
    'KEY_ITEM',
    'BALL',
    'TM_HM',
    'HIDDEN_POWER_DEFAULT_TYPE',
    'GIFT_LOCATION',
    'EVENT_LOCATION',
  ];
  const constants = Object.fromEntries(wanted.map((n) => [n, c.get(n)]));
  const canonical = { sram, wram, constants, main, backup, party, boxed, newbox, tables };
  // Hash only saved symbols, not unrelated WRAM/ROM linker movement.
  const saved = Object.fromEntries(
    Object.entries(wram).filter(
      ([, a]) =>
        (a >= w('wPlayerData') && a <= w('wPokemonDataEnd')) ||
        (a >= w('wPokemonIndexTable') && a <= w('wPokemonIndexTableEnd')) ||
        (a >= w('wMoveIndexTable') && a <= w('wMoveIndexTableEnd')),
    ),
  );
  const ordered = (o: Record<string, unknown>) =>
    Object.fromEntries(Object.entries(o).sort(([a], [b]) => a.localeCompare(b)));
  const layoutHash = createHash('sha256')
    .update(JSON.stringify({ ...canonical, sram: ordered(sram), wram: ordered(saved) }))
    .digest('hex');
  return { ...canonical, layoutHash, build, date, romHash };
}
