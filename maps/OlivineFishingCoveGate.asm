	object_const_def
	const OLIVINEFISHINGCOVEGATE_OFFICER

OlivineFishingCoveGate_MapScripts:
	db 0 ; scene scripts
	db 0 ; callbacks

OlivineFishingCoveGateOfficerScript:
	jumptextfaceplayer OlivineFishingCoveGateOfficerText

OlivineFishingCoveGateSign:
	jumptext OlivineFishingCoveGateSignText

OlivineFishingCoveGateOfficerText:
	text "Welcome to OLIVINE"
	line "FISHING COVE!"

	para "The cove is right"
	line "through the doors."
	done

OlivineFishingCoveGateSignText:
	text "OLIVINE"
	line "FISHING COVE"

	para "A fisherman's"
	line "paradise!"
	done

OlivineFishingCoveGate_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  3,  0, OLIVINE_FISHING_COVE, 1
	warp_event  4,  0, OLIVINE_FISHING_COVE, 2
	warp_event  3,  7, OLIVINE_CITY, 12
	warp_event  4,  7, OLIVINE_CITY, 12

	db 0 ; coord events

	db 1 ; bg events
	bg_event  5,  0, BGEVENT_READ, OlivineFishingCoveGateSign

	db 1 ; object events
	object_event  2,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveGateOfficerScript, -1
