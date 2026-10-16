# Learnset distribution through Scarlet/Violet

All verified moves implemented in this ROM are available across the 495-entry
roster. The expanded pools add **12,949 newly obtainable species/move pairs**
over the original baseline, with **zero deferred moves**. The audit protects
all 36,072 previously expanded species/move access pairs against removal.

The Goldenrod catch-all expansion has been removed. That NPC again teaches
only its original five utility moves: Substitute, Sleep Talk, Reflect,
Light Screen and Thunder Wave, subject to the original compatibility flags.

Aron, Lairon and Aggron learn **Body Press at levels 32, 38 and 44**,
respectively. These are custom thematic placements after Iron Defense.
The existing family egg entry is retained too.

| Acquisition route | Additions since the original baseline |
| --- | ---: |
| Sourced natural/restored level-up placements | 452 |
| Custom thematic level-up placements | 1,031 |
| Canonical family egg-list entries | 996 |
| Existing TM/HM/elemental-tutor compatibility flags | 1,360 |
| Added independent level-30 breeding fallbacks | 16 |
| Blackthorn fallback tutor assignments | 9,051 |
| Catch-all Goldenrod tutor entries | 0 |

The existing purple tutor in Blackthorn City's Move Deleter's House teaches
the remaining species-specific moves alongside its family egg moves, for its
existing **¥5,000** fee. Natural, thematic, breeding and machine placements are
retained; Blackthorn supplies every verified move without another route.
The previous Goldenrod assignments are archived in the audit receipt and
replaced by the Blackthorn fallback table. Custom levels are design choices,
not claimed as official Bulbapedia/Smogon level-up data. Thematic choices
consider typing, established anatomy/attacks, and physical/special roles.
The scored supplement is limited to eight moves per species, with explicit
family fixes such as Body Press recorded separately.

Canonical egg eligibility stays in the family breeding lists. All 1,961
family egg entries have independent acquisition proofs using this roster's
genders, egg groups, natural moves and real machines. The egg tutor is
excluded from those proofs. Example Aron routes include Rhyperior's level-55
Head Smash, Nidoking's level-56 Superpower and Lickitung's level-12 Stomp.

The current lists cover all 495 roster entries. Six original custom species
retain their authored sets; clone learnsets mirror their originals. Existing
project moves, machine compatibility and intentional removals are preserved,
with explicit user-approved thematic egg/level overlaps recorded in the receipt.

All 33,110 reference species/move pairs have acquisition routes. Historical
TM, tutor or event compatibility does not by itself establish a natural
level-up placement; the remaining 9,051 assignments use Blackthorn instead.
The [placement status](canonical-moves-awaiting-review.md) confirms that no
verified implemented moves remain awaiting placement.

The [Pokémon-by-Pokémon additions list](learnset-additions-by-pokemon.md)
separates newly obtainable moves, natural/restored levels, custom thematic
levels, egg routes, machine compatibility and Blackthorn tutor routes. It
includes regional forms and clones.

The structured reference is [Smogon's SV-era Pokémon Showdown data](https://github.com/smogon/pokemon-showdown/blob/f7d73fdb20909885b70c4463f3878cf37875068d/data/learnsets.ts),
pinned after the SV DLC and before Legends: Z-A. Bulbapedia source-category
spot checks included [Aron](https://bulbapedia.bulbagarden.net/wiki/Aron_%28Pok%C3%A9mon%29/Generation_VIII_learnset),
[Lairon](https://bulbapedia.bulbagarden.net/wiki/Lairon_%28Pok%C3%A9mon%29/Generation_VIII_learnset),
[Aggron](https://bulbapedia.bulbagarden.net/wiki/Aggron_%28Pok%C3%A9mon%29/Generation_VIII_learnset)
and [Duraludon](https://bulbapedia.bulbagarden.net/wiki/Duraludon).
The reference concerns individual historical moves rather than official
cartridge transfer legality for every simultaneous moveset. The 245 distinct
canonical moves absent from this ROM's engine remain listed separately in
the receipt; this distribution pass does not implement additional battle moves.

Validation: release and debug builds each passed 9,458 compiled learnset
checks covering every species' Blackthorn menu, Goldenrod's original five-move
rules, known-move filtering, scrolling beyond 128 entries, Body Press timing
and specific Aron breeding pairs. The release breeding suite passed 11,810
checks, the reminder/QoL suite passed 8,826, and the save-layout audit passed
142. The static move-integrity audit passed for all 421 implemented moves.
Mew's 158-entry list survived native menu setup and rendering. The source
audit enforces full reference coverage and preservation of the expanded pools;
an independent recheck found zero missing pairs. Refreshed documentation
reported zero warnings and zero unparsed rows.

A subsequent visual check through the actual Blackthorn NPC found and fixed
overworld sprites remaining over the full-screen move list: the shared tutor
menu now flushes its cleared OAM buffer for one frame while preserving the
conversation's transfer lock. `tools/battletest/blackthorn_tutor_ui_checks.py`
drives a private native-cartridge New Game, opens the real NPC menu, scrolls
Mew's 158 moves beyond entry 128 to Cancel, checks the displayed sprite layer,
and captures the first, middle and final pages. That check passed, as did the
9,458-check learnset suite on both rebuilt ROMs.
