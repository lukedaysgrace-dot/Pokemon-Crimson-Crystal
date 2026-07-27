	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $31
.frame2
	db $01 ; bitmask
	db $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d
	db $3e, $3f, $40, $00, $41, $42
.frame3
	db $01 ; bitmask
	db $32, $33, $34, $35, $36, $37, $43, $39, $3a, $3b, $44, $3d
	db $3e, $3f, $40, $00, $41, $42
.frame4
	db $01 ; bitmask
	db $32, $33, $34, $35, $36, $45, $38, $39, $3a, $46, $47, $3d
	db $3e, $3f, $40, $00, $41, $42
.frame5
	db $02 ; bitmask
	db $48, $49, $4a
