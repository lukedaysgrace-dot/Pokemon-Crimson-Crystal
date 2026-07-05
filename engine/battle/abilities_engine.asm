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

ShowEnemyAbilityBannerBrief::
; Like ShowAbilityBannerBrief, but presents the opponent's (defender's)
; banner. Held briefly, then dismissed before any text/effect runs.
	call BeginAbility
	call ShowEnemyAbilityActivation
	jr BannerHoldAndDismiss

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
	; a busted Mimikyu keeps its broken sprite when it re-enters
	call ReapplyBrokenDisguise
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
	dbw THERMAL_EXCHANGE, WaterVeilAbility
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
	call ShowAbilityBannerBrief
	pop hl
	jp StdBattleTextbox

TraceAbility:
	call GetOpponentIgnorableAbility
	and a
	ret z
	call AbilityCanBeTraced
	ret nz
	push af
	call BeginAbility
	call ShowAbilityActivation
	call ShowEnemyAbilityActivation
	pop af
	push af
	call ShowAbilityReplacement
	call BannerHoldAndDismiss
	; buffer the traced ability's name AFTER the banners - the banner
	; GFX clobbers wStringBuffer1
	pop af
	push af
	ld b, a
	farcall GetAbilityName
	ld hl, TraceActivationText
	call StdBattleTextbox
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
	call ShowAbilityBannerBrief
	pop bc
	ld a, b
	ld [wBattleWeather], a
	ld a, 5
	ld [wWeatherCount], a
	pop hl
	call StdBattleTextbox
	; show the weather itself, right after the "it started" text
	ld a, [wBattleWeather]
	ld b, a
	; fallthrough

PlayWeatherAbilityAnim:
; b = WEATHER_*. Play that weather's full-screen effect animation once.
	ld a, b
	cp WEATHER_RAIN
	ld de, RAIN_DANCE
	jr z, PlayWeatherAnimDE
	cp WEATHER_SUN
	ld de, SUNNY_DAY
	jr z, PlayWeatherAnimDE
	cp WEATHER_SANDSTORM
	ld de, ANIM_IN_SANDSTORM
	jr z, PlayWeatherAnimDE
	ld de, ANIM_IN_HAIL ; WEATHER_HAIL
	; fallthrough

PlayWeatherAnimDE:
; de = animation id. Play it full-screen.
	ld a, e
	ld [wFXAnimID], a
	ld a, d
	ld [wFXAnimID + 1], a
	xor a
	ld [wNumHits], a
	farcall PlayBattleAnim
	ret

PlayPerTurnWeatherAnim::
; Called from HandleWeather each turn (via farcall). Rain and sun replay
; their animation; sandstorm and hail already animate via their own
; between-turn damage path, so they are skipped here.
	ld a, [wBattleWeather]
	cp WEATHER_RAIN
	ld de, RAIN_DANCE
	jr z, PlayWeatherAnimDE
	cp WEATHER_SUN
	ret nz
	ld de, SUNNY_DAY
	jr PlayWeatherAnimDE

IntimidateAbility:
	; does not work against Inner Focus, Own Tempo, Oblivious, Scrappy
	call GetOpponentIgnorableAbility
	ld b, a
	and a
	jr z, .intimidate_ok
	call GetAbilityFlags
	and ABILFLAG_NO_INTIMIDATE
	jr z, .intimidate_ok
	; blocked: show both abilities and print the resist text.
	; NOTE: buffer the resisting ability's name AFTER the banners -
	; the banner GFX clobbers wStringBuffer1
	ld a, b
	push af
	call BeginAbility
	call ShowAbilityActivation
	call ShowEnemyAbilityActivation
	call BannerHoldAndDismiss
	pop af
	ld b, a
	farcall GetAbilityName
	ld hl, IntimidateResistedText
	jp StdBattleTextbox

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
	call ShowAbilityBannerBrief
	call GetItemName
	ld hl, FriskedItemText
	jp StdBattleTextbox

ScreenCleanerAbility:
	ld a, [wPlayerScreens]
	and a
	jr nz, .screens_up
	ld a, [wEnemyScreens]
	and a
	ret z
.screens_up
	call ShowAbilityBannerBrief
	ldh a, [hBattleTurn]
	push af
	call .do_it
	call SwitchTurn
	call .do_it
	pop af
	ldh [hBattleTurn], a
	ret

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
; b = stat. Prints the text on success; the generic stat-up
; animation plays from BattleCommand_StatUpMessage itself.
	farcall RaiseStat
	ld a, [wFailedMessage]
	and a
	ret nz
	farcall BattleCommand_StatUpMessage
	ret

AbilityLowerOppStat::
; b = stat. Lowers the user's opponent's stat; respects Mist.
; Prints the text on success; the generic stat-down animation
; plays from BattleCommand_StatDownMessage itself.
; Flags the drop as ability-driven so StatDown skips the vanilla
; 25% computer-miss roll (it randomly ate Mirror Armor reflections
; and enemy Intimidate).
	push hl
	ld hl, wDisguiseBusted
	set 6, [hl]
	pop hl
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
	call ShowAbilityBannerBrief
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	xor a
	ld [hl], a
	ld hl, BecameHealthyText
	call StdBattleTextbox
	ldh a, [hBattleTurn]
	and a
	jp z, UpdateBattleMonInParty
	jp UpdateEnemyMonInParty

OwnTempoAbility:
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_CONFUSED, a
	ret z ; not confused
	call ShowAbilityBannerBrief
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_CONFUSED, [hl]
	ld hl, ConfusedNoMoreText
	jp StdBattleTextbox

ObliviousAbility:
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVar
	bit SUBSTATUS_IN_LOVE, a
	ret z ; not infatuated
	call ShowAbilityBannerBrief
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, NoLongerInfatuatedText
	jp StdBattleTextbox

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
	db WATER_VEIL, THERMAL_EXCHANGE, -1

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
	call ShowEnemyAbilityBannerBrief
	scf
	ret
.no_match
	and a ; nc
	ret

; ==== End-of-turn abilities ==============================================

RunEndTurnAbilitiesBoth::
	; rain and sun replay their weather animation each turn (sandstorm and
	; hail animate via their own between-turn damage path in HandleWeather).
	; Hooked here - which core.asm already farcalls every turn - so the
	; tight Battle Core bank gains no bytes.
	call PlayPerTurnWeatherAnim
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
	; clear a stale Disguise presentation flag (set by a move that missed
	; after damage calc and never reached its kingsrock command)
	ld hl, wDisguiseBusted + 1
	res 7, [hl]
	call CheckAirBalloonImmunity
	ret c
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
	cp DISGUISE
	jp z, DisguiseBlock
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
	db STORM_DRAIN, WATER
	dw AbsorbRaiseSpAtk
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

CheckPlayerAssaultVestMove_Core:
; b = selected move. Carry if Assault Vest blocks it.
	push bc
	callfar GetUserItem
	ld a, b
	cp HELD_ASSAULT_VEST
	jr nz, .ok
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	pop bc
	ld l, b
	ld a, MOVE_CATEGORY
	call GetMoveAttribute
	cp CATEGORIZE_STATUS
	jr z, .blocked
	and a
	ret
.ok
	pop bc
	and a
	ret
.blocked
	scf
	ret

CheckPlayerChoiceLock_Core:
; b = selected move. Carry if a Choice item locks another move.
	push bc
	callfar GetUserItem
	ld a, b
	sub HELD_CHOICE_BAND
	cp HELD_CHOICE_SCARF - HELD_CHOICE_BAND + 1
	jr nc, .not_choice
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	pop bc
	ld a, [wPlayerChoiceLockedMove]
	and a
	jr z, .set_lock
	cp b
	jr nz, .blocked
	and a
	ret
.set_lock
	ld a, b
	ld [wPlayerChoiceLockedMove], a
	and a
	ret
.not_choice
	pop bc
	xor a
	ld [wPlayerChoiceLockedMove], a
	and a
	ret
.blocked
	scf
	ret


HandleEnemyHeldMoveLocks_Core:
	call SetEnemyTurn
	callfar GetUserItem
	ld a, b
	cp HELD_ASSAULT_VEST
	jr z, .assault_vest
	sub HELD_CHOICE_BAND
	cp HELD_CHOICE_SCARF - HELD_CHOICE_BAND + 1
	jr nc, .not_choice
	ld a, [wEnemyChoiceLockedMove]
	and a
	jr nz, .use_locked
	ld a, [wCurEnemyMove]
	and a
	ret z
	ld [wEnemyChoiceLockedMove], a
	ret
.use_locked
	ld b, a
	call FindEnemyMoveWithPP
	ret c
	jr ForceEnemyStruggle
.not_choice
	xor a
	ld [wEnemyChoiceLockedMove], a
	ret
.assault_vest
	xor a
	ld [wEnemyChoiceLockedMove], a
	ld a, [wCurEnemyMove]
	call EnemyMoveIsStatus
	ret nc
	call FindFirstEnemyDamagingMove
	ret c
	; fallthrough
ForceEnemyStruggle:
	ld hl, STRUGGLE
	call GetMoveIDFromIndex
	ld [wCurEnemyMove], a
	ret

FindEnemyMoveWithPP:
; b = move id. Carry if the enemy can use it.
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonPP
	ld c, 0
.loop
	ld a, [hli]
	cp b
	jr nz, .next
	ld a, [wEnemyDisabledMove]
	cp b
	jr z, .no
	ld a, [de]
	and PP_MASK
	jr z, .no
	ld a, c
	ld [wCurEnemyMoveNum], a
	ld a, b
	ld [wCurEnemyMove], a
	scf
	ret
.next
	inc de
	inc c
	ld a, c
	cp NUM_MOVES
	jr c, .loop
.no
	and a
	ret

FindFirstEnemyDamagingMove:
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonPP
	ld c, 0
.loop
	ld a, [hli]
	and a
	jr z, .next
	ld b, a
	ld a, [wEnemyDisabledMove]
	cp b
	jr z, .next
	ld a, [de]
	and PP_MASK
	jr z, .next
	ld a, b
	call EnemyMoveIsStatus
	jr c, .next
	ld a, c
	ld [wCurEnemyMoveNum], a
	ld a, b
	ld [wCurEnemyMove], a
	scf
	ret
.next
	inc de
	inc c
	ld a, c
	cp NUM_MOVES
	jr c, .loop
	and a
	ret

EnemyMoveIsStatus:
; Carry if move a is status.
	ld l, a
	ld a, MOVE_CATEGORY
	call GetMoveAttribute
	cp CATEGORIZE_STATUS
	jr z, .status
	and a
	ret
.status
	scf
	ret

RunDamageModifiers:
; Apply ability-based damage modifiers to wCurDamage.
; Attacker = current turn holder. Physical/special moves only.
	call GetMoveCategory
	cp CATEGORIZE_STATUS
	ret z
	ld e, a ; e = category
	call ApplyHeldItemDamageModifiers

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
	cp STRONG_JAW
	jp z, .strong_jaw
	cp SUPREME_OVERLORD
	jp z, .supreme_overlord
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

.strong_jaw
	; x1.5 for biting moves
	push de
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	call GetMoveIndexFromID
	ld b, h
	ld c, l
	ld de, 2
	ld hl, BiteMoves
	call IsInHalfwordArray
	pop de
	jp nc, .defender
	call DamageX1_5
	jp .defender

.supreme_overlord
	; ~+10% damage for each fainted ally (x1.09375 each, additive)
	push de
	call CountFaintedAllies
	pop de
	and a
	jp z, .defender
	call SupremeOverlordBoost
	jp .defender

ApplyHeldItemDamageModifiers:
	callfar GetUserItem
	ld a, b
	cp HELD_CHOICE_BAND
	jr z, .physical_50
	cp HELD_CHOICE_SPECS
	jr z, .special_50
	cp HELD_EXPERT_BELT
	jr z, .expert_belt
	cp HELD_LIFE_ORB
	jr z, .life_orb
	cp HELD_MUSCLE_BAND
	jr z, .physical_10
	cp HELD_WISE_GLASSES
	jr z, .special_10
	ret
.physical_50
	ld a, e
	and a
	ret nz
	ld a, 150
	jp DamagePercent
.special_50
	ld a, e
	cp CATEGORIZE_SPECIAL
	ret nz
	ld a, 150
	jp DamagePercent
.expert_belt
	ld a, [wTypeModifier]
	and $7f
	cp EFFECTIVE + 1
	ret c
	ld a, 120
	jp DamagePercent
.life_orb
	ld a, 130
	jp DamagePercent
.physical_10
	ld a, e
	and a
	ret nz
	ld a, 110
	jp DamagePercent
.special_10
	ld a, e
	cp CATEGORIZE_SPECIAL
	ret nz
	ld a, 110
	jp DamagePercent

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
DamagePercent:
; a = percent multiplier for wCurDamage. Preserves de.
	push hl
	push bc
	push de
	ldh [hMultiplier], a
	xor a
	ldh [hMultiplicand + 0], a
	ld hl, wCurDamage
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a
	call Multiply
	ld a, 100
	ldh [hDivisor], a
	ld b, 4
	call Divide
	ld hl, wCurDamage
	ldh a, [hQuotient + 2]
	ld [hli], a
	ldh a, [hQuotient + 3]
	ld [hl], a
	pop de
	pop bc
	pop hl
	ret

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
	cp MIRROR_ARMOR
	jr z, .mirror_armor
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
	call ShowEnemyAbilityBannerBrief
	scf
	ret

.mirror_armor
	; bounce the drop back at its source (no ping-pong between two
	; Mirror Armors: while the guard bit is set, take the drop instead)
	ld a, [wDisguiseBusted]
	bit 7, a
	jr nz, .no
	call ShowEnemyAbilityBannerBrief
	ld hl, wDisguiseBusted
	set 7, [hl]
	ld a, [wLoweredStat]
	ld b, a ; stat | possible $10 sharp-drop flag
	call StackCallOpponentTurn
	; (defender's perspective from here; ret unswitches)
	call AbilityLowerOppStat
	ld hl, wDisguiseBusted
	res 7, [hl]
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
	ld a, [wBattleMonItem]
	call .ChoiceScarfBoost
	push hl
	; enemy effective speed -> hl
	ld a, [wEnemyAbility]
	ld c, a
	ld a, [wEnemyMonStatus]
	ld b, a
	ld hl, wEnemyMonSpeed
	call .GetEffectiveSpeed
	ld a, [wEnemyMonItem]
	call .ChoiceScarfBoost
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

.ChoiceScarfBoost:
	cp CHOICE_SCARF
	ret nz
	ld d, h
	ld e, l
	srl d
	rr e
	add hl, de
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

CheckAirBalloonImmunity:
	call GetMoveCategory
	cp CATEGORIZE_STATUS
	jr z, .no
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp GROUND
	jr nz, .no
	callfar GetOpponentItem
	ld a, b
	cp HELD_AIR_BALLOON
	jr nz, .no
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	xor a
	ld [wTypeModifier], a
	ld [wCurDamage], a
	ld [wCurDamage + 1], a
	inc a
	ld [wAttackMissed], a
	ld hl, AirBalloonImmuneText
	call StdBattleTextbox
	scf
	ret
.no
	and a
	ret

RunPostDamageHeldItems:
	call LifeOrbRecoil
	call AirBalloonPop
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret nz
	call WeaknessPolicyBoost
	jp RockyHelmetDamage

LifeOrbRecoil:
	callfar GetUserItem
	ld a, b
	cp HELD_LIFE_ORB
	ret nz
	call GetTrueUserAbility
	cp MAGIC_GUARD
	ret z
	call UserHasFainted
	ret z
	ld d, 10
	call GetUserMaxHPFraction
	farcall SubtractHPFromUser
	ld hl, LifeOrbRecoilText
	jp StdBattleTextbox

AirBalloonPop:
	callfar GetOpponentItem
	ld a, b
	cp HELD_AIR_BALLOON
	ret nz
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	callfar ConsumeHeldItem
	ld hl, AirBalloonPoppedText
	jp StdBattleTextbox

WeaknessPolicyBoost:
	ld a, [wTypeModifier]
	and $7f
	cp EFFECTIVE + 1
	ret c
	callfar GetOpponentItem
	ld a, b
	cp HELD_WEAKNESS_POLICY
	ret nz
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	callfar ConsumeHeldItem
	call SwitchTurn
	ld hl, BattleText_UsersStringBuffer1Activated
	call StdBattleTextbox
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	farcall BattleCommand_AttackUp2
	farcall BattleCommand_StatUpMessage
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	farcall BattleCommand_SpecialAttackUp2
	farcall BattleCommand_StatUpMessage
	jp SwitchTurn

RockyHelmetDamage:
	call CheckContactMove
	ret nc
	call UserHasFainted
	ret z
	callfar GetOpponentItem
	ld a, b
	cp HELD_ROCKY_HELMET
	ret nz
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld d, 6
	call GetUserMaxHPFraction
	farcall SubtractHPFromUser
	ld hl, RockyHelmetText
	jp StdBattleTextbox

GetUserMaxHPFraction:
; d = divisor. Returns bc = max(1, max HP / d).
	ld hl, wBattleMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonMaxHP
.got_hp
	xor a
	ldh [hDividend + 0], a
	ldh [hDividend + 1], a
	ld a, [hli]
	ldh [hDividend + 2], a
	ld a, [hl]
	ldh [hDividend + 3], a
	ld a, d
	ldh [hDivisor], a
	ld b, 4
	call Divide
	ldh a, [hQuotient + 2]
	ld b, a
	ldh a, [hQuotient + 3]
	ld c, a
	or b
	ret nz
	inc c
	ret

RunContactAbilitiesHook::
; Runs after damage is applied. Turn = attacker.
	; deferred Disguise reveal: now that the move animation has played,
	; bust the disguise, swap the sprite and print the texts
	ld hl, wDisguiseBusted + 1
	bit 7, [hl]
	call nz, DisguisePresentation
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
	call RunPostDamageHeldItems
	; no procs through a Substitute
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret nz
	; nothing procs if the defender already fainted
	call OppHasFainted
	ret z
	; defender on-hit abilities (any damaging move, contact or not)
	call GetOpponentAbility
	cp STAMINA
	jr z, .stamina
	cp THERMAL_EXCHANGE
	jr z, .thermal_exchange
.contact
	call CheckContactMove
	ret nc
	; attacker on-contact abilities
	call GetTrueUserAbility
	cp POISON_TOUCH
	call z, PoisonTouchAbility
	; defender on-contact abilities (perspective switches to the defender)
	call StackCallOpponentTurn
	jr _RunDefenderContactAbilities

.stamina
	ld b, DEFENSE
	jr .on_hit_stat_up
.thermal_exchange
	; only Fire-type hits (checked from the attacker's perspective)
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp FIRE
	jr nz, .contact
	ld b, ATTACK
.on_hit_stat_up
	call SwitchTurn
	call BeginAbility
	call StatUpAbility
	call EndAbility
	call SwitchTurn
	jr .contact

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
	; CallBattleCore lives in the Effect Commands bank - a plain call from
	; this bank jumps into garbage and crashes. farcall does the same job
	; with the target's own bank.
	farcall ApplyPrzEffectOnSpeed
	ld de, ANIM_PAR
	call AbilityStatusAnim
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
	; see StaticAbility: CallBattleCore is not callable from this bank
	farcall ApplyBrnEffectOnAttack
	ld de, ANIM_BRN
	call AbilityStatusAnim
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
	ld de, ANIM_PSN
	call AbilityStatusAnim
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
	ld de, ANIM_SLP
	call AbilityStatusAnim
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

AbilityStatusAnim:
; de = status anim id (ANIM_PAR/BRN/PSN/SLP). Plays it on the turn
; holder's opponent (the mon that just got the status). Same mechanism as
; Effect Commands' PlayOpponentBattleAnim, which is in another bank.
; Safe here: every caller uses ShowAbilityBannerBrief, so the banner is
; already dismissed before the animation redraws the scene.
	ld a, e
	ld [wFXAnimID], a
	ld a, d
	ld [wFXAnimID + 1], a
	xor a
	ld [wNumHits], a
	call SwitchTurn
	farcall PlayBattleAnim
	jp SwitchTurn

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

; ==== Session 4 additions ================================================

AbilityCriticalMods::
; Called from BattleCommand_Critical before the normal crit roll.
; Returns carry if the crit decision is final (wCriticalHit already set):
; Battle Armor/Shell Armor block crits; Merciless always crits poisoned foes.
	call GetOpponentIgnorableAbility
	cp BATTLE_ARMOR
	jr z, .blocked
	cp SHELL_ARMOR
	jr z, .blocked
	call GetTrueUserAbility
	cp MERCILESS
	jr nz, .normal
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and 1 << PSN
	jr z, .normal
	ld a, 1
	ld [wCriticalHit], a
	scf
	ret
.blocked
	xor a
	ld [wCriticalHit], a
	scf
	ret
.normal
	and a
	ret

AbilityCompareMovePriority::
; Replaces the body of CompareMovePriority (Battle Core).
; Returns carry if the player goes first, z if the priorities match.
; Applies Gale Wings (X/Y behavior: all Flying moves +1, no HP condition)
; and Triage (+3 to HP-restoring moves).
	ld a, [wCurPlayerMove]
	ld e, a
	farcall GetMovePriority_e
	ld d, e
	ld a, [wCurPlayerMove]
	ld b, a
	ld a, [wPlayerAbility]
	ld c, a
	call .Adjust
	push de
	ld a, [wCurEnemyMove]
	ld e, a
	farcall GetMovePriority_e
	ld d, e
	ld a, [wCurEnemyMove]
	ld b, a
	ld a, [wEnemyAbility]
	ld c, a
	call .Adjust
	pop bc ; b = player priority
	ld a, d ; enemy priority
	cp b
	ret

.Adjust:
; b = move id, c = ability, d = priority. Returns adjusted priority in d.
	ld a, b
	and a
	ret z ; no move chosen (switch/item)
	ld a, c
	cp GALE_WINGS
	jr z, .gale_wings
	cp TRIAGE
	jr z, .triage
	ret

.gale_wings
	; +1 priority for Flying-type moves (type as stored in the move data)
	ld a, b
	call GetMoveIndexFromID
	dec hl
	ld b, h
	ld c, l
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, bc ; hl = (index - 1) * MOVE_LENGTH
	ld bc, Moves + MOVE_TYPE
	add hl, bc
	ld a, BANK(Moves)
	call GetFarByte
	cp FLYING
	ret nz
	inc d
	ret

.triage
	; +3 priority for HP-restoring moves
	ld a, b
	call GetMoveIndexFromID
	ld b, h
	ld c, l
	push de
	ld de, 2
	ld hl, TriageMoves
	call IsInHalfwordArray
	pop de
	ret nc
	ld a, d
	add 3
	ld d, a
	ret

CountFaintedAllies:
; a = number of fainted mons in the user's party (0-5). Eggs don't count.
	push hl
	push de
	push bc
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	; wild mons have no party
	ld a, [wBattleMode]
	dec a ; WILDMON?
	jr z, .none
	ld a, [wOTPartyCount]
	and a
	jr z, .none
	ld c, a
	ld hl, wOTPartySpecies
	ld de, wOTPartyMon1HP
	jr .count
.player
	ld a, [wPartyCount]
	and a
	jr z, .none
	ld c, a
	ld hl, wPartySpecies
	ld de, wPartyMon1HP
.count
	ld b, 0
.loop
	ld a, [hli]
	cp EGG
	jr z, .next
	push hl
	ld h, d
	ld l, e
	ld a, [hli]
	or [hl]
	pop hl
	jr nz, .next
	inc b
.next
	push hl
	ld hl, PARTYMON_STRUCT_LENGTH
	add hl, de
	ld d, h
	ld e, l
	pop hl
	dec c
	jr nz, .loop
	ld a, b
	jr .done
.none
	xor a
.done
	pop bc
	pop de
	pop hl
	ret

SupremeOverlordBoost:
; Add a * (1/16 + 1/32) of the current damage to wCurDamage (a = 1-5).
; Approximates the canon +10% per fainted ally as +9.375% each, additive.
	push hl
	push de
	push bc
	ld b, a
	ld hl, wCurDamage
	ld a, [hli]
	ld e, [hl]
	ld d, a ; de = damage
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e ; de = damage / 16
	ld h, d
	ld l, e
	srl h
	rr l ; hl = damage / 32
	add hl, de
	ld d, h
	ld e, l ; de = fraction per fainted ally
	ld hl, wCurDamage
	ld a, [hli]
	ld l, [hl]
	ld h, a
.add_loop
	add hl, de
	jr c, .cap
	dec b
	jr nz, .add_loop
	jr .store
.cap
	ld hl, $ffff
.store
	ld a, h
	ld [wCurDamage], a
	ld a, l
	ld [wCurDamage + 1], a
	pop bc
	pop de
	pop hl
	ret

; ==== Disguise (Sun/Moon behavior) ========================================

DisguiseBlock:
; Jumped to from .CheckNullification with the defender's ability = DISGUISE.
; Blocks the damage of the first hit outright (no HP loss - S/M behavior),
; but not the move's other effects. Returns carry if the hit was blocked.
	call SwitchTurn ; user = the Disguise holder from here
	ldh a, [hBattleTurn]
	and a
	ld a, [wBattleMonSpecies]
	jr z, .got_species
	ld a, [wEnemyMonSpecies]
.got_species
	call GetPokemonIndexFromID
	ld a, l
	cp LOW(MIMIKYU)
	jr nz, .no_block
	ld a, h
	cp HIGH(MIMIKYU)
	jr nz, .no_block
	; no trigger through a Substitute (canon)
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	jr nz, .no_block
	call GetDisguiseFlag
	and [hl]
	jr nz, .no_block ; already busted
	; cancel the damage, but keep the move's secondary effects:
	; zero wCurDamage and neutralize the effectiveness text
	xor a
	ld [wCurDamage], a
	ld [wCurDamage + 1], a
	ld [wCriticalHit], a
	ld a, [wTypeModifier]
	and $80
	or EFFECTIVE
	ld [wTypeModifier], a
	; the bust + presentation are DEFERRED to DisguisePresentation (run
	; from the kingsrock hook), so the move's animation plays first and a
	; move that misses after damage calc doesn't break the disguise
	ld hl, wDisguiseBusted + 1
	set 7, [hl]
	call SwitchTurn
	scf
	ret
.no_block
	call SwitchTurn
	and a
	ret

DisguisePresentation:
; Deferred from DisguiseBlock; runs from the kingsrock hook (turn =
; attacker), after the move animation and HP bar update.
	ld hl, wDisguiseBusted + 1
	res 7, [hl]
	; if the move ultimately missed, the disguise never broke
	ld a, [wAttackMissed]
	and a
	ret nz
	call SwitchTurn ; the Disguise holder's side
	call GetDisguiseFlag
	ld b, a
	ld a, [hl]
	or b
	ld [hl], a ; mark this slot's disguise as busted
	call ShowAbilityBannerBrief
	ld hl, DisguiseDecoyText
	call StdBattleTextbox
	call LoadBrokenDisguisePic
	ld hl, DisguiseBustedText
	call StdBattleTextbox
	jp SwitchTurn

GetDisguiseFlag:
; For the current turn holder: hl = its wDisguiseBusted byte,
; a = the bit mask for its current party slot (wild mons use bit 0).
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	ld hl, wDisguiseBusted + 1
	ld a, [wBattleMode]
	dec a ; WILDMON?
	ld a, 0
	jr z, .got_slot
	ld a, [wCurOTMon]
	jr .got_slot
.player
	ld hl, wDisguiseBusted
	ld a, [wCurBattleMon]
.got_slot
	and %111
	push bc
	ld b, a
	ld a, 1
	inc b
.shift
	dec b
	jr z, .shifted
	add a, a
	jr .shift
.shifted
	pop bc
	ret

ReapplyBrokenDisguise:
; If the entering turn holder is a Mimikyu whose disguise busted earlier
; this battle, restore the broken sprite (the switch-in loaded the normal
; pic).
	ldh a, [hBattleTurn]
	and a
	ld a, [wBattleMonSpecies]
	jr z, .got_species
	ld a, [wEnemyMonSpecies]
.got_species
	call GetPokemonIndexFromID
	ld a, l
	cp LOW(MIMIKYU)
	ret nz
	ld a, h
	cp HIGH(MIMIKYU)
	ret nz
	call GetDisguiseFlag
	and [hl]
	ret z
	; fallthrough

LoadBrokenDisguisePic:
; Load the broken-disguise pic for the current turn holder's side.
; Enemy: animated 5x5 frontpic padded to 7x7 at vTiles2 $00 (+ animation
; tiles in VRAM bank 1, mirroring GetAnimatedFrontpic's layout).
; Player: 6x6 backpic at vTiles2 $31.
	push hl
	push de
	push bc
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	xor a
	ldh [hBGMapMode], a
	ldh a, [hBattleTurn]
	and a
	jr z, .backpic
	; enemy frontpic
	ld a, BANK(MimikyuBrokenFrontpic)
	ld hl, MimikyuBrokenFrontpic
	ld de, wDecompressScratch
	call FarDecompress
	ld de, wDecompressScratch
	ld hl, wDecompressScratch + 50 tiles
	call .Pad5x5To7x7
	ld hl, vTiles2
	ld de, wDecompressScratch + 50 tiles
	ld c, 7 * 7
	ldh a, [hROMBank]
	ld b, a
	call Get2bpp
	; animation frames -> VRAM bank 1, after the padded base pic
	ld a, BANK(vTiles3)
	ldh [rVBK], a
	ld hl, vTiles2 tile $31
	ld de, wDecompressScratch + 25 tiles
	ld c, 25
	ldh a, [hROMBank]
	ld b, a
	call Get2bpp
	xor a
	ldh [rVBK], a
	jr .done
.backpic
	ld a, BANK(MimikyuBrokenBackpic)
	ld hl, MimikyuBrokenBackpic
	ld de, wDecompressScratch
	call FarDecompress
	ld hl, vTiles2 tile $31
	ld de, wDecompressScratch
	ld c, 6 * 6
	ldh a, [hROMBank]
	ld b, a
	call Get2bpp
.done
	pop af
	ldh [rSVBK], a
	ld a, $1
	ldh [hBGMapMode], a
	pop bc
	pop de
	pop hl
	ret

.Pad5x5To7x7:
; de = source (25 tiles, column-major), hl = dest (49 tiles).
; Mirrors PadFrontpic's 5x5 layout: 1 blank column, 5x (2 blank tiles +
; 5 pic tiles), 1 blank column.
	xor a
	ld c, 7 * 16
	call .fill
	ld b, 5
.column
	xor a
	ld c, 2 * 16
	call .fill
	ld c, 5 * 16
.copy
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .copy
	dec b
	jr nz, .column
	xor a
	ld c, 7 * 16
	; fallthrough
.fill
	ld [hli], a
	dec c
	jr nz, .fill
	ret

BiteMoves:
; Strong Jaw: biting moves (canon list, restricted to moves in this game)
	dw BITE
	dw CRUNCH
	dw HYPER_FANG
	dw FIRE_FANG
	dw ICE_FANG
	dw THUNDER_FANG
	dw POISON_FANG
	dw -1

TriageMoves:
; Triage: HP-restoring moves (canon list, restricted to moves in this game)
	dw ABSORB
	dw MEGA_DRAIN
	dw GIGA_DRAIN
	dw LEECH_LIFE
	dw DREAM_EATER
	dw DRAIN_PUNCH
	dw DRAINING_KISS
	dw RECOVER
	dw SOFTBOILED
	dw REST
	dw MILK_DRINK
	dw MORNING_SUN
	dw SYNTHESIS
	dw MOONLIGHT
	dw -1

MimikyuBrokenFrontpic: INCBIN "gfx/pokemon/mimikyu-broken/front.animated.2bpp.lz"
MimikyuBrokenBackpic:  INCBIN "gfx/pokemon/mimikyu-broken/back.2bpp.lz"

INCLUDE "data/abilities/flags.asm"
