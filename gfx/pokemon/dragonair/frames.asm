	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $24
.frame2
	db $01 ; bitmask
	db $25, $26, $27, $28, $29, $2a, $2b, $2c, $24, $2d, $2e, $2f
	db $30, $31, $32, $33, $34, $35
.frame3
	db $02 ; bitmask
	db $36, $37, $38, $28, $29, $39, $3a, $2b, $2c, $24, $3b, $3c
	db $3d, $3e, $3f, $40, $41, $42, $43, $44
.frame4
	db $03 ; bitmask
	db $45, $46
.frame5
	db $04 ; bitmask
	db $47, $48
.frame6
	db $04 ; bitmask
	db $49, $4a
.frame7
	db $05 ; bitmask
	db $4b
