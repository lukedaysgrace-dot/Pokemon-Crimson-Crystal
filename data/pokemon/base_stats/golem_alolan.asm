	db 0 ; species ID placeholder

	db  80, 120, 130,  45,  55,  65
	;  hp  atk  def  spd  sat  sdf

	db ROCK, ELECTRIC ; type
	db 45 ; catch rate
	db 223 ; base exp
	db NO_ITEM, EVERSTONE ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/golem_alolan/front.dimensions"
	abilities_for GOLEM_ALOLAN, MAGNET_PULL, STURDY, GALVANIZE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, THUNDER, EARTHQUAKE, RETURN, DIG, SWAGGER, SANDSTORM, FIRE_BLAST, THUNDERPUNCH, REST, ATTRACT, FIRE_PUNCH, STRENGTH, FLAMETHROWER, THUNDERBOLT
	; end
