#!/usr/bin/env python3
"""Reorder complete 16x16 frames in a freshly compiled GB 2bpp sprite sheet."""
import argparse
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('sheet', type=Path)
    parser.add_argument('order', type=int, nargs='+')
    args = parser.parse_args()
    data = args.sheet.read_bytes()
    frame_bytes = 4 * 16
    if len(data) != len(args.order) * frame_bytes:
        parser.error('The frame order must cover the complete 2bpp sheet')
    if sorted(args.order) != list(range(len(args.order))):
        parser.error('The frame order must use each frame exactly once')
    args.sheet.write_bytes(b''.join(data[i * frame_bytes:(i + 1) * frame_bytes] for i in args.order))


if __name__ == '__main__':
    main()
