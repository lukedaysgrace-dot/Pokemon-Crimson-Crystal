	db 0 ; species ID placeholder

	db  85,  60, 100,  75, 125,  80
	;  hp  atk  def  spd  sat  sdf

	db FIRE, PSYCHIC ; type
	db 25 ; catch rate
	db 255 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 35 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/armarouge/front.dimensions"
	abilities_for ARMAROUGE, FLASH_FIRE, WEAK_ARMOR, MEGA_LAUNCHER
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_HUMANSHAPE, EGG_HUMANSHAPE ; egg groups

	; tm/hm learnset
	tmhm TOXIC, DRAGON_PULSE, SUNNY_DAY, HYPER_BEAM, PROTECT, ENERGY_BALL, WILL_O_WISP, FACADE, PSYCHIC_M, FLASH_CANNON, FIRE_BLAST, REST, ATTRACT, WEATHER_BALL, FLAMETHROWER, SHADOW_BALL, SOLARBEAM
	; end
