	db 0 ; species ID placeholder

	db  55, 100,  80,  96,  50, 105
	;  hp  atk  def  spd  sat  sdf

	db GHOST, FAIRY ; type
	db 45 ; catch rate
	db 167 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/mimikyu/front.dimensions"
	abilities_for MIMIKYU, DISGUISE, NO_ABILITY, NO_ABILITY
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_INDETERMINATE, EGG_INDETERMINATE ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, HIDDEN_POWER, WORK_UP, PROTECT, WILL_O_WISP, FACADE, RETURN, SHADOW_BALL, SWAGGER, BULK_UP, REST, ATTRACT, THIEF, HONE_CLAWS, NIGHT_SLASH, FLASH
	; end
