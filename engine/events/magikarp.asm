CheckMagikarpLength:
	; Returns 3 if you select a Magikarp that beats the previous record.
	; Returns 2 if you select a Magikarp, but the current record is longer.
	; Returns 1 if you press B in the Pokemon selection menu.
	; Returns 0 if the Pokemon you select is not a Magikarp.

	; Let's start by selecting a Magikarp.
	farcall SelectMonFromParty
	jr c, .declined
	ld a, [wCurPartySpecies]
	call GetPokemonIndexFromID
	ld a, l
	sub LOW(MAGIKARP)
	if HIGH(MAGIKARP) == 0
		or h
	else
		jr nz, .not_magikarp
		if HIGH(MAGIKARP) == 1
			dec h
		else
			ld a, h
			cp HIGH(MAGIKARP)
		endc
	endc
	jr nz, .not_magikarp

	; Now let's compute its length based on its DVs and ID.
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	push hl
	ld bc, MON_DVS
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, MON_ID
	add hl, bc
	ld b, h
	ld c, l
	call CalcMagikarpLength
	call PrintMagikarpLength
	farcall StubbedTrainerRankings_MagikarpLength
	ld hl, .MeasureItText
	call PrintText

	; Did we beat the record?
	ld hl, wMagikarpLength
	ld de, wBestMagikarpLengthFeet
	ld c, 2
	call CompareBytes
	jr nc, .not_long_enough

	; NEW RECORD!!! Let's save that.
	ld hl, wMagikarpLength
	ld de, wBestMagikarpLengthFeet
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld a, [wCurPartyMon]
	ld hl, wPartyMonOT
	call SkipNames
	call CopyBytes
	ld a, MAGIKARPLENGTH_BEAT_RECORD
	ld [wScriptVar], a
	ret

.not_long_enough
	ld a, MAGIKARPLENGTH_TOO_SHORT
	ld [wScriptVar], a
	ret

.declined
	ld a, MAGIKARPLENGTH_REFUSED
	ld [wScriptVar], a
	ret

.not_magikarp
	xor a ; MAGIKARPLENGTH_NOT_MAGIKARP
	ld [wScriptVar], a
	ret

.MeasureItText:
	; Let me measure that MAGIKARP. …Hm, it measures @ .
	text_far UnknownText_0x1c1203
	text_end

PrintMagikarpLength:
; The prime marks ′ ″ now live in the main font ($ce-$cf), so there is no
; longer a separate feet/inches graphic to load here.
	ld hl, wStringBuffer1
	ld de, wMagikarpLength
	lb bc, PRINTNUM_RIGHTALIGN | 1, 2
	call PrintNum
	ld [hl], "′"
	inc hl
	ld de, wMagikarpLength + 1
	lb bc, PRINTNUM_RIGHTALIGN | 1, 2
	call PrintNum
	ld [hl], "″"
	inc hl
	ld [hl], "@"
	ret

CalcMagikarpLength:
; Return Magikarp's length (in feet and inches) at wMagikarpLength (big endian).
;
; input:
;   de: wEnemyMonDVs
;   bc: wPlayerID

; This function is poorly commented.

; In short, it generates a value between 190 and 1786 using
; a Magikarp's DVs and its trainer ID. This value is further
; filtered in LoadEnemyMon to make longer Magikarp even rarer.

; The value is generated from a lookup table.
; The index is determined by the dv xored with the player's trainer id.

; bc = rrc(dv[0]) ++ rrc(dv[1]) ^ rrc(id)

; if bc < 10:    [wMagikarpLength] = c + 190
; if bc ≥ $ff00: [wMagikarpLength] = c + 1370
; else:          [wMagikarpLength] = z * 100 + (bc - x) / y

; X, Y, and Z depend on the value of b as follows:

; if b = 0:        x =   310,  y =   2,  z =  3
; if b = 1:        x =   710,  y =   4,  z =  4
; if b = 2-9:      x =  2710,  y =  20,  z =  5
; if b = 10-29:    x =  7710,  y =  50,  z =  6
; if b = 30-68:    x = 17710,  y = 100,  z =  7
; if b = 69-126:   x = 32710,  y = 150,  z =  8
; if b = 127-185:  x = 47710,  y = 150,  z =  9
; if b = 186-224:  x = 57710,  y = 100,  z = 10
; if b = 225-243:  x = 62710,  y =  50,  z = 11
; if b = 244-251:  x = 64710,  y =  20,  z = 12
; if b = 252-253:  x = 65210,  y =   5,  z = 13
; if b = 254:      x = 65410,  y =   2,  z = 14

	; bc = rrc(dv[0]) ++ rrc(dv[1]) ^ rrc(id)

	; id
	ld h, b
	ld l, c
	ld a, [hli]
	ld b, a
	ld c, [hl]
	rrc b
	rrc c

	; dv
	ld a, [de]
	inc de
	rrca
	rrca
	xor b
	ld b, a

	ld a, [de]
	rrca
	rrca
	xor c
	ld c, a

	; if bc < 10:
	;     de = bc + 190
	;     break

	ld a, b
	and a
	jr nz, .no
	ld a, c
	cp 10
	jr nc, .no

	ld hl, 190
	add hl, bc
	ld d, h
	ld e, l
	jr .done

.no

	ld hl, MagikarpLengths
	ld a, 2
	ld [wTempByteValue], a

.read
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	call .BCLessThanDE
	jr nc, .next

	; c = (bc - de) / [hl]
	call .BCMinusDE
	ld a, b
	ldh [hDividend + 0], a
	ld a, c
	ldh [hDividend + 1], a
	ld a, [hl]
	ldh [hDivisor], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 3]
	ld c, a

	; de = c + 100 × (2 + i)
	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, 100
	ldh [hMultiplicand + 2], a
	ld a, [wTempByteValue]
	ldh [hMultiplier], a
	call Multiply
	ldh a, [hProduct + 3]
	add c
	ld e, a
	ldh a, [hProduct + 2]
	adc 0
	ld d, a
	jr .done

.next
	inc hl ; align to next triplet
	ld a, [wTempByteValue]
	inc a
	ld [wTempByteValue], a
	cp 16
	jr c, .read

	call .BCMinusDE
	ld hl, 1600
	add hl, bc
	ld d, h
	ld e, l

.done
	; convert from mm to feet and inches
	; in = mm / 25.4
	; ft = in / 12

	; hl = de × 10
	ld h, d
	ld l, e
	add hl, hl
	add hl, hl
	add hl, de
	add hl, hl

	; hl = hl / 254
	ld de, -254
	ld a, -1
.div_254
	inc a
	add hl, de
	jr c, .div_254

	; d, e = hl / 12, hl % 12
	ld d, 0
.mod_12
	cp 12
	jr c, .ok
	sub 12
	inc d
	jr .mod_12
.ok
	ld e, a

	ld hl, wMagikarpLength
	ld [hl], d ; ft
	inc hl
	ld [hl], e ; in
	ret

.BCLessThanDE:
	ld a, b
	cp d
	ret c
	ret nz
	ld a, c
	cp e
	ret

.BCMinusDE:
; bc -= de
	ld a, c
	sub e
	ld c, a
	ld a, b
	sbc d
	ld b, a
	ret

ApplyMagikarpLengthFilters::
; Make exceptionally large Magikarp rarer, and usually enforce the 3'4"
; minimum at Lake of Rage. Length is stored as feet and inches, so compare
; both bytes instead of treating it as the old millimeter value. Cap retries
; so pathological RNG can never lock LoadEnemyMon forever.
	ld a, 32
.retry
	push af
	ld de, wEnemyMonDVs
	ld bc, wPlayerID
	call CalcMagikarpLength
	ld hl, wMagikarpLength
	ld b, [hl] ; feet
	inc hl
	ld c, [hl] ; inches

; Lengths of 5'4" and above have only a 5% chance to survive this filter.
; A 5'3" Magikarp gets that chance plus a second 20% chance.
	ld a, b
	cp 5
	jr c, .check_area
	call Random
	cp 5 percent
	jr c, .check_area
	ld a, b
	cp 5
	jr nz, .reroll
	ld a, c
	cp 4
	jr nc, .reroll
	call Random
	cp 20 percent - 1
	jr c, .check_area
	ld a, c
	cp 3
	jr nc, .reroll

.check_area
	ld a, [wMapGroup]
	cp GROUP_LAKE_OF_RAGE
	jr nz, .accept
	ld a, [wMapNumber]
	cp MAP_LAKE_OF_RAGE
	jr nz, .accept

; At Lake of Rage, allow any size 40% of the time. Otherwise reject values
; below 3'4", comparing inches as well as feet.
	call Random
	cp 40 percent - 2
	jr c, .accept
	ld a, b
	cp 3
	jr c, .reroll
	jr nz, .accept
	ld a, c
	cp 4
	jr c, .reroll

.accept
	pop af
	ret

.reroll
	pop af
	dec a
	ret z
	push af
	call BattleRandom
	ld b, a
	call BattleRandom
	ld c, a
	ld hl, wEnemyMonDVs
	ld a, b
	ld [hli], a
	ld [hl], c
	pop af
	jr .retry

INCLUDE "data/events/magikarp_lengths.asm"

MagikarpHouseSign:
	ld a, [wBestMagikarpLengthFeet]
	ld [wMagikarpLength], a
	ld a, [wBestMagikarpLengthInches]
	ld [wMagikarpLength + 1], a
	call PrintMagikarpLength
	ld hl, .CurrentRecordtext
	call PrintText
	ret

.CurrentRecordtext:
	; "CURRENT RECORD"
	text_far UnknownText_0x1c123a
	text_end
