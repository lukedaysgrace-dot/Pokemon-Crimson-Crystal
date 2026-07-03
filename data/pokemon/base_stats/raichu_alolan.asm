	db 0 ; species ID placeholder

	db  60,  85,  50, 110,  95,  85
	;  hp  atk  def  spd  sat  sdf

	db ELECTRIC, PSYCHIC ; type
	db 75 ; catch rate
	db 122 ; base exp
	db BERRY, LIGHT_BALL ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 10 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/raichu_alolan/front.dimensions"
	abilities_for RAICHU_ALOLAN, STATIC, STATIC, MOTOR_DRIVE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_FAIRY ; egg groups

	; tm/hm learnset
	tmhm DYNAMICPUNCH, CURSE, TOXIC, HIDDEN_POWER, HYPER_BEAM, PROTECT, RAIN_DANCE, IRON_TAIL, THUNDERBOLT, THUNDER, RETURN, DIG, ROCK_SMASH, DOUBLE_TEAM, SWIFT, REST, ATTRACT, THIEF, FLASH, SURF, STRENGTH, DEFENSE_CURL, ENDURE, HEADBUTT, ROLLOUT, SLEEP_TALK, SWAGGER, THUNDERPUNCH, ZAP_CANNON
	; end
