import { ExtractError } from './asm/constants';
import { romOffset, type SymbolAddress } from './sym';

/** Keep every physical row, including the dummy species and Unown placeholders. */
export function parsePictureTable(
  source: string,
  label: string,
  expectedRows: number,
  file: string,
): (string | null)[] {
  const lines = source.split(/\r?\n/);
  const start = lines.findIndex((line) =>
    line
      .replace(/;.*/, '')
      .trim()
      .match(new RegExp(`^${label}::?$`)),
  );
  if (start < 0) throw new ExtractError(file, 1, label, 'picture table label');
  const result: (string | null)[] = [];
  for (let i = start + 1; i < lines.length; i++) {
    const line = lines[i].replace(/;.*/, '').trim();
    if (!line) continue;
    if (/^\w+::?$/.test(line)) break;
    const pointer = line.match(/^dba\s+(\w+)$/);
    if (pointer) result.push(pointer[1]);
    else if (/^dbw\s+-1\s*,\s*-1$/.test(line)) result.push(null);
    else throw new ExtractError(file, i + 1, lines[i], 'dba LABEL or dbw -1, -1');
  }
  if (result.length !== expectedRows) {
    throw new ExtractError(
      file,
      start + 1,
      `${result.length} picture rows`,
      `${expectedRows} rows including placeholders`,
    );
  }
  return result;
}

/** Verify the source's order against every compiled bank/address triple. */
export function verifyPictureTable(
  rom: Uint8Array,
  symbols: Record<string, SymbolAddress>,
  label: string,
  rows: (string | null)[],
): void {
  const table = symbols[label];
  if (!table) throw new Error(`Missing picture table symbol ${label}`);
  const offset = romOffset(table);
  rows.forEach((name, i) => {
    const target = name ? symbols[name] : null;
    if (name && !target) throw new Error(`Missing picture symbol ${name}`);
    const expected = target
      ? [target.bank, target.address & 255, target.address >>> 8]
      : [255, 255, 255];
    const actual = Array.from(rom.slice(offset + i * 3, offset + (i + 1) * 3));
    if (actual.length !== 3 || actual.some((value, j) => value !== expected[j])) {
      throw new Error(
        `Picture ROM oracle mismatch ${label}[${i}] (${name || 'placeholder'}): source=${expected}, ROM=${actual}`,
      );
    }
  });
}

export function parseFrontpicAssets(source: string): Map<string, string> {
  return new Map(
    [...source.matchAll(/^(\w+):\s*INCBIN\s+"gfx\/pokemon\/([^/]+)\/front\.[^"]+"/gm)].map(
      (match) => [match[1], match[2]],
    ),
  );
}

export function resolveFrontpic(
  speciesIndex: number,
  main: (string | null)[],
  alternate?: { speciesIndex: number; rows: (string | null)[] },
): string {
  const front = main[speciesIndex * 2];
  if (front) return front;
  if (front === null && alternate?.speciesIndex === speciesIndex && alternate.rows[0])
    return alternate.rows[0];
  throw new Error(`No supported front picture for species ${speciesIndex}`);
}
