	db 0 ; species ID placeholder

	db  70,  80,  70, 110,  80,  70
	;  hp  atk  def  spd  sat  sdf

	db ICE, GHOST ; type
	db 45 ; catch rate
	db 100 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F100 ; gender ratio (female only)
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/froslass/front.dimensions"
	abilities_for FROSLASS, SNOW_CLOAK, NO_ABILITY, CURSED_BODY
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_FAIRY, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, REST, ATTRACT
	; end
