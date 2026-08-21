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
	db $3d, $3e, $3f, $40, $41, $42, $43, $44
.frame2
	db $01 ; bitmask
	db $31, $32, $45, $35, $36, $37, $46, $3a, $3b, $3c, $3d, $3f
	db $40, $41, $42, $43, $44
.frame3
	db $02 ; bitmask
	db $31, $32, $33, $34, $47, $38, $39, $3a, $48, $49, $4a, $3e
	db $42, $43, $44
.frame4
	db $03 ; bitmask
	db $4b, $4c, $4d, $4e, $35, $36, $37, $46, $3a, $3b, $3c, $3d
	db $3f, $40, $41, $42, $43, $44
.frame5
	db $04 ; bitmask
	db $31, $32, $47, $3a, $48, $49, $4a, $42, $43, $44
.frame6
	db $05 ; bitmask
	db $4b, $4c, $4d, $4f, $47, $3a, $48, $49, $4a, $42, $43, $44
.frame7
	db $04 ; bitmask
	db $31, $32, $47, $3a, $48, $49, $4a, $42, $43, $44
.frame8
	db $05 ; bitmask
	db $4b, $4c, $4d, $4f, $47, $3a, $48, $49, $4a, $42, $43, $44
