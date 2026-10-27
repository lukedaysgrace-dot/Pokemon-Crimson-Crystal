#!/usr/bin/env python3
"""Gen 1 Mimic through the retail battle menus (button input, no auto moves).

The player picks Mimic, then picks one of the foe's moves from the foe-move
menu. The copied move must replace Mimic, keep Mimic's PP and charge both PP
copies when used.
"""
from pathlib import Path

from runner import Harness, snapshot_side
from state import Request
from ui_checks import tile_text, wait


def main():
    h = Harness()
    h.ensure_fixture()
    out = Path('.tmpbuild/mimic-gen1-ui')
    out.mkdir(parents=True, exist_ok=True)
    m = h.battle.mem
    try:
        h.load_fixture()
        m.write('wOptions', 0x40)
        Request(h.battle).write({
            'player': {'species': 'MEW', 'level': 50, 'moves': ['MIMIC', 'SPLASH']},
            'enemy': {'species': 'SNORLAX', 'level': 100, 'moves': ['SPLASH', 'REST', 'AMNESIA', 'HARDEN']},
            'rng': 'forced_low', 'turns': 2})
        m.write('wDebugBattleFlags', 0)
        wait(h, lambda: 'FIGHT' in tile_text(h), advance=True)
        start = snapshot_side(h.battle.player)
        assert start['moves'][0] == 'MIMIC', start

        # FIGHT -> Mimic
        h.press('a', hold=8, wait=80)
        wait(h, lambda: 'MIMIC' in tile_text(h))
        h.press('a', hold=8, wait=20)
        # The foe's moves are listed for the player to choose from.
        wait(h, lambda: all(n in tile_text(h) for n in ('REST', 'AMNESIA', 'HARDEN')))
        h.pb.screen.image.resize((640, 576)).save(out / 'foe-move-menu.png')
        print('MENU\n' + tile_text(h), flush=True)
        h.press('down', hold=8, wait=20)
        h.press('down', hold=8, wait=20)
        h.press('a', hold=8, wait=20)
        wait(h, lambda: 'FIGHT' in tile_text(h), advance=True)
        h.pb.screen.image.resize((640, 576)).save(out / 'after-mimic.png')
        p = h.battle.player
        assert p.moves[0] == 'AMNESIA', p.moves
        assert p.pp[0] == start['pp'][0] - 1, (p.pp, start['pp'])
        assert m.read('wPartyMon1PP') & 63 == start['pp'][0] - 1
        print('PASS chose AMNESIA from the foe-move menu; Mimic PP kept', flush=True)

        # Use the copied move: it spends Mimic's PP in battle and party copies.
        h.press('a', hold=8, wait=80)
        wait(h, lambda: 'AMNESIA' in tile_text(h))
        h.press('a', hold=8, wait=20)
        wait(h, lambda: h.battle.player.pp[0] == start['pp'][0] - 2 and 'FIGHT' in tile_text(h), advance=True)
        assert p.stat_levels[4] == 9, p.stat_levels
        assert m.read('wPartyMon1PP') & 63 == start['pp'][0] - 2
        assert p.moves[0] == 'AMNESIA'
        print('PASS copied move used through the menu and drew from Mimic PP', flush=True)
    finally:
        h.pb.stop(save=False)


if __name__ == '__main__':
    main()
