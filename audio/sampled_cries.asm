; Sampled cries use Coral's DED stream and decoder. Existing synth cries never
; enter this path. The decoder/player runs from dedicated WRAM4 so its sample
; can occupy any ROM bank, without consuming the nearly-full home bank.
; hSoundKeepalive* is a scoped overlay: those bytes are saved/restored below.
; A cry never runs inside an LCD-off sound keepalive transfer.

hDEDActive EQUS "hSoundKeepaliveOn"
hCurSampVal EQUS "hSoundKeepaliveTima"
hCurBitStream EQUS "hSoundKeepaliveAccLo"
hLoopCounter EQUS "hSoundKeepaliveAccHi"
hDEDNR51Mask EQUS "hSoundKeepaliveTac"

PlaySampledCry::
	res 7, d
	push de
	call WaitSFX
	pop de
	; Huffman decoding at 16 kHz needs CGB double speed. Ordinary gameplay
	; already uses it; the unused mobile paths may call with normal speed.
	; Preserve the caller's interrupt state across both speed transitions.
	ldh a, [rIE]
	push af
	ldh a, [rIF]
	push af
	ldh a, [rKEY1]
	and $80
	push af
	call z, SampledCryDoubleSpeed
	ld hl, SampledCryPointers
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld c, [hl]
	ld h, d
	ld l, e
	push hl
	push bc
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDEDTempSamp)
	ldh [rSVBK], a
	ld a, [wDEDAnimRequest]
	ld [wDEDAnimEnabled], a
	xor a
	ld [wDEDAnimRequest], a
	ld [wDEDAnimReady], a
	dec a
	ld [wDEDAnimLastFrame], a
	ld hl, SampledCryDecoderROM
	ld de, SampledCryDecoder
	ld bc, SampledCryDecoderEnd - SampledCryDecoder
	call CopyBytes
	pop af
	ld [wDEDSavedWRAMBank], a
	pop bc
	pop hl
	ld a, c
	ld [wDEDTimerTicks], a
	push hl
	push bc
	; Preserve all timer/interrupt state, including an already-pending interrupt.
	ldh a, [rIE]
	push af
	di
	ldh a, [rIF]
	push af
	ldh a, [rTAC]
	push af
	ldh a, [rTMA]
	push af
	ldh a, [rTIMA]
	push af
	ldh a, [hVBlank]
	push af
	ldh a, [hSoundKeepaliveOn]
	push af
	ldh a, [hCurSampVal]
	push af
	ldh a, [hCurBitStream]
	push af
	ldh a, [hLoopCounter]
	push af
	ldh a, [hDEDNR51Mask]
	push af
	ldh a, [rNR50]
	push af
	ldh a, [rNR51]
	push af
	ld a, $80
	ldh [hDEDActive], a
	ld a, 7
	ldh [hVBlank], a
	xor a
	ld [wDEDFrames], a
	ldh [rTAC], a
	ldh [rIF], a
	ldh [rNR51], a
	ldh [rNR30], a
	ld a, 1 << VBLANK | 1 << TIMER
	ldh [rIE], a
	ld a, $77
	ldh [rNR50], a
	ld a, $20
	ldh [rNR32], a
	; 64 ticks = 16.384 kHz; Coral's original encodes use 100 = 10.48576 kHz.
	ld a, [wDEDTimerTicks]
	ld c, a
	; Called/faint cries may deliberately request a lower playback pitch.
	ld a, [wCryPitch + 1]
	bit 7, a
	jr z, .normal_pitch
	ld a, c
	add 10
	ld c, a
.normal_pitch
	xor a
	sub c
	ldh [rTMA], a
	ldh [rTIMA], a
	; Wave hardware is independent of CPU speed: 100 M-cycles/sample.
	ld a, c
	add a
	cpl
	inc a
	ldh [rNR33], a
	ld c, %01000100
	ld a, [wOptions]
	bit STEREO, a
	jr z, .mono
	ld a, [wStereoPanningMask]
	and a
	jr z, .mono
	ld a, [wCryTracks]
	and a
	jr z, .mono
	and c
	ld c, a
.mono
	ld a, c
	ldh [hDEDNR51Mask], a
	; Recover sample pointer/bank underneath our saved registers.
	ld hl, sp + 26
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call SampledCryDecoder
	xor a
	ldh [rTAC], a
	ldh [rNR51], a
	ldh [rNR30], a
	pop af
	ldh [rNR51], a
	pop af
	ldh [rNR50], a
	pop af
	ldh [hDEDNR51Mask], a
	pop af
	ldh [hLoopCounter], a
	pop af
	ldh [hCurBitStream], a
	pop af
	ldh [hCurSampVal], a
	pop af
	ldh [hDEDActive], a
	pop af
	ldh [hVBlank], a
	pop af
	ldh [rTIMA], a
	pop af
	ldh [rTMA], a
	pop af
	ldh [rTAC], a
	pop af
	ldh [rIF], a
	pop af
	ldh [rIE], a
	pop bc
	pop hl
	; The music wave channel was borrowed; force its next update to reload art.
	ld hl, wChannel3NoteFlags
	set NOTE_NOISE_SAMPLING, [hl]
	ld a, [wDEDSavedWRAMBank]
	push af
	xor a
	ld [wDEDAnimEnabled], a
	ld [wDEDAnimReady], a
	pop af
	ldh [rSVBK], a
	pop af
	and a
	call z, SampledCryNormalSpeed
	pop af
	ldh [rIF], a
	pop af
	ldh [rIE], a
	ei
	ret

SampledCryDoubleSpeed:
	ldh a, [rLCDC]
	push af
	call DisableLCD
	call DoubleSpeed
	pop af
	ldh [rLCDC], a
	ret

SampledCryNormalSpeed:
	ldh a, [rLCDC]
	push af
	call DisableLCD
	call NormalSpeed
	pop af
	ldh [rLCDC], a
	ret

SampledCryPreparePicture::
; de is the picture's top-left address in wTileMap. Keep the original
; sampled IDs/data untouched; only arm this individual animation's callback.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDEDAnimRequest)
	ldh [rSVBK], a
	ld a, e
	ld [wDEDAnimSource], a
	ld a, d
	ld [wDEDAnimSource + 1], a
	ld h, d
	ld l, e
	ld de, -wTileMap & $ffff
	add hl, de
	ld b, 0
.row
	ld a, l
	sub SCREEN_WIDTH
	ld e, a
	ld a, h
	sbc 0
	jr c, .column
	ld h, a
	ld l, e
	inc b
	jr .row
.column
	ld c, l
	ld l, b
	ld h, 0
rept 5
	add hl, hl
endr
	ld b, 0
	add hl, bc
	ldh a, [hBGMapAddress]
	ld e, a
	ldh a, [hBGMapAddress + 1]
	ld d, a
	add hl, de
	ld a, l
	ld [wDEDAnimDestination], a
	ld a, h
	ld [wDEDAnimDestination + 1], a
	ld a, 1
	ld [wDEDAnimRequest], a
	pop af
	ldh [rSVBK], a
	ret

SampledCryAdvancePicture:
	ld a, [wDEDAnimEnabled]
	and a
	ret z
	ld a, [wDEDAnimReady]
	and a
	ret nz
	ld a, [wDEDFrames]
	ld hl, wDEDAnimLastFrame
	cp [hl]
	ret z
	ld [hl], a
	xor a
	ld [wDEDAnimReady], a
	farcall PokeAnim_SampledCryFrame
	ld hl, wDEDAnimSource
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDEDAnimTiles
	ld b, 7
.row
	push bc
	ld c, 7
.column
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .column
	ld bc, SCREEN_WIDTH - 7
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ld a, 1
	ld [wDEDAnimReady], a
	ret

SampledCryUploadPicture::
; Called only inside the short sampled-cry VBlank. Timer interrupts may
; preempt these 49 tile writes, so the cry's stream never waits for graphics.
	ld a, [wDEDAnimReady]
	and a
	ret z
	xor a
	ld [wDEDAnimReady], a
	ldh a, [rIE]
	push af
	ld a, 1 << TIMER
	ldh [rIE], a
	ldh a, [rVBK]
	push af
	xor a
	ldh [rVBK], a
	ld hl, wDEDAnimDestination
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wDEDAnimTiles
	ld b, 7
	ei
.row
	push bc
rept 7
	ld a, [hli]
	ld [de], a
	inc de
endr
	ld a, e
	add BG_MAP_WIDTH - 7
	ld e, a
	jr nc, .same_page
	inc d
.same_page
	pop bc
	dec b
	jr nz, .row
	di
	pop af
	ldh [rVBK], a
	pop af
	ldh [rIE], a
	ret

SampledCryDecoderROM::
LOAD "Sampled cry playback", WRAMX, BANK[4]
SampledCryDecoder::
	ldh a, [hROMBank]
	push af
	ld a, b
	rst Bankswitch
	call .play
	pop af
	rst Bankswitch
	ret

INCLUDE "audio/sampled_cry_stream.asm"

WriteDEDTreeToWRAM:
	ld d, h
	ld e, l
	ld hl, wGetDEDByte
	ld a, $f0 ; ldh a, [hCurBitStream]
	ld [hli], a
	ld a, LOW(hCurBitStream)
	ld [hli], a
.loop
	ld a, [de]
	cp $ff
	jr z, .end
	add a
	jr nc, .huffhuffjr
	add a
	jr nc, .huffleaf
	add a
	jr nc, .leafleaf
	call CopyBitreeCode
	push bc
	ld a, $da ; jp c
	ld [hli], a
	ld a, [de]
	and $f
	ld b, a
	inc de
	ld a, [de]
	inc de
	ld c, a
	push hl
	add hl, bc
	inc hl
	inc hl
	ld b, h
	ld c, l
	pop hl
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	pop bc
	jr .loop
.leafleaf
	call .leafcommon
	ld a, $06 ; ld b, immediate
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, $c9 ; ret
	ld [hli], a
	jr .loop
.huffleaf
	call .leafcommon
	jr .loop
.huffhuffjr
	call CopyBitreeCode
	ld a, $38 ; jr c
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	jr .loop
.end
	inc de
	ld h, d
	ld l, e
	ret
.leafcommon
	call CopyBitreeCode
	ld a, $06
	ld [hli], a
	ld a, [de]
	inc de
	and $f
	ld [hli], a
	ld a, $d8 ; ret c
	ld [hli], a
	ret

CopyBitreeCode:
	ld a, $0d ; dec c
	ld [hli], a
	ld a, $20 ; jr nz, +3
	ld [hli], a
	ld a, 3
	ld [hli], a
	ld a, $2a ; ld a, [hli]
	ld [hli], a
	ld a, $0e ; ld c, 8
	ld [hli], a
	ld a, 8
	ld [hli], a
	ld a, $87 ; add a
	ld [hli], a
	ret
SampledCryDecoderEnd::
ENDL

INCLUDE "audio/sampled_cry_data.asm"
