	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $24, $25
.frame2
	db $01 ; bitmask
	db $26, $27, $28
.frame3
	db $02 ; bitmask
	db $29, $2a, $26, $27, $2b, $28, $2c, $2d, $2e, $2f, $30, $31
.frame4
	db $02 ; bitmask
	db $29, $2a, $32, $33, $2b, $34, $2c, $2d, $2e, $2f, $30, $31
