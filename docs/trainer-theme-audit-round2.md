# Trainer thematic review — second pass

Reviewed 20 October 2026, after the 50 approved roster substitutions and dialogue fixes.

**Roster options implemented:** the subsequent mon-only pass addresses all 16 findings with a roster or moveset solution. [See applied changes and scope](trainer-theme-fixes-round2.md). Findings 3–5 concern phone dialogue or code and remain outside that authorized pass. The review below preserves the pre-change evidence.

**Scope:** all **594 authored party records / 1,819 Pokémon slots / 87 populated groups** were re-inventoried. The review rechecked the ordinary-trainer dialogue records, special-trainer map conversations (46 battle-related maps), shared Cape/phone text, actual local typings, evolution routes, moves, selected abilities, and relevant encounter tables. Battle Tower remains 70 independently selected identities drawing shared generated teams.

**Main conclusion:** no newly discovered Gym Leader/Elite Four species is simply the wrong type for its role. Koga has a real advertised-technique gap, and the phone dialogue has two concrete consistency/reader problems. Most remaining special-trainer suggestions concern making an already legal team more personally recognizable. The previous 31 fixes are retained; none are silently reverted.

**New findings:** 4 concrete dialogue/data mismatches (A), 5 supported character/teaching improvements (B), and 10 optional refinements (C). “Optional” is intentional: it should not be read as an instruction to remove every unusual favorite.

**This review is the pre-change snapshot.** [Current complete party checklist](trainer-theme-coverage.md) · [Previously implemented fixes](trainer-theme-fixes.md).

## Prioritized findings

| # | Strength | Trainer / issue | What needs attention |
|---|---|---|---|
| [1](#finding-1) | A | Koga — promised sleep is missing; rematch loses confusion | Battle-style dialogue, not a wrong Poison species. |
| [2](#finding-2) | A | Bird Keeper Denis — says Fly was learned, but neither partner knows it | Watu/Corvisquire moves versus explicit travel dialogue. |
| [3](#finding-3) | A | Beverly — present-tense Snubbull/Granbull identity changes between conversations | Named pet in phone text. |
| [4](#finding-4) | A | Wilton and Kenji — phone species reader skips the wrong number of bytes | Functional dialogue bug behind potentially nonsensical Pokémon names. |
| [5](#finding-5) | B | Rematch callers — generic calls keep using the contact's starting party | Possible stale species names across 19 active caller families. |
| [6](#finding-6) | B | Eusine — rematch loses the hypnosis/dream-hunter demonstration | Hypno/Gengar moves, especially unsupported Dream Eater. |
| [7](#finding-7) | B | Fisher Andre — newly caught Corsola at a Magikarp/Gyarados lake | Corsola and the immediate local-catching implication. |
| [8](#finding-8) | B | Fisher Henry — freshly caught pair does not match Route 32 fishing | Chinchou/Remoraid and local-catching implication. |
| [9](#finding-9) | B | Cooltrainer Megan — evolution researcher without a comparison pair | Yanmega/Walrein/Lickilicky/Feraligatr versus her specific research lesson. |
| [10](#finding-10) | C | Brock — fossil offense is less defensive than his introduction | Aerodactyl and Rampardos; optional emphasis, not wrong types. |
| [11](#finding-11) | C | School Girl Sharon — singer is not represented by a sound move | Altaria's battle moves, not the species. |
| [12](#finding-12) | C | Whitney — Buneary's rematch continuity is missing | Buneary disappears instead of returning as Lopunny. |
| [13](#finding-13) | C | Silver — no friendship evolution to visualize his redemption | Optional story symbolism; no current species violates his character. |
| [14](#finding-14) | C | Crystal — established Marowak vanishes before the final personal battle | Cubone/Marowak continuity versus Ursaluna/Bloodmoon Ursaluna. |
| [15](#finding-15) | C | Lorelei — Articuno needs a little personal legendary context | Articuno is perfectly Ice-themed; the question is story significance. |
| [16](#finding-16) | C | Lorelei — classic Slowbro currently demonstrates no Ice technique | Slowbro's moves, not a request to remove an iconic partner. |
| [17](#finding-17) | C | Ariana — Milotic to Octillery loses some elegant personal identity | Octillery, weighed against the established Milotic slot. |
| [18](#finding-18) | C | Archer — Cloyster is the least character-specific executive partner | Cloyster; a weak optional concern, not a wrong-class species. |
| [19](#finding-19) | C | Bird Keeper Perry — speed speech beside a slow defensive bird | Corviknight and a speed-focused introduction. |

## Evidence and recommendations

<a id="finding-1"></a>

### 1. [A] Koga — promised sleep is missing; rematch loses confusion

His introduction promises “Confusion, sleep, poison.” The first Salazzle actually has Poison Puppeteer and Toxic, so it CAN cause confusion: an ability-aware review must count that. Neither team can directly inflict sleep. In the rematch Salazzle switches to Corrosion, and no other selected move/ability supplies confusion. The Poison/trap theme works, but his exact advertised technique is only partly demonstrated.

**Recommended response:** Keep the species. In KOGA1, replace Crobat's redundant Toxic with Hypnosis. For KOGA2, give Crobat Hypnosis and Confuse Ray in the U-turn/Roost slots, retaining both attacking STAB moves; alternatively keep Roost and change the speech to poison, traps and ambushes. A roster alternative is Venomoth with Sleep Powder, but that would overlap Janine and is not necessary.

**Party evidence:**

- [KOGA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:885) — Koga's Room — Glimmora 68, Alolan Muk 69, Scolipede 69, Tentacruel 70, Salazzle 70, Crobat 71.
- [KOGA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:919) — Koga's Room — Glimmora 83, Alolan Muk 84, Scolipede 84, Tentacruel 85, Salazzle 85, Crobat 85.

**Dialogue/mechanics evidence:** [maps/KogasRoom.asm:100](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/KogasRoom.asm:100); [engine/battle/abilities_engine.asm:6395](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/abilities_engine.asm:6395); [data/pokemon/base_stats/salazzle.asm:15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/salazzle.asm:15).

<a id="finding-2"></a>

### 2. [A] Bird Keeper Denis — says Fly was learned, but neither partner knows it

Denis says his Pokémon learned Fly in Cianwood and that he will Fly across the sea. His normal-format Lv.34 Watu and Corvisquire use automatic level-up moves; neither resulting set contains Fly. Both species are perfectly appropriate birds and can learn the HM. The problem is the claim that it has already been taught.

**Recommended response:** Retain both birds. Author a moveset with Fly for Corvisquire, or change the line to say he plans to get the HM/teach Fly. Toby's similar future-tense plan is already fine.

**Party evidence:**

- [DENIS](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1681) — Olivine Lighthouse 5F — Watu 34, Corvisquire 34.

**Dialogue/mechanics evidence:** [maps/OlivineLighthouse5F.asm:94](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse5F.asm:94); [data/pokemon/base_stats/corvisquire.asm:21](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/corvisquire.asm:21).

<a id="finding-3"></a>

### 3. [A] Beverly — present-tense Snubbull/Granbull identity changes between conversations

Her actual initial partner is Snubbull Lv.22. Her number-accepted text calls it her cute Snubbull, but one ordinary phone story says “My GRANBULL” in the present tense. Stored later parties do have Granbull, but those have no direct map loads, and the phone story has no evolution/rematch-state condition. This is not a complaint about an adult loving either species; it is inconsistent identification of the same advertised pet.

**Recommended response:** Use a generic “my darling” in the hardcoded story, or dynamically resolve the owned partner consistently. Keeping Snubbull as the initial pet preserves the existing introduction. Do not add a new rematch merely to justify the text.

**Party evidence:**

- [BEVERLY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6411) — National Park — Snubbull 22.
- [BEVERLY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6423) — National Park (rematch) — Granbull 43.
- [BEVERLY3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6429) — National Park (rematch) — Granbull 56.

**Dialogue/mechanics evidence:** [data/phone/text/beverly_caller.asm:16](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/beverly_caller.asm:16); [data/phone/text/beverly_overworld.asm:31](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/beverly_overworld.asm:31).

<a id="finding-4"></a>

### 4. [A] Wilton and Kenji — phone species reader skips the wrong number of bytes

RandomPhoneMon computes each party member's stride from level/species plus optional item/moves, but omits the optional ability byte. Both current phone-contact records carry one: WILTON1 is TRAINERTYPE_ABILITY and KENJI3 is TRAINERTYPE_MOVES_ABILITY. Reading the rebuilt ROM with that exact stride confirms the mismatch: Wilton is interpreted as four entries instead of three, with only the first species valid; Kenji is interpreted as 36 entries instead of four, including invalid species indices and data beyond his party. This is independent of the stylistic roster choices.

**Recommended response:** Teach the phone helper to include TRAINERTYPE_ABILITY_F in its stride, following ReadTrainerParty's format handling. Keep both teams intact. Verify the names selected from these two contacts before addressing the separate stale-rematch issue below.

**Party evidence:**

- [WILTON1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3628) — Route 44 — Octillery 39, Mantine 39, Seaking 41.
- [KENJI3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5050) — Route 45 — Heracross 39, Primeape 39, Hitmontop 41, Conkeldurr 43.

**Dialogue/mechanics evidence:** [engine/overworld/wildmons.asm:1083](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/overworld/wildmons.asm:1083); [engine/overworld/wildmons.asm:1127](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/overworld/wildmons.asm:1127); [data/phone/phone_contacts.asm:46](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/phone_contacts.asm:46); [data/phone/phone_contacts.asm:47](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/phone_contacts.asm:47).

<a id="finding-5"></a>

### 5. [B] Rematch callers — generic calls keep using the contact's starting party

PhoneContacts stores one base class/party ID. RandomPhoneMon reads that fixed record, not the team selected by the latest rematch. Thus Alan can still discuss Pawniard/Chinchou after fighting with Kingambit/Lanturn, and Chad can discuss Eevee/Voltorb after using Espeon/Electrode. Nineteen families have base members absent from their highest directly referenced party. This is a confirmed naming mechanism, with a characterization caveat: an NPC could own extra boxed Pokémon, so an absent battle member alone does not prove an impossible story. Consistent evolving-partner dialogue would nevertheless be clearer.

**Recommended response:** Resolve the party appropriate to the caller's rematch state before choosing a name, or make the generic bragging text refer to “my team.” Retain hardcoded Farfetch'd/Rapidash stories that now name their intended signature partner. The table below enumerates all 19 cases.

**Party evidence:**

This is a shared reader issue. All 19 caller families are enumerated in the dedicated table below.

**Dialogue/mechanics evidence:** [engine/overworld/wildmons.asm:1083](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/overworld/wildmons.asm:1083); [engine/phone/phone.asm:683](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/phone/phone.asm:683); [data/phone/phone_contacts.asm:11](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/phone_contacts.asm:11); [engine/phone/scripts/generic_caller.asm:1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/engine/phone/scripts/generic_caller.asm:1).

<a id="finding-6"></a>

### 6. [B] Eusine — rematch loses the hypnosis/dream-hunter demonstration

In Cianwood, both Hypno and Haunter know Hypnosis. In Ecruteak the automatic sets on Hypno/Gengar/Electrode/Noctowl/Espeon contain no sleep move, while Gengar still has Dream Eater. The species still suit a Mystical Man; the stronger second team simply stops showing the hypnotic technique that distinguished the first encounter. This is a style/continuity concern, not a rule that an Entei enthusiast must use Fire types.

**Recommended response:** Keep the core species and give EUSINE2 Hypno Hypnosis in place of Trick Room, or Gengar Hypnosis in place of Toxic Spikes. Dream Eater then supports a recognizable technique. An Arcanine tracker could strengthen the new Entei-focused characterization if desired, but replacing Espeon with one is optional.

**Party evidence:**

- [EUSINE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6581) — Cianwood City — Hypno 33, Haunter 33, Electrode 34.
- [EUSINE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6600) — Ecruteak City — Hypno 38, Gengar 38, Electrode 39, Noctowl 39, Espeon 40.

**Dialogue/mechanics evidence:** [maps/CianwoodCity.asm:437](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CianwoodCity.asm:437); [maps/EcruteakCity.asm:546](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakCity.asm:546); [data/pokemon/dex_entries/hypno.asm:6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/dex_entries/hypno.asm:6).

<a id="finding-7"></a>

### 7. [B] Fisher Andre — newly caught Corsola at a Magikarp/Gyarados lake

He introduces the Pokémon he “just caught.” His only partner is Corsola Lv.36, but Lake of Rage uses FISHGROUP_GYARADOS: its rods produce Magikarp/Gyarados, and its surf table has Magikarp/Poliwag/Gyarados. Corsola is absent. The species fits Fisher generally; the local just-caught scene is the weak link. “Just caught” does not literally name the lake, so travel is possible, but currently unexplained.

**Recommended response:** For a local scene use Gyarados Lv.36, or Magikarp for the comic contrast between expert angler and poor battler. The smallest fix is wording that says he brought Corsola from the coast rather than just caught it here.

**Party evidence:**

- [ANDRE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3616) — Lake of Rage — Corsola 36.

**Dialogue/mechanics evidence:** [maps/LakeOfRage.asm:375](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LakeOfRage.asm:375); [data/maps/maps.asm:240](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/maps/maps.asm:240); [data/wild/fish.asm:135](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/wild/fish.asm:135); [data/wild/johto_water.asm:217](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/wild/johto_water.asm:217).

<a id="finding-8"></a>

### 8. [B] Fisher Henry — freshly caught pair does not match Route 32 fishing

Henry explicitly calls his Pokémon freshly caught. Chinchou and Remoraid are legitimate aquatic partners, but Route 32's assigned Qwilfish group (including its swarm/no-swarm/time variants) produces Magikarp, Tentacool/Tentacruel, Qwilfish and Overqwil, not either of Henry's species. As with Andre, catching them elsewhere is possible; the current nearby fishing scene does not establish that.

**Recommended response:** Use Tentacool + Qwilfish at the current levels, or keep the pair and say they were caught on a fishing trip. This is an environment/dialogue recommendation, not a blanket restriction on Fisher collections.

**Party evidence:**

- [HENRY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3592) — Route 32 — Chinchou 11, Remoraid 11.

**Dialogue/mechanics evidence:** [maps/Route32.asm:728](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:728); [data/maps/maps.asm:243](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/maps/maps.asm:243); [data/wild/fish.asm:183](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/wild/fish.asm:183); [data/wild/fish.asm:336](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/wild/fish.asm:336).

<a id="finding-9"></a>

### 9. [B] Cooltrainer Megan — evolution researcher without a comparison pair

She says she is checking pre- and post-evolution Pokémon, then explains their different learning speeds. All four current partners are final evolutions from different families. They are valid Cooltrainer choices, but the team no longer visibly illustrates her particular research subject. She could be conducting that research offscreen, so this is a lost teaching opportunity rather than a hard contradiction.

**Recommended response:** Keep Yanmega and replace Lickilicky with Yanma Lv.47 to show a pre/post pair, or put Sealeo beside Walrein. Keeping an unevolved specimen at this level is appropriate for the research concept. Alternatively let her discuss advanced evolutions rather than a comparison.

**Party evidence:**

- [MEGAN](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2627) — Route 27 — Yanmega 47, Walrein 47, Lickilicky 47, Feraligatr 47.

**Dialogue/mechanics evidence:** [maps/Route27.asm:404](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:404).

<a id="finding-10"></a>

### 10. [C] Brock — fossil offense is less defensive than his introduction

His speech stresses being impervious to physical attacks and rock-hard defense. Aerodactyl and Rampardos communicate fast/heavy fossil offense more than fortification. Importantly, this game buffs Rampardos to base 90 Defense, so calling it the official-series 60-Defense glass cannon would be wrong. Steelix/Golem/Armaldo/Cradily already provide a sound sturdy core. All fossil picks remain excellent Rock/geology choices.

**Recommended response:** Only if you want a distinctly defensive Brock: Rampardos → Bastiodon Lv.49 preserves the fossil theme, or use Aggron. I would otherwise keep the varied team. Steelix remains a defensible evolved-Onix exception and is not a newly discovered error.

**Party evidence:**

- [BROCK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1027) — Pewter Gym — Aerodactyl 47, Cradily 48, Steelix 48, Rampardos 49, Armaldo 49, Golem 50.

**Dialogue/mechanics evidence:** [maps/PewterGym.asm:90](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/PewterGym.asm:90); [data/pokemon/base_stats/rampardos.asm:3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/rampardos.asm:3); [data/pokemon/base_stats/bastiodon.asm:15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/bastiodon.asm:15).

<a id="finding-11"></a>

### 11. [C] School Girl Sharon — singer is not represented by a sound move

Her art-club line explicitly says Smeargle paints and Altaria sings. Altaria currently has Dragon Dance, Dual Wingbeat, Moonblast and Roost, with no singing/sound move. Singing outside battle is completely plausible, so this is only an opportunity to make her artistic identity visible during the fight.

**Recommended response:** Replace Dual Wingbeat with Hyper Voice, or Dragon Dance with Sing. Both are available to Altaria in this game. Do not replace Altaria: it is a particularly good singer/costume-art partner.

**Party evidence:**

- [SHARON](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5580) — Route 4 — Smeargle 51, Altaria 52.

**Dialogue/mechanics evidence:** [maps/Route4.asm:222](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route4.asm:222); [data/pokemon/base_stats/altaria.asm:15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/altaria.asm:15).

<a id="finding-12"></a>

### 12. [C] Whitney — Buneary's rematch continuity is missing

The initial team introduces Aipom and Buneary as cute companions. The rematch follows Aipom into Ambipom but drops Buneary, adding several large Normal powerhouses. All six rematch species fit Normal specialization, and a cute-loving trainer can love a large bear or Snorlax. The only concern is that Lopunny would make the original companion growth more recognizable.

**Recommended response:** If continuity matters, put Lopunny Lv.78 in Kangaskhan's slot, or Lv.79 in Snorlax's slot. Otherwise retain the present roster. Ursaluna is not thematically forbidden just because it is large or uses Flame Orb competitively.

**Party evidence:**

- [WHITNEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:76) — Goldenrod Gym — Clefairy 18, Aipom 19, Buneary 19, Miltank 20.
- [WHITNEY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:100) — Goldenrod Gym — Blissey 77, Ambipom 77, Kangaskhan 78, Ursaluna 78, Snorlax 79, Miltank 79.

**Dialogue/mechanics evidence:** [maps/GoldenrodGym.asm:209](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/GoldenrodGym.asm:209); [data/pokemon/base_stats/lopunny.asm:6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/lopunny.asm:6).

<a id="finding-13"></a>

### 13. [C] Silver — no friendship evolution to visualize his redemption

The Plateau dialogue explicitly completes the love/trust arc, but the team after his crisis changes mainly through levels and moves. There is no friendship evolution as a visual payoff. Gliscor, Magnezone, Slowking, Weavile, Ceruledge/Gengar and the starter are all credible partners; a ruthless-looking species can become a loved partner. This is a missing storytelling device, not evidence that he still mistreats them.

**Recommended response:** If you want that visual payoff, establish Golbat earlier and evolve it into Crobat only after his change of attitude. Replacing the Gligar/Gliscor line would require changing all relevant earlier variants, so I would not suddenly drop a Crobat into the final party. A short line about a specific existing partner trusting him is the smaller solution. Golbat really does use happiness evolution here.

**Party evidence:**

- [RIVAL2_2_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7938) — Indigo Plateau Pokémon Center 1F — Gliscor 82, Magnezone 83, Slowking 83, Weavile 83, Ceruledge 83, Meganium 85.
- [RIVAL2_2_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7972) — Indigo Plateau Pokémon Center 1F — Gliscor 82, Magnezone 83, Slowking 83, Weavile 83, Gengar 83, Typhlosion 85.
- [RIVAL2_2_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8006) — Indigo Plateau Pokémon Center 1F — Gliscor 82, Magnezone 83, Galarian Slowking 83, Weavile 83, Ceruledge 83, Feraligatr 85.

**Dialogue/mechanics evidence:** [maps/IndigoPlateauPokecenter1F.asm:243](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IndigoPlateauPokecenter1F.asm:243); [maps/IndigoPlateauPokecenter1F.asm:287](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IndigoPlateauPokecenter1F.asm:287); [data/pokemon/evos_attacks_kanto.asm:1122](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_kanto.asm:1122).

<a id="finding-14"></a>

### 14. [C] Crystal — established Marowak vanishes before the final personal battle

She introduces Cubone in Ilex Forest and keeps Marowak through Cianwood and Ice Path. It disappears at the Cape in favor of an Ursaluna form. Those are separate families, not an evolution of her Marowak. As a Pokédex researcher she can rotate captures, and the Ice Path dialogue promises new things next time, so this is not a continuity contradiction. It is a choice between demonstrating her wider collection and retaining a recognizable longtime partner.

**Recommended response:** For a tighter companion arc, keep Marowak Lv.69 in the Ursaluna slot across all Cape branches. For the collector interpretation, keep both Ursaluna forms and add a brief mention of rotating field partners. Natu → Xatu and the apple line already provide strong continuity; she need not own only the same six Pokémon forever.

**Party evidence:**

- [CRYSTAL_4_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8231) — Ice Path 1F — Xatu 41, Marowak 42, Hydrapple 42, Pupitar 42, Meganium 44.
- [CRYSTAL_4_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8260) — Ice Path 1F — Xatu 41, Marowak 42, Flapple 42, Pupitar 42, Typhlosion 44.
- [CRYSTAL_4_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8289) — Ice Path 1F — Xatu 41, Marowak 42, Appletun 42, Pupitar 42, Feraligatr 44.
- [CRYSTAL_5_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8318) — Route 25 (Cerulean Cape) — Meganium 70, Hydrapple 68, Tyranitar 69, Ursaluna 69, Xatu 68, Lanturn 68.
- [CRYSTAL_5_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8352) — Route 25 (Cerulean Cape) — Typhlosion 70, Flapple 68, Tyranitar 69, Ursaluna 69, Xatu 68, Lanturn 68.
- [CRYSTAL_5_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8386) — Route 25 (Cerulean Cape) — Feraligatr 70, Appletun 68, Tyranitar 69, Ursalunabm 69, Xatu 68, Volcarona 68.

**Dialogue/mechanics evidence:** [maps/IlexForest.asm:1100](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IlexForest.asm:1100); [maps/IcePath1F.asm:127](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IcePath1F.asm:127); [data/text/route25_cape.asm:5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/text/route25_cape.asm:5).

<a id="finding-15"></a>

### 15. [C] Lorelei — Articuno needs a little personal legendary context

The game explicitly describes Articuno as a legendary bird. Lorelei brings one into an otherwise straightforward old-Elite-Four encounter without mentioning how they met or bonded. A veteran Ice trainer is an entirely plausible owner, and the game does not establish that there can only be one Articuno. This is an opportunity to make an exceptional partner feel earned, not a species/type violation.

**Recommended response:** My preference is to keep Articuno and add a short line about earning its trust in the Seafoam cold. If ordinary nonlegendary teams are preferred, use Glaceon, Alolan Ninetales or Froslass at Lv.87.

**Party evidence:**

- [LORELEI1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7049) — Silver Cave Outside — Dewgong 85, Cloyster 86, Slowbro 86, Mesmeria 87, Lapras 87, Articuno 87.

**Dialogue/mechanics evidence:** [maps/SilverCaveOutside.asm:175](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilverCaveOutside.asm:175); [data/pokemon/dex_entries/articuno.asm:4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/dex_entries/articuno.asm:4).

<a id="finding-16"></a>

### 16. [C] Lorelei — classic Slowbro currently demonstrates no Ice technique

Slowbro is Water/Psychic and its current set is Calm Mind, Surf, Psychic and Slack Off. It is a coherent cold-water/classic Lorelei partner, but contributes no Ice move to the battle she describes as facing her ice. Other team members already supply plenty of Ice attacks, so the speech is not literally false.

**Recommended response:** Keep Slowbro. If you want every member to participate visibly in her Ice identity, replace Psychic or Calm Mind with Ice Beam. Removing Slowbro merely for not having Ice typing would weaken her recognizable personal roster.

**Party evidence:**

- [LORELEI1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7049) — Silver Cave Outside — Dewgong 85, Cloyster 86, Slowbro 86, Mesmeria 87, Lapras 87, Articuno 87.

**Dialogue/mechanics evidence:** [maps/SilverCaveOutside.asm:188](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilverCaveOutside.asm:188); [data/pokemon/base_stats/slowbro.asm:21](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/slowbro.asm:21).

<a id="finding-17"></a>

### 17. [C] Ariana — Milotic to Octillery loses some elegant personal identity

The first team's Murkrow/Salazzle/Milotic/Weavile forms a recognizable elegant-but-dangerous collection. The rematch removes Milotic and adds Octillery and Toxapex. Octillery is Water/Fire here and its artillery concept fits Rocket, as accepted in the first review; it simply feels more like generic criminal equipment than a continuation of Ariana's individual aesthetic. Her actual dialogue does not impose elegance as a rule.

**Recommended response:** For stronger personal continuity, restore Milotic Lv.43 in Octillery's slot and retain Toxapex as the new poison wall. Keeping Octillery is equally defensible if her character is intended to favor weapons and intimidation over elegance.

**Party evidence:**

- [ARIANA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6693) — Team Rocket Base B2F — Murkrow 35, Salazzle 35, Milotic 36, Weavile 36.
- [ARIANA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6717) — Radio Tower 5F — Honchkrow 42, Salazzle 42, Octillery 43, Toxapex 43, Weavile 43.

**Dialogue/mechanics evidence:** [maps/RadioTower5F.asm:281](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower5F.asm:281); [data/pokemon/base_stats/octillery.asm:6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/octillery.asm:6).

<a id="finding-18"></a>

### 18. [C] Archer — Cloyster is the least character-specific executive partner

Crobat, Dusknoir, Kingambit and Houndoom establish a dark, intimidating command team. Cloyster is threatening and armored, and its multi-hit artillery role works, but has the least direct connection to his leader/criminal identity. The source gives Archer no personal marine or shell-weapon story. Rocket commanders are generalists and can still use it without contradiction.

**Recommended response:** If sharpening the criminal-boss identity, use Krookodile Lv.42/44 in the corresponding Cloyster slots. If a fire/undead visual is preferred, Alolan Marowak is another option. My priority would be character dialogue, not a compulsory swap.

**Party evidence:**

- [ARCHER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6749) — Radio Tower 5F (rematch) — Crobat 43, Dusknoir 44, Kingambit 44, Cloyster 44, Houndoom 44.
- [ARCHER2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6778) — Radio Tower 5F — Crobat 41, Dusknoir 41, Kingambit 42, Cloyster 42, Houndoom 43.

**Dialogue/mechanics evidence:** [maps/RadioTower5F.asm:295](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower5F.asm:295); [maps/RadioTower5F.asm:329](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/RadioTower5F.asm:329).

<a id="finding-19"></a>

### 19. [C] Bird Keeper Perry — speed speech beside a slow defensive bird

He describes agility as the key attribute and says he lost to your speed. His Honchkrow/Corviknight pair has base Speed 71/67 in this source, with Corviknight using Iron Head, Body Press, U-turn and Roost. Honchkrow does have Sucker Punch, so the team is not completely without a way to act first. Both are excellent Bird Keeper species; this is only a mismatch in emphasis.

**Recommended response:** Either reword the lesson around timing and defenses, or replace Corviknight Lv.61 with Talonflame Lv.61, Fearow or Pidgeot. Do not add Tailwind to these current birds without checking learnsets: this source does not give it to Honchkrow or Corviknight.

**Party evidence:**

- [PERRY](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1776) — Route 13 — Honchkrow 60, Corviknight 61.

**Dialogue/mechanics evidence:** [maps/Route13.asm:114](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route13.asm:114); [data/pokemon/base_stats/corviknight.asm:15](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/base_stats/corviknight.asm:15).

## All 19 caller families with possible stale names

This compares each contact's fixed base party to its highest-level **directly map-referenced** party. It does not assume that a stored unused rematch is playable, and it does not claim NPCs cannot own boxed Pokémon. The concern is that a caller described as growing with a partner can keep naming an earlier form after later battles.

| Caller | Fixed phone party | Highest referenced party | Base names absent from later team |
|---|---|---|---|
| Jack | [JACK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1363) | [JACK5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1557) | Teddiursa |
| Huey | [HUEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4125) | [HUEY4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4229) | Poliwhirl, Sealeo |
| Jose | [JOSE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1764) | [JOSE3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1796) | Corviknight, Honchkrow |
| Joey | [JOEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1219) | [JOEY5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1344) | Rattata |
| Wade | [WADE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3368) | [WADE5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3486) | Pineco, Weedle |
| Ralph | [RALPH1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3560) | [RALPH5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3808) | Wooper |
| Liz | [LIZ1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5343) | [LIZ5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5503) | Ledyba, Oddish |
| Anthony | [ANTHONY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4405) | [ANTHONY5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4608) | Dunsparce, Phanpy, Swinub |
| Todd | [TODD1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5652) | [TODD5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5780) | Cubone, Wooper Paldean |
| Gina | [GINA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5351) | [GINA5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5531) | Poliwag, Snubbull |
| Arnie | [ARNIE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3398) | [ARNIE5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3514) | Venonat |
| Alan | [ALAN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1381) | [ALAN5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1585) | Chinchou, Pawniard |
| Dana | [DANA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1928) | [DANA5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2011) | Swablu, Togetic |
| Chad | [CHAD1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1451) | [CHAD5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1621) | Eevee, Voltorb |
| Tully | [TULLY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3608) | [TULLY4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3824) | Seadra |
| Brent | [BRENT1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2905) | [BRENT4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2986) | Dunsparce, Munchlax |
| Tiffany | [TIFFANY3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5465) | [TIFFANY4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5547) | Jigglypuff |
| Vance | [VANCE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1689) | [VANCE3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1837) | Corviknight, Skarmory |
| Erin | [ERIN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5384) | [ERIN3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5475) | Ambipom, Dodrio, Dudunsparce, Farigiraf |

## Special-trainer verdicts — every named boss/family

These judgments distinguish actual stated specialization from visual preferences. A trainer can own unusual favorites, rotate captures, or use coverage without losing character.

| Trainer / family | Verdict | Party source records |
|---|---|---|
| Falkner | Strong fit. Every partner is a bird. Hoothoot/Fletchling/Pidgeotto visibly return as Noctowl/Talonflame/Pidgeot. Psychic Noctowl is still a bird. | [FALKNER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:20), [FALKNER2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:39) |
| Whitney | Normal/cute-companion theme works. Fairy Clefairy is explicitly allowed by the gym guide. Buneary → Lopunny continuity is optional (finding 12); large Normal favorites are valid. | [WHITNEY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:76), [WHITNEY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:100) |
| Bugsy | Strong insect/research theme. Pineco → Forretress and Scyther → Scizor preserve companion growth. Replacing Joltik with Vikavolt is a collection change, not an illegal evolution claim. | [BUGSY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:137), [BUGSY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:156) |
| Morty | All Ghosts; spiritual/night imagery works. Golett and Dragapult do not have to look like bedsheet ghosts to fit. His new collection is compatible with a mystic researching legends. | [MORTY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:193), [MORTY2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:217) |
| Chuck | Fighting discipline and raw training fit the entire roster. Gallade and Sirfetch'd introduce martial technique rather than breaking a supposed fists-only rule. | [CHUCK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:391), [CHUCK2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:420) |
| Jasmine | All Steel. Steelix is her signature; industrial, armored, bird and fairy-smith partners support the specialist. Her kindness does not require a team of only gentle-looking creatures. | [JASMINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:325), [JASMINE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:354) |
| Pryce | All Ice with a coherent winter/cold-water collection. Alolan Ninetales, Cetitan and Abomasnow are thematically appropriate. His actual ice attacks can freeze opponents; Icicle Crash itself need not freeze. | [PRYCE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:254), [PRYCE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:288) |
| Clair | All actual Dragon types in this hack, including Bug/Dragon Flygon and Dragon/Fairy Altaria. Archaludon and the reptilian powerhouses fit a proud Dragon master. | [CLAIR1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:457), [CLAIR2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:491) |
| Brock | Rock/fossil/geology identity works, including the accepted Steelix/Onix continuity. Defensive emphasis could be sharpened (finding 10), but Rampardos is buffed to base 90 Defense here. | [BROCK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1027) |
| Misty | All Water; Starmie signature, elegant Milotic, sea life and powerful Gyarados make a convincing experienced Water leader. No species change recommended. | [MISTY1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1064) |
| Lt. Surge | All Electric; machinery and strong physical partners suit a veteran. Raichu's selected Galvanize converts ExtremeSpeed/Hyper Voice into Electric attacks. No missing-Electric-STAB complaint is warranted. | [LT_SURGE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1101) |
| Erika | All Grass; plants, flowers, trees and graceful garden partners suit botany. Ludicolo's rain supports a plant collection; Erika is not explicitly limited to sun teams. | [ERIKA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1182) |
| Janine | All Poison; hazards, sleep, poison and ambush partners visibly support the ninja role. Venomoth's Sleep Powder and Toxapex's Baneful Bunker make the style distinct. | [JANINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:2080) |
| Sabrina | All Psychic, spanning mind control, dreams, protection and counterattacks. Mesmeria/Hypno demonstrate sleep directly. Gardevoir/Farigiraf/Wobbuffet do not break a Psychic identity. | [SABRINA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:3300) |
| Blaine | All Fire; volcanic Torkoal, fire beasts, artillery and Magmortar fit both burned-island backstory and veteran Fire mastery. No roster mismatch found. | [BLAINE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:4633) |
| Blue — Gym and Cinnabar rematch | Mixed veteran/champion teams are intentional. Pidgeot/Rhyperior/Scizor/Electivire remain recognizable across the two fights. The rematch dialogue explicitly says he changed his strategy; replacing Gyarados/Arcanine with Exeggutor/Blastoise is consistent. | [BLUE1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6502), [BLUE_CLOAK1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7123) |
| Will | Every member is Psychic. World-travel training accommodates the varied psychic animals and Gallade. A masked trainer is not automatically obliged to use only circus/mime species. | [WILL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:530), [WILL2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:564) |
| Koga | All Poison and the species suit traps, venom and stealth. The issue is sleep/confusion delivery versus his exact introduction, not an inappropriate species (finding 1). | [KOGA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:885), [KOGA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:919) |
| Bruno | All Fighting, with physical strength, discipline and technique. Toxicroak's poison and Annihilape's rage add methods without violating his actual power-focused dialogue. | [BRUNO1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:744), [BRUNO2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:778) |
| Karen | All Dark. The text specifically admires a wild, tough image: Grimmsnarl and Kingambit satisfy it. Her favorites can also be strong; a competitive team does not contradict that philosophy. | [KAREN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:814), [KAREN2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:848) |
| Lance | All Dragon with signature Dragonite. Diverse modern dragons fit his mastery. They need not be the exact historical three-Dragonite roster to fit this game. | [LANCE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:956), [LANCE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:990) |
| Silver — all 21 starter/story variants | The stolen starter persists, and the evolving mixed team fits his progression from harsh power-seeking to trust. Crobat could symbolize the final change but is optional (finding 13). Do not label gentle Meganium wrong merely because early Silver is cruel. | [RIVAL1_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7473), [RIVAL1_1_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7482), [RIVAL1_1_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7491), [RIVAL1_2_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7500), [RIVAL1_2_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7519), [RIVAL1_2_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7538), [RIVAL1_3_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7557), [RIVAL1_3_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7581), [RIVAL1_3_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7605), [RIVAL1_4_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7629), [RIVAL1_4_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7663), [RIVAL1_4_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7697), [RIVAL1_5_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7731), [RIVAL1_5_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7765), [RIVAL1_5_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7799), [RIVAL2_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7836), [RIVAL2_1_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7870), [RIVAL2_1_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7904), [RIVAL2_2_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7938), [RIVAL2_2_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7972), [RIVAL2_2_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8006) |
| Crystal — all 15 starter/story variants | Field researcher/collector identity fits the mixed team. The apple progression is LEGAL here: Applin → Dipplin, then Tart/Sweet/Syrupy Apple → Flapple/Appletun/Hydrapple. Xatu remains an anchor; Marowak continuity is optional (finding 14). Cape Xatu already supplies Thunder Wave, so her team is not devoid of capture support. | [CRYSTAL_1_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8045), [CRYSTAL_1_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8059), [CRYSTAL_1_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8073), [CRYSTAL_2_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8087), [CRYSTAL_2_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8111), [CRYSTAL_2_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8135), [CRYSTAL_3_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8159), [CRYSTAL_3_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8183), [CRYSTAL_3_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8207), [CRYSTAL_4_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8231), [CRYSTAL_4_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8260), [CRYSTAL_4_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8289), [CRYSTAL_5_CHIKORITA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8318), [CRYSTAL_5_CYNDAQUIL](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8352), [CRYSTAL_5_TOTODILE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8386) |
| Red — Mt. Silver and Pallet | Pikachu, Snorlax, Espeon, starters and later Lapras/Aerodactyl are credible partners for an experienced generalist. Both Pikachu sets use selected Galvanize, so their Normal attacks reinforce the Electric signature. No thematic swap recommended. | [RED1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6465), [RED2_1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7086) |
| Green | A varied experienced challenger is consistent with her dialogue. Wigglytuff/Nidoqueen/Venusaur give a recognizable companion core, while Ice/Fairy coverage can help face Dragon teams. The source does not prescribe an all-cute, all-Fairy or one-type team. | [GREEN1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7160) |
| Agatha | Ghost/Poison haunted identity fits. Arbok and Crobat are creepy classic companions. Eviolite Misdreavus, Haunter and duplicate Gengar can preserve a veteran's recognizable tastes; evolution stage and duplication alone are not theme failures. | [AGATHA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7012) |
| Lorelei | Ice/cold-water veteran identity works. Slowbro remains a valid personal partner; adding Ice Beam is optional (finding 16). Articuno is appropriate by type but deserves a line of bond/history if desired (finding 15). | [LORELEI1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:7049) |
| Eusine | Mystical/hypnosis-oriented partners fit his Entei pursuit without requiring Fire typing. The automatic rematch moves lose the earlier hypnosis demonstration and leave Dream Eater unsupported (finding 6). | [EUSINE](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6581), [EUSINE2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6600) |
| Proton | Impidimp/Grimmsnarl and clawed Perrserker/Sneasler/Zangoose fit a cruel, bullying enforcer. Steel or Fairy secondary types do not make them inappropriate Rocket partners. | [PROTON1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6617), [PROTON2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6636) |
| Petrel — base and fake Director | Ditto is an especially strong impersonator signature; Porygon technology and Banette's puppet imagery reinforce deception and private schemes. No new mismatch found. | [PETREL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6663), [PETREL_DIRECTOR1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6810) |
| Ariana | Danger, poison and sinister elegance work. Milotic fits that identity well; keeping it into the rematch would be a stronger personal through-line than Octillery, but artillery Octillery remains defensible (finding 17). | [ARIANA1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6693), [ARIANA2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6717) |
| Archer | Houndoom, Kingambit, Crobat and Dusknoir establish intimidating command. Cloyster is the weakest personal hook but still an armored weapon-like enforcer; any swap is optional (finding 18). ARCHER1 lacks a direct map reference. | [ARCHER1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6749), [ARCHER2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:6778) |
| Karate King Kiyo | All Fighting; his dialogue explicitly says he mastered many kinds of Fighting Pokémon. Bird swordsmen, clawed martial artists and mushroom fighters therefore fit rather than violating a narrow karate aesthetic. | [KARATE_KIYO](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8655) |
| Elder Li | Plants, growth, bonds and gentle control suit Sprout Tower. Hoppip/Exeggcute/Weepinbell form a deliberate Grass team; Poison Puppeteer even supports his control-oriented set. His overleveled evolution is a separate legality/balance choice, not a theme error. | [LI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:8423) |
| Cal / Trainer House | A training opponent is a generalist. The scalable starter team is coherent. CAL2's live mystery-gift behavior can replace the source placeholder, so its source record must not be overinterpreted as a personal fixed roster. | [CAL1](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:601), [CAL2](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:617), [CAL3](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:635), [CAL4](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:654), [CAL5](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:678), [CAL6](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:707) |

**Wise Trio:** Gaku's Fire core, Masa's Electric core and Koji's Water core echo the tower/beast story, with Xatu/Noctowl/Slowking reinforcing spiritual wisdom. They are Sages, not explicitly monotype leaders; Noctowl is not a mistaken Electric type. Their actual entries are [GAKU](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5934), [MASA](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5944), [KOJI](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:5954).

## Corrections and tempting false positives avoided

- **Koga can confuse in the first fight:** Poison Puppeteer must be counted. The supported complaint is absent sleep and absent rematch confusion.
- **Raichu/Pikachu have Electric offense:** their selected Galvanize converts Normal moves; move names alone are misleading.
- **Crystal's Dipplin can become Flapple or Appletun here:** this is explicitly implemented in [data/pokemon/evos_attacks_johto.asm:6343](C:/Users/luked/Documents/GitHub/Pokemon-Crimson-Crystal/data/pokemon/evos_attacks_johto.asm:6343).
- **Rampardos is not using its official-series Defense:** this source gives it 90, reducing the force of a defensive-theme objection.
- **Jasmine's Tinkaton/Corviknight pairing is not a documented contradiction in this game:** the local Tinkaton Pokédex text discusses stealing tools and smashing steel, not hunting Corviknight. External lore alone should not force a swap.
- **Shane's Moon Stone line is correct:** he still has Nidorino, and Nidorino really uses Moon Stone here. Donphan does not invalidate the line.
- **Boarder Ronald can freeze:** the automatic Delibird/Jynx sets contain Freeze-Dry/Ice Beam. Do not infer the moves from official-series learnsets.
- **Cody/Cara intentionally lack Dragons:** permission-based dialogue supports their Seadra/Gyarados/Aerodactyl choices. Local Dragon retypes on other trainers remain valid.
- **Pokéfan Carter's basic-starter names can refer to the partners he originally caught:** the three evolved starters retain that collection identity. Joshua's Pikachu gang reasonably includes Raichu forms.
- **Rival teams need not be monotype:** Meganium can become a loved partner even if Silver starts harsh; Crystal can rotate rare captures; Blue/Green/Red can field mixed teams.
- **The first-pass corrected trainers remain improved:** Jose has Farfetch'd in all tiers, Beth names Rapidash, Irwin has a ball/dexterity line, and the revised Cosplayer dialogue now establishes specific costume partners.

## Complete group coverage for this second pass

Every populated source group is represented below. This is a group-level conclusion; the companion current checklist supplies all 594 individual full rosters. A listed refinement does not condemn every member of that class.

| Group | Parties | Second-pass result |
|---|---|---|
| `FalknerGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `WhitneyGroup` | 2 | Specific issues/refinements: [12](#finding-12). Other rosters remain class-appropriate. |
| `BugsyGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `MortyGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `PryceGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `JasmineGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `ChuckGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `ClairGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `WillGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `PKMNTrainerGroup` | 6 | No additional thematic issue identified under class, location and actual-species rules. |
| `BrunoGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `KarenGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `KogaGroup` | 2 | Specific issues/refinements: [1](#finding-1). Other rosters remain class-appropriate. |
| `ChampionGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `BrockGroup` | 1 | Specific issues/refinements: [10](#finding-10). Other rosters remain class-appropriate. |
| `MistyGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `LtSurgeGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `ScientistGroup` | 5 | No additional thematic issue identified under class, location and actual-species rules. |
| `ErikaGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `YoungsterGroup` | 14 | Specific issues/refinements: [5](#finding-5). Other rosters remain class-appropriate. |
| `SchoolboyGroup` | 24 | Specific issues/refinements: [5](#finding-5). Other rosters remain class-appropriate. |
| `BirdKeeperGroup` | 19 | Specific issues/refinements: [2](#finding-2), [5](#finding-5), [19](#finding-19). Other rosters remain class-appropriate. |
| `LassGroup` | 19 | Specific issues/refinements: [5](#finding-5). Other rosters remain class-appropriate. |
| `JanineGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `CooltrainerMGroup` | 21 | No additional thematic issue identified under class, location and actual-species rules. |
| `CooltrainerFGroup` | 22 | Specific issues/refinements: [9](#finding-9). Other rosters remain class-appropriate. |
| `BeautyGroup` | 6 | No additional thematic issue identified under class, location and actual-species rules. |
| `PokemaniacGroup` | 15 | Specific issues/refinements: [5](#finding-5). Other rosters remain class-appropriate. |
| `GruntMGroup` | 18 | No additional thematic issue identified under class, location and actual-species rules. |
| `GentlemanGroup` | 4 | No additional thematic issue identified under class, location and actual-species rules. |
| `SkierGroup` | 4 | No additional thematic issue identified under class, location and actual-species rules. |
| `TeacherGroup` | 3 | No additional thematic issue identified under class, location and actual-species rules. |
| `SabrinaGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `BugCatcherGroup` | 19 | Specific issues/refinements: [5](#finding-5). Other rosters remain class-appropriate. |
| `FisherGroup` | 25 | Specific issues/refinements: [4](#finding-4), [5](#finding-5), [7](#finding-7), [8](#finding-8). Other rosters remain class-appropriate. |
| `SwimmerMGroup` | 13 | No additional thematic issue identified under class, location and actual-species rules. |
| `SwimmerFGroup` | 13 | No additional thematic issue identified under class, location and actual-species rules. |
| `SailorGroup` | 13 | Specific issues/refinements: [5](#finding-5). Other rosters remain class-appropriate. |
| `SuperNerdGroup` | 9 | No additional thematic issue identified under class, location and actual-species rules. |
| `GuitaristGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `HikerGroup` | 22 | Specific issues/refinements: [5](#finding-5). Other rosters remain class-appropriate. |
| `BlaineGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `BurglarGroup` | 5 | No additional thematic issue identified under class, location and actual-species rules. |
| `FirebreatherGroup` | 8 | No additional thematic issue identified under class, location and actual-species rules. |
| `JugglerGroup` | 9 | No additional thematic issue identified under class, location and actual-species rules. |
| `BlackbeltGroup` | 11 | Specific issues/refinements: [4](#finding-4). Other rosters remain class-appropriate. |
| `ExecutiveMGroup` | 4 | No additional thematic issue identified under class, location and actual-species rules. |
| `PsychicGroup` | 12 | No additional thematic issue identified under class, location and actual-species rules. |
| `PicnickerGroup` | 19 | Specific issues/refinements: [5](#finding-5). Other rosters remain class-appropriate. |
| `SchoolGirlGroup` | 8 | Specific issues/refinements: [11](#finding-11). Other rosters remain class-appropriate. |
| `CamperGroup` | 16 | Specific issues/refinements: [5](#finding-5). Other rosters remain class-appropriate. |
| `ExecutiveFGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `SageGroup` | 11 | No additional thematic issue identified under class, location and actual-species rules. |
| `MediumGroup` | 5 | No additional thematic issue identified under class, location and actual-species rules. |
| `BoarderGroup` | 6 | No additional thematic issue identified under class, location and actual-species rules. |
| `PokefanMGroup` | 15 | No additional thematic issue identified under class, location and actual-species rules. |
| `KimonoGirlGroup` | 9 | No additional thematic issue identified under class, location and actual-species rules. |
| `TwinsGroup` | 10 | No additional thematic issue identified under class, location and actual-species rules. |
| `PokefanFGroup` | 6 | Specific issues/refinements: [3](#finding-3). Other rosters remain class-appropriate. |
| `RedGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `BlueGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `OfficerGroup` | 3 | No additional thematic issue identified under class, location and actual-species rules. |
| `MysticalmanGroup` | 2 | Specific issues/refinements: [6](#finding-6). Other rosters remain class-appropriate. |
| `ProtonGroup` | 2 | No additional thematic issue identified under class, location and actual-species rules. |
| `PetrelGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `ArianaGroup` | 2 | Specific issues/refinements: [17](#finding-17). Other rosters remain class-appropriate. |
| `ArcherGroup` | 2 | Specific issues/refinements: [18](#finding-18). Other rosters remain class-appropriate. |
| `PetrelDirectorGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `HexManiacGroup` | 3 | No additional thematic issue identified under class, location and actual-species rules. |
| `CosplayerGroup` | 6 | No additional thematic issue identified under class, location and actual-species rules. |
| `NinjaGroup` | 4 | No additional thematic issue identified under class, location and actual-species rules. |
| `AgathaGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `LoreleiGroup` | 1 | Specific issues/refinements: [15](#finding-15), [16](#finding-16). Other rosters remain class-appropriate. |
| `Red2Group` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `BlueCloakGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `GreenGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `BattleGirlGroup` | 4 | No additional thematic issue identified under class, location and actual-species rules. |
| `TamerGroup` | 5 | No additional thematic issue identified under class, location and actual-species rules. |
| `GruntFGroup` | 16 | No additional thematic issue identified under class, location and actual-species rules. |
| `Rival1Group` | 15 | No additional thematic issue identified under class, location and actual-species rules. |
| `Rival2Group` | 6 | Specific issues/refinements: [13](#finding-13). Other rosters remain class-appropriate. |
| `CrystalGroup` | 15 | Specific issues/refinements: [14](#finding-14). Other rosters remain class-appropriate. |
| `ElderGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `AromaLadyGroup` | 3 | No additional thematic issue identified under class, location and actual-species rules. |
| `BikerGroup` | 9 | No additional thematic issue identified under class, location and actual-species rules. |
| `CueballGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |
| `KarateKingGroup` | 1 | No additional thematic issue identified under class, location and actual-species rules. |

## Battle Tower and limits

The Tower still selects its 70 identities independently of the shared room-based Pokémon pools. Occupational mismatches remain possible by design, as in the first review. No fixed personal team can truthfully be assigned to those names. Making the Tower monotype/class-themed would be a separate design change; it is not evidence that a particular stored trainer roster is wrong.

Dialogue claims were checked against the **current source**, not official-series memories. C-tier suggestions are interpretive and do not all deserve implementation. Local “just caught” claims can be explained by travel; missing battle members may be boxed; an animal can sing outside combat. No world rule establishes that a legendary bird is a unique individual. Those caveats are why these points have different priorities.

This pass made no changes to parties, maps, scripts, moves, abilities, trainer classes or ROMs. The phone stride diagnosis was also checked by reading the already-built ROM bytes; it was not inferred only from a theme preference. No full playthrough or live call sequence was performed for this review.
