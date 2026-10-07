#!/usr/bin/env python3
"""Interactive, logged button-only story playthrough in private test SRAM.

Starts at the cached fresh-new-game boot (before receiving a starter).
After that, commands only press buttons, advance frames, or read/capture state.
No party/encounter staging, native routine calls, or gameplay WRAM edits.
"""

import argparse
import json
import shutil
import sys
from pathlib import Path

from runner import Harness
from symbols import ROOT
from ui_checks import tile_text


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', default='.tmpbuild/story-playthrough')
    args = parser.parse_args()
    output = ROOT / args.output
    output.mkdir(parents=True, exist_ok=True)
    h = Harness()
    h.ensure_fixture()
    # The fixture was created through the new-game menus, before the starter.
    # Leave DEBUG and the start menu through their normal cancel inputs.
    h.press('b', hold=4, wait=30)
    h.press('b', hold=4, wait=30)
    frames = commands = 0
    journal = (output / 'journal.jsonl').open('a', buffering=1)

    def snapshot(label):
        m = h.battle.mem
        party = []
        for slot in range(1, min(6, m.read('wPartyCount')) + 1):
            prefix = f'wPartyMon{slot}'
            index = m.species_index_of(m.read(prefix + 'Species'))
            party.append(dict(species=h.con.species_by_index.get(index, str(index)),
                              level=m.read(prefix + 'Level'), hp=m.read_u16_be(prefix + 'HP'),
                              maxhp=m.read_u16_be(prefix + 'MaxHP'), item=m.read(prefix + 'Item'),
                              moves=[h.con.moves_by_index.get(m.move_index_of(value), str(value))
                                     for value in m.read_bytes(prefix + 'Moves', 4)],
                              pp=list(m.read_bytes(prefix + 'PP', 4)),
                              status=m.read(prefix + 'Status'),
                              personality=list(m.read_bytes(prefix + 'Personality', 2))))
        data = dict(command=commands, frames=frames, emulated_minutes=round(frames / 3600, 2),
                    label=label, map=[m.read('wMapGroup'), m.read('wMapNumber')],
                    position=[m.read('wXCoord'), m.read('wYCoord')],
                    map_status=m.read('wMapStatus'), battle_mode=m.read('wBattleMode'),
                    party=party, text=tile_text(h), text_overflows=list(h.text_overflows),
                    pc=f'{h.pb.register_file.PC:04x}')
        h.pb.screen.image.save(str(output / 'latest.png'))
        h.pb.screen.image.save(str(output / f'{commands:04d}.png'))
        with (output / 'latest.state').open('wb') as stream:
            h.pb.save_state(stream)
        journal.write(json.dumps(data) + '\n')
        print(json.dumps(data), flush=True)

    snapshot('fresh game, no starter')
    try:
        for line in sys.stdin:
            try:
                command = json.loads(line)
                commands += 1
                journal.write(json.dumps(dict(input=command, command=commands)) + '\n')
                if command.get('quit'):
                    break
                for action in command.get('actions', []):
                    button = action.get('button')
                    hold, wait = action.get('hold', 8), action.get('wait', 24)
                    repeats = action.get('repeat', 1)
                    for _ in range(repeats):
                        if button:
                            h.press(button, hold=hold, wait=wait)
                            frames += hold + wait
                        else:
                            h.tick(wait)
                            frames += wait
                snapshot(command.get('label', 'buttons'))
            except Exception as error:
                print(json.dumps(dict(error=repr(error))), flush=True)
    finally:
        private_rom = Path(h._rom_tempdir.name) / 'pokecrystal_debug.gbc'
        h.pb.stop(save=True)
        for suffix in ('.ram', '.rtc'):
            source = Path(str(private_rom) + suffix)
            if source.exists():
                shutil.copy2(source, output / source.name)
        journal.close()


if __name__ == '__main__':
    main()
