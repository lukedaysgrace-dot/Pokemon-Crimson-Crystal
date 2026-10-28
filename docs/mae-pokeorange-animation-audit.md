# Mae Pokeorange move animation comparison

## Sour Apple update — October 27, 2026

The current comparison uses the requested [sour-apple branch at 41a4463](https://github.com/PiaCarrot/mae-pokeorange/tree/41a44630a3f712f3f45a157874361234e13e68ca). All **360 shared moves** are covered: **166 matching**, **157 preserved**, and **37 updated** across the original import and this update. The remaining **79 moves** are absent from Sour Apple and are listed in the manifest. Move names, rather than numeric move positions, determine the mapping.

The initial pass synchronized **26 animation scripts** with the requested branch; the later Trick Room sound restoration leaves **25 source upgrades from that pass**. In the initial recording, **24 moves have a visible change on at least one attacking side**. Whirlwind and Twister were already visually equivalent; their explicit source palette assignments do not change the recorded output. Rock Polish changes on the opponent side.

| Group | Moves |
| --- | --- |
| Wind and movement | Gust, Whirlwind, Twister, Tackle, Brave Bird, Volt Tackle, Bug Buzz |
| Bites and poison | Fire Fang, Ice Fang, Thunder Fang, Poison Fang, Poison Jab, Cross Poison |
| Ghost and psychic | Shadow Ball, Shadow Sneak, Psycho Cut, Trick Room |
| Field and setup | Leaf Storm, Rock Polish, Head Smash, Stealth Rock, Defog, Wish |
| Later move ports | Vacuum Wave, Discharge, Lava Plume |

Existing Polished Crystal ports were replaced where Sour Apple's charge, directional sprites, impact or cleanup improves the result. Existing custom Wood Hammer, blue Sacred Fire, party-member Beat Up, rising-moon Moonlight, metallic Iron Head, Coral Cosmic Power and Ominous Wind, and corrected Weather Ball remain. Blaze Kick retains its existing six-frame flame spacing because the source's one-frame burst drops flames from the ten-object pool.

Poison Fang's teeth use a dedicated purple palette during the bite, as requested. The impact retains its original colors, the poison-splash phase and timing are unchanged, and the other biting moves keep their existing teeth colors.

Scripts and their reachable helpers live together in `animations7.asm`. Required objects, framesets, OAM layouts, graphics and the Discharge callback use appended IDs. Source vortex/swirl tiles have dedicated objects and graphics, avoiding changes to other animations. Shadow Sneak uses the exact three shadow tiles extracted from Angels, packed at offset zero so HIT graphics and copied battler tiles stay intact. Wish's hover callback now handles explicit state-3 deletion while keeping the starfield alive. Head Smash clears the first debris group before the next impact; Lava Plume spaces spawns three frames apart so its smoke and embers all render, with short flame crackles replacing the source's lingering sound tail.

Following the user's clarification, **overworld Surf is restored to its original speed: 1 pixel per frame, 16 frames per tile** for both riders. Surf's battle animation is unchanged by this restoration. Trick Room also uses its original repeated `SFX_UNKNOWN_66` sound sequence again, with its original visual effects and timing. It is now a preserved implementation rather than one of the Sour Apple upgrades.

Validation and comparison-video artifacts are under `_artifacts/sour-apple-animation-update/`. The video shows the pre-update ROM on the left and the final ROM on the right, both attacking sides, at game speed with updated game audio. `chapters.txt` provides move timestamps and `results.json` records ROM hashes and capture checks. All captures use private test battles without loading the player's save.

The initial 26-move recording passed: release/debug builds, **442 battle cases**, **52 Sour Apple animation captures**, **36 later-move regression captures**, **72 Surf checks** across both ROMs, and all **360 saved source mappings/dependency hashes**. The **3:36 video** has **52 chapters**; full video/audio decoding, audible chapter audio and its recording-ROM hash check passed. The recorder retains the original ROM's Poison Fang palette-leak evidence while requiring clean restoration in every updated capture.

The subsequent purple-teeth revision is shown in `_artifacts/poison-fang-and-surf/poison-fang-and-surf.mp4`: Poison Fang from both attacking sides, Surf's existing battle animation, and native before/after Surf travel with identical held input. This revision passed both ROM builds, Poison Fang graphics/cleanup checks from both sides, 72 Surf checks, the 360-move saved audit, and full clip decoding. The earlier full reel remains a recording of the preceding teeth-color revision.

Both recordings predate the final clarification restoring overworld Surf speed and Trick Room's original sound. The current ROM preserves the purple teeth and Surf battle animation; the updated Surf checks require the original 16-frame overworld step.

Reproduce the current checks with the project's Python/emulator environment:

```sh
make -j4 all debug
python3 tools/audit_mae_animations.py --upstream .tmpbuild/mae-sour-apple
python3 tools/audit_mae_animations.py
python3 tools/battletest/sour_apple_animation_checks.py
python3 tools/test_surf_speed.py pokecrystal.gbc
python3 tools/test_surf_speed.py pokecrystal_debug.gbc
python3 tools/battletest/october_animation_checks.py
python3 tools/battletest/runner.py --all-moves -k "Move smoke" --no-render --jobs 4
python3 tools/battletest/record_sour_apple_animations.py --before-rom _artifacts/sour-apple-animation-update/before_debug.gbc
python3 tools/battletest/record_poison_fang_and_surf.py --before-rom _artifacts/sour-apple-animation-update/before_debug.gbc
```

## Original import — October 17, 2026

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
