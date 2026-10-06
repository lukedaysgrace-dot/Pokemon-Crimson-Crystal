# Crimson Crystal dialogue review — October 5, 2026

The additions need a focused editing pass, especially Crystal's longer scenes. Most ordinary trainers are serviceable, and several additions have good character. The strongest problems are inaccurate gameplay information, repeated speeches, and incidental lines that invent relationships or backstory.

The editing pass below has now been implemented: 117 dialogue blocks across 44 assembly files. Crystal's encounters and Mew finale are shorter, Rocket executives and other rivals have clearer voices, and repetitive trainer and rematch lines have been revised. Incorrect gameplay guidance, missing-rematch promises, outdated place names, grammar and text-width problems have been corrected. Event scripts, teams and rewards are unchanged.

**Intentional exception:** The crypt still mentions a red-haired boy defacing graves and taking offerings, implying Silver. You confirmed that this is intended. The advice is shorter, and the reminder still refers to the boy. Recommendation 15 below is retained as part of the original review, not an outstanding change request.

The rest of this document preserves the original audit and its coverage inventory. Quoted old dialogue, proposed wording and line numbers describe the pre-edit version; current text is identified by the same assembly labels.

**Validation after editing:** Release and debug ROMs built successfully. All 117 edited text blocks ran through the ROM's text interpreter in an in-memory emulator; 381 input pauses and every final page were checked for border overflow using seven-character player names. All 738 source lines fit the 18-tile text area. The 10 portrait coverage tests passed, and a comparison with the pre-edit files confirmed that only text bodies changed in the 44 assembly files. Input and presentation waits were skipped for the renderer check; this was not a full playthrough of the events.

## Scope and method

Compared current tracked assembly with the repository's starting commit, `72e1270b` ("the main game"), then read the added or changed map, phone, and event dialogue. The extraction identified 498 dialogue segments across 95 files; this includes split text fragments, signs, and short system responses, so it is not a count of conversations. I also checked reused dialogue for renamed trainer classes, the relocated Viridian Forest trainers, named Rocket executives, and Silver's relocated final challenge. Script branches, parties, encounter tables, and relevant move definitions were used to check claims.

This was a source review. I did not play through the scenes in an emulator. Layout findings below are based on the source's 18-character text area, not screenshots. The comparison uses your repository's starting version, not a separately downloaded retail Crystal baseline. Ability descriptions and general battle messages were outside the narrative editing scope.

Source locations below are repository-relative, with one-based line numbers at the reviewed version.

## Changes I would make first

### 1. Remove Miho's unsolicited dojo affiliation

**Location:** [maps/Route7.asm:61](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route7.asm:61), `BattleGirlMihoSeenText`; also `:77`, her follow-up.

"The DOJO in SAFFRON is shut while the master's away training. So we train out here instead" makes Miho and Aya students of that dojo. Being Battle Girls does not establish that relationship. It is plausible within the setting, but it adds the specific backstory you said you did not want. Her follow-up about a closed door reinforces it.

Suggested opening: "MIHO and I train out here together. Let's see how you keep up!"

Suggested follow-up: "AYA never lets me skip a day of training!"

**Clarification about the Karate King:** None of the four current Battle Girls explicitly says "KARATE KING." Miho refers to the absent dojo master indirectly. The literal reference on the ship is Blackbelt Wai's text at [maps/FastShipB1F.asm:373](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:373), which is inherited from the starting version and still belongs to a Blackbelt. The other literal references are in Fighting Dojo, Saffron Gym, and Mount Mortar. I would remove Miho's affiliation rather than indiscriminately remove the existing Karate King dialogue.

### 2. Aya promises a rematch that does not exist

**Location:** [maps/Route7.asm:94](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route7.asm:94), `BattleGirlAyaAfterBattleText`.

"Come back when you want a rematch" directs the player toward a feature her trainer script does not support. After the first victory she only repeats her follow-up text.

Suggested replacement: "MIHO and I train here every day. Next time, I'll be the one keeping up!" Alternatively, implement a rematch if one is actually intended.

### 3. Erika describes the wrong move

**Location:** [maps/CeladonGym.asm:158](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonGym.asm:158), `ErikaExplainTMText`.

Energy Ball does not drain half the damage dealt. Your move table gives it a Special Defense lowering effect, 90 power, and a 10% secondary-effect chance ([data/moves/moves.asm:331](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/moves/moves.asm:331)). This is leftover Giga Drain explanation attached to the new TM.

Suggested replacement: "It is ENERGY BALL. It may lower the foe's SPECIAL DEFENSE. Please use it if it pleases you…"

### 4. Chuck incorrectly says Drain Punch never misses

**Location:** [maps/CianwoodGym.asm:234](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodGym.asm:234), `ChuckExplainTMText`.

The healing description is correct. "It never misses" is leftover DynamicPunch dialogue: your Drain Punch has ordinary 100 accuracy and a draining effect ([data/moves/moves.asm:315](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/moves/moves.asm:315)), not guaranteed-hit behavior.

Suggested replacement: "That is DRAIN PUNCH. A good punch gives you strength! It restores half the damage you deal."

### 5. Crystal sends players looking for nonexistent Route 34 Eevee

**Location:** [data/phone/text/crystal.asm:163](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/crystal.asm:163), `CrystalPhoneTipRoute34Text`.

The morning Route 34 table has Smeargle in its rare slot, not Eevee. Eevee is absent from that route's morning, day, and night grass tables. This is particularly damaging because Crystal says she is reporting researched observations.

Suggested replacement: "Check ROUTE 34 in the morning. SMEARGLE are rare, but I found one there. It tried to sketch my notes!"

### 6. Other phone tips need small factual corrections

| Location | Problem | Recommendation |
| --- | --- | --- |
| [data/phone/text/crystal.asm:149](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/crystal.asm:149) | "PIKACHU … only showed during the day" implies a day-only encounter, but Route 33 has Pikachu in both morning and day slots. | Say "Look during the morning or day." |
| [data/phone/text/crystal.asm:190](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/crystal.asm:190) | "By midmorning, they're gone" suggests a precise cutoff. Route 36 Shroomish occupy the normal morning period and also appear at night. | Say "Try morning or night. I haven't found them during the day." |
| [data/phone/text/crystal.asm:293](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/crystal.asm:293) | "Early in the day" is vague for Route 9 Rhyhorn, which occupy the morning table and not the day table. | Use "in the morning." |
| [data/phone/text/crystal.asm:307](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/crystal.asm:307) | The Kadabra tip promises immediate TELEPORT and only one chance. Route 24's Kadabra are level 61; their latest learned moves are FUTURE SIGHT, SUBSTITUTE, TRICK, and CALM MIND. TELEPORT is a level-1 move they have displaced. | Keep the correct morning/location tip; replace the escape advice with "They're rare. Don't mistake one for an ABRA!" |

The other reviewed location/time tips match the tables: Route 31 Ledyba, Route 32 Wooper, Route 35 Drowzee, Route 38 Girafarig, Route 39 Miltank, Route 43 Murkrow, Route 45 Donphan, Route 46 Houndour, and the Safari Zone Chansey/Kangaskhan tips. The latter two labels still contain old route numbers, but their displayed locations have been updated correctly.

### 7. Mew's escape ending suggests another opportunity that the event does not provide

**Location:** [data/text/route25_cape.asm:217](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/text/route25_cape.asm:217), `Route25CrystalMewEscapedText`; event state in [maps/Route25.asm:28](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:28) and `:310`.

"I'll keep looking into it. If MEW shows up again… we'll be ready" sounds like a future encounter or phone follow-up. The current script records the escape permanently and hides Mew on later visits. This includes an uncaught outcome after running or knocking it out.

If that permanent outcome is intentional, close the scene without implying another playable attempt: "We know it's real now. That's more than we knew before. I'll send OAK our notes."

The line can remain if you plan a real second opportunity; the writing and event behavior need to agree.

### 8. Fix the old area name on Route 37

**Location:** [maps/Route37.asm:241](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route37.asm:241), `Route37SilentCryptSignText`.

The sign still reads "SILENT HOLLOW." The current map is Silent Crypt. Change the displayed name to "SILENT CRYPT" unless Hollow is deliberately a larger area containing the crypt; nothing in this sign explains that distinction.

### 9. Rob blames a Pokémon he does not have

**Location:** [maps/ViridianForest.asm:94](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianForest.asm:94), `BugCatcherRobBeatenText`; party at [data/trainers/parties.asm:3149](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3149).

"CATERPIE can't cut it!" clashes with his current Galvantula/Yanmega team. This is reused early-game-style dialogue in a much stronger encounter.

Suggested replacement: "Even my best bugs couldn't stop you!"

Ed's "You can't jam out if you're a #MON trainer" ([maps/ViridianForest.asm:106](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianForest.asm:106)) also reads awkwardly. "You can't sneak past a BUG CATCHER!" is clearer. Doug's broken "I / give!" (`:129`) should be "I give! You're good at this!"

### 10. Fix Devin's broken sentence

**Location:** [maps/VictoryRoad.asm:227](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:227), `TamerDevinAfterBattleText`.

"A strong #MON needs trust too. as discipline." is visibly unfinished.

Suggested replacement: "A strong #MON needs trust as well as discipline."

### 11. Reflow three lines that exceed the text area's width

The renderer writes characters directly, and the main text area is 18 characters wide. These source lines reach 19 characters, including the four-character expansion of `#` to "POKé":

| Location | Line to reflow | Suggested wording |
| --- | --- | --- |
| [maps/IcePath1F.asm:107](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IcePath1F.asm:107) | "I've spent the last" | "I've been studying" / "#MON all across" / "JOHTO." |
| [maps/OlivineFishingCoveGate.asm:265](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineFishingCoveGate.asm:265) | "your first #MON." | "Put a #MON" / "first in your" / "party." |
| [maps/RuinsOfAlphFossilLab.asm:252](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RuinsOfAlphFossilLab.asm:252) | "Show me what you're" | "Show me a fossil" / "and I'll restore" / "it!" |

These need source reflow and a visual check when implemented.

## Major writing revisions

### 12. Give Crystal a consistent voice and shorten her battle speeches

**Locations:** [maps/VioletCity.asm:388](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletCity.asm:388); [maps/IlexForest.asm:1100](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IlexForest.asm:1100); [maps/CianwoodCity.asm:504](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodCity.asm:504); [maps/IcePath1F.asm:99](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IcePath1F.asm:99); [data/text/route25_cape.asm:5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/text/route25_cape.asm:5).

Crystal's phone dialogue establishes a useful voice: observant, busy, dryly funny, and a little too direct. "I lost two pens," "ICE PATH froze my ink," and the apology after ordering the player to give her their number have character.

Her battle scenes repeatedly reset to a generic friendly rival: "I've been training," "we've both improved," "you taught me something," and "next time I'll be ready." She explains these ideas at length rather than reacting to the particular place or encounter.

The explicit paragraph groups illustrate the pacing: Violet's opening has 11; Cianwood's has 16; Ice Path's has 15; Mew's opening has 23, and its catch ending has 32. Lines marked `cont` add scrolling as well. These counts are not exact screen counts, but they show how much interaction occurs before the player can resume.

I would aim for roughly 3–5 paragraph groups before an ordinary rival battle, leaving more room for the introduction and finale. Give each meeting one new character beat:

| Meeting | What it should accomplish | Example direction |
| --- | --- | --- |
| Violet | Introduce the research job and her competitive curiosity. | "I'm CRYSTAL. ELM said you were helping with the #DEX. Let's see how well you know your team!" |
| Ilex | Show her distracted by fieldwork, with a concrete discovery or joke. | "I've checked so many trees, I'm starting to recognize the branches. Your team looks rested. Mine could use a battle!" |
| Cianwood | Show her balancing research and training rather than explaining that balance repeatedly. | "My notes are soaked. My team is ready. Let's see if all that work paid off!" |
| Ice Path | Show confidence and determination before Blackthorn. | "BLACKTHORN's ahead. Before we go, I want one more battle. I've been saving this team for you!" |
| Cape | Let the unusual discovery briefly break her composure. | "Quiet. That's MEW. I've checked twice. …I'm trying not to shout. One battle. Winner gets the first try." |

These are proposed directions, not finished assembly replacements. Preserve her research focus and competitive edge; avoid turning every speech into praise for the player.

Violet also treats a battle as a complete measure of Pokédex progress: "A battle should tell me everything I need to know." Use "I want to see how you work with your team" so her research goal and reason for battling connect naturally.

### 13. Keep the Mew finale's emotional point, cut its repetition

**Location:** [data/text/route25_cape.asm:123](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/text/route25_cape.asm:123), `Route25CrystalMewCaughtText`.

The useful payoff is that Crystal admits the rivalry helped her grow, while remaining slightly annoyed. "It was incredibly annoying. But I wouldn't change it" is worth keeping. The scene spends many paragraphs arriving there and then repeatedly says goodbye.

A tighter version could be:

> You actually caught MEW. Let me see your #DEX!
>
> …There it is. OAK is going to have questions.
>
> When we started, I only thought about filling the #DEX. Then you kept beating me.
>
> It was incredibly annoying. But it made me better.
>
> Take care of MEW, <PLAYER>. And call me when you find something impossible again.

The pre-battle text can also lose the catalogue of "size, movement, markings… Everything," the repeated silence, and the repeated declaration that Mew is real. Her urge to shout is a better indication of excitement than a scientific checklist.

### 14. Rewrite the motivation for giving away Riolu

**Location:** [maps/GoldenrodUnderground.asm:1029](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUnderground.asm:1029), `GoldenrodUndergroundGirlThanksText`.

She has just fought to keep her grandmother's treasured Riolu, then offers it to a stranger because the stranger won battles. "You'll protect him better than I can" makes the rescue seem to prove she should surrender him. The scene can work, but the handoff needs a positive reason beyond fear and gratitude.

It also retells the shops, chase, cornering, and theft attempt that the player just witnessed. Cut that recap.

Suggested direction:

> Thank you! I thought they'd take him.
>
> RIOLU was my grandma's partner. He's brave, but I can't give him the training he needs.
>
> After seeing your team, I think he'd be happy traveling with you. Would you take him?

If desired, an existing emote or a short reaction from Riolu could make his participation in the choice clearer. This is a story recommendation, not a claim that the current event is logically impossible. The decline response is already decent because it lets her keep him.

Also change "show em" to "show 'em" at `:968`. Keep the basic Rocket demands and Tony's orders; they are functional villain dialogue.

### 15. Remove the implication that Silver vandalized graves unless you specifically want that

**Location:** [maps/SilentCrypt.asm:287](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilentCrypt.asm:287), `SilentCryptGrannyAdviceText`.

The "red-haired boy" who sullied graves and stole offerings strongly reads as Silver. It does not explicitly name him, but it gives a recognizable rival a new act of cruelty outside his existing encounters. It may undermine the intended progression toward caring about his Pokémon, especially for players who enter later.

If that was not an intentional addition, replace it with an unnamed visitor: "Someone dirtied those stones and took the offerings." Keep the cleaning task and the gravekeeper's initial distrust.

### 16. Route 42's fisherman feels like a script gate speaking

**Location:** [maps/Route42.asm:422](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route42.asm:422), `Route42FishingSpotFisherText`.

"This is my favorite fishing spot and I'm just now setting up. Come back later" does not convincingly explain stopping the player from proceeding. The script removes him only after Jasmine is beaten, so waiting does not help. He also conveniently sends the player directly to the next required story location.

I would give the obstruction an understandable reason, or simply shorten the exchange so the artificiality is less noticeable. Any stronger reason should match an actual event or visible map obstruction. Avoid inventing a dangerous condition or official closure solely in the dialogue unless you also want that story detail.

## Smaller changes worth making

| Area and source | Assessment | Recommendation |
| --- | --- | --- |
| Proton, [maps/SlowpokeWellB1F.asm:225](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SlowpokeWellB1F.asm:225) | "I am often labeled" and "I'd strongly urge you" are stiff for an intimidating Rocket. | "I'm PROTON. You picked the wrong place to play hero!" gives him an introduction and a direct threat. |
| Proton's return, [maps/RadioTower4F.asm:169](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower4F.asm:169) | He now has a named identity, but still uses the old anonymous executive's "fortress" routine. | Add a short recognition of the Slowpoke Well loss: "You again! I haven't forgotten the WELL." |
| Petrel, Ariana, Archer; [maps/TeamRocketBaseB3F.asm:393](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB3F.asm:393), [maps/TeamRocketBaseB2F.asm:560](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TeamRocketBaseB2F.asm:560), [maps/RadioTower5F.asm:240](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower5F.asm:240), `:271` | Much of their dialogue remains inherited anonymous-executive text. It generally fits the events, but the new identities have little personality. | Optional pass: Petrel can be evasive, Ariana commanding, Archer focused on Giovanni. Introduce their names briefly; no new conspiracy or backstory is necessary. |
| Green, [maps/Route20.asm:132](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route20.asm:132), `:167` | Both speeches mostly praise the player for beating Red and point toward Blue. Green feels like a messenger for the next boss. | Shorten the opening and give her one confident or playful reaction to losing. Retain the useful explicit Cinnabar hint. |
| Blue rematch, [maps/CinnabarIsland.asm:148](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CinnabarIsland.asm:148), `:199` | His disappointment and admission that the player was better work. The 11-paragraph opening repeats that he wants a rematch and has reviewed his loss. | Keep "I've gone over that battle more times than I'd admit"; cut several adjacent statements. Replace "in the area" with "PALLET TOWN" if you want a clear lead to Red. |
| Silver final challenge, [maps/IndigoPlateauPokecenter1F.asm:217](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IndigoPlateauPokecenter1F.asm:217) | Existing Crystal text is used at the new rematch-stage timing. "My super-well-trained #MON are going to pound you" sounds earlier in his arc. | Optional placement-aware rewrite: "My partners and I have trained for this. Let's see how far we've come." Keep some of his pride and bluntness. |
| Agatha/Lorelei, [maps/SilverCaveOutside.asm:148](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilverCaveOutside.asm:148), `:192` | Good choice of encounters, but both give extended versions of "you're impressive, let's battle." "If it's not obvious enough" is clumsy. | Agatha: "Few trainers come this far. Let's see if you belong here." Lorelei: "You beat AGATHA. Impressive. I'll heal your team first—I want your best." Her healing is supported by the script. |
| Seafoam Gym, [maps/SeafoamGym.asm:218](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SeafoamGym.asm:218) | "Only the hottest #MON survive here" can sound as though Blaine's training kills Pokémon. | "Only the toughest teams keep up with BLAINE." The other fire jokes are ordinary Pokémon-style banter and can stay. |
| Nugget challenge, [maps/Route25.asm:746](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:746), `:777`, `:809` | "Strength, style and support" is vague, while four challengers repeat "I did my best. I have no regrets." The repetition is inherited, but weakens the newly varied cast. | Give Nadia a specific school/group-project remark; give Noelle and Silas short class-specific follow-ups. Keep the five-trainer numbering: it matches the revised challenge. |
| New Kimono Girls, [maps/DanceTheatre.asm:279](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DanceTheatre.asm:279), `:300`, `:321` | All three largely say they like dancing with Pokémon. Yumi's ribbons are the most distinctive detail. | Keep Yumi; use season, ice, or leaf imagery for Fuyu/Hana tied to their Eeveelutions. One detail each is enough. |
| New Victory Road trainers, [maps/VictoryRoad.asm:249](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:249), `:266`, `:282`, `:298` | Kira, Mina, Adrian, and Selene are mostly generic discipline, focus, trust, and power slogans. | Optional polish: give one a tired cave-travel observation, one a competitive boast, one a concrete team tactic. They do not all need philosophical advice. |
| School Girl Kim, [maps/Route35.asm:344](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:344) | KIRLIA helping her read expressions in "battles and exams" suggests using psychic help to cheat, perhaps unintentionally. | Keep if that mischievous implication is wanted; otherwise use "battles and class presentations." |
| Goldenrod rooftop couple, [maps/GoldenrodDeptStoreRoof.asm:166](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodDeptStoreRoof.asm:166) | "PRYCE … was just a boy when we retired" gives this newly invented couple a striking age/history claim. | "We knew PRYCE when he was still making a name for himself" keeps the joke without that specific chronology. |
| Gravekeeper gift, [maps/GravekeepersHouse.asm:122](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GravekeepersHouse.asm:122) | "It was pinned to a coat I buried" can make the reward sound taken from a burial, beside a quest condemning theft from graves. | Clarify ownership if that discomfort is unintended: "I've kept this old pin for years. Take it." Keep the unsettling wording if the ambiguity is intentional. |
| Gravekeeper conclusion, [maps/GravekeepersHouse.asm:134](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GravekeepersHouse.asm:134) | "Kids as good as you … gives an old man hope" becomes a generic sentimental ending after a distinct, terse character introduction. | "You did right by them. Thank you. Safe travels." preserves his voice. |
| Crystal research status, [data/phone/text/crystal.asm:43](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/crystal.asm:43) | "OAK wants sixty new entries" invents a precise assignment that the rest of the reviewed story does not establish. | Keep only if this quota is intentional. Otherwise: "OAK is waiting for my next report." |
| Entei/Ho-Oh lore, [maps/TinTower1F.asm:321](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TinTower1F.asm:321), `:514` | The converted Suicune dialogue asserts that Entei's mystic power summons Ho-Oh and that Unown share a cooperative bond with Entei. These are substantial claims attached to the species swap. | Keep only if that is intended custom lore. Softer wording can describe Eusine's speculation: "Seeing ENTEI makes me wonder whether HO-OH will return." |
| Skateboard, [maps/GoldenrodBikeShop.asm:135](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodBikeShop.asm:135) | "You can ride them anywhere" conflicts with indoor and water restrictions in `SkateboardFunction`. The inherited introduction also repeatedly promises a bicycle before offering the board. | Say "Great for getting around town!" and offer "a BICYCLE or SKATEBOARD" earlier in the conversation. |
| Normal difficulty, [data/text/common_2.asm:692](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/text/common_2.asm:692) | "Classic #MON rules" is vague given the separate modern/custom rule choices. | "Switch freely. Use items in battle." describes the choice itself. This is interface wording rather than character dialogue. |

## Dialogue I would mostly keep

- **Route 18 Tamers:** Cole's "They take dares," Jax's "You just hold on," and the brief loss reactions have distinct personality. Their references fit the actual teams. Much better than making each trainer explain trust and discipline.
- **Silent Crypt trainers:** Odessa's "Sssh. You'll wake them. …Too late," Lilith's warmth remark, and Bethany's unnamed voice give the place a coherent eerie mood. Bethany's deepest nameless grave is a larger supernatural story hook; decide whether you want that implication, but it is effective atmosphere rather than an obvious writing failure.
- **Crystal's short phone jokes:** Trees looking suspicious, soaked notes/boots, frozen ink, and stolen pens. Keep the voice; correct the encounter guidance.
- **Fishing Cove contestants:** Wilton's lucky spots/hat and Cindy's shoes/boots have good small payoffs. The visitors fit a quiet recreational area. The rules are fairly clear, and a large Magikarp really can beat a poorer rare catch under the current score calculation. No need to rewrite every fisher into a battle challenge.
- **Safari visitors:** The visual descriptions of regional Pokémon help players notice what makes the preserve different. The admission rules are understandable. Minor polishing is optional.
- **Fossil Lab:** Clear, brief purpose and usable hints. Fix the long source line; no major rewrite needed.
- **School Girls Debra, Sharon, Heidi, and Edna:** Sea currents, the art club, fossils, and ghost stories distinguish them and generally fit their teams. Hope's computing/luck joke is also acceptable.
- **Cosplayers Daisy, Mimi, Pearl, and Pixie:** Light costume jokes work for their class. They do not need deeper backstory. Noelle would benefit from a line that acknowledges the class because hers are reused generic challenge text.
- **Olivine's new Lasses:** The steel-related jokes are simple but appropriate. Elise is generic, but not bad enough to demand a rewrite.
- **Shiver Isle and Route 44 winter trainers:** Brief and appropriately themed. Spencer acknowledges that his current slope has no snow, which avoids an obvious location mismatch.
- **Gym rematch routing:** Leaders pointing toward the next leader is useful and mostly consistent with the sequence. Trim repeated "JOHTO CHAMPION" congratulations and redundant challenge questions when convenient; do not lose the route guidance.
- **Red in Pallet:** Keep his silence. His new encounter does not need a speech to justify its significance. Blue can provide the lead-in.
- **Finizen, legendary birds, Raikou, Suicune, and Relic Clock:** Short cries or object descriptions fit these events. Some optional setup could improve discovery, but they do not contain bad speeches needing replacement.

## Bird-island discovery could use one better clue

The Elemental Sphere is obtained after Lugia, while the statue on Route 19 only describes a hole for "something" ([maps/Route19.asm:370](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route19.asm:370)). This is sparse for connecting two distant places.

One explicit clue—on the item, statue, or an appropriate NPC—would help. For example, "A hollow sphere rests between three carved birds" makes the statue's shape suggest the item without inventing a named ancient order, a guardian, or a new myth. If the deliberate exploration puzzle is already clear visually, keep the minimal text.

## Recommended editing order

1. Correct gameplay claims, outdated names, the missing rematch promise, broken grammar, and long lines.
2. Remove incidental backstory you do not want: Miho's dojo affiliation and the recognizable red-haired grave vandal are the clearest cases.
3. Rewrite Crystal's battles as a progression with one new beat per encounter; retain her stronger phone voice.
4. Tighten the Mew finale and make its uncaught ending honest about the event's permanence.
5. Make the Riolu handoff feel like a positive choice rather than compensation for its owner's helplessness.
6. Polish the boss introductions and repetitive trainer follow-ups. Keep ordinary short jokes that already work.

Every suggested replacement should be split into the game's 18-character lines and checked in context when applied. The examples here describe the wording and tone; they are not ready-to-paste assembly.

## Coverage inventory

The table records all 95 files containing extracted added or changed narrative dialogue. Counts include text fragments and signs. An entry here does not mean its dialogue needs changing; the recommendations above identify the actual concerns. Reused Rocket and Silver dialogue was checked in addition to this list.

| Source | Added/changed segments |
| --- | ---: |
| [data/phone/text/bike_shop.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/bike_shop.asm) | 1 |
| [data/phone/text/crystal.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/crystal.asm) | 24 |
| [data/phone/text/crystal_cape_call.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/crystal_cape_call.asm) | 2 |
| [data/text/fishing_cove.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/text/fishing_cove.asm) | 30 |
| [data/text/route25_cape.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/text/route25_cape.asm) | 5 |
| [engine/phone/scripts/unused.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/phone/scripts/unused.asm) | 1 |
| [maps/AzaleaGym.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/AzaleaGym.asm) | 2 |
| [maps/BattleTower1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BattleTower1F.asm) | 4 |
| [maps/BlackthornCity.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornCity.asm) | 1 |
| [maps/BlackthornGym1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym1F.asm) | 3 |
| [maps/BurnedTower1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BurnedTower1F.asm) | 6 |
| [maps/BurnedTowerB1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BurnedTowerB1F.asm) | 1 |
| [maps/CeladonGym.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonGym.asm) | 4 |
| [maps/CeladonPokecenter1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonPokecenter1F.asm) | 1 |
| [maps/CherrygroveCity.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CherrygroveCity.asm) | 1 |
| [maps/CianwoodCity.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodCity.asm) | 8 |
| [maps/CianwoodGym.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodGym.asm) | 3 |
| [maps/CinnabarIsland.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CinnabarIsland.asm) | 3 |
| [maps/DanceTheatre.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DanceTheatre.asm) | 9 |
| [maps/DiglettsCave.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DiglettsCave.asm) | 1 |
| [maps/DragonShrine.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DragonShrine.asm) | 3 |
| [maps/DragonsDenB1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DragonsDenB1F.asm) | 2 |
| [maps/EcruteakCity.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakCity.asm) | 4 |
| [maps/EcruteakGym.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakGym.asm) | 2 |
| [maps/ElmsLab.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ElmsLab.asm) | 9 |
| [maps/FastShipB1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm) | 3 |
| [maps/FireIsland.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FireIsland.asm) | 1 |
| [maps/GoldenrodBikeShop.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodBikeShop.asm) | 4 |
| [maps/GoldenrodDeptStoreRoof.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodDeptStoreRoof.asm) | 3 |
| [maps/GoldenrodGym.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm) | 2 |
| [maps/GoldenrodPPSpeechHouse.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodPPSpeechHouse.asm) | 2 |
| [maps/GoldenrodPokecenter1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodPokecenter1F.asm) | 7 |
| [maps/GoldenrodUnderground.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodUnderground.asm) | 22 |
| [maps/GravekeepersHouse.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GravekeepersHouse.asm) | 5 |
| [maps/IceIsland.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IceIsland.asm) | 1 |
| [maps/IcePath1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IcePath1F.asm) | 4 |
| [maps/IlexForest.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IlexForest.asm) | 7 |
| [maps/LakeOfRage.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LakeOfRage.asm) | 1 |
| [maps/LakeOfRageHiddenPowerHouse.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LakeOfRageHiddenPowerHouse.asm) | 9 |
| [maps/LancesRoom.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LancesRoom.asm) | 2 |
| [maps/MahoganyGym.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MahoganyGym.asm) | 3 |
| [maps/MahoganyTown.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MahoganyTown.asm) | 2 |
| [maps/MoveDeletersHouse.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MoveDeletersHouse.asm) | 4 |
| [maps/MrPsychicsHouse.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MrPsychicsHouse.asm) | 1 |
| [maps/OlivineCity.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineCity.asm) | 1 |
| [maps/OlivineFishingCoveGate.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineFishingCoveGate.asm) | 17 |
| [maps/OlivineGym.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineGym.asm) | 14 |
| [maps/PalletTown.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/PalletTown.asm) | 3 |
| [maps/Route16.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route16.asm) | 2 |
| [maps/Route18.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route18.asm) | 9 |
| [maps/Route19.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route19.asm) | 4 |
| [maps/Route2.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route2.asm) | 1 |
| [maps/Route20.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route20.asm) | 3 |
| [maps/Route23.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route23.asm) | 1 |
| [maps/Route25.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm) | 10 |
| [maps/Route3.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route3.asm) | 6 |
| [maps/Route31.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route31.asm) | 1 |
| [maps/Route32.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm) | 1 |
| [maps/Route35.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm) | 3 |
| [maps/Route37.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route37.asm) | 1 |
| [maps/Route38.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm) | 1 |
| [maps/Route39Farmhouse.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route39Farmhouse.asm) | 1 |
| [maps/Route4.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route4.asm) | 12 |
| [maps/Route41.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route41.asm) | 3 |
| [maps/Route42.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route42.asm) | 1 |
| [maps/Route44.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm) | 6 |
| [maps/Route7.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route7.asm) | 6 |
| [maps/Route9.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route9.asm) | 12 |
| [maps/RuinsOfAlphAerodactylWordRoom.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RuinsOfAlphAerodactylWordRoom.asm) | 4 |
| [maps/RuinsOfAlphFossilLab.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RuinsOfAlphFossilLab.asm) | 10 |
| [maps/RuinsOfAlphHoOhWordRoom.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RuinsOfAlphHoOhWordRoom.asm) | 4 |
| [maps/RuinsOfAlphKabutoWordRoom.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RuinsOfAlphKabutoWordRoom.asm) | 4 |
| [maps/RuinsOfAlphOmanyteWordRoom.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RuinsOfAlphOmanyteWordRoom.asm) | 3 |
| [maps/RuinsOfAlphOutside.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RuinsOfAlphOutside.asm) | 1 |
| [maps/SafariZoneLobby.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SafariZoneLobby.asm) | 14 |
| [maps/SeafoamGym.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SeafoamGym.asm) | 12 |
| [maps/ShiverIsle.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ShiverIsle.asm) | 9 |
| [maps/SilentCrypt.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilentCrypt.asm) | 18 |
| [maps/SilverCaveOutside.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilverCaveOutside.asm) | 7 |
| [maps/SilverCaveRoom2.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilverCaveRoom2.asm) | 1 |
| [maps/SlowpokeWellB1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SlowpokeWellB1F.asm) | 3 |
| [maps/ThunderIsland.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ThunderIsland.asm) | 1 |
| [maps/TinTower1F.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TinTower1F.asm) | 3 |
| [maps/TohjoFalls.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TohjoFalls.asm) | 1 |
| [maps/VermilionCity.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionCity.asm) | 4 |
| [maps/VictoryRoad.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm) | 18 |
| [maps/VioletCity.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletCity.asm) | 7 |
| [maps/VioletGym.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletGym.asm) | 2 |
| [maps/ViridianCity.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianCity.asm) | 2 |
| [maps/ViridianForest.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianForest.asm) | 17 |
| [maps/ViridianForestNorthGate.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianForestNorthGate.asm) | 2 |
| [maps/ViridianForestSouthGate.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianForestSouthGate.asm) | 2 |
| [maps/ViridianGym.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianGym.asm) | 10 |
| [maps/WhirlIslandLugiaChamber.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/WhirlIslandLugiaChamber.asm) | 1 |
| [maps/WiseTriosRoom.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/WiseTriosRoom.asm) | 6 |
