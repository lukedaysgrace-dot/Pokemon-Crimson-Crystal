# Copy/fill and VBlank optimizations

## Streamed walking updates

Walking now decodes only the entering two-tile row or column directly into
`wBGMapBuffer` and `wBGMapPalBuffer`. The queue remains 40 bytes per plane;
horizontal movement uses 36 bytes. The VRAM BG map retains the rest of the
screen, with its existing wrapping and VBlank upload logic. Queue publication
happens after both data planes and the destination pointers are ready.

The approach is adapted from
[Polished Crystal's streamed map renderer](https://github.com/rangi42/polishedcrystal/blob/68ee7ee4412c53811cf1c6b98f99604f2c634327/engine/overworld/stream_map_part.asm).
Crimson reads its independently banked ROM metatile and attribute tables in
ROM0; it does not adopt the donor's WRAM table cache or extra walked-patch
queue entries. Crimson's old walking path did not have that additional patch.
The address/publishing routines moved to ROMX to keep the fixed bank within
capacity. The cartridge-header reservation remains intact.

`wTileMap`, `wAttrMap` and the surrounding buffers are not refreshed by walking.
Full-background uploads are disabled before streaming so those stale buffers
cannot overwrite the VRAM cache. Text, menus, battles, map entry and scripted
`reloadmappart` still use the existing full decoder and reanchoring paths.
New code that consumes a full RAM screen must rebuild it first.

`make test-streamed-map BATTLE_TEST_PYTHON=.venv/bin/python` runs the dedicated
routine and rendered native checks on both ROMs. Routine tests compare the
queues against the unchanged full decoder across all 38 tilesets, metatile
quarters, directions, border blocks and BG wrapping. Synthetic tables also
exercise non-page-aligned pointers and independent ROM banks `$80`/`$fe`.
Checks cover queue bounds, bank restoration and deliberately stale RAM screens.

In the isolated hardware-DIV timing check, the old full decoder takes 71 ticks;
the complete new edge/queue path takes 47/46 ticks vertically and 39 ticks
horizontally, about 34–45% less CPU time. The old control excludes its later
edge-copy step, so this is conservative. These are routine timings, not a
claim of a 34–45% whole-game frame-rate improvement. No save or RAM layout,
map data, dialogue or player movement speed changes are needed.

Results and screenshots are written under `.tmpbuild/streamed-map/`.
Both ROMs pass 7,429 routine checks and 1,527 native checks each (17,912
total). Native checks verify 287 complete screens and 213 scrolling queues
per ROM, including rain/snow, Pack and textbox restoration, scripted block
refreshes, two map connections, a door warp and the real wild-battle return.
The 34 captured screens include a contact sheet for each ROM. Across 32,232
observed native VBlank updates, OAM completed no later than scanline 151.
The full existing move/effect/ability battle sweep also passes all 3,665 cases
with no failures, errors or skips. The final rebuild produces identical ROM
bytes to those tested. See
[`reports/streamed-overworld-rendering-2026-11-03.md`](../reports/streamed-overworld-rendering-2026-11-03.md)
for the complete verification record.

## Existing copy/fill and VBlank changes

The four-byte copy/fill loops are adapted from
[Polished Crystal's home/copy.asm](https://github.com/Rangi42/polishedcrystal/blob/master/home/copy.asm).
They stay in ROM0 so banked ROM sources remain accessible without extra bank
switches. The routines and the graphics scheduler occupy unused space between
the interrupt vectors and cartridge header. They preserve Crimson's original
register and carry-flag behavior, forward-overlap semantics, and zero lengths.

On the emulator's DIV hardware clock, a 1,024-byte copy takes 113 ticks versus
160 for the previous loop (about 29% less CPU time); filling the block takes
49 versus 96 (about 49% less). These are large-block routine measurements, not
whole-game speed claims. Short copies have additional setup/flag-preservation
overhead.

The normal VBlank handler adopts the budgeted scheduling approach from
[Polished Crystal's home/vblank.asm](https://github.com/Rangi42/polishedcrystal/blob/master/home/vblank.asm),
with these adaptations for Crimson:

- Scrolling-buffer and palette uploads can complete in the same double-speed
  frame. Normal-speed execution retains exclusive scheduling.
- The PC's single/two-part general DMA transfers reserve their own frame.
- Tileset animation and early-window 1bpp/2bpp uploads precede a background
  refresh, avoiding starvation while background refresh is continuously enabled.
- A background refresh starts only before scanline 148, leaving room for the
  slower background-map modes and OAM. RNG/frame bookkeeping follows graphics.
- A stale VBlank interrupt serviced during a visible scanline defers graphics
  and leaves their queues pending for the next real VBlank. This occurs after
  some existing long interrupt-disabled screen transfers.

No save/RAM format or game data changes are required.

## Verification

`make test-engine-optimizations` runs the focused checks and native UI sessions.
The low-level tests compare memory and register/flag behavior with the old loops
executed in private test RAM, including zero lengths, page boundaries, forward
overlap and ROM banks above $7f. They exercise 360 graphics-contention cases and
2,352 tileset-animation cases per ROM, plus stale interrupts on visible lines.
VRAM contents, queue completion and PPU scanlines are checked.

The native sessions boot New Game, generate a party with the real game code,
stage map locations/weather, then use normal buttons for city/rain walking,
menus and a wild battle. Separate existing tests cover PC box switching,
summary transitions, moving Pokemon, trainer replacements, abilities, capture,
and Save/Continue. Rendering runs in both release and debug ROMs; screenshots
are saved under `.tmpbuild/engine-optimizations-ui/` and `.tmpbuild/engine-opt-pc/`.
This is focused engine integration coverage, not a full campaign playthrough.

The faster timing exposed an old test-fixture issue: button mashing could
select Abilities Off in the intro. The battle harness now chooses its rules
explicitly and versions its fixture cache. The storage-save test's old expected
version 3 was also updated to the game's already-existing version 4; the save
format itself is unchanged.

Validated on release and debug builds:

- 9,851 focused engine checks per ROM, including the contention/animation cases.
- 28 native-session checks and 13 captured screens per ROM. Across 10,583
  observed normal VBlank updates, OAM completed no later than scanline 151.
- All 3,289 battle cases passed (moves, effects, abilities and existing cases).
- PC/summary UI: 16 checks; native trainer UI: 75; wild UI: 21;
  Save/Continue: 23; storage backend: 122; save recovery: 25. All passed.
- Resource and save-layout audits, 3,259 overworld-state checks, 979
  portrait/weather checks and 1,660 QoL checks passed.
- Eight rendered/unrendered battles produced identical CPU/RAM/text results.
