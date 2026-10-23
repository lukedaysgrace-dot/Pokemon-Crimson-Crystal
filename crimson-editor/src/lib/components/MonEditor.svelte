<script lang="ts">
  import { untrack } from 'svelte';
  import type { Mon } from '../save/model';
  import type { GameData } from '../gamedata/model';
  import { stats, expAtLevel, maxPP, hpDV, gender, ability, unownLetter } from '../save/mechanics';
  import { base } from '$app/paths';
  let {
    mon = $bindable(),
    data,
    rules,
    boxed = false,
    debug = false,
  }: { mon: Mon; data: GameData; rules: number; boxed?: boolean; debug?: boolean } = $props();
  let search = $state(''),
    group = $state('all'),
    nameTarget = $state<'nickname' | 'ot'>('nickname');
  const species = $derived(data.species.find((s) => s.index === mon.species));
  const calculated = $derived(
    species ? stats(species, mon.dvs, mon.statExp, mon.level, rules) : [],
  );
  let previousMon: Mon | undefined;
  let previousStatsKey = '';
  $effect(() => {
    const currentMon = mon,
      values = calculated,
      keep = mon.keepStats;
    const key = JSON.stringify([mon.species, mon.level, mon.dvs, mon.statExp, rules, keep]);
    untrack(() => {
      if (previousMon !== currentMon) {
        previousMon = currentMon;
        previousStatsKey = key;
        return;
      }
      if (key === previousStatsKey) return;
      previousStatsKey = key;
      if (
        boxed ||
        currentMon.raw.length < data.layout.party.size ||
        keep ||
        !values.every(Number.isFinite)
      )
        return;
      const oldMax = currentMon.stats[0],
        hp = currentMon.hp;
      currentMon.stats = [...values];
      currentMon.hp = oldMax
        ? Math.min(values[0], Math.ceil((hp * values[0]) / oldMax))
        : Math.min(hp, values[0]);
    });
  });
  const held = $derived(
    data.items.filter(
      (i) =>
        i.index === 0 ||
        (![data.layout.constants.KEY_ITEM, data.layout.constants.TM_HM].includes(i.pocket) &&
          (!i.mail || (!boxed && mon.raw.length >= data.layout.party.size)) &&
          i.index !== 255),
    ),
  );
  const choices = $derived(
    data.moves.filter(
      (m) =>
        group === 'all' ||
        (group === 'level' && species?.levelMoves.some((x) => x.move === m.index)) ||
        (group === 'egg' && species?.eggMoves.includes(m.index)) ||
        (group === 'tm' && (species?.tmhm.includes(m.index) || species?.tutor.includes(m.index))),
    ),
  );
  function levelChanged() {
    if (species) mon.exp = expAtLevel(data.growth[species.growth], mon.level);
  }
  function setSpecies() {
    levelChanged();
    mon.nickname = species?.name || mon.nickname;
  }
  function heal() {
    mon.hp = calculated[0];
    mon.status = 0;
    mon.pp = mon.moves.map((n, i) =>
      maxPP(data.moves.find((m) => m.index === n)?.pp || 0, mon.ups[i]),
    );
  }
</script>

{#if mon.bad}<p class="error">
    Bad Egg — the record checksum is invalid. Delete this slot to remove it. Export stays blocked
    while it is present.
  </p>{/if}
<div class="mon-heading">
  {#if species}<img
      src={`${base}/sprites/${species.sprite}/${mon.shiny ? 'shiny' : 'normal'}.png`}
      alt={species.name}
      width="96"
      height="96"
    />{/if}
  <div>
    <h2>{mon.nickname || species?.name || 'Unknown Pokémon'}</h2>
    <p>
      {species?.const || mon.species} · {species ? gender(species, mon.male) : 'Unknown'} · {mon.egg
        ? 'Egg'
        : `Level ${mon.level}`}
    </p>
  </div>
</div>
<div class="fields">
  <label>Find species<input bind:value={search} placeholder="Name or constant" /></label>
  <label
    >Species<select aria-label="Species" bind:value={mon.species} onchange={setSpecies}
      >{#each data.species.filter((s) => s.index === mon.species || `${s.name} ${s.const}`
            .toLowerCase()
            .includes(search.toLowerCase())) as s}<option value={s.index}
          >{s.name} · {s.const}</option
        >{/each}</select
    ></label
  >
  <label>Nickname<input aria-label="Nickname" bind:value={mon.nickname} /></label>
  <label>OT name<input bind:value={mon.ot} /></label>
  <label>OT ID<input type="number" min="0" max="65535" bind:value={mon.id} /></label>
  <label
    >Level<input
      aria-label="Level"
      type="number"
      min="1"
      max="100"
      bind:value={mon.level}
      onchange={levelChanged}
    /></label
  >
  <label>Experience<input type="number" min="0" max="16777215" bind:value={mon.exp} /></label>
  <label
    >Held item<select bind:value={mon.item}
      >{#each held as i}<option value={i.index}>{i.name} · {i.const}</option>{/each}</select
    ></label
  >
  <label
    >Ability slot<select
      value={(mon.personality >>> 5) & 3}
      onchange={(e) =>
        (mon.personality = (mon.personality & 159) | (Number(e.currentTarget.value) << 5))}
      >{#each [0, 1, 2, 3] as slot}<option value={slot}
          >{slot === 0 ? 'Unset (Ability 1)' : `Ability ${slot}`}: {data.abilities.find(
            (a) => a.index === species?.abilities[Math.max(0, slot - 1)],
          )?.name || 'Falls back to slot 1'}</option
        >{/each}</select
    ></label
  >
  <label
    >Happiness / hatch cycles<input
      type="number"
      min="0"
      max="255"
      bind:value={mon.happiness}
    /></label
  >
  <label
    >Pokérus byte<input
      type="number"
      min="0"
      max={boxed ? 63 : 255}
      bind:value={mon.pokerus}
    /></label
  >
  <label
    >Hidden Power<select bind:value={mon.hpType}
      ><option value={0}>Default (Dark)</option
      >{#each data.types.filter((t) => !t.const.startsWith('TYPE_')) as t}<option value={t.index}
          >{t.name}</option
        >{/each}</select
    ></label
  >
</div>
<details>
  <summary>Name keyboard</summary>
  <label
    >Write to<select bind:value={nameTarget}
      ><option value="nickname">Nickname</option><option value="ot">OT name</option></select
    ></label
  >
  <div class="toolbar">
    {#each boxed ? data.boxKeyboard : data.keyboard as token}<button
        onclick={() => (mon[nameTarget] += token)}>{token === ' ' ? 'Space' : token}</button
      >{/each}<button onclick={() => (mon[nameTarget] = mon[nameTarget].replace(/<[^>]+>$|.$/, ''))}
      >Delete</button
    >
  </div>
</details>
{#if boxed || mon.raw.length >= data.layout.party.size}<div class="checks">
    <label><input type="checkbox" bind:checked={mon.shiny} /> Shiny</label><label
      ><input type="checkbox" bind:checked={mon.male} /> Male flag</label
    ><label><input type="checkbox" bind:checked={mon.egg} /> Egg</label>
  </div>{/if}
{#if species}<p class="muted">
    Effective ability: {data.abilities.find(
      (a) => a.index === ability(species, (mon.personality >>> 5) & 3, rules),
    )?.name || 'Unknown'}{rules & 4 ? ' (disabled by gameplay rules)' : ''}. {species.const ===
    'UNOWN'
      ? `Unown letter: ${String.fromCharCode(65 + unownLetter(mon.dvs))}.`
      : ''}
  </p>{/if}
<h3>Stats</h3>
<div class="fields">
  {#each ['Attack', 'Defense', 'Speed', 'Special'] as stat, i}<label
      >{stat} DV<input type="number" min="0" max="15" bind:value={mon.dvs[i]} /></label
    >{/each}
</div>
<p class="muted">Derived HP DV: {hpDV(mon.dvs)}</p>
<div class="fields">
  {#each ['HP', 'Attack', 'Defense', 'Speed', 'Special'] as stat, i}<label
      >{stat} Stat Exp<input type="number" min="0" max="65535" bind:value={mon.statExp[i]} /></label
    >{/each}
</div>
<div class="stats">
  {#each ['HP', 'Attack', 'Defense', 'Speed', 'Sp. Atk', 'Sp. Def'] as label, i}<span
      >{label}<strong>{calculated[i] ?? '—'}</strong></span
    >{/each}
</div>
{#if !boxed}<div class="fields">
    <label
      >Current HP<input
        type="number"
        min="0"
        max={mon.stats[0] || 999}
        bind:value={mon.hp}
      /></label
    ><label>Status byte<input type="number" min="0" max="127" bind:value={mon.status} /></label>
  </div>
  <button onclick={heal}>Heal Pokémon</button>{#if debug}<label class="check"
      ><input type="checkbox" bind:checked={mon.keepStats} /> Keep stored stats on species / level / DV
      edits</label
    >{#if mon.keepStats}<div class="fields">
        {#each mon.stats as _, i}<label
            >Stored stat {i + 1}<input
              type="number"
              min="1"
              max="999"
              bind:value={mon.stats[i]}
            /></label
          >{/each}
      </div>{/if}{/if}{:else}<p class="muted">
    HP, status and PP are restored by the game on withdrawal.
  </p>{/if}
<h3>Moves</h3>
<label
  >Show moves<select bind:value={group}
    ><option value="all">All moves</option><option value="level">Level-up</option><option
      value="egg">Egg moves</option
    ><option value="tm">TMs, HMs and tutors</option></select
  ></label
>
{#each [0, 1, 2, 3] as i}<div class="move-row">
    <label
      >Move {i + 1}<select
        aria-label={`Move ${i + 1}`}
        bind:value={mon.moves[i]}
        onchange={() =>
          (mon.pp[i] = maxPP(
            data.moves.find((m) => m.index === mon.moves[i])?.pp || 0,
            mon.ups[i],
          ))}
        ><option value={0}>None</option
        >{#each data.moves.filter((m) => choices.includes(m) || m.index === mon.moves[i]) as m}<option
            value={m.index}>{m.name} · {m.const}</option
          >{/each}</select
      ></label
    ><label
      >PP Ups<input
        type="number"
        min="0"
        max="3"
        bind:value={mon.ups[i]}
        onchange={() =>
          (mon.pp[i] = Math.min(
            mon.pp[i],
            maxPP(data.moves.find((m) => m.index === mon.moves[i])?.pp || 0, mon.ups[i]),
          ))}
      /></label
    >{#if !boxed}<label
        >Current PP<input
          type="number"
          min="0"
          max={maxPP(data.moves.find((m) => m.index === mon.moves[i])?.pp || 0, mon.ups[i])}
          bind:value={mon.pp[i]}
        /></label
      >{/if}
  </div>{/each}
<h3>Caught data</h3>
<div class="fields">
  <label
    >Ball<select
      value={mon.personality & 31}
      onchange={(e) => (mon.personality = (mon.personality & 224) | Number(e.currentTarget.value))}
      >{#each data.balls as b}<option value={b.index}>{b.name}</option>{/each}</select
    ></label
  ><label
    >Caught level<input
      type="number"
      min="0"
      max="63"
      value={mon.caught[0] & 63}
      onchange={(e) => (mon.caught[0] = (mon.caught[0] & 192) | Number(e.currentTarget.value))}
    /></label
  ><label
    >Time<select
      value={mon.caught[0] >>> 6}
      onchange={(e) =>
        (mon.caught[0] = (mon.caught[0] & 63) | (Number(e.currentTarget.value) << 6))}
      >{#each ['Unknown', 'Morning', 'Day', 'Night'] as time, i}<option value={i}>{time}</option
        >{/each}</select
    ></label
  ><label
    >Location<select
      value={mon.caught[1] & 127}
      onchange={(e) => (mon.caught[1] = (mon.caught[1] & 128) | Number(e.currentTarget.value))}
      >{#each data.landmarks as loc}<option value={loc.index}>{loc.name}</option>{/each}<option
        value={126}>Gift</option
      ><option value={127}>Event</option></select
    ></label
  >
</div>
<label class="check"
  ><input
    type="checkbox"
    checked={!!(mon.caught[1] & 128)}
    onchange={(e) => (mon.caught[1] = (mon.caught[1] & 127) | (e.currentTarget.checked ? 128 : 0))}
  /> Female original trainer</label
>
<details>
  <summary>Raw bytes ({mon.raw.length})</summary>
  <pre>{mon.raw.map((n) => n.toString(16).padStart(2, '0')).join(' ')}</pre>
</details>
