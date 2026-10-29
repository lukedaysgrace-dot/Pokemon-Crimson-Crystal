# Restored Burned Tower Firebreathers

Dick and Ned occupy their original Gold/Silver positions on Burned Tower 1F,
before and after the rival encounter. Their original teams and dialogue are
restored: Dick has Charmeleon Lv17; Ned has Koffing Lv15, Growlithe Lv16, and
Koffing Lv15. Existing trainer IDs retain their values; the restored parties
are appended to the Firebreather group.

Dick's original approach trigger at (8,1) works in every tower scene. Talking
to him also starts the battle. Both trainers use the Firebreather overworld
sprite. Winning replaces Dick's red appearance with a white/gray Firebreather
ashes appearance and retains his post-battle text.
The existing defeat flag controls this appearance on every map entry; the
ashes visibility flag is recomputed, so a new game is not required. His ashes stay
at the original post-battle position (8,2). Losing does not transform him.

The tower supplies the original G/S gray palette in its silver/emote slot;
other maps retain their current palettes. The Crystal rival, hole, Eusine,
Morty, and basement progression remain in place.

Native encounter regression checks: `python3 tools/battletest/burned_tower_checks.py`
after `make debug`. Tests use private emulator state and do not open player saves.
