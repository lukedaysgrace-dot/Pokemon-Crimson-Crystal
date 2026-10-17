# Mae Pokeorange move animation comparison

Compared Crimson Crystal with [PiaCarrot/mae-pokeorange at 83db98a](https://github.com/PiaCarrot/mae-pokeorange/tree/83db98aec1a0ccf50e78f8b38e37b8427ba310bb) on October 17, 2026.

All **345 shared moves** have a recorded decision: **14 updated**, **142 matching scripts**, and **189 preserved implementations**. The remaining 76 Crimson Crystal moves are absent from this reference. `NO_MOVE` is excluded.

The comparison follows animation pointers by move name, expands reachable helpers and fallthrough blocks, and accounts for each engine's different object names, BG-effect IDs, graphics coordinates, palette slots and script banks. Matching scripts describe timing and animation commands; they do not assert pixel identity between engines with different shared graphics. Existing upgraded graphics and engine fixes remain in use.

## Changed moves

| Move | Change |
| --- | --- |
| Bubble | Pokeorange's custom bubble colors. |
| Egg Bomb | Fire-colored explosion flashes. |
| Spike Cannon | Larger gray spikes, four impacts, reference sounds and timing. |
| Barrage | Fire-colored explosion on impact. |
| Flame Wheel | Reference fire palette. |
| Leaf Blade | Three green slashes, scattered leaves and impact shakes. |
| Shadow Punch | Darkened scene, advancing battler and traveling punch. |
| Dragon Dance | Restore the missing second phase with rising focus lines. |
| Slack Off | Reference withdrawal/recovery motion and healing sparkles. |
| Volt Tackle | Electric charge, speed lines, traveling sparks and thunder impact. |
| Wish | Restore the cosmic starfield, colors, movement and opponent HUD clearing. |
| Selfdestruct | Reference fire colors in both explosion paths. |
| Powder Snow | Reference ice colors for the final ice burst. |
| Present | Reference fire colors for the damaging gift explosion. |

## Preserved improvements

The detailed decision for every move is in [the comparison manifest](../tools/battletest/mae_animation_manifest.json). Preserved implementations include the existing Polished Crystal ports, the redesigned poison Spider Web, custom Wood Hammer, rising-globe Moonlight, actual party members in Beat Up, enhanced Draco Meteor, Nasty Plot and Brick Break, and Weather Ball's corrected travel and removed transition flash. Pokeorange's empty placeholders do not replace completed animations.

Required engine adaptations also stay: safe graphics loading, correct object indices, correct palette slots, multi-hit timing, and restoration of battler sprites and palettes. Twineedle's needle already uses gray; Icicle Spear already colors the actual blue palette slot used by its objects. Renaming these slots would add no visible improvement.

## Recording and verification

The recording is generated from the built debug ROM, with the original ROM saved before editing. Every changed move appears from both attacking sides, with **before on the left, updated on the right**, at game speed with audio from the updated animation. These are native animation previews in a private test battle; they do not load or change the player's save.

The video and per-move contact sheets are generated under `_artifacts/mae-animation-comparison/`. `results.json` records ROM hashes, frame counts, checks and video chapter timestamps.

Completed recording: `all-changed-moves-before-after.mp4` (2:03, 28 chapters, both sides of all 14 changed moves). `chapters.txt` provides timestamps. Full video/audio decoding passed, every chapter has audible game sound, and the recording's ROM hash matches the final debug ROM.

Completed validation: release and debug builds passed; all 421 move execution cases passed; 32 native animation/alternate-path checks passed; all 56 stat-animation scenarios passed; eight paired rendering-mode battles and alternate-ROM fixture checks passed. The saved audit verifies all 345 mappings, script dependencies and supporting resource hashes.

Reproduce the source audit with a local checkout of the pinned reference:

```sh
.venv/bin/python tools/audit_mae_animations.py --upstream PATH_TO_MAE_POKEORANGE
.venv/bin/python tools/audit_mae_animations.py
```

Run native rendering and cleanup checks, or make a comparison recording with an original ROM and its matching symbol file:

```sh
make -j4 all debug
.venv/bin/python tools/battletest/mae_animation_checks.py
.venv/bin/python tools/battletest/mae_animation_checks.py --record --before-rom PATH_TO_ORIGINAL_DEBUG_ROM
.venv/bin/python tools/battletest/runner.py --all-moves -k "Move smoke" --no-render --jobs 6
```

The checks exercise both sides, palette restoration, screen-offset cleanup, LCD-effect cleanup, the alternate Selfdestruct path and Present's healing path. The full move sweep separately exercises native move execution.

Two existing banks had no room for the additions. Leaf Blade and Shadow Punch now use the existing fifth script bank and its local helpers. The object tables and their existing far-called readers now share a separate floating bank, leaving the frame/OAM data together. Object IDs and existing function IDs remain stable.
