	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
	dw .frame9
	dw .frame10
	dw .frame11
	dw .frame12
.frame1
	db $00 ; bitmask
	db $31, $00, $32, $33, $34, $16, $35, $36, $37, $38, $39, $3a
	db $3b, $3c, $3d, $3e, $3f, $40, $41, $00, $42, $43, $44, $45
	db $46, $00, $47, $48, $49, $4a, $4b, $00, $4c, $4d, $4e, $4f
.frame2
	db $01 ; bitmask
	db $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $00
	db $5b, $5c, $5d, $5e, $5f, $00, $00, $60, $61, $62, $63, $64
	db $65, $66, $67, $68, $69, $6a, $00, $6b, $6c, $6d, $6e
.frame3
	db $02 ; bitmask
	db $6f, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7a
	db $7b, $7c, $00, $7d, $7e, $7f, $80, $81, $00, $00, $82, $83
	db $84, $00, $00, $00, $85, $86, $87, $00, $00, $00, $00, $00
	db $00, $00
.frame4
	db $02 ; bitmask
	db $88, $89, $8a, $8b, $8c, $8d, $8e, $8f, $90, $91, $92, $93
	db $94, $95, $00, $96, $97, $98, $99, $9a, $00, $00, $00, $9b
	db $9c, $9d, $9e, $00, $00, $00, $9f, $a0, $a1, $00, $00, $00
	db $00, $00
.frame5
	db $03 ; bitmask
	db $a2, $a3, $a4, $a5, $a6, $a7, $a8, $00, $a9, $aa, $ab, $ac
	db $8b, $00, $00, $ad, $ae, $af, $b0, $00, $00, $00, $b1, $b2
	db $b3, $b4, $b5, $00, $b6, $b7, $b8, $b9, $ba, $00, $bb, $bc
	db $bd, $be, $bf
.frame6
	db $04 ; bitmask
	db $00, $00, $16, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8
	db $c9, $00, $00, $ca, $cb, $cc, $cd, $00, $00, $ce, $cf, $d0
	db $d1, $d2, $00, $d3, $d4, $d5, $d6, $d7, $00, $d8, $d9, $da
	db $db, $bf
.frame7
	db $05 ; bitmask
	db $dc, $dd, $00, $de, $df, $e0, $e1, $e2, $e3, $e4, $e5, $e6
	db $e7, $e8, $e9, $ea, $eb, $ec
.frame8
	db $06 ; bitmask
	db $ed, $ee, $ef
.frame9
	db $07 ; bitmask
	db $f0, $f1, $f2
.frame10
	db $08 ; bitmask
.frame11
	db $07 ; bitmask
	db $f0, $f1, $f2
.frame12
	db $08 ; bitmask
