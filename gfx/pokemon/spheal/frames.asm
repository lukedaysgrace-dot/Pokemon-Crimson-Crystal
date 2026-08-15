	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
	dw .frame9
	dw .frame10
	dw .frame11
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24
	db $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30
.frame2
	db $01 ; bitmask
	db $31, $32
.frame3
	db $02 ; bitmask
	db $33, $34, $35, $36
.frame4
	db $00 ; bitmask
	db $19, $1a, $1b, $37, $38, $1e, $1f, $39, $3a, $3b, $23, $24
	db $3c, $3d, $3e, $28, $29, $2a, $2b, $3f, $2d, $2e, $2f, $40
.frame5
	db $00 ; bitmask
	db $19, $1a, $1b, $37, $38, $1e, $1f, $41, $42, $3b, $23, $24
	db $3c, $43, $3e, $28, $29, $2a, $2b, $3f, $2d, $2e, $2f, $40
.frame6
	db $03 ; bitmask
	db $19, $1a, $1b, $37, $38, $1e, $1f, $20, $3b, $23, $24, $25
	db $26, $3e, $28, $29, $2a, $2b, $3f, $2d, $2e, $2f, $40
.frame7
	db $00 ; bitmask
	db $44, $45, $46, $47, $1d, $48, $49, $4a, $4b, $22, $4c, $4d
	db $4e, $4f, $27, $50, $51, $52, $53, $54, $2d, $55, $56, $57
.frame8
	db $00 ; bitmask
	db $58, $59, $5a, $5b, $5c, $48, $5d, $5e, $5f, $60, $4c, $61
	db $62, $63, $64, $50, $65, $66, $67, $68, $69, $6a, $6b, $6c
.frame9
	db $00 ; bitmask
	db $58, $6d, $6e, $6f, $70, $71, $5d, $72, $72, $73, $74, $72
	db $72, $72, $75, $76, $77, $78, $79, $7a, $2d, $7b, $7c, $6c
.frame10
	db $00 ; bitmask
	db $58, $7d, $7e, $7f, $80, $81, $82, $83, $84, $85, $86, $87
	db $88, $89, $75, $8a, $8b, $8c, $8d, $8e, $8f, $90, $6b, $6c
.frame11
	db $00 ; bitmask
	db $19, $91, $92, $93, $94, $1e, $95, $96, $97, $98, $99, $9a
	db $9b, $9c, $9d, $9e, $9f, $a0, $a1, $a2, $2d, $a3, $a4, $a5
