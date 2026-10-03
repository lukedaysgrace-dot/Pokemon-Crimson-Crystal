	db 0 ; species ID placeholder

	db 130, 140, 105,  50,  45,  80
	;  hp  atk  def  spd  sat  sdf

	db GROUND, NORMAL ; type
	db 60 ; catch rate
	db 175 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/ursaluna/front.dimensions"
	abilities_for URSALUNA, GUTS, BULLETPROOF, UNNERVE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, ROAR, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, SWEET_SCENT, WORK_UP, HYPER_BEAM, PROTECT, FACADE, EARTHQUAKE, RETURN, DIG, MUD_SLAP, SWAGGER, ICE_PUNCH, SANDSTORM, SWIFT, BULK_UP, THUNDERPUNCH, REST, ATTRACT, THIEF, FIRE_PUNCH, FURY_CUTTER, HONE_CLAWS, NIGHT_SLASH, CUT, STRENGTH
	; end
