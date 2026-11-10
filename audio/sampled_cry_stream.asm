.play
	call WriteDEDTreeToWRAM
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, 8
	ldh [hCurSampVal], a
	ld c, 1
	xor a
	ld [wDEDRingRead], a
	ld [wDEDRingWrite], a
	ld [wDEDRingCount], a
	ld [wDEDSourceDone], a
	ld [wDEDFinished], a
	ld [wDEDTimerStarted], a
	ld [wDEDUnderruns], a
	ld [wDEDPlayedBlocks], a
	ld [wDEDPlayedBlocks + 1], a
	ei
.loop
	ld a, [wDEDFinished]
	and a
	ret nz
	ld a, d
	or e
	jr z, .source_done
	ld a, [wDEDRingCount]
	cp 16
	jr z, .dispatch
	push de
	ld a, [wDEDRingWrite]
	ld e, a
	ld d, HIGH(wDEDRingBuffer)
.decode_byte
	push de
	call wGetDEDByte
	ldh [hCurBitStream], a
	ldh a, [hCurSampVal]
	add b
	and $f
	swap a
	ld d, a
	call wGetDEDByte
	ldh [hCurBitStream], a
	ld a, d
	swap a
	add b
	and $f
	ldh [hCurSampVal], a
	or d
	pop de
	ld [de], a
	inc e
	ld a, e
	and $f
	jr nz, .decode_byte
	ld a, e
	ld [wDEDRingWrite], a
	pop de
	dec de
	push hl
	ld hl, wDEDRingCount
	di
	inc [hl] ; publish the complete block atomically
	ei
	pop hl
	ld a, d
	or e
	jr nz, .dispatch
.source_done
	ld a, 1
	ld [wDEDSourceDone], a
.dispatch
	ld a, [wDEDTimerStarted]
	and a
	jr nz, .animate
	ld a, [wDEDSourceDone]
	and a
	jr nz, .start_timer
	ld a, [wDEDRingCount]
	cp 8
	jp c, .loop
.start_timer
	ld a, 1
	ld [wDEDTimerStarted], a
	ldh a, [rTMA]
	ldh [rTIMA], a
	ld a, 1 << rTAC_ON | rTAC_16384_HZ
	ldh [rTAC], a
.animate
	ld a, [wDEDSourceDone]
	and a
	jr nz, .picture
	ld a, [wDEDRingCount]
	cp 8
	jp c, .loop
.picture
	push hl
	push de
	push bc
	homecall SampledCryAdvancePicture
	pop bc
	pop de
	pop hl
	ld a, [wDEDSourceDone]
	and a
	jr nz, .wait
	ld a, [wDEDRingCount]
	cp 16
	jp c, .loop
.wait
	halt
	nop
	jp .loop

SampledCryInterrupt::
; ROM0 has saved all registers and selected WRAM4. Streaming never changes
; the ROM bank, decoder registers, or carry in the interrupted program.
	ld a, [wDEDRingCount]
	and a
	jp z, .empty
	ld a, [wDEDRingRead]
	ld l, a
	ld h, HIGH(wDEDRingBuffer)
	ld de, wDEDTempSamp
rept 16
	ld a, [hli]
	ld [de], a
	inc de
endr
	xor a
	ldh [rNR51], a
	ldh [rNR30], a
	ld hl, wDEDTempSamp
DED_WAVE = rWave_0
rept 16
	ld a, [hli]
	ldh [DED_WAVE], a
DED_WAVE = DED_WAVE + 1
endr
	ld a, $80
	ldh [rNR30], a
	ld a, $87
	ldh [rNR34], a
	ldh a, [hDEDNR51Mask]
	ldh [rNR51], a
	ld a, [wDEDRingRead]
	add 16
	ld [wDEDRingRead], a
	ld hl, wDEDRingCount
	dec [hl]
	ld hl, wDEDPlayedBlocks
	inc [hl]
	jr nz, .played
	inc hl
	inc [hl]
.played
	scf
	ret
.empty
	ld a, [wDEDSourceDone]
	and a
	jr z, .underrun
	ld a, 1
	ld [wDEDFinished], a
	xor a
	ldh [rTAC], a
	ret
.underrun
	ld hl, wDEDUnderruns
	inc [hl]
	and a
	ret
