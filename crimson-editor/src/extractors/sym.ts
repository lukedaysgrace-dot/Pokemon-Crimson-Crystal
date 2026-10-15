export interface SymbolAddress {
  bank: number;
  address: number;
}
export function parseSymbols(text: string): Record<string, SymbolAddress> {
  const result: Record<string, SymbolAddress> = {};
  for (const raw of text.split(/\r?\n/)) {
    const line = raw.trim();
    if (!line || line.startsWith(';')) continue;
    const m = line.match(/^([\da-f]{2,3}):([\da-f]{4})\s+(\S+)$/i);
    if (!m) throw new Error(`unknown symbol line: ${line}`);
    result[m[3]] = { bank: parseInt(m[1], 16), address: parseInt(m[2], 16) };
  }
  return result;
}
export function fileOffset(s: SymbolAddress): number {
  if (s.bank > 7 || s.address < 0xa000 || s.address >= 0xc000)
    throw new Error('symbol outside SRAM');
  return s.bank * 0x2000 + s.address - 0xa000;
}
export function romOffset(s: SymbolAddress): number {
  return s.bank ? s.bank * 0x4000 + s.address - 0x4000 : s.address;
}
export function loadIndirectPointer(rom: Uint8Array, offset: number, index: number): number {
  const header = rom[offset] | (rom[offset + 1] << 8);
  const size = header & 0x7fff;
  let i = index - (header >>> 15);
  if (i < 0 || !size) throw new Error('invalid indirect index/header');
  for (let p = offset + 2; p + 3 < rom.length; p += 4) {
    const count = rom[p];
    if (!count) break;
    if (i < count)
      return romOffset({ bank: rom[p + 1], address: rom[p + 2] | (rom[p + 3] << 8) }) + i * size;
    i -= count;
  }
  throw new Error(`indirect index ${index} out of range`);
}
