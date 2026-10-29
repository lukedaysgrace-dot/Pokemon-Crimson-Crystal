# Gigaton Hammer video reference

Historical reference: the subsequent creative-animation request replaces
this sequence with the large steel-hammer slam in `animations8.asm`.
The current checks and showcase are in `creative_animation_checks.py`.

The animation follows the user-supplied private recording
`SameBoy_v1.0.1_2026-03-05_09-12-55.mov`.
The recording is not a repository asset.

The reference has two gray diagonal shine bands over the darkened user,
a pause, a small pale impact star followed by a larger lower star, two short
inverted flashes, and six rocks bursting outward from the target. It does
not show rocks falling from above, a fist, or the previous cluster of kick
and punch sprites.

Audio comparison against the ROM's isolated sound effects identifies
`SFX_SHINE`, followed by `SFX_EGG_BOMB` twice. The second explosion coincides
with the rock burst. Comparing complete overlapping impact sequences gives
the repeated explosion a better spectral match than the old rumble or kick
combinations. The normal damage sound after the animation remains the
battle engine's responsibility.

| Cue | Reference audio time | Native animation frame |
| --- | ---: | ---: |
| Shine | approximately 5.325 s | 44 |
| First explosion | approximately 8.075 s | 208 |
| Rock-burst explosion | approximately 8.310 s | 222 |

The native frame rate is `262144 / 4389` Hz. Relative to the shine, both
explosion cues align within one native frame. The MOV uses variable video
frame timestamps; its reported average frame rate must not be used as a
constant rate when measuring the animation. Emulator color conversion and
the recording's compression can change displayed RGB values.

Run the native regression checks after building:

```sh
make -j4 all debug
python3 tools/battletest/gigaton_hammer_checks.py --record
python3 tools/battletest/runner.py --all-moves -k GIGA_HAMMER
```

The checks execute the animation on both battle sides, validate sound IDs,
panning and timing, validate sprite graphics and the rock burst lifetime,
check both dark flashes, and require full screen, palette, tilemap and LCD
effect restoration. `--record` writes previews with emulated game audio and
`checks.json` under `_artifacts/gigaton-hammer/`. Private emulator fixtures
are used; player saves are not opened.
