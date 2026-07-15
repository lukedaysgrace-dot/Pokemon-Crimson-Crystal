	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $24, $25, $00, $26, $27, $00, $28, $29
.frame2
	db $01 ; bitmask
	db $2a, $2b, $00, $2c, $2d, $2e, $2f
.frame3
	db $02 ; bitmask
	db $00, $00, $30, $00, $31, $00, $32, $33, $34, $35, $36, $37
	db $38, $39, $3a, $3b, $3c
.frame4
	db $03 ; bitmask
	db $00, $3d, $3e, $00, $00, $31, $3f, $40, $2e, $33, $34, $35
	db $2f, $36, $37, $38, $39, $3a, $3b, $3c
