# Modern height and weight audit — 2026-11-02

Compared all 502 internal roster slots (501 visible Dex entries) against freshly
downloaded PokeAPI `pokemon.csv` and Pokémon Showdown `data/pokedex.ts`.
Every regional form was mapped to its exact form. Heights use nearest-inch
rounding in the game's feet/inches encoding; weights use tenths of a pound.
Checked the actual Dex pointers, including shared clone and Bloodmoon pre-evolution
entries, rather than assuming each species has a distinct Dex record.

One incorrect game value was found and corrected:

| Species | Before | Correct value | Height |
| --- | --- | --- | --- |
| Dipplin | 9.7 kg / 21.4 lb | 4.4 kg / 9.7 lb | 0.4 m / 1 ft 4 in (already correct) |

The [official Dipplin page](https://ph.portal-pokemon.com/pokedex/1011/)
confirms 4.4 kg. PokeAPI mistakenly uses the pound value as kilograms.
PokeAPI also repeats ordinary Ursaluna's dimensions for Bloodmoon; the game
already correctly uses 2.7 m / 333.0 kg, confirmed by the
[official Bloodmoon page](https://ph.portal-pokemon.com/pokedex/0901_1/).
There were no other disagreements between the two datasets for this roster,
and all other official game dimensions were already correct.

The six custom species (Mesmeria, Watu, Kotora, Raitora, Gorotora and Gorochu)
have no official modern dimensions, so their authored values are preserved.
Custom Bloodmoon Teddiursa/Ursaring reuse their ordinary forms' Dex records.
Palafin uses Hero Form, Dudunsparce Two-Segment, and both Aegislash forms
share the same official dimensions. Hisuian Zorua/Zoroark use their Hisuian data.

`tools/testdata/species_dimensions.json` records every slot, both source hashes,
and the official discrepancy resolutions. `tools/audit_species_dimensions.py`
checks all source records, mappings, unit conversions, existing weight reference
data, and (with `--rom`) the actual compiled Dex fields in either ROM.
It is included in `make audit-static`. Battle weights derive from Dex pounds;
the corrected Dipplin value therefore also corrects weight-based move ratios.

Validation:

- Both release and debug ROMs rebuilt successfully with RGBDS 0.5.2.
- Independent source recheck: 502 slots, zero dimension mismatches or other errors.
- Compiled Dex check: all 502 slots match in both release and debug ROMs.
- Native battle checks: 502 species weights and 5,815 move-power results, zero mismatches.
- Weight-move battle suite: all 38 scenarios passed.
- Full `make audit-static` passed, including the new compiled dimension audit.
