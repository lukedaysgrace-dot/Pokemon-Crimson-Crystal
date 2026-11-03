	db 0 ; species ID placeholder

	db  48,  48,  48,  48,  48,  48
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 35 ; catch rate
	db 101 ; base exp
	db METAL_POWDER, LOW(QUICK_POWDER) ; items: common 20%, rare 5%
	db GENDER_UNKNOWN ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/ditto/front.dimensions"
	abilities_for DITTO, IMPOSTER, NO_ABILITY, NO_ABILITY
	db HIGH(QUICK_POWDER) << 1 ; padding: held-item high bits (slot 2)
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_DITTO, EGG_DITTO ; egg groups

	; tm/hm learnset
	tmhm
	; end
