CrystalPhoneCalleeScript:
	checkevent EVENT_CRYSTAL_CAPE_CALL_PENDING
	iftrue CrystalPhoneCapeCallScript
	scall CrystalPhoneGreeting
	checkevent EVENT_CRYSTAL_CAUGHT_MEW
	iftrue .Mew
	checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE
	iftrue .Cape
	checkevent EVENT_BEAT_CRYSTAL_ICE_PATH
	iftrue .IcePath
	checkevent EVENT_BEAT_CRYSTAL_CIANWOOD_CITY
	iftrue .Cianwood
	checkevent EVENT_BEAT_CRYSTAL_ILEX_FOREST
	iftrue .Ilex
	farwritetext CrystalPhoneStatusVioletText
	buttonsound
	sjump CrystalPhoneTier1Tips

.Ilex
	farwritetext CrystalPhoneStatusIlexText
	buttonsound
	sjump CrystalPhoneTier2Tips

.Cianwood
	farwritetext CrystalPhoneStatusCianwoodText
	buttonsound
	sjump CrystalPhoneTier3Tips

.IcePath
	farwritetext CrystalPhoneStatusIcePathText
	buttonsound
	sjump CrystalPhoneTier4Tips

.Cape
	farwritetext CrystalPhoneStatusCapeText
	buttonsound
	sjump CrystalPhoneTier5Tips

.Mew
	farwritetext CrystalPhoneStatusMewText
	buttonsound
	sjump CrystalPhoneTier5Tips

CrystalPhoneCallerScript:
; The EARTHBADGE call is CRYSTAL summoning the player to the CERULEAN
; coast, so it skips the usual greeting-and-tips routine entirely.
	checkevent EVENT_CRYSTAL_CAPE_CALL_PENDING
	iftrue CrystalPhoneCapeCallScript
	scall CrystalPhoneGreeting
	farwritetext CrystalPhoneReportIntroText
	buttonsound
	checkevent EVENT_BEAT_CRYSTAL_CERULEAN_CAPE
	iftrue CrystalPhoneTier5Tips
	checkevent EVENT_BEAT_CRYSTAL_ICE_PATH
	iftrue CrystalPhoneTier4Tips
	checkevent EVENT_BEAT_CRYSTAL_CIANWOOD_CITY
	iftrue CrystalPhoneTier3Tips
	checkevent EVENT_BEAT_CRYSTAL_ILEX_FOREST
	iftrue CrystalPhoneTier2Tips
	sjump CrystalPhoneTier1Tips

CrystalPhoneCapeCallScript:
; Also reachable from CrystalPhoneCalleeScript and the CountStep special call
; handler, so it clears both halves of the pending state itself.
	farwritetext CrystalPhoneCapeCallText1
	buttonsound
	farwritetext CrystalPhoneCapeCallText2
	clearevent EVENT_CRYSTAL_CAPE_CALL_PENDING
	specialphonecall SPECIALCALL_NONE
	end

CrystalPhoneGreeting:
	checktime MORN
	iftrue .Morn
	checktime DAY
	iftrue .Day
	farwritetext CrystalPhoneNiteGreetingText
	buttonsound
	end

.Morn
	farwritetext CrystalPhoneMornGreetingText
	buttonsound
	end

.Day
	farwritetext CrystalPhoneDayGreetingText
	buttonsound
	end

CrystalPhoneTier1Tips:
	random 3
	ifequal 0, .Route32
	ifequal 1, .Route33
	farwritetext CrystalPhoneTipRoute31Text
	end

.Route32
	farwritetext CrystalPhoneTipRoute32Text
	end

.Route33
	farwritetext CrystalPhoneTipRoute33Text
	end

CrystalPhoneTier2Tips:
	random 3
	ifequal 0, .Route34
	ifequal 1, .Route35
	farwritetext CrystalPhoneTipRoute36Text
	end

.Route34
	farwritetext CrystalPhoneTipRoute34Text
	end

.Route35
	farwritetext CrystalPhoneTipRoute35Text
	end

CrystalPhoneTier3Tips:
	random 3
	ifequal 0, .Route38
	ifequal 1, .Route39
	farwritetext CrystalPhoneTipRoute43Text
	end

.Route38
	farwritetext CrystalPhoneTipRoute38Text
	end

.Route39
	farwritetext CrystalPhoneTipRoute39Text
	end

CrystalPhoneTier4Tips:
	random 3
	ifequal 0, .Route44
	ifequal 1, .Route45
	farwritetext CrystalPhoneTipRoute46Text
	end

.Route44
	farwritetext CrystalPhoneTipRoute44Text
	end

.Route45
	farwritetext CrystalPhoneTipRoute45Text
	end

CrystalPhoneTier5Tips:
	random 3
	ifequal 0, .Route24
	ifequal 1, .Route28
	farwritetext CrystalPhoneTipRoute9Text
	end

.Route24
	farwritetext CrystalPhoneTipRoute24Text
	end

.Route28
	farwritetext CrystalPhoneTipRoute28Text
	end
