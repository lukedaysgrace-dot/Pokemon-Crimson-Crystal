# Gold/Silver content cut or changed in Crystal

Audit date: 2026-10-27. Compared the clean English retail disassemblies, **not this ROM hack**. This focuses on playable trainers, events, services, exploration, rewards, and meaningful NPC dialogue. Pokémon availability, gift/trade/prize species, graphics/music, unused beta content, Japanese mobile features, and routine engine fixes are excluded. Pokémon are named below only to explain trainer battles.

The main losses are **two Burned Tower trainers** and **rematches for four phone contacts**. Several other contacts get revised or expanded teams; major story content is usually replaced or expanded rather than deleted.

## 1. Actual trainer encounters removed

| Trainer | Gold/Silver encounter | Crystal change |
|---|---|---|
| Firebreather Dick — Burned Tower 1F | Charmeleon Lv17. A scripted challenge after the rival encounter; afterward he changes to an “ashes” sprite and mentions falling down a hole. | Entire encounter, scene, and dialogue removed. |
| Firebreather Ned — Burned Tower 1F | Koffing Lv15 / Growlithe Lv16 / Koffing Lv15. | Field trainer and dialogue removed. |

Both party definitions remain stored in Crystal, so searching only the party table would incorrectly suggest the fights survived. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/BurnedTower1F.asm#L92) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/BurnedTower1F.asm#L8)

## 2. Phone rematches removed

Each of these characters keeps the original first battle and phone number. The two additional Gold/Silver party variants per contact become unreachable in Crystal:

| Contact | Gold/Silver rematch parties lost | What Crystal does instead |
|---|---|---|
| Juggler Irwin — Route 35 | Voltorb 6/10/14/18; then Voltorb 18/22/26 + Electrode 30. | Calls react to the player’s story progress. No rematch. |
| Pokéfan Beverly — National Park | Snubbull 18; then Granbull 30. Both hold a Berry. | Nugget gifts. |
| Pokéfan Derek — Route 39 | Pikachu 19; then Pikachu 36. Both hold a Berry. | Nugget gifts. |
| Blackbelt Kenji — Route 45 | Onix 27 / Hitmonlee 30 / Onix 27 / Machoke 32; then Onix 30 / Machamp 37 / Onix 30 / Hitmonlee 35. | Training/break-time calls and PP Up gifts. |

These really were available in Gold/Silver: its phone callers set the corresponding rematch-ready events. [Gold/Silver phone callers](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/engine/phone/scripts/trainers.asm#L347). Crystal encounter scripts: [Irwin](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/Route35.asm#L30) · [Beverly](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/NationalPark.asm#L200) · [Derek](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/Route39.asm#L26) · [Kenji](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/Route45.asm#L21).

Kenji’s initial party is **KENJI3**, Machoke Lv28, in both games. Crystal edits the stored KENJI2 team, but does not make that rematch playable. Likewise, an unused IRWIN4 definition is not evidence of an extra Irwin battle.

## 3. Existing trainers with changed parties

“Later rematch” means a later party variant, not a claim that its numeric suffix is its battle order. Full levels, explicit moves, held items, IDs, and source links are in [trainer-party-changes.csv](trainer-party-changes.csv).

| Trainer / location | Gold/Silver → Crystal |
|---|---|
| Bird Keeper Jose — Route 27 | Farfetch’d levels drop by one in every existing variant: initial 35→34, rematches 37→36 and 41→40. Last variant gets Fury Attack / Detect / Fly / Slash. |
| Bird Keeper Vance — Route 44 | Middle rematch’s Pidgeotto 31/33→32/32. Last rematch’s Pidgeotto 35 + Pidgeot 37 become two Pidgeot 38, with explicit sets including Fly, Toxic, Detect, and Steel Wing. |
| Cooltrainer Beth — Route 26 | Rematch Rapidash 38→39 and 42→43. Last variant gains Focus Band and replaces Agility with Fire Blast. |
| Cooltrainer Reena — Route 27 | Rematches rise 33/35/33→34/36/34 and 37/39/37→38/40/38. Last variant has custom sets; Nidoqueen gains Pink Bow. |
| Cooltrainer Gaven — Route 26 | Rematch teams rise from all Lv34→35 and all Lv38→39. Last variant gets stronger custom moves, and Kingler gains King’s Rock. Initial Lv32 trio stays the same. |
| Fisher Wilton — Route 44 | Last rematch’s Goldeen 31 / Seaking 35 / Seaking 35 → Seaking 34 / Seaking 34 / Remoraid 38, with custom moves. |
| Hiker Parry — Route 45 | Onix 34→Onix 35 + Swinub 33; Onix 38→Piloswine 35 / Dugtrio 35 / Steelix 38 with custom moves. Initial Onix 29 stays the same. |
| Picnicker Erin — Route 46 | Last rematch’s two Ponyta 36 gain a Raichu 34 between them; all three use explicit moves. |
| Pokémaniac Brent — Route 43 | Nidoran♀ 19 / Nidoking 23→Kangaskhan 25. Later four-member Nidoran-family team→Porygon 36 with Recover / Psychic / Conversion 2 / Tri Attack. |
| Fisher Chris → Fisher Tully — Route 42 | Same character renamed. Initial Qwilfish 18 and next Qwilfish 23 stay the same. Third variant’s Qwilfish 34→32; both Goldeen 32 remain. Crystal adds another rematch and Water Stone gifts. |
| Hiker Benjamin — Route 42 | Same roster, but Dugtrio 16 gains Tri Attack through the revised level-up learnset. |
| Swimmer♂ Tucker — Route 19 | Same roster, but Cloyster 34 gets Spikes in place of Withdraw through the revised level-up learnset. |

Party definitions: [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/data/trainers/parties.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/data/trainers/parties.asm). The last two cases require checking [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/data/pokemon/evos_attacks.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/data/pokemon/evos_attacks.asm) as well as the party table. There are 18 existing party variants with direct roster/level/item/explicit-move edits, plus the two default-move changes above; a rename alone is not counted as a party rebalance.

Crystal also adds later rematch variants for Joey, Jack, Alan, Chad, Wade, Arnie, Ralph, Anthony, Todd, Gina, Liz, Dana, Huey, Brent, Tiffany, and Tully. That expansion does not restore the four lost contacts’ rematches.

Existing phone contacts also gain item-giving roles: Alan (Fire Stone), Gina (Leaf Stone), Dana (Thunderstone), Tully (Water Stone), Jose (Star Piece), Huey (Protein), Vance (Carbos), Parry (Iron), and Erin (Calcium). These are additions to those characters, not lost battles. For examples, see [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/Route36.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/Route36.asm); [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/Route45.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/Route45.asm).

## 4. Trainer placement and behavior

**88 ordinary trainer objects** change position, facing/movement, movement range, sight range, or another encounter condition. The complete object-by-object comparison is [trainer-placement-changes.csv](trainer-placement-changes.csv); coordinates are local map tiles, not screen pixels. This excludes sprite/palette-only changes and separately scripted boss scenes.

Examples: Route 1’s Quinn moves (3,26)→(9,25), Danny (7,17)→(4,12); Route 17’s Joel (16,32)→(9,68); Route 30’s Joey (6,29)→(2,28); Route 44’s Wilton (42,5)→(35,3). These trainers were moved, not cut.

The stored teams of all Gym Leaders, Elite Four members, Lance, Red, Blue, and the rival are unchanged. Shared trainer-class AI flags and DVs are also unchanged. This is a statement about their party/class data, not a claim that every battle-engine rule stayed identical. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/data/trainers/attributes.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/data/trainers/attributes.asm); [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/data/trainers/dvs.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/data/trainers/dvs.asm).

## 5. Original events, quests, services, and exploration changed

1. **Burned Tower / Morty progression.** Both floors are redesigned, Dick/Ned are removed, and Eusine/Morty scenes replace the old setup. The rival encounter now leads into the player’s fall to the basement. Crystal blocks Ecruteak Gym until the tower’s release event; Gold/Silver has no corresponding tower prerequisite. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/EcruteakGym.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/EcruteakGym.asm); [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/BurnedTowerB1F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/BurnedTowerB1F.asm).
2. **Clair’s Dragon Fang test is replaced.** In Gold/Silver, collecting the Dragon Fang in Dragon’s Den triggers Clair awarding the RisingBadge and TM24. Crystal instead requires the elder’s questions inside the new Dragon Shrine; Clair gives the badge there and TM24 during the exit scene. The Dragon Fang itself remains a normal pickup. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/DragonsDenB1F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/DragonsDenB1F.asm); [Crystal shrine](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/DragonShrine.asm#L21).
3. **SquirtBottle acquisition gains extra steps.** Gold/Silver checks the PlainBadge at the Flower Shop. Crystal also requires meeting Floria on Route 36 and talking to her after she returns to the shop. The bottle-giving and follow-up dialogue are rewritten. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/GoldenrodFlowerShop.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/GoldenrodFlowerShop.asm).
4. **Kurt’s one-ball workflow becomes batch crafting.** Gold/Silver selects one Apricorn for one ball. Crystal lets the player choose a quantity of a single Apricorn color for that day’s batch. His granddaughter gains phone-contact-related dialogue; she is not removed. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/KurtsHouse.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/KurtsHouse.asm); [Crystal quantity selection](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/engine/events/kurt.asm#L19).
5. **Mt. Mortar’s interior is extensively redesigned.** The inside 1F, upper floor, and basement have different traversable layouts and warp/item arrangements. Existing trainers are retained while additional encounters are added. The outside-floor pickup also changes. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/MountMortar1FInside.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/MountMortar1FInside.asm); [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/MountMortarB1F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/MountMortarB1F.asm).
6. **Ice Path traversal changes.** The walk-tile collision layouts differ on 1F, B1F, and B3F; B2F’s collision layout is unchanged. This includes actual route/ice changes, not just the new graphics. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/IcePath1F.blk) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/IcePath1F.blk); [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/IcePathB1F.blk) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/IcePathB1F.blk); [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/IcePathB3F.blk) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/IcePathB3F.blk).
7. **Tin Tower’s entrance and progression are reworked.** The old rear-entry map becomes the Wise Trio’s room with three sage battles. Gold/Silver’s Radio Tower Director gives the version’s wing; Crystal gives the Clear Bell. Crystal moves the Rainbow Wing reward to Tin Tower’s sages and gates the upper stairs through the expanded story. Pewter’s elder gives Silver Wing in Crystal, rather than the version-dependent opposite wing. This is a quest/key-item change; species availability is outside this list. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/RadioTower5F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/RadioTower5F.asm); [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/PewterCity.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/PewterCity.asm); [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/TinTower1F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/TinTower1F.asm).
8. **Route 40’s shoreline changes for the Battle Tower entrance.** The rocks, hidden Hyper Potion, Monica, and nearby NPCs move. All four original Route 40 swimmers remain. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/Route40.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/Route40.asm).
9. **Other smaller layout edits.** Union Cave’s three floors, parts of Routes 26/27/36/43, National Park, Silver Cave, and several city/interior maps have collision edits. Lance’s room shifts his standing position and the Hall of Fame doorway, with adjusted entrance/ending movements; his battle team is unchanged. These are revisions to existing spaces, not removed dungeons. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/LancesRoom.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/LancesRoom.asm). All shared retail-map collision changes are listed in [map-layout-changes.csv](map-layout-changes.csv); the unused Safari Zone beta map is excluded.

Pure additions such as Buena’s Password, the Battle Tower, the Goldenrod move tutor, the Poké Seer, department-store rooftop sales, and extra Ruins of Alph rooms are not presented as content cut from Gold/Silver.

## 6. Field rewards removed, replaced, or relocated

**Burned Tower loses four pickups:** the 1F Burn Heal and X Speed, and the basement’s hidden Burn Heal and hidden Nugget. Its HP Up and hidden Ultra Ball move from B1F to 1F; TM31 Endure remains in the basement at a different position. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/BurnedTower1F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/BurnedTower1F.asm); [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/BurnedTowerB1F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/BurnedTowerB1F.asm).

| Location | Gold/Silver pickup → Crystal pickup |
|---|---|
| SproutTower2F | X Defend → X Accuracy |
| Route31 | Antidote → Potion |
| Route32 | Potion → Repel |
| MountMortar1FOutside | Guard Spec → Revive |
| MountMortarB1F | Full Heal → Full Restore |
| OlivineLighthouse5F | Great Ball → Super Repel |
| LakeOfRage | Max Ether → Elixir |
| Route45 | X Special → Nugget |
| Route46 | Dire Hit → X Speed |
| SilverCaveRoom1 | X Accuracy → Ultra Ball |
| TeamRocketBaseB1F | X Accuracy → Guard Spec |
| TeamRocketBaseB3F | Dire Hit → X Special |
| TinTower4F | Super Potion → PP Up |
| VictoryRoad | X Special → HP Up |
| WhirlIslandSW | Guard Spec → Ultra Ball |

The record-size reward at the Lake of Rage house also changes **Ether → Elixir**. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/LakeOfRageMagikarpHouse.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/LakeOfRageMagikarpHouse.asm).

See [field-item-changes.csv](field-item-changes.csv) for pickup replacements, actual removals, coordinate changes, additions, and paired source links. It compares visible item balls and hidden items; scripted quest rewards are discussed above rather than inferred from raw command counts.

## 7. Meaningful NPC material rewritten or removed

| Location / character | Material lost or changed |
|---|---|
| Bill and his mother — BillsFamilysHouse | Bill’s teleporter experiment/follow-up line is replaced by complaints about his father avoiding work. His mother’s homecoming dialogue is replaced with remarks about his father’s Pokémaniac past. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/BillsFamilysHouse.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/BillsFamilysHouse.asm) |
| Walking Fisher NPC — GoldenrodPokecenter1F | The NPC wondering about Oak’s old count of 150 species is removed. Crystal adds a woman who trades Eon Mail for a Revive. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/GoldenrodPokecenter1F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/GoldenrodPokecenter1F.asm) |
| Dragon’s Den guard / city residents — BlackthornCity | Dialogue now establishes Clair’s grandfather as the master, chosen trainers, the dragon clan, and Clair’s losses to Lance. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/BlackthornCity.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/BlackthornCity.asm) |
| Gym trainers / Clair — BlackthornGym1F | Dialogue is rewritten around the elder and Dragon Shrine test; trainers’ parties remain unchanged. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/BlackthornGym1F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/BlackthornGym1F.asm) |
| Super Nerd — CeruleanPokecenter1F | Route 9 / Power Plant directions become a comment about personally raised Pokémon. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/CeruleanPokecenter1F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/CeruleanPokecenter1F.asm) |
| Teacher — SaffronPokecenter1F | Power Plant location hint becomes a conversation about Johto’s Pokémon Centers. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/SaffronPokecenter1F.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/SaffronPokecenter1F.asm) |
| Fishing Guru / Strength sailor — OlivineCafe | The sea/Whirlpool warning becomes café-menu dialogue. The Strength giver also loses the explicit Goldenrod Gym Badge reminder; he still gives HM04. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/OlivineCafe.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/OlivineCafe.asm) |
| Fishing Guru → Fishing Dude — VermilionFishingSpeechHouse | The old anecdote about Fisher Wilton’s phone tip becomes a pointer to the Lake of Rage record-size side activity. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/maps/VermilionFishingSpeechHouse.asm) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/maps/VermilionFishingSpeechHouse.asm) |

Small punctuation, line wrapping, gender-address substitutions, and sprite-only NPC swaps are excluded. The report records meaningful rewrites rather than treating every altered sentence as a separate cut.

## 8. Common false positives

- **Fisher Chris is Tully**, not a missing Route 42 trainer.
- **Azalea Gym’s Bug Catcher Benny remains.** Its internal constant changes from BENNY to BUG_CATCHER_BENNY; the displayed name and Weedle 7 / Kakuna 9 / Beedrill 12 team remain.
- **Ilex Forest’s Farfetch’d chase remains.** Multiple fixed-position object definitions become a dynamically moved object; raw object-count reduction does not mean nine encounters were removed.
- **Kurt’s granddaughter remains.** Her object/script naming changes as the phone feature is added.
- **Violet Pokémon Center’s PC-storage NPC retains the same Bill dialogue**, despite changing sprite/script name.
- **Unused parties are not playable content.** For example, Crystal’s edited KENJI2 and extra IRWIN4 cannot be counted as accessible battles. Other unused trainer definitions are excluded from the change list.
- The phone contact capacity remains **10** in both games. [Gold/Silver](https://github.com/pret/pokegold/blob/fc702b6d922aecce274782d68bba8639936a1182/constants/phone_constants.asm#L71) · [Crystal](https://github.com/pret/pokecrystal/blob/5c877ef55197039c9676e8e3eec6d254b1c40fe8/constants/phone_constants.asm#L72).

## Method and limits

Compared all stored trainer entries and their references in map scripts, ordinary trainer objects, map text/scripts, item-ball/hidden-item records, and expanded collision layouts for all shared maps. Checked the phone caller scripts for rematches claimed as lost, and level-up learnsets for changed default trainer moves. Source inspection distinguishes playable content from retained unused data. This is a static content audit, not an emulator playthrough or an exhaustive catalog of battle-engine bugs, audiovisual changes, or every minor dialogue edit.

Pinned source revisions: [pokegold fc702b6d922a](https://github.com/pret/pokegold/tree/fc702b6d922aecce274782d68bba8639936a1182) and [pokecrystal 5c877ef55197](https://github.com/pret/pokecrystal/tree/5c877ef55197039c9676e8e3eec6d254b1c40fe8). [Source manifest](sources.json).
