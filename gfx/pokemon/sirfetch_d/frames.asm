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
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
.frame2
	db $01 ; bitmask
	db $31, $3d, $3e, $3f, $35, $36, $37, $40, $41, $3a, $3b, $3c
	db $42, $43, $44
.frame3
	db $02 ; bitmask
	db $00, $45, $00, $00, $46, $47, $48, $49, $4a, $4b, $4c, $4d
	db $4e, $35, $4f, $50, $51, $52, $3a, $3b, $3c, $42, $43, $44
.frame4
	db $02 ; bitmask
	db $00, $45, $00, $00, $46, $47, $48, $49, $4a, $4b, $4c, $4d
	db $4e, $53, $54, $50, $51, $52, $55, $56, $3c, $42, $43, $44
.frame5
	db $03 ; bitmask
	db $31, $32, $33, $34, $38, $39
.frame6
	db $04 ; bitmask
	db $31, $32, $33, $34, $57, $37, $38, $39, $58, $3c
.frame7
	db $05 ; bitmask
	db $31, $3d, $3e, $3f, $59, $37, $40, $41, $5a, $5b, $5c, $5d
	db $5e, $5f
.frame8
	db $05 ; bitmask
	db $31, $32, $33, $34, $59, $37, $38, $39, $5a, $5b, $5c, $5d
	db $5e, $5f
