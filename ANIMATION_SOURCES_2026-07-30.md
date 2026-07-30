# Animation sources for the 62 new moves (2026-07-30 pass)

"pokeorange" = ported from mae-pokeorange (Ancient Platinum engine).
"custom" = made up here (pokeorange either doesn't have the move, or its
animation is an empty `anim_ret` stub).

## Batch 1 (moves 352-377)

| Move | Source |
|---|---|
| Overheat | **pokeorange** (charge glow, flame ring eruption, charred-smoke aftermath) |
| Leaf Storm | custom (stub in pokeorange) |
| Fake Out | **pokeorange** — the little Encore-style clapping hands |
| Flip Turn | custom (not in pokeorange) |
| Iron Defense | **pokeorange** (flashing metallic sheen) |
| Rock Polish | **pokeorange** (incl. its rockpolish grit graphics) |
| Wood Hammer | custom (stub in pokeorange) |
| Head Smash | custom (stub in pokeorange) |
| Drill Run | custom (not in pokeorange) |
| Psycho Cut | custom (stub in pokeorange) |
| Sacred Sword | custom (not in pokeorange) |
| Brick Break | **hybrid** — pokeorange's hand-poised-above + chop, plus the screen-shatter kept |
| Heat Wave | **pokeorange** (heat-haze wash, incl. its heat-wave palette) |
| Snarl | custom (not in pokeorange) |
| Nuzzle | custom (not in pokeorange) |
| Bullet Seed | **pokeorange**, shortened so the multi-hit loop stays snappy |
| Dual Wingbeat | custom (stub in pokeorange) |
| Rock Tomb | **pokeorange** (boulders drop one by one + flashing red X) |
| Low Sweep | custom (not in pokeorange) |
| Mud Shot | **pokeorange** (sustained mud stream + splatter) |
| Air Cutter | **pokeorange** (incl. its razor-wind blade object) |
| Cross Poison | custom (stub in pokeorange) |
| Magical Leaf | **pokeorange** (leaves tinted aurora via the green palette slot) |
| Signal Beam | **pokeorange** (alternating red/blue pulses + screen strobe) |
| Scale Shot | custom (not in pokeorange) — now fires 3 scales per hit |
| Phantom Force | custom (Shadow Force is a stub in pokeorange) — turn 1 redone: slow Faint Attack-style fade, user stays invisible until the turn-2 strike |

## Batch 2 (moves 378-413)

| Move | Source |
|---|---|
| Headlong Rush | custom |
| Shadow Bone | custom |
| Dire Claw | custom |
| Barb Barrage | custom |
| Infernal Parade | custom |
| Kowtow Cleave | custom |
| Armor Cannon | custom |
| Shell Side Arm | custom |
| Glaive Rush | custom |
| Dragon Darts | custom |
| Apple Acid | custom |
| Grav Apple | custom |
| Psyshield Bash | custom |
| Raging Fury | custom |
| Strange Steam | custom |
| Eerie Spell | custom |
| Baneful Bunker | custom |
| Raging Bull | custom |
| Fickle Beam | custom — FIXED: full 4-segment beam + beam head, reaches the target now |
| Stone Axe | custom (Stealth Rock is a stub in pokeorange) |
| Quiver Dance | custom |
| Stealth Rock | custom (stub in pokeorange) |
| Defog | custom (stub in pokeorange) |
| Body Press | custom |
| Work Up | custom |
| Superpower | **pokeorange** (focus lines, lunge, triple mega-blow) |
| Fiery Dance | custom |
| Foul Play | custom |
| Rage Fist | custom |
| Crush Claw | **pokeorange** (triple rake + crushing claw) |
| Force Palm | **pokeorange** (incl. its spiked-shockwave graphics) |
| Hammer Arm | **pokeorange** (hammer fist drops from the sky + impact smoke) |
| Circle Throw | custom |
| Freeze-Dry | custom |
| Bounce | **pokeorange** (both the spring-up and the drop) |
| Dragon Tail | custom |

**Totals: 16 pokeorange ports + 1 hybrid (Brick Break) + 45 custom.**

## Superpower investigation

Found it: when a hit **broke a Substitute**, the engine zeroed the move's
effect byte (vanilla "no secondary effects through a sub" rule). The self
stat drop after the hit then no longer recognized the move as
self-inflicted and ran through the opponent-drop path — including the
25% "computer miss" roll and Mist/ability checks — so Superpower (and
Hammer Arm, Close Combat, Headlong Rush, Scale Shot, Draco Meteor /
Overheat / Leaf Storm, Shell Smash) randomly skipped their stat changes
in exactly that situation. Fixed in `DoSubstituteDamage`. Bonus fix:
Defiant/Competitive no longer trigger off a mon's own self-inflicted
drops.
