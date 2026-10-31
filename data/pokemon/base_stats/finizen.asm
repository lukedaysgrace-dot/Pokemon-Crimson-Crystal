	db 0 ; species ID placeholder

	db  70,  45,  40,  75,  45,  40
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 200 ; catch rate
	db 63 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 40 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/finizen/front.dimensions"
	abilities_for FINIZEN, WATER_VEIL, SWIFT_SWIM, NO_ABILITY
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_WATER_2, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm BLIZZARD, PROTECT, RAIN_DANCE, FACADE, SWIFT, REST, ZEN_HEADBUTT, SURF, WATERFALL, ICE_BEAM
	; end
