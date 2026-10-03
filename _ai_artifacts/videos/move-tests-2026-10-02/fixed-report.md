# Extreme Speed and Incinerate fixes

Both playable and debug ROMs have been rebuilt and updated in the project root.
Save hashes were verified unchanged. The preceding builds are retained under
`.tmpbuild/move-videos-2026-10-02/before-fixes/`.

## Changes

- Extreme Speed now has +2 priority. Quick Attack and Sucker Punch retain +1.
  The shared priority helper is used by battle turn ordering and AI checks.
- Incinerate destroys a hit target's eligible berry before HP-berry healing and
  before knockout handling can end the move. It clears both the active item and
  party item, and does not record the berry as consumed for Harvest/Cud Chew.
- Sticky Hold continues to protect surviving holders. A knocked-out holder
  cannot protect its berry. Mold Breaker and Substitute behavior are retained.
- Incinerate now uses a dedicated animation: the same Flamethrower flame trail,
  cut to about half its duration, followed by Scald's final steam, target palette
  effect, and sizzle sound. The flame objects are cleared before steam begins.
  Standard Flamethrower and Scald animations are unchanged.

The existing custom power and PP values are retained.

## Validation

**77 automated battle checks passed:** 51 targeted regressions and 26 existing
move-effect regressions. The 51 targeted cases were rerun on the updated root
debug ROM. Release and debug move attribute tables match.

The regression file is `tools/battletest/tests/65-priority-incinerate.yaml`.
It covers both sides, priority interactions with Sucker Punch/Quick Attack/Fake
Out/Protect, all supported berries, healing thresholds, knockouts, Sticky Hold,
Mold Breaker, Infiltrator, intact/broken Substitute, immunity, misses, Harvest,
Klutz, and party item synchronization.

The flame timing was measured in actual emulator frames: the full Flamethrower
stream spans approximately 157 frames, while Incinerate spans approximately
78–79 frames. Steam starts after the flame-clear command. Player and enemy
animations were visually inspected. The ending uses Scald's actual steam objects,
background effect, and `SFX_POISON_STING` sizzle.

The new videos include actual emulated game audio. Both audio captures contain
nonzero sound, and the finished MP4s were decoded successfully after encoding.

## Videos

- [Incinerate after fixes](incinerate-fixed.mp4) — 1:21, with Flamethrower as a
  duration reference, both attack directions, berry healing timing, and a KO.
- [Sucker Punch and Extreme Speed after fixes](sucker-punch-fixed.mp4) — 0:25.
- [Video player](watch.html).

Evidence: `results.json`, `results-rebuilt-game.json`, `rebuild-verification.json`,
`rom-verification-rebuilt-game.json`, `chapters-fixed.json`, and `screenshots/`.

Modern item-rule reference: Pokémon Showdown's
[Incinerate implementation](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts)
and [Sticky Hold implementation](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts).

These are controlled singles battles; the checks do not cover every possible
ability combination or link battle.
