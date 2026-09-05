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
; Stop holding the particles above the textbox before the close begins rather
; than after it ends. .CloseText erases the box in its first few instructions
; but then spends a dozen-odd frames restoring VRAM, and it rebuilds the
; sprites partway through; with the clip still on, that rebuild would leave the
; bottom third of the map bare for the whole of it, and the weather would then
; visibly flood back in. Permission to draw at all (bit 3) has to outlast the
; close, so it is still cleared at the bottom.
	ld hl, wVramState
	res VRAMSTATE_TEXTBOX_DRAWN_F, [hl]

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

; The map is still on screen above the textbox, so overworld weather carries on
; falling there instead of freezing for the length of the conversation. This is
; set before the reanchor rather than after it because the reanchor is itself
; five or six frames of map redraw and BG map transfers, and those frames are
; the pause at the start of a conversation. Nothing clips yet - bit 6 is still
; clear at this point, so the particles simply have the whole screen, which is
; right, because the textbox has not been drawn.
	ld hl, wVramState
	set VRAMSTATE_SPEECH_TEXTBOX_F, [hl]

	call ReanchorBGMap_NoOAMUpdate ; clear bgmap

; Now the box is about to go down, so hold the particles above it.
	ld hl, wVramState
	set VRAMSTATE_TEXTBOX_DRAWN_F, [hl]

	call SpeechTextbox
	call _OpenAndCloseMenu_HDMATransferTileMapAndAttrMap ; anchor bgmap
	call LoadFonts_NoOAMUpdate ; load font
	pop af
	rst Bankswitch

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
