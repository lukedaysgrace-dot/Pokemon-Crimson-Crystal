import { test, expect } from '@playwright/test';
import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { game } from '../fixture';
import { parse } from '../../src/lib/save/parse';
import { write } from '../../src/lib/save/write';
import { wramOffset } from '../../src/lib/save/copies';

const directory = process.env.CRIMSON_FRESH_TEST_DIR;
test('real new game → editor additions → downloadable emulator fixture', async ({ page }) => {
  test.skip(
    !directory || !existsSync(resolve(directory, 'new-game.sav')),
    'Requires the native new-game fixture.',
  );
  test.setTimeout(180000);
  page.setDefaultTimeout(20000);
  const input = resolve(directory!, 'new-game.sav'),
    original = new Uint8Array(readFileSync(input));
  const before = parse(original, game);
  expect(before.copies.source).toBe('main');
  expect(before.party).toHaveLength(1);
  expect(before.party[0].species).toBe(game.species.find((s) => s.const === 'BULBASAUR')!.index);
  expect(before.diagnostics.filter((d) => d.severity === 'ERROR')).toEqual([]);
  expect(Buffer.compare(Buffer.from(write(before)), Buffer.from(original))).toBe(0);
  const crashes: string[] = [];
  page.on('pageerror', (e) => crashes.push(e.message));
  await page.goto('/');
  await expect(page.getByLabel('Open save file')).toBeEnabled();
  await page.getByLabel('Open save file').setInputFiles(input);
  console.log('Uploaded the native new-game save.');
  await page.getByRole('button', { name: 'Player', exact: true }).click();
  await page.getByLabel('Name', { exact: true }).fill('LUCAS');
  await page.getByRole('button', { name: 'Party', exact: true }).click();

  async function editMon(constant: string, nickname: string, level: number) {
    const species = game.species.find((s) => s.const === constant);
    expect(species, `Species ${constant} exists`).toBeTruthy();
    await page.getByLabel('Species', { exact: true }).selectOption(String(species!.index));
    await page.getByLabel('Nickname', { exact: true }).fill(nickname);
    await page.getByLabel('Level', { exact: true }).fill(String(level));
    await page.getByLabel('Level', { exact: true }).blur();
  }
  for (const [constant, nickname, level] of [
    ['MEOWTH_ALOLAN', 'ALOLA', 25],
    ['MEOWTH_GALARIAN', 'GALAR', 30],
    ['CHARMANDER_CLONE', 'CLONE', 40],
    ['GOROCHU', 'CRIMSON', 50],
    ['FRIGIBAX', 'EGG', 1],
  ] as const) {
    console.log(`Adding ${constant} to the party...`);
    await page.getByRole('button', { name: '+ Add Pokémon', exact: true }).click();
    await editMon(constant, nickname, level);
    if (nickname === 'GALAR') await page.getByLabel('Shiny', { exact: true }).check();
    if (nickname === 'EGG') {
      await page.getByLabel('Egg', { exact: true }).check();
      await page.getByLabel('Happiness / hatch cycles').fill('5');
    }
    if (nickname === 'CRIMSON') {
      const moves = [421, 300, 1, 256];
      for (let i = 0; i < moves.length; i++)
        await page.getByLabel(`Move ${i + 1}`, { exact: true }).selectOption(String(moves[i]));
    }
  }
  await expect(page.getByRole('button', { name: '+ Add Pokémon', exact: true })).toBeDisabled();
  await page.screenshot({ path: resolve(directory!, 'editor-six-pokemon.png'), fullPage: true });
  await page.getByRole('button', { name: 'Boxes', exact: true }).click();
  for (const [box, constant, nickname] of [
    [0, 'MESMERIA', 'BOXONE'],
    [12, 'MEOWTH_GALARIAN', 'BOXMID'],
    [24, 'GOROCHU', 'BOXFINAL'],
  ] as const) {
    console.log(`Adding ${constant} to box ${box + 1}...`);
    await page.getByLabel('Box', { exact: true }).selectOption(String(box));
    await page.getByRole('button', { name: 'Add Pokémon', exact: true }).click();
    await editMon(constant, nickname, 35);
    if (box === 24) await page.getByLabel('Shiny', { exact: true }).check();
  }
  // Exercise inventory and player writes on the same game-created save.
  await page.getByRole('button', { name: 'Player', exact: true }).click();
  await page.getByLabel('Money', { exact: true }).fill('20000');
  await page.getByRole('button', { name: 'Party', exact: true }).click();
  const pending = page.waitForEvent('download');
  await page.getByRole('button', { name: 'Download save', exact: true }).click();
  const modal = page.getByRole('dialog');
  if (await modal.isVisible())
    await page.getByRole('button', { name: 'Download verified save', exact: true }).click();
  const download = await pending,
    output = resolve(directory!, 'editor-added-pokemon.sav');
  await download.saveAs(output);
  const bytes = new Uint8Array(readFileSync(output)),
    after = parse(bytes, game);
  expect(after.diagnostics.filter((d) => d.severity === 'ERROR')).toEqual([]);
  expect(after.party).toHaveLength(6);
  expect(after.party.map((m) => m.nickname).slice(1)).toEqual([
    'ALOLA',
    'GALAR',
    'CLONE',
    'CRIMSON',
    'EGG',
  ]);
  expect(after.party[2].shiny).toBe(true);
  expect(after.party[5].egg).toBe(true);
  expect(after.player.money).toBe(20000);
  expect(after.boxes[0].slots[0]?.nickname).toBe('BOXONE');
  expect(after.boxes[12].slots[0]?.nickname).toBe('BOXMID');
  expect(after.boxes[24].slots[0]?.nickname).toBe('BOXFINAL');
  expect(after.boxes[24].slots[0]?.shiny).toBe(true);
  const nameLength = game.layout.constants.MON_NAME_LENGTH;
  writeFileSync(
    resolve(directory!, 'editor-expected.json'),
    JSON.stringify(
      {
        eggMarker: game.layout.tables.mon.reservedMin,
        nameLength,
        party: after.party.map((m, i) => ({
          species: m.species,
          level: m.level,
          moves: m.moves,
          shiny: m.shiny,
          egg: m.egg,
          nicknameBytes: Array.from(
            bytes.slice(
              wramOffset(game.layout, game.layout.main, 'wPartyMonNicknames') + i * nameLength,
              wramOffset(game.layout, game.layout.main, 'wPartyMonNicknames') +
                (i + 1) * nameLength,
            ),
          ),
        })),
        boxes: after.boxes.flatMap((box, i) =>
          box.slots.flatMap((m, j) =>
            m
              ? [
                  {
                    box: i + 1,
                    slot: j + 1,
                    species: m.species,
                    level: m.level,
                    moves: m.moves,
                    shiny: m.shiny,
                    egg: m.egg,
                  },
                ]
              : [],
          ),
        ),
      },
      null,
      2,
    ),
  );
  writeFileSync(
    resolve(directory!, 'editor-validation.json'),
    JSON.stringify(after.diagnostics, null, 2),
  );
  await page.getByLabel('Open save file').setInputFiles(output);
  await expect(page.getByRole('button', { name: 'Download save', exact: true })).toBeEnabled();
  expect(crashes).toEqual([]);
});
