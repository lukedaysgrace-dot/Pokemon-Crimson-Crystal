import { le16, setLE16 } from './bytes';
import type { TableParams } from '../gamedata/model';
export function idToIndex(t: Uint8Array, id: number, p: TableParams): number | null {
  if (!id) return 0;
  if (id >= p.reservedMin) return 0xff00 | id;
  if (id > p.entries) return null;
  return le16(t, 2 + 2 * (id - 1)) || null;
}
export function indexToId(t: Uint8Array, index: number, p: TableParams): number {
  if (!index) return 0;
  if ((index & 0xff00) === 0xff00 && (index & 255) >= p.reservedMin) return index & 255;
  for (let k = 0; k < p.entries; k++) if (le16(t, 2 + 2 * k) === index) return k + 1;
  for (let k = 0; k < p.entries; k++)
    if (!le16(t, 2 + 2 * k)) {
      setLE16(t, 2 + 2 * k, index);
      t[0]++;
      return k + 1;
    }
  throw new Error('Conversion table full; save in-game once to let the game garbage-collect.');
}
