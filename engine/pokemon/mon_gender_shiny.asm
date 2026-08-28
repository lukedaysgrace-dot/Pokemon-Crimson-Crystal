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
; TEMPORARY TEST: Assign Pokerus to every new mon.
; de = destination PokerusStatus byte.

	push bc
	push de
	; The normal 5% Random/POKERUS_PROBABILITY check is bypassed so the
	; summary-screen icon can be inspected reliably.
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

	call IsClonePokemon
	jr c, .not_shiny
	; Elm's starters use the shininess that was rolled when the player
	; first looked at them, so the Pokepic and the received mon agree.
	call GetStarterShininess
	jr nc, .roll
	ld b, a
	jr .not_shiny
.roll
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

	call IsClonePokemon
	jr c, .not_shiny
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

IsClonePokemon:
; Return carry if wCurPartySpecies is one of the shiny-locked clone forms.
	ld a, [wCurPartySpecies]
	call GetPokemonIndexFromID

	assert HIGH(BULBASAUR_CLONE) == HIGH(BLASTOISE_CLONE)
	ld a, h
	cp HIGH(BULBASAUR_CLONE)
	jr nz, .not_clone
	ld a, l
	cp LOW(BULBASAUR_CLONE)
	jr c, .not_clone
	cp LOW(BLASTOISE_CLONE) + 1
	jr nc, .not_clone

	scf
	ret

.not_clone
	and a
	ret

NUM_ELM_STARTERS EQU 6

GetStarterShininess::
; If wCurPartySpecies is one of Elm's starters and the player hasn't
; received a starter yet, return carry and a = MON_SHINY_FLAG or 0,
; using the shininess pre-rolled in wStarterShinyFlags (rolling it now
; if this is the first time a starter is looked at).
; Otherwise return no carry.
; Preserves bc, de, hl.
	push hl
	push de
	push bc

	ld de, EVENT_GOT_A_POKEMON_FROM_ELM
	ld b, CHECK_FLAG
	call EventFlagAction
	ld a, c
	and a
	jr nz, .not_starter

	ld a, [wCurPartySpecies]
	call GetPokemonIndexFromID
	ld de, ElmStarterShinyTable
	ld c, 0
.loop
	ld a, [de]
	inc de
	cp l
	jr nz, .skip
	ld a, [de]
	cp h
	jr z, .found
.skip
	inc de
	inc c
	ld a, c
	cp NUM_ELM_STARTERS
	jr c, .loop

.not_starter
	pop bc
	pop de
	pop hl
	and a
	ret

.found
	call RollStarterShininess
	; a = 1 << c
	ld a, 1
	inc c
.shift
	dec c
	jr z, .shifted
	add a
	jr .shift
.shifted
	ld hl, wStarterShinyFlags
	and [hl]
	ld a, 0
	jr z, .done
	ld a, MON_SHINY_FLAG
.done
	pop bc
	pop de
	pop hl
	scf
	ret

RollStarterShininess:
; Roll each starter's shininess once and remember the result.
; Preserves c.
	ld hl, wStarterShinyFlags
	bit 7, [hl]
	ret nz
	push bc
	ld b, NUM_ELM_STARTERS
	ld c, 0
.loop
	; each roll is independent, so which starter lands in which bit
	; doesn't matter; just fill bits 0-5 one at a time
	sla c
	call Random
	cp SHINY_PROBABILITY
	jr nc, .not_shiny
	inc c
.not_shiny
	dec b
	jr nz, .loop
	ld a, c
	or 1 << 7 ; rolled flag
	ld [hl], a
	pop bc
	ret

ElmStarterShinyTable:
; 16-bit species indices, in wStarterShinyFlags bit order
	dw CYNDAQUIL
	dw TOTODILE
	dw CHIKORITA
	dw CHARMANDER
	dw SQUIRTLE
	dw BULBASAUR
	assert (@ - ElmStarterShinyTable) / 2 == NUM_ELM_STARTERS
