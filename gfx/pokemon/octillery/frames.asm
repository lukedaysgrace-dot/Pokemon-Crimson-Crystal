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
	db $00, $24, $25, $26
.frame2
	db $01 ; bitmask
	db $00, $27, $28, $29, $2a, $2b
.frame3
	db $01 ; bitmask
	db $00, $27, $28, $29, $2a, $2b
.frame4
	db $02 ; bitmask
	db $2c, $2d, $2e, $2f, $30
.frame5
	db $03 ; bitmask
	db $31, $32, $33, $34, $29, $35, $2b
.frame6
	db $04 ; bitmask
	db $36, $37, $38, $39, $3a, $3b, $2f, $30
.frame7
	db $05 ; bitmask
	db $3c, $3d, $3e, $3f, $40, $41, $29, $35, $2b
.frame8
	db $06 ; bitmask
	db $42, $00, $43, $24, $44, $2f, $30
