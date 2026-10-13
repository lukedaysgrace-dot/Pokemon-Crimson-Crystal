	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
	dw .frame9
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
.frame2
	db $00 ; bitmask
	db $31, $32, $33, $3c, $35, $36, $37, $3d, $39, $3a, $3b
.frame3
	db $01 ; bitmask
	db $3e, $3f, $40, $41, $42, $43, $44, $3c, $35, $36, $37, $45
	db $46, $3a, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f
.frame4
	db $02 ; bitmask
	db $31, $32, $50, $51, $52, $35, $53, $54, $55, $56, $57, $58
	db $59
.frame5
	db $03 ; bitmask
	db $3e, $3f, $5a, $41, $42, $5b, $5c, $5d, $5e, $5f, $60, $61
	db $62, $57, $63, $64, $65, $66, $49, $4a, $4b, $4c, $4d, $4e
	db $4f
.frame6
	db $04 ; bitmask
	db $67, $68, $69, $6a, $6b, $6c, $5d, $6d, $5f, $60, $55, $56
	db $57, $6e, $06, $06, $6f, $70, $71
.frame7
	db $03 ; bitmask
	db $72, $73, $74, $75, $76, $77, $6c, $5d, $6d, $5f, $60, $61
	db $62, $57, $78, $06, $06, $79, $7a, $7b, $7c, $4c, $4d, $4e
	db $4f
.frame8
	db $05 ; bitmask
	db $7d, $7e
.frame9
	db $06 ; bitmask
	db $7f, $80, $69, $81, $82, $6c, $5d, $6d, $5f, $60, $55, $56
	db $57, $78, $06, $06, $6f, $83, $06, $84
