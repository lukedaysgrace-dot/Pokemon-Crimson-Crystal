#!/usr/bin/env python3
"""Observe Conversion2's smart scoring during ordinary native AI turns."""
from runner import Harness, FRAME_CEILING_BATTLE
from symbols import STATE_WAIT, STATE_DONE, STATE_ERROR


def resume(h, turn):
    memory = h.battle.mem
    memory.write('wDebugTurnTarget', turn)
    memory.write('wDebugControl', 1)
    for _ in range(0, FRAME_CEILING_BATTLE, 4):
        state = h.state()
        if state in (STATE_DONE, STATE_ERROR) or (state == STATE_WAIT and h.battle.turns_done >= turn):
            return state
        h.pb.button('a', 2)
        h.tick(4)
    raise RuntimeError('native AI battle timed out')


def main():
    h = Harness(render=False, instant_text=True)
    h.ensure_fixture()
    observations = []
    start = h.sym.addr('AI_Smart_Conversion2')
    end = h.sym.addr('AI_Smart_Disable')

    def scoring_coin(_context):
        # This is an observation hook, never a direct call or register edit.
        registers = h.pb.register_file
        stack = registers.SP
        return_address = h.pb.memory[stack] | h.pb.memory[stack + 1] << 8
        if start <= return_address < end:
            memory = h.battle.mem
            observations.append((memory.read('wPlayerMoveStructType'), memory.read('wTypeMatchup'),
                                 memory.read('hBattleTurn')))

    hook = h.sym['AI_50_50']
    h.pb.hook_register(*hook, scoring_coin, None)
    cases = [('HIDDEN_POWER', 'NO_ABILITY', 'GYARADOS', 23, 'none'),
             ('HIDDEN_POWER', 'NO_ABILITY', 'QUAGSIRE', 22, 'none'),
             ('WEATHER_BALL', 'NO_ABILITY', 'SCIZOR', 20, 'sun'),
             ('TACKLE', 'GALVANIZE', 'GYARADOS', 23, 'none')]
    try:
        for move, ability, species, kind, weather in cases:
            h.load_fixture()
            observations.clear()
            test = {
                'player': dict(species='ELECTRODE', level=30, ability=ability,
                               substatus=['CANT_RUN'], moves=[move, 'SPLASH']),
                'enemy': dict(species=species, level=100, ability='NO_ABILITY', status_byte=3,
                              substatus=['CANT_RUN'], moves=['CONVERSION2', 'SPLASH']),
                'enemy2': dict(species='PIDGEY', level=100, moves=['SPLASH']),
                'enemy_class': 'FALKNER', 'weather': weather,
                'rng': 'seeded', 'rng_value': 91, 'turns': 0, 'move_script': [1, 2],
            }
            assert h.run_battle(test) == STATE_WAIT
            memory = h.battle.mem
            memory.write('wBattleMonHiddenPowerType', kind)
            assert resume(h, 1) == STATE_WAIT
            assert memory.read('wPlayerLastMoveType') == kind
            memory.write('wEnemyMonStatus', 0)
            assert resume(h, 2) == STATE_WAIT
            assert (kind, 40, 0) in observations, (move, ability, species, observations)
            print(f'PASS native AI Conversion2: {move}/{ability} against {species}: historical type {kind}, 4x matchup')
        print(f'AI DYNAMIC TYPES: {len(cases)} native two-turn scoring checks passed')
    finally:
        h.pb.hook_deregister(*hook)
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
