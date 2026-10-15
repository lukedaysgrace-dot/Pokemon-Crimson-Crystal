import type { Reroute } from '@sveltejs/kit';

// Static hosts serve the same entry file at /editor/ and /editor/index.html.
// Resolve the explicit filename to the root route as well.
export const reroute: Reroute = ({ url }) =>
  url.pathname.endsWith('/index.html') ? url.pathname.slice(0, -'index.html'.length) : undefined;
