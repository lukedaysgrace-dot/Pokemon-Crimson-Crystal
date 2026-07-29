# Move Expansion — second fix pass (2026-07-28)

You were right that it was a mess. There was one systemic bug behind most of what you saw,
plus two real gameplay bugs. ROM md5 `fcc1b99e28c6f83542e21d511b54dad8`.

Still not emulator-tested — everything below is reasoned from the code and verified
structurally, not by watching it run.

---

## The big one: 34 animation jumps into the wrong bank

`anim_jump`, `anim_call` and `anim_if_param_equal` store a bare **2-byte address**. The
interpreter keeps running in whichever bank the script started in, and that bank comes from
the per-move `banim` table. So a jump is **bank-local**.

`animations5.asm` links into its own section, in a different bank from `animations.asm`.
Every jump from the new file into a shared helper (`BattleAnim_ShowMon_0`,
`BattleAnim_TargetObj_1Row`, `BattleAnim_DoubleEdge`, …) landed on that same *offset* in the
**wrong bank** and executed whatever bytes happened to be there as animation commands.

That is why moves stalled for 20 seconds, played someone else's animation, or did nothing:
the interpreter was running garbage, and garbage `anim_wait` bytes are long waits.

rgbasm and rgblink cannot catch this — the address resolves fine, it is just in the wrong bank.

**20 moves were affected:**

Rock Polish, Wood Hammer, Mud Shot, Air Cutter, Cross Poison, Magical Leaf, Phantom Force,
Headlong Rush, Shadow Bone, Dire Claw, Shell Side Arm, Psyshield Bash, Raging Bull,
Quiver Dance, Work Up, Superpower, Circle Throw, Dragon Tail, Baneful Bunker, Body Press
— plus Snarl and Bounce, which share bodies with two of those.

**Fix:** 14 shared helper scripts are now duplicated into the same bank with a `_5` suffix,
and all 34 references repoint to the local copies. Verified: **0 cross-bank references left**
across all five animation files. There is a comment block at the bottom of `animations5.asm`
explaining the constraint so the next person doesn't reintroduce it.

---

## Second systemic bug: 39 animation objects with a dead parameter

The 4th argument to `anim_obj` is the object's behaviour parameter, and most object functions
read it as **speed, angle or jumptable index**. 39 of the new spawns passed `$0`.

The clearest case: `BATTLEANIMFUNC_02` does `param & $f` for x-speed. With `$0` the object
**never moves and never deinitialises** — it just sits at the spawn point. That is Freeze-Dry's
mist and Dragon Darts' pulses, among others.

**Fix:** for every object whose function actually reads the parameter, the value is now one
that is already used for that same object in the vanilla animation files. Where an object is
spawned several times, the proven values are cycled so the objects don't all move identically.
`BATTLEANIMFUNC_00` objects were left alone — that function ignores the parameter.

Verified: **0 unproven parameters left**.

Note: I also audited "object spawned without its tiles loaded" and found 27 in the new file —
but vanilla `animations.asm` has 21 of the same, including Shadow Ball itself, so that pattern
is normal here and I left it alone.

---

## Freeze-Dry did no extra damage

You were right, and the previous pass's fix was aimed at the wrong thing.

`BattleCommand_Stab` walks the type chart **itself** and multiplies `wCurDamage` as it goes.
`wTypeMatchup` is computed separately, afterwards, and only drives the "It's super effective!"
message and `wTypeModifier`. So `FreezeDryOverride_Core` was correcting the message and nothing
else — exactly the symptom you described.

**Fix:** new `FreezeDryDamage_Core`, called from Stab's `.end`. The chart scores Ice vs Water
at 0.5x and Freeze-Dry wants 2x, which is **exactly x4 regardless of the target's second type**
(that type's multiplier is applied identically either way), so it just scales `wCurDamage` by 4
with a `$FFFF` clamp.

The message logic stays as it was — scoring against the non-Water type and doubling — because
that avoids the chart's truncating divide. Expected results:

| Target | Freeze-Dry |
|---|---|
| pure Water | 2x |
| Water/Ground, Water/Flying, Water/Grass | 4x |
| Water/Poison, Water/Dark | 2x |
| Water/Ice, Water/Steel | 1x |

---

## Getting hit during Phantom Force's charge turn

Two separate bugs stacked here.

**1. Phantom Force never became invulnerable at all.** `BattleCommand_Charge` picks the vanish
substatus by move ID and only knew `FLY` and `DIG`. Everything else — including Phantom Force
**and Bounce** — fell through with no substatus set, so it was a normal, fully targetable
charge turn.

Fixed: Bounce now sets `SUBSTATUS_FLYING`, Phantom Force sets `SUBSTATUS_UNDERGROUND` as its
vanished state.

> **Tradeoff, your call:** SubStatus3 has no free bits, so Phantom Force borrows the
> "underground" slot. That means Earthquake, Fissure and Magnitude can still reach it. Giving
> it a true "nothing hits me" state means a new bit in SubStatus2 (bits 3-6 are free) and
> touching ~8 more sites; I didn't want to make that many untested changes in one pass.

**2. The semi-invulnerability move lists were swapped.** This one is pre-existing and affects
vanilla Fly and Dig too:

```
	bit SUBSTATUS_FLYING, a
	ld hl, .FlyMoves
	jr z, .check_move_in_list     ; z = NOT flying = underground -> used .FlyMoves
	ld hl, .DigMoves              ; flying -> used .DigMoves
```

So **Earthquake hit a flying target and Thunder hit a digging one** — backwards. Restored to
the vanilla ordering.

---

## Animations rewritten by hand

Beyond the mechanical fixes, three you called out specifically:

- **Phantom Force** — charge turn now fades out with `ANIM_BG_1D`, the same palette-cycle Faint
  Attack uses, cut short with `anim_incbgeffect` while still dark so it stays gone. The strike
  reuses Shadow Ball's proven object setup, then a screen-shake and three impacts.
- **Dire Claw** — three raking claws with a flash, then two venom droplets.
- **Headlong Rush** — kicks up ground with Dig's sand objects, then a shaking full-body tackle.
- **Magical Leaf, Shadow Bone** — now jump to in-bank copies of Razor Leaf and Bone Club.

---

## What to check now

1. **Dire Claw, Headlong Rush, Shadow Bone, Magical Leaf** — these were the worst of the
   cross-bank breakage. If they play something coherent, the systemic fix is good.
2. **Freeze-Dry** on a pure Water target — should now hit about twice as hard, not just say so.
3. **Phantom Force** — try to hit it on the charge turn with anything that isn't Earthquake,
   Fissure or Magnitude. It should miss.
4. **Fly and Dig** (existing moves) — Earthquake should now miss a flying target, Thunder should
   miss a digging one. This changed for vanilla moves too, so worth confirming.
5. **Bounce** — also newly invulnerable on the way up.
6. The other 16 moves from the affected list.

If something still looks wrong, the useful detail is *what* it does — plays the wrong move's
animation, hangs, or plays nothing. Those three point at different causes.
