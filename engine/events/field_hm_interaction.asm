; Field HM use without teaching moves to a party member:
; - matching Johto badge in wJohtoBadges
; - matching HM in wTMsHMs
; - any party #MON that can learn the move (TM/HM table)

JohtoBadgeEngineFlags:
	db ENGINE_ZEPHYRBADGE
	db ENGINE_HIVEBADGE
	db ENGINE_PLAINBADGE
	db ENGINE_FOGBADGE
	db ENGINE_MINERALBADGE
	db ENGINE_STORMBADGE
	db ENGINE_GLACIERBADGE
	db ENGINE_RISINGBADGE

HMFieldMoveTable:
; move id, Johto badge, HM item id
	db CUT,        HIVEBADGE,   HM_CUT
	db FLY,        STORMBADGE,  HM_FLY
	db SURF,       FOGBADGE,    HM_SURF
	db STRENGTH,   PLAINBADGE,  HM_STRENGTH
	db FLASH,      ZEPHYRBADGE, HM_FLASH
	db WHIRLPOOL,  GLACIERBADGE, HM_WHIRLPOOL
	db WATERFALL,  RISINGBADGE, HM_WATERFALL
	db 0

HMEventOwnershipTable:
	dw HM_CUT,       EVENT_GOT_HM01_CUT
	dw HM_FLY,       EVENT_GOT_HM02_FLY
	dw HM_SURF,      EVENT_GOT_HM03_SURF
	dw HM_STRENGTH,  EVENT_GOT_HM04_STRENGTH
	dw HM_FLASH,     EVENT_GOT_HM05_FLASH
	dw HM_WHIRLPOOL, EVENT_GOT_HM06_WHIRLPOOL
	dw HM_WATERFALL, EVENT_GOT_HM07_WATERFALL
	dw 0

CheckHMStoryOwned:
; a = HM item id. Carry if obtained.
	ld c, a
	ld hl, HMEventOwnershipTable
.loop
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	or e
	or d
	jr z, .no
	ld a, e
	cp c
	jr nz, .skip
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld b, CHECK_FLAG
	push hl
	call EventFlagAction
	pop hl
	ld a, c
	and a
	jr nz, .yes
.skip
	jr .loop
.no
	and a
	ret
.yes
	scf
	ret

FindHMEntryForMove:
; l = move id
; Output: carry if found; b = Johto badge bit, a = HM item id
	ld b, l
	ld hl, HMFieldMoveTable
.loop
	ld a, [hl]
	and a
	jr z, .not_found
	cp b
	jr nz, .skip_entry
	ld a, [hl]
	push hl
	inc hl
	ld a, [hli]
	ld b, a
	ld a, [hl]
	pop hl
	scf
	ret
.skip_entry
	ld de, 3
	add hl, de
	jr .loop
.not_found
	and a
	ret

CheckJohtoBadgeOwned:
; b = Johto badge bit (ZEPHYRBADGE..RISINGBADGE)
; Output: carry if not owned
; Uses the same engine-flag path as party-menu field moves.
	ld a, b
	cp NUM_JOHTO_BADGES
	jr nc, .missing
	ld e, a
	ld d, 0
	ld hl, JohtoBadgeEngineFlags
	add hl, de
	ld a, [hl]
	ld d, 0
	ld e, a
	jp CheckEngineFlag
.missing
	scf
	ret

CheckHMOwnedForMove:
; hl = move id in l
; Output: carry if HM is owned
	call FindHMEntryForMove
	ret nc
	ld c, a
	push bc
	call GetTMHMNumber
	ld c, a
	call CheckTMHM
	pop bc
	jr c, .owned
	ld a, c
	jp CheckHMStoryOwned
.owned
	scf
	ret

MonCanLearnHMMoveBySlot:
; a = move id. wCurPartySpecies must be set.
; Output: c != 0 if this mon can learn the move via TM/HM table.
	ld [wPutativeTMHMMove], a
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetBaseData
	predef CanLearnTMHMMove
	ret

CheckFieldHMAllowCore:
; move id in wPutativeTMHMMove. Carry on failure.
	ld a, [wPutativeTMHMMove]
	ld l, a
	ld h, 0
	push hl
	call CheckHMOwnedForMove
	jr nc, .fail
	pop hl
	push hl
	call PartyAnyCanLearnMove
	pop hl
	and a
	ret
.fail:
	pop hl
	scf
	ret

PartyAnyCanLearnMove:
; hl = move id (ld hl, CUT / SURF / FLY — id in l)
; Output: carry if at least one party member can learn it
	ld a, l
	ld [wPutativeTMHMMove], a
	ld a, [wPartyCount]
	and a
	jr z, .no
	ld d, a
	ld e, 0
.loop
	ld a, e
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	and a
	jr z, .no
	cp -1
	jr z, .no
	cp EGG
	jr z, .next
	ld [wCurPartySpecies], a
	push de
	ld a, [wPutativeTMHMMove]
	call MonCanLearnHMMoveBySlot
	pop de
	ld a, c
	and a
	jr nz, .yes
.next
	inc e
	ld a, e
	cp d
	jr nz, .loop
.no
	and a
	ret
.yes
	scf
	ret

FindFirstPartyMonCanLearnMove:
; hl = move id (ld hl, CUT / SURF / FLY — id in l)
; Output: a = party index, or $ff if none
	ld a, l
	ld [wPutativeTMHMMove], a
	ld a, [wPartyCount]
	and a
	jr z, .none
	ld d, a
	ld e, 0
.loop
	ld a, e
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl]
	and a
	jr z, .none
	cp -1
	jr z, .none
	cp EGG
	jr z, .next
	ld [wCurPartySpecies], a
	push de
	ld a, [wPutativeTMHMMove]
	call MonCanLearnHMMoveBySlot
	pop de
	ld a, c
	and a
	jr nz, .found
.next
	inc e
	ld a, e
	cp d
	jr nz, .loop
.none
	ld a, $ff
	ret
.found
	ld a, e
	ret

CheckFieldHMAllow:
; hl = move id in l
; Output: carry on failure; wCurPartyMon = first eligible mon on success
	ld a, l
	ld [wPutativeTMHMMove], a
	push hl
	call FindHMEntryForMove
	jr nc, .fallback
	ld a, b
	call CheckJohtoBadgeOwned
	jr c, .fail
	call CheckFieldHMAllowCore
	jr c, .fail
	ld a, [wPutativeTMHMMove]
	ld l, a
	ld h, 0
	call FindFirstPartyMonCanLearnMove
	ld [wCurPartyMon], a
.fail_ok:
	pop hl
	and a
	ret
.fail:
	pop hl
	scf
	ret
.fallback:
	pop hl
	jp CheckPartyMoveIndex

CheckFieldHMAllowForMenu:
; hl = move id, badge already verified
; Output: carry on failure after printing HM text if needed
	ld a, l
	ld [wPutativeTMHMMove], a
	call CheckFieldHMAllowCore
	jr nc, .ok
	ld hl, FieldHMNeedHMText
	call MenuTextboxBackup
	scf
	ret
.ok
	xor a
	ret

FieldHMNeedHMText:
	text_far _NeedHMOrCompatibleMonText
	text_end

TryTownMapFlyEligibility:
	ld hl, FLY
	call CheckFieldHMAllow
	jr c, .no
	scf
	ret
.no
	and a
	ret

FieldFlyPreparePartyMon:
; Set wCurPartyMon for fly animation (party menu may have set this already).
	push hl
	ld hl, FLY
	call FindFirstPartyMonCanLearnMove
	ld [wCurPartyMon], a
	pop hl
	ret

PokegearPrepareFlyWarp:
; Apply saved Pokégear fly destination and party mon for vanilla FlyWarpScript.
	ld a, [wFlySpawnpoint]
	and a
	ret z
	ld [wDefaultSpawnpoint], a
	xor a
	ld [wFlySpawnpoint], a
	jp FieldFlyPreparePartyMon

FieldHMOpenFlyMap:
; Returns spawn point in a, or -1 if fly map unavailable/cancelled.
	call TryTownMapFlyEligibility
	jr nc, .cancel
	ld a, [wPlayerState]
	cp PLAYER_SURF
	jr z, .cancel
	cp PLAYER_SURF_PIKA
	jr z, .cancel
	call GetMapEnvironment
	call CheckOutdoorMap
	jr nz, .cancel
	xor a
	ldh [hMapAnims], a
	call LoadStandardMenuHeader
	call ClearSprites
	farcall _FlyMap
	ld a, e
	ret

.cancel
	ld a, -1
	ret

TownMapFlyFromItem:
; Returns spawn point in a, or -1 for view-only town map.
	call FieldHMOpenFlyMap
	ret
