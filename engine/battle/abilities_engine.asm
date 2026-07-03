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

ShowAbilityBannerBrief::
; Full banner presentation, held briefly, then dismissed. Use this before
; effects that redraw the HUD or play animations (they corrupt a live
; banner on the player's side).
	call BeginAbility
	call ShowAbilityActivation
BannerHoldAndDismiss::
	ld c, 24
	call DelayFrames
	jp EndAbility

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

AbilityRestoreUserHP::
; bc = amount. The battle core's RestoreHP heals the side OPPOSITE to
; hBattleTurn (see its use by Leech Seed and Leftovers), so wrap it in
; SwitchTurns to heal the turn holder (the ability's owner).
	call SwitchTurn
	farcall RestoreHP
	jp SwitchTurn

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
; banner briefly, then transform (Transform redraws the scene and would
; corrupt a live player-side banner)
	call ShowAbilityBannerBrief
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
	call ShowAbilityBannerBrief
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
; (StatUpAbility presents the banner itself - no separate slideout here,
; or the banner would play twice.)
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
; Force-raise stat b of the user. Shows the banner briefly, dismisses it,
; then applies the stat change (anims corrupt a live player-side banner).
	push bc
	call BeginAbility
	call ShowPotentialAbilityActivation
	ld c, 24
	call DelayFrames
	call EndAbility
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	pop bc
	; fallthrough
AbilityRaiseStat::
; b = stat. Plays the stat-up animation and prints the text on success.
	farcall RaiseStat
	ld a, [wFailedMessage]
	and a
	ret nz
	farcall BattleCommand_StatUpAnim
	farcall BattleCommand_StatUpMessage
	ret

AbilityLowerOppStat::
; b = stat. Lowers the user's opponent's stat; respects Mist.
; Plays the stat-down animation and prints the text on success.
	farcall AbilityStatDown
	ld a, [wFailedMessage]
	and a
	ret nz
	farcall BattleCommand_StatDownAnim
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
	call ShowAbilityBannerBrief
	farcall GetEighthMaxHP
	; halve for 1/16, minimum 1
	srl b
	rr c
	ld a, c
	or b
	jr nz, .got_amount
	inc c
.got_amount
	call AbilityRestoreUserHP
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
	call ShowAbilityBannerBrief
	farcall GetEighthMaxHP
	farcall SubtractHPFromUser
	ld hl, IsHurtText
	call StdBattleTextbox
	jp EndAbility
.heal
	call CheckUserFullHP
	ret z
	call ShowAbilityBannerBrief
	farcall GetEighthMaxHP
	call AbilityRestoreUserHP
	ld hl, RegainedHealthText
	call StdBattleTextbox
	jp EndAbility

SolarPowerAbility:
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	ret nz
	call ShowAbilityBannerBrief
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
	call ShowAbilityBannerBrief
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
; Called at the end of BattleCommand_Stab, on the attacker's turn, after
; wCurDamage and wTypeModifier are final. First checks type nullification;
; if the move goes through, applies ability damage modifiers to wCurDamage.
	call .CheckNullification
	ret c ; nullified
	jp RunDamageModifiers

.CheckNullification:
	ld a, [wTypeModifier]
	and $7f
	jr nz, .not_immune
	and a ; clear carry
	ret
.not_immune
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
	jr nz, .check
	and a ; no match: clear carry
	ret
.check
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
	; nullified: cancel the hit outright, like a natural immunity
	; (wTypeModifier alone does not stop applydamage - wCurDamage has
	; already been through the type-chart multiplication by now)
	xor a
	ld [wTypeModifier], a
	ld [wCurDamage], a
	ld [wCurDamage + 1], a
	; run the absorb effect on the defender's side
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call SwitchTurn
	push hl
	call ShowAbilityBannerBrief
	pop hl
	call _hl_
	call SwitchTurn
	; flag the miss AFTER the effect (the stat-up helpers clear it)
	ld a, 1
	ld [wAttackMissed], a
	scf ; nullified
	ret

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
	call AbilityRestoreUserHP
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

RunDamageModifiers:
; Apply ability-based damage modifiers to wCurDamage.
; Attacker = current turn holder. Physical/special moves only.
	call GetMoveCategory
	cp CATEGORIZE_STATUS
	ret z
	ld e, a ; e = category

	; ---- attacker's ability ----
	call GetTrueUserAbility
	ld d, a
	cp HUGE_POWER
	jr z, .huge_power
	cp GUTS
	jr z, .guts
	cp HUSTLE
	jr z, .hustle
	cp TECHNICIAN
	jr z, .technician
	cp TINTED_LENS
	jr z, .tinted_lens
	cp SOLAR_POWER
	jr z, .solar_power
	cp OVERGROW
	ld b, GRASS
	jr z, .pinch_boost
	cp BLAZE
	ld b, FIRE
	jr z, .pinch_boost
	cp TORRENT
	ld b, WATER
	jr z, .pinch_boost
	cp SWARM
	ld b, BUG
	jr z, .pinch_boost
	call CheckAteAbilityBoost
	jr nc, .defender
	call DamageX1_2
	jr .defender

.huge_power
	ld a, e
	and a ; CATEGORIZE_PHYSICAL == 0
	jr nz, .defender
	call DoubleDamage
	jr .defender

.guts
	ld a, e
	and a
	jr nz, .defender
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and a
	jr z, .defender
	; Guts ignores the burn attack cut: an extra x2 when burned makes
	; the net effect x1.5 of unburned damage
	bit BRN, a
	jr z, .guts_boost
	call DoubleDamage
.guts_boost
	call DamageX1_5
	jr .defender

.hustle
	ld a, e
	and a ; physical?
	jr nz, .defender
	call DamageX1_5
	jr .defender

.technician
	ld a, BATTLE_VARS_MOVE_POWER
	call GetBattleVar
	cp 60 + 1
	jr nc, .defender
	call DamageX1_5
	jr .defender

.tinted_lens
	ld a, [wTypeModifier]
	and $7f
	cp EFFECTIVE
	jr nc, .defender
	call DoubleDamage
	jr .defender

.solar_power
	ld a, e
	cp CATEGORIZE_SPECIAL
	jr nz, .defender
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	jr nz, .defender
	call DamageX1_5
	jr .defender

.pinch_boost
	; 1.5x for the matching type when at 1/3 max HP or less
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp b
	jr nz, .defender
	call CheckUserThirdHP
	jr nc, .defender
	call DamageX1_5
	; fallthrough

.defender
	; ---- defender's ability ----
	call GetOpponentIgnorableAbility
	ld d, a
	cp THICK_FAT
	jr z, .thick_fat
	cp MULTISCALE
	jr z, .multiscale
	cp FUR_COAT
	jr z, .fur_coat
	cp MARVEL_SCALE
	jr z, .marvel_scale
	cp FILTER
	jr z, .filter
	cp SOLID_ROCK
	jr z, .filter
	cp DRY_SKIN
	jr z, .dry_skin
	ret

.thick_fat
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp FIRE
	jp z, HalveDamage
	cp ICE
	jp z, HalveDamage
	ret

.multiscale
	call SwitchTurn
	call CheckUserFullHP
	call SwitchTurn
	ret nz
	jp HalveDamage

.fur_coat
	ld a, e
	and a ; physical?
	ret nz
	jp HalveDamage

.marvel_scale
	; approximates the 1.5x Defense boost (x2/3 damage) as x0.6875
	ld a, e
	and a
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	ret z
	jp DamageX0_69

.filter
	ld a, [wTypeModifier]
	and $7f
	cp EFFECTIVE + 1
	ret c ; not super effective
	jp DamageX0_75

.dry_skin
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp FIRE
	ret nz
	jp DamageX1_25

GetMoveCategory::
; a = current move's damage category
	push hl
	ld hl, wPlayerMoveStructCategory
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyMoveStructCategory
.got
	ld a, [hl]
	pop hl
	ret

CheckUserThirdHP:
; carry if the user's HP is at 1/3 max or below
	push hl
	push de
	push bc
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonHP
.got_hp
	; bc = HP * 3 (with overflow guard in a)
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	ld h, b
	ld l, c
	add hl, bc
	jr c, .no ; HP*2 overflowed; certainly above 1/3
	add hl, bc
	jr c, .no
	ld b, h
	ld c, l
	pop hl
	; compare with max HP: carry if HP*3 <= MaxHP i.e. MaxHP >= HP*3
	ld a, [hli]
	cp b
	jr c, .no_pop
	jr nz, .yes
	ld a, [hl]
	cp c
	jr c, .no_pop
.yes
	scf
	jr .done
.no
	pop hl
.no_pop
	and a
.done
	pop bc
	pop de
	pop hl
	ret

; ---- wCurDamage fraction helpers ----
DoubleDamage:
	push hl
	ld hl, wCurDamage
	ld a, [hli]
	ld l, [hl]
	ld h, a
	add hl, hl
	jr nc, .store
	ld hl, $ffff
.store
	ld a, h
	ld [wCurDamage], a
	ld a, l
	ld [wCurDamage + 1], a
	pop hl
	ret

DamageX1_5:
	push hl
	push de
	ld hl, wCurDamage
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld d, h
	ld e, l
	srl d
	rr e
	add hl, de
	jr nc, .store
	ld hl, $ffff
.store
	ld a, h
	ld [wCurDamage], a
	ld a, l
	ld [wCurDamage + 1], a
	pop de
	pop hl
	ret

DamageX1_2:
; approximates x1.2 as +1/8 +1/16 (x1.1875)
	push hl
	push de
	ld hl, wCurDamage
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld d, h
	ld e, l
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e ; 1/8
	add hl, de
	jr c, .cap
	srl d
	rr e ; 1/16
	add hl, de
	jr nc, .store
.cap
	ld hl, $ffff
.store
	ld a, h
	ld [wCurDamage], a
	ld a, l
	ld [wCurDamage + 1], a
	pop de
	pop hl
	ret

DamageX1_25:
	push hl
	push de
	ld hl, wCurDamage
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld d, h
	ld e, l
	srl d
	rr e
	srl d
	rr e
	add hl, de
	jr nc, .store
	ld hl, $ffff
.store
	ld a, h
	ld [wCurDamage], a
	ld a, l
	ld [wCurDamage + 1], a
	pop de
	pop hl
	ret

DamageX0_75:
	push hl
	push de
	ld hl, wCurDamage
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld d, h
	ld e, l
	srl d
	rr e
	srl d
	rr e
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	jr HalveDamage.store_min1

DamageX0_69:
; x11/16: half + eighth + sixteenth
	push hl
	push de
	ld hl, wCurDamage
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld d, h
	ld e, l
	srl d
	rr e ; 1/2
	push de
	srl d
	rr e
	srl d
	rr e ; 1/8
	ld h, d
	ld l, e
	srl d
	rr e ; 1/16
	add hl, de
	pop de
	add hl, de
	jr HalveDamage.store_min1

HalveDamage:
	push hl
	push de
	ld hl, wCurDamage
	ld a, [hli]
	ld l, [hl]
	ld h, a
	srl h
	rr l
.store_min1
	ld a, h
	or l
	jr nz, .store
	ld l, 1
.store
	ld a, h
	ld [wCurDamage], a
	ld a, l
	ld [wCurDamage + 1], a
	pop de
	pop hl
	ret

AbilityProtectsStatDrop::
; Carry if the opponent's (stat-drop target's) ability protects the stat
; in wLoweredStat. Shows the ability banner when it does.
	call GetOpponentIgnorableAbility
	and a
	ret z ; nc
	ld b, a
	cp CLEAR_BODY
	jr z, .protected
	cp WHITE_SMOKE
	jr z, .protected
	ld a, [wLoweredStat]
	and $f
	ld c, a
	ld a, b
	cp HYPER_CUTTER
	jr nz, .not_atk
	ld a, c
	cp ATTACK
	jr z, .protected
	jr .no
.not_atk
	cp KEEN_EYE
	jr nz, .not_acc
	ld a, c
	cp ACCURACY
	jr z, .protected
	jr .no
.not_acc
	cp BIG_PECKS
	jr nz, .no
	ld a, c
	cp DEFENSE
	jr z, .protected
.no
	and a ; nc
	ret
.protected
	call BeginAbility
	call ShowEnemyAbilityActivation
	call EndAbility
	scf
	ret

AbilityImmuneToSandstorm::
; Carry if the current turn holder's ability grants sandstorm immunity.
	call GetTrueUserAbility
	cp SAND_VEIL
	jr z, WeatherImmune
	cp SAND_RUSH
	jr z, WeatherImmune
	cp SAND_FORCE
	jr z, WeatherImmune
	jr WeatherImmuneCommon

AbilityImmuneToHail::
; Carry if the current turn holder's ability grants hail immunity.
	call GetTrueUserAbility
	cp ICE_BODY
	jr z, WeatherImmune
	cp SNOW_CLOAK
	jr z, WeatherImmune
	cp SLUSH_RUSH
	jr z, WeatherImmune
	; fallthrough
WeatherImmuneCommon:
	cp OVERCOAT
	jr z, WeatherImmune
	cp MAGIC_GUARD
	jr z, WeatherImmune
	and a ; nc
	ret
WeatherImmune:
	scf
	ret

AbilityAccuracyMods::
; b = hit chance (0-255, -1 = never miss). Modify per abilities.
	ld a, b
	cp -1
	ret z
	; No Guard on either side: always hits
	call GetTrueUserAbility
	cp NO_GUARD
	jr z, .always_hit
	call GetOpponentAbility
	cp NO_GUARD
	jr z, .always_hit
	; attacker mods
	call GetTrueUserAbility
	cp COMPOUND_EYES
	jr z, .compound_eyes
	cp HUSTLE
	jr z, .hustle
.defender
	call GetOpponentIgnorableAbility
	cp SAND_VEIL
	jr z, .sand_veil
	cp SNOW_CLOAK
	jr z, .snow_cloak
	cp TANGLED_FEET
	jr z, .tangled_feet
	cp WONDER_SKIN
	jr z, .wonder_skin
	ret

.always_hit
	ld b, -1
	ret

.compound_eyes
	; ~x1.3 (implemented as +25%)
	ld a, b
	srl a
	srl a
	add b
	jr nc, .ce_ok
	ld a, $fe ; cap below the never-miss value
.ce_ok
	ld b, a
	jr .defender

.hustle
	; physical moves only: ~x0.8 (implemented as -25%)
	call GetMoveCategory
	and a ; CATEGORIZE_PHYSICAL
	jr nz, .defender
	jr ReduceAccuracyQuarter_Defender

.sand_veil
	ld a, [wBattleWeather]
	cp WEATHER_SANDSTORM
	ret nz
	jr ReduceAccuracyQuarter
.snow_cloak
	ld a, [wBattleWeather]
	cp WEATHER_HAIL
	ret nz
	jr ReduceAccuracyQuarter

.tangled_feet
	; only while the defender is confused
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_CONFUSED, a
	ret z
	srl b
	ret

.wonder_skin
	; status moves get 50% accuracy at most
	call GetMoveCategory
	cp CATEGORIZE_STATUS
	ret nz
	ld a, b
	cp 50 percent + 1
	ret c
	ld b, 50 percent + 1
	ret

ReduceAccuracyQuarter_Defender:
	call ReduceAccuracyQuarter
	jr AbilityAccuracyMods.defender
ReduceAccuracyQuarter:
; approximates x0.8: b = b - b/8 - b/16 (= x0.8125)
	ld a, b
	srl a
	srl a
	srl a
	ld c, a ; b/8
	srl a   ; b/16
	add c
	ld c, a
	ld a, b
	sub c
	ld b, a
	ret

CompareSpeedsWithAbilities::
; Compare ability-adjusted speeds. Returns like CompareBytes on
; (player speed, enemy speed): z = tie, carry = enemy is faster.
	push hl
	push de
	push bc
	; player effective speed -> hl
	ld a, [wPlayerAbility]
	ld c, a
	ld a, [wBattleMonStatus]
	ld b, a
	ld hl, wBattleMonSpeed
	call .GetEffectiveSpeed
	push hl
	; enemy effective speed -> hl
	ld a, [wEnemyAbility]
	ld c, a
	ld a, [wEnemyMonStatus]
	ld b, a
	ld hl, wEnemyMonSpeed
	call .GetEffectiveSpeed
	ld d, h
	ld e, l
	pop hl
	; compare hl (player) vs de (enemy)
	ld a, h
	cp d
	jr nz, .done
	ld a, l
	cp e
.done
	pop bc
	pop de
	pop hl
	ret

.GetEffectiveSpeed:
; hl = speed stat ptr, c = ability, b = status. Returns speed in hl.
	ld a, [hli]
	ld d, a
	ld e, [hl]
	; hl := de
	ld h, d
	ld l, e
	ld a, c
	cp QUICK_FEET
	jr z, .quick_feet
	ld d, WEATHER_RAIN
	cp SWIFT_SWIM
	jr z, .weather_double
	ld d, WEATHER_SUN
	cp CHLOROPHYLL
	jr z, .weather_double
	ld d, WEATHER_SANDSTORM
	cp SAND_RUSH
	jr z, .weather_double
	ld d, WEATHER_HAIL
	cp SLUSH_RUSH
	ret nz
	; fallthrough
.weather_double
	ld a, [wBattleWeather]
	cp d
	ret nz
	add hl, hl
	ret nc
	ld hl, $ffff
	ret

.quick_feet
	; x1.5 while statused
	ld a, b
	and a
	ret z
	ld d, h
	ld e, l
	srl d
	rr e
	add hl, de
	ret nc
	ld hl, $ffff
	ret

RunContactAbilitiesHook::
; Runs after damage is applied. Turn = attacker.
	ld a, [wAttackMissed]
	and a
	ret nz
	ld a, [wTypeModifier]
	and $7f
	ret z
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	or b
	ret z
	; no procs through a Substitute
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret nz
	call CheckContactMove
	ret nc
	; nothing procs if the defender already fainted
	call OppHasFainted
	ret z
	; attacker on-contact abilities
	call GetTrueUserAbility
	cp POISON_TOUCH
	call z, PoisonTouchAbility
	; defender on-contact abilities (perspective switches to the defender)
	call StackCallOpponentTurn
_RunDefenderContactAbilities:
	call UserHasFainted
	ret z
	call GetTrueUserAbility
	ld hl, TargetContactAbilities
	jp BattleJumptable

TargetContactAbilities:
	dbw STATIC, StaticAbility
	dbw FLAME_BODY, FlameBodyAbility
	dbw POISON_POINT, PoisonPointAbility
	dbw EFFECT_SPORE, EffectSporeAbility
	dbw TANGLING_HAIR, TanglingHairAbility
	dbw -1, -1

CheckContactMove::
; carry if the current move makes contact
	push hl
	push de
	push bc
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	and a
	jr z, .no ; no move (e.g. confusion self-hit)
	call GetMoveIndexFromID
	; bit l&7 of ContactMoves[index >> 3]
	ld a, l
	and %111
	ld c, a
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	ld de, ContactMoves
	add hl, de
	ld b, [hl]
	inc c
.shift
	srl b
	dec c
	jr nz, .shift
	; bit now in carry
	jr c, .yes
.no
	and a
.yes
	pop bc
	pop de
	pop hl
	ret

PoisonTouchAbility:
; attacker ability: 30% to poison the defender
	ld a, 10
	call BattleRandomRange
	cp 3
	ret nc
	jp TryPoisonOpponentContact

StaticAbility:
	call ContactChance
	ret nc
.spore_paralyze
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	ret nz
	call AbilityPreventsParalysis
	ret c
	call ShowAbilityBannerBrief
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PAR, [hl]
	call UpdateOpponentInParty
	ld hl, ApplyPrzEffectOnSpeed
	call CallBattleCore
	call UpdateBattleHuds
	farcall PrintParalyze
	jp EndAbility

FlameBodyAbility:
	call ContactChance
	ret nc
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	ret nz
	call AbilityPreventsBurn
	ret c
	call ShowAbilityBannerBrief
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set BRN, [hl]
	call UpdateOpponentInParty
	ld hl, ApplyBrnEffectOnAttack
	call CallBattleCore
	call UpdateBattleHuds
	ld hl, WasBurnedText
	call StdBattleTextbox
	jp EndAbility

PoisonPointAbility:
	call ContactChance
	ret nc
TryPoisonOpponentContact:
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	ret nz
	call OpponentIsPoisonImmuneType
	ret z
	call AbilityPreventsPoison
	ret c
	call ShowAbilityBannerBrief
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PSN, [hl]
	call UpdateOpponentInParty
	call UpdateBattleHuds
	ld hl, WasPoisonedText
	call StdBattleTextbox
	jp EndAbility

EffectSporeAbility:
	call ContactChance
	ret nc
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	ret nz
	; 1/3 each: poison, paralysis, sleep
	ld a, 3
	call BattleRandomRange
	and a
	jp z, TryPoisonOpponentContact
	dec a
	jp z, StaticAbility.spore_paralyze
	; sleep
	call AbilityPreventsSleep
	ret c
	call ShowAbilityBannerBrief
	call BattleRandom
	and %11
	inc a
	ld b, a
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	ld [hl], b
	call UpdateOpponentInParty
	call UpdateBattleHuds
	ld hl, FellAsleepText
	call StdBattleTextbox
	jp EndAbility

TanglingHairAbility:
	call ShowAbilityBannerBrief
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld b, SPEED
	call AbilityLowerOppStat
	jp EndAbility

ContactChance:
; carry 30% of the time
	ld a, 10
	call BattleRandomRange
	cp 3
	ret

OpponentIsPoisonImmuneType:
; z if the opponent is Poison- or Steel-type
	push hl
	ld hl, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld hl, wBattleMonType1
.got_types
	ld a, [hli]
	cp POISON
	jr z, .immune
	cp STEEL
	jr z, .immune
	ld a, [hl]
	cp POISON
	jr z, .immune
	cp STEEL
.immune
	pop hl
	ret

INCLUDE "data/moves/contact_moves.asm"

AbilityConvertMoveType::
; "-ate" abilities: the user's Normal-type damaging moves become their
; element (Galvanize/Pixilate/Refrigerate/Aerilate). Runs right after the
; move struct is loaded for this use. Struggle is exempt.
	call GetTrueUserAbility
	and a
	ret z
	ld b, a
	call GetMoveCategory
	cp CATEGORIZE_STATUS
	ret z
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp NORMAL
	ret nz
	ld a, b
	ld c, ELECTRIC
	cp GALVANIZE
	jr z, .convert
	ld c, FAIRY
	cp PIXILATE
	jr z, .convert
	ld c, ICE
	cp REFRIGERATE
	jr z, .convert
	ld c, FLYING
	cp AERILATE
	ret nz
.convert
	; not Struggle
	push hl
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	call GetMoveIndexFromID
	ld a, h
	cp HIGH(STRUGGLE)
	jr nz, .not_struggle
	ld a, l
	cp LOW(STRUGGLE)
	jr z, .abort
.not_struggle
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	ld [hl], c
.abort
	pop hl
	ret

CheckAteAbilityBoost:
; carry if the attacker has an "-ate" ability and this move was converted
; (its original type in the move data is Normal)
	call GetTrueUserAbility
	cp GALVANIZE
	jr z, .check_original
	cp PIXILATE
	jr z, .check_original
	cp REFRIGERATE
	jr z, .check_original
	cp AERILATE
	jr z, .check_original
	and a ; nc
	ret
.check_original
	push hl
	push de
	push bc
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	call GetMoveIndexFromID
	dec hl
	push hl
	add hl, hl
	add hl, hl
	add hl, hl
	pop de
	add hl, de ; index * 9 (MOVE_LENGTH)
	ld de, Moves + MOVE_TYPE
	add hl, de
	ld a, BANK(Moves)
	call GetFarByte
	cp NORMAL
	pop bc
	pop de
	pop hl
	scf
	ret z
	and a ; nc
	ret

AbilityCapCore::
; ABILITY CAP key item: cycle the chosen mon's ability through its
; available slots (1 -> 2 -> hidden -> 1), skipping empty ones.
	ld b, PARTYMENUACTION_HEALING_ITEM
	callfar UseItem_SelectMon
	ret c ; cancelled
	; no eggs
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	cp EGG
	jr z, .no_effect
	ld [wCurSpecies], a
	push af
	call GetBaseData
	pop af
	ld c, a ; c = species id
	; current slot
	ld a, MON_PERSONALITY
	call GetPartyParamLocation
	ld a, [hl]
	and ABILITY_MASK
	ld d, a
	; availability
	ld a, [wBaseAbility2]
	and a
	ld e, 0
	jr z, .no_second
	set 1, e
.no_second
	ld a, [wBaseHiddenAbility]
	and a
	jr z, .no_hidden
	set 2, e
.no_hidden
	ld a, e
	and a
	jr z, .no_effect ; only one ability exists
	; cycle d to the next available slot
	ld a, d
	cp ABILITY_1
	jr z, .from_one
	cp ABILITY_2
	jr z, .from_two
	; from hidden (or unset): go to slot 1
	ld d, ABILITY_1
	jr .apply
.from_one
	bit 1, e
	ld d, ABILITY_2
	jr nz, .apply
	ld d, HIDDEN_ABILITY
	jr .apply
.from_two
	bit 2, e
	ld d, HIDDEN_ABILITY
	jr nz, .apply
	ld d, ABILITY_1
.apply
	ld a, [hl]
	and ~ABILITY_MASK & $ff
	or d
	ld [hl], a
	; announce the new ability
	ld b, a
	call GetAbility
	farcall GetAbilityName
	push de
	ld de, SFX_FULL_HEAL
	call PlaySFX
	call WaitSFX
	pop de
	ld hl, .BecameText
	jp PrintText

.no_effect
	ld hl, .NoEffectText
	jp PrintText

.BecameText:
	text "Its ability is"
	line "now @"
	text_ram wStringBuffer1
	text "!"
	prompt

.NoEffectText:
	text "It won't have"
	line "any effect."
	prompt
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
