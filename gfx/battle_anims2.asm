; Animation object graphics that no longer fit in bank21.
; AnimObjGFX rows are dba (bank-aware), so these can live anywhere.

SECTION "Battle Anim GFX 2", ROMX

; ported from mae-pokeorange
AnimObjTauntGFX:      INCBIN "gfx/battle_anims/taunt.2bpp.lz"

AnimObjWoodHammerGFX: INCBIN "gfx/battle_anims/wood_hammer.2bpp.lz"

; October move graphics (bank-aware AnimObjGFX entries).
AnimObjCottonGFX: INCBIN "gfx/battle_anims/cotton.2bpp.lz"
AnimObjLavaRocksGFX: INCBIN "gfx/battle_anims/lavarocks.2bpp.lz"
AnimObjSmallExplosionGFX: INCBIN "gfx/battle_anims/smallexplosion.2bpp.lz"
AnimObjRecycleGFX: INCBIN "gfx/battle_anims/recycle.2bpp.lz"
