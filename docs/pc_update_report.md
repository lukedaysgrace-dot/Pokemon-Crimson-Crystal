# Polished-style PC storage — delivery notes

Branch `polished-pc` on top of `6e539d60` (your `main`). Everything builds with
`make` (RGBDS 0.5.2) and `make pokecrystal_debug.gbc`.

## What you get

* **500 slots (25 boxes × 20)** in a 64 KiB save (`rgbfix -r 5`), copy-on-write
  PokeDB backend exactly as in Polished: moving Pokémon between boxes never copies
  data, releases are instant, and a save snapshots the box layout so an interrupted
  save can't lose a box.
* **Graphical Bill's PC**: 4×5 box grid + party column, mini icons with per-row
  colours, frontpic/nickname/level/gender/shiny/Pokérus/held item panel, three
  cursor modes (SELECT: MENU → SWAP → ITEM), quick-move animation, box themes with
  live preview, rename, change box, release / release all, summary with up/down
  scrolling through the box, full item handling (give from bag, move between
  Pokémon, bag, Mail take/read/compose — Mail can't be stored, same as Polished).
* **Gameplay callers** rewired (catching, gifts, Bug Contest, Day-Care/Odd Egg,
  Lucky Number, search, `VAR_BOXSPACE`, printer PC path removed, mobile SRAM
  quarantined).

## Things to know

1. **Old saves are not compatible** (you said that's fine). The save-format byte
   makes the game treat an old `.sav` as "no save". Delete or rename the old
   `pokecrystal.sav` next to the ROM before starting — its size also changed
   (32 KiB → 64 KiB) and some emulators refuse a mismatched file.
2. Two small engine changes outside the PC that you should know about:
   * `farcall` now returns `a` intact (vanilla returned `a = c`). A new macro
     `farcall_a` passes `a` *into* a far routine (`macros/rst.asm`, `home/farcall.asm`,
     `hFarCallReturnA`).
   * The VBlank DMA can run a second transfer (`hDMATransfer2`, `home/video.asm`)
     so the PC pushes tile + attribute maps in one frame without disabling interrupts.
   * `"Overworld Weather"` is no longer pinned to bank $23 in `pokecrystal.link`
     (it didn't fit next to the sprite-animation additions); it floats like the new
     `"PC Storage"` / `"PC UI"` sections.
3. **HBlank palette effect**: the per-row icon colours come from the STAT interrupt.
   Unlike Polished (HBlank interrupt every line), the PC switches `rSTAT` to the
   LYC interrupt and the handler waits for HBlank itself, so the palette writes
   start at the top of the HBlank window instead of 40-50 cycles into it. That
   is the fix for the blink / small white box above the Pokémon you reported:
   on lines where the cursor, a carried mini and the mode icon overlapped, the
   old timing pushed the last palette writes into mode 3, where the CGB ignores
   them, so a row of icons or the shiny/Pokérus cells showed the wrong colours
   for a frame (PyBoy doesn't model that, which is why it never showed up
   here). The idle cursor also uses a 4-sprite frameset now instead of carrying
   8 blank mini/shadow sprites around. If anything still flickers, it's
   `BillsPC_LCDCode` in `engine/pc/bills_pc_ui.asm`.
4. Not ported (Polished-specific): Mewtwo form refresh on item change, roaming
   beast respawn when releasing your own beast, VWF item names (Crimson prints
   item names with the normal font; the icon of the item sits in column 7).
5. ROM: 146 banks used (4 MiB); ROM0 slack $136 bytes; last bank ($92) has
   $33c0 bytes free. `"PC UI"` is $2144 bytes, `"PC Storage"` $0b0a bytes.

## Files

New: `engine/pc/storage.asm`, `engine/pc/storage_codec.asm`,
`engine/pc/bills_pc_ui.asm`, `constants/pc_constants.asm`, `data/pc/*`,
`gfx/pc/{pc,cursor,modes,bags,held_item_icons,shiny}.png` + `.pal` files,
`docs/pc_storage_design.md` (design + API reference), `tools/pc_harness.py`,
`tools/pc_ui_harness.py`, `tools/test_pc_*.py`, `tools/blink_probe.py`.

Removed: `engine/pokemon/bills_pc.asm`, `engine/pokemon/bills_pc_top.asm`,
`engine/pokemon/move_mon_wo_mail.asm`, `gfx/pc/orange.pal` (moved to
`_to_delete/pc_storage_removed/` in your folder rather than deleted).

Modified: `Makefile`, `constants.asm`, `constants/{hardware,pokemon_data,sprite_anim}_constants.asm`,
`data/predef_pointers.asm`, `data/sprite_anims/{framesets,oam,sequences}.asm`,
`engine/16/table_functions.asm`, `engine/battle/{check_battle_scene,core}.asm`,
`engine/events/{lucky_number,pokecenter_pc}.asm`, `engine/gfx/{cgb_layouts,load_pics,sprite_anims}.asm`,
`engine/items/item_effects.asm`, `engine/link/mystery_gift.asm`,
`engine/menus/{intro_menu,save}.asm`, `engine/overworld/variables.asm`,
`engine/pokemon/{caught_data,mon_stats,move_mon,search,stats_screen,tempmon}.asm`,
`engine/printer/printer.asm`, `engine/rtc/rtc.asm`, `gfx/pc/pc.png`,
`home/{copy,farcall,lcd,video}.asm`, `hram.asm`, `macros/{rst,wram}.asm`, `main.asm`,
`mobile/mobile_{12_2,40,5f}.asm`, `pokecrystal.link`, `sram.asm`, `wram.asm`,
`tools/audit_save.py`, `pokecrystal.cheats` (regenerated).

## Tests run (all in PyBoy, patched for 8 SRAM banks / 8-bit ROM banks)

* `tools/test_pc_storage.py` — 122 checks: record round trip (16-bit species/moves,
  PP Ups, eggs), checksum → Bad Egg, copy-on-write across saves, party↔box swaps
  (last healthy, Mail), box↔box, overflow to the next box, database exhaustion
  after a full 500-slot save, load discards unsaved edits, names/themes, 150-step
  random soak.
* `tools/test_pc_save.py` — 25 checks: version gate, interrupted-backup repair,
  corrupt main + valid backup, new game not clobbering the old snapshot.
* `tools/audit_save.py` — 185 layout/recovery checks on the linked ROM.
* `tools/test_pc_ui.py` / `ui2` / `ui3` / `ui4` — 70 checks with screenshots:
  open, cursor and box switching, menu, summary (+scrolling), swap mode pick/place,
  party deposit, item mode (take to bag, give from pack, Mail compose/take,
  "can't place Mail in storage"), release, release all, rename, theme preview and
  set, change box, exit prompt, and the "Save the game to do this?" flow when the
  database is full.

Not tested: walking to a Pokémon Center and opening the PC from the overworld
script (no save state available here) — `_BillsPC` keeps the vanilla entry/exit
contract (`LoadStandardMenuHeader` … `ReturnToMapFromSubmenu`/`CloseSubmenu`), so
that is the first thing to try in-game.
