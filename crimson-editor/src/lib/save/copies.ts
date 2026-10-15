import type { Layout, Region } from '../gamedata/model';
import { checksum16, le16, setLE16 } from './bytes';
export function verify(b: Uint8Array, l: Layout, r: Region) {
  const game = checksum16(b, r.start, r.end),
    move = checksum16(b, r.moveTable, r.moveTable + l.tables.move.size);
  const checks =
    b[r.check1] === l.constants.SAVE_CHECK_VALUE_1 &&
    b[r.check2] === l.constants.SAVE_CHECK_VALUE_2;
  return {
    valid:
      checks &&
      b[l.sram.sSaveVersion] === l.constants.SAVE_FORMAT_VERSION &&
      game === le16(b, r.checksum) &&
      move === le16(b, r.convChecksum),
    checks,
    game,
    move,
    storedGame: le16(b, r.checksum),
    storedMove: le16(b, r.convChecksum),
  };
}
export function selectCopy(b: Uint8Array, l: Layout) {
  const main = verify(b, l, l.main),
    backup = verify(b, l, l.backup);
  const source = main.valid ? 'main' : backup.valid ? 'backup' : null;
  return {
    main,
    backup,
    source,
    snapshot:
      source === 'main' && b[l.sram.sWritingBackup] === 1 ? l.sram.sNewBox1 : l.sram.sBackupNewBox1,
  };
}
export function fixChecksums(b: Uint8Array, l: Layout) {
  for (const r of [l.main, l.backup]) {
    setLE16(b, r.convChecksum, checksum16(b, r.moveTable, r.moveTable + l.tables.move.size));
    setLE16(b, r.checksum, checksum16(b, r.start, r.end));
  }
}
export function wramOffset(l: Layout, r: Region, name: string) {
  const a = l.wram[name];
  if (a === undefined) throw new Error(`Missing symbol ${name}`);
  for (const [w, s] of [
    ['wPlayerData', 'sPlayerData'],
    ['wCurMapData', 'sCurMapData'],
    ['wPokemonData', 'sPokemonData'],
  ])
    if (a >= l.wram[w] && a < l.wram[w + 'End'])
      return (r === l.backup ? l.sram[s.replace('s', 'sBackup')] : l.sram[s]) + a - l.wram[w];
  throw new Error(`${name} is outside saved WRAM`);
}
