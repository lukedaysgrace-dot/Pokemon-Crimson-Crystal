"""Final, source-backed corrections layered after older design receipts."""
from functools import lru_cache
import json
from pathlib import Path

PATH = Path(__file__).resolve().parent / 'testdata/historical_move_access.json'


@lru_cache(maxsize=1)
def review():
    return json.loads(PATH.read_text(encoding='utf-8')) if PATH.exists() else {}


def removed(species, route='level_up'):
    key = {'level_up': 'level_up_removals', 'tmhm': 'tmhm_removals',
           'egg': 'egg_removals', 'tutor': 'tutor_removals'}[route]
    return set(review().get('changes', {}).get(key, {}).get(species, []))


def retained(species, moves, route='level_up'):
    return set(moves) - removed(species, route)
