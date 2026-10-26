"""Reference reconciliation, move data and per-boss combat-context inventories."""
import csv
import json
import re
from collections import Counter
from model import *

def main():
    rows=[]
    for r in DATA['references']:
        src=r['source'];p=PARTIES[r['party_key']]
        if src in [x['source'] for x in UNUSED_REFERENCES]:status='unspawned trainer script; excluded'
        elif src in [x['source'] for x in REPEATS]:status='repeatable/external reference; excluded from unique run'
        elif any(src in e['reference_sources'] for e in EVENTS):status='selected encounter / shared completion flag'
        elif p['group'] in ['Rival1','Rival2','Crystal']:status='mutually exclusive starter alternative; cataloged, not stacked'
        elif any(e['party_key']==r['party_key'] and e['map']==r['map'] for e in EVENTS):status='duplicate loader / shared encounter'
        else:status='UNRESOLVED'
        rows.append(dict(**r,classification=status))
    assert not any(r['classification']=='UNRESOLVED' for r in rows)
    write_csv('reference_coverage.csv',rows)
    unreferenced=[]
    keys={r['party_key'] for r in DATA['references']}
    for k,p in PARTIES.items():
        if k not in keys:unreferenced.append(dict(party_key=k,name=p['name'],label=p['label'],source=p['source'],classification='dynamic Trainer House tier' if p['group']=='PKMNTrainer' and p['id'] in [4,5,6] else 'no direct map reference; not credited',solo_hard_exp=p['solo_hard_exp']))
    write_csv('parties_without_direct_map_reference.csv',unreferenced)
    moves=[]
    for i,line in enumerate(read('data/moves/moves.asm').splitlines()):
        m=re.match(r'\s*move\s+([^;]+);\s*(\w+)',line)
        if not m:continue
        parts=[x.strip() for x in m[1].split(',')]
        if len(parts)!=7:continue
        effect,power,typ,category,accuracy,pp,chance=parts
        moves.append(dict(move=m[2],effect=effect,power=int(power),type=typ,category=category,accuracy_percent=int(accuracy),pp=int(pp),effect_chance_percent=int(chance),source=f'data/moves/moves.asm:{i+1}'))
    write_csv('move_data.csv',moves)
    evos=[]
    for sp,defs in DATA['curricula'].items():
        for row in defs:
            if 'EVOLVE' not in row['command']:continue
            target=row['command'].split(',')[-1].strip()
            assert target in SP,(sp,target)
            evos.append(dict(species=sp,evolution_target=target,method=row['command'],growth_before=SP[sp]['growth'],growth_after=SP[target]['growth'],same_growth=SP[sp]['growth']==SP[target]['growth'],source=row['source']))
    write_csv('evolution_growth_continuity.csv',evos)
    trades=[]
    for i,line in enumerate(read('data/events/npc_trades.asm').splitlines()):
        if not line.strip().startswith('npctrade '):continue
        parts=next(csv.reader([line.strip()[9:]],skipinitialspace=True))
        if len(parts)!=10:continue
        trades.append(dict(requested_species=parts[1].strip(),offered_species=parts[2].strip(),held_item=parts[6].strip(),ot_id=parts[7].strip(),level_rule='matches traded-away level (engine/events/npc_trade.asm)',source=f'data/events/npc_trades.asm:{i+1}'))
    write_csv('npc_trades.csv',trades)
    facts=dict(reference_classification=dict(Counter(r['classification'] for r in rows)),parties_with_direct_reference=len(keys),parties_without_direct_reference=len(unreferenced),moves_parsed=len(moves),evolution_methods=len(evos),evolution_growth_changes=[r for r in evos if not r['same_growth']],npc_trades=len(trades))
    (HERE/'catalog_coverage.json').write_text(json.dumps(facts,indent=2))
    print(json.dumps(facts,indent=2))

if __name__=='__main__':main()
