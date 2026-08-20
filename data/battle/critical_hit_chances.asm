CriticalHitChances:
; Modern (Gen 7+) critical hit rates.
; Roll is `BattleRandom < value` => probability = value/256.
; Stage 3+ uses $ff = 255/256, not a true guarantee: the `cp [hl] / ret nc`
; comparison cannot express "always". The 1/256 miss is accepted on purpose
; to keep this a pure data change (see BATTLE_MATH results doc, BM2).
	db  11 ;  0  ; ~1/24
	db  32 ; +1  ; 1/8
	db 128 ; +2  ; 1/2
	db 255 ; +3  ; always (255/256, see note)
	db 255 ; +4
	db 255 ; +5
	db 255 ; +6
