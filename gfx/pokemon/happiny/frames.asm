	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24
	db $25, $26, $27, $28, $29, $2a, $2b
.frame2
	db $00 ; bitmask
	db $2c, $2d, $2e, $2f, $30, $31, $32, $33, $34, $35, $36, $37
	db $38, $39, $3a, $3b, $29, $3c, $3d
.frame3
	db $00 ; bitmask
	db $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49
	db $4a, $4b, $4c, $4d, $4e, $4f, $50
.frame4
	db $01 ; bitmask
	db $51, $52, $53, $54
.frame5
	db $00 ; bitmask
	db $19, $1a, $1b, $55, $1d, $1e, $1f, $20, $56, $57, $23, $24
	db $25, $26, $27, $28, $29, $2a, $2b
