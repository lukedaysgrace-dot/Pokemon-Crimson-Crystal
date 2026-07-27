	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d
.frame2
	db $01 ; bitmask
	db $2e, $2f, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39
	db $3a, $3b, $3c, $3d, $3e, $3f, $40, $41, $42, $43, $44, $45
	db $46
.frame3
	db $02 ; bitmask
	db $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51, $52
	db $53, $54, $55, $56, $57, $58
.frame4
	db $03 ; bitmask
	db $59, $5a, $5b, $5c, $5d, $51, $52, $53, $54, $55, $56, $5e
	db $5f, $57, $58, $60, $61
.frame5
	db $04 ; bitmask
	db $26, $27, $28, $29, $2a, $2b, $2c, $2d
.frame6
	db $05 ; bitmask
	db $47, $48, $62, $63, $31, $4a, $4b, $4c, $35, $36, $64, $4f
	db $50, $65, $42, $66, $46
