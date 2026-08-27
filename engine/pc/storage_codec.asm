; savemon_struct <-> wTempMon codec. Records are read from / written to SRAM
; directly (hl = record address, bank already open); no WRAM staging buffer.
; Layout: docs/pc_storage_design.md §1.

encode_move: MACRO
; \1 = move number 0-3. hl = record base (preserved).
	push hl
	ld a, [wTempMonMoves + \1]
	call GetMoveIndexFromID ; hl = true index
	ld a, [wTempMonPP + \1]
	and $c0 ; PP Ups
	ld d, a
	ld a, h
	and $3f
	or d
	ld d, a ; d = packed high byte
	ld e, l ; e = low byte
	pop hl
	push hl
	ld bc, SAVEMON_MOVES + \1
	add hl, bc
	ld [hl], e
	ld bc, SAVEMON_MOVES_HI - SAVEMON_MOVES
	add hl, bc
	ld [hl], d
	pop hl
ENDM

decode_move: MACRO
; \1 = move number 0-3. hl = record base (preserved).
	push hl
	ld bc, SAVEMON_MOVES + \1
	add hl, bc
	ld e, [hl]
	ld bc, SAVEMON_MOVES_HI - SAVEMON_MOVES
	add hl, bc
	ld a, [hl]
	and $c0
	ld [wTempMonPP + \1], a ; PP Ups; current PP is restored afterwards
	ld a, [hl]
	and $3f
	cp $3f
	jr nz, .hi_ok\@
	ld a, $ff ; reserved index range ($ffxx) is stored as $3f
.hi_ok\@
	ld h, a
	ld l, e
	call GetMoveIDFromIndex ; a = runtime ID
	ld [wTempMonMoves + \1], a
	pop hl
ENDM

EncodeSavedMon::
; Writes wTempMon (+extension) as a savemon_struct at hl (SRAM bank open).
; Clobbers everything. Closes SRAM. wTempMon is not modified.
	push hl
	ld a, [wTempMonSpecies]
	call GetPokemonIndexFromID
	ld d, h
	ld e, l
	pop hl
	push hl
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld a, [wTempMonItem]
	ld [hl], a
	pop hl

	encode_move 0
	encode_move 1
	encode_move 2
	encode_move 3

	; ID, Exp, Stat Exp, DVs: contiguous in both layouts
	push hl
	ld de, SAVEMON_ID
	add hl, de
	ld d, h
	ld e, l
	ld hl, wTempMonID
	ld bc, SAVEMON_DVS + 2 - SAVEMON_ID
	call CopyBytes
	pop hl

	push hl
	ld de, SAVEMON_HAPPINESS
	add hl, de
	ld a, [wTempMonHappiness]
	ld [hli], a
	ld a, [wTempMonPokerusStatus]
	and $3f
	ld d, a
	ld a, [wTempMonUnused]
	and MON_SHINY_FLAG | MON_MALE_FLAG
	or d
	ld [hli], a
	ld a, [wTempMonCaughtLevel]
	ld [hli], a
	ld a, [wTempMonCaughtLocation]
	ld [hli], a
	ld a, [wTempMonLevel]
	ld [hli], a
	ld a, [wTempMonPersonality]
	ld [hli], a
	ld a, [wTempMonIsEgg]
	and a
	ld a, 0
	jr z, .not_egg
	ld a, 1 << SAVEMON_IS_EGG_F
.not_egg
	ld [hl], a
	pop hl

	push hl
	ld de, SAVEMON_NICKNAME
	add hl, de
	ld d, h
	ld e, l
	ld hl, wTempMonNickname
	call .CopyNamePadded
	ld hl, wTempMonOT
	call .CopyNamePadded
	pop hl

	push hl
	call ComputeSavedMonChecksum ; de
	pop hl
	push hl
	ld bc, SAVEMON_CHECKSUM
	add hl, bc
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	jp CloseSRAM

.CopyNamePadded:
; Copies up to SAVEMON_NAME_LENGTH characters from hl to de, replacing the
; terminator and everything after it with "@" so records are deterministic.
	ld c, SAVEMON_NAME_LENGTH
.copy_loop
	ld a, [hli]
	cp "@"
	jr z, .pad
	ld [de], a
	inc de
	dec c
	jr nz, .copy_loop
	ret
.pad
	ld a, "@"
.pad_loop
	ld [de], a
	inc de
	dec c
	jr nz, .pad_loop
	ret

ComputeSavedMonChecksum::
; hl = record. Returns the checksum in de. Preserves hl. Clobbers a, bc.
; de = $7f + sum over the first SAVEMON_CHECKSUM bytes of byte[i] * (n - i).
	push hl
	ld a, SAVEMON_CHECKSUM
	ldh [hTemp], a
	ld bc, 0
	ld de, $7f
.loop
	ld a, [hli]
	add c
	ld c, a
	ld a, 0
	adc b
	ld b, a ; running sum
	ld a, e
	add c
	ld e, a
	ld a, d
	adc b
	ld d, a ; weighted sum
	ldh a, [hTemp]
	dec a
	ldh [hTemp], a
	jr nz, .loop
	pop hl
	ret

VerifySavedMonChecksum::
; hl = record. Returns carry if the stored checksum does not match.
; Preserves hl. Clobbers a, bc, de.
	call ComputeSavedMonChecksum
	push hl
	ld bc, SAVEMON_CHECKSUM
	add hl, bc
	ld a, [hli]
	cp e
	jr nz, .bad
	ld a, [hl]
	cp d
	jr nz, .bad
	pop hl
	and a
	ret
.bad
	pop hl
	scf
	ret

DecodeSavedMon::
; Decodes the savemon_struct at hl (SRAM bank open) into wTempMon (+extension),
; recalculating stats and restoring PP. If the checksum is invalid the Bad Egg
; record is decoded instead and carry is returned. Closes SRAM.
; Side effects: wCurSpecies/wCurPartySpecies/wCurPartyLevel and the base data
; buffer describe the decoded mon afterwards.
	call VerifySavedMonChecksum
	jr nc, .valid
	call CloseSRAM
	ld hl, BadEggRecord
	call .Decode
	ld a, 1
	or a ; nz
	scf ; c
	ret
.valid
	call .Decode
	ld a, 1
	and a ; nz, nc
	ret

.Decode:
	push hl
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, e
	ld [wTempMonSpeciesIndex], a
	ld a, d
	ld [wTempMonSpeciesIndex + 1], a
	ld h, d
	ld l, e
	call GetPokemonIDFromIndex
	ld [wTempMonSpecies], a
	pop hl
	push hl
	inc hl
	inc hl
	ld a, [hl]
	ld [wTempMonItem], a
	pop hl

	decode_move 0
	decode_move 1
	decode_move 2
	decode_move 3

	push hl
	ld de, SAVEMON_ID
	add hl, de
	ld de, wTempMonID
	ld bc, SAVEMON_DVS + 2 - SAVEMON_ID
	call CopyBytes
	pop hl

	push hl
	ld de, SAVEMON_HAPPINESS
	add hl, de
	ld a, [hli]
	ld [wTempMonHappiness], a
	ld a, [hli]
	ld d, a
	and $3f
	ld [wTempMonPokerusStatus], a
	ld a, d
	and MON_SHINY_FLAG | MON_MALE_FLAG
	ld [wTempMonUnused], a
	ld a, [hli]
	ld [wTempMonCaughtLevel], a
	ld a, [hli]
	ld [wTempMonCaughtLocation], a
	ld a, [hli]
	ld [wTempMonLevel], a
	ld a, [hli]
	ld [wTempMonPersonality], a
	ld a, [hl]
	and 1 << SAVEMON_IS_EGG_F
	ld [wTempMonIsEgg], a
	pop hl

	push hl
	ld de, SAVEMON_NICKNAME
	add hl, de
	ld de, wTempMonNickname
	ld bc, SAVEMON_NAME_LENGTH
	call CopyBytes
	ld a, "@"
	ld [de], a
	ld de, wTempMonOT
	ld bc, SAVEMON_NAME_LENGTH
	call CopyBytes
	ld a, "@"
	ld [de], a
	pop hl
	call CloseSRAM

	; current PP
	call RestoreTempMonPP

	; stats, HP, status
	ld a, [wTempMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wTempMonIsEgg]
	and a
	ld a, EGG
	jr nz, .got_species
	ld a, [wTempMonSpecies]
.got_species
	ld [wCurPartySpecies], a
	ld a, [wTempMonUnused]
	push af
	farcall CalcTempmonStats ; also clears status (and the adjacent Unused byte)
	pop af
	ld [wTempMonUnused], a
	ret

RestoreTempMonPP::
; Sets each wTempMonPP byte to (PP Ups << 6) | max PP for the move.
	ld hl, wTempMonMoves
	ld de, wTempMonPP
	ld b, NUM_MOVES
.loop
	push bc
	ld a, [hli]
	and a
	jr nz, .has_move
	xor a
	ld [de], a
	jr .next
.has_move
	push hl
	push de
	ld l, a
	ld a, MOVE_PP
	call GetMoveAttribute ; a = base PP
	pop de
	; max PP = base PP + min(7, base PP / 5) * PP Ups
	ld h, a
	ld l, -1
.pp_up_size_loop
	inc l
	sub 5
	jr nc, .pp_up_size_loop
	ld a, l
	cp 8
	jr c, .pp_up_size_ok
	ld l, 7
.pp_up_size_ok
	ld a, [de]
	and $c0
	or h
	ld h, a
	bit 6, h
	jr z, .skip_add_one
	add a, l
.skip_add_one
	add hl, hl ; bit 7 of h -> carry; doubles l
	jr nc, .got_pp
	add a, l
.got_pp
	ld [de], a
	pop hl
.next
	inc de
	pop bc
	dec b
	jr nz, .loop
	ret

BadEggRecord:
; savemon_struct returned in place of a corrupt record. Never checksummed.
	dw UNOWN ; species index
	db NO_ITEM
	ds NUM_MOVES, 0 ; moves
	dw 0 ; ID
	ds 3, 0 ; exp
	ds 10, 0 ; stat exp
	dw 0 ; DVs
	ds NUM_MOVES, 0 ; move high bits / PP Ups
	db 0 ; happiness
	db 0 ; pokerus/shiny/gender
	db CAUGHT_EGG_LEVEL, 0 ; caught data
	db 1 ; level
	db 0 ; personality
	db 1 << SAVEMON_IS_EGG_F ; flags
	db "BAD EGG@@@"
	db "?@@@@@@@@@"
	dw 0 ; checksum (unused)
.End
	assert .End - BadEggRecord == SAVEMON_STRUCT_LENGTH
