	db 0 ; species ID placeholder

	db  75, 115,  60,  80,  80,  60
	;   hp  atk  def  spd  sat  sdf

	db POISON, POISON ; type
	db 90 ; catch rate
	db 160 ; base exp
	db NO_ITEM, POISON_BARB ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/seviper/front.dimensions"
	abilities_for SEVIPER, SHED_SKIN, NO_ABILITY, MERCILESS
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_DRAGON ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, SNORE, PROTECT, ENDURE, FRUSTRATION, RETURN, DIG, MUD_SLAP, DOUBLE_TEAM, SLUDGE_BOMB, SWAGGER, SLEEP_TALK, REST, ATTRACT, THIEF, FURY_CUTTER, STRENGTH
	; end
