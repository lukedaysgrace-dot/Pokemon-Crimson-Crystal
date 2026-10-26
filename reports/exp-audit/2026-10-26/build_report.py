"""Build readable reports from the frozen, independently verified audit data."""
import csv
import json
import math
import statistics
from collections import defaultdict
from model import *

def csvrows(name):return list(csv.DictReader((HERE/name).open(encoding='utf-8',newline='')))
def fmt(v):
    try:return f'{round(float(v)):,}'
    except (ValueError,TypeError):return str(v)
def lv(v):return '/'.join(map(str,v))
def table(headers,rows):
    clean=lambda v:str(v).replace('|',' / ').replace('\n',' ')
    return '\n'.join(['| '+' | '.join(headers)+' |','|'+'|'.join(['---']*len(headers))+'|']+['| '+' | '.join(clean(v) for v in row)+' |' for row in rows])+'\n'
def src(value):
    file,sep,line=value.rpartition(':')
    if not sep:return f'`{value}`'
    return f'[{value}](../../../{file}#L{line})'

def main():
    base=json.loads((HERE/'baseline_results.json').read_text())
    cov=json.loads((HERE/'coverage.json').read_text())
    native=json.loads((HERE/'native_verification.json').read_text())
    catalog=json.loads((HERE/'catalog_coverage.json').read_text())
    grind=csvrows('grinding_estimates.csv');trials=csvrows('hypothetical_changes.csv');bands=csvrows('sensitivity_bands.csv')
    route=csvrows('replacement_and_route_scenarios.csv');orders=csvrows('gym_order_summary.csv')
    get=lambda style,n,method='casual':base[f'{style}:{n}:{method}']
    at=lambda name,n=6,method='equal_rotation',style='typical':next(r for r in get(style,n,method) if r['milestone']==name)
    gr=lambda name,n=6,method='equal_rotation',style='typical':next(r for r in grind if r['milestone']==name and r['team_size']==str(n) and r['method']==method and r['playstyle']==style)
    tr=lambda proposal,name,n=6,method='equal_rotation',style='typical':next(r for r in trials if r['proposal']==proposal and r['milestone']==name and r['team_size']==str(n) and r['method']==method and r['playstyle']==style)
    b6=at('Blue');r6=at('Red Mt Silver');j6=at('Jasmine');j4=at('Jasmine',4)
    jasmine_gym_pool=sum(PARTIES[e['party_key']]['solo_hard_exp'] for e in EVENTS if e['map']=='OlivineGym' and not e['primary'])
    p=[]
    p.append(f'''# Pokémon Crimson Crystal — Hard Mode EXP and progression audit

Snapshot: **2026-10-26**, repository commit `734cf74a1a99df149419d769c748382ade811501`. No gameplay files were changed. All generated files and code are confined to this audit directory.

## Findings and scope

**The modeled unique-battle economy does not meet the requested smooth four-to-six-Pokémon progression goal across the whole campaign.** Four-member teams generally handle Johto's EXP better. The corrected Lighthouse-after-Chuck itinerary puts four members close to Jasmine's cap; the original audit overstated this local shortage. Six-member teams are more sensitive to recruitment and participation. Kanto and especially the post-League level ramp remain short even with balanced rotation. This is an EXP-budget finding, not a claim that every underleveled team loses its battles.

In the typical-route, balanced-rotation example, four members arrive at Jasmine at **{lv(j4['levels'])}** against cap 34; six arrive at **{lv(j6['levels'])}**. At Blue, the six-member party is **{lv(b6['levels'])}** against cap 69. Before Mt. Silver Red it is **{lv(r6['levels'])}** against ace 90. Actual Hard Mode's cap after badge 16 is **100**, not Red's or any rematch leader's ace.

There is also a verified combat/progression defect independent of EXP supply: **Eusine's five-Pokémon level 38–40 team can trigger at Ecruteak's `(36, 9)` with three badges, when the player's cap is 25.** The existing ROM reaches `startbattle` with `MYSTICALMAN/EUSINE2` under that state. Extra grinding cannot raise the player's ordinary level past 25 here.

This deliverable includes a complete inventory of the relevant source definitions, map references and encounter tables, plus reproducible scenarios. It is **not an exhaustive executable proof of map reachability or the globally smallest unavoidable trainer set**. The precise casual encounter rate is unmeasured. The route model, conditional maximum, minimum-route assumptions, and incomplete movement proof are stated explicitly below. The tables must not be read as measured player telemetry or guaranteed battle outcomes.

Start with this report; consult [BOSS_CATALOG.md](BOSS_CATALOG.md), [ZONE_REVIEW.md](ZONE_REVIEW.md), [PRIORITY_FIXES.md](PRIORITY_FIXES.md), and [README.md](README.md) for the detailed teams, every map, recommendations, and rerun instructions.

**Lighthouse correction:** Jasmine blocks entry until the Cianwood Secretpotion trip. The default now visits Cianwood, defeats Chuck, then climbs the Lighthouse before Jasmine. Returning with medicine before defeating Chuck is a permitted alternative, not a required ordering. The original pre-Chuck assignment and recommendation to move Lighthouse trainers have been withdrawn. See [LIGHTHOUSE_CORRECTION.md](LIGHTHOUSE_CORRECTION.md).

![Gym progression](01_gym_progression.png)

## What was verified

''')
    p.append(table(['Item','Coverage'],[[k,fmt(v)] for k,v in [('Species, with custom EXP yields/growth/stats/abilities',cov['species']),('Trainer party definitions',cov['party_definitions']),('Trainer Pokémon records',cov['trainer_pokemon']),('Map scripts and map headers',cov['map_scripts']),('Map connections and warp edges',cov['map_edges']),('Trainer/loadtrainer references',cov['trainer_script_references']),('Selected campaign encounter instances',cov['campaign_encounter_instances']),('Major/side boss encounter variants selected for the main starter',cov['boss_encounters']),('Primary campaign checkpoints',cov['primary_milestones']),('Grass/surf slots, all times and swarms',cov['grass_surf_slots']),('Map/time encounter tables, including Safari sub-tables',cov['grass_surf_map_time_tables']),('Fishing groups',cov['fishing_groups']),('Resolved rod/time slots',cov['fishing_time_slots']),('Headbutt/Rock Smash map slots',cov['tree_rock_slots']),('Contest slots',cov['contest_slots']),('Static encounter commands / expanded scripted wild instances',f"{cov['static_definitions']} / {cov['scripted_wild_instances']}"),('Gift/egg commands; NPC trades',f"{cov['gifts']} / {catalog['npc_trades']}"),('Custom move definitions / evolution methods',f"{catalog['moves_parsed']} / {catalog['evolution_methods']}"),('Simulation runs / gym-order schedules',f"{cov['simulation_runs']} / {cov['gym_order_schedules']}"),('Source files fingerprinted',cov['sources'])]]))
    p.append(f'''
All **585** trainer references reconcile: **439** selected/shared references, **24** mutually exclusive starter alternatives, **121** repeatable/external references, and **one unspawned script**. The unspawned script is Super Nerd Stan in Ruins of Alph Outside; it has no object or incoming script call and contributes no campaign EXP. [reference_coverage.csv](reference_coverage.csv) preserves every reference and its disposition. Party definitions without a direct map reference are listed separately; dynamic Trainer House tiers are identified rather than treated as extra encounters.

The private PyBoy cartridge checks passed **{native['check_count']:,} native checks**, including all six engine growth formulas at every level 1–100, every badge cap, actual EXP grants, participant division, Day Care banking, over-cap acquisition, the early Eusine script, 594 static trainer parties and all 498 species' EXP/growth bytes. CAL2 is external SRAM trainer data and is explicitly not equated to the static placeholder. The repository's existing `tools/test_league_progression.py` also passed **3,974 checks, zero failures**. The audit regression suite exercises arithmetic, caps, access, recruitment and double counting; [native_verification.json](native_verification.json) contains the native observations.

ROM SHA-256: `{native['rom_sha256']}`. The relevant compiled values match the source. A fresh whole-ROM reproducible build was not attempted, and the user's saves were not opened or saved by the audit. Native presentation patches exist only in a private emulator image.

## Actual EXP mechanics

Source authority: {src('engine/battle/core.asm:7313')}, {src('engine/battle/core.asm:7738')}, {src('engine/battle/core.asm:7793')}, and {src('engine/pokemon/experience.asm:41')}.

For base EXP yield `b`, defeated Pokémon level `L`, and `n` **eligible, conscious, uncapped participants in that pass**, the ordinary Hard trainer award to each eligible participant is:

```text
base_for_pass = b                         # no EXP Share holder
base_for_pass = floor(b / 2)              # EXP Share: each of two passes
split_base = floor(base_for_pass / max(n, 1))
award = floor(split_base * L / 7)
award = award + floor(award / 2)          # only if recipient OT ID differs
award = min(65535, 2 * award)             # Hard trainer battles
award = award + floor(award / 2)          # only if recipient holds Lucky Egg
```

Normal trainer battles use `award + floor(award/2)` instead of doubling. Wild KOs omit the trainer boost. The player Pokémon's level does **not** scale the award; its level only affects cap eligibility. This is a modified Gen 2-style base-yield system, with a custom Hard multiplier and cap handling, not a Gen 5 level-relative catch-up formula.

The order of floors matters. With `b=127`, `L=50`, solo Hard EXP is 1,814. Three uncapped participants get **600 each**, not `1814//3=604`. One active participant and one EXP Share holder get 900 each. Two active participants plus one holder get 442 + 442 + 900. The simulator reproduces these operations, and actual native grant tests agree.

''')
    p.append(table(['Mechanic','Implemented behavior'],[
        ['Trainer bonus','Hard ×2; Normal ×1.5 with integer floors. Wild KOs are not doubled.'],
        ['Participation / switches','Only conscious participants in that opposing Pokémon’s battle receive the participant pass. Switching increases the divisor; it does not duplicate full EXP.'],
        ['EXP Share','Held item, not an automatic party-wide feature. If at least one conscious holder exists, base yields are halved before the participant and holder passes. Each pass divides separately. An active holder can receive both passes.'],
        ['Capped participants','Excluded from the divisor. Their presence does not dilute another uncapped participant’s share. A wholly capped pass is lost; the other EXP Share half is not reallocated to the other pass.'],
        ['Fainted members','No EXP. All baseline runs assume selected recipients survive; actual fainting can widen disparities.'],
        ['Catching','No battle EXP for a catch. The caught Pokémon brings its own starting EXP at its encountered level.'],
        ['Trades','Different OT ID gives ×1.5, before the trainer multiplier. NPC trades use the surrendered Pokémon’s level.'],
        ['Lucky Egg','Held Lucky Egg gives ×1.5 after the trainer boost; Chansey’s custom base data lists it as a held item. It cannot occupy the same item slot as EXP Share. Neither bonus is assumed in the baseline.'],
        ['Hard cap','Indexed by TOTAL badge count, not the next leader’s identity. Cap is 100 after badge 16.'],
        ['At / crossing cap','Already capped Pokémon get no battle EXP. A grant crossing the cap is clipped to exactly that growth curve’s EXP at the cap. The excess is discarded, not restored by another badge.'],
        ['Stat EXP','Credited before the level-cap check. It is distinct from level EXP and is not part of the progression totals.'],
        ['Rare Candy','Refreshes the cap and refuses a Pokémon already at/above it. It does not bypass the cap.'],
        ['Day Care exception','DayCareStep still adds EXP per counted step. Withdrawal level calculation is capped, but the underlying EXP is banked. Native checks show it becomes usable at a higher cap. No Day Care walking EXP is assumed.'],
        ['Acquisition exception','TryAddMonToParty initializes the encountered/gift level and EXP without reducing it to the Hard cap. A native level-30 acquisition retained level/EXP at a level-16 cap. Own-OT Pokémon bypass the traded obedience check.'],
        ['Excluded battle sources','Link and Battle Tower return without awarding battle EXP. Capture-only Safari/contest play is not ordinary KO training. Roaming beast battles are disabled; beasts are static encounters.']
    ]))
    p.append(f'''
Cap clipping and skipping: {src('engine/battle/core.asm:7410')}, {src('engine/battle/core.asm:7530')}. Rare Candy: {src('engine/items/item_effects.asm:1491')}. Day Care: {src('engine/events/happiness_egg.asm:140')} and `engine/pokemon/breedmon_level_growth.asm`. Acquisition: {src('engine/pokemon/move_mon.asm:151')}; own-OT obedience: {src('engine/battle/effect_commands.asm:781')}. Fishing and surfing require their actual runtime rules, not just the table levels.

The battle EXP clamp still applies when a withdrawn Day Care Pokémon resumes gaining EXP; banked values above a newly active cap can be clipped by that subsequent grant. This is not a permanent reserve automatically restored in full at each badge.

### Growth curves

`CalcExpAtLevel` evaluates `floor(a*n³/b) + c*n² + d*n - e`, with level 1 explicitly zero. All 280 extracted evolution methods preserve the growth curve; the audit found no cross-curve evolution to complicate EXP preservation.

''')
    p.append(table(['Curve','Species using it','EXP at 25','at 50','at 70','at 90','at 100'],[[g.replace('GROWTH_','').replace('_',' ').title(),cov['growth_usage'][g],*[fmt(exp_at(l,g)) for l in [25,50,70,90,100]]] for g in GROWTH]))
    p.append('''
Slightly Fast and Slightly Slow are engine-supported polynomial curves but **no current species uses them**. Erratic and Fluctuating are not implemented. The realistic cohorts use only Fast, Medium Fast, Medium Slow and Slow. [growth_curve_sensitivity.csv](growth_curve_sensitivity.csv) isolates these four active curves. The per-Pokémon records use actual accumulated EXP, not an average-level conversion.

## Progression and gates

The default itinerary is Falkner → Bugsy → Whitney → Morty → Chuck → Jasmine → Pryce → Clair/shrine → Brock → Misty → Surge → Erika/Janine/Sabrina → Blaine → Blue → first League → Johto rematches → Cape Crystal → League rematch → Agatha/Lorelei → Mt. Silver Red → Green → Blue Cloak → Pallet Red. This is a declared visit order; several events permit different timings.

The exact cap table is **10, 16, 20, 25, 30, 34, 38, 45, 50, 54, 58, 62, 62, 62, 66, 69**, then 100. Kanto's middle three gyms share a cap tier, but other permitted departures from the suggested order can put a stronger fixed team under an earlier, lower cap.

''')
    p.append(table(['Progression point','Verified requirement / consequence'],[
        ['Violet → Azalea','Route 32 story blocker checks Falkner and the aide egg; Kurt and Slowpoke Well precede Bugsy. Sprout Tower is useful optional EXP, not a prerequisite for Falkner.'],
        ['Ecruteak','Whitney/Floria/Squirtbottle opens Sudowoodo. Burned Tower’s beast-release story opens Morty. ALL EIGHT Kimono Girl flags are required for HM Surf, and Fog Badge is required to use Surf.'],
        ['Western Johto','Routes 38/39 are accessible before Morty, but Jasmine blocks the Lighthouse entrance until the Cianwood Secretpotion trip. Default: Chuck, then Lighthouse, then Jasmine. The medicine trip does not itself require Chuck’s badge; returning earlier is tested separately.'],
        ['Mahogany','The Route 42 fisherman and three approach triggers check EVENT_BEAT_JASMINE. The declared corridor model therefore requires Jasmine before the Mahogany/Pryce leg; Chuck can move around that dependency.'],
        ['Blackthorn / Clair','Rocket Hideout opens the eastward road; Radio Tower clearance removes Blackthorn’s gym blocker. Clair withholds Rising Badge until the Dragon Shrine trial. Den approach EXP remains capped at 45; the model raises the cap only after that approach.'],
        ['Kanto entry','Eight Johto badges allow the eastward Kanto exit of VictoryRoadGate. Restored Viridian Forest and Pewter are on this approach. The northern Victory Road guards still require ALL SIXTEEN badges.'],
        ['Kanto flexibility','Brock and Misty do not have extra gym-script badge checks. Route 5 opening requires Misty plus the returned Machine Part. Saffron’s gates have a separate shared drink requirement. Central leaders have fixed teams, not badge-scaled teams.'],
        ['Southern Kanto','CheckSouthernKantoAccessScript requires all eight Johto badges plus Boulder, Cascade, Thunder, Rainbow, Marsh and Soul. Both the Viridian southern road and Fuchsia shoreline use this rule.'],
        ['Blue','At least fifteen total badges. Blue AND all three ordinary Viridian Gym trainers share EVENT_VIRIDIAN_GYM_BLUE; the model does not award their EXP on first entering Kanto.'],
        ['First Elite Four','Only after sixteen badges. First-team aces are 70/71/72/72/73; there is no post-Johto eight-badge League in this implementation.'],
        ['Johto rematches','First Hall of Fame unlocks Falkner; each previous Johto rematch unlocks the next, finishing with Clair. These eight rematches are one-time event-gated fights.'],
        ['League rematch','EVENT_BEAT_CLAIR_REMATCH removes the Route 23 re-entry block and selects rematch teams. Silver’s Plateau ambush also requires the Mt. Moon rival event.'],
        ['Mt. Silver','Oak requires sixteen badges, first Hall of Fame, Clair rematch AND EVENT_BEAT_CRYSTAL_CERULEAN_CAPE. The second League victory is NOT required. Agatha and Lorelei precede cave entry, with a heal between them.'],
        ['Final chain','Lance’s rematch clears EVENT_GREEN_IN_ROUTE20. Green unlocks Blue Cloak; Blue Cloak unlocks Pallet Red. Mt. Silver Red is NOT a prerequisite for this chain. The legal Green-first alternative is simulated separately.'],
        ['Cape Crystal / cave','Erika’s badge enables the Mew/Cape event. Crystal’s team reaches 70 even if the badge cap is 62. Cerulean Cave requires caught Mew AND Mew in the party; its wild levels are 55–62, with static Mewtwo 70.'],
        ['Optional wings / islands','Tin Tower’s upper stairs need Rainbow Wing; its NPC visibility includes eight Johto badges and the beast check. Lugia needs Silver Wing. Route 19’s elemental islands additionally need the Elemental Sphere. These are not assumed free early EXP.']
    ]))
    p.append('''
Gate sources: `engine/events/league_progression.asm`; `maps/VictoryRoadGate.asm`; `maps/Route5.asm`; `engine/events/saffron_gates.asm`; `maps/Route19.asm`; `maps/ViridianGym.asm`; `maps/OaksLab.asm`; `maps/Route23.asm`; `maps/LancesRoom.asm`; `maps/Route20.asm`; `maps/CinnabarIsland.asm`; `maps/PalletTown.asm`; `maps/DragonShrine.asm`. Every extracted condition, with a line reference, is in [access_conditions.csv](access_conditions.csv). All 1,511 links are in [map_edges.csv](map_edges.csv).

### Exact primary teams and caps

Levels below are extracted, not inferred from a boss name. Species, every move, item, selected ability, custom stats and Hard stat EXP for all 63 selected major/side boss encounters are in [BOSS_CATALOG.md](BOSS_CATALOG.md) and [boss_teams.csv](boss_teams.csv). Alternate starters remain in the complete trainer database.

''')
    p.append(table(['Milestone','Actual cap','Party (species:level)','Ace','Party source'],[[name,cap_for(i) if i<16 else 100,', '.join(f"{m['species']}:{m['level']}" for m in PARTIES[key]['mons']),max(m['level'] for m in PARTIES[key]['mons']),src(PARTIES[key]['source'])] for i,(name,key) in enumerate(zip(STAGES,BOSS_KEYS))]))
    p.append('''
The final chain’s aces are **Green 82 → Blue Cloak 84 → Pallet Red 85**, below League-rematch Lance 87 and Mt. Silver Red 90. Do not invent a 95–100 superboss tier from their names. Aces and level caps are different quantities.

## Simulation assumptions

Two staggered, mixed-growth cohorts were run. The principal cohort is Cyndaquil 5 (starter), Rattata 4 (Route 29), Mareep 4 (Route 30), Zubat 10 (Union Cave), Jigglypuff 17 (Route 34), and Growlithe 11 (Route 36). Prefixes of this list produce team sizes 1–6. Thus the planned six-member team has **3 active members at Falkner, 4 at Bugsy, 5 at Whitney, and 6 by Morty**, not six level-5 Pokémon at the start. Species names in the EXP logs denote the recruited line; evolution does not change these lines’ growth rates. Combat analysis uses the actual evolution/learnset data, not a level-70 unevolved-starter battle assumption.

The alternative cohort is Chikorita, Hoothoot, Hoppip, Aron, Abra and Snubbull at the source-supported join levels/maps in `model.py`. The cohorts are illustrative legitimate choices, not an optimized battle team or an observed popularity sample. Chosen catches are assumed obtained without bonus KO EXP for the catch. Search encounters, money, catch success, healing time and travel distance are not simulated.

''')
    p.append(table(['Playstyle','Operational assumption'],[
        ['Minimal-route','Only the curated required/story set, needed recruitment detours and five obstacle KOs; no random wild KOs, candy or optional side-area trainer sweep. This is NOT a proven globally minimal path. Kimono Girls are deferred until Surf is needed after Morty.'],
        ['Typical casual (main baseline)','70% of ordinary trainers on visited main maps. Optional maps are visited at a declared 35% rate, then 65% of optional battles there. Optional event branches on a visited main map use 65%. These are seeded scenario drivers, not measured probabilities.'],
        ['Thorough','95% of main/optional ordinary battles and almost all side areas, without repeated training loops.'],
        ['Completionist','Every modeled eligible unique trainer in the scheduled itinerary, all five finite security-camera pairs and all 22 finite floor traps. Later repeatable ship passengers, phone repeats and CAL are separate. This is the itinerary’s maximum, not a theorem about every early-access shortcut.'],
        ['Efficient Hard player','85% of ordinary battles, more optional areas (65%), always feeding the lowest-level uncapped member. This tests informed rotation; it does not assume a typical player knows it.']
    ]))
    p.append('''
Eight participation policies are separate: casual lead share 45%; equal KO rotation; all members switch into each enemy; lead share 70%; two primaries take 80% combined; lowest-level rotation; switch training with lead + lowest; and one EXP Share holder with a main battler. The efficient playstyle explicitly forces lowest-level rotation regardless of the nominal policy column. All-participant switching is an optimistic mechanical test: Set mode and incoming damage can make it impractical.

The main random-wild driver is **2 KOs per newly visited encounter-bearing map**. Sensitivities use **0 / 2 / 5**, over 20 fixed seeds for typical four- and six-member teams and two distribution policies. Day tables are used; all morning/night tables are retained in the source database, but no literal clock itinerary is claimed. Surf-only EXP is blocked before Morty. Western Ruins grass and Route 34’s beach are treated as later Surf content. Safari and contest catches grant no KO training EXP. Revisited maps do not generate another automatic travel allotment.

Five story obstacles are KO’d in the baseline: Sudowoodo, red Gyarados and three Electrode. Capturing them instead removes their wild awards; the scripted wild database exposes the precise totals. Other static rare Pokémon are treated as captures with zero battle EXP, not silently turned into EXP farms. The optional 22 Rocket floor traps are expanded by their distinct event flags; typical exposure is a stated 10% per trap, thorough 50%, completionist all. The five cameras are separate finite encounters, not one endlessly credited grunt pair.

Every selected battle is assumed won, with intended recipients conscious. There is no automatic grinding between checkpoints. In particular, later results are **not** the levels of a player who first filled an earlier deficit: they show deficits carried forward. Difficulty does not follow from EXP alone.

## Main results: all primary milestones

Each table uses one playstyle at a time. “Min/Typ/Max EXP” are solo-equivalent TRAINER offers from the minimal-route, typical-route and scheduled-completionist cases; they are not summed together and are not EXP automatically earned by each party member. “Start6” is the average after the previous primary boss, before the next route segment. A boss’s own award is applied only AFTER its row. Between consecutive League/rematch bosses the new-route EXP may be zero because the previous boss award is already in Start6.

Team columns are individual levels using that playstyle’s casual participation policy (45% lead); Efficient uses lowest-level rotation. More evenly distributed comparison tables follow. Post-badge-16 “target” means boss ace; the actual cap remains 100. “KOs6” is an independent, balanced-training estimate to bring the whole unground team to that target, not a minimum required to win and not a count to add to other rows.

''')
    combined=[]
    for style in PLAYSTYLES:
        p.append(f'### {style.title()}\n\n')
        out=[]
        for i,name in enumerate(STAGES):
            rs=[get(style,n)[i] for n in [3,4,5,6]];r=rs[-1]
            pools=[get(s,6)[i]['segment_solo_available'] for s in ['minimal','typical','completionist']]
            g=gr(name,6,'casual',style)
            out.append([name,f"{r['hard_cap']}/{r['target_level']}",f"{r['starting_average_level']:.1f}",'/'.join(fmt(x) for x in pools),*[lv(x['levels']) for x in rs],fmt(r['target_shortfall']),g['balanced_training_kos'],r['balance_rating']])
            combined.append(dict(playstyle=style,milestone=name,actual_cap=r['hard_cap'],target=r['target_level'],starting_average6=r['starting_average_level'],minimal_trainer_exp=pools[0],typical_trainer_exp=pools[1],scheduled_max_trainer_exp=pools[2],team3=rs[0]['levels'],team4=rs[1]['levels'],team5=rs[2]['levels'],team6=r['levels'],exp_actually_earned6=r['segment_earned'],target_shortfall6=r['target_shortfall'],target_surplus6=r['target_surplus'],cap_waste_segment6=r['segment_wasted'],cap_waste_cumulative6=r['cumulative_wasted'],pct_at_cap6=r['at_cap_pct'],balanced_wild_kos6=g['balanced_training_kos'],selected_policy_wild_kos6=g['selected_policy_training_kos'],shortfall_pct_segment_demand6=r['shortfall_pct_of_segment_demand'],balance_rating=r['balance_rating']))
        p.append(table(['Milestone','Cap/target','Start6','Min/Typ/Max EXP','Team 3','Team 4','Team 5','Team 6','Shortfall6','KOs6','Rating6'],out))
    write_csv('milestone_results.csv',combined)
    p.append('''
### Equal rotation and distribution sensitivity

This comparison isolates distribution. It is not substituted for the casual baseline. `all_participants` splits base yield before multiplication, so its totals can be lower than equal KO rotation even when levels look even. The source has no special extra bonus for a low-level recipient.

''')
    p.append(table(['Milestone','4 balanced','6 balanced','6 casual lead45','6 lead70','6 two primaries','6 lowest','6 switch','6 EXP Share'],[[name,*[lv(at(name,n,m)['levels']) for n,m in [(4,'equal_rotation'),(6,'equal_rotation'),(6,'casual'),(6,'main70'),(6,'two_primary'),(6,'lowest'),(6,'switch'),(6,'exp_share')]]] for name in GYMS+['Lance','Falkner rematch','Clair rematch','Lance rematch','Red Mt Silver','Red Pallet']]))
    p.append('''
EXP Share becomes available in the model after the Lake of Rage red-scale event and the return to Mr. Pokémon. This is an optimistic item-access detour, not a free party-wide switch at game start. A capped main battler can lose the participant half while the holder still gets only the holder half. More holders do not duplicate the half; they divide it.

![Endgame levels](02_endgame_progression.png)

## Segment findings and smoothness

''')
    notes={
    'Falkner':'Small-team EXP is concentrated in the starter and early catches. Sprout Tower and the first Crystal battle materially affect the result; cap waste is possible in a solo run. A planned six-team is only three Pokémon here.',
    'Bugsy':'This is not a six-way split from New Bark. Four members are present in the principal six-team. The full-party target is more demanding than being 1–3 levels below the leader. Union Cave/well/gym encounters are the main stock.',
    'Whitney':'Route34/Ilex/Goldenrod supply helps, while newly caught level17 Jigglypuff can arrive close to the cap immediately. The beach sisters are not pre-Whitney trainer EXP: they need Surf.',
    'Morty':'Growlithe joins at 11 and can remain far behind while older members approach25. Averaging the party conceals that new-member problem. National Park, Silent Crypt and Kimono Girls change available EXP; minimal-route girls are after Morty.',
    'Chuck':'The western approach, sea routes, Cianwood Crystal and optional Surf revisits supply this segment. Lighthouse EXP is reserved for the medicine return after Chuck. Four-member teams can reach cap30 without it; six-member teams can be lower, especially their slow-growing sixth recruit.',
    'Jasmine':'The Lighthouse now supplies its 11 battles in this segment, followed by three ordinary gym trainers. Its full stock is30,804 solo Hard EXP. Four-member typical parties reach32–33, a reasonable1–2-level gap below34; the original recommendation to move Lighthouse trainers here was redundant and is withdrawn. Six-member casual/typical teams remain more uneven. Returning from Cianwood before Chuck is legal but can consume this stock under cap30.',
    'Pryce':'Lake/Rocket content restores momentum, but Jasmine-first and Pryce-before-Chuck schedules change where it is consumed. Password holders and the finite alarm/trap instances are distinguished from repeats.',
    'Clair':'Radio Tower, underground rescue, Route44 and Ice Path provide a substantial recovery segment. Four-member parties often catch up; six-member parties remain uneven. Badge8 is a separate shrine event after the battle.',
    'Brock':'The post-Clair descent, Routes26/27, Tohjo and restored forest provide meaningful EXP. Viridian Gym trainers are still hidden and are not part of this stock. Trainer access is not inferred merely from being below level50.',
    'Misty':'Mt Moon’s rival and Routes3/4/9/24/25 form a real Kanto segment. Power/date story work matters. Brock can be deferred, but that does not make Misty’s fixed54 team scale down to the first Kanto cap50.',
    'Surge':'A weak incremental segment follows Misty’s substantial approach. The cap rises to58 while relatively little new route content is provided on the direct itinerary. A tiny level buff to a few trainers does not close the budget.',
    'Erika':'The first62 tier stretches a six-member party. First-trip ship battles are unique opportunities, whereas later directional passengers are repeatable. Saffron’s drink gate is separate from gym badges.',
    'Janine':'A longer eastern/coastal or Cycling Road sweep can recover EXP without raising the62 cap. This is one reason middle-gym order changes cap waste and the timing of recovery.',
    'Sabrina':'The third62 gym may have little fresh route content left. Four-member teams can already be capped. Kiyo’s level67–69 dojo team is an optional combat spike, not ordinary safe grinding credit.',
    'Blaine':'Southern routes reopen only after all six prerequisite Kanto badges, providing a meaningful new zone set. The change from62 to66 still exposes the cumulative six-team deficit.',
    'Blue':'The final jump to69 has only the now-visible Viridian Gym trainers on the direct route. It does not come with an entire new region of trainers. Previous optional content cannot be credited again.'}
    for name in GYMS:
        r=at(name);small=at(name,4)
        p.append(f"**{name}:** {notes[name]} Balanced typical examples: four **{lv(small['levels'])}**, six **{lv(r['levels'])}**. The six-team shortfall is {fmt(r['target_shortfall'])} EXP ({r['shortfall_pct_of_segment_demand']:.1f}% of its segment-entry target demand); {r['within_2']}/{r['party_size']} are within two levels of target.\n\n")
    p.append('''
These ratings use the median individual gap, not just the mean. A slow new sixth member is still shown even when “most” meet a favorable rating. At high levels, a few levels can mean hundreds of thousands of team EXP. A 4–5 level early gap can also conceal missing evolutions or key moves; the label alone is not a battle verdict.

![Trainer stock](03_trainer_exp_supply.png)

The per-zone ledger records starting and ending level vectors, actual EXP, wild EXP, cap loss and battles consumed. [ZONE_REVIEW.md](ZONE_REVIEW.md) covers every map. Map-wide totals are lifetime totals: the JSON phase split in [zone_exp_database.csv](zone_exp_database.csv) prevents crediting late subareas such as Route34’s beach during the initial visit.

## Wild training and the size of the deficit

Grass slot weights are 30/30/20/10/5/4/1%; Surf weights are60/30/10%. Surf additionally rolls a **0–4 level bonus** with exact byte probabilities89/256,76/256,51/256,26/256,14/256. Fishing uses inclusive byte thresholds and a separate bite chance; probabilities in [fishing_encounters.csv](fishing_encounters.csv) reflect those byte comparisons, not rounded percentages. Johto fishing scales as `max(listed, listed//2 + 4*Johto badges)`; shared Kanto groups add `[0,4,8,12,12,12,16,19,23]` by Kanto badge count. Safari, Silver Cave and Ice groups remain distinct.

Headbutt and Rock Smash have separate map-linked distributions. Safari’s grass/ice/rock/mud sub-tables and five-badge species replacements are not merged into an ordinary route encounter. All are cataloged, including the capture-only contests. The disabled roaming structs are not credited as encounters.

The following use the highest mean-yield visited, eligible normal grass/Surf table at that checkpoint, with actual growth/award rounding and lowest-member rotation. That is favorable to the player, but it is not a claim about optimal fishing or the fastest real-time method. The selected-policy estimate also appears in the CSV. Bad matchups, fainting, healing and encounters that flee would increase time; these are KO counts, not minutes.

''')
    p.append(table(['Boss','Four EXP short','Four KOs','Six EXP short','Six KOs','Training map (six)'],[[name,fmt(at(name,4)['target_shortfall']),gr(name,4)['balanced_training_kos'],fmt(at(name)['target_shortfall']),gr(name)['balanced_training_kos'],gr(name)['wild_map']] for name in ['Bugsy','Morty','Chuck','Jasmine','Pryce','Clair','Brock','Surge','Blue','Falkner rematch','Clair rematch','Lance rematch','Agatha','Red Mt Silver']]))
    p.append('''
**Do not add these checkpoint estimates.** For example, training before Blue changes every later checkpoint, so a later “untrained deficit” is not another independent tax after paying the earlier one. These counts answer “what would filling the entire current target deficit cost from this unground save state?” They do not establish that exact-cap grinding is necessary to win. Arriving1–3 levels below a leader is often an acceptable result.

### Sensitivity to exploration and ordinary travel

Each range below is the minimum–maximum of 20 declared trainer/optional-route seeds for a typical six-member team with equal rotation. It is a scenario envelope, not a confidence interval.

''')
    p.append(table(['Boss','0 travel KOs/map','2 KOs/map','5 KOs/map'],[[name,*[f"{float(r['average_min']):.1f}–{float(r['average_max']):.1f}" for wild in [0,2,5] for r in bands if r['team_size']=='6' and r['method']=='equal_rotation' and r['wild_kos_per_map']==str(wild) and r['milestone']==name]] for name in ['Bugsy','Morty','Jasmine','Clair','Surge','Blue','Falkner rematch','Clair rematch','Red Mt Silver']]))
    p.append('''
## Team replacement and catch-up

The source offers appropriately leveled wild recruits in many later areas. The problem is not universally “new Pokémon cannot catch up.” A newly caught route-appropriate Pokémon brings a large starting EXP balance and can improve a lagging slot immediately. Revisiting an early gift or old area is different: there is no level-relative EXP bonus to help that member beyond its smaller low-level thresholds.

The following replace slot6 after Clair, before the Kanto leg: Magnemite26 from Route38, Sandslash45 from Route26, and the level20 Eevee gift. They are actual species/growth/join levels, not the same growth curve under three labels. The growth differences are part of the result.

''')
    repl=[]
    for name in ['Brock','Surge','Blue','Lance','Clair rematch','Red Mt Silver']:
        vals=[]
        for scenario in ['old_area_replacement','current_area_replacement','eevee20_replacement']:
            r=next(x for x in route if x['scenario']==scenario and x['milestone']==name and x['primary']=='True' and x['team_size']=='6' and x['playstyle']=='typical' and x['method']=='equal_rotation')
            vals.append(json.loads(r['levels'])[-1])
        repl.append([name,at(name)['levels'][-1],*vals])
    p.append(table(['Boss','Existing Growlithe line','Magnemite26','Sandslash45','Eevee20'],repl))
    p.append('''
Retaining an older undertrained Slow-growth member and adding a low-level gift both make averages misleading. `replacement_individual.csv` shows every member’s EXP and level after each change. Recommended support is access to useful stage-appropriate recruits, not inflating every wild level across the game or assuming all new catches start at the cap.

## Nonlinear gym orders and alternate endings

The enumerated source-informed corridor graph uses3 western Johto orders (Chuck–Jasmine–Pryce, Jasmine–Chuck–Pryce, Jasmine–Pryce–Chuck) and144 Kanto orders among Brock/Misty/Surge/Erika/Janine/Sabrina with Misty preceding the central/southern corridor, followed by Blaine and Blue. That gives432 schedules and1,728 four/six-member, casual/balanced runs. Shared western approach and Kanto-entry stock is consumed on first travel, not delayed until a postponed Chuck or Brock. Lighthouse battles instead follow the medicine return before Jasmine; an alternative return before Chuck is tested explicitly. The same event ID is never awarded twice.

These are all orders in the declared graph, **not proof that the graph captures every movement loophole**. No gym-script badge gate is invented for the first seven Kanto leaders. A route that finds another legitimate way around the assumed corridor should be added to the graph rather than silently rejected as “impossible.” The native progression tests verify script/event checks but teleport between test states; they are not end-to-end walking tests.

''')
    orows=[]
    for n,method in [(4,'equal_rotation'),(6,'equal_rotation'),(6,'casual')]:
        vals=[r for r in orders if r['team_size']==str(n) and r['method']==method]
        lo=min(vals,key=lambda r:float(r['blue_average']));hi=max(vals,key=lambda r:float(r['blue_average']))
        orows.append([n,method,f"{float(lo['blue_average']):.2f}",lo['order'],f"{float(hi['blue_average']):.2f}",hi['order']])
    p.append(table(['Team','Policy','Lowest Blue avg','Order','Highest Blue avg','Order'],orows))
    p.append('''
“Best” here means the stated EXP statistic, not combat ease. Fighting a fixed level62 central leader at an earlier54/58 cap can be harder even if it yields more EXP. Early optional sweeps can also waste stock against the old cap and leave a later route unrewarding. The `earliest_exploration` sensitivity probes that timing separately; its internal puzzle/subzone reachability remains a curated assumption.

The Green-first scenario follows the permitted final chain before visiting Mt. Silver. The direct-Silver scenario omits the League rematch and therefore also omits Green/Blue Cloak/Pallet Red, whose unlock depends on that rematch. Neither route credits locked rewards as a solution to its own prerequisites.

## Late-game economy and repeatable training

The first League is a full sixteen-badge event with six Pokémon on every team. After that, the game asks for a quick jump to rematch aces77–84, then League aces85–87 and Silver trainers87/87/90. The badge cap is no longer the restraint: **unique EXP stock and cubic growth costs are**.

The eight Johto rematches supply only the rewards of eight six-member teams, with little new one-time route content between them. They unlock the next tier; they do not automatically train a full party to that tier. Winning every selected unique fight is already an optimistic assumption if the player is heavily underleveled.

''')
    rematch_pool=sum(PARTIES[k]['solo_hard_exp'] for k in BOSS_KEYS[21:29])
    e4_pool=sum(PARTIES[k]['solo_hard_exp'] for k in BOSS_KEYS[31:36])
    p.append(f'''The complete Johto rematch chain awards **{fmt(rematch_pool)} solo-equivalent Hard EXP**; the League rematch awards **{fmt(e4_pool)}**. Even with equal rotation, the typical six-team reaches Clair rematch at **{lv(at('Clair rematch')['levels'])}**, versus ace84, and League-rematch Lance at **{lv(at('Lance rematch')['levels'])}**, versus87. A four-team fares better but still arrives at Clair rematch at **{lv(at('Clair rematch',4)['levels'])}**.

The typical balanced six-team’s unground shortfall to level90 before Red is **{fmt(r6['target_shortfall'])} EXP**. A single maximum-yield level90 trainer Pokémon provides `2*floor(255*90/7)=6,556` solo EXP. Even an ideal six-Pokémon battle at that yield supplies39,336; that shortfall is equivalent to **at least {math.ceil(r6['target_shortfall']/39336)} such perfect-yield battles**, ignoring distribution loss. This demonstrates why one or two extra trainers cannot repair the entire late-game curve. It is an upper-yield comparison, not a recommendation to add that many trainers.

Phone rematches, later ship passengers and daily CAL are in [repeatable_exp.csv](repeatable_exp.csv), never silently inserted into the unique baseline. CAL3–CAL6 choose3/4/5/6 level50/60/70/80 starters according to the highest player level; they are not four separate one-time map trainers. The League can also be repeated once its rematch gate is open; a completed five-battle rematch loop offers{fmt(e4_pool)} before distribution. Required repetitions, cooldowns and real-time effort must be discussed as training, not as natural unique exploration.

![Cap loss](05_cap_waste.png)

## Combat difficulty, separated from EXP

The code uses a physical/special/status move category, custom species stats and abilities, selected boss ability slots and held items. `move_data.csv`, `species.csv`, `evolutions_learnsets.csv` and `boss_teams.csv` retain the actual hack data. No canonical online Pokémon stat table was substituted.

Falkner has3 Pokémon; Bugsy3; Whitney4; Morty4; Chuck5; Jasmine5; Pryce6; Clair6. Every Kanto leader and every first/rematch League opponent has6. Equal levels therefore do not mean equal resource pressure. Hard Mode forces Set behavior and only allows the Ball pocket in the battle pack; held items and outside-battle healing still matter.

Specific pressure points:

- **Eusine2 in Ecruteak:** five fully evolved Pokémon38/38/39/39/40 at an available25 cap. This is source- and ROM-verified. The safe baseline defers this optional approach until the Radio Tower segment; the early hazard scenario exposes what that assumption avoids.
- **Whitney:** Aipom’s selected Skill Link with Fury Swipes and Miltank’s recovery/status combination are separate from the level budget. Reaching20 alone does not establish an easy fight.
- **Jasmine:** custom Steelix has75/105/200/30/45/65 base stats, and selected items/abilities matter. A six-team straggler can also miss important evolutionary thresholds. Raising a weak route trainer by one level will not address either issue by itself.
- **Evolution thresholds:** Cyndaquil evolves at14; Quilava has level36 regional/normal branches; Mareep15, Flaaffy30; Zubat22 and Golbat by happiness. A party averaging29 can include Pokémon on both sides of a substantial power jump.
- **Optional Kiyo:** six level67–69 Pokémon in a dojo that has no late visibility gate. The fixed team can substantially outrank the active cap if the player walks in during central Kanto. Unlike the safe EXP-routing assumption, an unsuspecting player is not guaranteed to defer it.
- **Cape Crystal:** a level70 ace becomes available after Erika, while the cap can still be62. It is required eventually for Silver access, not immediately for the next Kanto badge.
- **Hard NPC stats:** `GetTrainerStatExp` returns the class table only in Hard Mode. Perfect boss DVs and large stat-EXP values increase effective strength; stale comments naming old trainer levels were not used as current levels. The boss catalog reports the actual class values and an approximate level-scaled stat contribution.
- **Acquisition loophole:** route-appropriate high-level catches can bypass an earned-EXP ceiling and can obey their own trainer. For example, reachable Route35 grass includes levels21 above the Whitney cap20. Whether this is intended difficulty relief or a cap-policy defect is a separate design choice.

No win-rate or full turn-by-turn damage tournament was run. Ability/item/move interactions are reviewed as concrete threats; the chart’s level-gap proxy is not labeled a complete battle difficulty score. Type counters, custom starter abilities, status, setup and smart switching may win below the target; fainting and bad matchups can make the modeled EXP outcome optimistic.

Additional standalone plots: [EXP deficits](04_exp_deficits.png), [level-gap spikes](06_level_gap_spikes.png), [EXP surpluses](07_exp_surpluses.png), and [all six team sizes](08_all_team_sizes.png). Every PNG has a matching SVG export for enlargement.

## Targeted hypotheses and their tests

All hypotheses are overlays in `hypotheses.json`; **none edits the game**. Every one was run across all six team sizes, five playstyles and casual/equal policies. A candidate that helps four members but hurts six is not presented as a solved balance patch.

''')
    tst=[]
    for proposal,name in [('jasmine_cap32','Jasmine'),('lighthouse_before_chuck','Chuck'),('lighthouse_before_chuck','Jasmine'),('jasmine_trainers_plus3','Jasmine'),('surge_trainers_plus3','Surge'),('endgame_level_retarget_trial','Clair rematch'),('endgame_level_retarget_trial','Red Mt Silver')]:
        for n in [4,6]:
            r=tr(proposal,name,n)
            tst.append([proposal,name,n,lv(json.loads(r['original_levels'])),lv(json.loads(r['levels'])),f"{r['original_target']}→{r['target_level']}",fmt(r['shortfall_change']),fmt(r['waste_change'])])
    p.append(table(['Overlay','Checkpoint','Team','Original levels','Trial levels','Target','Shortfall change','Cumulative cap loss change'],tst))
    p.append('''
The original Lighthouse redistribution recommendation was based on an incorrect route assignment and is **withdrawn**. All11 Lighthouse battles already belong between the Cianwood medicine trip and Jasmine; the default fights Chuck before returning. Their full stock is30,804 solo Hard EXP. The `lighthouse_before_chuck` overlay is an actual permitted route choice: collect the medicine and return before fighting Chuck. It is not a proposed map change. It improves Chuck readiness at the cost of claiming some Lighthouse stock under the old cap. The separate `jasmine_trainers_plus3` trial raises only the three ordinary Olivine Gym trainers, to measure the size of a local buff without assuming it is needed for four-member teams.

The cap32 experiment is retained as a sensitivity, not a recommendation. Corrected four-member typical parties already come within1–2 levels of34. Lowering the cap changes permitted levels, not Jasmine's existing ace34 or the EXP supply, and could constrain a healthy four-team merely to make an attainment metric look better.

The “Surge trainers+3” overlay raises only Route6 and ordinary Vermilion Gym trainer levels. Its small EXP improvement demonstrates that a cosmetic local buff is insufficient. More boss levels are not a general source of large EXP, and moving scarce trainers out of Misty’s approach could create a new shortage there.

The deliberately aggressive endgame retarget trial sets Johto rematch aces69,69,70,70,70,71,71,72; Plateau/League aces73–74; Silver gatekeepers75; Mt. Red77; final chain75/76/77. Lowering enemy levels also lowers their EXP rewards, which the trial accounts for. It is a useful lower-intensity design alternative, **not an accepted fix**: four-member teams become much closer or over target, while six-member stragglers can still lag. Preserving the current80s/90 endpoint requires a materially larger unique training budget or a carefully tested late catch-up mechanism, not a claim that two more trainers will suffice.

The full [hypothetical_changes.csv](hypothetical_changes.csv) includes carryover, per-member vectors, deficits and cap loss at every primary checkpoint, so later oversupply and regressions are visible. Cap-waste improvements alone are not accepted as proof of combat balance.

''')
    hg=csvrows('hypothetical_grinding.csv')
    p.append('### Catch-up battles under the trial changes\n\nThe following estimates use balanced catch-up training from the typical-route equal-rotation checkpoint. The target can change in a cap/boss-retarget trial; it is shown explicitly. These are independent exact-target estimates, not proven battles required to win. The full CSV includes all six team sizes, casual/equal route policies, and both balanced and selected-policy training: [hypothetical_grinding.csv](hypothetical_grinding.csv).\n\n')
    p.append(table(['Overlay','Checkpoint','Team','Original→trial target','Original KOs','Trial KOs','Wild map'],[[r['proposal'],r['milestone'],r['team_size'],r['original_target']+'→'+r['trial_target'],r['original_balanced_kos'],r['trial_balanced_kos'],r['wild_map']] for r in hg if r['method']=='equal_rotation' and r['team_size'] in ['4','6']]))
    p.append('''
## Remaining uncertainty and reproducibility limits

1. The mandatory ordinary-trainer set is a curated minimal-route scenario, not a formally proven shortest path through every NPC sight line, moving object and puzzle. First-rival/Crystal losses can also advance some story states; the simulations assume victories.
2. Every map/edge/condition is inventoried, but HM/puzzle subzones are curated. The targeted collision probes are conservative and do not implement every movement collision, directional warp, script, moving NPC or hidden door. A failed search is **not** proof of inaccessibility. Route9 probes remain inconclusive; native gate tests do not replace a walking playthrough.
3. The scheduled-completionist maximum excludes infinite repeats and unresolved early shortcuts. `earliest_exploration` is a sensitivity, not a certified global maximum. A map’s total EXP is not automatically available on its first visit.
4. Player encounter/avoidance rates, exact casual routes and optional-area timing are assumptions. The seed envelope is not a statistically calibrated population forecast. Morning/night/Safari tables are extracted, while the main travel simulations use daytime and no exact travel-distance estimate.
5. The safe itinerary defers the dangerous early Ecruteak fight and the Cape battle. A casual player can trigger them earlier; their hazard cases and native script facts are reported, not hidden in the EXP baseline.
6. Rare/static captures, trades, Lucky Egg farming, candy collection and Day Care banking are not free baseline supplies. Changing those choices can change results. Replacing a slot with a high-level catch is intentionally modeled separately.
7. Every selected fight is assumed winnable and intended recipients alive. No full combat win-rate proof, emulator autoplay campaign, or measured minutes-to-grind estimate is claimed. Ordinary trainers within a map generally follow source order, not a reconstructed tile-by-tile walk. Reviewed story bosses follow their preceding fights; the Radio Tower has separate pre-Card-Key and post-Card-Key visits. Smaller within-map timing and cap-waste differences can remain.
8. The existing ROM was checked in a private emulator state. External CAL2 save data, user saves, link battles and fresh-build bit identity were not analyzed as ordinary campaign EXP.

These limitations prevent a categorical statement that every real player must grind exactly the displayed number of battles. They do not erase the large, reproducible unique-EXP shortfalls or the verified cap-exceeding Eusine script.

## Answers to the fifteen final questions

1. **Can a typical six-team naturally stay close for every gym?** Not in these carried-EXP scenarios. Balanced rotation is viable in much of Johto, but the western split and later Kanto can miss the0–3-level goal; casual concentration makes individual lag much worse. Correcting the Lighthouse timing substantially improves four-member Jasmine readiness. A six-team is not assumed present at the first gym.
2. **Is four significantly better?** Yes, especially after recruitment finishes. It caps earlier in several Johto/62-tier segments and reaches late bosses several levels ahead of six. That advantage still does not supply the whole post-League ramp.
3. **Largest gym shortages?** For the balanced six-team, examine the combined Chuck/Jasmine allocation and cumulative gaps through Surge/Erika, Blaine and Blue. Jasmine is no longer a major four-member shortage after correctly crediting the Lighthouse. Absolute deficits rise with level, so compare the level vectors and demand percentages, not only raw EXP.
4. **Where is EXP excessive?** Smaller teams can waste substantial stock in the western Johto approach and around shared62-tier content. Thorough early sweeps can consume useful later trainers under an old cap. This does not imply a full six-team has too much EXP globally.
5. **Over/underleveled zones?** Western Johto and central Kanto have uneven timing; early Eusine, Kiyo and Cape Crystal are specific early-access combat hazards. Low-yield older areas remain poor places to develop a late low-level gift. Every zone’s level range and timing are in the zone review.
6. **Does exploration pay?** Yes, materially. But needing nearly every one-time trainer and unusually careful rotation to approach later targets would exceed the stated casual-exploration goal. Completionism still does not solve the post-League budget.
7. **Is grinding needed, where/how much?** Exact-cap catch-up costs are quantified in `grinding_estimates.csv` and the tables above. The western split for six members, late Kanto and especially the rematch/Silver ramp deserve attention. Four-member Jasmine levels are already near the cap. Those are independent counterfactual KO counts, not proven minimum requirements to win or numbers to sum.
8. **Problematic gaps between story events?** Misty→Surge; the limited fresh content before Blue; first League→Falkner rematch; and the boss-only rematch climb are the clearest structural cases. Chuck→Jasmine has a substantial Lighthouse segment, which the original audit had incorrectly consumed before Chuck.
9. **Enough Kanto EXP for sixteen badges?** Kanto trainers are meaningful and no longer vanilla low-level filler. Their unique stock and timing still do not keep the full six-team near every increasing target in the tested routes. The three62 gyms allow recovery but do not cancel the whole accumulated deficit.
10. **Do Johto rematches train the team for the League rematch?** Not by themselves for a normal four-to-six development curve. Their one-time rewards are much smaller than the target EXP increase; the chain is also an unlock condition.
11. **League rematch→Red→superbosses reasonable?** The unique stock does not support the current90 peak for an unground six-team. The final chain is actually lower leveled and does not require beating Mt. Silver Red first. Green-first is a more sensible permitted ordering, but it does not manufacture a new large EXP budget.
12. **Does replacement discourage experimentation?** Old level20–26 recruits can lag badly without a level-relative catch-up bonus. Stage-appropriate wild catches can instead improve a slot, and over-cap acquisition is possible. Both cases are measured separately.
13. **Which trainers/areas to adjust?** First gate/reteam Ecruteak Eusine; then budget Vermilion/late Kanto and the whole rematch corridor from existing battle stock. Do not relocate Lighthouse trainers on the basis of the original audit: the corrected route already uses them before Jasmine. Arbitrary global level increases are not recommended.
14. **Could cap changes be better than more EXP?** The corrected four-member Jasmine progression does not justify lowering its cap merely to achieve exact attainment. Keep the cap32 trial as an experiment, with explicit boss/order tradeoffs. After badge16 there is no progression cap to lower: changing an assumed “rematch cap” would fix nothing because it does not exist. Boss pacing or unique EXP supply must change there.
15. **Five most important review priorities?** Prevent the early Eusine mismatch; redesign the post-League target/budget relationship; repair Kanto’s weak incremental segments; support deliberate team changes; and monitor the Chuck/Lighthouse/Jasmine split for full teams using the corrected timing. The last is a validation priority, not evidence that the Lighthouse needs an immediate buff. The simulated small changes are partial improvements, not a verified complete patch.
''')
    (HERE/'EXP_BALANCE_REPORT.md').write_text('\n'.join(p),encoding='utf-8')
    # Complete per-boss sheets: detailed combat data and raw script predicates.
    bosses=csvrows('boss_teams.csv');groups=defaultdict(list)
    for r in bosses:groups[r['event_id']].append(r)
    bp=['# Boss teams and combat context\n\nAll values are extracted from this source snapshot. “Cap” follows the declared itinerary; alternate gym orders use badge count, not leader identity. Raw predicates below are the script’s checks, including non-battle gift/retry branches; they are evidence to inspect, not a generated logical conjunction.\n']
    for eid,rs in groups.items():
        r=rs[0];e=next(e for e in EVENTS if e['event_id']==eid)
        bp.append(f"## {r['milestone']}\n\nMap `{r['map']}`; class `{r['trainer_class']}`; party `{r['party_key']}`; ace {r['boss_ace']}; itinerary cap {r['hard_cap']}. {src(r['event_source'])}.\n\n{r['access_requirements']}\n\n")
        bp.append(table(['Pokémon','Level','Base EXP','Hard solo EXP','Custom stats HP/Atk/Def/Spe/SpA/SpD','BST','Item','Ability','Moves','Hard stat EXP'],[[x['species'],x['level'],x['base_exp'],x['solo_hard_exp'],lv(json.loads(x['stats'])),x['bst'],x['item'],x['ability'],', '.join(json.loads(x['moves'])),x['hard_mode_stat_exp']] for x in rs]))
        conditions=[g for g in DATA['gates'] if g['map']==e['map'] and g['script'].startswith(e['script'])]
        if conditions:bp.append('\nScript predicates / event evidence:\n\n'+'\n'.join(f"- `{g['command']}` — {src(g['source'])}" for g in conditions)+'\n')
    (HERE/'BOSS_CATALOG.md').write_text('\n'.join(bp),encoding='utf-8')
    # All 406 maps retained, including empty/retired maps.
    zones=csvrows('zone_exp_database.csv')
    zp=['# Every zone and map\n\nOne row for every map script. EXP columns are solo-equivalent trainer lifetime stock for that map; a phase split or access requirement can prevent using it on the first visit. Primary bosses are in the boss catalog, rather than double counted here. Zero trainer EXP is a real inventory result, not a skipped map. Wild means describe source tables and require the encounter method / subzone to be usable.\n\nStages are zero-based itinerary labels; they are not badge requirements. See map_progression.csv for requirements and access confidence.\n']
    zp.append(table(['Map','Visit stage(s)','Unique trainers','Minimal-route EXP','Typical expected stock','All scheduled stock','Trainer level min/median/max','Day wild EXP/KO','Access'],[[r['map'],','.join(json.loads(r['trainer_exp_by_visit_stage']).keys()) or r['stage'],r['one_time_events'],fmt(r['mandatory_scenario_solo_exp']),fmt(r['typical_expected_solo_exp']),fmt(r['max_scheduled_one_time_solo_exp']),'/'.join([r['min_trainer_level'] or '—',r['median_trainer_level'] or '—',r['max_trainer_level'] or '—']),f"{float(r['day_wild_mean_exp']):.1f}",r['requirements']] for r in zones]))
    (HERE/'ZONE_REVIEW.md').write_text('\n'.join(zp),encoding='utf-8')
    # Ranked, concrete recommendations with magnitudes tied to computed output.
    fix=f'''# Priority fixes — recommendations only

No implementation is included. The audit does not endorse a global EXP multiplier or assume the displayed exact-cap deficit must all be filled.

| Rank | Scope / severity | Evidence | Smallest defensible next change | Measured effect / limit |
|---|---|---|---|---|
|1|Ecruteak Eusine — serious combat/progression mismatch|`maps/EcruteakCity.asm:36–65`, native three-badge trigger; five Pokémon at 38–40 under cap 25|Gate `EcruteakCityEusineTrigger` until the Radio Tower/late-Johto event, or select a separate early team. Preserve the existing late fight.|Removes a verified 15-level ace/cap mismatch. Default safe-itinerary EXP is unchanged; the early-hazard overlay exposes its different timing. Handle this separately from EXP buffs.|
|2|Post-League rematches / Silver — serious EXP-budget mismatch|Eight unique Johto rematches offer {fmt(rematch_pool)} EXP; typical balanced six-team before Clair rematch {lv(at('Clair rematch')['levels'])} versus 84; before Red {lv(r6['levels'])} versus 90|Choose a coherent late-game target curve before adding isolated trainers. Reuse/expand existing unique training opportunities or test a targeted late catch-up mechanic if the 80–90 endpoint must stay; otherwise retarget the boss ramp.|Current Red exact-target shortfall {fmt(r6['target_shortfall'])}; at least {math.ceil(r6['target_shortfall']/39336)} ideal max-yield six-mon battles equivalent. The tested lower-level ramp helps four members far more than six and is NOT a complete accepted fix.|
|3|Misty→Surge and final Kanto — moderate/serious for six|Surge balanced six = {lv(at('Surge')['levels'])} versus 58; Blue = {lv(b6['levels'])} versus 69. Most stock is frontloaded into other legs.|Budget existing Vermilion/Route 6 and Viridian battles against six-member growth costs; favor meaningful existing-party changes or better stock timing before adding encounters.|The tested +3 levels on Route 6 / ordinary Vermilion Gym trainers changes the six-team Surge deficit by only {fmt(abs(float(tr('surge_trainers_plus3','Surge')['shortfall_change'])))} EXP. Treat it as insufficient. Moving stock from Misty can worsen that segment.|
|4|Recruitment support and cap policy — moderate, affects experimenting players|Low old-area replacements lag; stage-appropriate catches can help; own catches can retain over-cap levels; Day Care banks EXP|Make intended stage-appropriate recruits and catch-up opportunities explicit. Decide whether acquired over-cap levels and Day Care banking are intended before tuning around a strict earned-EXP cap.|Use the replacement CSV to target gift/old-area cases. Do not raise all wild levels: Route 35 already has level 21 encounters under Whitney's cap 20. No blanket new sharing/catch-up mechanic is claimed tested here.|
|5|Chuck/Lighthouse/Jasmine — monitor six-member distribution; previous four-member shortage overstated|Corrected default: Cianwood/Chuck, then 11 Lighthouse battles (30,804 solo Hard EXP), then Jasmine. Typical selected segment stock = {fmt(at('Jasmine')['segment_solo_available'])}. Levels: four = {lv(j4['levels'])}; six = {lv(j6['levels'])}|Keep the existing Lighthouse timing. Test full-team readiness and recruitment distribution before changing local levels or caps. Returning with medicine before Chuck remains a valid route alternative.|Four typical members now finish within 1–2 levels of cap 34. Earlier advice to relocate Rosie/Dahlia/Ernest is withdrawn: those battles already occupy the correct segment. A local +3 gym-trainer trial and cap32 trial are sensitivities, not accepted fixes.|

The aggressive late retarget overlay, cap32 test, permitted Lighthouse-before-Chuck route, local Olivine/Vermilion trainer tests and combined trial are in [hypotheses.json](hypotheses.json) and [hypothetical_changes.csv](hypothetical_changes.csv). The obsolete Lighthouse-redistribution proposal has been removed. Review every team size and later checkpoint before choosing an implementation. The largest shortage cannot honestly be fixed with an advertised “one or two trainers” change.
'''
    (HERE/'PRIORITY_FIXES.md').write_text(fix,encoding='utf-8')
    correction=f'''# Lighthouse timing correction

The original audit assigned Lighthouse trainers before Chuck and incorrectly described the Lighthouse as available before Morty. That overlooked Jasmine's entrance scene/object and the Secretpotion handoff. The author identified the mistake; all campaign simulations, databases, charts, recommendations and the ZIP have been regenerated with corrected timing.

## Actual sequence and modeled route

- Jasmine explains Amphy's sickness outside and blocks the doorway while waiting for medicine. Source: {src('maps/OlivineCity.asm:25')}, {src('maps/OlivineCity.asm:74')}, {src('maps/OlivineCity.asm:496')}.
- Cianwood's pharmacist supplies the Secretpotion after that explanation: {src('maps/CianwoodPharmacy.asm:13')}.
- Delivering it outside sets `EVENT_JASMINE_RECEIVED_SECRETPOTION`, after which Jasmine enters the Lighthouse: {src('maps/OlivineCity.asm:92')}.
- **Corrected default:** Cianwood trip → Chuck → return with medicine → Lighthouse → Jasmine. This is a route assumption, not a claim that the medicine script checks Chuck's badge.
- **Permitted alternative:** collect the medicine and return/climb before Chuck. The `lighthouse_before_chuck` scenario compares that legal route, with Cianwood events preceding the climb. Earliest Lighthouse access is therefore after Surf/the Cianwood trip, not before Morty.

## EXP and revised assessment

The Lighthouse contains **11 distinct trainer battles, totaling 30,804 solo-equivalent Hard EXP**. The three ordinary Olivine Gym trainers add **{fmt(jasmine_gym_pool)}**, for **{fmt(30804+jasmine_gym_pool)}** if all 14 battles are fought. This is battle stock, not an EXP award to every party member; participant floors and cap clipping still apply.

The original published typical/equal-rotation Jasmine levels were four **31/31/30/30** and six **30/30/30/30/30/24**. Those values are obsolete. The corrected results below show that four members can approach Jasmine naturally; most do not need to hit 34 exactly for the segment to be healthy. The six-member party is more sensitive to its undertrained Slow-growth recruit and the EXP reserved from Chuck.

'''
    cr=[]
    for style in ['typical','thorough','completionist']:
        for n in [4,6]:
            chuck=at('Chuck',n,style=style);jas=at('Jasmine',n,style=style)
            early=tr('lighthouse_before_chuck','Jasmine',n,style=style)
            cr.append([style,n,lv(chuck['levels']),lv(jas['levels']),lv(json.loads(early['levels'])),fmt(jas['segment_solo_available'])])
    correction+=table(['Playstyle','Team','Chuck: corrected default','Jasmine: Lighthouse after Chuck','Jasmine: Lighthouse before Chuck','Default Jasmine selected trainer stock'],cr)
    correction+='''
All rows use equal KO rotation, declared travel assumptions and the same staggered cohorts; they are scenarios, not measured player telemetry or guaranteed combat outcomes.

**Recommendation withdrawn:** relocating Rosie, Dahlia or Ernest into Jasmine's segment. The intended route already puts the whole Lighthouse there. Jasmine is downgraded from a proposed immediate local fix to a full-team distribution/playtest check. Do not lower her cap merely to improve an exact-cap statistic when four-member teams already finish close to it. The cap32 and ordinary-gym +3 trials are retained as experiments, not endorsed changes.

This correction does not erase the separately measured late Kanto/post-League deficits or the independently verified early Eusine trigger. No gameplay files were changed.
'''
    (HERE/'LIGHTHOUSE_CORRECTION.md').write_text(correction,encoding='utf-8')
    print('Built report, boss catalog, every-map review, combined milestone CSV and ranked fixes.')

if __name__=='__main__':main()
