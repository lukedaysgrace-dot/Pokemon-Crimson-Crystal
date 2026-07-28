# Pokémon with single-frame front sprites

65 of 478 `gfx/pokemon/*/` folders have a front sprite with **no extra animation frames** —
their `front.png` is a plain N×N image (56×56, 48×48, or 40×40) rather than a stacked sheet.

**How this was determined:** a front sprite sheet's extra frames are the only thing
`frame 1`..`frame 9` in `anim.asm` / `anim_idle.asm` can point at. Every folder below has
animation data that references `frame 0` and nothing else, in both files — so the PNG is one
frame tall. All other 413 folders reference at least one higher frame.

## Alphabetical (65)

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
| 21 | `fletchinder` | Fletchinder |
| 22 | `fletchling` | Fletchling |
| 23 | `flygon` | Flygon |
| 24 | `fraxure` | Fraxure |
| 25 | `frigibax` | Frigibax |
| 26 | `golett` | Golett |
| 27 | `golurk` | Golurk |
| 28 | `grimmsnarl` | Grimmsnarl |
| 29 | `grubbin` | Grubbin |
| 30 | `grumpig` | Grumpig |
| 31 | `gurdurr` | Gurdurr |
| 32 | `haxorus` | Haxorus |
| 33 | `impidimp` | Impidimp |
| 34 | `kingambit` | Kingambit |
| 35 | `lairon` | Lairon |
| 36 | `lopunny` | Lopunny |
| 37 | `lucario` | Lucario |
| 38 | `milotic` | Milotic |
| 39 | `morgrem` | Morgrem |
| 40 | `munchlax` | Munchlax |
| 41 | `numel` | Numel |
| 42 | `pawniard` | Pawniard |
| 43 | `rampardos` | Rampardos |
| 44 | `riolu` | Riolu |
| 45 | `scrafty` | Scrafty |
| 46 | `scraggy` | Scraggy |
| 47 | `sealeo` | Sealeo |
| 48 | `shieldon` | Shieldon |
| 49 | `shroomish` | Shroomish |
| 50 | `snover` | Snover |
| 51 | `spheal` | Spheal |
| 52 | `spoink` | Spoink |
| 53 | `timburr` | Timburr |
| 54 | `tinkatink` | Tinkatink |
| 55 | `tinkaton` | Tinkaton |
| 56 | `tinkatuff` | Tinkatuff |
| 57 | `toxicroak` | Toxicroak |
| 58 | `trapinch` | Trapinch |
| 59 | `tsareena` | Tsareena |
| 60 | `tyrantrum` | Tyrantrum |
| 61 | `tyrunt` | Tyrunt |
| 62 | `vibrava` | Vibrava |
| 63 | `vikavolt` | Vikavolt |
| 64 | `walrein` | Walrein |
| 65 | `watu` | Watu |

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
- Riolu → Lucario
- Drilbur *(Excadrill animated)*
- Buneary → Lopunny
- Grumpig *(Spoink also here)*, Spoink
- Tsareena *(Bounsweet / Steenee animated)*
- Milotic *(Feebas animated)*
- Ceruledge *(Charcadet / Armarouge — Armarouge also here)*, Armarouge

**Standalone**

- Munchlax, Watu

## Verification notes

- Counts cross-checked: 478 folders with `anim.asm`; 411 reference `frame 1-9`; 1
  (`perrserker`) uses a double-space `frame  N` and is animated; leaving exactly 65.
- `anim_idle.asm` for all 65 folders was also checked — none reference a frame above 0.
