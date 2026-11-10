# Notes for AI agents (Codex, Claude, etc.)

Read this before changing the game. Keep it up to date when something here changes.

## Build
- Toolchain: RGBDS 0.5.2. Build both ROMs: `make -j8 pokecrystal.gbc pokecrystal_debug.gbc`.
- Static checks: `make audit-static` and `python3 tools/audit_*.py`.
- Emulator tests (PyBoy): `make test` / `make test-all`, plus `tools/test_*.py` and
  `tools/battletest/*_checks.py`. `release_audio_rtc_checks.py` and `fishing_ui_checks.py`
  need `tools/battletest/prepare_mbc30.py` run first.

## ROM0 (home bank) is almost full
- Fixed-bank free space is 109 bytes in release and 103 bytes in debug, split into
  small gaps. Check the `SLACK`
  line for ROM0 in `pokecrystal.map` /
  `pokecrystal_debug.map`.
- If a build fails with `Unable to place "..." (ROM0 section) anywhere`, ROM0 is out of
  room. Move code into a ROMX bank and call it with `farcall`/`callfar`, or shrink something.
  Do not remove the header reservation to make room.
- `home.asm` reserves the cartridge header (`ds $0150 - $0104` in `SECTION "Header"`).
  Without it, the linker can put code at $0104-$014F, rgbfix overwrites it, and the ROM
  builds cleanly but crashes on boot. Keep it.
- The graphics/palette section `bank2` remains tight. Battle attribute layout
  lives in `engine/battle/type_icons.asm` to leave room for palette hooks.
  Its two nearby back-palette dispatches use short jumps to fit the hippo palettes.

## Recorded cries
- Missing official-species/form cries use Coral-format DED recordings, with
  assignments/source hashes in `tools/testdata/sampled_cries.json`. Preserve the
  protected original Crystal, clone/custom and existing proper adapted cries.
  Regional forms and their regional evolutions retain their pre-import cry
  assignments (including Hisuian Zorua/Zoroark's suffixless constants).
  Clodsire uses Quagsire's exact cry. `restored_regionals` records the 43
  restored assignments; `sample_order` keeps all other sampled IDs stable.
  New encodes are 16.384 kHz; copied Coral samples retain 10.48576 kHz. Normal
  builds require neither downloads nor the optional scipy/soundfile encoder.
- Cry header indexes with bit 15 set dispatch to `audio/sampled_cries.asm`;
  `PlaySpeciesCry` is banked with `PokemonCries` to save ROM0. The copied WRAM4
  decoder and its dedicated buffers must stay separate from map/picture data.
  Its 16-byte wave buffer must be aligned to 16 bytes. During playback only,
  `hSoundKeepalive*` is a saved/restored overlay; bit 7 enables the timer's
  stream-upload path. VBlank mode 7 is the short playback handler. Preserve
  timer/interrupt/WRAM restoration, stereo tracks and final-block drain.
- Sample playback uses a 16-block WRAM4 ring. The timer uploads a complete
  block without changing the interrupted registers, flags or ROM bank, so
  normal picture-script calculation can run while audio continues. Sampled
  PokeAnim cry commands prepare their following Setup/Setup2 before playback;
  the same native Play/Play2 then advances each frame. VBlank commits only
  its prepared 7x7 tile snapshot, with timer interrupts allowed. Finish/Idle
  and full-map DMA stay in the normal loop after playback. Keep the VBlank
  bank switch stack-based (`homecall`): a nested `farcall` would corrupt the
  foreground farcall's shared return buffers. No direct VBlank picture work
  should use those buffers or overwrite the streamed overworld cache.
- Run `make test-sampled-cries` for both-ROM exact native decoded-block,
  preservation, duration and sound cleanup checks. `python3
  tools/battletest/sampled_cry_checks.py --record` creates the searchable
  listening gallery, compilation and individual emulator WAV recordings in
  `_artifacts/sampled-cries/`. These use private emulator states only.
  Listening recordings must use `record_sampled_cries.py` / SameBoy (the
  `--record` flag delegates to it). PyBoy's streamed-wave sample order and
  retrigger phase distort the final sound even when decoded blocks pass.
  SameBoy capture checks compare the final audio with the independently
  decoded reference; never use the old PyBoy WAVs as listening previews.
- `python3 tools/battletest/record_cry_battles.py` records 13 remaining changed
  non-regional cries in native battles using SameBoy, including entrances,
  picture animation, battle music and a combat turn. Individual MP4s, a joined
  video, entry screenshots and checks go in `_artifacts/cry-battles/`.
  The recorder uses a private New Game and native debug battle requests; it
  never injects direct cry calls, substitutes audio or opens player saves.
  It asserts visible pose and script changes during each animated cry and
  zero audio-ring underruns; one-frame art (such as Hippopotas and Jirachi)
  is explicitly recognized from its native animation script.
  `make test-cry-animation-sync` runs both-ROM stream checks plus native
  short/long-cry motion checks and produces fresh videos.

## Battle type icons
- The supplied 8x8 symbols in `gfx/battle_type_icons/` appear under both names:
  enemy columns 2/3 on row 1, player columns 10/11 on row 8. Single types leave
  the second slot blank. Live battle types follow the save's Original/Enhanced
  rules and type changes; Illusion shows the disguise's rule-aware types.
- Bank-1 BG tiles $60-$63 hold the four symbols. Palette 5 colors 1/2/3 and
  EXP palette color 1 provide independent colors; EXP/star art uses only 0/2/3.
  Preserve these slots when changing animation palettes or attribute restoration.
  Animated front pictures skip $60-$63 too: upload $31-$5f, then $64-$7f,
  then $80-$ff in bank 1, and map animation tile indexes through the same gap.
  Bank-1 $7f is picture data; textbox spaces use bank 0. The padded animation
  limit is 252 tiles (Dusknoir fills it). Do not restore the old $7f-only gap.
  `BitmasksPointers` is uniformly `dw`, including appended/shared forms; its
  masks live in the same ROM bank. A stray `dba` breaks subsequent animations.
  The move info box ends at column 9 and its compact PP row fits inside it.
- Animation palette updates rebuild only the symbols' display colors after
  DMG remapping. Their backgrounds follow the HP palettes; fully flat HP
  palettes hide their symbols too. Dark uses RGB 18/10/25 on black and its
  ordinary color otherwise. Clearing either HUD also changes its two icon
  cells to bank-0 spaces in that side's HP palette: bank-1 $7f is art.
  Complete the opponent-HUD upload before queued SHOW_MON effects can reset
  the BG-map third; otherwise the player's HP panel can linger without icons.
- Run `make test-battle-type-icons BATTLE_TEST_PYTHON=.venv/bin/python` for both
  ROMs, all symbols/colors/slots, typing modes, animation and menu returns.
  Screenshots and the all-type chart go in `_artifacts/battle-type-icons/`.
  That target also runs `tools/test_battle_picture_tiles.py` for exact native
  frame maps, pointer widths, VRAM uploads and the largest animation. The HUD
  suite checks the forest species and explicit enemy-picture reloads.
  `type_icon_animation_checks.py` checks all 256 BG mappings and both sides of
  blackout, flash and custom-palette animations. Add `--all-moves` for every
  move animation, or `--record` for a focused video with native game audio in
  `_artifacts/type-icon-animation-fix/`. All fixtures use private emulator state.

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
  `wBalls` and `wKeyItems` use 1-byte runtime IDs. `wKeyItems` is a root of
  `ItemTableGarbageCollection`: EXP RELAY ($0130) has a temporary runtime ID,
  and every save runs a collection. Any new byte array that can hold an
  item at TM01 or above must also be added to that collector's roots.
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
- EXP RELAY ($0130) is a reusable field-only Key Item. Elm calls once after six
  total badges, regardless of order, using the outdoor special-call system without
  replacing other pending calls. Talk to him in the lab for the one-time gift and
  explanation; existing saves with six or more badges also qualify. It transfers
  all five big-endian Stat EXP words with $ffff saturation, then zeroes the donor and
  recalculates both with the normal stat-mode-aware calculator. Current HP only
  clamps down to the new maximum; it never heals or revives. Run
  `make test-exp-relay` for both-ROM quest, transfer and menu cancellation checks.
  `python3 tools/record_exp_relay_quest.py` records the native outdoor call, lab
  pickup and repeat instructions with game audio under `_artifacts/exp-relay-quest/`.
  Use `--no-video --rom pokecrystal_debug.gbc --output _artifacts/exp-relay-quest-debug`
  for the debug walkthrough. Both scripts use only private emulator state.

## Battle Stat EXP
- Battle awards retain all five Gen 2 Stat EXP words, division, Pokérus and
  saturation rules. Hard Mode caps and level 100 block regular EXP only;
  eligible conscious participants and EXP Share holders still earn Stat EXP.
- `wPendingStatExpRecalcs` uses the former unused battle byte after `wWildMon`. Awards
  mark party slots; normal level-up calculations clear their slot, and later
  awards mark it again. `ExitBattle` refreshes pending party stats before
  evolution/cleanup on all outcomes. Do not refresh them during combat or copy
  modified battle stats into the party.
- The deferred calculation preserves damage taken when maximum HP changes;
  zero HP stays zero even if the recipient fainted after earning Stat EXP.
  Run `make test-stat-exp BATTLE_TEST_PYTHON=.venv/bin/python` for both ROMs,
  all levels, caps, sharing, switching, fainting and subsequent battle entry.

## Battle move metadata and priority
- Hidden Power's move-table row is a placeholder. Use its owner's stored type,
  fixed 70 power and current stat-based category where appropriate. Forewarn
  ranks its fixed 70 power; Gale Wings checks the actual owner's type.
- `wPlayerLastMoveType` / `wEnemyLastMoveType` (WRAM2) record the resolved type
  alongside last-used move IDs. Conversion2 and its AI use this history, not
  current weather/abilities or AI-mutated move structs. The bytes are valid
  only while the corresponding last-move ID is nonzero.
- The WRAM2 `w*ActionMove` / `w*ActionAbility` fields retain the selected action
  and effective ability at ordering. Called moves inherit that priority and
  Prankster origin. Capture also covers Pursuit interception and Giga Hammer
  reselection; entry clears each incoming side before Imposter can run.
  Future Sight's delayed hit is independent of this turn's selected action.
- Foe-target status moves without `checkhit` still need the pre-execution
  guard (Mimic, Mirror Move, Psych Up, Mean Look, Nightmare, Sketch, Transform
  and Ghost Curse). Called/continuing actions skip PP, not this guard. Perish
  Song receives the global priority-shield check without Dark-type immunity.
  Immediate damaging actions are checked before charge/self-faint commands;
  Bide's storage and Future Sight's delayed strike retain their own paths.
- `make test-moves-abilities BATTLE_TEST_JOBS=8` includes every-move semantic
  outcomes, dynamic-type controls and called-move interactions. The optional
  `make test-exhaustive-battles BATTLE_TEST_JOBS=8` also plays every move with
  every ability in both roles and directions; its Cartesian checks establish
  execution/state integrity, while the focused matrices assert mechanics.
  All fixtures use private emulator memory, never player saves.

## Species additions
- There are 503 internal species indexes and 501 visible Dex entries. Append new
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
  Hippopotas uses one static front frame; Hippowdon's front.png is a 15-frame
  strip: squint, jaw-raised roar, geyser small/mid/full pulses (frames 3-11,
  each paired with a side-vent flow phase) and three idle side-flow phases.
  Both use official-color shiny palettes.
  Run `make test-hippos` for the native family and battle checks.
- The current seen/caught fields are 63 bytes each (capacity 504 species).
  Exceeding that capacity requires reviewing WRAM/SRAM and save migration.
- ZANGOOSE_SCARRED appends at internal 503 for Viridian Forest's one-time level-50
  survivor. It is Normal/Poison in both typing modes, shares Zangoose's art,
  stats/abilities and Dex identity, and retains its form through capture, PC and
  v5 saves. Its offspring are ordinary pure-Normal Zangoose. Dire Claw is injected
  only into this wild encounter; neither form learns it by level, reminder,
  machine, tutor or breeding. Ordinary encounter selection rejects the form.
  The event uses Zangoose at 2,30 and Seviper at 2,31 / 3,30, with triggers at
  6,30 / 6,31. All three cycle walking frames in place. Zangoose uses Wimpod's
  gray body shade with red markings in a forest-local palette. The intro knocks
  the right-hand Seviper to 4,30 and back; talking to it repeats a mutual lunge
  without tile movement or a battle. Only the lower Seviper starts a battle.
  The other flees via column 6, then Zangoose steps once right to 3,30 and faces
  down toward the player at 3,31. Both battles prevent all escape methods.
  Once the intro trigger has played, re-entering the forest from outside (any
  warp, Fly/Teleport/Dig/Escape Rope, or a whiteout) before Seviper is beaten
  means the player abandoned Zangoose: the map callback sets
  EVENT_VIRIDIAN_FOREST_ZANGOOSE_PERISHED plus all three GONE flags, and the
  bg_event on Zangoose's tile (2,30) shows ForestRivalryRemainsText. The callback
  only runs on real entries, not after in-forest battles or on Continue. After
  Seviper is beaten, a whiteout against Zangoose still preserves the encounter;
  catching or fainting Zangoose ends it without remains.
  Six unused EVENT_12A..12F bits hold progress without shifting save offsets.
  The Viridian group's unused swimmer graphics entries now load the supplied
  full walking sheets. New NPC sprite IDs shift the icon range's end to $e6;
  the runtime-only Day-Care sentinels are $e6/$e7, below variables at $f0.
  Run `make test-forest-rivalry`; add `--record` to
  `python3 tools/battletest/forest_rivalry_checks.py` for the complete native
  event with audio in `_artifacts/forest-rivalry/`. `python3 tools/record_forest_rivalry.py`
  records two gameplay videos with audio in `_artifacts/forest-rivalry-videos/`: the
  full event plus leaving/returning, and the abandoned route with the remains text.
  Fixtures clear `hOAMUpdate`
  after staged map loading; hardware OAM checks prove all three actors render.

## Gender appearance forms
- Female Butterfree (`gfx/pokemon/butterfreef/`) is an appearance of BUTTERFREE,
  not a species: party/PC/Dex/save data, evolution and breeding all keep the
  BUTTERFREE index; males and the Dex/Pokepic/mail portraits use the regular art.
  The female uses graphics-only rows at `BUTTERFREE_FEMALE_FORM`
  (`NUM_POKEMON + 1`) appended after the last species in PokemonPicPointers,
  Animation(Idle)Pointers, FramesPointers, BitmasksPointers (after
  `BitmasksPointersEnd`) and PokemonPalettes; asserts pin each row.
- Gender comes from the stored MON_MALE_FLAG, never DVs. `GetUnownLetter`
  (now outside bank14) sets HRAM `hMonPicFemaleForm` from the DV pointer it is
  given (party/OT/wTempMon layouts, enemy, wild backup, battle mon, both trade
  mons), so call it before any individual mon's picture load. Species-only
  pictures clear it. Palettes read the flag through `GetShinyGenderFlags`
  (bc = DVs) in `GetMonNormalOrShinyPalettePointer`; Bill's PC encodes the
  female row for its frontpic palette. Party/box menu icons keep species colors.
- `hMonPicFemaleForm` uses the last free HRAM byte in the debug ROM ($fffe ends
  the debug tester block). Bank2 now has 2 bytes of slack.
- Run `python3 tools/test_gender_forms.py` on both ROMs, `tools/test_battle_picture_tiles.py`
  (exact female animation frames) and `tools/battletest/gender_form_checks.py`
  (native battles, both sides, normal/shiny; sheet in `_artifacts/gender-forms/`).

## Pokédex
- Dex entries use a clear upper-right header, with no per-species corner art or
  asset table. Preserve that layout on both text pages, species changes, AREA/CRY
  returns, printer redisplay and new-catch registration.
- Run `make test-pokedex-ui BATTLE_TEST_PYTHON=.venv/bin/python` for both ROMs.
  Native page/area/cry/browsing/registration captures and results go under
  `_artifacts/dex-ui/`; tests use private emulator state and preserve party data.

## Personal summary (stats) screen
- Gen 2 style layout in `engine/pokemon/stats_screen.asm`, colors/attributes in
  `engine/gfx/summary_screen_pals.asm`. Rows 0-6: pokepic + header (row 0 page-colored
  strip with dex no./level/gender, nickname, species, per-page headline on rows 3-5,
  page arrows/squares on row 6). Rows 7-17: framed box with a title tab on its top edge.
- Pages: INFO (types, OT/ID, exp), STATS (status, HP bar, stats, ability), MOVES (held
  item name, moves; A = move info in the lower box), MEMO (friendship, met data, ball,
  held item + description). The egg screen uses the same frame with egg colors (page 0).
- INFO shows type bars without a TYPE/ label and no gender symbol beside the OT;
  the Pokemon's gender remains beside its level in the shared header.
  The primary type stays at screen x64/y32; the secondary is at x94/y32,
  two pixels left of the BG grid, using OBJ tiles $0a-$0d, palette 7 and
  OAM 13-16. Single types and other pages hide those four sprites.
  The 16x16 overworld item-ball sprite sits right of the INFO type bars
  (screen x126/y24),
  using the exact full thrown-ball battle palette (OBJ tiles $06-$09,
  palette 6, OAM 9-12). INFO, MEMO and battle throws/send-outs share the full
  per-ball palettes in `data/battle_anims/ball_colors.asm` through `GetBallPalette`.
  Coral's RGB5 pairs are used except the retained Master/Heavy/Safari colors;
  Park is yellow over white. Battle balls temporarily use OBJ palette 5 and
  `RestoreBallOBPal` restores its standard green after each animation. Keep
  generic move palettes unchanged. `make test-ball-palettes` verifies exact
  RGB5 colors, native throws/send-outs, cleanup and both summary pages in both
  ROMs, with previews under `_artifacts/ball-palettes/`. No ball appears beside
  the nickname;
  MEMO retains its small ball beside the ball name (OBJ $02, palette 4).
  Remaining EXP clamps to zero if current EXP exceeds the next-level threshold,
  preventing subtraction underflow from printing a non-digit tile.
- Custom BG tiles: frame $36-$3d (over the unused old page squares), tab/strip caps,
  ball disc and stat dot at $42-$46. OBJ: squares $00-$01, ball $02, cursor $03,
  Pokerus/shiny $04-$05 (OBJ pal 5, every page). Move rows are 8 + 2n at column 2;
  keep `GreenSetup` in sync. `tools/battletest/stat_exp_checks.py` reads the stat rows 8-12.
- Page changes use `StatsScreen_CommitPage` to upload palettes, both BG maps and
  OAM in one CGB double-speed VBlank. Keep palette/OAM uploads deferred during
  page preparation. INFO's primary shares BG $4b with MOVES; MOVES uses
  $4b/$4f/$53/$57, while INFO's secondary uses OBJ $0a-$0d. Restore EXP
  tiles only on INFO, whose adjacent pages do not display those tiles.
  Category graphics are cached at $5d/$79/$7d so browsing details never rewrites
  a visible icon. Preserve the shared font glyphs at $71/$73/$74 and HP end $6b.
  Move details rebuild the selected type in BG palette 6 and category in 7;
  both use the green box fill. Do not put category markers in white palette 0.
- Run `make test-summary-ui BATTLE_TEST_PYTHON=.venv/bin/python` for both-ROM
  page/move-detail transitions, PC browsing/eggs/returns and data preservation.
  `SUMMARY_RECORD=1 PC_UI_OUT=_artifacts/summary-review/video .venv/bin/python
  tools/test_summary_ui.py pokecrystal.gbc` records the same native inputs with
  game audio. Captures and per-frame transition sheets stay under that output.
  `tools/battletest/type_icon_checks.py` also checks native battle-party summary
  entry/return in both typing modes, including exact restored picture crops.

## Intentional choices: do not "fix"
- Crimson/Enhanced Gallade transfers 25 Sp. Atk into Speed (40/105);
  Gardevoir transfers 25 Attack into Speed (40/105). Both retain 518 BST.
  Original stats retain 65 in the respective attacking stat and 80 Speed.
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
Modern height/weight references for all 503 slots are in
`tools/testdata/species_dimensions.json`. Run `python3 tools/audit_species_dimensions.py
--rom pokecrystal.gbc --rom pokecrystal_debug.gbc` (also part of `make audit-static`).
Dipplin is 0.4 m / 4.4 kg; Bloodmoon Ursaluna is 2.7 m / 333.0 kg. PokeAPI
currently has incorrect dimensions for those records; the receipt links official
confirmations. Battle weights derive from Dex pounds, so keep
`tools/testdata/species_weights.json` aligned when changing them. Custom species
retain authored dimensions, and regional forms must use form-specific sources.

Past audits are in `reports/` (`full-audit-*.md`, `full-sweep-*.md`).
