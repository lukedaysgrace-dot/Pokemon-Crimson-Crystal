	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24
	db $25, $26, $27
.frame2
	db $00 ; bitmask
	db $19, $1a, $1b, $28, $1d, $1e, $1f, $29, $21, $22, $23, $24
	db $25, $26, $27
.frame3
	db $00 ; bitmask
	db $19, $1a, $1b, $2a, $1d, $1e, $1f, $2b, $21, $22, $23, $24
	db $25, $26, $27
.frame4
	db $01 ; bitmask
	db $2c, $2d, $2e, $2f
.frame5
	db $02 ; bitmask
	db $30, $31
