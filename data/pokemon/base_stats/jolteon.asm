	db 0 ; species ID placeholder

	db  65,  65,  60, 130, 110,  95
	;   hp  atk  def  spd  sat  sdf

	db ELECTRIC, ELECTRIC ; type
	db 45 ; catch rate
	db 184 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 35 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/jolteon/front.dimensions"
	abilities_for JOLTEON, VOLT_ABSORB, QUICK_FEET, COMPETITIVE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, THUNDER, RETURN, SHADOW_BALL, MUD_SLAP, SWAGGER, SWIFT, REST, ATTRACT, FLASH, THUNDERBOLT
	; end
