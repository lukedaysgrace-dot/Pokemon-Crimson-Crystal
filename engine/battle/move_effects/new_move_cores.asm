; New move effect cores, ported/adapted from polishedcrystal.
; Lives in the Battle Effect Overflow bank; called via callfar stubs
; from the Effect Commands bank (same conventions as BattleParalyze_Core).

AIPredictVariableMoveCategory_Core:
; Shell Side Arm chooses its category before damage stats are loaded. Reuse the
; live selector, but preserve the AI's six move-score bytes that it uses as
; scratch space.
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_SHELL_SIDE_ARM
	ret nz
	ld hl, wBuffer1
rept 6
	ld a, [hli]
	push af
endr
	call BattleShellSideArm_Core
	ld hl, wBuffer6
rept 5
	pop af
	ld [hld], a
endr
	pop af
	ld [hl], a
	ret

AIPredictVariableMovePower_Core:
; Called after EnemyAttackDamage has loaded b/c/d/e. These live power helpers
; deliberately preserve b, c and e, so the normal damage formula can follow.
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_GYRO_BALL
	jp z, BattleGyroBall_Core
	cp EFFECT_RAGE_FIST
	jp z, BattleRageFistPower_Core
	ret

AIPredictVariableMoveDamage_Core:
; Apply deterministic post-formula modifiers used by move scripts. Keep this
; allowlist explicit: random and multi-hit effects need expected-value logic,
; not execution of their stateful live commands during AI scoring. Avalanche
; is also omitted because move selection happens before this turn's order and
; hit state exist; its live helper would read stale previous-turn state.
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_ACROBATICS
	jr z, .conditional
	cp EFFECT_FACADE
	jr z, .conditional
	cp EFFECT_HEX
	jr z, .conditional
	cp EFFECT_KNOCK_OFF
	jr z, .conditional
	cp EFFECT_VENOSHOCK
	jr z, .poisoned
	cp EFFECT_BARB_BARRAGE
	jr z, .poisoned
	cp EFFECT_GUST
	jr z, .flying
	cp EFFECT_TWISTER
	jr z, .flying
	cp EFFECT_EARTHQUAKE
	jr z, .underground
	cp EFFECT_STOMP
	ret nz
	jp BattleDoubleMinimizeDamage_Core
.conditional
	jp BattleConditionalBoost_Core
.poisoned
	jp BattleVenoshockDouble_Core
.flying
	jp BattleDoubleFlyingDamage_Core
.underground
	jp BattleDoubleUndergroundDamage_Core

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
	and a
	jr z, .no_knock_off_item
	ld d, a
	farcall ItemIsMail
	jr c, .no_knock_off_item
	ld a, 1
	jr .got_knock_off_item
.no_knock_off_item
	xor a
.got_knock_off_item
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
; Set move power (d) = floor(25 * target speed / user speed) + 1,
; capped at 150.
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
	; Base Power = floor(25 * target speed / user speed) + 1, capped at 150
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

	; Add the formula's final +1 and cap at 150.
	ldh a, [hMultiplicand + 0]
	ld b, a
	ldh a, [hMultiplicand + 1]
	or b
	jr nz, .max_power
	ldh a, [hMultiplicand + 2]
	inc a
	jr z, .max_power
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
	; Sticky Hold keeps the victim's item on (Mold Breaker pierces)
	push hl
	farcall GetOppIgnorableAbility_b
	ld a, b
	cp STICKY_HOLD
	pop hl
	jr z, .sticky_hold
	ld a, [hl]
	; Can't knock off mail
	; Keep the item id on the stack across ItemIsMail and the party-struct
	; lookup. wNamedObjectIndexBuffer is shared scratch and either call may
	; overwrite it before GetItemName consumes it.
	push af
	push hl
	push de
	ld d, a
	farcall ItemIsMail
	pop de
	pop hl
	jr c, .mail
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
	; the victim lost its item (for Unburden)
	ldh a, [hBattleTurn]
	and a
	ld c, 1
	jr z, .got_side
	dec c
.got_side
	farcall MarkSideLostItem_Core
	pop af
	ld b, a
	farcall AbilityBufferItemName_b
	ld hl, KnockedOffItemText
	jp StdBattleTextbox

.mail
	pop af
	ret

.sticky_hold
	farcall StickyHoldAnnounce_Core
	ret

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
	; Abilities marked NO_SWAP (including no ability, Disguise and
	; Neutralizing Gas) cannot be exchanged. Swapping identical abilities
	; must also fail instead of re-triggering both entry effects for free.
	ld a, [wPlayerAbility]
	ld b, a
	farcall GetAbilityFlags_b
	ld a, b
	and ABILFLAG_NO_SWAP
	jr nz, .failed
	ld a, [wEnemyAbility]
	ld b, a
	farcall GetAbilityFlags_b
	ld a, b
	and ABILFLAG_NO_SWAP
	jr nz, .failed
	ld a, [wPlayerAbility]
	ld b, a
	ld a, [wEnemyAbility]
	cp b
	jr z, .failed
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
	jp nz, .failed
	callfar CheckSubstituteOpp
	jp nz, .failed
	; Sticky Hold prevents the target's item from being swapped away. As with
	; Thief and Knock Off, Mold Breaker may ignore it.
	farcall GetOppIgnorableAbility_b
	ld a, b
	cp STICKY_HOLD
	jp z, .failed

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

	; If Trick left either holder empty, arm that side's Unburden state.
	ld a, [wBattleMonItem]
	and a
	jr nz, .player_still_holds
	ld c, 0
	farcall MarkSideLostItem_Core
.player_still_holds
	ld a, [wEnemyMonItem]
	and a
	jr nz, .enemy_still_holds
	ld c, 1
	farcall MarkSideLostItem_Core
.enemy_still_holds

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
	; Stealth Rock and Sticky Web share this switch-in hook (same bank).
	call StealthRockEntryDamage
	; Stealth Rock may have knocked out the switch-in. Toxic Spikes must not
	; status a fainted mon or activate/consume its held status-curing item.
	farcall UserHasFainted
	ret z
	call .toxic_spikes
	; the poison cannot faint the switch-in, so Sticky Web can run directly
	jp StickyWebEntry

.toxic_spikes

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

	; Levitate and an AIR BALLOON keep the holder off the ground.
	; Check both before Poison-type absorption: an ungrounded Poison-type
	; must not soak up the spikes either. Keep the effective ability in c
	; for the poison-prevention checks below.
	push hl
	push de
	push bc
	farcall GetTrueUserAbility_b
	ld a, b
	pop bc
	pop de
	pop hl
	cp LEVITATE
	ret z
	ld c, a

	push hl
	push de
	push bc
	callfar GetUserItem
	ld a, b
	pop bc
	pop de
	pop hl
	cp HELD_AIR_BALLOON
	ret z
	ld a, [de] ; restore type2 for the checks below

	; Grounded Poison-types absorb the toxic spikes (even Poison/Steel)
	cp POISON
	jp z, .absorb
	ld a, b
	cp POISON
	jp z, .absorb

	; Steel-types can't be poisoned
	ld a, [de]
	cp STEEL
	ret z
	ld a, b
	cp STEEL
	ret z

	; Poison-preventing abilities protect their owner.
	ld a, c
	cp IMMUNITY
	ret z
	cp PASTEL_VEIL
	ret z
	cp LEAF_GUARD
	jr nz, .status_check
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	ret z

	; Can't poison a mon that already has a status
.status_check
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
	call ToxicMarkUser_Core ; same bank (included from effect_commands_core)
	call UpdateUserInParty
	call .poison_anim
	call RefreshBattleHuds
	ld hl, UserBadlyPoisonedText
	call StdBattleTextbox
	jr .held_cure
.not_toxic
	call UpdateUserInParty
	call .poison_anim
	call RefreshBattleHuds
	ld hl, UserWasPoisonedText
	call StdBattleTextbox
	; Held status-curing items operate on the turn holder's opponent.
	; Toxic Spikes poisons the turn holder during entry, so reverse the
	; perspective around the shared item handler.
.held_cure
	farcall SwitchTurn
	farcall UseHeldStatusHealingItem
	farcall SwitchTurn
	ret

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

; ==== Modern status/hazard move pack (2026-08) ============================
; Torment, Taunt, Yawn, Wish, Sticky Web, multi-layer Spikes.
; All bodies live in this bank (Battle Effect Overflow); Battle Core and
; Effect Commands only hold farcall stubs.

BattleTorment_Core:
; Target can't use the same move twice in a row until it leaves the field.
	ld a, [wAttackMissed]
	and a
	jr nz, .failed
	farcall CheckSubstituteOpp_Core
	jr nz, .failed
	ld a, BATTLE_VARS_SUBSTATUS2_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_TORMENTED, [hl]
	jr nz, .failed
	set SUBSTATUS_TORMENTED, [hl]
	callfar AnimateCurrentMove
	call SwitchTurnForOppText
	ld hl, BattleText_UserSubjectedToTorment
	call StdBattleTextbox
	jp SwitchTurnForOppText
.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

BattleTaunt_Core:
; Target can't use status moves for 3 turns (counter 4: decremented at the
; end of the Taunt turn and then once per taunted turn, like Encore).
	ld a, [wAttackMissed]
	and a
	jr nz, .failed
	farcall CheckSubstituteOpp_Core
	jr nz, .failed
	; canon Gen 6+: Oblivious blocks Taunt
	farcall GetOpponentIgnorableAbility_b
	ld a, b
	cp OBLIVIOUS
	jr z, .failed
	call GetOppTauntCountAddr
	ld a, [hl]
	and a
	jr nz, .failed
	ld [hl], 4
	callfar AnimateCurrentMove
	call SwitchTurnForOppText
	ld hl, BattleText_UserFellForTaunt
	call StdBattleTextbox
	jp SwitchTurnForOppText
.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

GetOppTauntCountAddr:
; hl = opponent's taunt counter
	ld hl, wEnemyTauntCount
	ldh a, [hBattleTurn]
	and a
	ret z
	ld hl, wPlayerTauntCount
	ret

SwitchTurnForOppText:
; Battle texts address the turn holder as <USER>; flip the turn so a
; message about the TARGET can use a <USER> string, then flip it back.
	ldh a, [hBattleTurn]
	xor 1
	ldh [hBattleTurn], a
	ret

BattleYawn_Core:
; The target falls asleep at the end of the next turn.
	ld a, [wAttackMissed]
	and a
	jr nz, .failed
	farcall CheckSubstituteOpp_Core
	jr nz, .failed
	; fails on a mon that already has a status
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	jr nz, .failed
	; or is already drowsy
	call GetOppYawnCountAddr
	ld a, [hl]
	and a
	jr nz, .failed
	; Safeguard and sleep-preventing abilities stop the drowsiness up front
	farcall SafeCheckSafeguard_Core
	jr nz, .failed
	farcall AbilityPreventsSleep
	jr c, .failed
	call GetOppYawnCountAddr
	ld [hl], 2
	callfar AnimateCurrentMove
	call SwitchTurnForOppText
	ld hl, BattleText_UserGrewDrowsy
	call StdBattleTextbox
	jp SwitchTurnForOppText
.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

GetOppYawnCountAddr:
; hl = opponent's yawn countdown
	ld hl, wEnemyYawnCount
	ldh a, [hBattleTurn]
	and a
	ret z
	ld hl, wPlayerYawnCount
	ret

BattleWish_Core:
; Heal this side's active slot at the end of the NEXT turn for half the
; user's max HP (recorded now - that is the point of the move).
	ld hl, wPlayerWishCount
	ld de, wPlayerWishHP
	ld bc, wBattleMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_side
	ld hl, wEnemyWishCount
	ld de, wEnemyWishHP
	ld bc, wEnemyMonMaxHP
.got_side
	ld a, [hl]
	and a
	jr nz, .failed ; a Wish is already pending on this side
	ld [hl], 2
	; store maxhp/2 (min 1)
	ld a, [bc]
	ld h, a
	inc bc
	ld a, [bc]
	ld l, a
	srl h
	rr l
	ld a, h
	or l
	jr nz, .nonzero
	inc l
.nonzero
	ld a, h
	ld [de], a
	inc de
	ld a, l
	ld [de], a
	callfar AnimateCurrentMove
	ld hl, BattleText_UserMadeAWish
	jp StdBattleTextbox
.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

BattleStickyWeb_Core:
; Lay a sticky web on the opponent's side of the field.
	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyScreens
	jr z, .got_screens
	ld hl, wPlayerScreens
.got_screens
	bit SCREENS_STICKY_WEB, [hl]
	jr nz, .failed
	set SCREENS_STICKY_WEB, [hl]
	callfar AnimateCurrentMove
	ld hl, BattleText_StickyWebSpread
	jp StdBattleTextbox
.failed
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox

StickyWebEntry:
; Switch-in hook (turn holder = the entering mon): grounded mons get their
; Speed lowered one stage by a web on their side.
	ld hl, wPlayerScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .got_side
	ld hl, wEnemyScreens
.got_side
	bit SCREENS_STICKY_WEB, [hl]
	ret z
	farcall UserHasFainted
	ret z
	call CheckSpikesUngrounded_Core
	ret c
	ld hl, BattleText_CaughtInStickyWeb
	call StdBattleTextbox
	; lower the ENTERING mon's Speed: the stat-drop machinery targets the
	; turn holder's opponent (like Intimidate), so flip the turn around it
	call SwitchTurnForOppText
	ld b, SPEED
	callfar AbilityStatDown
	jp SwitchTurnForOppText

SpikesLayerDamage_Core:
; bc = entry damage for the turn holder from the spikes layers on its
; side: 1/8 max HP at one layer, 1/6 at two, 1/4 at three.
	ld hl, wPlayerSpikesLayers
	ldh a, [hBattleTurn]
	and a
	jr z, .got_layers
	ld hl, wEnemySpikesLayers
.got_layers
	ld a, [hl]
	cp 2
	jr c, .one_layer
	jr z, .two_layers
	farcall GetQuarterMaxHP
	ret
.one_layer
	farcall GetEighthMaxHP
	ret
.two_layers
	; 1/6 = (max HP / 2) / 3
	farcall GetHalfMaxHP
	ld h, b
	ld l, c
	ld bc, 0
.div3
	ld a, h
	and a
	jr nz, .big
	ld a, l
	cp 3
	jr c, .done_div
.big
	ld de, 3
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	inc bc
	jr .div3
.done_div
	ld a, b
	or c
	ret nz
	inc c ; minimum 1
	ret

HandleNewEndTurnEffects_Core:
; End-of-turn processing for Wish, Taunt and Yawn, in that order.
; Runs both sides, player first (link battles resolve rarely enough on
; these moves that strict serial ordering is not worth the bytes).
	call .wish_player
	call .wish_enemy
	call .taunt_player
	call .taunt_enemy
	call .yawn_player
	jp .yawn_enemy

.wish_player
	ld hl, wPlayerWishCount
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	; heal the player's active slot by the stored amount
	; (RestoreHP heals the PLAYER when hBattleTurn is nonzero)
	ld a, 1
	ldh [hBattleTurn], a
	ld a, [wPlayerWishHP]
	ld b, a
	ld a, [wPlayerWishHP + 1]
	ld c, a
	farcall RestoreHP
	xor a
	ldh [hBattleTurn], a
	ld hl, BattleText_WishCameTrue
	jp StdBattleTextbox

.wish_enemy
	ld hl, wEnemyWishCount
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	xor a
	ldh [hBattleTurn], a
	ld a, [wEnemyWishHP]
	ld b, a
	ld a, [wEnemyWishHP + 1]
	ld c, a
	farcall RestoreHP
	ld a, 1
	ldh [hBattleTurn], a
	ld hl, BattleText_WishCameTrue
	call StdBattleTextbox
	xor a
	ldh [hBattleTurn], a
	ret

.taunt_player
	ld hl, wPlayerTauntCount
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	xor a
	ldh [hBattleTurn], a
	ld hl, BattleText_ShookOffTheTaunt
	jp StdBattleTextbox

.taunt_enemy
	ld hl, wEnemyTauntCount
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	ld a, 1
	ldh [hBattleTurn], a
	ld hl, BattleText_ShookOffTheTaunt
	call StdBattleTextbox
	xor a
	ldh [hBattleTurn], a
	ret

.yawn_player
	ld hl, wPlayerYawnCount
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	; the player mon falls asleep: run from the ENEMY's perspective so the
	; opponent-relative sleep helpers apply to the player mon
	ld a, 1
	ldh [hBattleTurn], a
	call .yawn_apply
	xor a
	ldh [hBattleTurn], a
	ret

.yawn_enemy
	ld hl, wEnemyYawnCount
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	xor a
	ldh [hBattleTurn], a
	; fallthrough

.yawn_apply
; hBattleTurn holder = the awake side; its opponent falls asleep.
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	ld a, [hl]
	and a
	ret nz ; got a status in the meantime
	push hl
	farcall SafeCheckSafeguard_Core
	pop hl
	ret nz
	push hl
	farcall AbilityPreventsSleep
	pop hl
	ret c
.sleep_roll
	; modern 1-3 turn sleep; same swap-roll as the sleep move effect so
	; the debug harness's forced RNG values exit the loop
	call BattleRandom
	swap a
	and %11
	jr z, .sleep_roll
	ld [hl], a
	call UpdateOpponentInParty
	ld de, ANIM_SLP
	farcall AbilityStatusAnim
	call RefreshBattleHuds
	call SwitchTurnForOppText
	ld hl, FellAsleepText
	call StdBattleTextbox
	jp SwitchTurnForOppText

CheckTauntTormentCantMove_Core:
; Called from CheckTurn (turn holder = the acting mon). Carry + hl = text
; if Taunt or Torment forbids the selected move. Struggle is always legal.
	ld hl, wCurPlayerMove
	ldh a, [hBattleTurn]
	and a
	jr z, .got_move
	ld hl, wCurEnemyMove
.got_move
	ld a, [hl]
	ld b, a
	push bc
	ld hl, STRUGGLE
	call GetMoveIDFromIndex
	pop bc
	cp b
	jr z, .allowed
	; Taunt: no status moves
	ld hl, wPlayerTauntCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_taunt
	ld hl, wEnemyTauntCount
.got_taunt
	ld a, [hl]
	and a
	jr z, .no_taunt
	push bc
	ld l, b
	ld a, MOVE_CATEGORY
	call GetMoveAttribute
	pop bc
	cp CATEGORIZE_STATUS
	jr z, .taunt_blocked
.no_taunt
	; Torment: not the same move twice in a row
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVar
	bit SUBSTATUS_TORMENTED, a
	jr z, .allowed
	ld hl, wLastPlayerMove
	ldh a, [hBattleTurn]
	and a
	jr z, .got_last
	ld hl, wLastEnemyMove
.got_last
	ld a, [hl]
	and a
	jr z, .allowed
	cp b
	jr nz, .allowed
	ld hl, BattleText_MoveCantBeUsedTwice
	scf
	ret
.taunt_blocked
	ld hl, BattleText_CantUseAfterTaunt
	scf
	ret
.allowed
	and a
	ret
