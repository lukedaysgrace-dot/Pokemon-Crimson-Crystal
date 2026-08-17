	db 0 ; species ID placeholder

	db  73, 105,  62,  85,  75,  65
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 45 ; catch rate
	db 163 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/stantler/front.dimensions"
	abilities_for STANTLER, INTIMIDATE, FRISK, SAP_SIPPER
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, RAIN_DANCE, FACADE, EARTHQUAKE, RETURN, PSYCHIC_M, MUD_SLAP, SWAGGER, SWIFT, REST, ATTRACT, THIEF, ZEN_HEADBUTT, FLASH
	; end
