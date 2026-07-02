	db 0 ; species ID placeholder

	db  98,  87, 105,  67,  53,  85
	;   hp  atk  def  spd  sat  sdf

	db FLYING, STEEL ; type
	db 45 ; catch rate
	db 248 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/corviknight/front.dimensions"
	abilities_for CORVIKNIGHT, PRESSURE, UNNERVE, MAGIC_BOUNCE
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, MUD_SLAP, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, SANDSTORM, SWIFT, DETECT, REST, ATTRACT, THIEF, STEEL_WING, CUT, FLY
	; end
