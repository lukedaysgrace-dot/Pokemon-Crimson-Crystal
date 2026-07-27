	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f
.frame2
	db $01 ; bitmask
	db $20, $21, $22, $23, $24, $25, $26, $27, $28, $29
.frame3
	db $01 ; bitmask
	db $20, $2a, $2b, $23, $2c, $2d, $2e, $27, $2f, $30
.frame4
	db $02 ; bitmask
	db $31, $32, $33, $34, $35, $36
