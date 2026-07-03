	db 0 ; species ID placeholder

	db  38,  41,  40,  65,  50,  65
	;  hp  atk  def  spd  sat  sdf

	db ICE, ICE ; type
	db 190 ; catch rate
	db 63 ; base exp
	db ICE_BERRY, ICE_BERRY ; items
	db GENDER_F75 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/vulpix_alolan/front.dimensions"
	abilities_for VULPIX_ALOLAN, SNOW_CLOAK, SNOW_CLOAK, SNOW_WARNING
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm CURSE, ROAR, TOXIC, HIDDEN_POWER, ICE_BEAM, BLIZZARD, PROTECT, RAIN_DANCE, IRON_TAIL, RETURN, DIG, SHADOW_BALL, DOUBLE_TEAM, SWIFT, REST, ATTRACT, ENDURE, HEADBUTT, ICY_WIND, SLEEP_TALK, SWAGGER
	; end
