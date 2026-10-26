"""Verify delivered data, provenance, accounting, links, charts and CLI behavior."""
import csv
import hashlib
import json
import re
import subprocess
import sys
import tempfile
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
from model import HERE, ROOT, exp_at, exp_award, level_of


def rows(name):
    with (HERE/name).open(encoding='utf-8', newline='') as f:
        yield from csv.DictReader(f)


def main():
    checks=[]
    def passed(name, count, detail=''):
        checks.append(dict(check=name, records=count, passed=True, detail=detail))
    # Failure aborts without producing a new PASS receipt.
    (HERE/'validation.json').unlink(missing_ok=True)
    manifest=list(rows('source_manifest.csv'))
    for r in manifest:
        assert hashlib.sha256((ROOT/r['path']).read_bytes()).hexdigest()==r['sha256'], r['path']
    passed('source fingerprints unchanged',len(manifest))
    cov=json.loads((HERE/'coverage.json').read_text())
    assert cov['unclassified_trainer_maps']==[]
    assert cov['simulation_runs']==2928
    passed('coverage and simulation matrix',cov['simulation_runs'])
    trainer=list(rows('trainer_exp_database.csv'))
    for r in trainer:
        assert int(r['solo_hard_exp'])==exp_award(int(r['base_exp']),int(r['level']))
    assert len(trainer)==1822 and len({r['party_key'] for r in trainer})==595
    passed('all trainer records recompute exactly',len(trainer))
    refs=list(rows('reference_coverage.csv'))
    assert len(refs)==585 and all(r['classification'] and 'UNRESOLVED' not in r['classification'] for r in refs)
    passed('all source trainer references classified',len(refs))
    # Key includes the scenario and the checkpoint. Side encounters are unique by name.
    key=lambda r:tuple(r[k] for k in ['cohort','playstyle','team_size','method','milestone'])
    member_totals=defaultdict(lambda:dict(exp=[],levels=[],earned=0,wasted=0,shortfall=0))
    n=0
    for r in rows('individual_progression.csv'):
        xp=int(r['exp']);growth=r['growth'];target=int(r['target'])
        assert level_of(xp,growth)==int(r['level'])
        assert xp-exp_at(int(r['starting_level']),growth)==int(r['cumulative_earned'])
        deficit=max(0,exp_at(target,growth)-xp)
        assert deficit==int(r['exp_to_target'])
        acc=member_totals[key(r)]
        acc['exp'].append(xp);acc['levels'].append(int(r['level']))
        acc['earned']+=int(r['cumulative_earned']);acc['wasted']+=int(r['cumulative_wasted'])
        acc['shortfall']+=deficit;n+=1
    passed('individual EXP thresholds, earned totals and shortfalls',n)
    primary=Counter();n=0
    for r in rows('team_progression.csv'):
        acc=member_totals.pop(key(r))
        assert acc['exp']==json.loads(r['exp_totals'])
        assert acc['levels']==json.loads(r['levels'])
        assert acc['earned']==int(r['cumulative_earned'])
        assert acc['wasted']==int(r['cumulative_wasted'])
        assert acc['shortfall']==int(r['target_shortfall'])
        assert len(acc['exp'])==int(r['party_size'])
        if int(r['badges'])==16:assert int(r['hard_cap'])==100
        if r['primary']=='True':primary[key(r)[:4]]+=1
        n+=1
    assert not member_totals
    assert len(primary)==480 and set(primary.values())=={42}
    passed('team/member reconciliation and 42 primary checkpoints per baseline',n)
    seen=set();n=0
    for r in rows('battle_ledger.csv'):
        k=tuple(r[x] for x in ['playstyle','team_size','method','event_id'])
        assert k not in seen,k
        seen.add(k);n+=1
    passed('one-time trainer ledger has no repeated event per scenario',n)
    native=json.loads((HERE/'native_verification.json').read_text())
    assert native['check_count']==2284 and not native['failures']
    assert all(c['passed'] for c in native['checks'])
    passed('native verification receipt',native['check_count'])
    test=subprocess.run([sys.executable,'-B',str(HERE/'test_audit.py')],capture_output=True,text=True)
    (HERE/'unit_checks.log').write_text(test.stdout+test.stderr,encoding='utf-8')
    assert test.returncode==0 and 'Ran 20 tests' in test.stderr,test.stderr
    passed('audit regression suite',20)
    # Exercise the public interface with an actual species/growth override roster.
    with tempfile.TemporaryDirectory(prefix='_verification_',dir=HERE) as td:
        td=Path(td);team=td/'team.json';out=td/'result.csv'
        assert td.resolve().is_relative_to(HERE.resolve())
        team.write_text(json.dumps([
            dict(species='CYNDAQUIL',level=5,join_map='CherrygroveCity'),
            dict(species='RATTATA',level=4,join_map='Route29',growth='GROWTH_SLOW',traded=True,lucky=True)
        ]))
        smoke=subprocess.run([sys.executable,'-B',str(HERE/'simulator.py'),'--team-size','2','--team-json',str(team),'--sharing','exp_share','--output',str(out)],capture_output=True,text=True)
        assert smoke.returncode==0,smoke.stderr
        with out.open(newline='') as f:assert len(list(csv.DictReader(f)))==42
        invalid=subprocess.run([sys.executable,'-B',str(HERE/'simulator.py'),'--wild-kos','-1'],capture_output=True,text=True)
        assert invalid.returncode==2 and 'must be nonnegative' in invalid.stderr
    passed('public CLI custom roster and invalid-input handling',2)
    link_count=0
    for p in HERE.glob('*.md'):
        for dest in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
            if '://' in dest or dest.startswith('#'):continue
            target=dest.split('#')[0]
            assert (p.parent/target).exists(),(p.name,target)
            link_count+=1
    passed('local report links resolve',link_count)
    charts=list(HERE.glob('[0-9][0-9]_*.png'))
    assert len(charts)==8
    for p in charts:
        assert p.read_bytes().startswith(b'\x89PNG\r\n\x1a\n') and p.stat().st_size>10000
        assert p.with_suffix('.svg').stat().st_size>10000
    passed('eight raster/vector chart pairs',len(charts))
    # Inventory hashes exclude self-referential receipts and the optional ZIP.
    excluded={'artifact_manifest.csv','validation.json'}
    files=[p for p in sorted(HERE.iterdir()) if p.is_file() and p.name not in excluded and p.suffix not in {'.zip','.tmp'}]
    with (HERE/'artifact_manifest.csv').open('w',newline='',encoding='utf-8') as f:
        writer=csv.writer(f);writer.writerow(['file','bytes','sha256'])
        for p in files:writer.writerow([p.name,p.stat().st_size,hashlib.sha256(p.read_bytes()).hexdigest()])
    passed('deliverable artifact fingerprints',len(files))
    receipt=dict(status='PASS',verified_at_utc=datetime.now(timezone.utc).isoformat(),checks=checks,
                 note='The 3,974 repository league checks were separately observed passing during this audit. They are not rerun or added to this verifier count. Native receipt checks execute compiled routines, not a full campaign. Reachability and player behavior limitations remain as documented.')
    (HERE/'validation.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
    print(json.dumps(receipt,indent=2))


if __name__=='__main__':main()
