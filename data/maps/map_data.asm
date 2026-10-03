INCLUDE "constants.asm"


SECTION "Maps", ROMX

INCLUDE "data/maps/maps.asm"
INCLUDE "data/maps/attributes.asm"

INCLUDE "data/maps/blocks.asm"

INCLUDE "data/maps/scripts.asm"


SECTION "Trainer Portrait Texts", ROMX

; Who says each map text, for overworld trainer portraits. It is assembled with
; the map scripts so it can name their texts and object constants.

TrainerPortrait_FindText::
; Look up the text at [wPortraitTextBank]:[wPortraitTextAddr] in PortraitTexts.
; Returns its entry in a, or -1 if it is not listed.
	ld a, [wPortraitTextBank]
	ld b, a
	ld a, [wPortraitTextAddr]
	ld e, a
	ld a, [wPortraitTextAddr + 1]
	ld d, a
	ld hl, PortraitTexts
.loop
	ld a, [hli]
	cp -1
	ret z
	cp b
	jr nz, .skip3
	ld a, [hli]
	cp e
	jr nz, .skip2
	ld a, [hli]
	cp d
	jr nz, .skip1
	ld a, [hl]
	ret
.skip3
	inc hl
.skip2
	inc hl
.skip1
	inc hl
	jr .loop

INCLUDE "data/maps/portrait_texts.asm"
