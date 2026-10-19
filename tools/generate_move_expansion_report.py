#!/usr/bin/env python3
"""Generate the complete approved October move distribution for reviewers."""
import json
import re
from pathlib import Path
from audit_breeding_moves import breeding_data
from audit_learnset_variety import load_technical_tutors

ROOT = Path(__file__).resolve().parents[1]


def main():
    receipt = json.loads((ROOT/'tools/testdata/move_expansion_20261019.json').read_text())
    order, levels, _, eggs, parents, *_ = breeding_data()
    tutors = load_technical_tutors()
    title = lambda s: s.replace('_', ' ').title()
    lines = ['# Move expansion — 19 October 2026', '',
        '18 moves were appended at indices 422–439; all older move indices are unchanged.',
        'The full roster review produced 378 approved recipient pairs, including clone mirrors and explicitly approved custom placements.', '',
        '## References', '',
        f'- [Official Smogon Strategy Pokédex](https://www.smogon.com/dex/sv/moves/) and [Smogon learnsets](https://github.com/smogon/pokemon-showdown/blob/{receipt["smogon_revision"]}/data/learnsets.ts), frozen after the SV DLC and before Legends Z-A.',
        f'- [Team Lumi documentation](https://luminescent.team/docs/features) and [Lumi 3.0 game data](https://github.com/TeamLumi/luminescent-team/tree/{receipt["lumi_revision"]}/__gamedata/gamedata3.0). Lumi direct level-up schedules take priority; direct Smogon level-up sources fill gaps.',
        '- Custom species suggestions, Lanturn Tail Glow, Lumi power buffs, accuracy overrides and immediate Doom Desire follow the user’s explicit choices. “Cosmic powder” is implemented as Cosmic Power.', '',
        '## Mechanics and overrides', '',
        '| Move | Power | Accuracy | PP |', '|---|---:|---:|---:|']
    for line in (ROOT/'data/moves/moves.asm').read_text().splitlines():
        m=re.match(r'\s*move (.*?);(\w+)$',line)
        if m and m[2] in receipt['moves']:
            v=[x.strip() for x in m[1].split(',')]
            lines.append(f'| {title(m[2])} | {v[1]} | {v[4]}% | {v[5]} |')
    lines += ['', '- Psyshock uses Special Attack against Defense. Fur Coat and Marvel Scale follow the targeted defensive stat.',
        '- Vacuum Wave has +1 priority. Sky Uppercut can hit Fly/Bounce and is a punch; Meteor Mash is also a punch.',
        '- Discharge has 30% paralysis; Lava Plume has 30% burn. Meteor Mash has a 20% Attack raise. Blaze Kick and Poison Tail have high critical rates and 10% status chances. Ominous Wind has a 10% five-stat boost.',
        '- Cotton Guard raises Defense three stages; Tail Glow raises Special Attack three. Contrary inverts the full raise and stages cap at +6 / −6. Cosmic Power raises both defenses one stage.',
        '- Eruption and Water Spout use max(1, floor(150 × current HP / maximum HP)); Technician sees the calculated power.',
        '- Doom Desire strikes immediately as a special Steel move. It uses the same consecutive-use restriction as Giga Hammer; another move or switching clears that restriction.',
        '- Recycle restores the last consumed held item when empty-handed. History survives switching in the same battle. Removed/destroyed items do not create a recovery record. Harvest, Cud Chew, Klutz and Unburden use the real item state.',
        '- Petal Blizzard and Ominous Wind are noncontact wind moves; Wind Rider applies.', '',
        '## Distribution policy', '',
        'Direct source levels are natural learnset additions; supported root egg sources are breeding additions. Remaining eligible moves use the existing paid Blackthorn tutor. Goldenrod utility compatibility and all prior access are preserved.',
        'Cotton Guard on Hoppip and Recycle on both Voltorb forms lack an independent usable local breeding donor. Each receives the project’s level-30 first-stage fallback as well as its verified egg-list entry.',
        'Watu receives Psyshock and Cosmic Power; Mesmeria receives Psyshock; Kotora, Raitora, Gorotora and Gorochu receive Discharge. These are authored custom-species placements. Ampharos has Tail Glow at level 1 (reminder); Lanturn learns it at 40.', '',
        '## Complete approved recipients and routes', '']
    def route(c, move):
        direct=[str(lv) for lv,m in levels[c] if m==move]
        parts=['level '+', '.join(direct)] if direct else []
        if move in eggs[c]: parts.append('breeding / egg tutor')
        if move in tutors[c]: parts.append('Blackthorn tutor')
        if not parts: parts.append('retain through evolution')
        return '; '.join(parts)
    for move in receipt['moves']:
        slug=move.lower().replace('_','-')
        lines += [f'### {title(move)}', '',
            f'[Smogon move reference](https://www.smogon.com/dex/sv/moves/{slug}/)', '',
            '| Pokémon | Acquisition |', '|---|---|']
        for c in order:
            if move in receipt['required'].get(c,[]):
                lines.append(f'| {title(c)} | {route(c,move)} |')
        lines.append('')
    lines += ['## Animation provenance', '',
        '- [Polished Coral](https://github.com/pkmncoraldev/polishedcoral/tree/72506dc41e19f948af74ad53827bff7de7e14ab7): Psyshock, Dragon Hammer, Cotton Guard, Cosmic Power, Ominous Wind and Petal Blizzard.',
        '- [Mae Pokeorange](https://github.com/PiaCarrot/mae-pokeorange/tree/83db98aec1a0ccf50e78f8b38e37b8427ba310bb): Meteor Mash, Eruption, Water Spout, Doom Desire, Tail Glow, Recycle, Blaze Kick, Sky Uppercut and Poison Tail.',
        '- Orange’s Vacuum Wave, Discharge and Lava Plume entries were empty stubs. These three were rebuilt against the user-supplied GBC recordings: Vacuum Wave uses a fist, shrinking pressure rings and impact on the target; Discharge builds a blinking black/gray orb into a larger black/cyan orb with lightning radiating from the user; Lava Plume surrounds the user with staggered radial flames, trailing embers, black stippled smoke and light flashes. Its short fire sounds finish with the plume instead of delaying battle control. Reference hashes and observed phases are recorded in tools/testdata/move_animation_references_20261019.json.',
        '- Imported objects, framesets, OAM sets and palettes use isolated identifiers. Cotton Guard’s inward radial callback and Sky Uppercut’s continuous 15-pixel wind callback were adapted. Eruption’s rising/falling lava rocks explicitly use the imported lava graphics.',
        '- Animation follow-up: corrected imported graphics bindings and Recycle’s full-frame tile layout/eight-phase rotation. Staggered Blaze Kick and Petal Blizzard particles to avoid the ten-object limit. Updated HUD-clearing rectangles to prevent HP-border fragments in Cosmic Power. The earlier three custom substitute animations were superseded after comparison with the supplied recordings. Standalone recordings include VBlank recovery frames before holding the restored battle screen.', '',
        '## Save editor and compatibility', '',
        'Jirachi (index 496), its normal/shiny art, all 439 moves, current learnsets and tutor compatibility are extracted from the built ROM. Party conversion tables and boxed 16-bit move indices support every new move.',
        'Save format 3 accounts for the two-byte event-area increase introduced by Jirachi/Wishing Star. Previous format-2 profiles remain bundled. The editor migrates into a new-build save template: map/event progress comes from that template, while Pokémon, inventory and supported player fields transfer.', '',
        '## Verification', '',
        'Run tools/audit_move_expansion.py, make test-learnsets, make test-complete, the 202 focused new-move battles and 36 player/opponent animation previews. Editor checks cover Jirachi and all new moves in party and boxed round trips; a native ROM fixture loads Jirachi with its new moves.',
        'tools/battletest/october_animation_checks.py additionally decodes the linked ROM’s frames/OAM, compares uploaded VRAM with the required graphics at object creation and throughout object lifetimes, checks particle drops and movement, and verifies all eight assembled Recycle phases against the original sprite sheet. Visual timelines cover all 18 moves from both sides. tools/battletest/reference_move_showcase.py produces a private comparison with the supplied clips using the same Squirtle/Hoothoot scene. Technical checks alone do not establish visual fidelity; the earlier substitutes passed rendering checks but did not match the references.', '',
        'The machine-readable evidence and placements are in tools/testdata/move_expansion_20261019.json.', '']
    (ROOT/'tools/testdata/move-expansion-2026-10-19.md').write_text('\n'.join(lines),encoding='utf-8')


if __name__=='__main__':
    main()

