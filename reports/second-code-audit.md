# Second code-audit sweep

This pass builds on `general-code-audit.md` and focuses on move interactions,
quest/shop scripts, persistent pickup flags, and test coverage missed by the
first pass. Existing first-pass changes remain in place.

## Gameplay fixes

### Physical Shell Side Arm skipped contact reactions

`CheckContactMoveID` consulted only the static move bitfield. Shell Side Arm's
bit is clear because its normal special attack does not make contact; its
physical version therefore also skipped Iron Barbs, Rocky Helmet and the AI's
contact-risk penalty.

The shared helper now checks Shell Side Arm's resolved category in the
appropriate battler's move struct. Physical uses contact and special does not.
Other moves continue to use the bitfield. The helper preserves its register
contract and handles the move's full 16-bit index.

This contact rule was checked against the [Pokemon Showdown move
implementation](https://github.com/smogon/pokemon-showdown/blob/master/data/moves.ts),
whose Shell Side Arm handler sets contact for its physical version. The
project's existing category-selection and tie rules are unchanged.

### Avalanche doubled without taking a hit

`BattleConditionalBoost_Core` checked whether the opponent had acted and had
a last-used move. Status moves such as Splash, misses, hits absorbed by an
ability and Substitute damage all satisfied that check. The move description
requires the user to be hit first.

Avalanche now reads the user's existing direct-HP-hit category for the current
round. That history is reset each round and excludes indirect and Substitute
damage. The read restores the WRAM bank and preserves Avalanche's calculated
damage instead of replacing it with the incoming hit's damage.

## Test repairs

- Celadon and decoration-shop checks pinned `wCurBox` to an obsolete absolute
  RAM address. Scratch memory before `wGameData` can move while serialized save
  offsets remain fixed. The checks now guard its saved offset, `0x6f3`, retain
  the shop scratch-alias check, and verify event flags cannot overlap it.
- The legacy coin-wish fixture did not initialize its Key Item pocket. The
  well's newer Star Shard branch could run instead. It now starts with an
  explicitly empty Key Item pocket; the separate Star Piece quest tests remain.

## Reproductions and verification

The two new YAML groups contain 25 native battle cases. On the saved pre-fix
debug ROM, 15 fail and 10 controls pass, with no test errors. All 25 pass on
the rebuilt ROM. Cases cover both battlers, Iron Barbs, Rocky Helmet, AI risk
scoring, Klutz, successful hits, status moves, misses, Substitute, Water Absorb,
and hit-history reset between rounds.

Both release and debug ROMs pass 5,870 Shell Side Arm category/contact checks
and 168 Avalanche hit-history/damage-boundary cases each. The latter include
wrong-side history, both action orders, high damage saturation and bank
restoration. These routine checks are included in `make test-audit-state`;
the YAML cases are picked up by the ordinary battle runner.

The final release and debug ROMs both build successfully. The final debug ROM
passes all 3,356 cases in the existing suite plus every-move, every-effect and
every-ability sweeps and the 25 new regressions, with no failures, errors or
skips. Final static checks also pass: 45,418 game-data invariants, 442 moves,
595 trainer parties, 185 save-layout/recovery checks, 10,194 resource/audio
checks, and outdoor trainer-sprite packing.

The expanded sweep started before the fixes also completed: all 25,132 cases
passed, with zero failures, errors or skips. It covered ability suppression
and bypass, reflection, move outcomes, held items, hit reactions, multi-hit
combinations, 256 interaction stress cases and long battles. This run used
the first-pass ROM (`c02a95b8aed3`); the final 3,356-case run used the rebuilt
ROM (`659fc3681c67`). The new focused regressions expose the two defects
that those existing matrix cases did not detect.

Additional native suites passed for Celadon trades/vending/PP MAX (67 checks),
decoration stock/money/ownership (1,469), coin wishes (158), Star Piece wishes
(164), fishing boats (218), fishing-cove people (321), fishing-cove dialogue (370), fishing contests (2,159),
Jasmine's medicine quest (98), Riolu's 16 facing/animation phases,
Phantump/Trevenant (63), Pokedex save upgrades (43), and reminder/Repel/repeat-item
behavior (8,874).

The pickup-flag scan found only intentional shared pickups between the normal
and Bug Contest versions of National Park. No map/sprite gameplay change was
needed from these checks.

Detailed builds, reproductions and test output are under
`.tmpbuild/second-audit/`. Baseline ROM copies are kept there with matching
symbol files. Tests use private emulator memory, without opening player saves.

This remains targeted source/data and emulator coverage, rather than a manual
campaign playthrough or hardware certification.
