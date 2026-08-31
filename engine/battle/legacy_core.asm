; Small helpers kept out of the full Battle Core bank.

CheckContestBattleOver:
; Also covers the SAFARI ZONE, which shares the ball counter.
	ld a, [wBattleType]
	cp BATTLETYPE_CONTEST
	jr z, .check_balls
	cp BATTLETYPE_SAFARI
	jr nz, .contest_not_over
.check_balls
	ld a, [wParkBallsRemaining]
	and a
	jr nz, .contest_not_over
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	add DRAW
	ld [wBattleResult], a
	scf
	ret

.contest_not_over
	and a
	ret

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

CheckTargetFaintedWithCheat::
	ld hl, wEnemyMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, CheckBattleHPIsZero_Overflow

CheckPlayerFaintedWithCheat::
	ld hl, wBattleMonHP
	ld a, [wPlayerInvincibleCheat]
	and a
	jr z, CheckBattleHPIsZero_Overflow
	ld a, [hli]
	or [hl]
	ret nz
	call KeepPlayerAtOneHP
	ret

CheckBattleHPIsZero_Overflow:
	ld a, [hli]
	or [hl]
	ret

KeepPlayerAtOneHP::
; The battle struct and party struct are separate copies. Keep both at 1 HP
; immediately so ending one battle and starting another cannot make party
; validation see a fainted active mon while the invincibility cheat says it
; survived.
	push bc
	xor a
	ld [wBattleMonHP], a
	inc a
	ld [wBattleMonHP + 1], a
	ld hl, wPartyMon1HP
	ld a, [wCurBattleMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	inc a
	ld [hl], a
	pop bc
	ret

_BattleRandom::
; If the normal RNG is used in a link battle it'll desync.
; To circumvent this a shared PRNG is used instead.

IF DEF(DEBUG_BATTLE)
; Battle tester RNG control: forced mode returns a fixed value, seeded mode
; runs the deterministic link-battle PRNG stream even out of link mode.
	ldh a, [hDebugRNGMode]
	and a
	jr z, .no_debug_rng
	dec a
	jr nz, .debug_prng ; mode 2+: deterministic stream
	ldh a, [hDebugRNGValue]
	ret
.no_debug_rng
ENDC

; But if we're in a non-link battle we're safe to use it
	ld a, [wLinkMode]
	and a
	jp z, Random

IF DEF(DEBUG_BATTLE)
.debug_prng
ENDC
; The PRNG operates in streams of 10 values.

; Which value are we trying to pull?
	push hl
	push bc
	ld a, [wLinkBattleRNCount]
	ld c, a
	ld b, 0
	ld hl, wLinkBattleRNs
	add hl, bc
	inc a
	ld [wLinkBattleRNCount], a

; If we haven't hit the end yet, we're good
	cp 10 - 1 ; Exclude last value. See the closing comment
	ld a, [hl]
	pop bc
	pop hl
	ret c

; If we have, we have to generate new pseudorandom data
; Instead of having multiple PRNGs, ten seeds are used
	push hl
	push bc
	push af

; Reset count to 0
	xor a
	ld [wLinkBattleRNCount], a
	ld hl, wLinkBattleRNs
	ld b, 10 ; number of seeds

; Generate next number in the sequence for each seed
; a[n+1] = (a[n] * 5 + 1) % 256
.loop
	; get last #
	ld a, [hl]

	; a * 5 + 1
	ld c, a
	add a
	add a
	add c
	inc a

	; update #
	ld [hli], a
	dec b
	jr nz, .loop

; This has the side effect of pulling the last value first,
; then wrapping around. As a result, when we check to see if
; we've reached the end, we check the one before it.

	pop af
	pop bc
	pop hl
	ret
