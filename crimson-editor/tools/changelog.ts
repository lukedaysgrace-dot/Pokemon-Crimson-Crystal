import { readFileSync, writeFileSync } from 'node:fs';
import type { GameData } from '../src/lib/gamedata/model';
const manifest = JSON.parse(readFileSync('static/gamedata/manifest.json', 'utf8'));
if (manifest.length < 2) process.exit(0);
const [newest, previous] = manifest
  .slice(0, 2)
  .map((p: { id: string }): GameData =>
    JSON.parse(readFileSync(`static/gamedata/${p.id}.json`, 'utf8')),
  );
const lines = [
  `# Game data changes`,
  '',
  `${previous.layout.build.slice(0, 8)} → ${newest.layout.build.slice(0, 8)}`,
  '',
  `Save layout: ${previous.layout.layoutHash === newest.layout.layoutHash ? 'unchanged' : 'changed'}.`,
  '',
];
for (const key of ['species', 'moves', 'items', 'abilities'] as const) {
  const before = new Map(previous[key].map((x) => [x.const, JSON.stringify(x)]));
  const additions = newest[key].filter((x) => !before.has(x.const));
  const changed = newest[key].filter(
    (x) => before.has(x.const) && before.get(x.const) !== JSON.stringify(x),
  );
  lines.push(`- ${key}: ${additions.length} added, ${changed.length} changed.`);
  if (additions.length) lines.push(`  Added: ${additions.map((x) => x.const).join(', ')}.`);
}
writeFileSync('CHANGES.md', lines.join('\n') + '\n');
