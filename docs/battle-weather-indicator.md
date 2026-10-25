# Battle weather indicator

Rain, sun, sandstorm and Hail have labeled, colored 16×16 icons in the
ordinary battle command menu and the move-selection menu. They occupy the
lower-left space beside the options, below the move information box.
Clear weather has no icon. Cloud Nine hides the icon while suppressing the
weather; removing suppression reveals the underlying weather again.

The icons and the menu-time sprite approach come from
[CrystalShireEngine](https://github.com/aaronjeter/CrystalShireEngine/tree/core/gfx/battle/weather).
Crimson adds command-menu display, Hail support, suppression handling and
explicit hardware OAM updates. Battle menus normally freeze OAM transfers,
so drawing/clearing temporarily enables transfers for one VBlank and then
restores the previous setting. The indicator clears before a chosen move,
rejection message or another menu can use those sprites.

The implementation uses four existing animation tiles and four OAM entries
only while a menu is open. It does not change save fields, weather duration,
weather effects, ability banners or battle backgrounds.

## Verification

Run `make test-battle-weather` with the project's RGBDS toolchain and a Python
runtime containing PyBoy, Pillow and PyYAML. The checks boot both release and
debug ROMs with private SRAM and stage encounters without reading player saves.

Coverage includes all 256 weather bytes, correct hardware/virtual OAM and icon
tiles, preservation of background/OAM scheduling, Cloud Nine on either side,
command/move menus, cursor movement, move reordering, Pack return, all four
weather moves with animations enabled, and natural weather expiration.

Actual rendered screenshots and a contact sheet are written to
`.tmpbuild/battle-weather-indicator/<ROM name>/`, together with check results
and hardware sprite diagnostics.

Verified on release and debug builds: 1,337 focused checks and 11 captured
screens per ROM (2,674 checks total). Existing regression coverage also passed:
12 native battle UI scenarios / 44 assertions, 90 weather/ability-chain battle
cases, 10,192 resource/audio checks and 185 save-layout/recovery checks.
These are focused integration checks, not a complete campaign playthrough.
