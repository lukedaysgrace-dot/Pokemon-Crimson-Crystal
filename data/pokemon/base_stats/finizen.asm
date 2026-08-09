	db 0 ; species ID placeholder

	db  70,  45,  40,  75,  45,  40
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 200 ; catch rate
	db 63 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/finizen/front.dimensions"
	abilities_for FINIZEN, WATER_VEIL, WATER_VEIL, SWIFT_SWIM
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_WATER_2, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, HIDDEN_POWER, SNORE, BLIZZARD, ICY_WIND, PROTECT, RAIN_DANCE, ENDURE, FRUSTRATION, RETURN, MUD_SLAP, DOUBLE_TEAM, SWAGGER, SLEEP_TALK, SWIFT, DETECT, REST, ATTRACT, SURF, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end
