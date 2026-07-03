	db 0 ; species ID placeholder

	db  60,  55, 100,  30,  65, 100
	;  hp  atk  def  spd  sat  sdf

	db GHOST, GHOST ; type
	db 60 ; catch rate
	db 113 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F75 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/corsola_galarian/front.dimensions"
	abilities_for CORSOLA_GALARIAN, WEAK_ARMOR, WEAK_ARMOR, CURSED_BODY
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_WATER_1, EGG_WATER_3 ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, ICE_BEAM, BLIZZARD, PROTECT, RAIN_DANCE, GIGA_DRAIN, EARTHQUAKE, RETURN, DIG, SHADOW_BALL, DOUBLE_TEAM, SANDSTORM, REST, ATTRACT, SURF, WHIRLPOOL, WATERFALL, DEFENSE_CURL, ENDURE, HEADBUTT, ICY_WIND, ROLLOUT, SLEEP_TALK, SWAGGER
	; end
