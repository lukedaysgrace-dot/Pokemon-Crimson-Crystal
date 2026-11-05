# Personal stat screen review — 2026-11-05

Reviewed commit `6a65c964faac764f7cddaf7b281b23315f34b76a` and fixed the
transition defects below. No remaining failures were found in the tested flows.
Changes are left uncommitted for review.

## Findings and fixes

1. **Page colors could change before page content.** The existing combined-map
   helper actually queued a separate VBlank for each map. Palette uploads could
   occur before either map, briefly tinting INFO blue while its old content was
   still displayed. `StatsScreen_CommitPage` now copies palettes, tiles,
   attributes and OAM together during a CGB double-speed VBlank. Palette uploads
   remain deferred while pages and move details are prepared.
2. **Selector/cursor sprites could update early.** Normal OAM uploads could show
   the next selected page square over the previous page. OAM updates are now
   held during preparation and committed with the page.
3. **Shared graphics could visibly change before a transition.** Reloading EXP
   tiles on every page switch overwrote visible MOVES type pills. EXP tiles now
   reload only when entering INFO, whose adjacent pages do not display them.
   All three category graphics are cached separately, so move-detail selection
   changes only the tilemap and palette in the synchronized commit.
4. **Category markers had white padding in the green details panel.** The
   committed code explicitly assigned the white header palette to their cells;
   this visual mismatch was missed in the initial review. Details now rebuild
   the selected type in palette 6 and the category marker in palette 7, both
   with the green box fill. Regression checks inspect every rendered padding
   pixel for all three categories and verify the header/HP palette is unchanged.

## Verification

Both release and debug ROMs build with RGBDS 0.5.2.

| Suite | Result |
| --- | --- |
| New summary/PC suite | 1,403 checks passed per ROM, including green marker padding |
| Battle Stat EXP and displayed stats | 452 checks passed per ROM |
| Existing PC UI suites 1–3 | 53 checks passed per ROM |
| Rendered overworld/menu/battle suite | 28 checks passed per ROM |
| Battle type-icon suite, including new native summary returns | 41,184 release / 41,568 debug checks passed |
| `make audit-static` | Passed |
| `git diff --check` | Passed |

The full static and gameplay suites passed during the initial review. The
green-marker follow-up rebuilt both ROMs and reran the focused summary suite,
battle type-icon/summary-return suite, and resource audit.

Focused coverage includes all four pages, both wrap directions, physical/special/
status move details, four independent move-type palettes, cursor wrapping,
returning from move details to HP/status, boxed Pokémon and eggs, party browsing,
PC cursor/raster/OAM restoration, unchanged party and storage records, and
healthy/poisoned/burned/Frostbite/paralyzed/sleeping/fainted party summaries.

Frame comparisons reject any intermediate mixture of old/new page panels,
palettes, graphics or selector sprites. All 66 measured summary commits per
focused run finished on scanline 147, inside VBlank (144–153).

The battle suite now enters summaries through the native battle party menu in
Original and Enhanced modes, visits every page and move details, and checks
that both Pokémon pictures and all four type-icon slots are restored on return.
Existing PC suites also cover swaps, deposit/withdraw, held items, Mail, box
changes/themes/names, release/cancel and clean exit.

ROM0 slack remains 91 bytes release / 85 bytes debug. The header reservation is
unchanged. All emulator fixtures use private cartridge state; no player save
was opened or modified.

## Artifacts and reproduction

- Video: `_artifacts/summary-review/video/summary-pc-showcase.mp4`
  (131.6 seconds, native game audio, complete audio/video decode verified).
- Results and frame sheets: `_artifacts/summary-review/release/` and `debug/`.
- Audit log: `_artifacts/summary-audit-static.log`.
- Battle-return log: `_artifacts/summary-battle-returns.log`.
- Stat-value log: `_artifacts/summary-stat-exp.log`.
- Overworld log: `_artifacts/summary-overworld.log`.

```sh
make -j8 pokecrystal.gbc pokecrystal_debug.gbc
make test-summary-ui BATTLE_TEST_PYTHON=.venv/bin/python
.venv/bin/python tools/battletest/stat_exp_checks.py
.venv/bin/python tools/battletest/type_icon_checks.py
SUMMARY_RECORD=1 PC_UI_OUT=_artifacts/summary-review/video \
  .venv/bin/python tools/test_summary_ui.py pokecrystal.gbc
```

Verified ROM SHA-256:

- Release: `c0fc6640e604d7510d6000ec466daebe57893b4311206d317b4ef9c9eba5785e`
- Debug: `d1d90e9ddbf6ba84f20882fd7dc1781de7c0e02d7f47d15d99bab5122b088b14`

These results cover the documented emulator scenarios, not every possible
Pokémon/save state or physical hardware. Link/mobile/printer sessions and the
slower-machine fallback did not receive new end-to-end testing in this review.
