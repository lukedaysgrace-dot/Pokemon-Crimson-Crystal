#!/usr/bin/env python3
"""Battle test runner.

Usage:
    python3 tools/battletest/runner.py [test-file-or-dir ...] [-k filter]
    python3 tools/battletest/runner.py --all-moves
    make test
    make test-all

Boots pokecrystal_debug.gbc headless, walks a fresh save into the start
menu's DEBUG entry once (cached as a save state keyed on the ROM hash),
then for every YAML case: load fixture, write the request block, let the
ROM run the battle, read WRAM at the assertion point, evaluate.
"""

import argparse
from collections import Counter
import hashlib
import io
import re
import subprocess
import sys
import tempfile
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import yaml
from pyboy import PyBoy

from symbols import Symbols, Constants, STATE_MENU, STATE_READY, STATE_WAIT, STATE_DONE, STATE_ERROR
from state import Battle, Request, encode_action
from move_sweep import generate_move_smoke_tests
from effect_sweep import generate_effect_semantic_tests
from interaction_sweep import generate_interaction_tests
from ability_sweep import generate_ability_tests
from ability_matrix import generate_ability_matrix
from reflection_matrix import generate_reflection_matrix
from class_matrix import generate_class_matrix
from textbox_matrix import generate_textbox_matrix
from swagger_matrix import generate_swagger_matrix
from outcome_matrix import generate_outcome_matrix
from long_sweep import generate_long_tests
from item_matrix import generate_item_matrix
from reaction_matrix import generate_reaction_matrix
from complex_matrix import generate_complex_matrix

ROOT = Path(__file__).resolve().parents[2]
ROM = ROOT / "pokecrystal_debug.gbc"
FIXTURES = Path(__file__).resolve().parent / "fixtures"
FAILDIR = Path(__file__).resolve().parent / "failures"

FRAME_CEILING_BATTLE = 60 * 60 * 5  # 5 emulated minutes per test, hard stop


class Harness:
    def __init__(self, verbose=False):
        if not ROM.exists():
            sys.exit("pokecrystal_debug.gbc not found - run `make debug` first")
        self.verbose = verbose
        self.sym = Symbols()
        self.con = Constants()
        # PyBoy's MBC3 implementation masks ROM bank numbers to seven bits,
        # but this is a 4 MiB MBC30-style ROM with eight-bit bank numbers.
        # Run a private, header-only MBC5 surrogate: its low bank register has
        # the same behavior this game uses, so banks $80-$ff remain reachable.
        # The release/debug ROM on disk is never modified.
        rom_data = bytearray(ROM.read_bytes())
        if len(rom_data) > 128 * 0x4000 and rom_data[0x147] in range(0x0f, 0x14):
            rom_data[0x147] = 0x1b  # MBC5 + RAM + battery
            checksum = 0
            for value in rom_data[0x134:0x14d]:
                checksum = (checksum - value - 1) & 0xff
            rom_data[0x14d] = checksum
        self._rom_tempdir = tempfile.TemporaryDirectory(prefix="battletest-")
        clean_rom = Path(self._rom_tempdir.name) / ROM.name
        clean_rom.write_bytes(rom_data)
        self.pb = PyBoy(str(clean_rom), window="null", cgb=True, sound_emulated=False)
        # PyBoy's fast stepping path can mishandle this ROM's CGB double-speed
        # transitions and reboot into GBCOnlyScreen.  Registering a hook makes
        # PyBoy use its accurate stepping path; the cartridge entry point is a
        # safe one-shot location and the hook preserves the original opcode.
        self.pb.hook_register(0, 0x100, lambda _context: None, None)
        self.pb.set_emulation_speed(0)
        self.battle = Battle(self.pb, self.sym, self.con)
        self.battle.textbox_contexts = set()
        self.fixture = None  # BytesIO of the DEBUG-menu state
        self.text_context = None
        self.text_overflows = []
        self.action_context = None
        self.action_failures = []
        self.action_checks_seen = set()
        bank, address = self.sym['DoTurn']
        self.pb.hook_register(bank, address, self._before_action, None)
        for symbol, callback in (
                ("PrintTextboxText", self._begin_text),
                ("PrintTextboxText.done", self._end_text),
                ("CheckDict.place", self._check_text_glyph)):
            bank, address = self.sym[symbol]
            self.pb.hook_register(bank, address, callback, None)

    def _before_action(self, _context):
        """Observe item/ability updates before the next native action starts."""
        if self.action_context is None:
            return
        checks, snapshot = self.action_context
        side = 'enemy' if self.battle.mem.read('hBattleTurn') else 'player'
        # The ROM increments wDebugTurnsDone when it begins a turn.
        turn = self.battle.turns_done
        for index, check in enumerate(checks):
            if check['side'] != side or check.get('turn', 1) != turn:
                continue
            self.action_checks_seen.add(index)
            env = AssertionContext(self.battle, snapshot).env()
            for expression in check['assert']:
                try:
                    ok = eval(expression, {'__builtins__': {}}, env)
                except Exception as error:
                    self.action_failures.append(f'before {side} turn {turn}: {expression} [{error!r}]')
                    continue
                if not ok:
                    self.action_failures.append(f'before {side} turn {turn}: {expression}')

    def _begin_text(self, _context):
        registers = self.pb.register_file
        address = registers.HL
        bank = self.battle.mem.read("hROMBank") if address >= 0x4000 else 0
        self.text_context = self.sym.nearest(bank, address)
        self.battle.textbox_contexts.add(self.text_context)

    def _end_text(self, _context):
        self.text_context = None

    def _check_text_glyph(self, _context):
        # Observe the actual destination before the text engine writes a glyph.
        # This includes expanded <USER>/<TARGET> and text_ram strings, across
        # scrolls and pages; checking a screenshot at turn end misses old text.
        if self.text_context is None:
            return
        offset = self.pb.register_file.HL - self.sym.addr("wTileMap")
        row, column = divmod(offset, 20)
        if row not in (14, 16) or not 1 <= column <= 18:
            event = f"{self.text_context}: glyph at ({column}, {row})"
            if event not in self.text_overflows:
                self.text_overflows.append(event)

    # ---- low level ----

    def tick(self, n=1):
        for _ in range(n):
            self.pb.tick()

    def press(self, button, hold=2, wait=2):
        self.pb.button(button, hold)
        self.tick(hold + wait)

    def mash(self, button, frames, every=6):
        for i in range(0, frames, every):
            self.pb.button(button, 2)
            self.tick(every)

    def state(self):
        return self.battle.state

    # ---- bootstrap ----

    def rom_key(self):
        return hashlib.md5(ROM.read_bytes()).hexdigest()[:12]

    def fixture_path(self):
        return FIXTURES / f"menu-{self.rom_key()}.state"

    def ensure_fixture(self):
        path = self.fixture_path()
        if path.exists():
            with open(path, "rb") as f:
                self.pb.load_state(f)
            if self.state() == STATE_MENU:
                self.fixture = io.BytesIO(path.read_bytes())
                return
            print("cached fixture stale; rebuilding")
        self.bootstrap()
        buf = io.BytesIO()
        self.pb.save_state(buf)
        FIXTURES.mkdir(exist_ok=True)
        path.write_bytes(buf.getvalue())
        self.fixture = io.BytesIO(buf.getvalue())

    def bootstrap(self):
        """Fresh boot -> new game -> overworld -> START -> DEBUG (state $01).

        Verified sequence: mash through title/main menu, then A (with
        periodic STARTs to jump naming screens to END) through the intro.
        The DEBUG start-menu entry is found by reading wMenuSelection and
        stepping until it equals STARTMENUITEM_DEBUG (9)."""
        log = print if self.verbose else (lambda *a: None)
        log("bootstrap: booting")
        self.tick(400)
        log("bootstrap: title -> new game")
        for _ in range(30):
            self.press("start", wait=10)
            self.press("a", wait=10)
        for _ in range(60):
            self.press("a", wait=10)
        log("bootstrap: intro/naming")
        for i in range(320):
            self.press("a", wait=6)
            if i % 12 == 11:
                self.press("start", wait=6)
        # The naming screen consumes START by moving its cursor to END; it
        # still needs a separate A press to accept the name.  Do that before
        # any generic menu navigation can move the cursor away again.
        log("bootstrap: finishing naming screen")
        self.press("start", hold=4, wait=10)
        self.press("a", hold=4, wait=30)
        for _ in range(40):
            self.press("a", wait=8)
        # Difficulty selection ends with a Yes/No confirmation whose cursor
        # defaults to No.  Mashing A alone loops back to the difficulty menu.
        # Advance any remaining description pages, move to Yes, and confirm;
        # repeat defensively in case the first A only revealed another page.
        log("bootstrap: confirming difficulty")
        # The customized intro has several confirmation boxes (clock and
        # difficulty).  Alternating A with UP+A accepts their default YES
        # choice while continuing through ordinary dialogue in between.
        for _ in range(48):
            self.press("a", wait=8)
            self.press("up", wait=4)
            self.press("a", wait=12)
        for _ in range(24):
            self.press("a", wait=8)
        # back out of anything accidentally opened (pack, menus)
        for _ in range(6):
            self.press("b", wait=10)
        log("bootstrap: opening DEBUG")
        deadline = time.monotonic() + 180
        while self.state() != STATE_MENU:
            if time.monotonic() > deadline:
                self.screenshot("bootstrap-stuck")
                raise RuntimeError(
                    "bootstrap never reached the DEBUG menu "
                    "(state=%02x); see failures/bootstrap-stuck.png" % self.state())
            self.press("b", wait=10)
            self.press("start", hold=4, wait=14)
            for _ in range(12):
                if self.battle.mem.read("wMenuSelection") == 9:
                    break
                self.press("down", hold=4, wait=16)
            self.press("a", hold=4, wait=40)
            self.tick(120)
        log("bootstrap: DEBUG menu reached")

    # ---- per-test drive ----

    def load_fixture(self):
        self.fixture.seek(0)
        self.pb.load_state(self.fixture)
        self.text_context = None
        self.text_overflows = []
        self.battle.textbox_contexts.clear()

    def run_battle(self, test):
        """Write request, run to the assertion point. Returns reached state."""
        Request(self.battle).write(test)
        frames = 0
        # ROM consumes the magic from the menu poll loop, queues the battle
        # script, and battle setup/turns run; mash A through battle text.
        while frames < FRAME_CEILING_BATTLE:
            st = self.state()
            if st in (STATE_WAIT, STATE_DONE, STATE_ERROR):
                return st
            self.pb.button("a", 2)
            self.tick(4)
            frames += 4
        return None  # timed out

    def where(self, samples=120):
        """Sample the PC a few times and symbolize it - a timed-out battle
        is almost always spinning in a BattleRandom reroll loop, and this
        names it (see landmine 2 in BATTLE_TESTER_HANDOFF_2.md)."""
        seen = []
        for _ in range(samples):
            pc = self.pb.register_file.PC
            bank = self.battle.mem.read("hROMBank") if pc >= 0x4000 else 0
            seen.append(self.sym.nearest(bank, pc))
            self.tick(3)
        # The main loop spends most samples in sound/vblank work. Return a
        # short distribution so the less-frequent animation/battle routine is
        # still visible when diagnosing a timeout.
        return ", ".join(
            f"{name} ({count})" for name, count in Counter(seen).most_common(8))

    def animation_state(self):
        """Compact WRAM state for animation timeouts."""
        m = self.battle.mem
        address = m.read_bytes("wBattleAnimAddress", 2)
        return {
            "flags": m.read("wBattleAnimFlags"),
            "delay": m.read("wBattleAnimDelay"),
            "address": f"{address[1]:02x}:{address[0]:02x}",
            "byte": m.read("wBattleAnimByte"),
            "bg": list(m.read_bytes("wActiveBGEffects", 5)),
        }

    def control_state(self):
        """State-machine details for diagnosing a battle timeout."""
        m = self.battle.mem
        registers = self.pb.register_file
        def move_name(runtime_id):
            index = m.move_index_of(runtime_id)
            return self.battle.con.moves_by_index.get(index, f"MOVE_{index}")
        player_move = m.read("wCurPlayerMove")
        enemy_move = m.read("wCurEnemyMove")
        return {
            "pc": f"{registers.PC:04x}",
            "sp": f"{registers.SP:04x}",
            "rom_bank": m.read("hROMBank"),
            "svbk": self.pb.memory[0xFF70],
            "ie": self.pb.memory[0xFFFF],
            "if": self.pb.memory[0xFF0F],
            "lcdc": self.pb.memory[0xFF40],
            "vblank_pending": m.read("wVBlankOccurred"),
            "vblank_mode": m.read("hVBlank"),
            "battle_turn": m.read("hBattleTurn"),
            "turn_ended": m.read("wTurnEnded"),
            "player_status": m.read("wBattleMonStatus"),
            "player_move": (player_move, move_name(player_move)),
            "enemy_move": (enemy_move, move_name(enemy_move)),
            "anim_bank": m.read("wBattleAnimScriptBank"),
            "state": m.read("wDebugState"),
            "turns_done": m.read("wDebugTurnsDone"),
            "turn_target": m.read("wDebugTurnTarget"),
            "control": m.read("wDebugControl"),
            "player_action": m.read("wBattlePlayerAction"),
            "battle_ended": m.read("wBattleEnded"),
            "battle_result": m.read("wBattleResult"),
        }

    def screenshot(self, name):
        FAILDIR.mkdir(exist_ok=True)
        img = self.pb.screen.image
        # Keep failure artifacts portable across Windows/WSL (generated test
        # names include a colon between the move id and name).
        safe_name = re.sub(r"[^A-Za-z0-9_.-]+", "_", name).strip("_")
        p = FAILDIR / f"{safe_name}.png"
        img.save(p)
        return p


# ---- assertion evaluation ----

class AssertionContext:
    def __init__(self, battle, snapshot=None, results=None):
        self.battle = battle
        self.snapshot = snapshot or {}
        self.results = results or {}

    def env(self):
        b = self.battle
        return {
            "player": SideView(b.player, self.snapshot.get("player")),
            "enemy": SideView(b.enemy, self.snapshot.get("enemy")),
            "weather": b.weather,
            "weather_raw": b.mem.read("wBattleWeather"),
            "turns_done": b.turns_done,
            "wram": lambda name, offset=0: b.mem.read(name, offset),
            "wram16": lambda name, offset=0: b.mem.read_u16_be(name, offset),
            "item_id": b.con.item_id,
            "text_seen": b.text_seen,
            "textbox_seen": lambda label: any(context == label or context.startswith(label + "+")
                                             for context in b.textbox_contexts),
            "ability_seen": b.ability_seen,
            "buffer_is": b.buffer_is,
            # name of the move the AI picked last (wCurEnemyMove, 8-bit ID)
            "enemy_move": lambda: b.con.moves_by_index.get(
                b.mem.move_index_of(b.mem.read("wCurEnemyMove")),
                f"MOVE_{b.mem.read('wCurEnemyMove')}"),
            "result": lambda name: self.results[name],
            "abs": abs, "min": min, "max": max,
        }


class SideView:
    """Assertion-facing view; .start_* fields hold the pre-turn snapshot."""

    def __init__(self, side, snap):
        self._side = side
        self._snap = snap or {}

    def __getattr__(self, name):
        if name.startswith("start_"):
            return self._snap.get(name[6:])
        return getattr(self._side, name)


def snapshot_side(side):
    return {
        "hp": side.hp, "maxhp": side.maxhp, "status": side.status,
        "stats": side.stats, "stat_levels": side.stat_levels,
        "pp": side.pp, "item": side.item, "ability": side.ability,
        "species": side.species, "moves": side.moves,
    }


def result_side(side, start):
    """Plain values retained for later paired-control assertions."""
    start = start or {}
    return {
        "hp": side.hp,
        "maxhp": side.maxhp,
        "damage": max(0, start.get("hp", side.hp) - side.hp),
        "healing": max(0, side.hp - start.get("hp", side.hp)),
        "status": side.status,
        "item": side.item,
        "ability": side.ability,
        "species": side.species,
        "moves": side.moves,
        "pp": side.pp,
        "stats": side.stats,
        "stat_levels": side.stat_levels,
        "screens": side.screens,
        "substatus": side.substatus,
    }


def capture_result(battle, snapshot):
    return {
        "player": result_side(battle.player, snapshot.get("player")),
        "enemy": result_side(battle.enemy, snapshot.get("enemy")),
        "weather": battle.weather,
        "turns_done": battle.turns_done,
        "rng_count": battle.mem.read("wLinkBattleRNCount"),
        "text_ram_count": battle.mem.read("wDebugTextRamCount"),
    }


def apply_wram_setup(battle, setup):
    """Apply optional post-entry WRAM fixtures before the first turn."""
    for symbol, value in (setup or {}).items():
        if isinstance(value, dict) and set(value) == {"move"}:
            index = battle.con.move_index(value["move"])
            runtime_id = next((move for move in range(1, 0xfd)
                               if battle.mem.move_index_of(move) == index), None)
            if runtime_id is None:
                raise ValueError(f"setup move {value['move']} is not loaded in this battle")
            battle.mem.write(symbol, runtime_id)
        elif isinstance(value, list):
            battle.mem.write_bytes(symbol, value)
        else:
            battle.mem.write(symbol, value)


def load_tests(paths, keyword=None, all_moves=False, all_effects=False, interactions=0,
               all_abilities=False, ability_matrix=False, reflection_matrix=False,
               class_matrix=False, textbox_matrix=False, swagger_matrix=False,
               outcome_matrix=False, long_battles=False, item_matrix=False, reaction_matrix=False,
               complex_matrix=False):
    files = []
    default_dir = Path(__file__).resolve().parent / "tests"
    if not paths:
        paths = [default_dir]
    for p in paths:
        p = Path(p)
        if p.is_dir():
            files += sorted(p.glob("*.yaml")) + sorted(p.glob("*.yml"))
        else:
            files.append(p)
    tests = []
    for f in files:
        data = yaml.safe_load(f.read_text()) or []
        for t in data:
            t["_file"] = f.name
            tests.append(t)
    if all_moves:
        tests.extend(generate_move_smoke_tests())
    if all_effects:
        tests.extend(generate_effect_semantic_tests())
    if interactions:
        tests.extend(generate_interaction_tests(interactions))
    if all_abilities:
        tests.extend(generate_ability_tests())
    if ability_matrix:
        tests.extend(generate_ability_matrix())
    if reflection_matrix:
        tests.extend(generate_reflection_matrix())
    if class_matrix:
        tests.extend(generate_class_matrix())
    if textbox_matrix:
        tests.extend(generate_textbox_matrix())
    if swagger_matrix:
        tests.extend(generate_swagger_matrix())
    if outcome_matrix:
        tests.extend(generate_outcome_matrix())
    if long_battles:
        tests.extend(generate_long_tests())
    if item_matrix:
        tests.extend(generate_item_matrix())
    if reaction_matrix:
        tests.extend(generate_reaction_matrix())
    if complex_matrix:
        tests.extend(generate_complex_matrix())
    if keyword:
        selected = {i for i, t in enumerate(tests) if keyword.lower() in t.get("name", "").lower()}
        # A filtered assertion still needs its earlier paired controls.
        # Include dependencies transitively and retain original execution order.
        while True:
            required = set()
            for i in selected:
                for expression in tests[i].get("assert", []) + tests[i].get("turn_assert", []):
                    required.update(re.findall(r"result\(['\"]([^'\"]+)['\"]\)", expression))
            expanded = selected | {i for i, t in enumerate(tests) if t.get("id") in required}
            if expanded == selected:
                break
            selected = expanded
        tests = [t for i, t in enumerate(tests) if i in selected]
    return tests


def partition_tests(tests, count):
    """Keep paired result controls with their dependents in every worker."""
    parent = list(range(len(tests)))

    def root(index):
        while parent[index] != index:
            parent[index] = parent[parent[index]]
            index = parent[index]
        return index

    ids = {test['id']: index for index, test in enumerate(tests) if 'id' in test}
    for index, test in enumerate(tests):
        for expression in test.get('assert', []) + test.get('turn_assert', []):
            for dependency in re.findall(r"result\(['\"]([^'\"]+)['\"]\)", expression):
                if dependency not in ids:
                    raise ValueError(f"missing result control {dependency!r}")
                parent[root(index)] = root(ids[dependency])
    groups = {}
    for index in range(len(tests)):
        groups.setdefault(root(index), []).append(index)
    buckets = [[] for _ in range(count)]
    for group in sorted(groups.values(), key=lambda indices: (-len(indices), indices[0])):
        bucket = min(range(count), key=lambda i: (len(buckets[i]), i))
        buckets[bucket].extend(group)
    return [[tests[index] for index in sorted(bucket)] for bucket in buckets]


def run_parallel(tests, jobs):
    """Run isolated emulators, preserving the normal CLI assertions."""
    jobs = min(jobs, len(tests))
    # Bootstrap once so workers only read the cached fixture.
    h = Harness()
    h.ensure_fixture()
    key = h.rom_key()
    h.pb.stop(save=False)
    output = ROOT / '.tmpbuild' / f'battletest-{key}-{time.time_ns()}'
    output.mkdir(parents=True)
    print(f'Running {len(tests)} cases in {jobs} isolated workers; logs: {output}', flush=True)
    workers = []
    for index in range(jobs):
        path = output / f'worker-{index}.log'
        log = path.open('w')
        command = [sys.executable, '-u', str(Path(__file__).resolve()),
                   *sys.argv[1:], '--jobs', '1', '--shard', f'{index}/{jobs}']
        workers.append((subprocess.Popen(command, stdout=log, stderr=subprocess.STDOUT), log, path))
    totals = [0, 0, 0, 0]
    errors = []
    pattern = re.compile(r'^(\d+) passed, (\d+) failed, (\d+) errored, (\d+) skipped in ', re.M)
    for index, (process, log, path) in enumerate(workers):
        result = process.wait()
        log.close()
        content = path.read_text()
        summaries = pattern.findall(content)
        if summaries:
            values = [int(value) for value in summaries[-1]]
            totals = [a + b for a, b in zip(totals, values)]
            print(f'Worker {index}: {values[0]} passed, {values[1]} failed, {values[2]} errored, {values[3]} skipped', flush=True)
        else:
            errors.append(str(path))
            print(f'Worker {index} failed without a summary:\n{content[-3000:]}', flush=True)
        if result:
            errors.append(str(path))
            for line in content.splitlines():
                if line.startswith(('FAIL ', 'ERR ', 'ERROR ', '     assert')):
                    print(line, flush=True)
    print(f'{totals[0]} passed, {totals[1]} failed, {totals[2]} errored, {totals[3]} skipped across {jobs} workers', flush=True)
    if sum(totals) != len(tests):
        errors.append('worker case count differs from selected suite')
    return 1 if errors or totals[1] or totals[2] else 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("paths", nargs="*")
    ap.add_argument("-k", dest="keyword", help="only tests whose name matches")
    ap.add_argument("-v", dest="verbose", action="store_true")
    ap.add_argument('--jobs', type=int, default=1, help='isolated emulator workers; paired controls stay together')
    ap.add_argument('--shard', help=argparse.SUPPRESS)
    ap.add_argument("--all-moves", action="store_true",
                    help="also execute one generated smoke battle per move")
    ap.add_argument("--all-effects", action="store_true",
                    help="also assert one generated scenario per move effect")
    ap.add_argument("--all-abilities", action="store_true",
                    help="exercise every ability on both sides, Gas suppression and Trace")
    ap.add_argument("--ability-matrix", action="store_true",
                    help="move-class suppression/bypass controls and ability transfers")
    ap.add_argument("--reflection-matrix", action="store_true",
                    help="complete Magic Bounce effects, accuracy and targeting rules")
    ap.add_argument("--class-matrix", action="store_true",
                    help="every punch/slice/pulse/bite/ball/wind/sound move with paired controls")
    ap.add_argument("--textbox-matrix", action="store_true",
                    help="every move and ability execution with maximum-length nicknames")
    ap.add_argument("--swagger-matrix", action="store_true",
                    help="Swagger at every Attack stage with Contrary/Own Tempo and bypass controls")
    ap.add_argument("--outcome-matrix", action="store_true",
                    help="move-specific absorption, stat boundaries and secondary effects")
    ap.add_argument("--long-battles", action="store_true",
                    help="16-32 turn ability/switch/mixed battles with per-turn assertions")
    ap.add_argument("--item-matrix", action="store_true",
                    help="Life Orb/Klutz and contact damage/Magic Guard across damaging moves")
    ap.add_argument("--reaction-matrix", action="store_true",
                    help="per-hit Stamina, Weak Armor, Justified, Rattled and Thermal Exchange outcomes")
    ap.add_argument("--complex-matrix", action="store_true",
                    help="multi-hit ability/item combinations and new 12-turn mixed battles")
    ap.add_argument("--interactions", type=int, metavar="N", default=0,
                    help="also run N deterministic mixed-mechanic stress battles")
    args = ap.parse_args()
    if args.jobs < 1:
        ap.error('--jobs must be at least 1')

    tests = load_tests(args.paths, args.keyword, args.all_moves, args.all_effects,
                       args.interactions, args.all_abilities, args.ability_matrix,
                       args.reflection_matrix, args.class_matrix, args.textbox_matrix,
                       args.swagger_matrix, args.outcome_matrix, args.long_battles, args.item_matrix,
                       args.reaction_matrix, args.complex_matrix)
    if not tests:
        sys.exit("no tests found")
    if args.shard:
        index, count = map(int, args.shard.split('/'))
        if not 0 <= index < count:
            ap.error('invalid shard')
        tests = partition_tests(tests, count)[index]
    elif args.jobs > 1:
        sys.exit(run_parallel(tests, args.jobs))

    h = Harness(verbose=args.verbose)
    t0 = time.monotonic()
    h.ensure_fixture()
    print(f"fixture ready in {time.monotonic()-t0:.1f}s; running {len(tests)} tests")

    passed = failed = errored = skipped = 0
    results = {}
    for test in tests:
        name = test.get("name", "<unnamed>")
        if test.get("skip"):
            skipped += 1
            print(f"SKIP {name} ({test.get('skip') if isinstance(test.get('skip'), str) else 'skipped'})")
            continue
        t1 = time.monotonic()
        try:
            h.action_context = None
            h.action_failures = []
            h.action_checks_seen = set()
            h.load_fixture()
            checkpoint_failures = []
            # pre-turn snapshot comes from a 0-turn pause when requested
            snapshot = {}
            if test.get("snapshot", True):
                spec = dict(test)
                spec["turns"] = 0
                Request(h.battle).write(spec)
                st = None
                frames = 0
                while frames < FRAME_CEILING_BATTLE:
                    st = h.state()
                    if st in (STATE_WAIT, STATE_DONE, STATE_ERROR):
                        break
                    h.pb.button("a", 2)
                    h.tick(4)
                    frames += 4
                if st != STATE_WAIT:
                    raise RuntimeError(f"never reached pre-turn snapshot "
                                       f"(state={st}, stuck at {h.where()})")
                snapshot = {"player": snapshot_side(h.battle.player),
                            "enemy": snapshot_side(h.battle.enemy)}
                apply_wram_setup(h.battle, test.get("setup_wram"))
                h.action_context = (test.get('before_action', []), snapshot)
                # Longer scripts refresh the last ROM script slot at each
                # pause, preserving the retail turn/switch routines. Optional
                # assertions inspect every completed turn, not only the end.
                target = test.get("turns", 1)
                script = test.get("move_script") or []
                checkpoints = range(1, target + 1) if test.get("turn_assert") or test.get("turn_setup_wram") or len(script) > 8 else [target]
                for checkpoint in checkpoints:
                    if checkpoint >= 8 and len(script) > 8:
                        action = script[min(checkpoint - 1, len(script) - 1)]
                        h.battle.mem.write("wDebugMoveScript", encode_action(action), 7)
                    h.battle.mem.write("wDebugTurnTarget", checkpoint)
                    h.battle.mem.write("wDebugControl", 1)
                    frames = 0
                    while frames < FRAME_CEILING_BATTLE:
                        st = h.state()
                        if st in (STATE_WAIT, STATE_DONE, STATE_ERROR) and \
                                h.battle.turns_done >= checkpoint:
                            break
                        if st == STATE_DONE:
                            break
                        h.pb.button("a", 2)
                        h.tick(4)
                        frames += 4
                    else:
                        st = None
                    if st in (STATE_WAIT, STATE_DONE):
                        env = AssertionContext(h.battle, snapshot, results).env()
                        for expression in test.get("turn_assert", []):
                            if not eval(expression, {"__builtins__": {}}, env):
                                checkpoint_failures.append(f"turn {h.battle.turns_done}: {expression}")
                    if st != STATE_WAIT:
                        break
                    # Seed a documented state between native turns (for
                    # example, a revived bench ally), then resume normally.
                    apply_wram_setup(h.battle, (test.get("turn_setup_wram") or {}).get(checkpoint))
            else:
                st = h.run_battle(test)

            if st is None:
                raise RuntimeError(
                    f"battle timed out (stuck at {h.where()}; "
                    f"control={h.control_state()}; "
                    f"animation={h.animation_state()})")
            if st == STATE_ERROR:
                raise RuntimeError("ROM rejected the request")

            ctx = AssertionContext(h.battle, snapshot, results).env()
            if "id" in test:
                results[test["id"]] = capture_result(h.battle, snapshot)
            failures = []
            failures.extend(checkpoint_failures)
            failures.extend(h.action_failures)
            for index, check in enumerate(test.get('before_action', [])):
                if index not in h.action_checks_seen:
                    failures.append(f"missing before_action checkpoint: {check['side']} turn {check.get('turn', 1)}")
            failures.extend(h.text_overflows)
            for expr in test.get("assert", []):
                try:
                    ok = eval(expr, {"__builtins__": {}}, ctx)
                except Exception as e:
                    failures.append(f"{expr}  [raised {e!r}]")
                    continue
                if not ok:
                    failures.append(expr)

            if failures:
                failed += 1
                shot = h.screenshot(name.replace(" ", "_").replace("/", "-")[:60])
                print(f"FAIL {name} ({time.monotonic()-t1:.1f}s)")
                for f_ in failures:
                    print(f"     assert {f_}")
                detail = {k: v for k, v in (("player.hp", ctx["player"].hp),
                          ("player.maxhp", ctx["player"].maxhp),
                          ("enemy.hp", ctx["enemy"].hp),
                          ("enemy.maxhp", ctx["enemy"].maxhp),
                          ("player.pp", ctx["player"].pp),
                          ("enemy.pp", ctx["enemy"].pp),
                          ("player.stages", ctx["player"].stat_levels),
                          ("enemy.stages", ctx["enemy"].stat_levels),
                          ("player.screens", ctx["player"].screens),
                          ("enemy.screens", ctx["enemy"].screens),
                          ("critical", h.battle.mem.read("wCriticalHit")),
                          ("player.ability", ctx["player"].ability),
                          ("enemy.ability", ctx["enemy"].ability),
                          ("text_ram", [raw.hex() for raw in h.battle.rendered_ram_texts]),
                          ("dynamic_name", h.battle.mem.read_bytes(
                              "wBattleDynamicNameBuffer", 24).hex()),
                          ("weather", ctx["weather"]))}
                print(f"     state: {detail}")
                print(f"     screenshot: {shot}")
            else:
                passed += 1
                print(f"PASS {name} ({time.monotonic()-t1:.1f}s)")
                if h.verbose:
                    print(f"     control: {h.control_state()}")
        except Exception as e:
            errored += 1
            shot = h.screenshot(("err-" + name.replace(" ", "_"))[:60])
            print(f"ERROR {name}: {e} (screenshot: {shot})")

    dt = time.monotonic() - t0
    print(f"\n{passed} passed, {failed} failed, {errored} errored, {skipped} skipped in {dt:.1f}s")
    h.pb.stop(save=False)
    sys.exit(0 if failed == errored == 0 else 1)


if __name__ == "__main__":
    main()
