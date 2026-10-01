# Review of Claude's recent audit commits

Reviewed the September 28–October 1 audit series through `ef9f597a`, against
the pre-audit baseline `72592927`. The initial review found two reproduced
battle issues, one save-refusal integration issue in the call flow, and one
static audit mismatch. The subsequent working-tree changes resolve all four
points. Updated verdict: agree with the reviewed audit changes; no remaining
actionable issue found in the follow-up review.

## Follow-up review of the fixes

Reviewed the five modified source/test files after the initial report:

- Life Orb recoil now runs before the broken-Substitute path clears the move
  effect, preserving Sheer Force eligibility. That path returns after damage
  reset, avoiding a second recoil call.
- Pressure exemptions now include Conversion 2, Destiny Bond, Sleep Talk and
  Metronome.
- Both PC storage callers propagate save refusal into their cancellation
  paths, with balanced stack/window cleanup. Refusal handling was verified
  by source inspection; the emulator PC tests cover successful required saves.
- Snorlax's first-stage entry again agrees with the documented breeding rule.

Fresh release and debug builds succeeded. The updated audit battle cases and
the five additional review cases produced **45 passes, zero failures**. PC
required-save tests (`test_pc_ui4.py`) produced **20 passes, zero failures**.
The game-data audit passed all **44,759 invariants**, and the working-tree
diff passed whitespace checks (excluding the unrelated `.tmpplaytest` tree).
The full-suite results below belong to the initial review; the follow-up
reran the relevant checks against freshly built ROMs.

The findings below preserve the initial review evidence and are now resolved.

## Findings

### P2: Sheer Force loses its Life Orb exemption when a hit breaks a Substitute

Commit: `8d7af501`.

`engine/battle/effect_commands.asm:3719` now calls `LifeOrbRecoil` from
`DoSubstituteDamage`. On the broken-Substitute path, lines 3711–3712 have
already zeroed the move effect. `CurrentMoveHasSheerForceEffect` uses that
effect to decide whether Life Orb recoil is suppressed, so it no longer
recognizes an eligible attack.

Reproduction: level 100 Nidoking, Sheer Force, Life Orb, Thunderbolt, attacking
a level 50 Jolteon with a 1-HP Substitute and no ability. Nidoking drops from
302 to 272 HP. The same attack without a Substitute leaves it at 302 HP.

Preserve or recover the original move's Sheer Force eligibility for the recoil
check. Ordinary Life Orb recoil into Substitutes should remain enabled.

### P2: The new Pressure exemption list omits self-targeting moves

Commit: `8d7af501` (the list remains unchanged by the final audit).

`engine/battle/abilities_engine.asm:565` defines `PressureExemptEffects`, but
does not include `EFFECT_CONVERSION2` or `EFFECT_DESTINY_BOND`. Both operate on
the user, yet the PP hook treats them as targeting the Pressure holder.

Reproduced against Pressure Aerodactyl:

- Porygon's Conversion 2 falls from 30 to 28 PP in one turn.
- Gengar's Destiny Bond falls from 5 to 3 PP in one turn.
- Rest, which is in the exemption list, correctly spends 1 PP.

Complete the exemption list and check all supported user-targeting effects,
or represent move targets explicitly so future effects do not silently miss
this rule.

### P2: PC callers discard the new save-refusal result

Commit: `24be9fda`.

`engine/menus/save.asm:156` adds `AskOverwriteSaveFile` to `ForceGameSave`,
which now returns carry on refusal. `BillsPC_ForceSave` forwards that result,
but its callers do not handle it:

- `engine/pc/bills_pc_ui.asm:2963` calls it, then restores the earlier YES
  answer with `pop af` and retries the storage-space loop.
- `engine/pc/bills_pc_ui.asm:4199` calls it and unconditionally retries the
  storage swap.

When storage requires a save and the current game belongs to a different
player ID, choosing YES to the PC's save request and NO to the overwrite
request leads back into the save/retry flow instead of cancelling the pending
operation. No silent overwrite was observed or claimed. Propagate refusal
through both callers while balancing their saved window state and stack.
This finding is based on source control flow, not an interactive reproduction.

### Audit maintenance: Snorlax breeding and its documented exception disagree

Commit: `8d7af501`.

`data/pokemon/first_stages.asm:145` changes Snorlax's offspring from Snorlax to
Munchlax. `tools/audit_game_data.py:399` still explicitly requires Snorlax,
explaining that Full Incense is not implemented. The game-data audit therefore
fails one of 44,759 checks.

Producing Munchlax without incense can be a deliberate gameplay rule. If that
is intended, update the audit and its explanation; otherwise restore the
exception. I do not classify the new breeding rule itself as a demonstrated
runtime bug.

## Commit coverage

| Commit | Assessment |
| --- | --- |
| `b2d3fc9c` audit fixes | Agree with the bank-call, expanded-ID, HM-table and contest-score fixes. |
| `07ccdc6a` second audit | Agree with animation-state initialization, Battle Tower comparison and skateboard gate fixes. |
| `58dc98d0` audit 3 | Agree with the bank-safe type/rule reads, AI call and dex-number fixes. |
| `7044383e` audit 4 | Agree with the bulk of the battle, shiny/gender, breeding, storage, Safari and map fixes. |
| `b8ecec39` audit 5 | Agree with the bulk of the sleep, Quick Feet, Unnerve, Cud Chew, multi-hit, link-layout and Day-Care fixes. |
| `e6979ce2` more audit fixes | Agree with the bulk of the Baton Pass, Psystrike-defense, Battle Tower and data/text corrections. New evolution/content decisions depend on the intended game rules. |
| `8d7af501` small audit and additions | Life Orb/Sheer Force regression; incomplete Pressure exemptions; Snorlax audit mismatch. Other reviewed fixes appear sound. |
| `24be9fda` audit and cries | Save-refusal result needs caller integration. Other reviewed code fixes appear sound. |
| `ef9f597a` final audit | No additional confirmed defect found in the final commit; its new regression cases pass. |

Also checked the code/table changes in the intervening `d7e4fe1e` documentation
and Gorochu integration commit. Visual and audio assets were checked for source
integration, binary consistency and build validity; this review does not claim
an exhaustive visual playthrough or listening pass.

## Verification

- Fresh release and debug builds succeeded using RGBDS 0.5.2, in temporary
  review directories. Existing root ROMs and saves were not replaced.
- Entire existing battle YAML suite: **557 passed**, including all **37** cases
  in `57-audit-2026-09-28.yaml`.
- Save/recovery tests: **25 passed**.
- Storage tests: **122 passed**, covering 2,021 routine calls.
- PC menu tests (`test_pc_ui3.py`): **23 passed**.
- Extra edge cases: **2 passed, 3 failed**. The failures reproduce the Life Orb
  issue and the two missing Pressure exemptions above.
- Move, trainer, save-layout, resource/audio, overworld-icon and trainer-sprite
  audits passed. Map-sprite audit reported no VRAM or sprite-list overflow.
- Game-data audit: **1 failure**, the Snorlax exception described above.
- `git diff --check 72592927 HEAD` passed.

Temporary build scripts, emulator dependencies, review cases and failure
screenshots are retained under `.tmpbuild/claude-audit-review-2026-10-01/`.
No game-source fixes were made as part of this review.
