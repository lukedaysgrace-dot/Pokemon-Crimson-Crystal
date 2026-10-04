	db 0 ; species ID placeholder

	db  75, 125, 140,  40,  60,  90
	;  hp  atk  def  spd  sat  sdf

	db BUG, WATER ; type
	db 45 ; catch rate
	db 186 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/golisopod/front.dimensions"
	abilities_for GOLISOPOD, BATTLE_ARMOR, WATER_VEIL, TOUGH_CLAWS
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_BUG, EGG_WATER_3 ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, HYPER_BEAM, PROTECT, RAIN_DANCE, FACADE, RETURN, SWAGGER, KNOCK_OFF, BULK_UP, REST, ATTRACT, FURY_CUTTER, SURF, STRENGTH, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end
