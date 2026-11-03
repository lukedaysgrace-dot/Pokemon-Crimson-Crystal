# Notes for AI agents (Codex, Claude, etc.)

Read this before changing the game. Keep it up to date when something here changes.

## Build
- Toolchain: RGBDS 0.5.2. Build both ROMs: `make -j8 pokecrystal.gbc pokecrystal_debug.gbc`.
- Static checks: `make audit-static` and `python3 tools/audit_*.py`.
- Emulator tests (PyBoy): `make test` / `make test-all`, plus `tools/test_*.py` and
  `tools/battletest/*_checks.py`. `release_audio_rtc_checks.py` and `fishing_ui_checks.py`
  need `tools/battletest/prepare_mbc30.py` run first.

## ROM0 (home bank) is almost full
- Fixed-bank free space is 94 bytes in release and 88 bytes in debug, split into
  small gaps; the largest gaps are 37 and 16 bytes respectively. Check the `SLACK`
  line for ROM0 in `pokecrystal.map` /
  `pokecrystal_debug.map`.
- If a build fails with `Unable to place "..." (ROM0 section) anywhere`, ROM0 is out of
  room. Move code into a ROMX bank and call it with `farcall`/`callfar`, or shrink something.
  Do not remove the header reservation to make room.
- `home.asm` reserves the cartridge header (`ds $0150 - $0104` in `SECTION "Header"`).
  Without it, the linker can put code at $0104-$014F, rgbfix overwrites it, and the ROM
  builds cleanly but crashes on boot. Keep it.
- The graphics/palette section `bank2` is also exactly full after the hippo family.
  Its two nearby back-palette dispatches use short jumps to fit the added palettes.

## Streamed overworld rendering
- Walking decodes only the entering edge into the existing VBlank queues through
  `home/map_stream.asm` and `engine/overworld/map_scroll.asm`. The VRAM BG map is
  the walking cache; `wTileMap`, `wAttrMap` and the surrounding buffers are stale
  between full redraws. Do not enable full-map uploads from those stale buffers.
- Menus, text, battles and `reloadmappart` retain `LoadMapPart`/reanchoring. Any new
  full-screen consumer must rebuild first. Tile/attribute tables are independently
  banked ROM data, not the donor engine's decompressed WRAM tables.
- Run `make test-streamed-map BATTLE_TEST_PYTHON=.venv/bin/python` after rendering
  changes. It checks all tilesets against the full decoder, queue bounds and banks,
  then native walking, weather, BG wrapping, connections, warps and UI returns.

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
- Mahogany granny uses the original Crystal supplies plus White Herb, Power
  Herb and Throat Spray (1000 each, unlimited), available after the hideout.
  It is a standard mart with no markup. Her former eleven battle items are
  selectable Battle Tower prizes, one per completed seven-win challenge.
- BrightPowder, Custap/Salac Berries, Black Sludge, Red Card, Heavy-Duty Boots,
  Blunder Policy and Eject Button are retired. Their `RETIRED_` indexes remain
  reserved; old saved stacks are removed and held items normalize to no item.
- Wild Ditto is the only powder source: Metal Powder in the common 20% slot,
  Quick Powder in the rare 5% slot. Base held-item low bytes use padding bits
  0/1 for their high bits; `_GetBaseData` resolves both to runtime IDs. Keep
  `LOW(QUICK_POWDER)` and Ditto's padding bit together.
- Run `make test-item-retirements` after changing retired-item compatibility
  or wild powder sources. It tests both ROMs, catalog routes and Quick Powder.
- All type-boosting held items give 20%. Pink Bow boosts Normal; Polkadot Bow
  boosts Fairy (there is no Fairy Feather). Keep their saved item indexes stable.

## Species additions
- There are 502 internal species indexes and 501 visible Dex entries. Append new
  indexes for ordinary additions; displayed regional numbering is separate in
  `data/pokemon/dex_order_new.asm`.
- The retired Spoink, Lotad, Spheal and Flittle families were explicitly replaced
  in their old slots by Zorua, Seedot, Honedge and Sableye. Their assets and source
  receipts are preserved in `no longer implemented/`; do not reintroduce them.
- AEGISLASH_BLADE is an internal battle-only art/stat record in the extra retired
  slot. It shares Aegislash's Dex identity and never enters parties or encounters.
  Saved old Espathra indexes normalize to Sableye on load/PC decode. Other saved
  species indexes and the v5 save layout stay stable. See
  `tools/testdata/roster_replacements.json` and `make test-roster`.
- ZORUA/ZOROARK are specifically the **Hisuian** forms: Normal/Ghost, Illusion,
  canonical Hisuian stats/weight and form-specific move access. Their stable
  constants omit a suffix because regular forms are absent. Do not import the
  regular Dark forms over them. Zoroark learns Shadow Claw on evolution; Nuzleaf
  learns Razor Leaf. Both also have level-1 reminder entries.
- Seedot/Nuzleaf/Shiftry have Prankster / Wind Rider / Technician. Hisuian
  Zorua/Zoroark have Illusion in every slot. Honedge/Doublade have No Guard;
  only Aegislash has Stance Change and learns King's Shield on evolution
  (also available from the level-1 reminder). The supplied nine menu icons are
  wired in `gfx/menu_icons.asm` and reused by the overworld icon pointers.
- Aegislash enters in Shield, changes before a damaging move or King's Shield,
  and resets on entry. Its banked WRAM2 flags never replace saved species.
  Form stats are recalculated from original DVs/stat EXP, including level-ups;
  Transform copies the current form and Stance Change, but the ability cannot
  activate while transformed. Struggle and called damaging moves also change
  form; inability to execute a move (sleep/flinch/paralysis) does not.
- With animations on, form changes fade only the actor out, load all sprite
  tiles while hidden, then fade the new form in. Substitute/Minimize and disabled
  animations retain the instant path. King Shield uses Detect's animation;
  the display name is `KING SHIELD` to fit the 12-character move-name limit.
- King's Shield shares Protect's failure counter, allows status moves through,
  and lowers contact attackers' Attack one stage. Run the native roster check
  and `tools/battletest/tests/97-roster-stance-change.yaml` after changing it.
  `tools/battletest/record_stance_change.py` records both native sides with game
  audio under `_artifacts/roster/stance-change-video/` using private fixtures.
  `tools/battletest/stance_change_checks.py` compares all five stats and seven
  stages with ordinary form controls, including status penalties and varied DVs.
- Mienfoo/Mienshao are internal 499/500, regional #264/#265, and evolve at level 50.
  Their Field/Human-Like groups and supported move provenance are recorded in
  `tools/testdata/mienfoo_mienshao.json`. Run `make test-mienfoo` for native checks.
- Crimson Mienfoo/Mienshao are Fighting/Fairy with Serene Grace in slot 1;
  Original typing is pure Fighting. Mienshao's Enhanced Speed/Sp. Atk are 115/85,
  while Original retains 105/95. Their requested Fairy/coverage moves are authored
  additions in `tools/testdata/authored_move_restorations.json`.
- Hippopotas/Hippowdon append at internal 501/502, regional #235/#236 after
  Donphan, and evolve at level 34. Both are Ground with Sand Stream / Sand Force /
  Strong Jaw (Lumi 3.0 slots), Slow growth, and Field egg groups. Their complete
  implemented mainline-history/Lumi move union is recorded in
  `tools/testdata/hippopotas_hippowdon.json`. Route 45 supplies both species;
  supplied sprites use one static front frame and official-color shiny palettes.
  Run `make test-hippos` for the native family and battle checks.
- The current seen/caught fields are 63 bytes each (capacity 504 species).
  Exceeding that capacity requires reviewing WRAM/SRAM and save migration.

## Intentional choices: do not "fix"
- Proton's lines keep "damn": `maps/RadioTower4F.asm` ("Damn it! Not to") and
  `maps/SlowpokeWellB1F.asm` ("stopped a damn"). Never change them.
- Lileep/Cradily are Water 3 + Plant (not official Water 3 only) so STUN SPORE can be bred.
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
- Mahogany Mart keeps Dragonite visible after Hyper Beam. Lance's map-local
  secondary RAM movement stream walks ahead of the Dragonite/player follow pair;
  Dragonite steps up to 5,2 and faces down for the stair dialogue, then joins
  Lance from above via 6,2 and follows him downstairs. The bookcase at 6,4 is
  blocked; do not route Dragonite through it.
  B2F's healing Dragonite stands at 4,13, one tile left of Lance, and uses the
  healed event separately from the later executive-scene Dragonite. The west
  healing trigger is at 3,13 so Dragonite does not block it. Run
  `python3 tools/check_lance_escort_scenes.py` for both mart entrances, both
  healing approaches, native HP/status/PP restoration and re-entry persistence;
  repeat with `--rom pokecrystal_debug.gbc --output _artifacts/lance-escort-scenes-debug`.
  `python3 tools/record_lance_escort_scenes.py` records the mart entrance,
  healing and Ariana/Dragonite/Lance arrival with game audio under
  `_artifacts/lance-escort-videos/`, using only private emulator fixtures.
- B2F's transmitter scenes keep Dragonite horizontally beside Lance with the
  same facing. Dragonite may face right during the first conversation after
  Lance's two rightward steps; Lance faces down toward the player. Do not add
  extra lineup steps or detours. The hall inspection goes four tiles left,
  eight right and four left back to its starting spot, with the original
  upward looks and pauses; Dragonite mirrors it beside him. The actors mirror each
  route simultaneously; the player uses the native follow slot when entering.
  The initial entry chooses opposite sides for the two doorway columns so
  both stay on floor. The final return uses columns 18/19, then ends at 14/15
  beside the player at 13,11; their straight downward exit fits the open door.
  Both companions disappear only after walking off screen together.
  `python3 tools/record_rocket_transmitter.py` runs native Ariana/three-Electrode
  battles, validates actor paths against collisions and records the entire
  briefing-to-departure sequence with audio under `_artifacts/rocket-transmitter/`.
  Use `--no-video --entry right --order 3,1,2 --rom pokecrystal_debug.gbc` to
  test the other doorway and another final Electrode. No player save is touched.
  Add `--skip-electrode-battles` to omit those fights from the video while
  still running all three native battles and checks.
- Battle fixtures are cached per ROM hash in `tools/battletest/fixtures/`. A broken ROM shows
  up as "New Game did not finish" during bootstrap.
- B3F Lance's Outrage scene uses the walking `SPRITE_DRAGON` at 24,14. Keep
  the Rocket facing right for one rapid vertical slam, with `SFX_EGG_BOMB` on
  landing. Dragonite lunges through sprite offsets, then steps down to clear
  Lance's silent approach. Keep `follow LANCE, DRAGONITE` (leader first) active
  as Lance confronts the grunt, returns to the player and leaves. The initial
  diagonal follow step yields the aisle, then reseeds normally once adjacent.
  At impact the grunt switches to the supplied `rocket_asleep.png` static art
  and stays asleep on map re-entry, using the existing scene departure flag.
  `SPRITE_ROCKET_BASE_GRUNT` is its dedicated variable sprite; don't replace
  other Rocket actors' graphics when loading the four sleeping tiles.
  `python3 tools/record_lance_dragonite.py` checks the incoming stair warp, the
  single slam and impact timing, silent confrontation, concurrent following and
  persistent departure, and records
  game audio under `_artifacts/lance-dragonite/`. Use `--rom pokecrystal_debug.gbc`
  to check the debug ROM too; only private emulator memory is staged.

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
Modern height/weight references for all 502 slots are in
`tools/testdata/species_dimensions.json`. Run `python3 tools/audit_species_dimensions.py
--rom pokecrystal.gbc --rom pokecrystal_debug.gbc` (also part of `make audit-static`).
Dipplin is 0.4 m / 4.4 kg; Bloodmoon Ursaluna is 2.7 m / 333.0 kg. PokeAPI
currently has incorrect dimensions for those records; the receipt links official
confirmations. Battle weights derive from Dex pounds, so keep
`tools/testdata/species_weights.json` aligned when changing them. Custom species
retain authored dimensions, and regional forms must use form-specific sources.

Past audits are in `reports/` (`full-audit-*.md`, `full-sweep-*.md`).
