; Background palettes for the five Elite Four chambers. Each chamber has its
; own tileset (TILESET_KOGAS_ROOM .. TILESET_LANCES_ROOM, consecutive), so
; these palettes never touch any other map. Palette 7 stays the text palette.

SECTION "League Room Palettes", ROMX

LoadLeagueRoomPalette::
	ld a, [wMapTileset]
	sub TILESET_KOGAS_ROOM
	ld l, a
	ld h, 0
rept 6 ; * 8 palettes * 4 colours * 2 bytes
	add hl, hl
endr
	ld de, LeagueRoomPalettes
	add hl, de
	ld de, wBGPals1
	ld bc, 8 palettes
	ld a, BANK(wBGPals1)
	jp FarCopyWRAM

LeagueRoomPalettes:
; order matches the TILESET_*_ROOM constants
INCLUDE "gfx/tilesets/kogas_room.pal"
INCLUDE "gfx/tilesets/brunos_room.pal"
INCLUDE "gfx/tilesets/karens_room.pal"
INCLUDE "gfx/tilesets/loreleis_room.pal"
INCLUDE "gfx/tilesets/lances_room.pal"
