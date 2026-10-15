export function container(input: Uint8Array) {
  if (input.length === 32768)
    throw new Error(
      'Your emulator does not support 64 KiB MBC30 SRAM; boxes in banks 3–6 are missing.',
    );
  if (input.length < 65536 || input.length > 65600)
    throw new Error(`Expected 65,536 bytes plus up to 64 RTC bytes; got ${input.length}.`);
  return { sram: input.slice(0, 65536), trailer: input.slice(65536) };
}
