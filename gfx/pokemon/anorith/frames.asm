	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e
.frame2
	db $01 ; bitmask
	db $19, $1a, $1f, $20, $1b, $21, $1c, $1d, $22, $1e, $23, $24
.frame3
	db $02 ; bitmask
	db $18, $25, $19, $1a, $26, $27, $1b, $21, $1c, $1d, $22, $1e
	db $23, $28, $29
.frame4
	db $02 ; bitmask
	db $18, $2a, $19, $1a, $26, $2b, $1b, $21, $1c, $1d, $22, $1e
	db $23, $28, $2c
.frame5
	db $03 ; bitmask
	db $18, $2d, $2e, $19, $1a, $26, $2b, $1b, $21, $1c, $1d, $22
	db $2f, $1e, $23, $28, $30, $31
