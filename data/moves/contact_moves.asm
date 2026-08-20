ContactMoves::
; bitfield indexed by 16-bit move index (bit i&7 of byte i>>3, POUND = 1);
; set = the move makes contact (Gen IV contact flags; see CheckContactMove)
	db $be, $9f, $fa, $ef, $7f, $10, $00, $00
	db $7f, $00, $01, $08, $0c, $00, $20, $84
	db $15, $21, $04, $45, $ac, $91, $88, $02
	db $00, $61, $0e, $85, $b1, $43, $24, $92
	db $eb, $2f, $25, $ff, $d3, $bf, $01, $4e
	db $c1, $0a, $00, $be ; bit 7 of this byte = VOLT_TACKLE (contact)
	; new moves 352-413:
	; $cc = FAKE_OUT, FLIP_TURN, WOOD_HAMMER, HEAD_SMASH
	; $4d = DRILL_RUN, SACRED_SWORD, BRICK_BREAK, NUZZLE
	; $25 = DUALWINGBEAT, LOW_SWEEP, CROSS_POISON
	; $96 = PHANTOMFORCE, HEADLONGRUSH, DIRE_CLAW, KOWTOW_CLEAVE
	; $44 = GLAIVE_RUSH, PSYSHIELD (RAGING_FURY makes no contact per canon)
	; $28 = RAGING_BULL, STONE_AXE
	; $ea = BODY_PRESS, SUPERPOWER, FOUL_PLAY, RAGE_FIST, CRUSH_CLAW
	; $37 = FORCE_PALM, HAMMER_ARM, CIRCLE_THROW, BOUNCE, DRAGON_TAIL
	db $cc, $4d, $25, $96, $44, $28, $ea, $37
	; TORMENT..STICKY_WEB make no contact
	db $00
