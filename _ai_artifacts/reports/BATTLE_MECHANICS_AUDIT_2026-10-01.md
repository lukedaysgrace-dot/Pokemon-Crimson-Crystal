# Ability and move audit — October 1, 2026

## Rules and scope

The requested baseline is Generation 9 singles behavior for the moves and
abilities implemented by this game. The user explicitly preserved the existing
Gale Wings, Disguise, Filter, and Filter-like damage-reduction designs, including
Solid Rock. Existing custom Mega Sol, frostbite, and Hail content are retained.
The subsequent Flash Fire request adds the custom higher-offense boost described
below; that request supersedes the initial modern Flash Fire implementation.

The final requested scope is abilities, moves, and battle interactions. The
review covers battle execution, ability suppression and reactivation,
damage/stat calculation, Substitute and contact behavior, status eligibility,
multi-hit moves, residual effects, AI decisions, expanded species/move IDs,
tables, bank calls, and linked resources. It combines
source review, isolated ROM builds, emulator regressions, and static audits.
This is not an exhaustive visual playthrough or a proof that every possible
combination is bug-free.

Breeding and storage/save checks completed before the user narrowed the scope
are recorded separately below. Pre-existing working-tree fixes and unrelated
sprite edits were preserved.
Root ROMs and save files were not overwritten; audit builds and emulator state
are isolated under `.tmpbuild/full-audit-2026-10-01/`.

## Confirmed fixes

### Abilities and interactions

- Flash Fire follows the user's revised custom rule: each absorbed Fire hit
  raises the higher current Attack or Special Attack one stage, with Special
  Attack winning ties. It retains Fire immunity, stacks normal stat stages,
  and also activates against Will-O-Wisp. There is no separate Fire-only damage
  multiplier. Suppression prevents new activations; earned stages persist
  through suppression and ability replacement, and switching clears them in
  the usual way. Its in-game description reflects this behavior.
- Mold Breaker respects suppression. Trace copies the target's effective
  ability without treating its own Mold Breaker as a copying restriction.
- Neutralizing Gas leaving the field reactivates supported entry/status-cure
  effects. Both battlers receive immediate ability status cures after a move.
- Shield Dust blocks Poison Touch; sound moves bypass Substitute while retaining
  normal sound-immunity checks. Self-directed secondary boosts remain eligible
  through Substitute and against Shield Dust.
- Substitute hits retain actual damage for draining and recoil and do not trigger
  the protected holder's contact/held-item reactions when the Substitute breaks.
  Life Orb applies once per move and preserves Sheer Force's exemption.
- Struggle recoil uses the user's maximum HP and is not prevented by Magic Guard
  or Rock Head. Ordinary recoil uses supported move-specific rates.
- Gluttony affects eligible pinch berries rather than raising ordinary healing
  berries' activation threshold.
- Type-changing abilities also handle eligible status moves. Weather Ball keeps
  its own type rules and receives no type-changer conversion or boost.
- Parental Bond replays the normal hit pipeline. Each hit calculates damage
  and resolves Substitute, contact reactions, held items, and secondary
  effects separately. Fixed-damage moves retain their full damage; eligible
  calculated second hits use the modern quarter modifier. Recoil and switching
  occur at the appropriate point, with charging/native multi-hit exclusions.
- Berserk resolves once after the move, using actual holder damage and correct
  HP Berry timing. It runs before pivoting or phazing and cannot affect a
  replacement. Curing sleep also clears Nightmare.
- Sharpness move membership and Wind Rider move membership were corrected.
- Reckless excludes Struggle, and native Scale Shot pays Life Orb recoil once.
- Ghost-type battlers can escape supported trapping effects and ordinary wild
  battles; Klutz still suppresses Smoke Ball for non-Ghost users.

### Move and damage behavior

- Critical hits select offensive and defensive stages independently: they ignore
  negative offense and positive defense while retaining useful stages. Burn and
  custom frostbite penalties still apply. Unaware and screen handling use the
  selected stat rather than the legacy all-or-nothing critical comparison.
- Critical damage includes the formula's +2 and follows weather. Focus Energy,
  high-critical moves, Lucky Punch, and Stick contribute the correct additive
  stages; the guaranteed stage works even at the highest RNG value. Existing
  game badge bonuses remain consistent when rebuilding Attack.
- Body Press, Foul Play, Psystrike, and Facade use the correct stat, owner,
  stages, and status treatment for both player and opponent.
- Knock Off retains its damage boost against Sticky Hold while respecting the
  item's own removal restrictions.
- Skill Swap accepts identical swappable abilities and runs their entry effects.
- Belly Drum applies one direct stage change, including Contrary behavior;
  Psych Up copies neutral stages and Focus Energy correctly.
- Sleep Talk can call a disabled move and excludes unsupported calling/charging
  effects. Triple Kick accuracy respects Skill Link and Loaded Dice.
- Explosion/Self-Destruct no longer halve the target's Defense.
- Glare and non-Electric paralysis moves bypass the damage type chart; Thunder
  Wave retains its type-immunity check. Hidden enemy-only extra failure rolls
  were removed from supported status/stat effects.
- Transform rebuilds copied raw stats and stages using the transformed user's
  own status penalties. Beat Up uses modern contributor power and the active
  user's live stats, level, and STAB. Bide's storage period is fixed.
- Counter and Mirror Coat use the current round's last direct HP hit and its
  actual category, including variable-category and fixed-damage attacks. Hits
  absorbed by Substitute do not qualify. Their history is bank-safe.

### Turn timing and AI

- Residual status effects run after both actions. Burn and sand damage use 1/16
  maximum HP; binding uses 1/8 for its supported 4–5-turn duration and progresses
  through Substitute.
- Toxic's counter progresses while Magic Guard or Poison Heal prevents damage
  and stops at its supported cap.
- Residual stages are ordered across both battlers in effective-Speed order;
  Trick Room does not reverse residual ordering. Leech Seed precedes poison.
- Weather, Wish, Leftovers, residual damage, ability cures, and late ability
  effects use their supported timing. Bad Dreams precedes Hydration and Shed
  Skin; status cures precede Yawn, then Perish Song. Weather chip and each
  holder's weather ability share the same Speed-ordered pass. Future Sight and
  Perish Song resolve each victim before continuing, and expired Future Sight
  is cleared even when weather has already removed its target. Replacements
  enter after residual phases; last-mon knockouts stop later effects when the
  battle is decided.
- Leech Seed protects a fainted source and preserves the actual drained amount
  across HUD updates. An early purported over-heal was a percentage-HP fixture
  mistake, not a confirmed game defect; an exact raw-5-HP regression passes.
- AI distinguishes status immunity, damage immunity, Magic Bounce reflection,
  and Substitute blocking. Sound moves and Attract can bypass Substitute;
  zero-base-power damaging moves still receive type-immunity scoring.

### Previously completed nonbattle work

- Eggs inherit the selected mother/non-Ditto parent's ability slot with the
  supported 80% regular / 60% hidden probabilities, accounting for offspring
  slot availability and evolution-dependent ability names.
- Existing save-refusal propagation and the documented Snorlax breeding
  exception were retained and validated. The pre-existing Pressure self-target
  exemptions also remain in the battle engine.

## Initial audit verification

Both release and debug ROMs build successfully with RGBDS 0.5.2. Final emulator
runs use the frozen debug ROM in `.tmpbuild/full-audit-2026-10-01/verified-final/`
and compiled PyBoy 2.7.0. ROM builds reuse the existing generated graphics;
sprite-source regeneration is outside this battle pass.

| Check | Final result | Log under `.tmpbuild/full-audit-2026-10-01/` |
| --- | --- | --- |
| Complete YAML battle regressions | 911 passed; zero failures/errors | `full-suite-final.log` |
| Every implemented move | 420 passed; zero failures/errors | `move-sweep-verified.log` |
| Represented move effects and deterministic mixed interactions | 202 + 128 passed; zero failures/errors | `effects-stress-verified.log` |
| Focused final ability regressions | 64 passed; zero failures/errors | Included in the full suite |
| Focused final residual regressions | 43 passed; zero failures/errors | Included in the full suite |
| Linked resources and assets | 4,633 checks, 2,103 assets, zero errors | `static-linked-final.log` |
| Linked save layout and recovery | 185 checks passed | `static-linked-final.log` |

The three complete initial audit runs total **1,661 passing cases**, with zero
failures, errors, or skips. Their elapsed times were 343.8 seconds for YAML
regressions, 206.6 seconds for the move sweep, and 284.1 seconds for effects and
mixed interactions. The focused runs above overlap the complete suite. These
runs preceded the subsequent custom Flash Fire revision; its fresh validation
and ROM are recorded separately below.

The move/table audit passes for 420 moves, 222 effect scripts, 211 battle
commands, and 495 species learnset/egg-pointer blocks. Scoped `git diff --check`
passes. Independent final reviews of Parental Bond/Counter bank, stack, and
callback handling found no additional confirmed defects.

New battle regressions live in `tools/battletest/tests/58` through `64`
(the full filenames include the audit date). Existing expectations were updated
for corrected Knock Off, Weather Ball, Ghost escape, and critical behavior.
Two new Perish Song assertions originally inspected countdown bytes after
normal terminal battle cleanup clears them; they now assert that the battle
ended while retaining the decisive HP-order checks. Diagnostic failures and
interrupted intermediate runs are not final validation results.

The Gale Wings priority routine, Disguise routines, and Filter/Solid Rock
multiplier block compare unchanged against HEAD. Their requested custom rules
are also covered by the retained battle tests.

Earlier checks completed before scope was narrowed: 44,759 game-data invariant
checks; 578 trainer parties, 712 references, and 321 Battle Tower records;
and 211 nonbattle emulator cases (Day-Care 21, save 25, storage 122, PC UI 23,
required-save PC UI 20). The Day-Care regressions remain in
`tools/test_daycare_abilities.py`.

### Initial audit artifacts

The isolated release ROM is
`.tmpbuild/full-audit-2026-10-01/verified-final/pokecrystal.gbc`.
The debug counterpart is `pokecrystal_debug.gbc` in the same directory. Symbol
and map files accompany both.

| Artifact | SHA-256 |
| --- | --- |
| Release ROM | `ADFC5360E70DDAD9214E2FFE494213964C174C550A62AE142C15D3CFEC059EB3` |
| Debug ROM | `DD89CE01E506A6744429D2C1BE41DF222A057690630630B05DC89DDC8EBB1E8D` |

## Custom Flash Fire follow-up

The revised custom implementation compares the holder's live 16-bit battle
Attack and Special Attack, including applied stat stages and status penalties,
then uses the normal one-stage stat-raise path. A capped selected stat still
absorbs Fire. Fire-status handling preserves the caller's failure state.

Fresh release and debug builds succeed. Linked resources (4,633 checks,
2,103 assets), save-layout/recovery (185 checks), the move/table audit, and
scoped whitespace checks pass. The full abilities, Weather Ball, and audit
ability files pass all **179 cases**, with zero failures, errors, or skips in
70.8 seconds. These include 16 focused Flash Fire audit cases plus the existing
absorption and Weather Ball cases. Coverage includes both offensive stat
choices, Special Attack ties, repeated hits, stage caps, Will-O-Wisp, ordinary
damage boosts, Gas suppression, Skill Swap retention, and Mold Breaker bypass.
The log is `.tmpbuild/full-audit-2026-10-01/flash-fire-custom-regressions.log`.

The **current release ROM** is
`.tmpbuild/full-audit-2026-10-01/flash-fire-custom/pokecrystal.gbc`.
Its debug counterpart, symbols, and maps are in the same directory. The initial
audit artifacts above remain preserved as historical snapshots.

| Current artifact | SHA-256 |
| --- | --- |
| Release ROM | `FB25A2AAA9FA3CBE36FE473E42FC017DFD186304BC8195C3134E618D421AA2E0` |
| Debug ROM | `79F287C629BA6066811748F980F0E63E3510104D10B22AB8958FE94BBB559AD4` |

## Mechanics references

Behavior was cross-checked against the maintained primary implementation in
[Pokémon Showdown abilities](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts),
[moves](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts),
[conditions](https://github.com/smogon/pokemon-showdown/blob/master/data/conditions.ts),
[items](https://github.com/smogon/pokemon-showdown/blob/master/data/items.ts),
and [battle actions](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle-actions.ts).
The game's explicitly preserved custom rules take precedence.
