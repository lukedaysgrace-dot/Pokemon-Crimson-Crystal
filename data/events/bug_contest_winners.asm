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
;
; ComputeAIContestantScores picks one of the three rows at uniform random and
; adds 0-15, so these are three possible results for that trainer, not a ranking
; they work through. They must still descend within a row, or the "1st" row
; stops meaning anything.
;
; Tuned against ContestScore's 250-point ceiling: a top contestant lands near
; 175-180, so a perfect common (180) is a coin flip and any well-grown rare
; wins outright. Samuel's best result is deliberately a huge CATERPIE -- hearing
; the announcer read that out teaches the scoring rule better than an NPC can.

BugContestant_BugCatcherDon:
	db BUG_CATCHER, DON
	dw METAPOD,    152
	dw CATERPIE,   138
	dw WEEDLE,     119

BugContestant_BugCatcherEd:
	db BUG_CATCHER, ED
	dw BUTTERFREE, 168
	dw KAKUNA,     149
	dw CATERPIE,   127

BugContestant_CooltrainerMNick:
	db COOLTRAINERM, NICK
	dw SCYTHER,    178
	dw PINSIR,     172
	dw BUTTERFREE, 160

BugContestant_PokefanMWilliam:
	db POKEFANM, WILLIAM
	dw PINSIR,     170
	dw VENONAT,    158
	dw PARAS,      144

BugContestant_BugCatcherBenny:
	db BUG_CATCHER, BUG_CATCHER_BENNY
	dw BUTTERFREE, 165
	dw WEEDLE,     141
	dw CATERPIE,   125

BugContestant_CamperBarry:
	db CAMPER, BARRY
	dw PINSIR,     175
	dw BEEDRILL,   166
	dw KAKUNA,     147

BugContestant_PicnickerCindy:
	db PICNICKER, CINDY
	dw BUTTERFREE, 169
	dw METAPOD,    153
	dw CATERPIE,   132

BugContestant_BugCatcherJosh:
	db BUG_CATCHER, JOSH
	dw SCYTHER,    173
	dw BUTTERFREE, 162
	dw METAPOD,    148

BugContestant_YoungsterSamuel:
	db YOUNGSTER, SAMUEL
	dw CATERPIE,   171
	dw WEEDLE,     135
	dw KAKUNA,     121

BugContestant_SchoolboyKipp:
	db SCHOOLBOY, KIPP
	dw VENONAT,    161
	dw PARAS,      156
	dw CATERPIE,   130
