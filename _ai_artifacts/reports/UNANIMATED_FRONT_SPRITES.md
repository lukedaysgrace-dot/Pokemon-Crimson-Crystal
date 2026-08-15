> **Superseded** by `STATIC_SPRITES_TODO.md` (full PNG-based rescan, 2026-08-15). This file is kept for history only; its counts are stale.

# Pokémon with single-frame front sprites

60 of 478 `gfx/pokemon/*/` folders have a front sprite with **no extra animation frames** —
their `front.png` is a plain N×N image (56×56, 48×48, or 40×40) rather than a stacked sheet.

**How this was determined:** a front sprite sheet's extra frames are the only thing
`frame 1`..`frame 9` in `anim.asm` / `anim_idle.asm` can point at. Every folder below has
animation data that references `frame 0` and nothing else, in both files — so the PNG is one
frame tall. All other 413 folders reference at least one higher frame.

## Alphabetical (60)

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
| 45 | `shieldon` | Shieldon |
| 46 | `shroomish` | Shroomish |
| 47 | `snover` | Snover |
| 48 | `spoink` | Spoink |
| 49 | `timburr` | Timburr |
| 50 | `tinkatink` | Tinkatink |
| 51 | `tinkaton` | Tinkaton |
| 52 | `tinkatuff` | Tinkatuff |
| 53 | `toxicroak` | Toxicroak |
| 54 | `trapinch` | Trapinch |
| 55 | `tsareena` | Tsareena |
| 56 | `tyrantrum` | Tyrantrum |
| 57 | `tyrunt` | Tyrunt |
| 58 | `vibrava` | Vibrava |
| 59 | `vikavolt` | Vikavolt |
| 60 | `watu` | Watu |

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
  (60 after Golett, Golurk and the Spheal line were animated).
- `anim_idle.asm` for all 65 folders was also checked — none reference a frame above 0.
