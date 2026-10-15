INCLUDE "constants.asm"


SECTION "Egg Move Pointers", ROMX

; Either non-Ditto parent may pass these moves to the hatchling. Shared
; level-up moves are inherited separately; TM/HM compatibility is not inherited.
; Keep project egg lists (including regional/clone forms). The roster-aware
; audit in tools/audit_breeding_moves.py proves donor chains without the egg
; tutor, and preserves level-up fallbacks where breeding cannot supply a move.

EggMovePointers::
	indirect_table 2, 1
	indirect_entries MEW, EggMovePointers1
	indirect_entries NUM_POKEMON, EggMovePointers2
	indirect_table_end

INCLUDE "data/pokemon/egg_moves_kanto.asm"
INCLUDE "data/pokemon/egg_moves_johto.asm"
