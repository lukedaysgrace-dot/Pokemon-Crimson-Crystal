CalcLevel:
	ld a, [wTempMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld d, 1
.next_level
	inc d
	ld a, [wLevelCap]
	and a
	jr nz, .got_level_cap
	ld a, MAX_LEVEL

.got_level_cap
	inc a
	ld b, a
	ld a, d
	cp b
	jr z, .got_level
	call CalcExpAtLevel
	push hl
	ld hl, wTempMonExp + 2
	ldh a, [hProduct + 3]
	ld c, a
	ld a, [hld]
	sub c
	ldh a, [hProduct + 2]
	ld c, a
	ld a, [hld]
	sbc c
	ldh a, [hProduct + 1]
	ld c, a
	ld a, [hl]
	sbc c
	pop hl
	jr nc, .next_level

.got_level
	dec d
	ret

UpdateLevelCap::
	ld de, ENGINE_HARD_MODE
	ld b, CHECK_FLAG
	farcall EngineFlagAction
	ld a, c
	and a
	jr nz, .hard
	ld a, MAX_LEVEL
	ld [wLevelCap], a
	ret

.hard
	ld hl, wBadges
	ld b, 2
	call CountSetBits
	ld e, a
	ld hl, wStatusFlags
	bit STATUSFLAGS_HALL_OF_FAME_F, [hl]
	jr z, .load_cap
	cp NUM_JOHTO_BADGES
	jr c, .load_cap
	inc e

.load_cap
	ld d, 0
	ld hl, HardModeLevelCaps
	add hl, de
	ld a, [hl]
	ld [wLevelCap], a
	ret

HardModeLevelCaps:
; Each entry is the level a player who fights most (not all) trainers actually
; reaches by that point, solved against the real EXP in the game with the Hard
; Mode 2x trainer bonus -- see tools/audit_exp_economy.py. Gym leader aces are
; set to the same numbers, so every profile arrives at parity: a thorough
; player is clamped down to the cap rather than running away with it.
; Indexed by badge count, +1 once the Hall of Fame flag is set at 8+ badges,
; so the cap now runs the whole game rather than lifting after Clair. Kanto
; compresses hard because the EXP curve is cubic while the amount of content
; per badge is flat -- these are the levels Kanto can actually pay for.
	db 10 ; Falkner
	db 13 ; Bugsy
	db 20 ; Whitney
	db 25 ; Morty
	db 30 ; Chuck
	db 34 ; Jasmine
	db 38 ; Pryce
	db 45 ; Clair
	db 57 ; Elite Four (one step: no badge is earned until the Hall of Fame)
	db 58 ; Kanto, 0 badges
	db 63 ; Kanto, 1 badge
	db 65 ; Kanto, 2 badges
	db 67 ; Kanto, 3 badges
	db 68 ; Kanto, 4 badges
	db 69 ; Kanto, 5 badges
	db 70 ; Kanto, 6 badges
	db 71 ; Kanto, 7 badges
	db 73 ; Kanto, 8 badges -- Red

CalcExpAtLevel:
; (a/b)*n**3 + c*n**2 + d*n - e
	ld a, d
	dec a
	jr nz, .UseExpFormula
; Pokemon have 0 experience at level 1.
	ld hl, hProduct
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

.UseExpFormula
	ld a, [wBaseGrowthRate]
	add a
	add a
	ld c, a
	ld b, 0
	ld hl, GrowthRates
	add hl, bc
; Cube the level
	call .LevelSquared
	ld a, d
	ldh [hMultiplier], a
	call Multiply

; Multiply by a
	ld a, [hl]
	and $f0
	swap a
	ldh [hMultiplier], a
	call Multiply
; Divide by b
	ld a, [hli]
	and $f
	ldh [hDivisor], a
	ld b, 4
	call Divide
; Push the cubic term to the stack
	ldh a, [hQuotient + 1]
	push af
	ldh a, [hQuotient + 2]
	push af
	ldh a, [hQuotient + 3]
	push af
; Square the level and multiply by the lower 7 bits of c
	call .LevelSquared
	ld a, [hl]
	and $7f
	ldh [hMultiplier], a
	call Multiply
; Push the absolute value of the quadratic term to the stack
	ldh a, [hProduct + 1]
	push af
	ldh a, [hProduct + 2]
	push af
	ldh a, [hProduct + 3]
	push af
	ld a, [hli]
	push af
; Multiply the level by d
	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, d
	ldh [hMultiplicand + 2], a
	ld a, [hli]
	ldh [hMultiplier], a
	call Multiply
; Subtract e
	ld b, [hl]
	ldh a, [hProduct + 3]
	sub b
	ldh [hMultiplicand + 2], a
	ld b, $0
	ldh a, [hProduct + 2]
	sbc b
	ldh [hMultiplicand + 1], a
	ldh a, [hProduct + 1]
	sbc b
	ldh [hMultiplicand], a
; If bit 7 of c is set, c is negative; otherwise, it's positive
	pop af
	and $80
	jr nz, .subtract
; Add c*n**2 to (d*n - e)
	pop bc
	ldh a, [hProduct + 3]
	add b
	ldh [hMultiplicand + 2], a
	pop bc
	ldh a, [hProduct + 2]
	adc b
	ldh [hMultiplicand + 1], a
	pop bc
	ldh a, [hProduct + 1]
	adc b
	ldh [hMultiplicand], a
	jr .done_quadratic

.subtract
; Subtract c*n**2 from (d*n - e)
	pop bc
	ldh a, [hProduct + 3]
	sub b
	ldh [hMultiplicand + 2], a
	pop bc
	ldh a, [hProduct + 2]
	sbc b
	ldh [hMultiplicand + 1], a
	pop bc
	ldh a, [hProduct + 1]
	sbc b
	ldh [hMultiplicand], a

.done_quadratic
; Add (a/b)*n**3 to (d*n - e +/- c*n**2)
	pop bc
	ldh a, [hProduct + 3]
	add b
	ldh [hMultiplicand + 2], a
	pop bc
	ldh a, [hProduct + 2]
	adc b
	ldh [hMultiplicand + 1], a
	pop bc
	ldh a, [hProduct + 1]
	adc b
	ldh [hMultiplicand], a
	ret

.LevelSquared:
	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, d
	ldh [hMultiplicand + 2], a
	ldh [hMultiplier], a
	jp Multiply

INCLUDE "data/growth_rates.asm"
