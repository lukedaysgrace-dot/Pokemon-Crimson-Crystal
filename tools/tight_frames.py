#!/usr/bin/env python3
"""Push a textbox frame's lines out to the outer edge of its tiles.

Each frame in gfx/frames/ is 8 1bpp tiles: "┌" "─" "┐" "│" "└" "┘" "┃" "━".
As drawn, the lines sit a few pixels in from the outside of the box, leaving a
white margin around every textbox and menu. This shifts each side outwards by
however much blank space its edge tile has on the outside, so the box's outer
line is the edge of the box. The inside of the box is white anyway, so the
extra room just ends up inside.

Usage: tight_frames.py frame.1bpp   (rewritten in place; other sizes are left alone)
"""

import sys

TILE = 8


def to_grid(data):
	return [[(data[r] >> (7 - c)) & 1 for c in range(TILE)] for r in range(TILE)]


def to_bytes(grid):
	return bytes(sum(bit << (7 - c) for c, bit in enumerate(row)) for row in grid)


def blank_rows_top(g):
	n = 0
	while n < TILE and not any(g[n]):
		n += 1
	return n


def blank_rows_bottom(g):
	return blank_rows_top(g[::-1])


def blank_cols_left(g):
	n = 0
	while n < TILE and not any(row[n] for row in g):
		n += 1
	return n


def blank_cols_right(g):
	return blank_cols_left([row[::-1] for row in g])


def shift(g, dx, dy):
	out = [[0] * TILE for _ in range(TILE)]
	for r in range(TILE):
		for c in range(TILE):
			if g[r][c] and 0 <= r + dy < TILE and 0 <= c + dx < TILE:
				out[r + dy][c + dx] = 1
	return out


def fill(corner, edge, rows, cols):
	"""Copy the (already moved) edge tile into the strip of the corner tile its
	move left empty, so the straight part of the line still meets the edge."""
	for r in rows:
		for c in cols:
			corner[r][c] |= edge[r][c]


def main():
	path = sys.argv[1]
	data = open(path, 'rb').read()
	if len(data) != 8 * TILE:
		return
	tl, top, tr, left, bl, br, right, bottom = (to_grid(data[i * TILE:(i + 1) * TILE]) for i in range(8))

	# How far each side can move: the blank margin of its edge tile, but never
	# more than the corners have, so no line is cut off.
	up = min(blank_rows_top(top), blank_rows_top(tl), blank_rows_top(tr))
	down = min(blank_rows_bottom(bottom), blank_rows_bottom(bl), blank_rows_bottom(br))
	lft = min(blank_cols_left(left), blank_cols_left(tl), blank_cols_left(bl))
	rgt = min(blank_cols_right(right), blank_cols_right(tr), blank_cols_right(br))
	if TILE in (up, down, lft, rgt):
		return  # an empty edge tile; leave this frame as drawn

	top_s = shift(top, 0, -up)
	left_s = shift(left, -lft, 0)
	right_s = shift(right, rgt, 0)
	bottom_s = shift(bottom, 0, down)
	all_ = range(TILE)
	tl_s = shift(tl, -lft, -up)
	fill(tl_s, top_s, all_, range(TILE - lft, TILE))
	fill(tl_s, left_s, range(TILE - up, TILE), all_)
	tr_s = shift(tr, rgt, -up)
	fill(tr_s, top_s, all_, range(rgt))
	fill(tr_s, right_s, range(TILE - up, TILE), all_)
	bl_s = shift(bl, -lft, down)
	fill(bl_s, bottom_s, all_, range(TILE - lft, TILE))
	fill(bl_s, left_s, range(down), all_)
	br_s = shift(br, rgt, down)
	fill(br_s, bottom_s, all_, range(rgt))
	fill(br_s, right_s, range(down), all_)
	tiles = [tl_s, top_s, tr_s, left_s, bl_s, br_s, right_s, bottom_s]
	with open(path, 'wb') as f:
		f.write(b''.join(to_bytes(t) for t in tiles))


if __name__ == '__main__':
	main()
