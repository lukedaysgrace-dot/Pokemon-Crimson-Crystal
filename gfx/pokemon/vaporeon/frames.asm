	dw .frame1
	dw .frame2
	dw .frame3
.frame1
	db $00 ; bitmask
	db $03, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e
	db $2f, $30, $31
.frame2
	db $00 ; bitmask
	db $32, $33, $34, $1f, $35, $36, $29, $2a, $2b, $2c, $2d, $2e
	db $2f, $30, $31
.frame3
	db $01 ; bitmask
	db $37, $38, $39, $3a
