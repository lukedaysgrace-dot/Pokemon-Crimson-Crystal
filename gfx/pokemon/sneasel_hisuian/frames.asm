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
	db $24, $25, $26, $27, $28, $29
.frame2
	db $00 ; bitmask
	db $24, $2a, $2b, $2c, $2d, $2e
.frame3
	db $01 ; bitmask
	db $2f, $24, $2a, $30, $2c, $2d, $31
.frame4
	db $01 ; bitmask
	db $32, $24, $2a, $33, $2c, $2d, $34
.frame5
	db $02 ; bitmask
	db $35, $36, $00, $37, $38, $39, $25, $3a, $2c, $3b, $28, $29
	db $3c, $3d, $3e, $3f, $40, $00
.frame6
	db $02 ; bitmask
	db $41, $00, $00, $42, $43, $39, $25, $44, $45, $46, $28, $47
	db $48, $49, $4a, $3f, $40, $00
.frame7
	db $03 ; bitmask
	db $4b, $00, $00, $4c, $4d, $4e, $39, $25, $4f, $50, $51, $28
	db $47, $52, $53, $4a, $3f, $40, $00
.frame8
	db $02 ; bitmask
	db $54, $00, $00, $55, $56, $39, $25, $57, $58, $59, $28, $47
	db $5a, $49, $4a, $3f, $40, $00
