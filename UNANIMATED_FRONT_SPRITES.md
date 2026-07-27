# Pokémon with single-frame front sprites

68 of 480 `gfx/pokemon/*/` folders have a front sprite with **no extra animation frames** —
their `front.png` is a plain N×N image (56×56, 48×48, or 40×40) rather than a stacked sheet.

**How this was determined:** a front sprite sheet's extra frames are the only thing
`frame 1`..`frame 9` in `anim.asm` / `anim_idle.asm` can point at. Every folder below has
animation data that references `frame 0` and nothing else, in both files — so the PNG is one
frame tall. All other 412 folders reference at least one higher frame.

## Alphabetical (68)

| # | Folder | Pokémon |
|---|--------|---------|
| 1 | `abomasnow` | Abomasnow |
| 2 | `aggron` | Aggron |
| 3 | `amaura` | Amaura |
| 4 | `armarouge` | Armarouge |
| 5 | `aron` | Aron |
| 6 | `aurorus` | Aurorus |
| 7 | `axew` | Axew |
| 8 | `bastiodon` | Bastiodon |
| 9 | `bisharp` | Bisharp |
| 10 | `breloom` | Breloom |
| 11 | `buneary` | Buneary |
| 12 | `camerupt` | Camerupt |
| 13 | `ceruledge` | Ceruledge |
| 14 | `cetitan` | Cetitan |
| 15 | `cetoddle` | Cetoddle |
| 16 | `conkeldurr` | Conkeldurr |
| 17 | `croagunk` | Croagunk |
| 18 | `drifblim` | Drifblim |
| 19 | `drifloon` | Drifloon |
| 20 | `drilbur` | Drilbur |
| 21 | `electrike` | Electrike |
| 22 | `fletchinder` | Fletchinder |
| 23 | `fletchling` | Fletchling |
| 24 | `flygon` | Flygon |
| 25 | `fraxure` | Fraxure |
| 26 | `frigibax` | Frigibax |
| 27 | `golett` | Golett |
| 28 | `golurk` | Golurk |
| 29 | `grimmsnarl` | Grimmsnarl |
| 30 | `grubbin` | Grubbin |
| 31 | `grumpig` | Grumpig |
| 32 | `gurdurr` | Gurdurr |
| 33 | `haxorus` | Haxorus |
| 34 | `impidimp` | Impidimp |
| 35 | `kingambit` | Kingambit |
| 36 | `lairon` | Lairon |
| 37 | `lopunny` | Lopunny |
| 38 | `lucario` | Lucario |
| 39 | `manectric` | Manectric |
| 40 | `milotic` | Milotic |
| 41 | `morgrem` | Morgrem |
| 42 | `munchlax` | Munchlax |
| 43 | `numel` | Numel |
| 44 | `orstryx` | Orstryx |
| 45 | `pawniard` | Pawniard |
| 46 | `rampardos` | Rampardos |
| 47 | `riolu` | Riolu |
| 48 | `scrafty` | Scrafty |
| 49 | `scraggy` | Scraggy |
| 50 | `sealeo` | Sealeo |
| 51 | `shieldon` | Shieldon |
| 52 | `shroomish` | Shroomish |
| 53 | `snover` | Snover |
| 54 | `spheal` | Spheal |
| 55 | `spoink` | Spoink |
| 56 | `timburr` | Timburr |
| 57 | `tinkatink` | Tinkatink |
| 58 | `tinkaton` | Tinkaton |
| 59 | `tinkatuff` | Tinkatuff |
| 60 | `toxicroak` | Toxicroak |
| 61 | `trapinch` | Trapinch |
| 62 | `tsareena` | Tsareena |
| 63 | `tyrantrum` | Tyrantrum |
| 64 | `tyrunt` | Tyrunt |
| 65 | `vibrava` | Vibrava |
| 66 | `vikavolt` | Vikavolt |
| 67 | `walrein` | Walrein |
| 68 | `watu` | Watu |

## Grouped by family (handy for batch spriting)

**Complete families still unanimated**

- Aron → Lairon → Aggron
- Axew → Fraxure → Haxorus
- Cetoddle → Cetitan
- Drifloon → Drifblim
- Fletchling → Fletchinder *(Talonflame is animated)*
- Impidimp → Morgrem → Grimmsnarl
- Pawniard → Bisharp → Kingambit
- Scraggy → Scrafty
- Timburr → Gurdurr → Conkeldurr
- Tinkatink → Tinkatuff → Tinkaton
- Trapinch → Vibrava → Flygon
- Tyrunt → Tyrantrum
- Amaura → Aurorus
- Golett → Golurk

**Partial families (rest of the line already animated)**

- Spheal → Sealeo → Walrein *(Spheal line: all three here)*
- Frigibax *(Arctibax / Baxcalibur animated)*
- Grubbin → Vikavolt *(Charjabug animated)*
- Shieldon → Bastiodon; Rampardos *(Cranidos animated)*
- Snover *(Abomasnow also here)* → Abomasnow
- Croagunk → Toxicroak
- Numel *(Camerupt also here)* → Camerupt
- Shroomish → Breloom
- Electrike → Manectric
- Riolu → Lucario
- Drilbur *(Excadrill animated)*
- Buneary → Lopunny
- Grumpig *(Spoink also here)*, Spoink
- Tsareena *(Bounsweet / Steenee animated)*
- Milotic *(Feebas animated)*
- Ceruledge *(Charcadet / Armarouge — Armarouge also here)*, Armarouge

**Standalone**

- Munchlax, Orstryx, Watu

## Verification notes

- Counts cross-checked: 480 folders with `anim.asm`; 411 reference `frame 1-9`; 1
  (`perrserker`) uses a double-space `frame  N` and is animated; leaving exactly 68.
- `anim_idle.asm` for all 68 folders was also checked — none reference a frame above 0.
