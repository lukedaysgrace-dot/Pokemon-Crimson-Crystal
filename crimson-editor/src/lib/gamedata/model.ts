export interface Region {
  options: number;
  check1: number;
  start: number;
  end: number;
  gameEnd: number;
  monTable: number;
  moveTable: number;
  convChecksum: number;
  checksum: number;
  check2: number;
}
export interface TableParams {
  entries: number;
  reservedMin: number;
  size: number;
}
export interface Layout {
  layoutHash: string;
  build: string;
  date: string;
  romHash: string;
  sram: Record<string, number>;
  wram: Record<string, number>;
  constants: Record<string, number>;
  main: Region;
  backup: Region;
  party: Record<string, number>;
  boxed: Record<string, number>;
  newbox: Record<string, number>;
  tables: { mon: TableParams; move: TableParams };
}
export interface Entry {
  const: string;
  index: number;
  name: string;
  description?: string;
}
export interface Species extends Entry {
  stats: number[];
  originalStats: number[];
  types: number[];
  originalTypes: number[];
  gender: number;
  growth: number;
  abilities: number[];
  eggCycles: number;
  catchRate: number;
  baseExp: number;
  heldItems: number[];
  eggGroups: number[];
  tutor: number[];
  tmhm: number[];
  levelMoves: { level: number; move: number }[];
  eggMoves: number[];
  evolutions: { method: number; args: number[]; target: number }[];
  sprite: string;
  frontPic: string;
  spriteSource: string;
}
export interface Move extends Entry {
  power: number;
  type: number;
  category: number;
  accuracy: number;
  pp: number;
  effect: number;
  effectChance: number;
}
export interface Item extends Entry {
  pocket: number;
  price: number;
  mail: boolean;
  move?: number;
}
export interface GameData {
  layout: Layout;
  species: Species[];
  moves: Move[];
  items: Item[];
  abilities: Entry[];
  types: Entry[];
  themes: Entry[];
  balls: Entry[];
  landmarks: Entry[];
  characters: Entry[];
  charmap: Record<string, number>;
  keyboard: string[];
  boxKeyboard: string[];
  growth: { a: number; b: number; c: number; d: number; e: number }[];
  flags: { const: string; symbol: string; offset: number; mask: number; kind: string }[];
  caps: number[];
}
