	dw .frame1
	dw .frame2
	dw .frame3
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $00, $1d, $1e, $1f, $20, $21, $22, $23
	db $24, $00, $25, $26
.frame2
	db $01 ; bitmask
	db $00, $27, $28, $29, $00, $2a, $2b, $2c, $2d, $2e, $2f, $30
	db $31, $00, $32, $33, $34, $35
.frame3
	db $02 ; bitmask
	db $36, $37
