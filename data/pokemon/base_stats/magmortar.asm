	db 0 ; species ID placeholder

	db  75,  95,  67,  83, 125,  95
	;  hp  atk  def  spd  sat  sdf

	db FIRE, FIRE ; type
	db 30 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F25 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/magmortar/front.dimensions"
	abilities_for MAGMORTAR, FLAME_BODY, FLASH_FIRE, MEGA_LAUNCHER
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, IRON_HEAD, RETURN, PSYCHIC_M, MUD_SLAP, SWAGGER, KNOCK_OFF, FIRE_BLAST, THUNDERPUNCH, REST, ATTRACT, THIEF, FIRE_PUNCH, WEATHER_BALL, STRENGTH, FLAMETHROWER, THUNDERBOLT
	; end
