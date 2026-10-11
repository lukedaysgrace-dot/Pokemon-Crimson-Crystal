"""Build an evidence-backed, recommendation-only roster review from current ROM sources.

Does not edit game data or regenerate the public documentation site.
"""
from pathlib import Path
import collections
import csv
import hashlib
import html
import importlib.util
import json
import re
import subprocess
import math

from audit_learnset_variety import load_sources

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'docs' / 'audits' / 'pokemon-balance-review-2026-10-09'
TYPES = 'NORMAL FIRE WATER ELECTRIC GRASS ICE FIGHTING POISON GROUND FLYING PSYCHIC BUG ROCK GHOST DRAGON DARK STEEL FAIRY'.split()
UTILITY = ['SUBSTITUTE', 'SLEEP_TALK', 'REFLECT', 'LIGHT_SCREEN', 'THUNDER_WAVE']
STATS = ['HP', 'Attack', 'Defense', 'Speed', 'Sp. Atk', 'Sp. Def']
def read(p): return (ROOT / p).read_text(encoding='utf-8')
def pretty(c): return c.replace('_', ' ').title()

SETUP = set('SWORDS_DANCE DRAGON_DANCE QUIVER_DANCE NASTY_PLOT SHELL_SMASH BELLY_DRUM CALM_MIND BULK_UP AGILITY ROCK_POLISH IRON_DEFENSE AMNESIA WORK_UP HONE_CLAWS'.split())
RECOVERY = set('RECOVER ROOST SOFTBOILED SLACK_OFF MOONLIGHT MORNING_SUN SYNTHESIS WISH MILK_DRINK'.split())
PRIORITY = set('EXTREMESPEED AQUA_JET BULLET_PUNCH MACH_PUNCH SUCKER_PUNCH SHADOW_SNEAK ICE_SHARD QUICK_ATTACK ACCELROCK FAKE_OUT'.split())
SUPPORT = set('STEALTH_ROCK STICKY_WEB SPIKES TOXIC_SPIKES RAPID_SPIN DEFOG MORTAL_SPIN U_TURN VOLT_SWITCH FLIP_TURN TELEPORT HAZE WHIRLWIND ROAR TAUNT ENCORE HEAL_BELL LEECH_SEED'.split())
CONTROL = set('SPORE SLEEP_POWDER HYPNOSIS LOVELY_KISS SING THUNDER_WAVE GLARE NUZZLE WILL_O_WISP TOXIC'.split())

def ability_synergy(data,row):
    engine=read('engine/battle/abilities_engine.asm');moves=data['moves'];pool=set(row['pool'])
    def members(label):
        body=engine.split(label+':',1)[1].split('\tdw -1',1)[0]
        return set(re.findall(r'^\s*dw\s+(\w+)',body,re.M))
    named={a:members(lab) for a,lab in [('IRON_FIST','PunchMoves'),('SHARPNESS','SliceMoves'),('MEGA_LAUNCHER','PulseMoves'),('STRONG_JAW','BiteMoves'),('TRIAGE','TriageMoves')]}
    sfbody=engine.split('SheerForceEffects:',1)[1].split('\tdb -1',1)[0]
    sffects=set(re.findall(r'^\s*db\s+(\w+)',sfbody,re.M))
    variable={'HIDDEN_POWER','RETURN','FRUSTRATION','FLAIL','REVERSAL','GYRO_BALL','RAGE_FIST','MAGNITUDE','PRESENT','LOW_KICK','GRASS_KNOT','WEATHER_BALL','HEX','INFERNAL_PARADE','ACROBATICS','AVALANCHE','PURSUIT','FURY_CUTTER','ROLLOUT'}
    physical={m for m in pool if moves[m]['category']=='PHYSICAL' and moves[m]['power']>0}
    special={m for m in pool if moves[m]['category']=='SPECIAL' and moves[m]['power']>0}
    output=[]
    for slot,a in enumerate(row['abilities'],1):
        matches=set();comment=data['abilities'][a]
        if a in named:
            matches=pool&named[a];comment+=' Matching moves come from the engine membership list.'
        elif a=='SHEER_FORCE':
            matches={m for m in pool if moves[m]['power']>0 and moves[m]['chance']>0 and moves[m]['effect'] in sffects}
            comment+=' These attacks have a nonzero qualifying secondary effect; that effect is removed. Life Orb recoil is suppressed only on qualifying attacks.'
        elif a=='TECHNICIAN':
            matches={m for m in pool-variable if 0<moves[m]['power']<=60 and moves[m]['effect'] not in {'EFFECT_OHKO','EFFECT_LEVEL_DAMAGE','EFFECT_STATIC_DAMAGE','EFFECT_COUNTER','EFFECT_MIRROR_COAT'}}
            comment+=' Listed matches are fixed stored-power candidates, per hit. Variable-power conditions are excluded here; Hidden Power resolves to 70 and does not qualify.'
        elif a in {'PIXILATE','AERILATE','GALVANIZE','REFRIGERATE'}:
            matches={m for m in pool if m not in {'HIDDEN_POWER','WEATHER_BALL'} and moves[m]['type']=='NORMAL' and moves[m]['power']>0}
            comment+=' Candidates are converted Normal attacks, with the engine conversion boost. Resolve variable-power moves before comparison.'
        elif a in {'HUGE_POWER','GUTS','HUSTLE'}:
            matches=physical;comment+=' Relevant to physical offense, not special damage. Guts/Hustle costs and item/status requirements are separate.'
        elif a=='SOLAR_POWER':
            matches=special;comment+=' Requires sun and causes HP loss; it does not also summon weather or double Speed.'
        elif a=='TOUGH_CLAWS':
            matches={m for m in pool if moves[m]['power']>0 and moves[m]['contact']};comment+=' Matches use this ROM contact bitfield, not type/category guesses.'
        elif a in {'RECKLESS','ROCK_HEAD'}:
            matches={m for m in pool if moves[m]['effect'] in {'EFFECT_RECOIL_HIT','EFFECT_FLARE_BLITZ','EFFECT_VOLT_TACKLE'} or (a=='RECKLESS' and moves[m]['effect']=='EFFECT_JUMP_KICK')}
        elif a=='ADAPTABILITY':
            matches={m for m in pool if moves[m]['power']>0 and moves[m]['type'] in row['types']};comment+=' Native STAB candidates; resolve dynamic type/category moves separately.'
        elif a=='SKILL_LINK':
            matches={m for m in pool if moves[m]['effect'] in {'EFFECT_MULTI_HIT','EFFECT_POISON_MULTI_HIT','EFFECT_TRIPLE_KICK'}}
            comment+=' Fixed two-hit attacks and special accuracy-dependent moves still need their own routines checked.'
        elif a in {'SERENE_GRACE','POISON_PUPPETEER','MERCILESS'}:
            if a=='SERENE_GRACE':matches={m for m in pool if moves[m]['power']>0 and 0<moves[m]['chance']<100}
            else:matches={m for m in pool if m in {'TOXIC','TOXIC_SPIKES','POISON_GAS'} or moves[m]['effect'] in {'EFFECT_POISON_HIT','EFFECT_POISON_FANG','EFFECT_POISON_MULTI_HIT','EFFECT_BARBS_BARRAGE','EFFECT_BARB_BARRAGE'}}
            comment+=' A candidate list, not a guarantee that every shared effect can trigger the ability. Poison payoff may rely on teammates.'
        elif a=='BAD_DREAMS':
            matches={m for m in pool if moves[m]['effect']=='EFFECT_SLEEP'};comment+=' Sleep can also be supplied by teammates; no simultaneous accuracy ability is assumed.'
        elif a=='CONTRARY':
            matches=pool&{'SUPERPOWER','LEAF_STORM','DRACO_METEOR','OVERHEAT','CLOSE_COMBAT','SHELL_SMASH','HAMMER_ARM','CURSE'}
            comment+=' Inverts self changes as well as opponents\' changes; Curse/Shell Smash have inverted costs and benefits.'
        elif a in {'PRANKSTER','GALE_WINGS'}:
            matches={m for m in pool if moves[m]['category']=='STATUS'} if a=='PRANKSTER' else {m for m in pool if moves[m]['type']=='FLYING'}
            comment+=' Priority targeting/blocking rules still apply; this is one ability slot only.'
        elif a in {'DROUGHT','DRIZZLE','SNOW_WARNING','SAND_STREAM','CHLOROPHYLL','SWIFT_SWIM','SLUSH_RUSH','SAND_RUSH','RAIN_DISH','ICE_BODY','HYDRATION','MEGA_SOL'}:
            matches=pool&({'SOLARBEAM','SOLAR_BLADE','WEATHER_BALL','SYNTHESIS','MORNING_SUN','MOONLIGHT','GROWTH','FIRE_BLAST','FLAMETHROWER'} if a in {'DROUGHT','CHLOROPHYLL','MEGA_SOL'} else {'THUNDER','HURRICANE','WEATHER_BALL','REST','SURF','HYDRO_PUMP','SCALD'} if a in {'DRIZZLE','SWIFT_SWIM','RAIN_DISH','HYDRATION'} else {'BLIZZARD','WEATHER_BALL','PROTECT'} if a in {'SNOW_WARNING','SLUSH_RUSH','ICE_BODY'} else {'EARTHQUAKE','STONE_EDGE','ROCK_SLIDE','IRON_HEAD','PROTECT'})
            comment+=' Setter, Speed and recovery abilities are separate alternatives. Team/weather access determines the actual combination.'
        elif a in {'SPEED_BOOST','POISON_HEAL','REGENERATOR','MAGIC_GUARD','MULTISCALE','DISGUISE','UNAWARE','FUR_COAT','STAMINA'}:
            matches=pool&(SETUP|RECOVERY|{'PROTECT','SUBSTITUTE','BODY_PRESS','FACADE','HAZE','TAUNT','ENCORE','U_TURN','VOLT_SWITCH','FLIP_TURN'})
            comment+=' These are complementary tools, not additional ability effects. Item, HP, switch and stage conditions must be tested.'
        if a=='NO_ABILITY':comment='Empty slot: falls back to the first ability, rather than selecting a no-ability build.'
        output.append(dict(slot=slot,ability=a,description=comment,matches=sorted(matches)))
    return output

def load_notes(data):
    notes={}
    for line in read('tools/testdata/balance_review_notes.txt').splitlines():
        if not line.strip() or line.startswith('#'):continue
        c,verdict,priority,note=line.split('|',3)
        assert c in data['roster'] and c not in notes,c
        notes[c]=dict(verdict=verdict,priority=int(priority),note=note,review_kind='Individual design assessment')
    for c,r in data['roster'].items():
        if c.endswith('_CLONE'):
            original=c[:-6];src=data['roster'][original]
            for field in ['stats','types','abilities','level_up','tmhm','egg_moves','utility_tutors']:
                assert r[field]==src[field],(c,field,'clone mismatch')
            if original in notes:
                notes[c]={**notes[original],'note':f'Clone mirror of {src["name"]}. '+notes[original]['note'],'review_kind':'Clone mirror (source checked)'}
        if c not in notes:
            assert r['children'],(c,'unreviewed final evolution')
            stat=r['stats'];role='physical' if stat['Attack']-stat['Sp. Atk']>=20 else 'special' if stat['Sp. Atk']-stat['Attack']>=20 else 'mixed'
            important=[(lv,m) for lv,m in r['level_up'] if m in SETUP|RECOVERY|PRIORITY|SUPPORT|CONTROL]
            milestones=', '.join(f'{data["moves"][m]["name"]} at {lv}' for lv,m in important[:5]) or 'Its complete move timing and tutor support are listed below'
            evo='; '.join(r['evolutions'])
            note=f'Retain this {r["bst"]}-BST {role}-leaning progression stage. Its current ability choices and '+'/'.join(pretty(t) for t in r['types'])+f' typing must be assessed at its obtainable level, before evolving into '+', '.join(data['roster'][child]['name'] for child in r['children'])+f'. Relevant own-list milestones: {milestones}. Evolution route: {evo}. '
            if r['bst']>=400:note+='Because it can still evolve, Eviolite is a meaningful alternate build; compare actual bulk and item freedom with its evolution before giving more stats.'
            elif r['bst']<=250:note+='Low stats are appropriate for an early/baby or intentionally restricted stage; judge access to useful training moves and the evolution route rather than raising it to final-evolution strength.'
            else:note+='No independent stat or typing buff is proposed from source inspection. Check its own timing and retained moves when changing the family; evolution should remain its principal long-term reward.'
            notes[c]=dict(verdict='Keep',priority=3,note=note,review_kind='Source-based progression assessment')
    return notes

def validate_proposals(data,proposals):
    roster=data['roster'];moves=data['moves'];checks=0
    for p in proposals['changes']:
        c=p['species'];r=roster[c];kind=p['kind'];assert p['priority'] in {1,2,3};checks+=1
        if kind=='stats':
            for stat,(old,new) in p['values'].items():assert r['stats'][stat]==old and old!=new and 1<=new<=255,(c,stat);checks+=1
        elif kind=='level':
            changes={c:p['levels'],**p.get('family_changes',{})}
            if p.get('mirror_clones'):changes.update({mon+'_CLONE':ls for mon,ls in list(changes.items())})
            for mon,(old,new) in changes.items():assert (old,p['move']) in roster[mon]['level_up'] and 1<=new<=100 and old!=new,(mon,p);checks+=1
        elif kind=='add_level':
            for mon in [c]+p.get('family_additions',[]):assert p['move'] in moves and p['move'] not in roster[mon]['pool'],(mon,'redundant addition',p);checks+=1
        elif kind=='remove':
            assert p['move'] in r['pool'],p
            assert all(mon in roster for mon in p['family_scope']);checks+=1
        elif kind=='ability':assert r['abilities'][p['slot']-1]==p['abilities'][0] and p['abilities'][1] in data['abilities'] and p['abilities'][0]!=p['abilities'][1],p;checks+=1
        elif kind=='move_chance':assert moves[p['move']]['chance']==p['chances'][0] and p['chances'][0]!=p['chances'][1],p;checks+=1
        elif kind=='engine':assert p['ability'] in r['abilities'] and (ROOT/p['source']).exists(),p;checks+=1
        else:raise AssertionError(kind)
    for s in proposals['example_sets']:
        r=roster[s['species']]
        assert len(s['moves'])==len(set(s['moves']))==4,s
        assert set(s['moves'])<=set(r['pool']),(s['species'],'unavailable move',set(s['moves'])-set(r['pool']))
        assert s['ability'] in r['abilities'] and s['item'] in data['items'],s
        checks+=4
    return checks

def apply_family_notes(data,notes,proposals):
    for p in proposals['changes']:
        c=p['species'];kind=p['kind']
        if kind=='level':
            changes={c:p['levels'],**p.get('family_changes',{})}
            if p.get('mirror_clones'):changes.update({mon+'_CLONE':ls for mon,ls in list(changes.items())})
            for mon,(old,new) in changes.items():
                if mon==c:continue
                notes[mon]=dict(verdict=notes[c]['verdict'],priority=p['priority'],review_kind='Family timing assessment',note=f'Apply the {data["roster"][c]["name"]} family timing change here too: {data["moves"][p["move"]]["name"]} level {old} → {new}. '+('Mirror the non-clone stage. ' if mon.endswith('_CLONE') else '')+'This prevents retaining the move early and bypassing the evolved species restriction. Preserve this stage\'s stats, typing, other moves and abilities; review its ordinary progression role separately.')
        elif kind=='remove':
            for mon in p['family_scope']:
                if mon==c or p['move'] not in data['roster'][mon]['pool']:continue
                notes[mon]=dict(verdict='Nerf movepool',priority=p['priority'],review_kind='Family move-route assessment',note=f'Remove {data["moves"][p["move"]]["name"]} from this actual acquisition route as part of the {data["roster"][c]["name"]} recommendation. Current sources: '+', '.join(data['roster'][mon]['move_sources'][p['move']])+'. Retaining it here would bypass the evolved species removal. Keep other stats, abilities and moves unchanged.')
        elif kind=='engine':
            for mon,r in data['roster'].items():
                if mon!=c and p['ability'] in r['abilities']:
                    notes[mon]=dict(verdict='Nerf ability rule',priority=p['priority'],review_kind='Shared ability-rule assessment',note=f'The proposed {pretty(p["ability"])} full-HP priority condition affects this holder as well as {data["roster"][c]["name"]}. Keep this stage\'s stats and moves. Verify early campaign priority at full/damaged HP rather than treating the change as exclusive to the final evolution.')
    for c,r in data['roster'].items():r.update(notes[c]);r['ability_synergies']=ability_synergy(data,r)

def proposal_text(p,data):
    mn=lambda m:data['moves'][m]['name']
    if p['kind']=='stats':return '; '.join(f'{s} {old} → {new}' for s,(old,new) in p['values'].items())
    if p['kind']=='level':
        extra='; family and clone mirrors included' if p.get('mirror_clones') else '; family included' if p.get('family_changes') else ''
        return f'{mn(p["move"])} level {p["levels"][0]} → {p["levels"][1]}'+extra
    if p['kind']=='remove':return 'Remove '+mn(p['move'])+' from actual routes in '+', '.join(data['roster'][c]['name'] for c in p['family_scope'] if p['move'] in data['roster'][c]['pool'])
    if p['kind']=='add_level':return f'Add {mn(p["move"])} at level {p["level"]}'+(' (also '+', '.join(data['roster'][c]['name'] for c in p['family_additions'])+')' if p.get('family_additions') else '')
    if p['kind']=='ability':return f'Slot {p["slot"]}: {pretty(p["abilities"][0])} → {pretty(p["abilities"][1])}'
    if p['kind']=='move_chance':return f'{mn(p["move"])} effect chance {p["chances"][0]}% → {p["chances"][1]}%'
    return p['rule']

def write_reports(data,proposals,checks):
    OUT.mkdir(parents=True,exist_ok=True)
    roster=data['roster'];moves=data['moves'];esc=html.escape
    counts=collections.Counter(r['verdict'] for r in roster.values())
    mv=lambda m:'Empty slot' if m in {'0','NO_MOVE'} else moves[m]['name']
    nms=lambda ms:', '.join(mv(m) for m in ms) or 'None'
    relative_source=lambda path:'../../../'+path
    metadata=dict(species_records=len(roster),non_clone_records=sum(not c.endswith('_CLONE') for c in roster),terminal_records=sum(not r['children'] for r in roster.values()),
        individual_non_clone_assessments=sum(r['review_kind']=='Individual design assessment' for r in roster.values()),verdict_counts=dict(counts),
        proposal_groups=len(proposals['changes']),example_sets=len(proposals['example_sets']),proposal_validation_checks=checks,source_files_hashed=len(data['snapshot']['source_hashes']),**data['snapshot'])
    data['review_summary']=metadata
    (OUT/'source-data.json').write_text(json.dumps(data,indent=2,ensure_ascii=False),encoding='utf-8')
    (OUT/'recommendations.json').write_text(json.dumps(proposals,indent=2,ensure_ascii=False),encoding='utf-8')
    (OUT/'validation.json').write_text(json.dumps(metadata,indent=2,ensure_ascii=False),encoding='utf-8')
    with (OUT/'roster.csv').open('w',newline='',encoding='utf-8-sig') as fh:
        cols=['Species','Name','Verdict','Priority','Assessment','Types','HP','Attack','Defense','Speed','Sp. Atk','Sp. Def','BST','Ability 1','Ability 2','Hidden ability','Evolves into','Own level-up','TM/HM/tutors','Egg moves','Utility tutors','Retained moves','Notes']
        writer=csv.DictWriter(fh,fieldnames=cols);writer.writeheader()
        for c in data['order']:
            r=roster[c]
            writer.writerow({'Species':c,'Name':r['name'],'Verdict':r['verdict'],'Priority':r['priority'],'Assessment':r['review_kind'],'Types':'/'.join(map(pretty,r['types'])),**r['stats'],'BST':r['bst'],
                'Ability 1':pretty(r['abilities'][0]),'Ability 2':pretty(r['abilities'][1]),'Hidden ability':pretty(r['abilities'][2]),'Evolves into':', '.join(roster[c]['name'] for c in r['children']),
                'Own level-up':'; '.join(f'{lv}: {mv(m)}' for lv,m in r['level_up']),'TM/HM/tutors':'; '.join(f'{data["tm_labels"][m]}: {mv(m)}' for m in r['tmhm']),
                'Egg moves':nms(r['egg_moves']),'Utility tutors':nms(r['utility_tutors']),'Retained moves':nms(r['inherited']),'Notes':r['note']})
    intro=read('tools/testdata/balance_review_methodology.md')
    stats='\n\n## Snapshot and coverage\n\n'+f'- Commit: `{data["snapshot"]["git_commit"]}`\n- {len(roster)} species records, {len(moves)} move records, {metadata["source_files_hashed"]} hashed source files.\n- {data["trainer_party_count"]} fixed trainer parties / {data["trainer_record_count"]} trainer Pokémon records; {data["tower_record_count"]} Tower builds including the reserved Mew.\n- {len(proposals["changes"])} proposed change groups; {len(proposals["example_sets"])} source-validated illustrative four-move builds.\n- Verdicts: '+', '.join(f'{v} {k}' for k,v in counts.items())+'.\n\nThese counts include intermediate stages and mirrored clones. They are coverage counts, not independent competitive species or simulated wins.\n'
    ledger='\n## Exact proposal ledger\n\n| Target | Priority | Recommendation |\n|---|---:|---|\n'
    for p in proposals['changes']:ledger+=f'| {roster[p["species"]]["name"]} | {p["priority"]} | {proposal_text(p,data)} |\n'
    links='\n## Files\n\n- [Searchable full roster](index.html) — use name, type, ability or move, then expand the source data.\n- [Every species, readable Markdown](FULL_ROSTER.md) — full judgments and learnsets.\n- [Roster CSV](roster.csv) — editable/filterable review table.\n- [Exact recommendations and builds](recommendations.json).\n- [Extracted source evidence](source-data.json) and [snapshot checks](validation.json).\n\nRegenerate without editing game data with `python tools/build_balance_review.py` from the repository root. The existing source audit can be run separately with `python tools/audit_learnset_variety.py`.\n'
    (OUT/'README.md').write_text(intro+stats+ledger+links,encoding='utf-8')
    md=['# Every Pokémon: source-backed balance assessment','', 'Recommendations only. Main setting: Enhanced typing/stats, abilities enabled. Stats are in HP / Attack / Defense / Speed / Sp. Atk / Sp. Def order. Full move sources do not imply instant access at every point in the campaign.','', '[Read methodology and priorities](README.md) · [Searchable report](index.html)','']
    cards=[]
    examples=collections.defaultdict(list)
    for s in proposals['example_sets']:examples[s['species']].append(s)
    for c in sorted(roster,key=lambda c:(roster[c]['name'].lower(),c)):
        r=roster[c];st='/'.join(str(v) for v in r['stats'].values());types='/'.join(map(pretty,r['types']))
        typematch=lambda matrix:', '.join(f'{pretty(t)} ×{v:g}' for t,v in matrix.items() if v!=1) or 'All neutral'
        md += [f'## {r["name"]} — {r["verdict"]} (priority {r["priority"]})','',f'`{c}` · {types} · {st} · BST {r["bst"]} · {r["review_kind"]}','',r['note'],'',
            f'**Abilities:** 1. {pretty(r["abilities"][0])}; 2. {pretty(r["abilities"][1])}; hidden. {pretty(r["abilities"][2])}. One active ability at a time.','',
            '**Type-only matchups:** '+typematch(r['type_matchups'])+'.','',
            '**Original stats/types:** '+ '/'.join(str(v) for v in r['original_stats'].values())+'; '+ '/'.join(map(pretty,r['original_types']))+'. These settings are independent.','',
            '**Evolution:** '+('; '.join(r['evolutions']) or 'No further evolution')+'. **Growth:** '+pretty(r['growth'].replace('GROWTH_',''))+'.','',
            '**Own level-up:** '+ '; '.join(f'{lv}: {mv(m)}' for lv,m in r['level_up'])+'.','',
            '**TM/HM/elemental tutor compatibility:** '+('; '.join(f'{data["tm_labels"][m]}: {mv(m)}' for m in r['tmhm']) or 'None')+'.','',
            '**Egg tutor/breeding:** '+nms(r['egg_moves'])+'. **Utility/special tutors:** '+nms(r['utility_tutors'])+'.','',
            '**Pre-evolution moves available by retention:** '+nms(r['inherited'])+'.','']
        synergy_html=[]
        for a in r['ability_synergies']:
            extra=nms(a['matches'])
            md += [f'- **{pretty(a["ability"])} (slot {a["slot"]}):** {a["description"]}'+(' Candidates: '+extra+'.' if a['matches'] else ''),'']
            synergy_html.append(f'<li><b>{esc(pretty(a["ability"]))} <small>slot {a["slot"]}</small></b><p>{esc(a["description"])}</p>'+ (f'<p class="muted">Candidates: {esc(extra)}</p>' if a['matches'] else '')+'</li>')
        set_html=[]
        for s in examples[c]:
            build=f'{pretty(s["ability"])} / {pretty(s["item"])} / '+nms(s['moves'])
            md += ['**Illustrative current build:** '+build+'. '+s['purpose'],'']
            set_html.append(f'<div class="build"><b>{esc(pretty(s["ability"]))} · {esc(pretty(s["item"]))}</b><p>{esc(nms(s["moves"]))}</p><p class="muted">{esc(s["purpose"])}</p></div>')
        important={k:sorted(set(r['pool'])&ms) for k,ms in [('Setup',SETUP),('Direct recovery/Wish',RECOVERY),('Priority attacks',PRIORITY),('Control',CONTROL),('Field/pivot/disruption',SUPPORT)]}
        toolkit=''.join(f'<p><b>{label}:</b> {esc(nms(ms))}</p>' for label,ms in important.items() if ms)
        for label,ms in important.items():
            if ms:md += [f'**{label}:** '+nms(ms)+'.','']
        encounters=sorted(set((e['location'],e['method'],str(e['level']),e.get('time') or '') for e in r['encounters']))
        encounter_text='; '.join(f'{loc} — {method}, lv {lv} ({tm})' for loc,method,lv,tm in encounters) or 'No mapped wild entry. Gifts, trades, scripted encounters and evolution were not inferred from absence.'
        md += ['**Mapped wild evidence:** '+encounter_text,'',f'**Fixed trainers:** {len(r["trainer_appearances"])} Pokémon records. **Tower:** {len(r["tower_appearances"])} builds. Explicit enemy moves are not added to the player pool.','']
        trainer_rows=[]
        for t in r['trainer_appearances']:
            enemy_moves=[m for m in t['moves'] if m!='NO_MOVE'];outside=[m for m in enemy_moves if m not in r['pool']]
            slot={'ABILITY_1':0,'ABILITY_2':1,'HIDDEN_ABILITY':2}.get(t['ability'])
            ability=pretty(r['abilities'][slot]) if slot is not None else 'Default/random slot'
            detail=f'{t["name"]} ({t["group"]} #{t["party"]}) · Lv {t["level"]} · {pretty(t["item"])} · {ability} · '+(nms(enemy_moves) if enemy_moves else 'Uses automatic level-up moves')
            if outside:detail+=' · Enemy-only listed moves: '+nms(outside)
            trainer_rows.append(f'<li>{esc(detail)} <a href="{relative_source("data/trainers/parties.asm")}">source line {t["source_line"]}</a></li>')
        for t in r['tower_appearances']:
            detail=f'Tower '+(f'room Lv {t["group"]*10}' if t['group'] is not None else 'reserved final Mew')+f' · {pretty(t["item"])} · {t["ability"]} · '+nms(t['moves'])+f' · stat experience {t["stat_exp"]}'
            if t['outside_player_pool']:detail+=' · Enemy-only listed moves: '+nms(t['outside_player_pool'])
            trainer_rows.append(f'<li>{esc(detail)} <a href="{relative_source("data/battle_tower/parties.asm")}">source line {t["source_line"]}</a></li>')
            md += ['**Tower build:** '+detail+'.','']
        source=f'[{r["source"]}]({relative_source(r["source"])}) (abilities at line {r["source_line"]}); [{r["learnset_source"]}]({relative_source(r["learnset_source"])}) (table at line {r["learnset_source_line"]}).'
        md += ['**Source:** '+source,'','---','']
        level_rows=[]
        for lv,m in r['level_up']:
            mo=moves[m];power='Dynamic; see engine' if m in {'HIDDEN_POWER','RETURN','FRUSTRATION','RAGE_FIST','LOW_KICK','GRASS_KNOT','GYRO_BALL','MAGNITUDE','PRESENT','FLAIL','REVERSAL','WEATHER_BALL'} else str(mo['power']) if mo['power'] else '—'
            level_rows.append(f'<tr><td>{lv}</td><td>{esc(mv(m))}</td><td>{esc(pretty(mo["type"]))}</td><td>{esc(pretty(mo["category"]))}</td><td>{power}</td><td>{mo["accuracy"]}%</td><td>{mo["pp"]}</td></tr>')
        tmtext='; '.join(f'{data["tm_labels"][m]} {mv(m)}' for m in r['tmhm']) or 'None'
        inherited_html=''.join(f'<li><b>{esc(mv(m))}:</b> {esc("; ".join(s for s in r["move_sources"][m] if "retain before evolution" in s))}</li>' for m in r['inherited']) or '<li>None beyond the own list.</li>'
        search=' '.join([c,r['name'],types,r['verdict'],r['note']]+r['abilities']+[pretty(a) for a in r['abilities']]+r['pool']+[mv(m) for m in r['pool']]).lower()
        group='nerf' if r['verdict'].startswith('Nerf') else 'buff' if r['verdict'].startswith('Buff') else 'watch' if r['verdict']=='Watch' else 'reassign' if r['verdict'].startswith('Reassign') else 'keep'
        stage='clone' if c.endswith('_CLONE') else 'terminal' if not r['children'] else 'evolving'
        oldst='/'.join(str(v) for v in r['original_stats'].values());oldtypes='/'.join(map(pretty,r['original_types']))
        stats_table='<table class="stats"><thead><tr><th>Rule</th>'+''.join(f'<th>{esc(s)}</th>' for s in STATS)+'<th>BST</th></tr></thead><tbody><tr><th>Enhanced</th>'+''.join(f'<td>{v}</td>' for v in r['stats'].values())+f'<td>{r["bst"]}</td></tr><tr><th>Original</th>'+''.join(f'<td>{v}</td>' for v in r['original_stats'].values())+f'<td>{sum(r["original_stats"].values())}</td></tr></tbody></table>'
        card=f'''<article id="{c}" class="card {group}" data-search="{esc(search,quote=True)}" data-verdict="{group}" data-stage="{stage}" data-priority="{r['priority']}" data-types="{' '.join(r['types'])}">
<div class="card-head"><div><h2>{esc(r['name'])}</h2><p class="muted">{esc(types)} · {r['bst']} BST · {stage.title()} · <code>{c}</code></p></div><span class="badge">{esc(r['verdict'])} · P{r['priority']}</span></div>
<p class="assessment">{esc(r['note'])}</p><p class="muted assessment-kind">{esc(r['review_kind'])}</p>
<div class="scroll">{stats_table}</div><p><b>Ability alternatives:</b> {esc(' / '.join(map(pretty,r['abilities'])))}. Third slot is hidden. One active ability.</p>
<details><summary>Build combinations and useful tools</summary>{toolkit}<ul class="synergies">{''.join(synergy_html)}</ul>{''.join(set_html) or '<p class="muted">No individually specified example set. Lists above show candidate synergies; they are not a fifth-move build or a measured tier ranking.</p>'}</details>
<details><summary>Full learnsets and numbered TMs / HMs</summary><div class="scroll"><table><thead><tr><th>Level</th><th>Move</th><th>Table type</th><th>Category</th><th>Table power</th><th>Accuracy</th><th>PP</th></tr></thead><tbody>{''.join(level_rows)}</tbody></table></div><p class="muted">Table values are source facts. Dynamic moves, multi-hit attacks, charging and condition-dependent effects need their actual engine behavior considered. Hidden Power resolves to 70 power, with configurable type/category.</p><p><b>TM / HM / elemental tutors:</b> {esc(tmtext)}</p><p><b>Egg tutor / breeding:</b> {esc(nms(r['egg_moves']))}</p><p><b>Utility / special tutors:</b> {esc(nms(r['utility_tutors']))}</p><h3>Retain before evolution</h3><p class="muted">These moves must be learned on an earlier stage and retained; the current-species reminder does not automatically recover them.</p><ul>{inherited_html}</ul></details>
<details><summary>Typing, rule variants and evolution</summary><p><b>Enhanced type-only matchups:</b> {esc(typematch(r['type_matchups']))}</p><p><b>Original types:</b> {esc(oldtypes)}</p><p><b>Original type-only matchups:</b> {esc(typematch(r['original_type_matchups']))}</p><p class="muted">Stat/type settings are independent. Matchups exclude ability immunities, boosts, weather, items and suppression.</p><p><b>Evolutions:</b> {esc('; '.join(r['evolutions']) or 'No further evolution')}</p><p><b>Growth rate:</b> {esc(pretty(r['growth'].replace('GROWTH_','')))}</p></details>
<details><summary>Encounter and trainer evidence</summary><p>{esc(encounter_text)}</p><p class="muted">Mapped slots are not proof of earliest story access. Explicit enemy moves below do not establish player learnability or level-up timing.</p><ul>{''.join(trainer_rows) or '<li>No fixed trainer/Tower appearances in the parsed source.</li>'}</ul></details>
<p class="sources"><a href="{relative_source(r['source'])}">Base data</a> · abilities line {r['source_line']} · <a href="{relative_source(r['learnset_source'])}">Learnset table</a> · line {r['learnset_source_line']}</p></article>'''
        cards.append(card)
    (OUT/'FULL_ROSTER.md').write_text('\n'.join(md),encoding='utf-8')
    proposal_rows=''.join(f'<tr><td><a href="#{p["species"]}" class="jump">{esc(roster[p["species"]]["name"])}</a></td><td>P{p["priority"]}</td><td>{esc(proposal_text(p,data))}</td></tr>' for p in proposals['changes'])
    css='''*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;background:#f5f6fa;color:#182238;font:16px/1.6 system-ui,-apple-system,Segoe UI,sans-serif}header{background:#15253d;color:#fff;padding:44px max(24px,calc((100vw - 1120px)/2))}header p{max-width:850px;color:#d5deec}.eyebrow{text-transform:uppercase;letter-spacing:.12em;font-size:12px;font-weight:700}h1{font-size:clamp(30px,5vw,48px);line-height:1.15;margin:12px 0}h2{font-size:23px;line-height:1.3;margin:0}h3{font-size:17px}a{color:#315ec2;text-decoration:underline;text-underline-offset:3px}header a{color:#c7dcff}.container{max-width:1168px;margin:auto;padding:24px}.notice,.overview,.card{background:white;border:1px solid #dce2ed;border-radius:12px;padding:24px;margin-bottom:18px}.notice{border-left:5px solid #4274ba}.toolbar{position:sticky;top:0;z-index:2;background:#f5f6faf5;backdrop-filter:blur(8px);padding:14px 0;display:flex;gap:9px;flex-wrap:wrap}.toolbar input,.toolbar select,.toolbar button{font:inherit;border:1px solid #c0cad9;border-radius:7px;padding:9px 12px;background:white;color:#182238}.toolbar input{flex:1;min-width:225px}.toolbar button{cursor:pointer}.card{border-left:5px solid #8ba5cd;scroll-margin-top:100px}.card.nerf{border-left-color:#bb4856}.card.buff{border-left-color:#2e8b72}.card.watch{border-left-color:#b98424}.card.reassign{border-left-color:#8463b4}.card-head{display:flex;gap:12px;justify-content:space-between;align-items:flex-start}.badge{white-space:nowrap;border-radius:6px;padding:5px 9px;background:#eef1f6;font-size:12px;font-weight:700}.muted{color:#58667c;font-size:14px}.assessment{max-width:1000px}.assessment-kind{font-size:12px}.scroll{overflow:auto}table{border-collapse:collapse;width:100%;font-size:14px}th,td{text-align:left;border-bottom:1px solid #e1e6ef;padding:8px 10px}th{color:#4c5d77;background:#f7f9fc}.stats th,.stats td{text-align:center}.stats th:first-child{text-align:left}details{border-top:1px solid #e1e6ef;padding:12px 0}summary{cursor:pointer;font-weight:650;color:#29476d}details p{margin:10px 0}.synergies{list-style:none;padding:0}.synergies li{background:#f7f9fc;border-radius:8px;padding:14px;margin:10px 0}.synergies small{font-weight:400;color:#63718a}.build{border:1px solid #d9e0ec;border-radius:8px;padding:14px;margin:12px 0}.sources{font-size:12px;color:#6a7588;margin-bottom:0}code{font:12px ui-monospace,Consolas,monospace}.metrics{display:flex;flex-wrap:wrap;gap:12px;margin-top:22px}.metric{padding:10px 16px;background:#243b59;border-radius:8px}.metric b{display:block;font-size:25px}.metric span{font-size:12px;color:#d5deec}[hidden]{display:none!important}.resultbar{font-size:14px;color:#53647b;margin:6px 0 16px}.empty{padding:30px;text-align:center;color:#53647b}footer{color:#647189;font-size:13px;padding:20px 0}li{margin-bottom:6px}@media(max-width:650px){.container{padding:14px}.notice,.overview,.card{padding:16px}.card-head{display:block}.badge{display:inline-block;margin:8px 0}.toolbar{position:static}.toolbar select{flex:1}.stats{min-width:620px}}@media print{body{background:white;font-size:11px}.toolbar,.notice,.overview,.resultbar{display:none}header{padding:20px}header h1{font-size:25px}.card{break-inside:avoid;border-radius:0}details{display:block}details>summary{display:none}}'''
    script='''const cards=[...document.querySelectorAll('.card')];const search=document.querySelector('#search');const verdict=document.querySelector('#verdict');const stage=document.querySelector('#stage');const type=document.querySelector('#type');const priority=document.querySelector('#priority');function filter(){const terms=search.value.toLowerCase().trim().split(/\\s+/).filter(Boolean);let count=0;for(const card of cards){const show=terms.every(t=>card.dataset.search.includes(t))&&(!verdict.value||card.dataset.verdict===verdict.value)&&(!stage.value||card.dataset.stage===stage.value)&&(!type.value||card.dataset.types.split(' ').includes(type.value))&&(!priority.value||card.dataset.priority===priority.value);card.hidden=!show;if(show)count++;}document.querySelector('#result').textContent=count+' of '+cards.length+' records shown';document.querySelector('#empty').hidden=count!==0;}for(const el of [search,verdict,stage,type,priority])el.addEventListener('input',filter);document.querySelector('#reset').addEventListener('click',()=>{for(const el of [search,verdict,stage,type,priority])el.value='';filter();});document.querySelector('#expand').addEventListener('click',()=>{for(const card of cards.filter(c=>!c.hidden))for(const d of card.querySelectorAll('details'))d.open=true;});document.querySelector('#collapse').addEventListener('click',()=>{for(const d of document.querySelectorAll('.card details'))d.open=false;});for(const link of document.querySelectorAll('.jump'))link.addEventListener('click',()=>{for(const el of [search,verdict,stage,type,priority])el.value='';filter();});function revealHash(){const id=decodeURIComponent(location.hash.slice(1));const card=document.getElementById(id);if(card&&card.classList.contains('card')){for(const el of [search,verdict,stage,type,priority])el.value='';filter();}}window.addEventListener('hashchange',revealHash);filter();revealHash();'''
    (OUT/'report.js').write_text(script,encoding='utf-8')
    title='Crimson Crystal · Pokémon balance review'
    page=f'''<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>{title}</title><style>{css}</style></head><body>
<header><div class="eyebrow">Source-based design review · October 9–10, 2026</div><h1>Every Pokémon, reviewed.</h1><p>The current roster already has extensive buffs. Preserve useful differences; target the few combinations that remove counterplay. These recommendations are for Enhanced types and stats with abilities enabled.</p><div class="metrics"><div class="metric"><b>495</b><span>species records</span></div><div class="metric"><b>421</b><span>source move records</span></div><div class="metric"><b>{len(proposals['changes'])}</b><span>proposed change groups</span></div><div class="metric"><b>{len(proposals['example_sets'])}</b><span>validated example builds</span></div></div><p><a href="README.md">Read the full reasoning and test priorities</a> · <a href="FULL_ROSTER.md">Readable Markdown</a> · <a href="roster.csv">CSV</a> · <a href="recommendations.json">Exact proposals</a></p></header>
<main class="container"><section class="notice"><b>Recommendations only. No game data changed.</b><p>Keep means retain the current design. Watch means test first; fallback nerfs are not part of the initial change list. P1 = first pass / first test, P2 = second pass, P3 = maintain and observe. Every record includes exact acquisition evidence. No measured win rates or completed tournament simulations are claimed.</p></section>
<section class="overview"><h2>The concrete change list</h2><p class="muted">The full methodology explains custom mechanics, optional rulesets, evolution bypasses, the reserved Mew superboss and the limits of these judgments.</p><div class="scroll"><table><thead><tr><th>Target</th><th>Priority</th><th>Recommendation</th></tr></thead><tbody>{proposal_rows}</tbody></table></div></section>
<div class="toolbar" role="search"><input id="search" type="search" aria-label="Search Pokémon, ability, move or recommendation" placeholder="Search name, ability, move, recommendation…"><select id="verdict" aria-label="Verdict"><option value="">All verdicts</option><option value="nerf">Nerfs</option><option value="buff">Buffs</option><option value="watch">Watch</option><option value="reassign">Ability reassignment</option><option value="keep">Keep</option></select><select id="stage" aria-label="Stage"><option value="">All stages</option><option value="terminal">Terminal species</option><option value="evolving">Evolving species</option><option value="clone">Clones</option></select><select id="type" aria-label="Enhanced type"><option value="">All types</option>{''.join(f'<option value="{t}">{pretty(t)}</option>' for t in TYPES)}</select><select id="priority" aria-label="Priority"><option value="">All priorities</option><option value="1">P1</option><option value="2">P2</option><option value="3">P3</option></select><button id="reset">Reset</button><button id="expand">Expand shown</button><button id="collapse">Collapse</button></div>
<p id="result" class="resultbar" aria-live="polite"></p><p id="empty" class="empty" hidden>No matching records. Reset filters or use a broader search.</p>{''.join(cards)}
<footer>Snapshot commit <code>{esc(data['snapshot']['git_commit'])}</code>. {metadata['source_files_hashed']} hashed ROM source files. {data['trainer_party_count']} trainer parties; {data['tower_record_count']} Tower builds. <a href="source-data.json">Source evidence</a> · <a href="validation.json">Coverage / snapshot checks</a>. Ability and move candidate lists are source screens, not damage or tier rankings.</footer></main><script src="report.js"></script></body></html>'''
    (OUT/'index.html').write_text(page,encoding='utf-8')
    return metadata

def extract():
    order, levels, tm, eggs, parents, utility = load_sources()
    files = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^\"]+)"', read('data/pokemon/base_stats.asm'))
    rules = read('engine/pokemon/gameplay_rules.asm')
    def type_table(label):
        block = rules.split(label + ':', 1)[1].split('\tdw 0', 1)[0]
        return {c:list(dict.fromkeys(t.strip() for t in ts.split(','))) for c,ts in re.findall(r'dw\s+(\w+)\s+db\s+([A-Z_]+\s*,\s*[A-Z_]+)',block)}
    enhanced_types, original_types = type_table('RevampedPokemonTypes'), type_table('OriginalPokemonTypes')
    original_stats = {c:[int(v) for v in vs.split(',')] for c,vs in re.findall(r'dw\s+(\w+)\s+db\s+([\d ,]+)',read('data/pokemon/original_stats.asm'))}
    moves = {}
    for line_no,line in enumerate(read('data/moves/moves.asm').splitlines(),1):
        m = re.match(r'\s*move\s+(.*?);\s*(\w+)\s*$',line)
        if m:
            effect,power,typ,cat,acc,pp,chance = [v.strip() for v in m[1].split(',')]
            moves[m[2]] = dict(effect=effect,power=int(power),type=typ,category=cat.replace('CATEGORIZE_',''),accuracy=int(acc),pp=int(pp),chance=int(chance),source_line=line_no)
    declared_moves=re.findall(r'^\s*const\s+(\w+)',read('constants/move_constants.asm').split('NUM_ATTACKS',1)[0],re.M)
    assert declared_moves[0]=='NO_MOVE' and declared_moves[1:]==list(moves), 'Move order mismatch: contact flags depend on exact index order.'
    contact_bytes=[]
    for line in read('data/moves/contact_moves.asm').splitlines():
        m=re.match(r'\s*db\s+(.+)',line.split(';')[0])
        if m:contact_bytes.extend(int(b.strip()[1:],16) for b in m[1].split(','))
    for index,(c,move) in enumerate(moves.items(),1):
        assert index//8 < len(contact_bytes)
        move['contact']=bool(contact_bytes[index//8] & (1<<(index%8)))
        move['name']=pretty(c)
    chart = {(a,d):{'NOT_VERY_EFFECTIVE':.5,'SUPER_EFFECTIVE':2,'NO_EFFECT':0}[m] for a,d,m in re.findall(r'\bdb\s+(\w+),\s*(\w+),\s*(NOT_VERY_EFFECTIVE|SUPER_EFFECTIVE|NO_EFFECT)',read('data/types/type_matchups.asm'))}
    spec = importlib.util.spec_from_file_location('balance_doc_parser',ROOT/'crimson-crystal-docs/generate_docs.py')
    module = importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    for c,move in moves.items():move['name']=module.move_disp(c)
    builder = module.Builder(ROOT)
    _,names = builder.species()
    encounters = builder.wild(set(order))
    # Preserve shared description labels, which the website's tolerant text parser
    # does not always resolve. These are reference text, not mechanical definitions.
    description_blocks = {}; pending = []; parts = []
    for line in read('data/abilities/descriptions.asm').splitlines():
        label = re.match(r'^(\w+Description):',line)
        if label:
            pending.append(label[1]); continue
        text = re.match(r'\s*(?:text|next|line|cont|para)\s+"(.*)"',line)
        if text: parts.append(text[1].replace('#MON','Pokémon'))
        if re.match(r'\s*done\b',line):
            for label in pending: description_blocks[label] = ' '.join(parts)
            pending = []; parts = []
    ability_constants = re.findall(r'^\s*const\s+(\w+)',read('constants/ability_constants.asm'),re.M)
    description_labels = re.findall(r'^\s*dw\s+(\w+)',read('data/abilities/descriptions.asm'),re.M)
    assert len(ability_constants)==len(description_labels)
    ability_descriptions = {c:description_blocks.get(label,'No ability.') for c,label in zip(ability_constants,description_labels)}
    encounter_by = collections.defaultdict(list)
    for e in encounters: encounter_by[e['const']].append(e)
    def ancestors(c,seen=None):
        seen = set() if seen is None else seen
        for p in parents[c]:
            if p not in seen: seen.add(p);ancestors(p,seen)
        return seen
    children = {c:[x for x in order if c in parents[x]] for c in order}
    def tutor_pool(c):
        result = {m for i,m in enumerate(UTILITY) if utility[c] & (1<<i)}
        if c in {'DRATINI','DRAGONAIR','DRAGONITE'}:result.add('EXTREMESPEED')
        return result
    roster = {}
    for c,f in zip(order,files):
        text = read(f)
        stats = [int(x) for x in re.search(r'^\s*db\s+((?:\d+\s*,\s*){5}\d+)\s*$',text,re.M)[1].split(',')]
        base_types = list(dict.fromkeys(re.search(r'^\s*db\s+(\w+),\s*(\w+)\s*;\s*type',text,re.M).groups()))
        abilities = list(re.search(r'abilities_for\s+\w+,\s*(\w+),\s*(\w+),\s*(\w+)',text).groups())
        types = enhanced_types.get(c,base_types)
        own = {m for lv,m in levels[c]}
        inherited = set()
        for p in ancestors(c):
            inherited.update(m for lv,m in levels[p])
            inherited.update(tm[p]);inherited.update(eggs[p]);inherited.update(tutor_pool(p))
        tutors = tutor_pool(c)
        pool = own | set(tm[c]) | set(eggs[c]) | inherited | tutors
        assert pool <= moves.keys(), (c,pool-moves.keys())
        # Sketch has a special, effectively unrestricted pool. Keep listed sources exact.
        effectiveness = {a:math.prod(chart.get((a,d),1) for d in types) for a in TYPES}
        original_effectiveness = {a:math.prod(chart.get((a,d),1) for d in original_types.get(c,base_types)) for a in TYPES}
        available_sources = {}
        for mv in sorted(pool):
            src = [f'Lv {lv}' for lv,m in levels[c] if m==mv]
            if mv in tm[c]:src.append('TM/HM/elemental tutor')
            if mv in eggs[c]:src.append('egg tutor / breeding')
            if mv in tutors:src.append('utility / special tutor')
            for p in sorted(ancestors(c)):
                src.extend(f'{pretty(p)} Lv {lv} (retain before evolution)' for lv,m in levels[p] if m==mv)
                if mv in tm[p]:src.append(f'{pretty(p)} TM/HM/elemental tutor (retain before evolution)')
                if mv in eggs[p]:src.append(f'{pretty(p)} egg tutor / breeding (retain before evolution)')
                if mv in tutor_pool(p):src.append(f'{pretty(p)} utility / special tutor (retain before evolution)')
            available_sources[mv] = src
        attacks = [m for m in pool if moves[m]['power']>0 and moves[m]['category']!='STATUS']
        best = {}
        for typ in types:
            for category in ['PHYSICAL','SPECIAL']:
                ms = [m for m in attacks if moves[m]['type']==typ and moves[m]['category']==category and not moves[m]['effect'] in {'EFFECT_OHKO','EFFECT_STATIC_DAMAGE','EFFECT_LEVEL_DAMAGE','EFFECT_COUNTER','EFFECT_MIRROR_COAT'}]
                best[typ+' '+category] = sorted(ms,key=lambda m: (moves[m]['power']*moves[m]['accuracy']/100,m),reverse=True)[:4]
        roster[c] = dict(const=c,name=module.form_label(c,names[c]),source=f,source_line=text[:text.index('abilities_for')].count('\n')+1,
            stats=dict(zip(STATS,stats)),bst=sum(stats),types=types,original_types=original_types.get(c,base_types),original_stats=dict(zip(STATS,original_stats.get(c,stats))),
            abilities=abilities,level_up=levels[c],tmhm=tm[c],egg_moves=eggs[c],utility_tutors=sorted(tutors),inherited=sorted(inherited-own),parents=parents[c],children=children[c],
            pool=sorted(pool),move_sources=available_sources,best_stab=best,type_matchups=effectiveness,original_type_matchups=original_effectiveness,encounters=encounter_by[c],
            growth=re.search(r'db\s+(GROWTH_\w+)',text)[1],evolutions=[])
    tables={}; evolution_blocks={}
    for f in ['data/pokemon/evos_attacks_kanto.asm','data/pokemon/evos_attacks_johto.asm','data/pokemon/evos_attacks_clones.asm']:
        text=read(f)
        for m in re.finditer(r'^(\w+EvosAttacks):\n(.*?)(?=^\w|^SECTION|\Z)',text,re.M|re.S):
            evolution_blocks[m[1]] = dict(source=f,line=text[:m.start()].count('\n')+1,rows=[line.split(';')[0].strip() for line in m[2].splitlines() if re.match(r'\s*db+b?w\s+EVOLVE_',line)])
        for m in re.finditer(r'^(EvosAttacksPointers\w*)::?\n((?:\s*dw\s+\w+[^\n]*\n)+)',text,re.M):
            tables[m[1]]=re.findall(r'^\s*dw\s+(\w+)',m[2],re.M)
    sequence=[]
    for name in ['EvosAttacksPointers1','EvosAttacksPointers1C','EvosAttacksPointers1B','EvosAttacksPointers2','EvosAttacksPointers2D','EvosAttacksPointers2E','EvosAttacksPointers2B','EvosAttacksPointers2C']:sequence+=tables[name]
    assert len(sequence)==len(order)
    for c,label in zip(order,sequence):
        block=evolution_blocks[label]
        roster[c]['evolutions']=block['rows']
        roster[c]['learnset_source']=block['source']
        roster[c]['learnset_source_line']=block['line']
    import audit_trainers
    items=set(audit_trainers.constant_list('constants/item_constants.asm','NUM_ITEMS'))
    groups=audit_trainers.parse_parties(set(order),set(moves)|{'NO_MOVE'},items)
    assert not audit_trainers.ERRORS, audit_trainers.ERRORS
    trainers=[]
    for group,entries in groups.items():
        for entry in entries:
            for mon in entry['mons']:
                record=dict(group=group,name=entry['name'],party=entry['declared_number'],source_line=entry['line'],**mon)
                trainers.append(record)
                roster[mon['species']].setdefault('trainer_appearances',[]).append(record)
    for row in roster.values():row.setdefault('trainer_appearances',[])
    # The fixed Tower records can deliberately contain moves outside the player's
    # acquisition pool. Record those separately, never merge them into legal pools.
    tower=[]; group=None; current=None
    for line_no,line in enumerate(read('data/battle_tower/parties.asm').splitlines(),1):
        raw=line.split(';')[0].strip()
        m=re.match(r'BattleTowerMons(\d+):',raw)
        if m:group=int(m[1]);current=None;continue
        if raw=='BattleTowerMew:':group=None;current=None;continue
        m=re.match(r'btmon\s+(.+)',raw)
        if m:
            vals=[v.strip() for v in m[1].split(',')]
            assert len(vals)==9
            current=dict(group=group,species=vals[0],item=vals[1],moves=vals[2:6],level=int(vals[6]),stat_exp=int(vals[7]),ability=vals[8],source_line=line_no)
            tower.append(current);current=None;continue
        m=re.match(r'dw\s+(\w+)$',raw)
        if m and m[1] in roster:
            current=dict(group=group,species=m[1],source_line=line_no,directives=[('dw',m[1])]);continue
        if current:
            m=re.match(r'(db|dw|dt|bigdw|dn)\s+(.+)',raw)
            if m:current['directives'].append((m[1],m[2]))
            if m and m[1]=='db' and raw.startswith('db "'):
                vals=current.pop('directives')
                current.update(item=vals[1][1],moves=[s.strip() for s in vals[2][1].split(',')],level=int(vals[14][1]),stat_exp=int(vals[5][1]),ability=vals[15][1])
                tower.append(current);current=None
    assert len(tower)==321, len(tower)
    for record in tower:
        assert set(record['moves'])<=set(moves)|{'0','NO_MOVE'},record
        record['outside_player_pool']=[m for m in record['moves'] if m not in {'0','NO_MOVE'} and m not in roster[record['species']]['pool']]
        roster[record['species']].setdefault('tower_appearances',[]).append(record)
    for row in roster.values():row.setdefault('tower_appearances',[])
    import audit_exp_economy
    sources = files + ['constants/pokemon_constants.asm','constants/move_constants.asm','constants/ability_constants.asm','constants/item_constants.asm','constants/type_constants.asm',
        'data/pokemon/base_stats.asm','data/pokemon/first_stages.asm','data/pokemon/utility_tutor.asm','data/pokemon/evos_attacks.asm','data/pokemon/evos_attacks_kanto.asm','data/pokemon/evos_attacks_johto.asm','data/pokemon/evos_attacks_clones.asm',
        'data/pokemon/egg_moves_kanto.asm','data/pokemon/egg_moves_johto.asm','data/pokemon/original_stats.asm','data/types/type_matchups.asm','data/moves/moves.asm','data/abilities/descriptions.asm','engine/pokemon/gameplay_rules.asm',
        'engine/pokemon/experience.asm','engine/battle/abilities_engine.asm','engine/battle/core.asm','engine/battle/effect_commands.asm','engine/battle/effect_commands_core.asm','engine/battle/move_effects/new_move_cores.asm',
        'engine/battle/move_effects/parental_bond_core.asm','engine/battle/move_effects/supreme_overlord_core.asm','data/trainers/parties.asm','engine/events/move_deleter.asm','engine/events/utility_tutor.asm',
        'maps/ElmsLab.asm','maps/GoldenrodPPSpeechHouse.asm','maps/MoveDeletersHouse.asm','maps/LakeOfRageHiddenPowerHouse.asm','data/items/marts.asm',
        'data/moves/contact_moves.asm','data/moves/critical_hit_moves.asm','data/battle_tower/parties.asm','data/trainers/stat_exp.asm','engine/events/battle_tower/load_trainer.asm']
    sources += [p.relative_to(ROOT).as_posix() for p in (ROOT/'data/wild').glob('*.asm')]
    manifest={p:hashlib.sha256((ROOT/p).read_bytes()).hexdigest() for p in sorted(set(sources))}
    return dict(order=order,roster=roster,moves=moves,abilities=ability_descriptions,encounter_parse_report=builder.report,tm_labels=builder.tm_table(),
        hard_mode_caps=audit_exp_economy._CAP_ROWS,trainer_record_count=len(trainers),trainer_party_count=sum(map(len,groups.values())),
        tower_record_count=len(tower),items=sorted(items),
        snapshot=dict(review_started='2026-10-09',review_completed='2026-10-10',git_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),source_hashes=manifest))

if __name__ == '__main__':
    OUT.mkdir(parents=True,exist_ok=True)
    data=extract()
    notes=load_notes(data)
    proposals=json.loads(read('tools/testdata/balance_review_proposals.json'))
    checks=validate_proposals(data,proposals)
    apply_family_notes(data,notes,proposals)
    metadata=write_reports(data,proposals,checks)
    print(json.dumps({k:v for k,v in metadata.items() if k!='source_hashes'},indent=2))
    print('Report: '+str(OUT/'index.html'))
