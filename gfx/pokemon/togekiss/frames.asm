	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40, $41
.frame2
	db $01 ; bitmask
	db $31, $32, $33, $00, $42, $43, $35, $36, $44, $45, $46, $37
	db $38, $47, $48, $39, $49, $3b, $3c, $3d, $3e, $4a, $00, $3f
	db $40, $41, $4b
.frame3
	db $02 ; bitmask
	db $4c, $4d, $4e, $4a, $00, $4b
.frame4
	db $03 ; bitmask
	db $31, $32, $33, $34, $35, $36, $4c, $38, $4d, $4e, $3a, $3b
	db $3c, $3d, $3e, $4a, $00, $3f, $40, $41, $4b
.frame5
	db $04 ; bitmask
	db $4c
