	db 0 ; species ID placeholder

	db  60,  50,  70, 150,  80,  80
	;  hp  atk  def  spd  sat  sdf

	db ELECTRIC, GRASS ; type
	db 60 ; catch rate
	db 150 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_UNKNOWN ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/electrode_hisuian/front.dimensions"
	abilities_for ELECTRODE_HISUIAN, SOUNDPROOF, STATIC, AFTERMATH
	db 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_MINERAL, EGG_MINERAL ; egg groups

	; tm/hm learnset
	tmhm CURSE, TOXIC, HIDDEN_POWER, HYPER_BEAM, PROTECT, RAIN_DANCE, GIGA_DRAIN, SOLARBEAM, THUNDERBOLT, THUNDER, RETURN, DOUBLE_TEAM, SWIFT, REST, THIEF, FLASH, ENDURE, HEADBUTT, ROLLOUT, SLEEP_TALK, SWAGGER, ZAP_CANNON
	; end
