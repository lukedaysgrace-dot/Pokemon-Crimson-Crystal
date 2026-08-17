	db 0 ; species ID placeholder

	db  55,  95,  55, 115,  35,  75
	;   hp  atk  def  spd  sat  sdf

	db DARK, ICE ; type
	db 60 ; catch rate
	db 86 ; base exp
	db NO_ITEM, QUICK_CLAW ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/sneasel/front.dimensions"
	abilities_for SNEASEL, TECHNICIAN, INNER_FOCUS, KEEN_EYE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, BLIZZARD, ICICLE_CRASH, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, BUG_BITE, HONE_CLAWS, CUT, SURF, STRENGTH, ICE_BEAM
	; end
