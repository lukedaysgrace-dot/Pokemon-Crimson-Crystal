; Map-specific OBJ palette overrides, farcalled from LoadMapPals after the
; time-of-day object palettes are copied to wOBPals1. Kept out of bank 2
; (engine/gfx/color.asm), which is full.

LoadDanceTheatreObjectPalette:
; The Dance Theatre has no rock-paletted objects, so reuse that OBJ slot for
; Yumi's pink kimono without changing the rock palette anywhere else.
	ld a, [wMapGroup]
	cp GROUP_DANCE_THEATRE
	ret nz
	ld a, [wMapNumber]
	cp MAP_DANCE_THEATRE
	ret nz
	ld hl, DanceTheatrePinkPalette
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM

DanceTheatrePinkPalette:
	RGB 31,31,31, 31,19,10, 31,15,26, 00,00,00

LoadRoute4MewPalette:
; Route 4 has no rock-paletted NPCs. Give the party Mew its own pink slot;
; terrain rocks use BG palettes and are unaffected.
	ld a, [wMapGroup]
	cp GROUP_ROUTE_4
	ret nz
	ld a, [wMapNumber]
	cp MAP_ROUTE_4
	ret nz
	ld hl, .Pink
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM
.Pink
	RGB 31,31,31, 31,26,30, 31,17,26, 18,4,13

LoadApricornTreeObjectPalette:
; The apricorns on fruit trees use Sour Crystal's apricorn colours. Red, blue
; and green match existing OBJ palettes; the others are loaded into the rock
; slot, which none of these maps' objects or effects use.
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	ld hl, ApricornTreeObjectPalettes
.loop
	ld a, [hli]
	cp -1
	ret z
	cp b
	jr nz, .next
	ld a, [hl]
	cp c
	jr z, .found
.next
	inc hl
	inc hl
	inc hl
	jr .loop

.found
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wOBPals1 palette PAL_OW_ROCK
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM

ApricornTreeObjectPalettes:
	db GROUP_ROUTE_37, MAP_ROUTE_37
	dw .Black
	db GROUP_ROUTE_42, MAP_ROUTE_42
	dw .PinkYellow
	db GROUP_AZALEA_TOWN, MAP_AZALEA_TOWN
	dw .White
	db -1 ; end

; Colour 0 is transparent for sprites.
.Black: ; BLK APRICORN
	RGB 31,31,31, 23,23,23, 10,10,10, 00,00,00
.White: ; WHT APRICORN
	RGB 31,31,31, 31,31,31, 26,26,26, 00,00,00
.PinkYellow:
; Route 42 has one free slot for two colours. PNK APRICORN uses Sour's pink
; body (colour 2) with a yellow highlight; YLW APRICORN is drawn one-tone in
; Sour's yellow highlight (colour 1, SPRITEMOVEDATA_APRICORN_ONE_TONE).
	RGB 31,31,31, 30,27,08, 27,07,16, 00,00,00
