	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27
.frame2
	db $01 ; bitmask
	db $28, $29, $24, $25, $2a, $2b, $26, $27, $2c, $2d, $2e, $2f
	db $30
.frame3
	db $02 ; bitmask
	db $31, $32, $33, $28, $29, $31, $34, $24, $25, $2a, $2b, $35
	db $26, $27, $2c, $2d, $2e, $2f, $30
.frame4
	db $02 ; bitmask
	db $31, $36, $37, $28, $29, $31, $38, $24, $25, $2a, $2b, $39
	db $26, $27, $2c, $2d, $2e, $2f, $30
.frame5
	db $03 ; bitmask
	db $28, $29, $3a, $2b, $3b, $2d, $2e, $2f, $30
