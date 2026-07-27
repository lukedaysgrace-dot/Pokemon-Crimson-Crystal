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
	db $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24
	db $25, $26, $27
.frame2
	db $01 ; bitmask
	db $28, $29, $00, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32
	db $00, $33, $34, $35
.frame3
	db $01 ; bitmask
	db $36, $37, $00, $2a, $38, $00, $2d, $39, $00, $30, $31, $3a
	db $00, $3b, $3c, $3d
.frame4
	db $02 ; bitmask
	db $36, $37, $00, $2a, $38, $00, $3e, $2d, $39, $00, $3f, $40
	db $31, $3a, $00, $3b, $3c, $3d
.frame5
	db $03 ; bitmask
	db $41, $37, $00, $42, $43, $44, $00, $00, $45, $46, $47, $00
	db $00, $48, $49, $4a, $00, $4b, $4c, $4d
.frame6
	db $04 ; bitmask
	db $36, $37, $00, $4e, $4f, $50, $00, $51, $2d, $52, $00, $00
	db $53, $31, $3a, $00, $3b, $3c, $3d
.frame7
	db $05 ; bitmask
	db $54, $55, $37, $00, $42, $43, $44, $00, $00, $45, $46, $47
	db $00, $00, $48, $49, $4a, $00, $3b, $3c, $3d
.frame8
	db $06 ; bitmask
	db $56, $57
