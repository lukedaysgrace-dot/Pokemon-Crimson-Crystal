	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $02, $02, $31, $32, $33, $34, $02, $02, $35, $36, $37, $38
	db $02, $02, $39, $3a, $3b, $3c, $02, $02, $02, $02, $3d, $3e
	db $3f, $02, $02, $02, $40, $41, $42, $43, $02, $02, $02, $02
	db $44, $45, $46, $47
.frame2
	db $01 ; bitmask
	db $48, $49, $4a
.frame3
	db $01 ; bitmask
	db $4b, $49, $4c
.frame4
	db $01 ; bitmask
	db $4d, $49, $4e
