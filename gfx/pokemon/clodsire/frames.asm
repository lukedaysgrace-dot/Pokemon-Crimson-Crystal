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
.frame1
	db $00 ; bitmask
	db $31, $32, $33
.frame2
	db $01 ; bitmask
	db $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f
	db $40, $41, $42, $43, $44, $45
.frame3
	db $02 ; bitmask
	db $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51
	db $52, $53, $54, $55, $56, $57, $58, $59, $45, $5a, $5b, $5c
.frame4
	db $03 ; bitmask
	db $5d, $5e, $5f, $49, $60, $61, $62, $63, $4d, $4e, $64, $65
	db $66, $67, $52, $53, $68, $69, $6a, $6b, $57, $58, $59, $45
	db $5a, $5b, $5c
.frame5
	db $04 ; bitmask
	db $6c, $6d, $6e, $6f, $70, $71
.frame6
	db $05 ; bitmask
	db $72, $6d, $73, $74, $75, $76, $77, $78
.frame7
	db $06 ; bitmask
	db $79, $7a, $7b, $6d, $7c, $74, $7d, $7e, $7f, $80, $81
.frame8
	db $07 ; bitmask
	db $79, $7a, $82, $6d, $83, $84, $85, $86, $7d, $87, $88, $89
	db $8a, $8b, $8c, $8d, $8e, $8f
.frame9
	db $08 ; bitmask
	db $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $83
	db $84, $9b, $9c, $9d, $9e, $9f, $a0, $a1, $a2, $a3, $a4, $a5
	db $a6, $45, $a7, $8a, $8b, $8c, $a8, $8e, $8f
.frame10
	db $04 ; bitmask
	db $6c, $a9, $6e, $6f, $70, $aa
.frame11
	db $09 ; bitmask
	db $ab, $ac, $ad, $ae, $af, $b0, $b1, $b2, $b3, $b4, $b5, $b6
	db $b7, $b8, $b9, $ba, $bb, $bc, $bd, $be
