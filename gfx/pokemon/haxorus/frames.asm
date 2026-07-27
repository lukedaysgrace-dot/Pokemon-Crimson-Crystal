	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
	db $3d, $3e, $3f, $40
.frame2
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $41, $42, $39, $3a, $43, $44
	db $3d, $3e, $3f, $40
.frame3
	db $01 ; bitmask
	db $45, $46, $47, $48, $49, $04, $4a, $4b, $4c, $4d
.frame4
	db $02 ; bitmask
	db $4e, $4f
