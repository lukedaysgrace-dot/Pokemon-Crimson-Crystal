BugContestantPointers:
; there are NUM_BUG_CONTESTANTS + 1 entries
	dw BugContestant_BugCatcherDon ; this reverts back to the player
	dw BugContestant_BugCatcherDon
	dw BugContestant_BugCatcherEd
	dw BugContestant_CooltrainerMNick
	dw BugContestant_PokefanMWilliam
	dw BugContestant_BugCatcherBenny
	dw BugContestant_CamperBarry
	dw BugContestant_PicnickerCindy
	dw BugContestant_BugCatcherJosh
	dw BugContestant_YoungsterSamuel
	dw BugContestant_SchoolboyKipp

; contestant format:
;   db class, id
;   dw 1st-place mon, score
;   dw 2nd-place mon, score
;   dw 3rd-place mon, score

BugContestant_BugCatcherDon:
	db BUG_CATCHER, DON
	dw KAKUNA,     195
	dw METAPOD,    188
	dw CATERPIE,   165

BugContestant_BugCatcherEd:
	db BUG_CATCHER, ED
	dw BUTTERFREE, 218
	dw BUTTERFREE, 205
	dw CATERPIE,   170

BugContestant_CooltrainerMNick:
	db COOLTRAINERM, NICK
	dw SCYTHER,    248
	dw BUTTERFREE, 232
	dw PINSIR,     245

BugContestant_PokefanMWilliam:
	db POKEFANM, WILLIAM
	dw PINSIR,     238
	dw BUTTERFREE, 226
	dw VENONAT,    210

BugContestant_BugCatcherBenny:
	db BUG_CATCHER, BUG_CATCHER_BENNY
	dw BUTTERFREE, 222
	dw WEEDLE,     180
	dw CATERPIE,   168

BugContestant_CamperBarry:
	db CAMPER, BARRY
	dw PINSIR,     244
	dw VENONAT,    215
	dw KAKUNA,     196

BugContestant_PicnickerCindy:
	db PICNICKER, CINDY
	dw BUTTERFREE, 228
	dw METAPOD,    192
	dw CATERPIE,   172

BugContestant_BugCatcherJosh:
	db BUG_CATCHER, JOSH
	dw SCYTHER,    240
	dw BUTTERFREE, 220
	dw METAPOD,    190

BugContestant_YoungsterSamuel:
	db YOUNGSTER, SAMUEL
	dw WEEDLE,     178
	dw PINSIR,     205
	dw CATERPIE,   166

BugContestant_SchoolboyKipp:
	db SCHOOLBOY, KIPP
	dw VENONAT,    208
	dw PARAS,      200
	dw KAKUNA,     186
