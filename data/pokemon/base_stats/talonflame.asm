	db 0 ; species ID placeholder

	db  78,  81,  71, 126,  74,  69
	;  hp  atk  def  spd  sat  sdf

	db FIRE, FLYING ; type
	db 45 ; catch rate
	db 175 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/talonflame/front.dimensions"
	abilities_for TALONFLAME, FLAME_BODY, NO_ABILITY, GALE_WINGS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_FLYING, EGG_FLYING ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, WILL_O_WISP, FACADE, RETURN, SWAGGER, BULK_UP, REST, ATTRACT, STEEL_WING, HONE_CLAWS, FLY
	; end
