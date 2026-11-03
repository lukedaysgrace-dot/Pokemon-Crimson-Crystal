	db 0 ; species ID placeholder

	db 108, 112, 118, 47, 68, 72
	; hp atk def spd sat sdf

	db GROUND, GROUND ; type
	db 60 ; catch rate
	db 184 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 30 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/hippowdon/front.dimensions"
	abilities_for HIPPOWDON, SAND_STREAM, SAND_FORCE, STRONG_JAW
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups (Field)

	tmhm HEADBUTT, CURSE, ROCK_TOMB, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, SANDSTORM, REST, ATTRACT, WEATHER_BALL, STRENGTH
	; end
