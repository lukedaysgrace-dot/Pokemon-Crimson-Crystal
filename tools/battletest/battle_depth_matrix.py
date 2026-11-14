"""Focused native-turn outcomes for damage routing and lifecycle boundaries.

Authored expectations supplement the independent formula oracle. In
particular, counter/recoil/drain assertions use actual HP lost, rather than
the shared damage scratch word after other effects have run.
"""
from copy import deepcopy
from itertools import product

from exhaustive_battle_audit import mirror


def generate_battle_depth_tests():
    tests = []

    def base(move='TACKLE'):
        return dict(player=dict(species='MEW', level=50, ability='NO_ABILITY', moves=[move]),
                    enemy=dict(species='MEW', level=50, ability='NO_ABILITY', moves=['SPLASH']),
                    rng='forced', rng_value=20, turns=1,
                    setup_wram={'wInBattleTowerBattle': 1,
                                'wOTPlayerName': [0x93, 0x84, 0x92, 0x93, 0x50]},
                    assert_=[])

    def add(test, group, label, both=True):
        test = deepcopy(test)
        test['assert'] = test.pop('assert_') + [
            '0 <= player.hp <= player.maxhp', '0 <= enemy.hp <= enemy.maxhp',
            "wram('wInAbility') == 0", "(wram('wDisguiseBusted', 1) & 64) == 0"]
        for reverse in ((False, True) if both else (False,)):
            case = mirror(test) if reverse else deepcopy(test)
            if case.get('enemy2') and case.get('setup_wram', {}).get('wInBattleTowerBattle'):
                # The EXP-suppression flag also selects InitEnemyMon's
                # facility copy path. Unlike ordinary trainer loading it
                # reads party nicknames, which debug OT construction omits.
                def nickname(spec):
                    name = spec['species'].replace('_', ' ')[:10]
                    return [0x7f if ch == ' ' else 0x80 + ord(ch) - ord('A') for ch in name] + [0x50] * (11 - len(name))
                case['setup_wram']['wOTPartyMonNicknames'] = nickname(case['enemy']) + nickname(case['enemy2'])
            case['name'] = f'Depth {group}: {label} {"enemy" if reverse else "player"}'
            tests.append(case)

    # These attacks bypass ordinary percentage boosts. Substitute must cap
    # damage to its own remaining HP; natural immunities still block the hit.
    for move, amount, immune in (('SONICBOOM', 20, 'GENGAR'), ('DRAGON_RAGE', 40, 'CLEFABLE'),
                               ('SEISMIC_TOSS', 50, 'GENGAR'), ('NIGHT_SHADE', 50, 'SNORLAX')):
        for ability, item, route in product(('NO_ABILITY', 'HUGE_POWER', 'SHEER_FORCE'),
                                            ('NO_ITEM', 'LIFE_ORB'), ('holder', 'substitute', 'immune')):
            t = base(move)
            t['player'].update(ability=ability, item=item)
            t['setup_wram'].update(wEnemyMonHP=[1, 145], wEnemyMonMaxHP=[1, 145])  # 401
            if route == 'immune':
                t['enemy']['species'] = immune
            if route == 'substitute':
                t['setup_wram'].update(wEnemySubStatus4=16, wEnemySubstituteHP=1)
            t['assert_'] += [f'enemy.hp == {401 - amount if route == "holder" else 401}']
            loss = 'max(1, player.maxhp // 10)' if item == 'LIFE_ORB' and route != 'immune' else '0'
            t['assert_'].append(f'player.start_hp - player.hp == {loss}')
            if route == 'substitute':
                t['assert_'] += ["wram('wEnemySubstituteHP') == 0", '(enemy.substatus[3] & 16) == 0']
            add(t, 'fixed', f'{move} {ability} {item} {route}')
    for hp, route in product((1, 2, 3, 255, 256, 401), ('holder', 'substitute')):
        t = base('SUPER_FANG')
        t['setup_wram'].update(wEnemyMonHP=list(hp.to_bytes(2, 'big')), wEnemyMonMaxHP=[1, 145])
        if route == 'substitute':
            t['setup_wram'].update(wEnemySubStatus4=16, wEnemySubstituteHP=1)
        t['assert_'].append(f'enemy.hp == {hp - max(1, hp // 2) if route == "holder" else hp}')
        add(t, 'fixed', f'SUPER_FANG HP={hp} {route}')

    # Real Counter/Mirror Coat turns: recoil and draining may overwrite
    # wCurDamage before the return hit, and multi-hit uses the final hit.
    for move, counter, divisor in (('TACKLE', 'COUNTER', 1), ('DOUBLE_KICK', 'COUNTER', 2),
                                   ('TAKE_DOWN', 'COUNTER', 1), ('DRAIN_PUNCH', 'COUNTER', 1),
                                   ('WATER_GUN', 'MIRROR_COAT', 1), ('MEGA_DRAIN', 'MIRROR_COAT', 1)):
        for item, route in product(('NO_ITEM', 'LIFE_ORB'), ('holder', 'substitute')):
            t = base(move)
            t['player']['item'] = item
            t['enemy']['moves'] = [counter]
            t['setup_wram'].update(wBattleMonHP=[1, 44], wBattleMonMaxHP=[2, 88],
                                    wEnemyMonHP=[3, 232], wEnemyMonMaxHP=[3, 232])
            if route == 'substitute':
                # Lasts through the whole attack, so no qualifying direct hit.
                t['setup_wram'].update(wEnemySubStatus4=16, wEnemySubstituteHP=255)
                t['assert_'].append('enemy.hp == 1000')
                reflected = '0'
                dealt = "(255 - wram('wEnemySubstituteHP'))"
            else:
                dealt = '(1000 - enemy.hp)'
                reflected = f'2 * ({dealt} // {divisor})'
                t['assert_'].append('enemy.hp < 1000')
            recoil = f'max(1, ({dealt} * 25 + 50) // 100)' if move == 'TAKE_DOWN' else '0'
            heal = f'({dealt} + 1) // 2' if move in ('DRAIN_PUNCH', 'MEGA_DRAIN') else '0'
            orb = 60 if item == 'LIFE_ORB' else 0
            t['assert_'].append(f'player.hp == 300 - ({reflected}) - ({recoil}) + ({heal}) - {orb}')
            add(t, 'counter', f'{move}/{counter} {item} {route}')

    # Recoil/drain overkill, tiny hits, Substitute, and ability/item controls.
    for move, fraction, draining in (('TAKE_DOWN', 25, False), ('DOUBLE_EDGE', 33, False),
                                     ('HEAD_SMASH', 50, False), ('MEGA_DRAIN', 50, True),
                                     ('GIGA_DRAIN', 50, True), ('DRAIN_PUNCH', 50, True),
                                     ('BITTER_BLADE', 50, True)):
        for route, hp, ability, item in product(('holder', 'substitute'), (1, 3, 255),
                ('NO_ABILITY', 'MAGIC_GUARD', 'ROCK_HEAD'), ('NO_ITEM', 'LIFE_ORB')):
            t = base(move)
            t['player'].update(ability=ability, item=item)
            t['setup_wram'].update(wBattleMonHP=[1, 44], wBattleMonMaxHP=[2, 88],
                                    wEnemyMonHP=list(hp.to_bytes(2, 'big')), wEnemyMonMaxHP=[3, 232])
            if route == 'substitute':
                t['setup_wram'].update(wEnemySubStatus4=16, wEnemySubstituteHP=hp)
                dealt = f"({hp} - wram('wEnemySubstituteHP'))"
                t['assert_'].append(f'enemy.hp == {hp}')
            else:
                dealt = f'({hp} - enemy.hp)'
            orb = 60 if item == 'LIFE_ORB' and ability != 'MAGIC_GUARD' else 0
            if draining:
                t['assert_'].append(f'player.hp == 300 + ({dealt} + 1) // 2 - {orb}')
            else:
                recoil = f'max(1, ({dealt} * {fraction} + 50) // 100)' if ability not in ('MAGIC_GUARD', 'ROCK_HEAD') else '0'
                t['assert_'].append(f'player.hp == 300 - ({recoil}) - {orb}')
            add(t, 'recoil-drain', f'{move} HP={hp} {route} {ability} {item}')

    # Every hit can trigger Helmet + contact damage, but Orb is once per
    # completed move. Death on hit 1 must stop hit 2/3/4/5.
    for move, hits in (('TACKLE', 1), ('DOUBLE_KICK', 2), ('FURY_SWIPES', 5)):
        for defense, helmet, orb, hp, substitute in product(
                ('NO_ABILITY', 'IRON_BARBS'), (False, True), (False, True),
                (1, 600), (False, True)):
            t = base(move)
            t['player'].update(ability='SKILL_LINK', item='LIFE_ORB' if orb else 'NO_ITEM')
            t['enemy'].update(ability=defense, item='ROCKY_HELMET' if helmet else 'NO_ITEM')
            t['setup_wram'].update(wBattleMonHP=list(hp.to_bytes(2, 'big')), wBattleMonMaxHP=[2, 88],
                                    wEnemyMonHP=[3, 232], wEnemyMonMaxHP=[3, 232],
                                    wBattleMonSpeed=[3, 231], wEnemyMonSpeed=[0, 1])
            if substitute:
                t['setup_wram'].update(wEnemySubStatus4=16, wEnemySubstituteHP=1)
            chip = (75 if defense != 'NO_ABILITY' else 0) + (100 if helmet else 0)
            total_hits = min(hits, (hp + chip - 1) // chip + int(substitute)) if chip else hits
            holder_hits = total_hits - int(substitute)
            expected = max(0, hp - holder_hits * chip)
            if orb and expected:
                expected = max(0, expected - 60)
            t['assert_'] += [f'player.hp == {expected}', f"wram('wEnemyRageFistHits') == {holder_hits}"]
            add(t, 'contact', f'{move} {defense} Helmet={helmet} Orb={orb} HP={hp} sub={substitute}')

    for move, defense in product(('TACKLE', 'DOUBLE_KICK', 'FURY_SWIPES', 'TAKE_DOWN'),
                                 ('AFTERMATH', 'IRON_BARBS')):
        t = base(move)
        t['player'].update(ability='SKILL_LINK', item='LIFE_ORB')
        t['enemy'].update(ability=defense, item='ROCKY_HELMET')
        t['player2'] = dict(species='SNORLAX', level=50, ability='IMMUNITY', moves=['SPLASH'])
        t['enemy2'] = dict(species='SNORLAX', level=50, ability='IMMUNITY', moves=['SPLASH'])
        t['setup_wram'].update(wBattleMonHP=[0, 1], wEnemyMonHP=[0, 1],
                                wBattleMonSpeed=[3, 231], wEnemyMonSpeed=[0, 1])
        t['assert_'] += ["player.species == 'SNORLAX'", "enemy.species == 'SNORLAX'",
                         'player.hp == player.maxhp', 'enemy.hp == enemy.maxhp',
                         'wram16("wPartyMon1HP") == 0', 'wram16("wOTPartyMon1HP") == 0',
                         'player.pp[0] == player.start_pp[0]']
        # PP starts from the lead's Tackle, so check the replacement by its
        # party bytes instead of the snapshot's unrelated move PP.
        t['assert_'][-1] = 'player.pp[0] == wram("wPartyMon2PP")'
        add(t, 'simultaneous-ko', f'{move} {defense} both replacements')

    # Policy only activates for a surviving holder. Substitute shields it;
    # a first hit's activation cannot corrupt remaining multi-hit damage.
    for hp, route, caps in product((1, 1000), ('holder', 'substitute'), (False, True)):
        t = base('DOUBLE_KICK')
        t['enemy'].update(species='SNORLAX', item='WEAK_POLICY',
                          stages={'atk': 6, 'satk': 6} if caps else {})
        t['setup_wram'].update(wEnemyMonHP=list(hp.to_bytes(2, 'big')), wEnemyMonMaxHP=[3, 232])
        if route == 'substitute':
            t['setup_wram'].update(wEnemySubStatus4=16, wEnemySubstituteHP=255)
        activates = hp > 1 and route == 'holder'
        t['assert_'] += [f'enemy.item == "{"NO_ITEM" if activates else "WEAK_POLICY"}"',
                         f'enemy.stat_levels[0] == {13 if caps else 9 if activates else 7}',
                         f'enemy.stat_levels[3] == {13 if caps else 9 if activates else 7}']
        if activates:
            t['assert_'].append("wram('wEnemyRageFistHits') == 2")
        add(t, 'policy', f'HP={hp} {route} capped={caps}')

    for amount, route, defense in product((1, 255, 256, 65535), ('holder', 'substitute'),
                                          ('NO_ABILITY', 'ARMOR_TAIL')):
        t = base('SPLASH')
        t['player'].update(moves=['SPLASH', 'FUTURE_SIGHT'], ability='PRANKSTER')
        t['enemy'].update(species='UMBREON', ability=defense)
        t['setup_wram'].update(wPlayerFutureSightCount=2,
                                wPlayerFutureSightDamage=list(amount.to_bytes(2, 'big')),
                                wEnemyMonHP=[3, 232], wEnemyMonMaxHP=[3, 232])
        if route == 'substitute':
            t['setup_wram'].update(wEnemySubStatus4=16, wEnemySubstituteHP=1)
        t['assert_'] += [f'enemy.hp == {max(0, 1000 - amount) if route == "holder" else 1000}',
                         "wram('wPlayerFutureSightCount') == 0", 'player.pp[1] == player.start_pp[1]']
        add(t, 'delayed', f'pending Future Sight {amount} {route} {defense}')
    t = base('SPLASH')
    t['player']['moves'] = ['SPLASH', 'FUTURE_SIGHT']
    t['enemy2'] = dict(species='SNORLAX', level=50, moves=['SPLASH'])
    t['setup_wram'].update(wPlayerFutureSightCount=2, wPlayerFutureSightDamage=[3, 232], wEnemyMonHP=[0, 1])
    t['weather'] = 'hail'
    t['assert_'] += ["enemy.species == 'SNORLAX'", 'enemy.hp == enemy.maxhp',
                     "wram('wPlayerFutureSightCount') == 0"]
    add(t, 'delayed', 'weather KO expires pending strike before replacement')
    for species, defense in product(('MEW', 'UMBREON'), ('NO_ABILITY', 'ARMOR_TAIL')):
        t = base('FUTURE_SIGHT')
        t['player'].update(moves=['FUTURE_SIGHT', 'SPLASH'], ability='PRANKSTER')
        t['enemy'].update(species=species, ability=defense)
        t['setup_wram'].update(wBattleMonSpclAtk=[0, 150], wEnemyMonSpclDef=[0, 150],
                                wEnemyMonHP=[3, 232], wEnemyMonMaxHP=[3, 232])
        t['move_script'], t['turns'] = [1, 2, 2], 3
        # Independent launch formula: floor(22 * 120 * 150 / 150 / 50)+2.
        # The existing Gen-II delayed script stores this typeless damage.
        t['assert_'] += ['enemy.hp == 946', 'player.pp[0] == 14', 'player.pp[1] == 38',
                         "wram('wPlayerFutureSightCount') == 0"]
        add(t, 'delayed-launch', f'launch and impact {species} {defense}', both=False)

    # A called move pays for its caller only, even when the called slot has
    # no PP. Priority remains that of the selected action.
    for called, ability, target, item in product(
            ('TACKLE', 'HIDDEN_POWER', 'GROWL', 'SKILL_SWAP'),
            ('NO_ABILITY', 'PRANKSTER'), ('NO_ABILITY', 'NEUTRALIZING_GAS', 'ARMOR_TAIL'),
            ('NO_ITEM', 'CHOICE_BAND')):
        t = base('SLEEP_TALK')
        t['player'].update(moves=['SLEEP_TALK', called], ability=ability, item=item, status_byte=7)
        t['enemy']['ability'] = target
        t['rng'], t['rng_value'] = 'seeded', 91
        t['setup_wram'].update(wBattleMonPP=[10, 0, 0, 0], wBattleMonHiddenPowerType=2)
        blocked = ability == 'PRANKSTER' and target == 'ARMOR_TAIL'
        t['assert_'] += ['player.pp[0] == 9', 'player.pp[1] == 0']
        if called in ('TACKLE', 'HIDDEN_POWER'):
            t['assert_'].append(f'enemy.hp {"==" if blocked else "<"} enemy.start_hp')
        if called == 'GROWL':
            t['assert_'].append(f'enemy.stat_levels[0] == {7 if blocked else 6}')
        # The enemy's legal-selection path establishes a real Choice lock.
        add(t, 'called', f'Sleep Talk {called} {ability} vs {target} {item}')
    for called, ability, defense in product(('TACKLE', 'GROWL', 'SKILL_SWAP', 'HIDDEN_POWER'),
                                           ('NO_ABILITY', 'PRANKSTER'), ('NO_ABILITY', 'NEUTRALIZING_GAS', 'MAGIC_BOUNCE')):
        t = base('MIRROR_MOVE')
        # This project's Mirror Move fails if the caller already knows the
        # copied move. Allocate that ID on the target, in an exhausted slot.
        t['player'].update(ability=ability, item='CHOICE_BAND')
        t['enemy'].update(ability=defense, moves=['SPLASH', called])
        t['setup_wram'].update(wLastEnemyCounterMove={'move': called}, wBattleMonPP=[10, 0, 0, 0],
                                wEnemyMonPP=[40, 0, 0, 0],
                                wBattleMonSpeed=[3, 231], wEnemyMonSpeed=[0, 1], wBattleMonHiddenPowerType=2)
        t['assert_'] += ['player.pp[0] == 9', 'player.pp[1] == 0']
        if called == 'GROWL':
            t['assert_'].append('player.stat_levels[0] == 6' if defense == 'MAGIC_BOUNCE' else 'enemy.stat_levels[0] == 6')
        elif called in ('TACKLE', 'HIDDEN_POWER'):
            t['assert_'].append('enemy.hp < enemy.start_hp')
        add(t, 'called', f'Mirror Move {called} {ability} vs {defense}')

    # Encore arrives before a queued duplicate, then runs to expiry. Its
    # first matching slot is the established policy, including PP charging.
    for first_pp, turns in product((0, 2, 7), (1, 3, 5)):
        t = base('ENCORE')
        t['player']['moves'] = ['ENCORE', 'SPLASH']
        t['enemy']['moves'] = ['TACKLE', 'TACKLE', 'SPLASH']
        t['setup_wram'].update(wEnemyMonPP=[first_pp, 7, 40, 0],
                                wLastEnemyMove={'move': 'TACKLE'},
                                wBattleMonSpeed=[3, 231], wEnemyMonSpeed=[0, 1])
        t['turns'] = turns
        t['rng'], t['rng_value'] = 'seeded', 91
        t['move_script'] = [1] + [2] * (turns - 1)
        if first_pp:
            t['assert_'].append('player.hp < player.start_hp')
        else:
            t['assert_'].append('enemy.pp[0] == 0')
        if turns == 1 and first_pp:
            t['assert_'] += [f'enemy.pp[0] == {first_pp - 1}', 'enemy.pp[1] == 7',
                             "wram('wCurEnemyMoveNum') == 0", "wram('wEnemyEncoreCount') == 3"]
        if turns == 5:
            t['assert_'].append('(enemy.substatus[4] & 16) == 0')
        add(t, 'encore', f'queued duplicate firstPP={first_pp} turns={turns}', both=False)
    for first_pp in (0, 35):
        t = base('POUND')
        t['player']['moves'] = ['POUND', 'TACKLE', 'TACKLE']
        t['setup_wram'].update(wPlayerSubStatus5=16, wPlayerEncoreCount=3,
                                wLastPlayerMove={'move': 'TACKLE'}, wCurMoveNum=0,
                                wBattleMonPP=[first_pp, 7, 4, 0], wPartyMon1PP=[first_pp, 7, 4, 0])
        t['assert_'] += [f'player.pp == [{first_pp}, 6, 4, 0]',
                         "wram('wCurMoveNum') == 1", 'enemy.hp < enemy.start_hp']
        add(t, 'encore-reorder', f'active Encore reordered PP={first_pp}')
    for first_pp, turns in product((0, 2, 7), (1, 3, 5)):
        t = base('TACKLE')
        t['player']['moves'] = ['TACKLE', 'TACKLE', 'SPLASH']
        t['enemy']['moves'] = ['ENCORE', 'SPLASH']
        t['setup_wram'].update(wBattleMonPP=[first_pp, 7, 40, 0], wPartyMon1PP=[first_pp, 7, 40, 0],
                                wEnemyMonPP=[20, 0, 0, 0], wLastPlayerMove={'move': 'TACKLE'},
                                wBattleMonSpeed=[0, 1], wEnemyMonSpeed=[3, 231])
        # The opponent applies Encore once; later turns use Splash so they
        # cannot reapply it immediately after expiry. No execution is replaced.
        t['turn_setup_wram'] = {1: {'wEnemyMonMoves': {'move': 'SPLASH'}}}
        t['turns'], t['move_script'] = turns, [2] + [3] * (turns - 1)
        spent_first = min(first_pp, turns, 4) if first_pp else 0
        t['assert_'] += [f'player.pp[0] == {first_pp - spent_first}',
                         f'player.pp[1] == {7 if first_pp else 6}']
        if turns == 1 and first_pp:
            t['assert_'] += ["wram('wCurMoveNum') == 0", "wram('wPlayerEncoreCount') == 3"]
        if turns == 5:
            t['assert_'].append('(player.substatus[4] & 16) == 0')
        add(t, 'encore-player-target', f'queued and multi-turn firstPP={first_pp} turns={turns}', both=False)

    for move in ('SKILL_SWAP', 'TRANSFORM', 'MIMIC', 'SKETCH'):
        t = base(move)
        t['player'].update(species='SEEDOT' if move == 'SKILL_SWAP' else 'MEW')
        t['player'].pop('ability')  # use the mon's own legal ability on re-entry
        t['player2'] = dict(species='SNORLAX', level=50, moves=['SPLASH'])
        t['enemy'].update(species='MAGIKARP', moves=['SPLASH'])
        t['move_script'] = [1, 'switch:2', 'switch:1']
        t['turns'] = 3
        t['setup_wram'].update(wLastEnemyCounterMove={'move': 'SPLASH'})
        if move == 'SKETCH':
            t['assert_'] += ["player.moves[0] == 'SPLASH'"]
        else:
            t['assert_'] += [f"player.moves[0] == '{move}'"]
        t['assert_'] += [f"player.species == '{t['player']['species']}'", '(player.substatus[4] & 8) == 0',
                         'player.stats == player.start_stats',
                         "wram('wPlayerChoiceLockedMove') == 0", "wram('wPlayerGigaHammerLock') == 0"]
        if move == 'SKILL_SWAP':
            t['assert_'].append("player.ability == 'PRANKSTER'")
        else:
            t['assert_'].append("player.ability == 'SYNCHRONIZE'")
        add(t, 'switch-return', f'{move} switch out and back', both=False)

    for move in ('SOLARBEAM', 'HYPER_BEAM'):
        t = base(move)
        t['player2'] = dict(species='SNORLAX', level=50, ability='IMMUNITY', moves=['SPLASH'])
        t['enemy'].update(moves=['WHIRLWIND'], ability='NO_GUARD')
        t['enemy2'] = dict(species='MAGIKARP', level=50, moves=['SPLASH'])
        t['rng'], t['rng_value'] = 'seeded', 91
        t['setup_wram'].update(wEnemyMonHP=[3, 232], wEnemyMonMaxHP=[3, 232])
        t['assert_'] += ["player.species == 'SNORLAX'", 'player.hp == player.maxhp',
                         '(player.substatus[2] & 112) == 0', '(player.substatus[3] & 32) == 0',
                         "wram('wPlayerChoiceLockedMove') == 0", "wram('wPlayerActionMove') == 0",
                         "wram('wPlayerActionAbility') == 0"]
        add(t, 'phaze-cleanup', f'{move} charging/recharge cleared')

    t = base('SOLARBEAM')
    t['player']['item'] = 'POWER_HERB'
    t['assert_'] += ["player.item == 'NO_ITEM'", "wram('wPlayerConsumedItem') != 0",
                     "wram('wPlayerRecycleItems') != 0"]
    add(t, 'history-cleanup', 'consumed extended Power Herb')
    t = base('SPLASH')
    t['player']['item'] = 'WHITE_HERB'
    t['enemy']['moves'] = ['KNOCK_OFF']
    t['assert_'] += ["player.item == 'NO_ITEM'", "wram('wPlayerKnockedOffItems') != 0"]
    add(t, 'history-cleanup', 'extended White Herb Knock Off return', both=False)

    for item in ('CHOICE_BAND', 'METRONOME_ITEM', 'LIFE_ORB'):
        t = base('BATON_PASS')
        t['player'].update(item=item, stages={'atk': 2, 'def': -1})
        t['player2'] = dict(species='SEEDOT', level=50, moves=['SPLASH'])
        t['setup_wram'].update(wPlayerAbility={'ability': 'HUGE_POWER'}, wPlayerMetronomeCount=5,
                                wPlayerChoiceLockedMove={'move': 'BATON_PASS'})
        t['assert_'] += ["player.species == 'SEEDOT'", "player.ability == 'PRANKSTER'",
                         'player.stat_levels[0] == 9', 'player.stat_levels[1] == 6',
                         "wram('wPlayerChoiceLockedMove') == 0", "wram('wPlayerMetronomeCount') == 0",
                         '(player.substatus[4] & 24) == 0']
        add(t, 'baton-cleanup', f'{item} ability, stages and locks')
    t = base('TRANSFORM')
    t['enemy'].update(moves=['BATON_PASS'], ability='NATURAL_CURE', stages={'atk': 2, 'def': -1})
    t['player2'] = dict(species='SEEDOT', level=50, moves=['SPLASH'])
    t['move_script'], t['turns'] = [1, 1], 2
    t['assert_'] += ["player.species == 'SEEDOT'", "player.ability == 'PRANKSTER'",
                     'player.stat_levels[0] == 9', 'player.stat_levels[1] == 6',
                     '(player.substatus[4] & 8) == 0', "player.moves[0] == 'SPLASH'",
                     "wram('wPlayerChoiceLockedMove') == 0"]
    add(t, 'baton-cleanup', 'native Transform into Baton Pass restores incoming identity', both=False)
    t = base('MIMIC')
    t['player2'] = dict(species='SNORLAX', level=50, moves=['SPLASH'])
    t['move_script'] = [action for _ in range(5) for action in (1, 'switch:2', 'switch:1')]
    t['turns'] = 15
    t['assert_'] += ["player.moves[0] == 'MIMIC'", 'player.pp[0] == 5',
                     "wram('wPlayerChoiceLockedMove') == 0"]
    add(t, 'replacement-sequence', 'five Mimic copies and native switch restorations', both=False)

    t = base('MIMIC')
    t['player'].update(moves=['MIMIC', 'SKETCH', 'TACKLE'], item='MYSTERYBERRY')
    t['enemy'].update(moves=['SPLASH', 'GROWL'])
    t['player2'] = dict(species='SNORLAX', level=50, moves=['SPLASH'])
    t['setup_wram'].update(wEnemyMonPP=[40, 0, 0, 0], wBattleMonSpeed=[0, 1], wEnemyMonSpeed=[3, 231])
    t['turn_setup_wram'] = {2: {'wEnemyMonMoves': {'move': 'GROWL'}}}
    t['move_script'] = [1, 2, 2, 'switch:2', 'switch:1']
    t['turns'] = 5
    t['assert_'] += ["player.moves[0] == 'MIMIC'", "player.moves[1] == 'GROWL'",
                     "player.item == 'NO_ITEM'", 'player.pp[0] == 9', 'player.pp[1] == 40']
    add(t, 'replacement-sequence', 'Mimic duplicate, failed Sketch, PP recovery, permanent Sketch, switch', both=False)
    return tests


if __name__ == '__main__':
    import sys
    import yaml
    yaml.safe_dump(generate_battle_depth_tests(), sys.stdout, sort_keys=False)
