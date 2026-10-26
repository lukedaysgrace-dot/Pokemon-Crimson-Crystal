# Lighthouse timing correction

The original audit assigned Lighthouse trainers before Chuck and incorrectly described the Lighthouse as available before Morty. That overlooked Jasmine's entrance scene/object and the Secretpotion handoff. The author identified the mistake; all campaign simulations, databases, charts, recommendations and the ZIP have been regenerated with corrected timing.

## Actual sequence and modeled route

- Jasmine explains Amphy's sickness outside and blocks the doorway while waiting for medicine. Source: [maps/OlivineCity.asm:25](../../../maps/OlivineCity.asm#L25), [maps/OlivineCity.asm:74](../../../maps/OlivineCity.asm#L74), [maps/OlivineCity.asm:496](../../../maps/OlivineCity.asm#L496).
- Cianwood's pharmacist supplies the Secretpotion after that explanation: [maps/CianwoodPharmacy.asm:13](../../../maps/CianwoodPharmacy.asm#L13).
- Delivering it outside sets `EVENT_JASMINE_RECEIVED_SECRETPOTION`, after which Jasmine enters the Lighthouse: [maps/OlivineCity.asm:92](../../../maps/OlivineCity.asm#L92).
- **Corrected default:** Cianwood trip → Chuck → return with medicine → Lighthouse → Jasmine. This is a route assumption, not a claim that the medicine script checks Chuck's badge.
- **Permitted alternative:** collect the medicine and return/climb before Chuck. The `lighthouse_before_chuck` scenario compares that legal route, with Cianwood events preceding the climb. Earliest Lighthouse access is therefore after Surf/the Cianwood trip, not before Morty.

## EXP and revised assessment

The Lighthouse contains **11 distinct trainer battles, totaling 30,804 solo-equivalent Hard EXP**. The three ordinary Olivine Gym trainers add **13,928**, for **44,732** if all 14 battles are fought. This is battle stock, not an EXP award to every party member; participant floors and cap clipping still apply.

The original published typical/equal-rotation Jasmine levels were four **31/31/30/30** and six **30/30/30/30/30/24**. Those values are obsolete. The corrected results below show that four members can approach Jasmine naturally; most do not need to hit 34 exactly for the segment to be healthy. The six-member party is more sensitive to its undertrained Slow-growth recruit and the EXP reserved from Chuck.

| Playstyle | Team | Chuck: corrected default | Jasmine: Lighthouse after Chuck | Jasmine: Lighthouse before Chuck | Default Jasmine selected trainer stock |
|---|---|---|---|---|---|
| typical | 4 | 30/30/30/30 | 33/32/32/32 | 31/31/30/30 | 30,566 |
| typical | 6 | 28/28/28/27/29/21 | 31/30/30/29/32/24 | 30/30/30/30/30/24 | 30,566 |
| thorough | 4 | 30/30/30/30 | 34/33/33/32 | 31/31/31/31 | 42,286 |
| thorough | 6 | 30/30/30/30/30/25 | 32/32/33/32/32/28 | 31/30/30/30/31/27 | 42,286 |
| completionist | 4 | 30/30/30/30 | 34/33/33/33 | 31/30/31/31 | 44,732 |
| completionist | 6 | 30/30/30/30/30/27 | 32/32/33/32/32/30 | 31/30/31/30/30/29 | 44,732 |

All rows use equal KO rotation, declared travel assumptions and the same staggered cohorts; they are scenarios, not measured player telemetry or guaranteed combat outcomes.

**Recommendation withdrawn:** relocating Rosie, Dahlia or Ernest into Jasmine's segment. The intended route already puts the whole Lighthouse there. Jasmine is downgraded from a proposed immediate local fix to a full-team distribution/playtest check. Do not lower her cap merely to improve an exact-cap statistic when four-member teams already finish close to it. The cap32 and ordinary-gym +3 trials are retained as experiments, not endorsed changes.

This correction does not erase the separately measured late Kanto/post-League deficits or the independently verified early Eusine trigger. No gameplay files were changed.
