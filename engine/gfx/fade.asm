SECTION "Smooth Palette Fades", ROMX

; Smooth palette fade engine, ported from Polished Crystal / Polished Coral.
; Instead of stepping through 4-shade DMG tables, this interpolates every
; CGB color channel (red, green, blue) toward its destination over up to
; 31 steps, one step per frame, producing smooth transitions on CGB.
;
; Unlike Polished (which always runs the CGB at double speed), Crimson runs
; at single speed, so the per-step math is streamlined: channel step sizes
; come from a precomputed table (data/fade_step_amounts.asm) indexed by a
; per-step base pointer, keeping one full step well inside one frame. Each
; step is fully computed before hCGBPalUpdate is raised, so the screen only
; ever shows clean, complete fade steps - no palette tearing.

_DoFadePalettes::
; Fades the active palettes (wBGPals2/wOBPals2) toward a destination,
; uploading each intermediate step to hardware via hCGBPalUpdate.
;
; c: fade duration in frames (up to 31 distinct color steps)
; hPalFadeMode selects the destination and which palettes fade:
;   PALFADE_BOTH / PALFADE_BG / PALFADE_OBJ: fade toward wBGPals1/wOBPals1
;   PALFADE_TO_BLACK: fade everything to black (wBGPals1/wOBPals1 untouched)
;   PALFADE_TO_WHITE: fade everything to white (wBGPals1/wOBPals1 untouched)
;   PALFADE_FLASH: fade to black, then back toward wBGPals1/wOBPals1
	ldh a, [rSVBK]
	push af
	push hl
	push de
.restart_dofade
	push bc
	ld a, BANK(wBGPals2)
	ldh [rSVBK], a

	call FadePalettesInit
	jr c, .done

.outer_loop
	ldh a, [hVBlankCounter]
	ld [wPalFadeFrameStamp], a
	call FadePalettesStep
	call .FadeDelay
	ld a, [wPalFadeDelayFrames]
	dec a
	ld [wPalFadeDelayFrames], a
	jp nz, .outer_loop
.done
	pop bc
	ldh a, [hPalFadeMode]
	bit PALFADE_FLASH_F, a
	res PALFADE_FLASH_F, a
	ldh [hPalFadeMode], a
	jp nz, .restart_dofade
	pop de
	pop hl
	pop af
	ldh [rSVBK], a
	ret

.FadeDelay:
; Show the freshly computed step, then hold it so every step lasts exactly
; the same number of frames (at least 2: one for the step computation, one
; showing the uploaded result). A fixed cadence measured from the step's
; start (wPalFadeFrameStamp) keeps the fade perfectly even no matter how
; long the computation or the VBlank handler took - uneven step timing
; reads as stutter on a detailed screen like the overworld.
	ld a, [wPalFadeDelayFrames]
	ld c, a
	ld hl, wPalFadeDelay
	ld a, [hl]
	call SimpleDivide
	inc b
	dec b
	jr nz, .delay_ok
	inc b
.delay_ok
	ld a, [hl]
	sub b
	ld [hld], a
	ld a, 1
	jr nz, .delay_finished
	ld [hl], a
.delay_finished
	ldh [hCGBPalUpdate], a
	; c = this step's total length: at least 2 frames
	ld a, b
	cp 2
	jr nc, .got_length
	ld a, 2
.got_length
	ld c, a
.wait_loop
	call DelayFrame
	ld a, [wPalFadeFrameStamp]
	ld b, a
	ldh a, [hVBlankCounter]
	sub b
	jr z, .counter_dead
	cp c
	jr c, .wait_loop
	ret

.counter_dead
; Not every VBlank routine ticks hVBlankCounter (only VBlank0/VBlank6 do).
; If it isn't moving, just pace the step with one more frame instead of
; waiting on it forever.
	jp DelayFrame

FadePalettesInit:
; No matter what, we always take up to 31 color fade steps.
; Evenly divide DelayFrames in case the fade duration is more.
	ld a, c
	cp 32
	ld [wPalFadeDelayFrames], a
	ld [wPalFadeDelay], a
	jr c, .got_delay
	ld a, 31
	ld [wPalFadeDelayFrames], a

.got_delay
	and a
	jr nz, .has_delay
	call SetPalettes
	scf
	ret

.has_delay
	ldh a, [hPalFadeMode]
	bit PALFADE_PARTIAL_F, a
	jr z, .not_partial
	ld a, b
	ld [wPalFadeDelay], a

.not_partial
	and a
	ret

FadePalettesStep:
; Advance every fading color one step toward its destination.

	; Point wPalFadeStepBase at this step's row of FadeStepAmounts
	; (steps remaining * 32), so the per-channel lookup is just base + dist.
	ld a, [wPalFadeDelayFrames]
	ld l, a
	ld h, 0
rept 5
	add hl, hl
endr
	ld de, FadeStepAmounts
	add hl, de
	ld a, l
	ld [wPalFadeStepBase], a
	ld a, h
	ld [wPalFadeStepBase + 1], a

	ldh a, [hPalFadeMode]
	and PALFADE_WHICH
	ld hl, wBGPals2
	ld d, NUM_PAL_COLORS * 16 ; bg + ob palettes
	jr z, .got_count
	dec a
	ld d, NUM_PAL_COLORS * 8 ; bg or ob palettes only
	jr z, .got_count
	ld hl, wOBPals2
.got_count
.inner_loop
	push de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ldh a, [hPalFadeMode]
	and PALFADE_FLASH | PALFADE_TO_BLACK
	jr z, .not_black
	ld bc, 0 ; destination: black
	dec hl
	jr .got_destination

.not_black
	ldh a, [hPalFadeMode]
	and PALFADE_TO_WHITE
	jr z, .from_pals1
	ld bc, $7fff ; destination: white
	dec hl
	jr .got_destination

.from_pals1
	ld bc, wBGPals1 - wBGPals2
	add hl, bc
	ld a, [hld]
	ld b, a
	ld c, [hl]
	push bc
	ld bc, wBGPals2 - wBGPals1
	add hl, bc
	pop bc

.got_destination
	; de: active color, bc: color we're fading towards (high endian)
	push hl

	; Red
	ld a, c
	and %00011111
	ld l, a
	ld a, e
	and %00011111
	call .fadeColorStep
	ld a, e
	and %11100000
	or l
	ld e, a

	; Green
	push bc
	call .getGreen
	ld l, a
	ld b, d
	ld c, e
	call .getGreen
	pop bc
	call .fadeColorStep
	sla l
	swap l
	ld a, l
	and %11100000
	ld h, a
	ld a, e
	and %00011111
	or h
	ld e, a
	ld a, l
	and %00000011
	ld l, a
	ld a, d
	and %01111100
	or l
	ld d, a

	; Blue
	ld a, b
	call .getBlue
	ld l, a
	ld a, d
	call .getBlue
	call .fadeColorStep
	sla l
	sla l
	ld a, d
	and %00000011
	or l
	ld d, a

	; Store changed color
	pop hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	pop de
	dec d
	jr nz, .inner_loop
	ret

.getGreen:
	srl b
	rr c
	srl b
	rr c
	ld a, c
	rrca
.getBlue:
	rrca
	rrca
	and %00011111
	ret

.fadeColorStep:
; Move the active channel one step toward the target channel.
; a: active channel value, l: channel value we're fading towards
; Returns the new active value in l. Preserves bc and de.
	cp l
	ret z
	jr c, .increasing

	; decreasing: new = target + dist - move
	sub l ; a = dist (1-31)
	ld h, a
	push hl ; h = dist, l = target
	call .lookup
	pop hl
	cpl
	inc a ; a = -move
	add h
	add l
	ld l, a
	ret

.increasing
	; increasing: new = active + move
	ld h, a
	ld a, l
	sub h ; a = dist (1-31)
	push hl ; h = active
	call .lookup
	pop hl
	add h
	ld l, a
	ret

.lookup:
; a = distance (1-31) -> a = step amount from this step's table row
	ld l, a
	ld a, [wPalFadeStepBase]
	add l
	ld l, a
	ld a, [wPalFadeStepBase + 1]
	adc 0
	ld h, a
	ld a, [hl]
	ret

FadeStepAmounts:
; How far to move a color channel on one fade step, indexed by
; [steps remaining][distance to target]. Replicates the arithmetic of
; Polished Crystal's FadeColorStep, so every channel lands exactly on
; its destination as the step counter reaches zero.
INCLUDE "data/fade_step_amounts.asm"
