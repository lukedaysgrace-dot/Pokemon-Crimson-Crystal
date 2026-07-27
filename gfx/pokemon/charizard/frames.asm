	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
	dw .frame5
	dw .frame6
	dw .frame7
	dw .frame8
	dw .frame9
.frame1
	db $00 ; bitmask
	db $31
.frame2
	db $01 ; bitmask
	db $32, $33, $31, $34, $35, $36
.frame3
	db $02 ; bitmask
	db $37, $38, $33, $31, $34, $35, $36
.frame4
	db $02 ; bitmask
	db $39, $3a, $33, $31, $34, $35, $36
.frame5
	db $03 ; bitmask
	db $3b, $3c, $3d, $33, $34, $35, $36
.frame6
	db $03 ; bitmask
	db $3e, $3f, $40, $33, $34, $35, $36
.frame7
	db $03 ; bitmask
	db $41, $42, $32, $33, $34, $35, $36
.frame8
	db $03 ; bitmask
	db $43, $44, $32, $33, $34, $35, $36
.frame9
	db $04 ; bitmask
	db $45, $32, $33, $34, $35, $36
