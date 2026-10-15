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
and manifest entries. The manifest is sorted by commit date; checksums select a
layout, and an override is available in the UI. Layout changes require bumping
`SAVE_FORMAT_VERSION`; rebuild, regenerate, then update `save_layout.lock` with
`--write`. Do not update the lock to hide a same-version layout change.

The update workflow handles source pushes, daily fallback, dispatch and manual
runs and creates `codex/sync-crimson-editor-data`. Enable GitHub Actions permission
to create PRs in repository settings. No PAT is needed for this monorepo. All
generated data remains reviewable before merge. CI result artifacts include the
static site and ROM/symbol/map files.

`pnpm build` writes `build/`. Serve it on any static host. For GitHub Pages set
`BASE_PATH=/Pokemon-Crimson-Crystal/editor` when building and place the result at
the corresponding site path. Keep the existing documentation site alongside it.
The implementation does not activate or overwrite repository hosting settings.
