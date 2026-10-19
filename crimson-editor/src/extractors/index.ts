import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { execFileSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { PNG } from 'pngjs';
import { Constants, evaluate, ExtractError } from './asm/constants';
import { parseSymbols, romOffset, loadIndirectPointer } from './sym';
import { createLayout } from './layout';
import { mergeProfile, type Profile } from './profiles';
import {
  parsePictureTable,
  verifyPictureTable,
  parseFrontpicAssets,
  resolveFrontpic,
} from './sprites';
import type { Entry, GameData, Species } from '../lib/gamedata/model';

const arg = (name: string, fallback: string) =>
  process.argv.includes(name) ? process.argv[process.argv.indexOf(name) + 1] : fallback;
const root = resolve(arg('--crimson', '..')),
  symPath = arg('--sym', resolve(root, 'pokecrystal.sym')),
  romPath = arg('--rom', resolve(root, 'pokecrystal.gbc'));
const out = resolve(arg('--out', 'static/gamedata')),
  validate = process.argv.includes('--validate');
const read = (file: string) => readFileSync(resolve(root, file), 'utf8');
const symbols = parseSymbols(readFileSync(symPath, 'utf8')),
  rom = new Uint8Array(readFileSync(romPath));
const c = new Constants(
  Object.fromEntries(Object.entries(symbols).map(([n, s]) => [n, s.address])),
);
const files = [
  'ability',
  'wram',
  'misc',
  'text',
  'battle',
  'engine_flags',
  'event_flags',
  'item',
  'item_data',
  'landmark',
  'map_data',
  'move',
  'move_effect',
  'pokemon',
  'pokemon_data',
  'pc',
  'type',
  '16_bit_translation',
].map((n) => `constants/${n}${n.endsWith('flags') ? '' : '_constants'}.asm`);
for (const file of files) c.parse(read(file), file);
const value = (s: string) => evaluate(s, c.get);
function rows(file: string, keyword: string): string[][] {
  return read(file)
    .split(/\r?\n/)
    .flatMap((raw, i) => {
      const line = raw.replace(/;.*/, '').trim();
      if (!line.startsWith(keyword + ' ')) return [];
      const args = line
        .slice(keyword.length)
        .trim()
        .split(',')
        .map((s) => s.trim());
      if (args.some((a) => !a)) throw new ExtractError(file, i + 1, raw, `${keyword} arguments`);
      return [args];
    });
}
const names = (file: string) =>
  [
    ...(file === 'data/pokemon/names.asm'
      ? read(file).split('PokemonNames::')[1]
      : read(file)
    ).matchAll(/^\s*db\s+"([^"]*)"/gm),
  ].map((m) => m[1].replace(/@.*$/, '').replaceAll('#', 'POKé').replace(/[¯%]/g, ' '));
const list = (file: string, max: number, strings: string[], min = 0): Entry[] =>
  c.groups[file]
    .filter((n) => c.get(n) >= min && c.get(n) <= max)
    .map((n) => ({
      const: n,
      index: c.get(n),
      name: strings[c.get(n) - min] ?? n.replaceAll('_', ' '),
    }));
const speciesConsts = list(
  'constants/pokemon_constants.asm',
  c.get('NUM_POKEMON'),
  names('data/pokemon/names.asm'),
  1,
).slice(0, c.get('NUM_POKEMON'));
const moveConsts = list(
  'constants/move_constants.asm',
  c.get('NUM_ATTACKS'),
  names('data/moves/names.asm'),
  1,
).slice(0, c.get('NUM_ATTACKS'));
const abilities = list(
  'constants/ability_constants.asm',
  c.get('NUM_ABILITIES') - 1,
  names('data/abilities/names.asm'),
);
const types = list(
  'constants/type_constants.asm',
  c.get('TYPES_END') - 1,
  names('data/types/names.asm'),
);
const themes = list('constants/pc_constants.asm', c.get('NUM_BILLS_PC_THEMES') - 1, []).filter(
  (e) => e.const.startsWith('THEME_'),
);
const at = (name: string) => {
  if (!symbols[name]) throw new Error(`missing ROM symbol ${name}`);
  return romOffset(symbols[name]);
};
const le = (p: number) => rom[p] | (rom[p + 1] << 8);
function oracle(name: string, actual: number[], expected: number[]) {
  if (JSON.stringify(actual) !== JSON.stringify(expected))
    throw new Error(`ROM oracle mismatch ${name}: source=${actual}, ROM=${expected}`);
}
function overrides(label: string, count: number): Map<number, number[]> {
  let p = at(label);
  const result = new Map<number, number[]>();
  while (le(p)) {
    const id = le(p);
    p += 2;
    result.set(id, Array.from(rom.slice(p, p + count)));
    p += count;
    if (p >= rom.length) throw new Error(`unterminated ${label}`);
  }
  return result;
}
const origStats = overrides('OriginalPokemonStats', 6),
  origTypes = overrides('OriginalPokemonTypes', 2),
  revamped = overrides('RevampedPokemonTypes', 2);
// All source rows in sparse rule tables are checked against the compiled bytes.
const originalStatsFile = existsSync(resolve(root, 'data/pokemon/original_stats.asm'))
  ? 'data/pokemon/original_stats.asm'
  : 'engine/pokemon/gameplay_rules.asm';
for (const [label, file, count] of [
  ['OriginalPokemonStats', originalStatsFile, 6],
  ['OriginalPokemonTypes', 'engine/pokemon/gameplay_rules.asm', 2],
  ['RevampedPokemonTypes', 'engine/pokemon/gameplay_rules.asm', 2],
] as const) {
  const body = read(file)
    .split(`${label}:`)[1]
    ?.split(/\n\s*dw 0\b/)[0];
  if (!body) throw new Error(`missing ${label}`);
  const source = [...body.matchAll(/\bdw\s+(\w+)\s*\n\s*db\s+([^;\n]+)/g)].flatMap((m) => {
    const id = c.get(m[1]);
    return [id & 255, id >>> 8, ...m[2].split(',').map(value)];
  });
  const map = overrides(label, count);
  oracle(
    label,
    source,
    Array.from(rom.slice(at(label), at(label) + [...map.values()].length * (count + 2))),
  );
}
const baseFiles = [
  ...read('data/pokemon/base_stats.asm').matchAll(
    /^\s*INCLUDE "(data\/pokemon\/base_stats\/[^\"]+)"/gm,
  ),
].map((m) => m[1]);
if (baseFiles.length !== speciesConsts.length) throw new Error('base stats count mismatch');
const spriteMap = parseFrontpicAssets(read('gfx/pics.asm'));
const pictureRows = parsePictureTable(
  read('data/pokemon/pic_pointers.asm'),
  'PokemonPicPointers',
  (c.get('NUM_POKEMON') + 1) * 2,
  'data/pokemon/pic_pointers.asm',
);
const unownRows = parsePictureTable(
  read('data/pokemon/unown_pic_pointers.asm'),
  'UnownPicPointers',
  c.get('NUM_UNOWN') * 2,
  'data/pokemon/unown_pic_pointers.asm',
);
verifyPictureTable(rom, symbols, 'PokemonPicPointers', pictureRows);
verifyPictureTable(rom, symbols, 'UnownPicPointers', unownRows);
const species: Species[] = speciesConsts.map((e, i) => {
  const file = baseFiles[i],
    text = read(file),
    data = rows(file, 'db');
  const stats = data.find((r) => r.length === 6)?.map(value);
  if (!stats) throw new Error(`missing stats ${file}`);
  const field = (comment: string) => {
    const m = text.match(new RegExp(`^\\s*db\\s+([^;\\n]+); ${comment}`, 'm'));
    if (!m) throw new Error(`missing ${comment} in ${file}`);
    return m[1].split(',').map((s) => value(s.trim()));
  };
  const a = rows(file, 'abilities_for')[0];
  if (!a || a.length !== 4) throw new Error(`missing abilities ${file}`);
  const baseTypes = field('type'),
    gender = field('gender ratio')[0] & 255,
    growth = field('growth rate')[0],
    ability = a.slice(1).map(c.get);
  const p = loadIndirectPointer(rom, at('BaseData'), e.index);
  for (const [n, vals] of [
    ['BASE_STATS', stats],
    ['BASE_TYPES', baseTypes],
    ['BASE_ABILITIES', ability],
    ['BASE_GENDER', [gender]],
    ['BASE_GROWTH_RATE', [growth]],
    ['BASE_CATCH_RATE', field('catch rate')],
  ] as [string, number[]][])
    oracle(
      `${e.const}.${n}`,
      vals,
      Array.from(rom.slice(p + c.get(n), p + c.get(n) + vals.length)),
    );
  const tmhm = rows(file, 'tmhm').flat().map(c.get);
  const ep = loadIndirectPointer(rom, at('EvosAttacksPointers'), e.index);
  const bank = Math.floor(ep / 0x4000);
  let cursor = romOffset({ bank, address: le(ep) });
  const evolutions: Species['evolutions'] = [];
  for (let guard = 0; rom[cursor] && guard < 30; guard++) {
    const method = rom[cursor++];
    const two = [c.get('EVOLVE_STAT'), c.get('EVOLVE_HOLDING')].includes(method);
    const args = Array.from(rom.slice(cursor, cursor + (two ? 2 : 1)));
    cursor += args.length;
    evolutions.push({ method, args, target: le(cursor) });
    cursor += 2;
  }
  cursor++;
  const levelMoves: Species['levelMoves'] = [];
  for (let guard = 0; rom[cursor] && guard < 150; guard++) {
    levelMoves.push({ level: rom[cursor], move: le(cursor + 1) });
    cursor += 3;
  }
  const eggp = loadIndirectPointer(rom, at('EggMovePointers'), e.index);
  cursor = romOffset({ bank: Math.floor(eggp / 0x4000), address: le(eggp) });
  const eggMoves: number[] = [];
  for (let guard = 0; le(cursor) !== 65535 && guard < 150; guard++, cursor += 2)
    eggMoves.push(le(cursor));
  const pic = resolveFrontpic(e.index, pictureRows, {
    speciesIndex: c.get('UNOWN'),
    rows: unownRows,
  });
  const sprite = spriteMap.get(pic);
  if (!sprite) throw new Error(`No front PNG source for ${e.const}: ${pic}`);
  return {
    ...e,
    stats,
    originalStats: origStats.get(e.index) || stats,
    types: revamped.get(e.index) || baseTypes,
    originalTypes: origTypes.get(e.index) || baseTypes,
    gender,
    growth,
    abilities: ability,
    eggCycles: field('step cycles to hatch')[0],
    catchRate: field('catch rate')[0],
    baseExp: field('base exp')[0],
    heldItems: field('items'),
    eggGroups: rows(file, 'dn')[0].map(value),
    tutor: [],
    tmhm,
    levelMoves,
    eggMoves,
    evolutions,
    sprite,
    frontPic: pic,
    spriteSource: `gfx/pokemon/${sprite}/front.png`,
  };
});
if (existsSync(resolve(root, 'data/pokemon/first_stages.asm'))) {
  const roots = rows('data/pokemon/first_stages.asm', 'dw').flat().map(value);
  if (roots.length !== species.length) throw new Error('breeding family count mismatch');
  if (symbols.FirstEvoStages) oracle('FirstEvoStages', roots,
    Array.from({ length: roots.length }, (_, i) => le(at('FirstEvoStages') + i * 2)));
  const eggLists = species.map((s) => [...s.eggMoves]);
  species.forEach((s, i) => {
    if (!eggLists[roots[i] - 1]) throw new Error(`Unknown breeding family for ${s.const}`);
    s.eggMoves = [...eggLists[roots[i] - 1]];
  });
}
const moves = rows('data/moves/moves.asm', 'move').map((r, i) => {
  if (r.length !== 7 || !moveConsts[i]) throw new Error(`bad move row ${i}`);
  const [effect, power, type, category, accuracy, pp, effectChance] = r.map(value);
  oracle(
    moveConsts[i].const,
    [
      effect,
      power,
      type,
      category,
      Math.floor((accuracy * 255) / 100),
      pp,
      Math.floor((effectChance * 255) / 100),
    ],
    Array.from(
      rom.slice(
        loadIndirectPointer(rom, at('Moves'), i + 1),
        loadIndirectPointer(rom, at('Moves'), i + 1) + 7,
      ),
    ),
  );
  const displayNames: Record<string, string> = { DRAGON_HAMMER: 'DRAGON HAMMER', PETAL_BLIZZARD: 'PETAL BLIZZARD' };
  const displayName = displayNames[moveConsts[i].const];
  return { ...moveConsts[i], ...(displayName ? { name: displayName } : {}), effect, power, type, category, accuracy, pp, effectChance };
});
const itemNames = names('data/items/names.asm'),
  attributes = rows('data/items/attributes.asm', 'item_attribute');
const mail = new Set(
  rows('data/items/mail_items.asm', 'db')
    .flat()
    .filter((n) => n !== '-1')
    .map(c.get),
);
const tmMoves = rows('data/moves/tmhm_moves.asm', 'dw').flat().map(value);
const itemConstants = new Map(
  c.groups['constants/item_constants.asm']
    .filter((n) => !n.endsWith('_TMNUM'))
    .map((n) => [c.get(n), n]),
);
const items = attributes.map((r, i) => {
  if (r.length !== 7) throw new Error(`bad item attribute ${i}`);
  const index = (i + 1) & 255,
    pocket = value(r[4]),
    price = value(r[0]);
  oracle(`item ${index} pocket`, [pocket], [rom[at('ItemAttributes') + i * 7 + 5]]);
  return {
    const:
      itemConstants.get(index) || (index ? `ITEM_${index.toString(16).toUpperCase()}` : 'NO_ITEM'),
    index,
    name: index ? itemNames[index - 1] : 'None',
    pocket,
    price,
    mail: mail.has(index),
    ...(index >= c.get('TM01') && index < 255 ? { move: tmMoves[index - c.get('TM01')] } : {}),
  };
});
oracle(
  'TMHMMoves',
  tmMoves.flatMap((n) => [n & 255, n >>> 8]),
  Array.from(rom.slice(at('TMHMMoves'), at('TMHMMoves') + tmMoves.length * 2)),
);
const caught = c.groups['constants/pokemon_data_constants.asm'].filter((n) =>
  n.startsWith('CAUGHTBALL_'),
);
const balls = caught.map((n) => {
  const index = c.get(n),
    item = items.find((i) => i.index === rom[at('CaughtBallItems') + index]);
  if (!item) throw new Error(`missing ball ${n}`);
  return { const: n, index, name: item.name };
});
const charmap: Record<string, number> = {};
const used = new Set<number>();
for (const m of read('charmap.asm').matchAll(/^\s*charmap\s+"([^"]+)",\s*\$([\da-f]+)/gim)) {
  const v = parseInt(m[2], 16);
  if (!used.has(v)) {
    charmap[m[1]] = v;
    used.add(v);
  }
}
function romText(offset: number): string {
  const inverse = new Map(Object.entries(charmap).map(([k, v]) => [v, k]));
  let result = '';
  for (let i = 0; i < 512; i++) {
    const byte = rom[offset + i];
    if (byte === charmap['@'] || byte === charmap['<DONE>']) return result.trim();
    if (byte === 0) continue;
    if (
      [
        charmap['<NEXT>'],
        charmap['<LINE>'],
        charmap['<PARA>'],
        charmap['¯'],
        charmap['%'],
      ].includes(byte)
    )
      result += ' ';
    else result += inverse.get(byte)?.replace('#', 'POKé') || `<$${byte.toString(16)}>`;
  }
  throw new Error(`Unterminated ROM string at ${offset.toString(16)}`);
}
function tableText(label: string, index: number, stride = 2, field = 0): string {
  const p = at(label) + index * stride;
  return romText(romOffset({ bank: Math.floor(p / 0x4000), address: le(p + field) }));
}
for (const type of types) type.name = tableText('TypeNames', type.index);
for (const theme of themes) theme.name = tableText('BillsPC_ThemeNames', theme.index);
for (const item of items)
  if (item.index)
    Object.assign(item, { description: tableText('ItemDescriptions', item.index - 1) });
for (const ability of abilities)
  ability.description = tableText('AbilityDescriptions', ability.index);
for (const move of moves) {
  const p = loadIndirectPointer(rom, at('MoveDescriptions'), move.index);
  Object.assign(move, {
    description: romText(romOffset({ bank: Math.floor(p / 0x4000), address: le(p) })),
  });
}
if (existsSync(resolve(root, 'data/pokemon/utility_tutor.asm'))) {
  const compatibility = rows('data/pokemon/utility_tutor.asm', 'db').flat().map(value);
  const tutorMoves = rows('engine/events/utility_tutor.asm', 'dw')
    .flat()
    .filter((n) => n !== '0' && c.groups['constants/move_constants.asm'].includes(n))
    .map(c.get);
  if (compatibility.length !== species.length) throw new Error('utility tutor count mismatch');
  oracle(
    'UtilityTutorCompatibility',
    compatibility,
    Array.from(
      rom.slice(
        at('UtilityTutorCompatibility'),
        at('UtilityTutorCompatibility') + compatibility.length,
      ),
    ),
  );
  species.forEach(
    (s, i) => (s.tutor = tutorMoves.filter((_, bit) => compatibility[i] & (1 << bit))),
  );
}
if (symbols.TechnicalTutorPointers && existsSync(resolve(root, 'data/pokemon/technical_tutor.asm'))) {
  const source = read('data/pokemon/technical_tutor.asm');
  const pointers = rows('data/pokemon/technical_tutor.asm', 'dba').flat();
  if (pointers.length !== species.length) throw new Error('Blackthorn tutor count mismatch');
  const lists = new Map([...source.matchAll(/^(TechnicalTutor_\w+)::?\r?\n(.*?)^\s*dw\s+0\s*$/gms)]
    .map((match) => [match[1], [...match[2].matchAll(/^\s*dw\s+(\w+)\s*$/gm)].map((row) => c.get(row[1]))]));
  species.forEach((s, i) => {
    const label = pointers[i], pointer = symbols[label], moves = lists.get(label);
    if (!pointer || !moves) throw new Error(`Unknown Blackthorn tutor list ${label}`);
    const p = at('TechnicalTutorPointers') + i * 3;
    oracle(`${s.const}.BlackthornPointer`,
      [pointer.bank, pointer.address & 255, pointer.address >>> 8], Array.from(rom.slice(p, p + 3)));
    const data = romOffset(pointer);
    oracle(`${s.const}.BlackthornMoves`, [...moves, 0],
      Array.from({ length: moves.length + 1 }, (_, j) => le(data + j * 2)));
    s.tutor = [...new Set([...s.tutor, ...moves])];
  });
}
const keyboardBody = read('data/text/name_input_chars.asm');
const keyboard = (labels: string[]) =>
  [
    ...new Set(
      labels.flatMap((label) => {
        const body = keyboardBody.split(label + ':')[1]?.split(/\n\w/)[0];
        if (!body) throw new Error(`missing keyboard ${label}`);
        return [...body.matchAll(/db "([^"]*)"/g)]
          .slice(0, -1)
          .flatMap((m) => m[1].trim().split(/ +/));
      }),
    ),
  ].concat(' ');
const growth = rows('data/growth_rates.asm', 'growth_rate').map((r) => {
  const [a, b, cc, d, e] = r.map(value);
  return { a, b, c: cc, d, e };
});
const flags: GameData['flags'] = c.groups['constants/event_flags.asm'].map((n) => ({
  const: n,
  symbol: 'wEventFlags',
  offset: Math.floor(c.get(n) / 8),
  mask: 1 << (c.get(n) % 8),
  kind: 'event',
}));
const engineNames = c.groups['constants/engine_flags.asm'];
rows('data/engine_flags.asm', 'engine_flag').forEach((r, i) => {
  if (r.length !== 2 || !engineNames[i]) throw new Error(`engine flag ${i}`);
  const bit = value(r[1]);
  const address = symbols[r[0]]?.address;
  if (address < symbols.wPlayerData.address || address >= symbols.wPokemonDataEnd.address) {
    console.log(`Volatile flag excluded from save editing: ${engineNames[i]} (${r[0]})`);
    return;
  }
  flags.push({
    const: engineNames[i],
    symbol: r[0],
    offset: Math.floor(bit / 8),
    mask: 1 << (bit % 8),
    kind: 'engine',
  });
});
const capsBody =
  read('engine/pokemon/experience.asm').split('HardModeLevelCaps:')[1]?.split(/\n\w/)[0] || '';
const caps = [...capsBody.matchAll(/\bdb\s+([^;\n]+)/g)].flatMap((m) => m[1].split(',').map(value));
const landmarkConstants = c.groups['constants/landmark_constants.asm'].slice(
  0,
  c.groups['constants/landmark_constants.asm'].indexOf('JOHTO_REGION'),
);
const landmarks = landmarkConstants.map((n) => ({
  const: n,
  index: c.get(n),
  name: tableText('Landmarks', c.get(n), 4, 2),
}));
let build = arg('--build', ''),
  date = '';
if (!build) {
  build = execFileSync(process.env.GIT || 'git', ['rev-parse', 'HEAD'], {
    cwd: root,
    encoding: 'utf8',
  }).trim();
}
try {
  date = execFileSync(process.env.GIT || 'git', ['show', '-s', '--format=%cI', build], {
    cwd: root,
    encoding: 'utf8',
  }).trim();
} catch {
  date = 'unknown';
}
const layout = createLayout(symbols, c, build, date, createHash('sha1').update(rom).digest('hex'));
const charBody =
  read('engine/menus/init_gender.asm')
    .split('CharSelectOrder:')[1]
    ?.trim()
    .split(/\n\s*\n/)[0] || '';
let characters = [...charBody.matchAll(/^\s*db\s+([^;\n]+);\s*(\w+)/gm)].map((m) => ({
  const: m[2].toUpperCase(),
  index: value(m[1]),
  name: m[2],
}));
if (!characters.length) {
  // Older builds used a vertical menu. Interpret its tiny index conversion routine.
  const file = read('engine/menus/init_gender.asm'),
    menu = file.split('.MenuData:')[1]?.split('TextJump_')[0] || '';
  const labels = [...menu.matchAll(/db "([^@]+)@"/g)].map((m) => m[1]);
  const code =
    file
      .split('ld a, [wMenuCursorY]')[1]
      ?.split('ld [wPlayerGender], a')[0]
      .split(/\r?\n/)
      .map((s) => s.replace(/;.*/, '').trim())
      .filter(Boolean) || [];
  characters = labels.map((name, i) => {
    let a = i + 1,
      z = false,
      pc = 0,
      steps = 0;
    for (; pc < code.length && steps++ < 100; pc++) {
      const line = code[pc];
      let match: RegExpMatchArray | null;
      if (line.startsWith('.')) continue;
      if (line === 'dec a') {
        a--;
        z = a === 0;
      } else if ((match = line.match(/^cp (.+)$/))) z = a === value(match[1]);
      else if ((match = line.match(/^ld a, (.+)$/))) a = value(match[1]);
      else if ((match = line.match(/^jr (?:(z|nz), )?(\.\w+)$/))) {
        if (!match[1] || (match[1] === 'z' ? z : !z)) {
          const next = code.indexOf(match[2]);
          if (next < 0) throw new Error(`unknown character branch ${line}`);
          pc = next;
        }
      } else throw new Error(`unknown character selection instruction: ${line}`);
    }
    if (steps >= 100) throw new Error('character selection loop');
    return { const: name.toUpperCase(), index: a, name };
  });
}
if (!characters.length) throw new Error('No player characters extracted');
const bundle: GameData = {
  layout,
  species,
  moves,
  items,
  abilities,
  types,
  themes,
  balls,
  landmarks,
  characters,
  charmap,
  keyboard: keyboard(['NameInputUpper', 'NameInputLower']),
  boxKeyboard: keyboard(['BoxNameInputUpper', 'BoxNameInputLower']),
  growth,
  flags,
  caps,
};
if (moves.length !== c.get('NUM_ATTACKS') || items.length !== 256)
  throw new Error('roster counts mismatch');
for (const s of species)
  for (const m of [...s.tmhm, ...s.tutor, ...s.eggMoves, ...s.levelMoves.map((x) => x.move)])
    if (!moves.some((x) => x.index === m)) throw new Error(`unknown move ${m} in ${s.const}`);
if (!validate) {
  mkdirSync(out, { recursive: true });
  const manifestPath = resolve(out, 'manifest.json');
  const old: Profile[] = existsSync(
    manifestPath,
  )
    ? JSON.parse(readFileSync(manifestPath, 'utf8'))
    : [];
  const { id, manifest } = mergeProfile(old,
    { build, date, layoutHash: layout.layoutHash }, c.get('SAVE_FORMAT_VERSION'));
  writeFileSync(manifestPath, JSON.stringify(manifest, null, 2) + '\n');
  writeFileSync(resolve(out, `${id}.provenance.json`), JSON.stringify(c.provenance, null, 2));
  for (const s of species) {
    const source = PNG.sync.read(readFileSync(resolve(root, `gfx/pokemon/${s.sprite}/front.png`)));
    const frame = new PNG({ width: source.width, height: source.width });
    PNG.bitblt(source, frame, 0, 0, source.width, source.width, 0, 0);
    const palette = (shiny: boolean) =>
      [0, 1].map((i) => {
        const color = le(at('PokemonPalettes') + s.index * 8 + (shiny ? 4 : 0) + i * 2);
        return [color & 31, (color >>> 5) & 31, (color >>> 10) & 31].map((v) =>
          Math.round((v * 255) / 31),
        );
      });
    const unique = new Map<string, number>();
    for (let p = 0; p < frame.data.length; p += 4) {
      const rgb = [...frame.data.slice(p, p + 3)];
      unique.set(
        rgb.join(','),
        rgb.reduce((a, b) => a + b, 0),
      );
    }
    const ordered = [...unique].sort((a, b) => b[1] - a[1]).map(([key]) => key);
    const indices = Array.from({ length: frame.width * frame.height }, (_, i) =>
      ordered.indexOf([...frame.data.slice(i * 4, i * 4 + 3)].join(',')),
    );
    const grayscale = ordered.every((key) => {
      const rgb = key.split(',');
      return rgb[0] === rgb[1] && rgb[1] === rgb[2];
    });
    if (grayscale) {
      const colors = palette(false);
      indices.forEach((n, i) => {
        if (n === 1 || n === 2) frame.data.set(colors[n - 1], i * 4);
      });
    }
    const normal = PNG.sync.write(frame),
      colors = palette(true);
    indices.forEach((n, i) => {
      if (n === 1 || n === 2) frame.data.set(colors[n - 1], i * 4);
    });
    const shiny = PNG.sync.write(frame),
      hash = createHash('sha256').update(normal).update(shiny).digest('hex').slice(0, 16);
    s.sprite = `${s.const}/${hash}`;
    const dir = resolve(out, '../sprites', s.sprite);
    mkdirSync(dir, { recursive: true });
    writeFileSync(resolve(dir, 'normal.png'), normal);
    writeFileSync(resolve(dir, 'shiny.png'), shiny);
  }
  writeFileSync(resolve(out, `${id}.json`), JSON.stringify(bundle));
}
console.log(
  `Verified ${species.length} species, ${moves.length} moves, ${abilities.length} abilities, ${items.length} item rows; layout ${layout.layoutHash.slice(0, 12)} (${build.slice(0, 8)}).`,
);
