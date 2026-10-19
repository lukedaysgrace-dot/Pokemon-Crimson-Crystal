	db 0 ; species ID placeholder

	db 43, 70, 48, 38, 50, 60
	; hp, atk, def, spd, sat, sdf
	db GHOST, GRASS ; type
	db 120 ; catch rate
	db 62 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/phantump/front.dimensions"
	abilities_for PHANTUMP, NATURAL_CURE, FRISK, HARVEST
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_PLANT, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm ATTRACT, CURSE, CUT, DIG, ENERGY_BALL, FACADE, HIDDEN_POWER, PROTECT, PSYCHIC_M, RAIN_DANCE, REST, RETURN, ROCK_SMASH, SHADOW_BALL, SOLARBEAM, STRENGTH, SUNNY_DAY, SWAGGER, THIEF, TOXIC, WILL_O_WISP
	; end
