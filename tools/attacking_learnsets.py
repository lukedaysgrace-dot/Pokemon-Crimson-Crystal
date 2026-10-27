"""Final, explicit level-up edits from the attacking-role review."""
from functools import lru_cache
import json
from pathlib import Path

PATH = Path(__file__).resolve().parent / 'testdata/attacking_learnset_review.json'


@lru_cache(maxsize=1)
def review():
    return json.loads(PATH.read_text(encoding='utf-8')) if PATH.exists() else {}


def final_level(species, move, previous):
    from historical_move_access import removed
    if move in removed(species):
        return None
    return review().get('changes', {}).get(species, {}).get(move, {}).get('after', previous)


def removed(species):
    return {move for move, edit in review().get('changes', {}).get(species, {}).items()
            if edit['after'] is None}


def check_level(species, move, previous, levels):
    wanted = final_level(species, move, previous)
    actual = [lv for lv, m in levels[species] if m == move]
    assert actual == ([] if wanted is None else [wanted]), (species, move, actual, wanted)
