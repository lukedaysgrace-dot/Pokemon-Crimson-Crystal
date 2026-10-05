	object_const_def
	const OLIVINEFISHINGCOVE_BOAT1
	const OLIVINEFISHINGCOVE_BOAT2
	const OLIVINEFISHINGCOVE_BOAT3
	const OLIVINEFISHINGCOVE_CONTESTANT1
	const OLIVINEFISHINGCOVE_CONTESTANT2
	const OLIVINEFISHINGCOVE_CONTESTANT3
	const OLIVINEFISHINGCOVE_CONTESTANT4
	const OLIVINEFISHINGCOVE_CONTESTANT5
	const OLIVINEFISHINGCOVE_VISITOR1
	const OLIVINEFISHINGCOVE_VISITOR2
	const OLIVINEFISHINGCOVE_VISITOR3

OlivineFishingCove_MapScripts:
	db 0 ; scene scripts
	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .Visitors
.Visitors:
	checkflag ENGINE_FISHING_CONTEST
	iffalse .RegularDay
	checkflag ENGINE_BUG_CONTEST_TIMER
	iffalse .RegularDay
	disappear OLIVINEFISHINGCOVE_VISITOR1
	disappear OLIVINEFISHINGCOVE_VISITOR2
	disappear OLIVINEFISHINGCOVE_VISITOR3
	return
.RegularDay:
	appear OLIVINEFISHINGCOVE_VISITOR1
	appear OLIVINEFISHINGCOVE_VISITOR2
	appear OLIVINEFISHINGCOVE_VISITOR3
	return

OlivineFishingCoveContestantScript:
	faceplayer
	opentext
	checkflag ENGINE_FISHING_CONTEST
	iffalse .Visitor
	checkflag ENGINE_BUG_CONTEST_TIMER
	iffalse .Visitor
	writetext OlivineFishingCoveContestantText
	waitbutton
	closetext
	end
.Visitor:
	writetext OlivineFishingCoveVisitorText
	waitbutton
	closetext
	end

OlivineFishingCoveVisitorScript:
	jumptextfaceplayer OlivineFishingCoveVisitorText

OlivineFishingCoveContestantText:
	text "Shh! I think I've"
	line "got a bite!"
	para "I hope this catch"
	line "wins the Contest!"
	done

OlivineFishingCoveVisitorText:
	text "The water is so"
	line "peaceful here."
	para "It's a lovely"
	line "place to relax!"
	done

OlivineFishingCoveSign:
	jumptext OlivineFishingCoveSignText

OlivineFishingCoveSignText:
	text "OLIVINE"
	line "FISHING COVE"
	done

OlivineFishingCove_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 19, 33, OLIVINE_FISHING_COVE_GATE, 1
	warp_event 20, 33, OLIVINE_FISHING_COVE_GATE, 2

	db 0 ; coord events

	db 1 ; bg events
	bg_event 24, 30, BGEVENT_READ, OlivineFishingCoveSign

	db 11 ; object events
	object_event  8,  7, SPRITE_FISHING_BOAT, SPRITEMOVEDATA_FISHING_BOAT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
	object_event 26, 12, SPRITE_FISHING_BOAT, SPRITEMOVEDATA_FISHING_BOAT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
	object_event 15, 21, SPRITE_FISHING_BOAT, SPRITEMOVEDATA_FISHING_BOAT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
; These five slots use the saved contest roster, or regular visitors otherwise.
	object_event  6, 26, SPRITE_LASS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveContestantScript, -1
	object_event 12, 26, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveContestantScript, -1
	object_event 18, 26, SPRITE_TEACHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveContestantScript, -1
	object_event 26, 26, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveContestantScript, -1
	object_event 33, 26, SPRITE_LASS, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveContestantScript, -1
; Additional spectators enjoy the cove only while a contest isn't running.
	object_event 10, 29, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveVisitorScript, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	object_event 22, 30, SPRITE_TEACHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveVisitorScript, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	object_event 32, 29, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, OlivineFishingCoveVisitorScript, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
