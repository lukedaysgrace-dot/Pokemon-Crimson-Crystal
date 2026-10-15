// Independent full-roster audit: compiled picture pointer -> source PNG -> emitted pixels.
import { readFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { resolve } from 'node:path';
import { PNG } from 'pngjs';
import { parseSymbols, romOffset } from '../src/extractors/sym';
import type { GameData } from '../src/lib/gamedata/model';

const arg = (name: string, fallback: string) =>
  process.argv.includes(name) ? process.argv[process.argv.indexOf(name) + 1] : fallback;
const root = resolve(arg('--crimson', '..'));
const manifest: { id: string }[] = JSON.parse(
  readFileSync('static/gamedata/manifest.json', 'utf8'),
);
const profile = arg('--profile', `static/gamedata/${manifest[0].id}.json`);
const game: GameData = JSON.parse(readFileSync(profile, 'utf8'));
const symbols = parseSymbols(readFileSync(resolve(root, 'pokecrystal.sym'), 'utf8'));
const rom = readFileSync(resolve(root, 'pokecrystal.gbc'));
if (createHash('sha1').update(rom).digest('hex') !== game.layout.romHash)
  throw new Error('The audit requires the exact compiled ROM used by this profile.');
const assets = new Map(
  [
    ...readFileSync(resolve(root, 'gfx/pics.asm'), 'utf8').matchAll(
      /^(\w+):\s*INCBIN\s+"(gfx\/pokemon\/[^/]+)\/front\.[^"]+"/gm,
    ),
  ].map((match) => [match[1], `${match[2]}/front.png`]),
);
const fail = (message: string): never => {
  throw new Error(message);
};
const u16 = (at: number) => rom.readUInt16LE(at);
let pixels = 0;
for (const species of game.species) {
  let pointer = romOffset(symbols.PokemonPicPointers) + species.index * 6;
  if (rom[pointer] === 255 && u16(pointer + 1) === 65535) {
    if (species.const !== 'UNOWN') fail(`Unsupported alternate picture: ${species.const}`);
    pointer = romOffset(symbols.UnownPicPointers);
  }
  const target = symbols[species.frontPic];
  if (!target || target.bank !== rom[pointer] || target.address !== u16(pointer + 1))
    fail(`Wrong ROM front picture for ${species.const}`);
  if (assets.get(species.frontPic) !== species.spriteSource)
    fail(`Wrong source PNG for ${species.const}`);
  const source = PNG.sync.read(readFileSync(resolve(root, species.spriteSource)));
  const shades = new Map<string, number[]>();
  for (let y = 0; y < source.width; y++)
    for (let x = 0; x < source.width; x++) {
      const p = (y * source.width + x) * 4;
      const rgb = [...source.data.subarray(p, p + 3)];
      shades.set(rgb.join(','), rgb);
    }
  const ordered = [...shades.values()].sort(
    (a, b) => b.reduce((x, y) => x + y) - a.reduce((x, y) => x + y),
  );
  const grayscale = ordered.every(([r, g, b]) => r === g && g === b);
  for (const [variant, offset] of [
    ['normal', 0],
    ['shiny', 4],
  ] as const) {
    const image = PNG.sync.read(readFileSync(`static/sprites/${species.sprite}/${variant}.png`));
    if (image.width !== source.width || image.height !== source.width)
      fail(`Wrong frame size: ${species.const}`);
    const palette = [0, 1].map((i) => {
      const packed = u16(romOffset(symbols.PokemonPalettes) + species.index * 8 + offset + i * 2);
      return [packed & 31, (packed >> 5) & 31, (packed >> 10) & 31].map((value) =>
        Math.round((value * 255) / 31),
      );
    });
    for (let p = 0; p < image.data.length; p += 4) {
      const original = [...source.data.subarray(p, p + 3)];
      const shade = ordered.findIndex((rgb) => rgb.every((v, i) => v === original[i]));
      const expected =
        (variant === 'shiny' || grayscale) && (shade === 1 || shade === 2)
          ? palette[shade - 1]
          : original;
      if (
        expected.some((v, i) => v !== image.data[p + i]) ||
        source.data[p + 3] !== image.data[p + 3]
      )
        fail(`Wrong ${variant} pixel for ${species.const} at ${p / 4}`);
      pixels++;
    }
  }
}
console.log(
  `${game.layout.build.slice(0, 8)}: audited ${game.species.length} species, ${game.species.length * 2} PNGs, ${pixels} pixels against compiled pointers and source art.`,
);
