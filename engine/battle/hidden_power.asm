HiddenPowerDamage:
; Override Hidden Power's type and power.
; The player's Pokémon use the type chosen at the Hidden Power Guy
; (wHiddenPowerType) with a fixed 70 power. Enemies (and the player
; before choosing a type) fall back to the DV-based formula.

	ldh a, [hBattleTurn]
	and a
	jr nz, .dv_based ; enemy: keep DV-based behavior
	ld a, [wHiddenPowerType]
	and a
	jr z, .dv_based ; no type chosen yet

; Category: bit 7 set = physical, clear = special.
	ld c, a
	ld b, CATEGORIZE_SPECIAL
	bit 7, c
	jr z, .got_category
	ld b, CATEGORIZE_PHYSICAL
.got_category
	ld a, b
	ld [wPlayerMoveStructCategory], a
	ld a, c
	and %01111111 ; low bits hold the type
	ld d, 70
	jr .apply

.dv_based
	ld hl, wBattleMonDVs
	ldh a, [hBattleTurn]
	and a
	jr z, .got_dvs
	ld hl, wEnemyMonDVs
.got_dvs

; Power:

; Take the top bit from each stat

	; Attack
	ld a, [hl]
	swap a
	and %1000

	; Defense
	ld b, a
	ld a, [hli]
	and %1000
	srl a
	or b

	; Speed
	ld b, a
	ld a, [hl]
	swap a
	and %1000
	srl a
	srl a
	or b

	; Special
	ld b, a
	ld a, [hl]
	and %1000
	srl a
	srl a
	srl a
	or b

; Multiply by 5
	ld b, a
	add a
	add a
	add b

; Add Special & 3
	ld b, a
	ld a, [hld]
	and %0011
	add b

; Divide by 2 and add 30 + 1
	srl a
	add 30
	inc a

	ld d, a

; Type:

	; Def & 3
	ld a, [hl]
	and %0011
	ld b, a

	; + (Atk & 3) << 2
	ld a, [hl]
	and %0011 << 4
	swap a
	add a
	add a
	or b

; Skip Normal
	inc a

; Skip Bird
	cp BIRD
	jr c, .done
	inc a

; Skip unused types
	cp UNUSED_TYPES
	jr c, .done
	add SPECIAL - UNUSED_TYPES

.done
.apply
; a = type, d = power

; Overwrite the current move type.
	push af
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	pop af
	ld [hl], a

; Get the rest of the damage formula variables
; based on the new type, but keep base power.
	ld a, d
	push af
	farcall BattleCommand_DamageStats ; damagestats
	pop af
	ld d, a
	ret

GetHiddenPowerDisplayStats::
; Returns the values a move info box should display for Hidden Power:
; b = category, c = type, d = power.
; hl = pointer to the DVs to compute from (wBattleMonDVs in battle,
; wTempMonDVs on the stats screen). Callers outside battle should
; ignore b (it is read from a battle variable).
; Mirrors HiddenPowerDamage above without touching any battle variables.
	ld a, [wHiddenPowerType]
	and a
	jr z, .dv_based

; Type chosen at the Hidden Power Guy: fixed 70 power,
; bit 7 set = physical, clear = special.
	ld b, CATEGORIZE_SPECIAL
	bit 7, a
	jr z, .got_category
	ld b, CATEGORIZE_PHYSICAL
.got_category
	and %01111111 ; low bits hold the type
	ld c, a
	ld d, 70
	ret

.dv_based
; hl already points at the DVs (set by the caller)

; Power: take the top bit from each stat

	; Attack
	ld a, [hl]
	swap a
	and %1000

	; Defense
	ld b, a
	ld a, [hli]
	and %1000
	srl a
	or b

	; Speed
	ld b, a
	ld a, [hl]
	swap a
	and %1000
	srl a
	srl a
	or b

	; Special
	ld b, a
	ld a, [hl]
	and %1000
	srl a
	srl a
	srl a
	or b

; Multiply by 5
	ld b, a
	add a
	add a
	add b

; Add Special & 3
	ld b, a
	ld a, [hld]
	and %0011
	add b

; Divide by 2 and add 30 + 1
	srl a
	add 30
	inc a

	ld d, a

; Type:

	; Def & 3
	ld a, [hl]
	and %0011
	ld b, a

	; + (Atk & 3) << 2
	ld a, [hl]
	and %0011 << 4
	swap a
	add a
	add a
	or b

; Skip Normal
	inc a

; Skip Bird
	cp BIRD
	jr c, .done

	inc a

; Skip unused types
	cp UNUSED_TYPES
	jr c, .done
	add SPECIAL - UNUSED_TYPES

.done
	ld c, a
	ld a, [wPlayerMoveStructCategory]
	ld b, a
	ret

PrintMoveAccuracyPercent::
; Print the displayed accuracy for the move info box at 6, 10.
; Accuracy is stored as "x percent" (0-255 scale); convert back to 0-100.
	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, [wPlayerMoveStructAccuracy]
	ldh [hMultiplicand + 2], a
	ld a, 100
	ldh [hMultiplier], a
	call Multiply
	ldh a, [hProduct + 3]
	add 128 ; round to nearest
	ld d, a
	ldh a, [hProduct + 2]
	adc 0
	ldh [hDividend + 0], a
	ld a, d
	ldh [hDividend + 1], a
	ld a, 255
	ldh [hDivisor], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 3]
	ld [wStringBuffer1], a
	hlcoord 6, 10
	ld de, wStringBuffer1
	lb bc, 1, 3
	jp PrintNum
