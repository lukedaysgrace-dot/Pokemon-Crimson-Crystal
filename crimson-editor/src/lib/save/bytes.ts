export const le16 = (b: Uint8Array, o: number) => b[o] | (b[o + 1] << 8);
export const be16 = (b: Uint8Array, o: number) => (b[o] << 8) | b[o + 1];
export const be24 = (b: Uint8Array, o: number) => b[o] * 65536 + be16(b, o + 1);
export const setLE16 = (b: Uint8Array, o: number, n: number) => {
  b[o] = n;
  b[o + 1] = n >>> 8;
};
export const setBE16 = (b: Uint8Array, o: number, n: number) => {
  b[o] = n >>> 8;
  b[o + 1] = n;
};
export const setBE24 = (b: Uint8Array, o: number, n: number) => {
  b[o] = n >>> 16;
  setBE16(b, o + 1, n);
};
export function checksum16(b: Uint8Array, start = 0, end = b.length): number {
  let n = 0;
  for (let i = start; i < end; i++) n += b[i];
  return n & 65535;
}
export function savemonChecksum(b: Uint8Array, end = b.length - 2): number {
  let run = 0,
    acc = 0;
  for (let i = 0; i < end; i++) {
    run = (run + b[i]) & 65535;
    acc = (acc + run) & 65535;
  }
  return (127 + acc) & 65535;
}
export const equal = (a: Uint8Array, b: Uint8Array) =>
  a.length === b.length && a.every((n, i) => n === b[i]);
export function integer(n: number, min: number, max: number, field: string): void {
  if (!Number.isInteger(n) || n < min || n > max)
    throw new Error(`${field}: expected integer ${min}–${max}`);
}
