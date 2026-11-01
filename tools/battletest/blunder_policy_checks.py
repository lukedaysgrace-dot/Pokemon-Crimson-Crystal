#!/usr/bin/env python3
"""Verify Blunder Policy's first/later-kick exception in the ROM accuracy check."""

from runner import Harness
from probability_checks import call
from symbols import STATE_WAIT


def main():
    h = Harness(render=False)
    h.ensure_fixture()
    checks = 0
    try:
        for move in ('TRIPLE_KICK', 'TRIPLE_AXEL'):
            h.load_fixture()
            spec = dict(species='MEW', level=50, ability='NO_ABILITY',
                        moves=[move], item='BLUNDER_POLICY')
            assert h.run_battle(dict(player=spec, enemy=spec, turns=0,
                                     rng='forced_low')) == STATE_WAIT
            memory = h.battle.mem
            for side, moves, current in ((0, 'wBattleMonMoves', 'wCurPlayerMove'),
                                         (1, 'wEnemyMonMoves', 'wCurEnemyMove')):
                memory.write('hBattleTurn', side)
                memory.write(current, memory.read(moves))
                call(h, 'UpdateMoveData')
                for kick in (0, 1, 2):
                    memory.write('wKickCounter', kick)
                    memory.write('wAttackMissed', 0)
                    memory.write('wBlunderPolicyPending', 0)
                    memory.write('wTypeModifier', 16)
                    memory.write('hDebugRNGMode', 1)
                    # Above this game's 95% Triple Kick and 90% Triple Axel.
                    memory.write('hDebugRNGValue', 244)
                    call(h, 'BattleCommand_CheckHit')
                    assert memory.read('wAttackMissed') == 1
                    assert memory.read('wBlunderPolicyPending') == (kick == 0), (move, side, kick)
                    checks += 1
                    print(f'PASS {move}, side {side}, kick {kick + 1}: miss eligibility')
    finally:
        h.pb.stop(save=False)
    print(f'{checks} native Blunder Policy accuracy checks passed')


if __name__ == '__main__':
    main()
