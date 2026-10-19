# Manual and automated acceptance checks

For the format-4 update, open a save produced by the updated ROM and select
Phantump and Trevenant. Check normal/shiny sprites, all three ability slots,
Horn Leech in the level-up filter, family egg moves (Disable and Sucker Punch)
and Blackthorn moves in the tutor filter. Download and reopen the save; verify
the chosen species, moves and ability survive, with both Dex flags preserved.
Format-3 saves should still select their retained profile. Saving them in the
updated game upgrades them to format 4 while preserving campaign progress.

Automated Playwright checks upload a synthetic save, edit a party nickname and
level plus a box nickname, download, independently parse the bytes, and upload
the download again. They also verify truncated/zero saves show errors. The suite
records landing/editor screenshots under ignored `test-results/` for visual QA.

Additional manual checks when releasing:

1. Upload a clean save. Confirm build, loaded copy and gameplay-rules badges.
2. Select regional/clone species with equal display names; confirm their constants
   remain distinct. Edit level, DVs, Stat Exp, ability, Hidden Power and shiny flag.
3. Edit names, theme and slots in boxes 1 and 25. Remove a Bad Egg; export should
   become available only after all errors are resolved.
4. Add/remove bag stacks, reusable TMs, key items and PC items. Check limits and
   duplicate/wrong-pocket diagnostics.
5. Edit player money/coins, dex, flags and an occupied daycare slot. Export and
   reload. Confirm unknown flags and unused bytes are preserved in byte diffs.
6. Inspect a symbol and export diagnostics/diff JSON. Export a mon as JSON and
   battletest YAML. Import JSON with invalid IDs; it should be rejected.
7. Confirm warnings require review and unsupported layouts remain read-only.
8. Confirm the output's RTC trailer equals the upload and both copies validate.

The emulator gate independently loads the edited SRAM through `TryLoadSaveFile`,
resolves party species/moves using ROM routines and decodes all boxes through
`GetStorageBoxMon`, checking for Bad Eggs.

## Fresh game integration test

After rebuilding both ROMs and running `pnpm extract`, the stronger integration
test creates a real new game with native input and saves through the game's Save
menu. The browser then adds five party Pokémon and three boxed Pokémon, including
regional/clone species, high move indexes, a shiny and an egg. A new emulator uses
Continue, opens the party and PC screens, exercises storage swaps, saves through
the native menu, and verifies the roster again after a second cold boot.

From `crimson-editor/` with PyBoy, PyYAML and Pillow installed:

```sh
python tools/roundtrip/fresh_game_check.py create --out tests/output/fresh-game
CRIMSON_FRESH_TEST_DIR="$PWD/tests/output/fresh-game" pnpm exec playwright test tests/ui/fresh-save.spec.ts
python tools/roundtrip/fresh_game_check.py verify --out tests/output/fresh-game --save tests/output/fresh-game/editor-added-pokemon.sav --expected tests/output/fresh-game/editor-expected.json
```

On Windows, set `CRIMSON_FRESH_TEST_DIR` through PowerShell and run the Python
steps through the repo's WSL `.venv`. Every emulator uses a private copy of the
ROM and private SRAM; existing player saves are never loaded or overwritten.
Screenshots, saves and JSON reports are written into the selected output folder.
