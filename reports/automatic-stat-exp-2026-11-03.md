# Automatic battle Stat EXP recalculation

Implemented and verified on release and debug ROMs, 2026-11-03.

## Behavior

Battle Stat EXP recipients now refresh their stored party stats at `ExitBattle`,
before evolution and cleanup. The party personal stats screen and subsequent
battles therefore use the updated stats without a level-up or PC deposit.

The original award path already adds all five Stat EXP words before checking
the Hard Mode cap or level 100. No award eligibility, amounts, division, Pokérus
doubling, saturation, regular EXP, level restrictions or stat formulas changed.

Awards mark a party-slot mask in a formerly unused battle-only byte following
`wWildMon`. Level-up stat calculations clear that slot; later awards, including
the second EXP Share pass, mark it again. Only pending slots are refreshed at
battle exit. The save layout and ROM0 usage are unchanged (94 release / 88 debug
bytes free).

The refresh uses normal species base data and `UpdateStatsAfterItem` /
`CalcMonStats`, with the party's level, DVs and five Stat EXP words. Battle
stages, status penalties, Transform and Aegislash Blade stats are not copied
into party stats. Both Original and Enhanced stat modes are supported.

Current HP preserves damage taken: a change from 40/50 to 41/51 retains ten
damage. Fainted recipients remain at zero, even if they earned Stat EXP earlier
in the battle. Refreshes run on wins, losses and draws; ineligible fainted
Pokémon do not receive new awards.

## Files changed

| File | Change |
| --- | --- |
| `engine/battle/stat_exp.asm` | Pending flag helpers and deferred party recalculation with HP handling. |
| `engine/battle/core.asm` | Reset mask, mark awards, clear level-up refreshes, invoke refresh at exit. |
| `main.asm` | Banked section for the new routine. |
| `wram.asm` | Name the existing unused battle byte; no structure size changes. |
| `tools/battletest/stat_exp_checks.py` | Native routine, full battle, personal stats screen and subsequent-entry checks on both ROMs. |
| `Makefile` | Add `test-stat-exp`. |
| `AGENTS.md` | Document behavior, RAM ownership and test command. |
| This report | Record implementation and verification. |

## Verification

- `make -j8 pokecrystal.gbc pokecrystal_debug.gbc` — passed with RGBDS 0.5.2.
- `make test-stat-exp BATTLE_TEST_PYTHON=.venv/bin/python` — passed. The final
  expanded script also opens the personal stats screen and checks its displayed
  numbers: **452 checks per ROM, 904 total, zero failures**.
- `make audit-static` — passed.
- Existing `cap_fast_ui_checks.py` — **172 checks per ROM**, zero failures;
  verifies every Hard Mode cap tier, Normal Mode and saved preferences.
- Existing `96-illusion.yaml` and `97-roster-stance-change.yaml` — **65 passed**,
  zero failures/errors.
- `git diff --check` — passed.

The new suite covers every level 1–100; ordinary gains without a level-up;
Pokémon at and above the Hard Mode cap; level 100; multiple participants and
switch participation; repeated KOs; EXP Share nonparticipants, fainted holders,
level-100 holders and a participant that levels in the first award pass;
ordinary level-ups with no redundant exit refresh; later awards after a
level-up; reaching the Hard Mode cap; fainting before and after an award;
full/one/zero HP; HP increases with unchanged damage; saturation at $ffff;
Pokérus; both stat modes; battle modifiers; and Link/Battle Tower exclusions.

Full native wild battles at levels 50, 10 (Hard cap) and 100 use normal button
input through the KO and exit. The checks then open the personal summary,
verify all five displayed non-HP stats against the refreshed party stats, and
enter another battle to verify the new stats load correctly. All fixtures use
private emulator state and never access player saves.

Machine-readable results and screenshots:

- `_artifacts/stat-exp/pokecrystal/results.json`
- `_artifacts/stat-exp/pokecrystal_debug/results.json`
- `_artifacts/stat-exp/{pokecrystal,pokecrystal_debug}/personal-stats-level-{10,50,100}.png`
- `_artifacts/stat-exp/build.log` and `_artifacts/stat-exp/tests.log`
