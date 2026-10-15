export function tokens(s: string, map: Record<string, number>): string[] {
  const keys = Object.keys(map).sort((a, b) => b.length - a.length),
    result: string[] = [];
  while (s) {
    const key = keys.find((k) => s.startsWith(k));
    if (!key) throw new Error(`Unsupported name character: ${s[0]}`);
    result.push(key);
    s = s.slice(key.length);
  }
  return result;
}
export function decode(b: Uint8Array, map: Record<string, number>): string {
  const inverse = new Map(Object.entries(map).map(([k, v]) => [v, k]));
  let out = '';
  for (const v of b) {
    if (v === map['@']) break;
    out += inverse.get(v) || `<$${v.toString(16).padStart(2, '0')}>`;
  }
  return out;
}
export function encode(
  s: string,
  size: number,
  max: number,
  map: Record<string, number>,
  keyboard?: string[],
): Uint8Array {
  const parts = tokens(s, map);
  if (parts.length > max) throw new Error(`Name exceeds ${max} characters`);
  if (parts.some((t) => t === '@' || (keyboard && !keyboard.includes(t))))
    throw new Error(
      'Name contains a character outside the naming keyboard; enable debug characters to use printable charmap tokens.',
    );
  if (parts.some((t) => map[t] < 0x60 && !['#'].includes(t)))
    throw new Error('Text control codes cannot be used in names');
  const out = new Uint8Array(size).fill(map['@']);
  parts.forEach((t, i) => (out[i] = map[t]));
  return out;
}
