; New move effect cores, ported/adapted from polishedcrystal.
; Lives in the Battle Effect Overflow bank; called via callfar stubs
; from the Effect Commands bank (same conventions as BattleParalyze_Core).

BattleConditionalBoost_Core:
; Damage modifiers keyed by move effect:
;  Acrobatics: x2 if the user holds no item
;  Facade:     x2 if the user is burned, poisoned or paralyzed
;  Hex:        x2 if the target has a status condition
;  Avalanche:  x2 if the target moved first and hit the user this turn
;  Knock Off:  x1.5 if the target holds a removable item
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ACROBATICS
	jr z, .acrobatics
	cp EFFECT_FACADE
	jr z, .facade
	cp EFFECT_HEX
	jr z, .hex
	cp EFFECT_AVALANCHE
	jr z, .avalanche
	cp EFFECT_KNOCK_OFF
	ret nz

; Knock Off: x1.5 if the target has an item to lose
	push bc
	push de
	push hl
	callfar GetOpponentItem
	ld a, [hl]
	pop hl
	pop de
	pop bc
	and a
	ret z
	; damage += damage / 2
	push bc
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
	srl b
	rr c
	ld a, [wCurDamage + 1]
	add c
	ld [wCurDamage + 1], a
	ld a, [wCurDamage]
	adc b
	ld [wCurDamage], a
	pop bc
	ret nc
	ld a, $ff
	ld [wCurDamage], a
	ld [wCurDamage + 1], a
	ret

.acrobatics
	push hl
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonItem
	jr z, .got_item
	ld hl, wEnemyMonItem
.got_item
	ld a, [hl]
	pop hl
	and a
	ret nz
	jr .double

.facade
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and 1 << BRN | 1 << PSN | 1 << PAR
	ret z
	jr .double

.hex
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	ret z
	jr .double

.avalanche
	; Opponent must have gone first this turn...
	callfar CheckOpponentWentFirst
	ret z
	; ...and used a damaging move.
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE_OPP
	call GetBattleVar
	and a
	ret z
	; fallthrough
.double
	push hl
	ld hl, wCurDamage + 1
	sla [hl]
	dec hl
	rl [hl]
	pop hl
	ret nc
	ld a, $ff
	ld [wCurDamage], a
	ld [wCurDamage + 1], a
	ret

BattleGyroBall_Core:
; Set move power (d) = 25 * (target speed / user speed), min 1, max 150.
; Must preserve b, c (attack/defense) and e (level).
	push bc
	push de
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonSpeed
	ld de, wEnemyMonSpeed
	jr z, .got_speeds
	ld hl, wEnemyMonSpeed
	ld de, wBattleMonSpeed
.got_speeds
	; user speed -> bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	; target speed -> de
	ld a, [de]
	ld h, a
	inc de
	ld a, [de]
	ld e, a
	ld d, h
	; User speed in bc, target speed in de
	ld a, b
	or c
	ld a, 1
	jr z, .got_power

	; We can't divide by numbers >255, so scale both speeds down
.scaledown_loop
	ld a, b
	and a
	jr z, .scaledown_ok
	srl b
	rr c
	srl d
	rr e
	jr .scaledown_loop
.scaledown_ok
	; Base Power = 25 * (target speed / user speed), capped at 150
	xor a
	ldh [hMultiplicand + 0], a
	ld a, d
	ldh [hMultiplicand + 1], a
	ld a, e
	ldh [hMultiplicand + 2], a
	ld a, 25
	ldh [hMultiplier], a
	call Multiply

	ld a, c
	and a
	ld a, 150
	jr z, .got_power ; user speed scaled to 0: treat as max
	ldh [hDivisor], a
	ld b, 4
	call Divide

	; Cap between 1 and 150
	ldh a, [hMultiplicand + 0]
	ld b, a
	ldh a, [hMultiplicand + 1]
	or b
	jr nz, .max_power
	ldh a, [hMultiplicand + 2]
	and a
	jr nz, .nonzero_power
	ld a, 1
	jr .got_power
.nonzero_power
	cp 151
	jr c, .got_power
.max_power
	ld a, 150
.got_power
	pop de
	ld d, a
	pop bc
	ret

BattleKnockOff_Core:
; Remove the target's held item.
	ld a, [wAttackMissed]
	and a
	ret nz
	callfar CheckSubstituteOpp
	ret nz
	callfar GetOpponentItem
	ld a, [hl]
	and a
	ret z
	; Can't knock off mail
	ld [wNamedObjectIndexBuffer], a
	push hl
	push de
	ld d, a
	farcall ItemIsMail
	pop de
	pop hl
	ret c
	xor a
	ld [hl], a
	; Remove it from the target's party struct too
	ldh a, [hBattleTurn]
	and a
	jr z, .target_is_enemy
	ld a, MON_ITEM
	call BattlePartyAttr
	jr .remove
.target_is_enemy
	ld a, MON_ITEM
	call OTPartyAttr
.remove
	xor a
	ld [hl], a
	call GetItemName
	ld hl, KnockedOffItemText
	jp StdBattleTextbox

BattleRoost_Core:
; Removes the user's Flying type until end of turn.
; Type slot is marked with CURSE_T (???) and restored in HandleRoost.
	; Do nothing if HP is full (the heal command will fail).
	push hl
	push de
	push bc
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonHP
	jr z, .got_hp
	ld hl, wEnemyMonHP
.got_hp
	; carry on: compare current HP with max HP (hl -> HP, HP+1, MaxHP, MaxHP+1)
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	cp d
	jr nz, .not_full
	ld a, [hl]
	cp e
	jr z, .done ; full HP: nothing to do
.not_full
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonType1
	jr z, .got_types
	ld hl, wEnemyMonType1
.got_types
	ld a, [hli]
	cp FLYING
	jr nz, .check_second
	ld a, [hld]
	cp FLYING
	jr z, .pure_flying
	; Flying / other: mark the first slot
	ld [hl], CURSE_T
	jr .set_substatus
.check_second
	ld a, [hl]
	cp FLYING
	jr nz, .done ; no Flying type: types don't change
	ld [hl], CURSE_T
	jr .set_substatus
.pure_flying
	; Pure Flying becomes pure Normal
	ld a, NORMAL
	ld [hli], a
	ld [hl], a
.set_substatus
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	set SUBSTATUS_ROOST, [hl]
.done
	pop bc
	pop de
	pop hl
	ret

BattleSkillSwap_Core:
; Swap abilities with the target.
	ld a, [wAttackMissed]
	and a
	jr nz, .failed
	callfar AnimateCurrentMove
	ld a, [wPlayerAbility]
	ld b, a
	ld a, [wEnemyAbility]
	ld [wPlayerAbility], a
	ld a, b
	ld [wEnemyAbility], a
	ld hl, SwappedAbilitiesText
	call StdBattleTextbox
	; Re-run switch-in abilities: user first, then the opponent
	farcall RunEntryAbilities
	farcall SwitchTurn
	farcall RunEntryAbilities
	farcall SwitchTurn
	ret

.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

BattleTrick_Core:
; Swap held items with the target.
	ld a, [wAttackMissed]
	and a
	jr nz, .failed
	callfar CheckSubstituteOpp
	jr nz, .failed

	; A wild enemy can't use Trick
	ldh a, [hBattleTurn]
	and a
	jr z, .user_is_player
	ld a, [wBattleMode]
	dec a ; WILDMON?
	jr z, .failed
.user_is_player

	; Neither item may be mail
	ld a, [wBattleMonItem]
	ld d, a
	and a
	jr z, .player_item_ok
	farcall ItemIsMail
	jr c, .failed
.player_item_ok
	ld a, [wEnemyMonItem]
	ld d, a
	and a
	jr z, .enemy_item_ok
	farcall ItemIsMail
	jr c, .failed
.enemy_item_ok

	; Fails if neither battler holds an item
	ld a, [wBattleMonItem]
	ld b, a
	ld a, [wEnemyMonItem]
	or b
	jr z, .failed

	callfar AnimateCurrentMove

	; Swap the battle copies
	ld a, [wBattleMonItem]
	ld b, a
	ld a, [wEnemyMonItem]
	ld [wBattleMonItem], a
	ld a, b
	ld [wEnemyMonItem], a

	; Update the party structs
	ld a, MON_ITEM
	call BattlePartyAttr
	ld a, [wBattleMonItem]
	ld [hl], a
	ld a, [wBattleMode]
	dec a ; WILDMON?
	jr z, .skip_ot_party
	ld a, MON_ITEM
	call OTPartyAttr
	ld a, [wEnemyMonItem]
	ld [hl], a
.skip_ot_party

	ld hl, SwappedItemsText
	jp StdBattleTextbox

.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

BattleToxicSpikes_Core:
; Lay a layer of toxic spikes on the opponent's side (max 2).
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyScreens
	jr z, .got_screens
	ld hl, wPlayerScreens
.got_screens
	bit SCREENS_TOXIC_SPIKES_1, [hl]
	jr z, .first_layer
	bit SCREENS_TOXIC_SPIKES_2, [hl]
	jr nz, .failed
	set SCREENS_TOXIC_SPIKES_2, [hl]
	jr .done
.first_layer
	set SCREENS_TOXIC_SPIKES_1, [hl]
.done
	callfar AnimateCurrentMove
	ld hl, ToxicSpikesText
	jp StdBattleTextbox

.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

BattleTrickRoom_Core:
; Invert speed order for 5 turns; using it again ends it early.
	callfar AnimateCurrentMove
	ld hl, wTrickRoomTimer
	ld a, [hl]
	and a
	jr z, .start
	ld [hl], 0
	ld hl, TrickRoomEndedText
	jp StdBattleTextbox
.start
	ld [hl], 5
	ld hl, TrickRoomText
	jp StdBattleTextbox

BattleBurn_Core:
; Burn the target (Will-O-Wisp). Modeled on BattleParalyze_Core.
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	bit BRN, a
	jp nz, .burned
	ld a, [wTypeModifier]
	and $7f
	jp z, .didnt_affect
	; Fire-types can't be burned
	push hl
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyMonType1
	jr z, .got_target_types
	ld hl, wBattleMonType1
.got_target_types
	ld a, [hli]
	cp FIRE
	jr z, .fire_type
	ld a, [hl]
	cp FIRE
	jr z, .fire_type
	pop hl
	callfar GetOpponentItem
	ld a, b
	cp HELD_PREVENT_BURN
	jr nz, .no_item_protection
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	callfar AnimateFailedMove
	ld hl, ProtectedByText
	jp StdBattleTextbox

.fire_type
	pop hl
	jp .didnt_affect

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
	farcall AbilityPreventsBurn
	jp c, .failed
	ld c, 30
	call DelayFrames
	callfar AnimateCurrentMove
	ld a, $1
	ldh [hBGMapMode], a
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set BRN, [hl]
	call UpdateOpponentInParty
	farcall ApplyBrnEffectOnAttack
	call UpdateBattleHuds
	ld hl, WasBurnedText
	call StdBattleTextbox
	farcall RunSynchronizeBrn
	farcall UseHeldStatusHealingItem
	ret

.burned
	callfar AnimateFailedMove
	ld hl, AlreadyBurnedText
	jp StdBattleTextbox

.didnt_affect
	callfar AnimateFailedMove
	ld hl, DoesntAffectText
	jp StdBattleTextbox

.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

HandleTrickRoom:
; Tick down the Trick Room timer at the end of each turn.
	ld hl, wTrickRoomTimer
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	ld hl, TrickRoomEndedText
	jp StdBattleTextbox

HandleRoost:
; Restore the Flying type removed by Roost at the end of the turn.
	ld hl, wPlayerSubStatus4
	bit SUBSTATUS_ROOST, [hl]
	jr z, .enemy
	res SUBSTATUS_ROOST, [hl]
	ld hl, wBattleMonType1
	call .restore
.enemy
	ld hl, wEnemySubStatus4
	bit SUBSTATUS_ROOST, [hl]
	ret z
	res SUBSTATUS_ROOST, [hl]
	ld hl, wEnemyMonType1
.restore
	ld a, [hl]
	cp CURSE_T
	jr z, .set_flying
	inc hl
	ld a, [hl]
	cp CURSE_T
	jr z, .set_flying
	; No marker: the user was pure Flying and became pure Normal
	ld a, [hld]
	cp NORMAL
	ret nz
	ld a, [hl]
	cp NORMAL
	ret nz
	ld a, FLYING
	ld [hli], a
	ld [hl], a
	ret
.set_flying
	ld [hl], FLYING
	ret

ToxicSpikesPoison:
; Poison a grounded mon switching in if toxic spikes lie on its side.
; Like SpikesDamage, the victim is the current turn holder.
	ld hl, wPlayerScreens
	ld de, wBattleMonType
	ldh a, [hBattleTurn]
	and a
	jr z, .got_side
	ld hl, wEnemyScreens
	ld de, wEnemyMonType
.got_side
	ld a, [hl]
	and SCREENS_TOXIC_SPIKES_MASK
	ret z

	; Flying-types aren't grounded
	ld a, [de]
	cp FLYING
	ret z
	ld b, a
	inc de
	ld a, [de]
	cp FLYING
	ret z

	; Grounded Poison-types absorb the toxic spikes (even Poison/Steel)
	cp POISON
	jr z, .absorb
	ld a, b
	cp POISON
	jr z, .absorb

	; Steel-types can't be poisoned
	ld a, [de]
	cp STEEL
	ret z
	ld a, b
	cp STEEL
	ret z

	; Levitate and poison-preventing abilities protect their owner
	push hl
	farcall GetTrueUserAbility
	pop hl
	cp LEVITATE
	ret z
	cp IMMUNITY
	ret z
	cp PASTEL_VEIL
	ret z

	; Can't poison a mon that already has a status
	push hl
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	ld a, [hl]
	pop hl
	and a
	ret nz

	; One layer poisons; two layers badly poison
	ld a, [hl]
	and SCREENS_TOXIC_SPIKES_MASK
	cp SCREENS_TOXIC_SPIKES_MASK
	push af
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	set PSN, [hl]
	pop af
	jr nz, .not_toxic
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
	call .poison_anim
	call RefreshBattleHuds
	ld hl, UserBadlyPoisonedText
	jp StdBattleTextbox
.not_toxic
	call UpdateUserInParty
	call .poison_anim
	call RefreshBattleHuds
	ld hl, UserWasPoisonedText
	jp StdBattleTextbox

.absorb
	ld a, [hl]
	and $ff ^ SCREENS_TOXIC_SPIKES_MASK
	ld [hl], a
	ret

.poison_anim
; Play the skull-and-crossbones poison animation on the victim. The victim
; is the current turn holder, so (unlike AbilityStatusAnim) no SwitchTurn is
; needed - PlayBattleAnim renders it on the mon that just switched in.
	ld de, ANIM_PSN
	ld a, e
	ld [wFXAnimID], a
	ld a, d
	ld [wFXAnimID + 1], a
	xor a
	ld [wNumHits], a
	farcall PlayBattleAnim
	ret
