	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
.frame1
	db $00 ; bitmask
	db $00, $00, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a
	db $3b, $3c, $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46
	db $47, $48, $49, $4a, $4b, $4c, $00, $4d, $4e, $00
.frame2
	db $01 ; bitmask
	db $00, $00, $4f, $50, $51, $52, $53, $54, $55, $56, $57, $58
	db $59, $5a, $5b, $5c, $5d, $5e, $5f, $60, $61, $62, $63, $64
	db $65, $66, $67, $68, $69, $6a, $6b, $6c, $00, $00, $6d, $6e
	db $00, $00
.frame3
	db $02 ; bitmask
	db $00, $00, $6f, $70, $71, $72, $73, $74, $75, $76, $77, $78
	db $79, $7a, $7b, $7c, $7d, $7e, $7f, $80, $81, $82, $83, $84
	db $85, $67, $2c, $86, $87, $88, $89, $8a, $00, $00, $00, $00
.frame4
	db $03 ; bitmask
	db $8b, $00, $8c, $8d, $8e, $8f, $90, $91, $92, $93, $94, $95
	db $96, $2c, $97, $98, $99, $9a, $9b, $7f, $9c, $9d, $9e, $9f
	db $a0, $a1, $67, $a2, $a3, $a4, $a5, $a6, $00, $00, $00, $00
.frame5
	db $04 ; bitmask
	db $a7, $a8, $8c, $8d, $a9, $aa, $ab, $ac, $91, $92, $ad, $ae
	db $af, $b0, $2c, $97, $98, $b1, $9a, $9b, $7f, $9c, $9d, $9e
	db $b2, $b3, $a1, $67, $a2, $b4, $b5, $b6, $a6, $00, $00, $b7
	db $00
.frame6
	db $05 ; bitmask
	db $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf, $c0, $c1, $c2, $c3
	db $c4, $c5, $c6, $c7, $c8, $c9, $9a, $ca, $cb, $cc, $cd, $ce
	db $cf, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $a6, $00, $00, $d7
	db $00
.frame7
	db $06 ; bitmask
	db $00, $00, $d8, $d9, $da, $db, $dc, $dd, $de, $df, $e0, $e1
	db $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ed
	db $ee, $ef, $f0, $f1, $f2, $f3, $4c, $00, $f4, $f5, $00
.frame8
	db $07 ; bitmask
	db $f6
