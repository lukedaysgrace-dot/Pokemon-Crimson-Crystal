from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent / "pydeps_local"))
from pyboy import PyBoy

ROM = Path(__file__).parent / "fresh_debug_mbc5.gbc"
p = PyBoy(str(ROM), window="null", cgb=True, sound_emulated=False)
p.hook_register(0, 0x100, lambda _c: None, None)
p.set_emulation_speed(0)

def tick(n=1):
    for _ in range(n):
        p.tick()

def press(button, hold=2, wait=2):
    p.button(button, hold)
    tick(hold + wait)

def snap(name):
    pc = p.register_file.PC
    print(name, "PC", hex(pc), "hCGB", p.memory[0xFFE6], flush=True)
    p.screen.image.save(Path(__file__).parent / f"trace-{name}.png")

tick(400); snap("boot")
for _ in range(30):
    press("start", wait=10); press("a", wait=10)
snap("title")
for _ in range(60): press("a", wait=10)
snap("dialogue")
for i in range(320):
    press("a", wait=6)
    if i % 12 == 11: press("start", wait=6)
snap("intro")
press("start", hold=4, wait=10); press("a", hold=4, wait=30)
for _ in range(40): press("a", wait=8)
snap("naming")
for _ in range(48):
    press("a", wait=8); press("up", wait=4); press("a", wait=12)
snap("difficulty1")
for _ in range(24): press("a", wait=8)
snap("difficulty2")
p.stop(save=False)
