SECTION "Abilities", ROMX

GetAbilityName::
; in: b = ability constant
; out: ability name copied to wStringBuffer1
	push hl
	push de
	push bc
	ld hl, AbilityNames
	ld a, b
	and a
	jr z, .found
	ld c, a
.next_name
	ld a, [hli]
	cp "@"
	jr nz, .next_name
	dec c
	jr nz, .next_name
.found
	ld de, wStringBuffer1
.copy
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .copy
	pop bc
	pop de
	pop hl
	ret

PlaceAbilityNameStats::
; Print wTempMon's ability name at 8,9 for the stats screen green page.
	ld a, [wTempMonPersonality]
	ld b, a
	ld a, [wTempMonSpecies]
	ld c, a
	call GetAbility
	call GetAbilityName
	ld de, wStringBuffer1
	hlcoord 8, 9
	jp PlaceString

INCLUDE "data/abilities/names.asm"

INCLUDE "engine/battle/ability_gfx.asm"
