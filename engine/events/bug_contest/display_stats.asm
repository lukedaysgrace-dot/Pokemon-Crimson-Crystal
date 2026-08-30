DisplayCaughtContestMonStats:
	call ClearBGPalettes
	call ClearTileMap
	call ClearSprites
	call LoadFontsBattleExtra

	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]

	hlcoord 0, 0
	ld b, 4
	ld c, 13
	call Textbox

	hlcoord 0, 6
	ld b, 4
	ld c, 13
	call Textbox

	hlcoord 2, 0
	ld de, .Stock
	call PlaceString

	hlcoord 2, 6
	ld de, .This
	call PlaceString

	hlcoord 2, 4
	ld de, .Size
	call PlaceString

	hlcoord 2, 10
	ld de, .Size
	call PlaceString

	ld a, [wContestMon]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld de, wStringBuffer1
	hlcoord 1, 2
	call PlaceString

	ld h, b
	ld l, c
	ld a, [wContestMonLevel]
	ld [wTempMonLevel], a
	call PrintLevel

	ld de, wEnemyMonNick
	hlcoord 1, 8
	call PlaceString

	ld h, b
	ld l, c
	ld a, [wEnemyMonLevel]
	ld [wTempMonLevel], a
	call PrintLevel

	; Max HP used to sit here, back when ContestScore paid for a full-HP
	; catch. It doesn't any more, so show the thing that actually scores:
	; how well grown each mon is for its own species.
	ld a, [wContestMon]
	ld b, a
	ld a, [wContestMonLevel]
	ld c, a
	farcall GetContestMonLevelPercent
	call .SizeRating
	hlcoord 7, 4
	call PlaceString

	ld a, [wEnemyMonSpecies]
	ld b, a
	ld a, [wEnemyMonLevel]
	ld c, a
	farcall GetContestMonLevelPercent
	call .SizeRating
	hlcoord 7, 10
	call PlaceString

	ld hl, SwitchMonText
	call PrintText

	pop af
	ld [wOptions], a

	call WaitBGMap
	ld b, SCGB_DIPLOMA
	call GetSGBLayout
	call SetPalettes
	ret

.SizeRating:
; in:  a  = 0-150, from GetContestMonLevelPercent
; out: de = what the judges would call a mon that size
	ld de, .Runt
	cp 30
	ret c
	ld de, .Small
	cp 60
	ret c
	ld de, .Average
	cp 90
	ret c
	ld de, .Big
	cp 120
	ret c
	ld de, .Giant
	ret

.Size:
	db "SIZE@"
.Runt:
	db "RUNT   @"
.Small:
	db "SMALL  @"
.Average:
	db "AVERAGE@"
.Big:
	db "BIG    @"
.Giant:
	db "GIANT  @"
.Stock:
	db " STOCK <PKMN> @"
.This:
	db " THIS <PKMN>  @"

SwitchMonText:
	; Switch #MON?
	text_far UnknownText_0x1c10cf
	text_end

DisplayAlreadyCaughtText:
	call GetPokemonName
	ld hl, .AlreadyCaughtText
	jp PrintText

.AlreadyCaughtText:
	; You already caught a @ .
	text_far UnknownText_0x1c10dd
	text_end

DummyPredef2F:
DummyPredef38:
DummyPredef39:
	ret
