SafariZone_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_NEWMAP, .StartGame

; Hands out the balls and the step allowance on the way in. Does nothing
; if a game is already running, so this is safe on a save-and-reload.
.StartGame:
	special StartSafariGame
	return

SafariZone_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event 19, 35, SAFARI_ZONE_LOBBY, 1

	db 0 ; coord events

	db 0 ; bg events

	db 0 ; object events
