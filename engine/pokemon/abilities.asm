SECTION "Abilities", ROMX

GetAbilityName::
; in: b = ability constant
; out: ability name copied to wStringBuffer1
; wStringBuffer1 lives in banked WRAM ($D000+). Select its bank only for the
; copy, then restore rSVBK so battle text (<USER>, etc.) still reads WRAM0.
	push hl
	push de
	push bc
	ldh a, [rSVBK]
	push af
	ld a, BANK(wStringBuffer1)
	ldh [rSVBK], a
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
	pop af
	ldh [rSVBK], a
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
