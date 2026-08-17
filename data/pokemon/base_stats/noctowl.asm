	db 0 ; species ID placeholder

	db 100,  40,  50,  60, 106, 116
	;   hp  atk  def  spd  sat  sdf

	db PSYCHIC, FLYING ; type
	db 90 ; catch rate
	db 158 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/noctowl/front.dimensions"
	abilities_for NOCTOWL, TINTED_LENS, INSOMNIA, INTIMIDATE
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, WORK_UP, HYPER_BEAM, PROTECT, FACADE, RETURN, MUD_SLAP, SWAGGER, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, STEEL_WING, ZEN_HEADBUTT, FLY, FLASH
	; end
