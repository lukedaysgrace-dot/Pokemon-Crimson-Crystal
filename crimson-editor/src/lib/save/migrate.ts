import type { SaveModel } from './model';
import { template } from './mon';
import { write } from './write';
import { parse } from './parse';
/** Migrate into a real target save, retaining its map, events and other build-specific state. */
export function migrate(
  source: SaveModel,
  target: SaveModel,
): { bytes: Uint8Array; report: string[] } {
  if (!source.copies.source || !target.copies.source)
    throw new Error('Migration requires two valid saves.');
  const result = parse(write(target), target.data),
    report: string[] = [];
  const map = (
    from: { index: number; const: string }[],
    to: { index: number; const: string }[],
    id: number,
  ) => {
    if (!id) return 0;
    const constant = from.find((x) => x.index === id)?.const,
      found = to.find((x) => x.const === constant);
    if (!found) throw new Error(`Target build has no ${constant || id}`);
    return found.index;
  };
  function copyMon(mon: SaveModel['party'][number], box: boolean) {
    const species = map(source.data.species, target.data.species, mon.species);
    const copy = {
      ...JSON.parse(JSON.stringify(mon)),
      raw: template(target.data, result.player, box, result.rules).raw,
      pointer: undefined,
      species,
      item: map(source.data.items, target.data.items, mon.item),
      moves: mon.moves.map((n) => map(source.data.moves, target.data.moves, n)),
    };
    if (source.data.items.find((i) => i.index === mon.item)?.mail) {
      copy.item = 0;
      report.push(
        `Removed mail item from ${mon.nickname}; its message remains in the source save.`,
      );
    }
    return copy;
  }
  result.player = { ...source.player };
  result.rules = source.rules;
  result.hardMode = source.hardMode;
  result.badges = source.badges;
  result.party = source.party.map((m) => copyMon(m, false));
  result.boxes.forEach((box, i) => {
    const from = source.boxes[i];
    if (!from) return;
    box.name = from.name;
    box.theme = map(source.data.themes, target.data.themes, from.theme);
    box.slots = from.slots.map((m) => (m ? copyMon(m, true) : null));
  });
  for (const [pocket, stacks] of Object.entries(source.bag))
    result.bag[pocket] = stacks.map((s) => ({
      ...s,
      item: map(source.data.items, target.data.items, s.item),
    }));
  result.dex = {
    caught: Array(target.data.species.length).fill(false),
    seen: Array(target.data.species.length).fill(false),
  };
  for (const s of source.data.species) {
    const t = target.data.species.find((x) => x.const === s.const);
    if (t) {
      result.dex.caught[t.index - 1] = source.dex.caught[s.index - 1];
      result.dex.seen[t.index - 1] = source.dex.seen[s.index - 1];
    }
  }
  const oldTm = source.data.layout.constants.TM01,
    newTm = target.data.layout.constants.TM01;
  result.tms.fill(0);
  source.tms.forEach((v, i) => {
    const sourceItem = source.data.items.find((x) => x.index === oldTm + i),
      item = target.data.items.find((x) => x.const === sourceItem?.const);
    if (item && item.index - newTm < result.tms.length) result.tms[item.index - newTm] = v;
    else if (v) report.push(`TM/HM not mapped: ${sourceItem?.const}`);
  });
  report.push(
    'Map position, event/engine flags, options, daycare and unmodeled state retained from the target template.',
  );
  report.push(
    `Transferred ${result.party.length} party Pokémon and ${result.boxes.flatMap((b) => b.slots).filter(Boolean).length} boxed Pokémon by constants.`,
  );
  return { bytes: write(result), report };
}
