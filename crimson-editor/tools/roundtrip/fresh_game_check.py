#!/usr/bin/env python3
"""Create a new game via input, or Continue/editor-save/resave it in a rebuilt ROM.

Each emulator has a private ROM/SRAM directory. No player's save or sidecar is
loaded or overwritten. Routine checks preserve and restore the live game state.
"""
import argparse
import hashlib
import io
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT / 'tools/battletest'))
from runner import Harness
from probability_checks import call
from save_menu_checks import begin_native_call
from ui_checks import tile_text
from cove_sprite_checks import native_call

parser = argparse.ArgumentParser()
parser.add_argument('mode', choices=['create', 'verify'])
parser.add_argument('--out', type=Path, required=True)
parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
parser.add_argument('--save', type=Path)
parser.add_argument('--expected', type=Path)
args = parser.parse_args()
args.out.mkdir(parents=True, exist_ok=True)
checks = []


def check(condition, message):
    if not condition:
        raise AssertionError(message)
    checks.append(message)
    print('PASS ' + message, flush=True)


def shot(h, name):
    h.pb.screen.image.convert('RGB').save(str(args.out / (name + '.png')))


def dump_sram(h, filename):
    result = bytearray()
    h.pb.memory[0] = 0x0a
    for bank in range(8):
        h.pb.memory[0x4000] = bank
        result.extend(h.pb.memory[0xa000:0xc000])
    h.pb.memory[0] = 0
    (args.out / filename).write_bytes(result)
    return bytes(result)


def load_sram(h, data):
    if len(data) < 65536:
        raise ValueError('Truncated input SRAM')
    h.pb.memory[0] = 0x0a
    for bank in range(8):
        h.pb.memory[0x4000] = bank
        h.pb.memory[0xa000:0xc000] = list(data[bank * 8192:(bank + 1) * 8192])
    h.pb.memory[0] = 0


def create_game(h):
    m = h.battle.mem
    entered = []
    h.pb.hook_register(*h.sym['NewGame'], lambda _: entered.append(True), None)
    print('Booting a blank cartridge and selecting NEW GAME...', flush=True)
    h.tick(400)
    for _ in range(30):
        h.press('start', wait=10)
        h.press('a', wait=10)
    for _ in range(60):
        h.press('a', wait=10)
    print('Completing intro, trainer naming and gameplay choices...', flush=True)
    for i in range(320):
        h.press('a', wait=6)
        if i % 12 == 11:
            h.press('start', wait=6)
    h.press('start', hold=4, wait=10)
    h.press('a', hold=4, wait=30)
    for _ in range(40):
        h.press('a', wait=8)
    for _ in range(48):
        h.press('a', wait=8)
        h.press('up', wait=4)
        h.press('a', wait=12)
    for _ in range(24):
        h.press('a', wait=8)
    for _ in range(6):
        h.press('b', wait=10)
    # The expanded intro can still be in Oak's speech after the settings. Keep
    # using ordinary input until the map loop is actually running, rather than
    # assuming a fixed number of A presses is sufficient.
    for i in range(1200):
        if m.read('wMapStatus') == 2 and m.read('wMapGroup') > 0:
            break
        text = tile_text(h)
        if 'YES' in text and 'NO' in text:
            h.press('up', hold=4, wait=6)
        if 'DEL' in text and 'END' in text or i % 24 == 23:
            h.press('start', hold=4, wait=6)
        h.press('a', hold=4, wait=16)
        if i and i % 300 == 0:
            print('Advancing the native intro: ' + text.replace('\n', ' ').strip(), flush=True)
    check(bool(entered), 'Started NEW GAME on a blank private cartridge')
    check(m.read('wMapStatus') == 2 and m.read('wMapGroup') > 0,
          'Intro completed and reached the overworld')
    shot(h, 'new-game-overworld')
    # Generate an initial starter through the release ROM, before its first save.
    starter = h.con.species_index('BULBASAUR')
    call(h, 'GetPokemonIDFromIndex', HL=starter)
    m.write('wCurPartySpecies', h.pb.register_file.A)
    m.write('wCurPartyLevel', 5)
    m.write('wMonType', 0)
    m.write('wBattleMode', 0)
    call(h, 'TryAddMonToParty')
    check(m.read('wPartyCount') == 1, 'Release ROM generated the initial level-5 starter')


def native_save(h, prefix):
    m = h.battle.mem
    saved = []
    h.pb.hook_register(*h.sym['SavedTheGame'], lambda _: saved.append(True), None)
    begin_native_call(h, 'StartMenu')
    h.tick(90)
    for _ in range(12):
        if m.read('wMenuSelection') == 4:
            break
        h.press('down', hold=4, wait=20)
    check(m.read('wMenuSelection') == 4, prefix + ': selected the native SAVE menu')
    shot(h, prefix + '-save-menu')
    h.press('a', hold=6, wait=30)
    for _ in range(1800):
        h.pb.button('a', 2)
        h.tick(4)
        if saved and h.pb.register_file.PC in (0xc0f1, 0xc0f3):
            break
    else:
        raise RuntimeError('SAVE did not complete: ' + tile_text(h))
    check(bool(saved), prefix + ': native save completed')
    shot(h, prefix + '-saved')


def continue_game(h, prefix, count):
    m = h.battle.mem
    continued = []
    h.pb.hook_register(*h.sym['MainMenu_Continue'], lambda _: continued.append(True), None)
    h.tick(400)
    for _ in range(80):
        if 'CONTINUE' in tile_text(h):
            break
        h.press('start', hold=4, wait=16)
        h.press('a', hold=4, wait=16)
    check('CONTINUE' in tile_text(h), prefix + ': fresh boot offers CONTINUE')
    h.pb.button_release('a')
    h.pb.button_release('start')
    h.tick(120)
    shot(h, prefix + '-continue-menu')
    for _ in range(300):
        if continued and m.read('wPartyCount') == count and m.read('wMapStatus') == 2:
            break
        h.press('a', hold=8, wait=24)
    h.pb.button_release('a')
    h.tick(120)
    check(bool(continued) and m.read('wPartyCount') == count, prefix + ': Continue loaded the edited party')
    check(m.read('wMapStatus') == 2, prefix + ': Continue returned to the overworld')
    shot(h, prefix + '-overworld')


def verify_roster(h, expected, prefix):
    # Routine calls replace the program counter. Restore it afterwards so the
    # actual Continue/save/menu/walking checks still exercise the game loop.
    state = io.BytesIO()
    h.pb.save_state(state)
    m = h.battle.mem
    try:
        check(m.read('wPartyCount') == len(expected['party']), prefix + ': party count')
        for i, mon in enumerate(expected['party'], 1):
            call(h, 'GetPokemonIndexFromID', A=m.read(f'wPartyMon{i}Species'))
            check(h.pb.register_file.HL == mon['species'], f'{prefix}: party {i} species')
            check(m.read(f'wPartyMon{i}Level') == mon['level'], f'{prefix}: party {i} level')
            name_length = expected['nameLength']
            nickname = m.read_bytes('wPartyMonNicknames', name_length * i)[name_length * (i - 1):]
            check(list(nickname) == mon['nicknameBytes'], f'{prefix}: party {i} nickname')
            for j, move in enumerate(mon['moves']):
                call(h, 'GetMoveIndexFromID', A=m.read(f'wPartyMon{i}Moves', j))
                check(h.pb.register_file.HL == move, f'{prefix}: party {i} move {j + 1}')
            check(bool(m.read(f'wPartyMon{i}Unused') & 128) == mon['shiny'], f'{prefix}: party {i} shiny flag')
            check(bool(m.read('wPartySpecies', i - 1) == expected['eggMarker']) == mon['egg'], f'{prefix}: party {i} egg marker')
            check(m.read_u16_be(f'wPartyMon{i}HP') <= m.read_u16_be(f'wPartyMon{i}MaxHP'), f'{prefix}: party {i} valid HP')
        for mon in expected['boxes']:
            call(h, 'GetStorageBoxMon', B=mon['box'], C=mon['slot'])
            flags = h.pb.register_file.F
            check(not flags & 0x90, f"{prefix}: box {mon['box']} slot {mon['slot']} decodes without Bad Egg")
            check(m.read('wTempMonSpeciesIndex') | m.read('wTempMonSpeciesIndex', 1) << 8 == mon['species'], f"{prefix}: box {mon['box']} species")
            for j, move in enumerate(mon['moves']):
                call(h, 'GetMoveIndexFromID', A=m.read('wTempMonMoves', j))
                check(h.pb.register_file.HL == move, f"{prefix}: box {mon['box']} move {j + 1}")
    finally:
        state.seek(0)
        h.pb.load_state(state)


def show_party(h):
    begin_native_call(h, 'StartMenu')
    h.tick(90)
    for _ in range(12):
        if h.battle.mem.read('wMenuSelection') == 1:
            break
        h.press('down', hold=4, wait=20)
    h.press('a', hold=6, wait=120)
    shot(h, 'edited-party-in-game')
    check('ALOLA' in tile_text(h) and 'GALAR' in tile_text(h), 'Native party screen displays the added Pokémon')
    for _ in range(6):
        h.press('b', hold=4, wait=20)


def show_pc(h):
    state = io.BytesIO()
    h.pb.save_state(state)
    try:
        begin_native_call(h, '_BillsPC')
        h.tick(200)
        check('BOX' in tile_text(h), 'Native Bill\'s PC opens with the edited save')
        shot(h, 'edited-box-one-in-game')
        h.pb.register_file.A = 24
        native_call(h, 'BillsPC_ChangeBox')
        native_call(h, 'GetCursorMon')
        h.tick(30)
        check(h.battle.mem.read('wCurBox') == 24, 'Native PC switches to box 25')
        check('BOXFINAL' in tile_text(h), 'Native PC displays the added Pokémon in box 25')
        shot(h, 'edited-box-25-in-game')
    finally:
        state.seek(0)
        h.pb.load_state(state)


def exercise_storage(h, expected):
    state = io.BytesIO()
    h.pb.save_state(state)
    m = h.battle.mem
    try:
        boxed = expected['boxes'][0]
        result = call(h, 'SwapStorageBoxSlots', B=0, C=0, D=boxed['box'], E=boxed['slot'])
        check(result != 0 and m.read('wPartyCount') == 6,
              'Native storage refuses withdrawal into a full party')
        result = call(h, 'SwapStorageBoxSlots', B=0, C=1, D=boxed['box'], E=boxed['slot'])
        check(result == 0, 'Native storage swaps an editor-created box Pokémon into the party')
        call(h, 'GetPokemonIndexFromID', A=m.read('wPartyMon1Species'))
        check(h.pb.register_file.HL == boxed['species'], 'Withdrawn Pokémon resolves to its intended species')
        result = call(h, 'SwapStorageBoxSlots', B=0, C=1, D=boxed['box'], E=boxed['slot'])
        check(result == 0, 'Native storage swaps the Pokémon back successfully')
        verify_roster(h, expected, 'After native storage swaps')
    finally:
        state.seek(0)
        h.pb.load_state(state)


h = None
try:
    h = Harness(rom_path=args.rom)
    if args.mode == 'create':
        create_game(h)
        native_save(h, 'new-game')
        dump_sram(h, 'new-game.sav')
    else:
        if not args.save or not args.expected:
            parser.error('verify requires --save and --expected')
        expected = json.loads(args.expected.read_text())
        load_sram(h, args.save.read_bytes())
        continue_game(h, 'edited', len(expected['party']))
        verify_roster(h, expected, 'Editor download')
        show_party(h)
        show_pc(h)
        exercise_storage(h, expected)
        native_save(h, 'edited')
        resaved = dump_sram(h, 'game-resaved.sav')
        h.pb.stop(save=False)
        h = Harness(rom_path=args.rom)
        load_sram(h, resaved)
        continue_game(h, 'resaved', len(expected['party']))
        verify_roster(h, expected, 'Native resave and second boot')
    result = {'status': 'passed', 'mode': args.mode, 'checks': checks, 'rom': str(args.rom), 'romSha1': hashlib.sha1(args.rom.read_bytes()).hexdigest()}
    (args.out / (args.mode + '-report.json')).write_text(json.dumps(result, indent=2) + '\n')
    print(f'{len(checks)} checks passed.', flush=True)
except Exception:
    if h:
        shot(h, args.mode + '-failure')
    raise
finally:
    if h:
        h.pb.stop(save=False)
