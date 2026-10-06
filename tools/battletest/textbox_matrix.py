"""Repeat every move and both sides of every ability with full-width names."""

from ability_sweep import generate_ability_tests
from move_sweep import generate_move_smoke_tests


def generate_textbox_matrix():
    tests = generate_move_smoke_tests()
    tests += [test for test in generate_ability_tests()
              if test["name"].endswith("move execution")]
    for test in tests:
        test["name"] = "Textbox matrix: " + test["name"]
        # Post-entry setup requires the pre-turn pause, even for move smoke
        # cases whose ordinary variants omit their snapshot.
        test["snapshot"] = True
        # Ten visible glyphs plus terminator. W has the same tile width as
        # every other battle-text glyph. Trainer targets add the longest
        # enemy prefix; both sides exercise USER and TARGET substitutions.
        test.setdefault("setup_wram", {}).update(
            wBattleMonNick=[0x96] * 10 + [0x50],
            wEnemyMonNick=[0x96] * 10 + [0x50])
        if "Move smoke" in test["name"]:
            test["enemy2"] = {"species": "LUGIA", "level": 100,
                              "ability": "NO_ABILITY", "moves": ["SPLASH"]}
            test["enemy_class"] = "FALKNER"
        test["_file"] = "<generated maximum-name textbox matrix>"
    return tests
