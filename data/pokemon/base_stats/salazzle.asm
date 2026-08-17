	db 0 ; species ID placeholder

	db  68,  64,  60, 117, 116,  60
	;   hp  atk  def  spd  sat  sdf

	db POISON, FIRE ; type
	db 45 ; catch rate
	db 168 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F100 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/salazzle/front.dimensions"
	abilities_for SALAZZLE, CORROSION, POISON_PUPPETEER, MERCILESS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, DRAGON_CLAW, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, KNOCK_OFF, SLUDGE_BOMB, FIRE_BLAST, SWIFT, NASTY_PLOT, DRAGON_DANCE, REST, ATTRACT, THIEF, FLAMETHROWER
	; end
