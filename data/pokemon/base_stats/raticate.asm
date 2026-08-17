	db 0 ; species ID placeholder

	db  55,  97,  70, 113,  45,  70
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 130 ; catch rate
	db 145 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 15 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/raticate/front.dimensions"
	abilities_for RATICATE, HUSTLE, GUTS, TECHNICIAN
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, BLIZZARD, HYPER_BEAM, PROTECT, FACADE, IRON_HEAD, THUNDER, RETURN, DIG, SHADOW_BALL, MUD_SLAP, SWAGGER, SWIFT, REST, ATTRACT, THIEF, ZEN_HEADBUTT, CUT, STRENGTH, THUNDERBOLT, ICE_BEAM
	; end
