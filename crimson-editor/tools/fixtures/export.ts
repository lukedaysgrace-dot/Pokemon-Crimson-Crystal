import { mkdirSync, writeFileSync } from 'node:fs';
import { fixture, game } from '../../tests/fixture';
import { parse } from '../../src/lib/save/parse';
import { write } from '../../src/lib/save/write';
import { template } from '../../src/lib/save/mon';
import { expAtLevel, maxPP } from '../../src/lib/save/mechanics';
mkdirSync('tests/output', { recursive: true });
const m = parse(fixture(), game),
  s = game.species.find((s) => s.const === 'JIRACHI')!;
const mon = m.party[0];
mon.species = s.index;
mon.nickname = 'CRIMSON';
mon.level = 73;
mon.exp = expAtLevel(game.growth[s.growth], mon.level);
mon.moves = ['DOOM_DESIRE', 'METEOR_MASH', 'PSYSHOCK', 'RECYCLE'].map(
  (constant) => game.moves.find((move) => move.const === constant)!.index,
);
mon.ups = [3, 1, 2, 0];
mon.pp = mon.moves.map((n, i) => maxPP(game.moves[n - 1].pp, mon.ups[i]));
mon.shiny = true;
mon.male = true;
mon.hpType = game.layout.constants.HIDDEN_POWER_DEFAULT_TYPE;
const egg = template(game, m.player, false, 0);
egg.egg = true;
egg.happiness = 5;
m.party.push(egg);
const ghostMoves = ['HORN_LEECH', 'SHADOW_CLAW', 'WOOD_HAMMER', 'WILL_O_WISP'].map(
  (constant) => game.moves.find((move) => move.const === constant)!.index,
);
for (const constant of ['PHANTUMP', 'TREVENANT']) {
  const added = template(game, m.player, false, m.rules);
  added.species = game.species.find((species) => species.const === constant)!.index;
  added.moves = [...ghostMoves];
  added.ups = [0, 1, 2, 3];
  added.pp = added.moves.map((id, slot) => maxPP(game.moves[id - 1].pp, added.ups[slot]));
  added.personality = (added.personality & 159) | (3 << 5);
  added.shiny = constant === 'TREVENANT';
  m.party.push(added);
}
for (let i = 0; i < m.boxes.length; i++) {
  const boxed = template(game, m.player, true, 0);
  boxed.species = game.species.find((species) => species.const === ['JIRACHI', 'PHANTUMP', 'TREVENANT'][i % 3])!.index;
  boxed.moves = i % 3 === 0 ? [...mon.moves] : [...ghostMoves];
  boxed.ups = [...mon.ups];
  boxed.shiny = true;
  boxed.male = true;
  boxed.hpType = mon.hpType;
  boxed.pointer = { pool: i < 12 ? 1 : 2, entry: 144 + i };
  m.boxes[i].slots[i % 20] = boxed;
}
const bytes = write(m),
  expected = parse(bytes, game);
writeFileSync('tests/output/edited.sav', bytes);
writeFileSync(
  'tests/output/edited.json',
  JSON.stringify(
    {
      party: expected.party.map((m) => ({
        species: m.species,
        moves: m.moves,
        level: m.level,
        egg: m.egg,
        shiny: m.shiny,
      })),
      boxes: expected.boxes.flatMap((b, box) =>
        b.slots.flatMap((m, slot) =>
          m
            ? [
                {
                  box: box + 1,
                  slot: slot + 1,
                  species: m.species,
                  moves: m.moves,
                  shiny: m.shiny,
                  egg: m.egg,
                },
              ]
            : [],
        ),
      ),
    },
    null,
    2,
  ),
);
console.log('Exported edited synthetic fixture and emulator expectations.');
