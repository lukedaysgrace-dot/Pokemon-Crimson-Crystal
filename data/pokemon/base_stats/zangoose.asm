	db 0 ; species ID placeholder

	db  75, 115,  60, 100,  60,  60
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 90 ; catch rate
	db 160 ; base exp
	db NO_ITEM, QUICK_CLAW ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/zangoose/front.dimensions"
	abilities_for ZANGOOSE, IMMUNITY, SCRAPPY, TOUGH_CLAWS
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, FACADE, THUNDER, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, THUNDERPUNCH, REST, ATTRACT, THIEF, BUG_BITE, HONE_CLAWS, NIGHT_SLASH, ZEN_HEADBUTT, CUT, STRENGTH
	; end
