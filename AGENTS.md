# Notes for AI agents (Codex, Claude, etc.)

Read this before changing the game. Keep it up to date when something here changes.

## Build
- Toolchain: RGBDS 0.5.2. Build both ROMs: `make -j8 pokecrystal.gbc pokecrystal_debug.gbc`.
- Static checks: `make audit-static` and `python3 tools/audit_*.py`.
- Emulator tests (PyBoy): `make test` / `make test-all`, plus `tools/test_*.py` and
  `tools/battletest/*_checks.py`. `release_audio_rtc_checks.py` and `fishing_ui_checks.py`
  need `tools/battletest/prepare_mbc30.py` run first.

## ROM0 (home bank) is almost full
- Fixed-bank free space is about 95 bytes in total, split into small gaps. The largest gap
  is under 30 bytes. Check the `SLACK` line for ROM0 in `pokecrystal.map` /
  `pokecrystal_debug.map`.
- If a build fails with `Unable to place "..." (ROM0 section) anywhere`, ROM0 is out of
  room. Move code into a ROMX bank and call it with `farcall`/`callfar`, or shrink something.
  Do not remove the header reservation to make room.
- `home.asm` reserves the cartridge header (`ds $0150 - $0104` in `SECTION "Header"`).
  Without it, the linker can put code at $0104-$014F, rgbfix overwrites it, and the ROM
  builds cleanly but crashes on boot. Keep it.

## Item IDs are 16-bit
- Bag rows in `wItems` / `wPCItems` are 3 bytes: [index hi, index lo, quantity].
  `wBalls` and `wKeyItems` use 1-byte runtime IDs.
- `wCurItem`, party held items and `wCurMart` hold 8-bit runtime IDs. Convert with
  `GetItemIDFromIndex` / `GetItemIndexFromID` (home/16bit.asm).
- Items below TM01 have fixed runtime IDs equal to their index, so `cp SOME_ITEM` on a
  runtime ID is only valid for those. Items at $101 and up must be compared as 16-bit indexes.
- `hiddenitem` is `dw flag, dw item` (4 bytes). Mart prices: `wMartItem1BCD`..`wMartItem10BCD`
  continue into `wMartExtraPrices` (14 items max).
- Save format version is 5.
- All type-boosting held items give 20%. Pink Bow boosts Normal; Polkadot Bow
  boosts Fairy (there is no Fairy Feather). Keep their saved item indexes stable.

## Species additions
- There are 500 internal species indexes. Append new indexes to preserve saved
  Pokémon; displayed regional numbering is in `data/pokemon/dex_order_new.asm`.
- Mienfoo/Mienshao are internal 499/500, regional #262/#263, and evolve at level 50.
  Their Field/Human-Like groups and supported move provenance are recorded in
  `tools/testdata/mienfoo_mienshao.json`. Run `make test-mienfoo` for native checks.
- Crimson Mienfoo/Mienshao are Fighting/Fairy with Serene Grace in slot 1;
  Original typing is pure Fighting. Mienshao's Enhanced Speed/Sp. Atk are 115/85,
  while Original retains 105/95. Their requested Fairy/coverage moves are authored
  additions in `tools/testdata/authored_move_restorations.json`.
- The current seen/caught fields are 63 bytes each (capacity 504 species).
  Exceeding that capacity requires reviewing WRAM/SRAM and save migration.

## Intentional choices: do not "fix"
- Proton's lines keep "damn": `maps/RadioTower4F.asm` ("Damn it! Not to") and
  `maps/SlowpokeWellB1F.asm` ("stopped a damn"). Never change them.
- Lileep/Cradily are Water 3 + Plant (not official Water 3 only) so STUN SPORE can be bred.
- BRIGHTPOWDER is trainer-theft only (Koga/Janine), price 10. Not sold in marts.
- Dipplin's growth rate matches Applin/Appletun/Flapple/Hydrapple on purpose.
- HOSTESS is a reserved trainer class with no trainers yet.
- Magby, Magmar and Magmortar must never learn or know SCALD. It is listed under `excluded` in
  `tools/testdata/authored_move_restorations.json`, which the historical move-access generator honors.
- Don't change dialogue unless the user asks. Report text issues instead.
- Pixie Punch is excluded from Galarian Ponyta/Rapidash and Azurill on theme (hooves/no arms), even though
  their stats qualify. See `excluded` in `tools/testdata/pixie_punch.json`.

## Test harness quirks
- Entry tests must use a legal species/ability pair. Arbitrary lead ability
  overrides are applied after entry; a post-entry ability assertion alone
  does not prove that ability was active during switch-in effects.
- A PyBoy hook can fire twice for one object when an interrupt lands on the hooked
  instruction. In animation tests, more spawns than queue attempts is not a bug. Only
  attempts greater than spawns means an object was dropped.
- Battle fixtures are cached per ROM hash in `tools/battletest/fixtures/`. A broken ROM shows
  up as "New Game did not finish" during bootstrap.

## Illusion
- Totodile's slot 1 is temporarily ILLUSION for testing (slots 2/3 stay Torrent/Sheer Force).
- Illusion copies the last conscious non-Egg party member's appearance, nickname,
  gender and shiny palette, while keeping all real battle/party data. It resets on
  every entry. Its two active-slot bytes are banked WRAM2, not saved data.
- The custom +1 Speed reward occurs once when a direct damaging hit breaks an
  active disguise. Substitute damage and residual/recoil damage do not break it.
  Suppression reveals without that damage reward; Gas ending cannot restore a
  disguise. Transform/Imposter fail if either battler has an active disguise.
- Reveals warp the copied sprite with Transform's wave and Dark Pulse's
  `SFX_SPITE`. At the picture-update cue the real sprite/palette appears, then
  the wave contracts around it. Do not add a palette flash. Keep the disguise
  active until that cue; skip directly to the clean reveal if animations are off.
- Run `tools/battletest/tests/96-illusion.yaml`; generate every-move coverage with
  `python3 tools/battletest/illusion_move_matrix.py` (use `--abilities-only` for
  every opposing ability against a legal active disguise). `record_illusion.py` verifies
  exact front/back tiles and palettes against ordinary species controls and records
  native switches/reveals with audio under `_artifacts/illusion/`.

## Reports
Past audits are in `reports/` (`full-audit-*.md`, `full-sweep-*.md`).
