	db 0 ; species ID placeholder

	db 120,  95,  65,  80,  95,  80
	;  hp  atk  def  spd  sat  sdf

	db ELECTRIC, NORMAL ; type
	db 30 ; catch rate
	db 205 ; base exp
	db PRZCUREBERRY, MAGNET ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/gorotora/front.dimensions"
	abilities_for GOROTORA, VOLT_ABSORB, INTIMIDATE, MOXIE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DYNAMICPUNCH, HEADBUTT, CURSE, ROLLOUT, ROAR, TOXIC, ZAP_CANNON, ROCK_SMASH, HIDDEN_POWER, SNORE, HYPER_BEAM, PROTECT, RAIN_DANCE, ENDURE, FRUSTRATION, IRON_TAIL, THUNDER, EARTHQUAKE, RETURN, DIG, SHADOW_BALL, MUD_SLAP, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, SANDSTORM, SWIFT, DEFENSE_CURL, THUNDERPUNCH, DETECT, REST, ATTRACT, THIEF, STRENGTH, THUNDERBOLT
	; end
