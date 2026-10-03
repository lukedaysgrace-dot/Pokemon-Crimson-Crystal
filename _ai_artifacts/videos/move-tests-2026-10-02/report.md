# Sucker Punch and Incinerate battle recordings — October 2, 2026

**Update:** The issues below have been fixed, both ROMs rebuilt, and 77 battle
checks passed. See the [current fix report](fixed-report.md) and the latest
[Incinerate video with audio](incinerate-fixed.mp4). The findings below describe
the earlier versions.

Both playable and debug game ROMs have now been rebuilt from the current source.
The updated debug ROM passed 36 of 39 controlled battle tests. Sucker Punch's
basic conditional behavior works, but one priority interaction and two Incinerate
item timing checks still fail. Both moves have been recorded again after the
rebuild, using the updated ROM in the project root.

## Videos

- [Rebuilt game: Sucker Punch](sucker-punch-rebuilt-game.mp4) — ordinary attack, correct failures, and the Extreme Speed mismatch.
- [Rebuilt game: Incinerate](incinerate-rebuilt-game.mp4) — berry destruction, item/ability protection, healing timing, and knockout behavior.
- [Watch both rebuilt-game videos](watch.html).

Earlier recordings retained for reference:

- [Existing ROM: Sucker Punch](sucker-punch-existing-rom.mp4) — 1:00. Ordinary attack, incorrect hit against Splash, incorrect hit after Quick Attack, and incorrect damage to a switching replacement.
- [Rebuilt source: Sucker Punch](sucker-punch.mp4) — 1:22. Successful priority hit, correct failures against status/previous action/switching, and the Extreme Speed mismatch.
- [Rebuilt source: Incinerate](incinerate.mp4) — 1:51. Berry destruction, nonberry preservation, Sticky Hold, Substitute, healing timing, and knockout behavior.

These are actual emulator frames at normal playback speed, enlarged with nearest
neighbor scaling. The videos are silent. The right panel reads live battle memory
to show HP and items. Chapter times are in `chapters.json` and
`chapters-existing.json`. All three MP4s were fully decoded successfully after
encoding, and representative action/outcome frames were visually inspected.

## Original ROM before rebuilding

Both `pokecrystal.gbc` and `pokecrystal_debug.gbc` have identical move attribute
tables with 420 entries. Incinerate is index 421 in the current source and is
absent from those tables. Attempting to request it in the old debug ROM stalled
the battle; that run was stopped and the unsupported cases were excluded.

The old Sucker Punch entry has the generic priority-hit effect, 50 power, and
30 PP. It has no conditional Sucker Punch check. The existing debug ROM passed
8 of 15 Sucker Punch cases and failed 7: status moves in either direction,
already-acted targets, First Impression, Extreme Speed, recharge, and switching.
`results-root.json` contains the observations. The release ROM was checked
statically; runtime battles used its corresponding debug build.

The fresh build contains 421 moves and the current dedicated Sucker Punch and
Incinerate effects. Both `pokecrystal.gbc` and `pokecrystal_debug.gbc`, with their
matching `.sym` and `.map` files, have now been updated. Original outputs were
backed up under `.tmpbuild/move-videos-2026-10-02/before-rebuild/`. Save hashes
were verified unchanged. See `rebuild-verification.json`.

## Fresh-source findings

**36 of 39 cases passed: 14/15 Sucker Punch, 22/24 Incinerate.**

| Finding | Expected modern singles behavior | Observed fresh-source behavior |
| --- | --- | --- |
| Sucker Punch vs Extreme Speed | Extreme Speed has +2 priority; Sucker Punch has +1 and fails after the target acts. | Extreme Speed shares the generic +1 effect priority. Faster Mew's Sucker Punch goes first and damages Snorlax. This is an Extreme Speed priority problem rather than a failure of Sucker Punch's new conditional check. |
| Incinerate vs an HP berry | Destroy the berry before it can activate in response to the hit. | Snorlax starts at 129 HP, takes 32 damage, then Gold Berry heals 30 HP, leaving 127 HP. The itemless control finishes at 97 HP. The consumed-item record is set to Gold Berry rather than remaining empty. |
| Incinerate knockout | A successful hit destroys the eligible held berry even when it knocks out the holder. | Snorlax reaches 0 HP while still holding Gold Berry. |

Source causes:

- `data/moves/moves.asm`: Extreme Speed uses `EFFECT_PRIORITY_HIT`.
- `data/moves/effects_priorities.asm`: that shared effect gives +1 priority.
- `data/moves/effects.asm`: Incinerate calls `checkfaint` before `knockoff`.
- `engine/battle/effect_commands.asm`: `BattleCommand_CheckFaint` runs HP-berry
  healing for surviving targets and ends the move on a knockout, so both paths
  happen before Incinerate's berry-destruction command.

Passing Sucker Punch checks include physical and special attacks, status moves,
Protect, faster/slower Quick Attack, First Impression, sleep with a selected
attack, recharge, SolarBeam preparation, enemy usage, player switching, and
Substitute damage. Failure consumes one PP as expected.

Passing Incinerate checks include all ten supported berries, both attack
directions, itemless/nonberry targets, Sticky Hold and Mold Breaker, Protect,
misses, Flash Fire, intact/broken Substitute, and preventing Harvest from
recovering a berry that was successfully destroyed before activation.

## Custom statistics

The source currently specifies Sucker Punch at 80 power / 30 PP and Incinerate
at 75 power / 15 PP. Standard modern main-series values are 70 / 5 and 60 / 15,
respectively. The tests assess behavior separately from those custom statistics.
There are no held Gems in this game's item constants, so modern Incinerate's
Gem-destruction rule has no supported item to test.

## Evidence and reproduction

- `cases.yaml`: all 39 battle setups and assertions.
- `results.json`: fresh-source snapshots, final state, assertions, and ROM hash.
- `results-root.json`: existing-ROM Sucker Punch results.
- `results-rebuilt-game.json`: all 39 cases rerun after updating the root ROM.
- `rebuild-verification.json`: updated build hashes and unchanged-save checks.
- `rom-verification.json`: release/debug move table comparison and move counts.
- `screenshots/`: action frames, recorded outcomes, and failing-case screenshots.

Scripts are under `.tmpbuild/move-videos-2026-10-02/`: run `build.py`,
`create_cases.py`, `run_tests.py`, `record.py`, and `verify.py`. `--root` on the
test/record scripts selected the original debug ROM's Sucker Punch cases.
`--rebuilt` selects all tests and both recordings in the newly rebuilt root ROM.
The local Python runtime and previously available PyBoy dependencies were used.
The emulator runs a temporary cartridge-header surrogate to support this
4 MiB ROM's bank selection, as the existing project harness does.

No gameplay source was changed. Both ROMs were rebuilt; saves were untouched.
Tests use a fresh temporary game state, forced RNG, and the project's in-ROM
debug battle setup. Four missing compiled water graphics were generated in an
isolated include directory for the build. These controlled singles tests do not
cover every ability combination, trainer AI decision, or link battle.

Rules references: [Sucker Punch](https://bulbapedia.bulbagarden.net/wiki/Sucker_Punch_(move)),
[Extreme Speed](https://bulbapedia.bulbagarden.net/wiki/Extreme_Speed_(move)), and
[Incinerate](https://bulbapedia.bulbagarden.net/wiki/Incinerate_(move)).
