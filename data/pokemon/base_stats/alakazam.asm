	db 0 ; species ID placeholder

	db  55,  50,  45, 120, 135,  95
	;   hp  atk  def  spd  sat  sdf

	db PSYCHIC, PSYCHIC ; type
	db 50 ; catch rate
	db 250 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F25 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/alakazam/front.dimensions"
	abilities_for ALAKAZAM, MAGIC_GUARD, SYNCHRONIZE, INNER_FOCUS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, RETURN, DIG, PSYCHIC_M, SHADOW_BALL, SWAGGER, ICE_PUNCH, KNOCK_OFF, THUNDERPUNCH, NASTY_PLOT, REST, ATTRACT, THIEF, FIRE_PUNCH, ZEN_HEADBUTT, FLASH
	; end
