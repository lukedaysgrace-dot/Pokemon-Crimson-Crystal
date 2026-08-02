; Functions to fade the screen in and out.

; On CGB, all of these use the smooth color fade engine ported from
; Polished Crystal (engine/gfx/fade.asm), which interpolates every RGB
; channel instead of stepping through 4-shade palette tables.
; On DMG/SGB, the original 4-step table fades are kept.

FadePalettes::
; Fade active palettes (wBGPals2/wOBPals2) to wBGPals1/wOBPals1 in c frames.
	xor a
	jr DoFadePalettes

FadeToBlackPals::
; Fade active palettes to black in c frames. wBGPals1/wOBPals1 are untouched.
	ld a, PALFADE_TO_BLACK
	jr DoFadePalettes

FadeToWhitePals::
; Fade active palettes to white in c frames. wBGPals1/wOBPals1 are untouched.
	ld a, PALFADE_TO_WHITE
DoFadePalettes::
	ldh [hPalFadeMode], a
	farcall _DoFadePalettes
	ret

RotateFourPalettesRight::
; Fade in from black.
	ldh a, [hCGB]
	and a
	jr z, .dmg
	ld c, 10
	jr FadePalettes

.dmg
	ld hl, IncGradGBPalTable_08
	ld b, 4
	jr RotatePalettesRight

RotateThreePalettesRight::
; Fade out to white.
	ldh a, [hCGB]
	and a
	jr z, .dmg
	ld c, 8
	jr FadeToWhitePals

.dmg
	ld hl, IncGradGBPalTable_13
	ld b, 3
RotatePalettesRight::
; Rotate palettes to the right and fill with loaded colors from the left
; If we're already at the leftmost color, fill with the leftmost color
	push de
	ld a, [hli]
	call DmgToCgbBGPals
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	call DmgToCgbObjPals
	ld c, 8
	call DelayFrames
	pop de
	dec b
	jr nz, RotatePalettesRight
	ret

RotateFourPalettesLeft::
; Fade out to black.
	ldh a, [hCGB]
	and a
	jr z, .dmg
	ld c, 10
	jr FadeToBlackPals

.dmg
	ld hl, IncGradGBPalTable_12 - 1
	ld b, 4
	jr RotatePalettesLeft

RotateThreePalettesLeft::
; Fade in from white.
	ldh a, [hCGB]
	and a
	jr z, .dmg
	ld c, 8
	jr FadePalettes

.dmg
	ld hl, IncGradGBPalTable_15 - 1
	ld b, 3
RotatePalettesLeft::
; Rotate palettes to the left and fill with loaded colors from the right
; If we're already at the rightmost color, fill with the rightmost color
	push de
	ld a, [hld]
	ld d, a
	ld a, [hld]
	ld e, a
	call DmgToCgbObjPals
	ld a, [hld]
	call DmgToCgbBGPals
	ld c, 8
	call DelayFrames
	pop de
	dec b
	jr nz, RotatePalettesLeft
	ret

IncGradGBPalTable_00:: dc 3,3,3,3, 3,3,3,3, 3,3,3,3
IncGradGBPalTable_01:: dc 3,3,3,2, 3,3,3,2, 3,3,3,2
IncGradGBPalTable_02:: dc 3,3,2,1, 3,3,2,1, 3,3,2,1
IncGradGBPalTable_03:: dc 3,2,1,0, 3,2,1,0, 3,2,1,0

IncGradGBPalTable_04:: dc 3,2,1,0, 3,2,1,0, 3,2,1,0
IncGradGBPalTable_05:: dc 2,1,0,0, 2,1,0,0, 2,1,0,0
IncGradGBPalTable_06:: dc 1,0,0,0, 1,0,0,0, 1,0,0,0

IncGradGBPalTable_07:: dc 0,0,0,0, 0,0,0,0, 0,0,0,0
;                           bgp      obp1     obp2
IncGradGBPalTable_08:: dc 3,3,3,3, 3,3,3,3, 3,3,3,3
IncGradGBPalTable_09:: dc 3,3,3,2, 3,3,3,2, 3,3,2,0
IncGradGBPalTable_10:: dc 3,3,2,1, 3,2,1,0, 3,2,1,0
IncGradGBPalTable_11:: dc 3,2,1,0, 3,1,0,0, 3,2,0,0

IncGradGBPalTable_12:: dc 3,2,1,0, 3,1,0,0, 3,2,0,0
IncGradGBPalTable_13:: dc 2,1,0,0, 2,0,0,0, 2,1,0,0
IncGradGBPalTable_14:: dc 1,0,0,0, 1,0,0,0, 1,0,0,0

IncGradGBPalTable_15:: dc 0,0,0,0, 0,0,0,0, 0,0,0,0
