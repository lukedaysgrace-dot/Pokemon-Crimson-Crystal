"""Local interactive / command-line Hard Mode EXP simulator, no dependencies.

Run extract.py after changing game data. See README.md for route assumptions.
"""
import argparse
import json
from pathlib import Path
from model import DEFAULT_TEAM, GROWTH, GYMS, METHODS, PLAYSTYLES, SP, simulate
from extract import HERE,write_csv

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--team-size',type=int,choices=range(1,7),default=6)
    p.add_argument('--playstyle',choices=PLAYSTYLES,default='typical')
    p.add_argument('--sharing',choices=METHODS,default='casual')
    p.add_argument('--wild-kos',type=int,default=2,help='random travel KOs per NEW encounter-bearing map, not encounter rate')
    p.add_argument('--seed',type=int,default=0)
    p.add_argument('--team-json',type=Path,help='list of species, level, join_map and optional growth/traded/lucky overrides')
    p.add_argument('--order',help='16 comma-separated gym names; case sensitive; order constraints checked')
    p.add_argument('--proposal-json',type=Path,help='hypothetical caps, party_level_delta, trainer_level_delta, event_stage_overrides')
    p.add_argument('--early-cape',action='store_true',help='fight Crystal Cape AFTER Erika, before further gyms')
    p.add_argument('--skip-e4-rematch',action='store_true',help='go directly to Mt Silver; also excludes dependent Green/Blue/Red2 chain')
    p.add_argument('--early-explore',action='store_true',help='completionist earliest-access itinerary sensitivity (not a formal all-path maximum)')
    p.add_argument('--interactive',action='store_true')
    p.add_argument('--output',type=Path,default=HERE/'simulator_result.csv')
    args=p.parse_args()
    team=json.loads(args.team_json.read_text()) if args.team_json else DEFAULT_TEAM[:args.team_size]
    if args.interactive:
        args.team_size=int(input('Team size (1-6) [6]: ') or '6')
        args.playstyle=input('Playstyle minimal/typical/thorough/completionist/efficient [typical]: ') or 'typical'
        args.sharing=input('Sharing casual/equal_rotation/all_participants/main70/two_primary/lowest/switch/exp_share [casual]: ') or 'casual'
        args.wild_kos=int(input('Travel KOs per new wild map [2]: ') or '2')
        team=[]
        for i in range(args.team_size):
            default=DEFAULT_TEAM[i]
            species=(input(f'Slot {i+1} species [{default["species"]}]: ') or default['species']).upper()
            level=int(input(f'Starting level [{default["level"]}]: ') or str(default['level']))
            join=input(f'Join map [{default["join_map"]}]: ') or default['join_map']
            growth=input(f'Growth [{SP.get(species,{}).get("growth","GROWTH_MEDIUM_FAST")}]: ')
            team.append(dict(species=species,level=level,join_map=join,**({'growth':growth} if growth else {})))
        args.order=input('Gym order (comma separated; blank for default): ') or None
    if not 1<=args.team_size<=6:p.error('Team size must be 1-6')
    if len(team)!=args.team_size:p.error('team-json length must match team-size')
    if args.playstyle not in PLAYSTYLES or args.sharing not in METHODS:p.error('Unknown playstyle/sharing method')
    if args.wild_kos<0:p.error('wild-kos must be nonnegative')
    from model import MAP_PLAN
    for mon in team:
        if mon['species'] not in SP:p.error('Unknown species: '+mon['species'])
        if not 1<=mon['level']<=100:p.error('Starting levels must be 1-100')
        if mon.get('growth',SP[mon['species']]['growth']) not in GROWTH:p.error('Unsupported growth curve; Erratic and Fluctuating are not implemented')
        if mon.get('join_map','CherrygroveCity') not in MAP_PLAN:p.error('Unknown join map')
        if MAP_PLAN[mon.get('join_map','CherrygroveCity')]['stage']>=99:p.error('Join map is not in the campaign itinerary')
    proposal=json.loads(args.proposal_json.read_text()) if args.proposal_json else None
    try:
        result=simulate(args.team_size,args.playstyle,args.sharing,args.seed,args.wild_kos,team_specs=team,order=[x.strip() for x in args.order.split(',')] if args.order else None,proposed=proposal,early_cape=args.early_cape,skip_e4_rematch=args.skip_e4_rematch,early_explore=args.early_explore)
    except (AssertionError,KeyError) as err:p.error(str(err) or 'Invalid gym order')
    primary=[r for r in result['checkpoints'] if r['primary']]
    # write_csv accepts absolute Paths as well as audit-relative names.
    write_csv(args.output.resolve(),primary)
    write_csv(args.output.resolve().with_name(args.output.stem+'_individual.csv'),result['individual'])
    print('Scenario estimates; no automatic grinding. Endgame target = boss ace; actual Hard cap = 100.')
    print(f'{"Boss":24} {"Cap":>3} {"Target":>6} {"Levels":25} {"Shortfall":>10}')
    for r in primary:print(f'{r["milestone"]:24} {r["hard_cap"]:3} {r["target_level"]:6} {str(r["levels"]):25} {r["target_shortfall"]:10,}')
    print(f'Saved {args.output.resolve()}')

if __name__=='__main__':main()
