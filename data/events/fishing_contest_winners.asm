FishingContestantPointers:
	dw FishingContestantJustin ; unused index 0
	dw FishingContestantJustin
	dw FishingContestantRalph
	dw FishingContestantArnold
	dw FishingContestantKyle
	dw FishingContestantWilton
	dw FishingContestantSamuel
	dw FishingContestantNick
	dw FishingContestantGwen
	dw FishingContestantBarry
	dw FishingContestantCindy
	dw FishingContestantWilliam
	assert (@ - FishingContestantPointers) / 2 == NUM_FISHING_CONTEST_CANDIDATES + 1

FishingContestantJustin:
	db FISHER, JUSTIN
	dw MAGIKARP, 170
	dw KRABBY,   151
	dw HORSEA,   130

FishingContestantRalph:
	db FISHER, RALPH1
	dw QWILFISH, 177
	dw CHINCHOU, 159
	dw MAGIKARP, 134

FishingContestantArnold:
	db FISHER, ARNOLD
	dw REMORAID, 180
	dw HORSEA,   161
	dw SHELLDER, 143

FishingContestantKyle:
	db FISHER, KYLE
	dw CORSOLA,  175
	dw KRABBY,   157
	dw MAGIKARP, 132

FishingContestantWilton:
	db FISHER, WILTON1
	dw MAREANIE, 178
	dw QWILFISH, 160
	dw SHELLDER, 140

FishingContestantSamuel:
	db YOUNGSTER, SAMUEL
	dw KRABBY,   168
	dw MAGIKARP, 149
	dw HORSEA,   129

FishingContestantNick:
	db COOLTRAINERM, NICK
	dw REMORAID, 179
	dw QWILFISH, 158
	dw CHINCHOU, 139

FishingContestantGwen:
	db COOLTRAINERF, GWEN
	dw CORSOLA,  176
	dw HORSEA,   156
	dw SHELLDER, 137

FishingContestantBarry:
	db CAMPER, BARRY
	dw HORSEA,   171
	dw KRABBY,   153
	dw MAGIKARP, 131

FishingContestantCindy:
	db PICNICKER, CINDY
	dw CHINCHOU, 173
	dw SHELLDER, 155
	dw MAGIKARP, 133

FishingContestantWilliam:
	db POKEFANM, WILLIAM
	dw MAREANIE, 178
	dw QWILFISH, 160
	dw KRABBY,   142
