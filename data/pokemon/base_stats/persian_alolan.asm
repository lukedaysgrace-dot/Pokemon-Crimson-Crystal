	db 0 ; species ID placeholder

	db  65,  70,  60, 115,  90,  65
	;  hp  atk  def  spd  sat  sdf

	db DARK, DARK ; type
	db 90 ; catch rate
	db 154 ; base exp
	db NO_ITEM, QUICK_CLAW ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/persian_alolan/front.dimensions"
	abilities_for PERSIAN_ALOLAN, FUR_COAT, TECHNICIAN, PRANKSTER
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ZAP_CANNON, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, RAIN_DANCE, IRON_HEAD, THUNDER, RETURN, DIG, SHADOW_BALL, SWAGGER, KNOCK_OFF, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, NIGHT_SLASH, POWER_GEM, CUT, FLASH, THUNDERBOLT
	; end
