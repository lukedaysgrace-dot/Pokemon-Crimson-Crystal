	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24
	db $25, $04, $26
.frame2
	db $01 ; bitmask
	db $19, $1a, $1b, $1c, $27, $28, $1f, $29, $22, $23, $2a, $25
	db $04, $26
.frame3
	db $02 ; bitmask
	db $19, $2b, $1c, $2c, $2d, $1f, $20, $21, $22, $23, $24, $25
	db $04, $26
.frame4
	db $03 ; bitmask
	db $19, $2b, $22, $2e, $25, $2f
