	object_const_def ; object_event constants
	const OLIVINELIGHTHOUSE6F_JASMINE
	const OLIVINELIGHTHOUSE6F_AMPY_SICK
	const OLIVINELIGHTHOUSE6F_AMPY_HEALTHY
	const OLIVINELIGHTHOUSE6F_POKE_BALL

OlivineLighthouse6F_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_NEWMAP, .LoadReservedID

.LoadReservedID:
	loadmonindex 1, AMPHAROS
	checkevent EVENT_JASMINE_RETURNED_TO_GYM
	iftrue .ShowHealthyAmphy
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	; Jasmine stays with Amphy. The entrance is always open, and older saves
	; with a completed outdoor handoff can finish the same healing scene here.
	clearevent EVENT_OLIVINE_LIGHTHOUSE_JASMINE
	return

.ShowHealthyAmphy:
	setevent EVENT_OLIVINE_LIGHTHOUSE_JASMINE
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	return

OlivineLighthouseJasmine:
	faceplayer
	opentext
	checkevent EVENT_JASMINE_RECEIVED_SECRETPOTION
	iftrue .HealAmphy
	checkitem SECRETPOTION
	iffalse .MedicineNotDelivered
	farwritetext JasmineCureAmphyText
	yesorno
	iffalse .Declined
	farwritetext PlayerHandedSecretpotionText
	buttonsound
	takeitem SECRETPOTION
	setevent EVENT_JASMINE_RECEIVED_SECRETPOTION
.HealAmphy:
	writetext JasmineDontBeOffendedText
	waitbutton
	closetext
	turnobject OLIVINELIGHTHOUSE6F_JASMINE, RIGHT
	pause 15
	turnobject OLIVINELIGHTHOUSE6F_AMPY_SICK, LEFT
	opentext
	playmusic MUSIC_HEAL
	writetext JasmineAmphyHowAreYouFeelingText
	pause 60
	buttonsound
	closetext
	special RestartMapMusic
	cry AMPHAROS
	special FadeOutPalettes
	disappear OLIVINELIGHTHOUSE6F_AMPY_SICK
	appear OLIVINELIGHTHOUSE6F_AMPY_HEALTHY
	special RefreshSprites
	pause 10
	special FadeInPalettes
	opentext
	writetext AmphyPaluPaluluText
	waitbutton
	closetext
	turnobject OLIVINELIGHTHOUSE6F_AMPY_HEALTHY, RIGHT
	pause 10
	turnobject OLIVINELIGHTHOUSE6F_AMPY_HEALTHY, LEFT
	pause 10
	turnobject OLIVINELIGHTHOUSE6F_AMPY_HEALTHY, RIGHT
	pause 10
	turnobject OLIVINELIGHTHOUSE6F_AMPY_HEALTHY, LEFT
	pause 10
	faceplayer
	opentext
	writetext JasmineThankYouText
	waitbutton
	closetext
	setevent EVENT_JASMINE_RETURNED_TO_GYM
	clearevent EVENT_OLIVINE_GYM_JASMINE
	readvar VAR_FACING
	ifequal DOWN, .FacingDown
	ifequal RIGHT, .FacingRight
	applymovement OLIVINELIGHTHOUSE6F_JASMINE, MovementData_0x60c68
	disappear OLIVINELIGHTHOUSE6F_JASMINE
	end

.FacingDown:
	applymovement OLIVINELIGHTHOUSE6F_JASMINE, MovementData_0x60c70
	disappear OLIVINELIGHTHOUSE6F_JASMINE
	end

.FacingRight:
	applymovement OLIVINELIGHTHOUSE6F_JASMINE, MovementData_0x60c79
	disappear OLIVINELIGHTHOUSE6F_JASMINE
	end

.MedicineNotDelivered:
	sjump OlivineLighthouseJasmineMedicineRequest

.Declined:
	farwritetext JasmineISeeText
	waitbutton
	closetext
	end

OlivineLighthouseJasmineMedicineRequest:
	checkevent EVENT_JASMINE_EXPLAINED_AMPHYS_SICKNESS
	iftrue .ExplainedSickness
	writetext JasmineCianwoodPharmacyText
	waitbutton
	closetext
	setevent EVENT_JASMINE_EXPLAINED_AMPHYS_SICKNESS
	end

.ExplainedSickness:
	writetext JasmineGetSomeMedicineText
	waitbutton
	closetext
	end

OlivineLighthouseUnusedDummyScript:
; unused
	end

OlivineLighthouseAmphy:
	faceplayer
	opentext
	checkevent EVENT_JASMINE_RETURNED_TO_GYM
	iftrue .HealthyNow
	writetext AmphyPalPalooText
	loadmonindex 0, AMPHAROS
	special PlaySlowCry
	buttonsound
	writetext AmphyBreathingLaboredText
	waitbutton
	closetext
	end

.HealthyNow:
	writetext AmphyPaluPaluluText
	cry AMPHAROS
	waitbutton
	closetext
	special FadeOutPalettes
	special FadeInPalettes
	special FadeOutPalettes
	special FadeInPalettes
	end

OlivineLighthouse6FSuperPotion:
	itemball SUPER_POTION

MovementData_0x60c68:
	slow_step UP
	slow_step UP
	slow_step RIGHT
	slow_step UP
	slow_step UP
	step_sleep 8
	step_sleep 8
	step_end

MovementData_0x60c70:
	slow_step DOWN
	slow_step RIGHT
	slow_step RIGHT
	slow_step RIGHT
	slow_step UP
	slow_step RIGHT
	slow_step RIGHT
	slow_step RIGHT
	step_end

MovementData_0x60c79:
	slow_step UP
	slow_step UP
	slow_step RIGHT
	slow_step UP
	slow_step UP
	slow_step UP
	step_sleep 8
	step_end

JasmineCianwoodPharmacyText:
	text "JASMINE: …Oh!"
	line "Hello…"

	para "…I'm sorry to"
	line "trouble you, but…"
	cont "I need your help,"
	cont "and I have no one"
	cont "else to turn to."

	para "The #MON that"
	line "lights this"
	cont "LIGHTHOUSE…"

	para "AMPHY… has become"
	line "terribly ill."

	para "…I'm very worried"
	line "about her…"

	para "I've heard there's"
	line "a wonderful"
	cont "PHARMACY in"
	cont "CIANWOOD CITY that"
	cont "makes special"
	cont "medicine."

	para "…But I can't leave"
	line "AMPHY alone for"
	cont "very long…"

	para "…Would you please"
	line "go to CIANWOOD and"
	cont "bring back some"
	cont "medicine?"

	para "…I'd be ever so"
	line "grateful…"
	done

JasmineGetSomeMedicineText:
	text "JASMINE: …Have you"
	line "been to the"
	cont "PHARMACY in"
	cont "CIANWOOD yet?"

	para "…AMPHY is still"
	line "very sick…"

	para "…Please hurry…"
	done

JasmineCureAmphyText:
	text "JASMINE: …Oh! Is"
	line "that medicine for"
	cont "AMPHY?"
	done

JasmineThankGoodnessText:
	text "JASMINE: …Thank"
	line "goodness!"

	para "…Please, come"
	line "inside!"

	para "Meet me upstairs"
	line "so we can give it"
	cont "to her right away!"
	done

PlayerHandedSecretpotionText:
	text "<PLAYER> handed the"
	line "SECRETPOTION to"
	cont "JASMINE."
	done

JasmineISeeText:
	text "JASMINE: …I see…"
	done

JasmineDontBeOffendedText:
	text "JASMINE: …Um,"
	line "please don't be"
	cont "offended…"

	para "…AMPHY won't take"
	line "medicine from"
	cont "anyone but me…"

	para "…I'll give it to"
	line "her now."
	done

JasmineAmphyHowAreYouFeelingText:
	text "JASMINE: …"

	para "AMPHY, how are you"
	line "feeling?"
	done

JasmineThankYouText:
	text "JASMINE: …Oh, I'm"
	line "so relieved…"

	para "This is just so"
	line "wonderful…"

	para "Thank you so very,"
	line "very much."

	para "…I will return to"
	line "the GYM…"
	done

AmphyPalPalooText:
	text "AMPHY: …"
	line "…Pa… paloo…"
	done

AmphyBreathingLaboredText:
	text "Its breathing is"
	line "terribly labored…"
	done

AmphyPaluPaluluText:
	text "AMPHY: Palu!"
	line "Palulu!"
	done

OlivineLighthouse6F_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event  9, 15, OLIVINE_LIGHTHOUSE_5F, 1
	warp_event 16,  5, OLIVINE_LIGHTHOUSE_5F, 6
	warp_event 17,  5, OLIVINE_LIGHTHOUSE_5F, 7

	db 0 ; coord events

	db 0 ; bg events

	db 4 ; object events
	object_event  8,  8, SPRITE_JASMINE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, OlivineLighthouseJasmine, EVENT_OLIVINE_LIGHTHOUSE_JASMINE
	object_event  9,  8, SPRITE_AMPY_SICK, SPRITEMOVEDATA_SLOW_POKEMON, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, OlivineLighthouseAmphy, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	object_event  9,  8, SPRITE_AMPHAROS, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, OlivineLighthouseAmphy, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	object_event  3,  4, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, OlivineLighthouse6FSuperPotion, EVENT_OLIVINE_LIGHTHOUSE_6F_SUPER_POTION
