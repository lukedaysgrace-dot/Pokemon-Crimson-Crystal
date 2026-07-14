; Small helpers kept out of the full Battle Core bank.

SetBerserkGeneConfusionDuration:
	ldh a, [hBattleTurn]
	and a
	ld hl, wPlayerConfuseCount
	jr z, .set_count
	ld hl, wEnemyConfuseCount
.set_count
	call BattleRandom
	and %11
	add 2
	ld [hl], a
	ret

ComputeEnemyHPPercentage:
; Compute hMultiplicand * 100 / max HP without ever using a zero divisor.
; Shift the 16-bit divisor and multiplier together until the divisor fits
; in one byte. For max HP below 256 (including 1-3), no shift is needed.
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, [hl]
	ld c, 100
	and a
	jr z, .shift_done
.shift
	rra
	rr b
	srl c
	and a
	jr nz, .shift
.shift_done
	ld a, c
	ldh [hMultiplier], a
	call Multiply
	ld a, b
	ld b, 4
	ldh [hDivisor], a
	jp Divide
