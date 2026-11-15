	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c
.frame2
	db $01 ; bitmask
	db $3d, $3e, $3f, $40, $31, $41, $42, $34, $35, $36, $37, $38
	db $39, $3a, $3b, $3c
.frame3
	db $02 ; bitmask
	db $43, $44, $45, $46, $47, $31, $48, $49, $34, $35, $36, $37
	db $38, $39, $3a, $3b, $3c
.frame4
	db $03 ; bitmask
	db $4a, $4b, $4c, $31, $4d, $4e, $34, $35, $36, $37, $38, $39
	db $3a, $3b, $3c
.frame5
	db $00 ; bitmask
	db $4f, $32, $33, $34, $35, $36, $50, $38, $39, $51, $3b, $3c
