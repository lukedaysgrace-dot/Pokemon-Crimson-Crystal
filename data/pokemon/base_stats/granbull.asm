	db 0 ; species ID placeholder

	db  90, 120,  75,  45,  60,  75
	;   hp  atk  def  spd  sat  sdf

	db FAIRY, FAIRY ; type
	db 75 ; catch rate
	db 158 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F75 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/granbull/front.dimensions"
	abilities_for GRANBULL, INTIMIDATE, QUICK_FEET, STRONG_JAW
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_GROUND, EGG_FAIRY ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROAR, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, THUNDER, RETURN, SHADOW_BALL, MUD_SLAP, SWAGGER, ICE_PUNCH, SLUDGE_BOMB, BULK_UP, THUNDERPUNCH, REST, ATTRACT, THIEF, FIRE_PUNCH, STRENGTH, THUNDERBOLT
	; end
