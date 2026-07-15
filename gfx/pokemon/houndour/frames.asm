	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $12, $24, $25, $26, $12, $27, $28, $29, $2a, $12, $2b, $2c
	db $2d, $2e, $2f, $30, $31, $32, $33, $34, $35, $36, $12
.frame2
	db $01 ; bitmask
	db $12, $24, $25, $26, $12, $27, $37, $38, $2a, $12, $2b, $2c
	db $2d, $2e, $2f, $30, $31, $39, $3a, $3b, $3c, $12
.frame3
	db $01 ; bitmask
	db $12, $3d, $3e, $3f, $12, $40, $41, $42, $2a, $12, $43, $44
	db $45, $2e, $2f, $30, $31, $39, $3a, $3b, $3c, $12
.frame4
	db $02 ; bitmask
	db $46, $47
