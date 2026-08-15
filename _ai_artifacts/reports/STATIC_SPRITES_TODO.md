# Static front sprites — still need animation

35 of 499 Pokémon have a **single-frame front sprite** (front.png is one square
tile block — 40x40 / 48x48 / 56x56 — with nothing stacked below it).

Detection method: `gfx/pokemon/<name>/anim.asm` **and** `anim_idle.asm` both
reference frame 0 only. Every other mon references at least one extra frame.
Spot-checked against the actual PNGs (gyarados, tinkaton) — both single-frame.

## Grouped by family

**Complete families still static**

- Pawniard → Bisharp → Kingambit
- Timburr → Gurdurr → Conkeldurr
- Impidimp → Morgrem → Grimmsnarl
- Spheal → Sealeo → Walrein
- Tinkatink → Tinkatuff → Tinkaton
- Amaura → Aurorus
- Cetoddle → Cetitan

**Partial families (rest of the line is already animated)**

- Axew, Fraxure — *Haxorus done*
- Fletchling, Fletchinder — *Talonflame done*
- Rookidee, Corvisquire — *Corviknight done*
- Frigibax — *Arctibax / Baxcalibur done*
- Ceruledge — *Armarouge done*
- Rampardos — *Cranidos done*
- Bastiodon — *Shieldon done*

**Standalone / one-offs**

- Dragonite
- Gyarados
- Houndoom
- Milotic
- Tyranitar
- Mesmeria (`mesmeria`)

## Done

- ~~Weavile~~
- ~~Tsareena~~
- ~~Appletun~~
- ~~Flapple~~ (Applin line fully animated)
- ~~Sirfetch'd~~
- ~~Ledian~~
- ~~Teddiursa BM (`teddiursabm`)~~
- ~~Ursaring BM (`ursaringbm`)~~
- ~~Golett → Golurk~~

## Flat list (folder names)

```
amaura        aurorus       axew          bastiodon     bisharp
cetitan       cetoddle      ceruledge     conkeldurr    corvisquire
dragonite     fletchinder   fletchling    fraxure       frigibax
grimmsnarl    gurdurr       gyarados      houndoom      impidimp
kingambit     mesmeria      milotic       morgrem       pawniard
rampardos     rookidee      sealeo        spheal        timburr
tinkatink     tinkaton      tinkatuff     tyranitar     walrein
```

## Note

`gfx/pokemon/` contains 509 `front.png` files but only 499 `anim.asm` files —
10 sprite folders have no anim data at all. Those are separate from the 45 above
and may be unused/leftover folders.
