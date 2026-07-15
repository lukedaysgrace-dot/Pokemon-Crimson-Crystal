	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32
.frame2
	db $01 ; bitmask
	db $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e
	db $3f, $40, $41, $42, $43, $44, $45
.frame3
	db $02 ; bitmask
	db $46, $47, $48, $49, $4a, $4b, $4c, $4d, $3b, $4e, $4f, $50
	db $51, $52, $53, $54, $43, $55, $45
.frame4
	db $03 ; bitmask
	db $56, $57, $58, $59, $00, $5a, $5b, $00, $5c, $47, $48, $49
	db $00, $5d, $5e, $4c, $4d, $5f, $4e, $4f, $50, $60, $61, $62
	db $54, $63, $64, $65
