	db 0 ; species ID placeholder

	db  40,  55,  30,  60,  30,  30
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, FLYING ; type
	db 255 ; catch rate
	db 49 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/starly/front.dimensions"
	abilities_for STARLY, RECKLESS, KEEN_EYE, DEFIANT
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, RAIN_DANCE, RETURN, MUD_SLAP, SWIFT, ATTRACT, THIEF, STEEL_WING, FLY
	; end
