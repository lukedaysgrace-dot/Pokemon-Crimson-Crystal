	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $00, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e
	db $2f, $30
.frame2
	db $01 ; bitmask
	db $00, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $31, $32
	db $2d, $2e, $2f, $33, $34, $35, $36, $37, $38
.frame3
	db $02 ; bitmask
	db $39, $3a
.frame4
	db $03 ; bitmask
	db $3b, $3c
.frame5
	db $04 ; bitmask
	db $3d, $39, $3a
