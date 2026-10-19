import { test, expect } from '@playwright/test';
import { readFileSync } from 'node:fs';
import { fixture, game } from '../fixture';
import { parse } from '../../src/lib/save/parse';
test('loads the correct normal and shiny pictures across the Unown gap', async ({
  page,
}, testInfo) => {
  await page.goto('/');
  await expect(page.getByLabel('Open save file')).toBeEnabled();
  await page.getByLabel('Open save file').setInputFiles({
    name: 'sprites.sav',
    mimeType: 'application/octet-stream',
    buffer: Buffer.from(fixture()),
  });
  for (const name of ['UNOWN', 'WOBBUFFET', 'CETODDLE', 'CETITAN', 'FEEBAS', 'MEOWTH_GALARIAN', 'JIRACHI']) {
    const species = game.species.find((s) => s.const === name)!;
    await page.getByLabel('Species', { exact: true }).selectOption(String(species.index));
    const image = page.getByRole('img', { name: species.name, exact: true });
    for (const shiny of [false, true]) {
      await page.getByLabel('Shiny', { exact: true }).setChecked(shiny);
      await expect(image).toHaveAttribute(
        'src',
        `/sprites/${species.sprite}/${shiny ? 'shiny' : 'normal'}.png`,
      );
      await expect
        .poll(() => image.evaluate((img: HTMLImageElement) => img.complete && img.naturalWidth > 0))
        .toBe(true);
    }
    if (name === 'CETITAN')
      await page.screenshot({ path: testInfo.outputPath('corrected-cetitan.png'), fullPage: true });
  }
});
test('upload, edit party and box, download and re-upload', async ({ page }, testInfo) => {
  const crashes: string[] = [];
  page.on('pageerror', (e) => crashes.push(e.message));
  await page.goto('/');
  await expect(page.getByLabel('Open save file')).toBeEnabled();
  await page.screenshot({ path: testInfo.outputPath('landing.png'), fullPage: true });
  await page.getByLabel('Open save file').setInputFiles({
    name: 'test.sav',
    mimeType: 'application/octet-stream',
    buffer: Buffer.from(fixture()),
  });
  await expect(page.getByLabel('Nickname', { exact: true })).toHaveValue('BULBASAUR');
  await page.getByLabel('Nickname', { exact: true }).fill('CRIMSON');
  await page.getByLabel('Level', { exact: true }).fill('42');
  await page.getByLabel('Level', { exact: true }).blur();
  await expect(page.getByLabel('Current HP', { exact: true })).toHaveValue('102');
  await page.getByRole('button', { name: 'Boxes', exact: true }).click();
  await page.getByLabel('Nickname', { exact: true }).fill('BOXMON');
  await page.getByRole('button', { name: 'Party', exact: true }).click();
  await expect(page.getByLabel('Nickname', { exact: true })).toHaveValue('CRIMSON');
  await page.screenshot({ path: testInfo.outputPath('editor.png'), fullPage: true });
  const pending = page.waitForEvent('download');
  await page.getByRole('button', { name: 'Download save', exact: true }).click();
  const modal = page.getByRole('dialog');
  if (await modal.isVisible())
    await page.getByRole('button', { name: 'Download verified save', exact: true }).click();
  const download = await pending,
    bytes = new Uint8Array(readFileSync((await download.path())!));
  const m = parse(bytes, game);
  expect(m.party[0].nickname).toBe('CRIMSON');
  expect(m.party[0].level).toBe(42);
  expect(m.boxes[0].slots[0]?.nickname).toBe('BOXMON');
  expect(m.diagnostics.filter((d) => d.severity === 'ERROR')).toEqual([]);
  await page.getByLabel('Open save file').setInputFiles({
    name: 'edited.sav',
    mimeType: 'application/octet-stream',
    buffer: Buffer.from(bytes),
  });
  await expect(page.getByLabel('Nickname', { exact: true })).toHaveValue('CRIMSON');
  expect(crashes).toEqual([]);
});
test('invalid container shows diagnostics without enabling download', async ({ page }) => {
  await page.goto('/');
  await expect(page.getByLabel('Open save file')).toBeEnabled();
  await page.getByLabel('Open save file').setInputFiles({
    name: 'truncated.sav',
    mimeType: 'application/octet-stream',
    buffer: Buffer.alloc(32768),
  });
  await expect(page.getByRole('alert')).toContainText('MBC30');
  await page.getByLabel('Open save file').setInputFiles({
    name: 'zero.sav',
    mimeType: 'application/octet-stream',
    buffer: Buffer.alloc(65536),
  });
  await expect(page.getByRole('button', { name: 'Download save', exact: true })).toBeDisabled();
  await expect(page.getByRole('heading', { name: 'Diagnostics', exact: true })).toBeVisible();
});

test('selects the correct layout when two save profiles share a source commit', async ({ page }) => {
  const old = JSON.parse(readFileSync(new URL('../../static/gamedata/c1a7287b-v2.json', import.meta.url), 'utf8'));
  await page.goto('/');
  await page.getByLabel('Open save file').setInputFiles({
    name: 'previous-jirachi.sav',
    mimeType: 'application/octet-stream',
    buffer: Buffer.from(fixture(old)),
  });
  await expect(page.getByLabel('Build profile')).toHaveValue('c1a7287b-v2');
  await expect(page.getByRole('button', { name: 'Download save', exact: true })).toBeEnabled();
  await page.getByLabel('Build profile').selectOption('c1a7287b');
  await expect(page.getByRole('button', { name: 'Download save', exact: true })).toBeDisabled();
  await page.getByLabel('Build profile').selectOption('c1a7287b-v2');
  await expect(page.getByRole('button', { name: 'Download save', exact: true })).toBeEnabled();
});
