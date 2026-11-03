	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $24, $00, $25, $26, $27, $28, $29, $2a, $00, $2b, $2c, $00
	db $00
.frame2
	db $00 ; bitmask
	db $24, $00, $25, $2d, $2e, $28, $2f, $30, $00, $31, $32, $00
	db $00
.frame3
	db $01 ; bitmask
	db $33, $34, $35, $36, $37
.frame4
	db $02 ; bitmask
	db $33, $34, $36
