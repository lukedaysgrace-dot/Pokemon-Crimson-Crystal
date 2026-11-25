import { expect, test } from '@playwright/test';
import type { Page } from '@playwright/test';

async function trackCries(page: Page) {
  const cries: string[] = [];
  await page.exposeFunction('recordCry', (src: string) => cries.push(new URL(src).pathname));
  await page.addInitScript(() => {
    const play = HTMLMediaElement.prototype.play;
    const { recordCry } = window as typeof window & { recordCry: (src: string) => Promise<number> };
    HTMLMediaElement.prototype.play = async function () {
      await play.call(this);
      await recordCry(this.currentSrc);
    };
  });
  return cries;
}

test('front sprite plays its cry on every activation and restores the still frame', async ({ page }) => {
  const cries = await trackCries(page);
  await page.goto('pokemon/chikorita.html');
  const front = page.getByRole('button', { name: "Play Chikorita's animation and cry" });
  await expect(front).toHaveAttribute('src', /^data:image\/png/);
  await page.getByRole('img', { name: 'Chikorita (back)' }).click();
  expect(cries).toEqual([]);

  const cry = '/Pokemon-Crimson-Crystal/assets/cries/chikorita.wav';
  await front.click();
  await expect.poll(() => cries).toEqual([cry]);
  await front.press('Enter');
  await expect.poll(() => cries).toEqual([cry, cry]);
  await expect(front).toHaveAttribute('src', '../assets/pokemon/chikorita.png');
});

test('clone and static front sprites play their own clips', async ({ page }) => {
  const cries = await trackCries(page);
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await page.goto('pokemon/bulbasaur.html');
  await page.getByRole('button', { name: 'Clone', exact: true }).click();
  await page.getByRole('button', { name: "Play Bulbasaur's animation and cry" }).press('Space');
  await expect.poll(() => cries).toEqual(['/Pokemon-Crimson-Crystal/assets/cries/bulbasaur-clone.wav']);

  await page.goto('pokemon/jirachi.html');
  await page.getByRole('button', { name: "Play Jirachi's cry" }).click();
  await expect.poll(() => cries).toHaveLength(2);
  expect(cries[1]).toBe('/Pokemon-Crimson-Crystal/assets/cries/jirachi.wav');
});
