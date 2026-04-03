	db LOW(URSALUNA) ; truncated species id for extended species

	db 130, 140, 105, 50, 45, 80
	;   hp  atk  def  spd  sat  sdf

	db GROUND, NORMAL ; type
	db 20 ; catch rate
	db LOW(275) ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 5 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/ursaluna/front.dimensions"
	dw NULL, NULL ; unused (beta front/back pics)
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DYNAMICPUNCH, HEADBUTT, CURSE, ROLLOUT, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, SNORE, HYPER_BEAM, PROTECT, ENDURE, FRUSTRATION, EARTHQUAKE, RETURN, DIG, MUD_SLAP, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, FIRE_BLAST, DEFENSE_CURL, REST, ATTRACT, THIEF, CUT, STRENGTH

	; end
