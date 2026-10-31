#!/usr/bin/env python3
"""Exact native Quick Powder Speed checks, including the custom Transform rule."""
from itertools import product
from pathlib import Path
import sys
from pc_harness import Harness, ROOT
from battletest.symbols import Constants


def main():
    rom = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(ROOT) / 'pokecrystal.gbc'
    h = Harness(str(rom), str(rom.with_suffix('.sym')))
    h.boot()
    con = Constants()
    h.call('InitializeItemIndexTable')
    powder = h.call('GetItemIDFromIndex', hl=con.item_id('QUICK_POWDER'))['a']
    ditto = h.species_id(con.species_index('DITTO'))
    mew = h.species_id(con.species_index('MEW'))
    checks = 0
    def wr(name, value): h.wr(h.s(name), value)
    try:
        for side, turn, transformed, original_ditto, speed, ability, foe in product(
                (0, 1), (0, 1), (False, True), (False, True),
                (1, 17, 100, 255, 256, 999, 32768, 65535),
                ('NO_ABILITY', 'KLUTZ'), ('NO_ABILITY', 'NEUTRALIZING_GAS')):
            wr('wPartyCount', 1)
            wr('wCurBattleMon', 0)
            wr('wCurOTMon', 0)
            wr('wPartyMon1Species', ditto if original_ditto else mew)
            wr('wTempEnemyMonSpecies', ditto if original_ditto else mew)
            wr('wBattleWeather', 0)
            for index, (prefix, who) in enumerate((('wBattleMon','wPlayer'),('wEnemyMon','wEnemy'))):
                wr(prefix+'Species', mew if transformed else ditto if original_ditto else mew)
                wr(prefix+'HP', [0, 100])
                wr(prefix+'Speed', (speed if index == side else 80).to_bytes(2,'big'))
                wr(prefix+'Status', 0)
                wr(prefix+'Item', powder if index == side else 0)
                wr(who+'Ability', con.ability_id(ability if index == side else foe))
                wr(who+'SubStatus5', 8 if transformed else 0)
            wr('hBattleTurn', turn)
            result = h.call('GetBattleEffectiveSpeeds')
            active = original_ditto and (ability != 'KLUTZ' or foe == 'NEUTRALIZING_GAS')
            expected = min(65535, 2 * speed) if active else speed
            assert result['hl' if side == 0 else 'de'] == expected, (side,turn,transformed,original_ditto,speed,ability,foe,result,expected)
            assert result['de' if side == 0 else 'hl'] == 80
            assert h.rd(h.s('hBattleTurn')) == turn, 'turn leaked'
            checks += 1
    finally:
        h.pyboy.stop(save=False)
    print(f'QUICK POWDER: {checks} exact Speed checks passed in {rom.name}')


if __name__ == '__main__':
    main()
