	dw .frame1
	dw .frame2
	dw .frame3
	dw .frame4
.frame1
	db $00 ; bitmask
	db $00, $19, $1a, $1b, $1c, $1d, $02, $1e, $1f, $00, $20, $21
	db $22, $23, $24
.frame2
	db $01 ; bitmask
	db $25
.frame3
	db $02 ; bitmask
	db $00, $19, $1a, $1b, $1c, $1d, $02, $1e, $25, $1f, $00, $20
	db $21, $22, $23, $24
.frame4
	db $03 ; bitmask
	db $00, $19, $1a, $00, $26, $1b, $1c, $1d, $02, $27, $25, $1f
	db $00, $20, $21, $22, $23, $24
