INCLUDE "engine/16/macros.asm"

ForceGarbageCollection::
	push bc
	ldh a, [rSVBK]
	push af
	ld a, BANK("16-bit WRAM tables")
	ldh [rSVBK], a
	call PokemonTableGarbageCollection
	call MoveTableGarbageCollection
	call ItemTableGarbageCollection
	pop af
	ldh [rSVBK], a
	pop bc
	ret

; Note: ID = 8-bit ID used in memory, etc.; index = true 16-bit index into tables

_GetPokemonIndexFromID::
	___conversion_table_load wPokemonIndexTable, MON_TABLE

_GetPokemonIDFromIndex::
	___conversion_table_store wPokemonIndexTable, MON_TABLE
	; fallthrough - as required by the macro
PokemonTableGarbageCollection:
	; must preserve de and rSVBK
	push de
	ldh a, [rSVBK]
	push af
	___conversion_bitmap_initialize wPokemonIndexTable, MON_TABLE, .set_bit
	ld a, 1
	ldh [rSVBK], a
	___conversion_bitmap_check_structs wPartyMons, PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
	___conversion_bitmap_check_structs wBreedMon1, wBreedMon2 - wBreedMon1, 2, .set_bit
	ld a, [wEggMonSpecies]
	call .set_bit
	; may or may not be valid, but marking them in use is free
	___conversion_bitmap_check_structs wOTPartyMons, PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
	___conversion_bitmap_check_structs wRoamMon1, wRoamMon2 - wRoamMon1, 3, .set_bit
	___conversion_bitmap_check_structs wBugContestFirstPlaceMon, wBugContestSecondPlaceMon - wBugContestFirstPlaceMon, 3, .set_bit
	___conversion_bitmap_check_values .set_bit, wBufferMonSpecies, wTempMonSpecies, wContestMonSpecies, \
	                                            wBattleMonSpecies, wEnemyMonSpecies, wOddEggSpecies, wBaseSpecies
IF DEF(DEBUG_BATTLE)
	; the battle tester parks the real party in WRAM bank 2 while a test
	; party is out; its IDs must survive collections during the test
	ld a, BANK(wDebugPartyBackedUp)
	ldh [rSVBK], a
	ld a, [wDebugPartyBackedUp]
	and a
	jr z, .no_debug_backup
	___conversion_bitmap_check_structs wDebugPartyBackup + (wPartyMons - wPartyCount), PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
.no_debug_backup
	ld a, 1
	ldh [rSVBK], a
ENDC
	pop af
	ldh [rSVBK], a
	; Stored (boxed) mons keep true 16-bit indexes in SRAM and are not roots.
	___conversion_bitmap_free_unused wPokemonIndexTable, MON_TABLE
	pop de
	ret

.set_bit
	___conversion_bitmap_set MON_TABLE

_LockPokemonID::
	___conversion_table_lock_ID wPokemonIndexTable, MON_TABLE

_GetMoveIndexFromID::
	___conversion_table_load wMoveIndexTable, MOVE_TABLE

_GetMoveIDFromIndex::
	___conversion_table_store wMoveIndexTable, MOVE_TABLE
	; fallthrough
MoveTableGarbageCollection:
	; must preserve de and rSVBK
	push de
	ldh a, [rSVBK]
	push af
	; clear the bitmap and mark the locked and recently allocated IDs, like
	; the Pokemon collector does (otherwise stale marks leak slots forever and
	; locked move IDs can be freed and reused)
	___conversion_bitmap_initialize wMoveIndexTable, MOVE_TABLE, .set_bit
	ld a, 1
	ldh [rSVBK], a
___move = 0
	rept NUM_MOVES
		___conversion_bitmap_check_structs wPartyMon1Moves + ___move, PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
		___conversion_bitmap_check_structs wBreedMon1Moves + ___move, wBreedMon2 - wBreedMon1, 2, .set_bit
		ld a, [wEggMonMoves + ___move]
		call .set_bit
		; may or may not be valid
		___conversion_bitmap_check_structs wOTPartyMon1Moves + ___move, PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
		___conversion_bitmap_check_values .set_bit, wBufferMonMoves + ___move, wTempMonMoves + ___move, wContestMonMoves + ___move, \
		                                            wBattleMonMoves + ___move, wEnemyMonMoves + ___move, wWildMonMoves + ___move, \
		                                            wPlayerUsedMoves + ___move, wOddEggMoves + ___move
___move = ___move + 1
	endr
	ld a, [wNamedObjectIndexBuffer] ;or any of its aliases...
	call .set_bit
	; only valid sometimes
	___conversion_bitmap_check_values .set_bit, wCurPlayerMove, wCurEnemyMove, wDisabledMove, wEnemyDisabledMove, wPlayerChoiceLockedMove, \
	                                            wEnemyChoiceLockedMove, wLastPlayerMove, wLastEnemyMove, wLastPlayerCounterMove, wLastEnemyCounterMove, \
	                                            wPlayerTrappingMove, wEnemyTrappingMove, wPlayerMoveStructAnimation, wEnemyMoveStructAnimation, \
	                                            wPutativeTMHMMove, wPlayerGigaHammerLock, wEnemyGigaHammerLock
IF DEF(DEBUG_BATTLE)
	ld a, BANK(wDebugPartyBackedUp)
	ldh [rSVBK], a
	ld a, [wDebugPartyBackedUp]
	and a
	jp z, .no_debug_backup
___move = 0
	rept NUM_MOVES
		___conversion_bitmap_check_structs wDebugPartyBackup + (wPartyMon1Moves - wPartyCount) + ___move, PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
___move = ___move + 1
	endr
.no_debug_backup
	ld a, 1
	ldh [rSVBK], a
ENDC
	pop af
	ldh [rSVBK], a
	; Stored (boxed) mons keep true 14-bit move indexes in SRAM and are not roots.
	___conversion_bitmap_free_unused wMoveIndexTable, MOVE_TABLE
	pop de
	ret

.set_bit
	___conversion_bitmap_set MOVE_TABLE

_LockMoveID::
	___conversion_table_lock_ID wMoveIndexTable, MOVE_TABLE

NormalizeRetiredBerryIndex::
; Old expansion saves may contain the seven removed status Berries. Resolve
; those reserved indices to their original equivalents, preserving bc/de.
	ld a, h
	cp $01
	ret nz
	ld a, l
	sub $11
	ret c
	cp 7
	ret nc
	push de
	ld e, a
	ld d, 0
	ld hl, .originals
	add hl, de
	ld l, [hl]
	ld h, 0
	pop de
	ret
.originals
	db PSNCUREBERRY, ICE_BERRY, BURNT_BERRY, MINT_BERRY
	db PRZCUREBERRY, BITTER_BERRY, MIRACLEBERRY

_GetItemIndexFromID::
	call .raw
	jp NormalizeRetiredBerryIndex
.raw
	___conversion_table_load wItemIndexTable, ITEM_TABLE

_GetItemIDFromIndex::
	call NormalizeRetiredBerryIndex
	___conversion_table_store wItemIndexTable, ITEM_TABLE
	; Fall through directly to collection, as required by the store macro.
ItemTableGarbageCollection:
	push de
	ldh a, [rSVBK]
	push af
	___conversion_bitmap_initialize wItemIndexTable, ITEM_TABLE, .set_bit
	ld a, 1
.fixed
	push af
	call .set_bit
	pop af
	inc a
	cp ITEM_FIXED_RUNTIME_IDS + 1
	jr c, .fixed
	ld a, 1
	ldh [rSVBK], a
	___conversion_bitmap_check_structs wPartyMon1Item, PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
	___conversion_bitmap_check_structs wOTPartyMon1Item, PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
	___conversion_bitmap_check_structs wBreedMon1Item, wBreedMon2 - wBreedMon1, 2, .set_bit
	___conversion_bitmap_check_values .set_bit, wCurItem, wNamedObjectIndexBuffer, wMenuSelection, wPackUsedItem, wTempMonItem, wBufferMonItem, wBattleMonItem, wEnemyMonItem, wContestMonItem, wCurEnemyItem, wEnemyTrainerItem1, wEnemyTrainerItem2, wScriptVar, wMartItemID, wBillsPC_CursorItem
	; All bag/PC entries and boxed items contain true indices, not roots.
	; Mart menus alone retain an array of runtime IDs.
	___conversion_bitmap_check_structs wCurMart + 1, 1, 14, .set_bit
IF DEF(DEBUG_BATTLE)
	ld a, BANK(wDebugPartyBackedUp)
	ldh [rSVBK], a
	ld a, [wDebugPartyBackedUp]
	and a
	jr z, .no_debug_backup
	___conversion_bitmap_check_structs wDebugPartyBackup + (wPartyMon1Item - wPartyCount), PARTYMON_STRUCT_LENGTH, PARTY_LENGTH, .set_bit
.no_debug_backup
ENDC
	ld a, BANK(wItemIndexTable)
	ldh [rSVBK], a
	___conversion_bitmap_free_unused wItemIndexTable, ITEM_TABLE
	pop af
	ldh [rSVBK], a
	pop de
	ret
.set_bit
	___conversion_bitmap_set ITEM_TABLE

InitializeItemIndexTable::
	ldh a, [rSVBK]
	push af
	ld a, BANK(wItemIndexTable)
	ldh [rSVBK], a
	ld hl, wItemIndexTable
	ld bc, wItemIndexTableEnd - wItemIndexTable
	xor a
	call ByteFill
	ld hl, wItemIndexTableEntries
	ld b, 1
.loop
	ld [hl], b
	inc hl
	ld [hl], 0
	inc hl
	inc b
	ld a, b
	cp ITEM_TABLE_ENTRIES + 1
	jr c, .loop
	ld hl, wItemIndexTableEntries + 2 * (0 + ITEM_FIXED_MAIL_RUNTIME - 1)
	ld [hl], LOW(SURF_MAIL)
	inc hl
	ld [hl], HIGH(SURF_MAIL)
	ld hl, wItemIndexTableEntries + 2 * (1 + ITEM_FIXED_MAIL_RUNTIME - 1)
	ld [hl], LOW(LITEBLUEMAIL)
	inc hl
	ld [hl], HIGH(LITEBLUEMAIL)
	ld hl, wItemIndexTableEntries + 2 * (2 + ITEM_FIXED_MAIL_RUNTIME - 1)
	ld [hl], LOW(PORTRAITMAIL)
	inc hl
	ld [hl], HIGH(PORTRAITMAIL)
	ld hl, wItemIndexTableEntries + 2 * (3 + ITEM_FIXED_MAIL_RUNTIME - 1)
	ld [hl], LOW(LOVELY_MAIL)
	inc hl
	ld [hl], HIGH(LOVELY_MAIL)
	ld hl, wItemIndexTableEntries + 2 * (4 + ITEM_FIXED_MAIL_RUNTIME - 1)
	ld [hl], LOW(MORPH_MAIL)
	inc hl
	ld [hl], HIGH(MORPH_MAIL)
	ld hl, wItemIndexTableEntries + 2 * (5 + ITEM_FIXED_MAIL_RUNTIME - 1)
	ld [hl], LOW(BLUESKY_MAIL)
	inc hl
	ld [hl], HIGH(BLUESKY_MAIL)
	ld hl, wItemIndexTableEntries + 2 * (6 + ITEM_FIXED_MAIL_RUNTIME - 1)
	ld [hl], LOW(MUSIC_MAIL)
	inc hl
	ld [hl], HIGH(MUSIC_MAIL)
	ld hl, wItemIndexTableEntries + 2 * (7 + ITEM_FIXED_MAIL_RUNTIME - 1)
	ld [hl], LOW(MIRAGE_MAIL)
	inc hl
	ld [hl], HIGH(MIRAGE_MAIL)
	ld a, ITEM_TABLE_ENTRIES
	ld [wItemIndexTableUsedSlots], a
	pop af
	ldh [rSVBK], a
	ret
