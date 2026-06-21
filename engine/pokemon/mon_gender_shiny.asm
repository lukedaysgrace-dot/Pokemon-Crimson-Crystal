RollMonGender:
; Return the gender for wCurPartySpecies using its normal ratio.
; carry: genderless
; a = 1: male
; a = 0: female

	push bc
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBaseGender]

	cp GENDER_UNKNOWN
	jr z, .Genderless

	and a
	jr z, .Male

	cp GENDER_F100
	jr z, .Female

; All other gendered species use a flat 50/50 ratio.
	call Random
	rrc a
	jr c, .Male

.Female:
	xor a
	pop bc
	ret

.Male:
	ld a, 1
	and a
	pop bc
	ret

.Genderless:
	scf
	pop bc
	ret

GetGenderFromFlags:
; Return gender from wBaseGender and a mon's shiny/gender flags byte in b.
; carry: genderless
; a = 1: male
; a = 0: female

	ld a, [wBaseGender]
	cp GENDER_UNKNOWN
	jr z, .Genderless

	and a
	jr z, .Male

	cp GENDER_F100
	jr z, .Female

	ld a, b
	and MON_MALE_FLAG
	jr nz, .Male

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
; Trainer Pokemon cannot be shiny. Their gender matches their trainer unless
; their species is fixed-gender or genderless.
; de = destination shiny/gender flags byte.

	push bc
	push de
	xor a
	ld b, a
	ld a, [wMonType]
	and $f
	jr nz, .trainer

	call Random
	cp SHINY_PROBABILITY
	jr nc, .not_shiny
	ld a, MON_SHINY_FLAG
	ld b, a
.not_shiny

	call RollMonGender
	jr c, .store
	and a
	jr z, .store
	ld a, b
	or MON_MALE_FLAG
	ld b, a
	jr .store

.trainer
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBaseGender]
	cp GENDER_UNKNOWN
	jr z, .store
	and a
	jr z, .male
	cp GENDER_F100
	jr z, .store

	ld a, [wOtherTrainerClass]
	dec a
	ld c, a
	ld b, 0
	ld hl, BTTrainerClassGenders
	add hl, bc
	ld a, BANK(BTTrainerClassGenders)
	call GetFarByte
	and a
	jr nz, .store
.male
	ld b, MON_MALE_FLAG
.store
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
