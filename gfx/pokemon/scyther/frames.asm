	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
.frame1
	db $00 ; bitmask
	db $31, $32, $33
.frame2
	db $01 ; bitmask
	db $31, $34, $32, $33
.frame3
	db $02 ; bitmask
	db $35, $36, $03, $37, $38, $39, $3a, $31, $3b, $3c, $3d, $3e
	db $34, $32, $33, $3f, $40, $41, $42
.frame4
	db $03 ; bitmask
	db $03, $03, $03, $43, $44, $03, $45, $46, $47, $48, $49, $34
	db $32, $4a, $4b, $4c, $4d, $4e, $4f, $50
.frame5
	db $04 ; bitmask
	db $03, $03, $03, $51, $52, $53, $54, $55, $56, $57, $34, $32
	db $33, $58, $59
.frame6
	db $05 ; bitmask
	db $03, $03, $03, $03, $03, $03, $51, $52, $5a, $5b, $03, $45
	db $46, $54, $55, $5c, $48, $49, $57, $34, $32, $4a, $4b, $4c
	db $58, $59, $4d, $4e, $4f, $50
.frame7
	db $06 ; bitmask
	db $34
