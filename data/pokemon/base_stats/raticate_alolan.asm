	db 0 ; species ID placeholder

	db  80,  78,  80,  82,  40,  90
	;  hp  atk  def  spd  sat  sdf

	db DARK, NORMAL ; type
	db 130 ; catch rate
	db 145 ; base exp
	db NO_ITEM, PSNCUREBERRY ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/raticate_alolan/front.dimensions"
	abilities_for RATICATE_ALOLAN, HUSTLE, GUTS, THICK_FAT
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, IRON_HEAD, RETURN, DIG, SHADOW_BALL, SWAGGER, KNOCK_OFF, SLUDGE_BOMB, SWIFT, BULK_UP, REST, ATTRACT, THIEF, ZEN_HEADBUTT, CUT, STRENGTH, ICE_BEAM
	; end
