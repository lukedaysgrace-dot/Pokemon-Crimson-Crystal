ResetCounterHitHistory_Core::
; Clear at the start of each round, before either side acts.
	push hl
	push bc
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerCounterHit)
	ldh [rSVBK], a
	ld hl, wPlayerCounterHit
	ld b, wCounterHitHistoryEnd - wPlayerCounterHit
	xor a
.clear
	ld [hli], a
	dec b
	jr nz, .clear
	pop af
	ldh [rSVBK], a
	pop bc
	pop hl
	ret

RecordCounterHit_Core::
; Called after applydamage has capped wCurDamage to actual HP lost.
; Substitute damage does not qualify. Each successful direct hit replaces
; the preceding one, so multi-hit attacks reflect only their final hit.
	push bc
	ld a, [wHitSubstitute]
	and a
	jr nz, .return
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	or b
	jr z, .return
	push hl
	push de
	ld hl, wEnemyCounterHit
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerMoveStructCategory]
	jr z, .got_side
	ld hl, wPlayerCounterHit
	ld a, [wEnemyMoveStructCategory]
.got_side
	cp CATEGORIZE_STATUS
	jr z, .done
	inc a
	ld b, a
	; wCurDamage lives in bank 1; cache it before selecting bank 2.
	ld a, [wCurDamage]
	ld d, a
	ld a, [wCurDamage + 1]
	ld e, a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerCounterHit)
	ldh [rSVBK], a
	ld a, b
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	pop af
	ldh [rSVBK], a
.done
	pop de
	pop hl
.return
	pop bc
	ret

LoadCounterHit_Core::
; Return the current user's recorded category in b and damage in
; wCurDamage. b=0 means no qualifying hit occurred during this round.
	push hl
	push de
	ld hl, wPlayerCounterHit
	ldh a, [hBattleTurn]
	and a
	jr z, .got_side
	ld hl, wEnemyCounterHit
.got_side
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPlayerCounterHit)
	ldh [rSVBK], a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	pop af
	ldh [rSVBK], a
	; Write bank-1 damage only after restoring the caller's bank.
	ld a, d
	ld [wCurDamage], a
	ld a, e
	ld [wCurDamage + 1], a
	pop de
	pop hl
	ret
