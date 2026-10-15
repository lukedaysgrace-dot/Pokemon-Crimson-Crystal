import { describe, expect, it } from 'vitest';
import { readFileSync, readdirSync } from 'node:fs';
import { createHash } from 'node:crypto';
import {
  parsePictureTable,
  verifyPictureTable,
  parseFrontpicAssets,
  resolveFrontpic,
} from '../src/extractors/sprites';
import type { GameData } from '../src/lib/gamedata/model';

describe('picture table ordering', () => {
  const source = `Pictures::
    dba DummyFrontpic
    dba DummyBackpic
    dba FirstFrontpic
    dba FirstBackpic
    dbw -1, -1 ; Unown has its own table
    dbw -1, -1
    dba ThirdFrontpic
    dba ThirdBackpic
  NextTable::`;
  it('preserves the dummy and both Unown rows without shifting later species', () => {
    const rows = parsePictureTable(source, 'Pictures', 8, 'pictures.asm');
    expect(resolveFrontpic(1, rows)).toBe('FirstFrontpic');
    expect(
      resolveFrontpic(2, rows, { speciesIndex: 2, rows: ['UnownAFrontpic', 'UnownABackpic'] }),
    ).toBe('UnownAFrontpic');
    expect(resolveFrontpic(3, rows)).toBe('ThirdFrontpic');
    expect(() => resolveFrontpic(2, rows)).toThrow('No supported front picture');
    expect(() => resolveFrontpic(4, rows)).toThrow('No supported front picture');
  });
  it('rejects unknown syntax and omitted pointer rows', () => {
    expect(() =>
      parsePictureTable(source.replace('dbw -1, -1', 'db 0'), 'Pictures', 8, 'pictures.asm'),
    ).toThrow('pictures.asm');
    expect(() => parsePictureTable(source, 'Pictures', 7, 'pictures.asm')).toThrow(
      'including placeholders',
    );
  });
  it('verifies compiled pointers, including placeholders and back pictures', () => {
    const symbols = {
      Pictures: { bank: 0, address: 0 },
      Front: { bank: 2, address: 0x4567 },
      Back: { bank: 3, address: 0x789a },
    };
    const rom = new Uint8Array([2, 0x67, 0x45, 3, 0x9a, 0x78, 255, 255, 255]);
    expect(() =>
      verifyPictureTable(rom, symbols, 'Pictures', ['Front', 'Back', null]),
    ).not.toThrow();
    expect(() => verifyPictureTable(rom, symbols, 'Pictures', ['Back', 'Front', null])).toThrow(
      'oracle mismatch',
    );
    rom[8] = 0;
    expect(() => verifyPictureTable(rom, symbols, 'Pictures', ['Front', 'Back', null])).toThrow(
      'placeholder',
    );
    expect(() => verifyPictureTable(rom, symbols, 'Pictures', ['Missing'])).toThrow(
      'Missing picture symbol',
    );
  });
  it('resolves exact picture labels to source assets', () => {
    expect(
      parseFrontpicAssets(
        'CetitanFrontpic: INCBIN "gfx/pokemon/cetitan/front.animated.2bpp.lz"\nFeebasFrontpic: INCBIN "gfx/pokemon/feebas/front.animated.2bpp.lz"',
      ).get('CetitanFrontpic'),
    ).toBe('cetitan');
  });
});

it('ships only referenced normal/shiny image pairs with correct content hashes in every profile', () => {
  const referenced = new Set<string>();
  const manifest: { id: string }[] = JSON.parse(
    readFileSync('static/gamedata/manifest.json', 'utf8'),
  );
  for (const { id } of manifest) {
    const game: GameData = JSON.parse(readFileSync(`static/gamedata/${id}.json`, 'utf8'));
    for (const species of game.species) {
      expect(species.frontPic, `${id} ${species.const}`).toBeTruthy();
      expect(species.spriteSource).toMatch(/^gfx\/pokemon\/[^/]+\/front\.png$/);
      expect(species.sprite).toMatch(new RegExp(`^${species.const}/[a-f0-9]{16}$`));
      const files = ['normal', 'shiny'].map((kind) => `${species.sprite}/${kind}.png`);
      const buffers = files.map((file) => readFileSync(`static/sprites/${file}`));
      const hash = createHash('sha256')
        .update(buffers[0])
        .update(buffers[1])
        .digest('hex')
        .slice(0, 16);
      expect(species.sprite.split('/')[1]).toBe(hash);
      files.forEach((file) => referenced.add(file));
    }
    for (const [name, source] of [
      ['CETITAN', 'cetitan'],
      ['FEEBAS', 'feebas'],
      ['MEOWTH_GALARIAN', 'meowth_galarian'],
    ]) {
      const species = game.species.find((s) => s.const === name);
      expect(species?.spriteSource, `${id} ${name}`).toBe(`gfx/pokemon/${source}/front.png`);
    }
  }
  const actual = readdirSync('static/sprites', { recursive: true, withFileTypes: true })
    .filter((entry) => entry.isFile())
    .map((entry) =>
      `${entry.parentPath}/${entry.name}`
        .replaceAll('\\', '/')
        .split('/static/sprites/')
        .pop()!
        .replace(/^static\/sprites\//, ''),
    );
  expect(actual.sort()).toEqual([...referenced].sort());
});
