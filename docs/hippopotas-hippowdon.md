# Hippopotas and Hippowdon

Hippopotas and Hippowdon are regional Pokédex **#235–236**, following Donphan.
Hippopotas evolves at **level 34**.

On **Route 45**, Hippopotas occupies the 10% morning/day slot at levels 28/30.
Hippowdon occupies the 5% daytime slot at level 38.

Both are Ground types with **Sand Stream / Sand Force / Strong Jaw**, following
Luminescent Platinum 3.0's three ability slots. They use official base stats in
both stats modes, Slow growth, equal gender ratios, 30 hatch cycles, and the
Field egg group. Their official weights are 49.5 kg and 300 kg.

Their level-up progression follows Lumi 3.0, with Legends: Z-A's natural
Amnesia at level 24 added. Slack Off remains at Lumi's levels 35/36. Hippowdon's
three elemental fangs are level-1 reminder moves. Existing machines, the
Goldenrod utility tutor, family egg moves, and Blackthorn's tutor supply every
other implemented move supported by their main-series history or Lumi 3.0.
This provides **51 moves for Hippopotas and 56 for Hippowdon**. Moves absent from
the engine are recorded in the source receipt rather than assigned invalid IDs.

Both use the supplied front/back sprites and two-frame menu icons. Each supplied
front sprite has one frame, so its animation scripts reference only frame zero.
Normal front/back palette slots are aligned; shiny colors adapt the official
male sprites' pale yellow/olive and olive/dark green to the Game Boy's two middle
colors. Each species has an authored Game Boy cry.
The cries are original PSG adaptations, not exact sampled main-series audio.

Internal indexes **501/502** preserve every existing species index. Save format
5 and the 63-byte seen/caught fields remain unchanged.

Run `make test-hippos` for the native data, evolution, breeding, reminder,
machine, tutor, Dex, icon, and focused battle checks. Exact move provenance,
reference versions, asset URLs and hashes are in
`tools/testdata/hippopotas_hippowdon.json`.

Sources: [Lumi 3.0 game data](https://github.com/TeamLumi/luminescent-team/tree/943b9efb70e4ead902603d3572982dcd9bcce6b2/__gamedata/gamedata3.0),
[main-series move history](https://github.com/smogon/pokemon-showdown/tree/1242c1e2d9763ba5b85d33f13aecb89bae19ae3d/data),
[Hippopotas data](https://pokemondb.net/pokedex/hippopotas),
[Hippowdon data](https://pokemondb.net/pokedex/hippowdon), and
[shiny sprite references](https://github.com/PokeAPI/sprites/tree/master/sprites/pokemon/shiny).
