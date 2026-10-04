	db 0 ; species ID placeholder

	db  80, 100,  70,  40, 105,  75
	;  hp  atk  def  spd  sat  sdf

	db FIRE, GROUND ; type
	db 150 ; catch rate
	db 161 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/camerupt/front.dimensions"
	abilities_for CAMERUPT, SOLID_ROCK, DROUGHT, SHEER_FORCE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, FLASH_CANNON, SANDSTORM, FIRE_BLAST, REST, ATTRACT, ZEN_HEADBUTT, STRENGTH, FLAMETHROWER
	; end
