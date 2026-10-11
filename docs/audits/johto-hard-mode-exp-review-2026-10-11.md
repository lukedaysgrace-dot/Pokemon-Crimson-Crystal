# Johto Hard Mode trainer EXP review — 2026-10-11

The strongest candidates for additional reliable EXP are the Olivine return
after Chuck, Route 42 and lower Mt. Mortar before Pryce, and the approach to
the Pokémon League. Route 38–39 is a secondary concern for players rotating
six Pokémon or skipping optional battles.

## What was checked

- Current trainer parties in `data/trainers/parties.asm`, resolved through
  `constants/trainer_constants.asm` and `data/trainers/party_pointers.asm`.
- Initial trainer declarations and scripted battles in the actual map files.
- The live Hard Mode 2× trainer EXP bonus in `engine/battle/core.asm`.
- Badge-count caps in `engine/pokemon/experience.asm`: Morty 25, Chuck 30,
  Jasmine 34, Pryce 38, Clair 45 and the Elite Four 57.
- Gym-return, night-only, starter-variant and HM-access conditions in scripts.

EXP pools below sum `2 × floor(base EXP × level / 7)` per opposing Pokémon.
They are approximate total party EXP before participant rounding, traded or
held-item bonuses. They count each ordinary initial trainer once, without
phone rematches, repeatable Rocket alarms or three copies of rival variants.
Trainer declarations are not a full movement or collision reachability test.

## Priority locations

| Location | Current initial battles | Assessment |
|---|---:|---|
| Olivine Fishing Cove | 0 trainer battles | A useful new source of optional EXP after Chuck; keep battles separate from the fishing contest. |
| Route 39 / return to Olivine | 4 ordinary trainers; 1 extra night-only fight | Good placement for fresh level 31–34 battles that were not consumed while preparing for Chuck. |
| Route 42 | 3 trainers, 5 Pokémon, about 4,248 EXP | Thin bridge into the Jasmine/Pryce portion. Additional level 33–37 teams would help. |
| Mt. Mortar, entrances and lower 1F | 2 trainers, 3 Pokémon, about 1,480 EXP | Very little early-access EXP for an exploration area. Do not rely on later Waterfall-access content to solve this gap. |
| Route 38 | 6 trainers, 10 Pokémon, about 8,498 EXP | Secondary priority: improves the Morty → Chuck transition when players skip optional trainers or rotate a full team. |
| Routes 27–26 / Victory Road | 6 ordinary trainers on each map | Later-game priority for a full team. Existing teams are substantial; increasing their yields is also an option. |

## Why Chuck → Jasmine is the clearest gap

Raising four Medium Slow Pokémon from level 30 to 34 requires about 45,296
party EXP; six require about 67,944. Olivine Gym's three current trainers give
about 13,928 EXP, and only appear after Jasmine returns from the lighthouse.

There are nine Lighthouse trainers, but their combined pool is about 13,466
EXP. If they and Routes 38–41 were used to prepare for Chuck, they are not
fresh EXP after his badge raises the cap. Fighting Jasmine herself cannot
serve as preparation for her battle, and the preceding leader's EXP is
subject to the old cap until that leader awards the badge.

Players can borrow EXP from the eastern branch, reserve western trainers,
fight phone rematches or grind wild Pokémon. Those alternatives make the
gap route-dependent, rather than proving Jasmine is unreachable.

## Pryce and the later game

Route 42, Route 43, Lake of Rage, Rocket Base and Mahogany Gym together have
27 ordinary trainers giving about 59,350 EXP. Six Medium Slow Pokémon need
about 88,572 to go from 34 to 38. Petrel and Ariana add about 11,446; refusing
the Route 43 gate toll adds two battles worth about 5,782. These help, but
route order matters if eastern EXP was already spent preparing for Jasmine.

The Radio Tower, Underground rescue, Route 44 and Blackthorn Gym provide
about 182,278 EXP from 39 ordinary trainers, before their major scripted
battles. Route 44 alone has nine trainers and about 50,424 EXP. This is a
lower priority for additions than the Olivine/eastern midgame transition.
Ice Path has no ordinary trainers but does have a Crystal battle.

After Clair, Routes 45–46, Routes 27–26 and Victory Road supply about
248,790 ordinary EXP. One Victory Road rival adds roughly 18,200. In an
evenly distributed six-Pokémon Medium Slow model starting at level 45,
this puts the team around level 51 at Will, whose ace is 52. The first four
Elite Four battles add about 71,836 EXP; the same model puts the team around
52 before Lance, whose ace is 57. This does not mean the team must reach the
57 cap before entering: it identifies a later full-team leveling concern.
Using Routes 45–46 before Clair or skipping optional trainers reduces the
remaining pool; concentrating EXP on four Pokémon reduces the concern.

## Limits

This is a source-based budget review, not a complete playthrough simulation.
Team size, growth rates, capture levels, ordinary wild encounters, EXP Share
distribution, defeated trainers and gym order all change actual arrival
levels. The level caps follow badge count, so the named stages assume the
usual Chuck → Jasmine → Pryce order. No game data was changed by this review.
