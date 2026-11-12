#!/usr/bin/env python3
"""Natively walk through the five Elite Four chambers and capture them.

For every chamber this checks, on the compiled ROM:
  * the map uses its dedicated tileset and loads that tileset's palettes;
  * the native entry scene walks the player in and seals the entrance;
  * the trainer stands at the preserved position and the walkable route to
    the trainer and the exit door exists;
  * the opened exit door warps to the next chamber (Lance: Hall of Fame).
Screenshots of each chamber's lower and upper halves (gate open/closed and
exit closed/open) are written to the output folder. Only private emulator
state is used; no player save is read or written.
"""
import argparse
import json
from pathlib import Path
import re
import sys

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from gameplay_rules_checks import new_game
from trainer_sprite_checks import native_call
from save_menu_checks import begin_native_call
from safari_ui_checks import map_ids
from overworld_controls import Controls
from symbols import _parse_constants

ROOMS = [
    # map, tileset, prefix, trainer (x, y), height, next map, gate y, door y
    ('KOGAS_ROOM', 'TILESET_KOGAS_ROOM', 'KOGAS', (5, 7), 18, 'BRUNOS_ROOM', 14, 2),
    ('BRUNOS_ROOM', 'TILESET_BRUNOS_ROOM', 'BRUNOS', (5, 7), 18, 'KARENS_ROOM', 14, 2),
    ('KARENS_ROOM', 'TILESET_KARENS_ROOM', 'KARENS', (5, 7), 18, 'LORELEIS_ROOM', 14, 2),
    ('LORELEIS_ROOM', 'TILESET_LORELEIS_ROOM', 'LORELEIS', (5, 7), 18, 'LANCES_ROOM', 14, 2),
    ('LANCES_ROOM', 'TILESET_LANCES_ROOM', 'LANCES', (5, 3), 24, 'HALL_OF_FAME', 22, 1),
]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
    parser.add_argument('--output', type=Path, default=ROOT / '_artifacts/league-rooms')
    args = parser.parse_args()
    out = args.output
    out.mkdir(parents=True, exist_ok=True)
    h = Harness(rom_path=args.rom)
    pb, m, controls = h.pb, h.battle.mem, Controls(h)
    maps = map_ids()
    flags = _parse_constants(ROOT / 'constants/event_flags.asm')
    tilesets = _parse_constants(ROOT / 'constants/tileset_constants.asm')
    checks = []

    def check(ok, label):
        if not ok:
            pb.screen.image.save(out / 'failure.png')
            raise AssertionError(label)
        checks.append(label)
        print('PASS', label, flush=True)

    def set_event(name, value):
        bit = flags[name]
        addr = h.sym.addr('wEventFlags') + bit // 8
        if value:
            pb.memory[addr] |= 1 << (bit % 8)
        else:
            pb.memory[addr] &= ~(1 << (bit % 8)) & 0xff

    def event(name):
        bit = flags[name]
        return bool(pb.memory[h.sym.addr('wEventFlags') + bit // 8] & (1 << (bit % 8)))

    def enter(name, x, y, scene):
        group, number = maps[name]
        m.write(f'w{camel(name)}SceneID', scene)
        for key, value in dict(wDefaultSpawnpoint=255, wMapGroup=group, wMapNumber=number,
                               wXCoord=x, wYCoord=y, hMapEntryMethod=0xf1).items():
            m.write(key, value)
        native_call(h, 'EnterMap')
        begin_native_call(h, 'OverworldLoop.loop')

    def camel(name):
        return ''.join(part.capitalize() for part in name.split('_'))

    def bg_palettes():
        return list(m.read_bytes('wBGPals1', 64))

    def authored_palettes(prefix):
        text = (ROOT / f'gfx/tilesets/{prefix.lower()}_room.pal').read_text()
        out_ = []
        for line in text.splitlines():
            nums = [int(v) for v in re.findall(r'\d+', line.split(';')[0])]
            for i in range(0, len(nums), 3):
                r, g, b = nums[i:i + 3]
                v = r | g << 5 | b << 10
                out_ += [v & 255, v >> 8]
        return out_

    def shot(label):
        pb.screen.image.convert('RGB').resize((320, 288), Image.Resampling.NEAREST).save(out / f'{label}.png')

    print('Booting private ROM:', args.rom, flush=True)
    new_game(h, 0)
    summary = {}
    for name, tileset, prefix, trainer, height, following, gate_y, door_y in ROOMS:
        set_event(f'EVENT_{prefix}_ROOM_ENTRANCE_CLOSED', False)
        set_event(f'EVENT_{prefix}_ROOM_EXIT_OPEN', False)
        # 1. gate still open: stand just inside without running the entry scene
        enter(name, 4, gate_y - 1, 1)
        h.tick(80)
        check(controls.map_id() == maps[name], f'{name}: loads')
        check(m.read('wMapTileset') == tilesets[tileset], f'{name}: uses {tileset}')
        pals = bg_palettes()
        want = authored_palettes(prefix)
        check(pals[:56] == want[:56], f'{name}: dedicated background palettes 0-6 loaded')
        check(controls.collision(4, gate_y) == 0 and controls.collision(5, gate_y) == 0,
              f'{name}: entrance gate starts open')
        shot(f'{prefix.lower()}_1_entrance_open')
        # 2. native entry scene from the lower warp
        enter(name, 4, height - 1, 0)
        under_lintel = False
        walk_in = []
        for _ in range(240):
            h.tick(2)
            if controls.position()[1] > height - 5 and len(walk_in) < 120:
                walk_in.append(pb.screen.image.convert('RGB'))
            if not under_lintel and controls.position()[1] == gate_y:
                under_lintel = True
            if event(f'EVENT_{prefix}_ROOM_ENTRANCE_CLOSED') and not m.read('wScriptMode'):
                break
        check(under_lintel, f'{name}: player walks in under the doorway lintel')
        # the walk through the doorway: the lintel tiles carry BG priority,
        # so the sprite passes underneath them
        walk_in[0].save(out / f'{prefix.lower()}_walk_in.gif', save_all=True,
                        append_images=walk_in[1::2], duration=60, loop=0)
        strip = walk_in[len(walk_in) // 2] if walk_in else None
        if strip is not None:
            strip.resize((320, 288), Image.Resampling.NEAREST).save(out / f'{prefix.lower()}_0_through_doorway.png')
        h.tick(60)
        check(controls.position() == (4, height - 5), f'{name}: entry scene walks the player in')
        check(event(f'EVENT_{prefix}_ROOM_ENTRANCE_CLOSED'), f'{name}: entrance seals behind the player')
        check(controls.collision(4, gate_y) == 0x07 and controls.collision(5, gate_y) == 0x07,
              f'{name}: sealed gate block is solid')
        shot(f'{prefix.lower()}_2_entrance_sealed')
        # 3. walk to the spot in front of the trainer (no battle is started)
        if name != 'LANCES_ROOM':
            controls.go((trainer[0], trainer[1] + 1))
            check(controls.position() == (trainer[0], trainer[1] + 1), f'{name}: trainer reachable')
            check(any(tuple(o['position']) == trainer for o in controls.objects()),
                  f'{name}: trainer stands at {trainer}')
            controls.go((4, door_y + 2))
            check(controls.position() == (4, door_y + 2), f'{name}: walkway to the exit door')
            shot(f'{prefix.lower()}_3_exit_closed')
            check(controls.collision(4, door_y) == 0x07, f'{name}: exit sealed before the battle')
        else:
            # Lance's coord triggers start the battle; stage the top view instead
            enter(name, 4, 4, 1)
            h.tick(80)
            check(any(tuple(o['position']) == trainer for o in controls.objects()),
                  f'{name}: trainer stands at {trainer}')
            shot(f'{prefix.lower()}_3_exit_closed')
            check(controls.collision(4, door_y) == 0x07, f'{name}: exit sealed before the battle')
        # 4. exit opened (as after the battle): re-enter just below the door
        set_event(f'EVENT_{prefix}_ROOM_EXIT_OPEN', True)
        enter(name, 4, door_y + 2 if name != 'LANCES_ROOM' else door_y + 3, 1)
        h.tick(80)
        check(controls.collision(4, door_y) >> 4 == 7 and controls.collision(5, door_y) >> 4 == 7,
              f'{name}: opened exit is a warp')
        shot(f'{prefix.lower()}_4_exit_open')
        # palette-cycling ambience: the picture must change while standing still
        frames = []
        for _ in range(64):
            frames.append(pb.screen.image.convert('RGB').resize((320, 288), Image.Resampling.NEAREST))
            h.tick(6)
        if name == 'LORELEIS_ROOM':
            # the frozen palace is deliberately still (no shimmer)
            check(len({f.tobytes() for f in frames}) == 1, f'{name}: no ambient animation')
        else:
            check(len({f.tobytes() for f in frames}) > 1, f'{name}: ambient animation runs')
        frames[0].save(out / f'{prefix.lower()}_ambience.gif', save_all=True, append_images=frames[1:],
                       duration=100, loop=0)
        controls.go((4, door_y))
        h.tick(120)
        check(controls.map_id() == maps[following], f'{name}: exit door leads to {following}')
        summary[name] = 'ok'
    # mosaic of every capture
    tiles = sorted(out.glob('*_[0-4]_*.png'))
    if tiles:
        cols = 4
        rows = (len(tiles) + cols - 1) // cols
        sheet = Image.new('RGB', (cols * 330, rows * 298), (24, 24, 24))
        for i, path in enumerate(tiles):
            sheet.paste(Image.open(path), ((i % cols) * 330 + 5, (i // cols) * 298 + 5))
        sheet.save(out / 'contact_sheet.png')
    (out / 'checks.json').write_text(json.dumps(dict(rom=str(args.rom), checks=checks), indent=1))
    print(f'LEAGUE ROOMS: {len(checks)} checks passed', flush=True)


if __name__ == '__main__':
    main()
