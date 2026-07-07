LoadOverworldMonIcon:
; e = species id
; Output: de = icon gfx pointer, b = bank, c = number of tiles
	ld a, e
	call GetIconPointer
	ld d, h
	ld e, l
	ld c, 8
	ret

SetMenuMonIconColor:
; Load the actual battle colors (shiny-aware; shininess data at hl)
; of the species in wTempIconSpecies into OBJ palette 1, and give
; that palette to menu icon 0.
	push hl
	push de
	push bc
	push af

	ld a, [wTempIconSpecies]
	ld [wCurPartySpecies], a
	ld d, a
	ld c, l
	ld b, h
	ld e, 1 ; OBJ palette 1
	farcall LoadMonMenuIconPal
	ld a, 1 ; OBJ palette 1
	ld hl, wVirtualOAMSprite00Attributes
	jp _ApplyMenuMonIconColor

LoadPartyMenuMonIconColors:
; Set the OAM palette of the current party menu icon
; (party mon index in hObjectStructIndexBuffer).
	push hl
	push de
	push bc
	push af

	ldh a, [hObjectStructIndexBuffer]
	ld [wCurPartyMon], a
	ld hl, wPartyMon1Item
	call GetPartyLocation
	ld a, [hl]
	push af ; held item

; Party mon icon palettes hold each mon's actual battle colors,
; loaded into OBJ palettes 2-7 by LoadPartyMenuMonPals.
	ldh a, [hObjectStructIndexBuffer]
	add 2
	ld hl, wVirtualOAMSprite00Attributes
	push af
	ldh a, [hObjectStructIndexBuffer]
	swap a ; party mon index * 16 (4 OAM entries of 4 bytes each)
	ld d, 0
	ld e, a
	add hl, de
	pop af

	ld de, SPRITEOAMSTRUCT_LENGTH
	ld [hl], a ; top left
	add hl, de
	ld [hl], a ; top right
	add hl, de
	push hl
	add hl, de
	ld [hl], a ; bottom right
	pop hl
	ld d, a
	pop af ; held item
	and a
	ld a, PAL_ICON_RED ; item/mail mini icon color
	jr nz, .got_pal
	ld a, d
.got_pal
	ld [hl], a ; bottom left
	jr _FinishMenuMonIconColor

_ApplyMenuMonIconColor:
	ld c, 4
	ld de, SPRITEOAMSTRUCT_LENGTH
.loop
	ld [hl], a
	add hl, de
	dec c
	jr nz, .loop
	; fallthrough
_FinishMenuMonIconColor:
	pop af
	pop bc
	pop de
	pop hl
	ret

LoadMenuMonIcon:
	push hl
	push de
	push bc
	call .LoadIcon
	pop bc
	pop de
	pop hl
	ret

.LoadIcon:
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.Jumptable:
; entries correspond to MONICON_* constants
	dw PartyMenu_InitAnimatedMonIcon    ; MONICON_PARTYMENU
	dw NamingScreen_InitAnimatedMonIcon ; MONICON_NAMINGSCREEN
	dw MoveList_InitAnimatedMonIcon     ; MONICON_MOVES
	dw Trade_LoadMonIconGFX             ; MONICON_TRADE
	dw Mobile_InitAnimatedMonIcon       ; MONICON_MOBILE1
	dw Mobile_InitPartyMenuBGPal71      ; MONICON_MOBILE2
	dw .GetPartyMenuMonIcon             ; MONICON_UNUSED

.GetPartyMenuMonIcon:
	call InitPartyMenuIcon
	call .GetPartyMonItemGFX
	call SetPartyMonIconAnimSpeed
	ret

.GetPartyMonItemGFX:
	push bc
	ldh a, [hObjectStructIndexBuffer]
	ld hl, wPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	ld a, [hl]
	and a
	jr z, .no_item
	push hl
	push bc
	ld d, a
	callfar ItemIsMail
	pop bc
	pop hl
	jr c, .not_mail
	ld a, $06
	jr .got_tile
.not_mail
	ld a, $05
	; fallthrough

.no_item
	ld a, $04
.got_tile
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	ret

Mobile_InitAnimatedMonIcon:
	call PartyMenu_InitAnimatedMonIcon
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld a, SPRITE_ANIM_SEQ_NULL
	ld [hl], a
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, 9 * 8
	ld [hl], a
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, 9 * 8
	ld [hl], a
	ret

Mobile_InitPartyMenuBGPal71:
	call InitPartyMenuIcon
	call SetPartyMonIconAnimSpeed
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld a, SPRITE_ANIM_SEQ_NULL
	ld [hl], a
	ld hl, SPRITEANIMSTRUCT_XCOORD
	add hl, bc
	ld a, 3 * 8
	ld [hl], a
	ld hl, SPRITEANIMSTRUCT_YCOORD
	add hl, bc
	ld a, 12 * 8
	ld [hl], a
	ld a, c
	ld [wc608], a
	ld a, b
	ld [wc608 + 1], a
	ret

PartyMenu_InitAnimatedMonIcon:
	call InitPartyMenuIcon
	call .SpawnItemIcon
	call SetPartyMonIconAnimSpeed
	ret

.SpawnItemIcon:
	push bc
	ldh a, [hObjectStructIndexBuffer]
	ld hl, wPartyMon1Item
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	pop bc
	ld a, [hl]
	and a
	ret z
	push hl
	push bc
	ld d, a
	callfar ItemIsMail
	pop bc
	pop hl
	jr c, .mail
	ld a, SPRITE_ANIM_FRAMESET_PARTY_MON_WITH_ITEM
	jr .okay

.mail
	ld a, SPRITE_ANIM_FRAMESET_PARTY_MON_WITH_MAIL
.okay
	ld hl, SPRITEANIMSTRUCT_FRAMESET_ID
	add hl, bc
	ld [hl], a
	ret

InitPartyMenuIcon:
	call LoadPartyMenuMonIconColors
	ld a, [wCurIconTile]
	push af
	ldh a, [hObjectStructIndexBuffer]
	ld hl, wPartySpecies
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	call ReadMonMenuIcon
	ld [wCurIcon], a
	call GetMemIconGFX
	ldh a, [hObjectStructIndexBuffer]
; y coord
	add a
	add a
	add a
	add a
	add $1c
	ld d, a
; x coord
	ld e, $10
; type is partymon icon
	ld a, SPRITE_ANIM_INDEX_PARTY_MON
	call InitSpriteAnimStruct
	pop af
	ld hl, SPRITEANIMSTRUCT_TILE_ID
	add hl, bc
	ld [hl], a
	ret

SetPartyMonIconAnimSpeed:
	push bc
	ldh a, [hObjectStructIndexBuffer]
	ld b, a
	call .getspeed
	ld a, b
	pop bc
	ld hl, SPRITEANIMSTRUCT_DURATIONOFFSET
	add hl, bc
	ld [hl], a
	rlca
	rlca
	ld hl, SPRITEANIMSTRUCT_0D
	add hl, bc
	ld [hl], a
	ret

.getspeed
	farcall PlacePartymonHPBar
	call GetHPPal
	ld e, d
	ld d, 0
	ld hl, .speeds
	add hl, de
	ld b, [hl]
	ret

.speeds
	db $00 ; HP_GREEN
	db $40 ; HP_YELLOW
	db $80 ; HP_RED

NamingScreen_InitAnimatedMonIcon:
	ld hl, wTempMonDVs
	call SetMenuMonIconColor
	ld a, [wTempIconSpecies]
	call ReadMonMenuIcon
	ld [wCurIcon], a
	xor a
	call GetIconGFX
	depixel 4, 4, 4, 0
	ld a, SPRITE_ANIM_INDEX_PARTY_MON
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_NULL
	ret

MoveList_InitAnimatedMonIcon:
	ld a, MON_DVS
	call GetPartyParamLocation
	call SetMenuMonIconColor
	ld a, [wTempIconSpecies]
	call ReadMonMenuIcon
	ld [wCurIcon], a
	xor a
	call GetIconGFX
	ld d, 3 * 8 + 2 ; depixel 3, 4, 2, 4
	ld e, 4 * 8 + 4
	ld a, SPRITE_ANIM_INDEX_PARTY_MON
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_NULL
	ret

Trade_LoadMonIconGFX:
	ld a, [wTempIconSpecies]
	call ReadMonMenuIcon
	ld [wCurIcon], a
	ld a, $62
	ld [wCurIconTile], a
	call GetMemIconGFX
	ret

GetSpeciesIcon:
; Load species icon into VRAM at tile a
	push de
	ld a, MON_DVS
	call GetPartyParamLocation
	call SetMenuMonIconColor
	ld a, [wTempIconSpecies]
	call ReadMonMenuIcon
	ld [wCurIcon], a
	pop de
	ld a, e
	call GetIconGFX
	ret

FlyFunction_GetMonIcon:
	push de
	ld a, [wTempIconSpecies]
	call ReadMonMenuIcon
	ld [wCurIcon], a
	pop de
	ld a, e
	call GetIcon_a
	; Edit OBJ palette 0 so the flying mon has the right colors.
	ld a, [wTempIconSpecies]
	ld [wCurPartySpecies], a
	ld d, a
	ld a, MON_DVS
	call GetPartyParamLocation
	ld c, l
	ld b, h
	farcall SetFirstOBJPaletteFromMonColors
	ret

Unreferenced_GetMonIcon2:
	push de
	ld a, [wTempIconSpecies]
	call ReadMonMenuIcon
	ld [wCurIcon], a
	pop de
	call GetIcon_de
	ret

GetMemIconGFX:
	ld a, [wCurIconTile]
GetIconGFX:
	call GetIcon_a
	ld de, 8 tiles
	add hl, de
	ld de, HeldItemIcons
	lb bc, BANK(HeldItemIcons), 2
	call GetGFXUnlessMobile
	ld a, [wCurIconTile]
	add 10
	ld [wCurIconTile], a
	ret

HeldItemIcons:
INCBIN "gfx/icons/mail.2bpp"
INCBIN "gfx/icons/item.2bpp"

GetIcon_de:
; Load icon graphics into VRAM starting from tile de.
	ld l, e
	ld h, d
	jr GetIcon

GetIcon_a:
; Load icon graphics into VRAM starting from tile a.
	ld l, a
	ld h, 0

GetIcon:
; Load icon graphics into VRAM starting from tile hl.

; One tile is 16 bytes long.
rept 4
	add hl, hl
endr

	ld de, vTiles0
	add hl, de
	push hl

; Each species has its own menu icon, looked up through MenuIconPointers.
	ld a, [wCurIcon]
	push hl
	call GetMenuIconPointer
	ld d, h
	ld e, l
	pop hl

	ld c, 8
	call GetGFXUnlessMobile

	pop hl
	ret

GetGFXUnlessMobile:
	ld a, [wLinkMode]
	cp LINK_MOBILE
	jp nz, Request2bpp
	jp Get2bpp_2

FreezeMonIcons:
	ld hl, wSpriteAnimationStructs
	ld e, PARTY_LENGTH
	ld a, [wMenuCursorY]
	ld d, a
.loop
	ld a, [hl]
	and a
	jr z, .next
	cp d
	jr z, .loadwithtwo
	ld a, SPRITE_ANIM_SEQ_NULL
	jr .ok

.loadwithtwo
	ld a, SPRITE_ANIM_SEQ_PARTY_MON_SWITCH

.ok
	push hl
	ld c, l
	ld b, h
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], a
	pop hl

.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret

UnfreezeMonIcons:
	ld hl, wSpriteAnimationStructs
	ld e, PARTY_LENGTH
.loop
	ld a, [hl]
	and a
	jr z, .next
	push hl
	ld c, l
	ld b, h
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], SPRITE_ANIM_SEQ_PARTY_MON
	pop hl
.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret

HoldSwitchmonIcon:
	ld hl, wSpriteAnimationStructs
	ld e, PARTY_LENGTH
	ld a, [wSwitchMon]
	ld d, a
.loop
	ld a, [hl]
	and a
	jr z, .next
	cp d
	jr z, .is_switchmon
	ld a, SPRITE_ANIM_SEQ_PARTY_MON_SELECTED
	jr .join_back

.is_switchmon
	ld a, SPRITE_ANIM_SEQ_PARTY_MON_SWITCH
.join_back
	push hl
	ld c, l
	ld b, h
	ld hl, SPRITEANIMSTRUCT_ANIM_SEQ_ID
	add hl, bc
	ld [hl], a
	pop hl
.next
	ld bc, $10
	add hl, bc
	dec e
	jr nz, .loop
	ret

ReadMonMenuIcon:
; Icons are per-species now: the icon id is the species id itself.
; EGG is resolved in GetIconPointer.
	ret

GetIconPointer:
; a = species id (or EGG)
; Output: b = bank, hl = address of icon gfx
	cp EGG
	jr z, .egg
	call GetPokemonIndexFromID
	dec hl
	ld b, h
	ld c, l
	add hl, hl
	add hl, bc ; hl = (species index - 1) * 3
	ld bc, IconPointers
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

.egg
	ld b, BANK(EggIcon)
	ld hl, EggIcon
	ret

GetMenuIconPointer:
; a = species id (or EGG)
; Output: b = bank, hl = address of menu icon gfx
; MenuIconPointers lives in its own bank, so read it with far accessors.
	cp EGG
	jr z, .egg
	call GetPokemonIndexFromID
	dec hl
	ld b, h
	ld c, l
	add hl, hl
	add hl, bc ; hl = (species index - 1) * 3
	ld bc, MenuIconPointers
	add hl, bc
	ld a, BANK(MenuIconPointers)
	call GetFarByte
	ld b, a ; icon gfx bank
	inc hl
	ld a, BANK(MenuIconPointers)
	call GetFarHalfword ; hl = icon gfx address
	ret

.egg
	ld b, BANK(EggMenuIcon)
	ld hl, EggMenuIcon
	ret

INCLUDE "data/icon_pointers.asm"

INCLUDE "gfx/icons.asm"

INCLUDE "gfx/menu_icons.asm"
