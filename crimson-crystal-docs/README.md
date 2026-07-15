# Crimson Crystal Documentation Generator

This creates a searchable, mobile-friendly website from the `Pokemon-Crimson-Crystal` source files.

## Install and generate

Copy this folder into the root of your repository, then run in WSL:

```bash
cd ~/romhacks/Pokemon-Crimson-Crystal
python3 -m pip install -r crimson-crystal-docs/requirements.txt
python3 crimson-crystal-docs/generate_docs.py .
```

The website is generated in `docs/`.

Preview it:

```bash
cd docs
python3 -m http.server 8000
```

Open `http://localhost:8000`.

## GitHub Pages

Commit the `docs` folder, then go to **GitHub → Settings → Pages**. Select **Deploy from a branch**, choose `main`, and choose `/docs`.

The initial site generates:

- Pokémon index with sprites pulled from `gfx/pokemon/*/front.png`
- Individual Pokémon pages
- Types, abilities, stats, BST, evolutions and level-up learnsets
- Move index and move detail pages
- Search and type filtering
- Wild encounter index for recognized pokecrystal-style encounter lines
- JSON exports and a build report

Because your project has substantial custom engine work, the parser is intentionally tolerant. The first real run may expose a few custom data formats that need an additional parser rule; it will still generate the rest of the site.


## Pokédex ordering and forms

- The Pokédex follows the first Pokémon constant block in `constants/pokemon_constants.asm` exactly.
- `EGG` and the three `?????` engine records are ignored.
- The nine clone starter constants are omitted from the Pokédex grid and appear through a **Normal / Clone** toggle on the corresponding starter page.
- Animated or multi-frame PNGs are cropped to the first complete static front frame.


## Encounter coverage and safety

The generator parses:

- Johto and Kanto grass/cave tables
- Johto and Kanto Surf tables
- Bug-Catching Contest tables
- Headbutt and Rock Smash sets through `treemon_maps.asm`
- Fishing groups only where an explicit map-to-`FISHGROUP_*` link is found
- Grass and water swarm tables
- Morning, day and night slots
- Slot chances and encounter rates where the source format provides them

It never pairs Pokémon and locations by Pokédex number, file position, or a guessed
filename. Unknown species, unknown shared groups, and malformed rows are written
to `docs/data/build-report.json`.

After any game-data change, rerun:

```bash
source .venv/bin/activate
python crimson-crystal-docs/generate_docs.py .
git add crimson-crystal-docs docs
git commit -m "Update documentation"
git push
```
