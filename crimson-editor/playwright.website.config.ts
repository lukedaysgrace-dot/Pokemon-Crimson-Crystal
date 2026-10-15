import { defineConfig } from '@playwright/test';
export default defineConfig({
  testDir: 'tests/website',
  timeout: 60000,
  workers: 1,
  use: {
    baseURL: 'http://127.0.0.1:4174/Pokemon-Crimson-Crystal/',
    viewport: { width: 1400, height: 1000 },
  },
  webServer: {
    command: 'node node_modules/tsx/dist/cli.mjs tools/website-server.ts',
    port: 4174,
    reuseExistingServer: !process.env.CI,
  },
});
