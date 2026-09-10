; Per-save Pokemon rules selected when starting a new game.
; The ROM's base-data files remain the updated ruleset. These routines replace
; types for either selection and replace stats only for the original selection.

_GetBaseData::
	push bc
	push de
	push hl

; Egg doesn't have BaseData.
	ld a, [wCurSpecies]
	cp EGG
	jr z, .egg

; Get BaseData.
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	ld a, BANK(BaseData)
	ld hl, BaseData
	call LoadIndirectPointer
	; jr z, <some error handler>
	ld de, wCurBaseData
	ld bc, BASE_DATA_SIZE
	call FarCopyBytes
	jr .loaded

.egg
	ld de, UnknownEggPic
	ld b, $55 ; 5x5
	ld hl, wBasePicSize
	ld [hl], b
	ld hl, wBasePadding
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, [wCurSpecies]
	ld [wBaseSpecies], a
	jr .done

.loaded
; Replace Pokedex number with the runtime species ID, then apply this save's
; selected type/stat rules.
	ld a, [wCurSpecies]
	ld [wBaseSpecies], a
	call ApplyGameplayRulesToBaseData

.done
	pop hl
	pop de
	pop bc
	ret

ApplyGameplayRulesToBaseData::
	push bc
	push de
	push hl

	ld a, [wCurSpecies]
	call GetPokemonIndexFromID
	ld b, h
	ld c, l

	call GetGameplayTypesByIndex
	ld a, l
	ld [wBaseType1], a
	ld a, h
	ld [wBaseType2], a

	ld a, [wGameplayRules]
	bit GAMEPLAYRULES_ORIGINAL_STATS_F, a
	jr z, .done
	ld a, BANK(OriginalPokemonStats)
	ld hl, OriginalPokemonStats
	call CopyGameplayStatsFromTable

.done
	pop hl
	pop de
	pop bc
	ret

; in: a = runtime species ID
SetEnemyGameplayTypesBySpecies::
	call GetPokemonIndexFromID
	ld b, h
	ld c, l
	call GetGameplayTypesByIndex
	ld a, l
	ld [wEnemyMonType1], a
	ld a, h
	ld [wEnemyMonType2], a
	ret

; in: bc = true 16-bit Pokemon index
; out: l = type 1, h = type 2
GetGameplayTypesByIndex::
	push de
	push bc
	ld a, BANK(BaseData)
	ld hl, BaseData
	call LoadIndirectPointer
	jr z, .missing
	ld bc, BASE_TYPES
	add hl, bc
	call GetFarHalfword
	pop bc
	jr .apply_rules

.missing
	pop bc
	ld hl, 0

.apply_rules
	ld a, [wGameplayRules]
	bit GAMEPLAYRULES_ORIGINAL_TYPES_F, a
	ld de, RevampedPokemonTypes
	jr z, .got_table
	ld de, OriginalPokemonTypes

.got_table
	call ReplaceGameplayTypePair
	pop de
	ret

; in: bc = true 16-bit Pokemon index, de = type table, hl = fallback types
; out: l = type 1, h = type 2
ReplaceGameplayTypePair:
	push de
	push hl
	ld h, d
	ld l, e

.loop
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	or e
	jr z, .not_found
	ld a, c
	cp e
	jr nz, .next
	ld a, b
	cp d
	jr z, .found

.next
	inc hl
	inc hl
	jr .loop

.found
	pop af ; discard the fallback type pair
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jr .done

.not_found
	pop hl

.done
	pop de
	ret

; in: a:hl = stats table, bc = true 16-bit Pokemon index
CopyGameplayStatsFromTable:
.loop
	push af
	call GetFarByte
	ld e, a
	pop af
	inc hl
	push af
	call GetFarByte
	ld d, a
	or e
	jr z, .done
	pop af
	inc hl
	push af
	ld a, c
	cp e
	jr nz, .next
	ld a, b
	cp d
	jr z, .found

.next
	pop af
	ld de, 6
	add hl, de
	jr .loop

.found
	pop af
	ld de, wBaseStats
	ld bc, 6
	jp FarCopyBytes

.done
	pop af
	ret

OriginalPokemonTypes:
	dw ALTARIA
	db DRAGON, FLYING
	dw AMPHAROS
	db ELECTRIC, ELECTRIC
	dw ARON
	db STEEL, ROCK
	dw BANETTE
	db GHOST, GHOST
	dw BELLOSSOM
	db GRASS, GRASS
	dw BLASTOISE
	db WATER, WATER
	dw CHARIZARD
	db FIRE, FLYING
	dw CROCONAW
	db WATER, WATER
	dw DRUNSPARCE
	db NORMAL, NORMAL
	dw DUNSPARCE
	db NORMAL, NORMAL
	dw ELECTIVIRE
	db ELECTRIC, ELECTRIC
	dw FERALIGATR
	db WATER, WATER
	dw FLYGON
	db GROUND, DRAGON
	dw GOLDUCK
	db WATER, WATER
	dw LAIRON
	db STEEL, ROCK
	dw LEDIAN
	db BUG, FLYING
	dw LEDYBA
	db BUG, FLYING
	dw LOPUNNY
	db NORMAL, NORMAL
	dw MEGANIUM
	db GRASS, GRASS
	dw MILOTIC
	db WATER, WATER
	dw MISDREAVUS
	db GHOST, GHOST
	dw MISMAGIUS
	db GHOST, GHOST
	dw NINETALES
	db FIRE, FIRE
	dw NOCTOWL
	db NORMAL, FLYING
	dw PALAFIN
	db WATER, WATER
	dw PONYTA_GALARIAN
	db PSYCHIC, PSYCHIC
	dw RAPIDASH_GALARIAN
	db PSYCHIC, FAIRY
	dw SEVIPER
	db POISON, POISON
	dw SIRFETCH_D
	db FIGHTING, FIGHTING
	dw SWABLU
	db NORMAL, FLYING
	dw TRAPINCH
	db GROUND, GROUND
	dw URSARING
	db NORMAL, NORMAL
	dw VIBRAVA
	db GROUND, DRAGON
	dw 0

RevampedPokemonTypes:
	dw ALTARIA
	db DRAGON, FAIRY
	dw AMPHAROS
	db ELECTRIC, DRAGON
	dw ARON
	db STEEL, STEEL
	dw BANETTE
	db GHOST, NORMAL
	dw BLASTOISE
	db WATER, STEEL
	dw CHARIZARD
	db FIRE, DRAGON
	dw CROCONAW
	db WATER, DARK
	dw DUNSPARCE
	db NORMAL, DRAGON
	dw ELECTIVIRE
	db ELECTRIC, FIGHTING
	dw FARFETCH_D
	db NORMAL, FLYING
	dw FERALIGATR
	db WATER, DARK
	dw FLYGON
	db BUG, DRAGON
	dw GOLDUCK
	db WATER, PSYCHIC
	dw LAIRON
	db STEEL, STEEL
	dw LEDIAN
	db BUG, FIGHTING
	dw LEDYBA
	db BUG, FIGHTING
	dw LOPUNNY
	db NORMAL, FIGHTING
	dw MEGANIUM
	db GRASS, FAIRY
	dw MILOTIC
	db WATER, FAIRY
	dw MISDREAVUS
	db GHOST, FAIRY
	dw MISMAGIUS
	db GHOST, FAIRY
	dw NINETALES
	db FIRE, FAIRY
	dw NOCTOWL
	db PSYCHIC, FLYING
	dw PALAFIN
	db WATER, FIGHTING
	dw PONYTA_GALARIAN
	db FAIRY, FAIRY
	dw RAPIDASH_GALARIAN
	db FAIRY, FIRE
	dw SEVIPER
	db POISON, DARK
	dw SWABLU
	db FAIRY, FLYING
	dw TRAPINCH
	db BUG, GROUND
	dw URSARING
	db GROUND, NORMAL
	dw VIBRAVA
	db BUG, DRAGON
	dw 0
