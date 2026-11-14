# Complete-turn damage pipeline follow-up — November 13, 2026

This follows up the first priority in the battle audit: independently check
damage through complete native turns with critical hits, weather, dual
weaknesses, defensive screens, status penalties and stacked modifiers.

## Result

Final expanded run: **3400 passed, zero failures, errors or skips**, in
79.8 seconds across eight workers. The preceding 2288-case matrix also
passed without a mismatch. No additional game defect has been confirmed.
The game assembly and ROMs are unchanged by this follow-up.

The new harness also detects the previously fixed percentage overflow and
Mega Sol minimum-damage bugs in complete turns on the pre-fix debug ROM:

| Pre-fix control | Passed | Failed | Errors / skips | Meaning |
| --- | ---: | ---: | ---: | --- |
| High/low arithmetic boundary turns | 114 | 6 | 0 / 0 | Six stacked Fire Punch cases calculate 4580 instead of saturating at 65535 |
| Weak Water / Mega Sol turns | 8 | 4 | 0 / 0 | Rain cases, critical and ordinary, both orientations, deal zero instead of one |

These are independent full-turn reproductions of existing fixes, not two new
findings. In the overflow cases both values exceed the defender's remaining
HP, so an HP-only assertion would miss the defect. The command-boundary
observations detect the incorrect calculated damage before HP clamping.

## What executes

`tools/battletest/damage_pipeline_checks.py` boots a private debug-ROM fixture,
starts a native battle, pauses before the first turn, supplies a declared
initial state, then resumes ordinary battle selection and execution. It does
not call damage commands individually or replace damage/stat-selection code.
Observers at command entries read values without changing them.

For every case the separate model in `damage_pipeline_oracle.py` predicts:

1. The selected Attack/Sp. Atk and Defense/Sp. Def after critical-hit and
   Unaware rules, screens, weather/item defense boosts, status and truncation.
2. The move's level, power, type and category, and the critical-hit decision.
3. Base damage after the ordinary formula, its type-item adjustment, cap,
   +2 and any declared Glaive Rush vulnerability.
4. Damage after weather, critical multiplier, STAB, type effectiveness,
   held items, offensive abilities and defensive abilities.
5. Final damage after random variation, followed by the actual immediate HP
   loss, including overkill and one-HP targets.

The model reads raw stats as inputs. It does not use native selected stats,
critical flags, intermediate damage, final damage or HP loss to calculate its
expected result. Move power/type/category, STAB and matchup factors are
explicitly authored for the declared nine representative moves, independently
of the assembly table parsers. This does not audit the entire move table.

## Project formula and order

The model preserves the project's integer behavior. It does not substitute
a modern Pokémon calculator:

```text
selected stats = project stage/status/critical/Unaware rules
defense = apply eligible screen, defensive weather and defensive held item
jointly quarter Attack and Defense until both fit a byte; each stays >= 1
q = floor(floor((floor(2L/5) + 2) * power * Attack / Defense) / 50)
q = apply any matching type-boost item, truncating
base = min(997, q) + 2
apply declared Glaive Rush doubling
apply weather, then critical damage, then STAB, then type-chart factors
apply held damage items, attacker ability, then defender ability
final = floor(damage * roll / 255), with the native 0/1-damage shortcut
HP loss = min(final, current HP)
```

Each stage retains its own rounding and saturation. Examples of preserved
custom behavior are Adaptability's additional 133%, Filter/Solid Rock's half
damage on a quadruple weakness, Mega Sol's rain compensation, and offensive
ability/item boosts applied to damage rather than a modern stat chain.
Critical hits ignore an unfavorable offensive stage and a favorable defensive
stage independently, ignore screens, and retain burn/frostbite penalties.

Principal traced implementation paths:

- `engine/battle/effect_commands_core.asm`: damage-stat selection, critical
  pointers, Unaware, defensive screens/weather/items, stat truncation.
- `engine/battle/effect_commands.asm`: formula, critical multiplier, STAB,
  ordered type-chart operations, variation and HP application.
- `engine/battle/misc.asm`: weather damage adjustments.
- `engine/battle/abilities_engine.asm`: offensive/defensive damage hooks.
- `engine/battle/modern_held_items.asm`: modern held-item damage boosts.
- `engine/battle/legacy_core.asm`: native battle PRNG.

## Matrix coverage

| Group | Complete battle cases | Coverage |
| --- | ---: | --- |
| Core | 2160 | Nine archetypes × three weather states × critical/ordinary × burn/control × screens/control × five stage pairs × both orientations |
| Stacked | 504 | 21 authored ability/item/defensive profiles × three weather states × critical/ordinary × burn/control × both orientations |
| Defensive paths | 120 | Rock/sand and Ice/hail defense; Eviolite; Assault Vest; Psyshock's physical-defense path; screen/critical controls |
| Unaware | 72 | Offensive and defensive Unaware, Mold Breaker controls, stages of opposite signs, screens and burn |
| Boundaries | 120 | Levels 1/100; raw stat endpoints 1/2/255/256/999; Glaive Rush; capped base and stacked saturation |
| Immunities | 36 | Ground, Ghost and Dark immunities with weather, critical and item/ability boosts |
| Minimum damage | 12 | Weak Water damage with Mega Sol in none/rain/sun, critical/ordinary, both orientations |
| Screen selection | 24 | Matching and nonmatching individual screens, ordinary/critical; Psyshock |
| Variation | 312 | Every integer roll 217 through 255, two attack archetypes, critical/ordinary, both orientations |
| Remaining focused controls | 40 | One-HP defenders, frostbite, Battle Armor, Neutralizing Gas and Marvel Scale |
| **Total** | **3400** | Exact formula inputs, command-boundary damage and HP assertions |

The core stage pairs are neutral, negative offense/positive defense, positive
offense/negative defense, both negative and both positive. This distinguishes
the two critical-stage decisions, rather than only checking cases where both
are ignored or both retained.

Named attack archetypes include ordinary neutral damage, physical/special
Fire and Water with quadruple weaknesses, quadruple Electric and Ice
weaknesses, quarter-resistant Fire, resisted STAB Psychic, weather defenses,
Psyshock and three natural type immunities. The move set is Tackle, Fire
Punch, Flamethrower, Waterfall, Surf, Thunderbolt, Ice Beam, Psychic and
Psyshock. Moves/abilities can be explicit post-entry overrides; entry effects
are not being certified by these cases.

Stacked profiles include Choice Band/Specs, Life Orb, Expert Belt, Muscle
Band, Wise Glasses, Charcoal, Mystic Water, Punching Glove and a maximum
Metronome streak. Ability paths include Tough Claws, Iron Fist, Huge Power,
Guts, Sniper, Sheer Force, Klutz, Adaptability, Solar Power, Mega Sol,
Tinted Lens, Technician, Hustle, Mold Breaker and Infiltrator, together with
Thick Fat, Multiscale, Fur Coat, Filter, Solid Rock, Dry Skin and Fluffy.

## Fixture controls and test-development corrections

- Ordinary/critical controls use forced RNG bytes 20/4. These moves have no
  high-critical bonus. Battle Armor and Gas controls have independent expected
  outcomes.
- The 312 variation cases seed the next native PRNG byte to produce the
  declared 217..255 roll. The native PRNG read, rotate/range check and damage
  multiplication/division still execute. Critical and accuracy RNG are
  restored to their controlled mode afterward. The model uses the requested
  roll and separately asserts that the native roll agrees. Roll probabilities
  and distribution are not certified.
- Raw and staged stat words are seeded coherently. The ordinary debug request
  applies stages after status and can overwrite a pre-existing status penalty;
  this suite supplies the independently calculated initial staged values.
  It therefore checks native damage-time stat selection, not the preceding
  stat calculator or the UI process for reaching every stage/status state.
- Boundary inputs include synthetic extremes and post-entry ability overrides;
  not every combination can occur on that species at that level. Artificial
  Fire-type burns and other status stress states are not encounter claims.
- Glaive Rush boundary fixtures give the attacker higher Speed, so the target's
  next action cannot expire its vulnerability before the measured hit.
- An Assault Vest defender with only Splash would correctly Struggle and take
  recoil before a slower attacker hits. Those defenders are asleep to isolate
  the declared damage input and preserve their initial HP.
- Facility EXP suppression prevents boundary KOs from entering long sequences
  of unrelated level-up/move-learning menus. Player saves are never opened.
- Early development runs found an incorrect test screen mask, an overstrict
  expectation that damage 0/1 draws a variation roll, the Vest recoil/setup
  issue, Glaive Rush expiry and level-up-menu timeouts. These were fixture or
  oracle errors, not additional game bugs. Their logs remain in `.tmpbuild/`.

## Reproduction and receipts

```sh
make test-damage-pipeline BATTLE_TEST_PYTHON=python3 BATTLE_TEST_JOBS=8
# or
python3 tools/battletest/damage_pipeline_checks.py --jobs 8
```

The suite is also part of `make test-moves-abilities`. It writes per-case
inputs, expected values, native observations, failures, group counts and the
loaded ROM SHA-256 to `_artifacts/damage-pipeline/results.json`. `--group`,
`--limit`, `--rom` and `--output` allow focused reproduction. An alternate
ROM must contain the debug battle tester and matching symbols.

The final debug ROM SHA-256 is
`0932238a2645d0e1d5812165b2d91bfd95e83bb87b57cdd30d2913569f9b5ecd`.
The final log is `.tmpbuild/damage-pipeline-final.log`; complete per-case
receipts are `_artifacts/damage-pipeline/results.json`.
Both release and debug ROM build targets completed successfully after the
test integration. Their SHA-256 values remain identical to the seven-fix
delivery build; release is
`b9d60b84eac48d47c722676530afbbf1116fb6406bf7f04af32f78ed59239959`.
Build output is `.tmpbuild/damage-pipeline-build.log`. Python syntax and
scoped whitespace checks passed. The complete earlier static audit was not
repeated for this test/documentation-only follow-up.
Baseline receipts are `.tmpbuild/damage-pipeline-2026-11-13/` files
`boundaries-before-final.json` and `minimum-before.json`. The baseline debug
ROM hash is `2f42e5ea8715ec94c5e903581c9ebfb01d53ee1d21d058ab67af3f9617f1fc61`.

## Limits

This is native debug-ROM execution of representative full damage pipelines.
It does not establish complete coverage of every move, ability, item or
reachable state. It does not test release-ROM full turns, physical hardware,
link sessions, the probability distribution of random rolls, full persistence
transitions, or every fixed/counter/delayed/multi-hit/recoil/drain path. Those
remain separate audit work. No additional engine fix was justified by this
follow-up's confirmed results.
