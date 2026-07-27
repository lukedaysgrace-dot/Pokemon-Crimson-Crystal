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
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f
.frame2
	db $00 ; bitmask
	db $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b
	db $4c, $4d, $4e
.frame3
	db $01 ; bitmask
	db $4f, $50, $51, $52, $53, $48, $04, $04, $4b, $04
.frame4
	db $02 ; bitmask
	db $4f, $33, $54, $55, $36, $56, $57, $48, $04, $04, $4b, $04
.frame5
	db $03 ; bitmask
	db $58, $59, $42, $5a, $44, $45, $5b, $5c, $48, $04, $04, $4b
	db $04
.frame6
	db $04 ; bitmask
	db $5d, $5e, $4f, $5f, $50, $51, $52, $53, $48, $04, $04, $4b
	db $04
.frame7
	db $05 ; bitmask
	db $60, $61, $4f, $62, $63, $54, $55, $36, $56, $57, $48, $04
	db $04, $4b, $04
.frame8
	db $03 ; bitmask
	db $64, $65, $42, $66, $44, $45, $67, $68, $69, $04, $6a, $4b
	db $04
.frame9
	db $06 ; bitmask
	db $6b, $5e, $6c, $42, $6d, $6e, $45, $6f, $70, $71, $72, $73
	db $74, $75, $76, $76, $04, $77, $78
.frame10
	db $07 ; bitmask
	db $60, $61, $79, $7a, $63, $7b, $7c, $36, $7d, $7e, $7f, $80
	db $74, $81, $82, $04, $83, $84
.frame11
	db $08 ; bitmask
	db $60, $61, $85, $63
.frame12
	db $09 ; bitmask
	db $60, $61, $6c, $86, $63, $6d, $6e, $45, $6f, $70, $71, $72
	db $73, $76, $76
