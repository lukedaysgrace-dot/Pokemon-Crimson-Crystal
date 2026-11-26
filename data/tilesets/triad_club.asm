; Beast Triad card clubs, painted by tools/triad_club/rooms.py.
; TILESET_TRIAD_LOUNGE: Goldenrod Triad Lounge (behind the Game Corner's back doorway).
; TILESET_TRIAD_VAULT: Celadon Grand Master room (behind the Game Corner's poster switch).

SECTION "Triad Lounge Tileset", ROMX
TilesetTriadLoungeGFX:
	INCBIN "gfx/tilesets/triad_lounge.2bpp.lz"
TilesetTriadLoungeMeta:
	INCBIN "data/tilesets/triad_lounge_metatiles.bin"
TilesetTriadLoungeColl:
	INCLUDE "data/tilesets/triad_lounge_collision.asm"
TilesetTriadLoungeAttr:
	INCBIN "data/tilesets/triad_lounge_attributes.bin"

SECTION "Triad Vault Tileset", ROMX
TilesetTriadVaultGFX:
	INCBIN "gfx/tilesets/triad_vault.2bpp.lz"
TilesetTriadVaultMeta:
	INCBIN "data/tilesets/triad_vault_metatiles.bin"
TilesetTriadVaultColl:
	INCLUDE "data/tilesets/triad_vault_collision.asm"
TilesetTriadVaultAttr:
	INCBIN "data/tilesets/triad_vault_attributes.bin"

SECTION "Triad Club Palettes", ROMX
LoadTriadClubPalette:
; The clubs are lamp-lit at every hour: always their own dim palettes.
	ld hl, TilesetTriadLoungePalette
	ld a, [wMapTileset]
	cp TILESET_TRIAD_LOUNGE
	jr z, .got_palette
	ld hl, TilesetTriadVaultPalette
.got_palette
	ld de, wBGPals1
	ld bc, 8 palettes
	ld a, BANK(wBGPals1)
	jp FarCopyWRAM

TilesetTriadLoungePalette:
	INCLUDE "gfx/tilesets/triad_lounge.pal"
TilesetTriadVaultPalette:
	INCLUDE "gfx/tilesets/triad_vault.pal"
