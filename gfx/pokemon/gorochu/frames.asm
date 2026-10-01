	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
.frame1
	db $00 ; bitmask
	db $31, $32, $33, $34, $35
.frame2
	db $01 ; bitmask
	db $31, $32, $36, $37, $33, $34, $35, $38, $39, $3a
.frame3
	db $02 ; bitmask
	db $3b, $32, $36, $3c, $3d, $3e, $35, $38, $39, $3f, $40, $41
	db $42
.frame4
	db $03 ; bitmask
	db $31, $32, $36, $37, $33, $34, $35, $38, $43, $39, $3a
.frame5
	db $04 ; bitmask
	db $3b, $44, $45, $05, $36, $3c, $3d, $46, $47, $48, $38, $43
	db $05, $49, $39, $3f, $4a, $4b, $4c, $4d, $41, $42, $4e, $4f
	db $50, $51, $52, $53
.frame6
	db $05 ; bitmask
	db $54, $55, $38, $56, $57
