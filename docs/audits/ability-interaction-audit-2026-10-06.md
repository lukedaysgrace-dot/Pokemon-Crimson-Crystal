# Ability interaction and textbox audit — 2026-10-06

This audit exercises all 171 implemented abilities and all 421 real move
constants. It combines the existing targeted mechanics tests with generated
move, effect, ability, suppression, copying, and mixed-battle scenarios.
Intentional Crimson Crystal balance rules remain the test expectations.

## Gameplay corrections

- Magic Bounce now executes the complete reflected status move through the
  normal battle pipeline. Previously unhandled commands include Leech Seed,
  Disable, Encore, Roar/Whirlwind, Foresight, Mean Look, Spikes, Toxic Spikes,
  Stealth Rock, Sticky Web, Taunt, Torment, Yawn, and Defog's clearing command.
  Reflected effects use the source as their target, respect its immunities,
  preserve PP and scheduled actions, and cannot repeatedly bounce.
- Reflection checks the bouncer's accuracy and the reflected target's
  protection for reflectable status moves. Protect on the original
  Magic Bounce holder blocks protectable moves before reflection. Hazards,
  Mean Look, Roar, and Whirlwind bypass Protect. Prankster's Dark immunity
  no longer preempts reflection; reflected moves lose
  the original user's Prankster boost.
- Reflected forced switching now bypasses the original move-order gate and
  restores the original battle turn even when the switch routine changes it.
  A two-turn regression verifies that the replacement uses its own move and
  PP normally on the following turn.
- Yawn's delayed sleep cannot be bounced a second time. Drowsiness and sleep
  occur on separate turns, including when both battlers have Magic Bounce.
- Taunt and Torment bypass Substitute. Leech Seed and Yawn still respect the
  reflected target's Substitute and their other protections.
- Neutralizing Gas no longer suppresses Disguise. Disguise's intentionally
  older first-hit damage behavior remains intact.
- Skill Swap now always hits eligible targets despite accuracy/evasion,
  Wonder Skin, and BrightPowder. Protect, semi-invulnerability, and applicable
  priority blockers still stop it; Substitute does not.
- Swagger's Attack raise and confusion both respect Substitute. Reflection
  keeps both effects on the reflected target. A dedicated targeted boost
  command resolves Contrary from the attacker's perspective, so Mold Breaker
  bypasses the recipient's Contrary in both battle directions. Self boosts
  continue to obey the holder's own Contrary.
- Swagger can still confuse when the Attack raise is capped. The cap message
  no longer ends the whole move before confusion is processed. Contrary's
  lower cap and real misses/protection remain separate outcomes.

Modern interaction references were checked against Pokémon Showdown's
[ability implementation](https://raw.githubusercontent.com/smogon/pokemon-showdown/master/data/abilities.ts),
[move implementation](https://raw.githubusercontent.com/smogon/pokemon-showdown/master/data/moves.ts),
and [hit-resolution order](https://raw.githubusercontent.com/smogon/pokemon-showdown/master/sim/battle-actions.ts).
The project's documented differences take precedence over those references.

The Protect ordering above was corrected during the sixth pass. The earlier
commit and its regression fixture incorrectly expected Taunt to reflect
through the holder's Protect. Showdown's Protect hit callback has priority 3;
Magic Bounce's has priority 1. Protect's move priority is a separate value.

## Textbox coverage

`tools/audit_ability_text.py` checks ability banners, descriptions, and battle
messages with expanded text fragments and maximum nickname, ability, move,
and item widths. All **574 banner/text fragments pass** the width checks.

The battle runner now hooks the actual glyph-writing routine while textbox
text is being printed. A glyph written outside either 18-cell interior line
fails the case. This catches expanded `<USER>`, `<TARGET>`, and `text_ram`
strings, including text that scrolls away before the final screenshot.
The added `.done` symbol in the text engine is only a hook boundary and adds
no ROM instruction.

## Test improvements and fixture corrections

`--all-abilities` adds **853 scenarios**: both battle sides for every ability,
Neutralizing Gas equivalence to no-ability controls where suppression is
permitted, and Trace's copying restrictions for every ability. Existing YAML
tests mention every implemented ability and supply specific mechanics checks.

The effect generator now derives the declared effect set instead of relying
on an obsolete count of 202. It covers all **205 effects**, including additional
assertions for the combined defense drop, Incinerate, and Sucker Punch.
`make test-all` includes the expanded text audit and the every-ability sweep.

Eight existing failures came from stale or incomplete fixtures: damage
expectations predating the current Lick power, a berry holder that fainted
before its intended assertion, a capped Counter knockout, a binding fixture
without a runtime trapping move, and an Attract fixture with incompatible
sexes. These now exercise their intended mechanics. The runner supports
`{move: WRAP}` for WRAM fixtures that need runtime move IDs.

The initial broad baseline finished with **1,816 passes, eight fixture
failures, and no errors or skipped cases**. After correction, the affected
186-case batch passed. The initial every-ability sweep passed all 855 cases;
the final sweep excludes the two Gas-suppression scenarios invalidated by
Disguise's corrected unsuppressible flag.

## Intentional rules preserved

Filter, Solid Rock, older Gale Wings, custom Flash Fire, older Disguise damage,
Mega Sol, Frostbite, and the project's Poison Puppeteer behavior were not
rebalanced to match the external reference. No species ability assignments
or move balance tables were changed.

## Initial validation

- Expanded ability text: **574 fragments passed**.
- Broad ROM suite: **1,859 passed, zero failures/errors/skips** in 1,255.4 s:
  1,105 targeted YAML cases, 421 move executions, 205 effect assertions, and
  128 mixed-battle stress cases.
- Game data: **44,865 invariant checks passed**.
- Linked resources/audio: **4,670 checks passed**, including release/debug
  bank and asset checks.
- Every-ability sweep: **853 passed, zero failures/errors/skips** in 766.6 s.
- Final Prankster/Dark follow-up plus related targeting, AI, Disguise, and
  reflection regressions: **76 passed, zero failures/errors/skips**.
- Debug and playable release ROMs build successfully with RGBDS 0.5.2.

The broad suite and ability sweep cover **2,712 cases**. The three additional
Prankster/Dark cases bring the distinct tested cases to **2,715**; the 76-case
follow-up also repeats the related targeting and AI regressions on that final
ordering correction. No runtime textbox violations were detected in the
passing runs.

The playable output is `pokecrystal.gbc`. Local run transcripts are in the
ignored `.venv/ability-*.log` files; permanent regression cases and audit
scripts are retained under `tools/`.

## Reproduce

```sh
make debug
python3 tools/audit_game_data.py
python3 tools/audit_ability_text.py
python3 tools/battletest/runner.py --all-moves --all-effects --interactions 128
python3 tools/battletest/runner.py --all-abilities -k "Ability sweep"
python3 tools/battletest/runner.py tools/battletest/tests/46-new-ability-edge-cases.yaml tools/battletest/tests/61-audit-ai-2026-10-01.yaml tools/battletest/tests/68-ability-interactions-2026-10-06.yaml tools/battletest/tests/69-magic-bounce-regressions.yaml
make
```

Tests run in the actual debug ROM through headless PyBoy, with deterministic
RNG for assertions and mixed scenarios for state-transition checks. All move
smoke tests establish execution; the targeted YAML and effect tests establish
specific outcomes. This is broad coverage, not an enumeration of every
ability × move × opposing ability combination or proof that no bug can exist.

## Extended coverage

The follow-up adds permanent generators and assertions rather than simply
repeating the original battles:

- `--ability-matrix`: 4,959 cases. Every ability faces twelve common move
  classes; Gas suppression compares both battlers' HP, status, stages, PP,
  items, screens, substatus, and weather with no-ability controls. Mold Breaker
  compares direct hit and stat-drop behavior for ignorable abilities. Skill
  Swap and Transform test every ability's transfer restrictions.
- `--class-matrix`: 340 paired cases for every implemented punch, slice,
  pulse, bite, ball/bomb, wind, and sound move. Boosts, immunities, suppression,
  bypass, and a nonmember Tackle control are asserted.
- `--reflection-matrix`: 84 cases spanning fourteen status moves, original
  accuracy reduction, Protect, both Substitutes, and Prankster/Dark targets.
  Additional YAML checks cover Contrary, Clear Body, Mirror Armor, Defiant,
  Competitive, Own Tempo, Synchronize, two bouncers, and Swagger boundaries.
- `--textbox-matrix`: 763 scenarios repeat every move and both sides of every
  ability with ten-character nicknames. Move cases use trainer battles for
  the longest enemy-name prefix. Glyph boundaries are monitored as text is
  written, including messages that scroll away.
- `--swagger-matrix`: 117 cases test every Attack stage with ordinary, Mold
  Breaker, and Gas sources against no ability, Contrary, and Own Tempo.
  The Own Tempo/Mold Breaker cases assert that confusion is inflicted and
  subsequently cured, using both actual textbox templates; a final status
  check alone cannot distinguish a blocked effect from a later cure.
- The mixed-battle sweep expands to 1,024 deterministic scenarios and adds
  HP bounds, seven valid stat stages per side, sleep/other-status exclusivity, and
  cleared ability execution guards.

`make test-deep` reproduces the combined ordinary and extended suites.

The deeper rebuild also exposed the other incomplete binding fixture: it
set a binding timer without a runtime trapping move. Both fixtures now load
Wrap and assert its displayed name as well as the damage/timer mechanics.

The broader `make audit-static` target has an unrelated existing failure in
`audit_learnset_variety.py`: its old review snapshot expects Bug Bite TM/tutor
compatibility that the current source omits for 91 species, starting with
Bulbasaur. The compatibility data, review snapshot, and that audit script are
unchanged by this work. Species compatibility has not been restored simply
to satisfy an older snapshot. The remaining independent static audits run
separately so this failure does not hide their results.

## Extended validation results

The completed batches cover **9,900 planned scenarios**, an increase of
**7,185** over the initial 2,715-case pass. Each scenario has a passing result
after repairs; the coverage check matches the ordered fixtures to the actual
ROM test logs. Repeated display names are distinguished by their fixture
position rather than counted as missing or silently merged.

| Suite | Passing scenarios |
| --- | ---: |
| Targeted YAML regressions | 1,134 |
| Every move execution | 421 |
| Effect assertions | 205 |
| Every-ability sweep | 853 |
| Every ability against common move classes | 2,064 |
| Gas suppression with paired controls | 2,040 |
| Mold Breaker with paired controls | 513 |
| Skill Swap and Transform restrictions | 342 |
| Reflection matrix | 84 |
| Classified move interaction matrix | 340 |
| Maximum-name textbox matrix | 763 |
| Swagger stage matrix | 117 |
| Mixed battles | 1,024 |
| **Total** | **9,900** |

These results were gathered in separate batches. The broad run completed all
YAML, move, and effect cases before it was stopped to avoid repeating the
remaining stress and ability phases already running separately. Its one
incomplete binding fixture was corrected and passed the subsequent reruns.
The final **284-case** focused run rechecked the affected gameplay, binding,
reflection, and Swagger paths after the last fix: **284 passed, zero
failures/errors/skips**. Other completed batches test paths unchanged by that
last Swagger cap correction. The final Gas batch passed all 2,040 cases and
the final every-ability batch passed all 853 cases.

No runtime textbox boundary violations were detected in the passing runs.
The final static checks passed 44,865 game-data invariants, 574 expanded
ability-text fragments, the 421-move/213-command dispatch audit, and 4,670
linked-resource/audio checks. Trainer, save-data, and overworld icon audits
also passed. The unrelated Bug Bite review-snapshot failure above remains
flagged.

The updated debug and playable release ROMs build successfully. The playable
output is `pokecrystal.gbc`; extended logs and the coverage reconciliation are
in the ignored `.venv/deep-*.log` files and `.venv/deep-coverage.json`.

This establishes the tested outcomes and state invariants across extensive
coverage. It does not exhaust every possible battle state, party, item,
ability, and move combination.

## Third pass: move outcomes, items, long battles, and retail paths

The third pass adds **8,981 passing battle scenarios** to the prior 9,900,
bringing cumulative reconciled coverage to **18,881 scenarios**, with no
missing cases. Repeated reruns are not added to that total.

| Additional suite | Scenarios |
| --- | ---: |
| Typed absorption/immunity with ordinary, Mold Breaker, and Gas controls | 1,560 |
| Pure stat moves at every stage boundary, both sides, with Contrary | 1,768 |
| Observable secondary effects with Sheer Force/Shield Dust/bypass controls | 516 |
| Klutz/Life Orb and Magic Guard/contact/held-item outcomes | 2,042 |
| Stamina/Weak Armor/Justified/Rattled/Thermal Exchange incoming-hit outcomes | 2,511 |
| All 171 abilities in longer passive battles, both sides | 342 |
| Repeated switching with entry/exit abilities and Gas | 24 |
| Longer mixed battles with per-turn invariants | 192 |
| Explosion/Gas timing and Ripen/berry regressions | 26 |
| **Additional total** | **8,981** |

Long cases request 16, 24, or 32 turns. Mixed battles may legitimately finish
early when a team is knocked out; repeated-switch fixtures explicitly require
all 24 turns. Completed turns check HP and stat bounds, status consistency,
and cleared ability-presentation/reflection guards. Longer action scripts are
streamed into the paused ROM instead of silently repeating its eighth slot.
Filtered tests retain every paired control required by their assertions.
Harness timing uses a monotonic clock to withstand Windows/WSL clock adjustments.

### Additional gameplay fix

Neutralizing Gas ended too early during Explosion/Self-Destruct. The core
sets the user's HP to zero before applying the hit, so the ability getter
allowed the defender's Stamina or Weak Armor to react while the hit was still
resolving. A temporary side-specific marker now preserves Gas through that
hit, its reactions, and immediate berry handling, then clears before subsequent
faint/entry processing. The berry extension fixes Ripen doubling a Berry's
healing during a Gas explosion; paired controls reproduced the premature
doubling on both sides before the fix.
Move completion and switch-in also clear the marker, covering missed or
protected explosions. Tests cover both battle directions, Damp, Protect,
next-turn reactions, and Drizzle resuming after the actual Gas holder faints.

Berry checks use this game's ordinary 10-HP Berry healing and compare Ripen
against an otherwise identical ordinary-ability control. Gas must preserve
the ordinary healing amount during the hit, while ordinary Ripen doubles it.
The reference's [berry update/healing events](https://github.com/smogon/pokemon-showdown/blob/master/data/items.ts)
and [Ripen events](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts)
confirm that these immediate events precede completion of the queued faint.

The expected timing was checked against the simulator's queued fainting and
hit-event order: [move-hit sequence](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle-actions.ts),
[ability suppression](https://github.com/smogon/pokemon-showdown/blob/master/sim/pokemon.ts),
and [faint processing](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle.ts).
This correction preserves the previously listed intentional custom mechanics,
including Filter, older Gale Wings, Flash Fire, and Disguise.

Fixture repairs preserve the actual game rules: an inactive Life Orb remains
a held item for Acrobatics; Knock Off controls must account for its held-item
damage bonus; probability fixtures must populate move structures; and Tower
battles must start with the saved party that the real frontend creates.
Gas/Drizzle faint-reactivation tests use legal ability holders so their entry
state is established before combat. Earlier invalid fixtures are superseded
by the corrected passing reruns, rather than accepted as gameplay evidence.

### Additional runtime checks

| Check | Verified coverage |
| --- | ---: |
| Secondary/critical probability thresholds | 172 configurations, 44,032 RNG-byte outcomes |
| Normal battle/party menus with animations enabled | 12 scenarios, 44 assertions |
| Actual Tower roster loader, conversion, PP and stat refill | All 321 builds, 23,299 checks |
| Tower battle wrapper: seven wins, one loss, forced party selection/restoration | 8 battles, 104 checks |
| Two emulator instances using the retail link RNG stream | 32 seeds, 16,384 synchrony checks |

These separate checks all passed on the final rebuilt ROM. Routine-level
assertions are counted separately from battle scenarios. No runtime textbox
boundary violations were recorded in the accepted runs, and representative
normal move/party-menu screenshots were visually inspected.

`make test-complete` reproduces the expanded battle suites and the separate
runtime scripts. Per-case coverage reconciliation and final ROM SHA-256
hashes are saved in `.venv/full-coverage.json` and
`.venv/full-coverage-cases.json`; detailed logs use `.venv/full-*.log`.

The final broad YAML rerun recorded 1,150 passes and two failures from the
post-entry Gas/Drizzle fixtures described above. Those two fixtures were
corrected to use legal holders, and the complete 26-case explosion/berry regression
file then passed. All 1,160 permanent YAML scenarios therefore have accepted
passing results on the final ROM. The separate probability/menu/Tower/link
checks above were also rerun after the final rebuild.

The broad Gas outcome/reaction rerun passed all 1,530 cases after the initial
explosion correction. After extending the marker through berry handling, the
final focused batches passed 26 timing/berry cases, 38 Explosion cases, and
15 Self-Destruct cases, with no failures, errors, or skips. These rerun counts
include repeats and are not added to the 18,881 unique-scenario total. Final
probability, menu, Tower, link-RNG, game-data, ability-text, move, save-layout,
and resource checks all passed after that last build as well.

Playable ROM SHA-256:
`b3e90ceef27f144c7efc8234715b7dbab2dbaa1430cabf5ad3d91eba4667e8bd`.

### Third-pass static checks and practical limits

The rebuilt ROM passes 44,865 game-data invariants, 574 expanded ability-text
fragments, the 421-move/213-command audit, 185 save-layout/recovery checks,
4,670 linked-resource/audio checks, trainer data, overworld mon icons, and map
sprite checks. At the end of the third pass, `make audit-static` still stopped at the Bug Bite
compatibility review mismatch. Running the remaining audits independently
also reported an Olivine outdoor-group issue: missing
`SPRITE_COOLTRAINER_F`, `SPRITE_COOLTRAINER_M`, and `SPRITE_TEACHER` entries.
Those two reports were investigated and resolved in the fourth pass below.

The link checks do not emulate the physical cable handshake or a complete
two-player battle. Tower wins use overleveled fixtures to exercise the actual
battle/restoration wrapper; they do not prove the level-selection frontend or
reward script. Probability enumeration proves the implemented thresholds,
not hardware RNG distribution. Passing these suites establishes their tested
outcomes, not the absence of every conceivable bug or exhaustive coverage of
every possible party/move/item/ability state.

## Fourth pass: complex chains, native visual checks, and the two audit failures

Added 1,564 named battle scenarios: 1,008 targeted multi-hit combinations,
512 new mixed battles, and 44 permanent exact-outcome chain regressions.
Together with the earlier accepted cases, the cumulative total is **20,445
named battle scenarios**. This counts individual test cases and paired
controls; it is not a count of every distinct possible battle configuration.
Reruns and the separate native visual/routine checks are excluded from that
total. All new cases passed without failures, errors, skips, or glyph-overflow
events. No additional gameplay correction was needed in this pass.

| Added check | Accepted results |
| --- | --- |
| Parental Bond / Skill Link combinations | 1,008 scenarios |
| New mixed battles, with checks after each completed turn | 512 scenarios |
| Exact berry healing and ability-transfer/switch chains | 44 scenarios |
| Native battle visual settings matrix | 120 scenarios, 912 assertions |
| Fishing cove map, roster, and actual sprite allocation | 12 views, 216 checks |
| Fishing cove allocation model | 463 visitor/contest rosters, zero risks |

The targeted matrix combines seven attacks, both battle directions, six
defender abilities (No Ability, Stamina, Weak Armor, Ripen, Contrary, Klutz),
four defender items (No Item, Berry, Weakness Policy, Rocky Helmet), and three
attacker items (No Item, Life Orb, Choice Specs). Assertions cover exact hit
counts and stat stages, item consumption, and contact/Life Orb recoil. The
berry controls additionally verify the exact healing amount under Ripen and
Klutz. Multi-turn Skill Swap cases check abilities, HP, PP, hit counts, and
Gas cleanup after swapping again or switching out through Weezing and back.
Modern reference outcomes were checked against the primary
[Pokémon Showdown ability implementation](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts)
and [held-item implementation](https://github.com/smogon/pokemon-showdown/blob/master/data/items.ts).
Intentional Crimson Crystal rules remain unchanged.

The new mixed cases use a different deterministic seed and scripts requesting
up to 12 turns, including switches and extra held items. Fainting can end a
battle sooner. These cases assert HP/status/stat boundaries and presentation
cleanup after each completed turn; they do not provide an independent full
outcome oracle for every randomly selected move.

The visual matrix uses native button-driven battle menus with debug auto
actions disabled: all 20 textbox frames, text speeds 1/3/5, and battle scenes
on/off. Five interactions cover reflected Swagger, Gas disabling reflection,
Mold Breaker versus Contrary, Skill Swap versus Pressure, and Stamina on
contact. Both battlers have maximum ten-character nicknames. The final run
saved 1,128 live-banner, live-text, completed-message, and restored-menu
captures. Contact sheets were inspected across all frames for completed
messages, active banners, and restored menus. No overflow, corrupt graphics,
or residual banner was found. The earlier all-move/all-ability text tests
remain relevant to the identical ROM build.

Both unrelated failures were audit false positives:

- The learnset review predates commit `f96557e98c8cc64284836ab8abc31e82248371dc`,
  which deliberately replaced the Bug Bite TM with Fury Cutter and removed
  Scyther's level-25 Bug Bite. The audit now recognizes those explicit changes
  and still requires all other reviewed moves/compatibility. A positive run
  and three negative probes verify that unrelated level-up losses, unrelated
  TM losses, and loss of Fury Cutter replacement compatibility are rejected.
  No learnset or TM balance data was changed.
- The fishing cove already uses its changing map objects for sprite
  allocation, through the special branch in `AddMapSprites`; it does not use
  the shared Olivine outdoor list. The audit now follows that branch and checks
  every possible five-candidate roster plus ordinary visitors. Native map
  checks verify the exact roster sprites and their actual allocation at four
  viewpoints in visitor and two contest states. The initially proposed
  outdoor-list changes were reverted after checking the runtime behavior.

The rebuilt release and debug ROMs are byte-identical to the final third-pass
ROMs. `make audit-static` now completes successfully, including both repaired
audits. The final expanded guardrails in those scripts also pass. Filter,
older Gale Wings, and all other intentional balance choices were preserved.
The cable-battle, Tower frontend/reward, and probability-distribution limits
described above still apply.

Reproduce this pass with `make test-complex` after building the debug ROM.
It includes the two repaired audits, all 1,564 added battle scenarios, and
the native battle/cove visual checks. `make test-complete` includes this pass
alongside the earlier suites. Emulator logs and coverage accounting are in
`.venv/fourth-*.log` and `.venv/fourth-coverage.json`; visual captures are in
`.venv/visual-matrix/` and `.venv/cove-ui/`.

## Fifth pass: lifecycle chains and persistent gameplay session

Added 32 legal-holder Gas/faint/replacement/Trace/weather/item chains and 18
pre-move entry-item cases. All pass, bringing cumulative named battle coverage
to 20,495. The prior generated suites were not all rerun after the latest fix.

The native session found a real timing gap: a low-HP incoming Pokémon's HP
Berry was only checked after damage/end-of-turn processing. Entry now checks
the incoming holder's HP item after entry abilities and Gas reactivation.
Trace into Ripen/Klutz resolves before healing/suppression; the opponent waits
for its own initial entry processing. Berry Juice, Gluttony, Filter, older
Gale Wings, and the intentional custom rules retain their existing behavior.
The timing reference is the contemporary update event after switching in
[Showdown's battle flow](https://github.com/smogon/pokemon-showdown/blob/master/sim/battle.ts)
and the HP threshold update handler in its
[item implementation](https://github.com/smogon/pokemon-showdown/blob/master/data/items.ts).

All 1,254 permanent cases were verified against the rebuilt ROM. Twenty-one
older fixture assumptions were corrected and retested: exact totals include
entry healing, Unnerve uses legal holders on entry, and multi-hit Berry tests
start at 51% HP so attacks trigger consumption. The retest groups passed
110, four, and 44 cases respectively. All 252 affected generated multi-hit
Berry combinations also pass (four shards of 63).

Eight consecutive native-menu wild battles use one legal party without any
fixture reset, debug auto actions, or debug party restoration. All 179 checks
pass: HP/PP/item and permanent-ability persistence, faint cleanup, manual
switching into Drizzle, text bounds, eight map reloads, healing, and three
exact Pokémon-data SRAM save/reloads. Entry and overworld captures were
inspected. Encounters are staged and native routines are invoked by the driver;
this is not a story playthrough or a full save-menu/power-cycle test.

Both ROM variants build and static audits pass. Current release SHA256 is
`7483a330de25cb30bbef4d633f070c9af7f5a86199c96ddbf16fcb60a2d016dd`;
debug is `1893b730f44ced14c96602fb79fdea7d531cb6a652f61939d40ff9dbb82d5645`.
Run `make test-session` for the focused lifecycle/entry/native checks.
Logs are `.venv/fifth-*.log`; captures are `.venv/gameplay-session/`.
The remaining coverage gaps and exact resume commands are detailed in
`ABILITY-TESTING-HANDOFF-2026-10-06.md`.

## Sixth pass: review corrections and item-update timing

The code review correctly questioned Protect: Showdown's
[Protect callback](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts)
has `onTryHitPriority: 3`, while
[Magic Bounce](https://github.com/smogon/pokemon-showdown/blob/master/data/abilities.ts)
has priority 1. This is callback order, separate from Protect's move priority.
The ROM now blocks protectable status moves before reflection. Hazards,
Mean Look, Roar, and Whirlwind retain Protect bypass, with regression controls.
The generated reflection matrix expects the corrected rule.

Obsolete per-status/stat-drop Magic Bounce handlers, substitute exemptions,
and the original-hit shortcut have been removed. A narrow Mean Look exemption
remains necessary in the earlier Prankster targeting check. The reflection
hook runs once immediately after the original action commands; later script
perspective changes cannot accidentally inspect the opponent's selected move.
Damaging move commands skip both reflection far calls.

Trace now reruns only the copied entry ability; the outer entry invocation
performs Gas cleanup and item checks once. Skill Swap resolves both entry
abilities, including Trace, before checking either holder's HP item.

New checkpoints inspect state before the next native action. They exposed an
existing holder's Berry waiting until turn end after Gas/Unnerve switched out.
Entry, move completion, and faint updates now check eligible live holders in
effective Speed order, retaining the committed Gas-explosion marker through
hit-time berries. Empty/single-item update events do not advance battle/link
RNG; only a genuine tie between two eligible holders requires a tie roll.

Role Play, Entrainment, Gastro Acid, Worry Seed, Simple Beam, and contact
ability transfers are absent from the implemented move/ability set. Their
animation assets do not establish an implemented mechanic. The handoff's
earlier checklist was broader than the current ROM's scope.

Both ROMs build and static audits pass. The final focused run passes 258
battles, including eight additional Protect/reflection regressions and 56
new item-timing cases. Forty native item-update scenarios and 24 faint-update
battles pass 352 exact healing/order/perspective/link-RNG/cleanup assertions.
Six native trainer chains pass 75 checks for Set/Shift, cancellation, forced
replacement after a faint, double KOs, delayed Trace/weather, and no reserves.
Three native wild endings pass 21 checks for escape, Arena Trap, and capture
through the Bag. Native Save, fresh emulator boot, Continue, map return, and
walking pass 23 checks, including exact party data and expected roaming-map
bookkeeping. Test fixtures use private SRAM.

The complete final-ROM generated sweep passes all 20,559 battle cases, with
zero failures, errors, or skips in eight isolated workers. Paired controls
and dependent assertions remain together. `make test-complete` finishes with
exit status 0. Every ancillary suite also passes:

| Suite | Final-ROM coverage | Failures |
| --- | --- | --- |
| Probability thresholds | 172 groups, 44,032 outcomes | 0 |
| Native battle UI | 12 scenarios, 44 assertions | 0 |
| Visual matrix | 120 scenarios, 912 assertions, 1,128 captures | 0 |
| Cove sprites | 12 views, 216 allocation checks | 0 |
| Tower roster | All 321 builds, 23,299 checks | 0 |
| Tower battles | Eight battles, 104 checks | 0 |
| Retail link RNG | 32 seeds, 16,384 synchrony checks | 0 |
| Persistent native session | Eight consecutive battles, 179 checks | 0 |

The new standalone checks were added during that run and verified separately
on the same ROM; future complete/session targets include them.

Current release SHA256 is
`f5476ee4ff8a76eb609c4286bc6afbfda04defedbc88d8fa5d5c6550122d1430`;
debug is `04a23c7a97e7d907a1c76555d9ac86aa3c4e94d565d32356091137111de8c254`.
Logs are under `.tmpbuild/ability-audit/`; full worker logs are under
`.tmpbuild/battletest-1a3316f34362-1791330588812600429/`. Longer story gameplay,
full cable battles, Tower frontend/rewards, and hardware RNG distribution
remain coverage gaps. The current backlog is in the sibling handoff document.
