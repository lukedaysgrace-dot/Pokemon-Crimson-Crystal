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
	text "<USER> traced"
	line "@"
	text_ram wBattleDynamicNameBuffer
	text "!"
	prompt

IntimidateResistedText:
	text "<TARGET>'s"
	line "@"
	text_ram wBattleDynamicNameBuffer

	text_start
	para "protects it from"
	line "Intimidate!"
	prompt

FriskedItemText:
	text "<USER>"
	line "frisked its foe"

	para "and found a"
	line "@"
	text_ram wBattleDynamicNameBuffer
	text "!"
	prompt

CursedBodyDisabledText:
	text "<TARGET>'s"
	line "@"
	text_ram wBattleDynamicNameBuffer
	text " was"
	cont "DISABLED!"
	prompt

AbilityItemActivatedText:
	text "<USER>'s"
	line "@"
	text_ram wBattleDynamicNameBuffer
	text_start
	cont "activated!"
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

MaxedAttackText:
; Anger Point (printed from the holder's perspective)
	text "<USER>"
	line "maxed its ATTACK!"
	prompt

Hit2TimesText:
; Parental Bond
	text "Hit 2 times!"
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

ToxicDebrisText::
; Toxic Debris (printed from the attacker's perspective)
	text "Toxic Spikes were"
	line "scattered on the"
	cont "ground!"
	prompt

AnticipationShudderText:
	text "<USER>"
	line "shuddered!"
	prompt

ForewarnAlertText:
	text "It was alerted to"
	line "@"
	text_ram wBattleDynamicNameBuffer
	text "!"
	prompt

HarvestedBerryText:
	text "<USER> harvested"
	line "its @"
	text_ram wBattleDynamicNameBuffer
	text "!"
	prompt

AnchorsItselfText:
	text "<TARGET>"
	line "anchors itself!"
	prompt
