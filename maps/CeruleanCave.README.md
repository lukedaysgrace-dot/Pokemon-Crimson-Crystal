Cerulean Cave restores the three-floor dungeon at Route 4 (34, 3).

The floor layouts, cave graphics, collision data, and item positions are adapted
from [Polished Crystal v2.2.0](https://github.com/Rangi42/polishedcrystal/tree/v2.2.0).
The cave has a dedicated tileset; existing caves and Route 4 blocks are unchanged.
The original tileset's 96 tiles per VRAM bank were padded to this engine's 128,
and its implicit bank/palette assignments were converted to per-tile attributes.

The entrance requires both Mew's caught Pokedex flag and Mew in the current party.
There is no permanent unlock flag: every entry checks the current party. Route 4
warp 2 is an exit anchor on ordinary floor; the cave mouth itself uses a coordinate
script so an automatic warp cannot bypass the barrier.

Mewtwo's existing level-70, guaranteed-held-item encounter is moved from Silver
Cave Room 2 to Cerulean Cave B1F. It keeps EVENT_SILVER_CAVE_ROOM_2_MEWTWO so an
existing save's encounter state is preserved.

The knockback sound ports the noise-channel effect used by Glare in
[pokered](https://github.com/pret/pokered/blob/master/audio/sfx/not_very_effective.asm),
with the move's original SFX tempo modifier.
