	db 0 ; species ID placeholder

	db 135,  85,  40,   5,  40,  85
	;  hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 50 ; catch rate
	db 78 ; base exp
	db LEFTOVERS, LEFTOVERS ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 40 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/munchlax/front.dimensions"
	abilities_for MUNCHLAX, THICK_FAT, PICKUP, GLUTTONY
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, EARTHQUAKE, RETURN, MUD_SLAP, SWAGGER, REST, ATTRACT, ZEN_HEADBUTT, SURF, STRENGTH, FLAMETHROWER, THUNDERBOLT, ICE_BEAM
	; end
