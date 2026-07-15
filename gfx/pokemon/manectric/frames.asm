	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32
.frame2
	db $01 ; bitmask
	db $00, $00, $33, $00, $34, $35, $36, $37, $38, $39, $3a, $3b
	db $3c, $3d, $3e, $3f, $40, $41, $42, $43, $44, $45, $46, $47
	db $48, $49, $4a, $4b
.frame3
	db $01 ; bitmask
	db $00, $00, $33, $00, $34, $35, $36, $4c, $4d, $39, $3a, $3b
	db $3c, $3d, $4e, $4f, $40, $41, $42, $43, $44, $45, $46, $47
	db $48, $49, $4a, $4b
.frame4
	db $02 ; bitmask
	db $50, $51, $31, $52, $32
