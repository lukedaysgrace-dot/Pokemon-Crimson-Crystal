	db 0 ; species ID placeholder

	db  97, 155,  90,  33,  35,  90
	;  hp  atk  def  spd  sat  sdf

	db ROCK, ROCK ; type
	db 45 ; catch rate
	db 173 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 30 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/rampardos/front.dimensions"
	abilities_for RAMPARDOS, ROCK_HEAD, MOLD_BREAKER, SHEER_FORCE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_MONSTER ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, DRAGON_PULSE, HIDDEN_POWER, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, DRAGON_CLAW, EARTHQUAKE, RETURN, MUD_SLAP, SWAGGER, ICE_PUNCH, SANDSTORM, THUNDERPUNCH, REST, ATTRACT, FIRE_PUNCH, ZEN_HEADBUTT, POWER_GEM, STRENGTH
	; end
