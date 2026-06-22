UnusedPhoneScript:
	farwritetext UnusedPhoneText
	end

OakMtSilverPhoneCallerScript:
	farwritetext OakMtSilverPhoneText
	specialphonecall SPECIALCALL_NONE
	end

OakMtSilverPhoneText:
	text "OAK: <PLAY_G>!"

	para "I heard about your"
	line "LEAGUE rematches."

	para "Please come visit"
	line "me at my LAB."
	done
