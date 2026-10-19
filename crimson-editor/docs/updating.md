# Updating game data and hosting

Build with the source toolchain rather than the damaged committed binaries:

```sh
bash crimson-editor/tools/build-crimson.sh
cd crimson-editor
pnpm extract
pnpm validate-data
pnpm exec tsx tools/changelog.ts
python ../tools/save_layout_lock.py --profile static/gamedata/BUILD_ID.json
```

For another checkout use `pnpm extract -- --crimson PATH --build SHA`. Options
`--rom`, `--sym` and `--out` select explicit inputs/outputs. Keep old JSON bundles
and manifest entries. If one source commit produces different save layouts,
extraction retains the old profile and adds a version-suffixed profile instead
of overwriting it. The manifest is sorted by commit date; checksums select a
layout, and an override is available in the UI. Layout changes require bumping
`SAVE_FORMAT_VERSION`; rebuild, regenerate, then update `save_layout.lock` with
`--write`. Do not update the lock to hide a same-version layout change.

The update workflow handles source pushes, daily fallback, dispatch and manual
runs and creates `codex/sync-crimson-editor-data`. Enable GitHub Actions permission
to create PRs in repository settings. No PAT is needed for this monorepo. All
generated data remains reviewable before merge. CI result artifacts include the
static site and ROM/symbol/map files.

`pnpm build` writes a standalone preview to `build/`.

The public website uses GitHub Pages from `main` / `docs`. To update its editor:

```sh
cd crimson-editor
pnpm build:website
pnpm test:website
```

`build:website` writes the production editor directly to `docs/editor/`, with
`/Pokemon-Crimson-Crystal/editor` as its base path. It also creates
`docs/.nojekyll` so GitHub Pages serves Svelte's `_app` assets. Commit and push
the generated `docs/editor/` files alongside editor source changes to publish
them through the existing Pages setup. No hosting setting change is needed.

The documentation generator includes the **Save Editor** tab in every page's
main navigation. Regenerate those pages with the usual documentation command;
the generator preserves `docs/editor/`. The editor links back to the guides.

`test:website` serves the real `docs` tree at the exact GitHub Pages project path
and checks navigation, game-data and sprite loading, save upload/download,
links from nested pages, and mobile navigation. The CI workflow runs these checks.
