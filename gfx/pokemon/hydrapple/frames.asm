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
	dw .frame13
	dw .frame14
	dw .frame15
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40, $41, $42
.frame2
	db $01 ; bitmask
.frame3
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40, $41, $42
.frame4
	db $01 ; bitmask
.frame5
	db $02 ; bitmask
	db $43, $44, $45, $46, $47, $48, $49, $4a
.frame6
	db $03 ; bitmask
	db $4b, $4c, $4d, $4e, $4f, $50, $51, $52, $53, $54
.frame7
	db $04 ; bitmask
	db $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $5f, $60
	db $61
.frame8
	db $05 ; bitmask
	db $55, $56, $57, $58, $62, $63, $5b, $5c, $5d, $64, $65, $60
	db $61, $66
.frame9
	db $06 ; bitmask
	db $55, $56, $67, $58, $62, $68, $69, $5c, $5d, $64, $65, $60
	db $61, $6a, $66, $6b, $6c, $6d
.frame10
	db $04 ; bitmask
	db $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $5f, $60
	db $61
.frame11
	db $03 ; bitmask
	db $4b, $4c, $4d, $4e, $4f, $50, $51, $52, $53, $54
.frame12
	db $01 ; bitmask
.frame13
	db $07 ; bitmask
	db $6e, $6f, $70, $71
.frame14
	db $01 ; bitmask
.frame15
	db $07 ; bitmask
	db $6e, $6f, $70, $71
