; Shared campaign checks. No new save flags: derive access from owned badges.
CheckJohtoBadgesScript::
	readmem wJohtoBadges
	ifequal $ff, .Ready
	setval FALSE
	end
.Ready:
	setval TRUE
	end

CheckSurgeBadgeScript::
	readmem wJohtoBadges
	ifnotequal $ff, .NotReady
	checkflag ENGINE_BOULDERBADGE
	iffalse .NotReady
	checkflag ENGINE_CASCADEBADGE
	iffalse .NotReady
	checkflag ENGINE_THUNDERBADGE
	end
.NotReady:
	setval FALSE
	end

CheckSouthernKantoAccessScript::
	readmem wJohtoBadges
	ifnotequal $ff, .NotReady
	checkflag ENGINE_BOULDERBADGE
	iffalse .NotReady
	checkflag ENGINE_CASCADEBADGE
	iffalse .NotReady
	checkflag ENGINE_THUNDERBADGE
	iffalse .NotReady
	checkflag ENGINE_RAINBOWBADGE
	iffalse .NotReady
	checkflag ENGINE_MARSHBADGE
	iffalse .NotReady
	checkflag ENGINE_SOULBADGE
	end
.NotReady:
	setval FALSE
	end

CheckBlueBadgeAccessScript::
	readmem wJohtoBadges
	ifnotequal $ff, .NotReady
	readvar VAR_BADGES
	ifless NUM_BADGES - 1, .NotReady
	setval TRUE
	end
.NotReady:
	setval FALSE
	end

UpdateBlueReturnScript::
; Repair an early return in older saves, without undoing an earned Earth Badge.
	farscall CheckBlueBadgeAccessScript
	iffalse .Waiting
	checkflag ENGINE_EARTHBADGE
	iftrue .Returned
	checkevent EVENT_BLUE_IN_CINNABAR
	iftrue .Returned
.Waiting:
	clearevent EVENT_BLUE_IN_CINNABAR
	setevent EVENT_VIRIDIAN_GYM_BLUE
	end
.Returned:
	setevent EVENT_BLUE_IN_CINNABAR
	clearevent EVENT_VIRIDIAN_GYM_BLUE
	end

QueueOakMtSilverCallScript::
; Whichever final milestone is completed must be able to invite the player.
	checkevent EVENT_OPENED_MT_SILVER
	iftrue .Done
	readvar VAR_BADGES
	ifless NUM_BADGES, .Done
	checkevent EVENT_BEAT_ELITE_FOUR
	iffalse .Done
	checkevent EVENT_BEAT_CLAIR_REMATCH
	iffalse .Done
	specialphonecall SPECIALCALL_OAK_MT_SILVER
.Done:
	end
