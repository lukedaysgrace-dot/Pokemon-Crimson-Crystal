; Ability battle engine.
; Port of Polished Crystal's engine/battle/abilities.asm, adapted to the
; vanilla-style Supreme Silver battle engine.
;
; Ported categories: entry, status-heal, status prevention, end-of-turn,
; post-battle, contact/on-hit, nullification/absorb, damage/stat/accuracy/
; priority modifiers, faint abilities, Magic Bounce, Synchronize, trapping
; (Shadow Tag/Arena Trap/Magnet Pull), switch-out (Natural Cure/
; Regenerator), Serene Grace/Sheer Force/Skill Link/Prankster/Armor Tail/
; Analytic/Cursed Body/Berserk/Weak Armor/Justified/Aftermath/Cute Charm/
; Iron Barbs. See ABILITY_PORT_PLAN.md for status and known limitations.

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
	; announce the traced ability AFTER the banners
	pop af
	push af
	ld hl, TraceActivationText
	call StdBattleTextbox
	ld a, BATTLE_VARS_ABILITY
	call GetBattleVarAddr
	pop af
	ld [hl], a
	jp RunEntryAbilities

ImposterAbility:
; Banner briefly, then Transform (wave deform + sprite swap).
; BattleCommand_Transform plays the anim itself; skip TransformedText.
	call ShowAbilityBannerBrief
	ld a, 1
	ld [wTempByteValue], a
	farcall BattleCommand_Transform
	xor a
	ld [wTempByteValue], a
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
; Each list is prefixed with a "bounce kind" byte so Magic Bounce knows how
; to reflect a STATUS move of that kind back at its user.
; NOTE: de must be preserved on the no-carry path (SleepTarget keeps its
; status pointer in de across the farcall). The carry paths all jump
; straight to failure handling, so de is free to clobber there.

BOUNCE_NONE EQU 0
BOUNCE_SLP  EQU 1
BOUNCE_PAR  EQU 2
BOUNCE_PSN  EQU 3
BOUNCE_BRN  EQU 4
BOUNCE_CNF  EQU 5
BOUNCE_ATR  EQU 6

AbilityPreventsSleep::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db BOUNCE_SLP
	db INSOMNIA, VITAL_SPIRIT, -1

AbilityPreventsParalysis::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db BOUNCE_PAR
	db LIMBER, -1

AbilityPreventsPoison::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db BOUNCE_PSN
	db IMMUNITY, PASTEL_VEIL, -1

AbilityPreventsBurn::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db BOUNCE_BRN
	db WATER_VEIL, THERMAL_EXCHANGE, -1

AbilityPreventsFreeze::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db BOUNCE_NONE
	db MAGMA_ARMOR, -1

AbilityPreventsConfusion::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db BOUNCE_CNF
	db OWN_TEMPO, -1

AbilityPreventsAttraction::
	ld hl, .abilities
	jr CheckStatusPrevention
.abilities
	db BOUNCE_ATR
	db OBLIVIOUS, -1

CheckStatusPrevention:
; hl = bounce kind byte, then -1-terminated ability list.
; Carry if the defender's ability matches (or Magic Bounce reflected).
	call GetOpponentIgnorableAbility
	and a
	ret z ; nc
	ld b, a
	ld a, [hli] ; bounce kind
	ld c, a
	ld a, b
	cp MAGIC_BOUNCE
	jr z, .magic_bounce
.loop
	ld a, [hli]
	cp -1
	jr z, .no_match
	cp b
	jr nz, .loop
	; prevented. Thermal Exchange's Fire hit already shows its own Atk-up
	; banner via the on-hit path, so suppress this (redundant) second
	; banner for it - the burn is still blocked, just silently.
	cp THERMAL_EXCHANGE
	jr z, .prevented_no_banner
	; show the defender's banner
	call ShowEnemyAbilityBannerBrief
.prevented_no_banner
	scf
	ret
.no_match
	and a ; nc
	ret

.magic_bounce
	; Magic Bounce reflects STATUS moves back at their user.
	; Secondary effects of damaging moves are not bounced (canon), and a
	; bounced move can't be bounced again (guard bit 6 of wDisguiseBusted+1).
	ld a, c
	and a ; BOUNCE_NONE?
	jr z, .no_match
	call GetMoveCategory
	cp CATEGORIZE_STATUS
	jr nz, .no_match
	ld a, [wDisguiseBusted + 1]
	bit 6, a
	jr nz, .no_match
	ld hl, wDisguiseBusted + 1
	set 6, [hl]
	; run the reflected status attempt from the bouncer's perspective
	; (the Try* handlers status the bouncer's OPPONENT = original attacker,
	; showing the bouncer's MAGIC BOUNCE banner)
	ld hl, .bounce_handlers
	ld b, 0
	dec c
	sla c
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call SwitchTurn
	call _hl_
	call SwitchTurn
	ld hl, wDisguiseBusted + 1
	res 6, [hl]
	scf ; the original move fails
	ret

.bounce_handlers
	dw TrySleepOpponent      ; BOUNCE_SLP
	dw TryParalyzeOpponent   ; BOUNCE_PAR
	dw TryPoisonOpponentContact ; BOUNCE_PSN
	dw TryBurnOpponent       ; BOUNCE_BRN
	dw TryConfuseOpponent    ; BOUNCE_CNF
	dw TryAttractOpponent    ; BOUNCE_ATR

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
	jr .list_abilities ; type table exhausted; try move-list blockers
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

.list_abilities
	; Soundproof / Bulletproof / Wind Rider block whole move classes
	ld a, b
	push af
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	call GetMoveIndexFromID
	ld b, h
	ld c, l
	pop af
	ld de, 2
	cp SOUNDPROOF
	ld hl, SoundMoves
	jr z, .try_block
	cp BULLETPROOF
	ld hl, BallBombMoves
	jr z, .try_block
	cp WIND_RIDER
	jr nz, .no_block
	; Wind Rider also raises Attack when it blocks
	ld hl, WindMoves
	call IsInHalfwordArray
	jr nc, .no_block
	ld hl, AbsorbRaiseAttack
	jr .do_block
.try_block
	call IsInHalfwordArray
	jr nc, .no_block
	ld hl, AbsorbNothing
.do_block
	xor a
	ld [wTypeModifier], a
	ld [wCurDamage], a
	ld [wCurDamage + 1], a
	call SwitchTurn
	push hl
	call ShowAbilityBannerBrief
	pop hl
	call _hl_
	call SwitchTurn
	ld a, 1
	ld [wAttackMissed], a
	scf ; blocked
	ret
.no_block
	and a ; nc
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
	dw FlashFireActivate
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

FlashFireActivate:
; Runs from the holder's perspective (the .found path SwitchTurns first).
; Arms the x1.5 Fire boost in RunDamageModifiers; the bit lives in
; SubStatus2 so it clears automatically when the mon leaves the field.
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVarAddr
	bit SUBSTATUS_FLASH_FIRE, [hl]
	ret nz ; already activated: still immune, no second message
	set SUBSTATUS_FLASH_FIRE, [hl]
	ld hl, FlashFireText
	jp StdBattleTextbox

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
	cp ANALYTIC
	jp z, .analytic
	cp SHEER_FORCE
	jp z, .sheer_force
	cp SNIPER
	jp z, .sniper
	cp RIVALRY
	jp z, .rivalry
	cp TOUGH_CLAWS
	jp z, .tough_claws
	cp IRON_FIST
	jp z, .iron_fist
	cp SHARPNESS
	jp z, .sharpness
	cp RECKLESS
	jp z, .reckless
	cp ADAPTABILITY
	jp z, .adaptability
	cp STEELY_SPIRIT
	jp z, .steely_spirit
	cp MEGA_LAUNCHER
	jp z, .mega_launcher
	cp MEGA_SOL
	jp z, .mega_sol
	cp SAND_FORCE
	jp z, .sand_force
	cp FLASH_FIRE
	jp z, .flash_fire
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
	cp FLUFFY
	jr z, .fluffy
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
	cp SUPER_EFFECTIVE * 2
	jp nc, HalveDamage
	jp DamageX0_75

.dry_skin
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp FIRE
	ret nz
	jp DamageX1_25

.fluffy
	; halves contact damage, but doubles Fire damage taken (both can apply)
	call CheckContactMove
	jr nc, .fluffy_fire
	call HalveDamage
.fluffy_fire
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp FIRE
	ret nz
	jp DoubleDamage

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

.analytic
	; x1.3 if the user moved last this turn
	ld a, [wEnemyGoesFirst] ; 0 if the player went first
	ld b, a
	ldh a, [hBattleTurn]
	and a
	jr z, .analytic_player
	; enemy attacker: boost only if the player went first
	ld a, b
	and a
	jp nz, .defender
	jr .analytic_boost
.analytic_player
	; player attacker: boost only if the enemy went first
	ld a, b
	and a
	jp z, .defender
.analytic_boost
	ld a, 130
	call DamagePercent
	jp .defender

.sheer_force
	; x1.3 if the move has a secondary effect chance (the effect itself is
	; suppressed in BattleCommand_EffectChance_Core)
	push hl
	ld hl, wPlayerMoveStruct + MOVE_CHANCE
	ldh a, [hBattleTurn]
	and a
	jr z, .sheer_got_chance
	ld hl, wEnemyMoveStruct + MOVE_CHANCE
.sheer_got_chance
	ld a, [hl]
	pop hl
	and a
	jp z, .defender
	ld a, 130
	call DamagePercent
	jp .defender

.sniper
	; x1.5 damage on critical hits
	ld a, [wCriticalHit]
	and a
	jp z, .defender
	call DamageX1_5
	jp .defender

.rivalry
	; x1.25 vs the same gender, x0.75 vs the opposite gender
	push de
	call CheckGenderMatchup
	pop de
	and a
	jr z, .rivalry_boost
	dec a
	jp nz, .defender ; genderless involved: no change
	call DamageX0_75
	jp .defender
.rivalry_boost
	call DamageX1_25
	jp .defender

.tough_claws
	; x1.3 for contact moves
	call CheckContactMove
	jp nc, .defender
	ld a, 130
	call DamagePercent
	jp .defender

.iron_fist
	; x1.2 for punching moves
	ld hl, PunchMoves
	call CurrentMoveInList
	jp nc, .defender
	call DamageX1_2
	jp .defender

.sharpness
	; x1.5 for slicing moves
	ld hl, SliceMoves
	call CurrentMoveInList
	jp nc, .defender
	call DamageX1_5
	jp .defender

.mega_launcher
	; x1.5 for pulse moves
	ld hl, PulseMoves
	call CurrentMoveInList
	jp nc, .defender
	call DamageX1_5
	jp .defender

.reckless
	; x1.2 for recoil and crash-damage moves
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_RECOIL_HIT
	jr z, .reckless_boost
	cp EFFECT_FLARE_BLITZ
	jr z, .reckless_boost
	cp EFFECT_JUMP_KICK
	jp nz, .defender
.reckless_boost
	call DamageX1_2
	jp .defender

.adaptability
	; STAB becomes x2 (an extra x1.33 on top of the normal x1.5)
	push hl
	ld hl, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .adapt_got_types
	ld hl, wEnemyMonType1
.adapt_got_types
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp [hl]
	inc hl
	jr z, .adapt_boost
	cp [hl]
	jr z, .adapt_boost
	pop hl
	jp .defender
.adapt_boost
	pop hl
	ld a, 133
	call DamagePercent
	jp .defender

.steely_spirit
	; x1.5 for Steel-type moves
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp STEEL
	jp nz, .defender
	call DamageX1_5
	jp .defender

.sand_force
	; x1.3 for Rock/Ground/Steel moves in a sandstorm
	ld a, [wBattleWeather]
	cp WEATHER_SANDSTORM
	jp nz, .defender
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp ROCK
	jr z, .sand_force_boost
	cp GROUND
	jr z, .sand_force_boost
	cp STEEL
	jp nz, .defender
.sand_force_boost
	ld a, 130
	call DamagePercent
	jp .defender

.mega_sol
	; the user's moves act as if Sunny Day were active:
	; Fire x1.5, Water x0.5 (compensating if rain is really up)
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	jp z, .defender ; real sun already applied
	cp WEATHER_RAIN
	jr z, .mega_sol_rain
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp FIRE
	jr z, .mega_sol_fire
	cp WATER
	jp nz, .defender
	call HalveDamage
	jp .defender
.mega_sol_fire
	call DamageX1_5
	jp .defender
.mega_sol_rain
	; rain already halved Fire / boosted Water - convert to sun's numbers
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp FIRE
	jr z, .mega_sol_rain_fire
	cp WATER
	jp nz, .defender
	ld a, 33 ; x1.5 rain boost -> x0.5 net
	call DamagePercent
	jp .defender
.mega_sol_rain_fire
	call DoubleDamage
	call DamageX1_5 ; x0.5 rain cut -> x1.5 net
	jp .defender

.flash_fire
	; x1.5 for the user's Fire moves once Flash Fire has been activated
	; (body lives at the end of the dispatch area - see the session 4
	; note about jr ranges before .pinch_boost)
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVar
	bit SUBSTATUS_FLASH_FIRE, a
	jp z, .defender
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp FIRE
	jp nz, .defender
	call DamageX1_5
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
	cp MAGIC_BOUNCE
	jr z, .magic_bounce_drop
	cp CONTRARY
	jr z, .contrary
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
	jr z, .check_acc
	cp MINDS_EYE
	jr nz, .not_acc
.check_acc
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

.contrary
	; Contrary: drops on the holder become raises (any source, incl.
	; Intimidate). The bit-7 marker stops ContraryCheckRaise from
	; re-inverting the synthetic raise.
	call ShowEnemyAbilityBannerBrief
	ld a, [wLoweredStat]
	and $1f
	ld b, a
	ld a, [wLoweredStat]
	or $80
	ld [wLoweredStat], a
	call SwitchTurn
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	call AbilityRaiseStat
	call SwitchTurn
	scf ; the original drop "fails"
	ret

.magic_bounce_drop
	; Magic Bounce reflects stat drops from STATUS moves only - not from
	; abilities (Intimidate/Tangling Hair, flagged via bit 6) and not from
	; secondary effects of damaging moves.
	ld a, [wDisguiseBusted]
	bit 6, a
	jr nz, .no
	call GetMoveCategory
	cp CATEGORIZE_STATUS
	jr nz, .no
	; fallthrough: bounce it exactly like Mirror Armor
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
	cp ARMOR_TAIL
	jr z, .armor_tail
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

.armor_tail
	; increased-priority moves fail against an Armor Tail holder
	push bc
	ldh a, [hBattleTurn]
	and a
	ld a, [wCurPlayerMove]
	jr z, .armor_tail_got_move
	ld a, [wCurEnemyMove]
.armor_tail_got_move
	and a
	jr z, .armor_tail_ok ; no move (item/switch edge case)
	ld e, a
	farcall GetMovePriority_e
	ld a, e
	cp BASE_PRIORITY + 1
	jr c, .armor_tail_ok ; normal or negative priority
	pop bc
	ld b, 0 ; can never hit
	ret
.armor_tail_ok
	pop bc
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
	jr z, .finish
	sbc a ; $ff if the enemy is faster, else $00
	ld b, a
	ld a, [wTrickRoomTimer]
	and a
	ld a, b
	jr z, .tr_done
	cpl ; Trick Room inverts speed order
.tr_done
	and a
	jr z, .player_faster
	scf ; enemy faster: carry set, z clear (a is $ff)
	jr .finish
.player_faster
	or 1 ; player faster: carry and z clear
.finish
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
; Also refreshes wBuffer1-2 (= wCurHPAnimMaxHP) with the USER's max HP, the
; way GetMaxHP does, so a following SubtractHPFromUser animates the bar
; against the right maximum. Without this the bar scales the user's HP
; against whatever max was last left in the buffer (the just-KO'd defender's
; on the Aftermath/Rocky Helmet/Life Orb paths), garbling the HP bar.
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
	ld [wBuffer2], a ; HP-bar max HP, high byte
	ld a, [hl]
	ldh [hDividend + 3], a
	ld [wBuffer1], a ; HP-bar max HP, low byte
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
	; if the defender just fainted, only its Aftermath can proc
	call OppHasFainted
	jp z, .aftermath
	; Parental Bond: a second hit at 25% power
	call GetTrueUserAbility
	cp PARENTAL_BOND
	call z, ParentalBondSecondHit
	call OppHasFainted
	jp z, .aftermath
	; defender on-hit abilities (any damaging move, contact or not)
	call GetOpponentAbility
	cp STAMINA
	jr z, .stamina
	cp THERMAL_EXCHANGE
	jr z, .thermal_exchange
	cp JUSTIFIED
	jr z, .justified
	cp WEAK_ARMOR
	jp z, .weak_armor
	cp BERSERK
	jp z, .berserk
	cp CURSED_BODY
	jp z, .cursed_body
	cp ANGER_POINT
	jp z, .anger_point
	cp TOXIC_DEBRIS
	jp z, .toxic_debris
.contact
	call CheckContactMove
	ret nc
	; attacker on-contact abilities
	call GetTrueUserAbility
	cp POISON_TOUCH
	call z, PoisonTouchAbility
	; defender on-contact abilities (perspective switches to the defender)
	call StackCallOpponentTurn
	jp _RunDefenderContactAbilities

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
	jr .on_hit_stat_up
.justified
	; Atk+1 when hit by a Dark-type move
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp DARK
	jr nz, .contact
	ld b, ATTACK
.on_hit_stat_up
	call SwitchTurn
	call BeginAbility
	call StatUpAbility
	call EndAbility
	call SwitchTurn
	; don't leak a maxed-stat failure into the rest of the move script
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	jr .contact

.weak_armor
	; physical hits lower the holder's Defense but sharply raise its Speed
	call GetMoveCategory
	and a ; CATEGORIZE_PHYSICAL
	jr nz, .contact
	call ShowEnemyAbilityBannerBrief
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld b, DEFENSE
	call AbilityLowerOppStat
	call SwitchTurn
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld b, $10 | SPEED ; sharply (+2)
	call AbilityRaiseStat
	call SwitchTurn
	; don't leak a failed stat change into the rest of the move script
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	jp .contact

.berserk
	; SpA+1 when a hit drops the holder from >=1/2 to <1/2 of its max HP
	call .berserk_check
	jr nc, .contact
	ld b, SP_ATTACK
	jr .on_hit_stat_up

.berserk_check
; carry if the defender crossed below half HP with this hit
	push hl
	push de
	push bc
	ld hl, wEnemyMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp_ptr
	ld hl, wBattleMonHP
.got_hp_ptr
	; de = current HP
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	; bc = max HP / 2
	ld a, [hli]
	ld b, a
	ld c, [hl]
	srl b
	rr c
	; HP now must be below half...
	ld a, d
	cp b
	jr c, .below_half_now
	jr nz, .berserk_no
	ld a, e
	cp c
	jr nc, .berserk_no
.below_half_now
	; ...and HP before the hit (HP + damage) must have been at least half
	ld h, d
	ld l, e
	ld a, [wCurDamage]
	ld d, a
	ld a, [wCurDamage + 1]
	ld e, a
	add hl, de
	jr c, .berserk_yes ; 16-bit overflow: certainly >= half
	ld a, h
	cp b
	jr c, .berserk_no
	jr nz, .berserk_yes
	ld a, l
	cp c
	jr c, .berserk_no
.berserk_yes
	pop bc
	pop de
	pop hl
	scf
	ret
.berserk_no
	pop bc
	pop de
	pop hl
	and a
	ret

.cursed_body
	; 30% chance to disable the move that hit the holder
	call ContactChance
	jp nc, .contact
	call CursedBodyEffect
	jp .contact

.anger_point
	; a critical hit maxes the holder's Attack
	ld a, [wCriticalHit]
	and a
	jp z, .contact
	call AngerPointEffect
	jp .contact

.toxic_debris
	; a physical hit makes the holder scatter Toxic Spikes on the attacker's
	; side (max 2 layers). Turn = attacker, so the attacker's own screens are
	; wPlayerScreens when hBattleTurn == 0, else wEnemyScreens.
	call GetMoveCategory
	and a ; CATEGORIZE_PHYSICAL
	jp nz, .contact
	call .toxic_debris_screens
	bit SCREENS_TOXIC_SPIKES_2, [hl]
	jp nz, .contact ; already two layers down
	call ShowEnemyAbilityBannerBrief
	; play the Toxic Spikes move animation. AbilityStatusAnim flips to the
	; holder's (defender's) perspective before PlayBattleAnim, so the spikes
	; render on the attacker's field - exactly the side we just spiked.
	ld de, TOXIC_SPIKES
	call AbilityStatusAnim
	call .toxic_debris_screens ; the banner + anim clobbered hl
	bit SCREENS_TOXIC_SPIKES_1, [hl]
	jr z, .toxic_debris_first
	set SCREENS_TOXIC_SPIKES_2, [hl]
	jr .toxic_debris_text
.toxic_debris_first
	set SCREENS_TOXIC_SPIKES_1, [hl]
.toxic_debris_text
	ld hl, ToxicDebrisText
	call StdBattleTextbox
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	jp .contact
.toxic_debris_screens
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerScreens
	ret z
	ld hl, wEnemyScreens
	ret

.aftermath
	; the fainted defender's Aftermath hurts a contact attacker (1/4 max HP)
	call GetOpponentAbility
	cp AFTERMATH
	ret nz
	; a Damp attacker suffers no Aftermath damage (canon)
	call GetTrueUserAbility
	cp DAMP
	ret z
	call CheckContactMove
	ret nc
	call UserHasFainted
	ret z
	call ShowEnemyAbilityBannerBrief
	ld d, 4
	call GetUserMaxHPFraction
	farcall SubtractHPFromUser
	ld hl, IsHurtText
	jp StdBattleTextbox

AngerPointEffect:
; Turn = attacker. Maximizes the crit victim's Attack.
	call SwitchTurn ; holder's perspective
	; already maxed?
	ld hl, wPlayerStatLevels + ATTACK
	ldh a, [hBattleTurn]
	and a
	jr z, .got_levels
	ld hl, wEnemyStatLevels + ATTACK
.got_levels
	ld a, [hl]
	cp MAX_STAT_LEVEL
	jr nc, .done
	call ShowAbilityBannerBrief
.raise_loop
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld b, $10 | ATTACK
	farcall RaiseStat
	ld a, [wFailedMessage]
	and a
	jr z, .raise_loop
	; clear the cap-failure state RaiseStat left behind
	xor a
	ld [wFailedMessage], a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld hl, MaxedAttackText
	call StdBattleTextbox
.done
	jp SwitchTurn

CursedBodyEffect:
; Turn = attacker. Disables the attacker's current move for 4 turns.
	; not if the attacker already has a disabled move
	ldh a, [hBattleTurn]
	and a
	jr z, .player_attacker
	ld a, [wEnemyDisableCount]
	and a
	ret nz
	ld a, [wCurEnemyMoveNum]
	ld c, a
	ld de, wEnemyDisableCount
	ld hl, wDisabledMove + 1
	jr .apply
.player_attacker
	ld a, [wPlayerDisableCount]
	and a
	ret nz
	ld a, [wCurMoveNum]
	ld c, a
	ld de, wPlayerDisableCount
	ld hl, wDisabledMove
.apply
	; get the move id; don't disable Struggle (or no-move hits)
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	and a
	ret z
	ld b, a
	push hl
	push de
	push bc
	ld hl, STRUGGLE
	call GetMoveIDFromIndex
	pop bc
	pop de
	pop hl
	cp b
	ret z
	; store the disabled move id
	ld [hl], b
	; count = (slot+1)<<4 | 4 turns
	ld a, c
	inc a
	swap a
	or 4
	ld [de], a
	; banner on the defender's side, then the disable text (naming the
	; attacker, so print it from the defender's perspective)
	call ShowEnemyAbilityBannerBrief
	ld a, b
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	call SwitchTurn
	ld hl, WasDisabledText
	call StdBattleTextbox
	jp SwitchTurn

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
	dbw CUTE_CHARM, CuteCharmAbility
	dbw IRON_BARBS, IronBarbsAbility
	dbw PERISH_BODY, PerishBodyAbility
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
	; fallthrough
TryParalyzeOpponent:
; Paralyzes the turn holder's opponent, with banner/anim/text.
; Shared by Static, Effect Spore, Synchronize and Magic Bounce.
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
	; fallthrough
TryBurnOpponent:
; Burns the turn holder's opponent, with banner/anim/text.
; Shared by Flame Body, Synchronize and Magic Bounce.
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	ret nz
	call OpponentIsFireType
	ret z ; Fire-types can't be burned (move burns already ensure this
	      ; via CheckMoveTypeMatchesTarget; this covers the ability paths)
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
	jp z, TryParalyzeOpponent
	; fallthrough
TrySleepOpponent:
; Puts the turn holder's opponent to sleep, with banner/anim/text.
; Shared by Effect Spore and Magic Bounce.
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	ret nz
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

TryConfuseOpponent:
; Confuses the turn holder's opponent, with banner/anim/text (Magic Bounce).
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_CONFUSED, a
	ret nz
	call AbilityPreventsConfusion
	ret c
	call ShowAbilityBannerBrief
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	set SUBSTATUS_CONFUSED, [hl]
	; confused for 2-5 turns
	ld bc, wEnemyConfuseCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_confuse_count
	ld bc, wPlayerConfuseCount
.got_confuse_count
	call BattleRandom
	and %11
	inc a
	inc a
	ld [bc], a
	ld de, ANIM_CONFUSED
	call AbilityStatusAnim
	ld hl, BecameConfusedText
	call StdBattleTextbox
	jp EndAbility

TryAttractOpponent:
; Infatuates the turn holder's opponent (Magic Bounce reflection of Attract;
; the genders already passed the original move's compatibility check).
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_IN_LOVE, a
	ret nz
	call AbilityPreventsAttraction
	ret c
	call ShowAbilityBannerBrief
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	set SUBSTATUS_IN_LOVE, [hl]
	ld hl, FellInLoveText
	call StdBattleTextbox
	jp EndAbility

CuteCharmAbility:
; Defender contact ability: 30% to infatuate the attacker. Turn = defender.
	call ContactChance
	ret nc
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_IN_LOVE, a
	ret nz
	; genders must be opposite (CheckOppositeGender is turn-agnostic:
	; it compares the two active battlers directly)
	farcall CheckOppositeGender
	ret c
	call AbilityPreventsAttraction
	ret c
	call ShowAbilityBannerBrief
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	set SUBSTATUS_IN_LOVE, [hl]
	ld hl, FellInLoveText
	call StdBattleTextbox
	jp EndAbility

IronBarbsAbility:
; Defender contact ability: the attacker loses 1/8 of its max HP.
	call ShowAbilityBannerBrief
	call SwitchTurn
	ld d, 8
	call GetUserMaxHPFraction
	farcall SubtractHPFromUser
	ld hl, IsHurtText
	call StdBattleTextbox
	jp SwitchTurn

TanglingHairAbility:
	call ShowAbilityBannerBrief
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld b, SPEED
	call AbilityLowerOppStat
	; don't leak a failed drop into the rest of the move script
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	jp EndAbility

PerishBodyAbility:
; Defender contact ability: both mons will faint in three turns
; (unless the attacker is already perishing). Turn = defender.
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_PERISH, a
	ret nz
	call ShowAbilityBannerBrief
	; doom the attacker
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	set SUBSTATUS_PERISH, [hl]
	ld hl, wPlayerPerishCount
	ldh a, [hBattleTurn]
	and a
	jr nz, .got_attacker_count ; holder = enemy -> attacker = player
	ld hl, wEnemyPerishCount
.got_attacker_count
	ld [hl], 4
	; the holder is doomed too (unless already counting down)
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	bit SUBSTATUS_PERISH, [hl]
	jr nz, .text
	set SUBSTATUS_PERISH, [hl]
	ld hl, wEnemyPerishCount
	ldh a, [hBattleTurn]
	and a
	jr nz, .got_holder_count
	ld hl, wPlayerPerishCount
.got_holder_count
	ld [hl], 4
.text
	ld hl, StartPerishText
	jp StdBattleTextbox

ContactChance:
; carry 30% of the time
	ld a, 10
	call BattleRandomRange
	cp 3
	ret

AbilityStatusAnim::
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

OpponentIsFireType:
; z if the turn holder's opponent is Fire-type (burn immunity)
	push hl
	ld hl, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got_types
	ld hl, wBattleMonType1
.got_types
	ld a, [hli]
	cp FIRE
	jr z, .done
	ld a, [hl]
	cp FIRE
.done
	pop hl
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
	cp PRANKSTER
	jr z, .prankster
	ret

.prankster
	; +1 priority for status moves
	push hl
	ld l, b
	ld a, MOVE_CATEGORY
	call GetMoveAttribute
	pop hl
	cp CATEGORIZE_STATUS
	ret nz
	inc d
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

; ==== Session 6 additions ================================================

RunSynchronizePar::
; Called (farcall) right after the attacker's move paralyzed the defender.
	ld hl, TryParalyzeOpponent
	jr RunSynchronize
RunSynchronizeBrn::
; Called right after the attacker's move burned the defender.
	ld hl, TryBurnOpponent
	jr RunSynchronize
RunSynchronizePsn::
; Called right after the attacker's move poisoned the defender.
; Doubles as the Poison Puppeteer hook - both react to "this move just
; poisoned the target" (primary Toxic/Poison Gas/Powder via the Poison
; body, secondaries via PoisonTarget/ToxicTarget).
	call RunPoisonPuppeteer
	ld hl, TryPoisonOpponentContact
	; fallthrough
RunSynchronize:
; If the defender has Synchronize, pass the status back to the attacker.
; Turn = attacker; the Try* helpers run from the defender's perspective.
	call GetOpponentAbility
	cp SYNCHRONIZE
	ret nz
	call SwitchTurn
	call _hl_
	jp SwitchTurn

RunPoisonPuppeteer:
; Poison Puppeteer: a target poisoned by the holder's move also becomes
; confused (no species requirement here, unlike canon Pecharunt).
; Turn = attacker = the Puppeteer holder; TryConfuseOpponent handles the
; banner, the already-confused/Own Tempo guards, count, anim and text.
	call GetTrueUserAbility
	cp POISON_PUPPETEER
	ret nz
	jp TryConfuseOpponent

AbilityEffectChanceMods::
; b = secondary effect chance. Serene Grace doubles it; Sheer Force
; suppresses it (carry) - its damage boost lives in RunDamageModifiers.
	call GetTrueUserAbility
	cp SHEER_FORCE
	jr z, .suppress
	cp SERENE_GRACE
	jr z, .double
	and a ; nc
	ret
.double
	sla b
	ret nc
	ld b, $ff
	and a ; nc
	ret
.suppress
	ld a, b
	and a
	ret z ; no chance to suppress; nc
	scf
	ret

GetTrueUserAbility_b::
; farcall-safe wrapper: the user's effective ability, returned in b.
	call GetTrueUserAbility
	ld b, a
	ret

CheckPlayerIsTrapped::
; Carry if the player's mon can't be recalled: Wrap, Mean Look, or an
; enemy trapping ability. (Lives here to keep Battle Core bytes down.)
	ld a, [wPlayerWrapCount]
	and a
	jr nz, .trapped
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr z, CheckOpponentTrapAbility
.trapped
	scf
	ret

CheckOpponentTrapAbility::
; Carry if the ENEMY's ability prevents the player's mon from
; switching or fleeing. Preserves hl/de/bc.
	push hl
	push de
	push bc
	; the player's own Neutralizing Gas suppresses the trap
	ld a, [wPlayerAbility]
	cp NEUTRALIZING_GAS
	jr z, .free
	; Ghost-types can always leave (Gen 6 rules)
	ld a, [wBattleMonType1]
	cp GHOST
	jr z, .free
	ld a, [wBattleMonType2]
	cp GHOST
	jr z, .free
	ld a, [wEnemyAbility]
	cp SHADOW_TAG
	jr z, .shadow_tag
	cp MAGNET_PULL
	jr z, .magnet_pull
	cp ARENA_TRAP
	jr nz, .free
	; Arena Trap only traps grounded mons
	ld a, [wBattleMonType1]
	cp FLYING
	jr z, .free
	ld a, [wBattleMonType2]
	cp FLYING
	jr z, .free
	ld a, [wPlayerAbility]
	cp LEVITATE
	jr z, .free
	jr .trapped
.shadow_tag
	; Shadow Tag doesn't trap another Shadow Tag holder (Gen 4 rules)
	ld a, [wPlayerAbility]
	cp SHADOW_TAG
	jr z, .free
	jr .trapped
.magnet_pull
	; only Steel-types are trapped
	ld a, [wBattleMonType1]
	cp STEEL
	jr z, .trapped
	ld a, [wBattleMonType2]
	cp STEEL
	jr z, .trapped
.free
	pop bc
	pop de
	pop hl
	and a
	ret
.trapped
	pop bc
	pop de
	pop hl
	scf
	ret

CheckPlayerTrapsEnemy::
; Carry if the PLAYER's ability prevents the enemy mon from
; fleeing or switching. Preserves hl/de/bc.
	push hl
	push de
	push bc
	ld a, [wEnemyAbility]
	cp NEUTRALIZING_GAS
	jr z, .free
	ld a, [wEnemyMonType1]
	cp GHOST
	jr z, .free
	ld a, [wEnemyMonType2]
	cp GHOST
	jr z, .free
	ld a, [wPlayerAbility]
	cp SHADOW_TAG
	jr z, .shadow_tag
	cp MAGNET_PULL
	jr z, .magnet_pull
	cp ARENA_TRAP
	jr nz, .free
	ld a, [wEnemyMonType1]
	cp FLYING
	jr z, .free
	ld a, [wEnemyMonType2]
	cp FLYING
	jr z, .free
	ld a, [wEnemyAbility]
	cp LEVITATE
	jr z, .free
	jr .trapped
.shadow_tag
	ld a, [wEnemyAbility]
	cp SHADOW_TAG
	jr z, .free
	jr .trapped
.magnet_pull
	ld a, [wEnemyMonType1]
	cp STEEL
	jr z, .trapped
	ld a, [wEnemyMonType2]
	cp STEEL
	jr z, .trapped
.free
	pop bc
	pop de
	pop hl
	and a
	ret
.trapped
	pop bc
	pop de
	pop hl
	scf
	ret

RunPlayerSwitchOutAbilities::
; Natural Cure / Regenerator for the outgoing player mon (wLastPlayerMon).
; Called right before RecallPlayerMon; edits the party struct directly.
	ld a, [wPlayerAbility]
	cp NATURAL_CURE
	jr z, .natural_cure
	cp REGENERATOR
	ret nz
	ld a, [wLastPlayerMon]
	ld hl, wPartyMon1HP
	jr DoRegenerator
.natural_cure
	ld a, [wLastPlayerMon]
	ld hl, wPartyMon1Status
	call GetPartyLocation
	xor a
	ld [hl], a
	ret

RunEnemySwitchOutAbilities::
; Natural Cure / Regenerator for the outgoing enemy mon (wCurOTMon).
; Called before AI_Switch swaps it out.
	ld a, [wBattleMode]
	dec a ; WILDMON?
	ret z
	ld a, [wEnemyAbility]
	cp NATURAL_CURE
	jr z, .natural_cure
	cp REGENERATOR
	ret nz
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1HP
	jr DoRegenerator
.natural_cure
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Status
	call GetPartyLocation
	xor a
	ld [hl], a
	ret

DoRegenerator:
; a = party index, hl = partymon 1 HP base. Heals 1/3 max HP, capped.
	call GetPartyLocation
	; skip if fainted
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	ret z
	; de = max HP / 3
	push hl
	inc hl
	inc hl ; -> max HP
	xor a
	ldh [hDividend + 0], a
	ldh [hDividend + 1], a
	ld a, [hli]
	ldh [hDividend + 2], a
	ld a, [hld]
	ldh [hDividend + 3], a
	ld a, 3
	ldh [hDivisor], a
	ld b, 4
	call Divide
	ldh a, [hQuotient + 2]
	ld d, a
	ldh a, [hQuotient + 3]
	ld e, a
	; bc = max HP
	ld a, [hli]
	ld b, a
	ld c, [hl]
	pop hl
	; HP += de (big-endian in the struct)
	inc hl ; -> HP low
	ld a, [hl]
	add e
	ld [hld], a
	ld a, [hl]
	adc d
	ld [hli], a
	; cap at max HP: hl -> HP low, compare (high in a)
	ld d, a
	ld e, [hl]
	ld a, d
	cp b
	jr c, .done
	jr nz, .cap
	ld a, e
	cp c
	jr c, .done
	jr z, .done
.cap
	ld a, c
	ld [hld], a
	ld [hl], b
	ret
.done
	ret

; ==== Session 7 additions ================================================

ContraryCheckRaise::
; Hooked at the top of RaiseStat. b = stat id (with $10 sharp bit).
; Carry if Contrary converted the turn holder's raise into a drop
; (fully resolved, "fell" message printed; wLoweredStat bit 7 tells the
; pending statupmessage to stay quiet).
	ld a, [wLoweredStat]
	add a ; bit 7 -> carry
	jr c, .no ; this raise IS a Contrary inversion - don't recurse
	ld a, [wAttackMissed]
	and a
	jr nz, .no
	ld a, [wEffectFailed]
	and a
	jr nz, .no
	call GetTrueUserAbility
	cp CONTRARY
	jr z, .invert
.no
	and a
	ret
.invert
	call SwitchTurn
	; from here the holder is the "opponent"; drop its stat via the
	; StatDown core, skipping Mist/protection (self-inflicted, canon)
	ld hl, wDisguiseBusted
	set 6, [hl] ; skip the AI 25% miss roll
	ld a, b
	and $1f
	ld [wLoweredStat], a
	farcall StatDownSkipProtect
	farcall BattleCommand_StatDownMessage
	call SwitchTurn
	; mark the pending statupmessage as handled; report success
	ld a, [wLoweredStat]
	or $80
	ld [wLoweredStat], a
	xor a
	ld [wFailedMessage], a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	scf
	ret

AbilityPiercesGhosts::
; Carry if the user's ability lets Normal/Fighting hit Ghosts
; (Scrappy, Mind's Eye) - hooked at the type chart's Foresight marker.
	call GetTrueUserAbility
	cp SCRAPPY
	jr z, .yes
	cp MINDS_EYE
	jr z, .yes
	and a
	ret
.yes
	scf
	ret

ParentalBondSecondHit:
; Turn = attacker; the defender is alive and not behind a Substitute.
; Deals a second hit at 25% of the damage just dealt. Multi-hit-style
; moves are exempt.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_MULTI_HIT
	ret z
	cp EFFECT_DOUBLE_HIT
	ret z
	cp EFFECT_TRIPLE_KICK
	ret z
	cp EFFECT_BEAT_UP
	ret z
	cp EFFECT_SELFDESTRUCT
	ret z
	; bc = damage / 4, min 1
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
	srl b
	rr c
	srl b
	rr c
	ld a, b
	or c
	jr nz, .got_damage
	inc c
.got_damage
	; hit the defender
	call SwitchTurn
	farcall SubtractHPFromUser
	call SwitchTurn
	call UpdateBattleHuds
	ld hl, Hit2TimesText
	jp StdBattleTextbox

CurrentMoveInList:
; hl = -1-terminated dw move-index list. Carry if the current move is in
; the list. Preserves de.
	push de
	push hl
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	call GetMoveIndexFromID
	ld b, h
	ld c, l
	pop hl
	ld de, 2
	call IsInHalfwordArray
	pop de
	ret

AbilityCritLevelMods::
; c = crit stage. Super Luck adds one stage (capped at the table limit).
	call GetTrueUserAbility
	cp SUPER_LUCK
	ret nz
	inc c
	ld a, c
	cp 5
	ret c
	ld c, 4
	ret

AbilityPreventsFlinch::
; Carry if the defender's ability blocks flinching (Inner Focus).
; Canon: no message is shown.
	call GetOpponentIgnorableAbility
	cp INNER_FOCUS
	jr z, .block
	and a ; nc
	ret
.block
	scf
	ret

RunSteadfast::
; Called when the turn holder loses its action to a flinch.
	call GetTrueUserAbility
	cp STEADFAST
	ret nz
	call BeginAbility
	ld b, SPEED
	call StatUpAbility
	call EndAbility
	; a maxed Speed shouldn't leave failure flags set mid-turn
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld [wFailedMessage], a
	ret

RunStatDropReaction::
; Called after a successful stat-drop message. If the victim (the turn
; holder's opponent) has Defiant/Competitive, its Atk/SpA sharply rises.
	ld a, [wFailedMessage]
	and a
	ret nz
	call GetOpponentAbility
	cp DEFIANT
	ld b, $10 | ATTACK
	jr z, .proc
	cp COMPETITIVE
	ld b, $10 | SP_ATTACK
	ret nz
.proc
	push bc
	call SwitchTurn
	call BeginAbility
	pop bc
	call StatUpAbility
	call EndAbility
	call SwitchTurn
	; restore the caller's success state (the drop DID land)
	xor a
	ld [wFailedMessage], a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ret

AbilityPreventsSelfdestruct::
; Carry if Damp (on either side) blocks the user's selfdestructing move.
; Sets the missed/failed flags so the rest of the script fizzles.
	call GetOpponentIgnorableAbility
	cp DAMP
	jr z, .blocked_opp
	call GetTrueUserAbility
	cp DAMP
	jr z, .blocked_self
	and a ; nc
	ret
.blocked_opp
	call ShowEnemyAbilityBannerBrief
	jr .fail
.blocked_self
	call ShowAbilityBannerBrief
.fail
	ld a, 1
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	scf
	ret

GetOppIgnorableAbility_b::
; farcall-safe wrapper: the opponent's effective (Mold Breaker-ignorable)
; ability, returned in b.
	call GetOpponentIgnorableAbility
	ld b, a
	ret

RunResidualStatusAbilities::
; Called from ResidualDamage before poison/burn chip is applied.
; Carry = skip the damage: Magic Guard ignores it, Poison Heal replaces
; it with healing.
	call GetTrueUserAbility
	cp MAGIC_GUARD
	jr z, .no_damage
	cp POISON_HEAL
	jr z, .poison_heal
	and a ; nc
	ret
.poison_heal
	; heals 1/8 max HP while poisoned; burn damages normally
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and 1 << PSN
	ret z ; nc
	call CheckUserFullHP
	jr z, .no_damage
	call ShowAbilityBannerBrief
	farcall GetEighthMaxHP
	call AbilityRestoreUserHP
	ld hl, RegainedHealthText
	call StdBattleTextbox
	call EndAbility
.no_damage
	scf
	ret

CheckGenderMatchup:
; For the two active battlers: a = 0 if same gender, 1 if opposite
; genders, 2 if either is genderless/unknown. (Same setup as
; CheckOppositeGender in attract.asm, which lives in another bank.)
	ld a, MON_SPECIES
	call BattlePartyAttr
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld a, [wCurBattleMon]
	ld [wCurPartyMon], a
	xor a
	ld [wMonType], a
	farcall GetGender
	jr c, .genderless
	ld b, 1
	jr nz, .got_gender
	dec b
.got_gender
	push bc
	ld a, [wTempEnemyMonSpecies]
	ld [wCurPartySpecies], a
	ld hl, wEnemyMonDVs
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .not_transformed
	ld hl, wEnemyBackupDVs
.not_transformed
	ld a, [hli]
	ld [wTempMonDVs], a
	ld a, [hl]
	ld [wTempMonDVs + 1], a
	ld a, 3
	ld [wMonType], a
	farcall GetGender
	pop bc
	jr c, .genderless
	ld a, 1
	jr nz, .got_enemy_gender
	dec a
.got_enemy_gender
	xor b ; 0 = same, 1 = opposite
	ret
.genderless
	ld a, 2
	ret

BattleCommand_EffectChance_Core::
; Relocated from effect_commands.asm; adds Serene Grace (double chance)
; and Sheer Force (suppress the secondary effect).
	xor a
	ld [wEffectFailed], a
	callfar CheckSubstituteOpp
	jr nz, .failed

	ld hl, wPlayerMoveStruct + MOVE_CHANCE
	ldh a, [hBattleTurn]
	and a
	jr z, .got_move_chance
	ld hl, wEnemyMoveStruct + MOVE_CHANCE
.got_move_chance
	ld b, [hl]
	call AbilityEffectChanceMods
	jr c, .failed ; Sheer Force

	; BUG (vanilla): 1/256 chance to fail even for a 100% effect chance
	call BattleRandom
	cp b
	ret c

.failed
	ld a, 1
	ld [wEffectFailed], a
	and a
	ret

BattleOHKO_Core::
; Relocated from effect_commands.asm; adds Sturdy's OHKO immunity.
	callfar ResetDamage
	ld a, [wTypeModifier]
	and $7f
	jr z, .no_effect
	; Sturdy is immune to OHKO moves (classic effect)
	call GetOpponentIgnorableAbility
	cp STURDY
	jr z, .sturdy
	ld hl, wEnemyMonLevel
	ld de, wBattleMonLevel
	ld bc, wPlayerMoveStruct + MOVE_ACC
	ldh a, [hBattleTurn]
	and a
	jr z, .got_move_accuracy
	push hl
	ld h, d
	ld l, e
	pop de
	ld bc, wEnemyMoveStruct + MOVE_ACC
.got_move_accuracy
	ld a, [de]
	sub [hl]
	jr c, .no_effect
	add a
	ld e, a
	ld a, [bc]
	add e
	jr nc, .finish_ohko
	ld a, $ff
.finish_ohko
	ld [bc], a
	callfar BattleCommand_CheckHit
	ld hl, wCurDamage
	ld a, $ff
	ld [hli], a
	ld [hl], a
	ld a, $2
	ld [wCriticalHit], a
	ret

.sturdy
	call ShowEnemyAbilityBannerBrief
.no_effect
	ld a, $ff
	ld [wCriticalHit], a
	ld a, $1
	ld [wAttackMissed], a
	ret

BattleRecoil_Core::
; Relocated from effect_commands.asm; adds Rock Head / Magic Guard.
	call GetTrueUserAbility
	cp ROCK_HEAD
	ret z
	cp MAGIC_GUARD
	ret z
	ld hl, wBattleMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonMaxHP
.got_hp
; get 1/4 damage or 1 HP, whichever is higher
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
	srl b
	rr c
	srl b
	rr c
	ld a, b
	or c
	jr nz, .min_damage
	inc c
.min_damage
	ld a, [hli]
	ld [wBuffer2], a
	ld a, [hl]
	ld [wBuffer1], a
	dec hl
	dec hl
	ld a, [hl]
	ld [wBuffer3], a
	sub c
	ld [hld], a
	ld [wBuffer5], a
	ld a, [hl]
	ld [wBuffer4], a
	sbc b
	ld [hl], a
	ld [wBuffer6], a
	jr nc, .dont_ko
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wBuffer5
	ld [hli], a
	ld [hl], a
.dont_ko
	hlcoord 10, 9
	ldh a, [hBattleTurn]
	and a
	ld a, 1
	jr z, .animate_hp_bar
	hlcoord 2, 2
	xor a
.animate_hp_bar
	ld [wWhichHPBar], a
	predef AnimateHPBar
	call RefreshBattleHuds
	ld hl, RecoilText
	jp StdBattleTextbox

PunchMoves:
; Iron Fist: punching moves in this game
	dw COMET_PUNCH
	dw MEGA_PUNCH
	dw FIRE_PUNCH
	dw ICE_PUNCH
	dw THUNDERPUNCH
	dw DIZZY_PUNCH
	dw MACH_PUNCH
	dw DYNAMICPUNCH
	dw SHADOW_PUNCH
	dw BULLET_PUNCH
	dw DRAIN_PUNCH
	dw -1

SliceMoves:
; Sharpness: slicing moves in this game
	dw RAZOR_WIND
	dw CUT
	dw RAZOR_LEAF
	dw SLASH
	dw FURY_CUTTER
	dw AIR_SLASH
	dw LEAF_BLADE
	dw X_SCISSOR
	dw NIGHT_SLASH
	dw -1

PulseMoves:
; Mega Launcher: aura/pulse moves in this game
	dw DARK_PULSE
	dw DRAGON_PULSE
	dw WATER_PULSE
	dw AURA_SPHERE
	dw -1

SoundMoves:
; Soundproof: sound-based moves in this game
	dw GROWL
	dw ROAR
	dw SING
	dw SUPERSONIC
	dw SCREECH
	dw SNORE
	dw PERISH_SONG
	dw BUG_BUZZ
	dw HYPER_VOICE
	dw DISARMING_VOICE
	dw -1

BallBombMoves:
; Bulletproof: ball and bomb moves in this game
	dw EGG_BOMB
	dw BARRAGE
	dw SLUDGE_BOMB
	dw OCTAZOOKA
	dw ZAP_CANNON
	dw SHADOW_BALL
	dw AURA_SPHERE
	dw ENERGY_BALL
	dw FOCUS_BLAST
	dw GYRO_BALL
	dw ROCK_BLAST
	dw SEED_BOMB
	dw -1

WindMoves:
; Wind Rider: wind moves in this game
	dw GUST
	dw RAZOR_WIND
	dw WHIRLWIND
	dw TWISTER
	dw HURRICANE
	dw -1

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

TryEnemyFlee_Core::
; Relocated from core.asm ("Battle Core" was full). Carry = the wild
; enemy flees. farcall preserves flags on return.
	ld a, [wBattleMode]
	dec a
	jr nz, .Stay

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr nz, .Stay

	ld a, [wEnemyWrapCount]
	and a
	jr nz, .Stay

	; trapping abilities (Shadow Tag/Arena Trap/Magnet Pull); same bank now
	call CheckPlayerTrapsEnemy
	jr c, .Stay

	ld a, [wEnemyMonStatus]
	and SLP ; frostbite no longer immobilizes; only sleep pins a wild mon
	jr nz, .Stay

	ld a, [wTempEnemyMonSpecies]
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	ld de, 2
	ld hl, AlwaysFleeMons
	call IsInHalfwordArray
	jr c, .Flee

	call BattleRandom
	add a, a
	jr nc, .Stay

	push af
	; de preserved from last call
	ld hl, OftenFleeMons
	call IsInHalfwordArray
	pop de
	jr c, .Flee

	ld a, d
	cp 20 percent ; double the value because of the previous add a, a
	jr nc, .Stay

	ld de, 2
	ld hl, SometimesFleeMons
	call IsInHalfwordArray
	jr c, .Flee

.Stay:
	and a
	ret

.Flee:
	scf
	ret

INCLUDE "data/wild/flee_mons.asm"

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
