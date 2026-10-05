FishingCoveVisitorTextPointers:
	dw FishingCoveLass1Text
	dw FishingCoveCooltrainerF1Text
	dw FishingCoveTeacher1Text
	dw FishingCoveCooltrainerM1Text
	dw FishingCoveLass2Text
	dw FishingCoveCooltrainerF2Text
	dw FishingCoveTeacher2Text
	dw FishingCoveCooltrainerM2Text

FishingContestTextPointers:
; Candidate order matches FishingContestantPointers, without unused index 0.
	dw FishingContestJustinText
	dw FishingContestRalphText
	dw FishingContestArnoldText
	dw FishingContestKyleText
	dw FishingContestWiltonText
	dw FishingContestSamuelText
	dw FishingContestNickText
	dw FishingContestGwenText
	dw FishingContestBarryText
	dw FishingContestCindyText
	dw FishingContestWilliamText
	assert (@ - FishingContestTextPointers) / 2 == NUM_FISHING_CONTEST_CANDIDATES

FishingContestResultTextPointers:
	dw FishingContestJustinResultText
	dw FishingContestRalphResultText
	dw FishingContestArnoldResultText
	dw FishingContestKyleResultText
	dw FishingContestWiltonResultText
	dw FishingContestSamuelResultText
	dw FishingContestNickResultText
	dw FishingContestGwenResultText
	dw FishingContestBarryResultText
	dw FishingContestCindyResultText
	dw FishingContestWilliamResultText
	assert (@ - FishingContestResultTextPointers) / 2 == NUM_FISHING_CONTEST_CANDIDATES

FishingCoveLass1Text:
	text "I came for the"
	line "fresh sea air."
	para "Now I don't want"
	line "to leave!"
	done

FishingCoveCooltrainerF1Text:
	text "I train every day."
	line "Even trainers need"
	cont "a quiet afternoon."
	done

FishingCoveTeacher1Text:
	text "I brought my class"
	line "here once."
	para "They counted every"
	line "boat they saw!"
	done

FishingCoveCooltrainerM1Text:
	text "A calm mind helps"
	line "in battle."
	para "A few minutes here"
	line "always clears it."
	done

FishingCoveLass2Text:
	text "Did you see those"
	line "little ripples?"
	para "I wonder what's"
	line "swimming below..."
	done

FishingCoveCooltrainerF2Text:
	text "I'm taking the"
	line "scenic route."
	para "The GYM can wait"
	line "a little longer."
	done

FishingCoveTeacher2Text:
	text "Some #MON live"
	line "in fresh water."
	para "Others prefer the"
	line "sea. Isn't nature"
	cont "amazing?"
	done

FishingCoveCooltrainerM2Text:
	text "Everyone rushes"
	line "to get stronger."
	para "Sometimes you need"
	line "to slow down, too."
	done

FishingContestJustinText:
	text "Another MAGIKARP!"
	line "Don't laugh!"
	para "A really big one"
	line "could win this!"
	done

FishingContestRalphText:
	text "Cast gently."
	line "Watch the ripples."
	para "You can't rush"
	line "a good catch."
	done

FishingContestArnoldText:
	text "I saw a REMORAID"
	line "dart past my lure."
	para "Come back, little"
	line "one! I'm waiting!"
	done

FishingContestKyleText:
	text "A CORSOLA would"
	line "make my day."
	para "That pink color is"
	line "hard to miss!"
	done

FishingContestWiltonText:
	text "This is my lucky"
	line "fishing spot."
	para "Of course, I say"
	line "that about every"
	cont "spot I try!"
	done

FishingContestSamuelText:
	text "My first Contest!"
	line "I'm so excited!"
	para "Wait... Was that a"
	line "bite or a wave?"
	done

FishingContestNickText:
	text "I can handle tough"
	line "#MON battles."
	para "But waiting for a"
	line "bite? That's hard!"
	done

FishingContestGwenText:
	text "The water is like"
	line "a mirror today."
	para "I'm keeping still"
	line "so I won't scare"
	cont "the fish away."
	done

FishingContestBarryText:
	text "I've fished on"
	line "camping trips."
	para "This time, I want"
	line "more than a story"
	cont "about the big one!"
	done

FishingContestCindyText:
	text "I wore my good"
	line "shoes today."
	para "If I hook a big"
	line "one, I hope it"
	cont "doesn't splash me!"
	done

FishingContestWilliamText:
	text "Rod? Check."
	line "Snacks? Check."
	para "Now I just need"
	line "a fish to notice"
	cont "I'm here!"
	done

FishingContestJustinResultText:
	text "See? MAGIKARP"
	line "deserves a chance!"
	para "I'll keep trying"
	line "for a bigger one."
	done

FishingContestRalphResultText:
	text "What a fine group"
	line "of catches!"
	para "There's always"
	line "something new to"
	cont "learn out here."
	done

FishingContestArnoldResultText:
	text "That fish nearly"
	line "slipped away!"
	para "My hands are still"
	line "shaking a little."
	done

FishingContestKyleResultText:
	text "The Contest flew"
	line "by so quickly!"
	para "Next Friday can't"
	line "come soon enough."
	done

FishingContestWiltonResultText:
	text "I won't blame"
	line "my lucky spot."
	para "Maybe my lucky hat"
	line "needs replacing!"
	done

FishingContestSamuelResultText:
	text "I actually caught"
	line "one all by myself!"
	para "Wait till my"
	line "friends hear this!"
	done

FishingContestNickResultText:
	text "Patience takes"
	line "practice, too."
	para "I might try this"
	line "between battles."
	done

FishingContestGwenResultText:
	text "That was a lovely"
	line "way to spend time."
	para "And we get to keep"
	line "our new #MON!"
	done

FishingContestBarryResultText:
	text "Now that's a catch"
	line "I can brag about!"
	para "No tall tales"
	line "needed this time!"
	done

FishingContestCindyResultText:
	text "My shoes got wet,"
	line "but I had fun!"
	para "Next time I'm"
	line "bringing boots."
	done

FishingContestWilliamResultText:
	text "I finished all my"
	line "snacks too soon."
	para "Next Friday, I'll"
	line "bring more snacks!"
	done
