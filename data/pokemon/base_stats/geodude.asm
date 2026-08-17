	db 0 ; species ID placeholder

	db  40,  80, 100,  20,  30,  30
	;   hp  atk  def  spd  sat  sdf

	db ROCK, GROUND ; type
	db 255 ; catch rate
	db 60 ; base exp
	db NO_ITEM, EVERSTONE ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/geodude/front.dimensions"
	abilities_for GEODUDE, ROCK_HEAD, STURDY, SAND_FORCE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, PROTECT, FACADE, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, SANDSTORM, FIRE_BLAST, REST, ATTRACT, FIRE_PUNCH, STRENGTH, FLAMETHROWER
	; end
