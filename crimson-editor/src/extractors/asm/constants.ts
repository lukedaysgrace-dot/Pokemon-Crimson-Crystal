/** A deliberately small RGBDS expression interpreter. No JavaScript eval. */
export class ExtractError extends Error {
  constructor(file: string, line: number, source: string, expected: string) {
    super(`${file}:${line}: ${source} (expected ${expected})`);
  }
}
export function evaluate(source: string, lookup: (name: string) => number): number {
  source = source.replace(/(\d+)\s+percent/g, '($1 * 255 / 100)');
  const tokens = source.match(/\$[\da-f]+|%[01]+|\d+|[A-Za-z_][\w.]*|<<|>>|[()+\-*/&|^%~]/gi) || [];
  if (tokens.join('') !== source.replace(/\s/g, ''))
    throw new Error(`unsupported expression: ${source}`);
  let i = 0;
  const precedence: Record<string, number> = {
    '|': 1,
    '^': 2,
    '&': 3,
    '<<': 4,
    '>>': 4,
    '+': 5,
    '-': 5,
    '*': 6,
    '/': 6,
    '%': 6,
  };
  function atom(): number {
    const t = tokens[i++];
    if (!t) throw new Error(`incomplete expression: ${source}`);
    if (t === '-') return -atom();
    if (t === '+') return atom();
    if (t === '~') return ~atom();
    if (t === '(') {
      const n = expr(0);
      if (tokens[i++] !== ')') throw new Error('missing )');
      return n;
    }
    if (t.startsWith('$')) return parseInt(t.slice(1), 16);
    if (t.startsWith('%')) return parseInt(t.slice(1), 2);
    if (/^\d+$/.test(t)) return Number(t);
    if (!/^[A-Za-z_]/.test(t)) throw new Error(`unexpected ${t}`);
    return lookup(t);
  }
  function expr(min: number): number {
    let n = atom();
    while (i < tokens.length && (precedence[tokens[i]] ?? -1) >= min) {
      const op = tokens[i++],
        r = expr(precedence[op] + 1);
      switch (op) {
        case '+':
          n += r;
          break;
        case '-':
          n -= r;
          break;
        case '*':
          n *= r;
          break;
        case '/':
          if (!r) throw new Error('division by zero');
          n = Math.trunc(n / r);
          break;
        case '%':
          n %= r;
          break;
        case '<<':
          n <<= r;
          break;
        case '>>':
          n >>= r;
          break;
        case '&':
          n &= r;
          break;
        case '|':
          n |= r;
          break;
        case '^':
          n ^= r;
          break;
      }
    }
    return n;
  }
  const n = expr(0);
  if (i !== tokens.length || !Number.isFinite(n)) throw new Error(`invalid expression: ${source}`);
  return n;
}
export class Constants {
  values: Record<string, number> = {};
  expressions = new Map<string, { expr: string; file: string; line: number }>();
  provenance: Record<string, string> = {};
  groups: Record<string, string[]> = {};
  constructor(symbols: Record<string, number> = {}) {
    this.values = { ...symbols };
  }
  get = (name: string): number => {
    if (name in this.values) return this.values[name];
    const e = this.expressions.get(name);
    if (!e) throw new Error(`unknown constant ${name}`);
    this.expressions.delete(name);
    try {
      return (this.values[name] = evaluate(e.expr, this.get));
    } catch (err) {
      throw new ExtractError(e.file, e.line, `${name} = ${e.expr}`, String(err));
    }
  };
  parse(text: string, file: string) {
    let next = 0,
      step = 1,
      enumeration = 0,
      enumStep = 1,
      macro = false;
    this.groups[file] = [];
    const define = (name: string, value: number, line: number) => {
      this.values[name] = value;
      this.groups[file].push(name);
      this.provenance[name] = `${file}:${line}`;
    };
    text.split(/\r?\n/).forEach((raw, at) => {
      const s = raw.replace(/;.*/, '').trim(),
        line = at + 1;
      if (/\bMACRO\b/i.test(s)) {
        macro = true;
        return;
      }
      if (/^ENDM$/i.test(s)) {
        macro = false;
        return;
      }
      if (macro || !s) return;
      let m: RegExpMatchArray | null;
      const val = (e: string) => evaluate(e, this.get);
      if ((m = s.match(/^const_def(?:\s+(.+))?$/))) {
        const parts = m[1]?.split(',');
        next = parts ? val(parts[0]) : 0;
        step = parts?.[1] ? val(parts[1]) : 1;
      } else if ((m = s.match(/^const\s+(\w+)$/))) {
        define(m[1], next, line);
        next += step;
      } else if ((m = s.match(/^const_skip(?:\s+(.+))?$/))) next += step * (m[1] ? val(m[1]) : 1);
      else if ((m = s.match(/^const_next\s+(.+)$/))) {
        const parts = m[1].split(',');
        next = val(parts[0]);
        if (parts[1]) step = val(parts[1]);
      } else if ((m = s.match(/^enum_start(?:\s+(.+))?$/))) {
        const parts = m[1]?.split(',');
        enumeration = parts ? val(parts[0]) : 0;
        enumStep = parts?.[1] ? val(parts[1]) : 1;
      } else if ((m = s.match(/^enum\s+(\w+)$/))) {
        define(m[1], enumeration, line);
        enumeration += enumStep;
      } else if ((m = s.match(/^add_(tm|hm|mt)\s+(\w+)$/))) {
        if (m[1] !== 'mt') {
          const start = m[1] === 'tm' ? 'TM01' : 'HM01';
          if (!(start in this.values)) {
            define(start, next, line);
            if (m[1] === 'tm') enumeration = 1;
          }
          define(`${m[1].toUpperCase()}_${m[2]}`, next++, line);
        }
        define(`${m[2]}_TMNUM`, enumeration++, line);
      } else if ((m = s.match(/^(\w+)\s+(?:EQU|EQUS|=)\s+(.+)$/i))) {
        const e = m[2]
          .replace(/^"|"$/g, '')
          .replace(/\bconst_value\b/g, String(next))
          .replace(/\b__enum__\b/g, String(enumeration));
        this.expressions.set(m[1], { expr: e, file, line });
        this.provenance[m[1]] = `${file}:${line}`;
      } else if (/^(const|enum|add_(tm|hm|mt))\b/.test(s))
        throw new ExtractError(file, line, s, 'known constant declaration');
    });
  }
}
