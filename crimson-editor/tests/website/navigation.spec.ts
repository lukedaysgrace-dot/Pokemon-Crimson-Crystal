import { test, expect } from '@playwright/test';
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { resolve, relative, dirname } from 'node:path';
import { fixture, game } from '../fixture';
import { parse } from '../../src/lib/save/parse';

test('every documentation header links to the built editor', () => {
  expect(existsSync('../docs/.nojekyll')).toBe(true);
  const root = resolve('../docs');
  let checked = 0;
  for (const entry of readdirSync(root, { recursive: true, withFileTypes: true })) {
    const file = resolve(entry.parentPath, entry.name);
    if (!entry.isFile() || !file.endsWith('.html') || relative(root, file).startsWith('editor'))
      continue;
    const source = readFileSync(file, 'utf8');
    const nav = source.match(/<nav aria-label="Main navigation">(.*?)<\/nav>/s)?.[1];
    if (!nav) continue;
    const href = nav.match(/href="([^"]+)">Save Editor<\/a>/)?.[1];
    expect(href, file).toBeTruthy();
    expect(resolve(dirname(file), href!)).toBe(resolve(root, 'editor/index.html'));
    checked++;
  }
  expect(checked).toBeGreaterThan(900);
});

test('website tab opens the production editor, edits a save, and returns to the guides', async ({
  page,
}, testInfo) => {
  const failures: string[] = [];
  page.on('pageerror', (error) => failures.push(error.message));
  page.on('response', (response) => {
    if (response.status() >= 400) failures.push(`${response.status()} ${response.url()}`);
  });
  await page.goto('index.html');
  await page
    .getByRole('navigation', { name: 'Main navigation' })
    .getByRole('link', { name: 'Save Editor', exact: true })
    .click();
  await expect(page).toHaveURL(/\/Pokemon-Crimson-Crystal\/editor\/index\.html$/);
  await expect(page.getByLabel('Open save file')).toBeEnabled();
  await page.getByLabel('Open save file').setInputFiles({
    name: 'website.sav',
    mimeType: 'application/octet-stream',
    buffer: Buffer.from(fixture()),
  });
  const cetitan = game.species.find((s) => s.const === 'CETITAN')!;
  await page.getByLabel('Species', { exact: true }).selectOption(String(cetitan.index));
  await page.getByLabel('Shiny', { exact: true }).check();
  const image = page.getByRole('img', { name: cetitan.name, exact: true });
  await expect(image).toHaveAttribute('src', new RegExp(`/sprites/${cetitan.sprite}/shiny.png$`));
  await expect
    .poll(() => image.evaluate((img: HTMLImageElement) => img.complete && img.naturalWidth > 0))
    .toBe(true);
  await page.getByLabel('Nickname', { exact: true }).fill('WEBSITE');
  await page.screenshot({ path: testInfo.outputPath('website-editor.png'), fullPage: true });
  const pending = page.waitForEvent('download');
  await page.getByRole('button', { name: 'Download save', exact: true }).click();
  if (await page.getByRole('dialog').isVisible())
    await page.getByRole('button', { name: 'Download verified save', exact: true }).click();
  const download = await pending;
  const saved = parse(new Uint8Array(readFileSync((await download.path())!)), game);
  expect(saved.party[0].species).toBe(cetitan.index);
  expect(saved.party[0].nickname).toBe('WEBSITE');
  expect(saved.party[0].shiny).toBe(true);
  expect(saved.diagnostics.filter((d) => d.severity === 'ERROR')).toEqual([]);
  await page
    .getByRole('navigation', { name: 'Main navigation' })
    .getByRole('link', { name: 'Pokédex', exact: true })
    .click();
  await expect(page).toHaveURL(/\/Pokemon-Crimson-Crystal\/pokedex\.html$/);
  expect(failures).toEqual([]);
});

test('the top tab works from nested pages and on a phone', async ({ page }, testInfo) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto('pokemon/chikorita.html');
  const tab = page
    .getByRole('navigation', { name: 'Main navigation' })
    .getByRole('link', { name: 'Save Editor', exact: true });
  await expect(tab).toBeInViewport();
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true);
  await page.screenshot({ path: testInfo.outputPath('website-mobile-navigation.png') });
  await tab.click();
  await expect(page.getByLabel('Open save file')).toBeEnabled();
  await expect(
    page
      .getByRole('navigation', { name: 'Main navigation' })
      .getByRole('link', { name: 'Save Editor', exact: true }),
  ).toHaveAttribute('aria-current', 'page');
  await page.getByRole('link', { name: /CRIMSON EDITOR/ }).click();
  await expect(page).toHaveURL(/\/Pokemon-Crimson-Crystal\/index\.html$/);
  await page.goto('editor/');
  await expect(page.getByLabel('Open save file')).toBeEnabled();
});

test('website editor exports both new species, Horn Leech and Harvest in format 4', async ({ page }) => {
  const failures: string[] = [];
  page.on('pageerror', (error) => failures.push(error.message));
  await page.goto('editor/');
  await page.getByLabel('Open save file').setInputFiles({
    name: 'phantump-trevenant.sav', mimeType: 'application/octet-stream', buffer: Buffer.from(fixture()),
  });
  const horn = game.moves.find((move) => move.const === 'HORN_LEECH')!;
  for (const constant of ['PHANTUMP', 'TREVENANT']) {
    const species = game.species.find((entry) => entry.const === constant)!;
    await page.getByLabel('Species', { exact: true }).selectOption(String(species.index));
    await page.getByLabel('Move 1', { exact: true }).selectOption(String(horn.index));
    await expect(page.getByLabel('Move 1', { exact: true })).toHaveValue(String(horn.index));
    const image = page.getByRole('img', { name: species.name, exact: true });
    for (const shiny of [false, true]) {
      await page.getByLabel('Shiny', { exact: true }).setChecked(shiny);
      await expect(image).toHaveAttribute('src', new RegExp(`/sprites/${species.sprite}/${shiny ? 'shiny' : 'normal'}.png$`));
      await expect.poll(() => image.evaluate((img: HTMLImageElement) => img.complete && img.naturalWidth > 0)).toBe(true);
    }
  }
  await page.getByRole('combobox', { name: /^Ability slot/ }).selectOption('3');
  const pending = page.waitForEvent('download');
  await page.getByRole('button', { name: 'Download save', exact: true }).click();
  if (await page.getByRole('dialog').isVisible())
    await page.getByRole('button', { name: 'Download verified save', exact: true }).click();
  const download = await pending;
  const bytes = new Uint8Array(readFileSync((await download.path())!));
  const saved = parse(bytes, game);
  expect(saved.party[0].species).toBe(498);
  expect(saved.party[0].moves[0]).toBe(440);
  expect((saved.party[0].personality >>> 5) & 3).toBe(3);
  expect(bytes[game.layout.sram.sSaveVersion]).toBe(4);
  expect(saved.diagnostics.filter((diagnostic) => diagnostic.severity === 'ERROR')).toEqual([]);
  expect(failures).toEqual([]);
});
