	db 0 ; species ID placeholder

	db  55,  95, 115,  35,  45,  45
	;  hp  atk  def  spd  sat  sdf

	db ROCK, ELECTRIC ; type
	db 120 ; catch rate
	db 134 ; base exp
	db NO_ITEM, EVERSTONE ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/graveler_alolan/front.dimensions"
	abilities_for GRAVELER_ALOLAN, MAGNET_PULL, STURDY, GALVANIZE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm DYNAMICPUNCH, CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, PROTECT, THUNDERBOLT, THUNDER, EARTHQUAKE, RETURN, DIG, ROCK_SMASH, DOUBLE_TEAM, FLAMETHROWER, SANDSTORM, FIRE_BLAST, REST, ATTRACT, STRENGTH, DEFENSE_CURL, ENDURE, FIRE_PUNCH, HEADBUTT, ROLLOUT, SLEEP_TALK, SWAGGER, THUNDERPUNCH
	; end
