# Historical move access corrections

All **498 roster entries** were checked against mainline history (including Red/Blue/Yellow, Gold/Silver/Crystal, Let’s Go, Legends: Arceus and Legends: Z-A) and Luminescent Platinum 3.0 level-up, egg, machine and tutor tables.

**1,205 newly obtainable species/move pairs; 1,250 pairs remain removed after authored restorations; 35,651 sourced pairs accessible; zero deferred implemented moves.**

Only moves implemented in this ROM are distributed. This is a union of individual historical access, including event moves; it does not claim every four-move combination is transferable between official games.

Valid existing levels, machines and breeding routes remain. Missing access uses the existing purple Blackthorn tutor in the Move Deleter’s House for ¥5,000. Goldenrod keeps its five utility moves. Frigibax learns Freeze-Dry at level 30 because removing unsupported donors otherwise leaves no breeding source.

The six original custom species retain their authored move access, and Pixie Punch retains its custom rules. Clone tables match their originals. Custom evolution branches necessarily carry the parent’s legitimate moves; these exceptions are listed separately below. Smeargle’s Sketch access is verified against moves obtainable in this roster.

**129 trainer move slots** were changed to supported alternatives so NPCs follow the corrected pools. All replacements are recorded in the structured receipt.

Sources: [Team Lumi’s Pokédex](https://luminescent.team/pokedex), [pinned Lumi data](https://github.com/TeamLumi/luminescent-team/tree/943b9efb70e4ead902603d3572982dcd9bcce6b2/__gamedata/gamedata3.0), [pinned Pokémon Showdown data](https://github.com/smogon/pokemon-showdown/tree/1242c1e2d9763ba5b85d33f13aecb89bae19ae3d/data). Exact input URLs, SHA-256 hashes, added-move provenance and final tables are in `tools/testdata/historical_move_access.json`.

## Authored restorations

The project restores 125 level-up entries at their previous levels, 49 machine flags, 28 family egg entries and 4 Blackthorn lessons from before `de9c06cf`. These are deliberate design choices, recorded separately from official and Lumi source evidence.

Crobat regains Poison Jab. Duskull does not regain Shadow Punch; Chandelure, Cursola and Galarian Corsola do not regain Phantom Force; Mankey does not regain Rage Fist; Victreebel and Tangrowth do not regain Wood Hammer; Altaria does not regain Scale Shot. All four Slowbro/Slowking forms retain Slack Off instead of Recover. Normal pre-evolution inheritance and shared family egg lists still apply.

Exact restored routes and the requested and excluded pairs are in `tools/testdata/authored_move_restorations.json`.

## Rechecking

```sh
python tools/audit_historical_move_access.py
python tools/audit_historical_move_access.py --download
python tools/audit_historical_move_access.py --reference
make test-learnsets BATTLE_TEST_PYTHON=.venv/bin/python
```

## Unavoidable custom evolution carryover

- **Xatu:** Energy Ball, Extrasensory, Psybeam, Psycho Cut, Wing Attack.
- **Dragapult:** Scale Shot.
- **Tinkatuff:** Iron Head.
- **Tinkaton:** Iron Head.
- **Appletun:** Bug Bite, Dragon Breath, Infestation.
- **Flapple:** Body Slam, Bug Bite, Dragon Tail, Gyro Ball, Infestation, Recover, Reflect, Sweet Scent.
- **Charjabug:** Signal Beam.
- **Vikavolt:** Nuzzle.
- **Overqwil:** Bubble, Defense Curl, Headbutt, Mimic, Whirlpool.
- **Scrafty:** Night Slash.
- **Walrein:** Freeze-Dry.
- **Ursaluna (Bloodmoon):** Attract, Belly Drum, Counter, Curse, Cut, Defense Curl, Double Team, Dynamic Punch, Fury Cutter, Headbutt, Hone Claws, Mega Kick, Mega Punch, Metronome, Mimic, Mud-Slap, Rock Smash, Rollout, Seismic Toss, Stealth Rock, Strength, Superpower, Swagger, Tackle, Thrash, Torment, Work Up, Zap Cannon.
- **Mr. Rime:** Bide, Counter, Curse, Double-Edge, Dynamic Punch, Magical Leaf, Mind Reader, Nightmare, Play Rough, Psywave, Rage, Skull Bash, Submission, Take Down, Teleport.
- **Sirfetch'd:** Acrobatics, Air Cutter, Baton Pass, Bide, Double Team, Flail, Foresight, Gust, Headbutt, Heat Wave, Mimic, Mirror Move, Mud-Slap, Ominous Wind, Rage, Razor Leaf, Reflect, Take Down, Thief, Twister, Whirlwind, Wish, Yawn.
- **Galvantula:** Spark.

## Every Pokémon

“Added” and “removed” describe net obtainable access in this correction pass. The route rows also show removals where another legitimate route still exists.

### Abomasnow

**Added:** Seismic Toss.

**Removed:** Sunny Day.

- **Removed machine flags:** Sunny Day.
- **Added Blackthorn lessons:** Seismic Toss.
- **Restored natural entries:** Freeze-Dry.

### Abra

**Added:** Foresight.

**Removed:** None.

- **Added Blackthorn lessons:** Foresight.

### Aerodactyl

**Added:** None.

**Removed:** None.

- **Restored natural entries:** Head Smash.

### Aggron

**Added:** False Swipe, Mud Shot.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Added Blackthorn lessons:** False Swipe, Mud Shot.
- **Restored natural entries:** Hammer Arm.
- **Restored machine flags:** Power Gem.

### Aipom

**Added:** Quick Attack.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Quick Attack.

### Alakazam

**Added:** Foresight, Hypnosis.

**Removed:** None.

- **Added Blackthorn lessons:** Foresight, Hypnosis.

### Alolan Diglett

**Added:** Taunt.

**Removed:** Curse, Cut, Rock Smash.

- **Removed machine flags:** Curse, Cut, Rock Smash.
- **Added Blackthorn lessons:** Taunt.

### Alolan Dugtrio

**Added:** Taunt.

**Removed:** Cut, Drill Run, Rock Smash, Strength.

- **Removed natural entries:** Drill Run.
- **Removed machine flags:** Cut, Rock Smash, Strength.
- **Added Blackthorn lessons:** Taunt.

### Alolan Exeggutor

**Added:** Bulk Up.

**Removed:** Dragon Claw, Rock Smash, Rock Tomb.

- **Removed machine flags:** Dragon Claw, Rock Smash, Rock Tomb.
- **Removed family egg entries:** Magical Leaf.
- **Added Blackthorn lessons:** Bulk Up, Magical Leaf.

### Alolan Geodude

**Added:** Ancient Power, Hammer Arm, Scary Face, Sucker Punch.

**Removed:** Drain Punch, Power Gem, Rain Dance.

- **Removed machine flags:** Drain Punch, Power Gem, Rain Dance.
- **Added Blackthorn lessons:** Ancient Power, Hammer Arm, Scary Face, Sucker Punch.
- **Restored family egg entries:** Magnitude.

### Alolan Golem

**Added:** Ancient Power, Fury Cutter, Spikes, Sucker Punch.

**Removed:** Drain Punch, Power Gem, Rain Dance.

- **Removed machine flags:** Drain Punch, Power Gem, Rain Dance.
- **Added Blackthorn lessons:** Ancient Power, Fury Cutter, Spikes, Sucker Punch.
- **Restored natural entries:** Head Smash.

### Alolan Graveler

**Added:** Ancient Power, Body Press, Giga Impact, Hammer Arm, Heavy Slam, Sucker Punch.

**Removed:** Drain Punch, Power Gem, Rain Dance.

- **Removed machine flags:** Drain Punch, Power Gem, Rain Dance.
- **Added Blackthorn lessons:** Ancient Power, Body Press, Giga Impact, Hammer Arm, Heavy Slam, Sucker Punch.

### Alolan Grimer

**Added:** Lick, Shadow Punch, Zap Cannon.

**Removed:** Energy Ball, Night Slash, Strength.

- **Removed machine flags:** Energy Ball, Night Slash, Strength.
- **Added Blackthorn lessons:** Lick, Shadow Punch, Zap Cannon.

### Alolan Marowak

**Added:** Fury Attack, Tackle.

**Removed:** Drain Punch, Drill Run, Ice Punch, Mud Shot.

- **Removed natural entries:** Drill Run, Mud Shot.
- **Removed machine flags:** Drain Punch, Ice Punch.
- **Added Blackthorn lessons:** Fury Attack, Tackle.
- **Restored natural entries:** Phantom Force.

### Alolan Meowth

**Added:** False Swipe, Metronome, Mimic, Mud-Slap, Roar, Spikes, Tail Whip.

**Removed:** Crush Claw, Flash, Iron Head.

- **Removed natural entries:** Crush Claw.
- **Removed machine flags:** Flash, Iron Head.
- **Added Blackthorn lessons:** False Swipe, Metronome, Mimic, Mud-Slap, Roar, Spikes, Tail Whip.

### Alolan Muk

**Added:** Lick, Shadow Punch, Zap Cannon.

**Removed:** Energy Ball, Rock Smash, Strength.

- **Removed machine flags:** Energy Ball, Rock Smash, Strength.
- **Added Blackthorn lessons:** Lick, Shadow Punch, Zap Cannon.
- **Restored natural entries:** Cross Poison.
- **Restored machine flags:** Night Slash.

### Alolan Ninetales

**Added:** Bulk Up, Energy Ball, Giga Drain, Ice Fang, Psychic, Rock Slide, Snarl, Thief.

**Removed:** Curse, Iron Head.

- **Removed machine flags:** Curse, Iron Head.
- **Added Blackthorn lessons:** Bulk Up, Energy Ball, Giga Drain, Ice Fang, Psychic, Rock Slide, Snarl, Thief.
- **Restored machine flags:** Shadow Ball.

### Alolan Persian

**Added:** False Swipe, Metronome, Mimic, Mud-Slap, Spikes, Tail Whip, Toxic Spikes.

**Removed:** Crush Claw, Flash, Iron Head.

- **Removed natural entries:** Crush Claw.
- **Removed machine flags:** Flash, Iron Head.
- **Added Blackthorn lessons:** False Swipe, Metronome, Mimic, Mud-Slap, Spikes, Tail Whip, Toxic Spikes.

### Alolan Raichu

**Added:** Dazzling Gleam, Dizzy Punch, Ice Punch, Petal Dance, Scary Face.

**Removed:** Drain Punch, Iron Head, Rock Tomb, Zen Headbutt.

- **Removed machine flags:** Drain Punch, Iron Head, Rock Tomb, Zen Headbutt.
- **Added Blackthorn lessons:** Dazzling Gleam, Dizzy Punch, Ice Punch, Petal Dance, Scary Face.

### Alolan Raticate

**Added:** Endure, False Swipe, Mud-Slap, Nasty Plot, Thunder, Thunder Wave, Thunderbolt, Wild Charge.

**Removed:** Beat Up, Curse, Iron Head, Screech.

- **Removed machine flags:** Curse, Iron Head.
- **Removed family egg entries:** Beat Up, Screech.
- **Added Blackthorn lessons:** Endure, False Swipe, Mud-Slap, Nasty Plot, Thunder, Thunder Wave, Thunderbolt, Wild Charge.
- **Restored machine flags:** Night Slash.

### Alolan Rattata

**Added:** Endure, False Swipe, Mud-Slap, Nasty Plot, Scary Face, Strength, Swords Dance, Thunder, Thunder Wave, Thunderbolt, Venoshock, Wild Charge, Work Up.

**Removed:** Beat Up, Curse, Iron Head, Screech.

- **Removed machine flags:** Curse, Iron Head.
- **Removed family egg entries:** Beat Up, Screech.
- **Added Blackthorn lessons:** Endure, False Swipe, Mud-Slap, Nasty Plot, Scary Face, Strength, Swords Dance, Thunder, Thunder Wave, Thunderbolt, Venoshock, Wild Charge, Work Up.
- **Restored machine flags:** Knock Off, Night Slash.

### Alolan Sandshrew

**Added:** False Swipe, Giga Impact, Hyper Beam, Mud-Slap.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Added Blackthorn lessons:** False Swipe, Giga Impact, Hyper Beam, Mud-Slap.

### Alolan Sandslash

**Added:** Mud-Slap.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Added Blackthorn lessons:** Mud-Slap.
- **Restored Blackthorn lessons:** Freeze-Dry.

### Alolan Vulpix

**Added:** Bulk Up, Energy Ball, Giga Drain, Ice Fang, Psychic, Rock Slide, Snarl, Thief.

**Removed:** Curse, Iron Head.

- **Removed machine flags:** Curse, Iron Head.
- **Added Blackthorn lessons:** Bulk Up, Energy Ball, Giga Drain, Ice Fang, Psychic, Rock Slide, Snarl, Thief.
- **Restored machine flags:** Shadow Ball.

### Altaria

**Added:** Petal Dance.

**Removed:** Bounce, Curse, Scale Shot, Strength.

- **Removed natural entries:** Bounce, Scale Shot.
- **Removed machine flags:** Curse, Strength.
- **Added Blackthorn lessons:** Petal Dance.
- **Restored natural entries:** Dragon Tail, Draining Kiss.

### Amaura

**Added:** Tackle.

**Removed:** Curse, Headbutt, Mud-Slap.

- **Removed machine flags:** Curse, Headbutt, Mud-Slap.
- **Added Blackthorn lessons:** Tackle.
- **Restored machine flags:** Power Gem.
- **Restored family egg entries:** Moonblast.

### Ambipom

**Added:** Quick Attack.

**Removed:** Dizzy Punch, Drain Punch, Iron Head.

- **Removed natural entries:** Dizzy Punch.
- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Quick Attack.

### Ampharos

**Added:** Comet Punch, Flash Cannon.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Comet Punch, Flash Cannon.
- **Restored natural entries:** Hyper Voice, Nuzzle.

### Annihilape

**Added:** Comet Punch, Knock Off, Light Screen, Roar, Rock Throw, Tackle, Torment.

**Removed:** Foul Play, Iron Head, Snarl, Will-O-Wisp.

- **Removed natural entries:** Foul Play, Snarl.
- **Removed machine flags:** Iron Head, Will-O-Wisp.
- **Added Blackthorn lessons:** Comet Punch, Knock Off, Light Screen, Roar, Rock Throw, Tackle, Torment.
- **Restored natural entries:** Superpower.

### Anorith

**Added:** Bug Buzz.

**Removed:** Earthquake, Power Gem, Strength.

- **Removed machine flags:** Earthquake, Power Gem, Strength.
- **Added Blackthorn lessons:** Bug Buzz.

### Appletun

**Added:** Frustration.

**Removed:** Dragon Claw, Rock Smash, Rock Tomb, Scale Shot, Strength, Swagger, Thief, Twister, Wood Hammer.

- **Removed natural entries:** Scale Shot, Wood Hammer.
- **Removed machine flags:** Dragon Claw, Rock Smash, Rock Tomb, Strength, Swagger, Thief.
- **Removed family egg entries:** Dragon Tail, Giga Drain, Leech Seed.
- **Added Blackthorn lessons:** Frustration, Giga Drain.

### Applin

**Added:** None.

**Removed:** Absorb, Curse, Dragon Breath, Dragon Claw, Dragon Pulse, Dragon Tail, Energy Ball, Facade, Giga Drain, Growth, Hidden Power, Leech Seed, Mega Drain, Protect, Rest, Return, Solar Beam, Sunny Day, Swagger, Toxic, Twister.

- **Removed natural entries:** Absorb, Dragon Breath, Growth, Mega Drain, Twister.
- **Removed machine flags:** Curse, Dragon Claw, Dragon Pulse, Energy Ball, Facade, Hidden Power, Protect, Rest, Return, Solar Beam, Sunny Day, Swagger, Toxic.
- **Removed family egg entries:** Dragon Tail, Giga Drain, Leech Seed.

### Arbok

**Added:** Tackle.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.
- **Added Blackthorn lessons:** Tackle.

### Arcanine

**Added:** None.

**Removed:** Crush Claw.

- **Removed natural entries:** Crush Claw.

### Archaludon

**Added:** None.

**Removed:** Curse, Dig, Dragon Breath, Hammer Arm, Hidden Power, Return, Sandstorm, Scale Shot, Strength, Swagger, Toxic.

- **Removed natural entries:** Dragon Breath, Hammer Arm, Scale Shot.
- **Removed machine flags:** Curse, Dig, Hidden Power, Return, Sandstorm, Strength, Swagger, Toxic.

### Archen

**Added:** Air Slash.

**Removed:** Curse, Fly, Focus Energy, Headbutt, Mud-Slap, Sunny Day, Take Down, Thief.

- **Removed natural entries:** Take Down.
- **Removed machine flags:** Curse, Fly, Headbutt, Mud-Slap, Sunny Day, Thief.
- **Removed family egg entries:** Focus Energy.
- **Added Blackthorn lessons:** Air Slash.

### Archeops

**Added:** Drill Peck.

**Removed:** Curse, Drain Punch, Focus Energy, Headbutt, Mud-Slap, Strength, Sunny Day, Take Down, Thief, X-Scissor.

- **Removed machine flags:** Curse, Drain Punch, Headbutt, Mud-Slap, Strength, Sunny Day, Thief.
- **Removed family egg entries:** Focus Energy.
- **Removed fallback lessons:** X-Scissor.
- **Added Blackthorn lessons:** Drill Peck.

### Arctibax

**Added:** None.

**Removed:** Attract, Curse, Double-Edge, Earthquake, Hidden Power, Mist, Return, Swagger, Toxic.

- **Removed machine flags:** Attract, Curse, Earthquake, Hidden Power, Return, Swagger, Toxic.
- **Removed family egg entries:** Double-Edge, Mist.
- **Restored natural entries:** Scale Shot.

### Ariados

**Added:** False Swipe, First Impression, Growth, Headbutt.

**Removed:** Energy Ball, Fury Cutter.

- **Removed machine flags:** Energy Ball, Fury Cutter.
- **Added Blackthorn lessons:** False Swipe, First Impression, Growth, Headbutt.

### Armaldo

**Added:** Bug Buzz.

**Removed:** Signal Beam.

- **Removed fallback lessons:** Signal Beam.
- **Added Blackthorn lessons:** Bug Buzz.
- **Restored machine flags:** Power Gem.

### Armarouge

**Added:** Double Team, Future Sight, Ominous Wind, Rock Tomb, Smokescreen.

**Removed:** Curse, Extrasensory, Fire Fang, Flash, Hex, Hidden Power, Return, Swagger, Swords Dance, Zen Headbutt.

- **Removed natural entries:** Extrasensory, Hex.
- **Removed machine flags:** Curse, Flash, Hidden Power, Return, Swagger, Zen Headbutt.
- **Removed family egg entries:** Calm Mind, Swords Dance.
- **Added Blackthorn lessons:** Double Team, Future Sight, Ominous Wind, Rock Tomb, Smokescreen.

### Aron

**Added:** False Swipe, Mud Shot.

**Removed:** Fire Blast, Fire Punch, Flash Cannon, Ice Beam, Ice Punch, Power Gem, Thunder Punch, Thunderbolt.

- **Removed machine flags:** Fire Blast, Fire Punch, Flash Cannon, Ice Beam, Ice Punch, Power Gem, Thunder Punch, Thunderbolt.
- **Added Blackthorn lessons:** False Swipe, Mud Shot.

### Articuno

**Added:** None.

**Removed:** None.


### Aurorus

**Added:** Tackle.

**Removed:** Curse, Headbutt, Mud-Slap.

- **Removed machine flags:** Curse, Headbutt, Mud-Slap.
- **Added Blackthorn lessons:** Tackle.

### Axew

**Added:** None.

**Removed:** Curse, Earthquake, Headbutt, Hyper Beam.

- **Removed machine flags:** Curse, Earthquake, Headbutt, Hyper Beam.

### Azumarill

**Added:** Dizzy Punch, Scary Face.

**Removed:** Calm Mind, Growl, Iron Head, Rock Tomb.

- **Removed machine flags:** Iron Head, Rock Tomb.
- **Removed family egg entries:** Amnesia, Calm Mind, Future Sight, Superpower.
- **Added Blackthorn lessons:** Amnesia, Dizzy Punch, Future Sight, Scary Face.

### Azurill

**Added:** None.

**Removed:** Amnesia, Calm Mind, Curse, Future Sight, Growl, Iron Head, Rock Tomb, Superpower.

- **Removed natural entries:** Growl.
- **Removed machine flags:** Curse, Iron Head, Rock Tomb.
- **Removed family egg entries:** Amnesia, Calm Mind, Future Sight, Superpower.

### Bagon

**Added:** None.

**Removed:** Curse, Earthquake, Scale Shot, Superpower.

- **Removed natural entries:** Scale Shot.
- **Removed machine flags:** Curse, Earthquake.
- **Removed family egg entries:** Superpower.

### Banette

**Added:** Crush Claw, Icicle Spear, Lick, Razor Wind, Shadow Punch, Slash, Vacuum Wave, Zen Headbutt.

**Removed:** Drain Punch, Fire Punch, Ice Punch, Strength, Swift, Thunder Punch.

- **Removed machine flags:** Drain Punch, Fire Punch, Ice Punch, Strength, Swift, Thunder Punch.
- **Added Blackthorn lessons:** Crush Claw, Icicle Spear, Lick, Razor Wind, Shadow Punch, Slash, Vacuum Wave, Zen Headbutt.

### Bastiodon

**Added:** Self-Destruct.

**Removed:** None.

- **Added Blackthorn lessons:** Self-Destruct.
- **Restored Blackthorn lessons:** Head Smash.

### Baxcalibur

**Added:** None.

**Removed:** Attract, Curse, Hidden Power, Mist, Return, Strength, Swagger, Toxic.

- **Removed machine flags:** Attract, Curse, Hidden Power, Return, Strength, Swagger, Toxic.
- **Removed family egg entries:** Double-Edge, Mist.
- **Added Blackthorn lessons:** Double-Edge.

### Bayleef

**Added:** Bulldoze, Dazzling Gleam, Disarming Voice, Earth Power, Petal Dance, Tail Whip.

**Removed:** Iron Head, Mega Drain.

- **Removed natural entries:** Mega Drain.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Bulldoze, Dazzling Gleam, Disarming Voice, Earth Power, Petal Dance, Tail Whip.

### Beedrill

**Added:** Bug Buzz, Fly, Lunge.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.
- **Added Blackthorn lessons:** Bug Buzz, Fly, Lunge.

### Bellossom

**Added:** None.

**Removed:** Wood Hammer.

- **Removed natural entries:** Wood Hammer.
- **Restored natural entries:** Draining Kiss.

### Bellsprout

**Added:** Lovely Kiss, Sweet Kiss, Toxic Spikes.

**Removed:** None.

- **Added Blackthorn lessons:** Lovely Kiss, Sweet Kiss, Toxic Spikes.

### Bisharp

**Added:** None.

**Removed:** Curse, Focus Energy, Strength.

- **Removed machine flags:** Curse, Strength.
- **Removed family egg entries:** Focus Energy.
- **Restored natural entries:** Sacred Sword.

### Blastoise

**Added:** Heavy Slam, Zap Cannon.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Dark Pulse.
- **Added Blackthorn lessons:** Dark Pulse, Heavy Slam, Zap Cannon.

### Blastoise (Clone)

**Added:** Heavy Slam, Zap Cannon.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Dark Pulse.
- **Added Blackthorn lessons:** Dark Pulse, Heavy Slam, Zap Cannon.

### Blissey

**Added:** Draining Kiss, Fairy Wind.

**Removed:** Encore, Iron Head.

- **Removed machine flags:** Iron Head.
- **Removed family egg entries:** Encore, Wish.
- **Added Blackthorn lessons:** Draining Kiss, Fairy Wind, Wish.

### Bonsly

**Added:** Head Smash, Iron Defense, Seismic Toss, Tackle.

**Removed:** Ancient Power, Charm, Leer, Reversal, Rock Smash.

- **Removed natural entries:** Charm, Leer, Reversal.
- **Removed machine flags:** Rock Smash.
- **Removed fallback lessons:** Ancient Power.
- **Added Blackthorn lessons:** Head Smash, Iron Defense, Seismic Toss, Tackle.

### Bounsweet

**Added:** Growth, Power Whip.

**Removed:** Curse, Leech Seed.

- **Removed machine flags:** Curse.
- **Removed family egg entries:** Leech Seed.
- **Added Blackthorn lessons:** Growth, Power Whip.

### Breloom

**Added:** None.

**Removed:** Curse, Wood Hammer.

- **Removed natural entries:** Wood Hammer.
- **Removed machine flags:** Curse.

### Bulbasaur

**Added:** Ancient Power.

**Removed:** None.

- **Added Blackthorn lessons:** Ancient Power.

### Bulbasaur (Clone)

**Added:** Ancient Power.

**Removed:** None.

- **Added Blackthorn lessons:** Ancient Power.

### Buneary

**Added:** Close Combat, Cotton Guard, Double-Edge, Draining Kiss, Dynamic Punch, Seismic Toss, Tackle.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** Close Combat, Cotton Guard, Double-Edge, Draining Kiss, Dynamic Punch, Seismic Toss, Tackle.
- **Restored family egg entries:** Karate Chop.

### Butterfree

**Added:** Fly.

**Removed:** Fury Cutter.

- **Removed machine flags:** Fury Cutter.
- **Added Blackthorn lessons:** Fly.

### Camerupt

**Added:** None.

**Removed:** Raging Fury.

- **Removed natural entries:** Raging Fury.

### Carracosta

**Added:** Heavy Slam.

**Removed:** Drain Punch, Ice Punch, Mud-Slap, Power Gem, Roar.

- **Removed machine flags:** Drain Punch, Ice Punch, Mud-Slap, Power Gem, Roar.
- **Added Blackthorn lessons:** Heavy Slam.
- **Restored natural entries:** Head Smash.
- **Restored machine flags:** Headbutt.

### Caterpie

**Added:** None.

**Removed:** None.


### Celebi

**Added:** None.

**Removed:** None.


### Centiskorch

**Added:** Frustration, Gyro Ball, U-turn.

**Removed:** Agility, Curse, Fury Cutter, Raging Fury, Scary Face, Strength, Swagger.

- **Removed natural entries:** Raging Fury.
- **Removed machine flags:** Curse, Fury Cutter, Strength, Swagger.
- **Removed family egg entries:** Agility, Flame Charge, Scary Face, X-Scissor.
- **Added Blackthorn lessons:** Flame Charge, Frustration, Gyro Ball, U-turn, X-Scissor.

### Ceruledge

**Added:** Cut, Giga Impact, Ominous Wind, Razor Wind, Smokescreen, Stone Edge.

**Removed:** Attract, Calm Mind, Fire Fang, Hyper Beam, Return, Strength.

- **Removed natural entries:** Fire Fang.
- **Removed machine flags:** Attract, Hyper Beam, Return, Strength.
- **Removed family egg entries:** Calm Mind, Swords Dance.
- **Added Blackthorn lessons:** Cut, Giga Impact, Hex, Ominous Wind, Razor Wind, Smokescreen, Stone Edge.

### Cetitan

**Added:** None.

**Removed:** Attract, Freeze-Dry, Hidden Power, Return, Strength, Surf, Swagger, Toxic, Work Up.

- **Removed natural entries:** Work Up.
- **Removed machine flags:** Attract, Hidden Power, Return, Strength, Surf, Swagger, Toxic, Work Up.
- **Removed fallback lessons:** Freeze-Dry.
- **Restored natural entries:** Hammer Arm.
- **Restored machine flags:** Headbutt.

### Cetoddle

**Added:** None.

**Removed:** Attract, Freeze-Dry, Hidden Power, Return, Strength, Surf, Swagger, Toxic, Work Up.

- **Removed natural entries:** Work Up.
- **Removed machine flags:** Attract, Hidden Power, Return, Strength, Surf, Swagger, Toxic, Work Up.
- **Removed fallback lessons:** Freeze-Dry.
- **Restored machine flags:** Headbutt.
- **Restored family egg entries:** Slack Off.

### Chandelure

**Added:** Ominous Wind, Smokescreen.

**Removed:** Infestation, Phantom Force, Swift.

- **Removed natural entries:** Infestation.
- **Removed machine flags:** Swift.
- **Removed fallback lessons:** Phantom Force.
- **Added Blackthorn lessons:** Ominous Wind, Smokescreen.

### Chansey

**Added:** Draining Kiss, Fairy Wind.

**Removed:** Encore, Iron Head.

- **Removed machine flags:** Iron Head.
- **Removed family egg entries:** Encore, Wish.
- **Added Blackthorn lessons:** Draining Kiss, Fairy Wind, Wish.

### Charcadet

**Added:** Ominous Wind, Smokescreen.

**Removed:** Attract, Calm Mind, Curse, Fire Fang, Hex, Hidden Power, Return, Swagger, Swords Dance, Toxic.

- **Removed natural entries:** Fire Fang, Hex, Mean Look.
- **Removed machine flags:** Attract, Curse, Hidden Power, Return, Swagger, Toxic.
- **Removed family egg entries:** Calm Mind, Swords Dance.
- **Added Blackthorn lessons:** Ominous Wind, Smokescreen.
- **Restored family egg entries:** Mean Look.

### Charizard

**Added:** Tackle.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Tackle.
- **Restored natural entries:** Draco Meteor, Raging Fury.

### Charizard (Clone)

**Added:** Tackle.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Tackle.
- **Restored natural entries:** Draco Meteor, Raging Fury.

### Charjabug

**Added:** None.

**Removed:** Agility, Curse, Flash, Fury Cutter, Zap Cannon.

- **Removed machine flags:** Curse, Flash, Fury Cutter, Zap Cannon.
- **Removed family egg entries:** Agility.
- **Restored natural entries:** Nuzzle.

### Charmander

**Added:** Tackle.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Tackle.

### Charmander (Clone)

**Added:** Tackle.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Tackle.

### Charmeleon

**Added:** Tackle.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Tackle.

### Charmeleon (Clone)

**Added:** Tackle.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Tackle.

### Chikorita

**Added:** Bulldoze, Dazzling Gleam, Disarming Voice, Earth Power, Knock Off, Petal Dance, Tail Whip.

**Removed:** Iron Head, Mega Drain.

- **Removed natural entries:** Mega Drain.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Bulldoze, Dazzling Gleam, Disarming Voice, Earth Power, Knock Off, Petal Dance, Tail Whip.

### Chinchou

**Added:** Light Screen.

**Removed:** Nuzzle.

- **Removed natural entries:** Nuzzle.
- **Added Blackthorn lessons:** Light Screen.

### Clefable

**Added:** Air Slash, Dizzy Punch, Petal Dance, Scary Face, Tackle.

**Removed:** Iron Head, Rock Tomb.

- **Removed machine flags:** Iron Head, Rock Tomb.
- **Removed family egg entries:** Heal Bell.
- **Added Blackthorn lessons:** Air Slash, Dizzy Punch, Heal Bell, Petal Dance, Scary Face, Tackle.

### Clefairy

**Added:** Dizzy Punch, Petal Dance, Scary Face, Tackle.

**Removed:** Iron Head, Rock Tomb.

- **Removed machine flags:** Iron Head, Rock Tomb.
- **Removed family egg entries:** Heal Bell.
- **Added Blackthorn lessons:** Dizzy Punch, Heal Bell, Petal Dance, Scary Face, Tackle.

### Cleffa

**Added:** Blizzard, Bubble Beam, Dizzy Punch, Ice Beam, Moonblast, Moonlight, Petal Dance, Scary Face, Stealth Rock, Tackle, Thunder, Thunderbolt.

**Removed:** Heal Bell, Iron Head, Rock Tomb.

- **Removed machine flags:** Iron Head, Rock Tomb.
- **Removed family egg entries:** Heal Bell.
- **Added Blackthorn lessons:** Blizzard, Bubble Beam, Dizzy Punch, Ice Beam, Moonblast, Moonlight, Petal Dance, Scary Face, Stealth Rock, Tackle, Thunder, Thunderbolt.

### Clodsire

**Added:** Flip Turn, Frustration, Weather Ball, Whirlpool.

**Removed:** Attract, Blizzard, Drain Punch, Flash, Headbutt, Ice Beam, Ice Punch, Rock Smash, Safeguard, Strength, Swagger, Thief.

- **Removed machine flags:** Attract, Blizzard, Drain Punch, Flash, Headbutt, Ice Beam, Ice Punch, Rock Smash, Strength, Swagger, Thief.
- **Removed family egg entries:** Safeguard.
- **Added Blackthorn lessons:** Flip Turn, Frustration, Weather Ball, Whirlpool.

### Cloyster

**Added:** None.

**Removed:** None.

- **Restored natural entries:** Freeze-Dry.

### Conkeldurr

**Added:** None.

**Removed:** None.

- **Restored natural entries:** Body Press.

### Corsola

**Added:** None.

**Removed:** None.


### Corviknight

**Added:** Frustration, Gust, Ominous Wind, Razor Wind, Slash.

**Removed:** Cut, Mud-Slap, Sandstorm, Strength.

- **Removed machine flags:** Cut, Mud-Slap, Sandstorm, Strength.
- **Added Blackthorn lessons:** Frustration, Gust, Ominous Wind, Razor Wind, Slash.

### Corvisquire

**Added:** Frustration, Gust, Razor Wind, Slash.

**Removed:** Curse, Mud-Slap.

- **Removed machine flags:** Curse, Mud-Slap.
- **Added Blackthorn lessons:** Frustration, Gust, Razor Wind, Slash.
- **Restored machine flags:** Steel Wing.

### Cradily

**Added:** None.

**Removed:** Leaf Storm, Wood Hammer.

- **Removed natural entries:** Leaf Storm, Wood Hammer.
- **Restored machine flags:** Power Gem.

### Cranidos

**Added:** Bite, Seismic Toss, Tackle.

**Removed:** None.

- **Added Blackthorn lessons:** Bite, Seismic Toss, Tackle.
- **Restored machine flags:** Power Gem.

### Croagunk

**Added:** Close Combat, Earth Power, Seismic Toss.

**Removed:** Acid Armor, Curse.

- **Removed natural entries:** Acid Armor.
- **Removed machine flags:** Curse.
- **Removed family egg entries:** Acid Armor.
- **Added Blackthorn lessons:** Close Combat, Earth Power, Seismic Toss.
- **Restored natural entries:** Force Palm.

### Crobat

**Added:** Flail, Knock Off, Night Slash.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.
- **Added Blackthorn lessons:** Flail, Knock Off, Night Slash.
- **Restored natural entries:** Poison Jab.

### Croconaw

**Added:** Bubble Beam, Bulldoze, Dark Pulse, False Swipe, Outrage, Submission, Tackle.

**Removed:** Agility, Flash, Fly, Iron Head.

- **Removed machine flags:** Flash, Fly, Iron Head.
- **Added Blackthorn lessons:** Bubble Beam, Bulldoze, Dark Pulse, False Swipe, Outrage, Submission, Tackle.

### Cubone

**Added:** Fury Attack, Tackle.

**Removed:** Drain Punch, Drill Run, Mud Shot.

- **Removed natural entries:** Drill Run, Mud Shot.
- **Removed machine flags:** Drain Punch.
- **Added Blackthorn lessons:** Fury Attack, Tackle.

### Cursola

**Added:** Double Team, Explosion, Frustration, Heal Bell, Pain Split, Rock Polish, Rollout.

**Removed:** Barrier, Energy Ball, Foul Play, Headbutt, Phantom Force, Waterfall.

- **Removed natural entries:** Foul Play.
- **Removed machine flags:** Energy Ball, Headbutt, Waterfall.
- **Removed family egg entries:** Barrier.
- **Added Blackthorn lessons:** Double Team, Explosion, Frustration, Heal Bell, Pain Split, Rock Polish, Rollout.

### Cyndaquil

**Added:** None.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.

### Deino

**Added:** Dragon Dance.

**Removed:** Curse, Dragon Claw, Fire Blast, Flamethrower, Knock Off, Scale Shot, Surf.

- **Removed natural entries:** Scale Shot.
- **Removed machine flags:** Curse, Dragon Claw, Fire Blast, Flamethrower, Knock Off, Surf.
- **Added Blackthorn lessons:** Dragon Dance.
- **Restored machine flags:** Night Slash.

### Delibird

**Added:** Pay Day, Peck, Razor Wind, U-turn.

**Removed:** Mist.

- **Removed family egg entries:** Mist.
- **Added Blackthorn lessons:** Pay Day, Peck, Razor Wind, U-turn.

### Dewgong

**Added:** Flail.

**Removed:** None.

- **Added Blackthorn lessons:** Flail.
- **Restored natural entries:** Freeze-Dry.

### Diglett

**Added:** False Swipe.

**Removed:** None.

- **Added Blackthorn lessons:** False Swipe.

### Dipplin

**Added:** None.

**Removed:** Absorb, Apple Acid, Curse, Dragon Claw, Hidden Power, Iron Head, Leech Seed, Mega Drain, Return, Rock Smash, Rock Tomb, Swagger, Thief, Toxic, Twister.

- **Removed natural entries:** Apple Acid.
- **Removed machine flags:** Curse, Dragon Claw, Hidden Power, Iron Head, Return, Rock Smash, Rock Tomb, Swagger, Thief, Toxic.
- **Removed family egg entries:** Dragon Tail, Giga Drain, Leech Seed.
- **Added Blackthorn lessons:** Giga Drain.

### Ditto

**Added:** None.

**Removed:** None.


### Dodrio

**Added:** None.

**Removed:** Bounce, Dual Wingbeat.

- **Removed natural entries:** Bounce, Dual Wingbeat.

### Doduo

**Added:** None.

**Removed:** Dual Wingbeat.

- **Removed natural entries:** Dual Wingbeat.
- **Restored natural entries:** Drill Run.

### Donphan

**Added:** Absorb, Spikes.

**Removed:** None.

- **Added Blackthorn lessons:** Absorb, Spikes.
- **Restored natural entries:** Drill Run.

### Dragapult

**Added:** Frustration, Shadow Claw.

**Removed:** Crunch, Defog, Dual Wingbeat, Taunt, Twister.

- **Removed natural entries:** Crunch, Defog, Dual Wingbeat, Scale Shot.
- **Removed family egg entries:** Taunt.
- **Added Blackthorn lessons:** Frustration, Shadow Claw.

### Dragonair

**Added:** Fly, Tackle.

**Removed:** None.

- **Added Blackthorn lessons:** Fly, Tackle.

### Dragonite

**Added:** Tackle, Vacuum Wave, Whirlwind.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Added Blackthorn lessons:** Tackle, Vacuum Wave, Whirlwind.

### Drakloak

**Added:** Frustration.

**Removed:** Defog, Dragon Claw, Dual Wingbeat, Swagger, Taunt, Twister.

- **Removed natural entries:** Defog, Dual Wingbeat.
- **Removed machine flags:** Dragon Claw, Swagger.
- **Removed family egg entries:** Taunt.
- **Added Blackthorn lessons:** Frustration.
- **Restored natural entries:** Dragon Breath, Scale Shot.

### Dratini

**Added:** Tackle.

**Removed:** None.

- **Added Blackthorn lessons:** Tackle.

### Dreepy

**Added:** None.

**Removed:** Agility, Dragon Claw, Dragon Pulse, Dual Wingbeat, Fire Blast, Flamethrower, Hex, Hidden Power, Return, Scale Shot, Shadow Ball, Swagger, Taunt, Thunderbolt, Twister, Will-O-Wisp.

- **Removed natural entries:** Agility, Dual Wingbeat, Hex, Scale Shot, Twister.
- **Removed machine flags:** Dragon Claw, Dragon Pulse, Fire Blast, Flamethrower, Hidden Power, Return, Shadow Ball, Swagger, Thunderbolt, Will-O-Wisp.
- **Removed family egg entries:** Taunt.
- **Restored natural entries:** Dragon Breath, Phantom Force.

### Drifblim

**Added:** Confusion, Extrasensory, Flamethrower, Seismic Toss.

**Removed:** Bounce, Dual Wingbeat, Steel Wing, Strength.

- **Removed natural entries:** Bounce, Dual Wingbeat.
- **Removed machine flags:** Steel Wing, Strength.
- **Added Blackthorn lessons:** Confusion, Extrasensory, Flamethrower, Seismic Toss.

### Drifloon

**Added:** Confusion, Extrasensory, Seismic Toss.

**Removed:** Bounce, Steel Wing.

- **Removed natural entries:** Bounce.
- **Removed machine flags:** Steel Wing.
- **Added Blackthorn lessons:** Confusion, Extrasensory, Seismic Toss.

### Drilbur

**Added:** Agility, Leer, Tackle.

**Removed:** Superpower, Thrash.

- **Removed family egg entries:** Superpower, Thrash.
- **Added Blackthorn lessons:** Agility, Leer, Tackle.

### Drowzee

**Added:** Amnesia.

**Removed:** None.

- **Added Blackthorn lessons:** Amnesia.

### Dudunsparce

**Added:** Dazzling Gleam, Draco Meteor, Fury Attack, Horn Drill.

**Removed:** Cross Poison, Foul Play, Iron Head, Swift, Work Up.

- **Removed natural entries:** Cross Poison, Foul Play, Work Up.
- **Removed machine flags:** Iron Head, Swift, Work Up.
- **Added Blackthorn lessons:** Dazzling Gleam, Draco Meteor, Fury Attack, Horn Drill.
- **Restored natural entries:** Dragon Breath.
- **Restored machine flags:** Dragon Claw.

### Dugtrio

**Added:** False Swipe.

**Removed:** Drill Run.

- **Removed natural entries:** Drill Run.
- **Added Blackthorn lessons:** False Swipe.

### Dunsparce

**Added:** Draco Meteor, Fury Attack, Horn Drill.

**Removed:** Iron Head, Work Up.

- **Removed natural entries:** Work Up.
- **Removed machine flags:** Iron Head, Work Up.
- **Added Blackthorn lessons:** Draco Meteor, Fury Attack, Horn Drill.
- **Restored natural entries:** Dragon Breath.

### Duraludon

**Added:** None.

**Removed:** Curse, Dig, Dragon Breath, Earthquake, Hammer Arm, Hidden Power, Return, Sandstorm, Scale Shot, Strength, Swagger, Toxic.

- **Removed natural entries:** Dragon Breath, Hammer Arm, Scale Shot.
- **Removed machine flags:** Curse, Dig, Earthquake, Hidden Power, Return, Sandstorm, Strength, Swagger, Toxic.

### Dusclops

**Added:** Absorb.

**Removed:** None.

- **Added Blackthorn lessons:** Absorb.
- **Restored natural entries:** Shadow Claw.

### Dusknoir

**Added:** Absorb, Drain Punch.

**Removed:** None.

- **Added Blackthorn lessons:** Absorb, Drain Punch.
- **Restored natural entries:** Shadow Claw.

### Duskull

**Added:** Absorb.

**Removed:** Shadow Punch.

- **Removed natural entries:** Shadow Punch.
- **Added Blackthorn lessons:** Absorb.

### Eevee

**Added:** Disarming Voice, Grass Knot, Growth.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Disarming Voice, Grass Knot, Growth.

### Ekans

**Added:** Ice Fang, Tackle, Thunder Fang.

**Removed:** Dragon Tail, Energy Ball.

- **Removed natural entries:** Dragon Tail.
- **Removed machine flags:** Energy Ball.
- **Added Blackthorn lessons:** Ice Fang, Tackle, Thunder Fang.

### Electabuzz

**Added:** Dizzy Punch, Pursuit, Spark.

**Removed:** Crunch, Drain Punch, Iron Head, Nuzzle.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Removed family egg entries:** Crunch.
- **Added Blackthorn lessons:** Dizzy Punch, Pursuit, Spark.

### Electivire

**Added:** Dizzy Punch, Pursuit, Spark.

**Removed:** Crunch, Iron Head, Nuzzle.

- **Removed machine flags:** Iron Head.
- **Removed family egg entries:** Crunch.
- **Added Blackthorn lessons:** Dizzy Punch, Pursuit, Spark.

### Electrode

**Added:** Bug Buzz, Energy Ball.

**Removed:** Nuzzle, Recover, Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Removed family egg entries:** Nuzzle, Recover.
- **Added Blackthorn lessons:** Bug Buzz, Energy Ball.

### Elekid

**Added:** Dizzy Punch, Pursuit, Spark.

**Removed:** Crunch, Drain Punch, Nuzzle.

- **Removed natural entries:** Nuzzle.
- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Crunch.
- **Added Blackthorn lessons:** Dizzy Punch, Pursuit, Spark.

### Entei

**Added:** None.

**Removed:** None.


### Espathra

**Added:** None.

**Removed:** Air Cutter, Attract, Charm, Curse, Flash, Future Sight, Haze, Hidden Power, Magical Leaf, Return, Swagger, Toxic.

- **Removed natural entries:** Air Cutter, Charm.
- **Removed machine flags:** Attract, Curse, Flash, Hidden Power, Return, Swagger, Toxic.
- **Removed family egg entries:** Future Sight, Haze, Magical Leaf.

### Espeon

**Added:** Disarming Voice, Growth, Rock Smash, Safeguard.

**Removed:** Iron Head, Psycho Cut.

- **Removed machine flags:** Iron Head.
- **Removed fallback lessons:** Psycho Cut.
- **Added Blackthorn lessons:** Disarming Voice, Growth, Rock Smash, Safeguard.

### Excadrill

**Added:** Agility, Leer, Megahorn, Tackle.

**Removed:** Flash Cannon, Superpower, Thrash.

- **Removed machine flags:** Flash Cannon.
- **Removed family egg entries:** Superpower, Thrash.
- **Added Blackthorn lessons:** Agility, Leer, Megahorn, Tackle.

### Exeggcute

**Added:** None.

**Removed:** Magical Leaf, Rock Tomb.

- **Removed natural entries:** Magical Leaf.
- **Removed machine flags:** Rock Tomb.
- **Removed family egg entries:** Magical Leaf.

### Exeggutor

**Added:** None.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Removed family egg entries:** Magical Leaf.
- **Added Blackthorn lessons:** Magical Leaf.

### Farfetch'd

**Added:** Brick Break, Focus Blast, Hurricane.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Removed family egg entries:** Flail, Foresight, Gust, Mirror Move, Mud-Slap.
- **Added Blackthorn lessons:** Brick Break, Flail, Focus Blast, Foresight, Gust, Hurricane, Mirror Move.

### Farigiraf

**Added:** None.

**Removed:** Psycho Cut.

- **Removed natural entries:** Psycho Cut.

### Fearow

**Added:** Hurricane, Pay Day, Sonic Boom.

**Removed:** None.

- **Added Blackthorn lessons:** Hurricane, Pay Day, Sonic Boom.

### Feebas

**Added:** None.

**Removed:** Curse, Headbutt.

- **Removed machine flags:** Curse, Headbutt.

### Feraligatr

**Added:** Bubble Beam, Dark Pulse, False Swipe, Icicle Spear, Submission, Tackle.

**Removed:** Flash, Fly, Iron Head.

- **Removed machine flags:** Flash, Fly, Iron Head.
- **Added Blackthorn lessons:** Bubble Beam, Dark Pulse, False Swipe, Icicle Spear, Submission, Tackle.

### Finizen

**Added:** None.

**Removed:** Attract, Curse, Double Slap, Fake Out, Flip Turn, Headbutt, Hidden Power, Mud-Slap, Play Rough, Return, Super Fang, Swagger, Tackle, Toxic, Whirlpool.

- **Removed natural entries:** Double Slap, Flip Turn, Play Rough, Tackle, Whirlpool.
- **Removed machine flags:** Attract, Curse, Headbutt, Hidden Power, Mud-Slap, Return, Swagger, Toxic, Whirlpool.
- **Removed family egg entries:** Fake Out, Super Fang.

### Flaaffy

**Added:** None.

**Removed:** Drain Punch, Iron Head, Nuzzle.

- **Removed natural entries:** Nuzzle.
- **Removed machine flags:** Drain Punch, Iron Head.

### Flapple

**Added:** Frustration.

**Removed:** Absorb, Apple Acid, Curse, Dragon Claw, Iron Head, Mega Drain, Rock Smash, Rock Tomb, Scale Shot, Strength, Swagger, Swift, Thief, Wood Hammer.

- **Removed natural entries:** Recover, Scale Shot, Wood Hammer.
- **Removed machine flags:** Curse, Dragon Claw, Iron Head, Rock Smash, Rock Tomb, Strength, Swagger, Sweet Scent, Swift, Thief.
- **Removed family egg entries:** Dragon Tail, Giga Drain, Leech Seed.
- **Added Blackthorn lessons:** Frustration, Giga Drain.

### Flareon

**Added:** Disarming Voice, Grass Knot, Growth, Rock Slide, Smokescreen, Swords Dance, Taunt, Wild Charge.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Disarming Voice, Grass Knot, Growth, Rock Slide, Smokescreen, Swords Dance, Taunt, Wild Charge.

### Fletchinder

**Added:** Vacuum Wave, Wing Attack.

**Removed:** Curse, Headbutt, Pursuit, Sky Attack.

- **Removed machine flags:** Curse, Headbutt.
- **Removed family egg entries:** Pursuit, Sky Attack.
- **Added Blackthorn lessons:** Vacuum Wave, Wing Attack.

### Fletchling

**Added:** Flame Wheel.

**Removed:** Curse, Headbutt, Pursuit, Sky Attack.

- **Removed machine flags:** Curse, Headbutt.
- **Removed family egg entries:** Pursuit, Sky Attack.
- **Added Blackthorn lessons:** Flame Wheel.

### Flittle

**Added:** None.

**Removed:** Air Cutter, Attract, Charm, Curse, Dazzling Gleam, Flash, Future Sight, Haze, Hidden Power, Hyper Voice, Magical Leaf, Return, Shadow Ball, Swagger, Toxic.

- **Removed natural entries:** Air Cutter, Charm, Dazzling Gleam, Hyper Voice, Magical Leaf.
- **Removed machine flags:** Attract, Curse, Flash, Hidden Power, Return, Shadow Ball, Swagger, Toxic.
- **Removed family egg entries:** Future Sight, Haze, Magical Leaf.

### Flygon

**Added:** Hurricane, Hyper Voice, Quiver Dance.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Removed family egg entries:** Roost.
- **Added Blackthorn lessons:** Hurricane, Hyper Voice, Quiver Dance, Roost, U-turn.

### Forretress

**Added:** None.

**Removed:** Energy Ball, Fury Cutter.

- **Removed machine flags:** Energy Ball, Fury Cutter.

### Fraxure

**Added:** None.

**Removed:** Curse, Earthquake, Headbutt, Hyper Beam.

- **Removed machine flags:** Curse, Earthquake, Headbutt, Hyper Beam.

### Frigibax

**Added:** None.

**Removed:** Attract, Curse, Double-Edge, Earthquake, Hidden Power, Iron Head, Mist, Return, Scale Shot, Swagger, Toxic.

- **Removed natural entries:** Scale Shot.
- **Removed machine flags:** Attract, Curse, Earthquake, Hidden Power, Iron Head, Return, Swagger, Toxic.
- **Removed family egg entries:** Double-Edge, Mist.
- **Restored family egg entries:** Ice Shard.

### Froslass

**Added:** Nasty Plot, Petal Dance.

**Removed:** None.

- **Removed family egg entries:** Confuse Ray, Destiny Bond.
- **Added Blackthorn lessons:** Nasty Plot, Petal Dance.
- **Restored natural entries:** Freeze-Dry.

### Furret

**Added:** Dizzy Punch.

**Removed:** Drain Punch, Iron Head, Rock Tomb.

- **Removed machine flags:** Drain Punch, Iron Head, Rock Tomb.
- **Added Blackthorn lessons:** Dizzy Punch.

### Galarian Corsola

**Added:** Double Team, Explosion, Frustration, Heal Bell, Mud-Slap, Pain Split, Rock Polish, Rock Smash, Rollout, Strength.

**Removed:** Barrier, Energy Ball, Headbutt, Phantom Force, Waterfall.

- **Removed natural entries:** Phantom Force.
- **Removed machine flags:** Energy Ball, Headbutt, Waterfall.
- **Removed family egg entries:** Barrier.
- **Added Blackthorn lessons:** Double Team, Explosion, Frustration, Heal Bell, Mud-Slap, Pain Split, Rock Polish, Rock Smash, Rollout, Strength.

### Galarian Meowth

**Added:** Bite, Bulk Up, Close Combat, Frustration, Icy Wind, Mimic, Mud-Slap, Outrage, Roar, Spikes, Swift, Tail Whip, Thunder Wave, Torment, Water Pulse.

**Removed:** Crush Claw, Flash.

- **Removed natural entries:** Crush Claw.
- **Removed machine flags:** Flash.
- **Added Blackthorn lessons:** Bite, Bulk Up, Close Combat, Frustration, Icy Wind, Mimic, Mud-Slap, Outrage, Roar, Spikes, Swift, Tail Whip, Thunder Wave, Torment, Water Pulse.

### Galarian Ponyta

**Added:** Double Team, Flame Charge, Frustration, Heat Wave, Sunny Day.

**Removed:** Curse, Headbutt, Iron Head.

- **Removed machine flags:** Curse, Headbutt, Iron Head.
- **Added Blackthorn lessons:** Double Team, Flame Charge, Frustration, Heat Wave, Sunny Day.

### Galarian Rapidash

**Added:** Double Team, Flame Charge, Frustration, Heat Crash, Heat Wave, Overheat, Solar Beam.

**Removed:** Curse, Headbutt, Incinerate, Iron Head.

- **Removed natural entries:** Incinerate.
- **Removed machine flags:** Curse, Headbutt, Iron Head.
- **Added Blackthorn lessons:** Double Team, Flame Charge, Frustration, Heat Crash, Heat Wave, Overheat, Solar Beam.
- **Restored natural entries:** Moonblast.

### Galarian Slowbro

**Added:** Ancient Power, Aqua Tail, Dazzling Gleam, Dream Eater, Fire Punch, Frustration, Fury Cutter, Mud-Slap, Seismic Toss, Signal Beam, Skull Bash, Thunder, Thunder Punch, Thunderbolt, Toxic Spikes.

**Removed:** Flash, Iron Head, Rock Smash, Strength, Swagger.

- **Removed machine flags:** Flash, Iron Head, Rock Smash, Strength, Swagger.
- **Added Blackthorn lessons:** Ancient Power, Aqua Tail, Dazzling Gleam, Dream Eater, Fire Punch, Frustration, Fury Cutter, Mud-Slap, Seismic Toss, Signal Beam, Skull Bash, Thunder, Thunder Punch, Thunderbolt, Toxic Spikes.

### Galarian Slowking

**Added:** Ancient Power, Aqua Tail, Dream Eater, Frustration, Ice Fang, Mud-Slap, Ominous Wind, Signal Beam, Skull Bash, Thunder, Thunderbolt, Water Gun.

**Removed:** Flash, Iron Head, Psycho Cut, Recover, Rock Smash, Strength.

- **Removed natural entries:** Recover.
- **Removed machine flags:** Flash, Iron Head, Rock Smash, Strength.
- **Removed fallback lessons:** Psycho Cut.
- **Added Blackthorn lessons:** Ancient Power, Aqua Tail, Dream Eater, Frustration, Ice Fang, Mud-Slap, Ominous Wind, Signal Beam, Skull Bash, Thunder, Thunderbolt, Water Gun.

### Galarian Slowpoke

**Added:** Aqua Tail, Dream Eater, Frustration, Ice Fang, Mud-Slap, Nasty Plot, Scary Face, Signal Beam, Skull Bash, Sludge Bomb, Thunder, Thunderbolt, Water Gun.

**Removed:** Flash, Iron Head, Strength, Swagger.

- **Removed machine flags:** Flash, Iron Head, Strength, Swagger.
- **Added Blackthorn lessons:** Aqua Tail, Dream Eater, Frustration, Ice Fang, Mud-Slap, Nasty Plot, Scary Face, Signal Beam, Skull Bash, Sludge Bomb, Thunder, Thunderbolt, Water Gun.

### Galarian Weezing

**Added:** Snarl.

**Removed:** Rock Tomb, Strength.

- **Removed machine flags:** Rock Tomb, Strength.
- **Added Blackthorn lessons:** Snarl.

### Gallade

**Added:** Comet Punch, Focus Energy, Ice Beam, Razor Wind, Seismic Toss.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** Comet Punch, Focus Energy, Ice Beam, Razor Wind, Seismic Toss.
- **Restored natural entries:** Circle Throw, Force Palm.

### Galvantula

**Added:** None.

**Removed:** Curse, Sunny Day, Thunder Shock, Zap Cannon.

- **Removed natural entries:** Thunder Shock.
- **Removed machine flags:** Curse, Sunny Day, Zap Cannon.
- **Restored natural entries:** Nuzzle.

### Gardevoir

**Added:** Ice Beam, Recover.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** Ice Beam, Recover.

### Gastly

**Added:** Confusion, Shadow Sneak.

**Removed:** Phantom Force, Sludge.

- **Removed natural entries:** Sludge.
- **Removed fallback lessons:** Phantom Force.
- **Added Blackthorn lessons:** Confusion, Shadow Sneak.

### Gengar

**Added:** Confusion, Shadow Sneak.

**Removed:** Sludge.

- **Removed natural entries:** Sludge.
- **Added Blackthorn lessons:** Confusion, Shadow Sneak.

### Geodude

**Added:** Rapid Spin.

**Removed:** Drain Punch, Screech.

- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Screech.
- **Added Blackthorn lessons:** Rapid Spin.

### Girafarig

**Added:** None.

**Removed:** Iron Head, Psycho Cut.

- **Removed natural entries:** Psycho Cut.
- **Removed machine flags:** Iron Head.

### Glaceon

**Added:** Dazzling Gleam, Disarming Voice, Grass Knot, Growth, Mist, Taunt, Zap Cannon.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Dazzling Gleam, Disarming Voice, Grass Knot, Growth, Mist, Taunt, Zap Cannon.

### Gligar

**Added:** Bug Buzz.

**Removed:** Bounce, Iron Head.

- **Removed natural entries:** Bounce.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Bug Buzz.
- **Restored natural entries:** Drill Run.

### Glimmet

**Added:** None.

**Removed:** Attract, Curse, Earth Power, Hidden Power, Mortal Spin, Return, Rock Smash, Swagger.

- **Removed natural entries:** Earth Power.
- **Removed machine flags:** Attract, Curse, Hidden Power, Return, Rock Smash, Swagger.
- **Removed family egg entries:** Earth Power, Mortal Spin.

### Glimmora

**Added:** None.

**Removed:** Attract, Curse, Hidden Power, Return, Rock Smash, Swagger.

- **Removed machine flags:** Attract, Curse, Hidden Power, Return, Rock Smash, Swagger.
- **Removed family egg entries:** Earth Power, Mortal Spin.
- **Added Blackthorn lessons:** Earth Power.
- **Restored Blackthorn lessons:** Head Smash.

### Gliscor

**Added:** Bug Buzz, Pin Missile.

**Removed:** Bounce, Iron Head.

- **Removed natural entries:** Bounce.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Bug Buzz, Pin Missile.
- **Restored natural entries:** Drill Run.

### Gloom

**Added:** None.

**Removed:** None.


### Golbat

**Added:** Flail, Hurricane, Sky Attack, X-Scissor.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.
- **Added Blackthorn lessons:** Flail, Hurricane, Sky Attack, X-Scissor.
- **Restored natural entries:** Poison Jab.

### Goldeen

**Added:** Thunderbolt.

**Removed:** None.

- **Added Blackthorn lessons:** Thunderbolt.

### Golduck

**Added:** Dazzling Gleam, Petal Dance, Tri Attack.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Dazzling Gleam, Petal Dance, Tri Attack.

### Golem

**Added:** Rapid Spin, Spikes, Wild Charge.

**Removed:** Drain Punch, Screech.

- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Screech.
- **Added Blackthorn lessons:** Rapid Spin, Spikes, Wild Charge.
- **Restored natural entries:** Head Smash.

### Golett

**Added:** Comet Punch, Harden, Headlong Rush, Iron Head, Tackle.

**Removed:** None.

- **Added Blackthorn lessons:** Comet Punch, Harden, Headlong Rush, Iron Head, Tackle.
- **Restored machine flags:** Will-O-Wisp.

### Golisopod

**Added:** Agility, Cut, Gunk Shot, Night Slash, Stone Edge, U-turn.

**Removed:** Bubble, Curse, Low Sweep, Strength, Whirlpool.

- **Removed natural entries:** Low Sweep.
- **Removed machine flags:** Curse, Strength, Whirlpool.
- **Added Blackthorn lessons:** Agility, Cut, Gunk Shot, Night Slash, Stone Edge, U-turn.

### Golurk

**Added:** Comet Punch, Fissure, Harden, Headlong Rush, Iron Head, Skull Bash, Tackle.

**Removed:** None.

- **Added Blackthorn lessons:** Comet Punch, Fissure, Harden, Headlong Rush, Iron Head, Skull Bash, Tackle.
- **Restored machine flags:** Will-O-Wisp.

### Gorochu

**Added:** Dazzling Gleam, Dizzy Punch, Ice Punch, Petal Dance, Psychic, Scary Face.

**Removed:** None.

- **Added Blackthorn lessons:** Body Slam, Brick Break, Calm Mind, Counter, Defense Curl, Detect, Double-Edge, Draining Kiss, Dynamic Punch, Frustration, Giga Impact, Grass Knot, Hyper Voice, Mega Kick, Mega Punch, Mimic, Pay Day, Play Rough, Rage, Rollout, Safeguard, Seismic Toss, Sing, Skull Bash, Snore, Submission, Sweet Scent, Take Down, Yawn.

### Gorotora

**Added:** None.

**Removed:** None.


### Granbull

**Added:** None.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.

### Graveler

**Added:** Rapid Spin.

**Removed:** Drain Punch, Screech.

- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Screech.
- **Added Blackthorn lessons:** Rapid Spin.

### Grimer

**Added:** None.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.

### Grimmsnarl

**Added:** Frustration.

**Removed:** Circle Throw, Curse, Disarming Voice, Encore, Force Palm, Strength, Sweet Kiss.

- **Removed natural entries:** Circle Throw, Force Palm.
- **Removed machine flags:** Curse, Strength.
- **Removed family egg entries:** Encore.
- **Added Blackthorn lessons:** Frustration.
- **Restored machine flags:** Knock Off, Night Slash.

### Growlithe

**Added:** None.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.

### Grubbin

**Added:** None.

**Removed:** Agility, Curse, Fury Cutter, Nuzzle.

- **Removed natural entries:** Nuzzle.
- **Removed machine flags:** Curse, Fury Cutter.
- **Removed family egg entries:** Agility.
- **Restored natural entries:** Signal Beam.

### Grumpig

**Added:** Hypnosis, Ominous Wind, Pay Day, Shadow Punch, Will-O-Wisp.

**Removed:** Curse, Slack Off, Thunderbolt.

- **Removed natural entries:** Slack Off.
- **Removed machine flags:** Curse.
- **Removed fallback lessons:** Thunderbolt.
- **Added Blackthorn lessons:** Hypnosis, Ominous Wind, Pay Day, Shadow Punch, Will-O-Wisp.

### Gurdurr

**Added:** Rock Blast.

**Removed:** None.

- **Added Blackthorn lessons:** Rock Blast.
- **Restored natural entries:** Body Press.

### Gyarados

**Added:** Bubble, Focus Energy, Reversal.

**Removed:** None.

- **Added Blackthorn lessons:** Bubble, Focus Energy, Reversal.

### Happiny

**Added:** Calm Mind, Double-Edge, Draining Kiss, Fairy Wind, Soft-Boiled, Zap Cannon.

**Removed:** Blizzard, Curse, Encore, Ice Beam, Rock Tomb, Swift, Wish.

- **Removed machine flags:** Blizzard, Curse, Ice Beam, Rock Tomb, Swift.
- **Removed family egg entries:** Encore, Wish.
- **Added Blackthorn lessons:** Calm Mind, Double-Edge, Draining Kiss, Fairy Wind, Soft-Boiled, Zap Cannon.

### Haunter

**Added:** Confusion, Shadow Sneak.

**Removed:** Sludge.

- **Removed natural entries:** Sludge.
- **Added Blackthorn lessons:** Confusion, Shadow Sneak.

### Haxorus

**Added:** None.

**Removed:** Curse, Headbutt.

- **Removed machine flags:** Curse, Headbutt.

### Heracross

**Added:** Calm Mind, Mud Shot, Outrage, Skull Bash, Slash.

**Removed:** Feint Attack, Low Sweep.

- **Removed natural entries:** Low Sweep.
- **Removed family egg entries:** Feint Attack.
- **Added Blackthorn lessons:** Calm Mind, Mud Shot, Outrage, Skull Bash, Slash.
- **Restored natural entries:** Hammer Arm, Superpower.

### Hisuian Arcanine

**Added:** Ancient Power, Double Team, Flash Cannon, Frustration, Iron Tail, Mud-Slap, Snore.

**Removed:** Crush Claw, Curse, Incinerate.

- **Removed natural entries:** Crush Claw.
- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** Ancient Power, Double Team, Flash Cannon, Frustration, Iron Tail, Mud-Slap, Snore.
- **Restored machine flags:** Headbutt.

### Hisuian Electrode

**Added:** Attract, Bug Buzz, Frustration, Safeguard, Snore, Sucker Punch, Torment.

**Removed:** Headbutt, Rock Tomb, Sunny Day.

- **Removed machine flags:** Headbutt, Rock Tomb, Sunny Day.
- **Added Blackthorn lessons:** Attract, Bug Buzz, Frustration, Safeguard, Snore, Sucker Punch, Torment.

### Hisuian Growlithe

**Added:** Aerial Ace, Ancient Power, Bulldoze, Double Team, Flash Cannon, Frustration, Iron Tail, Mud-Slap, Snarl, Snore.

**Removed:** Curse, Incinerate, Iron Head.

- **Removed natural entries:** Incinerate.
- **Removed machine flags:** Curse, Iron Head.
- **Added Blackthorn lessons:** Aerial Ace, Ancient Power, Bulldoze, Double Team, Flash Cannon, Frustration, Iron Tail, Mud-Slap, Snarl, Snore.
- **Restored machine flags:** Headbutt.

### Hisuian Sneasel

**Added:** Bulldoze, Crush Claw, Dark Pulse, Foresight, Frustration, Fury Cutter, Hail, Iron Tail, Knock Off, Mud-Slap, Psych Up, Seismic Toss, Snore, Sucker Punch, Superpower, Thunder Punch, Torment.

**Removed:** Curse, Headbutt, Iron Head, Surf, Whirlpool.

- **Removed machine flags:** Curse, Headbutt, Iron Head, Surf, Whirlpool.
- **Added Blackthorn lessons:** Bulldoze, Crush Claw, Dark Pulse, Foresight, Frustration, Fury Cutter, Hail, Iron Tail, Knock Off, Mud-Slap, Psych Up, Seismic Toss, Snore, Sucker Punch, Superpower, Thunder Punch, Torment.
- **Restored family egg entries:** Pursuit.

### Hisuian Typhlosion

**Added:** Seismic Toss, Thunderbolt.

**Removed:** Raging Fury.

- **Removed natural entries:** Raging Fury.
- **Added Blackthorn lessons:** Seismic Toss, Thunderbolt.
- **Restored natural entries:** Phantom Force.

### Hisuian Voltorb

**Added:** Attract, Bug Buzz, Frustration, Safeguard, Scary Face, Signal Beam, Snore, Sucker Punch, Synthesis.

**Removed:** Curse, Headbutt, Rock Tomb, Sunny Day.

- **Removed machine flags:** Curse, Headbutt, Rock Tomb, Sunny Day.
- **Added Blackthorn lessons:** Attract, Bug Buzz, Frustration, Safeguard, Scary Face, Signal Beam, Snore, Sucker Punch, Synthesis.

### Hitmonchan

**Added:** None.

**Removed:** None.

- **Restored natural entries:** Force Palm, Hammer Arm.

### Hitmonlee

**Added:** Dizzy Punch.

**Removed:** Circle Throw.

- **Removed natural entries:** Circle Throw.
- **Added Blackthorn lessons:** Dizzy Punch.
- **Restored machine flags:** Drain Punch.

### Hitmontop

**Added:** Dizzy Punch, Rage.

**Removed:** None.

- **Added Blackthorn lessons:** Dizzy Punch, Rage.
- **Restored natural entries:** Body Press, Circle Throw.

### Ho-Oh

**Added:** None.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.

### Honchkrow

**Added:** Beat Up, Drill Run.

**Removed:** Strength.

- **Removed machine flags:** Strength.
- **Added Blackthorn lessons:** Beat Up, Drill Run.
- **Restored machine flags:** Knock Off.

### Hoothoot

**Added:** None.

**Removed:** None.


### Hoppip

**Added:** Agility, Air Cutter.

**Removed:** None.

- **Added Blackthorn lessons:** Agility, Air Cutter.

### Horsea

**Added:** None.

**Removed:** Dragon Tail.

- **Removed natural entries:** Dragon Tail.

### Houndoom

**Added:** Tackle.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Tackle.
- **Restored natural entries:** Raging Fury.

### Houndour

**Added:** Tackle.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Tackle.

### Hydrapple

**Added:** None.

**Removed:** Absorb, Apple Acid, Dragon Claw, Hidden Power, Iron Head, Leech Seed, Mega Drain, Return, Rock Smash, Rock Tomb, Scale Shot, Swagger, Thief, Toxic, Twister, Wood Hammer.

- **Removed natural entries:** Apple Acid, Scale Shot.
- **Removed machine flags:** Dragon Claw, Hidden Power, Iron Head, Return, Rock Smash, Rock Tomb, Swagger, Thief, Toxic.
- **Removed family egg entries:** Dragon Tail, Giga Drain, Leech Seed.
- **Removed fallback lessons:** Wood Hammer.
- **Added Blackthorn lessons:** Giga Drain.

### Hydreigon

**Added:** None.

**Removed:** Curse, Knock Off.

- **Removed machine flags:** Curse, Knock Off.
- **Restored natural entries:** Foul Play.
- **Restored machine flags:** Dragon Claw, Night Slash.

### Hypno

**Added:** Amnesia.

**Removed:** None.

- **Added Blackthorn lessons:** Amnesia.

### Igglybuff

**Added:** Brick Break, Calm Mind, Confusion, Dizzy Punch, Energy Ball, Nasty Plot, Petal Dance, Psyshock, Scary Face, Stealth Rock, Tackle, Taunt, Zen Headbutt.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Added Blackthorn lessons:** Brick Break, Calm Mind, Confusion, Dizzy Punch, Energy Ball, Nasty Plot, Petal Dance, Psyshock, Scary Face, Stealth Rock, Tackle, Taunt, Zen Headbutt.

### Impidimp

**Added:** Frustration.

**Removed:** Curse, Disarming Voice, Encore, Fire Punch, Ice Punch, Low Sweep, Sweet Kiss, Thunder Punch.

- **Removed natural entries:** Disarming Voice, Encore, Low Sweep, Sweet Kiss.
- **Removed machine flags:** Curse, Fire Punch, Ice Punch, Thunder Punch.
- **Removed family egg entries:** Encore.
- **Added Blackthorn lessons:** Frustration.
- **Restored natural entries:** Charm, Mean Look, Snarl.
- **Restored machine flags:** Knock Off.
- **Restored family egg entries:** Charm, Mean Look.

### Ivysaur

**Added:** Ancient Power.

**Removed:** None.

- **Added Blackthorn lessons:** Ancient Power.

### Ivysaur (Clone)

**Added:** Ancient Power.

**Removed:** None.

- **Added Blackthorn lessons:** Ancient Power.

### Jigglypuff

**Added:** Confusion, Dizzy Punch, Fake Out, Petal Dance, Scary Face, Tackle.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Added Blackthorn lessons:** Confusion, Dizzy Punch, Fake Out, Petal Dance, Scary Face, Tackle.

### Jirachi

**Added:** None.

**Removed:** None.


### Jolteon

**Added:** Disarming Voice, Grass Knot, Growth.

**Removed:** Iron Head, Nuzzle.

- **Removed natural entries:** Nuzzle.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Disarming Voice, Grass Knot, Growth.

### Joltik

**Added:** None.

**Removed:** Curse, Sunny Day, Thunder Shock, Zap Cannon.

- **Removed natural entries:** Thunder Shock.
- **Removed machine flags:** Curse, Sunny Day, Zap Cannon.
- **Restored natural entries:** Nuzzle, Spark.
- **Restored family egg entries:** Sticky Web.

### Jumpluff

**Added:** Agility, Air Cutter, Fly, Hurricane.

**Removed:** None.

- **Added Blackthorn lessons:** Agility, Air Cutter, Fly, Hurricane.

### Jynx

**Added:** Dazzling Gleam, Dizzy Punch, Petal Dance.

**Removed:** None.

- **Removed family egg entries:** Lovely Kiss.
- **Added Blackthorn lessons:** Dazzling Gleam, Dizzy Punch, Petal Dance.

### Kabuto

**Added:** None.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.

### Kabutops

**Added:** None.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.

### Kadabra

**Added:** Foresight, Hypnosis.

**Removed:** None.

- **Added Blackthorn lessons:** Foresight, Hypnosis.

### Kakuna

**Added:** Facade.

**Removed:** None.

- **Added Blackthorn lessons:** Facade.

### Kangaskhan

**Added:** Feint Attack, Tackle.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Feint Attack, Tackle.

### Kingambit

**Added:** None.

**Removed:** Body Press, Curse, Earthquake, Focus Energy, Hammer Arm, Strength.

- **Removed natural entries:** Body Press, Hammer Arm.
- **Removed machine flags:** Curse, Earthquake, Strength.
- **Removed family egg entries:** Focus Energy.
- **Restored natural entries:** Sacred Sword.

### Kingdra

**Added:** None.

**Removed:** Dragon Tail.

- **Removed natural entries:** Dragon Tail.

### Kingler

**Added:** Shadow Claw, Waterfall.

**Removed:** None.

- **Added Blackthorn lessons:** Shadow Claw, Waterfall.

### Kirlia

**Added:** Ice Beam, Vacuum Wave.

**Removed:** Curse, Energy Ball.

- **Removed machine flags:** Curse, Energy Ball.
- **Added Blackthorn lessons:** Ice Beam, Vacuum Wave.

### Kleavor

**Added:** Ancient Power, Calm Mind, Sonic Boom.

**Removed:** Low Sweep, Power Gem, Rock Polish, Sacred Sword, Work Up.

- **Removed natural entries:** Low Sweep, Rock Polish, Sacred Sword.
- **Removed machine flags:** Power Gem, Work Up.
- **Added Blackthorn lessons:** Ancient Power, Calm Mind, Sonic Boom.

### Koffing

**Added:** Snarl, Strange Steam.

**Removed:** Fairy Wind, Rock Tomb.

- **Removed natural entries:** Fairy Wind.
- **Removed machine flags:** Rock Tomb.
- **Added Blackthorn lessons:** Snarl, Strange Steam.

### Kotora

**Added:** None.

**Removed:** None.


### Krabby

**Added:** Shadow Claw, Waterfall.

**Removed:** None.

- **Added Blackthorn lessons:** Shadow Claw, Waterfall.

### Krokorok

**Added:** Tackle.

**Removed:** Scratch, Swift, Work Up.

- **Removed natural entries:** Scratch.
- **Removed machine flags:** Swift, Work Up.
- **Added Blackthorn lessons:** Tackle.
- **Restored machine flags:** Night Slash.

### Krookodile

**Added:** Fissure, Iron Head, Tackle.

**Removed:** Scratch, Swift, Work Up.

- **Removed natural entries:** Scratch.
- **Removed machine flags:** Swift, Work Up.
- **Added Blackthorn lessons:** Fissure, Iron Head, Tackle.
- **Restored machine flags:** Night Slash.

### Lairon

**Added:** False Swipe, Mud Shot.

**Removed:** Fire Blast, Fire Punch, Flash Cannon, Ice Beam, Ice Punch, Power Gem, Thunder Punch, Thunderbolt.

- **Removed machine flags:** Fire Blast, Fire Punch, Flash Cannon, Ice Beam, Ice Punch, Power Gem, Thunder Punch, Thunderbolt.
- **Added Blackthorn lessons:** False Swipe, Mud Shot.

### Lampent

**Added:** Ominous Wind, Smokescreen.

**Removed:** Hyper Beam, Phantom Force, Swift.

- **Removed machine flags:** Hyper Beam, Swift.
- **Removed fallback lessons:** Phantom Force.
- **Added Blackthorn lessons:** Ominous Wind, Smokescreen.

### Lanturn

**Added:** Light Screen.

**Removed:** Flash Cannon, Nuzzle.

- **Removed natural entries:** Nuzzle.
- **Removed fallback lessons:** Flash Cannon.
- **Added Blackthorn lessons:** Light Screen.
- **Restored natural entries:** Tail Glow.

### Lapras

**Added:** Bite.

**Removed:** None.

- **Added Blackthorn lessons:** Bite.

### Larvesta

**Added:** None.

**Removed:** Curse, Energy Ball, Fiery Dance, Fury Cutter, Quiver Dance.

- **Removed machine flags:** Curse, Energy Ball, Fury Cutter.
- **Removed fallback lessons:** Fiery Dance, Quiver Dance.

### Larvitar

**Added:** Rage.

**Removed:** None.

- **Added Blackthorn lessons:** Rage.

### Leafeon

**Added:** Cut, Disarming Voice, Growth, Night Slash, Petal Dance, Psycho Cut, Taunt, Zap Cannon.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Cut, Disarming Voice, Growth, Night Slash, Petal Dance, Psycho Cut, Taunt, Zap Cannon.

### Ledian

**Added:** Barrier, Fly.

**Removed:** Energy Ball, Quiver Dance, Rock Tomb, Signal Beam.

- **Removed machine flags:** Energy Ball, Rock Tomb.
- **Removed fallback lessons:** Quiver Dance, Signal Beam.
- **Added Blackthorn lessons:** Barrier, Fly.
- **Restored machine flags:** Fury Cutter.

### Ledyba

**Added:** Barrier, Dual Wingbeat.

**Removed:** Energy Ball, Rock Tomb.

- **Removed machine flags:** Energy Ball, Rock Tomb.
- **Added Blackthorn lessons:** Barrier, Dual Wingbeat.
- **Restored machine flags:** Fury Cutter.

### Lickilicky

**Added:** Double Slap, Tackle.

**Removed:** Drain Punch, Iron Head, Swift.

- **Removed machine flags:** Drain Punch, Iron Head, Swift.
- **Added Blackthorn lessons:** Double Slap, Tackle.

### Lickitung

**Added:** Double Slap, Tackle.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Double Slap, Tackle.

### Lileep

**Added:** None.

**Removed:** Earthquake, Rock Smash.

- **Removed machine flags:** Earthquake, Rock Smash.
- **Restored machine flags:** Power Gem.
- **Restored family egg entries:** Leech Seed, Stun Spore.

### Litwick

**Added:** Smokescreen.

**Removed:** Phantom Force, Swift.

- **Removed machine flags:** Swift.
- **Removed fallback lessons:** Phantom Force.
- **Added Blackthorn lessons:** Smokescreen.

### Lombre

**Added:** None.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Removed family egg entries:** Fake Out.

### Lopunny

**Added:** Comet Punch, Cotton Guard, Double-Edge, Draining Kiss, Dynamic Punch, Mach Punch, Seismic Toss, Swords Dance, Tackle.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** Comet Punch, Cotton Guard, Double-Edge, Draining Kiss, Dynamic Punch, Mach Punch, Seismic Toss, Swords Dance, Tackle.
- **Restored natural entries:** Brick Break.
- **Restored machine flags:** Bulk Up.

### Lotad

**Added:** None.

**Removed:** Curse, Fake Out, Waterfall.

- **Removed machine flags:** Curse, Waterfall.
- **Removed family egg entries:** Fake Out.

### Lucario

**Added:** Mach Punch, Seismic Toss.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** Mach Punch, Seismic Toss.
- **Restored natural entries:** Sacred Sword.
- **Restored machine flags:** Iron Head.

### Ludicolo

**Added:** None.

**Removed:** Curse, Wood Hammer.

- **Removed natural entries:** Wood Hammer.
- **Removed machine flags:** Curse.
- **Removed family egg entries:** Fake Out.

### Lugia

**Added:** None.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.

### Machamp

**Added:** Comet Punch, False Swipe, Mach Punch, Tackle, Thrash.

**Removed:** Body Press.

- **Removed natural entries:** Body Press.
- **Added Blackthorn lessons:** Comet Punch, False Swipe, Mach Punch, Tackle, Thrash.
- **Restored natural entries:** Circle Throw, Force Palm, Hammer Arm.

### Machoke

**Added:** Comet Punch, False Swipe, Mach Punch, Tackle, Thrash.

**Removed:** None.

- **Added Blackthorn lessons:** Comet Punch, False Swipe, Mach Punch, Tackle, Thrash.
- **Restored natural entries:** Circle Throw, Force Palm.

### Machop

**Added:** Comet Punch, False Swipe, Mach Punch, Tackle, Thrash.

**Removed:** None.

- **Added Blackthorn lessons:** Comet Punch, False Swipe, Mach Punch, Tackle, Thrash.
- **Restored natural entries:** Force Palm.

### Magby

**Added:** Dark Pulse, Dizzy Punch, Poison Gas, Scald, Tackle.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Dark Pulse, Dizzy Punch, Poison Gas, Scald, Tackle.

### Magcargo

**Added:** None.

**Removed:** None.


### Magikarp

**Added:** Bubble, Dragon Rage, Facade, Reversal.

**Removed:** None.

- **Added Blackthorn lessons:** Bubble, Dragon Rage, Facade, Reversal.

### Magmar

**Added:** Dark Pulse, Dizzy Punch, Poison Gas, Scald, Tackle.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Dark Pulse, Dizzy Punch, Poison Gas, Scald, Tackle.

### Magmortar

**Added:** Armor Cannon, Dizzy Punch, Dragon Pulse, Poison Gas, Scald, Tackle, Zap Cannon.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Armor Cannon, Dizzy Punch, Dragon Pulse, Poison Gas, Scald, Tackle, Zap Cannon.
- **Restored natural entries:** Raging Fury.

### Magnemite

**Added:** Agility, Bug Buzz.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Added Blackthorn lessons:** Agility, Bug Buzz.
- **Restored family egg entries:** Mirror Coat.

### Magneton

**Added:** Agility, Bug Buzz.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Added Blackthorn lessons:** Agility, Bug Buzz.

### Magnezone

**Added:** Agility, Bug Buzz.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Added Blackthorn lessons:** Agility, Bug Buzz.

### Mamoswine

**Added:** Whirlwind.

**Removed:** None.

- **Added Blackthorn lessons:** Whirlwind.

### Mankey

**Added:** Circle Throw, Comet Punch, Knock Off, Roar, Rock Throw, Tackle, Torment.

**Removed:** Iron Head, Rage Fist.

- **Removed natural entries:** Rage Fist.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Circle Throw, Comet Punch, Knock Off, Roar, Rock Throw, Tackle, Torment.

### Mantine

**Added:** U-turn.

**Removed:** Aqua Jet.

- **Removed natural entries:** Aqua Jet.
- **Removed family egg entries:** Gunk Shot.
- **Added Blackthorn lessons:** Gunk Shot, Gust, U-turn.

### Mantyke

**Added:** Double-Edge, U-turn.

**Removed:** Aqua Jet, Curse, Fly, Gunk Shot, Gust.

- **Removed natural entries:** Aqua Jet, Gust.
- **Removed machine flags:** Curse, Fly.
- **Removed family egg entries:** Gunk Shot.
- **Added Blackthorn lessons:** Double-Edge, U-turn.

### Mareanie

**Added:** None.

**Removed:** Curse, Sludge, Waterfall, Whirlpool.

- **Removed machine flags:** Curse, Waterfall, Whirlpool.
- **Removed family egg entries:** Sludge.
- **Restored natural entries:** Baneful Bunker, Cross Poison.
- **Restored family egg entries:** Spikes.

### Mareep

**Added:** None.

**Removed:** Iron Head, Nuzzle.

- **Removed natural entries:** Nuzzle.
- **Removed machine flags:** Iron Head.

### Marill

**Added:** Dizzy Punch, Scary Face.

**Removed:** Calm Mind, Drain Punch, Growl, Iron Head, Rock Tomb.

- **Removed machine flags:** Drain Punch, Iron Head, Rock Tomb.
- **Removed family egg entries:** Amnesia, Calm Mind, Future Sight, Superpower.
- **Added Blackthorn lessons:** Amnesia, Dizzy Punch, Future Sight, Scary Face.

### Marowak

**Added:** Fury Attack, Tackle.

**Removed:** Drain Punch, Drill Run, Mud Shot.

- **Removed natural entries:** Drill Run, Mud Shot.
- **Removed machine flags:** Drain Punch.
- **Added Blackthorn lessons:** Fury Attack, Tackle.

### Mawile

**Added:** Charm, Dazzling Gleam.

**Removed:** Curse, Cut, Dig, Disable, Drain Punch, Fire Punch, Fury Cutter, Hammer Arm, Metal Claw, Steel Wing, Tail Whip, Thief.

- **Removed natural entries:** Fury Cutter, Hammer Arm, Metal Claw, Tail Whip.
- **Removed machine flags:** Curse, Cut, Dig, Drain Punch, Fire Punch, Steel Wing, Thief.
- **Removed family egg entries:** Disable.
- **Added Blackthorn lessons:** Charm, Dazzling Gleam.

### Meganium

**Added:** Dazzling Gleam, Disarming Voice, Leaf Blade, Play Rough, Tail Whip.

**Removed:** Iron Head, Mega Drain.

- **Removed natural entries:** Mega Drain.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Dazzling Gleam, Disarming Voice, Leaf Blade, Play Rough, Tail Whip.
- **Restored natural entries:** Wood Hammer.

### Meowth

**Added:** Metronome, Spikes, Swords Dance.

**Removed:** Crush Claw, Iron Head.

- **Removed natural entries:** Crush Claw.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Metronome, Spikes, Swords Dance.

### Mesmeria

**Added:** Dazzling Gleam, Dizzy Punch, Petal Dance.

**Removed:** None.

- **Removed family egg entries:** Lovely Kiss.
- **Added Blackthorn lessons:** Bide, Body Slam, Brick Break, Bubble Beam, Charm, Counter, Double Team, Double-Edge, Dynamic Punch, Endure, Frustration, Giga Impact, Grass Knot, Hail, Heal Bell, Hyper Voice, Icicle Spear, Mega Kick, Mega Punch, Metronome, Mimic, Nightmare, Psycho Cut, Psywave, Rage, Recycle, Screech, Seismic Toss, Skull Bash, Snore, Submission, Take Down, Taunt, Teleport, Thrash, Torment, Triple Axel, Water Gun, Water Pulse.

### Metapod

**Added:** None.

**Removed:** None.


### Mew

**Added:** None.

**Removed:** None.


### Mewtwo

**Added:** Comet Punch, Discharge, Vacuum Wave.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Comet Punch, Discharge, Vacuum Wave.

### Milotic

**Added:** Dazzling Gleam, Liquidation.

**Removed:** Curse, Headbutt.

- **Removed machine flags:** Curse, Headbutt.
- **Added Blackthorn lessons:** Dazzling Gleam, Liquidation.

### Miltank

**Added:** None.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.

### Mime Jr.

**Added:** Energy Ball, First Impression, Haze, Iron Defense, Mist, Seismic Toss, Smokescreen, Stealth Rock, Zap Cannon.

**Removed:** Curse, Metronome, Rock Smash.

- **Removed natural entries:** Metronome.
- **Removed machine flags:** Curse, Rock Smash.
- **Added Blackthorn lessons:** Energy Ball, First Impression, Haze, Iron Defense, Mist, Seismic Toss, Smokescreen, Stealth Rock, Zap Cannon.

### Mimikyu

**Added:** Tackle.

**Removed:** Flash, Headbutt, Snarl, Strength.

- **Removed natural entries:** Snarl.
- **Removed machine flags:** Flash, Headbutt, Strength.
- **Added Blackthorn lessons:** Tackle.
- **Restored natural entries:** Foul Play.
- **Restored family egg entries:** Sucker Punch.

### Misdreavus

**Added:** Extrasensory.

**Removed:** None.

- **Added Blackthorn lessons:** Extrasensory.
- **Restored natural entries:** Fairy Wind.

### Mismagius

**Added:** Extrasensory.

**Removed:** None.

- **Added Blackthorn lessons:** Extrasensory.
- **Restored natural entries:** Fairy Wind.

### Moltres

**Added:** None.

**Removed:** None.


### Morgrem

**Added:** Frustration.

**Removed:** Curse, Disarming Voice, Encore, Fire Punch, Ice Punch, Low Sweep, Sweet Kiss, Thunder Punch.

- **Removed natural entries:** Disarming Voice, Low Sweep, Sweet Kiss.
- **Removed machine flags:** Curse, Fire Punch, Ice Punch, Thunder Punch.
- **Removed family egg entries:** Encore.
- **Added Blackthorn lessons:** Frustration.
- **Restored natural entries:** Snarl.
- **Restored machine flags:** Knock Off.

### Mr. Mime

**Added:** Comet Punch, First Impression, Haze, Mind Reader, Mist, Play Rough, Smokescreen, Stealth Rock, Triple Axel.

**Removed:** Psycho Cut, Rock Smash.

- **Removed machine flags:** Rock Smash.
- **Removed fallback lessons:** Psycho Cut.
- **Added Blackthorn lessons:** Comet Punch, First Impression, Haze, Metronome, Mind Reader, Mist, Play Rough, Smokescreen, Stealth Rock, Triple Axel.

### Mr. Rime

**Added:** Comet Punch, First Impression, Haze, Mind Reader, Mist, Play Rough, Smokescreen, Stealth Rock.

**Removed:** Psycho Cut, Rock Smash.

- **Removed machine flags:** Curse, Rock Smash.
- **Removed fallback lessons:** Psycho Cut.
- **Added Blackthorn lessons:** Aerial Ace, Comet Punch, First Impression, Haze, Metronome, Mist, Seismic Toss, Smokescreen, Stealth Rock.

### Muk

**Added:** None.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.
- **Restored natural entries:** Cross Poison.

### Munchlax

**Added:** Seismic Toss, Zap Cannon.

**Removed:** Drain Punch, Slack Off, Swift.

- **Removed natural entries:** Slack Off.
- **Removed machine flags:** Drain Punch, Swift.
- **Added Blackthorn lessons:** Seismic Toss, Zap Cannon.

### Murkrow

**Added:** Beat Up, Drill Run.

**Removed:** None.

- **Added Blackthorn lessons:** Beat Up, Drill Run.

### Natu

**Added:** Safeguard.

**Removed:** Energy Ball, Psycho Cut.

- **Removed natural entries:** Psycho Cut.
- **Removed machine flags:** Energy Ball.
- **Added Blackthorn lessons:** Safeguard.

### Nidoking

**Added:** Lovely Kiss, Morning Sun, Sweet Kiss.

**Removed:** Cross Poison, Drain Punch, Iron Head.

- **Removed natural entries:** Cross Poison.
- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Lovely Kiss, Morning Sun, Sweet Kiss.

### Nidoqueen

**Added:** Lovely Kiss, Moonlight, Sweet Kiss.

**Removed:** Cross Poison, Drain Punch, Iron Head.

- **Removed natural entries:** Cross Poison.
- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Lovely Kiss, Moonlight, Sweet Kiss.

### Nidoran♀

**Added:** Lovely Kiss, Moonlight, Sweet Kiss.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Lovely Kiss, Moonlight, Sweet Kiss.

### Nidoran♂

**Added:** Lovely Kiss, Morning Sun, Sweet Kiss.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Lovely Kiss, Morning Sun, Sweet Kiss.

### Nidorina

**Added:** Lovely Kiss, Moonlight, Sweet Kiss.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Lovely Kiss, Moonlight, Sweet Kiss.

### Nidorino

**Added:** Lovely Kiss, Morning Sun, Sweet Kiss.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Lovely Kiss, Morning Sun, Sweet Kiss.

### Ninetales

**Added:** Flame Wheel, Heal Bell, Psychic.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Flame Wheel, Heal Bell, Psychic.

### Noctowl

**Added:** None.

**Removed:** None.


### Noibat

**Added:** None.

**Removed:** Astonish, Curse, Dragon Tail, Flamethrower, Flash, Scale Shot.

- **Removed natural entries:** Astonish, Dragon Tail, Scale Shot.
- **Removed machine flags:** Curse, Flamethrower, Flash.

### Noivern

**Added:** None.

**Removed:** Astonish, Curse, Flash, Roar.

- **Removed natural entries:** Astonish.
- **Removed machine flags:** Curse, Flash, Roar.

### Numel

**Added:** None.

**Removed:** None.


### Octillery

**Added:** Amnesia, Bubble, Mist.

**Removed:** None.

- **Added Blackthorn lessons:** Amnesia, Bubble, Mist.

### Oddish

**Added:** None.

**Removed:** None.


### Omanyte

**Added:** None.

**Removed:** None.


### Omastar

**Added:** None.

**Removed:** None.


### Onix

**Added:** Sharpen.

**Removed:** Mud Shot.

- **Removed natural entries:** Mud Shot.
- **Added Blackthorn lessons:** Sharpen.
- **Restored natural entries:** Iron Defense.

### Overqwil

**Added:** Mortal Spin, Rock Slide.

**Removed:** Rock Tomb, Strength, Thief.

- **Removed machine flags:** Headbutt, Rock Tomb, Strength, Thief, Whirlpool.
- **Added Blackthorn lessons:** Bounce, Double Team, Frustration, Hail, Mortal Spin, Rock Slide, Scald, Snore.
- **Restored natural entries:** Cross Poison.
- **Restored machine flags:** Knock Off.

### Palafin

**Added:** None.

**Removed:** Attract, Circle Throw, Curse, Dig, Double Slap, Earthquake, Fake Out, Fire Punch, Force Palm, Hammer Arm, Headbutt, Hidden Power, Low Sweep, Mud-Slap, Play Rough, Return, Rock Smash, Strength, Super Fang, Swagger, Tackle, Thief, Thunder Punch, Toxic, Work Up.

- **Removed natural entries:** Circle Throw, Force Palm, Hammer Arm, Low Sweep, Tackle, Work Up.
- **Removed machine flags:** Attract, Curse, Dig, Earthquake, Fire Punch, Headbutt, Hidden Power, Mud-Slap, Return, Rock Smash, Strength, Swagger, Thief, Thunder Punch, Toxic, Work Up.
- **Removed family egg entries:** Fake Out, Super Fang.
- **Restored natural entries:** Brick Break, Cross Chop, Mach Punch, Superpower.

### Paldean Aqua Tauros

**Added:** Aerial Ace, Avalanche, Bullet Seed, Frustration, Iron Tail, Light Screen, Low Sweep, Reflect, Scald, Taunt.

**Removed:** Attract, Blizzard, Drain Punch, Ice Beam.

- **Removed machine flags:** Attract, Blizzard, Drain Punch, Ice Beam.
- **Added Blackthorn lessons:** Aerial Ace, Avalanche, Bullet Seed, Frustration, Iron Tail, Light Screen, Low Sweep, Reflect, Scald, Taunt.
- **Restored natural entries:** Horn Attack.
- **Restored family egg entries:** Horn Attack.

### Paldean Blaze Tauros

**Added:** Aerial Ace, Bullet Seed, Frustration, Heat Crash, Iron Tail, Light Screen, Low Sweep, Reflect, Taunt.

**Removed:** Aqua Jet, Attract, Drain Punch, Heat Wave, Hidden Power, Horn Attack, Solar Beam.

- **Removed natural entries:** Horn Attack.
- **Removed machine flags:** Attract, Drain Punch, Hidden Power, Solar Beam.
- **Removed family egg entries:** Horn Attack.
- **Removed fallback lessons:** Aqua Jet, Heat Wave.
- **Added Blackthorn lessons:** Aerial Ace, Bullet Seed, Frustration, Heat Crash, Iron Tail, Light Screen, Low Sweep, Reflect, Taunt.
- **Restored natural entries:** Flame Wheel, Raging Fury.

### Paldean Wooper

**Added:** Flip Turn, Frustration, Weather Ball, Whirlpool.

**Removed:** Attract, Blizzard, Drain Punch, Flash, Headbutt, Ice Beam, Ice Punch, Iron Head, Rock Smash, Safeguard, Swagger.

- **Removed machine flags:** Attract, Blizzard, Drain Punch, Flash, Headbutt, Ice Beam, Ice Punch, Iron Head, Rock Smash, Swagger.
- **Removed family egg entries:** Safeguard.
- **Added Blackthorn lessons:** Flip Turn, Frustration, Weather Ball, Whirlpool.
- **Restored family egg entries:** Acid Armor.

### Paras

**Added:** Bug Buzz, U-turn.

**Removed:** None.

- **Added Blackthorn lessons:** Bug Buzz, U-turn.

### Parasect

**Added:** Bug Buzz, U-turn.

**Removed:** Shadow Claw, Shadow Sneak.

- **Removed natural entries:** Shadow Claw, Shadow Sneak.
- **Added Blackthorn lessons:** Bug Buzz, U-turn.

### Pawniard

**Added:** None.

**Removed:** Curse, Focus Energy, Strength.

- **Removed machine flags:** Curse, Strength.
- **Removed family egg entries:** Focus Energy.
- **Restored family egg entries:** Superpower.

### Perrserker

**Added:** Bite, Bulk Up, Frustration, Icy Wind, Liquidation, Mimic, Mud-Slap, Outrage, Roar, Skull Bash, Spikes, Swift, Tail Whip, Thunder Wave, Torment, Water Pulse.

**Removed:** Crush Claw, Flash, Low Sweep, Strength.

- **Removed natural entries:** Crush Claw, Low Sweep.
- **Removed machine flags:** Flash, Strength.
- **Added Blackthorn lessons:** Bite, Bulk Up, Frustration, Icy Wind, Liquidation, Mimic, Mud-Slap, Outrage, Roar, Skull Bash, Spikes, Swift, Tail Whip, Thunder Wave, Torment, Water Pulse.

### Persian

**Added:** Metronome, Spikes, Swords Dance.

**Removed:** Crush Claw, Iron Head.

- **Removed natural entries:** Crush Claw.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Metronome, Spikes, Swords Dance.

### Phanpy

**Added:** Absorb, Spikes.

**Removed:** None.

- **Added Blackthorn lessons:** Absorb, Spikes.
- **Restored natural entries:** Drill Run.

### Phantump

**Added:** None.

**Removed:** None.


### Pichu

**Added:** Brick Break, Dig, Discharge, Dizzy Punch, Extreme Speed, Growl, Hyper Voice, Ice Punch, Petal Dance, Quick Attack, Scary Face, Sing, Spark.

**Removed:** Fly, Iron Head, Rock Tomb.

- **Removed machine flags:** Fly, Iron Head, Rock Tomb.
- **Added Blackthorn lessons:** Brick Break, Dig, Discharge, Dizzy Punch, Extreme Speed, Growl, Hyper Voice, Ice Punch, Petal Dance, Quick Attack, Scary Face, Sing, Spark.

### Pidgeot

**Added:** Growl.

**Removed:** Signal Beam.

- **Removed fallback lessons:** Signal Beam.
- **Added Blackthorn lessons:** Growl.

### Pidgeotto

**Added:** Growl, Hyper Voice.

**Removed:** None.

- **Added Blackthorn lessons:** Growl, Hyper Voice.

### Pidgey

**Added:** Dual Wingbeat, Growl, Hyper Voice.

**Removed:** None.

- **Added Blackthorn lessons:** Dual Wingbeat, Growl, Hyper Voice.

### Pikachu

**Added:** Dizzy Punch, Ice Punch, Petal Dance, Scary Face.

**Removed:** Drain Punch, Iron Head, Rock Tomb.

- **Removed machine flags:** Drain Punch, Iron Head, Rock Tomb.
- **Added Blackthorn lessons:** Dizzy Punch, Ice Punch, Petal Dance, Scary Face.

### Piloswine

**Added:** Whirlwind.

**Removed:** None.

- **Added Blackthorn lessons:** Whirlwind.

### Pineco

**Added:** None.

**Removed:** Energy Ball, Fury Cutter.

- **Removed machine flags:** Energy Ball, Fury Cutter.

### Pinsir

**Added:** Aerial Ace, Bug Buzz, Circle Throw, Detect, Dual Wingbeat, Lunge, Rock Throw, Tackle, U-turn.

**Removed:** None.

- **Added Blackthorn lessons:** Aerial Ace, Bug Buzz, Circle Throw, Detect, Dual Wingbeat, Lunge, Rock Throw, Tackle, U-turn.

### Politoed

**Added:** Growth, Lovely Kiss.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Added Blackthorn lessons:** Growth, Lovely Kiss.

### Poliwag

**Added:** Growth, Lovely Kiss.

**Removed:** None.

- **Added Blackthorn lessons:** Growth, Lovely Kiss.

### Poliwhirl

**Added:** Growth, Lovely Kiss.

**Removed:** None.

- **Added Blackthorn lessons:** Growth, Lovely Kiss.

### Poliwrath

**Added:** Growth, Lovely Kiss.

**Removed:** None.

- **Added Blackthorn lessons:** Growth, Lovely Kiss.

### Ponyta

**Added:** None.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.

### Porygon

**Added:** Confuse Ray, Flash Cannon, Self-Destruct, Spark, Volt Switch.

**Removed:** Disable, Foresight, Iron Head, Mind Reader.

- **Removed natural entries:** Disable, Foresight, Mind Reader.
- **Removed machine flags:** Iron Head.
- **Removed family egg entries:** Disable, Foresight, Mind Reader.
- **Added Blackthorn lessons:** Confuse Ray, Flash Cannon, Self-Destruct, Spark, Volt Switch.

### Porygon-Z

**Added:** Confuse Ray, Fire Blast, Flamethrower, Flash Cannon, Ominous Wind, Self-Destruct, Spark, Volt Switch.

**Removed:** Disable, Foresight, Iron Head, Mind Reader.

- **Removed machine flags:** Iron Head.
- **Removed family egg entries:** Disable, Foresight, Mind Reader.
- **Added Blackthorn lessons:** Confuse Ray, Fire Blast, Flamethrower, Flash Cannon, Ominous Wind, Self-Destruct, Spark, Volt Switch.

### Porygon2

**Added:** Confuse Ray, Flash Cannon, Self-Destruct, Spark, Volt Switch.

**Removed:** Disable, Foresight, Iron Head, Mind Reader.

- **Removed machine flags:** Iron Head.
- **Removed family egg entries:** Disable, Foresight, Mind Reader.
- **Added Blackthorn lessons:** Confuse Ray, Flash Cannon, Self-Destruct, Spark, Volt Switch.

### Primeape

**Added:** Circle Throw, Comet Punch, Knock Off, Roar, Rock Throw, Tackle, Torment.

**Removed:** Iron Head, Superpower.

- **Removed natural entries:** Superpower.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Circle Throw, Comet Punch, Knock Off, Roar, Rock Throw, Tackle, Torment.

### Psyduck

**Added:** Petal Dance, Tri Attack.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Petal Dance, Tri Attack.

### Pupitar

**Added:** Rage.

**Removed:** None.

- **Added Blackthorn lessons:** Rage.

### Quagsire

**Added:** Belly Drum, Flip Turn, Scary Face.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Belly Drum, Flip Turn, Scary Face.

### Quilava

**Added:** None.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.

### Qwilfish

**Added:** None.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Restored natural entries:** Cross Poison.

### Raichu

**Added:** Dazzling Gleam, Dizzy Punch, Ice Punch, Petal Dance, Psychic, Scary Face.

**Removed:** Iron Head, Rock Tomb.

- **Removed machine flags:** Iron Head, Rock Tomb.
- **Added Blackthorn lessons:** Dazzling Gleam, Dizzy Punch, Ice Punch, Petal Dance, Psychic, Scary Face.

### Raikou

**Added:** None.

**Removed:** None.


### Raitora

**Added:** None.

**Removed:** None.


### Ralts

**Added:** Ice Beam.

**Removed:** Curse, Energy Ball.

- **Removed machine flags:** Curse, Energy Ball.
- **Added Blackthorn lessons:** Ice Beam.

### Rampardos

**Added:** Bite, Seismic Toss, Tackle.

**Removed:** None.

- **Added Blackthorn lessons:** Bite, Seismic Toss, Tackle.
- **Restored machine flags:** Power Gem.

### Rapidash

**Added:** None.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Restored natural entries:** Raging Fury.

### Raticate

**Added:** Aerial Ace, False Swipe, Sludge Bomb.

**Removed:** Dizzy Punch, Iron Head.

- **Removed natural entries:** Dizzy Punch.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Aerial Ace, False Swipe, Sludge Bomb.

### Rattata

**Added:** Aerial Ace, False Swipe, Sludge Bomb.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Aerial Ace, False Swipe, Sludge Bomb.

### Remoraid

**Added:** Amnesia, Bubble, Mist.

**Removed:** None.

- **Added Blackthorn lessons:** Amnesia, Bubble, Mist.

### Rhydon

**Added:** Head Smash, Wild Charge.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Head Smash, Wild Charge.

### Rhyhorn

**Added:** Giga Impact, Head Smash, Wild Charge.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Giga Impact, Head Smash, Wild Charge.

### Rhyperior

**Added:** Wild Charge.

**Removed:** Drain Punch, Power Gem.

- **Removed machine flags:** Drain Punch, Power Gem.
- **Added Blackthorn lessons:** Wild Charge.

### Riolu

**Added:** Focus Energy, Seismic Toss.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** Focus Energy, Seismic Toss.

### Rookidee

**Added:** Frustration, Gust, Razor Wind, Slash.

**Removed:** Curse, Mud-Slap, Steel Wing, Sunny Day.

- **Removed machine flags:** Curse, Mud-Slap, Steel Wing, Sunny Day.
- **Added Blackthorn lessons:** Frustration, Gust, Razor Wind, Slash.
- **Restored family egg entries:** Pursuit, Whirlwind.

### Salamence

**Added:** Flame Charge, Skull Bash.

**Removed:** Curse, Superpower.

- **Removed machine flags:** Curse.
- **Removed family egg entries:** Superpower.
- **Added Blackthorn lessons:** Flame Charge, Skull Bash.

### Salandit

**Added:** None.

**Removed:** Curse, Dig, Flame Wheel, Headbutt, Shadow Ball.

- **Removed natural entries:** Flame Wheel.
- **Removed machine flags:** Curse, Dig, Headbutt, Shadow Ball.
- **Restored natural entries:** Fire Spin.

### Salazzle

**Added:** None.

**Removed:** Curse, Dig, Flame Wheel, Headbutt.

- **Removed natural entries:** Flame Wheel.
- **Removed machine flags:** Curse, Dig, Headbutt.
- **Restored natural entries:** Fire Spin.
- **Restored machine flags:** Shadow Ball.

### Sandile

**Added:** Aerial Ace, Dragon Claw, Tackle.

**Removed:** Knock Off, Scratch, Swift, Work Up.

- **Removed natural entries:** Scratch.
- **Removed machine flags:** Knock Off, Swift, Work Up.
- **Added Blackthorn lessons:** Aerial Ace, Dragon Claw, Tackle.
- **Restored machine flags:** Night Slash.

### Sandshrew

**Added:** None.

**Removed:** Drain Punch, Drill Run, Iron Head.

- **Removed natural entries:** Drill Run.
- **Removed machine flags:** Drain Punch, Iron Head.

### Sandslash

**Added:** None.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.

### Scizor

**Added:** Calm Mind, Sonic Boom.

**Removed:** Work Up.

- **Removed natural entries:** Work Up.
- **Removed machine flags:** Work Up.
- **Added Blackthorn lessons:** Calm Mind, Sonic Boom.

### Scolipede

**Added:** First Impression, Gunk Shot, Leer, Mortal Spin, Skull Bash, U-turn.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** First Impression, Gunk Shot, Leer, Mortal Spin, Skull Bash, U-turn.

### Scrafty

**Added:** Dynamic Punch, Skull Bash, Tackle.

**Removed:** None.

- **Removed machine flags:** Night Slash.
- **Added Blackthorn lessons:** Dynamic Punch, Skull Bash, Tackle.
- **Restored natural entries:** Circle Throw, Superpower.

### Scraggy

**Added:** Dynamic Punch, Tackle.

**Removed:** None.

- **Added Blackthorn lessons:** Dynamic Punch, Tackle.
- **Restored machine flags:** Night Slash.

### Scyther

**Added:** Calm Mind, Sonic Boom.

**Removed:** Work Up.

- **Removed natural entries:** Work Up.
- **Removed machine flags:** Work Up.
- **Added Blackthorn lessons:** Calm Mind, Sonic Boom.

### Seadra

**Added:** None.

**Removed:** Dragon Tail.

- **Removed natural entries:** Dragon Tail.

### Seaking

**Added:** Thunderbolt.

**Removed:** None.

- **Added Blackthorn lessons:** Thunderbolt.

### Sealeo

**Added:** Liquidation.

**Removed:** None.

- **Added Blackthorn lessons:** Liquidation.
- **Restored natural entries:** Freeze-Dry.

### Seel

**Added:** Flail.

**Removed:** None.

- **Added Blackthorn lessons:** Flail.

### Sentret

**Added:** Dizzy Punch.

**Removed:** Drain Punch, Iron Head, Rock Tomb.

- **Removed machine flags:** Drain Punch, Iron Head, Rock Tomb.
- **Added Blackthorn lessons:** Dizzy Punch.

### Seviper

**Added:** Dragon Pulse, Leer, Scale Shot.

**Removed:** Cross Poison.

- **Removed natural entries:** Cross Poison.
- **Added Blackthorn lessons:** Dragon Pulse, Leer, Scale Shot.
- **Restored natural entries:** Foul Play.
- **Restored family egg entries:** Pursuit, Spite.

### Shelgon

**Added:** None.

**Removed:** Curse, Earthquake, Scale Shot, Superpower.

- **Removed natural entries:** Scale Shot.
- **Removed machine flags:** Curse, Earthquake.
- **Removed family egg entries:** Superpower.

### Shellder

**Added:** None.

**Removed:** None.


### Shieldon

**Added:** Body Press, Self-Destruct.

**Removed:** None.

- **Added Blackthorn lessons:** Body Press, Self-Destruct.

### Shroomish

**Added:** None.

**Removed:** Curse.

- **Removed machine flags:** Curse.

### Shuckle

**Added:** Bug Buzz.

**Removed:** Body Press, Fury Cutter.

- **Removed natural entries:** Body Press.
- **Removed machine flags:** Fury Cutter.
- **Added Blackthorn lessons:** Bug Buzz.

### Shuppet

**Added:** Lick, Zen Headbutt.

**Removed:** None.

- **Added Blackthorn lessons:** Lick, Zen Headbutt.

### Sirfetch'd

**Added:** Focus Blast, Hurricane, Vacuum Wave.

**Removed:** Bulk Up, Circle Throw, Drain Punch, Force Palm, Hyper Beam, Iron Head, Low Sweep, Sacred Sword.

- **Removed natural entries:** Circle Throw, Force Palm, Low Sweep, Sacred Sword.
- **Removed machine flags:** Bulk Up, Drain Punch, Headbutt, Hyper Beam, Iron Head, Mud-Slap, Thief.
- **Removed family egg entries:** Flail, Foresight, Gust, Mirror Move, Mud-Slap.
- **Removed fallback lessons:** Air Cutter, Ominous Wind.
- **Added Blackthorn lessons:** Focus Blast, Frustration, Hurricane, Iron Tail, Psych Up, Razor Wind, U-turn, Vacuum Wave.

### Sizzlipede

**Added:** Frustration, Gyro Ball.

**Removed:** Agility, Curse, Fire Blast, Flame Charge, Flamethrower, Fury Cutter, Scary Face, Swagger, Will-O-Wisp, X-Scissor.

- **Removed machine flags:** Curse, Fire Blast, Flamethrower, Fury Cutter, Swagger, Will-O-Wisp.
- **Removed family egg entries:** Agility, Flame Charge, Scary Face, X-Scissor.
- **Added Blackthorn lessons:** Frustration, Gyro Ball.

### Skarmory

**Added:** Razor Wind, Scale Shot, Skull Bash.

**Removed:** U-turn.

- **Removed fallback lessons:** U-turn.
- **Added Blackthorn lessons:** Razor Wind, Scale Shot, Skull Bash.

### Skiploom

**Added:** Agility, Air Cutter.

**Removed:** None.

- **Added Blackthorn lessons:** Agility, Air Cutter.

### Slowbro

**Added:** Ancient Power, Power Gem.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Ancient Power, Power Gem.

### Slowking

**Added:** Ancient Power.

**Removed:** Iron Head, Psycho Cut, Recover.

- **Removed natural entries:** Psycho Cut, Recover.
- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Ancient Power.

### Slowpoke

**Added:** None.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.

### Slugma

**Added:** None.

**Removed:** None.


### Smeargle

**Added:** None.

**Removed:** None.


### Smoochum

**Added:** Dazzling Gleam, Dizzy Punch, Petal Dance.

**Removed:** Drain Punch, Lovely Kiss.

- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Lovely Kiss.
- **Added Blackthorn lessons:** Dazzling Gleam, Dizzy Punch, Petal Dance.

### Sneasel

**Added:** Moonlight.

**Removed:** Drain Punch, Freeze-Dry, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Removed fallback lessons:** Freeze-Dry.
- **Added Blackthorn lessons:** Moonlight.
- **Restored natural entries:** Ice Fang.

### Sneasler

**Added:** Bulldoze, Dark Pulse, Foresight, Frustration, Fury Cutter, Hail, Hex, Iron Tail, Knock Off, Mud-Slap, Psych Up, Seismic Toss, Snore, Superpower, Thunder Punch, Torment.

**Removed:** Curse, Headbutt, Iron Head, Surf, Whirlpool.

- **Removed machine flags:** Curse, Headbutt, Iron Head, Surf, Whirlpool.
- **Added Blackthorn lessons:** Bulldoze, Dark Pulse, Foresight, Frustration, Fury Cutter, Hail, Hex, Iron Tail, Knock Off, Mud-Slap, Psych Up, Seismic Toss, Snore, Superpower, Thunder Punch, Torment.
- **Restored natural entries:** Cross Poison.
- **Restored Blackthorn lessons:** Triple Axel.

### Snorlax

**Added:** Lovely Kiss, Splash, Sweet Kiss.

**Removed:** Drain Punch, Swift.

- **Removed machine flags:** Drain Punch, Swift.
- **Added Blackthorn lessons:** Lovely Kiss, Splash, Sweet Kiss.

### Snorunt

**Added:** None.

**Removed:** Confuse Ray, Curse, Destiny Bond, Freeze-Dry.

- **Removed natural entries:** Freeze-Dry.
- **Removed machine flags:** Curse.
- **Removed family egg entries:** Confuse Ray, Destiny Bond.

### Snover

**Added:** Seismic Toss.

**Removed:** Sunny Day.

- **Removed machine flags:** Sunny Day.
- **Added Blackthorn lessons:** Seismic Toss.
- **Restored natural entries:** Freeze-Dry.

### Snubbull

**Added:** None.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.

### Spearow

**Added:** Hurricane, Sonic Boom.

**Removed:** None.

- **Added Blackthorn lessons:** Hurricane, Sonic Boom.

### Spheal

**Added:** Liquidation.

**Removed:** None.

- **Added Blackthorn lessons:** Liquidation.
- **Restored natural entries:** Freeze-Dry.

### Spinarak

**Added:** False Swipe, Growth, Headbutt.

**Removed:** Energy Ball, Fury Cutter.

- **Removed machine flags:** Energy Ball, Fury Cutter.
- **Added Blackthorn lessons:** False Swipe, Growth, Headbutt.

### Spoink

**Added:** Hypnosis, Mud Shot, Pay Day, Shadow Punch, Will-O-Wisp.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** Hypnosis, Mud Shot, Pay Day, Shadow Punch, Will-O-Wisp.

### Squirtle

**Added:** Zap Cannon.

**Removed:** Dark Pulse, Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Dark Pulse.
- **Added Blackthorn lessons:** Zap Cannon.

### Squirtle (Clone)

**Added:** Zap Cannon.

**Removed:** Dark Pulse, Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Dark Pulse.
- **Added Blackthorn lessons:** Zap Cannon.

### Stantler

**Added:** Confusion, Psyshield Bash, Safeguard.

**Removed:** None.

- **Added Blackthorn lessons:** Confusion, Psyshield Bash, Safeguard.
- **Restored natural entries:** Horn Leech.

### Staraptor

**Added:** Blaze Kick, Brick Break, Bulk Up, Focus Blast, Focus Energy, Gust, Knock Off, Low Sweep, Outrage, Peck, Razor Wind, Seismic Toss, Skull Bash, Torment, Vacuum Wave.

**Removed:** Curse, Headbutt, Strength.

- **Removed machine flags:** Curse, Headbutt, Strength.
- **Added Blackthorn lessons:** Blaze Kick, Brick Break, Bulk Up, Focus Blast, Focus Energy, Gust, Knock Off, Low Sweep, Outrage, Peck, Razor Wind, Seismic Toss, Skull Bash, Torment, Vacuum Wave.

### Staravia

**Added:** Giga Impact, Gust, Knock Off, Peck, Skull Bash, Sky Attack, Vacuum Wave.

**Removed:** Curse, Headbutt.

- **Removed machine flags:** Curse, Headbutt.
- **Added Blackthorn lessons:** Giga Impact, Gust, Knock Off, Peck, Skull Bash, Sky Attack, Vacuum Wave.

### Starly

**Added:** Giga Impact, Gust, Knock Off, Peck.

**Removed:** Curse, Headbutt.

- **Removed machine flags:** Curse, Headbutt.
- **Added Blackthorn lessons:** Giga Impact, Gust, Knock Off, Peck.

### Starmie

**Added:** Ancient Power, Aqua Jet, Bulk Up, Liquidation, Safeguard, Self-Destruct, Triple Axel, Zen Headbutt.

**Removed:** Aurora Beam, Barrier, Supersonic.

- **Removed family egg entries:** Aurora Beam, Barrier, Supersonic.
- **Added Blackthorn lessons:** Ancient Power, Aqua Jet, Bulk Up, Liquidation, Safeguard, Self-Destruct, Triple Axel, Zen Headbutt.

### Staryu

**Added:** Aqua Jet, Safeguard, Self-Destruct.

**Removed:** Aurora Beam, Barrier, Supersonic.

- **Removed natural entries:** Aurora Beam, Barrier, Supersonic.
- **Removed family egg entries:** Aurora Beam, Barrier, Supersonic.
- **Added Blackthorn lessons:** Aqua Jet, Safeguard, Self-Destruct.

### Steelix

**Added:** Sharpen.

**Removed:** Mud Shot.

- **Removed natural entries:** Mud Shot.
- **Added Blackthorn lessons:** Sharpen.

### Steenee

**Added:** Growth, Power Whip.

**Removed:** Curse, Cut, Flash, Leech Seed.

- **Removed machine flags:** Curse, Cut, Flash.
- **Removed family egg entries:** Leech Seed.
- **Added Blackthorn lessons:** Growth, Power Whip.

### Sudowoodo

**Added:** Tackle.

**Removed:** Ancient Power, Bounce, Charm, Leer, Reversal.

- **Removed natural entries:** Bounce.
- **Removed fallback lessons:** Ancient Power.
- **Added Blackthorn lessons:** Tackle.

### Suicune

**Added:** Hurricane.

**Removed:** None.

- **Added Blackthorn lessons:** Hurricane.

### Sunflora

**Added:** Splash.

**Removed:** Wood Hammer.

- **Removed fallback lessons:** Wood Hammer.
- **Added Blackthorn lessons:** Splash.
- **Restored natural entries:** Flamethrower, Incinerate.

### Sunkern

**Added:** Splash.

**Removed:** None.

- **Added Blackthorn lessons:** Splash.

### Swablu

**Added:** None.

**Removed:** Bounce, Curse, Earthquake, Fire Blast, Flamethrower.

- **Removed natural entries:** Bounce.
- **Removed machine flags:** Curse, Earthquake, Fire Blast, Flamethrower.
- **Restored natural entries:** Draining Kiss.

### Swinub

**Added:** Whirlwind.

**Removed:** None.

- **Added Blackthorn lessons:** Whirlwind.

### Sylveon

**Added:** Grass Knot, Growth, Rock Smash, Taunt.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Grass Knot, Growth, Rock Smash, Taunt.

### Talonflame

**Added:** Blaze Kick, Vacuum Wave, Wing Attack.

**Removed:** Curse, Headbutt, Pursuit, Strength.

- **Removed machine flags:** Curse, Headbutt, Strength.
- **Removed family egg entries:** Pursuit, Sky Attack.
- **Added Blackthorn lessons:** Blaze Kick, Sky Attack, Vacuum Wave, Wing Attack.

### Tangela

**Added:** None.

**Removed:** None.


### Tangrowth

**Added:** None.

**Removed:** Wood Hammer.

- **Removed natural entries:** Wood Hammer.

### Tauros

**Added:** Quick Attack.

**Removed:** Brick Break, Crush Claw, Superpower.

- **Removed natural entries:** Brick Break, Crush Claw, Superpower.
- **Added Blackthorn lessons:** Quick Attack.

### Teddiursa

**Added:** Tackle.

**Removed:** Crush Claw, Drain Punch.

- **Removed natural entries:** Crush Claw.
- **Removed machine flags:** Drain Punch.
- **Added Blackthorn lessons:** Tackle.

### Teddiursa (Bloodmoon)

**Added:** Tackle.

**Removed:** Crush Claw, Drain Punch.

- **Removed natural entries:** Crush Claw.
- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Belly Drum, Counter, Fury Cutter, Seismic Toss.
- **Added Blackthorn lessons:** Belly Drum, Counter, Seismic Toss, Tackle.

### Tentacool

**Added:** None.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.

### Tentacruel

**Added:** None.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.

### Timburr

**Added:** None.

**Removed:** None.

- **Restored family egg entries:** Cross Chop.

### Tinkatink

**Added:** Brick Break, Bulldoze, False Swipe, Rock Throw, Screech, Tackle.

**Removed:** Attract, Bullet Punch, Charm, Curse, Hidden Power, Return, Strength, Swagger, Toxic.

- **Removed natural entries:** Bullet Punch.
- **Removed machine flags:** Attract, Curse, Hidden Power, Return, Strength, Swagger, Toxic.
- **Removed family egg entries:** Bullet Punch, Charm.
- **Added Blackthorn lessons:** Brick Break, Bulldoze, False Swipe, Rock Throw, Screech, Tackle.
- **Restored machine flags:** Iron Head.

### Tinkaton

**Added:** Bulk Up, False Swipe, Rock Throw, Screech, Tackle, Wood Hammer.

**Removed:** Attract, Bullet Punch, Charm, Curse, Hidden Power, Return, Strength, Swagger, Toxic.

- **Removed natural entries:** Iron Head.
- **Removed machine flags:** Attract, Curse, Hidden Power, Iron Head, Return, Strength, Swagger, Toxic.
- **Removed family egg entries:** Bullet Punch, Charm.
- **Added Blackthorn lessons:** Bulk Up, False Swipe, Rock Throw, Screech, Tackle, Wood Hammer.
- **Restored natural entries:** Hammer Arm, Iron Defense.

### Tinkatuff

**Added:** Bulk Up, Bulldoze, False Swipe, Rock Throw, Screech, Tackle.

**Removed:** Attract, Bullet Punch, Charm, Curse, Hidden Power, Return, Strength, Swagger, Toxic.

- **Removed machine flags:** Attract, Curse, Hidden Power, Iron Head, Return, Strength, Swagger, Toxic.
- **Removed family egg entries:** Bullet Punch, Charm.
- **Added Blackthorn lessons:** Bulk Up, Bulldoze, False Swipe, Rock Throw, Screech, Tackle.
- **Restored natural entries:** Hammer Arm, Iron Defense.

### Tirtouga

**Added:** None.

**Removed:** Iron Head, Mud-Slap, Power Gem, Roar.

- **Removed machine flags:** Iron Head, Mud-Slap, Power Gem, Roar.
- **Restored machine flags:** Headbutt.
- **Restored family egg entries:** Head Smash.

### Togekiss

**Added:** Hurricane, Tackle.

**Removed:** Bounce, Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Removed fallback lessons:** Bounce.
- **Added Blackthorn lessons:** Hurricane, Tackle.

### Togepi

**Added:** Fairy Wind, Tackle.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Added Blackthorn lessons:** Fairy Wind, Tackle.

### Togetic

**Added:** Air Slash, Hurricane, Tackle.

**Removed:** Aura Sphere, Bounce, Rock Tomb.

- **Removed natural entries:** Aura Sphere.
- **Removed machine flags:** Rock Tomb.
- **Removed fallback lessons:** Bounce.
- **Added Blackthorn lessons:** Air Slash, Hurricane, Tackle.

### Torkoal

**Added:** None.

**Removed:** Dig, Iron Head, Roar, Shadow Ball.

- **Removed natural entries:** Iron Head.
- **Removed machine flags:** Dig, Iron Head, Roar, Shadow Ball.

### Totodile

**Added:** Bubble Beam, Bulldoze, Dark Pulse, False Swipe, Night Slash, Outrage, Submission, Tackle.

**Removed:** Agility, Flash, Fly, Iron Head, Strength.

- **Removed natural entries:** Agility.
- **Removed machine flags:** Flash, Fly, Iron Head, Strength.
- **Added Blackthorn lessons:** Bubble Beam, Bulldoze, Dark Pulse, False Swipe, Night Slash, Outrage, Submission, Tackle.

### Toxapex

**Added:** None.

**Removed:** Curse, Sludge, Waterfall, Whirlpool.

- **Removed machine flags:** Curse, Waterfall, Whirlpool.
- **Removed family egg entries:** Sludge.
- **Restored natural entries:** Body Press.

### Toxicroak

**Added:** Earth Power, Seismic Toss.

**Removed:** Acid Armor, Curse.

- **Removed machine flags:** Curse.
- **Removed family egg entries:** Acid Armor.
- **Added Blackthorn lessons:** Earth Power, Seismic Toss.
- **Restored natural entries:** Force Palm, Superpower.

### Trapinch

**Added:** Hyper Voice.

**Removed:** Curse, Fire Blast, Flamethrower, Roost.

- **Removed machine flags:** Curse, Fire Blast, Flamethrower.
- **Removed family egg entries:** Roost.
- **Added Blackthorn lessons:** Hyper Voice.
- **Restored family egg entries:** U-turn.

### Trevenant

**Added:** Shadow Punch, Shadow Sneak.

**Removed:** None.

- **Added Blackthorn lessons:** Shadow Punch, Shadow Sneak.

### Tsareena

**Added:** Growth.

**Removed:** Brick Break, Circle Throw, Curse, Cut, Dig, Flash, Iron Head, Iron Tail, Leech Seed, Rock Smash, Strength, Thief, Wood Hammer.

- **Removed natural entries:** Brick Break, Circle Throw, Wood Hammer.
- **Removed machine flags:** Curse, Cut, Dig, Flash, Iron Head, Rock Smash, Strength, Thief.
- **Removed family egg entries:** Leech Seed.
- **Removed fallback lessons:** Iron Tail.
- **Added Blackthorn lessons:** Growth.
- **Restored natural entries:** Leaf Blade, Swords Dance.

### Typhlosion

**Added:** None.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.

### Tyranitar

**Added:** Rage, Scale Shot.

**Removed:** Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Added Blackthorn lessons:** Rage, Scale Shot.

### Tyrantrum

**Added:** None.

**Removed:** Mud-Slap, Power Gem.

- **Removed machine flags:** Mud-Slap, Power Gem.
- **Restored machine flags:** Headbutt.

### Tyrogue

**Added:** Dizzy Punch, Rage.

**Removed:** None.

- **Added Blackthorn lessons:** Dizzy Punch, Rage.

### Tyrunt

**Added:** None.

**Removed:** Mud-Slap, Power Gem.

- **Removed machine flags:** Mud-Slap, Power Gem.
- **Restored machine flags:** Headbutt.

### Umbreon

**Added:** Disarming Voice, Grass Knot, Growth, Knock Off, Ominous Wind, Razor Wind, Rock Smash.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Disarming Voice, Grass Knot, Growth, Knock Off, Ominous Wind, Razor Wind, Rock Smash.

### Unown

**Added:** None.

**Removed:** Calm Mind, Psychic, Shadow Ball, Trick.

- **Removed natural entries:** Calm Mind, Psychic, Trick.
- **Removed machine flags:** Shadow Ball.

### Ursaluna

**Added:** Stealth Rock, Tackle.

**Removed:** None.

- **Added Blackthorn lessons:** Stealth Rock, Tackle.
- **Restored natural entries:** Crush Claw.
- **Restored machine flags:** Sandstorm.

### Ursaluna (Bloodmoon)

**Added:** Stealth Rock, Tackle.

**Removed:** Crush Claw, Sandstorm.

- **Removed natural entries:** Work Up.
- **Removed machine flags:** Attract, Curse, Cut, Fury Cutter, Headbutt, Hone Claws, Mud-Slap, Rock Smash, Sandstorm, Strength, Swagger, Work Up, Zap Cannon.
- **Removed family egg entries:** Belly Drum, Counter, Fury Cutter, Seismic Toss.
- **Added Blackthorn lessons:** Aerial Ace, Frustration.

### Ursaring

**Added:** Stealth Rock, Tackle.

**Removed:** None.

- **Added Blackthorn lessons:** Stealth Rock, Tackle.
- **Restored natural entries:** Crush Claw.
- **Restored machine flags:** Drain Punch.

### Ursaring (Bloodmoon)

**Added:** Stealth Rock, Tackle.

**Removed:** Calm Mind, Crush Claw, Drain Punch, Earth Power, Sandstorm.

- **Removed natural entries:** Calm Mind, Earth Power.
- **Removed machine flags:** Drain Punch, Sandstorm.
- **Removed family egg entries:** Belly Drum, Counter, Fury Cutter, Seismic Toss.
- **Added Blackthorn lessons:** Belly Drum, Counter, Seismic Toss, Stealth Rock, Tackle.

### Vaporeon

**Added:** Bubble, Disarming Voice, Grass Knot, Growth, Taunt.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Bubble, Disarming Voice, Grass Knot, Growth, Taunt.

### Venipede

**Added:** Leer, Rock Tomb.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** Leer, Rock Tomb.
- **Restored natural entries:** Cross Poison.

### Venomoth

**Added:** Fly, Hurricane.

**Removed:** Fury Cutter.

- **Removed machine flags:** Fury Cutter.
- **Added Blackthorn lessons:** Fly, Hurricane.

### Venonat

**Added:** None.

**Removed:** Fury Cutter.

- **Removed machine flags:** Fury Cutter.

### Venusaur

**Added:** Ancient Power.

**Removed:** None.

- **Added Blackthorn lessons:** Ancient Power.
- **Restored natural entries:** Wood Hammer.

### Venusaur (Clone)

**Added:** Ancient Power.

**Removed:** None.

- **Added Blackthorn lessons:** Ancient Power.
- **Restored natural entries:** Wood Hammer.

### Vibrava

**Added:** Hurricane, Hyper Voice.

**Removed:** Curse, Fire Blast, Flamethrower.

- **Removed machine flags:** Curse, Fire Blast, Flamethrower.
- **Removed family egg entries:** Roost.
- **Added Blackthorn lessons:** Hurricane, Hyper Voice, Roost, U-turn.

### Victreebel

**Added:** Lovely Kiss, Sweet Kiss, Toxic Spikes.

**Removed:** Wood Hammer.

- **Removed natural entries:** Wood Hammer.
- **Added Blackthorn lessons:** Lovely Kiss, Sweet Kiss, Toxic Spikes.

### Vikavolt

**Added:** Hurricane.

**Removed:** Curse, Flash, Fury Cutter.

- **Removed natural entries:** Nuzzle.
- **Removed machine flags:** Curse, Flash, Fury Cutter.
- **Removed family egg entries:** Agility.
- **Added Blackthorn lessons:** Hurricane.

### Vileplume

**Added:** Quiver Dance.

**Removed:** None.

- **Added Blackthorn lessons:** Quiver Dance.

### Volcarona

**Added:** None.

**Removed:** Curse, Energy Ball, Fury Cutter.

- **Removed machine flags:** Curse, Energy Ball, Fury Cutter.

### Voltorb

**Added:** Bug Buzz.

**Removed:** Nuzzle, Recover, Rock Tomb.

- **Removed natural entries:** Nuzzle, Recover.
- **Removed machine flags:** Rock Tomb.
- **Removed family egg entries:** Nuzzle, Recover.
- **Added Blackthorn lessons:** Bug Buzz.

### Vulpix

**Added:** Flame Wheel, Heal Bell.

**Removed:** Iron Head.

- **Removed machine flags:** Iron Head.
- **Added Blackthorn lessons:** Flame Wheel, Heal Bell.

### Walrein

**Added:** None.

**Removed:** None.

- **Removed natural entries:** Freeze-Dry.
- **Restored natural entries:** Slack Off.

### Wartortle

**Added:** Zap Cannon.

**Removed:** Dark Pulse, Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Dark Pulse.
- **Added Blackthorn lessons:** Zap Cannon.

### Wartortle (Clone)

**Added:** Zap Cannon.

**Removed:** Dark Pulse, Drain Punch.

- **Removed machine flags:** Drain Punch.
- **Removed family egg entries:** Dark Pulse.
- **Added Blackthorn lessons:** Zap Cannon.

### Watu

**Added:** Safeguard.

**Removed:** None.

- **Added Blackthorn lessons:** Aerial Ace, Air Cutter, Baton Pass, Dazzling Gleam, Detect, Double Team, Double-Edge, Dual Wingbeat, Endure, Frustration, Giga Drain, Grass Knot, Mimic, Nightmare, Pain Split, Sky Attack, Snore, Twister, U-turn.

### Weavile

**Added:** Moonlight.

**Removed:** Drain Punch, Freeze-Dry, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Removed fallback lessons:** Freeze-Dry.
- **Added Blackthorn lessons:** Moonlight.
- **Restored natural entries:** Ice Fang.

### Weedle

**Added:** Facade.

**Removed:** None.

- **Added Blackthorn lessons:** Facade.

### Weepinbell

**Added:** Lovely Kiss, Sweet Kiss, Toxic Spikes.

**Removed:** None.

- **Added Blackthorn lessons:** Lovely Kiss, Sweet Kiss, Toxic Spikes.

### Weezing

**Added:** Snarl, Strange Steam.

**Removed:** Fairy Wind, Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Added Blackthorn lessons:** Snarl, Strange Steam.

### Whirlipede

**Added:** Leer, Mortal Spin, Rock Tomb.

**Removed:** Curse.

- **Removed machine flags:** Curse.
- **Added Blackthorn lessons:** Leer, Mortal Spin, Rock Tomb.
- **Restored natural entries:** Cross Poison.

### Wigglytuff

**Added:** Confusion, Dizzy Punch, Fake Out, Petal Dance, Scary Face, Tackle.

**Removed:** Rock Tomb.

- **Removed machine flags:** Rock Tomb.
- **Added Blackthorn lessons:** Confusion, Dizzy Punch, Fake Out, Petal Dance, Scary Face, Tackle.

### Wimpod

**Added:** None.

**Removed:** Bubble, Curse, Fury Cutter, Ice Beam, Whirlpool.

- **Removed natural entries:** Bubble, Fury Cutter.
- **Removed machine flags:** Curse, Fury Cutter, Ice Beam, Whirlpool.
- **Restored natural entries:** Bug Bite.
- **Restored family egg entries:** Aqua Tail, Superpower.

### Wobbuffet

**Added:** Mimic.

**Removed:** None.

- **Added Blackthorn lessons:** Mimic.

### Wooper

**Added:** Belly Drum, Scary Face.

**Removed:** Drain Punch, Iron Head.

- **Removed machine flags:** Drain Punch, Iron Head.
- **Added Blackthorn lessons:** Belly Drum, Scary Face.
- **Restored family egg entries:** Acid Armor.

### Wynaut

**Added:** None.

**Removed:** None.


### Wyrdeer

**Added:** Confusion, Safeguard.

**Removed:** Strength.

- **Removed machine flags:** Strength.
- **Added Blackthorn lessons:** Confusion, Safeguard.
- **Restored natural entries:** Horn Leech.

### Xatu

**Added:** Safeguard.

**Removed:** None.

- **Removed natural entries:** Psycho Cut.
- **Removed machine flags:** Energy Ball.
- **Added Blackthorn lessons:** Safeguard.

### Yanma

**Added:** Hurricane, Sweet Kiss.

**Removed:** Energy Ball, Fury Cutter.

- **Removed machine flags:** Energy Ball, Fury Cutter.
- **Added Blackthorn lessons:** Hurricane, Sweet Kiss.

### Yanmega

**Added:** Hurricane, Sweet Kiss.

**Removed:** Energy Ball, Fury Cutter.

- **Removed machine flags:** Energy Ball, Fury Cutter.
- **Added Blackthorn lessons:** Hurricane, Sweet Kiss.

### Zangoose

**Added:** Comet Punch, Fake Out, Skull Bash, Tackle.

**Removed:** Cut, Drain Punch.

- **Removed machine flags:** Cut, Drain Punch.
- **Added Blackthorn lessons:** Comet Punch, Fake Out, Skull Bash, Tackle.

### Zapdos

**Added:** None.

**Removed:** None.


### Zubat

**Added:** Cross Poison, Flail, Hurricane.

**Removed:** Energy Ball.

- **Removed machine flags:** Energy Ball.
- **Added Blackthorn lessons:** Cross Poison, Flail, Hurricane.

### Zweilous

**Added:** Dragon Dance.

**Removed:** Curse, Fire Blast, Flamethrower, Foul Play, Knock Off, Scale Shot, Surf.

- **Removed natural entries:** Foul Play, Scale Shot.
- **Removed machine flags:** Curse, Fire Blast, Flamethrower, Knock Off, Surf.
- **Added Blackthorn lessons:** Dragon Dance.
- **Restored machine flags:** Dragon Claw, Night Slash.
