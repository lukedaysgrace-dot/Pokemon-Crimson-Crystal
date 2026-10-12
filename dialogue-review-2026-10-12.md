# Dialogue review: added characters — 2026-10-12

**Scope.** Every text block in `maps/`, `data/phone/`, `data/text/` and `engine/events/` was compared
against vanilla Pokémon Crystal (pret/pokecrystal). Of 5,526 blocks, 561 are new or changed, and
all of them were read. This review lists only problems in dialogue for characters
added by Crimson Crystal (plus a short section of display/accuracy bugs found in original characters'
text along the way). No line exceeds the 18-tile text width, and Crystal's 15 phone #DEX tips were
checked against the current encounter tables. All 15 are accurate.

Most of the added dialogue is in good shape after the 10-05 pass. The items below are what's left.

---

## Needs fixing

### 1. Rocket thugs — Riolu event (Goldenrod Underground)
`maps/GoldenrodUnderground.asm:958` `GoldenrodUndergroundThugNoticeText`
- "Guess we'll have to show **em** not to poke their nose…" → missing apostrophe: **'em**.
- Suggested: "Well, what do we have here? / A kid playing hero? / Guess we'll have to teach you to keep your nose out of our business!"

`:1030` `GoldenrodUndergroundGirlThanksText`. This is about 40 lines in one speech, the longest single block of
NPC dialogue added to the game. Suggested trim:
> "Oh, thank you so much! / Those TEAM ROCKET members chased us down here. / RIOLU was my grandma's. He's always been special to me. / But after seeing you stand up for us… / I think Grandma would've trusted you with him, too. / He's brave for his size, and I know you'll protect him. / Would you please take him?"

### 2. Fisher blocking the fishing spot (Route 42)
`maps/Route42.asm:423` `Route42FishingSpotFisherText`. It has run-on sentences and comma splices.
> Current: "Sorry bud, this is my favorite fishing spot and I'm just now setting up. ¶ Come back later, you should go check out the LIGHTHOUSE in OLIVINE. ¶ I heard something's gone wrong there."
> Suggested: "Sorry, bud. This is my favorite fishing spot, and I'm just setting up. ¶ Come back later. ¶ Why not check out the LIGHTHOUSE in OLIVINE? I heard something's wrong there."

### 3. Rocket toll booth (Route 43 Gate)
`maps/Route43Gate.asm:240` `RocketText_TollFee`. "you gonna pay up?" starts a paragraph in lowercase → "**You** gonna pay up?"

### 4. Cooltrainer Chantz (Vermilion City)
`maps/VermilionCity.asm:324 / 335 / 339`. These lines use four-dot ellipses ("SNORLAX....", "anyways....") and three-dot "Oh...",
inconsistent with the game's "…" character, and the grammar is loose.
- Seen: "…SNORLAX…" → "Hey! I was trying to catch that SNORLAX!"
- Beaten: "Oh..." → "Oh…"
- After: "I probably would've never caught it anyways.... ¶ I'm out of here, later." → "I never would've caught it anyway… ¶ I'm out of here. Later!"

### 5. Lass Danielle (Olivine Gym)
`maps/OlivineGym.asm:313`. "Now that JASMINE is back, **us** GYM TRAINERS are on duty again!" → "**we** GYM TRAINERS".

### 6. Aroma Lady Rosie: stale after Amphy is cured (Lighthouse 5F)
`maps/OlivineLighthouse5F.asm:121` `AromaLadyRosieAfterBattleText`. Rosie never leaves the lighthouse, but her line
("Only real medicine will let her shine again") still assumes AMPHY is sick after you've cured her. Either
hide/branch her after the medicine event, or use a line that works both before and after:
> "Herbs can soothe a sick #MON. ¶ But only real medicine can cure one."

### 7. PETREL fake-director reveal (Radio Tower 5F)
`maps/RadioTower5F.asm:206` `FakeDirectorRevealText`. "Remember me kid?" → "Remember me, **kid**?" (missing comma).

### 8. Feebas salesman (Goldenrod Pokémon Center)
`maps/GoldenrodPokecenter1F.asm:827`. "What do you say???" → "What do you say?"
`:874`. "Heheh…sucker. ¶ That thing is worthless, I'm heading to the SLOTS!" (comma splice) →
"Heheh… Sucker! ¶ That thing's worthless. I'm off to the SLOTS!"

### 9. AGATHA and LORELEI (Silver Cave Outside)
`maps/SilverCaveOutside.asm:149` `SilverCaveOutsideAgathaBeforeText`. It's wordy and awkward ("We train here regularly, but if
it's not obvious enough, not many trainers dare to tread here").
> Suggested: "AGATHA: My, my. LORELEI, look who's here. ¶ The JOHTO CHAMPION we've heard so much about. ¶ Few trainers dare to come this far. ¶ Let's see what all the fuss is about, child."

`:193` `SilverCaveOutsideLoreleiBeforeText`. It opens with a double negative ("I can't say I'm not impressed") and the
explanation of why she heals your team runs for nine lines.
> Suggested: "LORELEI: Not many can say they beat AGATHA. ¶ Maybe there's more to you than meets the eye. ¶ But I want a fair fight. ¶ Your #MON should face my ice at full strength."

### 10. CRYSTAL: style consistency
The text is otherwise good. Fix these:
- Three-period "..." instead of the game's "…" character: `VioletCity.asm:389` ("same goal..."), `:425` ("I see..."),
  `IlexForest.asm:1123` ("that..."), `IcePath1F.asm:100 / 116 / 128` ("on...", "...I understand.", "again..."),
  `data/phone/text/crystal.asm:11` ("Hold on...").
- `IcePath1F.asm:100`: "**Blackthorn** is just ahead." → "**BLACKTHORN**" (place names are caps everywhere else).
- `CianwoodCity.asm:532`: "Hmph. Better notes than results." reads oddly → "Hmph. My notes went better than my battle."
- `IlexForest.asm:1130` and `CianwoodCity.asm:527` reuse the same loss line ("My training paid off!"). Optional: vary one.

### 11. Fishing Contest (Olivine Fishing Cove)
- `engine/events/fishing_contest.asm:568`. "Your **BAG** is full." Crystal calls it the **PACK** (the Riolu girl
  correctly says PACK).
- `data/text/fishing_cove.asm:68 / 133`. "below..." / "Wait... Was that" → use "…".
- Optional: the gate text writes "Fishing Contest", "Contest", "min." in mixed case; the game's
  convention is caps for event names (cf. "BUG-CATCHING CONTEST").

### 12. Bug Catcher Rob (Viridian Forest)
`maps/ViridianForest.asm:89`. "Let's battle'em!" → "Let's battle 'em!"

### 13. Rocket Executive PROTON: tone (optional)
`maps/SlowpokeWellB1F.asm:253` ("You haven't stopped a **damn** thing") and `maps/RadioTower4F.asm:191`
("**Damn** it! Not to you!"). Mainline games never use this word. Keep it if the edgier tone is intended; otherwise
"You haven't stopped a thing." / "Blast it! Not to you!". Also `SlowpokeWellB1F.asm:247` ".... Don't look so
pleased" → "…Don't look so pleased".

### 14. GREEN (Route 20): minor
`maps/Route20.asm:168`. "It was **great** meeting you! ¶ Thanks for a **great** battle!" Repeated word; drop one line
or change to "Thanks for the battle!"

---

## Bugs in original characters' text (found during the sweep)

- **Broken ¥ symbol (shows garbage tiles in-game).** The file contains a double-encoded `Â¥` (bytes C3 82 C2 A5)
  instead of `¥`:
  `maps/GoldenrodUnderground.asm:828` (Haircut Brother "¥500"), `:875` (younger brother "¥300"),
  `maps/Route32.asm:614` (SLOWPOKETAIL "¥1,000,000"). Replace `Â¥` with `¥`.
- **Wrong TM count.** `maps/NationalPark.asm:414`: "There are 50 kinds of TMs." Your game has **54**.
