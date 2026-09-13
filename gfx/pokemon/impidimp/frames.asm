	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20
.frame2
	db $01 ; bitmask
	db $19, $1a, $1b, $21, $22, $1e, $23, $24, $20
.frame3
	db $02 ; bitmask
	db $25, $26, $04, $1a, $1b, $27, $28, $29, $1e, $23, $2a, $2b
	db $2c, $2d, $2e, $2f, $30, $04, $31, $32, $33
.frame4
	db $03 ; bitmask
	db $34, $35, $36
