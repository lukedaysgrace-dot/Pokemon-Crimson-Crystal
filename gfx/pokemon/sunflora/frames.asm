	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f
	db $30, $31, $32, $33, $34
.frame2
	db $01 ; bitmask
	db $24, $35, $36, $37, $38, $39, $3a, $3b, $2b, $3c, $3d, $3e
	db $3f, $2e, $40, $41, $42, $43, $33, $34
.frame3
	db $02 ; bitmask
	db $18, $44, $45, $46, $47, $48, $49, $4a, $2b, $4b, $4c, $4d
	db $4e, $2e, $4f, $50, $51, $52, $18, $53, $54
.frame4
	db $03 ; bitmask
	db $55, $56
