	db LOW(ANNIHILAPE) ; truncated species id for extended species

	db 110, 115, 80, 90, 50, 90
	;   hp  atk  def  spd  sat  sdf

	db FIGHTING, GHOST ; type
	db 45 ; catch rate
	db LOW(268) ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 3 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/annihilape/front.dimensions"
	dw NULL, NULL ; unused (beta front/back pics)
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DYNAMICPUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, SNORE, HYPER_BEAM, PROTECT, ENDURE, FRUSTRATION, EARTHQUAKE, RETURN, DIG, MUD_SLAP, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, FIRE_BLAST, REST, ATTRACT, THIEF, STRENGTH

	; end
