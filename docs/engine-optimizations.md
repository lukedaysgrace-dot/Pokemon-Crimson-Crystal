# Copy/fill and VBlank optimizations

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
