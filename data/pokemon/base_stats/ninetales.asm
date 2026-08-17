	db 0 ; species ID placeholder

	db  73,  67,  75, 109,  81, 100
	;   hp  atk  def  spd  sat  sdf

	db FIRE, FAIRY ; type
	db 75 ; catch rate
	db 177 ; base exp
	db BURNT_BERRY, BURNT_BERRY ; items
	db GENDER_F75 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/ninetales/front.dimensions"
	abilities_for NINETALES, DROUGHT, FLASH_FIRE, CURSED_BODY
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, IRON_HEAD, RETURN, DIG, SWAGGER, FIRE_BLAST, SWIFT, NASTY_PLOT, REST, ATTRACT, ZEN_HEADBUTT, FLAMETHROWER
	; end
