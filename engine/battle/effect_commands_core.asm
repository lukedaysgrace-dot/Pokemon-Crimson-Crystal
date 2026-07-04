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
	ret nz
	ld b, charge_command
	callfar SkipToBattleCommand
	ret

BattleMultiHitRoll_Core:
	push bc
	callfar GetUserItem
	ld a, b
	pop bc
	cp HELD_LOADED_DICE
	jr z, .loaded_dice
	call BattleRandom
	and $3
	cp 2
	ret c
	call BattleRandom
	and $3
	ret

.loaded_dice
	call BattleRandom
	and 1
	add 3
	scf
	ret

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

	; fallthrough

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

BattleStartHail_Core:
	ld a, [wBattleWeather]
	cp WEATHER_HAIL
	jr z, .failed

	ld a, WEATHER_HAIL
	ld [wBattleWeather], a
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

	ldh a, [hBattleTurn]
	and a
	jp nz, .enemy

	callfar CheckAnyOtherAlivePartyMons
	ret z

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
