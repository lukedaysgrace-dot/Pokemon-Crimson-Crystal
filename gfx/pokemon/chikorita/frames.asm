	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b
.frame2
	db $01 ; bitmask
	db $1c, $1d, $19, $1a, $1e, $1f, $20, $1b, $21, $22, $23, $24
	db $25, $26, $27
.frame3
	db $01 ; bitmask
	db $1c, $1d, $19, $1a, $1e, $1f, $28, $1b, $21, $22, $23, $24
	db $25, $26, $27
.frame4
	db $02 ; bitmask
	db $29, $2a, $19, $1a, $2b, $1b, $2c, $2d
