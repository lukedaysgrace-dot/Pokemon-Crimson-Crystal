UnusedPhoneScript:
	farwritetext UnusedPhoneText
	end

OakMtSilverPhoneCallerScript:
	farwritetext OakMtSilverPhoneText
	specialphonecall SPECIALCALL_NONE
	end

OakMtSilverPhoneText:
	text "<PLAY_G>! It's"
	line "PROF.OAK."

	para "I heard about your"
	line "LEAGUE victory!"

	para "Please come visit"
	line "me at my LAB."
	done
