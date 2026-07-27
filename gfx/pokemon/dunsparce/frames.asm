	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f
	db $30, $31
.frame2
	db $01 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $32, $33, $34, $2d, $2e
	db $35, $36, $37, $38, $30, $31, $39, $3a, $3b, $3c, $3d, $00
	db $00, $3e, $3f
.frame3
	db $01 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $32, $33, $34, $2d, $2e
	db $40, $41, $37, $38, $30, $31, $42, $43, $3b, $3c, $3d, $00
	db $00, $3e, $3f
.frame4
	db $02 ; bitmask
	db $32, $44, $45, $35, $36, $37, $46, $39, $3a, $3b, $3c, $3d
	db $00, $00, $3e, $3f
.frame5
	db $03 ; bitmask
	db $47, $48, $00, $49, $4a, $4b, $4c, $4d, $4e, $4f
