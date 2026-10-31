# Modern held items

The 18 new items have appended item indices ($011d–$012f). Existing item indices,
save format, inventory quantities, and saved progress keep their identities.
The retired Sitrus index $012d is reserved and converts to Gold Berry on load,
including saved Bag, PC, held, and boxed items. Gold Berry now heals 25%
of maximum HP instead of a fixed 30 HP.

Held effects use the existing Klutz-aware getters and the shared consumption
history used by Recycle, Harvest, Cud Chew, and Unburden.

## Where to buy

Talk to the existing clerk and answer **Yes** to “Browse our new battle items?”
Answer No to reach the clerk's previous stock choices.

| Shop | New stock |
| --- | --- |
| Goldenrod Department Store 3F | Covert Cloak, Clear Amulet, Metronome, Heavy-Duty Boots, Red Card, Eject Button, Power Herb |
| Goldenrod Department Store 4F | White Herb, Black Sludge, Light Clay, Throat Spray, Punching Glove, Quick Powder, Safety Goggles |
| Celadon Department Store 4F | Big Root, Blunder Policy, Gold Berry, Custap Berry, Salac Berry |

Some item names are abbreviated to fit the game's 12-character item-name limit.
The held Metronome's source constant is `METRONOME_ITEM`, since `METRONOME`
already names the move.

## Effects

| Item | Effect |
| --- | --- |
| Covert Cloak | Blocks damaging moves' additional effects against the holder, including flinching. |
| Clear Amulet | Blocks opponents' stat drops, including Intimidate; permits self-inflicted drops. |
| Metronome | Repeating the same move adds 20% damage per consecutive use, up to 2×; changing moves or switching resets the count. |
| Heavy-Duty Boots | Ignores Spikes, Toxic Spikes, Stealth Rock, Sticky Web, and this game's Spider Web entry hazard. |
| Red Card | After surviving direct damage, consumes itself and forces the attacker out. A wild attacker flees. Suction Cups prevents displacement after consumption. |
| Eject Button | After surviving direct damage, consumes itself and switches the holder to a usable reserve through the native switch-selection flow. |
| Power Herb | Consumes itself to skip a two-turn move's charging turn. Sunny Solar Beam preserves it. |
| White Herb | Consumes itself to restore negative stat stages to neutral, preserving positive stages. |
| Black Sludge | Restores 1/16 max HP per turn to Poison types; damages other types by 1/8 max HP. Magic Guard prevents that damage. |
| Light Clay | Extends Reflect and Light Screen to eight turns, including the turn used. |
| Throat Spray | A successfully used sound move consumes it and raises Special Attack by one stage. |
| Punching Glove | Boosts punching moves by 10% and removes their contact. |
| Quick Powder | Doubles **original Ditto's** effective Speed, including after Transform. This intentionally follows this game's Gen II-style Metal Powder identity rule, as requested. |
| Safety Goggles | Blocks powder/spore moves and sandstorm/hail damage. |
| Big Root | Multiplies HP received from draining moves and Leech Seed by 1.3, rounded down. |
| Blunder Policy | An accuracy-roll miss consumes it and sharply raises Speed. Protect and type immunity do not trigger it. |
| Gold Berry | At half HP or lower, consumes itself and restores 1/4 max HP. Ripen doubles restoration. Also usable from the Bag. |
| Custap Berry | At 1/4 HP or lower, consumes itself and moves first within the existing move-priority bracket. Gluttony advances the threshold to half HP. |
| Salac Berry | At 1/4 HP or lower, consumes itself and raises Speed. Gluttony advances the threshold to half HP; Ripen doubles the stage increase. |

Unnerve prevents automatic Berry consumption. The new Berries participate in
the existing consumption, recovery, destruction, and save-serialization paths.
Move-end item events follow the engine's Sheer Force rules: eligible boosted
moves suppress Red Card, Eject Button, and Throat Spray; unboosted sound moves
can still activate Throat Spray.

## Berry animation source

Adapted from [Polished Crystal, commit 435bb9061592246dec0c5c5cf813389e7d17de4a](https://github.com/rangi42/polishedcrystal/tree/435bb9061592246dec0c5c5cf813389e7d17de4a):

- `BattleAnim_HeldItemTrigger` in `data/moves/animations.asm`.
- Original `gfx/battle_anims/berry.png` artwork.
- Berry object/frameset definitions in `data/battle_anims/objects.asm` and `framesets.asm`.

The port retains the bouncing berry, three bite sounds, shrinking bite frames,
and recovery effect. It uses this game's existing animation function $41,
palette, far animation pointers, and three-byte framesets. Both battlers use
the shared recovery animation. Berry Juice uses the non-Berry recovery branch.
Battle-animation settings remain respected.

### Berry colors

| In-game Berry | Modern counterpart | Consumption color |
| --- | --- | --- |
| Berry | Oran | Blue |
| Gold Berry | Sitrus | Warm gold |
| PSNCureBerry | Pecha | Pink |
| PRZCureBerry | Cheri | Red |
| Burnt Berry | Aspear | Yellow-green |
| Ice Berry | Rawst | Light blue |
| Bitter Berry | Persim | Pink |
| Mint Berry | Chesto | Blue |
| MiracleBerry | Lum | Green |
| MysteryBerry | Leppa | Red |

Gold, yellow-green, and light-blue palettes are dedicated to these Berries.
All ten are checked during actual consumption on both battle sides, including
the displayed object-palette bytes and captured sprite frames. Run
`python3 tools/battletest/berry_palette_checks.py` to reproduce the 20 checks
and the color contact sheet.

## Reproduce validation

```sh
make -j4 all debug
python3 tools/battletest/runner.py --no-render --jobs 6 --all-moves --all-effects --all-abilities --item-matrix --class-matrix
python3 tools/test_item_expansion.py
python3 tools/test_item_expansion.py pokecrystal_debug.gbc
python3 tools/test_quick_powder.py
python3 tools/test_quick_powder.py pokecrystal_debug.gbc
python3 tools/test_consumable_ui.py
python3 tools/test_consumable_ui.py pokecrystal_debug.gbc
python3 tools/battletest/berry_animation_checks.py --ffmpeg /path/to/ffmpeg
```

The recording fixture starts each holder just above half HP. An ordinary opposing
attack crosses the threshold; the native battle engine renders the consumption,
heals the holder, and removes the held item. Output includes MP4 video with game
audio, frame captures, and a JSON receipt. Tests use isolated emulator memory
and never open the player's save file.

## Validation results — October 30, 2026

- Release and debug ROMs build successfully.
- 6,105 native battle cases passed, with zero failures, errors, or skips.
  This includes 200 targeted cases for the new items, every-move/effect/ability
  sweeps, and the existing item/contact-class matrices.
- Each ROM passed 1,245 catalogue/save checks and 512 exact Quick Powder Speed
  checks, including original Ditto after Transform.
- Each ROM passed 69 native consumable-menu checks, including repeated Gold Berry use.
- Eight static item-catalogue tests passed; every held item has an acquisition source.
- The 38-second MP4 shows Gold Berry consumption on both sides, with native game
  audio. The recording checks consumption, rendered berry sprites, nonempty
  audio, and successful decoding of both streams.
- All 20 palette checks passed: each of the ten requested Berries was consumed
  and rendered with its assigned color on both battle sides.

The separate existing `tools/test_battle_symbols.py` still fails its assertion
that AROMA_LADY is the final trainer class. The repository already has classes
after it, ending with HOSTESS; that test and its trainer-constant input are
unchanged from HEAD. It is unrelated to these item changes.

The detailed receipt and logs are in
`reports/held-items/2026-10-30/validation.json`.
