from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent / "pydeps_local"))
from pyboy import PyBoy
p = PyBoy(str(Path(__file__).parent / "fresh_debug.gbc"), window="null", cgb=True, sound_emulated=False)
p.set_emulation_speed(0)
def t(n):
    for _ in range(n): p.tick()
def s(n):
    print(n, hex(p.register_file.PC), p.memory[0xffe6], flush=True)
    p.screen.image.save(Path(__file__).parent / f"input-{n}.png")
t(400); s("0")
p.button("start", 2); t(60); s("1-start")
p.button("a", 2); t(300); s("2-a")
p.button("a", 2); t(300); s("3-a")
p.button("a", 2); t(300); s("4-a")
p.button("start", 2); t(300); s("5-start")
p.button("a", 2); t(300); s("6-a")
p.button("start", 2); t(300); s("7-start")
p.stop(save=False)
