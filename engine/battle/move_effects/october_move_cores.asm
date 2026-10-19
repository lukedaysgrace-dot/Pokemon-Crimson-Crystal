; Requested October 2026 move mechanics.
; Lives in Battle Effect Overflow, shared with the AI power predictor.

BattleHPScaledPower_Core:
; d = max(1, floor(150 * current HP / maximum HP)), capped at 150.
; Preserve attack b, defense c, level e and hl. Use exact 24/16-bit division:
; reducing a 16-bit HP denominator to one byte would round low-HP cases wrong.
	push bc
	push de
	push hl
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonHP
	jr z, .got_hp
	ld hl, wEnemyMonHP
.got_hp
	xor a
	ldh [hMultiplicand], a
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hli]
	ldh [hMultiplicand + 2], a
	; hl now points at maximum HP, preserved by Multiply.
	ld a, 150
	ldh [hMultiplier], a
	call Multiply
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, b
	or c
	ld a, 1
	jr z, .done
	ldh a, [hProduct + 1]
	ld d, a
	ldh a, [hProduct + 2]
	ld h, a
	ldh a, [hProduct + 3]
	ld l, a
	ld e, 0
.divide
	ld a, d
	and a
	jr nz, .subtract
	ld a, h
	cp b
	jr c, .quotient
	jr nz, .subtract
	ld a, l
	cp c
	jr c, .quotient
.subtract
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ld a, d
	sbc 0
	ld d, a
	inc e
	ld a, e
	cp 150
	jr c, .divide
	jr .done
.quotient
	ld a, e
	and a
	jr nz, .done
	inc a
.done
	pop hl
	pop de
	ld d, a
	pop bc
	ret

InitRecycleItems_Core:
; Clear battle-only history, preserving the active WRAM bank.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerRecycleItems)
	ldh [rSVBK], a
	ld hl, wPlayerRecycleItems
	ld bc, PARTY_LENGTH * 2
	xor a
	call ByteFill
	pop af
	ldh [rSVBK], a
	ret

RecycleItemAddress_Core:
; c = side. Return this battler's party-member history byte in hl.
	ld a, c
	and a
	ld hl, wPlayerRecycleItems
	ld a, [wCurBattleMon]
	jr z, .index
	ld hl, wEnemyRecycleItems
	ld a, [wBattleMode]
	cp WILD_BATTLE
	ld a, 0
	jr z, .index
	ld a, [wCurOTMon]
.index
	cp PARTY_LENGTH
	jr c, .valid
	xor a
.valid
	push bc
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	ret

ReadRecycleItem_Core:
; c = side -> b = last consumed item. Other registers and rSVBK preserved.
	push hl
	call RecycleItemAddress_Core
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerRecycleItems)
	ldh [rSVBK], a
	ld b, [hl]
	pop af
	ldh [rSVBK], a
	pop hl
	ret

WriteRecycleItem_Core::
; c = side, b = item. Shared by real consumption, Harvest and Recycle.
	push hl
	call RecycleItemAddress_Core
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerRecycleItems)
	ldh [rSVBK], a
	ld [hl], b
	pop af
	ldh [rSVBK], a
	pop hl
	ret

BattleRecycle_Core:
	; Check the actual held item, including a Klutz-suppressed item.
	callfar GetUserItem
	ld a, [hl]
	and a
	jp nz, .fail
	ldh a, [hBattleTurn]
	ld c, a
	call ReadRecycleItem_Core
	ld a, b
	and a
	jp z, .fail
	push bc
	callfar BattleCommand_LowerSub
	callfar BattleCommand_MoveAnim
	callfar BattleCommand_RaiseSub
	pop bc
	; Restore the held item and its corresponding party byte.
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonItem
	jr z, .battle_item
	ld hl, wEnemyMonItem
.battle_item
	ld [hl], b
	push bc
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy_party
	ld a, MON_ITEM
	call BattlePartyAttr
	jr .party_item
.enemy_party
	ld a, [wBattleMode]
	cp WILD_BATTLE
	jr z, .skip_party
	ld a, MON_ITEM
	call OTPartyAttr
.party_item
	pop bc
	ld [hl], b
	push bc
.skip_party
	pop bc
	; It is held again: no outstanding consumable or Unburden bonus.
	; Preserve pending Cud Chew and the one-use Berserk Gene flag.
	push bc
	farcall ReadItemStateFlags
	ld a, b
	and $fc
	ld b, a
	farcall WriteItemStateFlags
	ld b, 0
	call WriteRecycleItem_Core
	pop bc
	farcall AbilityBufferItemName_b
	ld hl, .restored
	jp BattleTextbox ; this message lives in the current overflow bank
.fail
	ld a, 1
	ld [wAttackMissed], a
	callfar AnimateFailedMove
	ld hl, ButItFailedText
	jp StdBattleTextbox
.restored
	text "<USER>"
	line "recycled its"
	cont "@"
	text_ram wBattleDynamicNameBuffer
	text "!"
	prompt

