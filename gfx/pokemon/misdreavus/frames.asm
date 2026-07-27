	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e
.frame2
	db $01 ; bitmask
	db $24, $25, $26, $27, $29, $2a
.frame3
	db $02 ; bitmask
	db $2f, $30, $31, $32, $28, $33, $2a, $2b, $2d, $2e
.frame4
	db $01 ; bitmask
	db $2f, $30, $31, $32, $33, $2a
.frame5
	db $03 ; bitmask
	db $34, $35, $28, $2b, $2d, $2e
.frame6
	db $04 ; bitmask
	db $34, $35
.frame7
	db $01 ; bitmask
	db $36, $37, $38, $39, $3a, $3b
