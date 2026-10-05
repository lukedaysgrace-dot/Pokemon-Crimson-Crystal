; Overworld trainer portraits.
;
; Talking to (or being spotted by) an NPC whose sprite has a portrait puts a
; framed 56x56 portrait on top of the speech textbox, flush right. Its mouth
; moves only while their text is actually printing: once a line has finished
; (waiting for A, a yes/no box, the end of the text), it rests on the closed
; frame until the next line starts printing.
;
; Hooks elsewhere:
;   TryObjectEvent / CheckTrainerBattle  start a session  (wPortraitSession)
;   Script_end / Script_endall            end it
;   MapTextbox                            TrainerPortrait_Draw
;   PrintLetterDelay                      keeps the mouth moving (wPortraitTalkTimer)
;   UpdateWeatherSprites                  TrainerPortrait_Tick, once per frame
;   _UpdateSprites                        TrainerPortrait_ClipOAM
;   ApplyMovement                         TrainerPortrait_HideForMovement
;   CloseText                             TrainerPortrait_Restore
;
; The portrait borrows text palette colors 1 and 2 (the font and frames only use
; 0 and 3) and VRAM bank 1 tiles PORTRAIT_VTILE-$f3, the top of the table that
; bank-1 NPCs keep their walking frames in. Both are given back on CloseText,
; and before any movement runs while the box is still open.

; PORTRAIT_* constants are in constants/gfx_constants.asm.

SpritePortraits:
; overworld sprite, portrait
; Sprite variables (SPRITE_OLIVINE_RIVAL, the Fuchsia Gym Janines, ...) are
; resolved first, so they pick up whatever sprite they currently stand for.
	db SPRITE_AGATHA,      PORTRAIT_AGATHA
	db SPRITE_ARCHER,      PORTRAIT_ARCHER
	db SPRITE_ARIANA,      PORTRAIT_ARIANA
	db SPRITE_BILL,        PORTRAIT_BILL
	db SPRITE_BLAINE,      PORTRAIT_BLAINE
	db SPRITE_BLUE,        PORTRAIT_BLUE
	db SPRITE_BROCK,       PORTRAIT_BROCK
	db SPRITE_BRUNO,       PORTRAIT_BRUNO
	db SPRITE_BUGSY,       PORTRAIT_BUGSY
	db SPRITE_CHUCK,       PORTRAIT_CHUCK
	db SPRITE_CLAIR,       PORTRAIT_CLAIR
	db SPRITE_CRYSTAL,     PORTRAIT_CRYSTAL
	db SPRITE_CRYSTAL_SURF, PORTRAIT_CRYSTAL
	db SPRITE_ELM,         PORTRAIT_ELM
	db SPRITE_ERIKA,       PORTRAIT_ERIKA
	db SPRITE_MYSTICALMAN, PORTRAIT_EUSINE ; Eusine's overworld sprite
	db SPRITE_GREEN,       PORTRAIT_GREEN
	db SPRITE_JANINE,      PORTRAIT_JANINE
	db SPRITE_JASMINE,     PORTRAIT_JASMINE
	db SPRITE_KAREN,       PORTRAIT_KAREN
	db SPRITE_KIMONO_GIRL, PORTRAIT_KIMONO_GIRL
	db SPRITE_KOGA,        PORTRAIT_KOGA
	db SPRITE_LANCE,       PORTRAIT_LANCE
	db SPRITE_LORELEI,     PORTRAIT_LORELEI
	db SPRITE_MISTY,       PORTRAIT_MISTY
	db SPRITE_MORTY,       PORTRAIT_MORTY
	db SPRITE_OAK,         PORTRAIT_OAK
	db SPRITE_PRYCE,       PORTRAIT_PRYCE
	db SPRITE_RED,         PORTRAIT_RED
	db SPRITE_SABRINA,     PORTRAIT_SABRINA
	db SPRITE_SILVER,      PORTRAIT_SILVER
	db SPRITE_SURGE,       PORTRAIT_SURGE
	db SPRITE_WHITNEY,     PORTRAIT_WHITNEY
	db SPRITE_WILL,        PORTRAIT_WILL
	db -1

TrainerPortraitPointers:
; indexed by PORTRAIT_* - 1
	dba TrainerPortraitAgathaGFX
	dba TrainerPortraitArcherGFX
	dba TrainerPortraitArianaGFX
	dba TrainerPortraitBillGFX
	dba TrainerPortraitBlaineGFX
	dba TrainerPortraitBlueGFX
	dba TrainerPortraitBrockGFX
	dba TrainerPortraitBrunoGFX
	dba TrainerPortraitBugsyGFX
	dba TrainerPortraitChuckGFX
	dba TrainerPortraitClairGFX
	dba TrainerPortraitElmGFX
	dba TrainerPortraitErikaGFX
	dba TrainerPortraitEusineGFX
	dba TrainerPortraitGreenGFX
	dba TrainerPortraitJanineGFX
	dba TrainerPortraitJasmineGFX
	dba TrainerPortraitKarenGFX
	dba TrainerPortraitKimonoGirlGFX
	dba TrainerPortraitKogaGFX
	dba TrainerPortraitLanceGFX
	dba TrainerPortraitLoreleiGFX
	dba TrainerPortraitMistyGFX
	dba TrainerPortraitMortyGFX
	dba TrainerPortraitOakGFX
	dba TrainerPortraitPryceGFX
	dba TrainerPortraitRedGFX
	dba TrainerPortraitSabrinaGFX
	dba TrainerPortraitSilverGFX
	dba TrainerPortraitSurgeGFX
	dba TrainerPortraitWhitneyGFX
	dba TrainerPortraitWillGFX
	dba TrainerPortraitCrystalGFX
	dba TrainerPortraitWhitneyCryingGFX
	assert (@ - TrainerPortraitPointers) / 3 == NUM_TRAINER_PORTRAITS

TrainerPortrait_SetUpTextbox::
; PrintText specials also change speakers (Oak's rating, item notifications).
; b:de is the caller's text. Keep this out of the nearly full ROM0 bank.
	push de
	ldh a, [rSVBK]
	and %110
	jr nz, .no_portrait_text
	ld a, e
	ld [wPortraitTextAddr], a
	ld a, d
	ld [wPortraitTextAddr + 1], a
	ld a, b
	ld [wPortraitTextBank], a
.no_portrait_text
	call SpeechTextbox
	call TrainerPortrait_Draw
	call UpdateSprites
	call ApplyTilemap
	pop hl
	ret

TrainerPortrait_Draw::
; Called by MapTextbox right after it draws the speech textbox, before the
; tilemap is pushed. Puts up, keeps, swaps or takes down the portrait for
; whoever says this text.
	ldh a, [rSVBK]
	and %110
	ret nz ; WRAM bank 0/1 only
	ldh a, [hCGB]
	and a
	ret z
	ld a, [wVramState]
	bit VRAMSTATE_SPEECH_TEXTBOX_F, a
	ret z
	xor a
	ld [wPortraitMute], a

; Map texts are listed with their speaker (data/maps/portrait_texts.asm).
	farcall TrainerPortrait_FindText
	cp -1
	jr z, .nobody
	and a
	jr z, .nobody
	bit 7, a
	jr z, .show
	and $7f ; a map object: use whatever its sprite is right now
	call TrainerPortrait_GetObjectPortrait
	jr z, .nobody
	jr .show

.nobody
; Only text with an identified speaker may display a portrait. Shared item
; messages, signs and unknown text must never inherit the previous speaker
; or a portrait-looking disguise from hLastTalked.
	call TrainerPortrait_IsOnScreen
	ret nz
	jp TrainerPortrait_TakeDown

.show
	ld e, a
	call TrainerPortrait_IsOnScreen
	jr nz, .new
	ld a, [wPortraitShown]
	cp e
	jr z, TrainerPortrait_ApplyPalette ; already up
	; Somebody else's portrait is up: blank the picture while the new one
	; streams in, rather than showing a half-and-half face.
	push de
	hlcoord PORTRAIT_X, PORTRAIT_Y
	ld a, " "
	ld d, 0
	call TrainerPortrait_FillInterior
	hlcoord PORTRAIT_X, PORTRAIT_Y, wAttrMap
	ld a, PAL_BG_TEXT
	ld d, 0
	call TrainerPortrait_FillInterior
	call ApplyTilemap
	pop de
	jr .load

.new
	push de
	call TrainerPortrait_BackUpMap
	pop de

.load
	push de
	call TrainerPortrait_LoadGFX
	call TrainerPortrait_DrawFrame
	pop de
	ld a, e
	ld [wPortraitShown], a
	ld a, TRUE
	ld [wPortraitDirty], a
	xor a
	ld [wPortraitMouth], a
	ld [wPortraitTalkTimer], a
	inc a
	ld [wPortraitAnimTimer], a
	; fallthrough

TrainerPortrait_ReapplyPalette::
; Time/weather rebuilds use the normal textbox colors. Restore the portrait's
; two colors before that rebuilt buffer reaches VBlank, if it is still drawn.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPortraitShown)
	ldh [rSVBK], a
	call TrainerPortrait_IsOnScreen
	call z, TrainerPortrait_ApplyPalette
	pop af
	ldh [rSVBK], a
	ret

TrainerPortrait_ApplyPalette:
; Reapplied on every textbox: anything that reloads the text palette in
; between (a Pokepic, a fade) would otherwise leave the portrait gray.
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPortraitHeader)
	ldh [rSVBK], a
	ld hl, wPortraitHeader + 1
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, BANK(wBGPals2)
	ldh [rSVBK], a
	ld hl, wBGPals2 + PAL_BG_TEXT palettes + PAL_COLOR_SIZE
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], e
	pop af
	ldh [rSVBK], a
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	ret

TrainerPortrait_GetObjectPortrait:
; Return the portrait for map object a's current sprite in a (z and 0 if none).
	and a
	ret z ; the player
	cp NUM_OBJECTS
	jr nc, .none
	call GetMapObject
	ld hl, MAPOBJECT_SPRITE
	add hl, bc
	ld a, [hl]
	cp SPRITE_VARS
	jr c, .got_sprite
	sub SPRITE_VARS
	ld e, a
	ld d, 0
	ld hl, wVariableSprites
	add hl, de
	ld a, [hl]
.got_sprite
	ld c, a
	ld hl, SpritePortraits
.loop
	ld a, [hli]
	cp -1
	jr z, .none
	cp c
	ld a, [hli]
	jr nz, .loop
	and a
	ret

.none
	xor a
	ret

TrainerPortrait_IsOnScreen:
; z if a portrait is in the tilemap right now. Anything that redraws the
; screen (OpenText, a battle, the naming screen, a Pokepic box) wipes the
; top-left portrait cell, so this also catches portraits that are gone
; without anyone telling us.
	ld a, [wPortraitShown]
	and a
	jr z, .no
	ld a, [wTileMap + PORTRAIT_Y * SCREEN_WIDTH + PORTRAIT_X]
	cp PORTRAIT_VTILE
	ret nz
	ld a, [wAttrMap + PORTRAIT_Y * SCREEN_WIDTH + PORTRAIT_X]
	cp PAL_BG_TEXT | VRAM_BANK_1
	ret
.no
	or 1
	ret

TrainerPortrait_LoadGFX:
; Copy portrait e's header to WRAM and stream its tiles into VRAM bank 1.
	ld a, e
	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerPortraitPointers
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a

	push bc
	push hl
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPortraitHeader)
	ldh [rSVBK], a
	ld a, b
	ld de, wPortraitHeader
	ld bc, PORTRAIT_HEADER_SIZE
	call FarCopyBytes
	ld a, [wPortraitHeader]
	add PORTRAIT_NUM_TILES
	ld e, a
	pop af
	ldh [rSVBK], a
	pop hl
	pop bc

	ld c, e
	ld de, PORTRAIT_HEADER_SIZE
	add hl, de
	ld d, h
	ld e, l
	ld hl, vTiles0 tile PORTRAIT_VTILE
	ldh a, [rVBK]
	push af
	ld a, 1
	ldh [rVBK], a
	call Get2bpp
	pop af
	ldh [rVBK], a
	ret

TrainerPortrait_DrawFrame:
; The frame is part of the portrait's tiles, so this is just the picture.
	hlcoord PORTRAIT_X, PORTRAIT_Y
	ld a, PORTRAIT_VTILE
	ld d, 1
	call TrainerPortrait_FillInterior
	hlcoord PORTRAIT_X, PORTRAIT_Y, wAttrMap
	ld a, PAL_BG_TEXT | VRAM_BANK_1
	ld d, 0
	; fallthrough

TrainerPortrait_FillInterior:
; Fill the portrait interior at hl with a, adding d per tile.
	ld b, PORTRAIT_HEIGHT
.row
	push hl
	ld c, PORTRAIT_WIDTH
.col
	ld [hli], a
	add d
	dec c
	jr nz, .col
	pop hl
	push de
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec b
	jr nz, .row
	ret

TrainerPortrait_BackUpMap:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPortraitBackupTiles)
	ldh [rSVBK], a
	hlcoord PORTRAIT_FRAME_X, PORTRAIT_FRAME_Y
	ld de, wPortraitBackupTiles
	call .CopyOut
	hlcoord PORTRAIT_FRAME_X, PORTRAIT_FRAME_Y, wAttrMap
	ld de, wPortraitBackupAttrs
	call .CopyOut
	pop af
	ldh [rSVBK], a
	ret

.CopyOut:
	ld b, PORTRAIT_FRAME_SIZE
.row
	push hl
	ld c, PORTRAIT_FRAME_SIZE
.col
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .col
	pop hl
	push de
	ld de, SCREEN_WIDTH
	add hl, de
	pop de
	dec b
	jr nz, .row
	ret

TrainerPortrait_RestoreMap:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPortraitBackupTiles)
	ldh [rSVBK], a
	ld hl, wPortraitBackupTiles
	decoord PORTRAIT_FRAME_X, PORTRAIT_FRAME_Y
	call .CopyIn
	ld hl, wPortraitBackupAttrs
	decoord PORTRAIT_FRAME_X, PORTRAIT_FRAME_Y, wAttrMap
	call .CopyIn
	pop af
	ldh [rSVBK], a
	ret

.CopyIn:
	ld b, PORTRAIT_FRAME_SIZE
.row
	push de
	ld c, PORTRAIT_FRAME_SIZE
.col
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .col
	pop de
	ld a, e
	add SCREEN_WIDTH
	ld e, a
	jr nc, .no_carry
	inc d
.no_carry
	dec b
	jr nz, .row
	ret

TrainerPortrait_Tick::
; Farcalled from UpdateWeatherSprites, so it runs from every text-printing and
; wait-for-input loop. Does its work at most once per frame.
; Preserves bc and de.
	ldh a, [rSVBK]
	and %110
	ret nz
	ld a, [wPortraitShown]
	and a
	ret z
	push bc
	push de
	ldh a, [hVBlankCounter]
	ld b, a
	ld a, [wPortraitTickFrame]
	cp b
	jr z, .done
	ld a, b
	ld [wPortraitTickFrame], a
	; Only the plain speech textbox, with nothing open on top of it: a yes/no
	; box or menu could be sitting over the mouth tiles.
	ld a, [wVramState]
	and (1 << 0) | (1 << VRAMSTATE_SPEECH_TEXTBOX_F)
	cp (1 << 0) | (1 << VRAMSTATE_SPEECH_TEXTBOX_F)
	jr nz, .done
	ld a, [wWindowStackSize]
	and a
	jr nz, .done
	call TrainerPortrait_IsOnScreen
	jr nz, .done
	ld a, [wPortraitMute]
	and a
	jr nz, .quiet

	ld hl, wPortraitTalkTimer
	ld a, [hl]
	and a
	jr z, .quiet
	dec [hl]
	ld hl, wPortraitAnimTimer
	dec [hl]
	jr nz, .done
	ld [hl], PORTRAIT_MOUTH_FRAMES
	ld a, [wPortraitMouth]
	xor 1
	call TrainerPortrait_SetMouth
	jr .done

.quiet
; The line has finished printing: rest on the closed frame, and make the
; mouth open right away when the next line starts.
	ld a, 1
	ld [wPortraitAnimTimer], a
	ld a, [wPortraitMouth]
	and a
	jr z, .done
	xor a
	call TrainerPortrait_SetMouth

.done
	pop de
	pop bc
	ret

TrainerPortrait_SetMouth:
; Draw mouth state a (0 closed, 1 open) into the tilemap. The BG map
; transfer that is running for the textbox carries it to the screen.
	ld [wPortraitMouth], a
	ld d, a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wPortraitHeader)
	ldh [rSVBK], a
	ld a, [wPortraitHeader]
	and a
	jr z, .done
	ld c, a
	ld b, 0
	ld hl, wPortraitHeader + 1 + 2 * PAL_COLOR_SIZE
.loop
	push hl
	push bc
	ld e, [hl] ; cell
	ld a, d
	and a
	ld a, e
	jr z, .got_tile
	ld a, b
	add PORTRAIT_NUM_TILES
.got_tile
	add PORTRAIT_VTILE
	push af
	ld a, e
	ld hl, wTileMap + PORTRAIT_Y * SCREEN_WIDTH + PORTRAIT_X
	ld bc, SCREEN_WIDTH
.find_row
	cp PORTRAIT_WIDTH
	jr c, .got_row
	sub PORTRAIT_WIDTH
	add hl, bc
	jr .find_row
.got_row
	ld c, a
	ld b, 0
	add hl, bc
	pop af
	ld [hl], a
	pop bc
	pop hl
	inc hl
	inc b
	dec c
	jr nz, .loop
.done
	pop af
	ldh [rSVBK], a
	ret

TrainerPortrait_ClipOAM::
; Farcalled at the end of _UpdateSprites. NPCs and weather particles are OAM
; and would draw on top of the portrait, so hide any that overlap it.
	ldh a, [rSVBK]
	and %110
	ret nz
	ld a, [wPortraitShown]
	and a
	ret z
	ld a, [wVramState]
	bit VRAMSTATE_SPEECH_TEXTBOX_F, a
	ret z
	call TrainerPortrait_IsOnScreen
	ret nz
	push bc
	push de
	ld hl, wVirtualOAM
	ld b, NUM_SPRITE_OAM_STRUCTS
	ld de, SPRITEOAMSTRUCT_LENGTH
.loop
	inc hl
	ld a, [hld] ; x
	sub PORTRAIT_X * TILE_WIDTH + 1
	cp (SCREEN_WIDTH - PORTRAIT_X) * TILE_WIDTH + TILE_WIDTH - 1
	jr nc, .next
	ld a, [hl] ; y
	sub PORTRAIT_FRAME_Y * TILE_WIDTH + TILE_WIDTH + 1
	cp PORTRAIT_FRAME_SIZE * TILE_WIDTH + TILE_WIDTH - 1
	jr nc, .next
	ld [hl], SCREEN_HEIGHT_PX + 2 * TILE_WIDTH ; off screen
.next
	add hl, de
	dec b
	jr nz, .loop
	pop de
	pop bc
	ret

TrainerPortrait_HideForMovement::
; Farcalled by ApplyMovement. NPC walking frames may be sitting under the
; portrait's tiles, so take it down (putting the map back under it) before
; anything walks. The next line of text brings it back.
	ld a, [wPortraitShown]
	and a
	ret z
	call TrainerPortrait_IsOnScreen
	jr nz, TrainerPortrait_Restore
	; fallthrough

TrainerPortrait_TakeDown:
; Put the map back under the portrait, show that, then hand back what the
; portrait borrowed.
	call TrainerPortrait_RestoreMap
	xor a
	ld [wPortraitShown], a
	call ApplyTilemap
	call SafeUpdateSprites
	; fallthrough

TrainerPortrait_Restore::
; Give back the text palette colors and the VRAM the portrait borrowed. Called
; at the end of CloseText (and above), when it is no longer on screen.
	xor a
	ld [wPortraitShown], a
	ld [wPortraitMouth], a
	ld [wPortraitMute], a
	ld a, [wPortraitDirty]
	and a
	ret z
	xor a
	ld [wPortraitDirty], a

	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	ld hl, wBGPals1 + PAL_BG_TEXT palettes + PAL_COLOR_SIZE
	ld de, wBGPals2 + PAL_BG_TEXT palettes + PAL_COLOR_SIZE
	ld c, 2 * PAL_COLOR_SIZE
.palette
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .palette
	pop af
	ldh [rSVBK], a
	ld a, TRUE
	ldh [hCGBPalUpdate], a

; Reload the walking frames of every bank-1 sprite whose second table entry
; ran into the portrait's tiles.
	ld hl, wSpriteFlags
	ld a, [hl]
	push af
	set 7, [hl] ; skip the first facing
	res 6, [hl]
	res 5, [hl] ; VRAM bank 1

	ld hl, wUsedSprites
	ld c, SPRITE_GFX_LIST_CAPACITY
.loop
	ld a, [hli]
	and a
	jr z, .done
	ld b, a
	ld a, [hli]
	bit 7, a
	jr nz, .next ; VRAM bank 0
	cp WALKING_SPRITE
	jr c, .check
	cp BOAT_SPRITE + 1
	jr c, .next ; never got a VRAM slot (see ArrangeUsedSprites)
.check
	add $80 + 12 ; end of its walking frames
	jr c, .reload
	cp PORTRAIT_VTILE + 1
	jr c, .next
.reload
	push bc
	push hl
	ld a, b
	ldh [hUsedSpriteIndex], a
	dec hl
	ld a, [hl]
	ldh [hUsedSpriteTile], a
	farcall GetUsedSprite
	pop hl
	pop bc
.next
	dec c
	jr nz, .loop

.done
	pop af
	ld [wSpriteFlags], a
	ret


SECTION "Trainer Portrait Graphics 1", ROMX

TrainerPortraitAgathaGFX:     INCBIN "gfx/trainer_portraits/agatha.portrait"
TrainerPortraitArcherGFX:     INCBIN "gfx/trainer_portraits/archer.portrait"
TrainerPortraitArianaGFX:     INCBIN "gfx/trainer_portraits/ariana.portrait"
TrainerPortraitBillGFX:       INCBIN "gfx/trainer_portraits/bill.portrait"
TrainerPortraitBlaineGFX:     INCBIN "gfx/trainer_portraits/blaine.portrait"
TrainerPortraitBlueGFX:       INCBIN "gfx/trainer_portraits/blue.portrait"
TrainerPortraitBrockGFX:      INCBIN "gfx/trainer_portraits/brock.portrait"
TrainerPortraitBrunoGFX:      INCBIN "gfx/trainer_portraits/bruno.portrait"
TrainerPortraitBugsyGFX:      INCBIN "gfx/trainer_portraits/bugsy.portrait"
TrainerPortraitChuckGFX:      INCBIN "gfx/trainer_portraits/chuck.portrait"
TrainerPortraitClairGFX:      INCBIN "gfx/trainer_portraits/clair.portrait"
TrainerPortraitElmGFX:        INCBIN "gfx/trainer_portraits/elm.portrait"
TrainerPortraitErikaGFX:      INCBIN "gfx/trainer_portraits/erika.portrait"
TrainerPortraitEusineGFX:     INCBIN "gfx/trainer_portraits/eusine.portrait"
TrainerPortraitGreenGFX:      INCBIN "gfx/trainer_portraits/green.portrait"
TrainerPortraitJanineGFX:     INCBIN "gfx/trainer_portraits/janine.portrait"


SECTION "Trainer Portrait Graphics 2", ROMX

TrainerPortraitJasmineGFX:    INCBIN "gfx/trainer_portraits/jasmine.portrait"
TrainerPortraitKarenGFX:      INCBIN "gfx/trainer_portraits/karen.portrait"
TrainerPortraitKimonoGirlGFX: INCBIN "gfx/trainer_portraits/kimono_girl.portrait"
TrainerPortraitKogaGFX:       INCBIN "gfx/trainer_portraits/koga.portrait"
TrainerPortraitLanceGFX:      INCBIN "gfx/trainer_portraits/lance.portrait"
TrainerPortraitLoreleiGFX:    INCBIN "gfx/trainer_portraits/lorelei.portrait"
TrainerPortraitMistyGFX:      INCBIN "gfx/trainer_portraits/misty.portrait"
TrainerPortraitMortyGFX:      INCBIN "gfx/trainer_portraits/morty.portrait"
TrainerPortraitOakGFX:        INCBIN "gfx/trainer_portraits/oak.portrait"
TrainerPortraitPryceGFX:      INCBIN "gfx/trainer_portraits/pryce.portrait"
TrainerPortraitRedGFX:        INCBIN "gfx/trainer_portraits/red.portrait"
TrainerPortraitSabrinaGFX:    INCBIN "gfx/trainer_portraits/sabrina.portrait"
TrainerPortraitSilverGFX:     INCBIN "gfx/trainer_portraits/silver.portrait"
TrainerPortraitSurgeGFX:      INCBIN "gfx/trainer_portraits/surge.portrait"
TrainerPortraitWhitneyGFX:    INCBIN "gfx/trainer_portraits/whitney.portrait"
TrainerPortraitWillGFX:       INCBIN "gfx/trainer_portraits/will.portrait"
TrainerPortraitCrystalGFX:    INCBIN "gfx/trainer_portraits/crystal.portrait"
TrainerPortraitWhitneyCryingGFX: INCBIN "gfx/trainer_portraits/whitney_crying.portrait"
