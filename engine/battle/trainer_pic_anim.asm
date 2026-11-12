; Animated opposing trainer pictures.
;
; A trainer class listed in TrainerPicAnimations has a vertical frame strip
; (gfx/trainers/animated/<name>/front.png, 56 pixels wide, 56 pixels per frame)
; whose frame 0 is identical to its normal static picture. The battle picture
; keeps its usual 7x7 tile map (vTiles2 tiles $00-$30, bank 0); each animation
; step uploads the selected frame's 49 tiles in one VBlank with general-purpose
; DMA. Tile maps, attributes and palettes never change, so slide-outs, text
; boxes and palette rebuilds behave exactly as they do for static pictures.

CHAMPION_PIC_FRAMES EQU 6
TRAINER_PIC_ANIM_ENTRY_LENGTH EQU 1 + 2 + 2 + 2

AnimateTrainerFrontpic::
; Play the opposing trainer picture's animation once, if [wTrainerClass] has
; one. The static picture must already be loaded at vTiles2 and on screen.
	farcall CheckBattleScene
	ret c

	ld a, [wTrainerClass]
	ld b, a
	ld hl, TrainerPicAnimations
.find
	ld a, [hli]
	cp -1
	ret z
	cp b
	jr z, .found
	ld de, TRAINER_PIC_ANIM_ENTRY_LENGTH - 1
	add hl, de
	jr .find

.found
	ld a, [hli] ; column stride (frame count * 7 tiles)
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a ; de = frame graphics
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = animation script

.loop
	ld a, [hli]
	cp endanim_command
	ret z
	push hl
	push de
	push bc
	call TrainerPicAnim_ShowFrame
	pop bc
	pop de
	pop hl
	ld a, [hli] ; duration; the frame upload above already took one frame
	dec a
	jr z, .loop
	push bc
	ld c, a
	call DelayFrames
	pop bc
	jr .loop

TrainerPicAnim_ShowFrame:
; Upload frame a of the strip at de (column stride bc) to vTiles2 $00-$30.
	push bc
	ld h, d
	ld l, e
	ld bc, 7 tiles
	call AddNTimes ; hl = frame a, column 0
	pop de ; de = column stride

	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ldh a, [rVBK]
	push af

; rgbgfx -h stores the strip column-major: each 8-pixel column holds every
; frame's 7 tiles in turn. Gather this frame's seven columns in picture order.
	push de
	ld de, wDecompressScratch
	ld b, 7
.column
	push bc
	push hl
	ld bc, 7 tiles
	call CopyBytes
	pop hl
	pop bc
	ld a, b
	pop bc ; column stride
	push bc
	add hl, bc
	ld b, a
	dec b
	jr nz, .column
	pop de

; VBlank starts the queued general-purpose DMA before any other graphics work.
	xor a
	ldh [rVBK], a
	ld a, HIGH(wDecompressScratch)
	ldh [rHDMA1], a
	ld a, LOW(wDecompressScratch)
	ldh [rHDMA2], a
	ld a, HIGH(vTiles2) & $1f
	ldh [rHDMA3], a
	ld a, LOW(vTiles2)
	ldh [rHDMA4], a
	ld a, 7 * 7 - 1
	ldh [hDMATransfer], a
.wait
	call DelayFrame
	ldh a, [hDMATransfer]
	and a
	jr nz, .wait

	pop af
	ldh [rVBK], a
	pop af
	ldh [rSVBK], a
	ret

trainer_pic_anim: MACRO
; trainer class, frame count, frame strip, animation script
	db \1
	dw (\2) * 7 tiles
	dw \3, \4
ENDM

TrainerPicAnimations:
	trainer_pic_anim CHAMPION,         CHAMPION_PIC_FRAMES, ChampionPicFrames, ChampionPicAnimation
	assert @ - TrainerPicAnimations == TRAINER_PIC_ANIM_ENTRY_LENGTH
	trainer_pic_anim CHAMPION_REMATCH, CHAMPION_PIC_FRAMES, ChampionPicFrames, ChampionPicAnimation
	db -1

ChampionPicFrames:
	INCBIN "gfx/trainers/animated/champion/front.2bpp"
.End:
	assert .End - ChampionPicFrames == CHAMPION_PIC_FRAMES * 7 * 7 tiles, "champion/front.png must be 56 pixels wide with 6 frames"

ChampionPicAnimation:
INCLUDE "gfx/trainers/animated/champion/anim.asm"
