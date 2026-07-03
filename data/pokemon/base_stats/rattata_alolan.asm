	db 0 ; species ID placeholder

	db  30,  56,  35,  72,  25,  35
	;  hp  atk  def  spd  sat  sdf

	db DARK, NORMAL ; type
	db 255 ; catch rate
	db 57 ; base exp
	db NO_ITEM, PSNCUREBERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/rattata_alolan/front.dimensions"
	abilities_for RATTATA_ALOLAN, GLUTTONY, HUSTLE, THICK_FAT
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, ICE_BEAM, BLIZZARD, PROTECT, RAIN_DANCE, IRON_TAIL, RETURN, DIG, SHADOW_BALL, ROCK_SMASH, DOUBLE_TEAM, SLUDGE_BOMB, SWIFT, REST, ATTRACT, THIEF, CUT, DEFENSE_CURL, ENDURE, HEADBUTT, ICY_WIND, SLEEP_TALK, SWAGGER
	; end
