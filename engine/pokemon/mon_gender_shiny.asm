RollMonGender:
; Return the gender for wCurPartySpecies using its normal ratio.
; carry: genderless
; a = 1: male
; a = 0: female

	ld a, [wCurPartySpecies]
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	ld hl, BaseData
	ld a, BANK(BaseData)
	call LoadIndirectPointer
	ld bc, BASE_GENDER
	add hl, bc
	call GetFarByte

	cp GENDER_UNKNOWN
	jr z, .Genderless

	and a
	jr z, .Male

	cp GENDER_F100
	jr z, .Female

	ld b, a
	call Random
	cp b
	jr nc, .Male

.Female:
	xor a
	ret

.Male:
	ld a, 1
	and a
	ret

.Genderless:
	scf
	ret

InitMonPokerus:
; Assign a 5% Pokerus infection to a new mon.
; de = destination PokerusStatus byte.

	push bc
	push de
	call Random
	cp POKERUS_PROBABILITY
	jr nc, .no_pokerus
.randomPokerusLoop
	call Random
	and a
	jr z, .randomPokerusLoop
	ld b, a
	and $f0
	jr z, .load_pkrs
	ld a, b
	and $7
	inc a
.load_pkrs
	ld b, a
	swap b
	and $3
	inc a
	add b
	ld [de], a
	jr .done
.no_pokerus
	xor a
	ld [de], a
.done
	pop de
	pop bc
	ret

InitMonShinyGender:
; Assign a 10% shiny chance and species gender ratio.
; de = destination shiny/gender flags byte.

	push bc
	push de
	xor a
	ld b, a

	call Random
	cp SHINY_PROBABILITY
	jr nc, .not_shiny
	ld a, MON_SHINY_FLAG
	ld b, a
.not_shiny

	call RollMonGender
	jr c, .genderless
	and a
	jr z, .female
	ld a, b
	or MON_MALE_FLAG
	ld b, a
.female
.genderless
	pop de
	ld a, b
	ld [de], a
	pop bc
	ret

InitWildMonShinyGender:
; Roll shiny/gender for a wild battle mon into wEnemyMonShinyGenderFlags.

	push bc
	xor a
	ld b, a

	call BattleRandom
	cp SHINY_PROBABILITY
	jr nc, .not_shiny
	ld a, MON_SHINY_FLAG
	ld b, a
.not_shiny

	call RollMonGender
	jr c, .done
	and a
	jr z, .done
	ld a, b
	or MON_MALE_FLAG
	ld b, a
.done
	ld a, b
	ld [wEnemyMonShinyGenderFlags], a
	pop bc
	ret
