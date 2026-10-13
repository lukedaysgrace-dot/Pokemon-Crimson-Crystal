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
	db $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f
	db $30
.frame2
	db $01 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $30
.frame3
	db $01 ; bitmask
	db $31, $32, $33, $34, $40, $41, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $30
.frame4
	db $01 ; bitmask
	db $31, $42, $33, $34, $43, $41, $37, $38, $39, $44, $3b, $3c
	db $3d, $3e, $3f, $30
.frame5
	db $01 ; bitmask
	db $31, $45, $33, $34, $46, $41, $37, $38, $39, $47, $48, $3c
	db $3d, $3e, $3f, $30
.frame6
	db $01 ; bitmask
	db $49, $4a, $33, $4b, $4c, $41, $37, $38, $4d, $4e, $4f, $3c
	db $50, $51, $3f, $30
.frame7
	db $01 ; bitmask
	db $49, $4a, $33, $4b, $52, $53, $37, $38, $4d, $4e, $4f, $3c
	db $50, $51, $3f, $30
.frame8
	db $01 ; bitmask
	db $49, $54, $33, $4b, $55, $53, $37, $38, $4d, $56, $4f, $3c
	db $50, $51, $3f, $30
.frame9
	db $01 ; bitmask
	db $49, $57, $33, $4b, $58, $53, $37, $38, $4d, $59, $5a, $3c
	db $50, $51, $3f, $30
.frame10
	db $02 ; bitmask
	db $5b, $5c, $5d, $5e
.frame11
	db $03 ; bitmask
	db $31, $32, $33, $34, $35, $53, $5f, $39, $3a, $3b, $60, $61
	db $3d, $3e, $3f, $30
