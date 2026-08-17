	db 0 ; species ID placeholder

	db  60,  50,  50,  50,  60,  70
	;  hp  atk  def  spd  sat  sdf

	db WATER, GRASS ; type
	db 120 ; catch rate
	db 119 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/lombre/front.dimensions"
	abilities_for LOMBRE, SWIFT_SWIM, RAIN_DISH, OWN_TEMPO
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_WATER_1, EGG_PLANT ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, PROTECT, ENERGY_BALL, FACADE, RETURN, SWAGGER, KNOCK_OFF, REST, ATTRACT, HONE_CLAWS, ZEN_HEADBUTT, SURF, WHIRLPOOL, WATERFALL
	; end
