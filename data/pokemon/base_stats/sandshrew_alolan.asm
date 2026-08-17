	db 0 ; species ID placeholder

	db  50,  75,  90,  40,  10,  35
	;  hp  atk  def  spd  sat  sdf

	db ICE, STEEL ; type
	db 255 ; catch rate
	db 60 ; base exp
	db NO_ITEM, QUICK_CLAW ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/sandshrew_alolan/front.dimensions"
	abilities_for SANDSHREW_ALOLAN, SNOW_CLOAK, TOUGH_CLAWS, SLUSH_RUSH
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, BLIZZARD, ICICLE_CRASH, PROTECT, IRON_HEAD, EARTHQUAKE, RETURN, DIG, SWAGGER, ICE_PUNCH, FLASH_CANNON, KNOCK_OFF, SWIFT, REST, ATTRACT, THIEF, HONE_CLAWS, NIGHT_SLASH, CUT, STRENGTH, ICE_BEAM
	; end
