#!/usr/bin/env python3
"""Exercise HUD visibility through actual move/menu transitions on CGB.

Inspect both WRAM buffers and the two hardware BG-map banks, including every
type-cell cleanup and the faint text checkpoint. No graphics routines are
substituted. Run after `make debug`: python3 tools/battletest/type_icon_checks.py
"""

from pathlib import Path

from runner import Harness
from state import Request
from ui_checks import tile_text


OUTPUT = Path('.venv/type-icon-checks')
CELLS = {'enemy': (2, 1, 0x60, [13, 13], 2),
         'player': (10, 8, 0x62, [13, 12], 3)}


def read_cells(h, side):
    x, y, *_ = CELLS[side]
    bg = 0x9800 + y * 32 + x
    return dict(tiles=list(h.battle.mem.read_bytes('wTileMap', 2, y * 20 + x)),
                attrs=list(h.battle.mem.read_bytes('wAttrMap', 2, y * 20 + x)),
                vram_tiles=[h.pb.memory[0, bg + i] for i in range(2)],
                vram_attrs=[h.pb.memory[1, bg + i] for i in range(2)])


def hidden_errors(h, side):
    actual = read_cells(h, side)
    palette = CELLS[side][-1]
    expected = dict(tiles=[127, 127], attrs=[palette, palette],
                    vram_tiles=[127, 127], vram_attrs=[palette, palette])
    return [] if actual == expected else [f'{side} hidden: {actual} != {expected}']


def active_errors(h):
    errors = []
    for side in ('enemy', 'player'):
        _, _, first, attrs, _ = CELLS[side]
        expected = dict(tiles=[first, first + 1], attrs=attrs,
                        vram_tiles=[first, first + 1], vram_attrs=attrs)
        actual = read_cells(h, side)
        if actual != expected:
            errors.append(f'{side} active: {actual} != {expected}')
        p = 'wEnemyMon' if side == 'enemy' else 'wBattleMon'
        if h.battle.mem.read(p + 'Type1') == h.battle.mem.read(p + 'Type2'):
            address = 0x9000 + (first + 1) * 16
            if any(h.pb.memory[1, address + i] for i in range(16)):
                errors.append(f'{side} single-type secondary art is not blank')
    return errors


def mon(species, move='SPLASH', level=50, **extra):
    return dict(species=species, level=level, moves=[move], ability='NO_ABILITY') | extra


def cases():
    base = dict(player=mon('FERALIGATR'), player2=mon('PORYGON'),
                enemy=mon('HOUNDOOM', level=30), enemy2=mon('PORYGON', level=30),
                rng='seeded', turns=10)
    for disabled in (False, True):
        suffix = ' animations off' if disabled else ''
        yield 'player switch dual to single and back' + suffix, base, 'switch', disabled
        yield 'enemy knockout and single-type replacement' + suffix, {
            **base, 'player': mon('FERALIGATR', 'WATERFALL'),
            'enemy': mon('HOUNDOOM', level=20, hp=1), 'rng': 'forced_low'}, 'enemy_ko', disabled
        yield 'player knockout and single-type replacement' + suffix, {
            **base, 'player': mon('FERALIGATR', hp=1),
            'enemy': mon('HOUNDOOM', 'THUNDERBOLT', level=100)}, 'player_ko', disabled
    for move, species in [('U_TURN', 'FERALIGATR'), ('VOLT_SWITCH', 'AMPHAROS'),
                          ('BATON_PASS', 'FERALIGATR')]:
        yield 'player ' + move, {**base, 'player': mon(species, move)}, 'player_pivot', False
    for move in ('U_TURN', 'VOLT_SWITCH', 'BATON_PASS'):
        yield 'enemy ' + move, {**base, 'enemy': mon('HOUNDOOM', move)}, 'enemy_pivot', False
    yield 'forced player switch by ROAR', {**base, 'enemy': mon('HOUNDOOM', 'ROAR')}, 'player_pivot', False
    yield 'forced enemy switch by ROAR', {**base, 'player': mon('FERALIGATR', 'ROAR')}, 'enemy_pivot', False
    yield 'Pursuit knockout during player switch', {
        **base, 'player': mon('FERALIGATR', hp=1),
        'enemy': mon('HOUNDOOM', 'PURSUIT', level=100)}, 'pursuit', False
    yield 'player poison knockout', {**base, 'player': mon('FERALIGATR', hp=1, status_byte=8)}, 'player_ko', False
    yield 'enemy poison knockout', {**base, 'enemy': mon('HOUNDOOM', hp=1, status_byte=8)}, 'enemy_ko', False
    yield 'simultaneous poison knockouts', {
        **base, 'player': mon('FERALIGATR', hp=1, status_byte=8),
        'enemy': mon('HOUNDOOM', hp=1, status_byte=8)}, 'double_ko', False
    yield 'player COSMIC_POWER hides both HUDs', {
        **base, 'player': mon('FERALIGATR', 'COSMIC_POWER')}, 'animation', False
    yield 'enemy COSMIC_POWER hides both HUDs', {
        **base, 'enemy': mon('HOUNDOOM', 'COSMIC_POWER')}, 'animation', False


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    h = Harness()
    h.ensure_fixture()
    failures = []
    counts = []
    try:
        for index, (name, request, action, disabled) in enumerate(cases(), 1):
            h.load_fixture()
            m = h.battle.mem
            m.write('wOptions', 0x41 | (0x80 if disabled else 0))
            Request(h.battle).write(request)
            m.write('wDebugBattleFlags', 0)
            errors, clears, faints = [], [], []
            pending = []
            hooks = []

            def install(symbol, callback):
                bank, address = h.sym[symbol]
                h.pb.hook_register(bank, address, callback, None)
                hooks.append((bank, address))

            def clear_begin(_):
                pending.append('player' if h.pb.register_file.A == 0 else 'enemy')

            def far_return(_):
                if pending:
                    side = pending.pop()
                    clears.append(side)
                    errors.extend(hidden_errors(h, side))

            def faint_text(_):
                for side, symbol in [('player', 'BattleText_MonFainted'),
                                     ('enemy', 'BattleText_EnemyMonFainted')]:
                    if h.pb.register_file.HL == h.sym.addr(symbol):
                        faints.append(side)
                        errors.extend(hidden_errors(h, side))

            install('ClearBattleTypeIconCellsForSide', clear_begin)
            install('ReturnFarCall', far_return)
            install('StdBattleTextbox', faint_text)

            def menu():
                t = tile_text(h)
                return 'FIGHT' in t and 'PACK' in t and 'RUN' in t

            def advance_until(predicate, limit=12000):
                for frame in range(0, limit, 4):
                    if predicate():
                        h.tick(60)
                        return
                    current_text = tile_text(h)
                    if 'PORYGON' in current_text and 'CANCEL' in current_text:
                        # Actual post-faint/pivot party menu; pick a living
                        # replacement with buttons instead of re-selecting the
                        # first (possibly fainted) party member indefinitely.
                        current_slot = m.read('wCurBattleMon') + 1
                        eligible = [slot for slot in (1, 2) if slot != current_slot
                                    and m.read_u16_be(f'wPartyMon{slot}HP')]
                        if eligible:
                            target = eligible[0]
                            for _ in range(6):
                                cursor = m.read('wMenuCursorY')
                                if cursor == target:
                                    break
                                h.press('down' if cursor < target else 'up', hold=4, wait=18)
                            h.press('a', hold=4, wait=40)
                            if 'SWITCH' in tile_text(h) and 'STATS' in tile_text(h):
                                h.press('a', hold=4, wait=24)
                            continue
                    if frame % 24 == 0:
                        h.pb.button('a', 2)
                    h.tick(4)
                raise RuntimeError('transition timeout: ' + tile_text(h))

            def choose_move():
                if m.read('wMenuCursorY') != 1:
                    h.press('up', hold=4, wait=16)
                if m.read('wMenuCursorX') != 1:
                    h.press('left', hold=4, wait=16)
                h.press('a', hold=4, wait=60)
                h.press('a', hold=4, wait=24)

            def switch_to(slot):
                if m.read('wMenuCursorY') != 1:
                    h.press('up', hold=4, wait=16)
                if m.read('wMenuCursorX') != 2:
                    h.press('right', hold=4, wait=16)
                h.press('a', hold=4, wait=80)
                for _ in range(6):
                    y = m.read('wMenuCursorY')
                    if y == slot:
                        break
                    h.press('down' if y < slot else 'up', hold=4, wait=18)
                h.press('a', hold=4, wait=50)
                if 'SWITCH' in tile_text(h) and 'STATS' in tile_text(h):
                    h.press('a', hold=4, wait=24)

            try:
                advance_until(menu)
                errors.extend(active_errors(h))
                player, enemy = h.battle.player.species, h.battle.enemy.species
                if action in ('switch', 'pursuit'):
                    switch_to(2)
                    advance_until(lambda: h.battle.player.species == 'PORYGON' and menu())
                    errors.extend(active_errors(h))
                    if action == 'switch':
                        switch_to(1)
                        advance_until(lambda: h.battle.player.species == player and menu())
                        errors.extend(active_errors(h))
                else:
                    choose_move()
                    if action in ('player_ko', 'player_pivot'):
                        advance_until(lambda: h.battle.player.species != player and menu())
                    elif action in ('enemy_ko', 'enemy_pivot'):
                        advance_until(lambda: h.battle.enemy.species != enemy and menu())
                    elif action == 'double_ko':
                        advance_until(lambda: h.battle.player.species != player and h.battle.enemy.species != enemy and menu())
                    else:
                        advance_until(lambda: len(clears) >= 2 and menu())
                    errors.extend(active_errors(h))
                if not clears:
                    errors.append('No HUD cleanup was exercised')
                if action in ('enemy_ko', 'double_ko') and 'enemy' not in faints:
                    errors.append('Enemy faint checkpoint was not reached')
                if action in ('player_ko', 'double_ko', 'pursuit') and 'player' not in faints:
                    errors.append('Player faint checkpoint was not reached')
            except Exception as exc:
                errors.append(str(exc))
            finally:
                for bank, address in reversed(hooks):
                    h.pb.hook_deregister(bank, address)
            h.pb.screen.image.save(str(OUTPUT / f'{index:02d}.png'))
            counts.append((name, len(clears), len(faints)))
            if errors:
                failures.append((name, errors))
                print(f'FAIL {name}: {errors[:5]}', flush=True)
            else:
                print(f'PASS {name}: {len(clears)} clears, {len(faints)} faints', flush=True)
    finally:
        h.pb.stop(save=False)
    print(f'{len(counts)} transition scenarios; {sum(row[1] for row in counts)} HUD clears; '
          f'{sum(row[2] for row in counts)} faints; {len(failures)} failures', flush=True)
    return int(bool(failures))


if __name__ == '__main__':
    raise SystemExit(main())
