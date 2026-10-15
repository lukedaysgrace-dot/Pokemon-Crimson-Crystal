import { readFileSync, readdirSync, unlinkSync, rmdirSync, realpathSync } from 'node:fs';
import { resolve, relative, isAbsolute, dirname } from 'node:path';
import type { GameData } from '../src/lib/gamedata/model';

const root = realpathSync('static/sprites');
const referenced = new Set<string>();
const manifest: { id: string }[] = JSON.parse(
  readFileSync('static/gamedata/manifest.json', 'utf8'),
);
for (const { id } of manifest) {
  const game: GameData = JSON.parse(readFileSync(`static/gamedata/${id}.json`, 'utf8'));
  for (const species of game.species)
    for (const kind of ['normal', 'shiny']) referenced.add(`${species.sprite}/${kind}.png`);
}
const obsolete: string[] = [];
for (const entry of readdirSync(root, { recursive: true, withFileTypes: true })) {
  if (entry.isDirectory()) continue;
  const path = resolve(entry.parentPath, entry.name);
  const local = relative(root, realpathSync(path));
  if (
    isAbsolute(local) ||
    local.startsWith('..') ||
    !/^[A-Z0-9_]+\/[a-f0-9]{16}\/(normal|shiny)\.png$/.test(local.replaceAll('\\', '/')) ||
    !entry.isFile()
  )
    throw new Error(`Unexpected sprite path: ${path}`);
  if (!referenced.has(local.replaceAll('\\', '/'))) obsolete.push(path);
}
if (process.argv.includes('--write')) {
  // Delete only inventoried generated PNGs; remove directories only when empty.
  for (const path of obsolete) unlinkSync(path);
  const dirs = [
    ...new Set(obsolete.flatMap((path) => [dirname(path), dirname(dirname(path))])),
  ].sort((a, b) => b.length - a.length);
  for (const dir of dirs) if (readdirSync(dir).length === 0) rmdirSync(dir);
  console.log(
    `Removed ${obsolete.length} obsolete generated PNGs; retained ${referenced.size} referenced PNGs.`,
  );
} else if (obsolete.length)
  throw new Error(
    `${obsolete.length} obsolete PNGs; run tools/prune-sprites.ts --write after regenerating all profiles.`,
  );
else console.log(`All ${referenced.size} generated PNGs are referenced.`);
