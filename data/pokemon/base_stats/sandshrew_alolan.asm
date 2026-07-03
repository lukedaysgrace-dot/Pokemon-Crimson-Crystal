	db 0 ; species ID placeholder

	db  50,  75,  90,  40,  10,  35
	;  hp  atk  def  spd  sat  sdf

	db ICE, STEEL ; type
	db 255 ; catch rate
	db 93 ; base exp
	db NO_ITEM, QUICK_CLAW ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/sandshrew_alolan/front.dimensions"
	abilities_for SANDSHREW_ALOLAN, SNOW_CLOAK, SNOW_CLOAK, SLUSH_RUSH
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DYNAMICPUNCH, CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, ICE_BEAM, BLIZZARD, PROTECT, IRON_TAIL, EARTHQUAKE, RETURN, DIG, ROCK_SMASH, DOUBLE_TEAM, SWIFT, REST, ATTRACT, THIEF, CUT, STRENGTH, DEFENSE_CURL, ENDURE, HEADBUTT, ICE_PUNCH, ROLLOUT, SLEEP_TALK, SWAGGER
	; end
