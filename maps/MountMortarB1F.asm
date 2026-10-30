	object_const_def ; object_event constants
	const MOUNTMORTARB1F_POKE_BALL1
	const MOUNTMORTARB1F_POKE_BALL2
	const MOUNTMORTARB1F_BOULDER
	const MOUNTMORTARB1F_POKE_BALL3
	const MOUNTMORTARB1F_POKE_BALL4
	const MOUNTMORTARB1F_POKE_BALL5
	const MOUNTMORTARB1F_DURALUDON

MountMortarB1F_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

MountMortarB1FDuraludon:
	faceplayer
	opentext
	writetext MountMortarB1FDuraludonText
	cry DURALUDON
	waitsfx
	waitbutton
	closetext
	loadwildmon DURALUDON, 40
	startbattle
	disappear MOUNTMORTARB1F_DURALUDON
	reloadmapafterbattle
	end

MountMortarB1FDuraludonText:
	text "DURA?"
	done

LoadMountMortarDuraludonPalette::
; No other object on this map uses blue. Keep Duraludon's gray body opaque
; and its blue accents distinct, without changing the boulder or item balls.
	ld a, [wMapGroup]
	cp GROUP_MOUNT_MORTAR_B1F
	ret nz
	ld a, [wMapNumber]
	cp MAP_MOUNT_MORTAR_B1F
	ret nz
	ld hl, .Palette
	ld de, wOBPals1 palette PAL_OW_BLUE
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	jp FarCopyWRAM
.Palette:
	RGB 31,31,31, 25,25,25, 10,09,31, 00,00,00

MountMortarB1FBoulder:
	jumpstd strengthboulder

MountMortarB1FHyperPotion:
	itemball HYPER_POTION

MountMortarB1FCarbos:
	itemball CARBOS

MountMortarB1FFullRestore:
	itemball FULL_RESTORE

MountMortarB1FMaxEther:
	itemball MAX_ETHER

MountMortarB1FPPUp:
	itemball PP_UP

MountMortarB1FHiddenMaxRevive:
	hiddenitem MAX_REVIVE, EVENT_MOUNT_MORTAR_B1F_HIDDEN_MAX_REVIVE

MountMortarB1F_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  3,  3, MOUNT_MORTAR_1F_INSIDE, 5
	warp_event 19, 29, MOUNT_MORTAR_1F_OUTSIDE, 7

	db 0 ; coord events

	db 1 ; bg events
	bg_event  4,  6, BGEVENT_ITEM, MountMortarB1FHiddenMaxRevive

	db 7 ; object events
	object_event 29, 12, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MountMortarB1FHyperPotion, EVENT_MOUNT_MORTAR_B1F_HYPER_POTION
	object_event  4, 16, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MountMortarB1FCarbos, EVENT_MOUNT_MORTAR_B1F_CARBOS
	object_event  9, 10, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, MountMortarB1FBoulder, -1
	object_event 34, 24, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MountMortarB1FFullRestore, EVENT_MOUNT_MORTAR_B1F_FULL_RESTORE
	object_event 32,  3, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MountMortarB1FMaxEther, EVENT_MOUNT_MORTAR_B1F_MAX_ETHER
	object_event 21, 26, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, MountMortarB1FPPUp, EVENT_MOUNT_MORTAR_B1F_PP_UP
	; Kiyo's original (16,4) training area, with room to wander on land.
	object_event 16,  4, SPRITE_DURALUDON, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, MountMortarB1FDuraludon, EVENT_MOUNT_MORTAR_DURALUDON
