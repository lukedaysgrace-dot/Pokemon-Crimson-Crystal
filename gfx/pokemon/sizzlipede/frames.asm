	dw .frame1
	dw .frame2
	dw .frame3
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e
.frame2
	db $00 ; bitmask
	db $19, $1f, $1b, $1c, $1d, $1e
.frame3
	db $01 ; bitmask
	db $19, $1f, $1b, $1c, $20, $21, $1e, $22, $23, $24, $25
