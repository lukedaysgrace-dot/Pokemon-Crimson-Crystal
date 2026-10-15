import { execFileSync } from 'node:child_process';
import { existsSync, realpathSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const editor = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const docs = realpathSync(resolve(editor, '../docs'));
// adapter-static replaces this output folder. Keep it inside this repo's docs.
if (docs !== resolve(editor, '../docs'))
  throw new Error('The website docs folder must not be a symlink.');
const output = resolve(docs, 'editor');
if (existsSync(output) && realpathSync(output) !== output)
  throw new Error('The editor output folder must not be a symlink.');
console.log(`Building the website editor into ${resolve(docs, 'editor')}`);
execFileSync(process.execPath, ['node_modules/vite/bin/vite.js', 'build'], {
  cwd: editor,
  env: { ...process.env, WEBSITE_BUILD: '1', BASE_PATH: '/Pokemon-Crimson-Crystal/editor' },
  stdio: 'inherit',
});
// GitHub Pages must serve Svelte's _app directory without Jekyll filtering it.
writeFileSync(resolve(docs, '.nojekyll'), '');
