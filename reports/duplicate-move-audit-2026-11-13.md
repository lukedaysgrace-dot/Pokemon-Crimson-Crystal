# Focused duplicate-move audit — November 13, 2026

Two additional bugs were reproduced and fixed. This pass is limited to
duplicate-slot PP, Choice locks, Disable, Encore and native Mimic/Sketch
behavior; it does not repeat the broad battle audit.

## Fix 1 — Exhausted first copy incorrectly forced Struggle

Severity: medium. Source:
[CheckPlayerChoiceLock_Core](../engine/battle/abilities_engine.asm#L2502).

Reproduction: a Choice Band user has Tackle in slots 1 and 2, with PP 0 and
7, and Pound in slot 3. Its Choice lock is Tackle. Selecting Pound should
refuse that selection and let the player select the usable Tackle copy.
Instead, the rejection helper found the first Tackle, saw zero PP and
substituted Struggle immediately. The AI already searched other copies.

The helper now searches every matching slot for usable PP. When no usable
copy remains, it separately distinguishes an exhausted/disabled locked move
(Struggle) from a move that was overwritten (release the stale lock).

Before the fix, eight native assertions failed on each ROM across PP-Up
encodings. The real Fight-menu reproduction also executed the wrong move.
Both the direct checks and real-menu rejection/fallback now pass.

## Fix 2 — Fight menu accepted a disabled duplicate and wasted the turn

Severity: medium. Source:
[MoveSelectionScreen](../engine/battle/core.asm#L5813).

Reproduction: Tackle occupies slots 1 and 2, with Pound in slot 3. Disable
records Tackle and slot 1. Selecting slot 2 passed the menu's slot-only
check, but move execution rejected the disabled move ID. The player lost
the turn instead of receiving the menu refusal and selecting Pound.

The menu now checks the selected move ID against `wDisabledMove`, consistent
with native execution, the legal-move scan and enemy selection. Both copies
are refused; Pound remains selectable. Exact PP checks verify that refused
copies spend no PP and only the eventual chosen slot loses one PP.

The pre-fix real-menu test failed three assertions for this reproduction;
the corrected test passes without consuming a turn for the rejected copy.

## Other findings and preserved rules

- Native Mimic can create duplicate IDs and preserves the copied slot's
  separate PP. This was exercised on both sides in both ROMs. The direct
  player Mimic call uses its link-style random-choice branch with all four
  foe slots holding the same move, avoiding an interactive choice menu.
- Sketch explicitly refuses to copy a move already in the user's moveset.
  It does not create duplicates through that path. Native rejection and PP
  preservation were checked for both sides in both ROMs.
- Encore and Disable retain their existing **first matching slot** lookup.
  A zero-PP first copy causes application to fail even if a later copy has
  PP; a usable first copy receives the normal timer. This known behavior
  was verified, not silently redefined. No policy change was made here.
  Their direct controls use a target that already acted, so they do not
  certify every queued-action or multi-turn Encore interaction.
- Legal selected enemy duplicates retain their own PP slot. An exhausted
  selected copy falls back to a usable copy. All copies exhausted or
  disabled preserve the Choice lock and force Struggle. A truly absent
  locked move releases the stale lock. PP-Up bits cannot supply PP.

## Validation

| Check | Result |
| --- | --- |
| New native duplicate tests | **218 checks per ROM, zero failures** |
| Real Fight/restriction menu, including six duplicate cases | **78 checks, zero failures** |
| Existing selection/AI suite | **59 checks per ROM, zero failures** |
| Existing Choice menu suite | **21 checks, zero failures** |
| Release and debug builds | Passed, RGBDS 0.5.2 |
| `make audit-static` | Passed |
| Python syntax / scoped whitespace | Passed |

The native tests use private emulator memory; text and animation are stubbed
only for the direct effect-command checks. The Fight-menu suites use real
buttons with automatic debug actions disabled. Menu coverage is on the
debug ROM; both-ROM claims above refer to the routine suites. Player saves
are never opened.

Reproduction:

```sh
python3 tools/test_duplicate_move_restrictions.py
python3 tools/battletest/move_restriction_menu_checks.py --duplicates-only
```

The full menu script retains its existing cases. The new native duplicate
script is integrated into `make test-moves-abilities`.

Logs: `.tmpbuild/duplicate-moves-before.log`, `duplicate-menu-before.log`,
`duplicate-moves-final.log`, `duplicate-menu-final.log`,
`duplicate-selection-{release,debug}.log`, `duplicate-choice-menu.log`,
`duplicate-moves-build.log` and `duplicate-audit-static.log`.
Menu screenshots/results: `_artifacts/duplicate-moves/menu-{before,final}/`.

Delivery ROM SHA-256:

- Release: `a3e796572405c99b9ee8cf9d80c4b42404a57d5f1ff6106ed45bab55a91a6fa8`
- Debug: `3a798d9b06bfadc37b12805e773aab0f13ada13eeb01d3d062f216ceacef957c`

The damage matrix and broad Cartesian/interaction suites were not repeated
for this focused selection-only change. No save format, move balance or
unrelated game system was changed.
