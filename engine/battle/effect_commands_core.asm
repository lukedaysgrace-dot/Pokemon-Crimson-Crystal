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

EndureFocusSashInEffect_Core:
; Carry if ApplyDamage should proceed to damage. b = survival message id.
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_ENDURE, a
	jr z, .sturdy
	farcall BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .go_damage
	ld b, 1
	jr .go_damage
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

INCLUDE "engine/battle/move_effects/triple_kick.asm"
INCLUDE "engine/battle/move_effects/new_move_cores.asm"
INCLUDE "engine/battle/move_effects/thief.asm"
