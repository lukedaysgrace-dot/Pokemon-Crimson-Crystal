# Native GIF sprite assets

8 unique frames, each 56 x 56 pixels. Sheets are 56 x 448, ordered top to bottom.
`front_lossless.png` preserves every original color and pixel: enlarging each
frame exactly 10x recreates the source GIF. No cropping or smoothing was used.

`front.png` is the four-color game version. Two stray colors were normalized:
(160,205,93) -> green (66,206,90), (196,54,45) -> red (209,40,29).
This changes 80 color values across the 8 unique frames, retaining every pixel
position, outline, and motion. Game Boy hardware further quantizes RGB to 5 bits.

`anim.asm` preserves all 16 source holds and their original frame order. Durations
use cumulative rounding at the Game Boy's 59.7275 Hz; see timing.json for details.
It plays one 2.65-second source cycle and ends normally so gameplay can continue.
The GIF loops forever; replaying in game is controlled by the calling game code.
The game's slow animation mode scales timings as usual.

`preview.gif` is the lossless 56x56 animation with the original GIF timing.
`preview_4x.gif` is an enlarged nearest-neighbor preview.

For this repository's Pokemon frontpic pipeline, copy front.png and anim.asm to
the intended species folder. The included front.dimensions, frames.asm,
bitmask.asm, front.gbcpal, raw front.2bpp, front.animated.2bpp, and tilemap are
matching generated assets. The base frontpic dimensions must be 7x7 tiles.
No existing species or ROM was changed; no species slot was specified.

Validated: exact 10x source reconstruction, all generated 2bpp frames decoded
through the generated frame/bitmask data, and exact preview frame order/timing.
The animation uses 114 tiles, fitting within the first 128-tile VRAM block.
Emulator playback was not tested.
