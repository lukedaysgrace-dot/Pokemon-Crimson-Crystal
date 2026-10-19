export interface Profile {
  id: string;
  build: string;
  date: string;
  layoutHash: string;
}

// Uncommitted ROM changes can share a Git commit with an older save layout.
// Keep those layouts available instead of overwriting their profile files.
export function mergeProfile(
  previous: Profile[],
  current: Omit<Profile, 'id'>,
  saveFormatVersion: number,
): { id: string; manifest: Profile[] } {
  const base = current.build.slice(0, 8);
  let id = previous.find(
    (entry) => entry.build === current.build && entry.layoutHash === current.layoutHash,
  )?.id || base;
  const conflicts = (candidate: string) => previous.some(
    (entry) => entry.id === candidate && entry.layoutHash !== current.layoutHash,
  );
  if (conflicts(id)) id = `${base}-v${saveFormatVersion}`;
  if (conflicts(id)) id += `-${current.layoutHash.slice(0, 8)}`;
  return {
    id,
    manifest: [{ ...current, id }, ...previous.filter((entry) => entry.id !== id)]
      .sort((a, b) => b.date.localeCompare(a.date)),
  };
}
