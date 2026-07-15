	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
	dw .frame9
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48
	db $49, $44
.frame2
	db $01 ; bitmask
	db $4a, $4b, $4c, $34, $4d, $4e, $4f, $50, $51, $52, $53, $54
	db $55, $3c, $56, $57, $58, $59, $3f, $5a, $5b, $5c, $5d, $5e
	db $5f, $60, $61, $62, $44, $63, $64, $65, $66, $67, $68, $44
.frame3
	db $02 ; bitmask
	db $69, $6a, $6b, $6c, $6d, $6e, $6f, $70, $71, $72, $73, $74
	db $75, $57, $44, $44, $3f, $76, $77, $78, $79, $7a, $5e, $7b
	db $7c, $7d, $62, $7e, $7f, $44, $80, $81, $82, $83, $84, $44
.frame4
	db $03 ; bitmask
	db $85, $86, $87, $6c, $88, $89, $70, $8a, $8b, $75, $8c, $8d
	db $3f, $76, $77, $8e, $8f, $90, $91, $92, $93, $94, $43, $95
	db $44, $96, $97, $98, $99, $44
.frame5
	db $04 ; bitmask
	db $85, $86, $87, $6c, $88, $89, $70, $8a, $8b, $75, $9a, $9b
	db $3f, $76, $77, $8e, $9c, $90, $91, $92, $9d, $94, $43, $95
	db $9e, $44, $9f, $97, $98, $99, $a0, $44
.frame6
	db $05 ; bitmask
	db $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac
	db $ad, $ae, $3f, $af, $b0, $b1, $b2, $b3, $b4, $b5, $b6, $43
	db $b7, $b8, $b9, $ba, $98, $bb, $bc, $44
.frame7
	db $06 ; bitmask
	db $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $bd, $be, $bf, $c0
	db $c1, $c2, $c3, $b0, $c4, $c5, $b3, $c6, $c7, $c8, $43, $b7
	db $c9, $ca, $cb, $98, $cc, $cd, $44
.frame8
	db $07 ; bitmask
	db $51, $ce, $56, $5a, $cf, $5f
.frame9
	db $08 ; bitmask
	db $7b, $7e, $7f, $83, $d0
