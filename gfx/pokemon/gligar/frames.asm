	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $22, $22, $24, $25, $22, $26, $27, $28, $29, $2a, $2b, $2c
	db $2d, $2e, $2f, $30, $31, $22, $22, $32, $33, $34
.frame2
	db $01 ; bitmask
	db $22, $22, $35, $36, $22, $22, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48
	db $22, $22, $22, $22, $49
.frame3
	db $02 ; bitmask
	db $29, $4a, $2b, $2c
.frame4
	db $03 ; bitmask
	db $29, $4b, $4c, $2b, $4d, $4e
