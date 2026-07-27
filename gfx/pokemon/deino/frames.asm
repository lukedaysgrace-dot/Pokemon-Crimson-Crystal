	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24
	db $25, $00, $26, $27, $28
.frame2
	db $01 ; bitmask
	db $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32, $33, $34
	db $35, $00, $36, $37, $38, $00, $39, $3a
.frame3
	db $01 ; bitmask
	db $29, $2a, $2b, $2c, $2d, $3b, $3c, $30, $31, $32, $3d, $3e
	db $35, $00, $3f, $40, $38, $00, $39, $3a
.frame4
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24
	db $25, $00, $26, $27, $28
.frame5
	db $01 ; bitmask
	db $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32, $33, $34
	db $35, $00, $36, $37, $38, $00, $39, $3a
.frame6
	db $01 ; bitmask
	db $29, $2a, $2b, $2c, $2d, $3b, $3c, $30, $31, $32, $3d, $3e
	db $35, $00, $3f, $40, $38, $00, $39, $3a
