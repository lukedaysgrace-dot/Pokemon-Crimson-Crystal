	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21
.frame2
	db $01 ; bitmask
	db $22, $23, $19, $24, $25, $1c, $26, $27, $1f, $20, $28, $29
	db $2a
.frame3
	db $01 ; bitmask
	db $2b, $2c, $19, $2d, $2e, $1c, $26, $27, $1f, $20, $28, $29
	db $2a
.frame4
	db $01 ; bitmask
	db $2f, $30, $19, $2d, $31, $1c, $26, $27, $1f, $20, $28, $29
	db $2a
.frame5
	db $00 ; bitmask
	db $19, $32, $33, $1c, $26, $27, $1f, $20, $28
