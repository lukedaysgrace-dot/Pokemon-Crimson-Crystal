	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c
.frame2
	db $00 ; bitmask
	db $1d, $1e, $1f, $20
.frame3
	db $01 ; bitmask
	db $1d, $1e, $1f, $20, $21, $22, $23
.frame4
	db $02 ; bitmask
	db $1d, $1e, $1f, $20, $24, $25, $26, $27
.frame5
	db $00 ; bitmask
	db $28, $1e, $1f, $20
