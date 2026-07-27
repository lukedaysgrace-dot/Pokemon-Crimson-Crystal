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
	db $00, $00, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d
	db $2e, $2f, $30, $31, $32, $33, $34, $35, $36, $37
.frame2
	db $01 ; bitmask
	db $38, $39, $00, $00, $3a, $3b, $3c, $3d, $3e, $3f, $40, $41
	db $42, $43, $44, $45, $46, $47, $00, $48, $49, $4a, $4b, $4c
	db $4d, $4e, $4f
.frame3
	db $01 ; bitmask
	db $00, $50, $00, $00, $51, $52, $53, $54, $00, $55, $56, $57
	db $58, $59, $5a, $5b, $5c, $5d, $00, $5e, $5f, $60, $61, $62
	db $63, $64, $65
.frame4
	db $02 ; bitmask
	db $66, $67, $68, $00, $69, $6a, $6b, $6c, $00, $6d, $6e, $6f
	db $70, $71, $72, $00, $73, $74, $75, $76, $77, $00, $78, $79
	db $7a, $7b, $7c, $7d, $7e, $7f
.frame5
	db $01 ; bitmask
	db $80, $81, $82, $00, $83, $84, $85, $86, $87, $88, $89, $8a
	db $8b, $8c, $8d, $8e, $8f, $90, $91, $92, $93, $94, $95, $96
	db $97, $98, $99
.frame6
	db $03 ; bitmask
	db $83, $9a, $9b, $9c, $88, $89, $8a, $9d, $8d, $8e, $8f, $90
	db $91, $92, $93, $94, $95, $96, $97, $98, $99
.frame7
	db $04 ; bitmask
	db $9e, $9c, $9f, $a0, $a1, $a2
.frame8
	db $05 ; bitmask
.frame9
	db $05 ; bitmask
