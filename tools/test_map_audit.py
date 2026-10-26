#!/usr/bin/env python3
"""Ensure imported collision tables and scripted entrances remain audited."""
from unittest.mock import patch

import audit_game_data as data


def main():
    audit = data.Audit()
    maps = data.audit_maps(audit)
    assert not audit.errors, '\n'.join(audit.errors)
    assert {'CERULEAN_CAVE_1F', 'CERULEAN_CAVE_2F', 'CERULEAN_CAVE_B1F'} <= maps.keys()

    original_read = data.read

    def without_gate(path):
        text = original_read(path)
        if path == data.ROOT / 'maps/Route4.asm':
            text = text.replace('coord_event 34, 3, -1, Route4CeruleanCaveEntrance', '')
        return text

    with patch.object(data, 'read', side_effect=without_gate):
        audit = data.Audit()
        data.audit_maps(audit)
        assert any('unassigned active warp collision (34, 3)' in error for error in audit.errors)

    collision = data.ROOT / 'data/tilesets/cerulean_cave_collision.bin'
    original_bytes = type(collision).read_bytes
    for blob, expected in ((b'\0', 'incomplete collision row'), (b'\0' * 4, 'rows for'),
                           (bytes([2]) * collision.stat().st_size, 'unknown collision bytes')):
        def changed_bytes(path):
            return blob if path == collision else original_bytes(path)

        with patch.object(type(collision), 'read_bytes', changed_bytes):
            audit = data.Audit()
            data.audit_maps(audit)
            assert any(expected in error for error in audit.errors), audit.errors
    print('MAP AUDIT: all maps, scripted gate removal, truncated and invalid binary collision checks passed')


if __name__ == '__main__':
    main()
