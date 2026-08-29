# Fix log for the 28 Aug 2026 code audit

Companion to `CODE_AUDIT_2026-08-28.md`. Baseline: commit `3ca6ecd4`
("code audit update"). Every finding below was fixed in source, the release
and debug ROMs were rebuilt, and the battle-test harness was run: the full
existing YAML suite (420 cases) plus `--all-moves --all-effects`, and a new
file `tools/battletest/tests/54-audit-2026-08-28.yaml` (25 cases). All new
cases pass on the fixed ROM; 18 of them fail on the baseline ROM (the rest
are controls or guards for findings whose symptom the harness cannot see
directly).

One pre-existing failure is unrelated to this work and was already failing
on the baseline: "Name rendering: Intimidate resistance identifies the
blocking ability" (`43-name-rendering.yaml`) buffers OBLIVIOUS instead of
OWN TEMPO. Left alone.

## Applied

| # | Fix | Where |
|---|-----|-------|
| 1 | Spite / Disable / Encore move scans bounded to `NUM_MOVES`, fail the move on overrun. Sketch and Mimic's backwards scans bounded too (Sleep Talk reach). | `move_effects/spite.asm`, `disable.asm`, `encore.asm`, `sketch.asm`, `mimic.asm` |
| 2 | Enemy U-turn / Volt Switch / Flip Turn now does the full send-out: `AIPickPostKOSwitchIn` (fresh replacement pick, zeroes `wEnemySwitchMonIndex`), `NewEnemyMonStatus`, `ResetEnemyStatLevels`, `BreakAttraction`, `EnemySwitch_SetMode` (no Shift prompt), `ResetBattleParticipants`, `SetEnemyTurn` + `SpikesDamageAndEntryAbilities`. | `effect_commands_core.asm` `BattleUTurn_Core.enemy` |
| 3 | Stealth Rock entry damage routes through `CheckTypeMatchupFar` via `FarCall_de` (b = ROCK, hl = types) so the 4x / 2x / ½ / ¼ scaling is live. | `effect_commands_core.asm` `StealthRockEntryDamage` |
| 4 | `RunStatDropReaction` uses `CheckSelfInflictedStatDrop` (now exported) instead of a raw turn-keyed effect read. `EFFECT_CURSE` added to the self-drop list and Curse's Speed drop wrapped in a `savemiss`/`restoremiss` scope. Close Combat / Superpower scripts moved `restoremiss` after `flushstatmessages` so the scope is still open when the deferred drop message (and the Defiant check) runs. | `abilities_engine.asm`, `effect_commands.asm`, `curse.asm`, `data/moves/effects.asm` |
| 5 | Disguise no longer arms its deferred bust for STATUS-category moves; `DisguisePresentation` only busts a Mimikyu whose disguise is still intact. | `abilities_engine.asm` |
| 6 | `wPreStatScopeActive` cleared at the top of `DoMove` and in `EndMoveEffect`. | `effect_commands.asm` |
| 7 | `ToxicRestoreEnemy_Core` (with its Taunt/Yawn clears) moved out of `NewEnemyMonStatus` into `Function_SetEnemyMonAndSendOutAnimation`, where the incoming mon is always loaded. | `core.asm`, `effect_commands_core.asm` |
| 8 | Multi-hit loop stops when the attacker has fainted (contact recoil); "Hit N times!" counts the hits that landed. | `effect_commands.asm` `BattleCommand_EndLoop.in_loop` |
| 9 | Heal Bell / Aromatherapy clears `SUBSTATUS_TOXIC`, the side's toxic counter and the whole toxic-slots byte. | `heal_bell.asm` |
| 10 | `SafeCheckSafeguard_Core` inserted in `TryParalyze/Burn/PoisonContact/Toxic/Sleep/ConfuseOpponent` (covers Static, Flame Body, Poison Point, Effect Spore, Poison Touch, Synchronize, Magic Bounce reflections). Attraction (Cute Charm) deliberately not gated - Safeguard doesn't block infatuation. | `abilities_engine.asm` |
| 11 | Sticky Web's Speed drop goes through `AbilityLowerOppStat` (ability-drop flag, no AI-miss roll, no stale effect byte, fell message + Defiant/Competitive). | `new_move_cores.asm` |
| 12 | `BattleCommand_StatDown`'s bit-6 (ability/Contrary) branch lands on `.SelfInflicted`, skipping the redundant sub check that ate a Contrary holder's own raises behind its Substitute. Both bit-6 setters resolve the Substitute question themselves. | `effect_commands.asm` |
| 13 | Anticipation's scan bounded to `NUM_MOVES`. | `abilities_engine.asm` |
| 14 | Status moves (sleep, poison/Toxic, paralysis, burn, confusion) check Magic Bounce (`StatDropSubCheckExempt` + `AbilityPrevents*`) before the Substitute check and the AI 25% roll. | `effect_commands.asm`, `effect_commands_core.asm`, `new_move_cores.asm` |
| 15 | Flash Fire's Fire-status special case skipped while the ability-proc guard bit (`wDisguiseBusted+1` bit 6) is set. | `abilities_engine.asm` |
| 16 | Unaware's `.ReloadUnboostedDef` skips the screen re-doubling when `CheckDamageStatsCritical` says the unboosted (crit) branch is in use. | `effect_commands_core.asm` |
| 17 | Struggle still runs `RunNullificationAbilities` (Disguise, Multiscale, item/ability modifiers), skipping only STAB and the type chart. | `effect_commands.asm` `BattleCommand_Stab` |
| 18 | Mirror Move runs `AbilityConvertMoveType` (-ate abilities). | `mirror_move.asm` |
| 19 | Enemy confusion self-hit clears `wCriticalHit` like the player path. | `effect_commands.asm` |
| 20 | Rock Head no longer cancels Struggle recoil (Magic Guard still does). | `abilities_engine.asm` `BattleRecoil_Core` |
| 21 | `kingsrock` and `flinchtarget` bail when the user has fainted. | `effect_commands.asm` |
| 22 | Wild battles set `wEnemyFirstImpressionFresh` at battle start. | `core.asm` `DoBattle.wild` |
| 25 | Parental Bond's second hit refreshes the HP-bar max with the defender's max HP. | `abilities_engine.asm` |
| 26 | Damage cap test `or a` -> `or b`. | `effect_commands.asm` |
| 27 | `wOddEggMoves` and both Giga Hammer locks added to the move-table GC roots. | `engine/16/table_functions.asm` |
| 29 | The five `add 30` AI score bumps saturate at $ff. | `ai/scoring.asm` |
| 31 | Move reorder in battle: real `wBattleMode` test, only mirrors into `wBattleMon` when the reordered mon is the active one, `MON_PP - MON_MOVES` / `wBattleMonPP - wBattleMonMoves` offsets instead of `$15` / `$20`. | `engine/pokemon/mon_menu.asm` |
| 24 | Counter and Mirror Coat run `BattleCommand_CheckHit.Protect` first, so Protect / Detect / Baneful Bunker block them (with the normal "protecting itself" text). | `counter.asm`, `mirror_coat.asm` |

## Not applied

- **#23 weather text under Cloud Nine / Air Lock.** Implemented, then
  backed out: the "Battle Core" bank is now full to within 5 bytes in the
  debug build (the tester lives there), and this cosmetic item was the
  cheapest thing to drop. Re-add when something else moves out of that
  bank. (Same reason the defensive `wEnemySwitchMonIndex` clear in
  `LoadEnemyMonToSwitchTo` was left out - the U-turn path now zeroes it via
  `AIPickPostKOSwitchIn`, which is what matters.)
- **#28 Mystery Gift trainer format** - link-only, per the standing
  "no link play" call.
- **#30 Pickpocket item-name buffering** - `StoleText` reads
  `wStringBuffer1` directly (like Thief, which works); switching to
  `AbilityBufferItemName` would also mean re-pointing the text. Harmless as
  is.

## Notes for next time

- `engine/battle/core.asm` ("Battle Core") has ~5 bytes of headroom in the
  debug build. The next change there will need to relocate something.
- The #7 regression case passes on the baseline too; the harness setup
  (`substatus: [TOXIC]` + `wEnemyToxicSlots`) apparently doesn't reproduce
  the exact stale-read the audit describes, but the relocation is correct
  by construction and the case guards it going forward.
- The #1 case can't observe the out-of-bounds write directly (Spite's PP
  outcome is the same either way); it guards the bounded scan's "fails
  cleanly" contract.
- Magic Bounce reflecting Will-O-Wisp onto a Flash Fire holder now burns
  the holder instead of absorbing (the #15 guard bit is also set during a
  bounce). Pre-existing in spirit - the bounced move type read was already
  the bouncer's stale move - and very rare.
