	db 0 ; species ID placeholder

	db  48,  44,  40,  77,  76,  40
	;   hp  atk  def  spd  sat  sdf

	db POISON, FIRE ; type
	db 120 ; catch rate
	db 64 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F12_5 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/salandit/front.dimensions"
	abilities_for SALANDIT, CORROSION, POISON_PUPPETEER, MERCILESS
	db 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, DRAGON_PULSE, HIDDEN_POWER, SUNNY_DAY, PROTECT, WILL_O_WISP, FACADE, DRAGON_CLAW, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, KNOCK_OFF, SLUDGE_BOMB, FIRE_BLAST, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, FLAMETHROWER
	; end
