; Effect Commands overflow (Battle Effect Overflow bank) — keeps Effect Commands bank under its limit.

BattleCurl_Core:
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVarAddr
	set SUBSTATUS_CURLED, [hl]
	ret

BattleCheckRampage_Core:
	ld de, wPlayerRolloutCount
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	ld de, wEnemyRolloutCount
.player
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_RAMPAGE, [hl]
	ret z
	ld a, [de]
	dec a
	ld [de], a
	jr nz, .continue_rampage

	res SUBSTATUS_RAMPAGE, [hl]
	callfar BattleCommand_SwitchTurn
	callfar SafeCheckSafeguard
	push af
	callfar BattleCommand_SwitchTurn
	pop af
	jr nz, .continue_rampage

	; Own Tempo prevents fatigue confusion (silently, like Safeguard)
	farcall GetTrueUserAbility_b
	ld a, b
	cp OWN_TEMPO
	jr z, .continue_rampage

	; NOTE: the callfar/farcall macros above load their TARGET ADDRESS
	; into hl, so the SUBSTATUS3 pointer fetched at the top of this
	; routine is long gone by here - the old "set ..., [hl]" wrote bit 7
	; into a ROM address (an MBC register poke) and fatigue confusion
	; never landed on ANY rampage user (found 2026-08-09 by the battle
	; tester's Thrash probe). Re-fetch the address. de (ConfuseCount
	; pointer - 1) is not touched by these calls and survives.
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	set SUBSTATUS_CONFUSED, [hl]
	call BattleRandom
	and %00000001
	inc a
	inc a
	inc de ; ConfuseCount
	ld [de], a
.continue_rampage
	ld b, rampage_command
	callfar SkipToBattleCommand
	ret

BattleRampage_Core:
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	ret nz

	ld de, wPlayerRolloutCount
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, wEnemyRolloutCount
.ok
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	set SUBSTATUS_RAMPAGE, [hl]
	call BattleRandom
	and %00000001
	inc a
	ld [de], a
	ld a, 1
	ld [wSomeoneIsRampaging], a
	ret

BattleRechargeNextTurn_Core:
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	set SUBSTATUS_RECHARGE, [hl]
	ret

BattleSkipSunCharge_Core:
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	jr z, .skip_charge
	; Mega Sol: the user's Solar Beam acts as if the sun were shining
	farcall GetTrueUserAbility_b
	ld a, b
	cp MEGA_SOL
	ret nz
.skip_charge
	ld b, charge_command
	callfar SkipToBattleCommand
	ret

BattleUserHasLoadedDice_Core:
; Return z if the user holds Loaded Dice.
	push bc
	callfar GetUserItem
	ld a, b
	pop bc
	cp HELD_LOADED_DICE
	ret

BattleCheckHitLoadedDiceTripleKick_Core:
; Return z if Triple Kick/Axel hit 2+ with Loaded Dice (skip accuracy).
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_TRIPLE_KICK
	ret nz
	ld a, [wKickCounter]
	and a
	jr z, .first_kick
	jp BattleUserHasLoadedDice_Core
.first_kick
	or 1
	ret

BattleMultiHitRoll_Core:
; Leave the final endloop loop count in wPredefTemp.
; Must not return it in a: callfar clobbers a while restoring the bank.
; NOTE: BattleRandom itself stores its result in wPredefTemp + 1 (see
; home/random.asm), so that byte can never carry flags out of here.
; (A previous version did exactly that - the "skip inc" flag came back
; as random garbage, loop counts of 0 underflowed to 255 in endloop,
; and multi-hit moves pummeled the target until it fainted.)
	; Skill Link always hits 5 times.
	; MUST preserve bc: EndLoop keeps its hit-counter pointer in bc across
	; this callfar, and farcall passes the callee's final bc back to the
	; caller (clobbering b here wrote the hit count to a stray address -
	; VRAM pixel garbage + "Hit 0 times!").
	push bc
	farcall GetTrueUserAbility_b
	ld a, b
	pop bc
	cp SKILL_LINK
	ld a, 4 ; loop count 4 (5 hits total)
	jr z, .store
	call BattleUserHasLoadedDice_Core
	jr z, .loaded_dice
	call BattleRandom
	and $3
	cp 2
	jr c, .got_roll
	call BattleRandom
	and $3
.got_roll
	inc a ; loop count 1-4 (2-5 hits total)
	jr .store

.loaded_dice
	call BattleRandom
	and 1
	add 3 ; loop count 3-4 (4-5 hits total)
.store
	ld [wPredefTemp], a
	ret



; ==== 2026-07 move expansion cores ====

BattleBanefulBunker_Core:
; Protect variant: also poisons attackers that make contact.
	callfar ProtectChance
	ret c

	; mark this side's protect as a Baneful Bunker
	ld hl, wBunkerFlags
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	set 0, [hl]
	jr .protect
.enemy
	set 1, [hl]
.protect
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	set SUBSTATUS_PROTECT, [hl]

	callfar AnimateCurrentMove

	ld hl, ProtectedItselfText
	jp StdBattleTextbox

BanefulBunkerPunish_Core:
; Called from CheckHit's protect block: the current turn holder just got
; its contact move blocked. Poison it if the block was a Baneful Bunker.
	ld hl, wBunkerFlags
	ldh a, [hBattleTurn]
	and a
	jr z, .attacker_is_player
	bit 0, [hl] ; defender is the player
	ret z
	jr .bunkered
.attacker_is_player
	bit 1, [hl] ; defender is the enemy
	ret z
.bunkered
	farcall CheckContactMove
	ret nc

	; the victim here is the ATTACKER (the current turn holder)
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	ld a, [hl]
	and a
	ret nz ; already has a status

	ld de, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld de, wEnemyMonType1
.got_types
	ld a, [de]
	cp POISON
	ret z
	cp STEEL
	ret z
	inc de
	ld a, [de]
	cp POISON
	ret z
	cp STEEL
	ret z

	push hl
	farcall GetTrueUserAbility_b
	pop hl
	ld a, b
	cp IMMUNITY
	ret z
	cp PASTEL_VEIL
	ret z

	; the attacker's own Safeguard protects it
	push hl
	ld hl, wPlayerScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .got_safeguard
	ld hl, wEnemyScreens
.got_safeguard
	bit SCREENS_SAFEGUARD, [hl]
	pop hl
	ret nz

	set PSN, [hl]
	call UpdateUserInParty
	ld de, ANIM_PSN
	ld a, e
	ld [wFXAnimID], a
	ld a, d
	ld [wFXAnimID + 1], a
	xor a
	ld [wNumHits], a
	farcall PlayBattleAnim
	call RefreshBattleHuds
	ld hl, UserWasPoisonedText
	call StdBattleTextbox
	; The poisoned attacker is the current turn holder. Switch to the
	; Bunker user's perspective so Synchronize/Poison Puppeteer and the
	; shared held-item handler all see the poisoned mon as the opponent.
	farcall SwitchTurn
	farcall RunSynchronizePsn
	farcall UseHeldStatusHealingItem
	farcall SwitchTurn
	ret

BattleDireClaw_Core:
; 50% chance (the move's effect chance) of poison, paralysis or sleep.
	callfar BattleCommand_EffectChance
	ld a, [wEffectFailed]
	and a
	ret nz
.roll
	call BattleRandom
	swap a
	and %11
	jr z, .roll
	dec a
	jr z, .paralyze
	dec a
	jr z, .poison
	; sleep, applied silently on failure (unlike the sleeptarget command)
	ld a, [wAttackMissed]
	and a
	ret nz
	callfar CheckSubstituteOpp
	ret nz
	callfar SafeCheckSafeguard
	ret nz
	farcall AbilityPreventsSleep
	ret c
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	ld a, [hl]
	and a
	ret nz
.sleep_roll
	call BattleRandom
	and %11
	jr z, .sleep_roll
	ld [hl], a ; 1-3 turns of sleep
	call UpdateOpponentInParty
	ld de, ANIM_SLP
	farcall AbilityStatusAnim
	call RefreshBattleHuds
	ld hl, FellAsleepText
	call StdBattleTextbox
	farcall UseHeldStatusHealingItem
	ret

.paralyze
	callfar BattleCommand_ParalyzeTarget
	ret

.poison
	callfar BattleCommand_PoisonTarget
	ret

SetStealthRockSide:
; hl = the side's screens byte for the CURRENT TARGET
	ld hl, wEnemyScreens
	ldh a, [hBattleTurn]
	and a
	ret z
	ld hl, wPlayerScreens
	ret

BattleStealthRock_Core:
; Scatter pointed stones on the target's side. Fails if already set.
	call SetStealthRockSide
	bit SCREENS_STEALTH_ROCK, [hl]
	jr nz, .failed
	set SCREENS_STEALTH_ROCK, [hl]
	callfar AnimateCurrentMove
	ld hl, StealthRockText
	jp StdBattleTextbox
.failed
	callfar FailMove
	ret

BattleStealthRockHit_Core:
; Stone Axe: leave stealth rocks after a successful hit (silent if
; stones are already floating). Its guaranteed hazard is a removable
; secondary effect, so Sheer Force suppresses it on both ordinary hits
; and the KO hook. Do not use EffectChance here: Stone Axe intentionally
; lays rocks through Substitute, matching its after-sub-damage behavior.
	farcall GetTrueUserAbility_b
	ld a, b
	cp SHEER_FORCE
	jr nz, .apply
	farcall CurrentMoveHasSheerForceEffect
	ret c
.apply
	; Contact damage and Life Orb run from checkfaint before its Stone Axe
	; KO hook. The hazard is not placed if those reactions fainted the user.
	farcall UserHasFainted
	ret z
	ld a, [wAttackMissed]
	and a
	ret nz
	call SetStealthRockSide
	bit SCREENS_STEALTH_ROCK, [hl]
	ret nz
	set SCREENS_STEALTH_ROCK, [hl]
	ld hl, StealthRockText
	jp StdBattleTextbox

StealthRockEntryDamage:
; Hurt a mon switching in if pointed stones float on its side.
; Like SpikesDamage, the victim is the current turn holder.
	ld hl, wPlayerScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .got_side
	ld hl, wEnemyScreens
.got_side
	bit SCREENS_STEALTH_ROCK, [hl]
	ret z

	; Magic Guard prevents hazard damage, but not the Toxic Spikes
	; processing that follows when this routine returns to its caller.
	call UserHasMagicGuard_Core
	ret z

	; damage = 1/8 max HP scaled by ROCK's effectiveness on the victim
	ld hl, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld hl, wEnemyMonType1
.got_types
	ld a, ROCK
	callfar CheckTypeMatchup

	callfar GetEighthMaxHP
	ld a, [wTypeMatchup]
	cp 10
	jr z, .apply
	cp 20
	jr nz, .not_double
	sla c
	rl b
	jr .apply
.not_double
	cp 40
	jr nz, .not_quadruple
	sla c
	rl b
	sla c
	rl b
	jr .apply
.not_quadruple
	cp 5
	jr nz, .quarter
	srl b
	rr c
	jr .min_one
.quarter
	srl b
	rr c
	srl b
	rr c
.min_one
	ld a, b
	or c
	jr nz, .apply
	inc c
.apply
	push bc
	ld hl, StealthRockHurtText
	call StdBattleTextbox
	pop bc
	callfar SubtractHPFromTarget
	call RefreshBattleHuds
	ret

BattleDefog_Core:
; Blow away hazards on both sides and screens on the target's side.
	ld a, [wAttackMissed]
	and a
	ret nz
	ld e, 0 ; "cleared anything" flag

	ld hl, wPlayerScreens
	call .clear_hazards
	ld hl, wEnemyScreens
	call .clear_hazards

	ld hl, wEnemyScreens
	ld bc, wEnemyLightScreenCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens
	ld hl, wPlayerScreens
	ld bc, wPlayerLightScreenCount
.got_screens
	ld a, [hl]
	and 1 << SCREENS_LIGHT_SCREEN | 1 << SCREENS_REFLECT
	jr z, .no_screens
	ld e, 1
	ld a, [hl]
	and (1 << SCREENS_LIGHT_SCREEN | 1 << SCREENS_REFLECT) ^ $ff
	ld [hl], a
	xor a
	ld [bc], a ; light screen count
	inc bc
	ld [bc], a ; reflect count
.no_screens
	ld a, e
	and a
	ret z
	ld hl, DefogClearedText
	jp StdBattleTextbox

.clear_hazards
	ld a, [hl]
	ld d, a
	and 1 << SCREENS_SPIKES | 1 << SCREENS_STEALTH_ROCK | SCREENS_TOXIC_SPIKES_MASK
	ret z
	ld e, 1
	ld a, d
	and (1 << SCREENS_SPIKES | 1 << SCREENS_STEALTH_ROCK | SCREENS_TOXIC_SPIKES_MASK) ^ $ff
	ld [hl], a
	ret

BattleGlaiveRush_Core:
; After a landed Glaive Rush, the user can't avoid attacks and takes
; double damage until the start of its next turn.
	ld a, [wAttackMissed]
	and a
	ret nz
	ld hl, wPlayerGlaiveRush
	ldh a, [hBattleTurn]
	and a
	jr z, .got_flag
	inc hl ; wEnemyGlaiveRush
.got_flag
	ld [hl], 1
	ret

GlaiveRushIncomingDouble_Core:
; Double the computed damage if the DEFENDER is in Glaive Rush recoil.
	ld a, [wIsConfusionDamage]
	and a
	ret nz
	ldh a, [hBattleTurn]
	and a
	jr z, .player_attacking
	ld a, [wPlayerGlaiveRush]
	jr .check
.player_attacking
	ld a, [wEnemyGlaiveRush]
.check
	and a
	ret z
	jp DoubleDamage_Core

BattleFickleBeam_Core:
; 30% of the time Fickle Beam fires at double power.
	; runs after checkhit: don't roll (or print) once the move has missed
	ld a, [wAttackMissed]
	and a
	ret nz
	call BattleRandom
	cp 30 percent
	ret nc
	call DoubleDamage_Core
	ld hl, FickleBeamAllOutText
	jp StdBattleTextbox

BattleRageFistPower_Core:
; d = move power. Add 50 per hit the user has taken (capped at 250).
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	ld a, [wEnemyRageFistHits]
	jr .got_hits
.player
	ld a, [wPlayerRageFistHits]
.got_hits
	cp 5
	jr c, .capped
	ld a, 4
.capped
	and a
	ret z
.loop
	push af
	ld a, d
	add 50
	ld d, a
	pop af
	dec a
	jr nz, .loop
	ret

BattleShellSideArm_Core:
; Become physical or special, whichever would hit harder:
; physical if Atk * target SpDef > SpAtk * target Def (ties go special).
; All four stats are halved together until they fit in 8 bits, which
; preserves the comparison.
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy_user
	ld a, [wPlayerAttack]
	ld [wBuffer1], a
	ld a, [wPlayerAttack + 1]
	ld [wBuffer2], a
	ld a, [wPlayerSpAtk]
	ld [wBuffer3], a
	ld a, [wPlayerSpAtk + 1]
	ld [wBuffer4], a
	ld a, [wEnemyDefense]
	ld [wBuffer5], a
	ld a, [wEnemyDefense + 1]
	ld [wBuffer6], a
	ld a, [wEnemySpDef]
	ld [wCurDamage], a
	ld a, [wEnemySpDef + 1]
	ld [wCurDamage + 1], a
	jr .shift_loop
.enemy_user
	ld a, [wEnemyAttack]
	ld [wBuffer1], a
	ld a, [wEnemyAttack + 1]
	ld [wBuffer2], a
	ld a, [wEnemySpAtk]
	ld [wBuffer3], a
	ld a, [wEnemySpAtk + 1]
	ld [wBuffer4], a
	ld a, [wPlayerDefense]
	ld [wBuffer5], a
	ld a, [wPlayerDefense + 1]
	ld [wBuffer6], a
	ld a, [wPlayerSpDef]
	ld [wCurDamage], a
	ld a, [wPlayerSpDef + 1]
	ld [wCurDamage + 1], a

.shift_loop
	ld a, [wBuffer1]
	ld b, a
	ld a, [wBuffer3]
	or b
	ld b, a
	ld a, [wBuffer5]
	or b
	ld b, a
	ld a, [wCurDamage]
	or b
	jr z, .small_enough
	ld hl, wBuffer1
	call .halve
	ld hl, wBuffer3
	call .halve
	ld hl, wBuffer5
	call .halve
	ld hl, wCurDamage
	call .halve
	jr .shift_loop

.halve
	ld a, [hl]
	srl a
	ld [hli], a
	ld a, [hl]
	rra
	ld [hld], a
	ret

.small_enough
	; m1 = Atk * target SpDef
	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, [wBuffer2]
	ldh [hMultiplicand + 2], a
	ld a, [wCurDamage + 1]
	ldh [hMultiplier], a
	call Multiply
	ldh a, [hProduct + 2]
	ld d, a
	ldh a, [hProduct + 3]
	ld e, a
	; m2 = SpAtk * target Def
	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, [wBuffer4]
	ldh [hMultiplicand + 2], a
	ld a, [wBuffer6]
	ldh [hMultiplier], a
	call Multiply
	ldh a, [hProduct + 2]
	ld b, a
	ldh a, [hProduct + 3]
	ld c, a
	; physical iff de > bc
	ld a, d
	cp b
	jr c, .special
	jr nz, .physical
	ld a, e
	cp c
	jr c, .special
	jr z, .special
.physical
	ld b, CATEGORIZE_PHYSICAL
	jr .store
.special
	ld b, CATEGORIZE_SPECIAL
.store
	ld hl, wPlayerMoveStructCategory
	ldh a, [hBattleTurn]
	and a
	jr z, .store_it
	ld hl, wEnemyMoveStructCategory
.store_it
	ld [hl], b
	; wCurDamage was used as scratch; damagestats resets it anyway
	xor a
	ld [wCurDamage], a
	ld [wCurDamage + 1], a
	ret

BattleEerieSpell_Core:
; Sap 3 PP from the target's last used move (silent when impossible).
; It is a guaranteed additional effect: Sheer Force boosts the hit and
; suppresses this PP loss. Keep the direct gate so Eerie Spell retains its
; intentional ability to affect a target behind Substitute.
	farcall GetTrueUserAbility_b
	ld a, b
	cp SHEER_FORCE
	jr nz, .apply
	farcall CurrentMoveHasSheerForceEffect
	ret c
.apply
	ld a, [wAttackMissed]
	and a
	ret nz
	ld bc, PARTYMON_STRUCT_LENGTH
	ld hl, wEnemyMonMoves
	ldh a, [hBattleTurn]
	and a
	jr z, .got_moves
	ld hl, wBattleMonMoves
.got_moves
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	and a
	ret z
	ld b, a
	push bc
	push hl
	ld bc, STRUGGLE
	callfar CompareMove
	pop hl
	pop bc
	ret z
	ld c, -1
.loop
	inc c
	ld a, c
	cp NUM_MOVES
	ret nc ; not in the move list anymore (Mimic etc.) - no effect
	ld a, [hli]
	cp b
	jr nz, .loop
	ld [wNamedObjectIndexBuffer], a
	dec hl
	ld b, 0
	push bc
	ld c, wBattleMonPP - wBattleMonMoves
	add hl, bc
	pop bc
	ld a, [hl]
	and PP_MASK
	ret z
	push bc
	call GetMoveName
	ld b, 3 ; always saps 3 PP
	ld a, [hl]
	and PP_MASK
	cp b
	jr nc, .deplete_pp
	ld b, a
.deplete_pp
	ld a, [hl]
	sub b
	ld [hl], a
	push af
	ld a, MON_PP
	call OpponentPartyAttr
	ld d, b
	pop af
	pop bc
	add hl, bc
	ld e, a
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVar
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .transformed
	ldh a, [hBattleTurn]
	and a
	jr nz, .not_wildmon
	ld a, [wBattleMode]
	dec a
	jr nz, .not_wildmon
	ld hl, wWildMonPP
	add hl, bc
.not_wildmon
	ld [hl], e
.transformed
	ld a, d
	ld [wDeciramBuffer], a
	ld hl, SpiteEffectText
	jp StdBattleTextbox

BattleTrapTarget_Core:
; Body of BattleCommand_TrapTarget (moved here for bank space).
	ld a, [wAttackMissed]
	and a
	ret nz
	ld hl, wEnemyWrapCount
	ld de, wEnemyTrappingMove
	ldh a, [hBattleTurn]
	and a
	jr z, .got_trap
	ld hl, wPlayerWrapCount
	ld de, wPlayerTrappingMove

.got_trap
	ld a, [hl]
	and a
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret nz
	call BattleRandom
	; trapped for 2-5 turns
	and %11
	inc a
	inc a
	inc a
	ld [hl], a
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld [de], a
	call GetMoveIndexFromID
	ld b, h
	ld c, l
	ld hl, .Traps

.find_trap_text
	ld a, [hli]
	cp c
	ld a, [hli]
	jr nz, .next_trap_text
	cp b
	jr z, .found_trap_text
.next_trap_text
	inc hl
	inc hl
	jr .find_trap_text

.found_trap_text
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextbox

.Traps:
	dw BIND,      UsedBindText      ; 'used BIND on'
	dw WRAP,      WrappedByText     ; 'was WRAPPED by'
	dw FIRE_SPIN, FireSpinTrapText  ; 'was trapped!'
	dw CLAMP,     ClampedByText     ; 'was CLAMPED by'
	dw WHIRLPOOL, WhirlpoolTrapText ; 'was trapped!'

BattleScaleShotKO_Core:
; Scale Shot still lowers the user's DEFENSE and raises its SPEED when
; the final hit KOs the target (the script's endloop tail never runs in
; that case). Called from BattleCommand_CheckFaint.
	callfar BattleCommand_SaveMiss
	callfar BattleCommand_SwitchTurn
	callfar BattleCommand_DefenseDown
	callfar BattleCommand_SwitchTurn
	callfar BattleCommand_SwitchTurn
	callfar BattleCommand_StatDownMessage
	callfar BattleCommand_SwitchTurn
	callfar BattleCommand_SpeedUp
	callfar BattleCommand_StatUpMessage
	callfar BattleCommand_RestoreMiss
	ret

BattleBrickBreak_Core:
; Shatter Reflect and Light Screen on the target's side before the
; damage is dealt. If the target is immune to the move (e.g. a Ghost
; type against this Fighting move), the screens are spared.
	callfar BattleCheckTypeMatchup
	ld a, [wTypeMatchup]
	and a
	ret z

	ld hl, wEnemyScreens
	ld de, wEnemyLightScreenCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens
	ld hl, wPlayerScreens
	ld de, wPlayerLightScreenCount
.got_screens
	ld a, [hl]
	and 1 << SCREENS_LIGHT_SCREEN | 1 << SCREENS_REFLECT
	ret z

	ld a, [hl]
	and (1 << SCREENS_LIGHT_SCREEN | 1 << SCREENS_REFLECT) ^ $ff
	ld [hl], a
	xor a
	ld [de], a ; light screen count
	inc de
	ld [de], a ; reflect count
	ld hl, BrickBreakShatterText
	jp StdBattleTextbox

BattleCheckCharge_Core:
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_CHARGED, [hl]
	ret z
	res SUBSTATUS_CHARGED, [hl]
	res SUBSTATUS_UNDERGROUND, [hl]
	res SUBSTATUS_FLYING, [hl]
	ld b, charge_command
	callfar SkipToBattleCommand
	ret

BattleVenoshockDouble_Core:
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and 1 << PSN
	ret z
	jr DoubleDamage_Core

BattleDoubleFlyingDamage_Core:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_FLYING, a
	ret z
	jr DoubleDamage_Core

BattleDoubleUndergroundDamage_Core:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_UNDERGROUND, a
	ret z
	jr DoubleDamage_Core

BattleDoubleMinimizeDamage_Core:
	ld hl, wEnemyMinimized
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wPlayerMinimized
.ok
	ld a, [hl]
	and a
	ret z
	jr DoubleDamage_Core

DoubleDamage_Core:
	ld hl, wCurDamage + 1
	sla [hl]
	dec hl
	rl [hl]
	jr nc, .quit

	ld a, $ff
	ld [hli], a
	ld [hl], a
.quit
	ret

HeldDefenseBoost_Core:
; bc = defending stat. Returns boosted bc when applicable.
	push hl
	push de
	push bc
	callfar GetOpponentItem
	ld a, b
	cp HELD_ASSAULT_VEST
	jr z, .assault_vest
	cp HELD_EVIOLITE
	jr z, .eviolite
	pop bc
	jr .done
.assault_vest
	call .CurrentMoveCategory
	cp CATEGORIZE_SPECIAL
	pop bc
	jr nz, .done
	call .BoostBCx1_5
	jr .done
.eviolite
	call .OpponentCanEvolve
	pop bc
	jr nc, .done
	call .BoostBCx1_5
.done
	pop de
	pop hl
	ret

.CurrentMoveCategory
	ld hl, wPlayerMoveStructCategory
	ldh a, [hBattleTurn]
	and a
	jr z, .got_category
	ld hl, wEnemyMoveStructCategory
.got_category
	ld a, [hl]
	ret

.OpponentCanEvolve
	ld a, [wEnemyMonSpecies]
	ldh [hTemp], a
	ldh a, [hBattleTurn]
	and a
	jr z, .got_species
	ld a, [wBattleMonSpecies]
	ldh [hTemp], a
.got_species
	ldh a, [hTemp]
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	ld hl, EvosAttacksPointers
	ld a, BANK(EvosAttacksPointers)
	call LoadDoubleIndirectPointer
	call GetFarByte
	and a
	ret z
	scf
	ret

.BoostBCx1_5
	ld h, b
	ld l, c
	ld d, b
	ld e, c
	srl d
	rr e
	add hl, de
	jr nc, .store_boost
	ld hl, $ffff
.store_boost
	ld b, h
	ld c, l
	ret

DittoMetalPowder_Core::
; Apply Metal Powder's 1.5x defensive boost before the 16-to-8-bit stat
; truncation. Applying it afterwards can increase damage when Defense has
; already been scaled down, and the old bytewise math can overflow.
	ld a, MON_SPECIES
	call BattlePartyAttr
	ldh a, [hBattleTurn]
	and a
	ld a, [hl]
	jr nz, .got_species
	ld a, [wTempEnemyMonSpecies]
.got_species
	push hl
	call GetPokemonIndexFromID
	ld a, l
	sub LOW(DITTO)
	if HIGH(DITTO) == 0
		or h
		pop hl
	else
		ld a, h
		pop hl
		ret nz
		if HIGH(DITTO) == 1
			dec a
		else
			cp HIGH(DITTO)
		endc
	endc
	ret nz

	push bc
	callfar GetOpponentItem
	ld a, [hl]
	cp METAL_POWDER
	pop bc
	ret nz

	ld h, b
	ld l, c
	srl b
	rr c
	add hl, bc
	ld b, h
	ld c, l
	ld a, HIGH(MAX_STAT_VALUE)
	cp b
	jr c, .cap
	ret nz
	ld a, LOW(MAX_STAT_VALUE)
	cp c
	ret nc
.cap
	ld bc, MAX_STAT_VALUE
	ret

EndureFocusSashInEffect_Core:
; Carry if ApplyDamage should proceed to damage. b = survival message id.
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_ENDURE, a
	jr z, .sturdy
	farcall BattleCommand_FalseSwipe
	ld b, 0
	jp nc, .go_damage
	ld b, 1
	jp .go_damage
.sturdy
	; Sturdy (Gen 5): survives any hit taken at full HP
	farcall GetOppIgnorableAbility_b
	ld a, b
	cp STURDY
	jr nz, .focus_sash
	ld de, wEnemyMonHP
	ld hl, wEnemyMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .sturdy_got_hp
	ld de, wBattleMonHP
	ld hl, wBattleMonMaxHP
.sturdy_got_hp
	ld a, [de]
	cp [hl]
	jr nz, .focus_sash
	inc de
	inc hl
	ld a, [de]
	cp [hl]
	jr nz, .focus_sash
	farcall BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .go_damage
	; it would have been KO'd: banner + "endured the hit"
	farcall ShowEnemyAbilityBannerBrief
	ld b, 1
	jr .go_damage
.focus_sash
	callfar GetOpponentItem
	ld a, b
	cp HELD_FOCUS_SASH
	jr nz, .not_sash
	ld de, wEnemyMonHP
	ld hl, wEnemyMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld de, wBattleMonHP
	ld hl, wBattleMonMaxHP
.got_hp
	ld a, [de]
	cp [hl]
	jr nz, .no_trigger
	inc de
	inc hl
	ld a, [de]
	cp [hl]
	jr nz, .no_trigger
	farcall BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .go_damage
	; buffer the Sash's name now: ConsumeHeldItem zeroes the item slot,
	; so the hung-on text in ApplyDamage can't re-read it after damage
	callfar GetOpponentItem
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	callfar ConsumeHeldItem
	ld b, 3
.go_damage
	scf
	ret
.no_trigger
	ld b, 0
	scf
	ret
.not_sash
	and a
	ret

BattleStartHail_Core:
	ld a, [wBattleWeather]
	and WEATHER_TYPE_MASK
	cp WEATHER_HAIL
	jr z, .failed

	ld b, WEATHER_HAIL
	farcall SetBattleWeatherFromB
	ld a, 5
	ld [wWeatherCount], a
	callfar AnimateCurrentMove
	ld hl, ItStartedToHailText
	jp StdBattleTextbox

.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

WeatherDefenseBoost_Core:
; Raise the defending Pokémon's defense stat in bc by 50%
; if its type benefits from the current weather:
; - Ice-types get 1.5x Defense against physical moves in hail.
; - Rock-types get 1.5x Sp.Def against special moves in a sandstorm.
	push de
	ld a, [wBattleWeather]
	cp WEATHER_HAIL
	jr z, .hail
	cp WEATHER_SANDSTORM
	jr nz, .done
; sandstorm
	ld d, CATEGORIZE_SPECIAL
	ld e, ROCK
	jr .got_weather
.hail
	ld d, CATEGORIZE_PHYSICAL
	ld e, ICE
.got_weather
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerMoveStruct + MOVE_CATEGORY]
	ld hl, wEnemyMonType1
	jr z, .got_category
	ld a, [wEnemyMoveStruct + MOVE_CATEGORY]
	ld hl, wBattleMonType1
.got_category
	cp d
	jr nz, .done
	ld a, [hli]
	cp e
	jr z, .boost
	ld a, [hl]
	cp e
	jr nz, .done
.boost
; bc = bc * 1.5
	ld h, b
	ld l, c
	srl h
	rr l
	add hl, bc
	ld b, h
	ld c, l
.done
	pop de
	ret

BattleUTurn_Core:
	ld a, [wAttackMissed]
	and a
	ret nz
	; Contact recoil can faint the user in CheckFaint's post-hit hook.
	; A fainted user must go through normal replacement, not pivot out.
	farcall UserHasFainted
	ret z

	ldh a, [hBattleTurn]
	and a
	jp nz, .enemy

	callfar CheckAnyOtherAlivePartyMons
	ret z

	; record the outgoing mon so switch-out abilities (Regenerator/
	; Natural Cure) heal the right party slot in BattleMonEntrance
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a

	callfar UpdateBattleMonInParty
	call LoadStandardMenuHeader
	farcall SetUpBattlePartyMenu_NoLoop
	farcall ForcePickSwitchMonInBattle
	call ClearPalettes
	farcall _LoadBattleFontsHPBar
	call CloseWindow
	call ClearSprites
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	ld b, SCGB_BATTLE_COLORS
	call GetSGBLayout
	call SetPalettes
	callfar BatonPass_LinkPlayerSwitch

	farcall CheckMobileBattleError
	ret c

	; ForcePickSwitchMonInBattle stored the chosen slot in wCurPartyMon, but
	; BattleMonEntrance keys off wCurBattleMon (and overwrites wCurPartyMon
	; from it). Without this copy it re-sends the U-turn user. The normal
	; switch path (TryPlayerSwitch) does the same copy before entering.
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a

	ld hl, BattleMonEntrance
	ld a, BANK("Battle Core")
	rst FarCall
	ret

.enemy
	ld a, [wBattleMode]
	dec a ; WILDMON
	ret z

	callfar CheckAnyOtherAliveEnemyMons
	ret z

	callfar UpdateEnemyMonInParty
	; switch-out abilities for the outgoing enemy mon
	farcall RunEnemySwitchOutAbilities
	callfar BatonPass_LinkEnemySwitch

	farcall CheckMobileBattleError
	ret c

	ld hl, EnemySwitch
	ld a, BANK("Battle Core")
	rst FarCall
	ret

BattleParalyze_Core:
; Relocated from effect_commands.asm; in-bank calls became callfar.
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	bit PAR, a
	jp nz, .paralyzed
	ld a, [wTypeModifier]
	and $7f
	jp z, .didnt_affect
	farcall OpponentIsElectricType
	jp z, .didnt_affect
	callfar GetOpponentItem
	ld a, b
	cp HELD_PREVENT_PARALYZE
	jr nz, .no_item_protection
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	callfar AnimateFailedMove
	ld hl, ProtectedByText
	jp StdBattleTextbox

.no_item_protection
	ldh a, [hBattleTurn]
	and a
	jr z, .dont_sample_failure

	ld a, [wLinkMode]
	and a
	jr nz, .dont_sample_failure

	ld a, [wInBattleTowerBattle]
	and a
	jr nz, .dont_sample_failure

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_LOCK_ON, a
	jr nz, .dont_sample_failure

	call BattleRandom
	cp 25 percent + 1 ; 25% chance AI fails
	jp c, .failed

.dont_sample_failure
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	jp nz, .failed
	ld a, [wAttackMissed]
	and a
	jp nz, .failed
	callfar CheckSubstituteOpp
	jp nz, .failed
	; ability check (Limber)
	farcall AbilityPreventsParalysis
	jp c, .failed
	ld c, 30
	call DelayFrames
	callfar AnimateCurrentMove
	ld a, $1
	ldh [hBGMapMode], a
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PAR, [hl]
	call UpdateOpponentInParty
	; CallBattleCore lives in the Effect Commands bank; this file is in the
	; Battle Effect Overflow bank, so a plain call to it jumps into garbage
	; and crashes (every move-inflicted paralysis that LANDED did this).
	; farcall does the same job with the target's own bank.
	farcall ApplyPrzEffectOnSpeed
	call UpdateBattleHuds
	callfar PrintParalyze
	; Synchronize passes move-inflicted paralysis back (this body covers
	; the pure status moves - Thunder Wave/Glare/Stun Spore - which were
	; the one paralysis path missing the hook)
	farcall RunSynchronizePar
	farcall UseHeldStatusHealingItem
	ret

.paralyzed
	callfar AnimateFailedMove
	ld hl, AlreadyParalyzedText
	jp StdBattleTextbox

.failed
	callfar PrintDidntAffect2
	ret

.didnt_affect
	callfar AnimateFailedMove
	callfar PrintDoesntAffect
	ret

; (BattleCommand_EffectChance_Core, BattleOHKO_Core and BattleRecoil_Core
; live in the Abilities Engine bank - this bank was full.)

BattleParalyzeTarget_Core:
; Relocated from effect_commands.asm. Adds the missing ability check
; (Limber - secondary paralysis used to bypass it) and Synchronize.
	xor a
	ld [wNumHits], a
	callfar CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	ret nz
	ld a, [wTypeModifier]
	and $7f
	ret z
	farcall OpponentIsElectricType
	ret z
	callfar GetOpponentItem
	ld a, b
	cp HELD_PREVENT_PARALYZE
	ret z
	ld a, [wEffectFailed]
	and a
	ret nz
	callfar SafeCheckSafeguard
	ret nz
	farcall AbilityPreventsParalysis
	ret c
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PAR, [hl]
	call UpdateOpponentInParty
	farcall ApplyPrzEffectOnSpeed
	ld de, ANIM_PAR
	farcall AbilityStatusAnim
	call UpdateBattleHuds
	callfar PrintParalyze
	farcall RunSynchronizePar
	farcall UseHeldStatusHealingItem
	ret

HandleStatusOrbs_Core:
; FLAME ORB / TOXIC ORB: status the holder at the end of the turn.
; Self-inflicted, so Safeguard doesn't block it (canon).
; Farcalled from HandleBetweenTurnEffects (core.asm).
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .DoEnemyFirst
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jp .do_it

.DoEnemyFirst:
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn

.do_it
	callfar GetUserItem
	ld a, b
	cp HELD_FLAME_ORB
	jr z, .flame_orb
	cp HELD_TOXIC_ORB
	jr z, .toxic_orb
	ret

.flame_orb
	call .GetHolderState
	ret c ; fainted or already statused
	; Fire-types can't be burned
	ld a, [de]
	cp FIRE
	ret z
	inc de
	ld a, [de]
	cp FIRE
	ret z
	; nor can mons whose ability prevents burns
	farcall GetTrueUserAbility_b
	ld a, b
	cp WATER_VEIL
	ret z
	cp THERMAL_EXCHANGE
	ret z
	call .GetOrbName
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	set BRN, [hl]
	call UpdateUserInParty
	; burn halves Attack; ApplyBrnEffectOnAttack works on the
	; opponent of the turn holder, so flip perspective around it
	callfar BattleCommand_SwitchTurn
	farcall ApplyBrnEffectOnAttack
	callfar BattleCommand_SwitchTurn
	ld de, ANIM_BRN
	call .OrbAnim
	call RefreshBattleHuds
	ld hl, BattleText_BurnedByItem
	jp StdBattleTextbox

.toxic_orb
	call .GetHolderState
	ret c ; fainted or already statused
	; Poison- and Steel-types can't be poisoned
	ld a, [de]
	cp POISON
	ret z
	cp STEEL
	ret z
	inc de
	ld a, [de]
	cp POISON
	ret z
	cp STEEL
	ret z
	; nor can mons whose ability prevents poison
	farcall GetTrueUserAbility_b
	ld a, b
	cp IMMUNITY
	ret z
	cp PASTEL_VEIL
	ret z
	call .GetOrbName
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	set PSN, [hl]
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	set SUBSTATUS_TOXIC, [hl]
	ld hl, wPlayerToxicCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_toxic_count
	ld hl, wEnemyToxicCount
.got_toxic_count
	xor a
	ld [hl], a
	call UpdateUserInParty
	ld de, ANIM_PSN
	call .OrbAnim
	call RefreshBattleHuds
	ld hl, BattleText_BadlyPoisonedByItem
	jp StdBattleTextbox

.GetHolderState
; Carry if the holder can't take the orb's status
; (fainted or already statused). Returns de = holder's types.
	ld hl, wBattleMonHP
	ld de, wBattleMonType
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonHP
	ld de, wEnemyMonType
.got_hp
	ld a, [hli]
	or [hl]
	jr z, .cant
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and a
	jr nz, .cant
	and a ; clear carry
	ret
.cant
	scf
	ret

.GetOrbName
	push de
	callfar GetUserItem
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	pop de
	ret

.OrbAnim
; de = anim id. Like ToxicSpikesPoison's poison_anim, the victim is the
; current turn holder, so PlayBattleAnim renders it on the right mon.
	ld a, e
	ld [wFXAnimID], a
	ld a, d
	ld [wFXAnimID + 1], a
	xor a
	ld [wNumHits], a
	farcall PlayBattleAnim
	ret

CheckSpikesUngrounded_Core:
; Carry if the turn holder avoids Spikes: Flying-type, Levitate,
; Air Balloon, or Magic Guard. Body lives here because
; the Battle Core bank is full. Clobbers b, hl.
	ld hl, wBattleMonType
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld hl, wEnemyMonType
.got_types
	ld a, [hli]
	cp FLYING
	jr z, .ungrounded
	ld a, [hl]
	cp FLYING
	jr z, .ungrounded
	farcall GetTrueUserAbility_b
	ld a, b
	cp LEVITATE
	jr z, .ungrounded
	cp MAGIC_GUARD
	jr z, .ungrounded
	callfar GetUserItem
	ld a, b
	cp HELD_AIR_BALLOON
	jr z, .ungrounded
	and a
	ret
.ungrounded
	scf
	ret

UserHasMagicGuard_Core::
; Return z if the current turn holder's effective ability is Magic Guard.
	farcall GetTrueUserAbility_b
	ld a, b
	cp MAGIC_GUARD
	ret

; ==================================================================
; Stat change messages (moved here from the full Effect Commands bank).
;
; Normal (single-stat) moves behave as before: anim + "X went up!" per
; stat. Multi-stat moves (Bulk Up, Shell Smash, Close Combat, Curse,
; Ancient Power, ...) wrap their stat changes in deferstatmessages /
; flushstatmessages: each raise/drop is recorded in a bitmask, then the
; flush plays the stat up anim ONCE with one combined message listing
; every raised stat, and likewise the stat down anim once for the drops.
; ==================================================================

StatUpMessage_Core:
	ld a, [wFailedMessage]
	and a
	ret nz
	; bit 7 of wLoweredStat: Contrary already printed its own "fell"
	ld a, [wLoweredStat]
	bit 7, a
	jr z, .show
	and $7f
	ld [wLoweredStat], a
	ret
.show
	ld a, [wStatMsgDefer]
	and a
	jr nz, .defer
	call PlayStatUpAnim_Core
	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	callfar GetStatName
	ld hl, .stat
	jp BattleTextbox

.defer
	ld hl, wDeferredUps1
	ld de, wDeferredUpSide
	jp RecordDeferredStat

.stat
	text_far UnknownText_0x1c0cc6
	text_asm
	ld hl, .up
	ld a, [wLoweredStat]
	and $f0
	ret z
	ld hl, .wayup
	ret

.wayup
	text_far UnknownText_0x1c0cd0
	text_end

.up
	text_far UnknownText_0x1c0ce0
	text_end

StatDownMessage_Core:
	ld a, [wFailedMessage]
	and a
	ret nz
	ld a, [wStatMsgDefer]
	and a
	jr nz, .defer
	call PlayStatDownAnim_Core
	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	callfar GetStatName
	ld hl, .stat
	call BattleTextbox
	; Defiant / Competitive react to the drop
	farcall RunStatDropReaction
	ret

.defer
	ld hl, wDeferredDowns1
	ld de, wDeferredDownSide
	jp RecordDeferredStat

.stat
	text_far UnknownText_0x1c0ceb
	text_asm
	ld hl, .fell
	ld a, [wLoweredStat]
	and $f0
	ret z
	ld hl, .sharplyfell
	ret

.sharplyfell
	text_far UnknownText_0x1c0cf5
	text_end

.fell
	text_far UnknownText_0x1c0d06
	text_end

RecordDeferredStat:
; Record the stat change in wLoweredStat instead of printing it.
; hl = "+1" bitmask (the "sharply" bitmask follows it), de = side byte.
	ldh a, [hBattleTurn]
	ld [de], a
	ld a, [wLoweredStat]
	and $f0
	jr z, .got_mask
	inc hl ; sharply mask
.got_mask
	ld a, [wLoweredStat]
	and $f
	inc a
	ld c, a
	xor a
	scf
.shift
	rla
	dec c
	jr nz, .shift
	or [hl]
	ld [hl], a
	ret

DeferStatMessages_Core::
	xor a
	ld [wDeferredUps1], a
	ld [wDeferredUps2], a
	ld [wDeferredDowns1], a
	ld [wDeferredDowns2], a
	ld a, 1
	ld [wStatMsgDefer], a
	ret

FlushStatMessages_Core::
	xor a
	ld [wStatMsgDefer], a
; Raises first, then drops.
	ld a, [wDeferredUps1]
	ld b, a
	ld a, [wDeferredUps2]
	or b
	call nz, .DoUps
	ld a, [wDeferredDowns1]
	ld b, a
	ld a, [wDeferredDowns2]
	or b
	call nz, .DoDowns
	xor a
	ld [wDeferredUps1], a
	ld [wDeferredUps2], a
	ld [wDeferredDowns1], a
	ld [wDeferredDowns2], a
	ret

.DoUps:
	ldh a, [hBattleTurn]
	push af
	ld a, [wDeferredUpSide]
	ldh [hBattleTurn], a
	call .UpsBody
	pop af
	ldh [hBattleTurn], a
	ret

.UpsBody:
	; anim loops twice ("sharply") if any +2 was recorded
	ld b, $00
	ld a, [wDeferredUps2]
	and a
	jr z, .up_anim
	ld b, $10
.up_anim
	ld a, b
	ld [wLoweredStat], a
	call PlayStatUpAnim_Core
	ld a, [wDeferredUps2]
	and a
	jr z, .up_plain
	ld b, a
	ld de, SharplyRoseVerb
	ld hl, DeferredUpListText
	call PrintStatList
.up_plain
	ld a, [wDeferredUps1]
	and a
	ret z
	ld b, a
	ld de, RoseVerb
	ld hl, DeferredUpListText
	jp PrintStatList

.DoDowns:
	ldh a, [hBattleTurn]
	push af
	ld a, [wDeferredDownSide]
	ldh [hBattleTurn], a
	call .DownsBody
	pop af
	ldh [hBattleTurn], a
	ret

.DownsBody:
	ld b, $00
	ld a, [wDeferredDowns2]
	and a
	jr z, .down_anim
	ld b, $10
.down_anim
	ld a, b
	ld [wLoweredStat], a
	call PlayStatDownAnim_Core
	ld a, [wDeferredDowns2]
	and a
	jr z, .down_plain
	ld b, a
	ld de, SharplyFellVerb
	ld hl, DeferredDownListText
	call PrintStatList
.down_plain
	ld a, [wDeferredDowns1]
	and a
	jr z, .reaction
	ld b, a
	ld de, FellVerb
	ld hl, DeferredDownListText
	call PrintStatList
.reaction
	; Defiant / Competitive react once to the whole batch of drops
	farcall RunStatDropReaction
	ret

PrintStatList:
; b = bitmask of stat ids, de = verb string ("@"-terminated),
; hl = wrapper text (DeferredUpListText / DeferredDownListText)
	push hl
	ld a, e
	ld [wDeferredVerb], a
	ld a, d
	ld [wDeferredVerb + 1], a
	call BuildStatListString
	pop hl
	jp BattleTextbox

BuildStatListString:
; Build "NAME1,<CONT>NAME2 and<CONT>NAME3 verb!<PROMPT>" into wStringBuffer2.
; b = bitmask of stat ids (must be nonzero).
; Worst case ("ATTACK, DEFENSE, SPEED, SPCL.ATK and SPCL.DEF sharply rose!")
; is 54 bytes, which fits in wStringBuffer2-4 (57 contiguous bytes).
	; popcount of b -> wDeferredCount
	push bc
	ld c, 0
	ld a, b
.count
	srl a
	jr nc, .count_noinc
	inc c
.count_noinc
	and a
	jr nz, .count
	ld a, c
	ld [wDeferredCount], a
	pop bc

	ld hl, DeferredStatNames
	ld de, wStringBuffer2
.next_stat
	srl b
	jr c, .copy_name
.skip_name
	ld a, [hli]
	cp "@"
	jr nz, .skip_name
	jr .next_stat

.copy_name
	push bc
	ld c, 0
.copy_char
	ld a, [hli]
	cp "@"
	jr z, .copied
	ld [de], a
	inc de
	inc c
	jr .copy_char
.copied
	ld a, c
	ld [wDeferredLastLen], a
	pop bc
	ld a, [wDeferredCount]
	dec a
	ld [wDeferredCount], a
	jr z, .verb ; that was the last name
	cp 1
	jr z, .and_sep
	; "NAME,"
	ld a, ","
	ld [de], a
	inc de
	jr .newline
.and_sep
	; "NAME and"
	push hl
	ld hl, .AndSep
	call .Append
	pop hl
.newline
	ld a, "<CONT>"
	ld [de], a
	inc de
	jr .next_stat

.verb
	; measure the verb
	ld a, [wDeferredVerb]
	ld l, a
	ld a, [wDeferredVerb + 1]
	ld h, a
	push hl
	ld c, 0
.verb_len
	ld a, [hli]
	cp "@"
	jr z, .verb_measured
	inc c
	jr .verb_len
.verb_measured
	pop hl
	; last name + space + verb on one line if it fits (18 chars)
	ld a, [wDeferredLastLen]
	add c
	cp 18
	jr c, .use_space
	ld a, "<CONT>"
	jr .put_sep
.use_space
	ld a, " "
.put_sep
	ld [de], a
	inc de
	call .Append
	ld a, "<PROMPT>"
	ld [de], a
	inc de
	ld a, "@"
	ld [de], a
	ret

.Append
; copy "@"-terminated string from hl to de (terminator not copied)
	ld a, [hli]
	cp "@"
	ret z
	ld [de], a
	inc de
	jr .Append

.AndSep
	db " and@"

RoseVerb:        db "rose!@"
SharplyRoseVerb: db "sharply rose!@"
FellVerb:        db "fell!@"
SharplyFellVerb: db "sharply fell!@"

DeferredStatNames:
; copy of data/battle/stat_names.asm (that copy must stay in the
; Effect Commands bank for GetStatName)
	db "ATTACK@"
	db "DEFENSE@"
	db "SPEED@"
	db "SPCL.ATK@"
	db "SPCL.DEF@"
	db "ACCURACY@"
	db "EVASION@"

DeferredUpListText:
; "<USER>'s" <line> [list from wStringBuffer2]
	text_far UnknownText_0x1c0cc6
	text_end

DeferredDownListText:
; "<TARGET>'s" <line> [list from wStringBuffer2]
	text_far UnknownText_0x1c0ceb
	text_end

PlayStatUpAnim_Core:
; Play the generic stat raise animation on the user's side.
	ld de, ANIM_STAT_UP
	jr PlayStatChangeAnim_Core

PlayStatDownAnim_Core:
; Play the generic stat drop animation on the opponent's side
; (the same side StatDownMessage's text refers to).
	call .SwitchTurn
	ld de, ANIM_STAT_DOWN
	call PlayStatChangeAnim_Core
	; fallthrough
.SwitchTurn:
	ldh a, [hBattleTurn]
	xor 1
	ldh [hBattleTurn], a
	ret

PlayStatChangeAnim_Core:
	push de
	push bc
	farcall CheckBattleScene
	pop bc
	pop de
	ret c
	xor a
	ld [wNumHits], a
	ld [wKickCounter], a
	ld a, e
	ld [wFXAnimID], a
	ld a, d
	ld [wFXAnimID + 1], a
	ld c, 3
	call DelayFrames
	callfar PlayBattleAnim
	ret

INCLUDE "engine/battle/move_effects/triple_kick.asm"
INCLUDE "engine/battle/move_effects/new_move_cores.asm"
INCLUDE "engine/battle/move_effects/thief.asm"

BattleDamageStats_Core:
; damagestats (body; see the stub in effect_commands.asm)

	ldh a, [hBattleTurn]
	and a
	jp nz, EnemyAttackDamage_Core

	; fallthrough

PlayerAttackDamage_Core:
; Return move power d, player level e, enemy defense c and player attack b.

	call ResetDamage

	ld hl, wPlayerMoveStructPower
	ld a, [hli]
	and a
	ld d, a
	ret z

	inc hl ; wPlayerMoveStructType -> Category
	ld a, [hl]
	cp CATEGORIZE_SPECIAL
	jr z, .special

.physical
	ld hl, wEnemyMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]

	ld a, [wEnemyScreens]
	bit SCREENS_REFLECT, a
	jr z, .physicalcrit
	sla c
	rl b

.physicalcrit
	; pick the unboosted attacking-stat source (used on crits)
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	ld hl, wBattleMonAttack
	cp EFFECT_BODY_PRESS
	jr nz, .not_bp_unboosted
	ld hl, wBattleMonDefense ; Body Press attacks with the user's DEFENSE
.not_bp_unboosted
	cp EFFECT_FOUL_PLAY
	jr nz, .not_fp_unboosted
	ld hl, wEnemyMonAttack ; Foul Play uses the target's ATTACK
.not_fp_unboosted
	call CheckDamageStatsCritical
	jp c, .thickclub

	; boosted stats. Sacred Sword ignores the target's DEFENSE stat
	; stages: keep the unmodified defense in bc, but use boosted attack.
	push bc
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	pop bc
	ld hl, wPlayerAttack
	cp EFFECT_SACRED_SWORD
	jr z, .thickclub

	cp EFFECT_BODY_PRESS
	jr nz, .not_bp_boosted
	ld hl, wEnemyDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wPlayerDefense
	jr .thickclub
.not_bp_boosted
	cp EFFECT_FOUL_PLAY
	jr nz, .not_fp_boosted
	ld hl, wEnemyDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemyAttack
	jr .thickclub
.not_fp_boosted
	ld hl, wEnemyDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wPlayerAttack
	jr .thickclub

.special
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_PSYSTRIKE
	jr z, .psystrike

	ld hl, wEnemyMonSpclDef
	ld a, [hli]
	ld b, a
	ld c, [hl]

	ld a, [wEnemyScreens]
	bit SCREENS_LIGHT_SCREEN, a
	jr z, .specialcrit
	sla c
	rl b

.specialcrit
	ld hl, wBattleMonSpclAtk
	call CheckDamageStatsCritical
	jr c, .lightball

	ld hl, wEnemySpDef
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wPlayerSpAtk
	jr .lightball

.psystrike
; Psystrike is special but hits the target's physical Defense.
	ld hl, wEnemyMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]

	ld a, [wEnemyScreens]
	bit SCREENS_REFLECT, a
	jr z, .psystrikecrit
	sla c
	rl b

.psystrikecrit
	ld hl, wBattleMonSpclAtk
	call CheckDamageStatsCritical
	jr c, .lightball

	ld hl, wEnemyDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wPlayerSpAtk

.lightball
; Note: Returns player special attack at hl in hl.
	call LightBallBoost
	jr .done

.thickclub
; Note: Returns player attack at hl in hl.
	call ThickClubBoost

.done
	; Raise defending stat by 50% in weather (WeatherDefenseBoost_Core is
	; in this same bank, but callfar keeps the register contract identical)
	push hl
	callfar WeatherDefenseBoost_Core
	pop hl
	push hl
	callfar HeldDefenseBoost_Core
	callfar DittoMetalPowder_Core
	pop hl
	call TruncateHLBC_Ovf

	ld a, [wBattleMonLevel]
	ld e, a

	ld a, 1
	and a
	ret

TruncateHLBC_Ovf:
.loop
; Truncate 16-bit values hl and bc to 8-bit values b and c respectively.
; b = hl, c = bc

	ld a, h
	or b
	jr z, .finish

	srl b
	rr c
	srl b
	rr c

	ld a, c
	or b
	jr nz, .done_bc
	inc c

.done_bc
	srl h
	rr l
	srl h
	rr l

	ld a, l
	or h
	jr nz, .finish
	inc l

.finish
; If we go back to the loop point,
; it's the same as doing this exact
; same check twice.
	ld a, h
	or b
	jr nz, .loop

	ld b, l
	ret

CheckDamageStatsCritical:
; Return carry if boosted stats should be used in damage calculations.
; Unboosted stats should be used if the attack is a critical hit,
;  and the stage of the opponent's defense is higher than the user's attack.

	ld a, [wCriticalHit]
	and a
	scf
	ret z

	push hl
	push bc
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld a, [wPlayerMoveStruct + MOVE_CATEGORY]
	cp CATEGORIZE_SPECIAL
; special
	ld a, [wPlayerSAtkLevel]
	ld b, a
	ld a, [wEnemySDefLevel]
	jr nc, .end
; physical
	ld a, [wPlayerAtkLevel]
	ld b, a
	ld a, [wEnemyDefLevel]
	jr .end

.enemy
	ld a, [wEnemyMoveStruct + MOVE_CATEGORY]
	cp CATEGORIZE_SPECIAL
; special
	ld a, [wEnemySAtkLevel]
	ld b, a
	ld a, [wPlayerSDefLevel]
	jr nc, .end
; physical
	ld a, [wEnemyAtkLevel]
	ld b, a
	ld a, [wPlayerDefLevel]
.end
	cp b
	pop bc
	pop hl
	ret

ThickClubBoost:
; Return in hl the stat value at hl.

; If the attacking monster is Cubone or Marowak and
; it's holding a Thick Club, double it.
	push bc
	push de
	ld bc, CUBONE
	ld d, THICK_CLUB
	call SpeciesItemBoost
	if MAROWAK == (CUBONE + 1)
		inc bc
	else
		ld bc, MAROWAK
	endc
	call DoubleStatIfSpeciesHoldingItem
	pop de
	pop bc
	ret

LightBallBoost:
; Return in hl the stat value at hl.

; If the attacking monster is Pikachu and it's
; holding a Light Ball, double it.
	push bc
	push de
	ld bc, PIKACHU
	ld d, LIGHT_BALL
	call SpeciesItemBoost
	pop de
	pop bc
	ret

SpeciesItemBoost:
; Return in hl the stat value at hl.

; If the attacking monster is species bc and
; it's holding item d, double it.

	ld a, [hli]
	ld l, [hl]
	ld h, a
	; fallthrough

DoubleStatIfSpeciesHoldingItem:
; If the attacking monster is species bc and
; it's holding item d, double the stat in hl.

	push hl
	ld a, MON_SPECIES
	call BattlePartyAttr

	ldh a, [hBattleTurn]
	and a
	ld a, [hl]
	jr z, .CompareSpecies
	ld a, [wTempEnemyMonSpecies]
.CompareSpecies:

	call GetPokemonIndexFromID
	ld a, h
	cp b
	ld a, l
	pop hl
	ret nz
	cp c
	ret nz

	push hl
	callfar GetUserItem
	ld a, [hl]
	pop hl
	cp d
	ret nz

; Double the stat
	sla l
	rl h
	ld a, HIGH(MAX_STAT_VALUE)
	cp h
	jr c, .cap_boost
	ret nz
	ld a, LOW(MAX_STAT_VALUE)
	cp l
	ret nc
.cap_boost
	ld hl, MAX_STAT_VALUE
	ret

EnemyAttackDamage_Core:
	call ResetDamage

; No damage dealt with 0 power.
	ld hl, wEnemyMoveStructPower
	ld a, [hli] ; hl = wEnemyMoveStructType
	ld d, a
	and a
	ret z

	inc hl ; Type -> Category
	ld a, [hl]
	cp CATEGORIZE_SPECIAL
	jr z, .Special

.physical
	ld hl, wBattleMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]

	ld a, [wPlayerScreens]
	bit SCREENS_REFLECT, a
	jr z, .physicalcrit
	sla c
	rl b

.physicalcrit
	; pick the unboosted attacking-stat source (used on crits)
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	ld hl, wEnemyMonAttack
	cp EFFECT_BODY_PRESS
	jr nz, .not_bp_unboosted
	ld hl, wEnemyMonDefense ; Body Press attacks with the user's DEFENSE
.not_bp_unboosted
	cp EFFECT_FOUL_PLAY
	jr nz, .not_fp_unboosted
	ld hl, wBattleMonAttack ; Foul Play uses the target's ATTACK
.not_fp_unboosted
	call CheckDamageStatsCritical
	jp c, .thickclub

	; boosted stats. Sacred Sword ignores the target's DEFENSE stat
	; stages: keep the unmodified defense in bc, but use boosted attack.
	push bc
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	pop bc
	ld hl, wEnemyAttack
	cp EFFECT_SACRED_SWORD
	jr z, .thickclub

	cp EFFECT_BODY_PRESS
	jr nz, .not_bp_boosted
	ld hl, wPlayerDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemyDefense
	jr .thickclub
.not_bp_boosted
	cp EFFECT_FOUL_PLAY
	jr nz, .not_fp_boosted
	ld hl, wPlayerDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wPlayerAttack
	jr .thickclub
.not_fp_boosted
	ld hl, wPlayerDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemyAttack
	jr .thickclub

.Special:
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_PSYSTRIKE
	jr z, .psystrike

	ld hl, wBattleMonSpclDef
	ld a, [hli]
	ld b, a
	ld c, [hl]

	ld a, [wPlayerScreens]
	bit SCREENS_LIGHT_SCREEN, a
	jr z, .specialcrit
	sla c
	rl b

.specialcrit
	ld hl, wEnemyMonSpclAtk
	call CheckDamageStatsCritical
	jr c, .lightball
	ld hl, wPlayerSpDef
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemySpAtk
	jr .lightball

.psystrike
; Psystrike is special but hits the target's physical Defense.
	ld hl, wBattleMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]

	ld a, [wPlayerScreens]
	bit SCREENS_REFLECT, a
	jr z, .psystrikecrit
	sla c
	rl b

.psystrikecrit
	ld hl, wEnemyMonSpclAtk
	call CheckDamageStatsCritical
	jr c, .lightball
	ld hl, wPlayerDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemySpAtk

.lightball
	call LightBallBoost
	jr .done

.thickclub
	call ThickClubBoost

.done
	; Raise defending stat by 50% in weather (WeatherDefenseBoost_Core is
	; in this same bank, but callfar keeps the register contract identical)
	push hl
	callfar WeatherDefenseBoost_Core
	pop hl
	push hl
	callfar HeldDefenseBoost_Core
	callfar DittoMetalPowder_Core
	pop hl
	call TruncateHLBC_Ovf

	ld a, [wEnemyMonLevel]
	ld e, a

	ld a, 1
	and a
	ret
