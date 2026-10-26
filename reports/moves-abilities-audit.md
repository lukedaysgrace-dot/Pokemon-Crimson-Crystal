# Moves and abilities audit

This pass starts from `f69c72b6` and focuses on move execution, power, accuracy,
secondary effects, move classes, abilities, suppression, held items and battle
state transitions. Existing project-specific move and ability rules are
preserved.

## Fixes

### Gyro Ball calculated incorrect power and ignored speed modifiers

The old routine overwrote the user's speed divisor with 150 before dividing.
It also reduced both speeds to bytes, losing precision, and read stored speeds
without applying ability and held-item modifiers. An initial 288-case native
reproduction failed 176 cases on the pre-fix ROM.

Gyro Ball now calculates `min(150, floor(25 * targetSpeed / userSpeed) + 1)`
using exact integer arithmetic. Its speed calculation shares the existing
turn-order helper, including weather abilities, Quick Feet, Choice Scarf,
Klutz, Unburden and ability suppression. Trick Room changes action order,
without reversing the speeds used for power. The routine preserves its damage
calculation registers and the caller's turn and WRAM bank.

`tools/test_gyro_ball.py` checks both battlers, ratio boundaries, large speeds,
power caps and ability/item interactions. It passes 18,372 checks on each of
the release and debug ROMs. Native battle regressions also assert resulting
power and successful damage through the full move pipeline.

### Sleep Talk could select Bounce

Sleep Talk rejected the older two-turn move effects but omitted Bounce's
separate effect ID. It could therefore select an ineligible move. The shared
eligibility check now rejects `EFFECT_BOUNCE`.

Regression battles cover player and enemy Sleep Talk, failure without entering
a semi-invulnerable state, and correct PP use. A Tackle control verifies that
eligible moves can still be called.

The 20 new battle cases include these fixes and working Heal Bell/Soundproof
controls. Against the pre-fix ROM, 14 fail and six controls pass; all 20 pass
on the rebuilt ROM. Heal Bell required no code change: its user can cure
itself, and inactive reserves do not retain Soundproof's protection under the
modern ability rules used here.

## Verification

Release and debug builds succeed. The final debug ROM's SHA-256 prefix is
`2350d3573890`.

| Check | Result |
| --- | --- |
| Complete move/ability battle run | 28,202 passed; zero failures, errors or skips |
| Exact Gyro Ball native checks | 18,372 passed per ROM |
| Secondary-effect and critical-hit probabilities | 172 groups, 44,032 outcomes passed |
| Accuracy, Wide Lens, Klutz and Neutralizing Gas | 2,048 native checks passed |
| Species weights and weight-based move power | 498 weights, 5,698 power results; zero mismatches |
| Spider Web switch-in ability matrix | 344 battles passed, covering both sides |
| HP-item updates, faint updates and speed ordering | 352 checks passed |
| Move-data audit | 442 moves, 233 effect entries, 218 battle commands and 498 learnsets passed |
| Ability text | 574 banner/text fragments fit the battle textbox |
| Resource/audio audit after rebuilding | 10,194 checks passed |

The complete battle run includes all YAML cases, every move/effect/ability,
ability suppression and bypass, reflection, move classes, textboxes, Swagger,
move outcomes, items, hit reactions, multi-hit combinations, long battles and
512 deterministic interaction stress cases. The ability sweeps cover all
172 entries, including the no-ability control.

The probability suite exercises all 256 RNG values per scenario, including
Serene Grace, Sheer Force, Shield Dust, Neutralizing Gas, Mold Breaker,
Merciless and Super Luck. Weight checks cover Low Kick, Grass Knot, Heavy Slam
and Heat Crash. The speed-ordering checks also exercise Trick Room, link-battle
ordering and ability suppression after extracting the shared speed helper.

Re-run the principal suite with:

```sh
make BATTLE_TEST_JOBS=8 test-moves-abilities
```

Gyro Ball's native checks also run under `make test-audit-state`. The previous
source-pattern check was removed because it accepted the broken divisor;
compiled-ROM behavior now guards the formula.

Builds, baseline reproductions and validation logs are retained under
`.tmpbuild/moves-abilities-audit/`. The complete battle run's worker logs are
under `.tmpbuild/battletest-2350d3573890-1792994552430917714/`. Tests use private
emulator memory and do not open player saves.

## Reference review and coverage limits

The [Pokemon Showdown move definitions](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts)
were used to verify Gyro Ball's formula, Sleep Talk's two-turn exclusions and
Heal Bell's user exemption. Its [ability activation rules](https://github.com/smogon/pokemon-showdown/blob/master/sim/pokemon.ts)
explain the inactive Soundproof reserve controls. The
[ability definitions](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts)
and [damage calculation](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle-actions.ts)
also informed review of speed modifiers and alternate attacking stats. These
references were checked on 2026-10-26; intentional local rules take precedence.

Move contact flags and the applicable punch, slice, pulse, ball/bomb, powder,
bite and Triage classifications were compared across 440 canonical-name
mappings; two local move definitions have no direct canonical-name mapping.
Dynamic Shell Side Arm contact remains covered by the previous audit's tests.

Every-move sweeps provide execution/crash coverage. Effect scenarios and
interaction matrices add behavioral assertions, but do not prove every move
under every prerequisite or enumerate every move/ability/opposing-ability
combination. This audit is source/data review and emulator validation, not a
complete campaign playthrough or hardware certification.
