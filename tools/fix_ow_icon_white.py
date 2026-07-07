#!/usr/bin/env python3
"""Convert menu-style icon PNGs to the overworld-safe format.

Overworld mon icons map their palette by brightness: the background must
be the lightest color (slot #0, drawn transparent), and the light body
color goes in slot #1 (drawn as white in-game). The standard OW icons in
gfx/icons therefore use: white background, light "mustard" body color
(#ff9c52), dark color, black.

Some icons were instead authored menu-style, with a TRANSPARENT background
and only three opaque colors. With no real background color, the converter
shoves the lightest BODY color into slot #0 and the whole sprite turns
invisible in the overworld (menus hide the problem, since transparent over
a white textbox still looks white). Abra and Slowbro were like this.

For each PNG whose background (top-left pixel) is transparent, this script:
  1. recolors ENCLOSED transparent pixels (white details inside the body)
     to the icon's lightest opaque color, so they draw as white in-game
  2. converts the transparent background to opaque white
Icons that already have an opaque background are left completely untouched,
so it is safe to run over every file in gfx/icons.

Usage (from the repo root, inside WSL):
    python3 tools/fix_ow_icon_white.py gfx/icons/*.png

Requires Pillow. If missing:
    python3 -m pip install pillow --break-system-packages
"""
import sys
from collections import deque

try:
    from PIL import Image
except ImportError:
    sys.exit("Pillow is required: python3 -m pip install pillow --break-system-packages")

WHITE = (255, 255, 255, 255)


def luminance(c):
    r, g, b = c[:3]
    return 0.299 * r + 0.587 * g + 0.114 * b


def fix(path):
    img = Image.open(path).convert("RGBA")
    w, h = img.size
    px = img.load()

    bg = px[0, 0]
    if bg[3] != 0:
        print(f"{path}: opaque background; already OW-safe, skipped")
        return

    colors = {px[x, y] for y in range(h) for x in range(w)}
    opaque = [c for c in colors if c[3] == 255]
    if not opaque:
        print(f"{path}: no opaque colors?! skipped")
        return
    repl = max(opaque, key=luminance)
    if repl[:3] in ((255, 255, 255), (248, 248, 248)):
        print(f"{path}: WARNING: has opaque white body pixels; converting the "
              f"background to white will merge them with it (manual fix needed)")

    names = ", ".join(f"#{c[0]:02x}{c[1]:02x}{c[2]:02x}" +
                      ("(a%d)" % c[3] if c[3] != 255 else "")
                      for c in sorted(colors, key=luminance, reverse=True))
    print(f"{path}: transparent background, colors [{names}]")

    # Flood fill from the edges: transparent pixels reachable from the
    # border are true background.
    is_bg = [[False] * w for _ in range(h)]
    queue = deque()

    def seed(x, y):
        if px[x, y][3] == 0 and not is_bg[y][x]:
            is_bg[y][x] = True
            queue.append((x, y))

    for x in range(w):
        seed(x, 0)
        seed(x, h - 1)
    for y in range(h):
        seed(0, y)
        seed(w - 1, y)
    while queue:
        x, y = queue.popleft()
        for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if 0 <= nx < w and 0 <= ny < h and not is_bg[ny][nx] and px[nx, ny][3] == 0:
                is_bg[ny][nx] = True
                queue.append((nx, ny))

    # 1. Enclosed transparent pixels = white details inside the body.
    n = 0
    for y in range(h):
        for x in range(w):
            if px[x, y][3] == 0 and not is_bg[y][x]:
                px[x, y] = repl
                n += 1

    # 2. Remaining transparent pixels = real background -> opaque white.
    m = 0
    for y in range(h):
        for x in range(w):
            if px[x, y][3] == 0:
                px[x, y] = WHITE
                m += 1

    img.convert("RGB").save(path)
    print(f"{path}: fixed ({n} body pixel(s) -> "
          f"#{repl[0]:02x}{repl[1]:02x}{repl[2]:02x}, {m} background pixel(s) -> white)")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    for p in sys.argv[1:]:
        fix(p)
