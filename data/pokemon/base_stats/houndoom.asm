	db 0 ; species ID placeholder

	db  75, 100,  50,  95, 110,  80
	;   hp  atk  def  spd  sat  sdf

	db DARK, FIRE ; type
	db 45 ; catch rate
	db 175 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/houndoom/front.dimensions"
	abilities_for HOUNDOOM, INTIMIDATE, FLASH_FIRE, ADAPTABILITY
	db 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm HEADBUTT, CURSE, ROAR, TOXIC, ROCK_SMASH, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, PROTECT, WILL_O_WISP, FACADE, SOLARBEAM, IRON_HEAD, RETURN, SHADOW_BALL, MUD_SLAP, SWAGGER, SLUDGE_BOMB, FIRE_BLAST, SWIFT, NASTY_PLOT, REST, ATTRACT, THIEF, STRENGTH, FLAMETHROWER
	; end
