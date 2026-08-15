	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $00
	db $2f, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a
	db $3b, $00
.frame2
	db $01 ; bitmask
	db $3c, $3d, $3e, $3f, $40, $00, $41, $42, $43, $44, $45, $00
	db $46, $47, $48, $49, $00, $00, $4a, $4b, $4c, $4d, $4e, $4f
	db $50, $51, $52, $53, $54, $55, $56, $57
.frame3
	db $01 ; bitmask
	db $58, $59, $5a, $5b, $5c, $00, $00, $5d, $5e, $5f, $60, $00
	db $61, $62, $63, $64, $00, $00, $65, $66, $67, $68, $4e, $4f
	db $69, $6a, $52, $53, $54, $55, $56, $57
.frame4
	db $01 ; bitmask
	db $58, $59, $6b, $6c, $5c, $00, $00, $5d, $5e, $5f, $60, $00
	db $61, $62, $63, $64, $00, $00, $65, $6d, $6e, $68, $4e, $4f
	db $69, $6a, $52, $53, $54, $55, $56, $57
.frame5
	db $02 ; bitmask
	db $6f, $70, $71, $72
.frame6
	db $03 ; bitmask
	db $6f, $73, $74, $72, $75
.frame7
	db $04 ; bitmask
	db $00, $76, $00, $77
.frame8
	db $05 ; bitmask
	db $78, $79
