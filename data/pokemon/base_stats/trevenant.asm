	db 0 ; species ID placeholder

	db 85, 110, 76, 56, 65, 82
	; hp, atk, def, spd, sat, sdf
	db GHOST, GRASS ; type
	db 60 ; catch rate
	db 166 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/trevenant/front.dimensions"
	abilities_for TREVENANT, NATURAL_CURE, FRISK, HARVEST
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_PLANT, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm ATTRACT, CURSE, CUT, DIG, DRAIN_PUNCH, EARTHQUAKE, ENERGY_BALL, FACADE, HIDDEN_POWER, HONE_CLAWS, HYPER_BEAM, KNOCK_OFF, PROTECT, PSYCHIC_M, RAIN_DANCE, REST, RETURN, ROCK_SMASH, SHADOW_BALL, SOLARBEAM, STRENGTH, SUNNY_DAY, SWAGGER, THIEF, TOXIC, WILL_O_WISP
	; end
