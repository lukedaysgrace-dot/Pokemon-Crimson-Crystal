	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20
.frame2
	db $00 ; bitmask
	db $01, $21, $22, $23, $24, $25, $26, $20
.frame3
	db $00 ; bitmask
	db $01, $27, $28, $23, $24, $25, $26, $20
.frame4
	db $01 ; bitmask
	db $29
.frame5
	db $02 ; bitmask
	db $2a, $2b
