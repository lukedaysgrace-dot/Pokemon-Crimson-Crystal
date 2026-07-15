	dw .frame1
	dw .frame2
	dw .frame3
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b
.frame2
	db $01 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20
.frame3
	db $02 ; bitmask
	db $21, $22, $19, $23, $24, $1a, $25, $26, $1b
