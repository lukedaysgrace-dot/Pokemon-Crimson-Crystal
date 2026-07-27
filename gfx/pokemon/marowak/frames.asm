	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f
	db $30, $31, $32, $33, $34, $35, $36, $37, $38, $39
.frame2
	db $01 ; bitmask
	db $3a, $3b, $3c, $3d, $29, $2a, $3e, $2c, $2d, $2e, $2f, $3f
	db $31, $32, $33, $34, $35, $40, $37, $38, $41, $42
.frame3
	db $02 ; bitmask
	db $24, $25, $26, $27, $28, $2b, $30, $31, $43, $44, $45, $46
	db $47
.frame4
	db $03 ; bitmask
	db $3a, $3b, $3c, $3d, $3e, $3f, $31, $43, $44, $45, $46, $47
.frame5
	db $04 ; bitmask
	db $29, $2a, $48, $2f, $33
.frame6
	db $05 ; bitmask
	db $43, $44, $45, $46, $47
