	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $00, $20, $21, $22, $23
	db $24, $25
.frame2
	db $00 ; bitmask
	db $26, $27, $1b, $28, $29, $2a, $1f, $00, $20, $21, $22, $23
	db $24, $25
.frame3
	db $01 ; bitmask
	db $26, $27, $2b, $2c, $28, $29, $2d, $2e, $2a, $1f, $00, $20
	db $21, $22, $23, $24, $25
.frame4
	db $02 ; bitmask
	db $26, $27, $1b, $00, $28, $29, $2f, $30, $2a, $1f, $31, $32
	db $00, $20, $21, $22, $23, $24, $25
.frame5
	db $00 ; bitmask
	db $33, $34, $1b, $35, $36, $1e, $37, $00, $20, $21, $22, $23
	db $24, $25
