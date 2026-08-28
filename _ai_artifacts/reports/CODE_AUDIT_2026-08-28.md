# Code audit — 28 Aug 2026 (battle engine, moves, abilities, interactions)

Scope: the battle engine end to end, ordered from most to least dangerous —
`core.asm` turn flow / switching / damage math, `abilities_engine.asm` in
full, `effect_commands*.asm` and every `move_effects/*` file, ten-plus
move↔ability interaction families traced step by step, then the lighter
areas (16-bit move/species ID plumbing, trainer AI, held items, the new
Hidden Power system, exp/evolution, battle items). Five audit passes read
the code; every finding below was then re-verified adversarially against the
source by a separate pass (two candidate findings were refuted and dropped —
see the end). Baseline: working tree at commit `326fd32f` ("elms lab
update"). Static analysis only; nothing was run in an emulator.

Nothing in this report has been changed in the repo. Each finding has a
suggested minimal fix so they can be applied selectively.

---

## CRITICAL — memory / save corruption

### 1. Spite writes a PP byte into arbitrary party data after Metronome or Mirror Move
`engine/battle/move_effects/spite.asm:22-70` (Disable and Encore share the
read-only half of this: `disable.asm:30-42`, `encore.asm:19-27`).

Spite finds the target's last move by scanning `wBattleMonMoves` /
`wEnemyMonMoves` with `ld c,-1 / .loop: inc c / ld a,[hli] / cp b / jr nz,.loop`
— there is no `NUM_MOVES` bound. That is fine only if the last move is one
of the four slots. Metronome and Mirror Move break that by construction:
`BattleCommand_Metronome` rerolls until `CheckUserMove` says the user does
*not* know the move, `BattleCommand_MirrorMove` only proceeds when the user
does *not* know the copied move, and both `jp ResetTurn` into the new move's
script, whose `usedmovetext` writes that foreign move into
`BATTLE_VARS_LAST_COUNTER_MOVE` (`used_move_text.asm:16-40`). Spite then walks
forward from the move slots through the rest of the battle struct and beyond
until some byte equals the move ID, and uses the resulting index `c` (0–255)
twice: `add hl,bc` on the PP array, and `OpponentPartyAttr(MON_PP) + c` with
`ld [hl], e` — a write into whatever lands there. Against the player that is
`wPartyMons`, i.e. saved data (other mons' species/moves/DVs/HP/OT/nicks).

Scenario: your mon uses Metronome → Fire Blast; next turn a faster wild or
trainer mon uses Spite (both moves are in learnsets: Metronome at
`evos_attacks_johto.asm:636,659`, Spite at `:1198,1306,2652,2675`, plus egg
moves; wild mons pick moves at random). Save afterwards and the corruption
is permanent. Inherited from vanilla, but fully reachable.

Disable stores a garbage slot nibble and does an out-of-range PP read;
Encore can succeed against a move the target doesn't have (read only).
Sketch/Mimic have similar unbounded backwards scans but are only reachable
via Sleep Talk → Sketch.

Fix: bound all three scans and fail the move on overrun, e.g.
`ld d, NUM_MOVES` … `dec d / jr nz, .loop / jp .failed` — the same shape
already used by `FindEnemyMoveWithPP` (`abilities_engine.asm:1973-1998`) and
`BattleEerieSpell_Core` (`effect_commands_core.asm:754-759`).

---

## HIGH — wrong outcomes that materially change battles

### 2. Enemy U-turn / Volt Switch / Flip Turn does none of the switch-in work
`engine/battle/effect_commands_core.asm:1317-1336` (`BattleUTurn_Core.enemy`)
and `core.asm:3294-3334` (`EnemySwitch` / `EnemySwitch_SetMode`).

The enemy half of the U-turn core goes straight to `EnemySwitch`, which only
runs `ResetEnemyBattleVars` and loads the mon. Every other enemy send-out
path (`EnemyPartyMonEntrance` 2468-2491, `ForceEnemySwitch` 3280-3292,
`AI_Switch` + `DetermineMoveOrder.switch` 549-552, enemy Baton Pass) wraps
it with `NewEnemyMonStatus`, `ResetEnemyStatLevels`, `BreakAttraction`,
`ResetBattleParticipants` and `SetEnemyTurn` + `SpikesDamageAndEntryAbilities`.
The player half of the same routine (`:1312`) goes through
`BattleMonEntrance` and does all of it. 26 trainer party rows carry
U-turn/Volt Switch/Flip Turn.

Consequences on every enemy pivot: the replacement inherits Leech Seed,
confusion, Curse, Nightmare, Perish count, Substitute, Encore/Disable, wrap,
Taunt/Yawn counters and the outgoing mon's **stat stages** (while its stored
stats are the fresh unboosted values); it takes no Spikes/Stealth Rock/
Toxic Spikes/Sticky Web damage; no entry ability runs (Intimidate, Drizzle,
Trace, Cloud Nine refresh…); exp participation isn't re-based; and — verified
separately — `wEnemySwitchMonIndex` is never written on this path, so
`CheckWhetherSwitchmonIsPredetermined` (3336-3367) reuses whatever
`AIPickPostKOSwitchIn` / `AI_Switch` / Roar last stored (which equals the
current slot) and `LoadEnemyMonToSwitchTo` has no "≠ wCurOTMon" check: an
Elite trainer's mon that came in after a KO and then Volt Switches is
**re-sent as itself**. `wBattleHasJustStarted` is also not set, so in Shift
mode the "will you switch?" prompt can fire mid-script. Enemy Baton Pass
(`baton_pass.asm:65-100`) shows the correct shape: it zeroes
`wEnemySwitchMonIndex`, uses `EnemySwitch_SetMode`, then runs the resets and
`SpikesDamageAndEntryAbilities`.

Fix: mirror the Baton Pass enemy path minus the stage-keeping: zero
`wEnemySwitchMonIndex`; `NewEnemyMonStatus`, `ResetEnemyStatLevels`,
`BreakAttraction`; `EnemySwitch_SetMode`; `ResetBattleParticipants`;
`SetEnemyTurn` + `SpikesDamageAndEntryAbilities`. (Also consider clearing
`wEnemySwitchMonIndex` at the end of `EnemySwitch_SetMode`/`ForceEnemySwitch`
once consumed, so no future path can reuse it.)

### 3. Stealth Rock entry damage is always exactly 1/8 — the type scaling is dead code
`engine/battle/effect_commands_core.asm:415-423`.

```asm
	ld hl, wBattleMonType1 / wEnemyMonType1
	ld a, ROCK
	callfar CheckTypeMatchup
```
`callfar` expands to `ld hl, target / ld a, BANK / rst FarCall`, and
`FarCall_hl` then loads `a` from `hFarCallReturnA` — so `CheckTypeMatchup`
receives neither the ROCK type in `a` nor the types pointer in `hl`. It reads
`b`/`c` from its own code bytes (`$E5`, `$D5` — `push hl`/`push de`), which
never match a type, and `wTypeMatchup` stays at 10. Charizard and Ferrothorn
both take 1/8. This is the only `callfar CheckTypeMatchup` in the tree; the
comment at `effect_commands.asm:1612-1616` documents exactly this hazard and
provides `CheckTypeMatchupFar` (b = type, hl = types) via `FarCall_de`, as the
switch AI uses (`ai/switch.asm:78-83`).

Fix: `ld b, ROCK` + `ld a, BANK(CheckTypeMatchupFar) / ld de, CheckTypeMatchupFar / rst FarCall`
(the `FarCall_de` pattern), keeping `hl` = types.

### 4. Defiant / Competitive fire on the user's *own* self-drops (Close Combat, Superpower, Draco Meteor…)
`engine/battle/abilities_engine.asm:5949-5987` (`RunStatDropReaction`) and
the self-drop scripts in `data/moves/effects.asm` (e.g. `CloseCombat`
2286-2320, `DracoMeteor` 1669+).

The routine guards self-inflicted drops by reading `BATTLE_VARS_MOVE_EFFECT`
and comparing it against the seven self-drop effects. But every self-drop
script prints its drop with the turn flipped
(`switchturn / defensedown / switchturn / switchturn / statdownmessage / switchturn`),
and `BATTLE_VARS_MOVE_EFFECT` is turn-keyed — so the guard reads the
**opponent's** move-effect byte, essentially never matches, falls to
`.from_opponent`, and `GetOpponentAbility` (opponent of the flipped turn = the
move's own user) returns the user's ability. The deferred path
(`FlushStatMessages_Core.DoDowns`, `effect_commands_core.asm:1868-1907`)
restores the same flipped side before calling it.

Result: a Defiant Bisharp/Kingambit/Annihilape or a Competitive
Milotic/Jolteon/Espathra gets +2 Atk / +2 SpA every time it uses Close Combat,
Superpower, Hammer Arm, Draco Meteor, Overheat-class, Headlong Rush, Scale
Shot or Shell Smash. Curse (Ghost-less form) is also missing from both
self-drop lists (`curse.asm:46-52` lowers Speed via `LowerStat` and prints
with a flipped `statdownmessage`), so a Defiant Curse user gets +2 too.

Fix: make `RunStatDropReaction` use `CheckSelfInflictedStatDrop`
(`effect_commands.asm:4715-4758`) — which already recovers the originating
effect from the `savemiss` snapshot when the turn is flipped — instead of a
raw `GetBattleVar`, and add `EFFECT_CURSE` to both self-drop lists.

### 5. Disguise's deferred "bust" flag leaks out of status moves and busts the wrong Pokémon
`abilities_engine.asm:1414-1418` (`.CheckNullification` → `DisguiseBlock`),
`:5093-5097` (arms `wDisguiseBusted+1` bit 7), `:5107-5128`
(`DisguisePresentation`, consumed from the `checkfaint` hook).

`DisguiseBlock` is reached from the `stab` command for *any* move with no
category filter and sets bit 7 for later presentation. Bit 7 is only cleared
by the next `stab` or by `DisguisePresentation` (run from `checkfaint`). The
three status scripts that run `stab` — `DoPoison` (`effects.asm:1151`),
`DoParalyze` (`:1161`), `DoBurn` (`:2630`) — have no `checkfaint`, so Toxic /
Poison Powder / Thunder Wave / Glare / Stun Spore / Will-O-Wisp against a
Mimikyu arm the flag and never consume it. The next executed script with
`checkfaint` but no `stab` — Night Shade / Seismic Toss / Dragon Rage / Sonic
Boom / Psywave (`StaticDamage`), Counter, Mirror Coat, Bide, Beat Up, Future
Sight — then runs `DisguisePresentation` against *its* defender:
`SwitchTurn`, mark that side's party slot busted, banner, "disguise served as
a decoy!", and `LoadBrokenDisguisePic` (`:5183`, no species guard, unlike
`ReapplyBrokenDisguise` at `:5161`) blits Mimikyu's broken sprite over
whatever is on the field.

Scenario: you Toxic an enemy Mimikyu; it uses Swords Dance; next turn it uses
Seismic Toss on you → your active mon is flagged "busted", the decoy text
prints for it, and your backpic becomes broken-Mimikyu for the rest of the
battle. (Reverse case: you Toxic it, then Night Shade it — its disguise is
busted for free without ever absorbing a hit.)

Fix: in `.CheckNullification`, skip `DisguiseBlock` when
`GetMoveCategory == CATEGORIZE_STATUS` (canon: Disguise only blocks damage),
and guard `DisguisePresentation`/`LoadBrokenDisguisePic` on the holder
actually being a Mimikyu with an unbroken disguise.

### 6. A failed self-drop move leaves `wPreStatScopeActive` set; the opponent's later stat drops then bypass Mist, Clear Body, Substitute and the AI-miss roll
`effect_commands.asm:4967-4992` (`savemiss`/`restoremiss`), `:2404-2430`
(`failuretext` → `EndMoveEffect`), `:4715-4758` (`CheckSelfInflictedStatDrop`),
`:4538-4546` and `:4613-4650` (`BattleCommand_StatDown`).

Every self-drop script is `checkhit / savemiss / moveanim / failuretext /
applydamage … restoremiss`. When the move misses or is Protected,
`failuretext` ends the script and `restoremiss` never runs.
`wPreStatScopeActive` is written nowhere else (it is inside the battle union,
so it is zeroed at battle start, but not per move or per turn). While the
stale scope is active with `wPreStatTurn` = the failing side, any stat drop
from the **other** side (Growl, Screech, Charm, Icy Wind, Crunch's secondary…)
passes `CheckSelfInflictedStatDrop` (turn ≠ saved turn → uses the saved
`EFFECT_CLOSE_COMBAT`) and is treated as self-inflicted: `StatDownSkipProtect`
skips `CheckMist` and `AbilityProtectsStatDrop`, and `.SelfInflicted` skips
`CheckSubstituteOpp` and the 25% AI-miss roll. It stays that way until either
side completes a self-drop move.

Scenario: your Close Combat is blocked by Protect. From then on, enemy Growls
pierce your Clear Body / Mirror Armor / Mist / Substitute with no message and
no 25% fail chance. Symmetric the other way.

Fix: clear `wPreStatScopeActive` in `EndMoveEffect` (or at the top of
`DoMove`).

### 7. Enemy switches run the badly-poisoned bookkeeping against the *outgoing* mon
`effect_commands_core.asm:2951-2970` (`ToxicRestoreEnemy_Core`, called at the
tail of `NewEnemyMonStatus`, `core.asm:3822`); callers `ai/items.asm:708`,
`core.asm:2262`, `core.asm:2472`.

The routine's own contract is "run with the incoming mon already in
`wEnemyMon` and `wCurOTMon` updated". That holds for the player side
(`NewBattleMonStatus` always follows `InitBattleMon`) and for
`ForceEnemySwitch` (3285-3287), but on the AI-switch and post-KO paths
`NewEnemyMonStatus` runs **before** `EnemySwitch` loads the new mon. So it
reads the outgoing slot's bit and the outgoing status: if the outgoing mon
was badly poisoned, `SUBSTATUS_TOXIC` is re-set on `wEnemySubStatus5` after
the clear, and `LoadEnemyMon` doesn't touch that byte — the replacement
arrives unpoisoned but flagged toxic, and its first plain poison (Poison
Point, a secondary, one Toxic Spikes layer) escalates from n/16 instead of a
flat 1/8. Conversely an incoming mon that *was* badly poisoned earlier is
never restored to toxic (it ticks as regular poison). Vanilla
`NewEnemyMonStatus` had no `wCurOTMon` dependency, which is why the ordering
was harmless before.

Fix: move the `farcall ToxicRestoreEnemy_Core` out of `NewEnemyMonStatus`
and into the post-load point (`EnemySwitch_SetMode` /
`Function_SetEnemyMonAndSendOutAnimation`), keeping the Taunt/Yawn clears
where they are.

---

## MEDIUM

### 8. Multi-hit moves keep hitting after the attacker is KO'd mid-loop
`data/moves/effects.asm:953-977` (multi-hit scripts), `effect_commands.asm:2721-2747`
(`checkfaint` only tests the target), `:5603-5607` (`endloop` has no user
guard), `abilities_engine.asm:4486-4498` (Iron Barbs), `:3696-3714` (Rocky
Helmet). Rough Skin/Iron Barbs/Rocky Helmet run from `checkfaint` inside the
loop and `SubtractHP` clamps at 0 without fainting; the loop jumps back to
`critical` regardless. A Fury Swipes user at ≤2/8 HP into Ferrothorn is
reduced to 0 on hit 2 and still lands hits 3–5, possibly KOing the target;
its own faint is processed afterwards. Fix: in `BattleCommand_EndLoop.in_loop`
add a `UserHasFainted` check before looping.

### 9. Heal Bell / Aromatherapy leaves the Toxic counter armed
`move_effects/heal_bell.asm:1-35`. Clears status bytes only; never clears
`SUBSTATUS_TOXIC`, `w*ToxicCount` or `w*ToxicSlots`. Every other cure path
does (Rest `effect_commands.asm:6285-6288`, Shed Skin/Hydration
`abilities_engine.asm:892-893` — the exact bug fixed there last audit, items
`item_effects.asm:1595-1596`, AI items `ai/items.asm:746-747`). A mon cured
mid-count that later takes plain poison resumes escalating ticks (e.g. 6/16
on the first tick); switching out and in re-arms toxic via the stale slot
bit. Fix: `res SUBSTATUS_TOXIC`, zero the side's toxic count, and zero the
whole toxic-slots byte (the move cures the whole party).

### 10. Ability-inflicted statuses ignore Safeguard
`abilities_engine.asm:4247-4470` (`TryParalyzeOpponent`, `TryBurnOpponent`,
`TryPoisonOpponentContact`, `TryToxicOpponent`, `TrySleepOpponent`,
`TryConfuseOpponent`, `TryAttractOpponent`, `CuteCharmAbility`) plus
Synchronize (5300-5308) and every Magic Bounce reflection that reuses them.
`SafeCheckSafeguard_Core` is only ever called from move-driven status paths.
Static/Flame Body/Poison Point/Effect Spore/Cute Charm/Poison Touch land
through Safeguard; a bounced Toxic lands on a Safeguarded user. Fix: insert
`call SafeCheckSafeguard_Core / ret nz` after the "already statused" early-out
in each helper (same bank; the turn convention already matches).

### 11. Sticky Web's Speed drop bypasses the ability-drop wrapper
`move_effects/new_move_cores.asm:1099-1105` calls `AbilityStatDown` raw
under `SwitchTurnForOppText`, without `wAbilityStatDropFlag` /
`wDisguiseBusted` bit 6 that `AbilityLowerOppStat`
(`abilities_engine.asm:786-815`) sets. In `BattleCommand_StatDown`:
(a) `.ComputerMiss` rolls the 25% AI-fail roll exactly when the **player's**
mon enters (turn flipped) — a quarter of player switch-ins ignore the web,
the enemy's never do; (b) `CheckSelfInflictedStatDrop`/`CheckMist` read the
other side's stale move-effect byte — Mist never protects, and if that byte
is a self-drop effect the web pierces Clear Body/Contrary/Substitute;
(c) no drop message and no Defiant/Competitive reaction (that lives in
`StatDownMessage_Core`). Fix: `farcall AbilityLowerOppStat` with `b = SPEED`.

### 12. A Contrary holder behind its own Substitute gets nothing from self-raises
`abilities_engine.asm:5816-5837` (`ContraryCheckRaise` → `StatDownSkipProtect`)
→ `effect_commands.asm:4613` (bit-6 branch lands on `.DidntMiss`) → `:4646-4648`
`CheckSubstituteOpp` — "opponent" after the flip is the holder itself, so its
own sub fails the drop; the caller then clears the failure flags and reports
handled. Swords Dance/Calm Mind behind a sub does nothing, silently. Fix:
send the bit-6 branch to `.SelfInflicted` instead of `.DidntMiss` (both
bit-6 setters already did their own substitute check).

### 13. Anticipation scans past the four moves and shudders on garbage
`abilities_engine.asm:6862-6925`. `CopyOppMovesToBuffer` copies 4 bytes to
`wBuffer1-4`; the routine then writes the holder's own types into
`wBuffer5/6` and scans from `wBuffer1` with a loop whose only exit is a zero
byte. Against any 4-move foe it reads the holder's types and then live WRAM
(`wCurHPAnim*`/`wCurEnemyItem` union) as move IDs. `ForewarnAbility` right
above it is correctly bounded (`ld e, NUM_MOVES`). Fix: same counter.

### 14. Magic Bounce: status moves aren't reflected from behind the bouncer's own Substitute, and the AI 25% roll runs before the bounce
`effect_commands.asm:3944-3957` (Toxic/Poison), `effect_commands_core.asm:1377-1393`
(paralysis), burn/sleep cores likewise: `CheckSubstituteOpp` and the 25%
AI-fail roll both precede the ability check, whereas the stat-drop path was
deliberately given `StatDropSubCheckExempt` (`abilities_engine.asm:2861-2877`,
comment at `effect_commands.asm:4548-4552`: "Magic Bounce still reflects status
moves even from behind its own Substitute"). So an Espeon behind a sub bounces
Growl but not Will-O-Wisp, and a quarter of enemy Toxics silently "fail"
instead of bouncing. Fix: hoist the ability check above the sub check and the
roll for status-category moves, mirroring the stat-drop pattern.

### 15. Flash Fire absorbs Flame Body / Synchronize burns off a stale move type
`abilities_engine.asm:966-981` reads `BATTLE_VARS_MOVE_TYPE` (turn-keyed)
before the generic list; from `TryBurnOpponent` the turn is on the
defender/Synchronize holder, so it reads *their* last move type. Reachable
only with a non-Fire Flash Fire holder (Trace / Skill Swap): e.g. Porygon2
Traces Flash Fire, gets hit by Flame Body while Magmar's last move was Ember
→ burn absorbed, +1 SpA. Fix: gate the special case on the ability-proc
guard bit (`wDisguiseBusted+1` bit 6, already bracketed by
`RunGuardedStatusProc` / the contact region) or on move category.

### 16. Unaware attacker re-applies Reflect / Light Screen on the critical-hit path
`effect_commands_core.asm:2180-2222` and `:2261-2290` (`.ReloadUnboostedDef`).
`PlayerAttackDamage_Core` deliberately drops the screen doubling on the
unboosted (crit) branch (2417-2420); the Unaware reload unconditionally
re-applies it, so an Unaware crit through Reflect does ~half damage. Fix:
skip the `.rescreen` doubling when `CheckDamageStatsCritical` returned nc.

---

## LOW

17. **Struggle skips nullification and every damage modifier.** `BattleCommand_Stab` returns early for Struggle (`effect_commands.asm:1370-1376`), and `RunNullificationAbilities` is only called from `stab`'s tail, so Struggle ignores Disguise, Air Balloon, Multiscale, Filter, Huge Power, Guts, item modifiers, etc. Fix: for Struggle, skip only the type loop and still `farcall RunNullificationAbilities`.
18. **Mirror Move skips the -ate conversion.** `mirror_move.asm:29-40` hand-rolls the move load without `AbilityConvertMoveType`; Metronome and Sleep Talk use `UpdateMoveData` and are fine. Fix: `call UpdateMoveData`.
19. **Enemy confusion self-hit can inherit a stale crit flag.** `effect_commands.asm:525-566` (inline enemy branch) lacks the `xor a / ld [wCriticalHit], a` that `HitConfusion` (654-661) has, so after a player crit the enemy hurts itself for ×1.5.
20. **Rock Head / Magic Guard cancel Struggle recoil.** Struggle is `EFFECT_RECOIL_HIT` and `BattleRecoil_Core` (`abilities_engine.asm:6193-6199`) exempts both; canon Struggle recoil ignores Rock Head. A Rock Head mon out of PP takes no Struggle damage.
21. **A dead attacker can still flinch via King's Rock** and run the rest of its script; only Stone Axe and U-turn guard `UserHasFainted` individually (`effect_commands_core.asm:384-386`, `1269-1272`). Add the same guard to `kingsrock`/`flinchtarget` if wanted.
22. **Wild Pokémon never get First Impression's entry-turn flag.** Only `NewEnemyMonStatus` sets `wEnemyFirstImpressionFresh`, and `DoBattle` skips it for wild battles (`core.asm:37-46`).
23. **Weather text prints every turn under Cloud Nine / Air Lock.** `.PrintWeatherMessage` masks `WEATHER_TYPE_MASK` (`core.asm:1903-1905`) while the gameplay branches correctly don't; cosmetic sibling of the animation fix from last audit.
24. **Counter and Mirror Coat aren't blocked by Protect / Baneful Bunker** — their scripts have no `checkhit` (vanilla); OHKO moves are fine because `BattleOHKO_Core` calls `CheckHit` itself.
25. **Parental Bond's second hit animates the HP bar against the attacker's max HP** after Rocky Helmet (`abilities_engine.asm:3769-3789` never refreshes `wCurHPAnimMaxHP` for the defender). Visual only.
26. **Damage-cap check tests a dead register.** `effect_commands.asm:3166-3170` `or a` should be `or b` (vanilla); unreachable in practice because the product can't exceed 24 bits, but worth restoring.
27. **GC-root hygiene for the 16-bit move table.** `wPlayerGigaHammerLock`/`wEnemyGigaHammerLock` (`giga_hammer_core.asm:38-50`) and `wOddEggMoves` hold 8-bit move IDs but aren't in `MoveTableGarbageCollection`'s root list (`engine/16/table_functions.asm:63-88`). Practically safe (the Giga Hammer move is also in the rooted move slots; Odd Egg's IDs sit in the recent-allocation ring) but free to add.
28. **Mystery Gift trainer (CAL2) format mismatch.** `StagePartyDataForMysteryGift` (`engine/link/mystery_gift.asm:1207-1250`) writes 1-byte species and 1-byte moves (raw dynamic 8-bit IDs, meaningless on another cart anyway); `ReadTrainerPartyPieces` (`read_trainer_party.asm:146-234`) parses 2-byte species and moves. Link-only, so per your "no link play" call this is just a note.
29. **AI move scores are unclamped bytes.** `AI_Elite`/`AI_Abilities` add 30 several times (`ai/scoring.asm:3929-4001, 4443-4447`); the reachable worst case (~155) doesn't wrap, but one more layer could, turning a dismissed move into the AI's favourite. Consider a saturating add.
30. **Pickpocket buffers the item name without selecting WRAM bank 1** (`abilities_engine.asm:7057-7065`), against the file's own header contract; every other ability message uses `AbilityBufferItemName`. Thief uses the same unguarded pattern and works, so probably harmless.
31. **`mon_menu.asm:1026-1047` move reorder:** the `ld a,[wBattleMode] / jr z` test branches on a stale flag (loads don't set flags) and the in-battle stride `$20` is stale (battle struct is now 34 bytes). Falls into dormant union scratch outside battle, so no visible effect; tidy when convenient.

---

## Verified correct (highlights)

Tables: 419 move rows / names / descriptions aligned; 222 effect constants =
222 pointers, all landing on real scripts; 172 abilities = 172 flags = 172
names/descriptions; contact bitfield decoded move-by-move for 352-419 (all
correct); critical-hit list and Metronome exceptions correct; every AI/engine
move list is `dw` + `IsInHalfwordArray`, every effect list `db` +
`IsInArray`; no code compares an 8-bit WRAM move byte against a >255 constant
and no ROM table is indexed by a raw 8-bit ID. The "table really full"
infinite loop in the 16-bit allocator is unreachable: at most ~120 rooted
move IDs vs 230 entries, 66 species vs 100. Party struct grew to 50 bytes and
the battle struct to 34 consistently (sym-verified); Hidden Power type byte is
read from the right mon at every consumer, packed into 5 bits for boxes
(FAIRY = 28 < 32), and Transform deliberately doesn't copy it.

Battle math: damage cap chain (997+2), crit ×1.5 clamp, `SubtractHP`/
`RestoreHP` clamps, Toxic loop, 1/4-1/8-1/16 HP helpers (max HP ≈ 713 <
1024), stat-stage clamps 1..13, `MAX_STAT_VALUE` caps, exp/level maths at the
level cap, catch-rate formula with 16-bit HP, Rollout/Fury Cutter/Rage caps.
`farcall` preserves `a`, `bc` and flags (`wFarCallBCBuffer` is unbanked), so
the carry-return convention every ability hook relies on is sound.

Perspective: all 26 `SwitchTurn` pairs in the ability engine are balanced on
every exit; `StackCallOpponentTurn` verified byte-by-byte; contact-hook
perspective (last audit's fix) holds; hazard sidedness agrees at every site;
absorb abilities heal-cap, ignore own-side moves and are guarded during AI
damage prediction (every hook on the prediction path respects
`wAIDamagePrediction`); `-ate` conversion runs before immunity checks and
excludes Hidden Power; Freeze-Dry stays Ice-typed for absorb purposes;
Mold Breaker vs the IGNORABLE flag is consistent at all 56 abilities (a
scripted cross-check); Sheer Force's single gate is shared by all consumers;
Sturdy > Sash > Endure > Band ordering; multi-hit + Disguise / absorb / Life
Orb bookkeeping; trapping abilities and escapes; Prankster/Gale Wings/Triage
priority and Queenly Majesty/Armor Tail blocking; weather suppression (raw
compare convention) at every gameplay site. Faint handling after contact
recoil and after hazard KOs on entry is correct on every path (mid-turn player
switch, Roar, post-KO replacement, AI voluntary switch — the latter *does* get
hazards/entry abilities via `DetermineMoveOrder.switch`, `core.asm:549-552`).
AI switching can't pick a fainted mon or itself; AI 16-bit HP item maths is
correct; jumptables (`BattleCommandPointers`, `AIScoringPointers`,
`AI_Smart` dispatch, `CriticalHitChances`) are in range.

## Refuted during verification (not bugs)

- "RisingBadge never boosts Sp.Def / Glacier tested twice" in `BadgeStatBoosts`: GSC canon is that GlacierBadge boosts Special (both Sp.Atk and Sp.Def) and RisingBadge boosts nothing; the `push af`/`pop af` makes the vanilla non-deterministic second Glacier boost deterministic, which is the documented pokecrystal fix. Only the header comment is misleading.
- "AI voluntary switches skip hazards and entry abilities": refuted — `DetermineMoveOrder.switch` runs `SetEnemyTurn` + `SpikesDamageAndEntryAbilities` after `AI_Switch`. Only the U-turn path (finding 2) lacks it.

## Not covered

- Runtime verification — nothing was run. The repo's `tools/battletest` harness is the natural place to add regression cases for findings 1–12 once fixed (Spite-after-Metronome, enemy Volt Switch into Stealth Rock, Charizard into Stealth Rock, Defiant Close Combat, Toxic on Mimikyu then Seismic Toss, Protected Close Combat then enemy Growl vs Clear Body, enemy switch after Toxic, Heal Bell then Poison Sting).
- `engine/pc/` (storage codec, PokeDB allocator) and `engine/events/battle_tower*.asm` were not in the audited snapshot: box deposit/withdraw encode/decode of the Hidden Power bits and 14-bit moves, and whether Battle Tower's bank-3 staged parties (8-bit IDs, not GC roots) survive a mid-tower save, remain unverified.
- Link-battle ordering, mobile paths, the debug battle tester, and `ai/scoring.asm`'s inherited vanilla `AI_Smart_*` handlers (skimmed, not read line by line).
- A fresh row-by-row canon diff of moves 1–351 (last audit did it; structural cross-checks were repeated here).
