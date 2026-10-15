import { defineConfig } from '@playwright/test';
export default defineConfig({
  testDir: 'tests/ui',
  timeout: 60000,
  workers: 1,
  use: { baseURL: 'http://127.0.0.1:4173', viewport: { width: 1400, height: 1000 } },
  webServer: {
    command: 'node node_modules/vite/bin/vite.js --host 127.0.0.1 --port 4173',
    port: 4173,
    reuseExistingServer: !process.env.CI,
  },
});
