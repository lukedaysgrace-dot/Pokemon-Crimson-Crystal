	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $04, $04
.frame2
	db $01 ; bitmask
	db $19, $1a, $1e, $1b, $1c, $1d, $04, $04
.frame3
	db $02 ; bitmask
	db $1f, $20, $21, $22, $23, $24, $25, $26, $27, $1e, $1b, $1c
	db $1d, $04, $04
.frame4
	db $03 ; bitmask
	db $1e
