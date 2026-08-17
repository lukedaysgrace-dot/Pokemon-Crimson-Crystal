	db 0 ; species ID placeholder

	db  50,  20,  40,  20,  20,  40
	;  hp  atk  def  spd  sat  sdf

	db NORMAL, FAIRY ; type
	db 150 ; catch rate
	db 33 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F75 ; gender ratio
	db 100 ; unknown 1
	db 10 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/azurill/front.dimensions"
	abilities_for AZURILL, THICK_FAT, HUGE_POWER, SAP_SIPPER
	db 0 ; padding
	db GROWTH_FAST ; growth rate
	dn EGG_NONE, EGG_NONE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROCK_TOMB, TOXIC, HIDDEN_POWER, WORK_UP, BLIZZARD, PROTECT, RAIN_DANCE, IRON_HEAD, RETURN, SWAGGER, KNOCK_OFF, SWIFT, REST, ATTRACT, SURF, WHIRLPOOL, WATERFALL, ICE_BEAM
	; end
