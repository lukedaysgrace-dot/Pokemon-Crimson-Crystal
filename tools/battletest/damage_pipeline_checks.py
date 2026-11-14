#!/usr/bin/env python3
"""Compare an independent damage model with complete native debug battle turns.

No battle routine is replaced. Hooks observe native command boundaries;
optional PRNG inputs select each real native variation roll. Initial staged
stats are explicit fixture inputs, independently derived from raw stats, since
the debug request's stage setup otherwise overwrites existing status penalties.
All emulator state/SRAM is private. Release ROM coverage is not claimed here.
"""
import argparse
from concurrent.futures import ProcessPoolExecutor
from itertools import product
import json
from pathlib import Path
import time

from damage_pipeline_oracle import MATCHUPS, calculate, staged
from runner import Harness, ROOT, Request, STATE_WAIT, STATE_DONE, STATE_ERROR


def cases():
    result = []

    def add(group, matchup, **overrides):
        case = dict(group=group, matchup=matchup, ability='NO_ABILITY', defender_ability='NO_ABILITY',
                    item='NO_ITEM', defender_item='NO_ITEM', level=50, target_level=100,
                    weather='none', critical=False, burn=False, screens=0, offense_stage=0,
                    defense_stage=0, reverse=False)
        case.update(overrides)
        if case['defender_item'] == 'ASSAULT_VEST':
            case['defender_status'] = 7
        case['id'] = len(result)
        result.append(case)

    # Full cross product within nine declared attack/matchup archetypes.
    for matchup, weather, critical, burn, screens, stages, reverse in product(
            tuple(MATCHUPS)[:9], ('none', 'rain', 'sun'), (False, True), (False, True), (0, 24),
            ((0, 0), (-6, 6), (6, -6), (-6, -6), (6, 6)), (False, True)):
        add('core', matchup, weather=weather, critical=critical, burn=burn, screens=screens,
            offense_stage=stages[0], defense_stage=stages[1], reverse=reverse)
    profiles = [
        ('fire-contact', 'TOUGH_CLAWS', 'LIFE_ORB', 'THICK_FAT', 'NO_ITEM'),
        ('fire-contact', 'TOUGH_CLAWS', 'METRONOME_ITEM', 'NO_ABILITY', 'NO_ITEM'),
        ('fire-contact', 'TOUGH_CLAWS', 'PUNCHING_GLOVE', 'FLUFFY', 'NO_ITEM'),
        ('fire-contact', 'IRON_FIST', 'PUNCHING_GLOVE', 'NO_ABILITY', 'NO_ITEM'),
        ('fire-contact', 'HUGE_POWER', 'CHOICE_BAND', 'MULTISCALE', 'NO_ITEM'),
        ('fire-contact', 'GUTS', 'CHOICE_BAND', 'FILTER', 'NO_ITEM'),
        ('fire-contact', 'SNIPER', 'EXPERT_BELT', 'SOLID_ROCK', 'NO_ITEM'),
        ('fire-contact', 'SHEER_FORCE', 'LIFE_ORB', 'FLUFFY', 'NO_ITEM'),
        ('fire-contact', 'KLUTZ', 'CHOICE_BAND', 'NO_ABILITY', 'NO_ITEM'),
        ('fire-contact', 'NO_ABILITY', 'MUSCLE_BAND', 'DRY_SKIN', 'NO_ITEM'),
        ('fire-special', 'ADAPTABILITY', 'CHARCOAL', 'NO_ABILITY', 'ASSAULT_VEST'),
        ('fire-special', 'SOLAR_POWER', 'CHOICE_SPECS', 'MULTISCALE', 'NO_ITEM'),
        ('fire-special', 'SHEER_FORCE', 'WISE_GLASSES', 'THICK_FAT', 'NO_ITEM'),
        ('fire-special', 'MEGA_SOL', 'LIFE_ORB', 'NO_ABILITY', 'NO_ITEM'),
        ('water-special', 'MEGA_SOL', 'MYSTIC_WATER', 'FILTER', 'NO_ITEM'),
        ('water-contact', 'HUGE_POWER', 'EXPERT_BELT', 'FUR_COAT', 'NO_ITEM'),
        ('quarter', 'TINTED_LENS', 'CHOICE_SPECS', 'NO_ABILITY', 'ASSAULT_VEST'),
        ('neutral', 'TECHNICIAN', 'MUSCLE_BAND', 'FUR_COAT', 'NO_ITEM'),
        ('neutral', 'HUSTLE', 'LIFE_ORB', 'NO_ABILITY', 'NO_ITEM'),
        ('neutral', 'MOLD_BREAKER', 'CHOICE_BAND', 'FUR_COAT', 'NO_ITEM'),
        ('neutral', 'INFILTRATOR', 'LIFE_ORB', 'NO_ABILITY', 'NO_ITEM'),
    ]
    for profile, weather, critical, burn, reverse in product(
            profiles, ('none', 'rain', 'sun'), (False, True), (False, True), (False, True)):
        matchup, ability, item, defender, target_item = profile
        add('stacked', matchup, ability=ability, item=item, defender_ability=defender,
            defender_item=target_item, weather=weather, critical=critical, burn=burn, screens=24,
            offense_stage=2, defense_stage=2, reverse=reverse)
    for matchup, weather, critical, screens, reverse in product(
            ('rock-sand', 'ice-hail', 'eviolite', 'eviolite-special', 'psyshock'),
            ('none', 'sandstorm', 'hail'), (False, True), (0, 24), (False, True)):
        add('defense', matchup, weather=weather, critical=critical, screens=screens, reverse=reverse,
            defender_item='EVIOLITE' if matchup.startswith('eviolite') else 'ASSAULT_VEST')
    for matchup, ability, critical, stages, reverse in product(
            ('neutral', 'psychic', 'psyshock'), ('UNAWARE', 'MOLD_BREAKER', 'NO_ABILITY'),
            (False, True), ((-3, 3), (3, -3)), (False, True)):
        add('unaware', matchup, ability=ability, defender_ability='UNAWARE', critical=critical,
            offense_stage=stages[0], defense_stage=stages[1], screens=24, burn=True, reverse=reverse)
    for matchup, level, value, critical, reverse in product(
            ('neutral', 'fire-contact', 'water-special'), (1, 100), (1, 2, 255, 256, 999),
            (False, True), (False, True)):
        add('boundaries', matchup, level=level, raw_stats=[value] * 5,
            target_raw_stats=[999 if value < 3 else 1] * 5, critical=critical,
            ability='TOUGH_CLAWS', item='METRONOME_ITEM', weather='sun', glaive_rush=True, reverse=reverse)
    for matchup, weather, critical, reverse in product(
            ('ground-immunity', 'ghost-immunity', 'dark-immunity'),
            ('none', 'rain', 'sun'), (False, True), (False, True)):
        add('immunity', matchup, weather=weather, critical=critical, reverse=reverse,
            ability='HUGE_POWER', item='LIFE_ORB')
    for weather, critical, reverse in product(('none', 'rain', 'sun'), (False, True), (False, True)):
        add('minimum', 'weak-water', weather=weather, critical=critical, reverse=reverse,
            level=1, raw_stats=[1] * 5, target_raw_stats=[999] * 5, ability='MEGA_SOL')
    for matchup, screen, critical, reverse in product(('neutral', 'psychic', 'psyshock'),
                                                      (8, 16), (False, True), (False, True)):
        add('screen-selection', matchup, screens=screen, critical=critical, reverse=reverse)
    for matchup, critical, reverse in product(('fire-special', 'water-special'), (False, True), (False, True)):
        for mode in ('variation', 'low-hp', 'frostbite', 'armor', 'gas', 'marvel'):
            settings = dict(critical=critical, reverse=reverse, item='LIFE_ORB', ability='SNIPER')
            if mode == 'variation':
                for roll in range(217, 256):
                    add('variation', matchup, **settings, variation_roll=roll)
                continue
            if mode == 'low-hp':
                settings['target_hp'] = 1
            if mode == 'frostbite':
                settings.update(frostbite=True, offense_stage=-3, defense_stage=3)
            if mode == 'armor':
                settings['defender_ability'] = 'BATTLE_ARMOR'
            if mode == 'gas':
                settings['defender_ability'] = 'NEUTRALIZING_GAS'
            if mode == 'marvel':
                settings.update(defender_ability='MARVEL_SCALE', defender_status=8)
                matchup = 'fire-contact'
            add(mode, matchup, **settings)
    return result


def wait(h, initial=False):
    for _ in range(4500):
        state = h.state()
        if state in (STATE_WAIT, STATE_DONE, STATE_ERROR) and (initial or h.battle.turns_done >= 1):
            if state == STATE_ERROR:
                raise RuntimeError('debug request rejected')
            return state
        h.pb.button('a', 2)
        h.tick(4)
    raise RuntimeError(f'native battle timeout: {h.where(samples=12)}')


class Observer:
    def __init__(self, h):
        self.h = h
        self.case = None
        for label, callback in (
                ('BattleCommand_DamageCalc', self.inputs),
                ('BattleCommand_Stab', self.base),
                ('BattleCommand_DamageVariation', self.modifiers),
                ('BattleCommand_DamageVariation.got_roll', self.roll),
                ('BattleCommand_CheckHit', self.restore_rng),
                ('BattleCommand_ApplyDamage', self.hit),
                ('BattleCommand_CriticalText', self.hp)):
            bank, address = h.sym[label]
            h.pb.hook_register(bank, address, callback, None)

    def active(self):
        m = self.h.battle.mem
        return self.case is not None and not m.read('wAIDamagePrediction') and m.read('hBattleTurn') == int(self.case['reverse'])

    def inputs(self, _):
        if self.active():
            r = self.h.pb.register_file
            m = self.h.battle.mem
            prefix = 'wEnemy' if self.case['reverse'] else 'wPlayer'
            self.seen['inputs'] = dict(attack=r.B, defense=r.C, power=r.D, level=r.E,
                                       critical=m.read('wCriticalHit'), category=m.read(prefix + 'MoveStructCategory'),
                                       type=m.read(prefix + 'MoveStructType'))

    def base(self, _):
        if self.active():
            self.seen['base'] = self.h.battle.mem.read_u16_be('wCurDamage')

    def modifiers(self, _):
        if self.active():
            self.seen['modifiers'] = self.h.battle.mem.read_u16_be('wCurDamage')
            if 'variation_roll' in self.case:
                # Supply a PRNG seed, not a damage or multiplier result.
                # Native _BattleRandom reads it, then the retail rrca/range
                # check and multiply/divide still execute unmodified.
                m = self.h.battle.mem
                roll = self.case['variation_roll']
                m.write('wLinkBattleRNCount', 0)
                m.write('wLinkBattleRNs', ((roll << 1) | (roll >> 7)) & 255)
                m.write('hDebugRNGMode', 2)

    def roll(self, _):
        if self.active():
            self.seen['roll'] = self.h.pb.register_file.A

    def restore_rng(self, _):
        if self.active():
            self.h.battle.mem.write('hDebugRNGMode', 1)

    def hit(self, _):
        if self.active():
            self.seen['hit'] = self.h.battle.mem.read_u16_be('wCurDamage')

    def hp(self, _):
        if self.active():
            self.seen['hp'] = self.h.battle.mem.read_u16_be(self.target_prefix + 'HP')

    def run(self, case):
        self.case = None
        h, m = self.h, self.h.battle.mem
        actor, target, move, *_ = MATCHUPS[case['matchup']]
        attacking = dict(species=actor, level=case['level'], ability=case['ability'], item=case['item'], moves=[move],
                         status_byte=(16 if case['burn'] else 0) | (32 if case.get('frostbite') else 0))
        defending = dict(species=target, level=case['target_level'], ability=case['defender_ability'],
                         item=case['defender_item'], moves=['SPLASH'], status_byte=case.get('defender_status', 0))
        test = dict(player=defending if case['reverse'] else attacking,
                    enemy=attacking if case['reverse'] else defending, turns=0,
                    rng='forced', rng_value=4 if case['critical'] else 20, weather=case['weather'])
        h.load_fixture()
        Request(h.battle).write(test)
        if wait(h, initial=True) != STATE_WAIT:
            raise RuntimeError('did not reach the zero-turn native battle pause')
        actor_side, target_side = ('wEnemy', 'wPlayer') if case['reverse'] else ('wPlayer', 'wEnemy')
        actor_prefix, self.target_prefix = ('wEnemyMon', 'wBattleMon') if case['reverse'] else ('wBattleMon', 'wEnemyMon')
        raw_actor = case.get('raw_stats') or [m.read_u16_be(actor_side + 'Stats', 2 * i) for i in range(5)]
        raw_target = case.get('target_raw_stats') or [m.read_u16_be(target_side + 'Stats', 2 * i) for i in range(5)]
        raw_actor, raw_target = list(raw_actor), list(raw_target)
        if case.get('glaive_rush'):
            # Vulnerability expires when its owner acts. This declared
            # boundary state needs the attacker to act before that expiry.
            raw_actor[2], raw_target[2] = 999, 1
        # Facility EXP suppression keeps a level-1 boundary KO from spending
        # the test in dozens of unrelated level-up/move-learning menus.
        m.write('wInBattleTowerBattle', 1)
        # Build coherent declared initial states without replacing any damage
        # code. The raw mirrors stay distinct from stage/status-adjusted stats.
        for side, prefix, raw, offensive in ((actor_side, actor_prefix, raw_actor, True),
                                              (target_side, self.target_prefix, raw_target, False)):
            stages = [case['offense_stage'] if i in (0, 3) else 0 for i in range(5)] if offensive else [case['defense_stage'] if i in (1, 4) else 0 for i in range(5)]
            m.write_bytes(side + 'StatLevels', [s + 7 for s in stages] + [7, 7])
            for i, value in enumerate(raw):
                m.write_bytes(side + 'Stats', value.to_bytes(2, 'big'), 2 * i)
                cut = offensive and ((i == 0 and case['burn']) or (i == 3 and case.get('frostbite')))
                m.write_bytes(prefix + 'Stats', staged(value, stages[i], cut).to_bytes(2, 'big'), 2 * i)
        m.write(target_side + 'Screens', case['screens'])
        m.write(target_side + 'ReflectCount', 5)
        m.write(target_side + 'LightScreenCount', 5)
        if case.get('glaive_rush'):
            m.write(target_side + 'GlaiveRush', 1)
        if case['item'] == 'METRONOME_ITEM':
            m.write(actor_side + 'MetronomeMove', m.read(actor_prefix + 'Moves'))
            m.write(actor_side + 'MetronomeCount', 5)
            m.write(actor_side + 'MetronomeLanded', 1)
        if case.get('target_hp'):
            m.write_bytes(self.target_prefix + 'HP', case['target_hp'].to_bytes(2, 'big'))
        initial_hp = m.read_u16_be(self.target_prefix + 'HP')
        self.seen = {}
        self.case = case
        m.write('wDebugTurnTarget', 1)
        m.write('wDebugControl', 1)
        wait(h)
        self.case = None
        expected_roll = case.get('variation_roll', 255)
        expected = calculate(case, raw_actor, raw_target, expected_roll)
        errors = []
        actual_inputs = self.seen.get('inputs')
        wanted_inputs = {key: expected[key] for key in ('attack', 'defense', 'power', 'critical', 'category')}
        wanted_inputs['level'] = case['level']
        wanted_inputs['type'] = {'NORMAL': 0, 'FIRE': 20, 'WATER': 21, 'ELECTRIC': 23, 'PSYCHIC': 24, 'ICE': 25}[MATCHUPS[case['matchup']][4]]
        if actual_inputs != wanted_inputs:
            errors.append(f'formula inputs {actual_inputs} != {wanted_inputs}')
        for boundary in ('base', 'modifiers'):
            if self.seen.get(boundary) != expected[boundary]:
                errors.append(f'{boundary} {self.seen.get(boundary)} != {expected[boundary]}')
        if expected['modifiers'] >= 2 and self.seen.get('roll') != expected_roll:
            errors.append(f'native variation roll {self.seen.get("roll")} != {expected_roll}')
        if expected['final']:
            if self.seen.get('hit') != expected['final']:
                errors.append(f'hit {self.seen.get("hit")} != {expected["final"]}')
            wanted_hp = max(0, initial_hp - expected['final'])
            if self.seen.get('hp') != wanted_hp:
                errors.append(f'immediate HP {self.seen.get("hp")} != {wanted_hp}')
        elif 'hit' in self.seen or m.read_u16_be(self.target_prefix + 'HP') != initial_hp:
            errors.append('immune hit applied damage')
        if h.text_overflows:
            errors.extend(h.text_overflows)
        return dict(case=case, raw_actor=raw_actor, raw_target=raw_target, expected=expected,
                    observed=self.seen, errors=errors)


def worker(payload):
    selected, rom = payload
    h = Harness(rom_path=rom, render=False, instant_text=True, short_delays=True)
    h.ensure_fixture()
    observer = Observer(h)
    records = []
    try:
        for case in selected:
            try:
                record = observer.run(case)
            except Exception as error:
                record = dict(case=case, errors=[repr(error)], errored=True, observed=getattr(observer, 'seen', {}))
            records.append(record)
    finally:
        h.pb.stop(save=False)
    return dict(rom_sha256=h.rom_sha256, records=records)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal_debug.gbc')
    ap.add_argument('--jobs', type=int, default=1)
    ap.add_argument('--group')
    ap.add_argument('--limit', type=int)
    ap.add_argument('--output', type=Path, default=ROOT / '_artifacts/damage-pipeline/results.json')
    args = ap.parse_args()
    selected = [case for case in cases() if not args.group or case['group'] == args.group]
    if args.limit:
        selected = selected[:args.limit]
    if args.jobs < 1 or not selected:
        ap.error('positive worker count and at least one case required')
    started = time.monotonic()
    print(f'Running {len(selected)} complete native battle turns across {args.jobs} workers', flush=True)
    payloads = [(selected[i::args.jobs], str(args.rom)) for i in range(args.jobs)]
    if args.jobs == 1:
        outcomes = [worker(payloads[0])]
    else:
        with ProcessPoolExecutor(max_workers=args.jobs) as pool:
            outcomes = list(pool.map(worker, payloads))
    records = sorted((record for outcome in outcomes for record in outcome['records']), key=lambda r: r['case']['id'])
    failed = [record for record in records if record['errors']]
    errors = sum(bool(record.get('errored')) for record in records)
    summary = dict(cases=len(records), passed=len(records) - len(failed), failed=len(failed) - errors,
                   errored=errors, skipped=0, seconds=round(time.monotonic() - started, 2),
                   rom_sha256=sorted({outcome['rom_sha256'] for outcome in outcomes}),
                   groups={group: sum(r['case']['group'] == group for r in records) for group in sorted({r['case']['group'] for r in records})})
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(dict(summary=summary, records=records), indent=2) + '\n')
    for record in failed[:30]:
        print('FAIL', record['case'], *record['errors'], sep='\n  ')
    print(json.dumps(summary, indent=2), flush=True)
    raise SystemExit(bool(failed))


if __name__ == '__main__':
    main()
