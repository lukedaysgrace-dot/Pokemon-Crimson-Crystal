	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f
	db $30, $31, $32, $33, $34, $35
.frame2
	db $01 ; bitmask
	db $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $40, $41
	db $42, $43, $44, $45, $46
.frame3
	db $02 ; bitmask
	db $36, $37, $47, $48, $3a, $3b, $3c, $3d, $3e, $49, $40, $41
	db $42, $43, $44, $4a, $46, $4b
.frame4
	db $01 ; bitmask
	db $36, $37, $38, $4c, $3a, $3b, $3c, $3d, $3e, $4d, $40, $41
	db $42, $43, $44, $4e, $46
.frame5
	db $03 ; bitmask
	db $36, $37, $38, $4c, $3a, $3b, $3c, $3d, $3e, $4d, $40, $41
	db $42, $43, $44, $4e, $46, $4f, $50, $51, $52, $00, $53
.frame6
	db $04 ; bitmask
	db $54, $55
