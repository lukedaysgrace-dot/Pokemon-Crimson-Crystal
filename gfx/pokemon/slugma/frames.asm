	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29
.frame2
	db $01 ; bitmask
	db $24, $25, $26, $27, $2a, $2b, $2c, $2d
.frame3
	db $02 ; bitmask
	db $24, $25, $26, $27, $2e, $2f, $30, $31
.frame4
	db $03 ; bitmask
	db $24, $25, $26, $27
.frame5
	db $04 ; bitmask
	db $32, $33, $34, $35, $36
.frame6
	db $05 ; bitmask
	db $28, $29
.frame7
	db $06 ; bitmask
	db $2a, $2b, $2c, $2d
.frame8
	db $07 ; bitmask
	db $2e, $2f, $30, $31
