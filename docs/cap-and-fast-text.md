# Trainer-card cap and FAST default text

The trainer card's first page shows **LEVEL CAP** in Hard Mode. Opening the
page recalculates it through `UpdateLevelCap`, the same routine used by EXP
and Rare Candies. This avoids displaying a stale cached value after earning
a badge or loading an older save. The existing cap schedule is unchanged:
the first cap is 10, the cap before Blue is 69, and all sixteen badges end
progression caps with a maximum level of 100. Normal Mode has no extra row.
The Johto/Kanto badge pages and their navigation remain available.

FAST replaces MED in the default options for a new game. Continue still loads
saved options, so an existing FAST, MID or SLOW preference is preserved.
Neither change adds save fields or requires a save-layout migration.

Run `make test-cap-fast` with the project's RGBDS toolchain and a Python
runtime containing PyBoy, Pillow and PyYAML. Screenshots and results are in
`.tmpbuild/cap-fast-ui/<ROM name>/`; `gallery.png` compares cap stages,
Normal Mode and the new default options screen.

Both release and debug ROMs passed 172 focused checks each. The native UI
checks cover all seventeen badge counts, deliberately stale cached caps,
the pre-Dex card, both badge pages, text/options restoration, actual cap
tiles in display VRAM, and saving a selected SLOW preference followed by
a fresh emulator boot and Continue. Tests use private SRAM, not player saves.
