# Heavy Move Animation Testing Checklist

Ported move animations to spot-check (matched to Polished Crystal).
Ranked by animation load. Two signals used:

- **GFX sets** = how many `ANIM_GFX_*` graphics banks the script loads at once
  (`anim_4gfx` / `anim_3gfx`). More sets = more VRAM/OAM pressure = most likely to
  glitch tiles, flicker sprites, or corrupt the HUD.
- **Script size** = number of objects, sounds, loops and BG/screen effects.

Source files: `data/moves/animations2.asm` (Gen 4+ batch), `animations3.asm`
(main `_PC3` batch), `animations4.asm` (`_PC4`, all light — no multi-gfx moves).

---

## Tier 1 — Highest risk (4 graphics sets loaded)

These push the tile/OAM budget hardest. Watch for garbled tiles, missing sprites,
palette corruption, or HUD glitches when they fire.

- [ ] **Aura Sphere** — loads 4 gfx, then **reloads 3 more mid-animation** (double load — the single riskiest one)
- [ ] **Energy Ball**
- [ ] **Flash Cannon**
- [ ] **Psystrike**
- [ ] **First Impression**
- [ ] **Liquidation**
- [ ] **Aqua Jet**
- [ ] **Ice Shard**
- [ ] **Moonblast**
- [ ] **Tri Attack**

## Tier 2 — Heavy (3 graphics sets loaded)

- [ ] **Aqua Tail**
- [ ] **Calm Mind**
- [ ] **Focus Blast**
- [ ] **Icicle Spear**
- [ ] **Iron Head**
- [ ] **Scald**
- [ ] **Shell Smash**
- [ ] **Volt Switch**
- [ ] **Dazzling Gleam**
- [ ] **Dragon Claw**
- [ ] **Icicle Crash**
- [ ] **Leech Life**
- [ ] **Octazooka**
- [ ] **Outrage**
- [ ] **Petal Dance**
- [ ] **Play Rough**
- [ ] **Poison Jab**
- [ ] **Smokescreen**
- [ ] **Spore**
- [ ] **Sucker Punch**
- [ ] **Wild Charge**

## Tier 3 — Long / busy scripts (many objects, sounds, screen effects)

Single gfx set but visually dense or long-running — good for catching timing,
looping, and BG-effect issues.

- [ ] **Flare Blitz** — longest ported script
- [ ] **Stone Edge**
- [ ] **Giga Impact**
- [ ] **Giga Drain**
- [ ] **Power Gem**
- [ ] **Waterfall**
- [ ] **Razor Leaf**
- [ ] **Zen Headbutt**
- [ ] **Gunk Shot**
- [ ] **Hydro Pump**
- [ ] **Fire Blast**
- [ ] **Trick Room** — full-screen BG effect
- [ ] **U-Turn**
- [ ] **Close Combat**
- [ ] **Hidden Power**
- [ ] **Icy Wind**
- [ ] **Crabhammer**
- [ ] **Drill Peck**

## Tier 4 — Callers (test because they invoke *other* animations)

If any ported animation is broken, these can surface it by randomly/indirectly
triggering it.

- [ ] **Metronome**
- [ ] **Sleep Talk**
- [ ] **Sketch**

---

## Tier 5 — Additional heavy moves (live scripts in `animations.asm`)

My first pass only ranked `animations2/3/4.asm`. The main `animations.asm` file
also holds live scripts — including new signature moves and the screen-shake
"boom" moves whose short script length hid how heavy they actually are (they call
big shared subroutines / full-screen effects).

- [ ] **Self-Destruct** — full-screen inverted flash + screen shake (subroutine-driven)
- [ ] **Explosion** — same family; full-screen flash + shake
- [ ] **Draco Meteor** — 3 gfx, ~14 objects, meteor barrage + multiple flashes
- [ ] **Blood Moon** — 3 gfx, long charge + Hyper Beam-style blast, custom sprites
- [ ] **Solar Blade** — 3 gfx
- [ ] **Triple Axel** — 3 gfx, multi-hit
- [ ] **Accelrock** — 3 gfx
- [ ] **Struggle Bug** — 3 gfx
- [ ] **Infestation** — 3 gfx
- [ ] **Mortal Spin**
- [ ] **Leaf Blade**
- [ ] **Shadow Sneak**
- [ ] **Pixie Punch**

Note: several unsuffixed scripts in `animations.asm` (e.g. Close Combat, Poison
Jab, U-Turn, Dragon Claw) are **superseded** by their `_PC3` versions in the
pointer table — those are the ones you already tested, so no need to re-test the
old copies.

---

**What to look for while testing:** garbled/leftover tiles, sprites that don't
despawn, wrong palettes, HUD corruption, animation hanging or ending early, and
missing sound effects. Test each from **both** the player and enemy side — object
coordinates differ and mirrored positions are a common break point.
