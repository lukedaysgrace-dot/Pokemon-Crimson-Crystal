"""Toolkit for authoring the Elite Four chamber tilesets.

A room is painted as a full-size picture: every pixel holds a colour index
(0-3) and every 8x8 cell holds one of the seven room palettes (0-6).  The
builder slices the picture into 8x8 tiles (deduplicated with X/Y flips),
4x4-tile blocks (deduplicated together with their collision), and writes
the tileset PNG, metatiles, attributes, collision table, palette and map
blocks in the formats this engine already uses.
"""
import os, subprocess, json, tempfile
from pathlib import Path
import numpy as np
from PIL import Image

ROOT = str(Path(__file__).resolve().parents[2]) + '/'
OUT = ROOT + '_artifacts/league-rooms-art/'

TEXT_PAL = [(31, 31, 16), (31, 31, 16), (14, 9, 0), (0, 0, 0)]


class Canvas:
    def __init__(self, wt, ht):
        self.wt, self.ht = wt, ht
        self.px = np.zeros((ht * 8, wt * 8), np.uint8)
        self.pal = np.zeros((ht, wt), np.int8)
        self.prio = np.zeros((ht, wt), bool)   # BG-over-sprite priority (attr bit 7)
        self.coll = [['WALL'] * (wt // 2) for _ in range(ht // 2)]

    # ---- pixel drawing -------------------------------------------------
    def inb(self, x, y):
        return 0 <= x < self.wt * 8 and 0 <= y < self.ht * 8

    def pset(self, x, y, c):
        if self.inb(x, y):
            self.px[y, x] = c

    def rect(self, x, y, w, h, c):
        x0, y0 = max(x, 0), max(y, 0)
        x1, y1 = min(x + w, self.wt * 8), min(y + h, self.ht * 8)
        if x1 > x0 and y1 > y0:
            self.px[y0:y1, x0:x1] = c

    def hline(self, x, y, w, c):
        self.rect(x, y, w, 1, c)

    def vline(self, x, y, h, c):
        self.rect(x, y, 1, h, c)

    def frame(self, x, y, w, h, c):
        self.hline(x, y, w, c); self.hline(x, y + h - 1, w, c)
        self.vline(x, y, h, c); self.vline(x + w - 1, y, h, c)

    def stamp(self, x, y, rows, flipx=False, flipy=False, cmap=None):
        """rows: list of strings; digits 0-3 are colours, anything else is
        transparent.  cmap may remap digit characters."""
        if flipy:
            rows = rows[::-1]
        for j, r in enumerate(rows):
            if flipx:
                r = r[::-1]
            for i, ch in enumerate(r):
                if cmap and ch in cmap:
                    c = cmap[ch]
                elif ch in '0123':
                    c = int(ch)
                else:
                    continue
                if c is None:
                    continue
                self.pset(x + i, y + j, c)

    def tex(self, x, y, w, h, rows, ox=0, oy=0, cmap=None):
        """Fill a rectangle with a periodic pattern aligned to absolute
        coordinates (shifted by ox/oy)."""
        ph, pw = len(rows), len(rows[0])
        for yy in range(max(y, 0), min(y + h, self.ht * 8)):
            r = rows[(yy + oy) % ph]
            for xx in range(max(x, 0), min(x + w, self.wt * 8)):
                ch = r[(xx + ox) % pw]
                if cmap and ch in cmap:
                    c = cmap[ch]
                elif ch in '0123':
                    c = int(ch)
                else:
                    continue
                if c is not None:
                    self.px[yy, xx] = c

    def mirror_x(self, x0, x1):
        """Copy left half [x0, mid) mirrored onto the right half (pixels,
        palettes are mirrored separately with mirror_pal_x)."""
        w = x1 - x0
        for i in range(w // 2):
            self.px[:, x1 - 1 - i] = self.px[:, x0 + i]

    def mirror_pal_x(self):
        for i in range(self.wt // 2):
            self.pal[:, self.wt - 1 - i] = self.pal[:, i]
            self.prio[:, self.wt - 1 - i] = self.prio[:, i]

    def mirror_coll_x(self):
        w = self.wt // 2
        for row in self.coll:
            for i in range(w // 2):
                row[w - 1 - i] = row[i]

    # ---- palette / collision ------------------------------------------
    def setpal(self, tx, ty, tw, th, p):
        self.pal[max(ty, 0):ty + th, max(tx, 0):tx + tw] = p

    def walk(self, sx, sy, sw=1, sh=1, kind='FLOOR'):
        for y in range(sy, sy + sh):
            for x in range(sx, sx + sw):
                if 0 <= y < len(self.coll) and 0 <= x < len(self.coll[0]):
                    self.coll[y][x] = kind

    def mirror_all(self):
        self.mirror_x(0, self.wt * 8)
        self.mirror_pal_x()

    def copy(self):
        c = Canvas(self.wt, self.ht)
        c.px = self.px.copy(); c.pal = self.pal.copy(); c.prio = self.prio.copy()
        c.coll = [r[:] for r in self.coll]
        return c


def tile2bpp(t):
    out = bytearray()
    for y in range(8):
        lo = hi = 0
        for x in range(8):
            v = int(t[y, x])
            lo |= (v & 1) << (7 - x)
            hi |= ((v >> 1) & 1) << (7 - x)
        out += bytes([lo, hi])
    return bytes(out)


def cell(canvas, tx, ty):
    return canvas.px[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8].copy()


def tile_key(arr):
    return arr.tobytes()


class Builder:
    """Collects tiles and blocks for one tileset."""

    def __init__(self, name):
        self.name = name
        self.tiles = []        # list of 8x8 arrays (image order, excluding the gap)
        self.tile_index = {}   # bytes -> (img_index, flipx, flipy)
        self.blocks = []       # list of (meta16, attr16, coll4)
        self.block_index = {}
        self.forced = {}       # (tx, ty) -> private animated tile (see build_room)
        self.forced_canvas = None

    def add_tile(self, arr):
        variants = [(arr, 0, 0), (arr[:, ::-1], 1, 0), (arr[::-1, :], 0, 1), (arr[::-1, ::-1], 1, 1)]
        for v, fx, fy in variants:
            k = tile_key(np.ascontiguousarray(v))
            if k in self.tile_index:
                idx, a, b = self.tile_index[k]
                # stored tile seen through flip (fx,fy) equals arr
                return idx, fx, fy
        idx = len(self.tiles)
        if idx == 127:                 # bank 0 $7f is never loaded
            self.tiles.append(np.zeros((8, 8), np.uint8))
            idx = 128
        self.tiles.append(arr.copy())
        self.tile_index[tile_key(np.ascontiguousarray(arr))] = (idx, 0, 0)
        return idx, 0, 0

    def add_block(self, canvas, bx, by, coll=None):
        meta, attr = [], []
        for j in range(4):
            for i in range(4):
                tx, ty = bx * 4 + i, by * 4 + j
                arr = canvas.px[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8]
                if (tx, ty) in self.forced and canvas is self.forced_canvas:
                    idx, fx, fy = self.forced[tx, ty]
                else:
                    idx, fx, fy = self.add_tile(arr)
                p = int(canvas.pal[ty, tx])
                assert 0 <= p <= 7, (self.name, tx, ty, p)
                if idx >= 128:
                    t, bank = idx - 128, 1
                else:
                    t, bank = idx, 0
                meta.append(t)
                attr.append(p | (bank << 3) | (fx << 5) | (fy << 6) | (0x80 if canvas.prio[ty, tx] else 0))
        if coll is None:
            coll = (canvas.coll[by * 2][bx * 2], canvas.coll[by * 2][bx * 2 + 1],
                    canvas.coll[by * 2 + 1][bx * 2], canvas.coll[by * 2 + 1][bx * 2 + 1])
        key = (tuple(meta), tuple(attr), tuple(coll))
        if key not in self.block_index:
            self.block_index[key] = len(self.blocks)
            self.blocks.append(key)
        return self.block_index[key]

    def ntiles(self):
        return len(self.tiles) - (1 if len(self.tiles) > 127 else 0)


def check_palettes(canvas, pals, name):
    """Every 8x8 cell must only use colour indices; nothing to check about
    count since indices are 0-3 by construction.  Report cells with
    unassigned palette (-1)."""
    bad = np.argwhere(canvas.pal < 0)
    assert len(bad) == 0, (name, bad[:5])


def build_room(name, mapname, canvas, pals, border, extra_blocks, out_preview=None, anims=None, pal_anims=None):
    """canvas: full room; border: Canvas 4x4 tiles for block 0;
    extra_blocks: dict label -> (Canvas, bx, by) single blocks to register.
    Returns dict with block ids of extras."""
    check_palettes(canvas, pals, name)
    b = Builder(name)
    b.forced_canvas = canvas
    border_id = b.add_block(border, 0, 0, coll=('WALL',) * 4)
    assert border_id == 0
    # animated tiles are registered first so they land in VRAM bank 0
    anim_info = []
    for a in (anims or []):
        if 'cells' in a:
            # a private animated tile: it is never shared with other cells by
            # image, so several tiles can show the same picture yet animate
            # on their own timings. Listed cells (or their mirror images) use it.
            first = np.asarray(a['frames'][a['seq'][0]], np.uint8)
            idx = len(b.tiles)
            assert idx < 127, (name, a['name'], idx)
            b.tiles.append(first.copy())
            for (tx, ty) in a['cells']:
                cell = canvas.px[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8]
                if (cell == first).all():
                    b.forced[tx, ty] = (idx, 0, 0)
                elif (cell == first[:, ::-1]).all():
                    b.forced[tx, ty] = (idx, 1, 0)
                else:
                    raise AssertionError((name, a['name'], (tx, ty), 'cell must show the first frame'))
            n = len(a['seq'])
            assert n & (n - 1) == 0 and n <= 256, (name, a['name'], 'sequence length must be a power of two, at most 256')
            anim_info.append(dict(name=a['name'], tile=idx, seq=list(a['seq']), shift=a['shift'],
                                  frames=[tile2bpp(np.asarray(f, np.uint8)).hex() for f in a['frames']]))
            continue
        tx, ty = a['cell']
        cell = np.ascontiguousarray(canvas.px[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8])
        first = np.asarray(a['frames'][a['seq'][0]], np.uint8)
        assert (cell == first).all(), (name, a['name'], 'canvas cell must show the first frame')
        n = len(a['seq'])
        assert n & (n - 1) == 0 and n <= 256, (name, a['name'], 'sequence length must be a power of two, at most 256')
        for v in (cell, cell[:, ::-1], cell[::-1, :], cell[::-1, ::-1]):
            assert tile_key(np.ascontiguousarray(v)) not in b.tile_index, (name, a['name'], 'animated tile already used')
        idx, fx, fy = b.add_tile(cell)
        assert idx < 127 and not fx and not fy, (name, a['name'], idx)
        anim_info.append(dict(name=a['name'], tile=idx, seq=list(a['seq']), shift=a['shift'],
                              frames=[tile2bpp(np.asarray(f, np.uint8)).hex() for f in a['frames']]))
    bw, bh = canvas.wt // 4, canvas.ht // 4
    blk = []
    for by in range(bh):
        for bx in range(bw):
            blk.append(b.add_block(canvas, bx, by))
    extras = {}
    for label, (cv, bx, by) in extra_blocks.items():
        extras[label] = b.add_block(cv, bx, by)
    # ---- write outputs ----
    n = len(b.tiles)
    rows = (n + 15) // 16
    img = np.zeros((rows * 8, 128), np.uint8)
    for i, t in enumerate(b.tiles):
        img[(i // 16) * 8:(i // 16) * 8 + 8, (i % 16) * 8:(i % 16) * 8 + 8] = t
    gray = np.array([255, 170, 85, 0], np.uint8)[img]
    Image.fromarray(gray, 'L').save(ROOT + 'gfx/tilesets/%s.png' % name)
    with open(ROOT + 'data/tilesets/%s_metatiles.bin' % name, 'wb') as f:
        for m, a, c in b.blocks:
            f.write(bytes(m))
    with open(ROOT + 'data/tilesets/%s_attributes.bin' % name, 'wb') as f:
        for m, a, c in b.blocks:
            f.write(bytes(a))
    with open(ROOT + 'data/tilesets/%s_collision.asm' % name, 'w') as f:
        for i, (m, a, c) in enumerate(b.blocks):
            f.write('\ttilecoll %s ; %02x\n' % (', '.join(c), i))
    with open(ROOT + 'gfx/tilesets/%s.pal' % name, 'w') as f:
        labels = ['0', '1', '2', '3', '4', '5', '6', 'text']
        allp = list(pals[:7]) + [TEXT_PAL]
        for i, p in enumerate(allp):
            f.write('\tRGB %s ; %s\n' % (', '.join('%02d,%02d,%02d' % c for c in p), labels[i]))
    with open(ROOT + 'maps/%s.ablk' % mapname, 'wb') as f:
        f.write(bytes(blk))
    # size report
    tiles2bpp = bytearray()
    for t in b.tiles:
        for y in range(8):
            lo = hi = 0
            for x in range(8):
                v = int(t[y, x])
                lo |= (v & 1) << (7 - x)
                hi |= ((v >> 1) & 1) << (7 - x)
            tiles2bpp += bytes([lo, hi])
    lz = 0
    lzcomp = ROOT + 'tools/lzcomp'
    if os.path.exists(lzcomp):
        with tempfile.TemporaryDirectory() as d:
            tmp = os.path.join(d, name + '.2bpp')
            open(tmp, 'wb').write(tiles2bpp)
            subprocess.run([lzcomp, '--', tmp, tmp + '.lz'], check=True, capture_output=True)
            lz = os.path.getsize(tmp + '.lz')
    info = dict(name=name, tiles=b.ntiles(), blocks=len(b.blocks), lz=lz,
                blockbytes=len(b.blocks) * 36, total=lz + len(b.blocks) * 36, extras=extras, anims=anim_info, pal_anims=list(pal_anims or []))
    print(json.dumps(info))
    os.makedirs(OUT, exist_ok=True)
    json.dump(info, open(OUT + '%s.json' % name, 'w'))
    if out_preview:
        preview(canvas, pals, out_preview)
    return info


WATERFALL_PNG = ROOT + 'gfx/tilesets/league/waterfall.png'


def waterfall_frame(frame=0):
    """16x8 indices of one waterfall animation frame (left + right tile)."""
    im = np.array(Image.open(WATERFALL_PNG).convert('L'))
    idx = {255: 0, 170: 1, 85: 2, 0: 3}
    a = np.vectorize(lambda v: idx[int(v)])(im)
    return a[frame * 8:frame * 8 + 8, 0:16].astype(np.uint8)


W2 = (30, 28, 26)   # Gen 2 indoor highlight white
K2 = (7, 7, 7)      # Gen 2 outline / darkest shade


def rgb(c):
    return tuple(v * 255 // 31 for v in c)


def preview(canvas, pals, out, scale=3, coll=False):
    allp = list(pals[:7]) + [TEXT_PAL]
    h, w = canvas.px.shape
    img = np.zeros((h, w, 3), np.uint8)
    for ty in range(canvas.ht):
        for tx in range(canvas.wt):
            p = allp[int(canvas.pal[ty, tx])]
            cell = canvas.px[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8]
            for ci in range(4):
                img[ty * 8:ty * 8 + 8, tx * 8:tx * 8 + 8][cell == ci] = rgb(p[ci])
    im = Image.fromarray(img, 'RGB')
    if coll:
        from PIL import ImageDraw
        d = ImageDraw.Draw(im, 'RGBA')
        for sy, row in enumerate(canvas.coll):
            for sx, k in enumerate(row):
                if k != 'FLOOR':
                    col = (255, 0, 0, 70) if k == 'WALL' else (0, 255, 0, 90)
                    d.rectangle([sx * 16, sy * 16, sx * 16 + 15, sy * 16 + 15], fill=col)
    im = im.resize((w * scale, h * scale), Image.NEAREST)
    im.save(out)
    return im


# ---------------------------------------------------------------------------
# Shape masks and automatic Gen-2 style shading
# ---------------------------------------------------------------------------
def clean_mask(m):
    """Tidy a rasterised shape the way a pixel artist would: drop one-pixel
    nubs, then remove the convex 'L' corner pixels along diagonal edges so the
    outline becomes a clean 8-connected staircase without doubled steps."""
    m = m.copy()
    for _ in range(2):
        n4 = (_shift(m, 1, 0).astype(int) + _shift(m, -1, 0) + _shift(m, 0, 1) + _shift(m, 0, -1))
        m &= ~(m & (n4 <= 1))
    edge = m & ~(_shift(m, 1, 0) & _shift(m, -1, 0) & _shift(m, 0, 1) & _shift(m, 0, -1))
    N, S, E, W = _shift(edge, 0, 1), _shift(edge, 0, -1), _shift(edge, -1, 0), _shift(edge, 1, 0)
    count = N.astype(int) + S + E + W
    remove = np.zeros_like(m)
    for (a, b, dx, dy) in ((N, E, 1, -1), (N, W, -1, -1), (S, E, 1, 1), (S, W, -1, 1)):
        diag_inside = _shift(m, -dx, -dy)
        remove |= edge & a & b & (count == 2) & diag_inside
    return m & ~remove


def convexify(m):
    """Clean pixel-art curve for a convex blob (ellipse, arch top): every
    row stays one run, and the step sizes along each side shrink steadily
    towards the widest rows (big steps at the ends, single steps at the
    sides), so there are no uneven 1-2-1 kinks. Non-convex masks are
    returned unchanged."""
    rows = [y for y in range(m.shape[0]) if m[y].any()]
    if len(rows) < 3:
        return m
    xs0, xs1 = {}, {}
    for y in rows:
        xs = np.flatnonzero(m[y])
        if xs[-1] - xs[0] + 1 != len(xs):
            return m
        xs0[y], xs1[y] = int(xs[0]), int(xs[-1])
    if rows[-1] - rows[0] + 1 != len(rows):
        return m
    # a lone 1-pixel nub at the very top/bottom of a round shape reads as a spike
    for end, nxt in ((rows[0], rows[1]), (rows[-1], rows[-2])):
        if xs1[end] == xs0[end] and xs1[nxt] - xs0[nxt] >= 4:
            m = m.copy()
            m[end] = False
            rows.remove(end)
    width = {y: xs1[y] - xs0[y] for y in rows}
    top = max(width.values())
    band = [y for y in rows if width[y] == top]
    ea, eb = band[0], band[-1]
    out = np.zeros_like(m)
    lo, hi = dict(xs0), dict(xs1)
    up = list(range(rows[0], ea + 1))
    down = list(range(eb, rows[-1] + 1))
    def tidy(d):
        """d: per-row horizontal steps along one side, walking from the end
        of the blob towards its widest row. Group into (step, rows-without-
        a-step) pairs, then make the steps shrink and the vertical runs
        grow, as a well-drawn pixel curve does."""
        lead = 0
        while lead < len(d) and d[lead] == 0:
            lead += 1
        groups = []
        for v in d[lead:]:
            if v:
                groups.append([v, 0])
            else:
                groups[-1][1] += 1
        hs = sorted((g[0] for g in groups), reverse=True)
        vs = sorted(g[1] for g in groups)
        out_ = [0] * lead
        for h_, v_ in zip(hs, vs):
            out_ += [h_] + [0] * v_
        return out_

    for side, sign in ((lo, 1), (hi, -1)):
        d = [sign * (side[up[i]] - side[up[i + 1]]) for i in range(len(up) - 1)]
        if any(v < 0 for v in d):
            return m
        d = tidy(d)                      # walk from the top row down
        for i in range(len(up) - 2, -1, -1):
            side[up[i]] = side[up[i + 1]] + sign * d[i]
        d = [sign * (side[down[i + 1]] - side[down[i]]) for i in range(len(down) - 1)]
        if any(v < 0 for v in d):
            return m
        d = tidy(d[::-1])[::-1]          # walk from the bottom row up
        for i in range(1, len(down)):
            side[down[i]] = side[down[i - 1]] + sign * d[i - 1]
    for y in rows:
        out[y, lo[y]:hi[y] + 1] = True
    return out


def band(m, t):
    """Outer band of a convex shape, exactly t pixels thick all the way
    round (two separately drawn ellipses leave a band that thickens and
    thins, which reads as wobbly)."""
    inner = m.copy()
    for _ in range(int(t)):
        inner = inner & _shift(inner, 1, 0) & _shift(inner, -1, 0) & _shift(inner, 0, 1) & _shift(inner, 0, -1)
    return m & ~convexify(inner)


def emask(canvas_or_shape, cx, cy, rx, ry):
    h, w = canvas_or_shape
    yy, xx = np.mgrid[0:h, 0:w]
    return convexify(((xx - cx) / max(rx, 0.01)) ** 2 + ((yy - cy) / max(ry, 0.01)) ** 2 <= 1.0)


def rmask(shape, x, y, w, h):
    m = np.zeros(shape, bool)
    m[max(y, 0):y + h, max(x, 0):x + w] = True
    return m


def pmask(shape, pts):
    """Polygon mask (even-odd), points as (x, y) pixel centres."""
    h, w = shape
    from PIL import ImageDraw
    im = Image.new('1', (w, h), 0)
    ImageDraw.Draw(im).polygon(pts, fill=1, outline=1)
    # polygons are authored with clean slopes (1:1, 1:2, 2:1), which the
    # plain raster already steps evenly
    return np.array(im, bool)


def _shift(m, dx, dy):
    out = np.zeros_like(m)
    h, w = m.shape
    ys = slice(max(dy, 0), h + min(dy, 0)); yd = slice(max(-dy, 0), h + min(-dy, 0))
    xs = slice(max(dx, 0), w + min(dx, 0)); xd = slice(max(-dx, 0), w + min(-dx, 0))
    out[ys, xs] = m[yd, xd]
    return out


def shade(cv, m, base=1, light=0, dark=2, outline=3, ldx=-1, ldy=-1, hl=1, sh=1,
          do_outline=True):
    """Paint mask m onto canvas cv with an outline and bevel lighting from
    direction (ldx, ldy) (towards the light)."""
    inner = m.copy()
    if do_outline:
        edge = m & ~(_shift(m, 1, 0) & _shift(m, -1, 0) & _shift(m, 0, 1) & _shift(m, 0, -1))
        inner = m & ~edge
        cv.px[edge] = outline
    cv.px[inner] = base
    if light is not None:
        cur = inner.copy()
        for _ in range(hl):
            lit = cur & ~_shift(inner, -ldx if ldx else 0, -ldy if ldy else 0) if False else None
            # pixels whose neighbour toward the light is outside the inner mask
            nb = np.ones_like(inner)
            if ldx: nb &= _shift(inner, -ldx, 0)
            if ldy: nb &= _shift(inner, 0, -ldy)
            lit = cur & ~nb
            cv.px[lit] = light
            cur = cur & ~lit
            inner_l = cur
    if dark is not None:
        cur = inner.copy()
        for _ in range(sh):
            nb = np.ones_like(inner)
            if ldx: nb &= _shift(inner, ldx, 0)
            if ldy: nb &= _shift(inner, 0, ldy)
            dk = cur & ~nb
            cv.px[dk] = dark
            cur = cur & ~dk


def dither(cv, m, c1, c2, phase=0):
    yy, xx = np.mgrid[0:m.shape[0], 0:m.shape[1]]
    chk = ((xx + yy + phase) % 2) == 0
    cv.px[m & chk] = c1
    cv.px[m & ~chk] = c2


def full(cv):
    return cv.px.shape


def edge_of(m):
    return m & ~(_shift(m, 1, 0) & _shift(m, -1, 0) & _shift(m, 0, 1) & _shift(m, 0, -1))

shift = _shift


def rock_pattern(seed, w=32, h=32, n=7, light=0, base=1, dark=2, line=3, jitter=0.0):
    """Periodic chunky-rock texture (list of strings) built from a wrapped
    Voronoi diagram with Gen-2 style edge lighting."""
    rng = np.random.RandomState(seed)
    pts = rng.rand(n, 2) * [w, h]
    yy, xx = np.mgrid[0:h, 0:w]
    best = np.full((h, w), 1e9); lab = np.zeros((h, w), int)
    for i, (px, py) in enumerate(pts):
        for ox in (-w, 0, w):
            for oy in (-h, 0, h):
                d = (xx - px - ox) ** 2 + ((yy - py - oy) * 1.25) ** 2
                upd = d < best
                best[upd] = d[upd]; lab[upd] = i
    out = np.full((h, w), base, int)
    def L(x, y):
        return lab[y % h, x % w]
    for y in range(h):
        for x in range(w):
            me = lab[y, x]
            if L(x + 1, y) != me or L(x, y + 1) != me:
                out[y, x] = line
            elif L(x - 1, y) != me or L(x, y - 1) != me:
                out[y, x] = light
            elif L(x + 2, y) != me or L(x, y + 2) != me:
                out[y, x] = dark
    return [''.join(str(v) for v in row) for row in out]


def lump_pattern(lumps, w=16, h=16, base=1, light=0, dark=2, line=3, bg=2):
    """Gen-2 style rounded rock lumps on a wrapping w x h tile.
    lumps: list of (cx, cy, rx, ry)."""
    c = Canvas(w // 8 * 3, h // 8 * 3)
    c.px[:] = bg
    shp = c.px.shape
    for (cx, cy, rx, ry) in lumps:
        for ox in (0, w, 2 * w):
            for oy in (0, h, 2 * h):
                m = emask(shp, cx + ox, cy + oy, rx, ry)
                shade(c, m, base=base, light=light, dark=dark, outline=line)
    sub = c.px[h:2 * h, w:2 * w]
    return [''.join(str(v) for v in row) for row in sub]


def flame_frames(w=16, h=8, n=4, seed=1, outer=2, mid=1, core=0, bg=3, height=1.0, x0=0):
    """Gen-2 style flickering flame frames (list of h x w arrays).
    Colours: outer/mid/core flame layers on bg."""
    rng = np.random.RandomState(seed)
    phases = rng.rand(3) * 6.28
    frames = []
    for f in range(n):
        a = np.full((h, w), bg, np.uint8)
        t = f * 6.283 / n
        for x in range(w):
            d = abs(x - (w - 1) / 2) / (w / 2)
            base = h * height * max(0.0, 1 - d ** 1.5)
            tongue = (1.5 * np.sin(x * 0.9 + t + phases[0]) + 0.9 * np.sin(x * 1.7 - 2 * t + phases[1])
                      + 0.5 * np.sin(x * 0.5 + 3 * t + phases[2]))
            hx = base * 0.8 + tongue * (1 - d * 0.6) * h / 8
            if d > 0.92:
                hx = min(hx, 1)
            for k in range(h):
                y = h - 1 - k
                if k < hx:
                    depth = hx - k
                    if depth > max(2.5, hx * 0.55) and d < 0.4:
                        v = core
                    elif depth > 1.4 and d < 0.8:
                        v = mid
                    else:
                        v = outer
                    a[y, x] = v
        frames.append(a)
    return frames


def stamp_array(canvas, x, y, arr, skip=None):
    h, w = arr.shape
    for j in range(h):
        for i in range(w):
            v = int(arr[j, i])
            if skip is not None and v == skip:
                continue
            canvas.pset(x + i, y + j, v)


def sprite_png(path, frame=0, size=16, mapping=None):
    """Read one frame of an overworld sprite sheet from the game's own
    assets as colour indices (0 = transparent white ... 3 = black)."""
    im = Image.open(path)
    if im.mode == 'P':
        pal = im.getpalette()
        a = np.array(im)
        lum = {i: sum(pal[i * 3:i * 3 + 3]) for i in set(a.flatten().tolist())}
        order = sorted(lum, key=lambda i: -lum[i])
        rank = {c: order.index(c) for c in order}
        a = np.vectorize(lambda v: rank[v])(a)
    else:
        g = np.array(im.convert('L'))
        a = 3 - np.round(g / 85).astype(int)
    out = a[frame * size:(frame + 1) * size, 0:size].astype(np.uint8)
    if mapping:
        out = np.vectorize(lambda v: mapping.get(int(v), int(v)))(out).astype(np.uint8)
    return out
