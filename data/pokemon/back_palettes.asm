; Back sprite palettes for Pokémon whose back pic uses colors that don't
; appear on their front pic.
;
; Normally a species has exactly one palette, generated from its front.png,
; and the back pic is drawn with it. That breaks when the two pics aren't
; colored alike (e.g. Finizen and Palafin have pink/red on the front only).
;
; Each entry is a normal palette followed by a shiny palette, two colors
; apiece, matching the layout of PokemonPalettes. The normal palette is
; generated from back.png, so editing the sprite updates it automatically.
; Entries are hooked up in GetBackpicPalettePointer (engine/gfx/color.asm).

FinizenBackpicPalette:
INCBIN "gfx/pokemon/finizen/back.gbcpal", middle_colors
INCLUDE "gfx/pokemon/finizen/back_shiny.pal"

PalafinBackpicPalette:
INCBIN "gfx/pokemon/palafin/back.gbcpal", middle_colors
INCLUDE "gfx/pokemon/palafin/back_shiny.pal"
