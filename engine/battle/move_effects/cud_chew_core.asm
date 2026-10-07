CudChewFindPPMove_Core:
; Mystery Berry's Eat effect targets the first move with the lowest current
; PP, even above zero. Carry if it can restore PP; hl = battle PP slot,
; b = restored packed PP, c = move slot. No writes or consumption here.
	call .Pointers
	ld b, PP_MASK + 1
	ld c, 0
	xor a
	push af ; selected move slot
.find
	ld a, [hli]
	and a
	jr z, .selected
	ld a, [de]
	and PP_MASK
	cp b
	jr nc, .next
	ld b, a
	pop af
	ld a, c
	push af
.next
	inc de
	inc c
	ld a, c
	cp NUM_MOVES
	jr nz, .find
.selected
	pop af
	ld c, a
	ld a, b
	cp PP_MASK + 1
	jp z, .no
	call .Pointers
	ld b, 0
	add hl, bc
	ld a, [hl]
	push af ; move id
	ld h, d
	ld l, e
	add hl, bc
	pop af
	ld e, [hl] ; packed PP, including PP Ups
	push de
	push hl
	ld l, a
	ld a, MOVE_PP
	call GetMoveAttribute
	ld b, a ; base maximum PP
	pop hl
	pop de
	push hl
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVar
	pop hl
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .pp_ups
	; Transformed move slots have at most five PP (Sketch has one).
	ld a, b
	cp 5 + 1
	jr c, .max_ready
	ld b, 5
	jr .max_ready
.pp_ups
	ld a, e
	rlca
	rlca
	and 3
	ld d, a ; PP Up count
	push bc
	ld c, 0
	ld a, b
.divide
	sub 5
	jr c, .divided
	inc c
	jr .divide
.divided
	ld a, c
	cp 8
	jr c, .increment_ready
	ld a, 7 ; match the packed PP format's 61-PP cap
.increment_ready
	ld c, a
.add_pp_ups
	ld a, d
	and a
	jr z, .max_calculated
	ld a, b
	add c
	ld b, a
	dec d
	jr .add_pp_ups
.max_calculated
	ld a, b
	pop bc
	ld b, a
.max_ready
	ld a, e
	and PP_MASK
	add 5
	cp b
	jr c, .restored
	ld a, b
.restored
	ld d, a
	ld a, e
	and PP_MASK
	cp d
	jr nc, .no
	ld a, e
	and PP_UP_MASK
	or d
	ld b, a
	scf
	ret
.no
	and a
	ret

.Pointers
	ld hl, wBattleMonMoves
	ld de, wBattleMonPP
	ldh a, [hBattleTurn]
	and a
	ret z
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonPP
	ret

CudChewRestorePP_Core:
	call CudChewFindPPMove_Core
	ret nc
	ld [hl], b
	push bc
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVar
	pop bc
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .show ; copied moves do not belong to the original party mon
	ld a, MON_PP
	call BattlePartyAttr
	ldh a, [hBattleTurn]
	and a
	jr z, .sync
	ld hl, wWildMonPP
	ld a, [wBattleMode]
	dec a
	jr z, .sync
	ld a, MON_PP
	call OTPartyAttr
.sync
	ld a, b
	ld b, 0
	add hl, bc
	ld [hl], a
.show
	ld a, MYSTERYBERRY
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	farcall SwitchTurn
	farcall ItemRecoveryAnim
	farcall SwitchTurn
	ld hl, BattleText_UserRecoveredPPUsing
	jp StdBattleTextbox
