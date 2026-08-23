	db 0 ; species ID placeholder

	db  60, 110,  70, 110,  60,  60
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, FLYING ; type
	db 45 ; catch rate
	db 165 ; base exp
	db NO_ITEM, SHARP_BEAK ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/dodrio/front.dimensions"
	abilities_for DODRIO, RECKLESS, EARLY_BIRD, TANGLED_FEET
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, FACADE, RETURN, MUD_SLAP, SWAGGER, KNOCK_OFF, SWIFT, REST, ATTRACT, THIEF, STEEL_WING, FLY
	; end
