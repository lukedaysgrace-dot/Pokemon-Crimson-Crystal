	db 0 ; species ID placeholder

	db  85,  90, 140,  70,  40,  70
	;   hp  atk  def  spd  sat  sdf

	db STEEL, FLYING ; type
	db 25 ; catch rate
	db 163 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 25 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/skarmory/front.dimensions"
	abilities_for SKARMORY, IRON_BARBS, STURDY, SHARPNESS
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, PROTECT, FACADE, RETURN, MUD_SLAP, SWAGGER, FLASH_CANNON, SANDSTORM, SWIFT, REST, ATTRACT, THIEF, STEEL_WING, NIGHT_SLASH, CUT, FLY
	; end
