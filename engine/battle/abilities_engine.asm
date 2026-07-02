; Ability battle engine.
; Port of Polished Crystal's engine/battle/abilities.asm, adapted to the
; vanilla-style Supreme Silver battle engine.
;
; Ported categories: entry abilities, status-heal abilities, status
; prevention, end-of-turn abilities, post-battle abilities.
; Not yet ported (see docs/ABILITY_PORT_STATUS.md): contact abilities,
; damage/stat modifiers, nullification/absorb abilities, faint abilities,
; Anticipation/Forewarn, Moody, Neutralizing Gas deactivation handling.

; ==== Turn and jumptable helpers =========================================

SwitchTurn::
; Preserves all registers.
	push af
	ldh a, [hBattleTurn]
	xor 1
	ldh [hBattleTurn], a
	pop af
	ret

StackCallOpponentTurn::
; Inserts SwitchTurn into the call stack so the following function pointer
; is "wrapped" by SwitchTurns. See Polished Crystal home/battle.asm.
	add sp, -2
	push de
	push hl
	ld hl, sp + 7
	ld d, [hl]
	ld [hl], HIGH(SwitchTurn)
	dec hl
	ld e, [hl]
	ld [hl], LOW(SwitchTurn)
	dec hl
	ld [hl], d
	dec hl
	ld [hl], e
	pop hl
	pop de
	jr SwitchTurn

BattleJumptable::
; hl = jumptable of dbw entries, a = target.
; Returns z if no jump was made, nz otherwise.
	push bc
	ld b, a
.loop
	ld a, [hli]
	cp -1
	jr z, .end
	cp b
	jr z, .got_target
	inc hl
	inc hl
	jr .loop
.got_target
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call _hl_
	or 1
.end
	pop bc
	ret

BattleRandomRange::
; in: a = n. out: a = 0 to n-1 (link-safe random).
	push bc
	ld c, a
	call BattleRandom
	call SimpleDivide
	pop bc
	ret

UserHasFainted::
	push hl
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonHP
.got_hp
	ld a, [hli]
	or [hl]
	pop hl
	ret

OppHasFainted::
	call StackCallOpponentTurn
	jp UserHasFainted

; ==== Ability getters =====================================================

GetTrueUserAbility::
GetUserAbility::
; Current effective ability of the user, after Neutralizing Gas.
	call StackCallOpponentTurn
GetOpponentAbility::
; Current effective ability of the opponent, after Neutralizing Gas.
	push hl
	ld a, BATTLE_VARS_ABILITY_OPP
	call GetBattleVar
	ld l, a
	; check for the user's Neutralizing Gas
	ld a, BATTLE_VARS_ABILITY
	call GetBattleVar
	cp NEUTRALIZING_GAS
	ld a, l
	pop hl
	ret nz
	; Neutralizing Gas suppresses unless the ability can't be suppressed
	push bc
	ld b, a
	call GetAbilityFlags
	and ABILFLAG_NO_SUPPRESS
	ld a, b
	pop bc
	ret nz
	xor a ; NO_ABILITY
	ret

GetTrueUserIgnorableAbility::
	call StackCallOpponentTurn
GetOpponentIgnorableAbility::
; Returns the opponent's ability, unless the user's Mold Breaker ignores it.
	call GetOpponentAbility
	push bc
	ld b, a
	ld a, BATTLE_VARS_ABILITY
	call GetBattleVar
	cp MOLD_BREAKER
	ld a, b
	jr nz, .done
	call GetAbilityFlags
	and ABILFLAG_IGNORABLE
	ld a, b
	jr z, .done
	xor a ; ignored
.done
	pop bc
	ret

GetAbilityFlags::
; return flags for ability in a. Preserves all but a.
	push hl
	push bc
	ld l, a
	ld h, 0
	ld bc, AbilityFlags
	add hl, bc
	ld a, [hl]
	pop bc
	pop hl
	ret

AbilityCanBeTraced::
; z if ability in a can be traced. Preserves a.
	push bc
	ld b, a
	call GetAbilityFlags
	and ABILFLAG_NO_TRACE
	ld a, b
	pop bc
	ret

; ==== Activation framework ================================================

BeginAbility::
	ld a, [wInAbility]
	and a
	ret nz
	push hl
	push de
	push bc
	call LoadTileMapToTempTileMap
	pop bc
	pop de
	pop hl
	ld a, 1
	ld [wInAbility], a
	ret

EndAbility::
	ld a, [wInAbility]
	and a
	ret z
	farcall DismissAbilityOverlays
	xor a
	ld [wInAbility], a
	ret

ShowEnemyAbilityActivation::
	call StackCallOpponentTurn
ShowAbilityActivation::
; Unconditionally does the banner slideout for the user's current ability.
	push hl
	push de
	push bc
	ld a, BATTLE_VARS_ABILITY
	call GetBattleVar
	ld b, a
	farcall PerformAbilityGFX
	pop bc
	pop de
	pop hl
	ret

ShowAbilityReplacement::
; Redraw the user's banner with ability a (for Trace).
	push hl
	push de
	push bc
	ld b, a
	farcall PerformAbilityReplacementGFX
	pop bc
	pop de
	pop hl
	ret

ShowPotentialAbilityActivation::
; Only shows the banner if we're within an ability execution (BeginAbility)
; and this side hasn't shown its banner yet. Avoids duplicate slideouts.
	ld a, [wInAbility]
	and a
	ret z
	push hl
	ld h, a
	ldh a, [hBattleTurn]
	inc a
	rrca
	rrca
	and h
	pop hl
	ret nz
	call ShowAbilityActivation
	ldh a, [hBattleTurn]
	inc a
	rrca
	rrca
	push hl
	ld h, a
	ld a, [wInAbility]
	or h
	ld [wInAbility], a
	pop hl
	ret

; ==== Entry abilities =====================================================

RunEntryAbilities::
; Runs the current turn holder's switch-in abilities.
	call EndAbility
	call UserHasFainted
	ret z
	call OppHasFainted
	ld hl, BattleEntryAbilities
	jr z, .got_table
	ld hl, BattleEntryAbilitiesNonfainted
.got_table
	call GetTrueUserAbility
	jp BattleJumptable

BattleEntryAbilitiesNonfainted:
	dbw TRACE, TraceAbility
	dbw IMPOSTER, ImposterAbility
	dbw INTIMIDATE, IntimidateAbility
	dbw DOWNLOAD, DownloadAbility
	dbw FRISK, FriskAbility
	dbw UNNERVE, UnnerveAbility
BattleEntryAbilities:
	dbw DRIZZLE, DrizzleAbility
	dbw DROUGHT, DroughtAbility
	dbw SAND_STREAM, SandStreamAbility
	dbw SNOW_WARNING, SnowWarningAbility
	dbw CLOUD_NINE, CloudNineAbility
	dbw PRESSURE, PressureAbility
	dbw MOLD_BREAKER, MoldBreakerAbility
	dbw NEUTRALIZING_GAS, NeutralizingGasAbility
	dbw SCREEN_CLEANER, ScreenCleanerAbility
	; fallthrough
StatusHealAbilities:
; Status immunity abilities that autoproc if the user has the status
	dbw LIMBER, LimberAbility
	dbw IMMUNITY, ImmunityAbility
	dbw PASTEL_VEIL, PastelVeilAbility
	dbw MAGMA_ARMOR, MagmaArmorAbility
	dbw WATER_VEIL, WaterVeilAbility
	dbw INSOMNIA, InsomniaAbility
	dbw VITAL_SPIRIT, VitalSpiritAbility
	dbw OWN_TEMPO, OwnTempoAbility
	dbw OBLIVIOUS, ObliviousAbility
	dbw -1, -1

CloudNineAbility:
	ld hl, NotifyCloudNineText
	jr NotificationAbilities
PressureAbility:
	ld hl, NotifyPressureText
	jr NotificationAbilities
MoldBreakerAbility:
	ld hl, NotifyMoldBreakerText
	jr NotificationAbilities
UnnerveAbility:
	ld hl, NotifyUnnerveText
	jr NotificationAbilities
NeutralizingGasAbility:
	ld hl, NotifyNeutralizingGasText
	; fallthrough
NotificationAbilities:
	push hl
	call BeginAbility
	call ShowAbilityActivation
	pop hl
	call StdBattleTextbox
	jp EndAbility

TraceAbility:
	call GetOpponentIgnorableAbility
	and a
	ret z
	call AbilityCanBeTraced
	ret nz
	push af
	; buffer the traced ability's name for the text
	ld b, a
	farcall GetAbilityName
	call BeginAbility
	call ShowAbilityActivation
	call ShowEnemyAbilityActivation
	pop af
	push af
	call ShowAbilityReplacement
	ld hl, TraceActivationText
	call StdBattleTextbox
	call EndAbility
	ld a, BATTLE_VARS_ABILITY
	call GetBattleVarAddr
	pop af
	ld [hl], a
	jp RunEntryAbilities

ImposterAbility:
	call BeginAbility
	call ShowPotentialAbilityActivation
	farcall BattleCommand_Transform
	jp EndAbility

; Lasts 5 turns, consistent with Generation VI.
DrizzleAbility:
	ld a, WEATHER_RAIN
	ld hl, DownpourText
	jr WeatherAbility
DroughtAbility:
	ld a, WEATHER_SUN
	ld hl, SunGotBrightText
	jr WeatherAbility
SandStreamAbility:
	ld a, WEATHER_SANDSTORM
	ld hl, SandstormBrewedText
	jr WeatherAbility
SnowWarningAbility:
	ld a, WEATHER_HAIL
	ld hl, ItStartedToHailText
	; fallthrough
WeatherAbility:
	ld b, a
	ld a, [wBattleWeather]
	cp b
	ret z ; don't re-activate it
	push hl
	push bc
	call BeginAbility
	call ShowAbilityActivation
	pop bc
	ld a, b
	ld [wBattleWeather], a
	ld a, 5
	ld [wWeatherCount], a
	pop hl
	call StdBattleTextbox
	jp EndAbility

IntimidateAbility:
	; does not work against Inner Focus, Own Tempo, Oblivious, Scrappy
	call GetOpponentIgnorableAbility
	ld b, a
	and a
	jr z, .intimidate_ok
	call GetAbilityFlags
	and ABILFLAG_NO_INTIMIDATE
	jr z, .intimidate_ok
	; blocked: show both abilities and print the resist text
	ld a, b
	push af
	farcall GetAbilityName
	call BeginAbility
	call ShowAbilityActivation
	call ShowEnemyAbilityActivation
	pop af
	ld hl, IntimidateResistedText
	call StdBattleTextbox
	jp EndAbility

.intimidate_ok
	call BeginAbility
	call ShowAbilityActivation
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld b, ATTACK
	call AbilityLowerOppStat
	; if the stat fell, proc the opponent's Rattled
	ld a, [wFailedMessage]
	and a
	jp nz, EndAbility
	call SwitchTurn
	call GetTrueUserIgnorableAbility
	cp RATTLED
	ld b, SPEED
	call z, StatUpAbility
	call SwitchTurn
	jp EndAbility

DownloadAbility:
; Raise Atk if the foe's Def is lower than its SpDef, otherwise SpAtk.
	call BeginAbility
	call ShowAbilityActivation
	ld hl, wEnemyMonDefense
	ld de, wEnemyMonSpclDef
	ldh a, [hBattleTurn]
	and a
	jr z, .got_stats
	ld hl, wBattleMonDefense
	ld de, wBattleMonSpclDef
.got_stats
	; compare 16-bit Def (hl) with SpDef (de)
	ld a, [de]
	ld b, a
	ld a, [hli]
	cp b
	jr c, .inc_atk
	jr nz, .inc_spatk
	inc de
	ld a, [de]
	ld b, a
	ld a, [hl]
	cp b
	jr c, .inc_atk
.inc_spatk
	ld b, SP_ATTACK
	jr .got_stat
.inc_atk
	ld b, ATTACK
.got_stat
	call StatUpAbility
	jp EndAbility

FriskAbility:
	ldh a, [hBattleTurn]
	and a
	ld a, [wEnemyMonItem]
	jr z, .got_item
	ld a, [wBattleMonItem]
.got_item
	and a
	ret z ; no item
	ld [wNamedObjectIndexBuffer], a
	call BeginAbility
	call ShowAbilityActivation
	call GetItemName
	ld hl, FriskedItemText
	call StdBattleTextbox
	jp EndAbility

ScreenCleanerAbility:
	ld a, [wPlayerScreens]
	and a
	jr nz, .screens_up
	ld a, [wEnemyScreens]
	and a
	ret z
.screens_up
	call BeginAbility
	call ShowAbilityActivation
	ldh a, [hBattleTurn]
	push af
	call .do_it
	call SwitchTurn
	call .do_it
	pop af
	ldh [hBattleTurn], a
	jp EndAbility

.do_it
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerScreens
	jr z, .got_screens
	ld hl, wEnemyScreens
.got_screens
	ld a, [hl]
	push af
	ld [hl], 0
	and 1 << SCREENS_REFLECT
	jr z, .no_reflect
	ld hl, BattleText_MonsReflectFaded
	call StdBattleTextbox
.no_reflect
	pop af
	and 1 << SCREENS_LIGHT_SCREEN
	ret z
	ld hl, BattleText_MonsLightScreenFell
	jp StdBattleTextbox

; ==== Stat change helpers =================================================

StatUpAbility::
; Force-raise stat b of the user, with the banner if within an ability.
	push bc
	call ShowPotentialAbilityActivation
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	pop bc
	; fallthrough
AbilityRaiseStat::
; b = stat. Prints the stat-up text on success.
	farcall RaiseStat
	ld a, [wFailedMessage]
	and a
	ret nz
	farcall BattleCommand_StatUpMessage
	ret

AbilityLowerOppStat::
; b = stat. Lowers the user's opponent's stat; respects Mist.
	farcall AbilityStatDown
	ld a, [wFailedMessage]
	and a
	ret nz
	farcall BattleCommand_StatDownMessage
	ret

; ==== Status heal / prevention ============================================

RunEnemyStatusHealAbilities::
	call StackCallOpponentTurn
RunStatusHealAbilities::
	ld hl, StatusHealAbilities
	call GetTrueUserAbility
	jp BattleJumptable

ImmunityAbility:
PastelVeilAbility:
	ld a, 1 << PSN
	jr HealStatusAbility
WaterVeilAbility:
	ld a, 1 << BRN
	jr HealStatusAbility
MagmaArmorAbility:
	ld a, 1 << FRZ
	jr HealStatusAbility
LimberAbility:
	ld a, 1 << PAR
	jr HealStatusAbility
InsomniaAbility:
VitalSpiritAbility:
	ld a, SLP
	; fallthrough
HealStatusAbility:
	ld b, a
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and b
	ret z ; not afflicted / wrong status
	call BeginAbility
	call ShowAbilityActivation
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	xor a
	ld [hl], a
	ld hl, BecameHealthyText
	call StdBattleTextbox
	call EndAbility
	ldh a, [hBattleTurn]
	and a
	jp z, UpdateBattleMonInParty
	jp UpdateEnemyMonInParty

OwnTempoAbility:
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_CONFUSED, a
	ret z ; not confused
	call BeginAbility
	call ShowAbilityActivation
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_CONFUSED, [hl]
	ld hl, ConfusedNoMoreText
	call StdBattleTextbox
	jp EndAbility

ObliviousAbility:
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVar
	bit SUBSTATUS_IN_LOVE, a
	ret z ; not infatuated
	call BeginAbility
	call ShowAbilityActivation
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, NoLongerInfatuatedText
	call StdBattleTextbox
	jp EndAbility

; Status prevention: called from effect commands with hBattleTurn = attacker.
; Each returns carry if the DEFENDER's ability prevents the status
; (and shows the ability banner).

AbilityPreventsSleep::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db INSOMNIA, VITAL_SPIRIT, -1

AbilityPreventsParalysis::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db LIMBER, -1

AbilityPreventsPoison::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db IMMUNITY, PASTEL_VEIL, -1

AbilityPreventsBurn::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db WATER_VEIL, -1

AbilityPreventsFreeze::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db MAGMA_ARMOR, -1

AbilityPreventsConfusion::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db OWN_TEMPO, -1

AbilityPreventsAttraction::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db OBLIVIOUS, -1

CheckStatusPrevention:
; hl = -1-terminated ability list. Carry if the defender's ability matches.
	call GetOpponentIgnorableAbility
	and a
	ret z ; nc
	ld b, a
.loop
	ld a, [hli]
	cp -1
	jr z, .no_match
	cp b
	jr nz, .loop
	; prevented: show the defender's banner
	call BeginAbility
	call ShowEnemyAbilityActivation
	call EndAbility
	scf
	ret
.no_match
	and a ; nc
	ret

; ==== End-of-turn abilities ==============================================

RunEndTurnAbilitiesBoth::
	call SetPlayerTurn
	call .run
	call SetEnemyTurn
.run
	call UserHasFainted
	ret z
	ld hl, EndTurnAbilities
	call GetTrueUserAbility
	jp BattleJumptable

EndTurnAbilities:
	dbw SPEED_BOOST, SpeedBoostAbility
	dbw SHED_SKIN, ShedSkinAbility
	dbw HYDRATION, HydrationAbility
	dbw RAIN_DISH, RainDishAbility
	dbw ICE_BODY, IceBodyAbility
	dbw DRY_SKIN, DrySkinAbility
	dbw SOLAR_POWER, SolarPowerAbility
	dbw BAD_DREAMS, BadDreamsAbility
	dbw -1, -1

SpeedBoostAbility:
	call BeginAbility
	ld b, SPEED
	call StatUpAbility
	jp EndAbility

ShedSkinAbility:
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and a
	ret z
	; 30% chance to proc
	ld a, 10
	call BattleRandomRange
	cp 3
	ret nc
	jr HealAllStatusAbility

HydrationAbility:
	ld a, [wBattleWeather]
	cp WEATHER_RAIN
	ret nz
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and a
	ret z
	; fallthrough
HealAllStatusAbility:
	ld a, ALL_STATUS
	jp HealStatusAbility

RainDishAbility:
	ld a, [wBattleWeather]
	cp WEATHER_RAIN
	ret nz
	jr Heal16thAbility

IceBodyAbility:
	ld a, [wBattleWeather]
	cp WEATHER_HAIL
	ret nz
	; fallthrough
Heal16thAbility:
; Heal 1/16 max HP, if not already at full HP.
	call CheckUserFullHP
	ret z
	call BeginAbility
	call ShowAbilityActivation
	farcall GetEighthMaxHP
	; halve for 1/16, minimum 1
	srl b
	rr c
	ld a, c
	or b
	jr nz, .got_amount
	inc c
.got_amount
	farcall RestoreHP
	ld hl, RegainedHealthText
	call StdBattleTextbox
	jp EndAbility

DrySkinAbility:
	ld a, [wBattleWeather]
	cp WEATHER_RAIN
	jr z, .heal
	cp WEATHER_SUN
	ret nz
	; hurt 1/8 in sun
	call BeginAbility
	call ShowAbilityActivation
	farcall GetEighthMaxHP
	farcall SubtractHPFromUser
	ld hl, IsHurtText
	call StdBattleTextbox
	jp EndAbility
.heal
	call CheckUserFullHP
	ret z
	call BeginAbility
	call ShowAbilityActivation
	farcall GetEighthMaxHP
	farcall RestoreHP
	ld hl, RegainedHealthText
	call StdBattleTextbox
	jp EndAbility

SolarPowerAbility:
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	ret nz
	call BeginAbility
	call ShowAbilityActivation
	farcall GetEighthMaxHP
	farcall SubtractHPFromUser
	ld hl, IsHurtText
	call StdBattleTextbox
	jp EndAbility

BadDreamsAbility:
	; only if the opponent is asleep
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and SLP
	ret z
	call OppHasFainted
	ret z
	call BeginAbility
	call ShowAbilityActivation
	call SwitchTurn
	farcall GetEighthMaxHP
	farcall SubtractHPFromUser
	ld hl, TormentedText
	call StdBattleTextbox
	call SwitchTurn
	jp EndAbility

; ==== Post-battle abilities ==============================================

RunPostBattleAbilities::
; Party-wide Pickup / Honey Gather / Natural Cure.
	ld a, [wPartyCount]
	and a
	ret z
	xor a
.loop
	push af
	ld [wCurPartyMon], a
	; get species; skip eggs
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	cp EGG
	jr z, .next
	ld c, a
	ld a, MON_PERSONALITY
	call GetPartyParamLocation
	ld b, [hl]
	call GetAbility
	ld a, b
	cp NATURAL_CURE
	jr z, .natural_cure
	cp PICKUP
	jr z, .pickup
	cp HONEY_GATHER
	jr z, .honey_gather
.next
	pop af
	inc a
	ld hl, wPartyCount
	cp [hl]
	jr c, .loop
	ret

.natural_cure
	ld a, MON_STATUS
	call GetPartyParamLocation
	xor a
	ld [hl], a
	jr .next

.pickup
	; 10% chance to pick up an item, if not holding one
	ld a, MON_ITEM
	call GetPartyParamLocation
	ld a, [hl]
	and a
	jr nz, .next
	ld a, 10
	call BattleRandomRange
	and a
	jr nz, .next
	push hl
	call GetRandomPickupItem
	pop hl
	ld [hl], a
	jr .next

.honey_gather
	; (level + 9) / 2 percent chance, floored to nearest 5%, to find honey
	ld a, MON_ITEM
	call GetPartyParamLocation
	ld a, [hl]
	and a
	jr nz, .next
	push hl
	ld a, 20
	call BattleRandomRange
	inc a
	ld c, a
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	add 9
	call SimpleDivide
	pop hl
	ld a, b
	cp 11
	jr c, .next
	ld a, GOLD_BERRY ; no honey item; closest sweet treat
	ld [hl], a
	jr .next

GetRandomPickupItem:
; out: a = item
	ld a, 10
	call BattleRandomRange
	push hl
	ld hl, .items
	push bc
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	ld a, [hl]
	pop hl
	ret

.items
	db BERRY
	db GOLD_BERRY
	db SUPER_POTION
	db FULL_HEAL
	db ETHER
	db REVIVE
	db RARE_CANDY
	db NUGGET
	db MAX_POTION
	db ELIXER

RunNullificationAbilities::
; Called at the end of BattleCommand_Stab, on the attacker's turn.
; If the defender's ability nullifies this move's type, zero wTypeModifier
; (the regular battle flow then treats the move as ineffective), show the
; defender's ability banner and apply the absorb effect.
	ld a, [wTypeModifier]
	and $7f
	ret z ; already immune
	call GetOpponentIgnorableAbility
	and a
	ret z
	ld b, a
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	ld c, a
	ld hl, NullificationAbilities
.loop
	ld a, [hli]
	cp -1
	ret z
	cp b
	jr nz, .next
	ld a, [hli]
	cp c
	jr z, .found
	inc hl
	inc hl
	jr .loop
.next
	inc hl
	inc hl
	inc hl
	jr .loop
.found
	; nullified: make the move ineffective
	xor a
	ld [wTypeModifier], a
	; run the absorb effect on the defender's side
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call SwitchTurn
	call BeginAbility
	call ShowAbilityActivation
	call _hl_
	call EndAbility
	jp SwitchTurn

NullificationAbilities:
; ability, move type, handler
	db VOLT_ABSORB, ELECTRIC
	dw AbsorbHealQuarter
	db LIGHTNING_ROD, ELECTRIC
	dw AbsorbRaiseSpAtk
	db MOTOR_DRIVE, ELECTRIC
	dw AbsorbRaiseSpeed
	db WATER_ABSORB, WATER
	dw AbsorbHealQuarter
	db DRY_SKIN, WATER
	dw AbsorbHealQuarter
	db FLASH_FIRE, FIRE
	dw AbsorbNothing
	db SAP_SIPPER, GRASS
	dw AbsorbRaiseAttack
	db LEVITATE, GROUND
	dw AbsorbNothing
	db -1

AbsorbHealQuarter:
	call CheckUserFullHP
	ret z ; immune, but nothing to heal
	farcall GetQuarterMaxHP
	farcall RestoreHP
	ld hl, RegainedHealthText
	jp StdBattleTextbox

AbsorbRaiseSpAtk:
	ld b, SP_ATTACK
	jr AbsorbRaiseStat
AbsorbRaiseSpeed:
	ld b, SPEED
	jr AbsorbRaiseStat
AbsorbRaiseAttack:
	ld b, ATTACK
AbsorbRaiseStat:
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	jp AbilityRaiseStat

AbsorbNothing:
	ret

RunFaintAbilities::
; Called when a battler faints. If the current turn holder is still alive
; and its opponent just fainted, run its on-KO abilities (Moxie).
	call UserHasFainted
	ret z
	call OppHasFainted
	ret nz ; opponent alive; the fainter was the user's side
	call GetTrueUserAbility
	cp MOXIE
	ret nz
	call BeginAbility
	ld b, ATTACK
	call StatUpAbility
	jp EndAbility

CheckUserFullHP:
; z if the user is at full HP
	push hl
	push de
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonHP
.got_hp
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	cp d
	jr nz, .done
	ld a, [hl]
	cp e
.done
	pop de
	pop hl
	ret

INCLUDE "data/abilities/flags.asm"
