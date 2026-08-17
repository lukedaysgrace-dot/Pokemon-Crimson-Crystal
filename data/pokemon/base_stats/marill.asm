	db 0 ; species ID placeholder

	db  70,  20,  50,  40,  40,  50
	;   hp  atk  def  spd  sat  sdf

	db WATER, FAIRY ; type
	db 190 ; catch rate
	db 88 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/marill/front.dimensions"
	abilities_for MARILL, HUGE_POWER, THICK_FAT, SAP_SIPPER
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_WATER_1, EGG_FAIRY ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, ROCK_TOMB, TOXIC, HIDDEN_POWER, WORK_UP, BLIZZARD, PROTECT, RAIN_DANCE, FACADE, IRON_HEAD, RETURN, MUD_SLAP, SWAGGER, ICE_PUNCH, KNOCK_OFF, SWIFT, REST, ATTRACT, SURF, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end
