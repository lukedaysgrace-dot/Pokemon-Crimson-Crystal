# Battle mechanics audit — November 13, 2026

Status: seven confirmed defects fixed; both delivery ROMs built and validated.
The later [focused duplicate-move audit](duplicate-move-audit-2026-11-13.md)
found and fixed two additional selection bugs; its ROM receipts supersede
this original pass's hashes.
This is a documented audit pass, not a proof that every possible battle state
is correct. No save format, species data, move balance, dialogue or game
architecture was changed.

## 1. Audit summary and inventory

The source-derived catalogs enumerate **444 moves**, **173 abilities plus
NO_ABILITY**, and **74 item records with held effects**, including the four
species items whose attribute effect is HELD_NONE. Retired item records with
HELD_NONE are excluded. These are implementation inventories, not statements
that every activation condition was independently verified.

- [Move metadata and complete effect-command sequences](battle-audit-2026-11-13/moves.csv).
- [Ability flags and source references](battle-audit-2026-11-13/abilities.csv).
- [Held items, parameters and source references](battle-audit-2026-11-13/held-items.csv).
- [Direct calls and jumps, with callers and line numbers](battle-audit-2026-11-13/call-sites.csv).
- [Inventory counts and indexed source files](battle-audit-2026-11-13/inventory.json).

There are 234 effect-pointer rows, 214 distinct effects used by moves,
211 distinct dispatch scripts, and 212 script labels including the bank
marker. The longest script has 35 commands, within wBattleScriptBuffer's
40-byte allocation after the Scale Shot change. Indirect dispatch requires
tracing beyond the direct-call catalog.

The review traced turn dispatch, move scripts, ability and item hooks, damage
arithmetic, secondary-result preservation, stat changes, priority context,
switching, fainting, residual phases and cleanup. Principal source files were
`engine/battle/core.asm`, `effect_commands.asm`, `effect_commands_core.asm`,
`abilities_engine.asm`, `modern_held_items.asm`, `consume_held_item.asm`,
`hidden_power.asm`, `stance_change.asm`, `illusion.asm`, the `move_effects/`
routines, `ai/{move,scoring,items,switch,redundant}.asm`, `home/battle.asm`,
the move/ability/item tables and constants, and battle WRAM/HRAM definitions.
The catalogs distinguish files indexed mechanically from function-level code
tracing; they do not imply every line received an independent manual review.

**Confirmed/fixed: 7/7.** Severity: three high, four medium. No unresolved
confirmed defect remains in this pass. Coverage gaps and uncertain policies
are recorded below.

## 2. Turn and shared-state dependency map

| Phase | Actual path and shared state examined |
| --- | --- |
| Initialization | `DoBattle` → party selection → `InitAbilityItemState` → battle-mon initialization → entry/hazard/ability dispatch. Active abilities, item histories, Illusion and stance state are distinct from saved identity. |
| Selection | `AIChooseMove`, `BattleMenu`, `CheckPlayerLockedIn`, `ParsePlayerAction`/`ParseEnemyAction`; PP, Disable, Encore, Taunt/Torment, Choice/Vest/cooldown restrictions. Auto-mode selection does not cover the real player's move menu. |
| Ordering | `CaptureBattleActionContext` → `DetermineMoveOrder` → priority, Quick Claw and effective Speed. Selected-action move/ability bytes must survive called moves and ability changes. |
| Action | `DoPlayerTurn`/`DoEnemyTurn` → `CheckTurn` → `UpdateMoveData` → `DoMove` → command-buffer dispatch. `hBattleTurn` supplies the meaning of user/opponent. |
| Hit | Critical/stat/power/formula commands → STAB/weather/types/nullification → variation/accuracy → HP application → counter/direct-damage history → contact/item/ability reactions → faint checks. Individual scripts deliberately vary command order. |
| Move end | Parental Bond replay/termination, held-item events, Pickpocket, Life Orb, KO rewards and Berserk; pending flags must be consumed before a pivot replaces either battler. |
| Between turns | Weather → weather abilities → Future Sight → Wish/cures/healing → effect-ordered residuals → Taunt/Yawn → Perish Song → Trick Room → late abilities/items → replacements/Encore. Fainted slots remain empty until replacement processing. |
| Cleanup | `ExitBattle` → deferred Stat EXP recalculation → Knock Off item restoration → end-of-battle handling → `CleanUpBattleRAM`. |

Important shared contracts include `wAttackMissed`, `wEffectFailed`,
`wFailedMessage`, `wLoweredStat`, the savemiss/self-drop scope,
`wCurDamage`, `wHitSubstitute`, counter-hit history, Parental Bond state,
`wAfterMoveAbilitiesPending`, `wMoveDamageToHolder`, `wBerserkBerryPending`,
item consumption/Recycle roots, and selected-action context. Banked helpers
must restore rSVBK; ordinary farcall does not preserve an argument in A.
These were traced at their callers as well as within the helpers.

## 3. Confirmed bugs and corrections

### B1 — Scale Shot's capped Defense change canceled its Speed change (medium)

**Source:** [ScaleShot](../data/moves/effects.asm#L2720),
[BattleScaleShotKO_Core](../engine/battle/effect_commands_core.asm#L936).

Reproduction: use Scale Shot at −6 Defense against a surviving target or
score a KO. Speed stayed unchanged. With Contrary, a capped +6 Defense
raise similarly canceled the independent Speed drop. Both orientations failed.
The stat command set wAttackMissed on reaching its cap; the following stat
command inherited that temporary failure.

Correction: insert resetmiss between the two changes in both the ordinary
script and KO tail, retaining the original move's savemiss/restoremiss scope.
The four initial reproductions failed before the fix. The generated mixed-cap
matrix reproduced eight failures among 364 cases; the other 356 were controls.
Focused controls include White Herb, Protect, immunity and an actual accuracy
miss, on both sides. Fixtures: `115-scale-shot-stat-caps.yaml`.

### B2 — Late King's Rock flinching canceled recharge (high)

**Source:** [BattleCommand_HeldFlinch](../engine/battle/effect_commands.asm#L5865).

Reproduction: a faster Mew uses Hyper Beam; a slower King's Rock holder then
hits it. The item path unconditionally called EndRechargeOpp, allowing Mew
to use Hyper Beam on the next turn. Native two-turn cases reproduced this
on both sides. Sleeping targets also acquired an inappropriate flinch marker.

Correction: check target action order and sleep before attempting the held
flinch. The ordinary faster-attacker controls still flinch an awake target.
Removed obsolete effect-pointer setup and a second effective-item lookup;
the original item's chance in C is preserved by all intervening helpers.
This keeps the nearly full debug Effect Commands bank within its limit.
Fixtures: `116-held-flinch-timing.yaml`.

An initial hypothesis that the marker always stole the next turn was rejected:
`CheckPlayerLockedIn` normally clears it. The confirmed gameplay defect is
the premature recharge removal, not that broader hypothesis.

### B3 — Disable/Cursed Body duration froze during interruptions (medium)

**Source:** [CheckPlayerTurn](../engine/battle/effect_commands.asm#L246),
[CheckEnemyTurn](../engine/battle/effect_commands.asm#L479).

Reproduction: set a four-tick Disable on the second move, then spend a turn
asleep or flinching. Its packed duration did not decrease. Four sleep turns
left the disabled move and timer intact. Recharge had the same early-return
path. This affected both the move and Cursed Body's shared timer.

Correction: move the existing countdown, expiry clearing and message ahead
of recharge/sleep/flinch checks. Normal action timing and packed slot format
are preserved. Six initial battle cases failed before the fix. Native checks
also cover normal actions, recharge, one-tick expiry, move clearing and
turn/bank restoration. Fixtures: `117-disable-interrupted-turns.yaml`.

### B4 — Percentage damage boosts wrapped at 16 bits (high)

**Source:** [DamagePercent](../engine/battle/abilities_engine.asm#L3377).

The multiplication/division produced a wider quotient, but the helper stored
only its low two bytes. For example, native 32768 × 200% became zero instead
of saturating. Native Metronome ×2 followed by Tough Claws ×1.3 changed 26968
to 4580 instead of the capped 65535. Large intermediate values can arise
before HP application when critical hits, STAB, weather, dual weakness,
Glaive Rush and further modifiers combine.

Correction: inspect the quotient's upper byte and saturate to $ffff, matching
the existing DoubleDamage and DamageX1_5 contracts. The independent oracle
tests the actual base formula and percentage helper, register preservation,
both sides and both ROMs; it also invokes the complete native modifier
dispatch for the Metronome/Tough Claws example. No damage formula or rounding
order was replaced with a modern-generation formula.

### B5 — Mega Sol could reduce a nonimmune Water hit to zero (medium)

**Source:** [DamagePercent](../engine/battle/abilities_engine.asm#L3377)
and RunDamageModifiers's Mega Sol rain branch.

Reproduction: a three-damage Water hit in rain becomes zero through the
custom ability's 33% compensating adjustment. Native dispatch reproduced
zero on both sides. The intended custom behavior remains a sun-like Water
reduction, with at least one damage for a nonzero hit.

Correction: the percentage helper retains a minimum of one when its input
was nonzero. An input of zero stays zero, preserving immunity and prediction
contracts. The existing 33% factor and other intentional rounding remain.
The before-fix arithmetic/dispatch test had 38 failures among 1396 checks on
each ROM, including B4 and this finding.

### B6 — Trainer Ghosts were incorrectly trapped by binding/Mean Look (medium)

**Source:** [AI_SwitchOrTryItem](../engine/battle/ai/items.asm#L1).

Reproduction: a trainer's Gengar or Hisuian Zorua has Perish Song at one tick
with a healthy reserve. The untrapped control recalls it; binding or Mean
Look prevented that recall and it perished. The raw trapping checks ran
before the Ghost-aware ability-trapping helper. Player recalls already
exempt Ghosts from both restrictions.

Correction: check both current enemy type slots before the raw binding and
Mean Look vetoes. Ability trapping still uses the existing shared helper.
The primary-Ghost and secondary-Ghost reproductions failed; untrapped and
non-Ghost controls passed. Fixtures: `118-ghost-ai-trapping.yaml`.

### B7 — Fury Cutter overflowed its use counter on use 256 (high)

**Source:** [BattleCommand_FuryCutter](../engine/battle/move_effects/fury_cutter.asm#L1).

Reproduction: execute the actual command for 300 consecutive uses, with its
ordinary Technician eligibility helper before every use. PP recovery can
maintain a chain beyond the move's starting PP. On use 256, the byte wrapped
to zero, the decrement-driven damage loop underflowed and produced 65535
instead of the capped fourfold damage. Uses 257/258 restarted low power,
and Technician incorrectly became eligible again. Both orientations failed.

Correction: stop incrementing the stored counter at three uses, the existing
power cap. Parental Bond's second-hit no-increment path is preserved. The
300-use native test checks both damage and Technician throughout the chain;
the extended baseline reproduction had ten Fury Cutter assertion failures.

## 4. Move, ability and held-item coverage

### Move audit — 444 moves

All move rows are enumerated with power, type, category, accuracy, PP,
secondary probability and dispatch sequence. Existing static audits check
the full table, pointer counts, command counts and move expansion. The native
sweep includes every-move smoke coverage, prepared semantic outcomes for
every move in both orientations, effect outcomes, dynamic-type/called-move
cases, class matrices, variable-power moves and long battles. This establishes
the stated outcomes; it does not independently prove every listed property
under every status, weather, switching and failure state.

Move-command defects B1, B2, B3 and B7 were fixed. B4/B5 correct shared
damage arithmetic reached by moves, abilities and held items. The scope of
independent arithmetic verification is stated in section 6.

### Ability audit — 173 abilities, plus NO_ABILITY

The ability catalog includes suppression/bypass flags and code references.
Native ability sweeps, Gas/Trace/transfer controls, offensive/defensive class
matrices and hit-reaction matrices supplement the source tracing. Legal-species
entry controls and actual Imposter entry tests are kept distinct from arbitrary
post-entry ability overrides. No ability, move or item was added or removed.

B3 covers Cursed Body's shared Disable timer, B4 covers overflowing ability
damage boosts, and B5 covers Mega Sol. Contrary and Technician also have
direct controls for the B1/B7 fixes. These results do not certify every
ability's activation conditions across every battle transition.

### Held-item audit — 74 held-effect records

Held-item coverage includes effective Klutz, species items, Choice/Vest/menu
restrictions, consumption/history, HP thresholds, status cures, contact damage,
boosts, theft/removal, Unburden/Harvest/Cud Chew/Recycle, and move-end events.
The exhaustive item-move matrix focuses on its declared Life Orb/Klutz/contact
outcomes; it is not a complete cross product of all 74 held items with every
move and ability. Inactive retired-item compatibility was preserved.

B2 fixes King's Rock's late flinch; B4 also fixes overflowing item/ability
boost chains. White Herb and Metronome have explicit focused controls.

## 5. Interaction results

| Interaction | Expected outcome | Evidence |
| --- | --- | --- |
| Scale Shot × mixed caps × Contrary × both sides | Resolve each stat independently | Eight baseline matrix failures; corrected script/KO tail; 364-case generator |
| Scale Shot × White Herb / Protect / Fairy immunity / miss | Consume Herb after the drop; blocked hits change no stats | Focused native battle controls |
| King's Rock × slower action × Hyper Beam | Retain the completed attack's recharge | Failed before; corrected two-turn battle controls |
| Disable × sleep/flinch/recharge × both sides | Timer advances once per action opportunity | Failed before; native battle and both-ROM routine checks |
| Metronome × Tough Claws × high damage | Saturate without wrapping | Native dispatch and independent integer oracle |
| Mega Sol × rain × weak Water hit | At least one damage; zero inputs remain zero | Both-ROM native dispatch and boundary oracle |
| Ghost typing × binding/Mean Look × trainer switch × Perish Song | Ghost can recall; Normal type remains trapped | Native trainer battles with controls |
| Fury Cutter × PP recovery-length chain × Technician | Power stays capped beyond use 255 | 300 native command uses on each side in each ROM |
| Captured Prankster × Gale Wings Mirror Move × Skill Swap × Dark typing | Dark immunity requires both the original boost and live Prankster; ability loss permits the move | Both native orientations; checkhit/no-checkhit, late-gain and non-Dark controls; no engine change |
| Klutz / Gas × held items and stat boosts | Preserve effective-item and hit-state contracts | Existing 190-check native item suite per ROM |
| Choice/Vest/Taunt/Torment/cooldown × player menu | Select a legal move or Struggle | Real Fight-menu suites, 21 and 48 checks |
| Suppression ending × HP items × faint processing | Reactivate before subsequent actions/animations | 40 update scenarios and 24 native faint-update battles, 352 checks |
| Link RNG × native battle routines | Same stream and outcomes on both orientations | 16384 matched calls over 32 seeds; no cable-handshake claim |

## 6. Damage oracle and arithmetic limits

Follow-up: [complete-turn damage pipeline audit](damage-pipeline-audit-2026-11-13.md)
adds representative native full-turn formula-to-HP checks, including every
217..255 variation roll. Its coverage and receipts are separate from the
original sweep below.

For already-truncated byte-sized attack A, defense D, level L and power P,
the independently checked ordinary base calculation is:

```text
min(997, floor(floor((floor(2L/5) + 2) × P × A / D) / 50)) + 2
```

The engine loads stage/critical/Unaware/status-aware stats first, applies
defensive/species/weather/item adjustments and its Gen II 16-to-8-bit scaling.
The ordinary formula includes type-boosting items before the final +2.
Its command paths then apply Parental Bond/Glaive Rush, weather, critical
damage, STAB, typing and ability/item modifiers, followed by the script's
variation/conditional-power commands. Fixed/counter/delayed attacks have
separate scripts. The report does not replace these paths with a universal
modern formula.

Native oracles cover level 1/50/100, low/high byte stats, low/high power,
the 999 base cap, 16-bit percentage boundaries, zero preservation, register
preservation, modifier dispatch and 300-use counters. Existing exact Gyro Ball
checks add 18372 speed-ratio cases per ROM. The complete final pipeline for
every possible combination remains outside independent-oracle coverage.

## 7. Validation receipts

Toolchain: RGBDS 0.5.2. Builds use
`make -j8 pokecrystal.gbc pokecrystal_debug.gbc` under the installed WSL
toolchain. Player saves are never opened; fixtures use private emulator
memory/SRAM. Pixel rendering is disabled for the large mechanical sweep;
native UI checks retain it. Instant text/short delays accelerate presentation
without substituting move or ability routines.

| Check | Result |
| --- | --- |
| Baseline broad sweep | **33344 passed, 4 failed, 0 errors/skips**, all four failures the new Scale Shot reproductions |
| Baseline mixed-cap generator | **356 passed, 8 failed**, all eight Scale Shot/Contrary; no errors/skips |
| Delivery broad sweep | **33734 passed, 2 failed, 0 errors/skips**; both failures were the miss-control RNG setup described below; corrected cases passed separately on the same ROM |
| New focused delivery battle fixtures | **28 passed, zero failures/errors/skips**, after correcting the miss-control RNG |
| Prankster transfer policy controls | **8 passed, zero failures/errors/skips**; preserved intended policy |
| Final combined fixtures 115–119 recheck | **36 passed, zero failures/errors/skips** on the rebuilt delivery debug ROM |
| Delivery damage/oracle/300-use tests | **2596 checks per ROM, zero failures** |
| Delivery interruption/stat/flag/bank/action-origin tests | **104 checks per ROM, zero failures** |
| Ability slot / Hidden Power / appearance storage | **216 combinations, 1325 checks per ROM, zero failures**; PC decode, effective ability lookup, party reorder and redeposit |
| Day-Care ability inheritance | **21 checks per ROM, zero failures**; 820 native calls per ROM |
| Existing exact Gyro Ball checks | **18372 checks per ROM, zero failures** |
| Existing selection/AI checks | **59 checks per ROM, zero failures** |
| Existing native held-item integrity | **190 checks per ROM, zero failures** |
| Real Choice menu / restriction menu | **21 / 48 checks, zero failures** |
| Stale action-context / Imposter entry | Passed, both sides |
| Dynamic-type AI / Metronome priority | **4 / 24 native checks passed** |
| HP item updates / suppression-ending faints | **352 checks, zero failures** |
| Trainer menus / simultaneous KOs / replacements | **6 native chains, 75 checks, zero failures** |
| Retail link RNG routine synchronization | **16384 checks, zero failures** |
| `make audit-static` | **Passed on delivery ROMs** |
| Scoped whitespace / Python syntax checks | Passed |

Routine-only interruption checks stub text, banners, animation and fixed
presentation waits in private ROM memory. Their stat/timer/item/bank routines
execute normally. Full battle fixtures separately exercise native dispatch.
The arithmetic tests do not replace damage routines.
The final rebuilt-ROM arithmetic and interruption reruns again passed
2596 and 104 checks per ROM; receipts are `damage-delivery-recheck.log`
and `interruptions-delivery-recheck.log`. The final combined battle receipt
is `focused-delivery-recheck.log`.

Test-development issues are recorded rather than counted as game bugs:
the first Ghost binding fixtures lacked WRAP's dynamic move ID; adding it to
the fixture's moveset fixed those setup errors. Direct stat tests initially
used the harness-only wPlayerDisabledMove alias and omitted inline text/banner
presentation stubs. The complete native battles did not have those stalls.
Two new miss controls initially used forced_high ($b4), which is below Scale
Shot's accuracy threshold; they were corrected to an explicit $f4 roll.
Their original output is retained in `regressions-initial-controls.log`.
The broad workers loaded those two controls before their correction, so
`broad-delivery.log` also retains the two test-oracle failures. The corrected
28-case run in `regressions-final.log` includes both misses and passes on
the identical seven-fix ROM. The full sweep was not repeated after that
fixture-only correction; it is not represented as an all-green run.

Two intermediate builds hit the full debug Effect Commands bank. Removing
redundant held-flinch work made the final build fit without changing ROM0 or
the cartridge header. The six-fix intermediate broad run was intentionally
stopped when the later Fury Cutter correction superseded it; it is not
reported as a completed pass.

After rejecting the Prankster suspicion, the original policy was restored
and both ROMs rebuilt. Their hashes exactly match the preserved seven-fix
ROMs used by the completed sweep and the final native checks. The temporary
Prankster candidate is not a delivery ROM.

Delivery SHA-256 receipts:

| ROM | SHA-256 |
| --- | --- |
| Release | `b9d60b84eac48d47c722676530afbbf1116fb6406bf7f04af32f78ed59239959` |
| Debug | `0932238a2645d0e1d5812165b2d91bfd95e83bb87b57cdd30d2913569f9b5ecd` |

ROM0 slack remains **97 bytes release / 91 bytes debug**, in small gaps.
The Effect Commands bank has 16 free bytes in release and is full in debug;
future additions should use an overflow bank.
Logs, source-baseline ROMs/symbols and generated cases are under
`.tmpbuild/exhaustive-audit-2026-11-13/`. The catalog can be regenerated with
`python3 tools/audit_battle_inventory.py`. The new arithmetic/interruption
checks and mixed-cap matrix are integrated into `make test-moves-abilities`.

Reproduction commands (run from the repository root with PyBoy/PyYAML and
RGBDS 0.5.2 available):

```sh
make -j8 pokecrystal.gbc pokecrystal_debug.gbc
make audit-static
python3 tools/test_battle_damage_boundaries.py
python3 tools/test_battle_interruption_integrity.py
python3 tools/test_battle_configuration_storage.py
python3 tools/battletest/runner.py --no-render --instant-text --short-delays tools/battletest/tests/115-scale-shot-stat-caps.yaml tools/battletest/tests/116-held-flinch-timing.yaml tools/battletest/tests/117-disable-interrupted-turns.yaml tools/battletest/tests/118-ghost-ai-trapping.yaml tools/battletest/tests/119-prankster-origin-transfer.yaml
python3 tools/battletest/runner.py --no-render --instant-text --short-delays --jobs 8 --all-moves --all-effects --move-semantics --dynamic-type-matrix --all-abilities --ability-matrix --reflection-matrix --class-matrix --textbox-matrix --swagger-matrix --outcome-matrix --item-matrix --reaction-matrix --complex-matrix --long-battles --interactions 1024
```

The reported broad sweep used the debug ROM default. Both-ROM claims in the
table apply to the separately invoked native routine suites; this is not a
claim that the full 33736-case sweep ran twice.
The full command now also selects the eight later Prankster controls,
which were run separately and in the final combined recheck above.

## 8. Unresolved suspicions and limitations

No additional suspicion in this section is a confirmed bug:

- A suspected Prankster defect was rejected after checking the actual
  reference immunity condition. Losing Prankster before a queued action
  executes permits that action to affect Dark targets, despite its retained
  priority; gaining Prankster late grants no original boost. Both the source
  and [reference dispatch](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle-actions.ts)
  require captured origin **and** current Prankster. A temporary candidate
  change was reverted. Fixture `119` and the native action-origin controls
  document the correct behavior; this is not an eighth fixed bug.

- King's Rock's legacy command placement and per-move/per-hit distribution
  need an explicit intended-policy decision before broader modernization.
  This pass fixed its verified action-order defect without changing that policy.
- Duplicate-slot Encore/Disable lookup remains the first-match behavior noted
  in prior audits. No new reproduction established a different required rule.
- Future Sight retains the project's delayed-damage and active-source model;
  this pass did not reinterpret it as modern-generation delayed attacks.
- The formula deliberately applies some offensive modifiers to damage rather
  than rebuilding a modern stat-modifier chain. Differences in rounding alone
  are not evidence of defects in this customized engine.

Actual ROM execution verifies the listed cases and their assertions. Catalog
generation/static tracing does not. No complete campaign, physical cartridge,
full cable-handshake/link battle, or exhaustive human menu sequence was tested.
The routine-level link checks do not certify the cable protocol. General audio,
graphics and unrelated overworld suites were not rerun. Party/PC associations
were checked with the configuration matrix below; trading and evolution were
not exhaustively retested. Those saved structures were not changed.

The new PC configuration checks cover all 18 supported stored type values,
all three legal Seedot ability slots and four appearance combinations. This
does not establish every species' trading/evolution transitions.

The move-by-every-ability Cartesian integrity target was not run: its generic
fixtures cannot establish every meaningful activation. This pass prioritizes
the prepared semantic, class, suppression, reaction, higher-order interaction,
long-battle and boundary suites described above. Additional work should extend
outcome assertions, rather than treat uneventful Cartesian executions as proof.

## 9. Prioritized continuation

1. Specify the intended per-hit policy for legacy added-flinch and Twineedle
   secondary effects, then test miss/Substitute/Shield Dust/Cloak/faint boundaries.
2. Add paired delayed-attack/source-switch and duplicate-move restriction cases
   once the intended rules are explicit.
3. Expand prepared higher-order cases for remaining ability/item activation
   conditions and full state-reset sequences, with both player orientations.
4. Extend legal-species ability/Hidden Power persistence coverage across party
   reorder, PC decode, trading and evolution without changing save layout.
5. Validate selected outcomes through full link sessions and physical hardware.

Reference implementations consulted for uncertain modern interactions:
[Showdown move definitions](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts),
[held-item definitions](https://github.com/smogon/pokemon-showdown/blob/master/data/items.ts)
and [damage dispatch](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle-actions.ts).
Repository custom rules take precedence. For example, Body Press still receives
physical offensive modifiers in the reference dispatch; an initially suspicious
interaction was therefore not changed merely because it uses Defense.
