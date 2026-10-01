; Parental Bond is a real two-hit move. Replay the hit portion of the existing
; script so damage, Substitute, items, contact abilities and secondary effects
; all resolve separately. Preparation/PP/turn checks run only once. The state
; is banked; every accessor restores rSVBK before calling ordinary battle code.

ReadParentalBondState:
	push bc
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	ld a, [wParentalBondState]
	ld b, a
	pop af
	ldh [rSVBK], a
	ld a, b
	pop bc
	ret

WriteParentalBondState:
; a = 0 inactive, 1 first hit, 2 second hit, 3 finished.
	push bc
	ld b, a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	ld a, b
	ld [wParentalBondState], a
	pop af
	ldh [rSVBK], a
	pop bc
	ret

PrepareParentalBond_Core::
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	xor a
	ld hl, wParentalBondState
	ld bc, wParentalBondEnd - wParentalBondState
	call ByteFill
	pop af
	ldh [rSVBK], a
	farcall GetTrueUserAbility_b
	ld a, b
	cp PARENTAL_BOND
	ret nz
	ld hl, wPlayerMoveStructCategory
	ldh a, [hBattleTurn]
	and a
	jr z, .category
	ld hl, wEnemyMoveStructCategory
.category
	ld a, [hl]
	cp CATEGORIZE_STATUS
	ret z
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	ld hl, .excluded_effects
	ld de, 1
	call IsInArray
	ret c
	; Find the first damage calculation, without altering the script buffer.
	; Fixed-damage and counter moves have no critical command.
	ld hl, wBattleScriptBuffer
	ld c, 0
	ld d, $ff
.scan
	ld a, [hli]
	cp endmove_command
	jr z, .end
	ld b, a
	ld a, d
	cp $ff
	jr nz, .next
	ld a, b
	cp critical_command
	jr z, .start
	cp constantdamage_command
	jr z, .start
	cp counter_command
	jr z, .start
	cp mirrorcoat_command
	jr z, .start
	cp ohko_command
	jr nz, .next
.start
	ld d, c
.next
	inc c
	jr .scan
.end
	ld a, d
	cp $ff
	ret z
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	ld a, d
	ld [wParentalBondLoopStart], a
	ld a, c
	inc a ; dispatcher address is immediately after the current command
	ld [wParentalBondScriptEnd], a
	ld a, 1
	ld [wParentalBondState], a
	pop af
	ldh [rSVBK], a
	ret
.excluded_effects
	; Existing multi-hit moves, charging moves, delayed attacks, and moves
	; whose supported effect cannot make a second attack.
	db EFFECT_MULTI_HIT, EFFECT_DOUBLE_HIT, EFFECT_POISON_MULTI_HIT
	db EFFECT_TRIPLE_KICK, EFFECT_BEAT_UP, EFFECT_SCALE_SHOT
	db EFFECT_RAZOR_WIND, EFFECT_SKY_ATTACK, EFFECT_SKULL_BASH
	db EFFECT_SOLARBEAM, EFFECT_FLY, EFFECT_BOUNCE
	db EFFECT_FUTURE_SIGHT, EFFECT_SELFDESTRUCT, EFFECT_ROLLOUT, EFFECT_BIDE
	db -1

CheckParentalBondSecondHit_Core::
; Carry if accuracy was already checked on this move's first hit.
	call ReadParentalBondState
	cp 2
	jr z, .yes
	and a
	ret
.yes
	scf
	ret

CheckParentalBondMove_Core::
; Carry while a Parental Bond move is processing either hit.
	call ReadParentalBondState
	cp 1
	jr z, .yes
	cp 2
	jr z, .yes
	and a
	ret
.yes
	scf
	ret

ParentalBondHitPending_Core::
; Carry if a living attacker will make its second hit. Life Orb and move
; recoil are deferred until that hit; an early KO still pays recoil once.
	call ReadParentalBondState
	cp 1
	jr nz, .no
	farcall UserHasFainted
	jr z, .no
	farcall OppHasFainted
	jr z, .no
	scf
	ret
.no
	and a
	ret

ParentalBondCommandGate_Core::
; b = command. Carry skips it and resumes the dispatcher; otherwise b is
; unchanged. One-time switching is deferred until both hits complete.
	push bc
	push de
	call ReadParentalBondState
	cp 1
	jr z, .first
	cp 2
	jp nz, .ordinary
	ld a, b
	cp counter_command
	jp z, .fixed_counter
	cp mirrorcoat_command
	jp z, .fixed_counter
	cp present_command
	jp z, .present_power
	cp endmove_command
	jp nz, .ordinary
	ld a, 3
	call WriteParentalBondState
	; Do not report a second hit if its script aborted before applydamage.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	ld a, [wParentalBondHits]
	ld d, a
	pop af
	ldh [rSVBK], a
	ld a, d
	cp 2
	jp nz, .ordinary
	ld hl, Hit2TimesText
	call StdBattleTextbox
	jp .ordinary
.first
	ld a, b
	cp applydamage_command
	jp z, .save_counter_damage
	cp recoil_command
	jp z, .defer_recoil
	cp uturn_command
	jr z, .repeat
	cp forceswitch_command
	jr z, .repeat
	cp endmove_command
	jp nz, .ordinary
	; EndMoveEffect can write an early terminator on a miss, Present heal,
	; KO, or other aborted script. Only the original end starts a replay.
	ld a, [wBattleScriptBufferAddress]
	sub LOW(wBattleScriptBuffer)
	ld d, a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	ld a, [wParentalBondScriptEnd]
	cp d
	ld d, 0
	jr nz, .checked_end
	inc d
.checked_end
	pop af
	ldh [rSVBK], a
	ld a, d
	and a
	jp z, .cancel
.repeat
	farcall UserHasFainted
	jp z, .cancel
	farcall OppHasFainted
	jp z, .cancel
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	ld a, [wParentalBondHits]
	and a
	jr z, .not_landed
	ld a, [wParentalBondLoopStart]
	ld d, a
	ld a, 2
	ld [wParentalBondState], a
	pop af
	ldh [rSVBK], a
	ld a, LOW(wBattleScriptBuffer)
	add d
	ld [wBattleScriptBufferAddress], a
	ld a, HIGH(wBattleScriptBuffer)
	adc 0
	ld [wBattleScriptBufferAddress + 1], a
	xor a
	ld [wHitSubstitute], a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld [wPreStatScopeActive], a
	jp .skip
.not_landed
	pop af
	ldh [rSVBK], a
.cancel
	ld a, 3
	call WriteParentalBondState
	jr .ordinary
.defer_recoil
	call ParentalBondHitPending_Core
	jr c, .skip
	jr .ordinary
.save_counter_damage
	ld a, [wCurDamage]
	ld d, a
	ld a, [wCurDamage + 1]
	ld e, a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	ld a, d
	ld [wParentalBondFirstDamage], a
	ld a, e
	ld [wParentalBondFirstDamage + 1], a
	pop af
	ldh [rSVBK], a
	jr .ordinary
.fixed_counter
	; Counter/Mirror Coat double the incoming damage in place. Reusing
	; their result avoids doubling it again, including a first-hit HP cap.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	ld a, [wParentalBondFirstDamage]
	ld d, a
	ld a, [wParentalBondFirstDamage + 1]
	ld e, a
	pop af
	ldh [rSVBK], a
	ld a, d
	ld [wCurDamage], a
	ld a, e
	ld [wCurDamage + 1], a
	jr .skip
.present_power
	; Present chooses its power/healing mode once per move. The damaging
	; branch leaves the selected index in wPresentPower for its second hit.
	ld a, [wPresentPower]
	ld e, a
	ld d, 0
	ld hl, .present_powers
	add hl, de
	ld a, [hl]
	pop de
	ld d, a
	pop bc
	scf
	ret
.ordinary
	pop de
	pop bc
	; The after-move defender event belongs to the battlers that took part
	; in the attack. Resolve it before either side's switch replaces them.
	ld a, b
	cp uturn_command
	jr z, .before_switch
	cp forceswitch_command
	jr nz, .continue
.before_switch
	push bc
	push de
	push hl
	farcall RunBerserkMoveEnd_Core
	pop hl
	pop de
	pop bc
.continue
	and a
	ret
.skip
	pop de
	pop bc
	scf
	ret
.present_powers
	db 40, 80, 120

RecordParentalBondDamage_Core::
; Called after applydamage, when wCurDamage is capped to actual HP lost.
	ld a, [wAttackMissed]
	and a
	ret nz
	ld a, [wCurDamage]
	push bc
	ld b, a
	ld a, [wCurDamage + 1]
	or b
	pop bc
	jr nz, .landed
	; An intact custom Disguise absorbs a legitimate first hit for zero HP.
	ld a, [wDisguiseBusted + 1]
	bit 7, a
	ret z
.landed
	farcall RecordCounterHit_Core
	push bc
	; Battle damage lives in bank 1; capture it before accessing bank 2.
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	ld hl, wParentalBondHits
	inc [hl]
	ld a, [wParentalBondTotalDamage + 1]
	add c
	ld [wParentalBondTotalDamage + 1], a
	ld a, [wParentalBondTotalDamage]
	adc b
	ld [wParentalBondTotalDamage], a
	jr nc, .restore
	ld a, $ff
	ld [wParentalBondTotalDamage], a
	ld [wParentalBondTotalDamage + 1], a
.restore
	; Berserk observes the holder's HP loss after the entire move, including
	; native multi-hit moves. Substitute HP never enters that total.
	ld a, [wHitSubstitute]
	and a
	jr nz, .restore_bank
	ld a, [wMoveDamageToHolder + 1]
	add c
	ld [wMoveDamageToHolder + 1], a
	ld a, [wMoveDamageToHolder]
	adc b
	ld [wMoveDamageToHolder], a
	jr nc, .restore_bank
	ld a, $ff
	ld [wMoveDamageToHolder], a
	ld [wMoveDamageToHolder + 1], a
.restore_bank
	pop af
	ldh [rSVBK], a
	pop bc
	ret

ReadMoveDamageToHolder_Core::
; bc = total actual HP lost by the defender during the current move.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wMoveDamageToHolder)
	ldh [rSVBK], a
	ld a, [wMoveDamageToHolder]
	ld b, a
	ld a, [wMoveDamageToHolder + 1]
	ld c, a
	pop af
	ldh [rSVBK], a
	ret

ClearMoveDamageToHolder_Core::
; Consume an after-move event before a pivot/phaze or final terminator.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wMoveDamageToHolder)
	ldh [rSVBK], a
	xor a
	ld [wMoveDamageToHolder], a
	ld [wMoveDamageToHolder + 1], a
	pop af
	ldh [rSVBK], a
	ret

QuarterParentalBondDamage_Core::
; Only ordinary calculated damage is reduced. Fixed-damage commands never
; call this helper. Round as the modern modifier does, with minimum 1.
	call ReadParentalBondState
	cp 2
	ret nz
	ld a, [wIsConfusionDamage]
	and a
	ret nz
	push bc
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
	inc bc ; round to nearest, rounding exact halves down
	ld a, b
	or c
	jr nz, .shift
	dec bc ; saturated $ffff
.shift
	srl b
	rr c
	srl b
	rr c
	ld a, b
	or c
	jr nz, .store
	inc c
.store
	ld a, b
	ld [wCurDamage], a
	ld a, c
	ld [wCurDamage + 1], a
	pop bc
	ret

ParentalBondRecoilDamage_Core::
; bc = damage dealt, summed across both hits for move recoil.
	call ReadParentalBondState
	cp 1
	jr z, .total
	cp 2
	jr z, .total
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
	ret
.total
	ldh a, [rSVBK]
	push af
	ld a, BANK(wParentalBondState)
	ldh [rSVBK], a
	ld a, [wParentalBondTotalDamage]
	ld b, a
	ld a, [wParentalBondTotalDamage + 1]
	ld c, a
	pop af
	ldh [rSVBK], a
	ret
