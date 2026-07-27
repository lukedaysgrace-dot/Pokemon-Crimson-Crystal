	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $04, $04, $04, $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21
	db $22, $23, $24, $25, $26, $27
.frame2
	db $01 ; bitmask
	db $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32, $33
	db $34, $35
.frame3
	db $01 ; bitmask
	db $28, $29, $2a, $2b, $2c, $36, $37, $2f, $30, $38, $39, $33
	db $34, $35
.frame4
	db $02 ; bitmask
	db $3a, $3b, $3c, $3d, $3e, $3f, $40, $41, $42, $43
