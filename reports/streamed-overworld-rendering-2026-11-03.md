# Streamed overworld rendering

Implemented November 3, 2026. Both release and debug ROMs build with RGBDS
0.5.2. Game data, dialogue, movement speed, WRAM/SRAM layouts and save format
are unchanged.

## Implementation

`engine/overworld/player_step.asm` now calls the banked scrolling entry points
without first rebuilding the full RAM screen. `home/map_stream.asm` decodes
the entering two-tile row/column straight into the existing tile and attribute
queues. The rendering approach comes from
[Polished Crystal at 68ee7ee4412c53811cf1c6b98f99604f2c634327](https://github.com/rangi42/polishedcrystal/blob/68ee7ee4412c53811cf1c6b98f99604f2c634327/engine/overworld/stream_map_part.asm).

Crimson-specific adaptations:

- Read the independently banked ROM metatile/attribute tables from ROM0,
  including arbitrary table alignment and banks above `$7f`.
- Retain the current 40-byte queues: 40 bytes per plane vertically, 36
  horizontally. Crimson did not have the donor's extra walked-patch update,
  so no additional queue entries or RAM allocations are needed.
- Move pointer generation and queue publication into the banked
  `engine/overworld/map_scroll.asm`; share the quarter reader to fit ROM0.
- Disable full-screen uploads before walking writes, and publish the edge
  only when both data planes and all destination pointers are ready.
- Preserve the existing full `LoadMapPart` path for map entry, reanchoring,
  text, menus, battles and scripted `reloadmappart` updates.

The VRAM BG map is now the persistent walking cache. The RAM tilemap,
attribute map and surrounding buffers can be stale while walking. Any new
full-screen consumer must rebuild before using them. This contract is
documented in AGENTS.md and `docs/engine-optimizations.md`.

The cartridge-header reservation remains intact. ROM0 has 94 bytes free in
release and 88 in debug, fragmented into gaps; largest gaps are 37 and 16
bytes respectively.

## Performance measurement

The routine test resets and samples the emulator's hardware DIV clock while
executing the actual compiled routines with interrupts disabled. Both ROMs
produce the same measurements:

| Direction | Existing full decoder | New edge + queue path | CPU-time reduction |
| --- | ---: | ---: | ---: |
| Down | 71 ticks | 47 ticks | 33.8% |
| Up | 71 ticks | 46 ticks | 35.2% |
| Left | 71 ticks | 39 ticks | 45.1% |
| Right | 71 ticks | 39 ticks | 45.1% |

The control excludes the old path's subsequent edge-copy step, making the
comparison conservative. These are isolated routine timings, not a claim of
that percentage improvement in whole-game FPS.

## Verification

`make test-streamed-map BATTLE_TEST_PYTHON=.venv/bin/python` passes on both ROMs.

| Coverage | Result |
| --- | --- |
| Compiled renderer equivalence | 7,429 checks per ROM; 928 configurations, all 38 linked tilesets |
| Boundary and bank cases | All four directions and metatile quarters; border substitution; independent `$80`/`$fe` ROM tables; unaligned pointers; narrow/wide map strides; horizontal/vertical BG wrap |
| Buffer contracts | Exact queue data/pointers, bounded writes, deliberately stale RAM screens, unchanged surrounding buffers, ROM/WRAM/VRAM-bank restoration |
| Native rendered sessions | 1,527 checks per ROM, 287 complete-screen comparisons and 213 native queue publications per ROM |
| Gameplay scenarios | Goldenrod walking/Pack, Azalea rain, Silver Cave snow, text open/close, scripted block replacement and refresh, east/west connections, directional door warp, real wild-battle script and normal reload, subsequent walking |
| Visual inspection | 17 captured screens per ROM; release contact sheet inspected for maps, weather, connection, text/menu and battle returns |
| VBlank observation | 32,232 normal updates across the dedicated native sessions; OAM completed no later than scanline 151 |
| Existing engine regression target | Pass; 10,107 low-level checks per ROM, 360 contention cases and 2,480 tileset-animation cases per ROM |
| Existing native engine smoke sessions | Pass on both ROMs; 28 checks and 13 captures per ROM |
| Existing PC/trainer/wild/save UI | 16 PC checks, 75 trainer checks, 21 wild checks and 23 save/reboot checks; zero failures |
| Overworld-state tests | 3,278 checks per ROM; zero failures |
| Portrait/weather sprite tests | 979 checks per ROM; zero failures |
| Static audits | `make audit-static` passed, including game data, moves, abilities, trainers, save layout, resources, icons and map/trainer sprites |
| Full battle regression sweep | 3,665 passed; zero failures, errors or skips, with all moves/effects/abilities selected and eight isolated workers |
| Final rebuild | Both ROMs rebuilt successfully; SHA-256 hashes exactly match the ROM bytes used by the completed renderer tests |

The new routine tests use the unchanged compiled full-map decoder as their
control. Native checks independently calculate expected visible tiles and
attributes from map blocks and the ROM tables, compare actual VRAM, and
observe queue publication. Screenshots supplement those checks.

Fixtures stage initial party/location/weather in private emulator memory.
Buttons drive walking, connections, doors, menus and battle choices. The wild
battle is explicitly queued through the game's actual script, including its
normal post-battle reload. The test does not stage a new map to hide that
return. Navigation disables unrelated random encounters. Text/refresh cases
invoke the normal compiled routines. No game routines are patched in the
native tests, and no player save or emulator sidecar is read or altered.

The standard harness uses its private MBC5 header surrogate for this MBC30-sized
ROM. This is emulator integration coverage, not a physical-cartridge test or
a complete campaign playthrough.

Machine-readable routine/native results, screenshots, contact sheets and
test logs are under `.tmpbuild/streamed-map/`. The full battle-regression
result is recorded there separately in `battle-parallel.log`.
The compact [verification receipt](streamed-overworld-rendering-2026-11-03.json)
records the renderer results and final ROM hashes.

Reproduce the battle sweep with
`.venv/bin/python tools/battletest/runner.py --all-moves --all-effects --all-abilities --jobs 8`.
