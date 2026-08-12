	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $24, $25
.frame2
	db $01 ; bitmask
	db $26, $27, $28, $29, $00, $2a, $2b, $2c, $2d, $2e, $2f, $30
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $00
.frame3
	db $02 ; bitmask
	db $3e, $3f, $40, $41, $00, $42, $43, $44, $45, $46, $47, $48
	db $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51, $52, $53, $54
	db $55, $56, $57, $00
.frame4
	db $00 ; bitmask
	db $58, $59
