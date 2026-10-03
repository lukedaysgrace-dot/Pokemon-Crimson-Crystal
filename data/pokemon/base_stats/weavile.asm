	db 0 ; species ID placeholder

	db  70, 120,  65, 125,  45,  85
	;  hp  atk  def  spd  sat  sdf

	db DARK, ICE ; type
	db 45 ; catch rate
	db 179 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/weavile/front.dimensions"
	abilities_for WEAVILE, TECHNICIAN, PRESSURE, PICKPOCKET
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, BLIZZARD, HYPER_BEAM, ICICLE_CRASH, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, FURY_CUTTER, HONE_CLAWS, NIGHT_SLASH, CUT, SURF, STRENGTH, ICE_BEAM
	; end
