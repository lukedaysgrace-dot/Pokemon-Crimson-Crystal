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
.frame1
	db $00 ; bitmask
	db $24, $25, $26
.frame2
	db $01 ; bitmask
	db $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32
	db $33, $34, $1f, $35, $36
.frame3
	db $02 ; bitmask
	db $37, $38, $1f, $2a, $39, $3a, $1f, $2e, $3b, $30, $3c, $3d
	db $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49
.frame4
	db $03 ; bitmask
	db $1f, $1f, $1f, $2a, $1f, $1f, $1f, $2e, $30, $4a, $4b, $4c
	db $4d, $4e, $4f, $50, $51, $52, $53, $54, $55, $56, $57, $58
	db $1f
.frame5
	db $04 ; bitmask
	db $1f, $1f, $1f, $59, $5a, $1f, $1f, $1f, $5b, $5c, $30, $5d
	db $5e, $5f, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69
.frame6
	db $05 ; bitmask
	db $6a, $6b, $6c, $6d, $6e, $6f, $70, $71, $72, $73, $74, $75
	db $76, $30, $77, $78, $79, $7a, $7b, $7c, $7d, $1f, $7e, $1f
.frame7
	db $06 ; bitmask
	db $1f, $7f, $80, $81, $82, $1f, $83, $84, $85, $86, $30, $87
	db $88, $89, $8a, $8b, $8c, $8d, $1f, $1f, $1f
.frame8
	db $07 ; bitmask
	db $1f, $1f, $1f, $2a, $1f, $1f, $1f, $2e, $30, $8e, $8f, $4b
	db $90, $91, $4f, $7b, $92, $93, $94, $95, $96
.frame9
	db $08 ; bitmask
	db $97, $98, $1f, $2a, $99, $9a, $1f, $2e, $9b, $2f, $30, $9c
	db $31, $9d, $9e, $33, $34, $9f, $a0, $35, $36
.frame10
	db $09 ; bitmask
	db $a1, $a2, $a3, $a4
