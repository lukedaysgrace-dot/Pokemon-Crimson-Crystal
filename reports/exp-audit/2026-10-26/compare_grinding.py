"""Targeted catch-up KO comparisons for the hypothetical changes (no game edits).

All six sizes, typical playstyle, casual/equal rotation; affected and late
checkpoints. Each estimate starts from the unground state at that checkpoint.
"""
import csv
import json
from model import HERE, write_csv
from run_audit import grind_estimate

PAIRS=[('jasmine_cap32','Jasmine'),('lighthouse_before_chuck','Chuck'),
       ('lighthouse_before_chuck','Jasmine'),('jasmine_trainers_plus3','Jasmine'),
       ('surge_trainers_plus3','Surge'),('endgame_level_retarget_trial','Clair rematch'),
       ('endgame_level_retarget_trial','Red Mt Silver'),('combined_trial','Jasmine'),
       ('combined_trial','Blue'),('combined_trial','Red Mt Silver')]


def main():
    baseline=json.loads((HERE/'baseline_results.json').read_text())
    with (HERE/'hypothetical_changes.csv').open(newline='',encoding='utf-8') as f:
        trials=[r for r in csv.DictReader(f) if r['playstyle']=='typical' and (r['proposal'],r['milestone']) in PAIRS]
    out=[];cache={}
    for r in trials:
        for k in ['species','exp_totals','growths','levels']:r[k]=json.loads(r[k])
        for k in ['target_level','hard_cap','badges','team_size']:r[k]=int(r[k])
        old=next(x for x in baseline[f"typical:{r['team_size']}:{r['method']}"] if x['milestone']==r['milestone'])
        estimates=[]
        for row in [old,r]:
            k=(tuple(row['exp_totals']),tuple(row['growths']),row['target_level'],row['hard_cap'],row['wild_map'],row['badges'],r['method'])
            if k not in cache:
                cache[k]=[grind_estimate(row,'lowest')[0],grind_estimate(row,r['method'])[0]]
            estimates.append(cache[k])
        out.append(dict(proposal=r['proposal'],playstyle='typical',team_size=r['team_size'],method=r['method'],milestone=r['milestone'],
                        original_target=old['target_level'],trial_target=r['target_level'],wild_map=r['wild_map'],
                        original_balanced_kos=estimates[0][0],trial_balanced_kos=estimates[1][0],
                        original_selected_policy_kos=estimates[0][1],trial_selected_policy_kos=estimates[1][1],
                        scope='independent catch-up from unground checkpoint; NEVER add across milestones; target is not a proven win requirement'))
    write_csv('hypothetical_grinding.csv',out)
    print(f'Compared {len(out)} targeted scenarios; both training policies, original and trial.')


if __name__=='__main__':main()
