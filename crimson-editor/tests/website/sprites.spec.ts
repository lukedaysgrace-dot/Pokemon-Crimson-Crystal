import { expect, test, type Locator } from '@playwright/test';

async function hasColor(sprite: Locator, color: number[]) {
  return sprite.evaluate((img: HTMLImageElement, [r, g, b]) => {
    if (!img.complete || !img.naturalWidth) return false;
    const canvas = document.createElement('canvas');
    canvas.width = img.naturalWidth;
    canvas.height = img.naturalHeight;
    const ctx = canvas.getContext('2d')!;
    ctx.drawImage(img, 0, 0);
    const { data } = ctx.getImageData(0, 0, canvas.width, canvas.height);
    for (let i = 0; i < data.length; i += 4) {
      if (data[i] === r && data[i + 1] === g && data[i + 2] === b && data[i + 3] === 255) return true;
    }
    return false;
  }, color);
}

test('Butterfree form and shiny controls work together on both sprites', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await page.goto('pokemon/butterfree.html');
  const shiny = page.getByRole('checkbox', { name: 'Shiny' });
  const front = page.getByRole('button', { name: "Play Butterfree's animation and cry" });
  const back = page.getByRole('img', { name: 'Female Butterfree (back)' });

  await page.getByRole('button', { name: 'Female', exact: true }).click();
  await expect(front).toHaveAttribute('src', '../assets/pokemon/butterfree-female.png');
  await expect(back).toHaveAttribute('src', '../assets/pokemon/butterfree-female.back.png');
  await shiny.check();
  await expect.poll(() => hasColor(front, [66, 222, 132])).toBe(true);
  await expect.poll(() => hasColor(back, [66, 222, 132])).toBe(true);
  const shinyStill = (await front.getAttribute('src'))!;
  await front.press('Enter');
  await expect(front).not.toHaveAttribute('src', shinyStill);
  await expect.poll(() => hasColor(front, [66, 222, 132])).toBe(true);

  await page.getByRole('button', { name: 'Male', exact: true }).click();
  await expect.poll(() => hasColor(front, [255, 123, 148])).toBe(true);
  const maleBack = page.getByRole('img', { name: 'Butterfree (back)', exact: true });
  await expect.poll(() => hasColor(maleBack, [255, 123, 148])).toBe(true);
  await shiny.uncheck();
  await expect(front).toHaveAttribute('src', '../assets/pokemon/butterfree.png');
  await page.getByRole('button', { name: 'Female', exact: true }).click();
  await expect(back).toHaveAttribute('src', '../assets/pokemon/butterfree-female.back.png');
});

test('other Pokémon can switch both sprites between normal and shiny', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await page.goto('pokemon/jirachi.html');
  const shiny = page.getByRole('checkbox', { name: 'Shiny' });
  const front = page.getByRole('button', { name: "Play Jirachi's cry" });
  const back = page.getByRole('img', { name: 'Jirachi (back)' });

  await expect(page.getByRole('button', { name: 'Female', exact: true })).toHaveCount(0);
  await shiny.check();
  await expect.poll(() => hasColor(front, [230, 74, 49])).toBe(true);
  await expect.poll(() => hasColor(back, [230, 74, 49])).toBe(true);
  await shiny.uncheck();
  await expect(front).toHaveAttribute('src', '../assets/pokemon/jirachi.png');
  await expect(back).toHaveAttribute('src', '../assets/pokemon/jirachi.back.png');
});
