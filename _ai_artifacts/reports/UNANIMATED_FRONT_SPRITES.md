# Pokémon with single-frame front sprites

63 of 478 `gfx/pokemon/*/` folders have a front sprite with **no extra animation frames** —
their `front.png` is a plain N×N image (56×56, 48×48, or 40×40) rather than a stacked sheet.

**How this was determined:** a front sprite sheet's extra frames are the only thing
`frame 1`..`frame 9` in `anim.asm` / `anim_idle.asm` can point at. Every folder below has
animation data that references `frame 0` and nothing else, in both files — so the PNG is one
frame tall. All other 413 folders reference at least one higher frame.

## Alphabetical (63)

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
| 26 | `grimmsnarl` | Grimmsnarl |
| 27 | `grubbin` | Grubbin |
| 28 | `grumpig` | Grumpig |
| 29 | `gurdurr` | Gurdurr |
| 30 | `haxorus` | Haxorus |
| 31 | `impidimp` | Impidimp |
| 32 | `kingambit` | Kingambit |
| 33 | `lairon` | Lairon |
| 34 | `lopunny` | Lopunny |
| 35 | `lucario` | Lucario |
| 36 | `milotic` | Milotic |
| 37 | `morgrem` | Morgrem |
| 38 | `munchlax` | Munchlax |
| 39 | `numel` | Numel |
| 40 | `pawniard` | Pawniard |
| 41 | `rampardos` | Rampardos |
| 42 | `riolu` | Riolu |
| 43 | `scrafty` | Scrafty |
| 44 | `scraggy` | Scraggy |
| 45 | `sealeo` | Sealeo |
| 46 | `shieldon` | Shieldon |
| 47 | `shroomish` | Shroomish |
| 48 | `snover` | Snover |
| 49 | `spheal` | Spheal |
| 50 | `spoink` | Spoink |
| 51 | `timburr` | Timburr |
| 52 | `tinkatink` | Tinkatink |
| 53 | `tinkaton` | Tinkaton |
| 54 | `tinkatuff` | Tinkatuff |
| 55 | `toxicroak` | Toxicroak |
| 56 | `trapinch` | Trapinch |
| 57 | `tsareena` | Tsareena |
| 58 | `tyrantrum` | Tyrantrum |
| 59 | `tyrunt` | Tyrunt |
| 60 | `vibrava` | Vibrava |
| 61 | `vikavolt` | Vikavolt |
| 62 | `walrein` | Walrein |
| 63 | `watu` | Watu |

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
  (`perrserker`) uses a double-space `frame  N` and is animated; leaving exactly 65
  (63 after Golett and Golurk were animated).
- `anim_idle.asm` for all 65 folders was also checked — none reference a frame above 0.
