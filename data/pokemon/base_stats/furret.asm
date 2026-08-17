	db 0 ; species ID placeholder

	db  95,  85,  65, 105,  45,  70
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 90 ; catch rate
	db 145 ; base exp
	db BERRY, GOLD_BERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/furret/front.dimensions"
	abilities_for FURRET, SCRAPPY, FUR_COAT, FRISK
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, SWIFT, THUNDERPUNCH, REST, ATTRACT, THIEF, FIRE_PUNCH, BUG_BITE, HONE_CLAWS, ZEN_HEADBUTT, CUT, SURF, STRENGTH
	; end
