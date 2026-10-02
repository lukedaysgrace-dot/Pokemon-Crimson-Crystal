	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48
	db $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51
.frame2
	db $01 ; bitmask
	db $06, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $5c
	db $5d, $5e, $5f, $60, $61, $62, $63, $64, $65, $66, $67, $68
	db $69, $6a, $6b, $6c, $6d, $6e, $6f, $70
.frame3
	db $02 ; bitmask
	db $06, $06, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7a
	db $7b, $7c, $7d, $7e, $7f, $80, $81, $82, $83, $84, $85, $86
	db $87, $6a, $6b, $88, $89, $8a, $8b, $6f, $70
.frame4
	db $02 ; bitmask
	db $06, $8c, $8d, $8e, $8f, $90, $91, $92, $93, $94, $95, $96
	db $97, $98, $99, $9a, $9b, $9c, $9d, $9e, $9f, $a0, $a1, $a2
	db $a3, $6a, $6b, $a4, $a5, $a6, $a7, $a8, $70
.frame5
	db $03 ; bitmask
	db $06, $a9, $aa, $ab, $ac, $ad, $ae, $af, $b0, $b1, $b2, $b3
	db $b4, $b5, $b6, $b7, $b8, $9d, $9e, $b9, $ba, $bb, $bc, $bd
	db $6a, $6b, $be, $bf, $c0, $c1, $c2, $c3, $c4, $70
.frame6
	db $04 ; bitmask
	db $06, $c5, $c6, $c7, $c8, $c9, $ae, $ca, $cb, $cc, $cd, $ce
	db $b4, $b5, $cf, $d0, $b8, $9d, $9e, $b9, $d1, $bb, $bc, $bd
	db $6a, $6b, $d2, $d3, $d4, $c1, $d5, $d6, $d7, $d8, $70, $d9
	db $da, $db, $dc
.frame7
	db $05 ; bitmask
	db $dd, $de, $df, $e0
