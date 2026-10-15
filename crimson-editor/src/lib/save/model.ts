import type { GameData } from '../gamedata/model';
import type { selectCopy } from './copies';
export interface Diagnostic {
  severity: 'ERROR' | 'WARN' | 'INFO';
  message: string;
  symbol: string;
  offset: number;
}
export interface Mon {
  raw: number[];
  species: number;
  item: number;
  moves: number[];
  pp: number[];
  ups: number[];
  id: number;
  exp: number;
  statExp: number[];
  dvs: number[];
  happiness: number;
  pokerus: number;
  caught: number[];
  level: number;
  personality: number;
  hpType: number;
  shiny: boolean;
  male: boolean;
  egg: boolean;
  nickname: string;
  ot: string;
  hp: number;
  status: number;
  stats: number[];
  bad: boolean;
  pointer?: { pool: number; entry: number };
  keepStats?: boolean;
}
export interface Box {
  name: string;
  theme: number;
  slots: (Mon | null)[];
  raw: number[];
}
export interface BagStack {
  item: number;
  quantity: number;
}
export interface SaveModel {
  original: Uint8Array;
  data: GameData;
  copies: ReturnType<typeof selectCopy>;
  diagnostics: Diagnostic[];
  party: Mon[];
  boxes: Box[];
  player: {
    name: string;
    rival: string;
    id: number;
    money: number;
    momsMoney: number;
    coins: number;
    character: number;
    blueCard: number;
  };
  bag: Record<string, BagStack[]>;
  tms: number[];
  dex: { caught: boolean[]; seen: boolean[] };
  rules: number;
  badges: number;
  hardMode: boolean;
  flags: Record<string, boolean>;
  daycare: {
    mon: Mon;
    active: boolean;
    symbol: string;
    nicknameSymbol?: string;
    otSymbol?: string;
  }[];
  debugCharacters: boolean;
  baseline: string;
}
export function semantic(m: SaveModel) {
  const { original, data, copies, diagnostics, baseline, ...rest } = m;
  return JSON.stringify(rest);
}
