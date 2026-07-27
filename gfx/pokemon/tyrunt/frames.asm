	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $00, $27, $28, $29, $2a, $2b, $00, $2c, $2d
	db $2e, $2f, $30, $31, $32, $33, $34, $35, $36
.frame2
	db $01 ; bitmask
	db $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $40, $41
.frame3
	db $02 ; bitmask
	db $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $40, $42, $43
	db $44, $45, $46, $47, $48, $49
.frame4
	db $03 ; bitmask
	db $37, $38, $39, $3a, $3b, $3c, $3d, $4a, $4b, $3f, $40, $4c
	db $4d, $4e, $00, $4f, $50, $51, $00
.frame5
	db $04 ; bitmask
	db $52, $53, $54, $00, $55, $56, $57, $58
.frame6
	db $05 ; bitmask
	db $59, $5a, $5b, $5c, $5d, $5e, $5f, $60, $61, $00, $62, $63
	db $64, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $6f
	db $70, $71, $72, $73, $74, $75, $76, $77
.frame7
	db $06 ; bitmask
