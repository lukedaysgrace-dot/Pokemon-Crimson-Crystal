	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27
.frame2
	db $01 ; bitmask
	db $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32, $33
	db $34, $35
.frame3
	db $02 ; bitmask
	db $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $36, $37, $38
	db $33, $39, $3a, $3b, $34, $3c, $3d, $35
.frame4
	db $03 ; bitmask
	db $2b, $2f, $30, $3e, $3f, $33, $40, $3b, $34, $41, $42, $3d
	db $35, $43, $44, $45
.frame5
	db $04 ; bitmask
	db $46, $47, $45
.frame6
	db $05 ; bitmask
	db $2b, $2f, $30, $33, $34, $35
