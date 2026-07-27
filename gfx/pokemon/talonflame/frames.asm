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
	db $31, $32, $05, $33, $34, $35, $36, $37, $38, $39, $3a, $3b
	db $3c
.frame2
	db $01 ; bitmask
	db $31, $3d, $05, $33, $3e, $35, $36, $37, $3f, $39, $3a, $40
.frame3
	db $01 ; bitmask
	db $41, $42, $05, $43, $44, $35, $36, $37, $45, $39, $46, $47
.frame4
	db $02 ; bitmask
	db $48, $49, $4a, $05, $4b, $4c, $4d, $35, $36, $37, $4e, $39
	db $4f, $50, $3b, $51, $52
.frame5
	db $03 ; bitmask
	db $53, $54, $55, $05, $33, $56, $35, $36, $57, $58, $39, $3a
	db $3b, $59, $5a
.frame6
	db $01 ; bitmask
	db $5b, $5c, $05, $33, $34, $35, $36, $5d, $5e, $39, $3a, $5f
.frame7
	db $01 ; bitmask
	db $60, $32, $05, $33, $34, $35, $36, $37, $3f, $39, $3a, $61
.frame8
	db $01 ; bitmask
	db $31, $32, $05, $33, $34, $35, $36, $37, $3f, $39, $3a, $3b
.frame9
	db $04 ; bitmask
