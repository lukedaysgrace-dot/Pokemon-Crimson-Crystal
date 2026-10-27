Cerulean Cave restores the three-floor dungeon at Route 4 (34, 3).

All three floor layouts and the Cavern graphics/metatiles come directly from
[pret/pokered](https://github.com/pret/pokered), matching international Red/Blue.
Each floor is the original 15 by 9 blocks (30 by 18 movement tiles), with the
original border block, ladders, water, raised platforms, and two exit tiles.
The dedicated tileset pads Red's 80 graphic tiles to this engine's 256 slots;
the original pixel data and block IDs are unchanged. Crystal palettes color the
cave brown and the water blue. The water uses Red's rotating tile animation.
Collision is converted from Red's quadrant graphic IDs, including its tile-pair
rules: raised platforms meet the low ground and water only through stairs.

The existing nine item balls and eight hidden items retain their item types,
quantities, scripts, and save flags. Their positions are fitted to the restored
terrain. No Red/Blue item definitions are imported. The extra Dusk Stone already
present in this project is retained.

Every floor plays the original Red/Blue Dungeon1 score (tempo 144), ported from
`audio/music/dungeon1.asm` with all four channels, notes, loops, envelopes,
vibrato, channel-1 pitch offset, waveform, and matching noise instruments.
This is a dedicated music ID and does not replace other caves' music.

Regenerate the imported assets from a local pokered checkout with:
`python3 tools/import_cerulean_cave.py /path/to/pokered`.
`python3 tools/test_cerulean_cave.py` verifies the original map/graphic hashes,
retained rewards, warp connections, and item/Mewtwo reachability.

The entrance requires both Mew's caught Pokedex flag and Mew in the current party.
There is no permanent unlock flag: every entry checks the current party. Route 4
warp 2 is an exit anchor on ordinary floor; the cave mouth itself uses a coordinate
script so an automatic warp cannot bypass the barrier.

Mewtwo occupies its original Red/Blue B1F position (27, 13). The existing level-70,
guaranteed-held-item encounter, dialogue, and EVENT_SILVER_CAVE_ROOM_2_MEWTWO
remain intact, preserving an existing save's encounter state.

The knockback sound ports the noise-channel effect used by Glare in
[pokered](https://github.com/pret/pokered/blob/master/audio/sfx/not_very_effective.asm),
with the move's original SFX tempo modifier.
