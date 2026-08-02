	db 0 ; species ID placeholder

	db 106,  70,  90,  66, 130,  80
	;   hp  atk  def  spd  sat  sdf

	db GRASS, DRAGON ; type
	db 10 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/hydrapple/front.dimensions"
	abilities_for HYDRAPPLE, REGENERATOR, SHEER_FORCE, MULTISCALE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_PLANT, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, SNORE, HYPER_BEAM, PROTECT, GIGA_DRAIN, ENDURE, FRUSTRATION, SOLARBEAM, IRON_TAIL, DRAGONBREATH, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT, THIEF, ROCK_SMASH, DEFENSE_CURL, ROLLOUT
	; end
