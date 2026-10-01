; Moved out of the full Battle Core bank.

ReadAndPrintLinkBattleRecord::
	call ClearTileMap
	call ClearSprites
	call .PrintBattleRecord
	hlcoord 0, 8
	ld b, 5
	ld de, sLinkBattleRecord + 2
.loop
	push bc
	push hl
	push de
	ld a, [de]
	and a
	jr z, .PrintFormatString
	ld a, [wSavedAtLeastOnce]
	and a
	jr z, .PrintFormatString
	push hl
	push hl
	ld h, d
	ld l, e
	ld de, wd002
	ld bc, 10
	call CopyBytes
	ld a, "@"
	ld [de], a
	inc de
	ld bc, 6
	call CopyBytes
	ld de, wd002
	pop hl
	call PlaceString
	pop hl
	ld de, 26
	add hl, de
	push hl
	ld de, wd00d
	lb bc, 2, 4
	call PrintNum
	pop hl
	ld de, 5
	add hl, de
	push hl
	ld de, wd00f
	lb bc, 2, 4
	call PrintNum
	pop hl
	ld de, 5
	add hl, de
	ld de, wd011
	lb bc, 2, 4
	call PrintNum
	jr .next

.PrintFormatString:
	ld de, .Format
	call PlaceString
.next
	pop hl
	ld bc, 18
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
	ret

.PrintBattleRecord:
	hlcoord 1, 0
	ld de, .Record
	call PlaceString

	hlcoord 0, 6
	ld de, .Result
	call PlaceString

	hlcoord 0, 2
	ld de, .Total
	call PlaceString

	hlcoord 6, 4
	ld de, sLinkBattleWins
	call .PrintZerosIfNoSaveFileExists
	jr c, .quit

	lb bc, 2, 4
	call PrintNum

	hlcoord 11, 4
	ld de, sLinkBattleLosses
	call .PrintZerosIfNoSaveFileExists

	lb bc, 2, 4
	call PrintNum

	hlcoord 16, 4
	ld de, sLinkBattleDraws
	call .PrintZerosIfNoSaveFileExists

	lb bc, 2, 4
	call PrintNum

.quit
	ret

.PrintZerosIfNoSaveFileExists:
	ld a, [wSavedAtLeastOnce]
	and a
	ret nz
	ld de, .Scores
	call PlaceString
	scf
	ret

.Scores:
	db "   0    0    0@"

.Format:
	db "  ---  <LF>"
	db "         -    -    -@"
.Record:
	db "<PLAYER>'s RECORD@"
.Result:
	db "RESULT WIN LOSE DRAW@"
.Total:
	db "TOTAL  WIN LOSE DRAW@"
