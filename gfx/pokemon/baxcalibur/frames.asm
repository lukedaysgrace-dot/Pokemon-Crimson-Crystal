	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f
.frame2
	db $01 ; bitmask
	db $40, $41, $42, $43, $44, $31, $32, $45, $46, $47, $48, $35
	db $49, $4a, $4b, $39, $3a, $4c, $4d, $3c, $3d, $3e, $3f
.frame3
	db $02 ; bitmask
	db $4e, $4f, $50, $51, $52, $31, $32, $45, $46, $53, $54, $55
	db $35, $49, $4a, $4b, $39, $3a, $4c, $4d, $3c, $3d, $3e, $3f
.frame4
	db $03 ; bitmask
	db $56, $57, $31, $32, $45, $46, $58, $35, $49, $4a, $4b, $59
	db $39, $3a, $4c, $4d, $3c, $3d, $3e, $3f
.frame5
	db $04 ; bitmask
	db $5a, $31, $32, $45, $46, $5b, $35, $49, $4a, $4b, $5c, $39
	db $3a, $4c, $4d, $3c, $3d, $3e, $3f
.frame6
	db $05 ; bitmask
	db $5d, $31, $32, $45, $46, $35, $49, $4a, $4b, $5e, $39, $3a
	db $4c, $4d, $3c, $3d, $3e, $3f
.frame7
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $5f, $37, $38, $39, $60, $3b, $3c
	db $3d, $3e, $3f
