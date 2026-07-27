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
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24
	db $00, $25, $26
.frame2
	db $01 ; bitmask
	db $27, $28, $29, $2a, $20, $2b, $2c, $2d
.frame3
	db $02 ; bitmask
	db $2e, $2f, $29, $30, $31, $20, $21, $32, $33, $34, $35, $36
.frame4
	db $03 ; bitmask
	db $37, $29, $30, $38, $20, $21, $39, $3a, $3b
.frame5
	db $04 ; bitmask
	db $3c, $3d, $29, $30, $3e, $20, $21, $3f, $40, $41, $42
.frame6
	db $05 ; bitmask
	db $43, $44, $29, $30, $45, $46, $47, $20, $21, $48, $49, $4a
.frame7
	db $06 ; bitmask
	db $4b, $29, $30, $4c, $20, $21, $4d, $4e, $4f
.frame8
	db $07 ; bitmask
	db $50, $44, $29, $30, $51, $46, $47, $20, $21, $52, $53
.frame9
	db $08 ; bitmask
	db $54, $29, $30, $51, $20, $21, $55, $56
.frame10
	db $09 ; bitmask
	db $57, $29, $30, $20, $21, $55, $58
