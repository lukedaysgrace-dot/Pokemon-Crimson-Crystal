	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $24, $25, $26, $27, $28, $29, $2a, $2b
.frame2
	db $01 ; bitmask
	db $24, $2c, $2d, $12, $2e, $2f, $30, $31, $32, $33, $34
.frame3
	db $02 ; bitmask
	db $24, $2c, $2d, $12, $2e, $2f, $30, $31, $32, $33, $34, $35
	db $36, $37, $38
.frame4
	db $03 ; bitmask
	db $39, $3a, $3b, $3c, $3d, $2c, $2d, $12, $12, $2e, $2f, $30
	db $31, $32, $33, $34, $35, $36, $37, $38
.frame5
	db $04 ; bitmask
	db $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49
	db $2e, $2f, $30, $4a, $31, $32, $33, $34, $35, $36, $37, $38
.frame6
	db $05 ; bitmask
	db $4b, $4c, $4d, $41, $42, $4e, $4f, $45, $46, $47, $12, $50
	db $2e, $2f, $30, $31, $32, $33, $34, $35, $36, $37, $38
.frame7
	db $06 ; bitmask
	db $51, $52
