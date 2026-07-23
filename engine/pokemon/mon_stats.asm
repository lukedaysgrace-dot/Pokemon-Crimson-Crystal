DrawPlayerHP:
	ld a, $1
	jr DrawHP

DrawEnemyHP:
	ld a, $2

DrawHP:
	ld [wWhichHPBar], a
	push hl
	push bc
	; box mons have full HP
	ld a, [wMonType]
	cp BOXMON
	jr z, .at_least_1_hp

	ld a, [wTempMonHP]
	ld b, a
	ld a, [wTempMonHP + 1]
	ld c, a

; Any HP?
	or b
	jr nz, .at_least_1_hp

	xor a
	ld c, a
	ld e, a
	ld a, 6
	ld d, a
	jp .fainted

.at_least_1_hp
	ld a, [wTempMonMaxHP]
	ld d, a
	ld a, [wTempMonMaxHP + 1]
	ld e, a
	ld a, [wMonType]
	cp BOXMON
	jr nz, .not_boxmon

	ld b, d
	ld c, e

.not_boxmon
	predef ComputeHPBarPixels
	ld a, 6
	ld d, a
	ld c, a

.fainted
	ld a, c
	pop bc
	ld c, a
	pop hl
	push de
	push hl
	push hl
	call DrawBattleHPBar
	pop hl

; Print HP
	bccoord 1, 1, 0
	add hl, bc
	ld de, wTempMonHP
	ld a, [wMonType]
	cp BOXMON
	jr nz, .not_boxmon_2
	ld de, wTempMonMaxHP
.not_boxmon_2
	lb bc, 2, 3
	call PrintNum

	ld a, "/"
	ld [hli], a

; Print max HP
	ld de, wTempMonMaxHP
	lb bc, 2, 3
	call PrintNum
	pop hl
	pop de
	ret

PrintTempMonStats:
; Print wTempMon's stats at hl, with spacing bc.
	push bc
	push hl
	ld de, .StatNames
	call PlaceString
	pop hl
	pop bc
	add hl, bc
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld de, wTempMonAttack
	lb bc, 2, 3
	call .PrintStat
	ld de, wTempMonDefense
	call .PrintStat
	ld de, wTempMonSpclAtk
	call .PrintStat
	ld de, wTempMonSpclDef
	call .PrintStat
	ld de, wTempMonSpeed
	jp PrintNum

.PrintStat:
	push hl
	call PrintNum
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

.StatNames:
	db   "ATTACK"
	next "DEFENSE"
	next "SPCL.ATK"
	next "SPCL.DEF"
	next "SPEED"
	next "@"

PrintStatDifferences:
; Level-up stat display, ported from Polished Crystal.
; Shows two screens in a self-sizing box:
;   1. old stat value with the "+gain" it just earned (e.g. "21+2")
;   2. the new combined totals (e.g. "23")
; Expects the pre-level-up stats (MaxHP, Atk, Def, Speed, SpclAtk, SpclDef,
; big-endian, 12 bytes) already copied into wStringBuffer3, and the freshly
; recalculated stats in wTempMon (via CopyMonToTempMon).

	; Figure out the length of the largest modifier (+x, +xx or +xxx) so the
	; box can be widened to fit it.
	ld hl, wStringBuffer3
	lb bc, 1, 6
.digit_loop
	call .ComputeStatDifference
	inc hl
	inc hl
	ld a, [wStringBuffer3 + 12]
	and a
	ld a, [wStringBuffer3 + 13]
	ld d, 4
	jr nz, .got_digit_length
	cp 100
	jr nc, .got_digit_length
	dec d
	cp 10
	jr nc, .got_digit_length
	dec d
.got_digit_length
	ld a, b
	cp d
	jr nc, .digit_length_not_larger
	ld b, d
.digit_length_not_larger
	dec c
	jr nz, .digit_loop

	ld a, b
	ld [wStringBuffer3 + 14], a

	; Screen 1: old stat + gain.
	ld de, wStringBuffer3
	ld b, 1 ; show stat+difference
	call .PrintStatDisplay
	ld c, 30
	call DelayFrames
	call WaitPressAorB_BlinkCursor

	; Screen 2: new totals.
	ld de, wTempMonMaxHP
	ld b, 0 ; just show stat
	call .PrintStatDisplay
	ld c, 30
	call DelayFrames
	jp WaitPressAorB_BlinkCursor

.ComputeStatDifference:
; hl points at the old stat in wStringBuffer3. Computes (new - old) and stores
; the result big-endian in wStringBuffer3 + 12. hl is preserved.
	push de
	push bc
	ld a, [hli]
	cpl
	ld d, a
	ld a, [hld]
	cpl
	inc a
	jr nz, .dont_inc_d
	inc d
.dont_inc_d
	ld e, a
	ld bc, wTempMonMaxHP - wStringBuffer3
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hld]
	ld c, a
	push bc
	ld bc, wStringBuffer3 - wTempMonMaxHP
	add hl, bc
	pop bc
	push hl
	ld h, b
	ld l, c
	add hl, de
	ld a, h
	ld [wStringBuffer3 + 12], a
	ld a, l
	ld [wStringBuffer3 + 13], a
	pop hl
	pop bc
	pop de
	ret

.PrintStatDisplay:
	push de
	push bc
	call .PrintStatNames
	ld bc, 9
	add hl, bc
	pop bc
	pop de
	jp .PrintStats

.PrintStatNames:
; Draws the box and places the six stat names single-spaced, returning hl at the
; top-left name coordinate.
	ld a, [wStringBuffer3 + 14]
	push af
	hlcoord 6, 4
.coord_loop
	dec hl
	dec a
	jr nz, .coord_loop
	pop af
	push af
	lb bc, 6, 12
	add c
	ld c, a
	call Textbox
	pop af
	hlcoord 7, 5
.coord_loop2
	dec hl
	dec a
	jr nz, .coord_loop2
	push hl
	ld de, .DiffStatNames
	ld b, 6
.name_loop
	push bc
	push hl
	call PlaceString
	inc de
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .name_loop
	pop hl
	ret

.DiffStatNames:
	db "Health@"
	db "Attack@"
	db "Defense@"
	db "Sp.Atk@"
	db "Sp.Def@"
	db "Speed@"

.PrintStats:
	; Screen movement is done because the internal stat order differs from the
	; order we want to display.
	; Printing: HP, Atk, Def, SAtk, SDef, Speed
	; Internal: HP, Atk, Def, Speed, SAtk, SDef
	call .PrintStat ; HP
	call .PrintStat ; Attack
	call .PrintStat ; Defense

	push bc
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	pop bc
	call .PrintStat ; Speed

	push bc
	ld bc, -SCREEN_WIDTH * 3
	add hl, bc
	pop bc
	call .PrintStat ; Sp.Atk
.PrintStat: ; falls through for Sp.Def
	push bc
	push hl
	push de
	ld a, b
	lb bc, 2, 3
	push af
	call PrintNum
	pop af
	and a
	jr z, .mod_done
	pop hl
	call .ComputeStatDifference
	ld d, h
	ld e, l
	pop hl
	push hl
	inc hl
	inc hl
	inc hl
	ld a, "+"
	ld [hli], a

	push de
	ld a, [wStringBuffer3 + 14]
	dec a ; field width = modifier length - 1
	cp 2
	jr c, .single_digit
	; two- or three-digit gain: right-align it with PrintNum
	ld b, 2
	ld c, a
	ld de, wStringBuffer3 + 12
	call PrintNum
	jr .mod_done
.single_digit
	; PrintNum can't print a single digit, so place it directly.
	ld a, [wStringBuffer3 + 13]
	add "0"
	ld [hl], a
.mod_done
	pop de
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc de
	inc de
	pop bc
	ret

GetGender:
; Return the gender of a given monster (wCurPartyMon/wCurOTMon/wCurWildMon).
; When calling this function, a should be set to an appropriate wMonType value.

; return values:
; a = 1: f = nc|nz; male
; a = 0: f = nc|z;  female
;        f = c:  genderless

; Gender is stored in the mon's shiny/gender flags byte (MON_MALE_FLAG),
; assigned randomly when the mon is created.

; Figure out what type of monster struct we're looking at.

	ld a, [wMonType]
	cp WILDMON
	jr z, .WildMon

; 0: PartyMon
	ld hl, wPartyMon1DVs
	ld bc, PARTYMON_STRUCT_LENGTH
	and a
	jr z, .PartyMon

; 1: OTPartyMon
	ld hl, wOTPartyMon1DVs
	dec a
	jr z, .PartyMon

; 2: sBoxMon
	ld hl, sBoxMon1DVs
	ld bc, BOXMON_STRUCT_LENGTH
	dec a
	jr z, .sBoxMon

; 3: TempMon
	ld hl, wTempMonDVs
	dec a
	jr z, .TempMon

; Unknown mon type; treat as genderless.
	scf
	ret

.WildMon:
	ld a, [wEnemyMonShinyGenderFlags]
	ld b, a
	jr .SpeciesRatio

; Get our place in the party/box.

.PartyMon:
	ld a, [wCurPartyMon]
	call AddNTimes
	ld bc, MON_SHINY_GENDER_OFFSET_FROM_DVS
	jr .LoadShinyGenderByte

.sBoxMon
	ld a, [wCurPartyMon]
	call AddNTimes
	ld bc, PKRUS_OFFSET_FROM_DVS
	jr .LoadShinyGenderByte

.TempMon:
	ld bc, MON_SHINY_GENDER_OFFSET_FROM_DVS

.LoadShinyGenderByte:
	add hl, bc

; sBoxMon data is read directly from SRAM.
	ld a, [wMonType]
	cp BOXMON
	ld a, BANK(sBox)
	call z, GetSRAMBank

	ld a, [hl]

; Close SRAM if we were dealing with a sBoxMon.
	push af
	ld a, [wMonType]
	cp BOXMON
	call z, CloseSRAM
	pop af
	ld b, a

.SpeciesRatio:
	push bc
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBaseGender]
	ld d, a
	pop bc

	ld a, d
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

ListMovePP:
	ld a, [wNumMoves]
	inc a
	ld c, a
	ld a, NUM_MOVES
	sub c
	ld b, a
	push hl
	ld a, [wBuffer1]
	ld e, a
	ld d, $0
	ld a, $3e ; P
	call .load_loop
	ld a, b
	and a
	jr z, .skip
	ld c, a
	ld a, "-"
	call .load_loop

.skip
	pop hl
	inc hl
	inc hl
	inc hl
	ld d, h
	ld e, l
	ld hl, wTempMonMoves
	ld b, 0
.loop
	ld a, [hli]
	and a
	jr z, .done
	push bc
	push hl
	push de
	ld hl, wMenuCursorY
	ld a, [hl]
	push af
	ld [hl], b
	push hl
	callfar GetMaxPPOfMove
	pop hl
	pop af
	ld [hl], a
	pop de
	pop hl
	push hl
	ld bc, wTempMonPP - (wTempMonMoves + 1)
	add hl, bc
	ld a, [hl]
	and $3f
	ld [wStringBuffer1 + 4], a
	ld h, d
	ld l, e
	push hl
	ld de, wStringBuffer1 + 4
	lb bc, 1, 2
	call PrintNum
	ld a, "/"
	ld [hli], a
	ld de, wTempPP
	lb bc, 1, 2
	call PrintNum
	pop hl
	ld a, [wBuffer1]
	ld e, a
	ld d, 0
	add hl, de
	ld d, h
	ld e, l
	pop hl
	pop bc
	inc b
	ld a, b
	cp NUM_MOVES
	jr nz, .loop

.done
	ret

.load_loop
	ld [hli], a
	ld [hld], a
	add hl, de
	dec c
	jr nz, .load_loop
	ret

Unreferenced_Function50cd0:
.loop
	ld [hl], $32
	inc hl
	ld [hl], $3e
	dec hl
	add hl, de
	dec c
	jr nz, .loop
	ret

Unused_PlaceEnemyHPLevel:
	push hl
	push hl
	ld hl, wPartyMonNicknames
	ld a, [wCurPartyMon]
	call GetNick
	pop hl
	call PlaceString
	call CopyMonToTempMon
	pop hl
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	push hl
	ld bc, -12
	add hl, bc
	ld b, $0
	call DrawEnemyHP
	pop hl
	ld bc, 5
	add hl, bc
	push de
	call PrintLevel
	pop de

.egg
	ret

PlaceStatusString:
	push de
	inc de
	inc de
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	or b
	pop de
	jr nz, PlaceNonFaintStatus
	push de
	ld de, FntString
	call CopyStatusString
	pop de
	ld a, $1
	and a
	ret

FntString:
	db "FNT@"

CopyStatusString:
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ret

PlaceNonFaintStatus:
	push de
	ld a, [de]
	ld de, PsnString
	bit PSN, a
	jr nz, .place
	ld de, BrnString
	bit BRN, a
	jr nz, .place
	ld de, FrzString
	bit FRZ, a
	jr nz, .place
	ld de, ParString
	bit PAR, a
	jr nz, .place
	ld de, SlpString
	and SLP
	jr z, .no_status

.place
	call CopyStatusString
	ld a, $1
	and a

.no_status
	pop de
	ret

SlpString: db "SLP@"
PsnString: db "PSN@"
BrnString: db "BRN@"
FrzString: db "FSB@"
ParString: db "PAR@"

ListMoves:
; List moves at hl, spaced every [wBuffer1] tiles.
	ld de, wListMoves_MoveIndicesBuffer
	ld b, $0
.moves_loop
	ld a, [de]
	inc de
	and a
	jr z, .no_more_moves
	push de
	push hl
	push hl
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	ld de, wStringBuffer1
	pop hl
	push bc
	call PlaceString
	pop bc
	ld a, b
	ld [wNumMoves], a
	inc b
	pop hl
	push bc
	ld a, [wBuffer1]
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	pop de
	ld a, b
	cp NUM_MOVES
	jr z, .done
	jr .moves_loop

.no_more_moves
	ld a, b
.nonmove_loop
	push af
	ld [hl], "-"
	ld a, [wBuffer1]
	ld c, a
	ld b, 0
	add hl, bc
	pop af
	inc a
	cp NUM_MOVES
	jr nz, .nonmove_loop

.done
	ret
