# Move and ability audit, November 10, 2026

Status: complete. Both ROM builds, static audits and all final battle runs passed.

This audit starts at `1747dbc561e0626063f069b4cea43892a618bc60`. Its scope is
all 444 implemented move records, all 174 ability entries (including the
no-ability control), and their battle interactions. Project-specific rules,
including 70-power stat-dependent Hidden Power, Gen 6 Gale Wings, Gen 1 Mimic,
custom Flash Fire, and the existing save format are preserved.

## Latest commit review

The three changes in the latest commit are appropriate for the authored rules:
Flying Hidden Power must receive Gale Wings priority; Conversion2 and its AI
must use the owner's Hidden Power type; Forewarn must rank this fixed-power
move at 70. The commit's 12 native regression cases passed. Broader tests found
additional gaps outside those cases.

## Confirmed corrections

### Historical move type

Conversion2 still read Weather Ball and ability-converted Normal attacks as
Normal. Native battles reproduced failures with weather and Galvanize,
Pixilate and Refrigerate on both battler sides; some other seeded cases passed
by coincidence because a randomly selected Normal resistance also resisted the
real type.

The resolved type is now recorded alongside the last-used move ID in private
WRAM2. Conversion2 and its smart AI read that history. This also preserves the
type when weather or abilities subsequently change, or AI prediction rewrites
a move struct. The bytes are not part of saved Pokémon or SRAM.

### Called-move priority and Prankster origin

Four native reproductions failed before correction: Prankster Sleep Talk's
Tackle bypassed Queenly Majesty and Dark immunity, while Gale Wings Sleep
Talk's Peck and Triage Sleep Talk's Mega Drain were incorrectly blocked.

Selected move and effective ability context now survive calls to another move.
Incoming Pokémon clear old context before entry abilities, and switch-time
Pursuit and Giga Hammer reselection refresh their context. Future Sight's
delayed hit is independent of the selected action on its landing turn.

### Invalid entry-animation frame references

The required resource audit found Hisuian Arcanine's script selecting frames
7–10 despite its supplied animation having only six non-base frame pointers.
Those four invalid references were removed; supplied valid art is preserved.
The build also regenerated Hippowdon's tracked animation tables from its
existing supplied art; the tracked tables at the starting commit were empty.

### Status-targeting paths without accuracy checks

Native Prankster battles reproduced 19 failures in a 30-case direct-move
matrix. Mimic, Mirror Move and Psych Up omitted the pre-execution targeting
guard, despite targeting the opposing Pokémon. Boosted Perish Song also
missed the priority-shield check; its global targeting must still remain
independent of Dark's Prankster immunity.

An additional 10-case Sleep Talk/Mean Look reproduction failed six cases,
three on each side. Called moves skipped PP deduction through a path that
also skipped the targeting guard. That path now retains the guard without
charging additional PP. AI targeting classification is aligned with the
corrected direct-move behavior.

Two further native charging-turn checks failed before correction: priority
shields allowed Gale Wings Fly to take off, only checking the later attack.
Damaging actions now receive the priority gate before charge or self-faint
commands, while Bide's storage and delayed Future Sight retain their separate
paths. Blocked actions clear pending damage and mark the attack unsuccessful.

## Validated build

Both RGBDS 0.5.2 ROM builds and `make audit-static` passed. The long runs used
immutable ROM/symbol/map copies under the audit log directory; the working ROMs
were verified to have the same hashes afterward. ROM0 retains 109 release and
103 debug bytes of slack, and the cartridge header reservation remains intact.

| ROM | SHA-256 |
| --- | --- |
| Release | `d43c89740ba6e6f2f8385f576c93e4f1a5799a6afceee54bbbb6b206c1ea4cd6` |
| Debug | `b2f65070c3730dcbe387d415e03d49ed778ac1324dd45873e55466570a817391` |

## Final validation

These results are from the final build. Rows describing subsets or supplementary
routine checks must not be summed as independent battle totals.

| Check | Observed result |
| --- | --- |
| Complete behavior suite | 36,108 passed; zero failures/errors/skips |
| Every move × every ability × holder role × battler side | 309,024 passed; all eight workers completed |
| Prepared outcomes for every move, both sides (subset) | 888 passed |
| Dynamic types/history/Forewarn/absorption (subset) | 2,256 passed |
| Called-move priority and Dark/suppression controls (subset) | 440 passed |
| Direct status-targeting controls (subset) | 300 passed |
| Live Illusion against every opposing ability and move | 617 passed; zero failures/errors/skips |
| Stance Change stats/stages/status/identity preservation | 532 native checks passed |
| Ordinary/instant/short-pause presentation equivalence, final build | 54 native cases matched |
| Stale-context cleanup before native Imposter entry | Both sides passed |
| Native two-turn Conversion2 AI scoring | Four scenarios passed |
| Native Metronome calls through controlled RNG bytes | 24 scenarios passed, both sides |
| Unaccelerated rendered battle evidence | Six scenarios passed |
| Gyro Ball exact native speed/power calculations | 18,372 passed in each ROM |
| Exact native picture uploads and animation frames | 1,164 passed in each ROM |
| Enumerated chance/critical routines | 44,032 outcomes passed in 172 groups |
| Wide Lens accuracy/item-ID preservation | 2,048 passed |
| Item update timing and suppression-ending faint battles | 352 checks passed |
| Species weights and native weight-based move powers | 503 species; 5,828 powers; zero mismatches |
| Independent standard-move classifications | 443 moves mapped; Pixie Punch is custom |

The completed behavior run contains 36,108 battles, including 888 prepared
per-move outcomes and 4,096 mixed multi-turn stress battles. The separate
exhaustive run completed all 309,024 combinations: 444 moves × 174 ability
entries × two holder roles × two battler sides. Its logs were checked for all
888 unique move/side groups with no duplicates or missing groups; all worker
results identify the same debug ROM hash. Mechanical battle runs use the debug
ROM's native battle engine; release and debug both receive the listed build,
static, native Gyro Ball and exact picture-frame checks.
An inventory of the explicit YAML fixtures finds at least one fixture for every
ability entry, with 3,149 ability/fixture references; this is an inventory, not
an additional passed-battle count.

The independent classifications matched contact, punch, slice, pulse, bite,
ball/bomb and powder flags. Existing differences were Sandstorm/Ominous Wind's
wind classification and Heal Bell's special team-healing sound handling.
These are reviewed as local behavior, not automatically changed from a remote
table.

Logs, generated cases and worker results are in
`.tmpbuild/battle-audit-2026-11-10/`. Superseded and interrupted phases are
retained for diagnosis and are not counted as completed full-suite runs.
The companion `battle-audit-2026-11-10-results.json` records final counts,
ROM hashes and SHA-256 hashes for the completed validation logs. Six ordinary
rendered battle captures and their asserted results are in
`_artifacts/battle-audit-2026-11-10/`, including `native-battle-evidence.png`.

## Reproduction and interpretation

`make test-moves-abilities BATTLE_TEST_JOBS=8` includes prepared per-move
outcomes and the expanded interaction matrices. `make test-exhaustive-battles
BATTLE_TEST_JOBS=8` additionally runs every move with every ability in attacking
and defending roles on both sides.

This audit used `--interactions 4096` for the mixed stress portion (the ordinary
Makefile target defaults to 512). The complete behavior invocation was:

```sh
.venv/bin/python tools/battletest/runner.py --rom .tmpbuild/battle-audit-2026-11-10/validated-roms/pokecrystal_debug.gbc --no-render --instant-text --short-delays --jobs 8 --all-moves --all-effects --move-semantics --dynamic-type-matrix --all-abilities --ability-matrix --reflection-matrix --class-matrix --textbox-matrix --swagger-matrix --outcome-matrix --item-matrix --reaction-matrix --complex-matrix --long-battles --interactions 4096
.venv/bin/python tools/battletest/exhaustive_battle_audit.py --mode cartesian --jobs 8 --rom .tmpbuild/battle-audit-2026-11-10/validated-roms/pokecrystal_debug.gbc --output .tmpbuild/battle-audit-2026-11-10/cartesian-validated
```

The Cartesian matrix uses a real initialized pre-turn state and lets native
selection, ordering, effects and cleanup execute. Reusing setup and replacing
initial ability fixture bytes avoids replaying identical introductions. It
asserts completion, HP/stage bounds and text/state integrity. It does not prove
that an ability activated when its prerequisite is absent; prepared outcome
matrices and legal-species entry tests provide that evidence.

Large mechanical runs can use instant letters and shortened fixed presentation
pauses. All text commands and glyphs execute, with at least one real VBlank per
fixed pause; sound waits and effect routines are retained. Separate comparisons
check mechanical/text equivalence against ordinary presentation. This mode
does not establish audio or animation timing correctness.

No finite suite covers every party, item, status, weather, action sequence and
random stream. Results establish the enumerated cases, rather than a promise
that undiscovered defects are impossible. Player saves are never opened.

## Independent references

The primary [Pokémon Showdown move definitions](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts),
[ability definitions](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts),
and [native action model](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle-actions.ts)
were consulted on November 10. Their called-move action propagation and
Conversion2 historical-type handling informed the expectations; authored local
rules take precedence. Source snapshots are retained with the audit logs.
