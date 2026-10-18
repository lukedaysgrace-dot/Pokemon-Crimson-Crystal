SECTION "Wishing Star Overworld Effects", ROMX

MtMoonOverworldWishingStar::
; Wish's large star crosses the live map. The constellation/background
; effects are deliberately absent. Emote tiles $fc-$ff in VRAM bank 1
; are temporary scratch; no emote is active during this effect.
	ldh a, [rSVBK]
	push af
	ld a, 1
	ldh [rSVBK], a
	ldh a, [rVBK]
	push af
	ld a, 1
	ldh [rVBK], a
	ld de, .StarGFX
	ld hl, vTiles0 tile $fc
	lb bc, BANK(.StarGFX), 4
	call Request2bpp
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
	ld hl, wOBPals1 palette PAL_OW_ROCK
rept 8
	ld a, [hli]
	push af
endr
	ld a, 1
	ldh [rSVBK], a
	ld hl, .StarPalette
	call .ShowPalette
	ld de, SFX_GAME_FREAK_LOGO_GS
	call PlaySFX
	lb bc, 0, 8 ; screen-space OAM x, y
	ld d, 88
.CrossScreen:
	push bc
	push de
	farcall _UpdateSprites
	pop de
	pop bc
	call .DrawStar
	push bc
	push de
	ld c, 2
	call DelayFrames
	pop de
	pop bc
	inc b
	inc b
	; Match the display's aspect ratio to exit at the bottom-right corner.
	ld a, d
	and 7
	jr z, .KeepY
	inc c
	inc c
.KeepY:
	dec d
	jr nz, .CrossScreen
	farcall _UpdateSprites
	call DelayFrame
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
	ld hl, wOBPals1 palette PAL_OW_ROCK + 7
rept 8
	pop af
	ld [hld], a
endr
	ld a, 1
	ldh [rSVBK], a
	call .UpdatePalette
	pop af
	ldh [rVBK], a
	pop af
	ldh [rSVBK], a
	ret

.DrawStar:
	ld hl, wVirtualOAMSprite36
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, $fc
	ld [hli], a
	ld a, VRAM_BANK_1 | PAL_OW_ROCK
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	add 8
	ld [hli], a
	ld a, $fd
	ld [hli], a
	ld a, VRAM_BANK_1 | PAL_OW_ROCK
	ld [hli], a
	ld a, c
	add 8
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, $fe
	ld [hli], a
	ld a, VRAM_BANK_1 | PAL_OW_ROCK
	ld [hli], a
	ld a, c
	add 8
	ld [hli], a
	ld a, b
	add 8
	ld [hli], a
	ld a, $ff
	ld [hli], a
	ld a, VRAM_BANK_1 | PAL_OW_ROCK
	ld [hl], a
	ret

.ShowPalette:
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM
.UpdatePalette:
	ldh a, [rOBP0]
	ld e, a
	ldh a, [rOBP1]
	ld d, a
	jp DmgToCgbObjPals

.StarPalette:
	RGB 31, 31, 31, 31, 31, 16, 31, 22, 0, 12, 6, 0
.StarGFX:
	INCBIN "gfx/battle_anims/stars.2bpp", 0, 4 * LEN_2BPP_TILE

EcruteakWellJirachiRise::
; Internal map object 10 is the well's Jirachi (script object 11).
; Start at the well's lip (one tile above the old player-overlapping start).
	ld a, 10
	call _CopyObjectStruct
	ldh a, [hObjectStructIndexBuffer]
	call GetObjectStruct
	ld hl, OBJECT_NEXT_MAP_X
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_MAP_X
	add hl, bc
	ld [hl], a
	ld hl, OBJECT_NEXT_MAP_Y
	add hl, bc
	ld a, [hl]
	ld hl, OBJECT_MAP_Y
	add hl, bc
	ld [hl], a
	; Newly copied objects begin with STANDING ($ff), which is hidden by
	; InitSprites until the normal action loop gives them a visible frame.
	; This special draws directly, so initialize the walking sprite here.
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_STEP_DOWN_0
	; Initialize the standing action as well as the rendered pose.
	ld hl, OBJECT_ACTION
	add hl, bc
	ld [hl], OBJECT_ACTION_STAND
	ld a, OW_DOWN
	call SetSpriteDirection
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], 0
.Rise:
	push bc
	push hl
	farcall _UpdateSprites
	ld c, 6 ; Same rise duration over the shorter, higher path.
	call DelayFrames
	pop hl
	pop bc
	dec [hl]
	ld a, [hl]
	cp -16
	jr nz, .Rise
	farcall _UpdateSprites
	ret

EcruteakWellJirachiCircle::
; Fly two smooth circles above the well, returning to the rise's endpoint.
; Render offsets let Jirachi fly over the well and trees without collision
; steps or moving the underlying map object away from its spawn location.
	ld a, 10
	call GetMapObject
	ld hl, MAPOBJECT_OBJECT_STRUCT_ID
	add hl, bc
	ld a, [hl]
	call GetObjectStruct
	ld e, 0
.CircleFrame:
	push bc
	push de
	ld a, e
	ld d, 12
	call .Sine
	pop de
	pop bc
	cpl
	inc a
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld [hl], a
	push bc
	push de
	ld a, e
	ld d, 12
	call .Cosine
	pop de
	pop bc
	sub 28
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], a
	; Face along the tangent and alternate the walking poses in the sheet.
	push de
	ld a, e
	rrca
	rrca
	rrca
	and 7
	ld e, a
	ld d, 0
	ld hl, .CircleFacings
	add hl, de
	ld a, [hl]
	pop de
	ld d, a
	ld a, e
	and 4
	rrca
	inc a
	or d
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], a
	push bc
	push de
	farcall _UpdateSprites
	ld c, 2
	call DelayFrames
	pop de
	pop bc
	inc e
	ld a, e
	cp 128
	jr nz, .CircleFrame
.CirclesDone:
	ld hl, OBJECT_SPRITE_X_OFFSET
	add hl, bc
	ld [hl], 0
	ld hl, OBJECT_SPRITE_Y_OFFSET
	add hl, bc
	ld [hl], -16
	ld hl, OBJECT_FACING_STEP
	add hl, bc
	ld [hl], FACING_STEP_DOWN_0
	farcall _UpdateSprites
	ret

.CircleFacings:
	db FACING_STEP_LEFT_0, FACING_STEP_UP_0
	db FACING_STEP_UP_0, FACING_STEP_RIGHT_0
	db FACING_STEP_RIGHT_0, FACING_STEP_DOWN_0
	db FACING_STEP_DOWN_0, FACING_STEP_LEFT_0

.Cosine:
	add 16
.Sine:
	calc_sine_wave
