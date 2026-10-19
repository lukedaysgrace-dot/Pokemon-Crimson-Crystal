; Version 3 saved 496 species (62 bytes in each Dex bitfield). Version 4
; inserts one zero byte into each bitfield. SRAM padding keeps the outer
; checksum/validation bytes and every later save section at their old address.
; Check both the old data checksum and move-table checksum before expanding.
; Only the in-game save is upgraded; species and move indexes do not change.

assert (NUM_POKEMON + 7) / 8 == 63

upgrade_pokedex_copy: MACRO
	ld a, BANK(\1CheckValue1)
	call GetSRAMBank
	ld a, [\1CheckValue1]
	cp SAVE_CHECK_VALUE_1
	jp nz, .invalid\@
	ld a, [\1CheckValue2]
	cp SAVE_CHECK_VALUE_2
	jp nz, .invalid\@
	ld hl, \1SaveData
	ld bc, \1SaveDataEnd - \1SaveData - 2
	call Checksum
	ld a, [\1Checksum]
	cp e
	jp nz, .invalid\@
	ld a, [\1Checksum + 1]
	cp d
	jp nz, .invalid\@

	ld hl, \1ConversionTableChecksum - 2
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, BANK(\1MoveIndexTable)
	call GetSRAMBank
	ld hl, \1MoveIndexTable
	ld bc, wMoveIndexTableEnd - wMoveIndexTable
	call Checksum
	pop hl
	ld a, BANK(\1SaveData)
	call GetSRAMBank
	ld a, d
	cp h
	jp nz, .invalid\@
	ld a, e
	cp l
	jp nz, .invalid\@

	; First move the Unown/Day-Care/roamer data and index/checksum tables.
	ld hl, \1SaveDataEnd - 3
	ld de, \1SaveDataEnd - 1
	ld bc, \1SaveDataEnd - (\1PokemonData + wUnownDex - wPokemonData)
	call UpgradePokedexSave_MoveBack
	; Then move the 62 legacy seen bytes over the new caught-flags byte.
	ld hl, \1PokemonData + wEndPokedexSeen - wPokemonData - 3
	ld de, \1PokemonData + wEndPokedexSeen - wPokemonData - 2
	ld bc, 62
	call UpgradePokedexSave_MoveBack
	xor a
	ld [\1PokemonData + wEndPokedexCaught - wPokemonData - 1], a
	ld [\1PokemonData + wEndPokedexSeen - wPokemonData - 1], a
	; Inserting zeros preserves the additive checksums exactly.
	jr .done\@
.invalid\@
	xor a
	ld [\1CheckValue1], a
.done\@
ENDM

UpgradePokedexSave:
	ld a, BANK(sSaveVersion)
	call GetSRAMBank
	ld a, [sSaveVersion]
	cp 3
	jp nz, CloseSRAM
	upgrade_pokedex_copy s
	upgrade_pokedex_copy sBackup
	ld a, BANK(sSaveVersion)
	call GetSRAMBank
	ld a, SAVE_FORMAT_VERSION
	ld [sSaveVersion], a
	jp CloseSRAM

UpgradePokedexSave_MoveBack:
	ld a, [hld]
	ld [de], a
	dec de
	dec bc
	ld a, b
	or c
	jr nz, UpgradePokedexSave_MoveBack
	ret
