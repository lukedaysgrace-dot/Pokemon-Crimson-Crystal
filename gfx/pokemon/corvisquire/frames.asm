	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $2b, $2c
.frame2
	db $01 ; bitmask
	db $2d, $2e, $2f, $30, $31, $32, $33, $34, $35, $36, $37, $38
	db $39, $3a, $3b
.frame3
	db $02 ; bitmask
	db $3c, $3d, $3e, $3f, $2d, $2e, $2f, $30, $31, $32, $33, $34
	db $35, $36, $37, $38, $39, $3a, $3b
.frame4
	db $02 ; bitmask
	db $40, $41, $42, $43, $2d, $2e, $2f, $30, $31, $32, $33, $34
	db $35, $36, $37, $38, $39, $3a, $3b
.frame5
	db $03 ; bitmask
	db $44, $45, $2d, $2e, $2f, $30, $31, $32, $33, $34, $35, $36
	db $37, $38, $39, $3a, $3b
