CheckPartyFullAfterContest:
	ld a, [wContestMon]
	and a
	jp z, .DidntCatchAnything
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jp nc, .TryAddToBox
	inc a
	ld [hl], a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wContestMon]
	ld [hli], a
	ld [wCurSpecies], a
	ld a, -1
	ld [hl], a
	ld hl, wPartyMon1Species
	ld a, [wPartyCount]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wContestMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonOT
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wPlayerName
	call CopyBytes
	ld a, [wCurPartySpecies]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld de, wMonOrItemNameBuffer
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	call GiveANickname_YesNo
	jr c, .Party_SkipNickname
	ld a, [wPartyCount]
	dec a
	ld [wCurPartyMon], a
	xor a
	ld [wMonType], a
	ld de, wMonOrItemNameBuffer
	callfar InitNickname

.Party_SkipNickname:
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonNicknames
	call SkipNames
	ld d, h
	ld e, l
	ld hl, wMonOrItemNameBuffer
	call CopyBytes
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Level
	call GetPartyLocation
	ld a, [hl]
	ld [wCurPartyLevel], a
	call SetCaughtData
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1CaughtLocation
	call GetPartyLocation
	ld a, [hl]
	and CAUGHT_GENDER_MASK
	ld b, NATIONAL_PARK
	or b
	ld [hl], a
	xor a
	ld [wContestMon], a
	and a ; BUGCONTEST_CAUGHT_MON
	ld [wScriptVar], a
	ret

.TryAddToBox:
	farcall NewStorageBoxPointer
	jr c, .StorageFull
	xor a
	ld [wCurPartyMon], a
	ld hl, wContestMon
	ld de, wBufferMon
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	xor a ; REMOVE_PARTY
	ld [wPokemonWithdrawDepositParameter], a
	ld hl, wPlayerName
	ld de, wBufferMonOT
	ld bc, NAME_LENGTH
	call CopyBytes
	callfar InsertPokemonIntoBox
	ld a, [wCurPartySpecies]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	call GiveANickname_YesNo
	ld hl, wStringBuffer1
	jr c, .Box_SkipNickname
	ld a, BOXMON
	ld [wMonType], a
	ld de, wMonOrItemNameBuffer
	callfar InitNickname
	ld hl, wMonOrItemNameBuffer

.Box_SkipNickname:
	ld de, wTempMonNickname
	ld bc, MON_NAME_LENGTH
	call CopyBytes

.BoxFull:
	ld a, [wTempMonLevel]
	ld [wCurPartyLevel], a
	call SetBoxMonCaughtData
	ld hl, wTempMonCaughtData + 1
	ld a, [hl]
	and CAUGHT_GENDER_MASK
	ld b, NATIONAL_PARK
	or b
	ld [hl], a
	farcall UpdateStorageBoxMonFromTemp
.StorageFull:
	xor a
	ld [wContestMon], a
	ld a, BUGCONTEST_BOXED_MON
	ld [wScriptVar], a
	ret

.DidntCatchAnything:
	ld a, BUGCONTEST_NO_CATCH
	ld [wScriptVar], a
	ret

GiveANickname_YesNo:
	ld hl, TextJump_GiveANickname
	call PrintText
	jp YesNoBox

TextJump_GiveANickname:
	; Give a nickname to the @  you received?
	text_far UnknownText_0x1c12fc
	text_end

SetCaughtData:
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1CaughtLevel
	call GetPartyLocation
SetBoxmonOrEggmonCaughtData:
	ld a, [wTimeOfDay]
	inc a
	rrca
	rrca
	ld b, a
	ld a, [wCurPartyLevel]
	or b
	ld [hli], a
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	cp MAP_POKECENTER_2F
	jr nz, .NotPokecenter2F
	ld a, b
	cp GROUP_POKECENTER_2F
	jr nz, .NotPokecenter2F

	ld a, [wBackupMapGroup]
	ld b, a
	ld a, [wBackupMapNumber]
	ld c, a

.NotPokecenter2F:
	call GetWorldMapLocation
	ld b, a
	ld a, [wPlayerGender]
	rrca ; shift bit 0 (PLAYERGENDER_FEMALE_F) to bit 7 (CAUGHT_GENDER_MASK)
	or b
	ld [hl], a
	ret

SetBoxMonCaughtData:
; Sets caught data on the just-deposited mon in wTempMon.
; The caller is responsible for recommitting it to storage
; (UpdateStorageBoxMonFromTemp) afterwards.
	ld hl, wTempMonCaughtData
	jp SetBoxmonOrEggmonCaughtData

SetGiftBoxMonCaughtData:
	ld hl, wTempMonCaughtData
	jp SetGiftMonCaughtData

SetGiftPartyMonCaughtData:
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1CaughtLevel
	push bc
	call GetPartyLocation
	pop bc
SetGiftMonCaughtData:
	xor a
	ld [hli], a
	ld a, GIFT_LOCATION
	rrc b
	or b
	ld [hl], a
	ret

SetEggMonCaughtData:
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1CaughtLevel
	call GetPartyLocation
	ld a, [wCurPartyLevel]
	push af
	ld a, CAUGHT_EGG_LEVEL
	ld [wCurPartyLevel], a
	call SetBoxmonOrEggmonCaughtData
	pop af
	ld [wCurPartyLevel], a
	ret

; Caught ball: stored in Personality bits 0-4 (CAUGHT_BALL_MASK), so it
; persists in the box struct through the PC, evolution and day-care.

CaughtBallItems:
; entries correspond to CAUGHTBALL_* constants
	db POKE_BALL
	db GREAT_BALL
	db ULTRA_BALL
	db MASTER_BALL
	db HEAVY_BALL
	db LEVEL_BALL
	db LURE_BALL
	db FAST_BALL
	db FRIEND_BALL
	db MOON_BALL
	db LOVE_BALL
	db PARK_BALL

SetCaughtBall::
; Store the ball in wCurItem into the Personality byte at bc,
; preserving the ability bits. Farcall-safe.
	ld a, [wCurItem]
	call GetCaughtBallIndex
	ld h, b
	ld l, c
	ld b, a
	ld a, [hl]
	and $ff ^ CAUGHT_BALL_MASK
	or b
	ld [hl], a
	ld b, h
	ld c, l
	ret

GetCaughtBallIndex:
; a = ball item id -> a = CAUGHTBALL_* index (Poke Ball if unknown)
	push bc
	push hl
	ld b, a
	ld c, 0
	ld hl, CaughtBallItems
.loop
	ld a, [hli]
	cp b
	jr z, .found
	inc c
	ld a, c
	cp NUM_CAUGHT_BALLS
	jr c, .loop
	ld c, CAUGHTBALL_POKE_BALL
.found
	ld a, c
	pop hl
	pop bc
	ret

GetPartyMonCaughtBallItem::
; e = party mon index -> c = ball item id. Farcall-safe.
	ld a, e
	ld hl, wPartyMon1Personality
	call GetPartyLocation
	ld a, [hl]
	and CAUGHT_BALL_MASK
	; fallthrough
GetCaughtBallItem::
; a = CAUGHTBALL_* index -> c = ball item id. Farcall-safe.
	cp NUM_CAUGHT_BALLS
	jr c, .valid
	xor a ; CAUGHTBALL_POKE_BALL
.valid
	ld hl, CaughtBallItems
	push de
	ld e, a
	ld d, 0
	add hl, de
	pop de
	ld c, [hl]
	ret
