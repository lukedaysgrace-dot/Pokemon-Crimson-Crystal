MAP_NAME_SIGN_START EQU $c0
MAP_NAME_SIGN_TILES EQU 8

ReturnFromMapSetupScript::
	xor a
	ldh [hBGMapMode], a
	farcall .inefficient_farcall ; this is a waste of 6 ROM bytes and 6 stack bytes
	ret

; should have just been a fallthrough
.inefficient_farcall
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetWorldMapLocation
	ld [wCurLandmark], a
	call .CheckNationalParkGate
	jr z, .nationalparkgate

	call GetMapEnvironment
	cp GATE
	jr nz, .not_gate

.nationalparkgate
	ld a, -1
	ld [wCurLandmark], a

.not_gate
	ld hl, wEnteredMapFromContinue
	bit 1, [hl]
	res 1, [hl]
	jr nz, .dont_do_map_sign

	call .CheckMovingWithinLandmark
	jr z, .dont_do_map_sign
	ld a, [wCurLandmark]
	ld [wPrevLandmark], a

	call .CheckSpecialMap
	jr z, .dont_do_map_sign

; Display for 60 frames
	ld a, 60
	ld [wLandmarkSignTimer], a
	call LoadMapNameSignGFX
	call InitMapNameFrame
	farcall HDMATransfer_OnlyTopFourRows
	ret

.dont_do_map_sign
	ld a, [wCurLandmark]
	ld [wPrevLandmark], a
	ld a, $90
	ldh [rWY], a
	ldh [hWY], a
	xor a
	ldh [hLCDCPointer], a
	ret

.CheckMovingWithinLandmark:
	ld a, [wCurLandmark]
	ld c, a
	ld a, [wPrevLandmark]
	cp c
	ret z
	cp SPECIAL_MAP
	ret

.CheckSpecialMap:
; These landmarks do not get pop-up signs.
	cp -1
	ret z
	cp SPECIAL_MAP
	ret z
	cp RADIO_TOWER
	ret z
	cp LAV_RADIO_TOWER
	ret z
	cp UNDERGROUND_PATH
	ret z
	cp INDIGO_PLATEAU
	ret z
	cp POWER_PLANT
	ret z
	ld a, 1
	and a
	ret

.CheckNationalParkGate:
	ld a, [wMapGroup]
	cp GROUP_ROUTE_35_NATIONAL_PARK_GATE
	ret nz
	ld a, [wMapNumber]
	cp MAP_ROUTE_35_NATIONAL_PARK_GATE
	ret z
	cp MAP_ROUTE_36_NATIONAL_PARK_GATE
	ret

PlaceMapNameSign::
	ld hl, wLandmarkSignTimer
	ld a, [hl]
	and a
	jr z, .disappear
	dec [hl]
	cp 60
	ret z
	cp 59
	jr nz, .skip2
	call InitMapNameFrame
	call PlaceMapNameCenterAlign
	farcall HDMATransfer_OnlyTopFourRows
.skip2
	ld a, SCREEN_HEIGHT_PX - 3 * TILE_WIDTH
	ldh [rWY], a
	ldh [hWY], a
	ret

.disappear
	ld a, $90
	ldh [rWY], a
	ldh [hWY], a
	xor a
	ldh [hLCDCPointer], a
	ret

LoadMapNameSignGFX:
	ld a, [wSign]
	ld hl, MapNameSignGFXPointers
	ld bc, 3
	call AddNTimes
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, vTiles0 tile MAP_NAME_SIGN_START
	ld c, MAP_NAME_SIGN_TILES
	call DecompressRequest2bpp
	call LoadMapNameSignPalette
	ret

LoadMapNameSignPalette:
	ld a, [wSign]
	ld hl, MapNameSignPals
	ld bc, 1 palettes
	call AddNTimes

	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a

	push hl
	ld de, wBGPals1 palette PAL_BG_TEXT
	ld bc, 1 palettes
	call CopyBytes
	pop hl
	ld de, wBGPals2 palette PAL_BG_TEXT
	ld bc, 1 palettes
	call CopyBytes

	pop af
	ldh [rSVBK], a
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	ret

MapNameSignGFXPointers:
	db BANK(WoodSignGFX)
	dw WoodSignGFX
	db BANK(CitySignGFX)
	dw CitySignGFX
	db BANK(ForestSignGFX)
	dw ForestSignGFX
	db BANK(CaveSignGFX)
	dw CaveSignGFX
	db BANK(RouteSignGFX)
	dw RouteSignGFX
	db BANK(WaterSignGFX)
	dw WaterSignGFX
	db BANK(BuildingSignGFX)
	dw BuildingSignGFX
.end
	assert .end - MapNameSignGFXPointers == NUM_SIGNS * 3

MapNameSignPals:
INCLUDE "gfx/signs/signs.pal"

InitMapNameFrame:
	; Attribute map: mirror the right edge of Polished Crystal's sign art.
	hlcoord 0, 0
	ld de, wAttrMap - wTileMap
	add hl, de
	ld a, PAL_BG_TEXT | PRIORITY
	ld bc, SCREEN_WIDTH - 1
	call ByteFill
	or X_FLIP
	ld [hli], a
	and ~X_FLIP
	ld [hli], a
	ld bc, SCREEN_WIDTH - 2
	call ByteFill
	or X_FLIP
	ld [hli], a
	and ~X_FLIP
	ld bc, SCREEN_WIDTH - 1
	call ByteFill
	or X_FLIP
	ld [hl], a

	call PlaceMapNameFrame
	ret

PlaceMapNameCenterAlign:
	ld a, [wCurLandmark]
	ld e, a
	farcall GetLandmarkName
	call GetMapNameLength
	ld a, SCREEN_WIDTH
	sub c
	srl a
	ld b, $0
	ld c, a
	hlcoord 0, 1
	add hl, bc
	ld de, wStringBuffer1
	call PlaceString
	call RemapMapNameFont
	ret

RemapMapNameFont::
	hlcoord 0, 0
	ld c, SCREEN_WIDTH * 3
.loop
	ld a, [hl]
	cp "A"
	jr c, .punctuation
	cp "Z" + 1
	jr nc, .punctuation
	add MAP_NAME_FONT_TILE_START - "A"
	jr .write
.punctuation
	cp "'"
	ld a, MAP_NAME_FONT_TILE_START + 16
	jr z, .write
	ld a, [hl]
	cp "."
	jr z, .period
	ld a, [hl]
	cp "/"
	ld a, MAP_NAME_FONT_TILE_START + 16
	jr z, .write
	ld a, [hl]
	cp "é"
	ld a, MAP_NAME_FONT_TILE_START + ("E" - "A")
	jr nz, .next
.write
	ld [hl], a
	jr .next
.period
	ld a, MAP_NAME_FONT_TILE_START + 16
	ld [hl], a
	push hl
	ld de, wAttrMap - wTileMap
	add hl, de
	set 6, [hl] ; flip apostrophe into a period
	pop hl
.next
	inc hl
	dec c
	jr nz, .loop
	ret

GetMapNameLength::
	ld c, 0
	push hl
	ld hl, wStringBuffer1
.loop
	ld a, [hli]
	cp "@"
	jr z, .stop
	cp "%"
	jr z, .loop
	inc c
	jr .loop
.stop
	pop hl
	ret

PlaceMapNameFrame:
	hlcoord 0, 0
	; top left
	ld a, MAP_NAME_SIGN_START
	ld [hli], a
	; top row
	inc a
	call .FillTopBottom
	; top right
	dec a
	ld [hli], a
	; middle left
	ld a, MAP_NAME_SIGN_START + 3
	ld [hli], a
	; blank name field
	ld a, " "
	ld bc, SCREEN_WIDTH - 2
	call ByteFill
	; middle right
	ld a, MAP_NAME_SIGN_START + 4
	ld [hli], a
	; bottom left
	inc a
	ld [hli], a
	; bottom
	inc a
	call .FillTopBottom
	; bottom right
	dec a
	ld [hl], a
	ret

.FillTopBottom:
	ld c, 5
	jr .enterloop

.continueloop
	ld [hli], a
	ld [hli], a

.enterloop
	inc a
	ld [hli], a
	ld [hli], a
	dec a
	dec c
	jr nz, .continueloop
	ret
