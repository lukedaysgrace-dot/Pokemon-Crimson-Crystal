import io, os, sys

ROOT = os.path.expanduser("~/mnt/Pokemon-Crimson-Crystal")

def rd(p):
    with io.open(os.path.join(ROOT, p), "r", encoding="utf-8", newline="") as f:
        return f.read()

def wr(p, s):
    with io.open(os.path.join(ROOT, p), "w", encoding="utf-8", newline="") as f:
        f.write(s)

def sub_once(p, old, new, label):
    s = rd(p)
    if new.strip() and new in s:
        print("SKIP (already applied):", label); return
    n = s.count(old)
    if n != 1:
        print("!! FAIL", label, "-- found", n, "matches"); sys.exit(1)
    wr(p, s.replace(old, new, 1))
    print("ok:", label)

# 1. trainer contact id
sub_once("constants/trainer_constants.asm",
    "\tconst PHONECONTACT_OAK\n",
    "\tconst PHONECONTACT_OAK\n\tconst PHONECONTACT_CRYSTAL\n",
    "trainer_constants: PHONECONTACT_CRYSTAL")

# 2. phone contact index
sub_once("constants/phone_constants.asm",
    "\tconst PHONE_OAK_CALL\n",
    "\tconst PHONE_OAK_CALL\n\tconst PHONE_CRYSTAL\n",
    "phone_constants: PHONE_CRYSTAL")

# 3. reuse the unused Crystal event slot for the phone-number flag
sub_once("constants/event_flags.asm",
    "\tconst EVENT_UNUSED_CRYSTAL_SLOT ; unused (was EVENT_CRYSTAL_TOHJO_FALLS_INITIALIZED)\n",
    "\tconst EVENT_GOT_CRYSTALS_NUMBER ; reused unused slot (was EVENT_CRYSTAL_TOHJO_FALLS_INITIALIZED)\n",
    "event_flags: EVENT_GOT_CRYSTALS_NUMBER")

# 4. caller name shown in the phone textbox / Pokegear list
sub_once("data/phone/non_trainer_names.asm",
    "\tdw .oak\n",
    "\tdw .oak\n\tdw .crystal\n",
    "non_trainer_names: pointer")
sub_once("data/phone/non_trainer_names.asm",
    '.oak:      db "PROF.OAK:@"\n',
    '.oak:      db "PROF.OAK:@"\n.crystal:  db "CRYSTAL:@"\n',
    "non_trainer_names: string")

# 5. permanent number (guarantees a free slot, cannot be deleted)
sub_once("data/phone/permanent_numbers.asm",
    "\tdb -1 ; end\n",
    "\tdb PHONECONTACT_CRYSTAL\n\tdb -1 ; end\n",
    "permanent_numbers: CRYSTAL")

# 6. the contact entry itself
sub_once("data/phone/phone_contacts.asm",
    "\tphone TRAINER_NONE, PHONECONTACT_OAK,      OAKS_LAB,                  0,       UnusedPhoneScript,        0,       OakMtSilverPhoneCallerScript\n",
    "\tphone TRAINER_NONE, PHONECONTACT_OAK,      OAKS_LAB,                  0,       UnusedPhoneScript,        0,       OakMtSilverPhoneCallerScript\n"
    "\tphone TRAINER_NONE, PHONECONTACT_CRYSTAL,  N_A,                       ANYTIME, CrystalPhoneCalleeScript, ANYTIME, CrystalPhoneCallerScript\n",
    "phone_contacts: CRYSTAL entry")

# 7. make her number undeletable
sub_once("engine/phone/phone.asm",
    "\tcp PHONECONTACT_ELM\n\tret z\n\tld c, $1\n\tret\n",
    "\tcp PHONECONTACT_ELM\n\tret z\n\tcp PHONECONTACT_CRYSTAL\n\tret z\n\tld c, $1\n\tret\n",
    "phone.asm: CheckCanDeletePhoneNumber")

# 8. includes
sub_once("main.asm",
    '\nINCLUDE "engine/phone/scripts/elm.asm"\n',
    '\nINCLUDE "engine/phone/scripts/elm.asm"\nINCLUDE "engine/phone/scripts/crystal.asm"\n',
    "main.asm: script include")
sub_once("main.asm",
    '\nINCLUDE "data/phone/text/erin_overworld.asm"\n',
    '\nINCLUDE "data/phone/text/erin_overworld.asm"\nINCLUDE "data/phone/text/crystal.asm"\n',
    "main.asm: text include")

# 9. Violet City: hand over the number after the post-battle dialogue
sub_once("maps/VioletCity.asm",
    "\twritetext VioletCityCrystalAfterText\n"
    "\twaitbutton\n"
    "\tclosetext\n"
    "\tsetevent EVENT_BEAT_CRYSTAL_VIOLET_CITY\n",
    "\twritetext VioletCityCrystalAfterText\n"
    "\tbuttonsound\n"
    "\twritetext VioletCityCrystalNumberText\n"
    "\tbuttonsound\n"
    "\twritetext VioletCityCrystalRegisteredText\n"
    "\tplaysound SFX_REGISTER_PHONE_NUMBER\n"
    "\twaitsfx\n"
    "\tbuttonsound\n"
    "\taddcellnum PHONE_CRYSTAL\n"
    "\tsetevent EVENT_GOT_CRYSTALS_NUMBER\n"
    "\twritetext VioletCityCrystalCallMeText\n"
    "\twaitbutton\n"
    "\tclosetext\n"
    "\tsetevent EVENT_BEAT_CRYSTAL_VIOLET_CITY\n",
    "VioletCity.asm: number handoff script")

NEW_TEXT = '''
VioletCityCrystalNumberText:
\ttext "One more thing."

\tpara "Give me your"
\tline "#GEAR number."

\tpara "If I turn up any-"
\tline "thing worth"
\tcont "knowing, you'll"
\tcont "hear about it."
\tdone

VioletCityCrystalRegisteredText:
\ttext "<PLAYER> recorded"
\tline "CRYSTAL's number."
\tdone

VioletCityCrystalCallMeText:
\ttext "Call any time."

\tpara "I'm usually out"
\tline "in the field, so"
\tcont "don't worry about"
\tcont "the hour."

\tpara "See you down the"
\tline "road, <PLAY_G>."
\tdone

VioletCity_MapEvents:
'''

sub_once("maps/VioletCity.asm",
    "\nVioletCity_MapEvents:\n",
    NEW_TEXT,
    "VioletCity.asm: new text")

print("ALL EDITS DONE")
