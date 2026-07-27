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
	dw .frame12
.frame1
	db $00 ; bitmask
	db $19, $1a, $1b
.frame2
	db $01 ; bitmask
	db $00, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24, $25, $26
	db $27, $28, $29, $00, $2a, $2b
.frame3
	db $02 ; bitmask
	db $19, $2c, $2d, $2e, $1b, $2f, $30, $31, $32
.frame4
	db $03 ; bitmask
	db $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e
	db $3f, $40, $41, $42, $43, $44, $45
.frame5
	db $04 ; bitmask
	db $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51
	db $52, $53, $54, $55, $56, $57, $58, $59, $5a
.frame6
	db $05 ; bitmask
	db $5b, $1a, $5c, $5d, $5e
.frame7
	db $06 ; bitmask
	db $5b, $1a, $5f, $5d, $5e, $60, $61
.frame8
	db $07 ; bitmask
	db $5b, $62, $1a, $63, $64, $5e, $65, $66
.frame9
	db $08 ; bitmask
	db $67, $68, $69, $6a, $6b, $6c, $1a, $6d, $63, $64, $5e, $6e
	db $6f, $70, $71, $72, $73, $74
.frame10
	db $08 ; bitmask
	db $75, $76, $77, $78, $6b, $79, $1a, $7a, $63, $64, $5e, $6e
	db $7b, $7c, $7d, $7e, $7f, $80
.frame11
	db $09 ; bitmask
	db $81, $82, $83, $84, $62, $1a, $85, $5e, $86, $87, $88
.frame12
	db $01 ; bitmask
	db $00, $1c, $89, $1e, $1f, $8a, $21, $22, $23, $8b, $25, $26
	db $27, $28, $29, $00, $2a, $2b
