import { expect, it } from 'vitest';
import { mergeProfile } from '../src/extractors/profiles';

it('retains older layouts when a ROM changes before a new source commit', () => {
  const previous = [{ id: '12345678', build: '12345678abcdef', date: '2026-10-19', layoutHash: 'old' }];
  const current = { ...previous[0], layoutHash: 'new' };
  const result = mergeProfile(previous, current, 4);
  expect(result.id).toBe('12345678-v4');
  expect(result.manifest.map((entry) => entry.id)).toEqual(['12345678-v4', '12345678']);
  expect(result.manifest[1].layoutHash).toBe('old');
  expect(mergeProfile(result.manifest, current, 4)).toEqual(result);
  const another = mergeProfile(result.manifest, { ...current, layoutHash: 'next123456' }, 4);
  expect(another.id).toBe('12345678-v4-next1234');
  expect(another.manifest).toHaveLength(3);
});
