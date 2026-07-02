	db 0 ; species ID placeholder

	db 100, 115,  65,  65,  90,  90
	;  hp  atk  def  spd  sat  sdf

	db FIRE, BUG ; type
	db 45 ; catch rate
	db 100 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/centiskorch/front.dimensions"
	abilities_for CENTISKORCH, FLASH_FIRE, WHITE_SMOKE, FLAME_BODY
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_BUG, EGG_BUG ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT, SUNNY_DAY
	; end
