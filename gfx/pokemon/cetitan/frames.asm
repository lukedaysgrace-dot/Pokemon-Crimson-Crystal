	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37
.frame2
	db $01 ; bitmask
	db $38, $39, $3a, $33, $3b, $3c, $3d, $3e, $3f
.frame3
	db $02 ; bitmask
	db $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b
	db $4c, $4d, $4e, $4f, $50, $51, $52, $53, $54, $55, $56, $3b
	db $57, $58, $59, $5a, $5b
.frame4
	db $03 ; bitmask
	db $5c, $41, $5d, $43, $44, $45, $5e, $5f, $48, $49, $4a, $4b
	db $4c, $4d, $4e, $60, $50, $51, $52, $53, $61, $62, $56, $63
	db $3b, $64, $58, $65, $66, $5b
.frame5
	db $04 ; bitmask
	db $67, $00, $68, $43, $44, $45, $5e, $5f, $48, $49, $4a, $4b
	db $4c, $4d, $4e, $60, $50, $51, $52, $53, $61, $62, $56, $63
	db $58, $69
.frame6
	db $05 ; bitmask
	db $00, $6a, $43, $44, $45, $5e, $5f, $48, $49, $4a, $4b, $4c
	db $4d, $4e, $60, $50, $51, $52, $53, $6b, $62, $56, $58
.frame7
	db $06 ; bitmask
	db $6c, $6d
