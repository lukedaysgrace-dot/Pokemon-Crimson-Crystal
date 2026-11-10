#!/usr/bin/env python3
"""Play native Metronome calls with explicit RNG bytes, never injected moves."""
import argparse
from pathlib import Path

from runner import Harness, FRAME_CEILING_BATTLE, snapshot_side
from symbols import STATE_WAIT, STATE_DONE, STATE_ERROR


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path)
    args = parser.parse_args()
    h = Harness(render=False, rom_path=args.rom)
    h.ensure_fixture()
    requested = 0
    random_sites_seen = set()
    observed = []
    reverse = False

    bank, address = h.sym['ChooseRandomMove']
    code = bytes(h.pb.memory[bank, address:address + 80])
    random_address = h.sym.addr('BattleRandom')
    call = bytes((0xcd, random_address & 255, random_address >> 8))
    sites = [address + offset + 3 for offset in range(len(code) - 2)
             if code[offset:offset + 3] == call][:2]
    assert len(sites) == 2, 'could not identify native high/low RNG call sites'

    def random_byte(_context):
        # An interrupt can fire a hook twice at the same instruction. Select
        # each forced RNG byte by its native return address, so duplicate
        # observations cannot consume the next byte. The game still masks,
        # validates and allocates the called move itself.
        stack = h.pb.register_file.SP
        return_address = h.pb.memory[stack] | h.pb.memory[stack + 1] << 8
        value = 180
        if return_address in sites:
            part = sites.index(return_address)
            random_sites_seen.add(part)
            value = requested & 255 if part else requested >> 8
        h.battle.mem.write('hDebugRNGValue', value)

    def used_move(_context):
        if h.battle.mem.read('hBattleTurn') == int(reverse):
            observed.append(h.battle.mem.move_index_of(h.battle.mem.read(
                'wEnemyMoveStruct' if reverse else 'wPlayerMoveStruct')))

    hooks = [('BattleRandom', random_byte), ('BattleCommand_DoTurn', used_move)]
    for label, callback in hooks:
        h.pb.hook_register(*h.sym[label], callback, None)
    cases = [
        ('EXPLOSION', 'PRANKSTER', 'QUEENLY_MAJESTY', False, True),
        ('EXPLOSION', 'NO_ABILITY', 'QUEENLY_MAJESTY', False, False),
        ('FLY', 'PRANKSTER', 'QUEENLY_MAJESTY', False, True),
        ('FLY', 'GALE_WINGS', 'QUEENLY_MAJESTY', False, False),
        ('QUICK_ATTACK', 'NO_ABILITY', 'QUEENLY_MAJESTY', False, False),
        ('QUICK_ATTACK', 'PRANKSTER', 'ARMOR_TAIL', False, True),
        ('MEGA_DRAIN', 'TRIAGE', 'QUEENLY_MAJESTY', False, False),
        ('PECK', 'GALE_WINGS', 'QUEENLY_MAJESTY', False, False),
        ('PSYCH_UP', 'PRANKSTER', 'NO_ABILITY', True, True),
        ('PSYCH_UP', 'NO_ABILITY', 'NO_ABILITY', True, False),
        ('PERISH_SONG', 'PRANKSTER', 'QUEENLY_MAJESTY', False, True),
        ('PERISH_SONG', 'PRANKSTER', 'NO_ABILITY', True, False),
    ]
    try:
        for reverse, (move, source, defense, dark, blocked) in (
                (reverse, case) for reverse in (False, True) for case in cases):
            h.load_fixture()
            random_sites_seen.clear()
            observed.clear()
            requested = h.con.move_index(move)
            actor, target = ('enemy', 'player') if reverse else ('player', 'enemy')
            test = {
                actor: dict(species='MEW', level=50, ability=source, moves=['METRONOME'],
                               hp=50 if move == 'MEGA_DRAIN' else 100),
                'player2': dict(species='MEW', level=50, moves=['SPLASH']),
                'enemy2': dict(species='MEW', level=50, moves=['SPLASH']),
                target: dict(species='UMBREON' if dark else 'MEW', level=100, ability=defense,
                              moves=['SPLASH'], stages={'atk': 2} if move == 'PSYCH_UP' else {}),
                'enemy_class': 'FALKNER', 'rng': 'forced_high', 'turns': 0,
            }
            assert h.run_battle(test) == STATE_WAIT
            before = dict(player=snapshot_side(h.battle.player), enemy=snapshot_side(h.battle.enemy))
            memory = h.battle.mem
            memory.write('wDebugTurnTarget', 1)
            memory.write('wDebugControl', 1)
            for _ in range(0, FRAME_CEILING_BATTLE, 4):
                state = h.state()
                if state in (STATE_DONE, STATE_ERROR) or (state == STATE_WAIT and h.battle.turns_done >= 1):
                    break
                h.pb.button('a', 2)
                h.tick(4)
            else:
                raise RuntimeError('Metronome battle timed out')
            assert state == STATE_WAIT, (move, state)
            assert requested in observed and random_sites_seen == {0, 1}, (move, observed, random_sites_seen)
            party = 'wOTPartyMon1' if reverse else 'wPartyMon1'
            assert memory.read(party + 'PP') & 63 == 9, move
            user = h.battle.enemy if reverse else h.battle.player
            opponent = h.battle.player if reverse else h.battle.enemy
            if move == 'EXPLOSION':
                assert (memory.read_u16_be(party + 'HP') > 0) == blocked, (move, source)
            if move == 'FLY':
                assert bool(user.substatus[2] & 64) != blocked, (move, source)
            elif move == 'PSYCH_UP':
                assert user.stat_levels[0] == (7 if blocked else 9), (move, source)
            elif move == 'PERISH_SONG':
                for side in ('Player', 'Enemy'):
                    assert memory.read(f'w{side}PerishCount') == (0 if blocked else 3), (move, source)
            else:
                assert (opponent.hp == before[target]['hp']) == blocked, (move, source, opponent.hp)
            if move == 'MEGA_DRAIN':
                assert user.hp > before[actor]['hp']
            print(f'PASS native Metronome: {actor} {source} calls {move} versus {defense}{" Dark" if dark else ""}')
        print(f'METRONOME PRIORITY: {len(cases) * 2} native called-move checks passed on both sides')
    finally:
        for label, _ in hooks:
            h.pb.hook_deregister(*h.sym[label])
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
