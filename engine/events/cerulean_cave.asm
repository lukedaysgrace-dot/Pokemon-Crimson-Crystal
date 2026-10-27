SECTION "Cerulean Cave Collision Hook", ROM0

CeruleanCaveCollisionHook::
; Use a free ROM0 gap: the fixed Home section is already full.
	farcall CeruleanCaveTilePermissions
	jp GetMovementPermissions.CheckHiNybble

SECTION "Cerulean Cave Barrier Effect", ROMX

CeruleanCaveTilePermissions::
; Red's Cavern tileset has two elevations. Its tile-pair rules prohibit
; crossing directly between raised floor ($05) and ground/water/exit/sign;
; stairs ($15) connect them. COLL_03 marks only that raised floor here.
; Apply the same rule to walking, Surf and the field-move shore check.
	ld a, [wMapTileset]
	cp TILESET_CERULEAN_CAVE
	jr nz, .done
	ld a, [wPlayerStandingTile]
	ld d, a
	ld hl, .Neighbors
	ld b, 4
.loop
	ld a, [hli]
	ld e, a
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	ld a, [hl]
	ld c, a
	ld a, d
	cp COLL_03
	jr z, .raised
	ld a, c
	cp COLL_03
	jr nz, .next
	ld a, d
	jr .check_edge
.raised
	ld a, c
.check_edge
	; COLL_01 is the cave sign, COLL_FLOOR is low ground, and the
	; two exit tiles use COLL_WARP_CARPET_DOWN. Stairs use COLL_04.
	cp COLL_FLOOR
	jr z, .block
	cp COLL_01
	jr z, .block
	cp COLL_WATER
	jr z, .block
	cp COLL_WARP_CARPET_DOWN
	jr nz, .next
.block
	ld a, [wTilePermissions]
	or e
	ld [wTilePermissions], a
.next
	pop hl
	inc hl
	dec b
	jr nz, .loop
.done
	ld a, [wPlayerStandingTile]
	ret
.Neighbors
	db FACE_DOWN
	dw wTileDown
	db FACE_UP
	dw wTileUp
	db FACE_LEFT
	dw wTileLeft
	db FACE_RIGHT
	dw wTileRight

CeruleanCaveMewPinkFlash::
; Route 4 assigns the temporary Mew to its otherwise unused rock OBJ palette.
; Save and restore that palette so the effect cannot recolor other maps.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
	ld hl, wOBPals1 palette PAL_OW_ROCK
rept 8
	ld a, [hli]
	push af
endr
	ld a, 1
	ldh [rSVBK], a
	ld b, 3
.pulse
	push bc
	ld hl, .BrightPink
	call .ShowPalette
	ld c, 8
	call DelayFrames
	ld hl, .SoftPink
	call .ShowPalette
	ld c, 8
	call DelayFrames
	pop bc
	dec b
	jr nz, .pulse
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
	ld hl, wOBPals1 palette PAL_OW_ROCK + 7
rept 8
	pop af
	ld [hld], a
endr
	pop af
	ldh [rSVBK], a
	jp .UpdateObjects

.ShowPalette
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM
.UpdateObjects
	ldh a, [rOBP0]
	ld e, a
	ldh a, [rOBP1]
	ld d, a
	jp DmgToCgbObjPals

.BrightPink
	RGB 31, 31, 31, 31, 15, 27, 31, 5, 20, 22, 0, 13
.SoftPink
	RGB 31, 31, 31, 31, 26, 30, 31, 17, 26, 18, 4, 13
