INCLUDE "constants.asm"

SECTION "SyntaxCheckA", ROMX
INCLUDE "data/phone/non_trainer_names.asm"
INCLUDE "data/phone/permanent_numbers.asm"
INCLUDE "data/phone/phone_contacts.asm"

SECTION "SyntaxCheckB", ROMX
INCLUDE "engine/phone/scripts/crystal.asm"

SECTION "SyntaxCheckC", ROMX
INCLUDE "data/phone/text/crystal.asm"

SECTION "SyntaxCheckD", ROMX
INCLUDE "maps/VioletCity.asm"
