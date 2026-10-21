# Trainer thematic review — third pass

**Implemented:** all six findings have been addressed. [See the applied fixes](trainer-theme-fixes-round3.md) and [current rosters](trainer-theme-coverage.md). The review below preserves the pre-change evidence.

Reviewed 20 October 2026 after both implementation passes. **The original review snapshot is retained below; subsequent Pokémon fixes are linked above.**

**Scope:** fresh inventory of all **594 authored parties / 1,819 Pokémon slots / 87 populated groups**, all **378 ordinary trainer-dialogue records**, the custom battle/text context across **68 maps**, rematches, starter branches, the 35 named special-trainer families below, and the existing 70 Battle Tower identities/shared pools. Actual local types, moves, abilities and encounter tables were used. “Map reference” means a direct source selection; it does not prove a path is reachable in a particular save.

**Result:** six new findings: one presented-team field-technique mismatch, one shared functional moveset issue, and four supported character/setting refinements. Together they concern 15 party records, including two stored records with no direct map reference. There is no new Gym Leader/Elite Four/rival species replacement that I recommend. The known phone issues from round two are listed separately and are not counted again.

[Current complete roster checklist](trainer-theme-coverage.md) · [Second-pass implemented changes](trainer-theme-fixes-round2.md) · [Earlier phone findings](trainer-theme-audit-round2.md#finding-3)

| # | Priority | Trainer / issue | Preferred response |
|---|---|---|---|
| [1](#finding-1) | A | Wayne — Headbutt story without a compatible partner | Pineco with explicit Headbutt; retain Sizzlipede. |
| [2](#finding-2) | A | Dream Eater remains unsupported in ten other party records | Sleep support or a replacement move; keep the species. |
| [3](#finding-3) | B | Boarder Spencer — snow boast without snow-setting | Snow Warning on Abomasnow. |
| [4](#finding-4) | B | Kelly — gentle tactics paired with Reckless recoil offense | Controlled moves instead of Reckless Double-Edge/itemless Acrobatics. |
| [5](#finding-5) | B | Adrian — one hole in the “move for every type” lesson | Bulldoze on Ampharos. |
| [6](#finding-6) | B | Raymond — the other Lake of Rage fishing scene | Optional local Magikarp; weigh the difficulty loss. |

A identifies a concrete technique/data issue. B identifies a supported improvement with a defensible interpretation of the existing design; it is not a compulsory roster purge.

<a id="finding-1"></a>

## 1. [A] Wayne — Headbutt story without a compatible partner

Wayne says an unfamiliar Pokémon fell from a tree “when I used HEADBUTT” and plans to try the technique elsewhere. His current Sizzlipede 18 and Venipede 18 neither know Headbutt nor have access to it through this game’s level-up, TM, egg or tutor sources. Their actual automatic moves were checked in the ROM. The bugs fit his class; the missing field-technique partner is the mismatch. An unseen boxed helper is possible, so this is a mismatch with the presented team rather than a claim about every Pokémon he could own.

**Suggested response:** Replace Venipede with Pineco 18 and author Headbutt / Pin Missile / Rapid Spin / Protect. Retain Sizzlipede and its current moves explicitly if the party is converted to TRAINERTYPE_MOVES. Heracross 18 with Headbutt / Aerial Ace / Bug Bite / Low Kick is another legal thematic option, but is a larger power increase. Merely swapping to an automatic-moves Pineco does not suffice: its level-18 automatic set also omits Headbutt.

**Current parties:**
- [WAYNE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3545) — Ilex Forest — Sizzlipede 18, Venipede 18.

**Evidence:** [maps/IlexForest.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IlexForest.asm:1087); [data/pokemon/base_stats/sizzlipede.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/sizzlipede.asm:21); [data/pokemon/base_stats/venipede.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/venipede.asm:21); [data/pokemon/base_stats/pineco.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/pineco.asm:21).

<a id="finding-2"></a>

## 2. [A] Dream Eater remains unsupported in ten other party records

The Eusine fix is correct, but the same moveset issue occurs elsewhere: eleven Pokémon in ten stored parties carry Dream Eater, and none of those teams has a selected move that puts the opponent to sleep. The complete effective sets, including normal-format automatic moves, were checked against the built ROM. Dream Eater checks the target’s sleep status in this engine. These slots therefore depend on the player bringing a sleeping Pokémon, using Rest, or otherwise providing sleep; they do not function against an ordinary awake opponent. This is primarily a battle-set issue, not evidence that the species is wrong for its trainer. Eight parties have direct map references; JOE and NAOKO1 are stored without one.

**Suggested response:** Keep the species and give the dream users legal sleep support, or replace Dream Eater with a reliable attack. The per-party recommendations below preserve class identity. No current Gym Leader, Elite Four member, rival or Rocket executive has this unsupported-Dream-Eater problem. Do not fix the underlying player learnsets just to change one NPC’s last-four automatic moves; author trainer sets where needed.

**Current parties:**
- [JOE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1430) — Route 25 — Exeggutor 52, Mesmeria 52.
- [CHAD4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1609) — Route 38 — Espeon 74, Electrode 72, Scizor 73, Xatu 72.
- [JOSE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1746) — Route 27 — Farfetch'd 58, Honchkrow 58, Skarmory 58, Noctowl 58.
- [FIDEL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5234) — Route 11 — Noctowl 56, Alakazam 58, Espathra 60.
- [JARED](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5316) — Saffron Gym — Noctowl 60, Exeggutor 60, Slowbro 60.
- [RODNEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5329) — Fast Ship Cabins_SE_SSE_Captains Cabin — Gardevoir 55, Mr. Rime 55, Noctowl 59.
- [NAOKO1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6241) — Dance Theatre (rematch) — Espeon 54, Sylveon 56, Flareon 56.
- [GRUNTF_7](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7398) — Radio Tower 2F — Gengar 40, Overqwil 40, Arbok 40.
- [GRUNTF_8](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7408) — Radio Tower 3F — Gengar 38, Weezing 38.
- [GRUNTF_9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7416) — Radio Tower 3F — Ariados 39, Gengar 39.

**Evidence:** [engine/battle/effect_commands.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/effect_commands.asm:2039); [engine/battle/ai/redundant.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/ai/redundant.asm:214); [data/pokemon/evos_attacks_johto.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:438); [data/pokemon/evos_attacks_kanto.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:2506).

| Party | Affected Pokémon | Source status | Species-preserving correction |
|---|---|---|---|
| [JOE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1430) | Exeggutor 52 | Stored; no direct map reference | Replace Dream Eater with Psychic, or give Exeggutor Sleep Powder. |
| [CHAD4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1609) | Espeon 74; Xatu 72 | Direct map reference | Replace both Dream Eaters with Psychic. Espeon can alternatively use its legal Yawn; Xatu cannot learn Hypnosis here. |
| [JOSE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1746) | Noctowl 58 | Direct map reference | Give Noctowl Hypnosis over Future Sight, retaining Dream Eater, Hurricane and Roost. |
| [FIDEL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5234) | Noctowl 56 | Direct map reference | Hypnosis over Psychic makes Dream Eater self-supported; alternatively replace Dream Eater. |
| [JARED](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5316) | Noctowl 60 | Direct map reference | Hypnosis over Psychic, retaining Dream Eater, Hurricane and Roost. |
| [RODNEY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5329) | Noctowl 59 | Direct map reference | Hypnosis over Psychic, retaining Dream Eater, Hurricane and Roost. |
| [NAOKO1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6241) | Espeon 54 | Stored; no direct map reference | Replace Dream Eater with Psychic, or add Yawn. This is stored data with no direct map reference. |
| [GRUNTF_7](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7398) | Gengar 40 | Direct map reference | Dream Eater → Shadow Ball gives it Ghost STAB while preserving its Poison/trap role. |
| [GRUNTF_8](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7408) | Gengar 38 | Direct map reference | Toxic Spikes → Hypnosis supports Dream Eater; alternatively Dream Eater → another legal coverage move. |
| [GRUNTF_9](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7416) | Gengar 39 | Direct map reference | Toxic Spikes → Hypnosis supports Dream Eater; alternatively Dream Eater → another legal coverage move. |

**Eight directly referenced records / nine affected Pokémon; two stored records / two affected Pokémon.** Every teammate was checked, not just the individual Dream Eater user. Player-driven sleep or a reflected sleep move remains an external possibility, rather than team-authored support.

<a id="finding-3"></a>

## 3. [B] Boarder Spencer — snow boast without snow-setting

He says the slope has no snow, but his Pokémon “bring it.” Abomasnow is exactly the right species for that image, yet the Boarder class’s default ability slot gives it Soundproof. Neither its actual set (Giga Drain / Swords Dance / Mist / Freeze-Dry) nor either teammate supplies Hail or Snow Warning. Mist is a separate battle effect and does not start hail. Ice attacks still make the line plausible as playful imagery; this is an opportunity to demonstrate the precise weather concept.

**Suggested response:** Keep all three species and levels. Give Spencer’s Abomasnow ABILITY_1 (Snow Warning), preserving its other moves. That requires an explicit ability format for the party; supply the other two partners’ existing slot-2 choices as well so their abilities do not change accidentally.

**Current parties:**
- [BOARDER_SPENCER](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6071) — Route 44 — Abomasnow 40, Piloswine 41, Weavile 41.

**Evidence:** [maps/Route44.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:525); [data/trainers/dvs.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/dvs.asm:61); [data/pokemon/base_stats/abomasnow.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/abomasnow.asm:15); [home/abilities.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/home/abilities.asm:1).

<a id="finding-4"></a>

## 4. [B] Kelly — gentle tactics paired with Reckless recoil offense

Kelly says she dislikes overly powerful moves and does not want to harm Pokémon. Her Rhydon has Double-Edge and the class-default Reckless ability, actively emphasizing stronger recoil damage. Talonflame carries Acrobatics with no item, so the local damage routine doubles its listed 55 power to 110. Rhydon is the clearest personal-style conflict. Leaf Blade, Moonblast and ordinary attacking moves are not automatically forbidden by her personality, and no species replacement is needed.

**Suggested response:** Replace Rhydon’s Double-Edge with Headbutt and consider Rock Tomb over Rock Slide for a more controlled speed-manipulation style. Replace Talonflame’s Acrobatics with Roost, keeping Aerial Ace / Flame Charge / Agility. All proposed moves are legal here. If authoring explicit abilities too, avoid retaining Reckless solely as an unused bonus after removing its recoil move.

**Current parties:**
- [KELLY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2556) — Route 45 — Talonflame 42, Rhydon 42, Sirfetch'd 42, Togetic 43.

**Evidence:** [maps/Route45.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:539); [data/pokemon/base_stats/rhydon.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/rhydon.asm:15); [data/moves/moves.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/moves/moves.asm:58); [engine/battle/move_effects/new_move_cores.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/move_effects/new_move_cores.asm:199).

<a id="finding-5"></a>

## 5. [B] Adrian — one hole in the “move for every type” lesson

He introduces himself as keeping a move ready for every type, then complains that he could not find the player’s weak point. His team has super-effective coverage against seventeen of the eighteen ordinary single types, but no Ground attack for pure Electric. Ampharos’s Hidden Ability is Galvanize, so Hyper Voice DOES count as Electric coverage; this was included in the check. He can still hit Electric neutrally, so this is a small teaching/precision improvement, not proof that his broad boast is literally impossible.

**Suggested response:** Keep the roster. Ampharos can learn Bulldoze from the local technical tutors; putting it over Power Gem closes the Electric gap while the remaining team still covers the other seventeen types. Dig is also legal, but Bulldoze better expresses immediate tactical coverage. Do not assume Ampharos learns Earth Power here.

**Current parties:**
- [ADRIAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2459) — Victory Road — Scizor 67, Kingdra 68, Ampharos 69, Alakazam 70.

**Evidence:** [maps/VictoryRoad.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:286); [data/pokemon/base_stats/ampharos.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/ampharos.asm:15); [data/pokemon/technical_tutor.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/technical_tutor.asm:4998); [data/types/type_matchups.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/types/type_matchups.asm:61).

<a id="finding-6"></a>

## 6. [B] Raymond — the other Lake of Rage fishing scene

Raymond complains that he only catches the same Pokémon and cannot catch anything good, while his sole partner is Seaking 37. Lake of Rage’s fishing group, including both timed slots, produces only Magikarp and Gyarados; neither Goldeen nor Seaking is present. The surf table also lacks them. This is weaker than a literal “I just caught this here” contradiction: he could have brought Seaking from another lake. It is nevertheless the same local-scene consistency issue that prompted Andre’s earlier change.

**Suggested response:** For the clearest comic unsuccessful-angler theme, use Magikarp 37. If retaining a serious opponent is more important, keep Seaking and accept that it came from elsewhere; Gyarados 37 fits the location but makes the complaint about catching nothing good less convincing. A Magikarp swap would materially reduce this battle’s difficulty, so it should be a deliberate choice.

**Current parties:**
- [RAYMOND](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3624) — Lake Of Rage — Seaking 37.

**Evidence:** [maps/LakeOfRage.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LakeOfRage.asm:395); [data/maps/maps.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/maps/maps.asm:240); [data/wild/fish.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/wild/fish.asm:135); [data/wild/fish.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/wild/fish.asm:336); [data/wild/johto_water.asm](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/wild/johto_water.asm:217).

## Special trainers — complete recheck

| Character / family | Current verdict | Authored records checked |
|---|---|---|
| Falkner | Keep. Bird identity and inherited partners remain clear. | 2; [FALKNER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:20) |
| Whitney | Keep. Lopunny now continues Buneary; the other Normal favorites still fit. | 2; [WHITNEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:76) |
| Bugsy | Keep. Insect researcher; Scyther actually demonstrates Fury Cutter in the first fight. | 2; [BUGSY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:137) |
| Morty | Keep. Ghost/mystic collection; no missing advertised status technique. | 2; [MORTY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:193) |
| Chuck | Keep. Fighting discipline and punches; the first team already demonstrates Drain Punch through Breloom. | 2; [CHUCK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:391) |
| Jasmine | Keep. Steel specialist and Steelix continuity; no new species conflict. | 2; [JASMINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:325) |
| Pryce | Keep. Winter specialist with real Snow Warning, freezing attacks and Ice offense. | 2; [PRYCE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:254) |
| Clair | Keep. All actual local Dragon types, including modified Flygon and Altaria. | 2; [CLAIR1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:457) |
| Brock | Keep. Bastiodon strengthens defense while retaining varied fossil/geology partners. | 1; [BROCK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1027) |
| Misty | Keep. Water specialist with recognizable Starmie and strong aquatic partners. | 1; [MISTY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1064) |
| Lt. Surge | Keep. Electric specialist; Raichu’s Galvanize attacks count as Electric. | 1; [LT_SURGE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1101) |
| Erika | Keep. Grass/botany theme; rain-supported Ludicolo is a valid botanical partner. | 1; [ERIKA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1182) |
| Janine | Keep. Poison ninja with traps, sleep, poison and deceptive techniques. | 1; [JANINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2082) |
| Sabrina | Keep. Psychic identity; both Dream Eater users have their own sleep move. | 1; [SABRINA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3302) |
| Blaine | Keep. Fire/volcano theme and burn techniques are represented. | 1; [BLAINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4635) |
| Blue | Keep. Generalist teams; changed rematch strategy is explicitly established. | 2; [BLUE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6504) |
| Will | Keep. All Psychic; the varied world-trained collection fits his introduction. | 2; [WILL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:530) |
| Koga | Keep. Both fights now have sleep. Initial confusion comes from Poison Puppeteer; rematch confusion from Crobat. | 2; [KOGA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:885) |
| Bruno | Keep. Physical Fighting discipline; current species and techniques fit. | 2; [BRUNO1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:744) |
| Karen | Keep. Dark favorites with a wild, tough image; no beauty-only rule. | 2; [KAREN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:814) |
| Lance | Keep. Dragon master with signature Dragonite; all current species fit. | 2; [LANCE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:956) |
| Silver | Keep. All 21 variants checked. Zubat/Golbat continuity and final Crobat give the trust arc a visible payoff. Mount Moon occurs before Victory Road in this game, so the 49 → 68 level progression is coherent. | 21; [RIVAL1_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7480) |
| Crystal | Keep. All 15 variants checked. Marowak now returns at the Cape; Xatu and the custom legal apple branches retain continuity. Xatu supplies capture-relevant paralysis. | 15; [CRYSTAL_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8052) |
| Red | Keep. Both generalist/iconic collections fit; Galvanize keeps Pikachu’s Normal-named attacks Electric. | 2; [RED1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6467) |
| Green | Keep. Seasoned mixed-team challenger; no source-imposed monotype restriction. | 1; [GREEN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7167) |
| Agatha | Keep. Ghost/Poison veteran collection; Haunter has Hypnosis for Dream Eater, and the unevolved partners are deliberate favorites. | 1; [AGATHA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7019) |
| Lorelei | Keep. Glaceon fits the nonlegendary option; Slowbro now demonstrates Ice Beam. No further replacement needed. | 1; [LORELEI1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7056) |
| Eusine | Keep. The rematch now has Hypnosis on both Hypno and Gengar; the dream-hunter technique works. | 2; [EUSINE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6583) |
| Ariana | Keep. Milotic now remains across both fights; the elegant/dangerous core and new Toxapex fit. | 2; [ARIANA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6700) |
| Archer | Keep. Krookodile sharpens intimidation and command-team identity in both stored variants. | 2; [ARCHER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6756) |
| Proton | Keep. Clawed, bullying and disruptive partners fit his threats. | 2; [PROTON1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6624) |
| Petrel | Keep. Both identities retain Ditto and the disguise/artificial/deceptive collection. | 2; [PETREL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6670) |
| Kiyo | Keep. His variety of Fighting Pokémon directly supports the dojo-master introduction. | 1; [KARATE_KIYO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8662) |
| Li | Keep. Plant growth and bond-testing theme; selected Poison Puppeteer is intentional. | 1; [LI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8430) |
| Cal | Keep. Generalist training opponent and starter scaling fit. Runtime Mystery Gift data can replace the CAL2 placeholder. | 6; [CAL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:601) |

The Wise Trio also retain their coherent Fire/Electric/Water cores and spiritual birds. The Kimono Girls retain the Eevee-family dance motif. Naoko’s stored Dream Eater move issue above does not make her Eeveelutions thematically wrong.

## Deliberately rejected candidates

- **Edmond without Bellsprout:** he says he tried to copy Bellsprout’s movements, not that he owns one. His Grass/plant and spiritual partners remain appropriate for Sprout Tower. Adding Bellsprout would be optional flavor, not a new defect.
- **Carter naming unevolved Kanto starters:** his Blastoise/Charizard/Venusaur team visibly continues those same three families. The wording can describe the starter trio generally; it does not justify de-evolving a late-game team.
- **Jaime’s Route 39 Meowth story:** Route 39 actually contains Meowth at night, at the same level as her partner. This was checked against the encounter table and is consistent.
- **Greg and Ronald’s status boasts:** Greg already has Hypnosis. Ronald’s actual Jynx set contains Ice Beam and Freeze-Dry, so his team can freeze; Delibird also has Hail.
- **Tanya’s botany lesson:** Leafeon, Breloom and Abomasnow each have an actual selected Grass move.
- **Cody and Cara’s non-Dragon parties:** their dialogue explicitly explains that their master has not yet permitted Dragon partners. Seadra, Gyarados and Aerodactyl are appropriate foreshadowing.
- **Empty second ability slots:** the game falls back to slot 1. Kelly’s Talonflame therefore has Flame Body, not an unusable “no ability”; the same fallback applies to Heidi’s Alolan Ninetales. Spencer’s Soundproof is a real occupied second slot, so it does not fall back to Snow Warning.
- **Assault Vest users:** a full source check found no selected status move being blocked by Assault Vest in the current authored fixed teams.
- **Battle Tower identities:** still intentionally draw shared generated teams. A random off-class combination is not a newly discovered personal roster defect.

## Known outstanding issues, not counted as new

These were explicitly excluded from the last mon-only implementation: Beverly’s Snubbull/Granbull wording, RandomPhoneMon omitting optional ability bytes for Wilton/Kenji, and generic calls drawing stale starting-party names across 19 caller families. They remain documented in [round two, findings 3–5](trainer-theme-audit-round2.md#finding-3). No new dialogue edit is proposed for a main character.

## All 87 populated groups — third-pass coverage

Every current party in each group was re-inventoried. This table reports new third-pass findings only; the full current roster remains in the linked checklist.

| Group | Parties | Slots | Third-pass result |
|---|---:|---:|---|
| FalknerGroup | 2 | 9 | No additional worthwhile thematic change identified |
| WhitneyGroup | 2 | 10 | No additional worthwhile thematic change identified |
| BugsyGroup | 2 | 9 | No additional worthwhile thematic change identified |
| MortyGroup | 2 | 10 | No additional worthwhile thematic change identified |
| PryceGroup | 2 | 12 | No additional worthwhile thematic change identified |
| JasmineGroup | 2 | 11 | No additional worthwhile thematic change identified |
| ChuckGroup | 2 | 11 | No additional worthwhile thematic change identified |
| ClairGroup | 2 | 12 | No additional worthwhile thematic change identified |
| WillGroup | 2 | 12 | No additional worthwhile thematic change identified |
| PKMNTrainerGroup | 6 | 24 | No additional worthwhile thematic change identified |
| BrunoGroup | 2 | 12 | No additional worthwhile thematic change identified |
| KarenGroup | 2 | 12 | No additional worthwhile thematic change identified |
| KogaGroup | 2 | 12 | No additional worthwhile thematic change identified |
| ChampionGroup | 2 | 12 | No additional worthwhile thematic change identified |
| BrockGroup | 1 | 6 | No additional worthwhile thematic change identified |
| MistyGroup | 1 | 6 | No additional worthwhile thematic change identified |
| LtSurgeGroup | 1 | 6 | No additional worthwhile thematic change identified |
| ScientistGroup | 5 | 8 | No additional worthwhile thematic change identified |
| ErikaGroup | 1 | 6 | No additional worthwhile thematic change identified |
| YoungsterGroup | 14 | 32 | No additional worthwhile thematic change identified |
| SchoolboyGroup | 24 | 69 | [Finding 2](#finding-2) |
| BirdKeeperGroup | 19 | 51 | [Finding 2](#finding-2) |
| LassGroup | 19 | 53 | No additional worthwhile thematic change identified |
| JanineGroup | 1 | 6 | No additional worthwhile thematic change identified |
| CooltrainerMGroup | 21 | 80 | [Finding 5](#finding-5) |
| CooltrainerFGroup | 22 | 80 | [Finding 4](#finding-4) |
| BeautyGroup | 6 | 11 | No additional worthwhile thematic change identified |
| PokemaniacGroup | 15 | 36 | No additional worthwhile thematic change identified |
| GruntMGroup | 18 | 52 | No additional worthwhile thematic change identified |
| GentlemanGroup | 4 | 7 | No additional worthwhile thematic change identified |
| SkierGroup | 4 | 8 | No additional worthwhile thematic change identified |
| TeacherGroup | 3 | 6 | No additional worthwhile thematic change identified |
| SabrinaGroup | 1 | 6 | No additional worthwhile thematic change identified |
| BugCatcherGroup | 19 | 57 | [Finding 1](#finding-1) |
| FisherGroup | 25 | 70 | [Finding 6](#finding-6) |
| SwimmerMGroup | 13 | 29 | No additional worthwhile thematic change identified |
| SwimmerFGroup | 13 | 28 | No additional worthwhile thematic change identified |
| SailorGroup | 13 | 31 | No additional worthwhile thematic change identified |
| SuperNerdGroup | 9 | 19 | No additional worthwhile thematic change identified |
| GuitaristGroup | 2 | 7 | No additional worthwhile thematic change identified |
| HikerGroup | 22 | 72 | No additional worthwhile thematic change identified |
| BlaineGroup | 1 | 6 | No additional worthwhile thematic change identified |
| BurglarGroup | 5 | 14 | No additional worthwhile thematic change identified |
| FirebreatherGroup | 8 | 20 | No additional worthwhile thematic change identified |
| JugglerGroup | 9 | 29 | No additional worthwhile thematic change identified |
| BlackbeltGroup | 11 | 32 | No additional worthwhile thematic change identified |
| ExecutiveMGroup | 4 | 18 | No additional worthwhile thematic change identified |
| PsychicGroup | 12 | 31 | [Finding 2](#finding-2) |
| PicnickerGroup | 19 | 59 | No additional worthwhile thematic change identified |
| SchoolGirlGroup | 8 | 16 | No additional worthwhile thematic change identified |
| CamperGroup | 16 | 43 | No additional worthwhile thematic change identified |
| ExecutiveFGroup | 2 | 9 | No additional worthwhile thematic change identified |
| SageGroup | 11 | 26 | No additional worthwhile thematic change identified |
| MediumGroup | 5 | 13 | No additional worthwhile thematic change identified |
| BoarderGroup | 6 | 15 | [Finding 3](#finding-3) |
| PokefanMGroup | 15 | 34 | No additional worthwhile thematic change identified |
| KimonoGirlGroup | 9 | 11 | [Finding 2](#finding-2) |
| TwinsGroup | 10 | 24 | No additional worthwhile thematic change identified |
| PokefanFGroup | 6 | 11 | No additional worthwhile thematic change identified |
| RedGroup | 1 | 6 | No additional worthwhile thematic change identified |
| BlueGroup | 1 | 6 | No additional worthwhile thematic change identified |
| OfficerGroup | 3 | 7 | No additional worthwhile thematic change identified |
| MysticalmanGroup | 2 | 8 | No additional worthwhile thematic change identified |
| ProtonGroup | 2 | 7 | No additional worthwhile thematic change identified |
| PetrelGroup | 1 | 4 | No additional worthwhile thematic change identified |
| ArianaGroup | 2 | 9 | No additional worthwhile thematic change identified |
| ArcherGroup | 2 | 10 | No additional worthwhile thematic change identified |
| PetrelDirectorGroup | 1 | 4 | No additional worthwhile thematic change identified |
| HexManiacGroup | 3 | 10 | No additional worthwhile thematic change identified |
| CosplayerGroup | 6 | 14 | No additional worthwhile thematic change identified |
| NinjaGroup | 4 | 12 | No additional worthwhile thematic change identified |
| AgathaGroup | 1 | 6 | No additional worthwhile thematic change identified |
| LoreleiGroup | 1 | 6 | No additional worthwhile thematic change identified |
| Red2Group | 1 | 6 | No additional worthwhile thematic change identified |
| BlueCloakGroup | 1 | 6 | No additional worthwhile thematic change identified |
| GreenGroup | 1 | 6 | No additional worthwhile thematic change identified |
| BattleGirlGroup | 4 | 12 | No additional worthwhile thematic change identified |
| TamerGroup | 5 | 15 | No additional worthwhile thematic change identified |
| GruntFGroup | 16 | 34 | [Finding 2](#finding-2) |
| Rival1Group | 15 | 60 | No additional worthwhile thematic change identified |
| Rival2Group | 6 | 36 | No additional worthwhile thematic change identified |
| CrystalGroup | 15 | 63 | No additional worthwhile thematic change identified |
| ElderGroup | 1 | 3 | No additional worthwhile thematic change identified |
| AromaLadyGroup | 3 | 11 | No additional worthwhile thematic change identified |
| BikerGroup | 9 | 26 | No additional worthwhile thematic change identified |
| CueballGroup | 1 | 6 | No additional worthwhile thematic change identified |
| KarateKingGroup | 1 | 5 | No additional worthwhile thematic change identified |

## Verification and limits

The trainer source audit passed: 594 parties, 734 trainer references, 104 class-table rows and 321 Battle Tower builds. The existing release ROM’s native ReadTrainerParty loaded all 15 parties implicated in the new findings and passed **535 checks**, including exact effective moves for normal-format parties, levels, species, items, explicit abilities and nonzero PP. The checked source was not changed during this review. This confirms the party data described above; it is not a claim of playing through all encounters or observing every AI choice.

Suggested replacement moves were checked against this game’s own level-up, TM, egg and tutor sources. Species substitutions, weather demonstrations, gentler moves and the seventeen/eighteen coverage interpretation remain design recommendations. No game build was needed because this pass changed documentation only.
