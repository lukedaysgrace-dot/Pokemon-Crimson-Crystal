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

## Intentional choices: do not "fix"
- Proton's lines keep "damn": `maps/RadioTower4F.asm` ("Damn it! Not to") and
  `maps/SlowpokeWellB1F.asm` ("stopped a damn"). Never change them.
- Lileep/Cradily are Water 3 + Plant (not official Water 3 only) so STUN SPORE can be bred.
- BRIGHTPOWDER is trainer-theft only (Koga/Janine), price 10. Not sold in marts.
- Dipplin's growth rate matches Applin/Appletun/Flapple/Hydrapple on purpose.
- HOSTESS is a reserved trainer class with no trainers yet.
- Don't change dialogue unless the user asks. Report text issues instead.

## Test harness quirks
- A PyBoy hook can fire twice for one object when an interrupt lands on the hooked
  instruction. In animation tests, more spawns than queue attempts is not a bug. Only
  attempts greater than spawns means an object was dropped.
- Battle fixtures are cached per ROM hash in `tools/battletest/fixtures/`. A broken ROM shows
  up as "New Game did not finish" during bootstrap.

## Reports
Past audits are in `reports/` (`full-audit-*.md`, `full-sweep-*.md`).
