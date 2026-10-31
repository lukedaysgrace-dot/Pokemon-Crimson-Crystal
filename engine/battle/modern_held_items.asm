; Modern items share the ordinary effective-item getters (including Klutz),
; consumption history (Harvest/Recycle/Unburden) and native switch paths.
; METRONOME_ITEM is named separately from the move METRONOME.

ModernConsumeUserItem_Core::
	callfar GetUserItem
	ld a, [hl]
	farcall_a AbilityBufferItemName
	farcall SwitchTurn
	farcall ConsumeHeldItem
	farcall SwitchTurn
	ld hl, AbilityItemActivatedText
	jp StdBattleTextbox

ModernRaiseUserStat_Core:
; b = stat, with $10 for two stages. Items obey Contrary/Simple.
	push bc
	call ModernConsumeUserItem_Core
	pop bc
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	farcall AbilityRaiseStat
	ret

ModernWhiteHerbUser_Core::
	farcall UserHasFainted
	ret z
	callfar GetUserItem
	ld a, b
	cp HELD_WHITE_HERB
	ret nz
	ld hl, wPlayerStatLevels
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyStatLevels
.got
	ld c, 7
	ld b, 0
.loop
	ld a, [hl]
	cp 7
	jr nc, .next
	ld [hl], 7
	inc b
.next
	inc hl
	dec c
	jr nz, .loop
	ld a, b
	and a
	ret z
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	callfar CalcPlayerStats
	jp ModernConsumeUserItem_Core
.enemy
	callfar CalcEnemyStats
	jp ModernConsumeUserItem_Core

ModernWhiteHerbOpp_Core::
	farcall SwitchTurn
	call ModernWhiteHerbUser_Core
	farcall SwitchTurn
	ret

ModernHPItemsOpp_Core::
; The core's HP-update convention: the holder is the opponent.
	call ModernWhiteHerbOpp_Core
	farcall OppHasFainted
	ret z
	callfar GetOpponentItem
	ld a, b
	cp HELD_GOLD_BERRY
	jr z, .gold_berry
	cp HELD_SALAC_BERRY
	ret nz
	farcall SwitchTurn
	call ModernPinchEligible_Core
	jr nc, .done
	ld hl, wPlayerStatLevels + SPEED
	ldh a, [hBattleTurn]
	and a
	jr z, .salac_stat
	ld hl, wEnemyStatLevels + SPEED
.salac_stat
	ld a, [hl]
	cp 13
	jr z, .done
	farcall GetTrueUserAbility_b
	ld a, b
	cp RIPEN
	ld b, SPEED
	jr nz, .salac_raise
	ld b, $10 | SPEED
.salac_raise
	push bc
	call ModernBerryAnimUser_Core
	pop bc
	call ModernRaiseUserStat_Core
.done
	farcall SwitchTurn
	ret
.gold_berry
	farcall SwitchTurn
	farcall FoeUnnerveCheck_b
	ld a, b
	and a
	jr nz, .done
	ld d, 2
	call ModernUserHPAtFraction_Core
	jr nc, .done
	call ModernBerryAnimUser_Core
	ld d, 4
	farcall GetUserMaxHPFraction
	push bc
	farcall GetTrueUserAbility_b
	ld a, b
	pop bc
	cp RIPEN
	jr nz, .heal
	sla c
	rl b
.heal
	farcall AbilityRestoreUserHP
	call ModernConsumeUserItem_Core
	jr .done

ModernUserHPAtFraction_Core:
; d = denominator. Carry if living user's HP <= floor(max HP / d).
	farcall GetUserMaxHPFraction
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyMonHP
.got
	ld a, [hli]
	ld d, a
	ld e, [hl]
	or e
	jr z, .no
	ld a, b
	cp d
	jr c, .no
	jr nz, .yes
	ld a, c
	cp e
	jr c, .no
.yes
	scf
	ret
.no
	and a
	ret

ModernPinchEligible_Core:
	farcall FoeUnnerveCheck_b
	ld a, b
	and a
	jr nz, ModernUserHPAtFraction_Core.no
	farcall GetTrueUserAbility_b
	ld a, b
	ld d, 4
	cp GLUTTONY
	jr nz, ModernUserHPAtFraction_Core
	ld d, 2
	jr ModernUserHPAtFraction_Core

ModernCustapOrder_Core::
; b=0 neither, 1 player only, 2 enemy only, 3 both.
	ldh a, [hBattleTurn]
	push af
	xor a
	ldh [hBattleTurn], a
	call .check
	push bc
	ld a, 1
	ldh [hBattleTurn], a
	call .check
	ld a, b
	add a
	pop bc
	or b
	ld b, a
	pop af
	ldh [hBattleTurn], a
	ret
.check
	callfar GetUserItem
	ld a, b
	cp HELD_CUSTAP_BERRY
	jr nz, .no
	call ModernPinchEligible_Core
	jr nc, .no
	call ModernBerryAnimUser_Core
	call ModernConsumeUserItem_Core
	ld b, 1
	ret
.no
	ld b, 0
	ret

ModernMetronomeMove_Core::
; Called once per executed move script, never once per hit.
	; Releasing a charged move is the same use, not a second selection.
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_CHARGED, a
	ret nz
	ld hl, wPlayerMetronomeMove
	ld de, wPlayerMetronomeCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	inc hl
	inc de
.got
	push hl
	push de
	callfar GetUserItem
	ld a, b
	pop de
	pop hl
	cp HELD_METRONOME
	jr nz, .reset
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp [hl]
	jr nz, .new
	ld a, [de]
	cp 5
	ret nc
	inc a
	ld [de], a
	ret
.reset
	xor a
.new
	ld [hl], a
	xor a
	ld [de], a
	ret

ModernDamageItems_Core::
	push hl
	push de
	push bc
	callfar GetUserItem
	ld a, b
	cp HELD_PUNCHING_GLOVE
	jr z, .glove
	cp HELD_METRONOME
	jr nz, .done
	ld hl, wPlayerMetronomeCount
	ldh a, [hBattleTurn]
	and a
	jr z, .count
	inc hl
.count
	ld a, [hl]
	ld b, a
	add a
	add a
	add b ; count * 5
	add a
	add a ; count * 20
	add 100
	jr .boost
.glove
	farcall ModernPunchMoveCheck_Core
	jr nc, .done
	ld a, 110
.boost
	farcall_a DamagePercent
.done
	pop bc
	pop de
	pop hl
	ret

ModernGloveContact_Core::
; Carry if the current punch is rendered noncontact by Punching Glove.
	push hl
	push de
	push bc
	callfar GetUserItem
	ld a, b
	cp HELD_PUNCHING_GLOVE
	jr nz, .no
	farcall ModernPunchMoveCheck_Core
	jr .done
.no
	and a
.done
	pop bc
	pop de
	pop hl
	ret

ModernQuickPowder_Core::
	ld h, d
	ld l, e
; b = side, hl = effective Speed. Original Ditto identity, exactly as
; Metal Powder: the multiplier survives Transform (custom Gen II rule).
	push hl
	ldh a, [hBattleTurn]
	push af
	ld a, b
	ldh [hBattleTurn], a
	callfar GetUserItem
	ld a, b
	cp HELD_QUICK_POWDER
	jr nz, .no
	ldh a, [hBattleTurn]
	and a
	ld a, [wTempEnemyMonSpecies]
	jr nz, .species
	ld hl, wPartyMon1Species
	ld a, [wCurBattleMon]
	call GetPartyLocation
	ld a, [hl]
.species
	call GetPokemonIndexFromID
	ld a, l
	cp LOW(DITTO)
	jr nz, .no
	ld a, h
	cp HIGH(DITTO)
	jr nz, .no
	pop af
	ldh [hBattleTurn], a
	pop hl
	add hl, hl
	ret nc
	ld hl, $ffff
	ret
.no
	pop af
	ldh [hBattleTurn], a
	pop hl
	ret

ModernGogglesUser_Core::
	push hl
	push bc
	callfar GetUserItem
	ld a, b
	cp HELD_SAFETY_GOGGLES
	pop bc
	pop hl
	ret

ModernCloakOpp_Core::
	push hl
	push bc
	callfar GetOpponentItem
	ld a, b
	cp HELD_COVERT_CLOAK
	pop bc
	pop hl
	ret

ModernClearAmulet_Core::
	callfar GetOpponentItem
	ld a, b
	cp HELD_CLEAR_AMULET
	jr nz, .no
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	ld hl, ProtectedByText
	call StdBattleTextbox
	scf
	ret
.no
	and a
	ret

ModernScreenDuration_Core::
; Preserve the selected screen's pointer; return duration in a.
	push bc
	push hl
	callfar GetUserItem
	ld a, b
	cp HELD_LIGHT_CLAY
	ld a, 8
	jr z, .done
	ld a, 5
.done
	pop hl
	pop bc
	ret

ModernPowerHerb_Core::
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_SOLARBEAM
	jr nz, .item
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	ret z
.item
	callfar GetUserItem
	ld a, b
	cp HELD_POWER_HERB
	ret nz
	call ModernConsumeUserItem_Core
	ld b, charge_command
	farcall SkipToBattleCommand
	ret

ModernBlunderPolicy_Core::
; Only reached by the accuracy roll, never Protect/type/semi-invulnerability.
	callfar GetUserItem
	ld a, b
	cp HELD_BLUNDER_POLICY
	ret nz
	ld b, $10 | SPEED
	jp ModernRaiseUserStat_Core

ModernThroatSpray_Core::
	call ModernMoveSuppressesSecondary_Core
	ret c
	farcall UserHasFainted
	ret z
	callfar GetUserItem
	ld a, b
	cp HELD_THROAT_SPRAY
	ret nz
	farcall ModernSoundMoveCheck_Core
	ret nc
	ld a, [wAttackMissed]
	and a
	ret nz
	ld a, [wEffectFailed]
	and a
	ret nz
	ld hl, wPlayerStatLevels + SP_ATTACK
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyStatLevels + SP_ATTACK
.got
	ld a, [hl]
	cp 13
	ret z
	ld b, SP_ATTACK
	jp ModernRaiseUserStat_Core

ModernBlackSludge_Core::
	farcall UserHasFainted
	ret z
	callfar GetUserItem
	ld a, b
	cp HELD_BLACK_SLUDGE
	ret nz
	ld hl, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyMonType1
.got
	ld a, [hli]
	cp POISON
	jr z, .heal
	ld a, [hl]
	cp POISON
	jr z, .heal
	farcall GetTrueUserAbility_b
	ld a, b
	cp MAGIC_GUARD
	ret z
	ld d, 8
	farcall GetUserMaxHPFraction
	farcall SubtractHPFromUser
	ld hl, IsHurtText
	jp StdBattleTextbox
.heal
	farcall CheckUserFullHP
	ret z
	ld d, 16
	farcall GetUserMaxHPFraction
	farcall AbilityRestoreUserHP
	ld hl, RegainedHealthText
	jp StdBattleTextbox

ModernBigRoot_Core::
; bc = HP drained; user = recipient. floor(1.3 * bc), min 1.
	push hl
	push de
	push bc
	callfar GetUserItem
	ld a, b
	pop bc
	cp HELD_BIG_ROOT
	jr nz, .done
	xor a
	ldh [hMultiplicand], a
	ld a, b
	ldh [hMultiplicand + 1], a
	ld a, c
	ldh [hMultiplicand + 2], a
	ld a, 13
	ldh [hMultiplier], a
	call Multiply
	ld a, 10
	ldh [hDivisor], a
	ld b, 4
	call Divide
	ldh a, [hQuotient + 2]
	ld b, a
	ldh a, [hQuotient + 3]
	ld c, a
.done
	pop de
	pop hl
	ret

ModernRecordHit_Core::
; Called after actual direct HP damage, never Substitute damage.
	push hl
	push de
	push bc
	callfar GetOpponentItem
	ld a, b
	cp HELD_RED_CARD
	jr z, .mark
	cp HELD_EJECT_BUTTON
	jr nz, .done
.mark
	ld hl, wEnemyItemSwitchPending
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wPlayerItemSwitchPending
.got
	ld [hl], 1
.done
	pop bc
	pop de
	pop hl
	ret

ModernReactiveSwitch_Core::
; Run after all hits, or before a pivot command. b=1 if a switch happened.
	ld hl, wEnemyItemSwitchPending
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wPlayerItemSwitchPending
.got
	ld a, [hl]
	ld [hl], 0
	and a
	jp z, .no
	farcall OppHasFainted
	jp z, .no
	farcall UserHasFainted
	jp z, .no
	call ModernMoveSuppressesSecondary_Core
	jp c, .no
	callfar GetOpponentItem
	ld a, b
	cp HELD_EJECT_BUTTON
	jr z, .eject
	cp HELD_RED_CARD
	jp nz, .no
	; A wild attacker has no bench: Red Card makes it flee instead.
	ld a, [wBattleMode]
	dec a
	jr nz, .red_bench
	ldh a, [hBattleTurn]
	and a
	jr nz, .use_red
.red_bench
	call .can_switch_user
	jp z, .no
.use_red
	farcall SwitchTurn
	call ModernConsumeUserItem_Core
	farcall SwitchTurn
	; Suction Cups stops the switch, after the card is consumed.
	farcall GetTrueUserAbility_b
	ld a, b
	cp SUCTION_CUPS
	jp z, .no
	ld a, [wBattleMode]
	dec a
	jr nz, .red_trainer
	ldh a, [hBattleTurn]
	and a
	jr z, .red_trainer
	farcall SwitchTurn
	farcall BattleCommand_ForceSwitch.wild_force_flee
	farcall SwitchTurn
	ld b, 1
	ret
.red_trainer
	; Random forced switch uses the native phazing path. Its ability marker
	; allows either move order and prevents the incoming mon acting now.
	ldh a, [hBattleTurn]
	push af
	farcall SwitchTurn
	ld hl, wDisguiseBusted + 1
	set 6, [hl]
	farcall BattleCommand_ForceSwitch
	ld hl, wDisguiseBusted + 1
	res 6, [hl]
	pop af
	ldh [hBattleTurn], a
	ld a, BATTLE_VARS_MOVE
	jr .mark_action_spent
.eject
	farcall SwitchTurn
	call .can_switch_user
	jr z, .eject_no
	call ModernConsumeUserItem_Core
	; Eject Button allows the holder to choose, using the normal pivot UI.
	ldh a, [hBattleTurn]
	push af
	xor a
	ld [wAttackMissed], a
	farcall BattleUTurn_Core.SwitchUser
	pop af
	ldh [hBattleTurn], a
	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	ld [hl], $ff
	farcall SwitchTurn
	ld b, 1
	ret
.mark_action_spent
	; Mark the replaced side as having spent its old mon's action.
	call GetBattleVarAddr
	ld [hl], $ff
	ld b, 1
	ret
.eject_no
	farcall SwitchTurn
.no
	ld b, 0
	ret
.can_switch_user
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy_bench
	farcall CheckAnyOtherAlivePartyMons
	ret
.enemy_bench
	ld a, [wBattleMode]
	cp 2
	jr nz, .no_bench
	farcall CheckAnyOtherAliveEnemyMons
	ret
.no_bench
	xor a
	ret

ModernBerryAnimUser_Core::
	farcall SwitchTurn
	callfar ItemRecoveryAnim
	farcall SwitchTurn
	ret

ModernMoveSuppressesSecondary_Core:
; Sheer Force removes these move-end item events for boosted moves, just
; as it removes Pickpocket and Life Orb recoil in the existing engine.
	farcall GetTrueUserAbility_b
	ld a, b
	cp SHEER_FORCE
	jr nz, .no
	farcall CurrentMoveHasSheerForceEffect
	ret
.no
	and a
	ret

ModernHPItemEligibleOpp_Core::
; Eligibility only: no animation, mutation, consumption or extra RNG.
	callfar GetOpponentItem
	ld a, b
	cp HELD_WHITE_HERB
	jr z, .herb
	cp HELD_GOLD_BERRY
	jr z, .gold_berry
	cp HELD_SALAC_BERRY
	jr nz, .no
	farcall SwitchTurn
	call ModernPinchEligible_Core
	farcall SwitchTurn
	ret
.gold_berry
	farcall SwitchTurn
	farcall FoeUnnerveCheck_b
	ld a, b
	and a
	jr nz, .unnerved
	ld d, 2
	call ModernUserHPAtFraction_Core
	farcall SwitchTurn
	ret
.unnerved
	farcall SwitchTurn
.no
	and a
	ret
.herb
	ld hl, wEnemyStatLevels
	ldh a, [hBattleTurn]
	and a
	jr z, .levels
	ld hl, wPlayerStatLevels
.levels
	ld b, 7
.loop
	ld a, [hli]
	cp 7
	ret c
	dec b
	jr nz, .loop
	and a
	ret

ModernCudChewBerry_Core::
; b is Gold Berry or Salac's held effect. Replay Eat without a held-item
; threshold, Unnerve check, consumption, or changes to a newly held item.
	ld a, b
	cp HELD_SALAC_BERRY
	jr z, .salac
	farcall CheckUserFullHP
	ret z
	call .present
	ld d, 4
	farcall GetUserMaxHPFraction
	farcall AbilityRestoreUserHP
	ld hl, RegainedHealthText
	jp StdBattleTextbox
.salac
	ld hl, wPlayerStatLevels + SPEED
	ldh a, [hBattleTurn]
	and a
	jr z, .got
	ld hl, wEnemyStatLevels + SPEED
.got
	ld a, [hl]
	cp 13
	ret z
	call .present
	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld b, SPEED
	farcall AbilityRaiseStat
	ret
.present
	push de
	farcall ShowAbilityBannerBrief
	callfar EmptyBattleTextbox
	pop de
	xor a
	ld [wNumHits], a
	ld b, e ; consumed Berry, even when Cud Chew currently holds nothing
	call BerryAnimationParam_Core
	ld a, b
	ld [wBattleAnimParam], a
	ld a, LOW(ANIM_HELD_ITEM_TRIGGER)
	ld [wFXAnimID], a
	ld a, HIGH(ANIM_HELD_ITEM_TRIGGER)
	ld [wFXAnimID + 1], a
	predef PlayBattleAnim
	ret

BerryAnimationParam_Core::
; b = runtime item. Return animation color parameter in b. Unknown berries
; retain the existing brown palette; non-Berries use parameter 0 upstream.
	ld a, b
	call GetItemIndexFromID
	ld a, h
	and a
	jr nz, .default
	ld c, l
	ld hl, .colors
.loop
	ld a, [hli]
	cp $ff
	jr z, .default
	cp c
	jr z, .found
	inc hl
	jr .loop
.found
	ld b, [hl]
	ret
.default
	ld b, 7
	ret
.colors
	db BERRY,        1 ; blue
	db GOLD_BERRY,   2 ; yellow/gold
	db PSNCUREBERRY, 3 ; pink
	db PRZCUREBERRY, 4 ; red
	db BURNT_BERRY,  8 ; yellow-green (Aspear; cures freezing)
	db ICE_BERRY,    9 ; light blue (Rawst; cures burns)
	db BITTER_BERRY, 3 ; pink
	db MINT_BERRY,   1 ; blue (Chesto; cures sleep)
	db MIRACLEBERRY, 5 ; green
	db MYSTERYBERRY, 4 ; red
	db $ff
