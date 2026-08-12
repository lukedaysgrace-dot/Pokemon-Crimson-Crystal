	db 0 ; species ID placeholder

	db  30,  35,  45,  65,  80,  95
	;  hp  atk  def  spd  sat  sdf

	db PSYCHIC, FAIRY ; type
	db 145 ; catch rate
	db 78 ; base exp
	db NO_ITEM, MYSTERYBERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/mime_jr_/front.dimensions"
	abilities_for MIME_JR_, SOUNDPROOF, FILTER, TECHNICIAN
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, ICY_WIND, PROTECT, RAIN_DANCE, ENDURE, SOLARBEAM, THUNDER, RETURN, PSYCHIC_M, SHADOW_BALL, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, DREAM_EATER, REST, ATTRACT, THIEF, FLASH, THUNDERBOLT
	; end
