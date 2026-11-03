# Retired Pokémon assets

The Spheal/Sealeo/Walrein, Flittle/Espathra, Spoink/Grumpig and
Lotad/Lombre/Ludicolo families were removed at the user's request.

Their original sprite folders, menu icons, source sheets, Pokédex entries,
base data and documentation exports retain their original relative paths here.
`manifest.json` records the original SHA-256 hashes of all 252 moved files.
Compiled graphics are preserved too. `audio/retired_paldea_cries.asm` preserves
the retired Flittle/Espathra cry scripts with their original labels.

Shared source references are recorded in `shared-source-rows.json`. The original
audit receipts in `tools/testdata/` include the complete retired learnsets,
egg lists, tutor compatibility, stats and source provenance. These files are
historical records and are excluded from active assembly and binary-reference
audits.

The replacement mapping, regional Dex positions and current source receipts
are in `../tools/testdata/roster_replacements.json`. No asset in this directory
should be reintroduced into the active game automatically.
