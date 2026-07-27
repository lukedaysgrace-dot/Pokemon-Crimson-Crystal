	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $24, $25
.frame2
	db $01 ; bitmask
	db $26, $27, $28, $04, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30
	db $31, $32, $33, $34, $35, $36
.frame3
	db $02 ; bitmask
	db $37, $2d, $38, $30
.frame4
	db $02 ; bitmask
	db $37, $39, $38, $3a
