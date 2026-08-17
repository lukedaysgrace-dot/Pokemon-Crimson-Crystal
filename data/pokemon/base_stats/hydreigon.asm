	db 0 ; species ID placeholder

	db  92, 105,  90,  98, 125,  90
	;  hp  atk  def  spd  sat  sdf

	db DARK, DRAGON ; type
	db 45 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 40 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/hydreigon/front.dimensions"
	abilities_for HYDREIGON, LEVITATE, BERSERK, NO_ABILITY
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_DRAGON, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, DRAGON_PULSE, HIDDEN_POWER, WORK_UP, PROTECT, FACADE, RETURN, SWAGGER, FLASH_CANNON, NASTY_PLOT, DRAGON_DANCE, REST, ATTRACT, ZEN_HEADBUTT
	; end
