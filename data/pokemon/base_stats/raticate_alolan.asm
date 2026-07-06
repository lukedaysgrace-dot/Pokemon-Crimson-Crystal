	db 0 ; species ID placeholder

	db  75,  71,  70,  77,  40,  80
	;  hp  atk  def  spd  sat  sdf

	db DARK, NORMAL ; type
	db 90 ; catch rate
	db 116 ; base exp
	db NO_ITEM, PSNCUREBERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/raticate_alolan/front.dimensions"
	abilities_for RATICATE_ALOLAN, HUSTLE, GUTS, HUSTLE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROAR, TOXIC, HIDDEN_POWER, SUNNY_DAY, ICE_BEAM, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, IRON_TAIL, RETURN, DIG, SHADOW_BALL, ROCK_SMASH, DOUBLE_TEAM, SLUDGE_BOMB, SWIFT, REST, ATTRACT, THIEF, CUT, STRENGTH, DEFENSE_CURL, ENDURE, HEADBUTT, ICY_WIND, SLEEP_TALK, SWAGGER
	; end
