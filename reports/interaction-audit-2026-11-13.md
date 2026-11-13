# Moves, abilities and held-item interaction audit — November 13, 2026

Status: complete. No unresolved failures remain after correcting the stale
Thermal Exchange test expectations described below.

Source revision: `7ce0788a2bbed193c7b5b8f53a4d5a17a90cbd20`, plus the
uncommitted changes described here. Existing changes to
`Claude outputs/all-six-reel.mp4` and `audio/ded/axew.ded` were preserved.

## Findings and corrections

Eleven defects were reproduced and fixed: ten battle-mechanics defects and
one AI scoring defect. No save-format, species-index or dialogue changes.

| Defect | Before | Correction |
| --- | --- | --- |
| Light Ball and Thick Club ignored Klutz | Pikachu and the Cubone family still received their doubled offensive stat with effective Klutz. | The species-item helper checks the effective ability before reading the raw item ID. Gas can restore the item; opposing Mold Breaker cannot bypass Klutz. |
| Capped Power Herb Skull Bash canceled its attack | At maximum Defense the herb was consumed but the cap failure marked the damaging move as missed. | Preserve the triggering move's failure flags around the charge-turn stat boost. |
| Capped Weakness Policy interrupted its triggering move | A capped Special Attack boost stopped Double Kick after its first hit and prevented a subsequent Psychic stat drop. | Preserve `wAttackMissed` across the item's independent boosts. The existing whole-hook wrapper already preserves the secondary-effect roll in `wEffectFailed`. |
| Mold Breaker did not bypass Thermal Exchange's Fire-hit boost | The target still gained Attack despite the ability being marked ignorable. | Read the opponent's ignorable effective ability in the on-hit dispatch. Unignorable reactions such as Stamina still activate. |
| Natural type immunity incorrectly preempted absorption abilities | A Ground holder of Lightning Rod gained no Special Attack, and one with Volt Absorb gained no HP from an Electric hit. | Resolve absorbers and move-class blockers before natural immunity. Disguise and Levitate retain their later immunity checks. Protect and semi-invulnerability still prevent absorption. |
| Nightmare bypassed Protect and Baneful Bunker | A sleeping target successfully calling a guard through Sleep Talk still acquired Nightmare. | Reuse the shared Protect guard. King Shield still permits status moves; existing accuracy semantics are preserved. |
| Player move restrictions could trap the Fight menu | Status-only Assault Vest, Choice plus Taunt/Torment, or Vest plus Torment could leave every selection refused without offering Struggle. | Scan the intersection of PP, Disable, status and effective-item restrictions. Preserve the caller's turn holder and do not establish a Choice lock during the scan. |
| Enemy move restrictions bypassed each other | Taunt/Torment could replace an existing Choice lock with another move; Torment could select a status move despite Assault Vest. | Choose a move satisfying all restrictions together, or Struggle. Preserve an already legal AI choice and its selected PP slot when Mimic creates duplicate move IDs. |
| Choice users spent PP from the wrong duplicate move | The first copy lost PP when the second was selected; an exhausted first copy could also force Struggle despite a usable second copy. | Preserve a legal selected slot and search all matching copies before rejecting the locked move. A separate bounded presence check distinguishes an absent move from an exhausted or disabled one. |
| An enemy retained a vanished Choice lock after Mimic | On the next turn it used Struggle while its copied move still had PP. | Release a lock whose move no longer exists, matching the player and the primary simulator. Disabled or exhausted moves still enforce their existing locks. |
| Spite AI counted PP-Up bits as remaining PP | Raw PP `$C1` was scored as a full move instead of one remaining PP. | Mask with `PP_MASK` before the low/medium/high PP comparisons. |

Two generated matrices also expected the incorrect Thermal Exchange behavior:
the reaction matrix for all 21 eligible Fire moves, and the ability matrix
for its four Fire-move controls. Their oracles now distinguish Mold Breaker's
temporary bypass from Gas suppression; only Gas is expected to keep
subsequent status and residual damage identical to the no-ability control.
The broad run exposed the ability-matrix assertions; their corrected cases
and paired controls were rerun separately against the same final ROM.

## Reproduction evidence

The pre-fix ROM and its matching symbols were saved privately under
`.tmpbuild/interaction-audit-2026-11-13/baseline/` before rebuilding.

| New coverage | Pre-fix result |
| --- | --- |
| `107-move-audit-2026-11-13.yaml`: Nightmare and guard controls | 2 passed, 6 failed |
| `108-ability-audit-2026-11-13.yaml`: ability bypass, immunity ordering and controls | 12 passed, 8 failed |
| `109-held-item-interactions-2026-11-13.yaml`: species items, capped boosts and controls | 44 passed, 28 failed |
| `110-enemy-selection-audit-2026-11-13.yaml`: intersecting restrictions, duplicate slots and Mimic | 8 passed, 10 failed |
| `test_battle_selection_restrictions.py`: player scan and PP-Up-independent Spite scoring | 20 passed, 23 failed |
| `move_restriction_menu_checks.py`: nine actual Fight-menu scenarios | 28 checks passed, 8 failed |
| Corrected Thermal Exchange matrix, all 21 Fire moves and paired controls | 21 passed, 21 failed |
| `test_held_item_hit_integrity.py`: item getters, capped boosts, consumption and bank/turn restoration, each ROM | 70 passed, 24 failed |

The eight menu failures are two assertions each for four blocked scenarios:
no Struggle executed, and the menu never returned after a completed turn.
Five legal/no-item/Klutz control scenarios passed before the fixes.
The no-item duplicate-slot case was added to prevent a regression found while
reviewing the new selector; it passes on the baseline and final selector.
A second duplicate-slot case with an active Choice lock reproduces the same
PP-slot defect in the original engine and is also fixed.

## Scope

Parallel source reviews covered individual move scripts, status and
Substitute gates, called and charging moves, counters, priority, phazing,
fainting and switching, ability suppression and bypass, contact and hit
reactions, item getters, consumption, berries, item transfer, Recycle and
16-bit runtime-item handling. Previous audits were read as evidence to
review, including their unresolved hypotheses and documented custom rules.

Preserved intentional or established behavior includes Illusion's Speed
reward, the custom Flash Fire boost, legacy recharge and healing rules,
selection-time Choice locking, called-move history, Knock Off's post-battle
return, enemy Thief/Pickpocket item loss, and the documented Harvest/Cud
Chew and Air Balloon/Recycle behavior. No dialogue was changed.

For uncertain modern mechanics, reference checks used the primary simulator
implementation: [ability definitions](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts),
[ability event suppression](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle.ts),
[move execution order](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle-actions.ts),
[Nightmare's Protect flag](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts),
and [effective-item handling](https://github.com/smogon/pokemon-showdown/blob/master/sim/pokemon.ts).
The stale Choice lock was checked against the
[Choice-lock condition](https://github.com/smogon/pokemon-showdown/blob/master/data/conditions.ts).
The repository's documented custom rules take precedence over those references.

## Validation

Both ROMs build with RGBDS 0.5.2 using the repository virtualenv for asset
generators:

```sh
PATH="$PWD/.venv/bin:$PATH" make -j8 pokecrystal.gbc pokecrystal_debug.gbc \
  BATTLE_TEST_PYTHON=.venv/bin/python
```

| Final ROM | SHA-256 |
| --- | --- |
| Release | `1e417872c16e0d679b26d40bc4301ade05e2939c1697cec6035a01223d5a8f9d` |
| Debug | `3057c8d055448f4936a870c9951e2b0c8af7d17db6af2d00ff04fad61aed5c99` |

The comprehensive battle matrix ran on debug `5b60c543...`; the both-ROM
native checks also used release `02d457dd...` before the final unrelated-asset
cleanup. The build had regenerated Kingdra's
tracked palette from its existing PNG; that palette was restored to its
original tracked bytes. A byte-for-byte comparison proves the delivery ROMs
differ only at Kingdra's four normal-palette bytes (`$AD4F`–`$AD52`) and the
global checksum. All engine code and other data are identical. Native item
and selection checks also passed again on both delivery ROMs. The receipt
is `.tmpbuild/interaction-audit-2026-11-13/palette-cleanup-checks.json`.

Completed checks:

- Comprehensive suite: 32,788 cases executed; 32,784 passed, four obsolete
  Thermal Exchange expectations failed, zero errors and zero skips. All
  four were corrected in the generator and verified in the 138-case rerun
  below against the same engine. No other failure appeared.

- Player selection and Spite scoring: 43 checks on each ROM, zero failures.
- Native held-item routines: 94 checks on each ROM, zero failures. Only
  textbox presentation is stubbed in private emulator memory; getters,
  consumption, ability checks, stat caps and bank/turn restoration run normally.
- Exact Gyro Ball powers and speed modifiers: 18,372 checks on each ROM,
  zero failures.
- Stale action-context entry controls: passed on both native battler sides.
- Native dynamic-type AI: four two-turn scoring cases passed.
- Native Metronome priority: 24 called-move checks passed on both sides.
- Focused Nightmare and enemy-selection regressions: 26 passed, zero failures.
- Existing native Choice-menu checks: 21 checks, zero failures.
- Corrected ability-matrix Thermal Exchange scenarios and paired controls:
  138 passed, zero failures. The four obsolete assertions in the already
  running broad suite expected an Attack boost through Mold Breaker; each
  affected move passes the corrected stat-level comparison on the same ROM.
- Native player menu: 36 checks across nine scenarios, zero failures;
  screenshots and JSON in `_artifacts/move-restriction-menu/`.
- Scoped `git diff --check`: passed.
- `make audit-static`: passed, including linked resources, save layout,
  move/ability data, trainers, icons and map-sprite audits.
- Delivery-ROM resource recheck after palette restoration: 11,182 checks
  passed across 1,912 binary assets.

ROM0 slack remains 97 bytes in release and 91 bytes in debug; the cartridge
header reservation is intact.

The normal move/ability target now includes both-ROM selector/AI and held-item
checks plus both native menu suites. The broad log deliberately retains its
original four failed assertions for traceability; the corrected rerun is
`thermal-ability-matrix-final.log`.

Logs are in `.tmpbuild/interaction-audit-2026-11-13/`.
The comprehensive run uses the existing acceleration modes (pixel rendering
off, instant letters and shortened presentation pauses) while preserving
native move selection, effects, text commands and per-frame CPU execution:

```sh
.venv/bin/python tools/battletest/runner.py \
  --no-render --instant-text --short-delays --jobs 8 \
  --all-moves --all-effects --move-semantics --dynamic-type-matrix \
  --all-abilities --ability-matrix --reflection-matrix --class-matrix \
  --textbox-matrix --swagger-matrix --outcome-matrix --item-matrix \
  --reaction-matrix --complex-matrix --long-battles --interactions 512
```

## Limits

The broad generated matrices establish their stated outcomes and execution
invariants; they do not prove every possible move/ability/item/state
combination. No campaign playthrough, physical-hardware or link-session test
was performed. The full every-move-by-every-ability Cartesian audit is
separate from the focused interaction matrices and was not run in this pass.
Player saves are never opened by these fixtures.
