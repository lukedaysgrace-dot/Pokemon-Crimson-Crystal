#!/usr/bin/env python3
"""Battle test runner.

Usage:
    python3 tools/battletest/runner.py [test-file-or-dir ...] [-k filter]
    make test

Boots pokecrystal_debug.gbc headless, walks a fresh save into the start
menu's DEBUG entry once (cached as a save state keyed on the ROM hash),
then for every YAML case: load fixture, write the request block, let the
ROM run the battle, read WRAM at the assertion point, evaluate.
"""

import argparse
import hashlib
import io
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import yaml
from pyboy import PyBoy

from symbols import Symbols, Constants, STATE_MENU, STATE_READY, STATE_WAIT, STATE_DONE, STATE_ERROR
from state import Battle, Request

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
        self.pb = PyBoy(str(ROM), window="null", cgb=True, sound_emulated=False)
        self.pb.set_emulation_speed(0)
        self.battle = Battle(self.pb, self.sym, self.con)
        self.fixture = None  # BytesIO of the DEBUG-menu state

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
        """Fresh boot -> new game -> overworld -> START -> DEBUG (state $01)."""
        log = print if self.verbose else (lambda *a: None)
        log("bootstrap: booting")
        self.tick(300)  # boot/logos
        log("bootstrap: title/menus")
        # Title screen -> main menu -> new game -> intro. The exact frame
        # counts do not matter; we just mash through every prompt. Naming
        # screens accept the default name with START then A on END.
        for _ in range(40):
            self.press("start", wait=8)
            self.press("a", wait=8)
        # Oak speech + naming: mash A with periodic STARTs to accept defaults
        for _ in range(220):
            self.press("a", wait=4)
            if _ % 10 == 9:
                self.press("start", wait=4)
        # We should be in the bedroom now; give the map a moment
        self.tick(120)
        # Open the start menu and hunt for DEBUG: it is the entry right
        # after OPTION. Simplest robust approach: open menu, then press
        # d_up twice from the top (list wraps: EXIT, DEBUG) then A.
        deadline = time.time() + 120
        while self.state() != STATE_MENU:
            if time.time() > deadline:
                self.screenshot("bootstrap-stuck")
                raise RuntimeError(
                    "bootstrap never reached the DEBUG menu "
                    "(state=%02x); see failures/bootstrap-stuck.png" % self.state())
            self.press("b", wait=6)          # close any stray dialog
            self.press("start", wait=10)     # open start menu
            self.press("d_up", wait=4)       # wrap to EXIT
            self.press("d_up", wait=4)       # wrap to DEBUG
            self.press("a", wait=10)
            # if that selected something else (menu layout differs), the
            # B at loop top backs out and we try a different offset
            if self.state() == STATE_MENU:
                break
            self.press("d_down", wait=4)
            self.press("a", wait=10)
        log("bootstrap: DEBUG menu reached")

    # ---- per-test drive ----

    def load_fixture(self):
        self.fixture.seek(0)
        self.pb.load_state(self.fixture)

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

    def screenshot(self, name):
        FAILDIR.mkdir(exist_ok=True)
        img = self.pb.screen.image
        p = FAILDIR / f"{name}.png"
        img.save(p)
        return p


# ---- assertion evaluation ----

class AssertionContext:
    def __init__(self, battle, snapshot=None):
        self.battle = battle
        self.snapshot = snapshot or {}

    def env(self):
        b = self.battle
        return {
            "player": SideView(b.player, self.snapshot.get("player")),
            "enemy": SideView(b.enemy, self.snapshot.get("enemy")),
            "weather": b.weather,
            "turns_done": b.turns_done,
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


def load_tests(paths, keyword=None):
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
    if keyword:
        tests = [t for t in tests if keyword.lower() in t.get("name", "").lower()]
    return tests


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("paths", nargs="*")
    ap.add_argument("-k", dest="keyword", help="only tests whose name matches")
    ap.add_argument("-v", dest="verbose", action="store_true")
    args = ap.parse_args()

    tests = load_tests(args.paths, args.keyword)
    if not tests:
        sys.exit("no tests found")

    h = Harness(verbose=args.verbose)
    t0 = time.time()
    h.ensure_fixture()
    print(f"fixture ready in {time.time()-t0:.1f}s; running {len(tests)} tests")

    passed = failed = errored = 0
    for test in tests:
        name = test.get("name", "<unnamed>")
        t1 = time.time()
        try:
            h.load_fixture()
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
                    raise RuntimeError(f"never reached pre-turn snapshot (state={st})")
                snapshot = {"player": snapshot_side(h.battle.player),
                            "enemy": snapshot_side(h.battle.enemy)}
                # continue to the real turn target
                h.battle.mem.write("wDebugTurnTarget", test.get("turns", 1))
                h.battle.mem.write("wDebugControl", 1)
                frames = 0
                while frames < FRAME_CEILING_BATTLE:
                    st = h.state()
                    if st in (STATE_WAIT, STATE_DONE, STATE_ERROR) and \
                            h.battle.turns_done >= test.get("turns", 1):
                        break
                    if st == STATE_DONE:
                        break
                    h.pb.button("a", 2)
                    h.tick(4)
                    frames += 4
            else:
                st = h.run_battle(test)

            if st is None:
                raise RuntimeError("battle timed out")
            if st == STATE_ERROR:
                raise RuntimeError("ROM rejected the request")

            ctx = AssertionContext(h.battle, snapshot).env()
            failures = []
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
                print(f"FAIL {name} ({time.time()-t1:.1f}s)")
                for f_ in failures:
                    print(f"     assert {f_}")
                detail = {k: v for k, v in (("player.hp", ctx["player"].hp),
                          ("player.maxhp", ctx["player"].maxhp),
                          ("enemy.hp", ctx["enemy"].hp),
                          ("enemy.maxhp", ctx["enemy"].maxhp),
                          ("player.ability", ctx["player"].ability),
                          ("enemy.ability", ctx["enemy"].ability),
                          ("weather", ctx["weather"]))}
                print(f"     state: {detail}")
                print(f"     screenshot: {shot}")
            else:
                passed += 1
                print(f"PASS {name} ({time.time()-t1:.1f}s)")
        except Exception as e:
            errored += 1
            shot = h.screenshot(("err-" + name.replace(" ", "_"))[:60])
            print(f"ERROR {name}: {e} (screenshot: {shot})")

    dt = time.time() - t0
    print(f"\n{passed} passed, {failed} failed, {errored} errored in {dt:.1f}s")
    h.pb.stop(save=False)
    sys.exit(0 if failed == errored == 0 else 1)


if __name__ == "__main__":
    main()
