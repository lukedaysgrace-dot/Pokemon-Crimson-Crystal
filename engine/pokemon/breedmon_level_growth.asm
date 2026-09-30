GetBreedMon1LevelGrowth:
	ld hl, wBreedMon1Stats
	ld de, wTempMon
	ld bc, BOXMON_STRUCT_LENGTH
	call CopyBytes
	callfar CalcLevel
	ld a, [wBreedMon1Level]
	ld b, a
	ld a, d
	; CalcLevel clamps to the Hard mode level cap: never lower a mon that
	; was deposited above the cap (or report negative growth)
	cp b
	jr nc, .level_ok1
	ld a, b
.level_ok1
	ld e, a
	sub b
	ld d, a
	ret

GetBreedMon2LevelGrowth:
	ld hl, wBreedMon2Stats
	ld de, wTempMon
	ld bc, BOXMON_STRUCT_LENGTH
	call CopyBytes
	callfar CalcLevel
	ld a, [wBreedMon2Level]
	ld b, a
	ld a, d
	; CalcLevel clamps to the Hard mode level cap: never lower a mon that
	; was deposited above the cap (or report negative growth)
	cp b
	jr nc, .level_ok2
	ld a, b
.level_ok2
	ld e, a
	sub b
	ld d, a
	ret
