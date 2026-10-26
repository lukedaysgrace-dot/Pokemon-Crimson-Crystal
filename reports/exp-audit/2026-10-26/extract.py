"""Lossless source inventory for the EXP audit. No game writes; stdlib only."""
import csv
import hashlib
import json
import re
import time
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]

def read(path):
    return (ROOT / path).read_text(encoding='utf-8-sig', errors='replace')

def write_csv(path, rows, fields=None):
    rows = list(rows)
    fields = fields or list(dict.fromkeys(k for row in rows for k in row))
    target=HERE/path
    temporary=target.with_suffix(target.suffix+'.tmp')
    with temporary.open('w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fields, extrasaction='ignore')
        w.writeheader()
        for row in rows:
            w.writerow({k: json.dumps(v, ensure_ascii=False) if isinstance(v, (list, dict)) else v for k, v in row.items()})
    for attempt in range(4):
        try:temporary.replace(target);break
        except OSError:
            if attempt==3:raise
            time.sleep(.25)

def supplemental(species, metadata, id_maps):
    fish_src=read('data/wild/fish.asm')
    groups=re.findall(r'^\s*fishgroup (.*)',fish_src,re.M)
    constants=re.findall(r'^\s*const (FISHGROUP_\w+)',read('constants/map_data_constants.asm'),re.M)[1:]
    assert len(groups)==len(constants)
    tables=defaultdict(list); cur=None
    times=[]
    for i,line in enumerate(fish_src.splitlines()):
        if m:=re.match(r'^(\.\w+):',line): cur=m[1]
        if m:=re.match(r'\s*dbbw\s+(.*?),\s*(\d+),\s*(\w+)',line):
            threshold=int(m[1].split()[0])*255//100+(1 if '+ 1' in m[1] else 0)
            tables[cur].append(dict(threshold=threshold,level=int(m[2]),species=m[3],source=f'data/wild/fish.asm:{i+1}'))
        if m:=re.match(r'\s*dbwbw\s+(\d+),\s*(\w+),\s*(\d+),\s*(\w+)',line):
            times.append([(int(m[1]),m[2]),(int(m[3]),m[4])])
    fish=[]
    for idx,(constant,line) in enumerate(zip(constants,groups)):
        parts=[x.strip() for x in line.split(',')]
        bite=int(parts[0].split()[0])*255//100+(1 if '+ 1' in parts[0] else 0)
        for rod,label in zip(('old_rod','good_rod','super_rod'),parts[1:]):
            prev=-1
            for slot,row in enumerate(tables[label]):
                probability=(row['threshold']-prev)/256; prev=row['threshold']
                for ti,time in enumerate(('day','night')):
                    level,sp=(times[row['level']][ti] if row['species']=='TIME_GROUP' else (row['level'],row['species']))
                    map_names=[name for name,info in metadata.items() if info.get('fishgroup')==constant]
                    scaling='max(listed, listed//2 + 4*Johto_badges)' if idx<13 else ('listed + [0,4,8,12,12,12,16,19,23][Kanto_badges]' if constant in ['FISHGROUP_OCEAN_KANTO','FISHGROUP_LAKE_KANTO','FISHGROUP_POND_KANTO'] else 'fixed')
                    fish.append(dict(group=constant,method=rod,time=time,slot=slot,probability_conditional_on_bite=probability,bite_probability=bite/256,listed_level=level,species=sp,base_exp=species[sp]['base_exp'],listed_solo_exp=species[sp]['base_exp']*level//7,scaling=scaling,maps=map_names,source=row['source']))
    write_csv('fishing_encounters.csv',fish)
    tree_src=read('data/wild/treemons.asm'); sets={}; labels=[]; rows=[]; tier=0
    for i,line in enumerate(tree_src.splitlines()):
        if m:=re.match(r'^(TreeMonSet_\w+):',line):
            if rows:
                for label in labels: sets[label]=rows
                rows=[]; labels=[]; tier=0
            labels.append(m[1])
        if m:=re.match(r'\s*dbbw\s+(\d+),\s*(\d+),\s*(\w+)',line):
            prob,level,sp=int(m[1]),int(m[2]),m[3]
            rows.append(dict(tier='common' if tier==0 else 'rare',probability=prob/100,level=level,species=sp,base_exp=species[sp]['base_exp'],solo_exp=species[sp]['base_exp']*level//7,source=f'data/wild/treemons.asm:{i+1}'))
        if line.strip()=='db -1': tier+=1
    if rows:
        for label in labels: sets[label]=rows
    pointer_labels=re.findall(r'^\s*dw (TreeMonSet_\w+)',tree_src,re.M)
    set_constants=re.findall(r'^\s*const (TREEMON_SET_\w+)', ''.join(p.read_text() for p in (ROOT/'constants').glob('*.asm')),re.M)
    assert len(pointer_labels)==len(set_constants),(len(pointer_labels),len(set_constants))
    tree_ids=dict(zip(set_constants,pointer_labels))
    tree=[]; mode='headbutt'
    for line in read('data/wild/treemon_maps.asm').splitlines():
        if line.startswith('RockMonMaps:'): mode='rock_smash'
        if m:=re.match(r'\s*treemon_map (\w+),\s*(\w+)',line):
            for row in sets[tree_ids[m[2]]]: tree.append(dict(map=id_maps.get(m[1],m[1]),method=mode,set=m[2],**row))
    write_csv('tree_rock_encounters.csv',tree)
    contest=[]
    for filename,method,mapname in [('bug_contest_mons.asm','bug_contest','NationalParkBugContest'),('fishing_contest_mons.asm','fishing_contest','OlivineFishingCove')]:
        total=0
        for i,line in enumerate(read('data/wild/'+filename).splitlines()):
            if m:=re.match(r'\s*dbwbb\s+(-?\d+),\s*(\w+),\s*(\d+),\s*(\d+)',line):
                prob=int(m[1]) if m[1]!='-1' else 100-total; total+=prob
                contest.append(dict(map=mapname,method=method,probability=prob/100,species=m[2],min_level=int(m[3]),max_level=int(m[4]),source=f'data/wild/{filename}:{i+1}',battle_exp='no KO EXP in Safari-style capture-only contest'))
    write_csv('contest_encounters.csv',contest)
    # Follow INCLUDEs for the complete custom evolution and move curriculum.
    visited=set(); texts={}
    def include(path):
        if path in visited:return
        visited.add(path); texts[path]=read(path)
        for inc in re.findall(r'^\s*INCLUDE "(data/pokemon/evos_attacks[^\"]+)"',texts[path],re.M): include(inc)
    include('data/pokemon/evos_attacks.asm')
    pointers={}; definitions={}
    for path,src in texts.items():
        label=None
        for i,line in enumerate(src.splitlines()):
            if m:=re.match(r'^(\w+):',line): label=m[1]
            if m:=re.match(r'\s*dw (\w+EvosAttacks)\s*$',line): pointers.setdefault(label,[]).append(m[1])
            if label and label.endswith('EvosAttacks'):
                s=line.split(';',1)[0].strip()
                if s.startswith(('dbbw EVOLVE','dbbbw EVOLVE','dbw ')):
                    definitions.setdefault(label,[]).append(dict(command=s,source=f'{path}:{i+1}'))
    names=list(species); cursor=0; curricula={}
    for end,ptr in re.findall(r'^\s*indirect_entries (\w+),\s*(\w+)',read('data/pokemon/evos_attacks.asm'),re.M):
        end_idx=names.index(end)+1 if end!='NUM_POKEMON' else len(names)
        sl=names[cursor:end_idx]
        assert len(sl)==len(pointers[ptr]),(ptr,len(sl),len(pointers[ptr]))
        for name,label in zip(sl,pointers[ptr]): curricula[name]=definitions.get(label,[])
        cursor=end_idx
    assert len(curricula)==len(species)
    write_csv('evolutions_learnsets.csv',[dict(species=sp,**row) for sp,rows in curricula.items() for row in rows])
    return dict(fish=fish,trees=tree,contests=contest,curricula=curricula)

def extract():
    species_names = re.findall(r'^\s*const\s+(\w+)', read('constants/pokemon_constants.asm').split('const_def 1',1)[1].split('NUM_POKEMON',1)[0], re.M)
    species_names = [x for x in species_names if x != 'EGG']
    includes = re.findall(r'INCLUDE "(data/pokemon/base_stats/[^\"]+)"', read('data/pokemon/base_stats.asm'))
    assert len(species_names) == len(includes)
    species = {}
    for name, filename in zip(species_names, includes):
        src = read(filename)
        def match(p):
            m = re.search(p, src)
            assert m, (name,p)
            return m
        stats = [int(x.strip()) for x in match(r'db\s+((?:\d+\s*,\s*){5}\d+)').group(1).split(',')]
        ab = match(r'abilities_for\s+\w+,\s*(\w+),\s*(\w+),\s*(\w+)').groups()
        species[name] = dict(species=name, base_exp=int(match(r'db\s+(\d+)\s*;\s*base exp').group(1)), growth=match(r'db\s+(GROWTH_\w+)\s*;\s*growth rate').group(1), stats=stats, bst=sum(stats), abilities=list(ab), source=filename, types=list(match(r'db\s+(\w+),\s*(\w+)\s*;\s*type').groups()))
    classes, ids, klass, id_values = [], {}, None, {}
    for line in read('constants/trainer_constants.asm').splitlines():
        m = re.match(r'\s*trainerclass (\w+)', line)
        if m:
            klass = m[1]
            classes.append(klass)
            ids[klass] = {}
        m = re.match(r'\s*const (\w+)', line)
        if m and klass:
            ids[klass][m[1]] = len(ids[klass])+1
            id_values[m[1]]=ids[klass][m[1]]
        m=re.match(r'\s*(\w+) EQU (\w+)\s*(?:;.*)?$',line)
        if m and m[2] in id_values:
            id_values[m[1]]=id_values[m[2]]
            ids[klass][m[1]]=id_values[m[2]]
    pointers = re.findall(r'^\s*dba (\w+)Group', read('data/trainers/party_pointers.asm'), re.M)
    assert len(pointers) == len(classes)-1, (len(pointers),len(classes))
    class_group = dict(zip(classes[1:], pointers))
    parties, group, cur = {}, None, None
    lines = read('data/trainers/parties.asm').splitlines()
    counts = defaultdict(int)
    for i,line in enumerate(lines):
        s = line.split(';',1)[0].strip()
        m = re.match(r'(\w+)Group:',s)
        if m: group=m[1]
        if s.startswith('next_list_item'):
            counts[group]+=1
            key=f'{group}:{counts[group]}'
            cur=dict(key=key, group=group, id=counts[group], label=line.split(';',1)[-1].strip(), source=f'data/trainers/parties.asm:{i+1}', mons=[])
            parties[key]=cur
        if cur and (m:=re.match(r'db "([^"]*)@",\s*(.*)',s)):
            cur['name'],cur['type']=m.groups()
        if cur and 'type' in cur and (m:=re.fullmatch(r'db\s+(\d+)',s)) and i+1 < len(lines):
            nxt=lines[i+1].split(';',1)[0].strip()
            sm=re.fullmatch(r'dw\s+(\w+)',nxt)
            if sm:
                sp=sm[1]
                assert sp in species,(cur['key'],sp)
                details=[]
                j=i+2
                while j<len(lines):
                    a=lines[j].split(';',1)[0].strip()
                    if re.fullmatch(r'db\s+(?:-1|\d+)',a) or a.startswith('next_list_item') or a.startswith('end_list_items'): break
                    if a.startswith(('db ','dw ')): details.append(a)
                    j+=1
                items=[x[3:] for x in details if x.startswith('db ')]
                moves=[v.strip() for x in details if x.startswith('dw ') for v in x[3:].split(',')]
                has_item='ITEM' in cur['type']
                has_ability='ABILITY' in cur['type']
                mon=dict(species=sp,level=int(m[1]),base_exp=species[sp]['base_exp'],growth=species[sp]['growth'],item=items[0] if has_item else 'NO_ITEM',ability_slot=items[int(has_item)] if has_ability and len(items)>int(has_item) else 'generated',moves=moves,source=f'data/trainers/parties.asm:{i+1}')
                mon['solo_hard_exp']=2*(mon['base_exp']*mon['level']//7)
                cur['mons'].append(mon)
    for p in parties.values():
        p['aliases']=[f'{cl}/{ident}' for cl,g in class_group.items() if g==p['group'] for ident,n in ids[cl].items() if n==p['id']]
        p['solo_hard_exp']=sum(m['solo_hard_exp'] for m in p['mons'])
    map_ids={name:mid for name,mid in re.findall(r'^\s*map_attributes (\w+),\s*(\w+)',read('data/maps/attributes.asm'),re.M)}
    id_maps={v:k for k,v in map_ids.items()}
    metadata={}
    for line in read('data/maps/maps.asm').splitlines():
        if not re.match(r'^\s*map \w+,',line):continue
        values=[v.strip() for v in line.split(';',1)[0].strip()[4:].split(',')]
        assert len(values)==8,values
        name,tileset,env,landmark,music,phone,time,fish=values
        metadata[name]=dict(tileset=tileset,environment=env,landmark=landmark,fishgroup=fish)
    assert set(metadata)==set(map_ids),(set(metadata)-set(map_ids),set(map_ids)-set(metadata))
    refs, maps, gates, edges, static,gifts=[] ,{},[],[],[],[]
    for file in sorted((ROOT/'maps').glob('*.asm')):
        name=file.stem
        src=file.read_text(encoding='utf-8-sig',errors='replace')
        sl=src.splitlines()
        global_label,local_label='',''
        obj=defaultdict(list)
        for i,line in enumerate(sl):
            s=line.split(';',1)[0].strip()
            if s.startswith('object_event '):
                a=[x.strip() for x in s[13:].split(',')]
                if len(a)>=13: obj[a[11]].append(dict(x=a[0],y=a[1],movement=a[3],type=a[9],sight=a[10],visibility=a[12],line=i+1))
        for i,line in enumerate(sl):
            s=line.split(';',1)[0].strip()
            lm=re.match(r'^([A-Za-z_]\w*):',s)
            if lm: global_label,local_label=lm[1],''
            lm=re.match(r'^(\.\w+):?$',s)
            if lm: local_label=lm[1]
            m=re.match(r'(trainer|loadtrainer)\s+(\w+),\s*(\w+)(?:,\s*(\w+))?',s)
            if m:
                kind,cl,ident,evt=m.groups()
                assert cl in class_group and ident in id_values,(name,i+1,cl,ident)
                key=f'{class_group[cl]}:{id_values[ident]}'
                assert key in parties,(name,key)
                clean_src='\n'.join(l.split(';',1)[0] for l in sl)
                label_uses=len(re.findall(r'(?<![\w.])'+re.escape(global_label)+r'(?![\w.])',clean_src))
                refs.append(dict(map=name,map_id=map_ids.get(name,''),kind=kind,trainer_class=cl,trainer_id=ident,party_key=key,event=evt if kind=='trainer' else '',script=global_label+local_label,global_script=global_label,objects=obj.get(global_label,[]),global_label_uses=label_uses,source=f'maps/{name}.asm:{i+1}'))
            if re.match(r'(checkevent|checkflag|readmem|readvar|checkitem|checkpoke|checkcode|setscene|setmapscene|changeblock|farscall|callasm|special)\b',s):
                gates.append(dict(map=name,script=global_label+local_label,command=s,source=f'maps/{name}.asm:{i+1}'))
            if m:=re.match(r'warp_event\s+(-?\d+),\s*(-?\d+),\s*(\w+),\s*(\d+)',s):
                x,y,dst,warp=m.groups()
                edges.append(dict(from_map=name,to_map=id_maps.get(dst,dst),kind='warp',x=x,y=y,destination_warp=warp,source=f'maps/{name}.asm:{i+1}'))
            if m:=re.match(r'loadwildmon\s+(\w+),\s*(\d+)',s):
                static.append(dict(map=name,species=m[1],level=int(m[2]),source=f'maps/{name}.asm:{i+1}',script=global_label+local_label))
            if m:=re.match(r'(givepoke|giveegg)\s+(\w+),\s*(\w+)',s):
                lev=m[3]
                if not lev.isdigit():
                    cm=re.search(r'^'+lev+r'\s+EQU\s+(\d+)',src,re.M)
                    if cm:lev=cm[1]
                gifts.append(dict(map=name,method=m[1],species=m[2],level=int(lev) if lev.isdigit() else '',level_expression=m[3],source=f'maps/{name}.asm:{i+1}',script=global_label+local_label))
        maps[name]=dict(map=name,map_id=map_ids.get(name,''),source=f'maps/{name}.asm',**metadata.get(name,{}),trainer_refs=sum(r['map']==name for r in refs),gates=sum(g['map']==name for g in gates))
    current=None
    for i,line in enumerate(read('data/maps/attributes.asm').splitlines()):
        if m:=re.match(r'\s*map_attributes (\w+),',line): current=m[1]
        if current and (m:=re.match(r'\s*connection (\w+),\s*(\w+),',line)):
            edges.append(dict(from_map=current,to_map=m[2],kind='connection',direction=m[1],source=f'data/maps/attributes.asm:{i+1}'))
    wild=[]
    for file in sorted((ROOT/'data/wild').glob('*.asm')):
        if file.name not in ['johto_grass.asm','kanto_grass.asm','johto_water.asm','kanto_water.asm','swarm_grass.asm','swarm_water.asm']: continue
        current=None; index=0; rates='';table_label=''
        for i,line in enumerate(file.read_text().splitlines()):
            if m:=re.match(r'^(\w+):',line):table_label=m[1]
            if m:=re.match(r'\s*map_id (\w+)',line): current=m[1]; index=0
            if 'encounter rates' in line or ('percent' in line and line.strip().startswith('db ')): rates=line.strip()
            if current and (m:=re.match(r'\s*dbw\s+(\d+),\s*(\w+)',line)):
                level,sp=int(m[1]),m[2]
                assert sp in species,(file,sp)
                grass='grass' in file.name
                probs=[30,30,20,10,5,4,1] if grass else [60,30,10]
                slot=index%len(probs)
                exp=species[sp]['base_exp']*level//7
                expected=exp if grass else sum(species[sp]['base_exp']*(level+d)//7*p/256 for d,p in [(0,89),(1,76),(2,51),(3,26),(4,14)])
                wild.append(dict(map=id_maps.get(current,current),map_id=current,table_label=table_label,method='grass' if grass else 'surf',time=['morning','day','night'][index//7] if grass else 'all',slot=slot,probability=probs[slot]/100,level=level,max_runtime_level=level if grass else level+4,species=sp,base_exp=species[sp]['base_exp'],solo_exp=exp,expected_runtime_solo_exp=expected,encounter_rate_source=rates,source=f'data/wild/{file.name}:{i+1}',variant='swarm' if file.name.startswith('swarm') else 'standard'))
                index+=1
    caps=[]
    capbody=read('engine/pokemon/experience.asm').split('HardModeLevelCaps:',1)[1].split('assert',1)[0]
    for level,comment in re.findall(r'^\s*db (\d+)\s*;\s*(.*)',capbody,re.M): caps.append(dict(badges=len(caps),cap=int(level),comment=comment))
    assert len(caps)==16
    more=supplemental(species,metadata,id_maps)
    result=dict(species=species,parties=parties,class_group=class_group,trainer_ids=ids,maps=maps,references=refs,gates=gates,edges=edges,wild=wild,static=static,gifts=gifts,caps=caps,**more)
    (HERE/'extracted.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
    write_csv('species.csv',species.values())
    write_csv('trainer_references.csv',refs)
    write_csv('map_inventory.csv',maps.values())
    write_csv('access_conditions.csv',gates)
    write_csv('map_edges.csv',edges)
    write_csv('wild_encounters.csv',wild)
    write_csv('static_encounters.csv',static)
    write_csv('gift_pokemon.csv',gifts)
    sources=[]
    for folder in ('constants','data','engine','home','maps','macros'):
        for f in sorted((ROOT/folder).rglob('*')):
            if not f.is_file() or f.suffix not in ['.asm','.ablk','.bin']:continue
            sources.append(dict(path=f.relative_to(ROOT).as_posix(),sha256=hashlib.sha256(f.read_bytes()).hexdigest()))
    write_csv('source_manifest.csv',sources)
    write_csv('trainer_parties.csv',parties.values())
    print(json.dumps(dict(species=len(species),party_definitions=len(parties),empty=[p['key'] for p in parties.values() if not p['mons']],maps=len(maps),references=len(refs),wild_slots=len(wild),static=len(static),sources=len(sources))))
    return result

if __name__=='__main__': extract()
