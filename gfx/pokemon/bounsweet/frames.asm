	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $19
.frame2
	db $01 ; bitmask
	db $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24, $25
	db $26, $27
.frame3
	db $02 ; bitmask
	db $28, $1e, $29, $21, $2a, $25
.frame4
	db $02 ; bitmask
	db $28, $1e, $29, $2b, $2a, $25
