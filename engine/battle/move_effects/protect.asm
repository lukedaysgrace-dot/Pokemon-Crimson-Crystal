BattleCommand_Protect:
; protect
	call ProtectChance
	ret c

	; a plain Protect is not a Baneful Bunker
	call ClearBunkerFlag

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	set SUBSTATUS_PROTECT, [hl]

	call AnimateCurrentMove

	ld hl, ProtectedItselfText
	jp StdBattleTextbox

ProtectChance:
	ld de, wPlayerProtectCount
	ldh a, [hBattleTurn]
	and a
	jr z, .asm_37637
	ld de, wEnemyProtectCount
.asm_37637

	call CheckOpponentWentFirst
	jr nz, .failed

; Protect works fine behind the user's own Substitute (the old bail here
; was not a real rule).

; Modern rule: each consecutive use divides the success chance by 3
; (1/3, 1/9, 1/27, ...), not by 2.

	ld a, [de]
	cp .SuccessChancesEnd - .SuccessChances
	jr c, .got_index
	ld a, .SuccessChancesEnd - .SuccessChances - 1
.got_index
	push hl
	ld hl, .SuccessChances
	push bc
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	ld b, [hl]
	pop hl

.rand
	call BattleRandom
	and a
	jr z, .rand

	dec a
	cp b
	jr nc, .failed

; Another consecutive Protect use.

	ld a, [de]
	inc a
	ld [de], a

	and a
	ret

.failed
	xor a
	ld [de], a
	call AnimateFailedMove
	call PrintButItFailed
	scf
	ret

.SuccessChances:
; roll is `(BattleRandom nonzero) - 1 < value`, so value/255
	db 255 ; 1st use   ~100%
	db  85 ; 2nd use    1/3
	db  28 ; 3rd use    1/9
	db   9 ; 4th use    1/27
	db   3 ; 5th use    1/81
	db   1 ; 6th+       1/243
.SuccessChancesEnd

ClearBunkerFlag:
; clear the current user's Baneful Bunker bit
	push hl
	ld hl, wBunkerFlags
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	res 0, [hl]
	pop hl
	ret
.enemy
	res 1, [hl]
	pop hl
	ret
