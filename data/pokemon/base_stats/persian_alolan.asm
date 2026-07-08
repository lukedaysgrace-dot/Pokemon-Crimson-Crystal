	db 0 ; species ID placeholder

	db  65,  70,  60, 115,  90,  65
	;  hp  atk  def  spd  sat  sdf

	db DARK, DARK ; type
	db 90 ; catch rate
	db 148 ; base exp
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
	tmhm CURSE, ROAR, TOXIC, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, RAIN_DANCE, IRON_TAIL, THUNDERBOLT, THUNDER, RETURN, DIG, SHADOW_BALL, DOUBLE_TEAM, SWIFT, REST, ATTRACT, THIEF, FLASH, CUT, DEFENSE_CURL, DREAM_EATER, ENDURE, HEADBUTT, ICY_WIND, SLEEP_TALK, SWAGGER, ZAP_CANNON
	; end
