# Polished Crystal Move Info Box + Frame Options Port (2026-08-02)

Two features ported from Polished Crystal:

1. **Battle move info box** — the in-battle move display now shows the
   Gen IV-style category icon (physical/special/status), the type name in a
   colored box (WATER on blue, FIRE on orange, etc.), base power, accuracy,
   and PP, exactly like Polished Crystal:

   ```
   ┌─────────────┐
   │ [icon][TYPE]│   icon = category badge, TYPE = white text on type color
   │  40P/100%   │   base power / accuracy (--- for status moves)
   │ PP  25/25   │
   └─────────────┘
   ```

2. **Textbox frame options** — all 20 Polished Crystal dialogue frames,
   selectable in OPTIONS (FRAME :TYPE 1-20 with a two-digit display and
   wraparound). Frames are now 8 tiles instead of 6: distinct right edge
   ("┃") and bottom edge ("━") tiles, so asymmetric frame designs render
   like they do in Polished.

## Changed files

### Battle move info box
- `engine/battle/core.asm` — `MoveInfoBox` rewritten: prints PP (bold-P row)
  then farcalls `BattleMoveInfoStats` (bank3F; battle core bank is packed
  tight, an inline version overflows it). The vanilla "Disabled!" text and
  the PHYSICAL/-style text labels are gone, matching Polished. After the
  move menu closes, `RestoreBattleMoveInfoPals` is farcalled so the player
  backpic row gets its colors back.
- `engine/battle/move_info_box.asm` (new, bank3F) — power/accuracy line,
  category icon + type colorbox tile loading (vTiles2 $79-$7e, free in
  battle since frames moved to $ba+), and attrmap/VRAM attribute fixup for
  the icon row (the Textbox call resets those attrs to the text palette
  every redraw, so they are re-pointed at PAL_BATTLE_BG_TYPE_CAT with an
  LCD-safe direct VRAM write).
- `engine/battle/hidden_power.asm` — `GetHiddenPowerDisplayStats` (display
  category/type/power for Hidden Power, honoring the Hidden Power Guy's
  chosen type with 70 power, DV formula otherwise) and
  `PrintMoveAccuracyPercent` (accuracy is stored 0-255 `percent`-scaled;
  converts back to 0-100 with rounding via Multiply/Divide).
- `engine/gfx/color.asm` — `LoadBattleCategoryAndTypePals` (writes category
  colors into PAL_BATTLE_BG_TYPE_CAT colors 1-2 and the type color into
  color 3) and `RestoreBattleMoveInfoPals`; includes the two new .pal files.
- `engine/gfx/cgb_layouts.asm` — battle layout loads the player pal into
  PAL_BATTLE_BG_TYPE_CAT (the icon row overlaps the backpic) and fills the
  (1,9)-(6,9) attrmap row; same restore added to `ReloadBattleAnimColors`.
- `constants/battle_constants.asm` — `NUM_CATEGORIES`.
- `gfx/battle/categories.png/.pal` — category badges (2 tiles 2bpp each).
- `gfx/battle/types.png/.pal` — type colorboxes (4 tiles 1bpp each),
  29 rows indexed by the raw type constant (BIRD and the unused gap rows
  use the "???" art/color so no runtime remapping is needed).

### Frames
- `gfx/frames/1-20.png` — Polished's 20 frames, converted to 16x32
  (8 tiles: ┌ ─ ┐ │ └ ┘ ┃ ━).
- `engine/gfx/load_font.asm` — `LoadFrame` uses an 8-tile stride, loads
  ┌-┘ to $ba-$bf and ┃━ to $c3-$c4; clamps out-of-range saved values.
  `_LoadStandardFont` now tail-jumps to `LoadFrame` because the font copy
  blankets tiles $c3/$c4.
- `home/text.asm` — `TextboxBorder` uses ┃ for the right edge and ━ for
  the bottom edge.
- `charmap.asm` — `<BOLD_P>` $c1, `<PCT>` $c2, `┃` $c3, `━` $c4 (free font
  slots; the glyphs for $c1/$c2 were added to `gfx/font/font.png` tiles
  65/66, taken from Polished's font).
- `constants/wram_constants.asm` — FRAME_9-FRAME_20, NUM_FRAMES = 20.
- `engine/menus/options_menu.asm` — FRAME option wraps 1-20 and prints a
  two-digit number (clearing stale digits first).
- `gfx/font.asm` — 20 frame INCBINs + `TypeIconGFX`/`CategoryIconGFX`.

### Build fixes (unrelated but needed for a clean checkout to build)
- `gfx/pokemon/magmar/back.png`, `gfx/trainers/giovanni.png` — had a 5th
  color (248,248,248 stray pixels) which makes rgbgfx fail on a fresh
  build; merged into white. Output art is unchanged.

## Notes
- Section layout shifted, so some floating data sections moved between
  banks ≥ $80 (this ROM is 4MB and already used such banks before this
  port). Emulators need MBC30-style 8-bit ROM banking, same as before.
- Tested in-emulator: category icon colors per category, type colorbox
  colors (NORMAL/FIRE verified), power/accuracy/PP values, "---" for
  status moves, frame cycling 1-20 with wraparound in OPTIONS, and the
  player backpic palette restore when the move menu closes.

## Follow-up (2026-08-02, round 2): snappiness + flash fixes

Three responsiveness fixes after playtesting feedback:

1. **Textbox/menu opens are much snappier.** Two causes of the old lag:
   - `_Get1bpp`/`_Get2bpp` (LCD-on font/frame loading) burned a
     `DelayFrame` plus a scanline-synced HBlank DMA per 16-tile chunk
     (~2 frames each; a full font load cost ~9+ frames). Replaced with
     `CopyScratchToVRAM` in `engine/gfx/dma_transfer.asm`: 4-byte bursts
     synced to the start of each hblank (free-running during early
     vblank), streaming a whole font in ~3 frames. The burst length is
     chosen for the worst-case shortest hblank plus the following mode 2,
     so no write can slide into mode 3 and get dropped on real hardware
     or accurate emulators (an early draft used unsynced 8-byte bursts,
     which chopped up glyphs and frame borders in SameBoy).
   - `OpenAndCloseMenu_HDMATransferTileMapAndAttrMap`: an experiment
     replaced its padded scanline-synced HDMA transfers with
     `CGBOnly_CopyTilemapAtOnce`, but that helper assumes a $xx00-aligned
     BG map anchor while this path also runs against re-anchored/scrolled
     maps (starter pokepic, phone-number handouts, menu opens) - it
     scrambled the screen on mGBA and caused a visible blink on menu
     open. Reverted to the original padded transfer.
   - Also dropped a redundant frame load in `LoadFonts_NoOAMUpdate`
     (`_LoadStandardFont` already ends by reloading the frame).
   - Measured: A-press to first letter of an overworld textbox went from
     38 to 28 frames; frame switching in OPTIONS is instant.

2. **No more palette flash when picking an attack.** The move info box's
   icon palette used to be restored while the box was still on screen.
   Now, after move selection: palette buffers are refilled
   (`RestoreBattleMoveInfoPals` no longer uploads by itself), the attrmap
   rows the box dirtied are repaired to battle-scene values, the whole
   tilemap+attrmap is pushed in one shot (`CGBOnly_CopyTilemapAtOnce`), and
   only then is the palette upload flagged. The box now cuts straight to
   the battle scene with no recolored frames (verified frame-by-frame).
   Two `jr`s near the fight-menu code became `jp`s for range.

3. **Fades now match Polished's total duration** — see
   SMOOTH_FADES_PORT.md (step counts halved; menu/warp fades are 10 frames
   total, evenly paced).
