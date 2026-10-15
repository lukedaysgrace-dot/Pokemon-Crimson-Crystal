// Serve the real docs tree at the exact GitHub Pages project path, without SPA fallbacks.
import { createServer } from 'node:http';
import { createReadStream, statSync } from 'node:fs';
import { dirname, extname, isAbsolute, relative, resolve, sep } from 'node:path';
import { fileURLToPath } from 'node:url';

const docs = resolve(dirname(fileURLToPath(import.meta.url)), '../../docs');
const prefix = '/Pokemon-Crimson-Crystal/';
const types: Record<string, string> = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json',
  '.png': 'image/png',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
};
createServer((request, response) => {
  try {
    const path = decodeURIComponent(new URL(request.url || '/', 'http://localhost').pathname);
    if (path === '/') {
      response.writeHead(302, { Location: `${prefix}index.html` });
      response.end();
      return;
    }
    if (!path.startsWith(prefix)) throw new Error('Outside project path');
    let file = resolve(docs, path.slice(prefix.length));
    const local = relative(docs, file);
    if (isAbsolute(local) || local === '..' || local.startsWith(`..${sep}`))
      throw new Error('Outside docs');
    if (statSync(file).isDirectory()) file = resolve(file, 'index.html');
    if (!statSync(file).isFile()) throw new Error('Not a file');
    response.writeHead(200, {
      'Content-Type': types[extname(file)] || 'application/octet-stream',
      'Cache-Control': 'no-store',
    });
    if (request.method === 'HEAD') response.end();
    else
      createReadStream(file)
        .on('error', () => response.destroy())
        .pipe(response);
  } catch {
    response.writeHead(404, { 'Content-Type': 'text/plain' });
    response.end('Not found');
  }
}).listen(4174, '127.0.0.1', () =>
  console.log(`Website preview: http://127.0.0.1:4174${prefix}index.html`),
);
