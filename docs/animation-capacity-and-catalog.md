# Animation capacity fixes and complete showcase

October 28, 2026. Fixes preserve the selected animations and their move effects.

| Animation | Fix |
| --- | --- |
| Rapid Spin | Finish and clear the wind objects, then load HIT alone before copying the target. WIND + HIT previously overlapped the two-row battler copy at tiles 102–104. |
| Waterfall | Space the rising impact/splash groups so all ten bubble splashes can allocate. |
| Spore | Delete the mushroom after its complete bounce sequence; all ten falling powder objects now fit. |
| Stone Edge | Clear the ten stationary rocks before creating the rising rocks. |
| Hail | Keep animating the first ten wrapping hailstones, with the original duration and sound cadence, instead of attempting twenty allocations into a full pool. |
| Close Combat | Release the seven persistent approach lines before the volley; all twenty punches and twenty impacts now render. |
| Flare Blitz | Stagger the flame pairs so all thirteen radial flames can allocate. |
| Flash Cannon | Space the impact rays so all seven white and six red sparks can allocate. |
| Gunk Shot | Finish and clear the approach lines before the poison buildup; all twenty-four bubbles now fit. |
| Iron Head | Let the impact expire before allocating the second debris group; all ten fragments now fit. |
| Overheat | Stagger each thirteen-flame wave; all sixty-five user flames now allocate, followed by the target flames and smoke. |

Release and debug ROM builds pass. The focused native regression checks both
attacking sides, counts every expected particle, requires zero failed object
allocations, and checks Rapid Spin's requested and live VRAM bytes. All 442 move
execution checks also pass. The saved MAE dependency audit was refreshed and
checks all 360 shared moves; the current classification is 161 matching,
37 imported/adapted and 162 preserved/adapted alternatives.

```sh
make -j4 all debug
python3 tools/battletest/animation_capacity_checks.py
python3 tools/battletest/runner.py --all-moves -k "Move smoke" --no-render --jobs 4
python3 tools/audit_mae_animations.py
```

The complete showcase is generated with:

```sh
python3 tools/battletest/record_animation_catalog.py
```

It inventories all **442 active moves**, all **27 negative special animations**,
and the three positive special entries (field Sweet Scent, stat up and stat down).
Reachable parameter branches add charge/strike/miss paths, weather variants,
different hits, Substitute states, capture balls, sendout variants, and every
stat color at one and two stages. The resulting **551 chapters** are ordered
alphabetically by the actual in-game display name, with related variants grouped.
Unused legacy script alternatives are excluded because they are not active
animations in the move table.

The two attacking directions play side by side at game speed with native audio
from the left view. Each chapter has a half-second lead-in and a one-second hold
after the longer animation finishes. Video is 1280×720 with nearest-neighbor
scaling. Captures use a private emulator fixture and never open player saves.
Beat Up's alternate preview substitutes Charizard to expose its sprite-change
path; it is a preview of the existing animation command, not a move-mechanics
change.

Outputs are under `_artifacts/animation-catalog/`:

- `crimson-crystal-all-battle-animations-a-z.mp4`: complete video with embedded chapters.
- `chapters.txt`: searchable timestamps.
- `plan.json`: full coverage and parameter inventory.
- `results.json`: recording ROM hash, per-side capture checks, chapter times and duration.
- `captures/<ROM hash>/`: resumable source captures with audio.

The recorder validates a complete video/audio decode and checks that the ROM
hash has not changed during recording. Capture caches are keyed by that hash.

Completed recording: **38:25.638**, 551 embedded chapters, 1,102 native
perspective captures, and audible audio in every chapter. All 442 move names
are present exactly as planned in alphabetical order. The final MP4 is
85,721,593 bytes; recording ROM hash is `f3b7c1ac7357`.
`quality-checks.json` records the final coverage, audio and chapter checks.
