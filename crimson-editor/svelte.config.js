import adapter from '@sveltejs/adapter-static';
const website = process.env.WEBSITE_BUILD === '1';
const output = website ? '../docs/editor' : 'build';
export default {
  kit: {
    adapter: adapter({ pages: output, assets: output, fallback: 'index.html' }),
    paths: { base: process.env.BASE_PATH || (website ? '/Pokemon-Crimson-Crystal/editor' : '') },
  },
};
