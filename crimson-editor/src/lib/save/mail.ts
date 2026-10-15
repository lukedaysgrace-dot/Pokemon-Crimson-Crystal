import type { GameData } from '../gamedata/model';
import type { Mon } from './model';
import { encode } from './text';
import { setBE16 } from './bytes';
/** Blank, valid mail using offsets from the linked mailmsg symbols. */
export function blankMail(g: GameData, mon: Mon, runtimeSpecies: number): Uint8Array {
  const s = g.layout.sram,
    start = s.sPartyMon1Mail;
  const length = s.sPartyMon1MailEnd - start,
    result = new Uint8Array(length);
  const offset = (name: string) => s['sPartyMon1Mail' + name] - start;
  result.fill(g.charmap['@'], offset('Message'), offset('MessageEnd') + 1);
  result.set(
    encode(
      mon.ot,
      offset('AuthorNationality') - offset('Author'),
      g.layout.constants.PLAYER_NAME_LENGTH - 1,
      g.charmap,
    ),
    offset('Author'),
  );
  setBE16(result, offset('AuthorID'), mon.id);
  result[offset('Species')] = runtimeSpecies;
  result[offset('Type')] = mon.item;
  return result;
}
