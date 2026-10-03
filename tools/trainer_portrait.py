#!/usr/bin/env python3
"""Convert an overworld trainer portrait PNG into the .portrait binary that
engine/events/trainer_portraits.asm streams into VRAM.

Input: gfx/trainer_portraits/<name>.png, 56x112. The top and bottom 56x56
halves are the two talking frames. Exactly four colours are expected: white,
black and two others (the two others borrow the middle colours of the text
palette, so white and black are shared with the textbox). Any extra colour is
merged into its nearest neighbour, with a warning.

The frame with its mouth closed becomes the resting frame. It is picked
automatically (the frame whose differing tiles have fewer black pixels; an
open mouth adds a dark interior). If the guess is wrong for a portrait, list
it in CLOSED_FRAME_OVERRIDES below (0 = top half, 1 = bottom half).

Output layout (see PORTRAIT_HEADER_SIZE in the engine):
	db  N                    ; number of tiles that change when talking (0-8)
	dw  color1, color2       ; RGB555, lighter then darker
	db  cell x 8             ; tile index (0-48, row-major) of each changing tile, $ff pad
	ds  (49 + N) * 16        ; 2bpp: the 49 resting tiles, then the N talking tiles

Usage: trainer_portrait.py in.png out.portrait
"""

import os
import struct
import sys
import zlib

WIDTH_TILES = 7
HEIGHT_TILES = 7
NUM_TILES = WIDTH_TILES * HEIGHT_TILES
MAX_MOUTH_TILES = 8

# name (file stem) -> index of the closed-mouth frame (0 = top, 1 = bottom)
CLOSED_FRAME_OVERRIDES = {
}


def read_png(path):
	"""Minimal PNG reader: 8-bit greyscale/RGB/RGBA/palette, non-interlaced."""
	with open(path, 'rb') as f:
		data = f.read()
	if data[:8] != b'\x89PNG\r\n\x1a\n':
		raise SystemExit(f'{path}: not a PNG')
	pos = 8
	idat = b''
	plte = None
	trns = None
	while pos < len(data):
		length, ctype = struct.unpack('>I4s', data[pos:pos + 8])
		chunk = data[pos + 8:pos + 8 + length]
		pos += 12 + length
		if ctype == b'IHDR':
			width, height, depth, color, _, _, interlace = struct.unpack('>IIBBBBB', chunk)
		elif ctype == b'PLTE':
			plte = [tuple(chunk[i:i + 3]) for i in range(0, len(chunk), 3)]
		elif ctype == b'tRNS':
			trns = chunk
		elif ctype == b'IDAT':
			idat += chunk
		elif ctype == b'IEND':
			break
	if interlace:
		raise SystemExit(f'{path}: interlaced PNGs are not supported')
	if depth != 8 and color != 3:
		raise SystemExit(f'{path}: only 8-bit PNGs are supported')
	channels = {0: 1, 2: 3, 3: 1, 4: 2, 6: 4}[color]
	bits_pp = depth * channels
	stride = (width * bits_pp + 7) // 8
	bpp = max(1, bits_pp // 8)
	raw = zlib.decompress(idat)
	rows = []
	prev = bytearray(stride)
	i = 0
	for _ in range(height):
		ftype = raw[i]
		line = bytearray(raw[i + 1:i + 1 + stride])
		i += 1 + stride
		for x in range(stride):
			a = line[x - bpp] if x >= bpp else 0
			b = prev[x]
			c = prev[x - bpp] if x >= bpp else 0
			if ftype == 1:
				line[x] = (line[x] + a) & 0xff
			elif ftype == 2:
				line[x] = (line[x] + b) & 0xff
			elif ftype == 3:
				line[x] = (line[x] + (a + b) // 2) & 0xff
			elif ftype == 4:
				p = a + b - c
				pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
				pr = a if pa <= pb and pa <= pc else (b if pb <= pc else c)
				line[x] = (line[x] + pr) & 0xff
		rows.append(line)
		prev = line
	pixels = []
	for line in rows:
		row = []
		for x in range(width):
			if color == 3:
				if depth == 8:
					idx = line[x]
				else:
					per = 8 // depth
					idx = (line[x // per] >> (8 - depth * (x % per + 1))) & ((1 << depth) - 1)
				r, g, b = plte[idx]
				alpha = trns[idx] if trns and idx < len(trns) else 255
			elif color == 0:
				r = g = b = line[x]
				alpha = 255
			elif color == 4:
				r = g = b = line[2 * x]
				alpha = line[2 * x + 1]
			elif color == 2:
				r, g, b = line[3 * x:3 * x + 3]
				alpha = 255
			else:
				r, g, b, alpha = line[4 * x:4 * x + 4]
			if alpha < 128:
				r = g = b = 0  # transparent pixels become the black backdrop
			row.append((r, g, b))
		pixels.append(row)
	return width, height, pixels


def luma(c):
	return c[0] * 299 + c[1] * 587 + c[2] * 114


def dist2(a, b):
	return sum((x - y) ** 2 for x, y in zip(a, b))


def main():
	if len(sys.argv) != 3:
		raise SystemExit(__doc__)
	src, dst = sys.argv[1], sys.argv[2]
	name = os.path.splitext(os.path.basename(src))[0]
	width, height, px = read_png(src)
	if (width, height) != (WIDTH_TILES * 8, HEIGHT_TILES * 8 * 2):
		raise SystemExit(f'{src}: expected {WIDTH_TILES * 8}x{HEIGHT_TILES * 16} (two stacked frames), got {width}x{height}')

	counts = {}
	for row in px:
		for c in row:
			counts[c] = counts.get(c, 0) + 1

	# White and black are fixed (shared with the textbox); keep the two most
	# common remaining colours and fold anything else into its nearest match.
	white = max(counts, key=luma)
	black = min(counts, key=luma)
	others = sorted((c for c in counts if c not in (white, black)), key=lambda c: -counts[c])
	if len(others) < 2:
		others += [white] * (2 - len(others))
	mids = sorted(others[:2], key=luma, reverse=True)  # lighter first
	keep = [white, mids[0], mids[1], black]
	index = {}
	for c in counts:
		if c in keep:
			index[c] = keep.index(c)
		else:
			nearest = min(range(4), key=lambda i: dist2(c, keep[i]))
			index[c] = nearest
			print(f'{src}: warning: merged {counts[c]} pixel(s) of colour {c} into {keep[nearest]}', file=sys.stderr)

	def tile(frame, n):
		ty, tx = divmod(n, WIDTH_TILES)
		x0, y0 = tx * 8, frame * HEIGHT_TILES * 8 + ty * 8
		return [[index[px[y0 + y][x0 + x]] for x in range(8)] for y in range(8)]

	frames = [[tile(f, n) for n in range(NUM_TILES)] for f in (0, 1)]
	cells = [n for n in range(NUM_TILES) if frames[0][n] != frames[1][n]]
	if len(cells) > MAX_MOUTH_TILES:
		raise SystemExit(f'{src}: {len(cells)} tiles differ between the frames; at most {MAX_MOUTH_TILES} may change')
	if 0 in cells:
		raise SystemExit(f'{src}: the top-left tile must be the same in both frames')

	if name in CLOSED_FRAME_OVERRIDES:
		closed = CLOSED_FRAME_OVERRIDES[name]
	else:
		def darkness(f):
			return sum(v == 3 for n in cells for row in frames[f][n] for v in row)
		def contrast(f):
			return sum(v in (0, 3) for n in cells for row in frames[f][n] for v in row)
		closed = 0
		if (darkness(1), contrast(1)) < (darkness(0), contrast(0)):
			closed = 1
	talking = 1 - closed

	def to_2bpp(t):
		out = bytearray()
		for row in t:
			lo = hi = 0
			for x, v in enumerate(row):
				lo |= (v & 1) << (7 - x)
				hi |= (v >> 1) << (7 - x)
			out += bytes((lo, hi))
		return out

	def rgb555(c):
		r, g, b = (v >> 3 for v in c)
		return r | (g << 5) | (b << 10)

	out = bytearray()
	out.append(len(cells))
	out += struct.pack('<HH', rgb555(mids[0]), rgb555(mids[1]))
	out += bytes(cells + [0xff] * (MAX_MOUTH_TILES - len(cells)))
	for n in range(NUM_TILES):
		out += to_2bpp(frames[closed][n])
	for n in cells:
		out += to_2bpp(frames[talking][n])
	with open(dst, 'wb') as f:
		f.write(out)


if __name__ == '__main__':
	main()
