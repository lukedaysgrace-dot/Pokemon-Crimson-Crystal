	object_const_def
	const OLIVINEFISHINGCOVE_BOAT1
	const OLIVINEFISHINGCOVE_BOAT2
	const OLIVINEFISHINGCOVE_BOAT3

OlivineFishingCove_MapScripts:
	db 0 ; scene scripts
	db 0 ; callbacks

OlivineFishingCoveSign:
	jumptext OlivineFishingCoveSignText

OlivineFishingCoveSignText:
	text "OLIVINE"
	line "FISHING COVE"
	done

OlivineFishingCove_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 19, 33, OLIVINE_CITY, 12
	warp_event 20, 33, OLIVINE_CITY, 12

	db 0 ; coord events

	db 1 ; bg events
	bg_event 24, 30, BGEVENT_READ, OlivineFishingCoveSign

	db 3 ; object events
	object_event  8,  7, SPRITE_FISHING_BOAT, SPRITEMOVEDATA_FISHING_BOAT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
	object_event 26, 12, SPRITE_FISHING_BOAT, SPRITEMOVEDATA_FISHING_BOAT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
	object_event 15, 21, SPRITE_FISHING_BOAT, SPRITEMOVEDATA_FISHING_BOAT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
