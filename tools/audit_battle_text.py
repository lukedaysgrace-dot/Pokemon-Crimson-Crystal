#!/usr/bin/env python3
"""Check that no battle message can overflow the textbox.

The battle textbox is 18 columns. A line is at risk when it holds something
whose width is not visible in the source:

  <USER> / <TARGET>   a nickname; on the enemy side PlaceMoveUsersName prints
  <ENEMY>             the EnemyText prefix first, so worst case is prefix + 11
  text_ram SYMBOL     a runtime buffer, whose contents depend on the call site
  <PLAYER> / <RIVAL>  a trainer name, PLAYER_NAME_LENGTH - 1

<ENEMY> is measured as a nickname. In a trainer battle PlaceEnemysName
prints the trainer's class and name instead, which this does not model.

Nickname widths follow from MON_NAME_LENGTH and the EnemyText prefix, so they
are computed, not assumed. Runtime buffers are resolved per message through
BUFFER_KIND below; each entry records what the engine loads before printing.
Every maximum is taken from the real name tables, so a green run means no
species, item, move or ability in the game can push a line onto the border.
"""
import re, sys, pathlib
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BOX = 18
SOURCES = ["data/text/battle.asm", "data/text/ability_text.asm"]

# Every routine that wipes a battle HUD name box must clear at least as many
# columns as the longest name, or the tail of the old name stays on screen.
# origin coordinate -> (files to scan, description)
HUD_BOXES = {"hlcoord 1, 0": "enemy HUD name box",
             "hlcoord 9, 7": "player HUD name box"}

# what the engine leaves in the buffer before each message is printed
BUFFER_KIND = {
    "item": """BattleText_TargetRecoveredWithItem BattleText_UserRecoveredPPUsing
        BattleText_UserFledUsingAStringBuffer1 RecoveredUsingText
        BattleText_UsersStringBuffer1Activated BattleText_ItemHealedConfusion
        BattleText_AssaultVestPreventsMove BattleText_ChoiceItemLocksMove
        AirBalloonImmuneText AirBalloonPoppedText RockyHelmetText
        BattleText_UsersHurtByStringBuffer1 HungOnText StoleText
        BattleText_UserWasReleasedFromStringBuffer1 BattleText_BurnedByItem
        BattleText_BadlyPoisonedByItem KnockedOffItemText ProtectedByText
        FriskedItemText AbilityItemActivatedText HarvestedBerryText""",
    "move": """DisabledMoveText HasNoPPLeftText SketchedText SpiteEffectText
        LearnedMoveText WasDisabledText CursedBodyDisabledText ForewarnAlertText""",
    "ability": "TraceActivationText IntimidateResistedText",
    "stat": "WontRiseAnymoreText WontDropAnymoreText",
    "type": "TransformedTypeText",
    "side": "BattleText_MonsLightScreenFell BattleText_MonsReflectFaded",
}
KIND = {lbl: k for k, names in BUFFER_KIND.items() for lbl in names.split()}

def longest(path, fallback):
    try: t = (ROOT / path).read_text(encoding="utf-8")
    except FileNotFoundError: return fallback
    names = [m.group(1).rstrip("@") for m in
             re.finditer(r'^\s*(?:raw)?(?:char|db)\s+"([^"]+)"', t, re.M)]
    return max((len(n) for n in names), default=fallback)

def main():
    txt  = (ROOT / "constants/text_constants.asm").read_text(encoding="utf-8")
    nick = int(re.search(r"^MON_NAME_LENGTH\s+EQU\s+(\d+)", txt, re.M).group(1)) - 1
    home = (ROOT / "home/text.asm").read_text(encoding="utf-8")
    m = re.search(r'^EnemyText::\s*db\s+"([^"]*)@"', home, re.M)
    prefix = len(m.group(1)) if m else 0
    side = prefix + nick                      # worst case for a name placeholder
    who  = int(re.search(r"^PLAYER_NAME_LENGTH\s+EQU\s+(\d+)", txt, re.M).group(1)) - 1

    WIDTH = {
        "nick": nick, "species": nick,
        "item": longest("data/items/names.asm", 12),
        "move": longest("data/moves/names.asm", 12),
        "ability": longest("data/abilities/names.asm", 16),
        "stat": longest("data/battle/stat_names.asm", 8),
        "type": 8, "side": len("Player"),
    }
    default = max(WIDTH.values())

    bad = []

    # ---- HUD clear widths -------------------------------------------------
    import glob as _glob
    for f in sorted(_glob.glob(str(ROOT / "engine/**/*.asm"), recursive=True)):
        lines = open(f, encoding="utf-8", errors="ignore").read().split("\n")
        for i, raw in enumerate(lines):
            for origin, what in HUD_BOXES.items():
                if raw.strip() != origin:
                    continue
                for j in range(i + 1, min(i + 3, len(lines))):
                    m = re.match(r"\s*lb bc, (\d+), (\d+)", lines[j])
                    if not m:
                        continue
                    cols = int(m.group(2))
                    if cols < nick:
                        rel = str(pathlib.Path(f).relative_to(ROOT))
                        bad.append(("HUD", rel, j + 1, what,
                                    f"lb bc, {m.group(1)}, {cols}",
                                    f"clears {cols} columns but names are up to {nick}"))
                    break

    # ---- battle text ------------------------------------------------------
    # text / text_start / text_ram / text_decimal continue the current rendered
    # line; line / cont / next / para begin a new one. Widths accumulate across
    # a run, so "<nick> ignored" is measured as one line, not two fragments.
    BREAK = ("line", "cont", "next", "para")
    for src in SOURCES:
        lines = (ROOT / src).read_text(encoding="utf-8").split("\n")
        label, width, why, start = None, 0, [], 0

        def flush():
            if width > BOX:
                bad.append((src, start, label, width, parts, ", ".join(why)))

        parts = ""
        for i, raw in enumerate(lines, 1):
            m = re.match(r"^(\w+):", raw)
            if m:
                flush(); label, width, why, parts = m.group(1), 0, [], ""
                continue
            d = re.match(r'^\s*(text|text_start|text_ram|text_decimal|line|cont|next|para)\b(.*)$', raw)
            if not d:
                if raw.strip() == "":
                    flush(); width, why, parts = 0, [], ""
                continue
            kindword, rest = d.group(1), d.group(2)
            if kindword in BREAK:
                flush(); width, why, parts = 0, [], ""
            if width == 0:
                start = i
            body = re.match(r'\s*"(.*)"\s*$', rest)
            if body:
                b = body.group(1)
                parts += b
                lit = re.sub(r"<(?:USER|TARGET|ENEMY|PLAYER|RIVAL)>", "", b).replace("@", "")
                width += len(lit.replace("#", "POKé"))
                n = len(re.findall(r"<(?:USER|TARGET|ENEMY)>", b))
                if n:
                    width += n * side; why.append(f"{n}x name={side}")
                t = len(re.findall(r"<(?:PLAYER|RIVAL)>", b))
                if t:
                    width += t * who; why.append(f"{t}x trainer={who}")
            elif kindword == "text_ram":
                sym = rest.split()[-1] if rest.split() else "?"
                kind = ("nick" if sym in ("wBattleMonNick", "wEnemyMonNick")
                        else KIND.get(label))
                w = WIDTH[kind] if kind else default
                width += w; parts += f"<{kind or sym}>"
                why.append(f"{kind or 'UNCLASSIFIED ' + sym}={w}")
            elif kindword == "text_decimal":
                digits = rest.split(",")[-1].strip()
                d2 = int(digits) if digits.isdigit() else 3
                width += d2; parts += "#" * d2; why.append(f"number={d2}")
        flush()

    if bad:
        print("BATTLE TEXT AUDIT FAILED")
        for kind, src, i, label, body, why in bad:
            verb = "renders up to" if kind == "TEXT" else "->"
            print(f"- {src}:{i}: {label} {verb} {why}")
            print(f'      {body!r}')
        print(f"{len(bad)} error(s)")
        return 1
    print(f"BATTLE TEXT AUDIT PASSED: every battle line fits {BOX} columns "
          f"(nickname {nick} + '{m.group(1) if m else ''}' prefix {prefix}; "
          f"item {WIDTH['item']}, move {WIDTH['move']}, ability {WIDTH['ability']})")
    return 0

if __name__ == "__main__":
    sys.exit(main())
