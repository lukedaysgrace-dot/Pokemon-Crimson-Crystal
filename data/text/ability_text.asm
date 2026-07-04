; Ability battle text, ported from Polished Crystal.

NotifyCloudNineText:
	text "The weather was"
	line "suppressed!"
	prompt

NotifyPressureText:
	text "<USER> is"
	line "exerting its"
	cont "pressure!"
	prompt

NotifyMoldBreakerText:
	text "<USER>"
	line "breaks the mold!"
	prompt

NotifyUnnerveText:
	text "<TARGET> is"
	line "too afraid to eat"
	cont "Berries!"
	prompt

NotifyNeutralizingGasText:
	text "Neutralizing gas"
	line "filled the area!"
	prompt

BecameHealthyText:
	text "<USER>"
	line "became healthy!"
	prompt

NoLongerInfatuatedText:
	text "<USER>'s"
	line "no longer"
	cont "infatuated!"
	prompt

TraceActivationText:
	text "<USER>"
	line "traced"
	cont ""
	text_ram wStringBuffer1
	text "!"
	prompt

IntimidateResistedText:
	text "<TARGET>'s"
	line ""
	text_ram wStringBuffer1

	para "protects it from"
	line "Intimidate!"
	prompt

FriskedItemText:
	text "<USER>"
	line "frisked its foe"

	para "and found a"
	line ""
	text_ram wStringBuffer1
	text "!"
	prompt

IsHurtText:
	text "<USER>"
	line "is hurt!"
	prompt

TormentedText:
; printed with the victim as the turn holder (see BadDreamsAbility)
	text "<USER> is"
	line "tormented!"
	prompt

DisguiseDecoyText::
	text "Its disguise"
	line "served it as"
	cont "a decoy!"
	prompt

DisguiseBustedText::
	text "<USER>'s"
	line "disguise was"
	cont "busted!"
	prompt
