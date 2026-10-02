# Crimson Crystal — Learnset Audit (level-up, TM/HM/tutor, egg)

## ✅ Pass 3 — modern level-up TM moves (2026-10-02)

Every TM/HM/tutor move that a Pokémon learns by level-up in Scarlet/Violet, Sword/Shield or Brilliant Diamond/Shining Pearl is now in its level-up learnset here too (61 moves on 49 Pokémon, `apply4.py`, log in `pass4_log.json`). The modern level is used; when the modern game only lists it as a level-1 relearn on an evolved form, the pre-evolution's level is used so it's actually learned. Most of these put back moves the first pass had trimmed (Psychic, Nasty Plot, Night Slash, Power Gem, the Slowpoke family's Surf, which replaces the Scald stand-in). After this, no Pokémon is missing a modern level-up TM move. TM-move overlap with level-up is now Night Slash 41%, Power Gem 47%, Nasty Plot 55%, Psychic 50%, Icicle Crash 70%, Dragon Dance 39%, which matches the official games.

---

## ✅ Pass 2 — "decent moves at every level" (2026-10-02)

Every Pokémon was checked level by level for its own stage of evolution (and moves carried over from its pre-evolution), using its final form's Attack vs Sp. Atk to decide whether it needs **physical** or **special** moves. Targets: something real to attack with by Lv12, a same-type attack of the right kind of ~50+ power by Lv20, ~65+ by Lv30, ~75+ by Lv40, ~85+ by Lv50, and no stretch of 12+ levels with nothing new before Lv40. New moves and levels were taken from the Gen 8/9 learnsets (PokéAPI data) wherever the move exists in this game.

- Flagged at the start: 104 Pokémon. 151 species were changed (`_ai_artifacts/scratch/learnset_fix/apply2.py`, `apply3.py`; logs in `pass2_log.json` / `pass3_log.json`).
- Examples: Mareep line gets **Volt Switch** (special) at 17 and Thunderbolt at 36 on Flaaffy/Ampharos instead of a physical Spark; Magnemite/Voltorb/Jolteon get Volt Switch too; Pawniard line Night Slash 30 / Iron Head 40-42; Rookidee line Wing Attack 16 / Drill Peck 28-30; Mimikyu Shadow Claw 20 / Play Rough 34; Mawile Fairy Wind 15 / Metal Claw 20 / Iron Head 31; Charcadet Flame Charge 18 / Fire Fang 28; Qwilfish Poison Jab 21; Shieldon Taunt 5 / Ancient Power 10; Spoink Confusion 5; Bounsweet Razor Leaf 6; Paldean Tauros (Fire) lost the Water moves it had copied from the Water breed.
- Still flagged afterwards (22), on purpose: final forms whose best level-up STAB at Lv50 is 80 power instead of 85 (Scyther/Scizor/Kleavor, Tyrantrum, Bastiodon, Corsola/Cursola, Glimmora, Archaludon, Alolan Persian, Perrserker, Parasect, Nidorina/Nidorino) — they get the rest from TMs; Pineco/Forretress (Gyro Ball is variable-power and strong for them, the check counts it as 1); Dragonair, Drakloak and Vibrava (60-power physical STAB until their mid-30s, but they have strong special or non-STAB moves); Slugma (Ember until Flamethrower 29 — there's no mid-power special Fire move in the game); Exeggcute and Alolan Raticate (a learnset that ends early).

**TM timing check (no changes made):** every TM and HM has a source. Gym TMs line up with the gym levels (Falkner ~Lv9 → Mud-Slap … Clair ~Lv43 → Dragon Claw). Flamethrower, Thunderbolt and Ice Beam come from the Goldenrod tutor, which only appears after the Elite Four; Psychic, Energy Ball, Power Gem, Nasty Plot and Earthquake only show up in Kanto or on Victory Road. That's why special attackers now get their mid-game same-type moves by level-up.

---

## ✅ Fix pass applied — 2026-10-02

Everything below was applied with `_ai_artifacts/scratch/learnset_fix/apply.py` (data in `topup.json` / `topup2.json`), the ROM was rebuilt cleanly, and the audit was re-run.

| Check | Before | After |
|---|---|---|
| Evolutions that lose TMs vs. pre-evo | 45 | **0** |
| Species that learn a TM move by level but can't use the TM | 186 | **0** |
| Learnsets with duplicate entries | 98 | **0** (Smeargle's Sketch excluded) |
| Added-Pokémon TM list median / minimum | 17 / 9 | **21.5 / 11** |
| Night Slash given by level to lines that can use the TM | 77% | **31%** |
| Power Gem | 75% | **38%** |
| Nasty Plot | 66% | **34%** |
| Psychic | 53% | **45%** (only Psychic-types keep it) |
| Dragon Dance | 52% | **39%** |
| Families with no egg moves | 103 | **18** (legendaries, Ditto, Unown, Smeargle, Caterpie, Weedle, Magikarp, Wynaut — on purpose) |
| Egg moves already learned by level / that are TMs / dead lists | 65 / 8 / 6 | **0 / 0 / 0** |
| Most common egg move | Flail (19 families) | Haze (25 of 213) — nothing over ~12% |
| Superpower / Body Press in level-up | 38 / 26 lines | 10 / 18 (kept on Fighting types / very bulky mons; moved to egg lists elsewhere) |

**What changed, in short**
- Totodile restored; Kotora's Lv5 Volt Tackle and Slack Off replaced (Volt Tackle is now a Kotora egg move); Togepi/Togetic Extrasensory moved to 20; Jynx Ice Punch moved to 28; Gorochu got a full learnset.
- Stone/late evolutions now learn moves at their pre-evolution's levels (Raichu, Ninetales, Wigglytuff, Clefable, Vileplume, Arcanine, Poliwrath, Victreebel, Cloyster, Exeggutor, Starmie, Sunflora, Ludicolo, Togekiss, Mismagius, Nidoqueen/king, Honchkrow, Excadrill, the Alolan/Hisuian forms, etc.) and get back strong moves they were losing.
- Thin sets filled: Dreepy line, Duraludon/Archaludon, Charcadet/Armarouge/Ceruledge, Impidimp/Morgrem, Wimpod, Applin, Bounsweet/Steenee/Tsareena, Pawniard line, Golett/Golurk, Fletchling line, Lucario, Doduo/Dodrio, Gyarados, Dunsparce/Dudunsparce. Larvitar line, Marill/Azumarill, Cranidos, Mankey line, Krabby/Kingler, Sentret/Furret early power pushed back.
- Over-given TM moves trimmed from level-up (kept on signature users), Slowpoke family de-duplicated (Surf → Scald).
- TMs: every evolution ⊇ its pre-evo; universal TMs added (Attract only for gendered mons, removed from genderless ones); type/role TMs added for the added Pokémon; every TM move learned by level is now TM-compatible; Kabuto gets Surf; Salamence/Gliscor/Togekiss get Fly.
- Egg moves: dead lists merged into the babies, redundant/obsolete entries removed, 4–7 egg moves for every eligible family. The 9 starter `_CLONE` entries mirror their originals.
- `pokecrystal.link`: "Egg Moves 2" no longer pinned to bank $12 (it grew past the bank); it now floats, which the indirect pointer tables support.

**Judgement calls left as-is:** Unown keeps Lv1 Earth Power; Butterfree, Gyarados and Jumpluff keep their canon "no Fly" (Mantine now gets Fly because Mantyke had it, Yanmega via the Flying-type rule); Wynaut/Wobbuffet stay egg-less (vanilla); Stealth Rock stays on Rock/Steel/Ground types; the Lv16–22 Take Down lines and Chikorita's Lv23 Energy Ball were left alone. On re-check, Larvesta (Flame Wheel 18) and Grubbin (Bug Bite 10) did have early STAB, so they weren't changed.

---

## Original audit (before the fix pass)

_Generated 2026-10-01 from the current source (`evos_attacks_*.asm`, `base_stats/*.asm`, `egg_moves_*.asm`). 486 species / 213 evolution families checked (the 9 starter `_CLONE` entries were skipped since they mirror the originals)._

## Verdict

| Area | Verdict |
|---|---|
| **Level-up learnsets** | **Mostly good.** The original 251 and the regional forms are thoughtfully modernized. Needs a cleanup pass, not a rewrite: one broken set (Totodile), a batch of stone-evolution "late learner" sets, ~98 sets with duplicate entries, and some thin new-mon sets. |
| **TM compatibility** | **Needs redoing for the added (Gen 4+) Pokémon.** Original 251 average ~24 TMs; added mons average ~17, and dozens of evolved forms have *fewer* TMs than their pre-evolution (Rhyperior 11 vs Rhydon 34, Lickilicky 12 vs Lickitung 37, Gorochu 9 vs Raichu 28). |
| **TMs inside level-up learnsets** | **Fine overall, a few TMs are over-given.** Average is ~3 TM moves per learnset and most are utility (Curse, Protect, Rest, Swagger, Headbutt). The problem TMs are Night Slash, Power Gem, Icicle Crash, Nasty Plot, Psychic and Dragon Dance — over half of the lines that can use those TMs already get them by level. |
| **Egg moves** | **Needs redoing.** They are not "too common" — the opposite. They are essentially untouched vanilla GSC lists: 80 of 91 added families have **no egg moves at all**, 65 families have egg moves they already learn by level-up, and 6 lists are dead data. Since the ¥5000 Egg Move Tutor teaches these, empty/redundant lists matter. |

Context that shaped the judgement: TMs are reusable (`engine/items/tmhm.asm`), there is a ¥1000 Move Reminder and a ¥5000 Egg Move Tutor that teaches the base form's egg list to any family member (`EggMoveTutor_GetTeachableMoves`). So TM overlap is about **TM value/identity**, not scarcity, and egg lists act as a **family tutor list**.

---

## 1. Fix first (bugs)

1. **Totodile's level-up set is test data.** Lv1 Weather Ball, Lv1 Torment, 4 Taunt, 5 Yawn, 6 Sticky Web, **7 Explosion, 8 Draco Meteor**, 9 Octazooka. Git history shows these slots being rotated (Lumina Crash / Wood Hammer / Dark Pulse…) — looks like the animation-test mon. It also has no Water move until 26 and no Scratch/Leer/Water Gun. Restore to mirror Croconaw's opening (1 Scratch, 1 Leer, 5 Water Gun, 8 Mud-Slap, 11 Bite, 14 Scary Face, 17 Ice Fang, 18 Aqua Jet…).
2. **Gorochu** (Raichu → Dusk Stone) has only 9 TMs and is missing Protect, Return, Hidden Power, Attract, Swagger, Facade, Curse; it learns Thunderpunch/Fire Punch by level but can't use either TM; its learnset is 11 moves with a Lv6→22 gap.
3. **Kotora gets Volt Tackle at Lv5** (and Slack Off at 1) while Raitora/Gorotora never get Volt Tackle — looks like a placeholder.
4. **Togepi has Extrasensory at Lv1**, Unown has Earth Power at Lv1 (intentional?), Jynx has Ice Punch at Lv9 (wild Jynx get a 75-power STAB immediately).
5. **Dead egg-move data** (the game reads the *lowest stage*, so these never do anything):
- Chansey has Present, Metronome, Heal Bell — but the family's egg list is read from **Happiny**
- Mr. Mime has Future Sight, Hypnosis, Mimic — but the family's egg list is read from **Mime Jr.**
- Snorlax has Lick — but the family's egg list is read from **Munchlax**
- Marill has Light Screen, Present, Amnesia, Future Sight, Belly Drum, Perish Song, Supersonic, Foresight — but the family's egg list is read from **Azurill**
- Sudowoodo has Selfdestruct — but the family's egg list is read from **Bonsly**
- Mantine has Twister, Hydro Pump, Haze, Slam — but the family's egg list is read from **Mantyke**

---

## 2. TM / HM / tutor compatibility — needs redoing for added mons

### 2a. Evolutions that LOSE TMs their pre-evolution had (most important)
An evolved form should be a superset of its pre-evo. These lose TMs (count = TMs lost):

| Evolution | Lost | TMs lost |
|---|---|---|
| Lickitung → **Lickilicky** | 25 | Drain Punch, Headbutt, Rock Tomb, Rock Smash, Sunny Day, Blizzard, Hyper Beam, Rain Dance, Iron Head, Thunder, Earthquake, Shadow Ball, Mud Slap, Ice Punch, Sandstorm, Fire Blast, Thunderpunch, Thief, Fire Punch, Cut, Surf, Strength, Flamethrower, Thunderbolt, Ice Beam |
| Rhydon → **Rhyperior** | 24 | Drain Punch, Headbutt, Rock Tomb, Roar, Zap Cannon, Rock Smash, Sunny Day, Blizzard, Hyper Beam, Iron Head, Thunder, Earthquake, Dig, Mud Slap, Sandstorm, Fire Blast, Thunderpunch, Fire Punch, Bug Bite, Surf, Strength, Flamethrower, Thunderbolt, Ice Beam |
| Ursaring → **Ursaluna** | 21 | Drain Punch, Headbutt, Rock Tomb, Roar, Zap Cannon, Rock Smash, Sunny Day, Work Up, Hyper Beam, Earthquake, Dig, Mud Slap, Ice Punch, Swift, Thunderpunch, Thief, Fire Punch, Bug Bite, Hone Claws, Cut, Strength |
| Raichu → **Gorochu** | 19 | Drain Punch, Headbutt, Curse, Rock Tomb, Zap Cannon, Hidden Power, Protect, Rain Dance, Facade, Iron Head, Return, Mud Slap, Swagger, Knock Off, Thunderpunch, Nasty Plot, Attract, Thief, Strength |
| Primeape → **Annihilape** | 18 | Drain Punch, Headbutt, Rock Smash, Sunny Day, Work Up, Hyper Beam, Iron Head, Thunder, Dig, Mud Slap, Ice Punch, Swift, Thunderpunch, Thief, Fire Punch, Hone Claws, Strength, Thunderbolt |
| Electabuzz → **Electivire** | 18 | Drain Punch, Headbutt, Zap Cannon, Rock Smash, Hyper Beam, Rain Dance, Iron Head, Thunder, Psychic, Mud Slap, Ice Punch, Swift, Thunderpunch, Thief, Fire Punch, Strength, Flash, Thunderbolt |
| Aipom → **Ambipom** | 18 | Drain Punch, Headbutt, Zap Cannon, Rock Smash, Sunny Day, Iron Head, Thunder, Shadow Ball, Mud Slap, Ice Punch, Swift, Thunderpunch, Thief, Fire Punch, Bug Bite, Cut, Strength, Thunderbolt |
| Bloodmoon Ursaring → **Bloodmoon Ursaluna** | 17 | Drain Punch, Headbutt, Rock Tomb, Roar, Zap Cannon, Sunny Day, Work Up, Hyper Beam, Mud Slap, Ice Punch, Swift, Thunderpunch, Thief, Fire Punch, Bug Bite, Hone Claws, Cut |
| Togetic → **Togekiss** | 17 | Headbutt, Rock Tomb, Zap Cannon, Rock Smash, Sunny Day, Hyper Beam, Rain Dance, Solarbeam, Psychic, Shadow Ball, Mud Slap, Fire Blast, Swift, Steel Wing, Fly, Flash, Flamethrower |
| Sneasel → **Weavile** | 17 | Drain Punch, Headbutt, Rock Smash, Blizzard, Rain Dance, Iron Head, Dig, Shadow Ball, Mud Slap, Ice Punch, Swift, Thief, Bug Bite, Cut, Surf, Strength, Ice Beam |
| Girafarig → **Farigiraf** | 15 | Headbutt, Zap Cannon, Rock Smash, Sunny Day, Work Up, Iron Head, Thunder, Earthquake, Psychic, Shadow Ball, Mud Slap, Swift, Thief, Strength, Thunderbolt |
| Dunsparce → **Dudunsparce** | 15 | Headbutt, Rock Tomb, Zap Cannon, Rock Smash, Sunny Day, Rain Dance, Solarbeam, Iron Head, Thunder, Dig, Mud Slap, Thief, Strength, Flamethrower, Thunderbolt |
| Magmar → **Magmortar** | 14 | Drain Punch, Headbutt, Rock Smash, Sunny Day, Hyper Beam, Iron Head, Psychic, Mud Slap, Fire Blast, Thunderpunch, Thief, Fire Punch, Strength, Flamethrower |
| Jynx → **Mesmeria** | 14 | Drain Punch, Headbutt, Sweet Scent, Blizzard, Hyper Beam, Rain Dance, Psychic, Shadow Ball, Mud Slap, Ice Punch, Nasty Plot, Thief, Zen Headbutt, Ice Beam |
| Porygon2 → **Porygon-Z** | 13 | Zap Cannon, Sunny Day, Blizzard, Hyper Beam, Rain Dance, Iron Head, Thunder, Psychic, Swift, Thief, Flash, Thunderbolt, Ice Beam |
| Stantler → **Wyrdeer** | 12 | Headbutt, Roar, Sunny Day, Work Up, Rain Dance, Earthquake, Psychic, Mud Slap, Swift, Thief, Zen Headbutt, Flash |
| Misdreavus → **Mismagius** | 11 | Headbutt, Zap Cannon, Sunny Day, Rain Dance, Thunder, Psychic, Shadow Ball, Swift, Thief, Flash, Thunderbolt |
| Gligar → **Gliscor** | 11 | Headbutt, Rock Smash, Sunny Day, Iron Head, Sludge Bomb, Sandstorm, Swift, Thief, Bug Bite, Cut, Strength |
| Tangela → **Tangrowth** | 10 | Headbutt, Sunny Day, Sweet Scent, Hyper Beam, Energy Ball, Solarbeam, Sludge Bomb, Thief, Cut, Flash |
| Qwilfish → **Overqwil** | 10 | Headbutt, Rock Tomb, Blizzard, Rain Dance, Sludge Bomb, Swift, Surf, Whirlpool, Waterfall, Ice Beam |
| Piloswine → **Mamoswine** | 10 | Headbutt, Roar, Rock Smash, Blizzard, Hyper Beam, Rain Dance, Earthquake, Mud Slap, Strength, Ice Beam |
| Magneton → **Magnezone** | 8 | Rock Tomb, Zap Cannon, Hyper Beam, Rain Dance, Thunder, Swift, Flash, Thunderbolt |
| Yanma → **Yanmega** | 7 | Headbutt, Sunny Day, Energy Ball, Solarbeam, Swift, Thief, Flash |
| Eevee → **Sylveon** | 7 | Headbutt, Sunny Day, Rain Dance, Iron Head, Shadow Ball, Mud Slap, Swift |
| Eevee → **Leafeon** | 7 | Headbutt, Sunny Day, Rain Dance, Iron Head, Shadow Ball, Mud Slap, Swift |
| Eevee → **Glaceon** | 7 | Headbutt, Sunny Day, Rain Dance, Iron Head, Shadow Ball, Mud Slap, Swift |
| Quilava → **Hisuian Typhlosion** | 5 | Work Up, Facade, Dig, Mud Slap, Bug Bite |
| Anorith → **Armaldo** | 5 | Rock Smash, Earthquake, Dig, Sandstorm, Strength |
| Galarian Corsola → **Cursola** | 4 | Blizzard, Energy Ball, Dig, Waterfall |
| Bisharp → **Kingambit** | 4 | Knock Off, Thief, Hone Claws, Cut |
| Pikachu → **Alolan Raichu** | 3 | Facade, Mud Slap, Fly |
| Croconaw → **Feraligatr** | 3 | Fly, Flash, Waterfall |
| Steenee → **Tsareena** | 2 | Cut, Flash |
| Scyther → **Kleavor** | 2 | Knock Off, Steel Wing |
| Mime Jr. → **Mr. Mime** | 2 | Rock Smash, Rain Dance |
| Mantyke → **Mantine** | 2 | Earthquake, Fly |
| Exeggcute → **Alolan Exeggutor** | 2 | Facade, Psychic |
| Cubone → **Alolan Marowak** | 2 | Facade, Mud Slap |
| Natu → **Watu** | 1 | Zen Headbutt |
| Koffing → **Galarian Weezing** | 1 | Facade |
| Gloom → **Bellossom** | 1 | Sludge Bomb |
| Farfetch'd → **Sirfetch'd** | 1 | Night Slash |
| Dipplin → **Flapple** | 1 | Rock Tomb |
| Alolan Diglett → **Alolan Dugtrio** | 1 | Hone Claws |
| Chansey → **Blissey** | 1 | Iron Head |

### 2b. Thin TM lists (fully evolved, ≤16 TMs; originals' median is 24)
Cradily (9), Gorochu (9), Mesmeria (9), Overqwil (9), Scolipede (9), Wyrdeer (9), Dudunsparce (10), Dusknoir (10), Lopunny (10), Magnezone (10), Tangrowth (10), Yanmega (10), Annihilape (11), Farigiraf (11), Glaceon (11), Grimmsnarl (11), Mamoswine (11), Porygon-Z (11), Rhyperior (11), Sylveon (11), Tinkaton (11), Ursaluna (11), Vikavolt (11), Volcarona (11), Abomasnow (12), Armaldo (12), Centiskorch (12), Conkeldurr (12), Electivire (12), Froslass (12), Gardevoir (12), Gliscor (12), Golurk (12), Leafeon (12), Lickilicky (12), Magmortar (12), Mismagius (12), Togekiss (12), Walrein (12), Ambipom (13), Armarouge (13), Ceruledge (13), Dragapult (13), Glimmora (13), Grumpig (13), Baxcalibur (14), Drifblim (14), Golisopod (14), Galarian Rapidash (14), Salamence (14), Toxapex (14), Weavile (14), Excadrill (15), Hydreigon (15), Staraptor (15), Jumpluff (16), Talonflame (16), Toxicroak (16), Bloodmoon Ursaluna (16)

Most of these are just the universal TMs + 1–3 picks. Examples of obvious gaps: Gardevoir has no Psychic/Shadow Ball TM; Magmortar has no Flamethrower/Fire Blast/Fire Punch; Rhyperior has no Earthquake/Rock Tomb; Mamoswine no Earthquake/Blizzard; Togekiss no Fly/Psychic/Flamethrower; Volcarona no Bug Bite/Psychic/Solarbeam/Energy Ball; Porygon-Z no Thunderbolt/Ice Beam/Psychic; Excadrill no Iron Head/Rock Tomb; Salamence no Fly/Flamethrower/Earthquake.

### 2c. Missing "universal" TMs
(Attract on genderless mons is correctly absent and not listed.)
- Missing **Facade**: Galarian Corsola, Alolan Rattata, Alolan Raticate, Alolan Raichu, Alolan Sandshrew, Alolan Sandslash, Alolan Vulpix, Alolan Ninetales, Alolan Diglett, Alolan Dugtrio, Alolan Meowth, Alolan Persian, Alolan Geodude, Alolan Graveler, Alolan Golem, Alolan Grimer, Alolan Muk, Alolan Exeggutor, Alolan Marowak, Galarian Meowth, Perrserker, Galarian Ponyta, Galarian Rapidash, Galarian Slowpoke, Galarian Slowbro, Galarian Slowking, Galarian Weezing, Hisuian Growlithe, Hisuian Arcanine, Hisuian Typhlosion, Hisuian Sneasel, Sneasler, Paldean Wooper, Clodsire, Paldean (Fire) Tauros, Paldean (Water) Tauros, Azurill, Bonsly
- Missing **Curse**: Bounsweet, Steenee, Glimmet, Glimmora, Mareanie, Toxapex, Joltik, Galvantula, Noibat, Noivern
- Missing **Facade, Curse**: Mime Jr., Happiny, Mantyke
- Missing **Rest, Swagger, Facade**: Starly, Staravia, Staraptor
- Missing **Protect, Return, Hidden Power, Attract, Swagger, Facade, Curse**: Gorochu
- Hisuian Voltorb/Electrode: missing Facade

The Facade gap across every regional form suggests Facade became a TM after those were written.

### 2d. Learns a TM move by level-up but can't use the TM (189 species)
Either add the TM or drop the level-up entry — inconsistent either way.
- Bulbasaur (Sludge Bomb); Ivysaur (Sludge Bomb); Venusaur (Sludge Bomb)
- Caterpie (Bug Bite); Butterfree (Bug Bite)
- Weedle (Bug Bite)
- Alolan Raichu (Psychic); Gorochu (Fire Punch, Thunderpunch)
- Vulpix (Roar)
- Venonat (Bug Bite); Venomoth (Bug Bite)
- Diglett (Sandstorm); Dugtrio (Sandstorm)
- Psyduck (Psychic); Golduck (Psychic)
- Annihilape (Work Up)
- Golem (Iron Head, Thunderpunch)
- Magnezone (Thunderbolt, Zap Cannon)
- Sirfetch'd (Night Slash)
- Dewgong (Icicle Crash)
- Gastly (Sludge Bomb); Haunter (Sludge Bomb); Gengar (Sludge Bomb)
- Onix (Rock Tomb)
- Alolan Exeggutor (Psychic)
- Alolan Marowak (Mud Slap)
- Rhyperior (Earthquake, Rock Tomb)
- Scyther (Work Up); Scizor (Iron Head, Work Up); Kleavor (Rock Tomb)
- Mesmeria (Blizzard, Ice Beam, Psychic)
- Electivire (Fire Punch, Ice Punch, Swift, Thunder, Thunderbolt, Thunderpunch)
- Magmortar (Fire Blast, Fire Punch, Flamethrower, Hyper Beam, Sunny Day, Thunderpunch)
- Lapras (Icicle Crash)
- Glaceon (Blizzard, Ice Beam, Swift); Leafeon (Night Slash, Sunny Day, Swift); Sylveon (Swift)
- Porygon-Z (Hyper Beam, Psychic, Thunderbolt, Zap Cannon)
- Omanyte (Power Gem); Omastar (Power Gem)
- Kabuto (Waterfall); Kabutops (Waterfall)
- Aerodactyl (Rock Tomb)
- Moltres (Energy Ball, Solarbeam)
- Dratini (Hyper Beam); Dragonair (Hyper Beam)
- Totodile (Night Slash, Weather Ball); Croconaw (Night Slash); Feraligatr (Night Slash)
- Sentret (Zen Headbutt)
- Hoothoot (Psychic); Noctowl (Psychic)
- Ledyba (Bug Bite); Ledian (Bug Bite)
- Spinarak (Bug Bite); Ariados (Bug Bite)
- Ambipom (Swift)
- Yanma (Bug Bite); Yanmega (Bug Bite)
- Mismagius (Shadow Ball)
- Unown (Hidden Power, Psychic)
- Farigiraf (Psychic)
- Pineco (Bug Bite); Forretress (Bug Bite, Zap Cannon)
- Dunsparce (Work Up); Dudunsparce (Dig, Mud Slap, Work Up)
- Gligar (Earthquake, Mud Slap); Gliscor (Earthquake, Mud Slap)
- Overqwil (Night Slash)
- Shuckle (Bug Bite, Sweet Scent)
- Teddiursa (Sweet Scent); Ursaring (Sweet Scent); Ursaluna (Earthquake, Sweet Scent, Work Up)
- Mamoswine (Blizzard, Earthquake, Mud Slap)
- Skarmory (Iron Head)
- Wyrdeer (Psychic, Work Up, Zen Headbutt)
- Larvitar (Rock Tomb); Pupitar (Rock Tomb); Tyranitar (Rock Tomb)
- Bagon (Flamethrower, Headbutt); Shelgon (Flamethrower, Headbutt); Salamence (Flamethrower, Fly, Headbutt)
- Ralts (Psychic); Kirlia (Psychic); Gardevoir (Psychic)
- Venipede (Bug Bite); Whirlipede (Bug Bite); Scolipede (Bug Bite)
- Lileep (Energy Ball, Rock Tomb); Cradily (Energy Ball, Rock Tomb)
- Anorith (Bug Bite, Rock Tomb); Armaldo (Bug Bite, Rock Tomb)
- Golett (Earthquake, Mud Slap, Rock Tomb, Shadow Ball); Golurk (Earthquake, Mud Slap, Rock Tomb, Shadow Ball)
- Duskull (Shadow Ball); Dusclops (Fire Punch, Ice Punch, Shadow Ball, Thunderpunch); Dusknoir (Fire Punch, Ice Punch, Shadow Ball, Thunderpunch)
- Larvesta (Bug Bite); Volcarona (Bug Bite, Fire Blast)
- Deino (Headbutt, Roar); Zweilous (Headbutt, Roar); Hydreigon (Headbutt, Hyper Beam, Roar)
- Tinkatink (Rock Smash); Tinkatuff (Rock Smash); Tinkaton (Iron Head, Rock Smash)
- Frigibax (Ice Beam); Arctibax (Ice Beam); Baxcalibur (Ice Beam)
- Armarouge (Flamethrower)
- Snover (Blizzard, Icicle Crash); Abomasnow (Blizzard, Ice Punch, Icicle Crash)
- Dipplin (Sweet Scent); Appletun (Headbutt, Sweet Scent); Flapple (Fly); Hydrapple (Sweet Scent)
- Duraludon (Hyper Beam); Archaludon (Hyper Beam)
- Shroomish (Headbutt, Solarbeam); Breloom (Headbutt)
- Buneary (Headbutt); Lopunny (Headbutt)
- Numel (Flamethrower); Camerupt (Flamethrower)
- Sizzlipede (Bug Bite); Centiskorch (Bug Bite)
- Grubbin (Bug Bite, Dig, Mud Slap); Charjabug (Bug Bite, Dig, Mud Slap); Vikavolt (Bug Bite, Dig, Fly, Mud Slap, Thunderbolt)
- Croagunk (Mud Slap, Sludge Bomb); Toxicroak (Mud Slap, Sludge Bomb)
- Drifloon (Shadow Ball); Drifblim (Shadow Ball)
- Drilbur (Mud Slap, Rock Tomb); Excadrill (Iron Head, Mud Slap, Rock Tomb)
- Trapinch (Bug Bite, Mud Slap); Vibrava (Mud Slap); Flygon (Mud Slap)
- Snorunt (Blizzard, Headbutt, Ice Beam); Froslass (Blizzard, Headbutt, Ice Beam, Shadow Ball)
- Golisopod (Bug Bite, Rock Smash)
- Spoink (Psychic); Grumpig (Psychic)
- Pawniard (Iron Head); Bisharp (Iron Head); Kingambit (Iron Head)
- Lotad (Rain Dance); Lombre (Rain Dance); Ludicolo (Rain Dance)
- Scraggy (Headbutt); Scrafty (Headbutt)
- Spheal (Blizzard, Ice Beam); Sealeo (Blizzard, Ice Beam); Walrein (Blizzard, Ice Beam)
- Bloodmoon Teddiursa (Sweet Scent); Bloodmoon Ursaring (Sweet Scent); Bloodmoon Ursaluna (Work Up)
- Cranidos (Iron Head); Rampardos (Iron Head)
- Shieldon (Iron Head); Bastiodon (Iron Head)
- Cetoddle (Work Up); Cetitan (Work Up)
- Lucario (Ice Punch, Thunderpunch)
- Tyrunt (Rock Tomb); Tyrantrum (Rock Tomb)
- Amaura (Hyper Beam, Rock Tomb); Aurorus (Power Gem, Rock Tomb)
- Alolan Raticate (Work Up)
- Alolan Diglett (Iron Head, Mud Slap); Alolan Dugtrio (Iron Head, Mud Slap)
- Galarian Ponyta (Flamethrower, Psychic); Galarian Rapidash (Flamethrower, Psychic)
- Galarian Slowpoke (Psychic, Sludge Bomb); Galarian Slowbro (Psychic); Galarian Slowking (Psychic)
- Glimmet (Rock Tomb); Glimmora (Rock Tomb)
- Archen (Rock Tomb); Archeops (Rock Tomb)
- Joltik (Bug Bite); Galvantula (Bug Bite)
- Mawile (Sweet Scent)
- Palafin (Work Up)
- Starly (Facade); Staravia (Facade); Staraptor (Facade)
- Sandile (Hone Claws); Krokorok (Hone Claws); Krookodile (Hone Claws)

### 2e. HM gaps
- Water type with no Surf: Kabuto.
- Fully-evolved fliers with no Fly: Butterfree, Gyarados, Jumpluff, Mantine, **Salamence** (learns Fly by level but not HM-compatible), **Gliscor**, **Togekiss**, Yanmega.

---

## 3. Are TMs too common in level-up learnsets?

Overall: **no.** Mean is 3 TM moves per learnset (median 3), and most of those are utility TMs. The issue is concentrated in a few TMs that most of their users already learn by level, which makes the TM pointless:

| TM | # | Lines that can use it AND get it by level | % |
|---|---|---|---|
| Night Slash | TM51 | 23/30 | 77% |
| Power Gem | TM53 | 15/20 | 75% |
| Icicle Crash | TM16 | 5/7 | 71% |
| Nasty Plot | TM42 | 25/38 | 66% |
| Psychic | TM29 | 20/38 | 53% |
| Dragon Dance | TM43 | 12/23 | 52% |
| Dragon Claw | TM24 | 10/22 | 45% |
| Dragon Pulse | TM09 | 15/39 | 38% |
| Flamethrower | Tutor | 15/46 | 33% |
| Knock Off | TM35 | 24/76 | 32% |
| Zen Headbutt | TM52 | 22/70 | 31% |
| Earthquake | TM26 | 20/66 | 30% |
| Rock Tomb | TM04 | 14/47 | 30% |
| Sludge Bomb | TM36 | 9/32 | 28% |
| Sweet Scent | TM12 | 5/18 | 28% |
| Will O Wisp | TM20 | 10/37 | 27% |

Who gets the worst offenders naturally:
- **Night Slash** (23 lines): Sandshrew, Diglett, Meowth, Mankey, Farfetch'd, Scyther, Kabuto, Spinarak, Yanma, Murkrow, Gligar, Heracross, Sneasel, Teddiursa, Skarmory, Ralts, Charcadet, Pawniard, Alolan Diglett, Alolan Meowth, Galarian Meowth, Zangoose, Seviper
- **Power Gem** (15 lines): Meowth, Psyduck, Slowpoke, Staryu, Eevee, Mareep, Misdreavus, Slugma, Corsola, Spoink, Shieldon, Galarian Corsola, Alolan Meowth, Galarian Slowpoke, Glimmet
- **Icicle Crash** (5 lines): Shellder, Sneasel, Swinub, Frigibax, Alolan Sandshrew
- **Nasty Plot** (25 lines): Pichu, Vulpix, Zubat, Meowth, Slowpoke, Drowzee, Mime Jr., Smoochum, Porygon, Mew, Togepi, Aipom, Murkrow, Girafarig, Sneasel, Houndour, Celebi, Deino, Impidimp, Croagunk, Riolu, Alolan Meowth, Galarian Slowpoke, Shuppet, Salandit
- **Psychic** (20 lines): Caterpie, Venonat, Abra, Slowpoke, Drowzee, Exeggcute, Staryu, Mime Jr., Smoochum, Eevee, Porygon, Mewtwo, Mew, Spinarak, Natu, Girafarig, Stantler, Celebi, Ralts, Flittle
- **Dragon Dance** (12 lines): Horsea, Magikarp, Lapras, Dratini, Totodile, Larvitar, Bagon, Dreepy, Swablu, Applin, Trapinch, Axew
- **Dragon Claw** (10 lines): Charmander, Aerodactyl, Bagon, Frigibax, Duraludon, Trapinch, Axew, Tyrunt, Archen, Noibat
- **Dragon Pulse** (15 lines): Charmander, Horsea, Lapras, Dratini, Mareep, Deino, Dreepy, Swablu, Applin, Trapinch, Axew, Feebas, Riolu, Noibat, Salandit

**Recommendation:** keep the TM by level only for the signature users (e.g., Night Slash: Sneasel/Weavile, Pawniard line, Kabutops, Scyther; Power Gem: Staryu/Starmie, Corsola, Shieldon, Glimmet; Nasty Plot: Mew, Porygon line, Houndour, Meowth). Replace the rest with a non-TM move of the same role (Slash/Crunch/Sucker Punch for Night Slash; Ancientpower/Rock Slide/Rock Blast for Power Gem; Calm Mind/Psych Up for Nasty Plot; Psybeam/Extrasensory/Psycho Cut for Psychic; Agility/Swords Dance for Dragon Dance).

Species with the most TM moves baked into level-up (≥6):
- Galarian Slowking (10): Curse, Headbutt, Nasty Plot, Power Gem, Psychic, Rain Dance, Sludge Bomb, Surf, Swagger, Zen Headbutt
- Slowking (10): Curse, Headbutt, Hidden Power, Nasty Plot, Power Gem, Psychic, Rain Dance, Surf, Swagger, Zen Headbutt
- Galarian Slowpoke (7): Curse, Headbutt, Psychic, Rain Dance, Sludge Bomb, Surf, Zen Headbutt
- Galarian Slowbro (7): Curse, Headbutt, Psychic, Rain Dance, Sludge Bomb, Surf, Zen Headbutt
- Salamence (7): Dragon Claw, Dragon Dance, Flamethrower, Fly, Headbutt, Protect, Zen Headbutt
- Primeape (7): Fire Punch, Ice Punch, Mud Slap, Night Slash, Swagger, Thunderpunch, Work Up
- Magmortar (7): Fire Blast, Fire Punch, Flamethrower, Hyper Beam, Sunny Day, Thunderpunch, Will O Wisp
- Hypno (7): Drain Punch, Headbutt, Nasty Plot, Psychic, Swagger, Zap Cannon, Zen Headbutt
- Excadrill (7): Dig, Earthquake, Hone Claws, Iron Head, Mud Slap, Rock Tomb, Sandstorm
- Appletun (7): Curse, Dragon Pulse, Energy Ball, Headbutt, Protect, Solarbeam, Sweet Scent
- Ampharos (7): Dragon Pulse, Fire Punch, Power Gem, Thunder, Thunderbolt, Thunderpunch, Zap Cannon
- Vikavolt (6): Bug Bite, Dig, Fly, Mud Slap, Thunderbolt, Zap Cannon
- Hisuian Typhlosion (6): Fire Punch, Flamethrower, Hyper Beam, Shadow Ball, Swift, Thunderpunch
- Toxicroak (6): Drain Punch, Mud Slap, Nasty Plot, Sludge Bomb, Swagger, Toxic
- Slowpoke (6): Curse, Headbutt, Psychic, Rain Dance, Surf, Zen Headbutt
- Slowbro (6): Curse, Headbutt, Psychic, Rain Dance, Surf, Zen Headbutt
- Shieldon (6): Flash Cannon, Iron Head, Power Gem, Protect, Rock Tomb, Swagger
- Shelgon (6): Dragon Claw, Dragon Dance, Flamethrower, Headbutt, Protect, Zen Headbutt
- Salazzle (6): Dragon Pulse, Fire Blast, Flamethrower, Nasty Plot, Sludge Bomb, Toxic
- Alolan Marowak (6): Earthquake, Headbutt, Iron Head, Knock Off, Mud Slap, Will O Wisp
- Magmar (6): Fire Blast, Fire Punch, Flamethrower, Hyper Beam, Sunny Day, Will O Wisp
- Golem (6): Earthquake, Fire Punch, Iron Head, Rock Tomb, Sandstorm, Thunderpunch
- Froslass (6): Blizzard, Headbutt, Ice Beam, Protect, Shadow Ball, Will O Wisp
- Flygon (6): Dragon Claw, Dragon Dance, Dragon Pulse, Earthquake, Mud Slap, Sandstorm
- Electivire (6): Fire Punch, Ice Punch, Swift, Thunder, Thunderbolt, Thunderpunch
- Dusknoir (6): Curse, Fire Punch, Ice Punch, Shadow Ball, Thunderpunch, Will O Wisp
- Dusclops (6): Curse, Fire Punch, Ice Punch, Shadow Ball, Thunderpunch, Will O Wisp
- Alolan Dugtrio (6): Dig, Earthquake, Iron Head, Mud Slap, Night Slash, Sandstorm
- Drowzee (6): Drain Punch, Headbutt, Nasty Plot, Psychic, Swagger, Zen Headbutt
- Drilbur (6): Dig, Earthquake, Hone Claws, Mud Slap, Rock Tomb, Sandstorm
- Dragonite (6): Dragon Dance, Dragon Pulse, Fire Punch, Hyper Beam, Rain Dance, Thunderpunch
- Cursola (6): Curse, Power Gem, Rock Tomb, Shadow Ball, Whirlpool, Will O Wisp
- Croagunk (6): Drain Punch, Mud Slap, Nasty Plot, Sludge Bomb, Swagger, Toxic
- Galarian Corsola (6): Curse, Power Gem, Rock Tomb, Shadow Ball, Whirlpool, Will O Wisp
- Bastiodon (6): Flash Cannon, Iron Head, Power Gem, Protect, Rock Tomb, Swagger
- Aerodactyl (6): Dragon Claw, Earthquake, Hyper Beam, Iron Head, Roar, Rock Tomb

The Slowpoke family (6–10 each) is the clear outlier — Curse, Headbutt, Rain Dance, Surf, Swagger, Zen Headbutt *and* Psychic/Sludge Bomb/Nasty Plot/Power Gem all by level.

---

## 4. Level-up learnsets

### 4a. Evolution penalty (mostly stone evolutions)
The evolved form learns the same moves much later than the pre-evolution, so evolving early is punished. Vanilla-style fix: give stone evos their kit at Lv1 (like Politoed/Chandelure already do) or keep the pre-evo's levels.
- **Raichu** (Pikachu Lv30): Thunder 39→**75**, Volt Tackle 45→**80**, Wild Charge never, Light Screen 36→70. Alolan Raichu: Thunder 39→71, never gets Volt Tackle.
- **Ninetales** (Fire Stone): Flamethrower 25→43, Fire Blast 45→**73**, Moonblast 60. Alolan Ninetales: Ice Beam 27→43, Moonblast 48→63.
- **Wigglytuff**: Hyper Voice 25→54, Moonblast 29→64, Double-Edge 35→69. **Clefable**: Moonblast 29→44.
- **Vileplume**: Moonblast 35→62, never gets Sludge Bomb by level, Petal Dance 47→67.
- **Arcanine**: Flamethrower 28→55, Flare Blitz 41→65, Take Down 21→50. (Hisuian Arcanine similar.)
- **Poliwrath**: Hydro Pump 44→61, Earth Power 40→56.
- **Victreebel**: Power Whip 47→72, Seed Bomb 31→47.
- **Cloyster**: Ice Beam 33→58, Hydro Pump 37→68, Shell Smash 73.
- **Exeggutor**: Psychic never (Exeggcute 33), Solarbeam 37→72, Energy Ball 25→52. Alolan Exeggutor: Psychic 33→62.
- **Starmie**: Psychic 31→49, Surf 44→69, Hydro Pump 41→74.
- **Sunflora**: Solarbeam 43→64, Energy Ball 28→44. **Ludicolo**: Hydro Pump 44→69, Energy Ball 40→59.
- **Togekiss**: Moonblast 29→60, Nasty Plot 31→65, Double-Edge 33→70. **Mismagius**: Moonblast 35→50, Power Gem 33→45.
- Level evos with the same issue: **Honchkrow** (loses Drill Peck; Dark Pulse 35→50), **Annihilape** (loses all three elemental punches, U-turn, Night Slash), **Farigiraf** (Psychic 36→50, loses Zen Headbutt/Hyper Voice), **Mesmeria** (loses Ice Punch/Freeze-Dry/Body Slam), **Overqwil** (loses Hydro Pump), **Bloodmoon Ursaluna** (loses Play Rough/Thrash), **Excadrill** (Earthquake 44→58), **Electrode-H** (Thunder 37→56, Explosion 71), **Flapple/Breloom** (lose Energy Ball by level; TM still works).

### 4b. Strong moves very early (non-legendary)
Totodile (Explosion 7, Draco Meteor 8), Kotora (Volt Tackle 5), Togepi (Extrasensory 1), Jynx (Ice Punch 9), Wooper/Quagsire/Paldean Wooper/Clodsire (Slam 10), Sentret/Furret (Slam 11), Mantine (Water Pulse 10), Cranidos/Rampardos (Take Down 12), Shieldon/Bastiodon (Take Down 15), Rattata/Raticate (Take Down + Hyper Fang both 16), Larvitar (Rock Slide 19, Thrash 22, Dark Pulse 24), Marill (Aqua Tail 21, Play Rough 24), Mesmeria (Dream Eater 21), Mankey/Annihilape (Cross Chop 22–23), Krabby (Crabhammer 23), Chikorita (Energy Ball 23). Take Down (90) between 16–22 appears on ~20 lines — fine if intentional, but it makes early Normal coverage uniform.

### 4c. Thin sets / late STAB
- **Dreepy**: nothing between Lv1 and Lv30; Dragon STAB first at 34 (Scale Shot); Drakloak/Dragapult only get Dragon Pulse/Dragon Breath as Lv1 evolution moves, nothing in between.
- **Duraludon/Archaludon**: nothing between Lv12 and Lv38; Steel STAB ≥60 not until Flash Cannon 54.
- **Charcadet**: 7 moves, ends at 24, no Fire STAB ≥60. **Armarouge**: no Psychic STAB at all by level; gap 24→37→48. **Ceruledge**: gap 24→37.
- **Impidimp/Morgrem**: nothing from Lv1/4 until 18–20; Fairy STAB at 50/51 (Play Rough only).
- **Wimpod**: 3 moves for 30 levels. **Applin**: 2 moves (ok if evolved quickly). **Bounsweet/Steenee**: Steenee ends at 28 and neither gets a ≥60 STAB.
- **Pawniard/Bisharp/Kingambit**: Steel STAB ≥60 at 55–57 (Iron Head); Swords Dance at 60–64; Guillotine 65–71.
- **Golett/Golurk**: Earthquake 52/58 is the first strong Ground move. **Excadrill**: Iron Head 52, Earthquake 58.
- **Larvesta**: first strong Fire move at 54. **Grubbin/Charjabug**: Bug STAB ≥60 at 30–36.
- **Fletchling line**: Fletchinder gets no Fire attack beyond Ember/Flame Charge; Talonflame Fly 74, Brave Bird **83**.
- **Lucario**: no Steel STAB stronger than Metal Claw by level (Flash Cannon/Iron Head via TM only).
- **Gorochu**: Dark STAB = Crunch 36 only.
- Old-gen late STAB worth a look: Nidoqueen/Nidoking (Earthquake 59, Earth Power 76, Toxic 71), Doduo (first strong Normal at 45), Gyarados (Flying STAB only Hurricane 50), Dunsparce (Dragon STAB only Outrage 52).

### 4d. Duplicate entries (98 species)
Mostly a Lv1 "evolution move" that is also learned again later (harmless but clutters the move list and the Move Reminder). Some are real double-learns at two different levels (Dewgong Icicle Crash 34 & 41, Venusaur Petal Dance 1 & 32, Salamence Fly 1 & 50, Mankey/Primeape Close Combat twice, Corsola-G/Cursola Power Gem 31 & 41/42, Weezing-G Destiny Bond 34 & 56, Sealeo Swagger 1 & 24, Walrein Crunch 1 & 40). Full list:

Ivysaur (Growth, Vine Whip), Venusaur (Growth, Vine Whip, Petal Dance), Charizard (Air Slash), Wartortle (Withdraw, Water Gun), Blastoise (Withdraw, Water Gun), Metapod (Harden), Butterfree (Gust, Confusion), Kakuna (Harden), Beedrill (Fury Attack), Pidgeot (Quick Attack), Raticate (Scary Face), Arbok (Crunch), Jigglypuff (Disable), Venomoth (Gust), Dugtrio (Tri Attack), Persian (Power Gem), Golduck (Confusion, Water Gun), Mankey (Close Combat), Primeape (Close Combat), Tentacruel (Wrap, Acid), Slowbro (Water Gun, Growl, Withdraw), Magneton (Tri Attack), Dewgong (Icy Wind, Bubblebeam, Icicle Crash), Shellder (Water Gun), Haunter (Shadow Punch), Krabby (Leer), Kingler (Metal Claw, Leer, Agility), Chansey (Minimize, Counter, Double Edge), Seaking (Supersonic), Gyarados (Bite), Kabutops (Slash, Sand Attack), Dragonite (Hurricane, Wing Attack), Meganium (Petal Dance, Earth Power), Typhlosion (Double Edge), Croconaw (Water Gun), Feraligatr (Mud Slap, Water Gun, Agility), Furret (Agility), Ariados (Swords Dance), Pichu (Disarming Voice), Xatu (Air Slash), Bellossom (Petal Dance), Marill (Defense Curl, Rollout), Azumarill (Defense Curl, Rollout, Hydro Pump), Sudowoodo (Slam), Slowking (Water Gun), Dunsparce (Flail), Granbull (Outrage), Magcargo (Rock Throw), Piloswine (Ice Fang), Octillery (Octazooka, Focus Energy), Mantine (Wing Attack, Supersonic), Donphan (Fury Attack), Hitmontop (Triple Kick), Suicune (Mist, Gust), Honchkrow (Night Slash), Bagon (Dragonbreath), Shelgon (Protect, Dragonbreath, Bite), Salamence (Fly), Electivire (Wild Charge), Gallade (Slash), Glaceon (Icy Wind), Leafeon (Razor Leaf), Magmortar (Smokescreen), Mamoswine (Ice Fang), Weavile (Ice Shard), Dusclops (Shadow Punch, Shadow Sneak), Tinkaton (Giga Hammer), Abomasnow (Mist), Altaria (Dragon Pulse), Breloom (Mach Punch), Camerupt (Rock Slide), Vibrava (Dragonbreath), Spheal (Rollout), Sealeo (Swagger, Rollout), Walrein (Rollout, Crunch), Milotic (Water Pulse), Galarian Corsola (Power Gem), Cursola (Power Gem), Mr. Rime (Protect), Lucario (Aura Sphere), Alolan Raticate (Focus Energy), Alolan Ninetales (Fairy Wind), Alolan Dugtrio (Tri Attack), Alolan Persian (Power Gem), Alolan Muk (Bite), Galarian Rapidash (Tail Whip), Galarian Weezing (Destiny Bond), Banette (Screech, Night Shade, Shadow Claw), Archeops (Rock Throw, Wing Attack), Carracosta (Rollout, Bite), Lampent (Minimize, Smog), Galvantula (Spider Web, Thundershock), Noivern (Gust, Supersonic), Salazzle (Ember, Smog), Espathra (Charm, Quick Attack), Palafin (Aqua Jet), Staraptor (Close Combat), Gorochu (Tail Whip)

(Smeargle's repeated Sketch is intentional and excluded.)

### 4e. "Modern staples" everywhere
Number of evolution families that learn each by level: Double Edge 51, Crunch 48, Bite 45, Agility 45, Superpower 38, Take Down 36, Screech 36, Dualwingbeat 34, Scary Face 32, Ancientpower 32, Psychic 27, Focus Energy 27, Stealth Rock 27, Slash 26, Swords Dance 26, Night Slash 26, Rock Slide 26, Body Press 26, Sucker Punch 25, Nasty Plot 25, Rock Tomb 25, Hydro Pump 24, Rollout 24, Body Slam 24, Confuse Ray 24, Knock Off 24, Brick Break 24, Heat Wave 23, Close Combat 23, Earth Power 22, Air Slash 22.
Superpower (38 lines), Body Press (26), Stealth Rock (27), Dual Wingbeat (34) and Heat Wave (23) are being appended to most big final forms, which makes late learnsets feel samey. These are good candidates to move into **egg move lists** instead (see §5), which also gives breeding/the Egg Move Tutor a purpose.

---

## 5. Egg moves — needs redoing

### 5a. Families with no egg moves (103 of 213)
**Added families (80 of 91):** Munchlax, Bagon, Ralts, Venipede, Lileep, Anorith, Golett, Duskull, Timburr, Larvesta, Deino, Dreepy, Impidimp, Tinkatink, Frigibax, Charcadet, Snover, Swablu, Applin, Duraludon, Shroomish, Buneary, Numel, Sizzlipede, Grubbin, Croagunk, Drifloon, Drilbur, Kotora, Fletchling, Trapinch, Snorunt, Wimpod, Spoink, Pawniard, Lotad, Scraggy, Spheal, Bloodmoon Teddiursa, Axew, Cranidos, Shieldon, Cetoddle, Feebas, Mimikyu, Galarian Corsola, Riolu, Tyrunt, Amaura, Torkoal, Alolan Rattata, Alolan Sandshrew, Alolan Vulpix, Alolan Diglett, Alolan Meowth, Alolan Geodude, Alolan Grimer, Galarian Meowth, Galarian Ponyta, Galarian Slowpoke, Hisuian Growlithe, Hisuian Voltorb, Hisuian Sneasel, Paldean Wooper, Paldean (Fire) Tauros, Paldean (Water) Tauros, Bounsweet, Aron, Glimmet, Mareanie, Zangoose, Seviper, Shuppet, Archen, Tirtouga, Litwick, Joltik, Mawile, Noibat, Salandit

Originals with none (mostly correct — genderless/legendary/Ditto/Smeargle; Sunkern, Tauros, Staryu, Voltorb, Magnemite could get some): Caterpie, Weedle, Magnemite, Voltorb, Staryu, Tauros, Magikarp, Ditto, Porygon, Articuno, Zapdos, Moltres, Mewtwo, Mew, Sunkern, Unown, Smeargle, Raikou, Entei, Suicune, Lugia, Ho-Oh, Celebi

### 5b. Egg moves the base form already learns by level-up (65 families)
These are wasted slots (the tutor hides moves the Pokémon already knows, and the reminder can teach them anyway). Count = redundant/total.
- Delibird — 5/5: Aurora Beam (Lv21), Quick Attack (Lv9), Future Sight (Lv39), Splash (Lv1), Rapid Spin (Lv1)
- Psyduck — 4/8: Hypnosis (Lv27), Future Sight (Lv39), Psychic (Lv33), Cross Chop (Lv45)
- Vulpix — 4/5: Faint Attack (Lv23), Hypnosis (Lv33), Spite (Lv12), Disable (Lv4)
- Mime Jr. — 4/5: Confuse Ray (Lv32), Future Sight (Lv43), Hypnosis (Lv4), Trick (Lv36)
- Exeggcute — 4/5: Synthesis (Lv25), Reflect (Lv7), Mega Drain (Lv15), Ancientpower (Lv29)
- Snubbull — 3/8: Crunch (Lv28), Heal Bell (Lv40), Lick (Lv10)
- Totodile — 3/6: Crunch (Lv23), Thrash (Lv35), Hydro Pump (Lv44)
- Scyther — 3/6: Baton Pass (Lv46), Razor Wind (Lv31), Reversal (Lv49)
- Rattata — 3/6: Flame Wheel (Lv31), Bite (Lv7), Reversal (Lv37)
- Ponyta — 3/6: Flame Wheel (Lv16), Double Kick (Lv13), Hypnosis (Lv28)
- Aipom — 2/8: Screech (Lv26), Agility (Lv29)
- Rhyhorn — 2/7: Crunch (Lv28), Rock Slide (Lv31)
- Teddiursa — 2/6: Crunch (Lv36), Metal Claw (Lv18)
- Murkrow — 2/6: Drill Peck (Lv25), Wing Attack (Lv13)
- Mareep — 2/6: Thunderbolt (Lv34), Take Down (Lv22)
- Horsea — 2/6: Aurora Beam (Lv16), Octazooka (Lv25)
- Cyndaquil — 2/6: Quick Attack (Lv11), Reversal (Lv20)
- Charmander — 2/6: Belly Drum (Lv41), Bite (Lv14)
- Sentret — 2/5: Double Edge (Lv44), Reversal (Lv29)
- Omanyte — 2/5: Bubblebeam (Lv22), Aurora Beam (Lv19)
- Mantyke — 2/5: Mirror Coat (Lv46), Hydro Pump (Lv49)
- Krabby — 2/5: Flail (Lv44), Slam (Lv35)
- Koffing — 2/5: Destiny Bond (Lv34), Pain Split (Lv13)
- Kangaskhan — 2/5: Stomp (Lv16), Focus Energy (Lv19)
- Finizen — 2/5: Aqua Jet (Lv15), Haze (Lv35)
- Tyrogue — 2/4: Rapid Spin (Lv1), Mach Punch (Lv1)
- Lickitung — 2/3: Belly Drum (Lv60), Body Slam (Lv37)
- Chinchou — 2/3: Flail (Lv30), Supersonic (Lv1)
- Wynaut — 2/2: Charm (Lv1), Encore (Lv1)
- Azurill — 1/8: Foresight (Lv5)
- Houndour — 1/7: Beat Up (Lv22)
- Cubone — 1/7: Belly Drum (Lv43)
- Starly — 1/6: Double Edge (Lv41)
- Seel — 1/6: Encore (Lv11)
- Cleffa — 1/6: Splash (Lv1)
- Chikorita — 1/6: Leech Seed (Lv23)
- Tangela — 1/5: Mega Drain (Lv16)
- Swinub — 1/5: Take Down (Lv28)
- Shellder — 1/5: Bubblebeam (Lv19)
- Sandshrew — 1/5: Rapid Spin (Lv11)
- Remoraid — 1/5: Aurora Beam (Lv12)
- Poliwag — 1/5: Bubblebeam (Lv18)
- Magby — 1/5: Cross Chop (Lv34)
- Larvitar — 1/5: Outrage (Lv37)
- Growlithe — 1/5: Crunch (Lv31)
- Elekid — 1/5: Cross Chop (Lv34)
- Dunsparce — 1/5: Ancientpower (Lv19)
- Doduo — 1/5: Quick Attack (Lv1)
- Corsola — 1/5: Amnesia (Lv28)
- Bellsprout — 1/5: Leech Life (Lv22)
- Slowpoke — 1/4: Future Sight (Lv43)
- Skarmory — 1/4: Drill Peck (Lv28)
- Rookidee — 1/4: Drill Peck (Lv28)
- Pineco — 1/4: Pin Missile (Lv15)
- Meowth — 1/4: Hypnosis (Lv33)
- Gligar — 1/4: Wing Attack (Lv13)
- Wooper — 1/3: Body Slam (Lv28)
- Venonat — 1/3: Baton Pass (Lv33)
- Ledyba — 1/3: Light Screen (Lv11)
- Goldeen — 1/3: Hydro Pump (Lv46)
- Onix — 1/2: Rock Slide (Lv25)
- Misdreavus — 1/2: Destiny Bond (Lv41)
- Geodude — 1/2: Rock Slide (Lv25)
- Eevee — 1/2: Charm (Lv31)
- Shuckle — 1/1: Sweet Scent (Lv39)

### 5c. Egg moves that are TMs
- Psyduck: Ice Beam (already TM-compatible, redundant), Psychic (not TM-compatible)
- Krabby: Dig (not TM-compatible)
- Mime Jr.: Nasty Plot (already TM-compatible, redundant)
- Kabuto: Dig (not TM-compatible)
- Natu: Steel Wing (not TM-compatible)
- Mareep: Thunderbolt (already TM-compatible, redundant)
- Pineco: Swift (not TM-compatible)
- Shuckle: Sweet Scent (not TM-compatible)

### 5d. Frequency — not too common
Most common egg moves by number of families: Flail 19, Haze 16, Counter 15, Foresight 14, Pursuit 14, Screech 14, Light Screen 11, Ancientpower 11, Safeguard 10, Rock Slide 10, Faint Attack 10, Reversal 10, Supersonic 10, Beat Up 9, Quick Attack 9. Nothing is overused; if anything the lists lean on obsolete Gen-2 filler (Bide ×4, Rage, Psywave, Sonicboom, Dragon Rage, Mimic, Present, Splash) that's worthless next to the modernized level-up pools.

---

## 6. Suggested order of work
1. Restore Totodile; fix Kotora/Togepi/Jynx early moves; delete the 6 dead egg lists (or move them to the baby).
2. TM pass on every added species: start from the pre-evo's TM list (§2a), add the universal TMs (§2c), then add type/role TMs (§2b). Resolve the §2d mismatches at the same time.
3. Trim TM moves from level-up for Night Slash / Power Gem / Icicle Crash / Nasty Plot / Psychic / Dragon Dance (§3) and de-duplicate the Slowpoke family.
4. Stone-evo pass (§4a): put the evolved form's key moves at Lv1 or at the pre-evo's levels.
5. Egg pass: give the 80 added families 4–6 egg moves each, replace redundant/obsolete entries in the originals, and use this to move Superpower/Body Press/Stealth Rock/Dual Wingbeat type staples out of so many level-up sets.
