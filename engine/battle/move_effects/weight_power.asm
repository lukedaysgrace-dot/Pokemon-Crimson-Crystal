; Weight-based move power (Low Kick, Grass Knot, Heavy Slam, Heat Crash).
; Lives in Battle Effect Overflow, shared with the AI power predictor.
;
; Weights come from each species' Pokedex entry, so the dex and the battle
; engine can never disagree. The dex stores pounds x 10, which is the official
; weight in hectograms (0.1 kg) multiplied by 2.20462 and rounded. Converting
; back with (pounds x 10 x 29727 + 32768) >> 16 recovers the official hectogram
; value exactly for every weight from 0.1 kg to 999.9 kg, so the thresholds and
; ratios below match the modern games (Showdown's getWeight()) to the unit.
; Transform copies the target's species, so a transformed user also uses the
; copied weight, as in the modern games.

BattleLowKickPower_Core:
; Low Kick / Grass Knot: d = base power from the target's weight.
;  >= 200 kg: 120, >= 100 kg: 100, >= 50 kg: 80, >= 25 kg: 60,
;  >= 10 kg: 40, otherwise 20.
; Preserve attack b, defense c, level e and hl.
	push bc
	push de
	push hl
	call GetOpponentWeightHG
	ld de, LowKickWeightPowers
.loop
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	; carry if weight < threshold
	ld a, l
	sub c
	ld a, h
	sbc b
	ld a, [de]
	inc de
	jr c, .loop
	pop hl
	pop de
	ld d, a
	pop bc
	ret

LowKickWeightPowers:
; threshold in hectograms, base power (first match from the top wins)
	dw 2000
	db 120
	dw 1000
	db 100
	dw 500
	db 80
	dw 250
	db 60
	dw 100
	db 40
	dw 0
	db 20

BattleHeavySlamPower_Core:
; Heavy Slam / Heat Crash: d = base power from the user's weight compared
; with the target's weight.
;  user >= 5x target: 120, >= 4x: 100, >= 3x: 80, >= 2x: 60, otherwise 40.
; Preserve attack b, defense c, level e and hl.
	push bc
	push de
	push hl
	call GetOpponentWeightHG
	push hl
	call GetUserWeightHG
	pop de
	; hl = user weight, de = target weight, bc = running multiple of target
	ld b, d
	ld c, e
	ld a, 40
	call .next_multiple ; 2x
	jr c, .got_power
	ld a, 60
	call .next_multiple ; 3x
	jr c, .got_power
	ld a, 80
	call .next_multiple ; 4x
	jr c, .got_power
	ld a, 100
	call .next_multiple ; 5x
	jr c, .got_power
	ld a, 120
.got_power
	pop hl
	pop de
	ld d, a
	pop bc
	ret

.next_multiple
; bc += de; carry if the user's weight (hl) is below the new multiple.
; Preserves a. Overflow past 16 bits is always above any weight.
	push af
	ld a, c
	add e
	ld c, a
	ld a, b
	adc d
	ld b, a
	jr c, .too_heavy
	ld a, l
	sub c
	ld a, h
	sbc b
	jr c, .too_heavy
	pop af
	and a
	ret
.too_heavy
	pop af
	scf
	ret

GetUserWeightHG:
; hl = the current user's weight in hectograms (at least 1).
	ldh a, [hBattleTurn]
	and a
	ld a, [wBattleMonSpecies]
	jr z, GetSpeciesWeightHG
	ld a, [wEnemyMonSpecies]
	jr GetSpeciesWeightHG

GetOpponentWeightHG:
; hl = the current target's weight in hectograms (at least 1).
	ldh a, [hBattleTurn]
	and a
	ld a, [wEnemyMonSpecies]
	jr z, GetSpeciesWeightHG
	ld a, [wBattleMonSpecies]
	; fallthrough

GetSpeciesWeightHG:
; a = species ID. Returns hl = weight in hectograms (at least 1).
; Clobbers a, bc and de.
	ld b, a
	farcall GetDexEntryPointer ; b:de = dex entry
	ld h, d
	ld l, e
.skip_category
	ld a, b
	call GetFarByte
	inc hl
	cp "@"
	jr nz, .skip_category
	inc hl ; skip height
	inc hl
	ld a, b
	call GetFarHalfword ; hl = pounds x 10
	; hg = (lbs10 * 29727 + 32768) >> 16
	;    = ((lbs10.lo * 29727) >> 8 + lbs10.hi * 29727 + 128) >> 8
	push hl
	xor a
	ldh [hMultiplicand + 0], a
	ld a, HIGH(29727)
	ldh [hMultiplicand + 1], a
	ld a, LOW(29727)
	ldh [hMultiplicand + 2], a
	ld a, l
	ldh [hMultiplier], a
	call Multiply
	; de = (lbs10.lo * 29727) >> 8, plus the rounding half
	ldh a, [hProduct + 2]
	add $80
	ld e, a
	ldh a, [hProduct + 1]
	adc 0
	ld d, a
	pop hl
	xor a
	ldh [hMultiplicand + 0], a
	ld a, HIGH(29727)
	ldh [hMultiplicand + 1], a
	ld a, LOW(29727)
	ldh [hMultiplicand + 2], a
	ld a, h
	ldh [hMultiplier], a
	push de
	call Multiply
	pop de
	; hl = (lbs10.hi * 29727 + de) >> 8
	ldh a, [hProduct + 3]
	add e
	ldh a, [hProduct + 2]
	adc d
	ld l, a
	ldh a, [hProduct + 1]
	adc 0
	ld h, a
	or l
	ret nz
	inc hl ; Showdown: weight is at least 1 hectogram
	ret
