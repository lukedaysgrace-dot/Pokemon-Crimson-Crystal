# Follow-up review of the November 12 audit

Status: complete. All nine fixes in commit `69ea0f80` ("move/ability audit
fixes, small scenario cases") were verified and are correct. One further
defect was found and fixed. Both ROMs build; validation results are at the end.

Scope: an independent review of `reports/bug-audit-2026-11-12.md` and its
commit, then a focused audit of held-item lifecycle and suppression,
switching and fainting during reactions, and called moves. The previous
report was treated as a set of claims to check.

## How this review was run

The work was done in an isolated copy, not in the shared working tree.

- The previous audit is no longer uncommitted: the working tree at review
  time was clean at `69ea0f80`, whose parent is the stated starting revision
  `7ea05c04`. Only the two `Zone.Identifier` files and the prompt file were
  untracked. `audio/ded/axew.ded` showed no modification from this
  environment; it was not touched.
- Source came from `git archive 69ea0f80`. RGBDS 0.5.2 was built from the
  upstream release tarball, because the copies tracked under `rgbds/` do not
  run (the `.gitattributes` comment already records that they were committed
  damaged).
- Four trees were built (the last after the requested Knock Off change): the pre-audit engine (the commit's `engine/` diff
  reversed), the commit itself, and the commit plus this review's fix.

| Build | Release SHA-256 | Debug SHA-256 |
| --- | --- | --- |
| Pre-audit engine (`7ea05c04` engine files) | not built | `fb9f717d90f5de2a17c5622f6fab49a3791c7635a4c499a778d817fa02ff6d6b` |
| `69ea0f80` (reviewed commit) | `a82fdca13e8f7f64d466690533ac868fb6507fc9e1f4f2b57d744bcdc3c0a2e9` | `d58d6c0870e8a6cbf084ffdee1cf624537af476aa299074d499286b6b838730b` |
| Review build (Yawn/Taunt fix only) | `0d6dd29a90ca2329228123a68d16fe788379672349d3ef3b9bd1bb400a14fa61` | `12b2a21628420c8c5b11b5971ff7e7b3ba2460560905102a19757e32ca8d6ecf` |
| Final build (plus the Knock Off change) | `390a429534c20add00386c867304cb1787c5d7ae4876f99ca7166d3c32ca12c4` | `d00102c273dd13eb314305aac5b42b80b1c3d2a36934902be3e1790e833f4e0c` |

The second row reproduces, byte for byte, the two ROMs in the repository and
the hashes in the previous report. That also shows the source used here is
the source those ROMs were built from.

The previous report could not offer a clean baseline (its pre-fix ROMs were
stale). This review has one: on the pre-audit debug ROM the previous audit's
45 cases give 17 passed and 28 failed; on `69ea0f80` they give 45 passed.

## Assessment of the nine previous fixes

All nine are correct as written. None is regressive and none rests on an
unresolved rule. "Added here" lists assertions the original cases did not
make; they are in `tools/battletest/tests/105-followup-audit-2026-11-12.yaml`
and pass on `69ea0f80` unless noted.

| Fix | Verdict | What was checked | Added here |
| --- | --- | --- | --- |
| A. Baneful Bunker and the guard counter | Correct | All three selection paths preserve the counter; item use, switching, locked-in moves and a failed attempt reset it. `ProtectChance` owns the increment and the reset on failure. | A failed Bunker resets the chance for the next one; switching out and back resets it. |
| B. Baton Pass and the incoming mon's bad poison | Correct | The second `ToxicRestore*` call also zeroes Taunt and Yawn counters, which are not passed anyway. The stale-bit path clears history for a cured replacement. | Ordinary poison stays ordinary; a healthy replacement stays healthy; a stale history bit is dropped. Both sides. |
| C. Disable and PP-Up bits | Correct | Every other PP-zero test in the battle engine already masks with `PP_MASK` (one AI heuristic does not; see hypotheses). | Raw PP `$80` and `$C0` are rejected on both sides; `$C1` is accepted. |
| D. Non-Ghost Curse cap check | Correct | Matches the simulator rule: the move fails only when no boost can apply. Uses the effective ability, so Neutralizing Gas is respected. | Minimum Speed still allows the two raises. |
| E. Contrary Curse and Speed | Correct | The drop is recognised as self-inflicted through the `savemiss` scope after `switchturn`, so Mist, Substitute, Clear Body and Defiant are not involved. The stale-marker suspicion is unfounded: `RaiseStatWithoutContrary` overwrites `wLoweredStat` before any exit, including the capped one. | Recalculated Attack, Defense and Speed values for normal and Contrary users; own Mist and Substitute; Clear Body; Defiant on either side. |
| F. Poison Touch and Covert Cloak | Correct | Uses the effective item, so Klutz disables the Cloak without removing it. The Cloak check precedes the roll, so a blocked hit draws no RNG, as in the simulator. | No contact, Substitute and Neutralizing Gas controls on both sides. |
| G. Delayed Yawn and Mold Breaker | Correct | `AbilityPreventsSleepResidual` reads the unignored ability, preserves the status pointer, and falls into the shared Leaf Guard weather test. | Neutralizing Gas still suppresses Leaf Guard at resolution; a status gained while drowsy cancels the sleep. |
| H. Safeguard raised after Yawn | Correct | Matches the simulator: Safeguard blocks the drowsiness, and explicitly not the later sleep. | None needed. |
| I. `UpdateStorageBoxMonFromTemp` with slot 0 | Correct, P3 as classified | Returns NZ before any write. No UI path was found that reaches it unloaded. | None needed. |

Other changes in the commit:

- `tools/test_trainer_portraits.py`: the exemption is narrow. It requires
  that Agatha and Will have *no* dialogue use, that both assets still exist,
  and that every other portrait is used. It cannot hide a missing active
  portrait. Ten checks pass.
- Generated files: a full build of the commit leaves `git status` clean, so
  `data/maps/portrait_texts.asm` and the Entei tables are consistent with
  their generators.

Test-quality note: on the pre-audit ROM, 12 of this review's 45 added cases
fail (the five new-defect cases, Contrary Curse stats, four PP-Up Disable
values and the failed-Bunker reset). The other 33 are controls that pass on
all three builds.

## Confirmed defect, fixed

### Pending Yawn and Taunt acted on a slot that had already fainted

- Severity: P3. Wrong text and animation, one wasted random roll, and a
  sleep status written to a fainted party record. No lasting gameplay effect
  was found.
- Where: `HandleNewEndTurnEffects_Core`,
  `engine/battle/move_effects/new_move_cores.asm:1721` (`.taunt_player` 1743,
  `.taunt_enemy` 1761, `.yawn_player` 1780, `.yawn_enemy` 1802).
- Reproduce (`69ea0f80` debug ROM): Magikarp at 2 HP with
  `wPlayerYawnCount = 1`, a second party member, sandstorm. Either side.
- Expected: the sandstorm knocks Magikarp out and nothing else happens to it.
- Actual: after it fainted, the sleep animation played and "fell asleep!"
  was printed for the empty slot. A sleep roll was drawn. On the enemy side
  the fainted party record kept a sleep counter (`wOTPartyMon1Status = 4`).
  A Taunt that ran out the same turn printed "shook off the taunt!" for the
  fainted mon.
- Cause: `HandleBetweenTurnEffects` deliberately keeps a fainted slot empty
  until every residual phase has finished. The Wish handler next to these
  two checks HP for that reason; Taunt and Yawn did not.
- Fix: each of the four branches returns when the battler's HP is zero. The
  counter is still decremented, so the Taunt expires silently.
- Coverage: ten cases in the new file, both sides: Yawn and Taunt on a
  fainted slot, living controls that must still sleep and still print the
  message, and a seeded pair showing no extra random draw.
- Evidence: on `69ea0f80` exactly these five fail (the other five are
  controls); on the final build all 45 pass.
- Why earlier coverage missed it: every Yawn and Taunt case ended with the
  target alive. The Cartesian and mixed runs can reach the state, but they
  assert bounds and integrity, and the mon is replaced by the time they look.

## Coverage added without a defect

`tools/battletest/choice_lock_menu_checks.py` (21 checks) drives the real
Fight menu to test the player's Choice lock, with no-item, enemy-item and
Klutz controls. It exists because of the first harness issue below. It
passes on `69ea0f80` and on the final build.

## What the follow-up audit covered

About 300 native probe battles were written against the simulator's rules
and run on the debug ROM. Apart from the defect above, all matched or fell
under the lists below.

- Item history: Recycle after Knock Off, Thief, Incinerate; Focus Sash,
  Weakness Policy, Power Herb, Throat Spray and Gold Berry restored; history
  per party slot across switches; no inheritance by an enemy replacement;
  Harvest not restoring a knocked-off Berry or a predecessor's Berry;
  battle and party item records after consumption and Knock Off.
- Suppression: Klutz with Rocky Helmet, Focus Sash, Life Orb, Weakness
  Policy, White Herb, Leftovers, Toxic Orb and Air Balloon; a Klutz holder's
  item can still be knocked off or stolen; a Klutz user can still steal.
- Switching and fainting: U-turn with Life Orb, Static, Rocky Helmet,
  Tangling Hair, Pickpocket and Rough Skin, each landing on the outgoing mon
  only; volatile state, counters and bad poison not carried by a pivot;
  Volt Switch against an absorber or immunity; multi-hit moves against
  Stamina, Weak Armor, Rocky Helmet and Berserk, including the attacker
  fainting between hits; reactions when the holder is knocked out.
- End of turn: every residual handler against a slot that fainted to weather
  (Leftovers, orbs, Perish Song, Future Sight, Speed Boost, Harvest, Bad
  Dreams, Leech Seed in both roles, Nightmare, Curse, Shed Skin, Mystery
  Berry, Dry Skin, binding). Only Yawn and Taunt misbehaved.
- Called moves: PP, last-move history, Disable and Encore against Sleep
  Talk, Metronome and Mirror Move users; Choice lock with Metronome.

## Unconfirmed hypotheses and rule questions (not changed)

- A Sleep Talk, Metronome or Mirror Move user has no "last move". The Gen 2
  flow clears it and the called move does not record one. Consequences:
  Disable fails against such a user (modern games disable the calling move)
  and Torment does not stop it from repeating the calling move. Encore
  failing against them does match modern rules. Changing this would touch
  Encore, Mirror Move, Conversion2 and the AI, so it is a design decision.
- The Choice lock and the guard counter are set when a move is selected,
  not when it executes. A holder that flinches or sleeps through its first
  turn is still locked into that selection. Modern games lock on use.
- Harvest and Cud Chew state is cleared on entry, as documented in the
  source. The simulator keeps the last eaten Berry across a switch.
  Recycle's history already persists per party slot.
- A popped Air Balloon is recorded as consumed and can be recycled. In the
  simulator it cannot. Trivial.
- `AI_Smart_Spite` (`engine/battle/ai/scoring.asm:1638`) compares the raw PP
  byte with 6 and 15, so PP-Up bits make a nearly empty move look full. This
  is the same class as the Disable fix but only shifts an AI score, and it
  was not reproduced as an outcome. Left alone.
- Ghost Curse blocked by Substitute remains the open design question from
  the previous report.

## Retained custom or legacy behavior

- An enemy's Thief and Pickpocket keep the item they take from the player
  after the battle (Gen 2 Thief rule). No trainer currently uses either.
  Knock Off was changed at the owner's request; see the next section.
- Bug Bite is an ordinary damaging move here; it does not eat the target's
  Berry, and its description does not claim to.
- Stat stages use the Gen 2 table (a one-stage drop is 66/100, not 2/3).
- Everything listed in AGENTS.md and the previous reports.

## Requested rule change: Knock Off no longer costs the player the item

This was listed above as legacy behavior, not a defect. The owner asked for
it to be changed and for Thief to be left alone.

- Before: an opponent's Knock Off cleared the item from the player's party
  record, so it was gone after the battle. 65 trainer Pokemon in
  `data/trainers/parties.asm` carry Knock Off.
- Now: the item is still removed for the rest of the battle (no effect, no
  Recycle, still gone if the mon switches out and back). It is remembered per
  party slot in the new bank-2 array `wPlayerKnockedOffItems` and returned
  by `RestoreKnockedOffItems_Core`, called from `ExitBattle` on every
  outcome, including a loss.
- If that party member holds something else by the end (it used Thief or
  Trick afterwards), the newer item is kept and the knocked-off one is not
  returned. A second Knock Off on the same slot in one battle replaces the
  first record. Both need the mon to regain an item mid-battle.
- Unchanged: Incinerate destroys the player's Berry; an enemy's Thief and
  Pickpocket keep what they take; the player's Knock Off and Thief against
  trainers and wild Pokemon.
- Files: `engine/battle/move_effects/new_move_cores.asm`
  (`RecordKnockedOffItem`, `RestoreKnockedOffItems_Core`, the call in
  `BattleKnockOff_Core`), `engine/battle/core.asm` (`ExitBattle`),
  `wram.asm`, `engine/battle/move_effects/october_move_cores.asm` (cleared
  at battle start with the Recycle arrays),
  `engine/16/table_functions.asm` (collector root, so an extended item such
  as Throat Spray keeps its runtime ID while nothing holds it).
- The array is battle-only WRAM in bank 2. The save layout is unchanged.
- Coverage: `tools/battletest/tests/106-knock-off-return-2026-11-12.yaml`,
  12 cases: unusable in battle, returned after wild, trainer and lost
  battles, returned to a benched member, an extended item, a newer item
  kept, and controls for Incinerate, enemy Thief, an itemless target, an
  untouched item and the player's own Knock Off. On `69ea0f80` the six
  return cases fail. `tools/test_item_expansion.py` gained three checks for
  the collector root.

## Harness issues

- Auto mode never opens `MoveSelectionScreen`, so YAML cases cannot test the
  player's selection-time refusals (Choice lock, Assault Vest, Taunt and
  Torment menu refusals). `wPlayerChoiceLockedMove` stays 0 in every YAML
  battle. The enemy's equivalents do run.
- `hBattleTurn` at the start of a turn is whatever the last end-of-turn
  handler left, usually the enemy. The player's Choice-lock check is correct
  only because `MoveInfoBox` sets the player's turn first. This looked like
  a defect until the native-menu probe showed otherwise.
- `hp:` and an illegal `ability:` are both applied after entry, and an HP
  Berry is eaten as soon as HP is set. A "Klutz does not eat its Berry" case
  with an overridden ability therefore fails for harness reasons.
- A wild enemy using Dragon Tail or U-turn takes the wild-battle path, so
  mirrored cases for those need a trainer battle.
- Assertion expressions have no builtins. `{}[(a, b, c)]` raises a
  `KeyError` that prints the values, which is a quick way to inspect state.

## Report-only text issue

Unchanged from the previous report: a fully capped Curse prints "ABILITY
won't rise anymore!". Dialogue was not edited.

## Validation

Runs marked "final" used the final build in the table above; the others
used the review build and exercise code the Knock Off change does not touch.
ROM0 slack is unchanged at 97 bytes (release) and 91 (debug) in both.

| Check | Build | Result |
| --- | --- | --- |
| Release and debug builds, RGBDS 0.5.2 | final | Built; tracked generated files unchanged |
| `106-knock-off-return-2026-11-12.yaml` | final | 12 passed |
| `105-followup-audit-2026-11-12.yaml` | final | 45 passed |
| Previous audit files 102, 103, 104 | final | 45 passed |
| Broad matrices plus every YAML case (the previous report's command, 2 workers) | final | 32,670 passed, 0 failed, 0 errored, 0 skipped |
| Same command before the Knock Off change | review | 32,658 passed, 0 failed, 0 errored, 0 skipped |
| `make audit-static` | final | Passed, exit 0 |
| `tools/test_item_expansion.py`, both ROMs | final | 1,303 checks passed each |
| `tools/test_battle_symbols.py` | final | Passed |
| `tools/test_pc_storage.py`, both ROMs | review | 130 passed each |
| `tools/test_battle_picture_tiles.py`, both ROMs | review | 1,259 checks passed each |
| `tools/battletest/hp_item_update_checks.py` | review | 352 checks, 0 failures |
| `tools/battletest/choice_lock_menu_checks.py` | review | 21 checks, 0 failures |
| `tools/test_trainer_portraits.py` | review | 10 passed |

## Not tested

- The every-move by every-ability Cartesian audit, a campaign playthrough
  and physical hardware.
- Link battles. The fix removes one random draw in a state both sides see
  identically, so it should not desynchronise, but that was not run.
- The remaining dedicated suites from the previous report (inventory
  boundaries, Gyro Ball, probability, Metronome priority,
  presentation equivalence, audit-state). The change does not touch code
  they exercise.
- Knock Off's return was tested through the debug battle wrapper, not
  through a map trainer battle followed by a save and reload.
- The player-side Giga Hammer reselection path of fix A was reviewed in
  source only.
