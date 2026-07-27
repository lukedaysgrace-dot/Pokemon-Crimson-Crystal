	dw .frame1
	dw .frame2
	dw .frame3
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21
.frame2
	db $01 ; bitmask
	db $19, $22, $1a, $1b, $23, $24, $25, $1d, $1e, $26, $27, $20
	db $28, $21
.frame3
	db $02 ; bitmask
	db $29, $25, $2a
