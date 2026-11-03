	db 0 ; species ID placeholder

	db 70, 70, 40, 60, 60, 40
	;  hp  atk  def  spd  sat  sdf

	db GRASS, DARK ; type
	db 120 ; catch rate
	db 119 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/nuzleaf/front.dimensions"
	abilities_for NUZLEAF, PRANKSTER, WIND_RIDER, TECHNICIAN
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_GROUND, EGG_PLANT ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, ENERGY_BALL, FACADE, SOLARBEAM, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, KNOCK_OFF, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, FURY_CUTTER, NIGHT_SLASH, WEATHER_BALL, CUT, STRENGTH, FLASH
	; end
