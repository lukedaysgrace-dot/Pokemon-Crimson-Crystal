	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24
	db $25
.frame2
	db $00 ; bitmask
	db $26, $27, $28, $1c, $29, $2a, $1f, $2b, $2c, $22, $03, $2d
	db $25
.frame3
	db $01 ; bitmask
	db $26, $2e, $1c, $1f, $2f, $22, $30, $25
.frame4
	db $02 ; bitmask
	db $26, $31, $32, $33, $1c, $34, $35, $1f, $36, $37, $22, $38
	db $39, $25
.frame5
	db $03 ; bitmask
	db $3a
