; Upgrade v3/v4 saves in place after validating both the data checksum and
; move table. The upgraded data and conversion tables get fresh checksums.
; Outer validation/checksum bytes, box records and metadata never move.

upgrade_item_copy: MACRO
	ld a, BANK(\1SaveData)
	call GetSRAMBank
	ld a, [\1CheckValue1]
	cp SAVE_CHECK_VALUE_1
	jp nz, .done\@
	ld a, [\1CheckValue2]
	cp SAVE_CHECK_VALUE_2
	jp nz, .invalid\@
	; A completed copy can survive interruption before the version advances.
	ld a, BANK(\1ItemIndexMagic)
	call GetSRAMBank
	ld a, [\1ItemIndexMagic]
	cp $49
	jr nz, .legacy\@
	ld a, [\1ItemIndexMagic + 1]
	cp $16
	jr nz, .legacy\@
	ld a, BANK(\1SaveData)
	call GetSRAMBank
	ld hl, \1SaveData
	ld bc, \1SaveDataEnd - \1SaveData
	call ItemUpgradeChecksum
	ld a, [\1Checksum]
	cp e
	jr nz, .legacy\@
	ld a, [\1Checksum + 1]
	cp d
	jp z, .done\@
.legacy\@
	ld a, BANK(\1SaveData)
	call GetSRAMBank
	ld hl, LEGACY_\1SaveData
	ld bc, LEGACY_\1SaveDataEnd - LEGACY_\1SaveData
	call ItemUpgradeChecksum
	ld a, [\1Checksum]
	cp e
	jp nz, .invalid\@
	ld a, [\1Checksum + 1]
	cp d
	jp nz, .invalid\@
	ld hl, LEGACY_\1ConversionTableChecksum
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, BANK(\1MoveIndexTable)
	call GetSRAMBank
	ld hl, \1MoveIndexTable
	ld bc, wMoveIndexTableEnd - wMoveIndexTable
	call ItemUpgradeChecksum
	pop hl
	ld a, d
	cp h
	jp nz, .invalid\@
	ld a, e
	cp l
	jp nz, .invalid\@
	ld a, BANK(\1SaveData)
	call GetSRAMBank

	; A reset must never make partially expanded data look like a legacy copy
	; with a valid checksum. Restore this signature only after all tables and
	; checksums are committed; the other copy remains available for fallback.
	xor a
	ld [\1CheckValue1], a

	; Copy the meaningful suffix blocks back-to-front over reclaimed padding.
	ld hl, LEGACY_\1PlayerData + LEGACY_wFishingContestRoster - LEGACY_wPlayerData + NUM_FISHING_CONTESTANTS - 1
	ld de, \1PlayerData + wFishingContestRoster - wPlayerData + NUM_FISHING_CONTESTANTS - 1
	ld bc, LEGACY_wFishingContestRoster + NUM_FISHING_CONTESTANTS - LEGACY_wJackFightCount
	call MoveItemSaveBack
	ld hl, LEGACY_\1PlayerData + LEGACY_wOlivineFishingCoveGateSceneID - LEGACY_wPlayerData
	ld de, \1PlayerData + wOlivineFishingCoveGateSceneID - wPlayerData
	ld bc, LEGACY_wOlivineFishingCoveGateSceneID - LEGACY_wPokecenter2FSceneID + 1
	call MoveItemSaveBack
	ld hl, LEGACY_\1PlayerData + LEGACY_wFinizenPosition - LEGACY_wPlayerData
	ld de, \1PlayerData + wFinizenPosition - wPlayerData
	ld bc, LEGACY_wFinizenPosition - LEGACY_wPokegearFlags + 1
	call MoveItemSaveBack
	; Expand every allocated PC slot backwards, including unused slots.
	ld hl, LEGACY_\1PlayerData + LEGACY_wPCItems - LEGACY_wPlayerData + MAX_PC_ITEMS * 2
	ld de, \1PlayerData + wPCItems - wPlayerData + MAX_PC_ITEMS * 3 - MAX_ITEMS
	ld a, [hld]
	ld [de], a
	dec de
	ld b, MAX_PC_ITEMS
	call ExpandLegacyItemRows
	; Shift the block between the two lists, including the expanded PC list.
	ld hl, LEGACY_\1PlayerData + LEGACY_wPCItems - LEGACY_wPlayerData + MAX_PC_ITEMS * 3
	ld de, \1PlayerData + wPCItems - wPlayerData + MAX_PC_ITEMS * 3
	ld bc, (LEGACY_wPCItems - LEGACY_wItems) + MAX_PC_ITEMS * 3 + 1 - (MAX_ITEMS * 2 + 1)
	call MoveItemSaveBack
	ld hl, LEGACY_\1PlayerData + LEGACY_wItems - LEGACY_wPlayerData + MAX_ITEMS * 2
	ld de, \1PlayerData + wItems - wPlayerData + MAX_ITEMS * 3
	ld a, [hld]
	ld [de], a
	dec de
	ld b, MAX_ITEMS
	call ExpandLegacyItemRows

	; Old party/daycare held bytes are legacy indices. In particular, TMs
	; $c2-$c9 must not become the newly reserved Mail runtime tags.
	ld hl, \1PokemonData + wPartyMon1Item - wPokemonData
	ld de, PARTYMON_STRUCT_LENGTH
	ld b, PARTY_LENGTH
	call UpgradeLegacyHeldItemIDs
	jp c, .invalid\@
	ld hl, \1PokemonData + wBreedMon1Item - wPokemonData
	ld de, wBreedMon2 - wBreedMon1
	ld b, 2
	call UpgradeLegacyHeldItemIDs
	jp c, .invalid\@

	ld hl, \1SaveData
	ld bc, \1SaveDataEnd - \1SaveData
	call ItemUpgradeChecksum
	ld a, e
	ld [\1Checksum], a
	ld a, d
	ld [\1Checksum + 1], a
	; Copy the identity item table and checksum it before setting the marker.
	ld a, BANK(\1ItemIndexTable)
	call GetSRAMBank
	ld hl, wItemIndexTable
	ld de, \1ItemIndexTable
	ld bc, wItemIndexTableEnd - wItemIndexTable
	call CopyBytes
	ld hl, \1ItemIndexTable
	ld bc, wItemIndexTableEnd - wItemIndexTable
	call ItemUpgradeChecksum
	ld a, e
	ld [\1ItemIndexChecksum], a
	ld a, d
	ld [\1ItemIndexChecksum + 1], a
	ld a, $49
	ld [\1ItemIndexMagic], a
	ld a, $16
	ld [\1ItemIndexMagic + 1], a
	ld a, BANK(\1SaveData)
	call GetSRAMBank
	ld a, SAVE_CHECK_VALUE_1
	ld [\1CheckValue1], a
	jr .done\@
.invalid\@
	ld a, BANK(\1CheckValue1)
	call GetSRAMBank
	xor a
	ld [\1CheckValue1], a
.done\@
ENDM

UpgradeItemSave::
	farcall UpgradePokedexSave
	ld a, BANK(sSaveVersion)
	call GetSRAMBank
	ld a, [sSaveVersion]
	cp 4
	jp nz, CloseSRAM
	ldh a, [rSVBK]
	push af
	farcall InitializeItemIndexTable
	ld a, BANK(wItemIndexTable)
	ldh [rSVBK], a
	; Existing boxed items are legacy byte indices.
	ld a, BANK(sPokeDBItemHigh)
	call GetSRAMBank
	ld hl, sPokeDBItemHigh
	ld bc, 2 * MONDB_ENTRIES
	xor a
	call ByteFill
	upgrade_item_copy s
	upgrade_item_copy sBackup
	pop af
	ldh [rSVBK], a
	ld a, BANK(sSaveVersion)
	call GetSRAMBank
	ld a, SAVE_FORMAT_VERSION
	ld [sSaveVersion], a
	jp CloseSRAM

MoveItemSaveBack:
	ld a, b
	or c
	ret z
.loop
	ld a, [hld]
	ld [de], a
	dec de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

ExpandLegacyItemRows:
; hl points at the last old quantity; de at its new destination. All list
; capacity is expanded, so a terminator in an unused slot is also preserved.
.loop
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	; A byte terminator must become $ff in the high byte too. Extra unused
	; terminators are harmless; active row counts remain authoritative.
	cp $ff
	ld a, 0
	jr nz, .high
	dec a
.high
	ld [de], a
	dec de
	dec b
	jr nz, .loop
	ret

UpgradeLegacyHeldItemIDs:
; hl = first held byte, de = stride, b = count. SRAM remains in the save
; copy's bank. All allocated IDs are saved with this copy's conversion table.
.loop
	ld a, [hl]
	and a
	jr z, .next
	cp $ff
	jr nz, .convert
	xor a ; unused/invalid legacy held-item placeholder
	ld [hl], a
	jr .next
.convert
	push bc
	push de
	push hl
	ld l, a
	ld h, 0
	call GetItemIDFromIndex
	pop hl
	pop de
	pop bc
	and a
	jr z, .failed
	ld [hl], a
.next
	add hl, de
	dec b
	jr nz, .loop
	and a
	ret
.failed
	scf
	ret

ItemUpgradeChecksum:
; Local bank copy: farcall uses hl for its target, but this API takes hl as
; the start of the data. Keep the checksum input pointer intact.
	ld de, 0
.loop
	ld a, [hli]
	add e
	ld e, a
	ld a, 0
	adc d
	ld d, a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret
