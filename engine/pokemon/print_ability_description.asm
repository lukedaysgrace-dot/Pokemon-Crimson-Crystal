PrintAbilityDescriptionStats::
; Print the description for ability b at de (two consecutive rows).
;
; Coords are passed in de because the farcall macro clobbers a and hl.
;
; AbilityDescriptions entries use the text/next/done macros, so they
; start with TX_START and have no "@" terminator; PlaceString can't
; render them directly. This walks the string by hand instead.
; Lives in the same bank as AbilityDescriptions; reached via farcall.
	ld l, b
	ld h, 0
	add hl, hl
	ld bc, AbilityDescriptions
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = description text
.next_line
	; remember the line start in bc
	ld b, d
	ld c, e
.char_loop
	ld a, [hli]
	cp TX_START
	jr z, .char_loop
	cp "<NEXT>"
	jr z, .line_break
	cp "<DONE>"
	ret z
	cp "@"
	ret z
	ld [de], a
	inc de
	jr .char_loop
.line_break
	; de = line start + 1 row
	ld a, c
	add SCREEN_WIDTH
	ld e, a
	ld a, b
	adc 0
	ld d, a
	jr .next_line
