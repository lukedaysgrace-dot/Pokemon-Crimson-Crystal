#!/usr/bin/env python3
"""Records every frame of a swap / deposit in the PC and reports frames that
differ a lot from their neighbours (a "blink")."""
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pc_ui_harness import *  # noqa: E402,F401,F403

setup_default()
OUTD = os.environ.get("PC_UI_OUT", "/tmp/blink")
os.makedirs(OUTD, exist_ok=True)

log = []


def grab():
    return np.array(py.screen.image.convert("RGB"))


def run(n, tag):
    for i in range(n):
        py.tick(1, True)
        log.append((tag, grab()))


def press_rec(btn, hold=8, wait=16, tag=""):
    py.button_press(btn)
    run(hold, tag + ":" + btn + "-hold")
    py.button_release(btn)
    run(wait, tag + ":" + btn)


enter()
run(180, "open")
seq = os.environ.get("SEQ", "swap")
if seq == "swap":
    press_rec("select", tag="swapmode")
    press_rec("a", wait=40, tag="pick")
    press_rec("right", tag="carry1")
    press_rec("right", tag="carry2")
    press_rec("a", wait=80, tag="place")
    press_rec("a", wait=40, tag="pick2")
    press_rec("down", tag="c1"); press_rec("down", tag="c2"); press_rec("down", tag="c3")
    press_rec("left", tag="c4"); press_rec("left", tag="c5"); press_rec("left", tag="c6"); press_rec("left", tag="c7")
    press_rec("a", wait=100, tag="place_party")
    press_rec("a", wait=40, tag="pick3")
    press_rec("up", tag="d1")
    press_rec("a", wait=100, tag="swap_party")
elif seq == "menu":
    press_rec("a", wait=30, tag="menu")
    press_rec("a", wait=120, tag="withdraw")
    press_rec("down", tag="e1"); press_rec("down", tag="e2"); press_rec("down", tag="e3")
    press_rec("left", tag="e4"); press_rec("left", tag="e5")
    press_rec("a", wait=30, tag="pmenu")
    press_rec("a", wait=120, tag="deposit")
elif seq == "idle":
    run(600, "idle")

prev = None
big = []
for i, (tag, img) in enumerate(log):
    if prev is not None:
        d = int((np.abs(img.astype(int) - prev.astype(int)).sum(axis=2) > 0).sum())
        if d > 300:
            big.append((i, tag, d))
    prev = img
print("frames:", len(log))
for i, tag, d in big:
    # does it revert on the next frame?
    nxt = log[i + 1][1] if i + 1 < len(log) else None
    back = None
    if nxt is not None:
        back = int((np.abs(nxt.astype(int) - log[i - 1][1].astype(int)).sum(axis=2) > 0).sum())
    print(f"{i:4d} {tag:24s} diff={d:6d} next-vs-prev={back}")
    if back is not None and back < d // 4:
        from PIL import Image
        for k in (i - 1, i, i + 1):
            Image.fromarray(log[k][1]).save(f"{OUTD}/f{k:04d}.png")
