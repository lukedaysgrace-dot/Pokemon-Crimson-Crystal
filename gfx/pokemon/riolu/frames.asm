	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $00, $27, $28, $29, $2a
.frame2
	db $01 ; bitmask
	db $2b, $2c, $25, $2d, $2e, $2f, $28, $30, $31
.frame3
	db $02 ; bitmask
	db $32, $33, $34, $35, $36, $37, $38
.frame4
	db $03 ; bitmask
.frame5
	db $04 ; bitmask
	db $39, $3a, $3b, $2e
.frame6
	db $05 ; bitmask
	db $3c, $3d, $3e, $3f, $00, $40
