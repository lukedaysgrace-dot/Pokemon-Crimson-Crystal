ContactMoves::
; bitfield indexed by 16-bit move index (bit i&7 of byte i>>3, POUND = 1);
; set = the move makes contact (Gen IV contact flags; see CheckContactMove)
	db $7c, $3f, $f5, $df, $ff, $20, $00, $00
	db $fe, $00, $02, $10, $18, $00, $40, $08
	db $2b, $42, $09, $8a, $58, $23, $11, $05
	db $00, $c2, $1c, $0a, $63, $87, $48, $04
	db $d7, $5f, $4a, $fe, $a7, $7f, $03, $9c
	db $82, $15, $00, $1c
