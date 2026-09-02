from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent / "pydeps_local"))
from pyboy import PyBoy
p=PyBoy(str(Path(__file__).parent/"fresh_debug_mbc5.gbc"),window="null",cgb=True,sound_emulated=False)
p.hook_register(0,0x150,lambda _c: print("RESET",*[hex(p.memory[a]) for a in range(0xffa2,0xffaa)],flush=True),None)
p.set_emulation_speed(0)
def t(n):
    for _ in range(n): p.tick()
def hit(k):
    p.button_press(k); t(20); p.button_release(k); t(80)
def snap(n):
    print(n,hex(p.register_file.PC),*[hex(p.memory[a]) for a in (0xffa7,0xffa8,0xffa9)],flush=True)
    p.screen.image.save(Path(__file__).parent/f"hold-{n}.png")
t(1200); snap("title")
hit("a"); snap("menu")
hit("a"); snap("newgame")
for i in range(15):
    hit("a")
    snap(f"dialogue-{i+1:02d}")
p.stop(save=False)
