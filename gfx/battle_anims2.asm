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
AnimObjSacredFireCenterGFX: INCBIN "gfx/battle_anims/sacred_fire_center.2bpp.lz"

SECTION "Sour Apple Animation Graphics", ROMX
AnimObjLeafStormGFXSourApple: INCBIN "gfx/battle_anims/leafstorm_sour_apple.2bpp.lz"
AnimObjSmokePuffBigGFXSourApple: INCBIN "gfx/battle_anims/smokepuffbig_sour_apple.2bpp.lz"
AnimObjVortexGFXSourApple: INCBIN "gfx/battle_anims/vortex_sour_apple.2bpp.lz"
AnimObjSwirlGFXSourApple: INCBIN "gfx/battle_anims/swirl_sour_apple.2bpp.lz"
AnimObjShadowSneakGFXSourApple: INCBIN "gfx/battle_anims/shadow_sneak_sour_apple.2bpp.lz"

SECTION "Creative Move Graphics", ROMX
AnimObjCreativeAppleGFX: INCBIN "gfx/battle_anims/creative_apple.2bpp.lz"
AnimObjGigatonHammerGFX: INCBIN "gfx/battle_anims/gigaton_hammer.2bpp.lz"
AnimObjInfestationBugGFX: INCBIN "gfx/battle_anims/infestation_bug.2bpp.lz"
