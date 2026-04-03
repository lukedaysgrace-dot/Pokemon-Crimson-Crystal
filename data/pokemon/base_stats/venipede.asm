	db LOW(VENIPEDE) ; truncated species id for extended species

	db 30, 45, 59, 57, 30, 39
	;   hp  atk  def  spd  sat  sdf

	db BUG, POISON ; type
	db 255 ; catch rate
	db 52 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 4 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/venipede/front.dimensions"
	dw NULL, NULL ; unused (beta front/back pics)
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_BUG, EGG_BUG ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, SNORE, PROTECT, GIGA_DRAIN, ENDURE, FRUSTRATION, RETURN, DIG, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, DEFENSE_CURL, REST, ATTRACT

	; end
