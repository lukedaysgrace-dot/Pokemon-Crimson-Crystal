	db 0 ; species ID placeholder

	db  25,  20,  15,  90, 105,  55
	;   hp  atk  def  spd  sat  sdf

	db PSYCHIC, PSYCHIC ; type
	db 200 ; catch rate
	db 62 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F25 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/abra/front.dimensions"
	abilities_for ABRA, MAGIC_GUARD, SYNCHRONIZE, INNER_FOCUS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, PROTECT, RAIN_DANCE, FACADE, RETURN, PSYCHIC_M, SHADOW_BALL, SWAGGER, ICE_PUNCH, KNOCK_OFF, THUNDERPUNCH, REST, ATTRACT, THIEF, FIRE_PUNCH, ZEN_HEADBUTT, FLASH
	; end
