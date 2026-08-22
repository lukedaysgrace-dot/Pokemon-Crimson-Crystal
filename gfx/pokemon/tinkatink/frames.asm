	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24
	db $25, $26, $27
.frame2
	db $01 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $28
	db $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31
.frame3
	db $02 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $32, $33, $34
	db $35, $36, $37, $38, $39, $00, $00, $25, $3a
.frame4
	db $03 ; bitmask
	db $3b, $3c, $3d
