; Important-trainer VS interstitial. All temporary frame data uses WRAM6;
; party/save data and the streamed overworld cache are never used as scratch.
; Bank-1 picture tiles survive the bank-0 frame uploads. No ROM0 additions.

CRIMSON_VS_TILES EQU 112
CRIMSON_VS_MAP EQUS "wDecompressScratch + CRIMSON_VS_TILES * 16"
CRIMSON_VS_ATTR EQUS "CRIMSON_VS_MAP + BG_MAP_WIDTH * SCREEN_HEIGHT"
CRIMSON_VS_BYTES EQU CRIMSON_VS_TILES * 16 + 2 * BG_MAP_WIDTH * SCREEN_HEIGHT
CRIMSON_VS_NAMES EQUS "wTileMap + 17 * SCREEN_WIDTH"
CRIMSON_VS_BANK EQUS "wTileMap + 16 * SCREEN_WIDTH"

CrimsonVSIntro::
	ldh a, [hCGB]
	and a
	ret z
	ldh a, [rKEY1]
	bit 7, a
	ret z
	ld a, [wLinkMode]
	and a
	ret nz
	ld a, [wInBattleTowerBattle]
	and a
	ret nz
	farcall CheckBattleScene
	ret c
	call CrimsonVSIsBoss
	ret nc

	ldh a, [rSVBK]
	push af
	ldh a, [rVBK]
	push af
	ld a, [wTrainerClass]
	push af
	ldh a, [hLCDCPointer]
	push af
	ldh a, [rLCDC]
	push af
	xor a
	ldh [hLCDCPointer], a
	ldh [hBGMapMode], a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	ldh [rWY], a
	call ClearSprites
	call DisableLCD
	ld hl, rLCDC
	res rLCDC_WINDOW_ENABLE, [hl]
	res rLCDC_BG_TILEMAP, [hl]
	res rLCDC_TILE_DATA, [hl] ; signed tiles rooted at $9000
	call CrimsonVSLoadPictures
	ld a, 1
	ldh [rSVBK], a
	call CrimsonVSPrepareNames
	call CrimsonVSLoadPalettes
	xor a
	ld [CRIMSON_VS_BANK], a
	; Start from an empty dark field while the first frame is prepared.
	xor a
	ldh [rVBK], a
	ld hl, $8800
	ld bc, 16
	call ByteFill
	ld hl, vBGMap0
	ld bc, BG_MAP_WIDTH * BG_MAP_HEIGHT
	ld a, $80
	call ByteFill
	ld a, 1
	ldh [rVBK], a
	ld hl, vBGMap0
	ld bc, BG_MAP_WIDTH * BG_MAP_HEIGHT
	xor a
	call ByteFill
	ldh [rVBK], a
	call EnableLCD
	ld hl, CrimsonVSFrames
.next
	ld a, [hli]
	cp -1
	jr z, .done
	push af
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a ; visible hold time
	ld a, [hli]
	ld b, a ; bit 0: names; bits 1/2: crystal impact / formation sounds
	push hl
	push bc
	ld h, d
	ld l, e
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	pop bc
	pop de ; next descriptor
	pop af ; graphics bank
	push de
	push bc
	ld de, wDecompressScratch
	ld bc, CRIMSON_VS_BYTES
	call FarCopyBytes
	pop bc
	push bc
	bit 0, b
	jr z, .commit
	ld hl, CRIMSON_VS_NAMES
	ld de, CRIMSON_VS_MAP + 14 * BG_MAP_WIDTH
	ld bc, SCREEN_WIDTH
	call CopyBytes
.commit
	call CrimsonVSCommit
	pop bc
	push bc
	call CrimsonVSSound
	pop bc
	call DelayFrames
	pop hl
	jr .next
.done
	; Use the game's interpolated RGB fade, then let the normal trainer slide
	; enter from the same white field. Twelve steps are paced over 24 frames.
	ld c, 12
	call FadeToWhitePals
	call DisableLCD
	; Remove bank-1 portrait attributes before the ordinary battle setup.
	ld a, 1
	ldh [rVBK], a
	ld hl, vBGMap0
	ld bc, 2 * BG_MAP_WIDTH * BG_MAP_HEIGHT
	xor a
	call ByteFill
	xor a
	ldh [rVBK], a
	ld hl, vBGMap0
	ld bc, 2 * BG_MAP_WIDTH * BG_MAP_HEIGHT
	ld a, " "
	call ByteFill
	pop af
	res rLCDC_ENABLE, a
	ldh [rLCDC], a
	call EnableLCD
	pop af
	ldh [hLCDCPointer], a
	ld a, 1
	ldh [rSVBK], a
	pop af
	ld [wTrainerClass], a
	pop af
	ldh [rVBK], a
	pop af
	ldh [rSVBK], a
	ret

CrimsonVSIsBoss:
	ld a, [wOtherTrainerClass]
	and a
	ret z
	farcall IsGymLeader
	ret c
	ld a, [wOtherTrainerClass]
	ld hl, .classes
	ld de, 1
	jp IsInArray
.classes
	db RIVAL1
	db RIVAL2
	db RIVAL3
	db PROTON
	db PETREL
	db ARIANA
	db ARCHER
	db EXECUTIVEM
	db EXECUTIVEF
	db CRYSTAL
	db CRYSTAL2
	db CRYSTAL3
	db -1

CrimsonVSSound:
	bit 1, b
	ld de, SFX_CRIMSON_VS_LOCK
	jp nz, PlaySFX
	bit 2, b
	ld de, SFX_CRIMSON_VS_FORM
	jp nz, PlaySFX
	ret

CrimsonVSLoadPictures:
	ld a, 1
	ldh [rVBK], a
	ld de, GoldPic
	ld b, BANK(GoldPic)
	ld a, [wPlayerSpriteSetupFlags]
	bit PLAYERSPRITESETUP_FEMALE_TO_MALE_F, a
	jr nz, .player
	ld a, [wPlayerGender]
	cp PLAYERGENDER_MINT
	jr nz, .indigo
	ld de, MintPic
	ld b, BANK(MintPic)
	jr .player
.indigo
	cp PLAYERGENDER_INDIGO
	jr nz, .lyra
	ld de, IndigoPic
	ld b, BANK(IndigoPic)
	jr .player
.lyra
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .player
	ld de, LyraPic
	ld b, BANK(LyraPic)
.player
	ld hl, vTiles2
	ld c, 49
	call Get2bpp
	ld a, [wOtherTrainerClass]
	ld [wTrainerClass], a
	; GetTrainerPic waits for VBlank, so decompress directly while LCD is off.
	dec a
	ld hl, TrainerPicPointers
	ld bc, 3
	call AddNTimes
	ld a, BANK(TrainerPicPointers)
	call GetFarByte
	push af
	inc hl
	ld a, BANK(TrainerPicPointers)
	call GetFarHalfword
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	pop af
	ld de, wDecompressScratch
	call FarDecompress
	ld de, wDecompressScratch
	ld hl, vTiles2 tile 49
	ld b, BANK(CrimsonVSLoadPictures)
	ld c, 49
	call Get2bpp
	xor a
	ldh [hBGMapMode], a
	ld hl, vTiles2 tile $62
	ld bc, 21 tiles ; 20 individual name glyphs, then a shared blank at $76
	xor a
	call ByteFill
	xor a
	ldh [rVBK], a
	ret

CrimsonVSLoadPalettes:
	xor a
	farcall_a GetPlayerOrMonPalettePointer
	push hl
	ld a, [wOtherTrainerClass]
	farcall_a GetTrainerPalettePointer
	push hl
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	ld hl, CrimsonVSPalettes
	ld de, wBGPals1
	ld bc, 8 palettes
	call CopyBytes
	pop hl
	ld de, wBGPals1 palette 5 + 2
	ld a, BANK(TrainerPalettes)
	ld bc, 4
	call FarCopyBytes
	pop hl
	ld de, wBGPals1 palette 4 + 2
	ld a, BANK(PlayerPalette)
	ld bc, 4
	call FarCopyBytes
	; Keep the exact authored palette indexes, independent of the transition.
	ld hl, wBGPals1
	ld de, wBGPals2
	ld bc, 8 palettes
	call CopyBytes
	ld a, 1
	ldh [hCGBPalUpdate], a
	ret

CrimsonVSPrepareNames:
	ld a, 1
	ldh [rVBK], a
	ld hl, CRIMSON_VS_NAMES
	ld bc, SCREEN_WIDTH
	ld a, $76
	call ByteFill
	ld de, wPlayerName
	ld c, PLAYER_NAME_LENGTH - 1
	call .length
	ld b, 0
	call .position
	call .draw
	ld a, [wOtherTrainerClass]
	cp RIVAL1
	jr z, .rival
	cp RIVAL2
	jr z, .rival
	cp RIVAL3
	jr z, .rival
	ld c, a
	ld a, [wOtherTrainerID]
	ld b, a
	farcall GetTrainerName
	ld de, wStringBuffer1
	jr .opponent
.rival
	ld de, wRivalName
.opponent
	ld c, 10
	call .length
	ld b, 13
	call .position
	call .draw
	xor a
	ldh [rVBK], a
	ret
.length
	; Keep the actual spelling/case entered by the player, up to the field limit.
	push de
	ld b, c
	ld c, 0
.count
	ld a, [de]
	cp "@"
	jr z, .counted
	inc de
	inc c
	ld a, c
	cp b
	jr c, .count
.counted
	pop de
	ret
.position
	; Center names below their seven-tile portraits. Longer opponent names may
	; extend inward onto the space below the crystal, never onto its artwork.
	ld a, 7
	sub c
	sra a
	add b
	ld b, a
	ld a, SCREEN_WIDTH
	sub c
	cp b
	jr nc, .positioned
	ld b, a
.positioned
	push de
	ld e, b
	ld d, 0
	ld hl, CRIMSON_VS_NAMES
	add hl, de
	pop de
	ret
.draw
	ld a, c
	and a
	ret z
.letter
	ld a, [de]
	cp "@"
	ret z
	push bc
	push de
	push hl
	push af
	; Name map position selects a private glyph slot, so all legal name
	; characters fit without reserving an entire font in visible VRAM.
	ld a, l
	sub LOW(CRIMSON_VS_NAMES)
	add $62
	ld [hl], a
	ld l, a
	ld h, 0
rept 4
	add hl, hl
endr
	ld bc, vTiles2
	add hl, bc
	pop af
	call CrimsonVSLoadNameGlyph
	pop hl
	pop de
	pop bc
	inc hl
	inc de
	dec c
	jr nz, .letter
	ret

CrimsonVSLoadNameGlyph:
; a = actual game character; hl = its dedicated bank-1 VRAM tile, LCD off.
	sub $80
	ret c ; spaces use the zeroed tile
	push hl
	ld l, a
	ld h, 0
rept 4
	add hl, hl
endr
	ld de, CrimsonVSFont
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld b, BANK(CrimsonVSFont)
	ld c, 1
	jp Get2bpp

CrimsonVSCommit:
; Double-buffer graphics at $8800-$8eff across both VRAM banks. The visible
; map continues using the previous bank while VBlank uploads the next one.
; Portraits ($9000-$961f) and name glyphs ($9620-$976f) stay in bank 1.
; A second VBlank commits both maps atomically: 72 blocks * 32 dots = 2304,
; comfortably inside the 4560-dot VBlank. No visible VRAM writes or LCD flicker.
	ld a, [CRIMSON_VS_BANK]
	xor 1
	ld [CRIMSON_VS_BANK], a
	ldh [rVBK], a
	and a
	jr z, .upload
	ld hl, CRIMSON_VS_ATTR
	ld bc, BG_MAP_WIDTH * SCREEN_HEIGHT
.attributes
	bit 3, [hl] ; portraits and name glyphs always remain in bank 1
	jr nz, .keep
	set 3, [hl]
.keep
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .attributes
.upload
	ld a, HIGH(wDecompressScratch)
	ldh [rHDMA1], a
	ld a, LOW(wDecompressScratch)
	ldh [rHDMA2], a
	ld a, $08
	ldh [rHDMA3], a
	xor a
	ldh [rHDMA4], a
	ld a, CRIMSON_VS_TILES - 1
	ldh [hDMATransfer], a
.wait
	call DelayFrame
	ldh a, [hDMATransfer]
	and a
	jr nz, .wait
	di
.visible
	ldh a, [rLY]
	cp LY_VBLANK
	jr nc, .visible
.vblank
	ldh a, [rLY]
	cp LY_VBLANK
	jr c, .vblank
	xor a
	ldh [rVBK], a
	ld hl, CRIMSON_VS_MAP
	ld de, vBGMap0
	ld b, 35
	call .dma
	ld a, 1
	ldh [rVBK], a
	ld hl, CRIMSON_VS_ATTR
	ld de, vBGMap0
	ld b, 35
	call .dma
	xor a
	ldh [rVBK], a
.complete
	ei
	ret
.dma
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	and $1f
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld a, b
	ldh [rHDMA5], a
	ret

CrimsonVSPalettes:
	RGB 2,1,3, 11,2,5, 26,4,8, 31,31,31
	RGB 2,1,3, 5,5,8, 13,14,17, 28,28,30
	RGB 2,1,3, 11,2,5, 26,4,8, 31,31,31
	RGB 2,1,3, 11,2,5, 26,4,8, 31,31,31
	RGB 31,31,31, 0,0,0, 0,0,0, 0,0,0
	RGB 31,31,31, 0,0,0, 0,0,0, 0,0,0
	RGB 2,1,3, 11,2,5, 26,4,8, 31,31,31
	RGB 2,1,3, 11,2,5, 26,4,8, 31,31,31
	assert @ - CrimsonVSPalettes == 8 palettes

CrimsonVSFont: INCBIN "gfx/battle_vs/font.bin"
INCLUDE "gfx/battle_vs/frames.asm"
