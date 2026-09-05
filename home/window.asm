RefreshScreen::
	call ClearWindowData
	ldh a, [hROMBank]
	push af
	ld a, BANK(ReanchorBGMap_NoOAMUpdate) ; aka BANK(LoadFonts_NoOAMUpdate)
	rst Bankswitch

	call ReanchorBGMap_NoOAMUpdate
	call _OpenAndCloseMenu_HDMATransferTileMapAndAttrMap
	call LoadFonts_NoOAMUpdate

	pop af
	rst Bankswitch
	ret

CloseText::
	ldh a, [hOAMUpdate]
	push af
	ld a, $1
	ldh [hOAMUpdate], a

	call .CloseText

	pop af
	ldh [hOAMUpdate], a
	ld hl, wVramState
	res 6, [hl]
	res VRAMSTATE_SPEECH_TEXTBOX_F, [hl]
	ret

.CloseText:
	call ClearWindowData
	xor a
	ldh [hBGMapMode], a
	call OverworldTextModeSwitch
	call _OpenAndCloseMenu_HDMATransferTileMapAndAttrMap
	xor a
	ldh [hBGMapMode], a
	call SafeUpdateSprites
	ld a, $90
	ldh [hWY], a
	call ReplacePlayerSprite
	farcall ReturnFromMapSetupScript
	farcall LoadOverworldFont
	farcall ReloadBank0SpriteFacings
	ret

OpenText::
	call ClearWindowData
	ldh a, [hROMBank]
	push af
	ld a, BANK(ReanchorBGMap_NoOAMUpdate) ; aka BANK(LoadFonts_NoOAMUpdate)
	rst Bankswitch

	call ReanchorBGMap_NoOAMUpdate ; clear bgmap
	call SpeechTextbox
	call _OpenAndCloseMenu_HDMATransferTileMapAndAttrMap ; anchor bgmap
	call LoadFonts_NoOAMUpdate ; load font
	pop af
	rst Bankswitch

; The map is still on screen above the textbox, so overworld weather carries on
; falling there instead of freezing for the length of the conversation. The
; reanchor above already set bit 6, which by itself only means some window is
; up; this says which one, so the particles know they have the top twelve rows.
	ld hl, wVramState
	set VRAMSTATE_SPEECH_TEXTBOX_F, [hl]

	ret

_OpenAndCloseMenu_HDMATransferTileMapAndAttrMap::
	ldh a, [hOAMUpdate]
	push af
	ld a, $1
	ldh [hOAMUpdate], a

	farcall OpenAndCloseMenu_HDMATransferTileMapAndAttrMap

	pop af
	ldh [hOAMUpdate], a
	ret

SafeUpdateSprites::
	ldh a, [hOAMUpdate]
	push af
	ldh a, [hBGMapMode]
	push af
	xor a
	ldh [hBGMapMode], a
	ld a, $1
	ldh [hOAMUpdate], a

	call UpdateSprites

	xor a
	ldh [hOAMUpdate], a
	call DelayFrame
	pop af
	ldh [hBGMapMode], a
	pop af
	ldh [hOAMUpdate], a
	ret
