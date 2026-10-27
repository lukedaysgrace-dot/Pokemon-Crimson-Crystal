BattleCommand_Mimic:
; mimic
; Gen 1 (Red/Blue) Mimic:
; - The player picks any one of the target's moves from a menu.
;   The AI (and both sides of a link battle, to stay in sync) copies a
;   random one of the target's moves instead.
; - The copied move replaces Mimic until the battle ends or the user
;   switches out, and it uses up Mimic's own PP (no fresh 5 PP).
; - Mimic never misses: its effect script has no checkhit, and it ignores
;   Fly/Dig-style semi-invulnerability.

	call ClearLastMove
	call BattleCommand_MoveDelay

; hl = start of the user's battle moveset, c = slot the user selected
	ld hl, wBattleMonMoves
	ld a, [wCurMoveNum]
	ld c, a
	ldh a, [hBattleTurn]
	and a
	jr z, .got_user_moves
	ld hl, wEnemyMonMoves
	ld a, [wCurEnemyMoveNum]
	ld c, a
.got_user_moves
	push hl
	ld hl, MIMIC
	call GetMoveIDFromIndex
	pop hl
	ld b, a

; Prefer the slot that was actually used (like Gen 1). Fall back to the
; first Mimic slot if that slot does not hold Mimic.
	ld a, c
	cp NUM_MOVES
	jr nc, .search_mimic
	push hl
	ld e, c
	ld d, 0
	add hl, de
	ld a, [hl]
	cp b
	jr nz, .not_cur_slot
	pop de ; discard start of moveset
	jr .found_mimic
.not_cur_slot
	pop hl
.search_mimic
	ld c, NUM_MOVES
.find_mimic
	ld a, [hli]
	cp b
	jr z, .found_mimic_inc
	dec c
	jr nz, .find_mimic
	jp FailMimic ; the user doesn't know Mimic
.found_mimic_inc
	dec hl
.found_mimic
; hl = Mimic slot in the user's battle moveset
	push hl
	call .ChooseMove ; a = move ID to copy
	pop hl
	and a
	jp z, FailMimic
	ld b, a
; Never copy Struggle, and never copy Sketch: Sketch rewrites the permanent
; party slot it occupies, which here would permanently overwrite Mimic.
	push bc
	ld bc, STRUGGLE
	call CompareMove
	pop bc
	jp z, FailMimic
	ld a, b
	push bc
	ld bc, SKETCH
	call CompareMove
	pop bc
	jp z, FailMimic

	ld a, b
	ld [hl], a
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName
	call AnimateCurrentMove
	ld hl, LearnedMoveText
	jp StdBattleTextbox

.ChooseMove:
; Return the move ID to copy in a.
	ldh a, [hBattleTurn]
	and a
	jr nz, .random_from_player
	ld a, [wLinkMode]
	and a
	jr nz, .random_from_enemy
IF DEF(DEBUG_BATTLE)
; Battle tester auto mode has no one to press buttons: copy the foe's
; first move instead of opening the menu.
	ldh a, [hDebugActive]
	and a
	jr z, .no_debug_auto
	ld a, [wEnemyMonMoves]
	ret
.no_debug_auto
ENDC

; Player: pick one of the foe's moves from the move menu.
	call LoadTileMapToTempTileMap
	ld a, 1 ; enemy moves menu
	ld [wMoveSelectionMenuType], a
	farcall MoveSelectionScreen
	xor a
	ld [wMoveSelectionMenuType], a
	call Call_LoadTempTileMapToTileMap
	call SetPlayerTurn
	ld a, [wMenuCursorY]
	cp NUM_MOVES
	jr c, .menu_slot_ok
	xor a
.menu_slot_ok
	ld c, a
	ld b, 0
	ld hl, wEnemyMonMoves
	add hl, bc
	ld a, [hl]
	ret

.random_from_enemy
	ld hl, wEnemyMonMoves
	jr .random

.random_from_player
	ld hl, wBattleMonMoves
.random
; The target always knows at least one move.
	call BattleRandom
	and NUM_MOVES - 1
	ld c, a
	ld b, 0
	push hl
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, .random
	ret
