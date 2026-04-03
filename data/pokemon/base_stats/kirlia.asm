	db LOW(KIRLIA) ; truncated species id for extended species

	db 38, 35, 35, 50, 65, 55
	;   hp  atk  def  spd  sat  sdf

	db PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	db 120 ; catch rate
	db 97 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 5 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/kirlia/front.dimensions"
	dw NULL, NULL ; unused (beta front/back pics)
	db GROWTH_SLOW ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, ZAP_CANNON, PSYCH_UP, HIDDEN_POWER, SUNNY_DAY, SNORE, PROTECT, RAIN_DANCE, ENDURE, FRUSTRATION, THUNDER, RETURN, PSYCHIC_M, SHADOW_BALL, MUD_SLAP, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, DREAM_EATER, REST, ATTRACT, THIEF, FLASH

	; end
