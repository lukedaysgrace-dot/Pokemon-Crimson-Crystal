import type { Layout } from '../gamedata/model';
export function recordOffset(l: Layout, pool: number, entry: number): number {
  if (
    ![1, 2].includes(pool) ||
    !Number.isInteger(entry) ||
    entry < 1 ||
    entry > l.constants.MONDB_ENTRIES
  )
    throw new Error(`Invalid PokeDB pointer ${pool}:${entry}`);
  let k = entry - 1;
  for (const section of ['A', 'B', 'C']) {
    const count = l.constants[`MONDB_ENTRIES_${section}`];
    if (k < count) return l.sram[`sBoxMons${pool}${section}`] + k * l.boxed.STRUCT_LENGTH;
    k -= count;
  }
  throw new Error('PokeDB entry outside sections');
}
