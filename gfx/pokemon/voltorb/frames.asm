	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d
.frame2
	db $01 ; bitmask
	db $1e, $1f, $20, $21, $22, $23, $24, $25, $26, $27, $28, $00
.frame3
	db $02 ; bitmask
	db $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32, $33, $34
	db $35, $36, $00
.frame4
	db $03 ; bitmask
	db $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $40, $41
.frame5
	db $04 ; bitmask
	db $42, $43, $44, $45
