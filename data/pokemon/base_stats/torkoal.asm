	db 0 ; species ID placeholder

	db  70,  85, 140,  20,  85,  70
	;   hp  atk  def  spd  sat  sdf

	db FIRE, FIRE ; type
	db 90 ; catch rate
	db 165 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/torkoal/front.dimensions"
	abilities_for TORKOAL, DROUGHT, WHITE_SMOKE, SHELL_ARMOR
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROCK_TOMB, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, SOLARBEAM, IRON_HEAD, EARTHQUAKE, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, SANDSTORM, FIRE_BLAST, REST, ATTRACT, ZEN_HEADBUTT, STRENGTH, FLAMETHROWER
	; end
