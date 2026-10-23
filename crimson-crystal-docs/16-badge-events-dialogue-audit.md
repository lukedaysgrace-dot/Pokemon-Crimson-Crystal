# 16-badge campaign: events, flags, and dialogue audit

Audit date: October 14, 2026. The original findings below describe the source before the requested fixes. Their line references may move as the implementation changes.

## Resolution

October 22 cap update: earning Blue's Earth Badge as the sixteenth badge now
removes progression-based level caps. The first League and all postgame fights
use ordinary leveling. Cap schedules mentioned in the historical findings below
describe the earlier implementation.

The requested fixes are implemented. The current campaign rules are documented in [league-progression.md](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/crimson-crystal-docs/league-progression.md:1).

- Blue remains on Cinnabar below fifteen badges, including migrated saves. His departure, gym battle and map visibility use the same requirement. Earned badges are preserved.
- Only Blue retains a gym-specific badge requirement. The extra prerequisite checks and refusal speeches for the other seven Kanto leaders were removed at the user's request. Travel gates remain: Saffron follows the early Kanto milestones, and the southern roads follow the middle leaders. Blue asks for the Kanto gym leaders to be defeated and greets the player as JOHTO boy or girl according to the saved gender.
- Blue's Champion title and premature rematch advice, Irwin's ship assumptions, Route 5's blocker explanation, and Surge's incorrect speed-reward claim are corrected.
- Silver's Mt. Moon/Victory Road dialogue follows the new order. Dragon's Den training stays during Kanto. Green and cloaked Blue refer to the Lance rematch that actually unlocks them.
- Both wings require all eight Johto badges, with no Kanto badges or League victory required. The Rainbow Wing sage retains the ownership check for Raikou, Entei and Suicune, preserving Ho-Oh's three-beast requirement. Silver Wing inventory failures remain retryable.
- Crystal's call now rings on leaving Erika's gym, and the Rainbow Badge unlocks Mew's appearance. A cape victory that completes the Mt. Silver requirements queues Oak's invitation; losses retain the retry and use appropriate dialogue.
- Johto phone trainers' final tiers follow League victory plus Falkner's rematch, independently of early Kanto power restoration.
- Regional radio recognition, Buena gossip and improved rooftop stock now match Kanto access. Oak reads the actual Kanto badge byte for regional progress.
- Existing HM permissions, full obedience at Rising Badge, early Johto Rocket milestones and the post-League rematch/Mt. Silver structure are retained deliberately. Badge stat and type-damage bonuses were subsequently removed at the user's request, including the matching claims by Falkner, Whitney, Jasmine, Pryce, Brock, Lt. Surge and Sabrina. The audit findings below describe the original pre-fix behavior.
- The public guide is regenerated, including its previously stale Kanto encounter levels and the current cap schedule. Event IDs and save layout remain unchanged.

The original audit is retained below as the rationale and scenario checklist.

## What is already implemented

The current project already describes and implements **Johto → Kanto → Victory Road → first Elite Four → Johto gym rematches → Mt. Silver**. See [crimson-crystal-docs/league-progression.md:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/crimson-crystal-docs/league-progression.md:1).

Repository-wide searches covered 403 map-script files and 1,839 assembly files under engine, data, home, mobile, and constants. I traced matches for badge bytes/counts, individual badge flags, League/Hall of Fame flags, Kanto access, ship gifts, rematches, and relevant dialogue. This is static source inspection; I did not play through every map or execute the compiled-ROM tests. Physical shortcuts and presentation still need playtesting.

**Do not replace every mention of “eight” with “sixteen.”** Eight Johto badges and eight Kanto badges remain correct regional counts.

## A. Concrete leftovers to change

### A1. Blue calls the player a Champion before the first League win

- Scenario: the first Viridian Gym battle, which is now part of the main badge challenge.
- Location: `LeaderBlueBeforeText`, [maps/ViridianGym.asm:102](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianGym.asm:102).
- The ending is “Ready, JOHTO CHAMP?”
- The preceding claim that you conquered Johto's gyms is correct; the Champion title assumes the old Johto-first League order.
- Change the title to something such as “JOHTO challenger,” or branch on `EVENT_BEAT_ELITE_FOUR` if old-save/post-League versions should retain it.

### A2. Blue directs you to rematches before they unlock

- Scenario: immediately after receiving the Earth Badge.
- Location: `LeaderBlueAfterText`, [maps/ViridianGym.asm:153](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianGym.asm:153).
- He says the Johto leaders want rematches and tells you to start with Falkner.
- Actual Falkner requirement: `EVENT_BEAT_ELITE_FOUR`, [maps/VioletGym.asm:49](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletGym.asm:49).
- Change Blue's first-victory advice to finish collecting any missing badges and then challenge the League. Mention Falkner after the League, or condition the advice on the League flag.
- Blue is not explicitly required to be the final Kanto badge by his battle script, so avoid unconditionally claiming the player has sixteen badges here.

### A3. Irwin's Vermilion gossip assumes a ship arrival

- Scenario: reaching Vermilion overland and receiving Irwin's gossip before taking any voyage.
- Trigger: `ENGINE_FLYPOINT_VERMILION` in [engine/phone/scripts/irwin_gossip.asm:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/phone/scripts/irwin_gossip.asm:1).
- Text: `UnknownText_0x643d4`, [data/phone/text/irwin_caller.asm:116](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/irwin_caller.asm:116), claims he watched the player boarding a ship.
- Visiting Vermilion sets a Fly point; it does not prove any voyage happened. The intended route reaches Vermilion before Surge's prepaid voyage.
- Change the text to observing your Kanto travels, or gate the ship version on actual ship progress.

### A4. Irwin's train-pass gossip also assumes a previous voyage

- Scenario: collecting Copycat's train pass without having sailed.
- Trigger: `EVENT_GOT_PASS_FROM_COPYCAT`.
- Text: `UnknownText_0x64448`, [data/phone/text/irwin_caller.asm:130](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/data/phone/text/irwin_caller.asm:130), recalls your departure on the ship.
- Receiving the pass does not prove a ship trip.
- Rewrite that recollection or use a voyage-dependent version. Review together with A3.

### A5. Route 5's blocker gives an outdated reason after power is restored

- Scenario: `EVENT_RETURNED_MACHINE_PART` is set but `EVENT_BEAT_MISTY` is not.
- Script: [maps/Route5.asm:10](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route5.asm:10) requires both milestones to remove this blocker.
- Dialogue: [maps/Route5.asm:33](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route5.asm:33) always says the road is closed until the Power Plant problem is solved.
- Add a second explanation for the power-restored/Misty-unbeaten state, or align the actual condition with the reason given.
- This NPC stands at the Underground Path entrance. Do not assume this condition also locks the separate Saffron gate.

### A6. Public documentation still describes the old campaign/caps

- Source: [crimson-crystal-docs/game_updates.json:148](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/crimson-crystal-docs/game_updates.json:148) says Johto → League → Kanto, League cap 57, and Kanto caps 58–73.
- Generated copy: [docs/updates.html:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/docs/updates.html:1) contains that same outdated description.
- Current code: [engine/pokemon/experience.asm:104](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/pokemon/experience.asm:104) uses Kanto caps 50–69, then League cap 73 at sixteen badges.
- Update the JSON and regenerate the documentation. The dedicated league-progression document is already aligned with the new campaign.

## B. Progression decisions and scenarios to review

These are not all bugs. They are consequences of moving Kanto before the first League victory.

| # | Scenario | Current behavior and decision |
| --- | --- | --- |
| B1 | Completing Johto and entering Kanto | The southern Reception Gate officer accepts at least eight **total** badges, despite naming Johto. Review whether this should explicitly require the complete Johto badge byte, especially for migrated saves. It must continue allowing the eastern Kanto route before sixteen badges. [maps/VictoryRoadGate.asm:45](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoadGate.asm:45) |
| B2 | Kanto gym order and Hard Mode | Most leaders check their own badge, not a list of prerequisite leaders. The cap table assumes Brock → Misty → Surge → Erika/Janine/Sabrina → Blaine → Blue. Decide whether that is enforced order or suggested order. If Kanto is open, fixed boss levels and a total-count cap need to support additional orders. [engine/pokemon/experience.asm:104](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/pokemon/experience.asm:104) |
| B3 | Misty and the Machine Part sequence | Power Plant manager → Cerulean Rocket scene → Route 24 grunt/Machine Part → Misty's date → Misty returns to gym. Route 5's Underground Path NPC needs power restored **and** Misty beaten; Route 9's sleeping trainers use Misty's event. Check whether other routes bypass this intended sequence. [maps/PowerPlant.asm:137](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/PowerPlant.asm:137), [maps/CeruleanGym.asm:16](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeruleanGym.asm:16), [maps/Route25.asm:57](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:57), [maps/Route9.asm:333](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route9.asm:333) |
| B4 | Early Saffron/Celadon access | The Route 5 Saffron gate has dialogue and warps, but no milestone check. Sabrina and Erika also do not require Surge's badge. Verify the actual map tiles/route access if Surge is supposed to precede them; shared middle caps alone do not enforce that. [maps/Route5SaffronGate.asm:9](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route5SaffronGate.asm:9), [maps/SaffronGym.asm:14](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SaffronGym.asm:14), [maps/CeladonGym.asm:14](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeladonGym.asm:14) |
| B5 | Opening the southern coast | Janine's defeat removes Route 19 rocks and Viridian's battling-trainer blockade toward Route 1/Pallet. That can expose Cinnabar and Blue while other Kanto gyms remain unfinished. Decide whether this freedom is intended. [maps/Route19.asm:19](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route19.asm:19), [maps/ViridianCity.asm:355](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianCity.asm:355) |
| B6 | Blaine versus Blue | Talking to Blue on Cinnabar makes him available in Viridian. His script does not require Blaine or seven Kanto badges. Verify whether a player can fight Blue before Blaine/other gyms, and whether caps and advice support it. [maps/CinnabarIsland.asm:26](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CinnabarIsland.asm:26), [maps/ViridianGym.asm:13](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianGym.asm:13) |
| B7 | Silver's character arc | Mt. Moon is now before Victory Road. Mt. Moon's self-improvement battle sets `EVENT_BEAT_RIVAL_IN_MT_MOON`; Victory Road later still uses the `RIVAL1_5_*` teams and has dialogue about the dragon master's lesson. Review the order of his growth, teams, and win/loss/after-battle text. Class names alone are not a bug. [maps/MountMoon.asm:20](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/MountMoon.asm:20), [maps/VictoryRoad.asm:62](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:62), [maps/VictoryRoad.asm:346](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:346) |
| B8 | Silver in Dragon's Den | Winning at Mt. Moon makes Silver appear on Tuesdays/Thursdays and changes the shrine elder's text, without a League requirement. Those scenes can now happen during the main Kanto challenge. Keep them there or add the milestone you want. [maps/DragonsDenB1F.asm:26](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DragonsDenB1F.asm:26), [maps/DragonShrine.asm:194](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DragonShrine.asm:194) |
| B9 | Crystal's final call and Mew | Earth Badge queues the cape call and unlocks the Route 25 Mew event; neither requires a League win or all sixteen badges. The Crystal battle and level-60 Mew can happen before the League. Decide whether the trigger should remain “beat Blue,” become “all badges,” or become post-League. Preserve loss/retry/capture/escape states if moving it. [maps/ViridianGym.asm:35](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianGym.asm:35), [maps/ViridianCity.asm:21](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ViridianCity.asm:21), [maps/Route25.asm:113](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:113), [maps/Route25.asm:241](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:241), [maps/Route25.asm:284](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:284) |
| B10 | Ho-Oh unlock timing | The Rainbow Wing sage depends on a first League victory plus the beasts check. This now moves normal Ho-Oh access until after the entire sixteen-badge campaign. Ho-Oh is level 60 against a first post-League cap of 77. Decide whether the timing and level still fit. [maps/TinTower1F.asm:29](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TinTower1F.asm:29), [maps/TinTowerRoof.asm:25](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/TinTowerRoof.asm:25) |
| B11 | Lugia unlock timing | Pewter's Silver Wing is available on arrival without a League check. Lugia at level 60 can therefore become available early in Kanto while the cap is 50–54. Decide whether the gift, encounter timing, or level should move. This asymmetry with Ho-Oh is a campaign choice. [maps/PewterCity.asm:24](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/PewterCity.asm:24), [maps/WhirlIslandLugiaChamber.asm:10](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/WhirlIslandLugiaChamber.asm:10) |
| B12 | Johto phone rematches | Their League tiers are delayed until after all sixteen badges. Kanto power is usually restored beforehand, so the formerly separated League/power milestones can bunch up after the first championship. Review the unlocks, fight counters, rewards, and levels for the full list below. |
| B13 | Places and People radio | Kanto gym leaders stay in the hidden-name list until the Hall of Fame. With all sixteen badges already held then, the intermediate “BeatE4, but not BeatKanto” state normally disappears. Decide whether the show should recognize Kanto leaders during your Kanto campaign. [engine/pokegear/radio.asm:1135](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/pokegear/radio.asm:1135), [data/radio/pnp_hidden_people.asm:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/data/radio/pnp_hidden_people.asm:1) |
| B14 | Buena's phone pool | Three extra gossip options depend on `EVENT_BEAT_ELITE_FOUR`, including a Lavender Radio Tower vacation story. These now become available after sixteen badges. Keep them post-Champion or unlock regional gossip on Kanto access. [engine/phone/scripts/buena.asm:68](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/phone/scripts/buena.asm:68) |
| B15 | Goldenrod rooftop sale | Its better inventory still requires the Hall of Fame, moving access to after sixteen badges. Decide whether these items should be sold during Kanto instead. [engine/items/mart.asm:85](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/items/mart.asm:85), [data/items/rooftop_sale.asm:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/data/items/rooftop_sale.asm:1) |
| B16 | Obedience and badge rewards | Rising Badge still gives full traded-Pokémon obedience at Johto badge eight. HM permissions and stat boosts are still Johto-based; Kanto badges add type boosts. Keep this deliberately, or redesign rewards and update their explanatory dialogue together. See section E. |
| B17 | Postgame route | Mt. Silver now needs sixteen badges + first League clear + Clair rematch + Crystal cape victory. League rematches additionally use Clair's flag, while Green → cloaked Blue → Pallet Red follows the Lance-rematch event. Decide whether that is the desired postgame order, and make advice describe it consistently. See section D. |

**Physical-order qualification:** B2–B6 identify script prerequisites and possible sequence risks. They are not a claim that every proposed shortcut has been demonstrated in the running game. Validate map collision, Surf routes, gates, and Fly destinations before treating any bypass as confirmed.

### All Johto phone trainers affected by the later League milestone

The following map locations contain direct `EVENT_BEAT_ELITE_FOUR` rematch checks. “Power tier” means the later fight-count branch also checks `EVENT_RESTORED_POWER_TO_KANTO`; the full fight-counter logic matters, so power restoration alone does not necessarily unlock it in a fresh save.

| Trainer | Script location | Later power tier |
| --- | --- | --- |
| Joey | [maps/Route30.asm:72](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route30.asm:72) | No |
| Wade | [maps/Route31.asm:59](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route31.asm:59) | No |
| Ralph | [maps/Route32.asm:200](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:200) | Yes |
| Liz | [maps/Route32.asm:334](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route32.asm:334) | No |
| Anthony | [maps/Route33.asm:48](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route33.asm:48) | Yes |
| Todd | [maps/Route34.asm:122](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:122) | Yes |
| Gina | [maps/Route34.asm:247](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route34.asm:247) | Yes |
| Arnie | [maps/Route35.asm:163](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route35.asm:163) | Yes |
| Alan | [maps/Route36.asm:203](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route36.asm:203) | Yes |
| Dana | [maps/Route38.asm:71](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:71) | Yes |
| Chad | [maps/Route38.asm:207](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route38.asm:207) | Yes |
| Tully | [maps/Route42.asm:130](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route42.asm:130) | Yes |
| Brent | [maps/Route43.asm:83](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:83) | Yes |
| Tiffany | [maps/Route43.asm:214](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route43.asm:214) | Yes |
| Vance | [maps/Route44.asm:53](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:53) | Yes |
| Wilton | [maps/Route44.asm:197](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route44.asm:197) | Yes |
| Parry | [maps/Route45.asm:179](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route45.asm:179) | Yes |
| Erin | [maps/Route46.asm:57](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route46.asm:57) | Yes |
| Jack | [maps/NationalPark.asm:104](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/NationalPark.asm:104) | Yes |
| Huey | [maps/OlivineLighthouse2F.asm:51](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivineLighthouse2F.asm:51) | Yes |

Gaven/Beth on Route 26 and Reena/Jose on Route 27 have already been retargeted: initial → Surge's badge → first League win. See [maps/Route26.asm:62](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:62) and [maps/Route27.asm:97](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:97). These do not need the old power-restoration trigger restored.

## C. Main-campaign events already converted: retain and verify

| Scenario | Current implementation / files to review |
| --- | --- |
| First introduction to the gym challenge | Elm tells you to take the challenge and start in Violet, without a hardcoded eight-badge completion rule. You can optionally introduce the two-region goal here. [maps/ElmsLab.asm:1298](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ElmsLab.asm:1298) |
| Winning Johto badges six/seven | Seven Johto gym scripts count `VAR_BADGES` for Goldenrod/Radio Tower Rocket activation at totals six/seven. These are early-Johto milestones, not League requirements. Retain them unless changing the whole Johto story. [maps/VioletGym.asm:75](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VioletGym.asm:75) and corresponding ActivateRockets routines in Azalea, Goldenrod, Ecruteak, Cianwood, Olivine, Mahogany gyms. |
| Beating Clair, shrine quiz, receiving Rising Badge | Advice already points toward Kanto and all sixteen badges. Clair changes her advice once sixteen are owned. Check all three locations together: [maps/BlackthornGym1F.asm:109](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym1F.asm:109), [maps/DragonShrine.asm:477](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DragonShrine.asm:477), [maps/DragonsDenB1F.asm:241](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/DragonsDenB1F.asm:241). |
| Blackthorn gym guide and Pokémon Center | Already explain Kanto next and sixteen badges for the League. [maps/BlackthornGym1F.asm:399](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym1F.asm:399), [maps/BlackthornPokecenter1F.asm:24](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornPokecenter1F.asm:24). |
| Crossing Routes 27/26 | NPC and Route 27 house advice already explain both regions and sixteen badges. [maps/Route27.asm:421](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27.asm:421), [maps/Route26.asm:250](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route26.asm:250), [maps/Route27SandstormHouse.asm:39](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route27SandstormHouse.asm:39). |
| Reception Gate split | South accepts eight; east goes to Kanto; north requires sixteen. Guard-moved and side-guard-hidden flags preserve the movement state. [maps/VictoryRoadGate.asm:24](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoadGate.asm:24), [maps/VictoryRoadGate.asm:45](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoadGate.asm:45), [maps/VictoryRoadGate.asm:69](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoadGate.asm:69). |
| Flying to Indigo Plateau in an older save | Entrance trigger at the Elite Four stairs independently checks sixteen badges in every scene. [maps/IndigoPlateauPokecenter1F.asm:149](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IndigoPlateauPokecenter1F.asm:149), [maps/IndigoPlateauPokecenter1F.asm:378](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IndigoPlateauPokecenter1F.asm:378). |
| Beating Surge and receiving Elm's call | Thunder Badge triggers the invitation, with Vermilion's exit tile and normal phone handling as fallbacks. [maps/VermilionGym.asm:30](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionGym.asm:30), [maps/VermilionCity.asm:21](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionCity.asm:21), [engine/phone/scripts/elm.asm:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/phone/scripts/elm.asm:1). |
| Returning to Johto before earning a permanent ticket | Elm's call grants one prepaid Vermilion → Olivine voyage, including nonstandard weekdays. Fare is consumed on boarding; reminders do not grant another. [engine/phone/scripts/elm.asm:142](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/phone/scripts/elm.asm:142), [maps/VermilionPort.asm:49](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionPort.asm:49). |
| Receiving ticket and Master Ball | Both now require Surge, independently of League victory. Full-pocket retries preserve unclaimed gifts. [maps/ElmsLab.asm:115](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ElmsLab.asm:115), [maps/ElmsLab.asm:606](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ElmsLab.asm:606), [maps/ElmsLab.asm:619](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/ElmsLab.asm:619). |
| Port visibility / saving on a dock | Olivine callbacks derive sailing access from Surge, ticket, invitation, fare and first-voyage state. The old BEFORE/AFTER_HALL_OF_FAME event names are repurposed; do not judge their meaning from the names. [maps/OlivinePort.asm:19](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivinePort.asm:19). |
| First ship trip / granddaughter quest | First voyage can now begin from either port. Review initial destination, grandfather/girl/lazy sailor, arrival, cabin reset and Metal Coat reward as one state machine. [maps/OlivinePort.asm:43](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OlivinePort.asm:43), [maps/VermilionPort.asm:17](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionPort.asm:17), [maps/FastShip1F.asm:31](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShip1F.asm:31), [maps/FastShipB1F.asm:53](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipB1F.asm:53), [maps/FastShipCabins_SE_SSE_CaptainsCabin.asm:24](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SE_SSE_CaptainsCabin.asm:24), [maps/FastShipCabins_SW_SSW_NW.asm:80](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/FastShipCabins_SW_SSW_NW.asm:80). |
| Subsequent ship trips | Existing eastbound/westbound weekday and passenger branches remain relevant after the first voyage. Both port scripts own boarding eligibility and passenger resets. |
| Kanto map and Pokédex area display | Already unlock from the complete Johto badge byte, before the League. [engine/pokegear/pokegear.asm:744](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/pokegear/pokegear.asm:744), [engine/pokegear/pokegear.asm:2518](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/pokegear/pokegear.asm:2518). |
| Vermilion badge NPC / HP Up | Total-count branches recognize the Kanto stretch and sixteen-badge completion; first reward dialogue already sends you to the Elite Four. [maps/VermilionCity.asm:152](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionCity.asm:152), [maps/VermilionCity.asm:280](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionCity.asm:280). Consider a post-Champion alternate line if visited late. |
| Oak during Kanto | Has no-Kanto, partial-Kanto, sixteen-badges-before-League, Champion-needing-rematches, and Champion-needing-Crystal states. Already converted. [maps/OaksLab.asm:15](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OaksLab.asm:15). His partial-Kanto classification assumes the normal eight-Johto-first route because it uses total count. |
| First Victory Road rival fight | Intro already explicitly says both rivals earned sixteen badges and trained throughout Kanto. Review the remaining arc as B7, not just this intro. [maps/VictoryRoad.asm:324](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoad.asm:324). |
| First Elite Four and Lance | First boss levels and trainer data have already been moved to the sixteen-badge stretch. Current documented aces: Will 70, Koga 71, Bruno/Karen 72, Lance 73. [data/trainers/parties.asm:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/data/trainers/parties.asm:1), [maps/WillsRoom.asm:44](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/WillsRoom.asm:44), [maps/LancesRoom.asm:59](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LancesRoom.asm:59). |

## D. Post-League events and flags to review together

1. **First championship:** `EVENT_BEAT_ELITE_FOUR` is persistent story progress; `STATUSFLAGS_HALL_OF_FAME_F` is the separate engine flag. Both are set through the Hall of Fame sequence. Preserve their synchronization. The individual Will/Koga/Bruno/Karen/Lance victory events are reset when entering Indigo's Pokémon Center and are not substitutes for the persistent first-clear flag. [maps/HallOfFame.asm:25](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/HallOfFame.asm:25), [engine/events/halloffame.asm:13](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/events/halloffame.asm:13), [maps/IndigoPlateauPokecenter1F.asm:22](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IndigoPlateauPokecenter1F.asm:22).
2. **Falkner → Bugsy → Whitney → Morty → Chuck → Jasmine → Pryce → Clair rematches:** Falkner needs the first League win; each next leader requires the preceding rematch flag. TM rewards can take precedence over offering a rematch, so test unclaimed TM/full-pocket states as well as ordinary revisits. Sources are the eight original Johto gym map scripts.
3. **Route 23 League rematch blockade:** blocks after first League clear until Clair's rematch. Check both entrance doors, side approach, Fly arrival and older saves inside the building. [maps/Route23.asm:15](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route23.asm:15).
4. **Indigo rival rematch:** depends on Mt. Moon victory and Clair's rematch; records `EVENT_BEAT_RIVAL_AT_INDIGO_PLATEAU`. [maps/IndigoPlateauPokecenter1F.asm:43](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/IndigoPlateauPokecenter1F.asm:43).
5. **Elite Four stronger teams:** select using `EVENT_BEAT_CLAIR_REMATCH`. Verify first/second League entry chooses the intended party and dialogue. Sources: WillsRoom, KogasRoom, BrunosRoom, KarensRoom, LancesRoom.
6. **Oak's Mt. Silver permission:** requires total sixteen, first League win, Clair rematch, and Crystal cape victory. `EVENT_OPENED_MT_SILVER` removes the west Reception Gate blocker. The existing code checks the final chain flag, relying on normal progression to prove the preceding rematches. [maps/OaksLab.asm:25](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OaksLab.asm:25), [maps/VictoryRoadGate.asm:24](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VictoryRoadGate.asm:24).
7. **Oak call timing:** Clair, Hall of Fame, and Lance's rematch queue the special call in relevant ready states. The call text itself only invites you to the lab; Oak's lab performs the access check. If Crystal's cape victory is the last missing condition, Route 25 sets her victory flag without queuing Oak's call. Oak can still open Mt. Silver when visited, but review whether this completion order needs an immediate invitation too. [maps/BlackthornGym1F.asm:99](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/BlackthornGym1F.asm:99), [maps/HallOfFame.asm:44](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/HallOfFame.asm:44), [maps/LancesRoom.asm:73](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LancesRoom.asm:73), [maps/Route25.asm:269](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:269), [engine/phone/scripts/unused.asm:5](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/phone/scripts/unused.asm:5).
8. **Advice after first League win:** Hall of Fame now says to start with Falkner, and Oak has matching advice. Morty's “JOHTO CHAMPION” rematch line and Silver Cave's Champion references occur after the League, so they are compatible with the campaign. [maps/HallOfFame.asm:122](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/HallOfFame.asm:122), [maps/OaksLab.asm:225](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/OaksLab.asm:225), [maps/EcruteakGym.asm:403](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/EcruteakGym.asm:403), [maps/SilverCaveOutside.asm:145](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilverCaveOutside.asm:145).
9. **Green → cloaked Blue → Pallet Red:** beating rematch Lance clears `EVENT_GREEN_IN_ROUTE20`; Green unlocks cloaked Blue, who unlocks the Pallet Red fight. This is a separate optional chain from Mt. Silver's unlock. [maps/LancesRoom.asm:71](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/LancesRoom.asm:71), [maps/Route20.asm:45](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route20.asm:45), [maps/CinnabarIsland.asm:38](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CinnabarIsland.asm:38), [maps/PalletTown.asm:15](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/PalletTown.asm:15).
10. **Mt. Silver Red and repeated League clears:** `EVENT_BEAT_RED` permanently records the win and lifts the Hard Mode cap; `EVENT_RED_IN_MT_SILVER` is the respawning object flag cleared by Hall of Fame. `EVENT_BEAT_RED2` is the separate Pallet fight. Preserve this distinction. [maps/SilverCaveRoom3.asm:12](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/SilverCaveRoom3.asm:12), [maps/HallOfFame.asm:38](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/HallOfFame.asm:38), [engine/pokemon/experience.asm:73](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/pokemon/experience.asm:73).

## E. Badge mechanics that are separate from the League requirement

| Mechanic | Current behavior / source |
| --- | --- |
| Badge storage and count | Two regional bytes already support sixteen. `NUM_BADGES = NUM_JOHTO_BADGES + NUM_KANTO_BADGES`; `VAR_BADGES` counts both. No expansion of the save layout is needed simply to require sixteen. [constants/wram_constants.asm:244](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/constants/wram_constants.asm:244), [data/engine_flags.asm:46](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/data/engine_flags.asm:46), [engine/overworld/variables.asm:100](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/overworld/variables.asm:100). |
| Continue screen / trainer card | Continue count already reads both bytes; trainer card has Johto and Kanto pages. Verify the visible number at 8, 9, 15 and 16. [engine/menus/intro_menu.asm:621](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/menus/intro_menu.asm:621), [engine/menus/trainer_card.asm:606](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/menus/trainer_card.asm:606). |
| Hard Mode cap | Total badges 0–16, then consecutive Johto rematches after Hall of Fame with sixteen badges. Old Hall of Fame state with fewer badges still uses the badge table. Normal Mode remains uncapped. [engine/pokemon/experience.asm:41](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/pokemon/experience.asm:41). |
| HM permissions | Flash/Zephyr, Cut/Hive, Strength/Plain, Surf/Fog, Fly/Storm, Whirlpool/Glacier, Waterfall/Rising. If redistributing permissions into Kanto, check every route's travel dependencies before changing them. [engine/events/field_hm_interaction.asm:16](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/events/field_hm_interaction.asm:16), [engine/events/overworld.asm:717](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/events/overworld.asm:717). |
| Traded-Pokémon obedience | Hive 30, Fog 50, Storm 70, Rising full obedience. Kanto badges do not add stages. If changing this, update the gym speeches that promise those rewards. [engine/battle/effect_commands.asm:751](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/effect_commands.asm:751). |
| Stat boosts | Johto badges still provide the player boosts. Kanto leader speeches such as Surge's speed reward should be reviewed if you redesign rewards; the current stat routine reads Johto, not Kanto. This is an existing mechanics/dialogue mismatch rather than a League-access bug. [engine/battle/core.asm:7327](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/core.asm:7327), [maps/VermilionGym.asm:145](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionGym.asm:145). |
| Type boosts | Already read both regional badge bytes and the sixteen-entry type table. No automatic change needed. [engine/battle/misc.asm:145](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/battle/misc.asm:145), [data/types/badge_type_boosts.asm:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/data/types/badge_type_boosts.asm:1). |
| Fishing | Johto scales using Johto badges; Kanto uses its own badge count/tier offsets. Already supports the new Kanto curve. [engine/events/fish.asm:102](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/events/fish.asm:102), [engine/events/fish.asm:124](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/events/fish.asm:124). |
| Safari species gate | Five **Johto** badges unlock selected stronger Safari encounters. This is not an eight-badge League gate. Decide separately if moving Safari access. [engine/overworld/wildmons.asm:433](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/overworld/wildmons.asm:433). |
| Ordinary mart stock | Standard marts are authored inventories, not a universal eight-badge League check. The Hall of Fame-dependent rooftop sale is the relevant delayed stock branch found. |
| Hall of Fame PC / credits / legacy mobile | Remain attached to the actual first League victory; generally correct. Legacy mobile Hall of Fame checks are not an ordinary Kanto access gate. [engine/events/pokecenter_pc.asm:94](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/events/pokecenter_pc.asm:94), [engine/movie/credits.asm:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/engine/movie/credits.asm:1), [mobile/mobile_46.asm:1159](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/mobile/mobile_46.asm:1159). |

### Regional dialogue that is already safe

- Misty's date speech explicitly discusses eight **Johto** badges; her gym intro also names Johto. [maps/Route25.asm:697](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/Route25.asm:697), [maps/CeruleanGym.asm:240](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/CeruleanGym.asm:240).
- Vermilion's eight gyms/eight-badge conquest references are explicitly about **Kanto**. [maps/VermilionCity.asm:247](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionCity.asm:247), [maps/VermilionCity.asm:291](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/maps/VermilionCity.asm:291).
- Blackthorn's guide and Route 26 explicitly describe each region's eight gyms. Those are consistent with sixteen overall.
- Kanto gym guides' “CHAMP in making” and Sabrina's future Champion prediction fit a pre-League Kanto campaign.
- Blue's former championship, Trainer House's Champion from Pallet, and Viridian's reference to the Champion three years ago concern other characters/history; they are not assertions that the player already won.
- Generic Champion aspirations from Elm, Chad and trainers do not impose an eight-badge completion rule.
- Fuchsia's references to Koga joining the Elite Four remain valid.
- The ship's general badge/Johto-trainer compliments do not require an exact current badge count.

## F. Playtest checklist after making decisions

- [ ] Fresh Normal and Hard saves: finish Johto, receive Rising Badge, follow Clair's advice, enter mainland Kanto without the League or ship ticket.
- [ ] Fewer than eight badges: southern gate refusal; eight through fifteen: Kanto access but northern gate and Elite Four stairs refuse; sixteen: both admit.
- [ ] Talk to both northern guards from each direction; leave/reenter after they move; verify side guards and saved movement flags.
- [ ] Old save with Indigo Fly unlocked and fewer than sixteen badges; old gate-moved flag; old Hall of Fame flag; partial/mixed regional badge bytes.
- [ ] Kanto sequence attempts: skip Brock, leave Misty unchallenged after the date, try the Saffron gate, restore power before Misty, approach Rock Tunnel, take Surf/sea routes, fight Blue before Blaine. Compare reachable bosses to the current cap.
- [ ] All six orders of Erika/Sabrina/Janine, plus any additional order the maps actually allow.
- [ ] Receive Irwin's calls before any voyage, after visiting Vermilion, after receiving the train pass, and after the first League win.
- [ ] Surge's immediate Elm call and phone fallback; prepaid voyage on every weekday; decline boarding; save on each dock; consume fare once; repeated calls do not renew it.
- [ ] Elm gifts with full regular pocket / full key-item pocket; collect ticket and Master Ball on separate visits; return overland instead of sailing.
- [ ] First ship quest from either port; sail in both directions later; passenger resets and weekday eligibility.
- [ ] Silver at Mt. Moon before Victory Road; Dragon's Den on Tuesday/Thursday before the League; each starter-dependent team and loss/win dialogue.
- [ ] Earth Badge with missing other Kanto badges; Crystal call; cape battle loss/retry/win; Mew capture/escape; visit Oak before and after each milestone.
- [ ] Ho-Oh's wing/beasts/League requirements, early Pewter Silver Wing and Lugia; check levels against the Hard Mode cap.
- [ ] First League entry and victory; Oak's partial milestones; rematch chain beginning with Falkner, including unclaimed TM rewards.
- [ ] Route 23 post-League blockade from both doors, side approach and Fly; Indigo rival; stronger Elite Four teams after Clair.
- [ ] Mt. Silver only at the intended milestone; Red rematches after another Hall of Fame entry; cap lift follows Mt. Silver Red, not Pallet Red.
- [ ] Phone rematch fight counters with power restored before the League, including old saves with advanced counters.
- [ ] Map/Pokédex visibility, Continue count/trainer card, radio leader recognition, rooftop sale, and regenerated public guide.

Existing regression coverage: [tools/test_league_progression.py:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/tools/test_league_progression.py:1) and [tools/test_overworld_state.py:1](C:/Users/luked/OneDrive/Documents/GitHub/Pokemon-Crimson-Crystal/tools/test_overworld_state.py:1). Run against a newly built ROM and matching symbols after changes. The progression harness skips presentation and uses private state, so it supplements rather than replaces the dialogue/map playthrough above.

