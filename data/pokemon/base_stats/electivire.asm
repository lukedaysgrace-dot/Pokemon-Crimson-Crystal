	db 0 ; species ID placeholder

	db  75, 123,  67,  95,  95,  85
	;  hp  atk  def  spd  sat  sdf

	db ELECTRIC, FIGHTING ; type
	db 30 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F25 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/electivire/front.dimensions"
	abilities_for ELECTIVIRE, MOTOR_DRIVE, SHEER_FORCE, IRON_FIST
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, THUNDER, RETURN, PSYCHIC_M, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, SWIFT, BULK_UP, THUNDERPUNCH, REST, ATTRACT, THIEF, FIRE_PUNCH, WEATHER_BALL, STRENGTH, FLASH, FLAMETHROWER, THUNDERBOLT
	; end
