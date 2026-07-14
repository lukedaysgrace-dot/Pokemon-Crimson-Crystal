ContactMoves::
; bitfield indexed by 16-bit move index (bit i&7 of byte i>>3, POUND = 1);
; set = the move makes contact (Gen IV contact flags; see CheckContactMove)
	db $be, $9f, $fa, $ef, $7f, $10, $00, $00
	db $7f, $00, $01, $08, $0c, $00, $20, $84
	db $15, $21, $04, $45, $ac, $91, $88, $02
	db $00, $61, $0e, $85, $b1, $43, $24, $92
	db $eb, $2f, $25, $ff, $d3, $bf, $01, $4e
	db $c1, $0a, $00, $3e
