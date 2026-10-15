import { readFileSync } from 'node:fs';
import type { GameData } from '../src/lib/gamedata/model';
import { fixChecksums, wramOffset } from '../src/lib/save/copies';
import { encode } from '../src/lib/save/text';
import { parse } from '../src/lib/save/parse';
import { template } from '../src/lib/save/mon';
import { write } from '../src/lib/save/write';
const manifest = JSON.parse(
  readFileSync(new URL('../static/gamedata/manifest.json', import.meta.url), 'utf8'),
);
export const game: GameData = JSON.parse(
  readFileSync(new URL(`../static/gamedata/${manifest[0].id}.json`, import.meta.url), 'utf8'),
);
export function emptySave(g = game): Uint8Array {
  const b = new Uint8Array(65584),
    l = g.layout,
    c = l.constants,
    o = (n: string) => wramOffset(l, l.main, n);
  b[l.sram.sSaveVersion] = c.SAVE_FORMAT_VERSION;
  b[l.sram.sCrystalData] = g.characters[0].index;
  b[o('wPartySpecies')] = 255;
  for (const n of ['wItems', 'wKeyItems', 'wBalls', 'wPCItems']) b[o(n)] = 255;
  for (const n of ['wPlayerName', 'wRivalName'])
    b.set(encode(n === 'wPlayerName' ? 'LUCAS' : 'SILVER', c.NAME_LENGTH, 7, g.charmap), o(n));
  for (let i = 0; i < c.NUM_BOXES; i++)
    for (const start of [l.sram.sNewBox1, l.sram.sBackupNewBox1])
      b.set(
        encode(`BOX ${i + 1}`, l.newbox.Theme - l.newbox.Name, 8, g.charmap),
        start + i * l.newbox.size + l.newbox.Name,
      );
  b.set(b.slice(l.main.start, l.main.end), l.backup.start);
  for (const r of [l.main, l.backup]) {
    b[r.check1] = c.SAVE_CHECK_VALUE_1;
    b[r.check2] = c.SAVE_CHECK_VALUE_2;
  }
  // Deliberately non-zero trailer and untouched bank 7 to check preservation.
  for (let i = 65536; i < b.length; i++) b[i] = (i * 37) & 255;
  b[60000] = 0x9a;
  fixChecksums(b, l);
  return b;
}
export function fixture(g = game): Uint8Array {
  const m = parse(emptySave(g), g);
  m.party.push(template(g, m.player, false, m.rules));
  m.boxes[0].slots[0] = template(g, m.player, true, m.rules);
  return write(m);
}
