<script lang="ts">
  import { onMount } from 'svelte';
  import { base } from '$app/paths';
  import type { GameData } from '$lib/gamedata/model';
  import type { SaveModel, Mon } from '$lib/save/model';
  import { parse, detect } from '$lib/save/parse';
  import { write } from '$lib/save/write';
  import { validate } from '$lib/save/validate';
  import { template } from '$lib/save/mon';
  import { stats, maxPP } from '$lib/save/mechanics';
  import { migrate } from '$lib/save/migrate';
  import MonEditor from '$lib/components/MonEditor.svelte';
  import '../style.css';
  type Profile = { id: string; build: string; date: string; layoutHash: string };
  const websiteRoot = base.endsWith('/editor') ? base.slice(0, -'/editor'.length) : null;
  let profiles = $state<Profile[]>([]),
    bundles = $state<GameData[]>([]),
    model = $state<SaveModel | null>(null),
    uploaded: Uint8Array | null = null;
  let filename = $state('crimson.sav'),
    error = $state(''),
    loading = $state(true),
    tab = $state('Party'),
    index = $state(0),
    boxIndex = $state(0),
    slotIndex = $state(0),
    flagSearch = $state(''),
    dexSearch = $state(''),
    pocket = $state('items'),
    hexSymbol = $state('sSaveData'),
    debug = $state(false),
    report = $state(''),
    showWarnings = $state(false),
    warningAccepted = $state(false),
    targetBox = $state(0),
    targetSlot = $state(0);
  const diagnostics = $derived(model ? validate(model) : []),
    errors = $derived(diagnostics.filter((d) => d.severity === 'ERROR')),
    warnings = $derived(diagnostics.filter((d) => d.severity === 'WARN'));
  const activeMon = $derived(
    model ? (tab === 'Party' ? model.party[index] : model.boxes[boxIndex]?.slots[slotIndex]) : null,
  );
  const selected = $derived(
    model ? profiles.find((p) => p.build === model?.data.layout.build)?.id || '' : '',
  );
  onMount(async () => {
    try {
      const res = await fetch(`${base}/gamedata/manifest.json`);
      if (!res.ok) throw new Error('Game-data manifest is missing. Run pnpm extract.');
      profiles = await res.json();
      bundles = await Promise.all(
        profiles.map(async (p) => {
          const r = await fetch(`${base}/gamedata/${p.id}.json`);
          if (!r.ok) throw new Error(`Missing build ${p.id}`);
          return r.json();
        }),
      );
    } catch (e) {
      error = String(e);
    } finally {
      loading = false;
    }
  });
  function load(bytes: Uint8Array, override?: GameData) {
    try {
      const data = override || detect(bytes, bundles) || bundles[0];
      if (!data) throw new Error('No build profiles available.');
      model = parse(bytes, data);
      uploaded = bytes;
      index = 0;
      boxIndex = 0;
      slotIndex = 0;
      error = '';
      report = '';
      warningAccepted = false;
      tab = model.copies.source ? 'Party' : 'Diagnostics';
    } catch (e) {
      error = String(e);
      model = null;
    }
  }
  async function upload(event: Event) {
    const file = (event.currentTarget as HTMLInputElement).files?.[0];
    if (file) {
      filename = file.name.replace(/\.(sav|bak|srm|ram)$/i, '') + '.sav';
      load(new Uint8Array(await file.arrayBuffer()));
    }
  }
  function downloadBytes(
    bytes: Uint8Array | string,
    name: string,
    type = 'application/octet-stream',
  ) {
    const blob = new Blob([typeof bytes === 'string' ? bytes : new Uint8Array(bytes)], { type });
    const url = URL.createObjectURL(blob),
      a = document.createElement('a');
    a.href = url;
    a.download = name;
    a.click();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  }
  function save() {
    if (!model) return;
    if (warnings.length && !warningAccepted) {
      showWarnings = true;
      return;
    }
    try {
      const output = write(model);
      downloadBytes(output, filename);
      report = 'Save verified and ready to download.';
      error = '';
    } catch (e) {
      error = String(e);
    }
  }
  function addMon(box = false) {
    if (!model) return;
    const m = template(model.data, model.player, box, model.rules);
    if (box) {
      model.boxes[boxIndex].slots[slotIndex] = m;
    } else {
      model.party.push(m);
      index = model.party.length - 1;
    }
  }
  function deleteMon() {
    if (!model) return;
    if (tab === 'Party') {
      model.party.splice(index, 1);
      index = Math.max(0, index - 1);
    } else model.boxes[boxIndex].slots[slotIndex] = null;
  }
  function exportMon(yaml = false) {
    if (!model || !activeMon) return;
    const g = model.data,
      m = activeMon,
      constant = (rows: { index: number; const: string }[], n: number) =>
        rows.find((x) => x.index === n)?.const || String(n);
    downloadBytes(
      yaml
        ? `species: ${constant(g.species, m.species)}\nlevel: ${m.level}\nability_slot: ${(m.personality >>> 5) & 3 || 1}\nitem: ${constant(g.items, m.item)}\nmoves: [${m.moves
            .filter(Boolean)
            .map((n) => constant(g.moves, n))
            .join(', ')}]\n`
        : JSON.stringify(m, null, 2),
      yaml ? 'pokemon.yaml' : 'pokemon.json',
      'text/plain',
    );
  }
  async function importMon(e: Event) {
    const file = (e.currentTarget as HTMLInputElement).files?.[0];
    if (!file || !model) return;
    try {
      const candidate = JSON.parse(await file.text());
      const boxed = tab === 'Boxes',
        fresh = template(model.data, model.player, boxed, model.rules);
      for (const key of Object.keys(fresh) as (keyof Mon)[])
        if (!['raw', 'pointer', 'bad'].includes(key) && key in candidate)
          Object.assign(fresh, { [key]: candidate[key] });
      const scratch = parse(write(model), model.data);
      if (boxed) scratch.boxes[boxIndex].slots[slotIndex] = fresh;
      else scratch.party[index] = fresh;
      write(scratch);
      if (boxed) model.boxes[boxIndex].slots[slotIndex] = fresh;
      else model.party[index] = fresh;
      error = '';
    } catch (e) {
      error = `Import rejected: ${e}`;
    }
  }
  function heal() {
    if (!model) return;
    for (const m of model.party) {
      const s = model.data.species.find((s) => s.index === m.species);
      if (s) {
        m.stats = stats(s, m.dvs, m.statExp, m.level, model.rules);
        m.hp = m.stats[0];
        m.status = 0;
        m.pp = m.moves.map((n, i) =>
          maxPP(model!.data.moves.find((m) => m.index === n)?.pp || 0, m.ups[i]),
        );
      }
    }
  }
  function setFlag(name: string, value: boolean) {
    if (!model) return;
    model.flags[name] = value;
    const f = model.data.flags.find((x) => x.const === name);
    if (f?.symbol === 'wStatusFlags2' && f.mask === 8) model.hardMode = value;
    if (f?.symbol === 'wGameplayRules')
      model.rules = (model.rules & ~f.mask) | (value ? f.mask : 0);
    if (f?.symbol === 'wJohtoBadges' || f?.symbol === 'wKantoBadges') {
      const mask = f.mask << (f.symbol === 'wJohtoBadges' ? 8 : 0);
      model.badges = (model.badges & ~mask) | (value ? mask : 0);
    }
  }
  function moveSlot() {
    if (!model || tab !== 'Boxes' || (targetBox === boxIndex && targetSlot === slotIndex)) return;
    const source = model.boxes[boxIndex].slots[slotIndex];
    model.boxes[boxIndex].slots[slotIndex] = model.boxes[targetBox].slots[targetSlot];
    model.boxes[targetBox].slots[targetSlot] = source;
    boxIndex = targetBox;
    slotIndex = targetSlot;
  }
  async function migrateTo(e: Event) {
    const file = (e.currentTarget as HTMLInputElement).files?.[0];
    if (!file || !model) return;
    try {
      const bytes = new Uint8Array(await file.arrayBuffer()),
        data = detect(bytes, bundles);
      if (!data) throw new Error('Target template has no valid matching build.');
      const result = migrate(model, parse(bytes, data));
      downloadBytes(result.bytes, 'crimson-migrated.sav');
      report = result.report.join(' ');
      error = '';
    } catch (e) {
      error = String(e);
    }
  }
  function hex() {
    if (!model) return '';
    const l = model.data.layout,
      offset = l.sram[hexSymbol];
    if (offset === undefined) return 'Select an SRAM symbol';
    let current: Uint8Array;
    try {
      current = write(model);
    } catch {
      current = model.original;
    }
    return Array.from({ length: 16 }, (_, row) => {
      const p = offset + row * 16;
      return `${p.toString(16).padStart(5, '0')}  ${Array.from(current.slice(p, p + 16))
        .map(
          (v, i) => `${v.toString(16).padStart(2, '0')}${v !== model!.original[p + i] ? '*' : ' '}`,
        )
        .join(' ')}`;
    }).join('\n');
  }
</script>

<svelte:head
  ><title>Crimson Editor</title><meta
    name="description"
    content="Private, local save editing and diagnostics for Pokémon Crimson Crystal."
  /></svelte:head
>
<main>
  <header>
    <a class="brand" href={websiteRoot !== null ? `${websiteRoot}/index.html` : base || '/'}
      ><span class="crystal">◆</span>
      <div>CRIMSON <b>EDITOR</b><small>Pokémon Crimson Crystal</small></div></a
    ><span class="privacy">Local processing · your save stays on this device</span>
  </header>
  {#if websiteRoot !== null}
    <nav class="site-nav" aria-label="Main navigation">
      <a href={`${websiteRoot}/pokedex.html`}>Pokédex</a>
      <a href={`${websiteRoot}/moves.html`}>Moves</a>
      <a href={`${websiteRoot}/items.html`}>Items</a>
      <a href={`${websiteRoot}/encounters.html`}>Encounters</a>
      <a href={`${websiteRoot}/locations.html`}>Locations</a>
      <a href={`${websiteRoot}/changes.html`}>Pokémon Changes</a>
      <a href={`${websiteRoot}/updates.html`}>Game Updates</a>
      <a href={`${base}/index.html`} aria-current="page">Save Editor</a>
    </nav>
  {/if}
  <section class="hero" class:loaded={!!model}>
    <h1>Save Editor</h1>
    <p>Edit your team, organize your boxes, and inspect your save.</p>
    <label class="upload"
      >{loading ? 'Loading game data…' : model ? 'Open another save' : 'Open a save file'}<input
        aria-label="Open save file"
        type="file"
        accept=".sav,.bak,.srm,.ram"
        onchange={upload}
        disabled={loading}
      /></label
    ><span class="muted">Supports .sav, .bak, .srm and .ram files.</span>
  </section>
  {#if error}<div role="alert" class="error">{error}</div>{/if}{#if report}<p
      role="status"
      class="success"
    >
      {report}
    </p>{/if}
  {#if model}
    <section class="buildbar">
      <label
        >Build profile<select
          aria-label="Build profile"
          value={selected}
          onchange={(e) => {
            const data = bundles.find((b) => b.layout.build.startsWith(e.currentTarget.value));
            if (data && uploaded) load(uploaded, data);
          }}
          >{#each profiles as p}<option value={p.id}>{p.id} · {p.date.slice(0, 10)}</option
            >{/each}</select
        ></label
      ><span class="badge">Game loads: {model.copies.source || 'neither copy'}</span><span
        class="badge">{model.rules & 1 ? 'Original' : 'Enhanced'} types</span
      ><span class="badge">{model.rules & 2 ? 'Original' : 'Enhanced'} stats</span><span
        class="badge">{model.rules & 4 ? 'Abilities off' : 'Abilities on'}</span
      >{#if model.hardMode}<span class="badge">Hard Mode</span>{/if}<button
        class="primary"
        disabled={errors.length > 0 || !model.copies.source}
        onclick={save}>Download save</button
      >
    </section>
    <nav aria-label="Editor sections">
      {#each ['Party', 'Boxes', 'Bag', 'Player', 'Pokédex', 'Flags', 'Daycare', 'Diagnostics', 'Inspector'] as name}<button
          class:active={tab === name}
          onclick={() => (tab = name)}>{name}</button
        >{/each}
    </nav>
    {#if errors.length}<p class="error">
        {errors.length} error{errors.length === 1 ? '' : 's'} block export. See Diagnostics for details.
      </p>{/if}
    <div class="workspace">
      {#if tab === 'Diagnostics'}
        <div class="section-heading">
          <div>
            <p class="eyebrow">SAVE HEALTH</p>
            <h2>Diagnostics</h2>
          </div>
          <button
            onclick={() =>
              downloadBytes(
                JSON.stringify(diagnostics, null, 2),
                'crimson-diagnostics.json',
                'application/json',
              )}>Export report</button
          >
        </div>
        <p>{errors.length} errors · {warnings.length} warnings · {diagnostics.length} findings</p>
        {#each diagnostics as d}<article class="diagnostic" class:error={d.severity === 'ERROR'}>
            <strong>{d.severity}</strong>
            <div>{d.message}<small>{d.symbol} · 0x{d.offset.toString(16)}</small></div>
          </article>{/each}
      {:else if tab === 'Inspector'}
        <h2>Structure inspector</h2>
        <p class="muted">
          * marks a changed byte. Output preview is available when validation passes.
        </p>
        <label
          >SRAM symbol<select bind:value={hexSymbol}
            >{#each Object.keys(model.data.layout.sram).sort() as s}<option>{s}</option
              >{/each}</select
          ></label
        >
        <pre>{hex()}</pre>
        <button
          onclick={() => {
            if (!model) return;
            try {
              const bytes = write(model);
              downloadBytes(
                JSON.stringify(
                  {
                    build: model.data.layout.build,
                    layout: model.data.layout.layoutHash,
                    changes: Array.from(bytes).flatMap((v, i) =>
                      v === model!.original[i]
                        ? []
                        : [{ offset: i, before: model!.original[i], after: v }],
                    ),
                  },
                  null,
                  2,
                ),
                'crimson-diff.json',
                'application/json',
              );
            } catch (e) {
              error = String(e);
            }
          }}>Export byte diff</button
        >
        {#if model.copies.source && !errors.length}
          <h3>Migrate into another build</h3>
          <p class="muted">
            Choose a valid save from the destination ROM. Roster and inventory are transferred by
            constants; map, events and unmodeled state come from that template. A new save is
            downloaded.
          </p>
          <label class="button"
            >Choose target template<input
              type="file"
              accept=".sav,.bak,.srm,.ram"
              onchange={migrateTo}
            /></label
          >
        {/if}
      {:else if !model.copies.source}<h2>This save is read-only</h2>
        <p>
          No valid copy was found for the selected profile. Choose another build profile or inspect
          the diagnostics.
        </p>
      {:else if tab === 'Party' || tab === 'Boxes'}
        {#if tab === 'Boxes'}<div class="fields">
            <label
              >Box<select aria-label="Box" bind:value={boxIndex}
                >{#each model.boxes as box, i}<option value={i}>{i + 1} · {box.name}</option
                  >{/each}</select
              ></label
            ><label>Box name<input bind:value={model.boxes[boxIndex].name} /></label><label
              >Theme<select bind:value={model.boxes[boxIndex].theme}
                >{#each model.data.themes as t}<option value={t.index}>{t.name}</option
                  >{/each}</select
              ></label
            >
          </div>{/if}
        <div class="team-layout">
          <aside>
            <div class="section-heading">
              <h2>{tab === 'Party' ? 'Your team' : 'Box slots'}</h2>
              {#if tab === 'Party'}<span class="muted"
                  >{model.party.length} / {model.data.layout.constants.PARTY_LENGTH}</span
                >{/if}
            </div>
            {#each tab === 'Party' ? model.party : model.boxes[boxIndex].slots as mon, i}<button
                class="mon-slot"
                class:selected={tab === 'Party' ? i === index : i === slotIndex}
                onclick={() => (tab === 'Party' ? (index = i) : (slotIndex = i))}
                ><span class="slot-number">{String(i + 1).padStart(2, '0')}</span>{#if mon}<span
                    ><b
                      >{mon.bad
                        ? 'Bad Egg'
                        : mon.nickname ||
                          model.data.species.find((s) => s.index === mon.species)?.name ||
                          'Unknown'}</b
                    ><small>Lv. {mon.level} {mon.shiny ? '✦' : ''} {mon.egg ? 'Egg' : ''}</small
                    ></span
                  >{:else}<span class="muted">Empty slot</span>{/if}</button
              >{/each}
            {#if tab === 'Party'}<button
                disabled={model.party.length >= model.data.layout.constants.PARTY_LENGTH}
                onclick={() => addMon()}>+ Add Pokémon</button
              ><button onclick={heal}>Heal party</button>{/if}
          </aside>
          <section class="mon-detail">
            {#if activeMon}<MonEditor
                bind:mon={
                  () => activeMon!,
                  (value) => {
                    if (!model) return;
                    if (tab === 'Party') model.party[index] = value;
                    else model.boxes[boxIndex].slots[slotIndex] = value;
                  }
                }
                data={model.data}
                rules={model.rules}
                boxed={tab === 'Boxes'}
                {debug}
              />
              <div class="toolbar">
                <button onclick={() => exportMon()}>Export JSON</button><button
                  onclick={() => exportMon(true)}>Battletest YAML</button
                ><label class="button"
                  >Import JSON<input type="file" accept=".json" onchange={importMon} /></label
                ><button class="danger" onclick={deleteMon}>Delete Pokémon</button>
              </div>{:else}<div class="empty">
                <h2>An open spot for someone new.</h2>
                <p>Create a Pokémon using this build's data and your trainer details.</p>
                <button class="primary" onclick={() => addMon(tab === 'Boxes')}>Add Pokémon</button>
              </div>{/if}
            {#if tab === 'Boxes'}
              <div class="fields">
                <label
                  >Destination box<select bind:value={targetBox}
                    >{#each model.boxes as box, i}<option value={i}>{i + 1} · {box.name}</option
                      >{/each}</select
                  ></label
                ><label
                  >Destination slot<select bind:value={targetSlot}
                    >{#each Array(model.data.layout.constants.MONS_PER_BOX).fill(0) as _, i}<option
                        value={i}>{i + 1}</option
                      >{/each}</select
                  ></label
                >
              </div>
              <button onclick={moveSlot}>Move / swap box slot</button>
            {/if}
          </section>
        </div>
      {:else if tab === 'Player'}<h2>Trainer details</h2>
        <div class="fields">
          <label>Name<input bind:value={model.player.name} /></label><label
            >Rival<input bind:value={model.player.rival} /></label
          ><label>ID<input type="number" min="0" max="65535" bind:value={model.player.id} /></label
          ><label
            >Character<select bind:value={model.player.character}
              >{#each model.data.characters as ch}<option value={ch.index}>{ch.name}</option
                >{/each}</select
            ></label
          ><label
            >Money<input
              type="number"
              min="0"
              max="999999"
              bind:value={model.player.money}
            /></label
          ><label
            >Mom's money<input
              type="number"
              min="0"
              max="999999"
              bind:value={model.player.momsMoney}
            /></label
          ><label
            >Coins<input type="number" min="0" max="9999" bind:value={model.player.coins} /></label
          ><label
            >Blue Card<input
              type="number"
              min="0"
              max="255"
              bind:value={model.player.blueCard}
            /></label
          >
        </div>
        <button
          onclick={() => {
            if (model) {
              model.player.money = model.data.layout.constants.MAX_MONEY;
              model.player.coins = model.data.layout.constants.MAX_COINS;
            }
          }}>Max money and coins</button
        >
      {:else if tab === 'Bag'}<h2>Bag & storage</h2>
        <div class="toolbar">
          {#each ['items', 'balls', 'key', 'pc', 'tm'] as p}<button
              class:active={pocket === p}
              onclick={() => (pocket = p)}
              >{p === 'tm'
                ? 'TMs / HMs'
                : p === 'pc'
                  ? 'PC items'
                  : p === 'key'
                    ? 'Key items'
                    : p}</button
            >{/each}
        </div>
        {#if pocket === 'tm'}<button
            onclick={() => {
              if (model) model.tms = model.tms.map(() => 1);
            }}>All TMs / HMs</button
          >
          <div class="check-grid">
            {#each model.tms as _, i}<label
                ><input
                  type="checkbox"
                  checked={!!model.tms[i]}
                  onchange={(e) => {
                    if (model) model.tms[i] = Number(e.currentTarget.checked);
                  }}
                />{model.data.items.find((x) => x.index === model!.data.layout.constants.TM01 + i)
                  ?.name}</label
              >{/each}
          </div>
        {:else}{#each model.bag[pocket] as stack, i}<div class="move-row">
              <label
                >Item<select bind:value={stack.item}
                  >{#each model.data.items.filter((x) => x.index > 0 && x.index < 255 && (pocket === 'pc' || x.pocket === model!.data.layout.constants[pocket === 'items' ? 'ITEM' : pocket === 'balls' ? 'BALL' : 'KEY_ITEM'])) as item}<option
                      value={item.index}>{item.name} · {item.const}</option
                    >{/each}</select
                ></label
              >{#if pocket !== 'key'}<label
                  >Quantity<input
                    type="number"
                    min="1"
                    max="99"
                    bind:value={stack.quantity}
                  /></label
                >{/if}<button onclick={() => model?.bag[pocket].splice(i, 1)}>Remove</button>
            </div>{/each}<button
            onclick={() => {
              if (!model) return;
              const p =
                model.data.layout.constants[
                  pocket === 'items' ? 'ITEM' : pocket === 'balls' ? 'BALL' : 'KEY_ITEM'
                ];
              const item = model.data.items.find(
                (x) =>
                  x.index > 0 &&
                  x.index < 255 &&
                  (pocket === 'pc' || x.pocket === p) &&
                  !model!.bag[pocket].some((s) => s.item === x.index),
              );
              if (item) model.bag[pocket].push({ item: item.index, quantity: 1 });
            }}>+ Add item</button
          >{/if}
      {:else if tab === 'Pokédex'}<h2>Pokédex</h2>
        <div class="toolbar">
          <input
            aria-label="Search Pokédex"
            bind:value={dexSearch}
            placeholder="Find species"
          /><button
            onclick={() => {
              if (model) {
                model.dex.caught.fill(true);
                model.dex.seen.fill(true);
              }
            }}>Complete dex</button
          ><button
            onclick={() => {
              if (model) {
                model.dex.caught.fill(false);
                model.dex.seen.fill(false);
              }
            }}>Clear dex</button
          >
        </div>
        <div class="dex-grid">
          {#each model.data.species.filter((s) => `${s.name} ${s.const}`
              .toLowerCase()
              .includes(dexSearch.toLowerCase())) as s}<div>
              <b>{s.name}</b><small>{s.const}</small><label
                ><input type="checkbox" bind:checked={model.dex.seen[s.index - 1]} /> Seen</label
              ><label
                ><input
                  type="checkbox"
                  bind:checked={model.dex.caught[s.index - 1]}
                  onchange={() => {
                    if (model?.dex.caught[s.index - 1]) model.dex.seen[s.index - 1] = true;
                  }}
                /> Caught</label
              >
            </div>{/each}
        </div>
      {:else if tab === 'Flags'}<h2>Flags & gameplay rules</h2>
        <p class="muted">
          Changing gameplay rules changes types, stats and abilities throughout the game.
        </p>
        <div class="checks">
          {#each ['Original types', 'Original stats', 'Disable abilities'] as rule, i}<label
              ><input
                type="checkbox"
                checked={!!(model.rules & (1 << i))}
                onchange={(e) => {
                  if (model)
                    model.rules =
                      (model.rules & ~(1 << i)) | (e.currentTarget.checked ? 1 << i : 0);
                }}
              />{rule}</label
            >{/each}<label><input type="checkbox" bind:checked={model.hardMode} /> Hard Mode</label>
        </div>
        <div class="fields">
          <label
            >Badges bitfield<input
              type="number"
              min="0"
              max="65535"
              bind:value={model.badges}
            /></label
          ><label>Find event / engine flag<input bind:value={flagSearch} /></label>
        </div>
        <div class="check-grid">
          {#each model.data.flags.filter((f) => f.const
              .toLowerCase()
              .includes(flagSearch.toLowerCase())) as f}<label
              ><input
                type="checkbox"
                checked={model.flags[f.const]}
                onchange={(e) => setFlag(f.const, e.currentTarget.checked)}
              />{f.const}</label
            >{/each}
        </div>
      {:else if tab === 'Daycare'}<h2>Daycare & pending egg</h2>
        {#each model.daycare as d, i}<details>
            <summary
              >{i === 2 ? 'Pending egg' : `Parent ${i + 1}`} · {d.active
                ? 'Occupied'
                : 'Empty'}</summary
            >{#if d.active}<MonEditor
                bind:mon={d.mon}
                data={model.data}
                rules={model.rules}
                {debug}
              />{:else}<p class="muted">Deposit a Pokémon in-game to initialize this slot.</p>{/if}
          </details>{/each}
      {/if}
    </div>
    <footer>
      <label><input type="checkbox" bind:checked={debug} /> Debug controls</label><label
        ><input type="checkbox" bind:checked={model.debugCharacters} /> Debug name characters</label
      ><span
        >{model.data.layout.build.slice(0, 8)} · layout {model.data.layout.layoutHash.slice(
          0,
          8,
        )}</span
      >
    </footer>
  {/if}
  {#if showWarnings}<div class="modal-backdrop">
      <div
        class="modal"
        role="dialog"
        tabindex="-1"
        aria-modal="true"
        aria-label="Review save warnings"
      >
        <h2>Review warnings</h2>
        <p>Your save has {warnings.length} warning{warnings.length === 1 ? '' : 's'}.</p>
        {#each warnings as w}<p>{w.message}</p>{/each}<button onclick={() => (showWarnings = false)}
          >Back to editor</button
        ><button
          class="primary"
          onclick={() => {
            showWarnings = false;
            warningAccepted = true;
            save();
          }}>Download verified save</button
        >
      </div>
    </div>{/if}
</main>
