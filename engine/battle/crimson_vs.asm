; Important-trainer VS interstitial. All temporary frame data uses WRAM6;
; party/save data and the streamed overworld cache are never used as scratch.
; Bank-1 picture tiles survive the bank-0 frame uploads. No ROM0 additions.

CRIMSON_VS_TILES EQU 112
CRIMSON_VS_MAP EQUS "wDecompressScratch + CRIMSON_VS_TILES * 16"
CRIMSON_VS_ATTR EQUS "CRIMSON_VS_MAP + BG_MAP_WIDTH * SCREEN_HEIGHT"
CRIMSON_VS_BYTES EQU CRIMSON_VS_TILES * 16 + 2 * BG_MAP_WIDTH * SCREEN_HEIGHT
CRIMSON_VS_NAMES EQUS "wTileMap + 17 * SCREEN_WIDTH"
CRIMSON_VS_BANK EQUS "wTileMap + 16 * SCREEN_WIDTH"
CRIMSON_VS_SHOWN EQUS "wTileMap + 16 * SCREEN_WIDTH + 1"
CRIMSON_VS_PAL EQUS "wTileMap + 16 * SCREEN_WIDTH + 2" ; raise palettes with the next map commit
CRIMSON_VS_STAMP EQUS "wTileMap + 16 * SCREEN_WIDTH + 3" ; hVBlankCounter at the last commit
; Bank-1 tiles 0-$76: player and opponent pictures, 20 name glyphs, a blank.
CRIMSON_VS_PORTRAITS EQU 2 * 7 * 7 + 21
; After the authored frames, CrimsonVSLoopFrames (one seamless streak period)
; cycles for the final hold, then keeps cycling through the white fade so the
; streaks never stop before the screen is fully white. Each loop frame is
; prefetched straight after the previous commit, so the loop runs at a fixed
; four-frame period: commit (V), two free VBlanks, then the tile GDMA. Fade
; steps land on V (raised with the map commit) and V+2, every second frame:
; twelve steps at the native two-frame cadence, 24 frames as before.
CRIMSON_VS_LOOP_HOLD EQU 7 ; loop frames shown before the fade starts
CRIMSON_VS_FADE_STEPS EQU 12

CrimsonVSWillPlay::
; Returns carry if this battle opens with the VS interstitial. DoBattleTransition
; asks first, so these battles cut straight from the overworld into the VS.
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
	ccf
	ret nc
	jp CrimsonVSIsBoss

CrimsonVSFlash::
; DoBattleTransition asks this first. For VS battles, play the ordinary
; trainer-battle flash (three flashes of the overworld's own palettes, as
; StartTrainerBattle_Flash does) and return carry, so the caller skips the
; spin/wave/speckle outro and cuts straight to black and into the VS.
; Otherwise return nc and the normal transition runs.
	call CrimsonVSWillPlay
	ret nc
	ld a, [wTimeOfDayPalset]
	cp %11111111 ; dark caves never flash, as in the native transition
	jr z, .done
	ld c, 3
.flash
	ld hl, .pals
	ld b, .pals_end - .pals
.step
	ld a, [hli]
	ld [wBGP], a
	push bc
	push hl
	call DmgToCgbBGPals
	ld c, 2 ; the native jumptable advances one table entry every two frames
	call DelayFrames
	pop hl
	pop bc
	dec b
	jr nz, .step
	dec c
	jr nz, .flash
.done
	scf
	ret

.pals
; Same steps as StartTrainerBattle_Flash.pals (engine/battle/battle_transition.asm).
	dc 3, 3, 2, 1
	dc 3, 3, 3, 2
	dc 3, 3, 3, 3
	dc 3, 3, 3, 2
	dc 3, 3, 2, 1
	dc 3, 2, 1, 0
	dc 2, 1, 0, 0
	dc 1, 0, 0, 0
	dc 0, 0, 0, 0
	dc 1, 0, 0, 0
	dc 2, 1, 0, 0
	dc 3, 2, 1, 0
.pals_end

CrimsonVSIntro::
	call CrimsonVSWillPlay
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
	; The LCD stays on: a CGB with its LCD off shows white, which would blink
	; between the transition and the VS. The transition left every BG colour
	; black, so nothing loaded below is visible until the first frame and its
	; palettes are committed. Sprites are simply switched off.
	ld hl, rLCDC
	res rLCDC_SPRITES_ENABLE, [hl]
	res rLCDC_WINDOW_ENABLE, [hl]
	res rLCDC_BG_TILEMAP, [hl]
	res rLCDC_TILE_DATA, [hl] ; signed tiles rooted at $9000
	call CrimsonVSLoadPictures
	ld a, 1
	ldh [rSVBK], a
	call CrimsonVSPrepareNames
	call CrimsonVSUploadPortraits
	call CrimsonVSLoadPalettes
	xor a
	ld [CRIMSON_VS_BANK], a
	ld [CRIMSON_VS_SHOWN], a
	ld [CRIMSON_VS_PAL], a
	ld hl, CrimsonVSFrames
.next
	call CrimsonVSShowFrame
	jr c, .settled
	push hl
	call DelayFrames
	pop hl
	jr .next

.settled
	; The settled screen keeps its streaks moving: one full loop period as
	; the final hold, then the loop continues underneath the white fade.
	ld hl, CrimsonVSLoopFrames
	call .load_loop
	ld d, CRIMSON_VS_LOOP_HOLD + CRIMSON_VS_FADE_STEPS / 2 ; loop commits
	ld e, CRIMSON_VS_FADE_STEPS ; fade steps remaining
.loop
	ld a, d
	cp CRIMSON_VS_FADE_STEPS / 2 + 1
	jr nc, .commit_loop
	; This step is raised between the tile GDMA and the map commit, so it
	; appears together with the new frame.
	call .fade_step
	ld a, 1
	ld [CRIMSON_VS_PAL], a
.commit_loop
	push de
	push bc ; c = this frame's hold
	push hl
	call CrimsonVSCommit
	ldh a, [hVBlankCounter]
	ld [CRIMSON_VS_STAMP], a
	pop hl
	pop bc
	pop de
	; The second step of each frame shows two frames after the first. It is
	; prepared now (the first step has just been uploaded) and raised once
	; the next VBlank has passed.
	ld a, d
	cp CRIMSON_VS_FADE_STEPS / 2 + 1
	call c, .fade_step
	push de
	push bc
	call .load_loop ; prefetch the next loop frame while this one shows
	pop bc
	pop de
	push bc
	ld c, 1
	call .wait
	pop bc
	ld a, d
	cp CRIMSON_VS_FADE_STEPS / 2 + 1
	jr nc, .no_step
	ld a, 1
	ldh [hCGBPalUpdate], a
.no_step
	call .wait ; until the frame's hold has elapsed
	dec d
	jr nz, .loop
	; The last step was white: hold it one more frame, as the native fade's
	; final two-frame step does, before the ordinary trainer slide.
	call DelayFrame
	jr .white

.fade_step
; One interpolated step toward white; e = steps remaining (decremented).
	push bc
	push de
	push hl
	ld c, e
	farcall CrimsonVSFadeStep
	pop hl
	pop de
	pop bc
	dec e
	ret

.wait
; Wait until c VBlanks have passed since the last commit.
	push hl
.wait_frame
	ld a, [CRIMSON_VS_STAMP]
	ld l, a
	ldh a, [hVBlankCounter]
	sub l
	cp c
	jr nc, .waited
	call DelayFrame
	jr .wait_frame
.waited
	pop hl
	ret

.load_loop
; hl = loop descriptor: prefetch it (wrapping at the end); c = its hold time.
	call CrimsonVSLoadFrame
	ret nc
	ld hl, CrimsonVSLoopFrames
	jr .load_loop

.white
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

CrimsonVSShowFrame:
; hl = frame descriptor. At the -1 terminator, return carry. Otherwise show
; the frame and play its cue; return nc, hl = next descriptor, c = hold time.
	call CrimsonVSLoadFrame
	ret c
	push bc
	push hl
	call CrimsonVSCommit
	ld a, [CRIMSON_VS_SHOWN]
	and a
	jr nz, .shown
	; Reveal the palettes only once the first frame's maps are in place.
	inc a
	ld [CRIMSON_VS_SHOWN], a
	call DelayFrame
	ld a, 1
	ldh [hCGBPalUpdate], a
.shown
	pop hl
	pop bc
	push bc
	push hl
	call CrimsonVSSound
	pop hl
	pop bc
	and a
	ret

CrimsonVSLoadFrame:
; hl = frame descriptor. At the -1 terminator, return carry. Otherwise copy
; the frame (and the name row) into WRAM6 for CrimsonVSCommit; return nc,
; hl = next descriptor, c = hold time, b = flags.
	ld a, [hli]
	cp -1
	jr nz, .frame
	scf
	ret
.frame
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
	jr z, .loaded
	ld hl, CRIMSON_VS_NAMES
	ld de, CRIMSON_VS_MAP + 14 * BG_MAP_WIDTH
	ld bc, SCREEN_WIDTH
	call CopyBytes
.loaded
	pop bc
	pop hl
	and a
	ret

CrimsonVSIsBoss:
; Important individuals only. IsGymLeader covers every Johto/Kanto leader,
; the Elite Four, Lance, all rematches, Red, Blue, Blue (cloak) and Green.
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
	db CRYSTAL
	db CRYSTAL2
	db CRYSTAL3
	db PROTON
	db PETREL
	db PETREL_DIRECTOR ; Petrel disguised as the Radio Tower director
	db ARIANA
	db ARCHER
	db EXECUTIVEM
	db EXECUTIVEF
	db MYSTICALMAN ; Eusine
	db WILL ; unused League classes, kept in case they return
	db AGATHA
	db -1

CrimsonVSSound:
; Both cues live on the noise channel alone, so pulse 1/2 and wave music
; voices are never muted. Themes with their own drums (Crystal, Rocket
; Executive) keep the noise channel too: the VS then plays silently over them.
	ld a, [wChannel4Flags1]
	bit SOUND_CHANNEL_ON, a
	ret nz
	bit 1, b
	ld de, SFX_CRIMSON_VS_LOCK
	jp nz, PlaySFX
	bit 2, b
	ld de, SFX_CRIMSON_VS_FORM
	jp nz, PlaySFX
	ret

CrimsonVSLoadPictures:
; Gather bank-1 tiles 0-$76 (both pictures; name glyphs are added later) in
; WRAM6. CrimsonVSUploadPortraits then copies them during VBlank. The player
; and trainer selectors live in WRAM1, so they are read before switching.
	ldh a, [rSVBK]
	push af
	ld a, 1
	ldh [rSVBK], a
	ld hl, GoldPic
	ld b, BANK(GoldPic)
	ld a, [wPlayerSpriteSetupFlags]
	bit PLAYERSPRITESETUP_FEMALE_TO_MALE_F, a
	jr nz, .player
	ld a, [wPlayerGender]
	cp PLAYERGENDER_MINT
	jr nz, .indigo
	ld hl, MintPic
	ld b, BANK(MintPic)
	jr .player
.indigo
	cp PLAYERGENDER_INDIGO
	jr nz, .lyra
	ld hl, IndigoPic
	ld b, BANK(IndigoPic)
	jr .player
.lyra
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .player
	ld hl, LyraPic
	ld b, BANK(LyraPic)
.player
	push hl
	push bc
	ld a, [wOtherTrainerClass]
	ld [wTrainerClass], a
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
	push hl
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld hl, wDecompressScratch
	ld bc, CRIMSON_VS_PORTRAITS tiles
	xor a
	call ByteFill
	pop hl
	pop af
	ld de, wDecompressScratch tile 7 * 7
	call FarDecompress
	pop bc
	pop hl
	ld a, b
	ld de, wDecompressScratch
	ld bc, 7 * 7 tiles
	call FarCopyBytes
	xor a
	ldh [hBGMapMode], a
	pop af
	ldh [rSVBK], a
	ret

CrimsonVSUploadPortraits:
; Copy the WRAM6 portrait buffer to bank-1 tiles 0-$76 with two GDMAs, each
; started at the top of its own VBlank (immediately if the LCD is off).
	ldh a, [rSVBK]
	push af
	ldh a, [rVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld a, 1
	ldh [rVBK], a
	ld hl, wDecompressScratch
	ld de, vTiles2
	ld b, 64
	call .dma
	ld hl, wDecompressScratch tile 64
	ld de, vTiles2 tile 64
	ld b, CRIMSON_VS_PORTRAITS - 64
	call .dma
	pop af
	ldh [rVBK], a
	pop af
	ldh [rSVBK], a
	ret

.dma
; hl = source, de = VRAM destination, b = tiles (at most 64 per VBlank).
	ldh a, [rLCDC]
	bit rLCDC_ENABLE, a
	jr z, .start
	di
.visible
	ldh a, [rLY]
	cp LY_VBLANK
	jr nc, .visible
.vblank
	ldh a, [rLY]
	cp LY_VBLANK
	jr c, .vblank
	call .start
	ei
	ret

.start
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
	dec a
	ldh [rHDMA5], a
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
	; CrimsonVSIntro requests the upload once the first frame is committed.
	ret

CrimsonVSPrepareNames:
; Name map row in wTileMap; each glyph goes into the WRAM6 portrait buffer.
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
	jp .draw
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
	ld bc, wDecompressScratch
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
; a = actual game character; hl = its tile in the WRAM6 portrait buffer.
	sub $80
	ret c ; spaces keep the zeroed tile
	push hl
	ld l, a
	ld h, 0
rept 4
	add hl, hl
endr
	ld de, CrimsonVSFont
	add hl, de
	pop de
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld bc, 1 tiles
	call CopyBytes ; CrimsonVSFont shares this ROM bank
	pop af
	ldh [rSVBK], a
	ret

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
	; A fade step queued for this frame uploads in the same VBlank as its
	; maps (after them: 2304 dots of map DMA leave room for the palettes),
	; never alongside the tile GDMA.
	ld a, [CRIMSON_VS_PAL]
	and a
	jr z, .visible
	ldh [hCGBPalUpdate], a
	xor a
	ld [CRIMSON_VS_PAL], a
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

; Arena, gunmetal, generated ruby palettes 2/3/6/7 and portrait templates 4/5.
INCLUDE "gfx/battle_vs/palettes.asm"

CrimsonVSFont: INCBIN "gfx/battle_vs/font.bin"
INCLUDE "gfx/battle_vs/frames.asm"
