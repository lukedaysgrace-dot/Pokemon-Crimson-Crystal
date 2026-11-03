; The screen's persistent walking cache is the VRAM BG map. Decode only the
; entering edge, then publish its addresses and data together to VBlank.
; Full-screen consumers continue to use LoadMapPart / reanchoring.

ScrollMapUp::
	call StreamMapEdge
	ld a, [wBGMapAnchor]
	ld e, a
	ld a, [wBGMapAnchor + 1]
	ld d, a
	jr QueueMapRow

ScrollMapDown::
	call StreamMapEdge
	ld a, [wBGMapAnchor]
	ld l, a
	ld a, [wBGMapAnchor + 1]
	ld h, a
	ld bc, BG_MAP_WIDTH tiles
	add hl, bc
	ld a, h
	and %11
	or HIGH(vBGMap0)
	ld e, l
	ld d, a
QueueMapRow:
	call UpdateBGMapRow
	jr PublishMapEdge

ScrollMapLeft::
	call StreamMapEdge
	ld a, [wBGMapAnchor]
	ld e, a
	ld a, [wBGMapAnchor + 1]
	ld d, a
	jr QueueMapColumn

ScrollMapRight::
	call StreamMapEdge
	ld a, [wBGMapAnchor]
	ld e, a
	and %11100000
	ld b, a
	ld a, e
	add SCREEN_WIDTH - 2
	and %00011111
	or b
	ld e, a
	ld a, [wBGMapAnchor + 1]
	ld d, a
QueueMapColumn:
	call UpdateBGMapColumn
PublishMapEdge:
	ld a, 1
	ldh [hBGMapUpdate], a
	ret

UpdateBGMapRow:
	ld hl, wBGMapBufferPtrs
	push de
	call .iteration
	pop de
	ld a, BG_MAP_WIDTH
	add e
	ld e, a

.iteration
	ld c, SCREEN_WIDTH / 2
.loop
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	inc a
	inc a
	and $1f
	ld b, a
	ld a, e
	and $e0
	or b
	ld e, a
	dec c
	jr nz, .loop
	ld a, SCREEN_WIDTH
	ldh [hBGMapTileCount], a
	ret

UpdateBGMapColumn:
	ld hl, wBGMapBufferPtrs
	ld c, SCREEN_HEIGHT
.loop
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, BG_MAP_WIDTH
	add e
	ld e, a
	jr nc, .skip
	inc d
	ld a, d
	and %11
	or HIGH(vBGMap0)
	ld d, a
.skip
	dec c
	jr nz, .loop
	ld a, SCREEN_HEIGHT
	ldh [hBGMapTileCount], a
	ret
