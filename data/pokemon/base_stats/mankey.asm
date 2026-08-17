	db 0 ; species ID placeholder

	db  40,  80,  35,  80,  35,  35
	;   hp  atk  def  spd  sat  sdf

	db FIGHTING, FIGHTING ; type
	db 190 ; catch rate
	db 61 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/mankey/front.dimensions"
	abilities_for MANKEY, VITAL_SPIRIT, ANGER_POINT, DEFIANT
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm DRAIN_PUNCH, HEADBUTT, CURSE, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, WORK_UP, PROTECT, FACADE, IRON_HEAD, THUNDER, RETURN, DIG, MUD_SLAP, SWAGGER, ICE_PUNCH, SWIFT, BULK_UP, THUNDERPUNCH, REST, ATTRACT, THIEF, FIRE_PUNCH, HONE_CLAWS, NIGHT_SLASH, STRENGTH, THUNDERBOLT
	; end
