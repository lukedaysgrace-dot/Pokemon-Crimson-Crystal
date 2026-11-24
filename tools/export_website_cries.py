#!/usr/bin/env python3
"""Record the website's Pokémon cries from a freshly built ROM and its symbols."""

import argparse
import io
import json
from pathlib import Path
import re
import struct
import wave

import numpy as np
from pyboy import PyBoy


ROOT = Path(__file__).resolve().parents[1]
SAMPLE_RATE = 32768


def read_symbols(path):
    return {
        name: (int(bank, 16), int(address, 16))
        for bank, address, name in re.findall(
            r'^([0-9a-f]+):([0-9a-f]+)\s+(\S+)', path.read_text(), re.MULTILINE
        )
    }


def cry_indexes(rom, symbols):
    constants = (ROOT / 'constants/cry_constants.asm').read_text()
    cry_names = re.findall(r'^\s*const (CRY_\w+)', constants, re.MULTILINE)
    cry_ids = {name: i for i, name in enumerate(cry_names)}
    source = (ROOT / 'data/pokemon/cries.asm').read_text()
    rows = re.findall(r'^\s*mon_cry\s+(\w+),\s*([^,]+),\s*([^;]+);\s*(\w+)', source, re.M)
    bank, address = symbols['PokemonCries']
    offset = bank * 0x4000 + (address & 0x3fff)
    indexes = {}
    for index, (cry, pitch, length, species) in enumerate(rows):
        pitch_word = int(pitch.strip().replace('$', '0x'), 0) & 0xffff
        length_word = int(length.strip().replace('$', '0x'), 0) & 0xffff
        expected = (cry_ids[cry], pitch_word, length_word)
        if struct.unpack_from('<3H', rom, offset + index * 6) != expected:
            raise ValueError(f'ROM cry data for {species} differs from source. Rebuild the ROM.')
        indexes[species] = index
    return indexes


def record_cry(emulator, symbols, index):
    def call(name):
        return [0xcd, *symbols[name][1].to_bytes(2, 'little')]

    memory = emulator.memory
    # Run just the native audio routines. The VBlank handler advances the sound
    # engine at the game's own frame rate while the CPU waits between updates.
    memory[0, 0x40:0x44] = [*call('UpdateSound'), 0xd9]
    memory[0xff50] = 1  # disable boot ROM
    memory[0xff40] = 0x80  # enable LCD and its frame timing
    memory[0xffff] = 1  # enable VBlank only
    memory[0xff0f] = 0
    memory[0x2000] = 1
    memory[symbols['hROMBank'][1]] = 1
    memory[0xc000:0xc00e] = [
        0xf3, *call('MapSetup_Sound_Off'),        # DI and reset audio engine
        0x11, *index.to_bytes(2, 'little'),      # LD DE, species table index
        *call('PlayCry'), 0xfb, 0x76, 0x18, 0xfd,  # EI, HALT, JR back to HALT
    ]
    emulator.register_file.SP = 0xcfff
    emulator.register_file.PC = 0xc000
    channels = [symbols[f'wChannel{i}Flags1'][1] for i in range(5, 9)]

    frames = []
    started = False
    for _ in range(1200):
        emulator.tick(1, False, True)
        frames.append(emulator.sound.ndarray.copy())
        if any(memory[address] & 1 for address in channels):
            started = True
        elif started:
            # Capture the rest of the frame in which the last channel was muted.
            emulator.tick(1, False, True)
            frames.append(emulator.sound.ndarray.copy())
            break
    else:
        raise ValueError(f'Cry at species index {index} did not finish')

    mono = np.concatenate(frames).astype(np.int16).sum(axis=1) // 2
    audible = np.flatnonzero(mono)
    if not len(audible):
        raise ValueError(f'Cry at species index {index} is silent')
    start = max(0, audible[0] - SAMPLE_RATE // 200)
    return (mono[start:] + 128).astype(np.uint8).tobytes()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom', type=Path, default=ROOT / 'pokecrystal.gbc')
    args = parser.parse_args()
    symbols = read_symbols(args.rom.with_suffix('.sym'))
    indexes = cry_indexes(args.rom.read_bytes(), symbols)
    docs = ROOT / 'docs'
    pokemon = json.loads((docs / 'data/pokemon.json').read_text(encoding='utf-8'))
    sprites = {
        Path(form['sprite']).stem: indexes[form['const']]
        for entry in pokemon
        for form in entry.get('forms', {'normal': entry}).values()
    }
    output = docs / 'assets/cries'
    output.mkdir(exist_ok=True)

    emulator = PyBoy(
        str(args.rom), window='null', cgb=True, sound_sample_rate=SAMPLE_RATE, log_level='ERROR'
    )
    emulator.set_emulation_speed(0)
    initial = io.BytesIO()
    emulator.save_state(initial)
    try:
        for sprite, index in sorted(sprites.items()):
            initial.seek(0)
            emulator.load_state(initial)
            samples = record_cry(emulator, symbols, index)
            with wave.open(str(output / f'{sprite}.wav'), 'wb') as clip:
                clip.setparams((1, 1, SAMPLE_RATE, 0, 'NONE', 'not compressed'))
                clip.writeframes(samples)
    finally:
        emulator.stop(save=False)
    print(f'Recorded {len(sprites)} Pokémon cries in {output}')


if __name__ == '__main__':
    main()
