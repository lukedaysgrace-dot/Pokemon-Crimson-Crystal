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
