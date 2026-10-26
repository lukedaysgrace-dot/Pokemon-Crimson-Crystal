"""Campaign assumptions and integer-exact battle EXP model (stdlib only).

The source inventory is factual. Route selection, ordinary trainer inclusion,
wild KOs, and participation are explicit scenarios, NOT observed player data.
"""
import bisect
import copy
import hashlib
import json
import math
import re
from collections import defaultdict
from functools import lru_cache
from pathlib import Path
from extract import HERE, ROOT, read, write_csv

DATA=json.loads((HERE/'extracted.json').read_text(encoding='utf-8'))
SP=DATA['species']; PARTIES=DATA['parties']
GROWTH_NAMES=['GROWTH_MEDIUM_FAST','GROWTH_SLIGHTLY_FAST','GROWTH_SLIGHTLY_SLOW','GROWTH_MEDIUM_SLOW','GROWTH_FAST','GROWTH_SLOW']
GROWTH={name:tuple(map(int,vals)) for name,vals in zip(GROWTH_NAMES,re.findall(r'^\s*growth_rate\s+(-?\d+),\s*(-?\d+),\s*(-?\d+),\s*(-?\d+),\s*(-?\d+)',read('data/growth_rates.asm'),re.M))}

@lru_cache(None)
def exp_at(level,rate):
    if level==1:return 0
    a,b,c,d,e=GROWTH[rate]
    return (a*level**3//b+c*level**2+d*level-e)&0xffffff

THRESHOLDS={g:[exp_at(l,g) for l in range(1,101)] for g in GROWTH}
def level_of(exp,rate): return min(100,bisect.bisect_right(THRESHOLDS[rate],exp))

def exp_award(base,level,participants=1,trainer=True,hard=True,traded=False,lucky=False,share=False):
    """Order matches core.asm: floor base/2, floor base/divisor, L/7,
    then traded, trainer, Lucky Egg. BoostExp uses 16-bit wrap; DoubleExp saturates.
    participants counts uncapped eligible recipients in THIS pass; minimum 1.
    """
    b=(base//2 if share else base)//max(1,participants)
    value=b*level//7
    if traded:value=(value+value//2)&65535
    if trainer:value=min(65535,2*value) if hard else (value+value//2)&65535
    if lucky:value=(value+value//2)&65535
    return value

GYMS=['Falkner','Bugsy','Whitney','Morty','Chuck','Jasmine','Pryce','Clair','Brock','Misty','Surge','Erika','Janine','Sabrina','Blaine','Blue']
END=['Will','Koga','Bruno','Karen','Lance','Falkner rematch','Bugsy rematch','Whitney rematch','Morty rematch','Chuck rematch','Jasmine rematch','Pryce rematch','Clair rematch','Crystal Cape','Silver Plateau','Will rematch','Koga rematch','Bruno rematch','Karen rematch','Lance rematch','Agatha','Lorelei','Red Mt Silver','Green','Blue Cloak','Red Pallet']
STAGES=GYMS+END
BOSS_KEYS=['Falkner:1','Bugsy:1','Whitney:1','Morty:1','Chuck:1','Jasmine:1','Pryce:1','Clair:1','Brock:1','Misty:1','LtSurge:1','Erika:1','Janine:1','Sabrina:1','Blaine:1','Blue:1','Will:1','Koga:1','Bruno:1','Karen:1','Champion:1','Falkner:2','Bugsy:2','Whitney:2','Morty:2','Chuck:2','Jasmine:2','Pryce:2','Clair:2','Crystal:13','Rival2:6','Will:2','Koga:2','Bruno:2','Karen:2','Champion:2','Agatha:1','Lorelei:1','Red:1','Green:1','BlueCloak:1','Red2:1']
assert len(STAGES)==len(BOSS_KEYS)

# Recommended visit stage, earliest access stage, optional zone, requirements.
# Stages are source-informed itinerary assumptions, not level-based bucketing.
LANDMARKS={
 'NEW_BARK_TOWN':(0,0,False,'starter / Elm errand'), 'CHERRYGROVE_CITY':(0,0,False,'Elm errand; Silver on return'),
 'VIOLET_CITY':(0,0,False,'Routes 30-31'), 'SPROUT_TOWER':(0,0,True,'Violet; Flash reward, not required for Falkner'),
 'DARK_CAVE':(4,0,True,'Violet entrance initially; inner water/rocks need Surf/Rock Smash; Blackthorn side later'),
 'RUINS_OF_ALPH':(1,0,True,'Violet/Route32; some chambers need Surf/Strength and Union Cave'),
 'AZALEA_TOWN':(1,1,False,'Falkner and aide egg; Union Cave; well clearance for gym'),
 'SLOWPOKE_WELL':(1,1,False,'Kurt opens well; B2 needs Surf/Strength'),
 'UNION_CAVE':(1,1,False,'Route32; deeper trainers need Surf'), 'ILEX_FOREST':(2,1,False,'Azalea rival; Bugsy for Cut at north exit'),
 'GOLDENROD_CITY':(2,2,False,'Cut through Ilex Forest'), 'NATIONAL_PARK':(3,2,True,'north of Goldenrod, accessible before Whitney'),
 'ECRUTEAK_CITY':(3,3,False,'Whitney, Floria and Squirtbottle/Sudowoodo; Burned Tower for Morty; 8 Kimono Girls for Surf'),
 'BURNED_TOWER':(3,3,False,'Ecruteak; Silver and beast release unlock gym'),
 'SILENT_HOLLOW':(3,3,True,'Route37 side entrance; grave cleaning gives Focus Sash'),
 'OLIVINE_CITY':(4,3,False,'Routes38-39; accessible before Morty; pharmacy Surf trip for Jasmine'),
 'LIGHTHOUSE':(5,4,False,'Jasmine blocks entrance until Cianwood Secretpotion delivery; default return after Chuck, before Jasmine; Chuck badge is not itself required'),
 'CIANWOOD_CITY':(4,4,False,'Morty + all 8 Kimono Girls for Surf; Routes40-41'),
 'SHIVER_ISLE':(4,4,True,'Surf from Route41'), 'WHIRL_ISLANDS':(8,4,True,'Surf/Whirlpool; Silver Wing from Pewter for Lugia'),
 'MT_MORTAR':(6,3,True,'Route42 west initially; internal Surf/Waterfall/Strength gates'),
 'MAHOGANY_TOWN':(6,5,False,'Route42 fisherman checks Jasmine; Rocket Hideout story'),
 'LAKE_OF_RAGE':(6,5,False,'Mahogany/Route43; Gyarados and Lance for Hideout'),
 'ICE_PATH':(7,6,False,'Rocket Hideout clears east road; Waterfall field use needs Clair'),
 'BLACKTHORN_CITY':(7,6,False,'Ice Path; gym entrance waits for Radio Tower'),
 'DRAGONS_DEN':(8,8,True,'Clair opens entrance; Whirlpool for inner trainers'),
 'TOHJO_FALLS':(8,8,False,'Surf + Clair Waterfall'), 'VICTORY_ROAD':(16,16,False,'16 badges; VictoryRoadGate guards'),
 'INDIGO_PLATEAU':(16,16,False,'16 badges; first League; rematch additionally Clair rematch'),
 'VIRIDIAN_CITY':(8,8,False,'Route22 east from gate after 8 Johto badges; southern road needs six Kanto badges'),
 'VIRIDIAN_FOREST':(8,8,False,'Route2, restored forest'), 'PEWTER_CITY':(8,8,False,'Route2/forest'),
 'MT_MOON':(9,8,False,'Route3 east from Pewter; Brock not checked in map script'),
 'CERULEAN_CITY':(9,8,False,'Mt Moon/Route4; power investigation, Route25 date for Misty'),
 'POWER_PLANT':(9,8,False,'Surf from Route9 river; investigation for Misty date and Route5 opening'),
 'VERMILION_CITY':(10,9,False,'Misty + returned Machine Part opens Route5/6'),
 'DIGLETTS_CAVE':(11,10,True,'Kanto radio/EXPN + Snorlax; alternative access not path-proved'),
 'SAFFRON_CITY':(13,9,False,'Route5; road blocker requires Misty + Machine Part'),
 'CELADON_CITY':(11,9,False,'Saffron/Route7'), 'FUCHSIA_CITY':(12,9,False,'Routes12-15 or Cycling Road; Snorlax/Bicycle alternate paths'),
 'LAVENDER_TOWN':(12,9,False,'Route9/10 or Saffron/Route8'), 'ROCK_TUNNEL':(10,9,True,'Route9 blocker checks Misty; river power access is distinct'),
 'LAV_RADIO_TOWER':(10,9,False,'restore Power Plant for EXPN Card'), 'UNDERGROUND_PATH':(10,9,True,'Routes5-6; Machine Part roadwork'),
 'PALLET_TOWN':(14,14,False,'southern Viridian road needs Brock/Misty/Surge/Erika/Janine/Sabrina'),
 'CINNABAR_ISLAND':(14,14,False,'same six Kanto badges; Surf south routes'),
 'SEAFOAM_ISLANDS':(14,14,False,'Route20; Blaine gym'), 'FIRE_ISLAND':(14,14,True,'Route19 + Elemental Sphere'),
 'THUNDER_ISLAND':(14,14,True,'Route19 + Elemental Sphere'), 'ICE_ISLAND':(14,14,True,'Route19 + Elemental Sphere'),
 'SILVER_CAVE':(36,29,False,'16 badges + first Hall of Fame + Clair rematch + Crystal Cape; Oak'),
 'TIN_TOWER':(8,8,True,'upper stairs require Rainbow Wing; 8 Johto badges + BeastsCheck for wing; first floor after Clear Bell'),
 'CERULEAN_CAVE':(30,11,True,'Route4 entrance requires caught Mew and Mew in party; Mew follows Erika-triggered Cape Crystal event'),
 'RADIO_TOWER':(7,7,False,'7 badges activates Rocket takeover; Basement and Card Keys'),
 'FAST_SHIP':(11,11,True,'Surge allows SS Ticket; first rescue voyage distinct from daily trips'),
 'BATTLE_TOWER':(4,4,True,'Route40; awards no battle EXP'), 'SPECIAL_MAP':(99,99,True,'cable/mobile/special content; no campaign EXP')}
ROUTES={29:(0,0),30:(0,0),31:(0,0),32:(1,1),33:(1,1),34:(2,2),35:(3,2),36:(3,0),37:(3,3),38:(4,3),39:(4,3),40:(4,3),41:(4,4),42:(6,3),43:(6,5),44:(7,6),45:(8,7),46:(8,7),26:(8,8),27:(8,8),28:(36,29),22:(8,8),2:(8,8),3:(9,8),4:(9,8),24:(9,8),25:(9,8),9:(9,8),10:(10,8),5:(10,9),6:(10,9),7:(11,9),8:(12,9),11:(11,9),12:(12,9),13:(12,9),14:(12,9),15:(12,9),16:(12,9),17:(12,9),18:(12,9),19:(14,14),20:(14,14),21:(14,14),1:(14,14),23:(16,16)}
OPTIONAL_MAPS={'GoldenrodGameCorner','GoldenrodUnderground','RuinsOfAlphOutside','UnionCaveB1F','UnionCaveB2F','MountMortar1FInside','MountMortar2FInside','WiseTriosRoom','TrainerHouseB1F','FightingDojo','SilentCrypt','NationalPark','ShiverIsle'}

def map_plan(name):
    info=DATA['maps'][name]; land=info.get('landmark','')
    if land.startswith('ROUTE_') and land[6:].isdigit():
        s,e=ROUTES[int(land[6:])]; optional=int(land[6:]) in [45,46,12,13,14,15,16,17,18]
        req=f'Route {land[6:]}; links in map_edges.csv; script conditions in access_conditions.csv'
    elif land in LANDMARKS:s,e,optional,req=LANDMARKS[land]
    elif name.startswith('RadioTower'):s,e,optional,req=7,7,False,'7 badges activates Radio Tower takeover; Basement/Card Key sequence'
    else:s,e,optional,req=99,99,True,'unused/unclassified map (review before adding to campaign)'
    if name in OPTIONAL_MAPS:optional=True
    if name=='Route36':s,e,optional,req=3,2,True,'trainers are WEST of Sudowoodo, accessible from Goldenrod before Whitney; east wild grass accessible from Violet'
    if name=='Route10North':s,e=9,8
    if name=='Route10South':s,e=10,9
    if name=='TinTower1F':s,e,optional=7,7,True;req='Radio Tower Clear Bell, Wise Trio; upper floors separately Rainbow Wing gated'
    if name in ['SafariZone','SafariZoneLobby']:s,e,optional=4,3,True;req='Route38 paid Safari; capture-only rules, no ordinary KO EXP'
    if name in ['SafariZoneBeta','SafariZoneFuchsiaGateBeta']:s,e,optional=99,99,True;req='retired Fuchsia Safari beta entrance is explicitly inaccessible'
    if name=='SlowpokeWellB2F':s,e,optional=4,4,True
    if name=='UnionCaveB2F':s,e,optional=4,4,True
    if name=='UnionCaveB1F':s,e,optional=4,1,True
    if name=='RuinsOfAlphOutside':s,e,optional=4,4,True;req='western grass/Nathan sector via Union Cave Surf; public puzzle courtyard accessible earlier'
    if name=='DarkCaveBlackthornEntrance':s,e,optional=8,7,True
    if name.startswith('GoldenrodUndergroundSwitch') or name=='GoldenrodUndergroundWarehouse':s,e,optional=7,7,False;req='Radio Tower fake director gives Basement Key; underground rescue'
    if name.startswith('TeamRocketBase'):s,e,optional=6,5,False;req='Lake of Rage Gyarados, Lance and hideout/passwords; map42 passage model assumes Jasmine'
    if name=='DanceTheatre':s,e,optional=3,3,False;req='ALL 8 Kimono Girls required to obtain HM Surf; Morty to use it'
    if name=='WiseTriosRoom':s,e,optional=7,7,True;req='Radio Tower rescue, Clear Bell; 3 sages before Suicune'
    if name=='MountMortar2FInside':s,e,optional=8,8,True;req='Waterfall after Clair; Kiyo later moves to Saffron Dojo'
    if name=='MountMortar1FInside':s,e,optional=6,5,True;req='Jasmine opens Route42 approach; Surf to interior trainers; deeper Waterfall route after Clair'
    if name=='OlivineGym':s,e=5,4
    if name=='ViridianGym':s,e,optional=15,15,False;req='Blue AND all 3 gym trainers share EVENT_VIRIDIAN_GYM_BLUE; 15 badges via UpdateBlueReturnScript'
    if name=='MahoganyGym':s,e=6,5
    if name in ['BlackthornGym1F','BlackthornGym2F']:s,e=7,7;req='Blackthorn entrance NPC stays until Radio Tower is cleared; city itself can be reached earlier'
    if name.startswith('SilverCave'):
        s,e=(38,38) if name in ['SilverCaveRoom1','SilverCaveRoom2','SilverCaveRoom3','SilverCaveItemRooms'] else (36,36)
        req='Oak opens region after first League + Johto rematches + Cape Crystal; cave floors additionally after Agatha and Lorelei'
    if name=='Route28':s,e=36,36
    if name=='FightingDojo':s,e,optional=13,9,True;req='Saffron access; Kiyo has no visibility event or progress gate (object flag -1)'
    return dict(map=name,stage=s,earliest_stage=e,optional_zone=optional,requirements=req,access_confidence='source-informed itinerary; no exhaustive collision solver',source=info['source'])

MAP_PLAN={name:map_plan(name) for name in DATA['maps']}

UNUSED_REFERENCES=[]
def build_events():
    events=[]; repeats=[]; refs=DATA['references']
    macro_scripts={(r['map'],r['global_script']) for r in refs if r['kind']=='trainer'}
    seen={}
    for r in refs:
        p=PARTIES[r['party_key']]; plan=MAP_PLAN[r['map']]
        if r['kind']=='trainer' and not r['objects'] and r.get('global_label_uses',0)<2:
            UNUSED_REFERENCES.append(dict(**r,reason='trainer macro has no map object or incoming script reference'))
            continue
        if r['kind']=='loadtrainer' and ((r['map'],r['global_script']) in macro_scripts or r['map']=='TrainerHouseB1F'):
            repeats.append(dict(**r,repeat_reason='phone/daily/repeat branch; never counted in one-time progression'))
            continue
        if r['kind']=='loadtrainer' and r['party_key'] in [x['party_key'] for x in events if x['map']==r['map']]:
            # e.g. identical load branches, not a second fight.
            continue
        key=r['event'] if r['kind']=='trainer' else f"{r['map']}:{p['group']}:{p['id']}"
        # Starter alternatives form ONE encounter. Choose the Totodile rival
        # branch for Cyndaquil, Chikorita Crystal branch for Cyndaquil.
        if p['group'] in ['Rival1','Rival2','Crystal']:
            if p['group']=='Crystal': chosen=p['id']%3==1
            else:chosen=p['id']%3==0
            if not chosen: continue
            key=f"{r['map']}:{p['group']}:variant{(p['id']-1)//3}"
        if key in seen:
            seen[key]['reference_sources'].append(r['source']);continue
        event=dict(event_id=key,map=r['map'],party_key=p['key'],trainer_class=r['trainer_class'],trainer_id=r['trainer_id'],name=p.get('name') or r['trainer_class'],kind=r['kind'],script=r['global_script'],stage=plan['stage'],earliest_stage=plan['earliest_stage'],optional_zone=plan['optional_zone'],requirements=plan['requirements'],mandatory=False,mandatory_confidence='ordinary trainer avoidance not path-proved',repeatable=False,source=r['source'],reference_sources=[r['source']],order=int(r['source'].rsplit(':',1)[1]))
        if r['party_key'] in BOSS_KEYS:
            event['stage']=BOSS_KEYS.index(r['party_key']);event['primary']=True
            event['mandatory']=True;event['mandatory_confidence']='required to reach this chosen campaign milestone'
        else:event['primary']=False
        g=p['group']; mp=r['map']
        if g in ['Rival1','Crystal'] or g in ['Proton','Petrel','Ariana','Archer','PetrelDirector']:
            event['mandatory']=True;event['mandatory_confidence']='story route assumption; first rival/Crystal losses may still advance'
        if mp=='CherrygroveCity':event['stage']=0;event['order']=-1000
        if mp=='AzaleaTown':event['stage']=2
        if mp=='IlexForest':event['stage']=2
        if mp=='CianwoodCity' and g=='Mysticalman':event['mandatory']=False;event['optional_zone']=True
        if mp=='EcruteakCity':event['mandatory']=False;event['optional_zone']=True;event['stage']=7
        if mp=='DanceTheatre':event['mandatory']=True;event['mandatory_confidence']='all 8 event flags checked by DanceTheaterSurfGuy'
        if mp=='SlowpokeWellB1F':event['mandatory']=True;event['mandatory_confidence']='main well corridor scenario; collision-level minimum not proven'
        if mp=='TeamRocketBaseB3F' and r['trainer_id'] in ['GRUNTM_28','GRUNTF_5']:
            event['mandatory']=True;event['mandatory_confidence']='password holders'
        if mp=='Route24':event['stage']=9;event['mandatory']=True;event['mandatory_confidence']='Machine Part investigation'
        if mp=='Route39' and p['group']=='PokefanF':event['optional_zone']=True;event['requirements']+='; night-only'
        if mp=='Route34' and r['trainer_id'] in ['IRENE','JENN','KATE']:
            event['stage']=4;event['earliest_stage']=4;event['optional_zone']=True;event['requirements']+='; southern beach reachable with Surf'
        if mp=='GoldenrodGameCorner':event['requirements']+='; Loaded Dice pickup triggers Slot Maniac';event['optional_zone']=True
        if mp=='GoldenrodUnderground' and g in ['GruntM','GruntF']:
            event['optional_zone']=True;event['requirements']+='; optional three-thug Riolu rescue'
        if mp=='FightingDojo' and g=='KarateKing':event['stage']=13;event['earliest_stage']=9
        if mp.startswith('FastShip'):
            visibility=[o['visibility'] for o in r['objects']]
            if 'EVENT_FAST_SHIP_PASSENGERS_FIRST_TRIP' not in visibility and r['trainer_id']!='STANLY':
                event['repeatable']=True
                repeats.append(dict(**r,repeat_reason='later east/west-bound ship passenger; excluded from unique campaign'))
                continue
            event['requirements']+='; first-trip passenger only'
            if r['trainer_id']=='STANLY':event['requirements']+='; lazy sailor required within first-trip rescue quest'
        if mp=='TeamRocketBaseB1F' and g=='GruntM' and r['kind']=='loadtrainer':
            # Five independently flagged alarms, each launches the same pair.
            for camera in range(1,6):
                e=copy.deepcopy(event); e['event_id']=f'camera{camera}:{r["trainer_id"]}';e['optional_zone']=camera>1
                e['requirements']+=f'; EVENT_SECURITY_CAMERA_{camera}; mutually exclusive a/b trigger tiles'
                events.append(e)
            continue
        events.append(event);seen[key]=event
    # Gym leader index is a unique progression fight even though its map has a
    # rematch record; aliases map to the same static party without duplication.
    assert len([e for e in events if e['primary']])==len(STAGES),[(STAGES[i],k) for i,k in enumerate(BOSS_KEYS) if k not in [e['party_key'] for e in events if e['primary']]]
    assert len({e['event_id'] for e in events})==len(events)
    return events,repeats

EVENTS,REPEATS=build_events()

def static_events():
    out=[]
    for r in DATA['static']:
        mp=r['map'];sp=r['species'];level=r['level']
        if mp in ['Route29','TeamRocketBaseB1F']:continue
        mandatory=mp in ['Route36','LakeOfRage','TeamRocketBaseB2F'] and sp in ['SUDOWOODO','GYARADOS','ELECTRODE']
        stage=MAP_PLAN[mp]['stage']
        if mp=='Route36':stage=3
        if mp=='LakeOfRage' and sp=='RAIKOU':stage=8
        if mp=='TohjoFalls' and sp=='SUICUNE':stage=8
        if mp=='UnionCaveB2F' and sp=='LAPRAS':repeatable=True
        else:repeatable=False
        out.append(dict(**r,event_id='static:'+r['source'],stage=stage,base_exp=SP[sp]['base_exp'],solo_exp=exp_award(SP[sp]['base_exp'],level,trainer=False),mandatory_ko_scenario=mandatory,repeatable=repeatable,baseline='KO' if mandatory else 'capture / no EXP; optional KO alternative cataloged'))
    trap_src=read('maps/TeamRocketBaseB1F.asm')
    for num,which in re.findall(r'ExplodingTrap(\d+):\s+checkevent[^\n]+\s+iftrue[^\n]+\s+scall (\w+)ExplodingTrap',trap_src):
        sp={'Voltorb':'VOLTORB','Geodude':'GEODUDE','Koffing':'KOFFING'}[which];level=23 if sp=='VOLTORB' else 21
        out.append(dict(map='TeamRocketBaseB1F',species=sp,level=level,event_id=f'floor_trap:{num}',stage=6,base_exp=SP[sp]['base_exp'],solo_exp=exp_award(SP[sp]['base_exp'],level,trainer=False),mandatory_ko_scenario=False,repeatable=False,baseline='finite optional floor trap; expected exposure scenario',source='maps/TeamRocketBaseB1F.asm:ExplodingTrap'+num))
    assert len([r for r in out if r['event_id'].startswith('floor_trap')])==22
    return out

STATIC_EVENTS=static_events()

def stable_fraction(key,seed): return int.from_bytes(hashlib.sha256(f'{seed}:{key}'.encode()).digest()[:8],'big')/2**64

PLAYSTYLES=['minimal','typical','thorough','completionist','efficient']
METHODS=['casual','equal_rotation','all_participants','main70','two_primary','lowest','switch','exp_share']
DEFAULT_TEAM=[dict(species='CYNDAQUIL',level=5,join_map='CherrygroveCity'),dict(species='RATTATA',level=4,join_map='Route29'),dict(species='MAREEP',level=4,join_map='Route30'),dict(species='ZUBAT',level=10,join_map='UnionCave1F'),dict(species='JIGGLYPUFF',level=17,join_map='Route34'),dict(species='GROWLITHE',level=11,join_map='Route36')]
ALT_TEAM=[dict(species='CHIKORITA',level=5,join_map='CherrygroveCity'),dict(species='HOOTHOOT',level=3,join_map='Route29'),dict(species='HOPPIP',level=5,join_map='Route30'),dict(species='ARON',level=11,join_map='UnionCave1F'),dict(species='ABRA',level=15,join_map='Route34'),dict(species='SNUBBULL',level=15,join_map='Route34')]

def cap_for(badges): return DATA['caps'][badges]['cap'] if badges<16 else 100

def include_event(e,style,seed):
    if e['mandatory'] or e['primary']:return True
    if style=='minimal':return False
    if style=='completionist':return True
    chance={'typical':(.65 if e['optional_zone'] else .70),'thorough':.95,'efficient':.85}[style]
    key=e['event_id']
    if key.startswith('camera'):key=key.split(':')[0]
    if e['map']=='GoldenrodUnderground' and PARTIES[e['party_key']]['group'] in ['GruntM','GruntF']:key='riolu_rescue_chain'
    if e['map']=='Route43Gate':key='refuse_toll_chain'
    return stable_fraction(key,seed)<chance

def party_new(spec):
    g=spec.get('growth',SP[spec['species']]['growth'])
    return {**spec,'growth':g,'exp':exp_at(spec['level'],g),'earned':0,'wasted':0,'traded':spec.get('traded',False),'lucky':spec.get('lucky',False)}

def party_levels(team):return [level_of(m['exp'],m['growth']) for m in team]

def choose_participants(team,method,seq,cap,share_available):
    n=len(team); levels=party_levels(team)
    under=[i for i,l in enumerate(levels) if l<cap]
    low=min(under or list(range(n)),key=lambda i:(levels[i],team[i]['exp']/max(1,exp_at(min(100,levels[i]+1),team[i]['growth']))))
    if method=='lowest':return [low],[]
    if method=='all_participants':return list(range(n)),[]
    if method=='equal_rotation':return [seq%n],[]
    weights=([.7]+[.3/(n-1)]*(n-1)) if method=='main70' and n>1 else ([.4,.4]+[.2/(n-2)]*(n-2) if method=='two_primary' and n>2 else [1/n]*n)
    if method=='casual' and n>1:weights=[.45]+[.55/(n-1)]*(n-1)
    roll=stable_fraction(f'participation:{seq}',0);total=0;chosen=n-1
    for i,w in enumerate(weights):
        total+=w
        if roll<total:chosen=i;break
    if method=='switch':return sorted(set([0,low])),[]
    if method=='exp_share' and share_available and n>1:
        holder=low if low!=0 else n-1
        return [0],[holder]
    return [chosen],[]

def give(team,mon,cap,method,seq,share_available=False,trainer=True):
    participants,holders=choose_participants(team,method,seq,cap,share_available)
    before=sum(m['exp'] for m in team);wasted=0;nominal=0
    passes=[participants]+([holders] if holders else [])
    # The second pass sees levels updated by the first pass, just as native code.
    for recipients in passes:
        eligible=[i for i in recipients if level_of(team[i]['exp'],team[i]['growth'])<cap]
        divisor=max(1,len(eligible))
        if not eligible:
            # No eligible recipient: the pass is lost once, NOT once per
            # capped participant. When anyone can receive it, capped mons have
            # already been removed from the divisor and cause no cap loss.
            m=team[recipients[0]]
            lost=exp_award(mon['base_exp'],mon['level'],1,trainer=trainer,traded=m['traded'],lucky=m['lucky'] and recipients[0] not in holders,share=bool(holders))
            nominal+=lost;wasted+=lost;m['wasted']+=lost
            continue
        for i in eligible:
            m=team[i]
            award=exp_award(mon['base_exp'],mon['level'],divisor,trainer=trainer,traded=m['traded'],lucky=m['lucky'] and i not in holders,share=bool(holders))
            nominal+=award
            room=max(0,exp_at(cap,m['growth'])-m['exp'])
            actual=min(room,award)
            m['exp']+=actual;m['earned']+=actual;m['wasted']+=award-actual;wasted+=award-actual
    return sum(m['exp'] for m in team)-before,wasted,nominal

@lru_cache(None)
def wild_distribution(mapname,surf=True):
    if mapname=='RuinsOfAlphOutside' and not surf:return []
    rows=[w for w in DATA['wild'] if w['map']==mapname and w['variant']=='standard' and w['time'] in ['day','all']]
    grass=[w for w in rows if w['method']=='grass']
    return grass or ([w for w in rows if w['method']=='surf'] if surf else [])

SURF_OFFSETS=[(0,89/256),(1,76/256),(2,51/256),(3,26/256),(4,14/256)]
@lru_cache(None)
def wild_mean(mapname,surf=True):
    return sum(w['probability']*(sum((w['base_exp']*(w['level']+d)//7)*p for d,p in SURF_OFFSETS) if w['method']=='surf' else w['solo_exp']) for w in wild_distribution(mapname,surf))

def wild_draw(mapname,seq,seed,surf=True):
    rows=wild_distribution(mapname,surf)
    if not rows:return None
    r=stable_fraction(f'wild:{mapname}:{seq}',seed);v=0
    for w in rows:
        v+=w['probability']
        if r<v:
            if w['method']=='surf':
                w=copy.copy(w);roll=stable_fraction(f'surf_offset:{mapname}:{seq}',seed);c=0
                for delta,prob in SURF_OFFSETS:
                    c+=prob
                    if roll<c:w['level']+=delta;break
            return w
    return rows[-1]

def gym_order(order=None):
    order=order or GYMS
    assert set(order)==set(GYMS) and len(order)==16
    pos={name:i for i,name in enumerate(order)}
    assert order[:4]==GYMS[:4] and pos['Clair']==7
    assert set(order[4:7])=={'Chuck','Jasmine','Pryce'}
    assert pos['Jasmine']<pos['Pryce'],'Route42 fisherman-gate model requires Jasmine before Pryce'
    assert set(order[8:14])==set(GYMS[8:14])
    assert pos['Misty']<min(pos[x] for x in ['Surge','Erika','Janine','Sabrina'])
    assert order[14:]==['Blaine','Blue']
    return order

def stage_map(order): return {i:order.index(name) for i,name in enumerate(GYMS)}|{i:i for i in range(16,len(STAGES))}

WEST_SHARED={'Route38','Route39','Route40','Route41','CianwoodCity','ShiverIsle','OlivineCity','UnionCaveB1F','UnionCaveB2F','RuinsOfAlphOutside','DarkCaveVioletEntrance','Route34'}
KANTO_ENTRY_SHARED={'DragonsDen1F','DragonsDenB1F','DragonShrine','Route45','Route46','Route26','Route27','TohjoFalls','VictoryRoadGate','Route22','Route2','ViridianForest','ViridianForestViridianGate','ViridianForestPewterGate','ViridianCity','MountMortar2FInside'}

def simulate(size=6,style='typical',method='casual',seed=0,wild_kos=2,team_specs=None,order=None,proposed=None,early_explore=False,replacement=False,details=True,early_cape=False,skip_e4_rematch=False,green_first=False):
    """Return pre-boss checkpoints; awards from that boss occur AFTER its row.

    No automatic grinding/candy/healing costs, deaths or combat win prediction.
    `shortfall` always describes the carried, unground run, not a patched run.
    """
    order=gym_order(order); remap=stage_map(order)
    specs=copy.deepcopy((team_specs or DEFAULT_TEAM)[:size]); team=[];joined=set();seen=set();visited_wild=set();seq=0;badges=0;clair_pending=False
    checkpoints=[];individual=[];zone_log=[];event_log=[];share_available=False
    maplists=defaultdict(list)
    def routed_stage(s,mapname,primary=False):
        if not primary and s==4 and (mapname in WEST_SHARED or mapname.startswith('OlivineLighthouse')):return 4
        if not primary and s==8 and (mapname in KANTO_ENTRY_SHARED or mapname.startswith('TinTower')):return 8
        return remap[s]
    # Itinerary visits all primary route maps; optional zone selection is seeded.
    for name,plan in MAP_PLAN.items():
        s=plan['stage']
        if s>=99:continue
        if early_explore and style=='completionist':s=plan['earliest_stage']
        if style=='minimal' and name=='DanceTheatre':s=4
        s=routed_stage(s,name)
        if plan['optional_zone'] and style=='minimal':continue
        visit_key='visit:'+DATA['maps'][name].get('landmark',name)
        if plan['optional_zone'] and style in ['typical','efficient'] and stable_fraction(visit_key,seed)>({'typical':.35,'efficient':.65}[style]):continue
        if plan['optional_zone'] and style=='thorough' and stable_fraction('visit:'+name,seed)>.95:continue
        maplists[s].append(name)
    # Required recruitment detours are transparent and present in all playstyles.
    for spec in specs:
        name=spec.get('join_map','CherrygroveCity');s=routed_stage(MAP_PLAN[name]['stage'],name)
        if name not in maplists[s]:maplists[s].append(name)
    milestones=[STAGES.index(n) for n in order]+list(range(16,len(STAGES)))
    if skip_e4_rematch:milestones=[x for x in milestones if x not in range(30,36)]
    remaining=defaultdict(list)
    for e in EVENTS:
        s=e['stage']
        if proposed:s=proposed.get('event_stage_overrides',{}).get(e['event_id'],s)
        if style=='minimal' and e['map']=='DanceTheatre':s=4
        if early_explore and style=='completionist' and not e['primary'] and not e['mandatory']:s=e['earliest_stage']
        if early_cape and s==29:s=11
        if skip_e4_rematch and (s in range(30,36) or s>=39):continue
        if s<99:remaining[routed_stage(s,e['map'],e['primary'])].append(e)
    # Arrange connected visit zones; lexical default does not imply tile paths.
    preferred=['CherrygroveCity','Route29','Route30','Route31','VioletCity','SproutTower1F','SproutTower2F','SproutTower3F','Route32','UnionCave1F','Route33','SlowpokeWellB1F','AzaleaGym','AzaleaTown','IlexForest','Route34','GoldenrodUnderground','GoldenrodGameCorner','Route35','NationalPark','Route36','Route37','SilentCrypt','BurnedTower1F','DanceTheatre','Route38','Route39','Route40','Route41','ShiverIsle','CianwoodCity','OlivineLighthouse1F','OlivineLighthouse2F','OlivineLighthouse3F','OlivineLighthouse4F','OlivineLighthouse5F','OlivineLighthouse6F','Route42','Route43','LakeOfRage','Route43Gate','TeamRocketBaseB1F','TeamRocketBaseB3F','TeamRocketBaseB2F','RadioTower1F','RadioTower2F','RadioTower3F','RadioTower4F','RadioTower5F','GoldenrodUndergroundSwitchRoomEntrances','GoldenrodUndergroundWarehouse','Route44','IcePath1F','BlackthornGym2F','BlackthornGym1F','DragonsDenB1F','Route45','Route46','Route27','TohjoFalls','Route26','Route22','Route2','ViridianForest','Route3','MountMoon','Route4','Route9','Route10North','Route24','Route25','Route5','Route6','VermilionCity','Route7','CeladonCity','Route8','Route10South','Route11','Route12','Route13','Route14','Route15','Route16','Route17','Route18','Route1','Route21','Route19','Route20','VictoryRoad','SilverCaveOutside','SilverCaveRoom1','SilverCaveRoom2']
    rank={m:i for i,m in enumerate(preferred)}
    totals=dict(earned=0,wasted=0,nominal=0,solo=0,wild_earned=0,trainer_earned=0)
    previous_primary_totals=totals.copy();previous_primary_levels=[]
    previous_primary_exps={}
    def current_cap():return (proposed or {}).get('caps',{}).get(str(badges),cap_for(badges))
    def adjusted_party(p):
        if not proposed:return p
        delta=proposed.get('party_level_delta',{}).get(p['key'],0)
        if not delta:return p
        out=copy.deepcopy(p)
        for m in out['mons']:
            m['level']=max(1,min(100,m['level']+delta));m['solo_hard_exp']=exp_award(m['base_exp'],m['level'])
        return out
    def join(mapname):
        for idx,spec in enumerate(specs):
            if idx not in joined and spec.get('join_map','CherrygroveCity')==mapname:
                new=party_new(spec);new['slot']=idx;team.append(new);joined.add(idx)
        team.sort(key=lambda x:x['slot'])
    def checkpoint(name,p,primary,stage,source):
        levels=party_levels(team);cap=current_cap();ace=max(m['level'] for m in p['mons'])
        target=cap if badges<16 else ace
        deficits=[max(0,exp_at(target,m['growth'])-m['exp']) for m in team]
        surpluses=[max(0,m['exp']-exp_at(target,m['growth'])) for m in team]
        present=len(team)
        stage_maps=set(maplists[stage])|visited_wild
        candidates=[(wild_mean(m,badges>=4),m) for m in stage_maps if wild_mean(m,badges>=4)>0 and m not in ['SafariZone','SafariZoneBeta','NationalParkBugContest']]
        if not candidates:
            # Postgame comparisons use actual Mt Silver outside, not arbitrary
            # max-yield species; Johto rematches use Route45/44 regional pool.
            fallback='SilverCaveOutside' if stage>=36 else ('Route45' if stage>=16 else 'Route29')
            candidates=[(wild_mean(fallback),fallback)]
        mean_wild,wmap=max(candidates)
        grind=math.ceil(sum(deficits)/mean_wild) if mean_wild else None
        # This pooled estimate is an optimistic balanced-rotation lower estimate.
        # Exact selected-method grind is calculated separately for primary rows.
        row=dict(playstyle=style,team_size=size,method=method,seed=seed,wild_kos_per_map=wild_kos,milestone=name,primary=primary,stage=stage,badges=badges,hard_cap=cap,target_level=target,boss_ace=ace,party_size=present,species=[m['species'] for m in team],starting_levels=previous_primary_levels,levels=levels,exp_totals=[m['exp'] for m in team],growths=[m['growth'] for m in team],average_level=round(sum(levels)/present,3),min_level=min(levels),max_level=max(levels),at_cap=sum(l>=cap for l in levels),at_cap_pct=round(100*sum(l>=cap for l in levels)/present,2),at_target=sum(l>=target for l in levels),within_2=sum(l>=target-2 for l in levels),target_shortfall=sum(deficits),target_surplus=sum(surpluses),pooled_wild_battles_estimate=grind,wild_map=wmap,wild_mean_solo_exp=round(mean_wild,4),segment_earned=totals['earned']-previous_primary_totals['earned'],segment_nominal=totals['nominal']-previous_primary_totals['nominal'],segment_solo_available=totals['solo']-previous_primary_totals['solo'],segment_wild_earned=totals['wild_earned']-previous_primary_totals['wild_earned'],segment_wasted=totals['wasted']-previous_primary_totals['wasted'],cumulative_earned=totals['earned'],cumulative_wasted=totals['wasted'],source=source)
        gaps=[target-l for l in levels];most=sorted(gaps)[present//2]
        row['balance_rating']='Excellent' if most<=2 else 'Good' if most<=3 else 'Needs attention' if most<=5 else 'Poor'
        demand=sum(max(0,exp_at(target,m['growth'])-previous_primary_exps.get(m['slot'],exp_at(m['level'],m['growth']))) for m in team)
        row['segment_exp_required_at_entry']=demand
        row['shortfall_pct_of_segment_demand']=round(100*sum(deficits)/max(1,demand),2)
        row['starting_average_level']=round(sum(previous_primary_levels)/len(previous_primary_levels),3) if previous_primary_levels else specs[0]['level']
        checkpoints.append(row)
        if details:
            for m,l,d in zip(team,levels,deficits):
                individual.append(dict(playstyle=style,team_size=size,method=method,seed=seed,wild_kos_per_map=wild_kos,milestone=name,primary=primary,slot=m['slot']+1,species=m['species'],growth=m['growth'],starting_level=m['level'],join_map=m.get('join_map'),level=l,exp=m['exp'],target=target,hard_cap=cap,exp_to_target=d,cumulative_earned=m['earned'],cumulative_wasted=m['wasted']))
        return row
    stage_sequence=list(range(len(STAGES)))
    if green_first:stage_sequence=stage_sequence[:36]+[39,40,41,36,37,38]
    for stage in stage_sequence:
        if skip_e4_rematch and (stage in range(30,36) or stage>=39):continue
        cap=current_cap()
        if replacement and stage==(replacement.get('stage',8) if isinstance(replacement,dict) else 8) and team:
            rs=replacement if isinstance(replacement,dict) else dict(species='MAGNEMITE',level=26,join_map='Route38')
            rs={k:v for k,v in rs.items() if k!='stage'}
            team[-1]=party_new(rs);team[-1]['slot']=size-1
        es=remaining[stage]
        maps=set(maplists[stage])|{e['map'] for e in es if e['mandatory'] or e['primary'] or (routed_stage(MAP_PLAN[e['map']]['stage'],e['map'])!=stage and include_event(e,style,seed))}
        if stage==8 and clair_pending:maps.add('DragonsDenB1F')
        grouped=defaultdict(list)
        for e in es:grouped[e['map']].append(e)
        primary=[]
        visits=[(name,'full') for name in sorted(maps,key=lambda m:(rank.get(m,999),m))]
        if stage==7:
            visits=[(name,'pre_card' if name=='RadioTower4F' else 'fake_director' if name=='RadioTower5F' else phase) for name,phase in visits]
            insertion=next((i+1 for i,(name,_) in enumerate(visits) if name=='GoldenrodUndergroundWarehouse'),len(visits))
            visits[insertion:insertion]=[('RadioTower4F','post_card'),('RadioTower5F','final_executives')]
        def battle_order(e):
            group=PARTIES[e['party_key']]['group']
            late=(e['map']=='SlowpokeWellB1F' and group=='Proton' or e['map']=='TeamRocketBaseB3F' and group=='Petrel' or e['map']=='TeamRocketBaseB2F' and group=='Ariana' or e['map']=='SproutTower3F' and group=='Elder')
            return e['primary'],late,e['order']
        for mapname,phase in visits:
            join(mapname)
            if not team:join('CherrygroveCity')
            start=party_levels(team);before=totals.copy();events_done=[]
            for e in sorted(grouped[mapname],key=battle_order):
                if phase=='fake_director' and PARTIES[e['party_key']]['group']!='PetrelDirector':continue
                if phase=='pre_card' and e['trainer_id']!='GRUNTM_10':continue
                if e['primary']:
                    primary.append(e);continue
                if e['event_id'] in seen or not include_event(e,style,seed):continue
                seen.add(e['event_id']);p=adjusted_party(PARTIES[e['party_key']])
                if p['group'] in ['Crystal','Rival1','Rival2','Proton','Petrel','Ariana','Archer','PetrelDirector','Elder','KarateKing','Mysticalman']:
                    checkpoint(f'{e["name"]} ({mapname})',p,False,stage,e['source'])
                for mon in p['mons']:
                    test=copy.copy(mon)
                    if proposed and mapname in proposed.get('trainer_level_delta',{}):test['level']=min(100,test['level']+proposed['trainer_level_delta'][mapname])
                    earned,wasted,nominal=give(team,test,cap,method if style!='efficient' else 'lowest',seq,share_available)
                    seq+=1;totals['earned']+=earned;totals['trainer_earned']+=earned;totals['wasted']+=wasted;totals['nominal']+=nominal;totals['solo']+=exp_award(test['base_exp'],test['level'])
                events_done.append(e['event_id'])
                if details:event_log.append(dict(stage=stage,map=mapname,visit_phase=phase,event_id=e['event_id'],party_key=e['party_key'],cap=cap,levels_after=party_levels(team),exp_after=[m['exp'] for m in team]))
            # Minimal has no random KOs. Expected travel KOs explicitly assumed.
            k=0 if mapname in visited_wild or style=='minimal' or mapname in ['SafariZone','SafariZoneBeta','NationalParkBugContest'] else wild_kos
            visited_wild.add(mapname)
            for wi in range(k):
                w=wild_draw(mapname,wi,seed,badges>=4)
                if w:
                    earned,wasted,nominal=give(team,w,cap,method if style!='efficient' else 'lowest',seq,share_available,trainer=False)
                    seq+=1;totals['earned']+=earned;totals['wild_earned']+=earned;totals['wasted']+=wasted;totals['nominal']+=nominal
            # Unique scripted wild battles are separate from random travel.
            # Required obstacles are KO'd; legendary catches award no EXP.
            for w in STATIC_EVENTS:
                if w['map']!=mapname or remap.get(w['stage'],w['stage'])!=stage or w['event_id'] in seen:continue
                expose=w['mandatory_ko_scenario']
                if w['event_id'].startswith('floor_trap'):
                    expose=style=='completionist' or style=='thorough' and stable_fraction(w['event_id'],seed)<.5 or style=='typical' and stable_fraction(w['event_id'],seed)<.1
                if not expose:continue
                seen.add(w['event_id'])
                earned,wasted,nominal=give(team,w,cap,method if style!='efficient' else 'lowest',seq,share_available,trainer=False)
                seq+=1;totals['earned']+=earned;totals['wild_earned']+=earned;totals['wasted']+=wasted;totals['nominal']+=nominal
            if details and (events_done or k and wild_distribution(mapname,badges>=4)):
                zone_log.append(dict(stage=stage,map=mapname,start_levels=start,end_levels=party_levels(team),solo_trainer_available=totals['solo']-before['solo'],exp_earned=totals['earned']-before['earned'],wild_earned=totals['wild_earned']-before['wild_earned'],exp_wasted=totals['wasted']-before['wasted'],event_count=len(events_done)))
            if mapname=='LakeOfRage':share_available=True
            if mapname=='DragonsDenB1F' and clair_pending:
                # Clair withholds badge 8 until the Dragon Shrine trial. The
                # approach trainers and travel EXP are still capped at 45.
                badges+=1;cap=current_cap();clair_pending=False
        # All planned route content precedes the primary boss. Minor bosses are
        # located within their maps; boss checkpoints do NOT include own rewards.
        for e in sorted(primary,key=lambda x:(x['stage'],x['order'])):
            if e['event_id'] in seen:continue
            seen.add(e['event_id']);p=adjusted_party(PARTIES[e['party_key']])
            name=STAGES[e['stage']]
            row=checkpoint(name,p,True,stage,e['source'])
            for mon in p['mons']:
                earned,wasted,nominal=give(team,mon,cap,method if style!='efficient' else 'lowest',seq,share_available)
                seq+=1;totals['earned']+=earned;totals['trainer_earned']+=earned;totals['wasted']+=wasted;totals['nominal']+=nominal;totals['solo']+=mon['solo_hard_exp']
            if e['stage']==7:clair_pending=True
            elif e['stage']<16:badges+=1;cap=current_cap()
            previous_primary_totals=totals.copy()
            previous_primary_levels=party_levels(team)
            previous_primary_exps={m['slot']:m['exp'] for m in team}
    return dict(checkpoints=checkpoints,individual=individual,zones=zone_log,events=event_log,seen=sorted(seen),team=team)

def export_catalog():
    write_csv('campaign_events.csv',EVENTS)
    write_csv('repeatable_references.csv',REPEATS)
    write_csv('map_progression.csv',MAP_PLAN.values())
    write_csv('scripted_wild_instances.csv',STATIC_EVENTS)
    write_csv('unspawned_trainer_scripts.csv',UNUSED_REFERENCES)
    rows=[]
    for p in PARTIES.values():
        refs=[r for r in DATA['references'] if r['party_key']==p['key']]
        es=[e for e in EVENTS if e['party_key']==p['key']]
        for i,m in enumerate(p['mons']):
            rows.append(dict(party_key=p['key'],trainer_name=p['name'],aliases=p['aliases'],party_size=len(p['mons']),pokemon_slot=i+1,**m,party_solo_hard_exp=p['solo_hard_exp'],maps=sorted({r['map'] for r in refs}),reference_sources=[r['source'] for r in refs],event_ids=[e['event_id'] for e in es],visit_stages=sorted({e['stage'] for e in es}),access_requirements=sorted({e['requirements'] for e in es}),classification='one-time campaign / alternate' if es else 'repeatable/external/unused (see refs)',mandatory_any=any(e['mandatory'] for e in es),repeat_reference=any(r['party_key']==p['key'] for r in REPEATS)))
    write_csv('trainer_exp_database.csv',rows)
    zones=[]
    for name,plan in MAP_PLAN.items():
        es=[e for e in EVENTS if e['map']==name and not e['primary']]
        levels=[m['level'] for e in es for m in PARTIES[e['party_key']]['mons']]
        ys=[PARTIES[e['party_key']]['solo_hard_exp'] for e in es]
        phase_exp=defaultdict(int)
        for e,y in zip(es,ys):phase_exp[e['stage']]+=y
        import statistics
        zones.append(dict(**plan,trainer_exp_by_visit_stage=dict(phase_exp),one_time_events=len(es),mandatory_scenario_solo_exp=sum(y for e,y in zip(es,ys) if e['mandatory']),typical_expected_solo_exp=sum(y*(1 if e['mandatory'] else .35*.65 if e['optional_zone'] else .70) for e,y in zip(es,ys)),max_scheduled_one_time_solo_exp=sum(ys),mean_trainer_level=round(statistics.mean(levels),3) if levels else '',median_trainer_level=statistics.median(levels) if levels else '',min_trainer_level=min(levels) if levels else '',max_trainer_level=max(levels) if levels else '',day_wild_mean_exp=wild_mean(name),wild_ko_assumptions='0/2/5 per visited map; encounter-rate/travel-distance not observed; SURF ONLY after Morty, western Ruins grass also after Surf',wild_low_exp=0,wild_medium_exp=2*wild_mean(name),wild_high_exp=5*wild_mean(name)))
    write_csv('zone_exp_database.csv',zones)
    return zones

if __name__=='__main__':
    zones=export_catalog()
    print(json.dumps(dict(events=len(EVENTS),repeat_references=len(REPEATS),primary=sum(e['primary'] for e in EVENTS),unclassified=[x['map'] for x in zones if x['stage']==99 and x['one_time_events']]),indent=2))
