document.addEventListener('DOMContentLoaded',()=>{const s=document.querySelector('#search'),t=document.querySelector('#typeFilter');function f(){const q=(s?.value||'').toLowerCase(),ty=t?.value||'';document.querySelectorAll('.card').forEach(x=>x.style.display=((x.dataset.search||'').includes(q)&&(!ty||(x.dataset.type||'').split(' ').includes(ty)))?'':'none')}s?.addEventListener('input',f);t?.addEventListener('change',f);const ts=document.querySelector('#tableSearch');ts?.addEventListener('input',()=>{const q=ts.value.toLowerCase();document.querySelectorAll('.table .searchable').forEach(x=>x.style.display=(x.dataset.search||'').includes(q)?'':'none')})});

document.addEventListener('DOMContentLoaded', () => {
  const search = document.querySelector('#itemSearch');
  const category = document.querySelector('#itemCategory');
  const availability = document.querySelector('#itemAvailability');
  if (!search || !category || !availability) return;
  const items = [...document.querySelectorAll('[data-item]')];
  const update = () => {
    const query = search.value.trim().toLowerCase();
    let visible = 0;
    items.forEach(item => {
      item.hidden = !(item.dataset.search.includes(query) &&
        (!category.value || category.value === item.dataset.category) &&
        (!availability.value || availability.value === item.dataset.availability));
      if (!item.hidden) visible++;
    });
    document.querySelector('#itemCount').textContent = `Showing ${visible} of ${items.length} items`;
    document.querySelector('#itemEmpty').hidden = visible !== 0;
  };
  const reveal = () => {
    const item = document.getElementById(window.location.hash.slice(1));
    if (!item?.matches('[data-item]')) return;
    if (item.hidden) {
      search.value = category.value = availability.value = '';
      update();
    }
    item.open = true;
    item.scrollIntoView({ block: 'start' });
  };
  search.addEventListener('input', update);
  category.addEventListener('change', update);
  availability.addEventListener('change', update);
  window.addEventListener('hashchange', reveal);
  document.querySelectorAll('a[href^="#"]').forEach(link => link.addEventListener('click', () => {
    search.value = category.value = availability.value = '';
    update();
    const item = document.getElementById(link.hash.slice(1));
    if (item?.matches('[data-item]')) item.open = true;
  }));
  update();
  reveal();
});

document.querySelectorAll('.form-toggle').forEach(toggle => {
  toggle.addEventListener('click', event => {
    const button = event.target.closest('button[data-form]');
    if (!button) return;
    const form = button.dataset.form;
    toggle.querySelectorAll('button').forEach(b => {
      b.classList.toggle('active', b === button);
      b.setAttribute('aria-pressed', String(b === button));
    });
    document.querySelectorAll('[data-form-view]').forEach(view => {
      view.hidden = view.dataset.formView !== form;
    });
  });
  const requestedForm = new URLSearchParams(window.location.search).get('form');
  const requestedButton = [...toggle.querySelectorAll('button')].find(button => button.dataset.form === requestedForm);
  requestedButton?.click();
});

document.addEventListener('DOMContentLoaded', () => {
  const search = document.querySelector('#changeSearch');
  const filter = document.querySelector('#changeFilter');
  if (!search || !filter) return;
  const cards = [...document.querySelectorAll('.change-card')];
  const update = () => {
    const query = search.value.trim().toLowerCase();
    let visible = 0;
    cards.forEach(card => {
      const matches = card.dataset.search.includes(query) &&
        (!filter.value || card.dataset.kinds.split(' ').includes(filter.value));
      card.hidden = !matches;
      if (matches) visible++;
    });
    document.querySelector('#changeCount').textContent = `Showing ${visible} Pokémon`;
    document.querySelector('#changeEmpty').hidden = visible !== 0;
  };
  search.addEventListener('input', update);
  filter.addEventListener('change', update);
  update();
});

document.addEventListener('DOMContentLoaded', () => {
  const search = document.querySelector('#updateSearch');
  const category = document.querySelector('#updateCategory');
  const kind = document.querySelector('#updateKind');
  if (!search || !category || !kind) return;
  const entries = [...document.querySelectorAll('[data-update-entry]')];
  const sections = [...document.querySelectorAll('[data-update-section]')];
  const directoryState = new Map();
  let wasFiltering = false;
  const update = () => {
    const query = search.value.trim().toLowerCase();
    const filtering = Boolean(query || category.value || kind.value);
    if (filtering && !wasFiltering) {
      sections.filter(section => section.tagName === 'DETAILS')
        .forEach(section => directoryState.set(section, section.open));
    }
    let visible = 0;
    entries.forEach(entry => {
      const matchesKind = !kind.value || (kind.value === 'exception'
        ? ['exception', 'custom'].includes(entry.dataset.kind)
        : kind.value === entry.dataset.kind);
      entry.hidden = !(entry.dataset.search.includes(query) &&
        (!category.value || category.value === entry.dataset.category) && matchesKind);
      if (!entry.hidden) visible++;
    });
    sections.forEach(section => {
      section.hidden = ![...section.querySelectorAll('[data-update-entry]')]
        .some(entry => !entry.hidden);
      if (section.tagName === 'DETAILS') {
        if (filtering) section.open = !section.hidden;
        else if (wasFiltering) section.open = directoryState.get(section) || false;
      }
    });
    document.querySelector('#updateCount').textContent = `Showing ${visible} of ${entries.length} entries`;
    document.querySelector('#updateEmpty').hidden = visible !== 0;
    wasFiltering = filtering;
  };
  const revealHash = () => {
    const target = document.getElementById(window.location.hash.slice(1));
    if (!target) return;
    if (target.hidden || target.closest('[hidden]')) {
      search.value = category.value = kind.value = '';
      update();
    }
    const directory = target.closest('details');
    if (directory) directory.open = true;
  };
  search.addEventListener('input', update);
  category.addEventListener('change', update);
  kind.addEventListener('change', update);
  window.addEventListener('hashchange', revealHash);
  document.querySelectorAll('a[href^="#"]').forEach(link => {
    link.addEventListener('click', () => {
      search.value = category.value = kind.value = '';
      update();
      const target = document.getElementById(link.getAttribute('href').slice(1));
      const directory = target?.closest('details');
      if (directory) directory.open = true;
    });
  });
  update();
  revealHash();
});

/* ------------------------------------------------------------------ *
 * Pokémon sprite palette toggle and front-pic animation player.
 *
 * Reproduces the stats-screen sequence from engine/gfx/pic_animation.asm
 * (ANIM_MON_MENU): run anim.asm once, hold 18 frames, run anim_idle.asm
 * once, then settle back on the static frame.
 *
 * front.png is the static frame followed by each animation frame stacked
 * vertically, so frame N is block N of the sheet. Blocks are sliced into
 * data URLs once per sprite and then swapped in as the <img> src, which
 * leaves the page's own layout and styling completely untouched.
 * ------------------------------------------------------------------ */
(() => {
  const GB_FRAME_MS = 1000 / 59.7275; // Game Boy vblank
  const sheets = new Map();           // sheet url -> Promise<string[]>
  const playing = new WeakMap();      // img -> token
  const shinySources = new Map();
  const paletteUrl = new URL('shiny-palettes.json', document.currentScript.src);
  let palettes;
  let shiny = false;
  let activeCry;

  const parseSeq = s => (s || '')
    .split(',')
    .filter(Boolean)
    .map(pair => pair.split(':').map(Number))
    .filter(([f, d]) => Number.isFinite(f) && Number.isFinite(d) && d > 0);

  function loadImage(url) {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => resolve(img);
      img.onerror = reject;
      img.src = url;
    });
  }

  async function recolorSprite(src) {
    palettes ??= fetch(paletteUrl).then(response => {
      if (!response.ok) throw new Error('Could not load shiny palettes');
      return response.json();
    }).catch(error => {
      palettes = undefined;
      throw error;
    });
    const [colors, img] = await Promise.all([palettes, loadImage(src)]);
    const name = new URL(src, document.baseURI).pathname.split('/').pop().replace(/(?:\.sheet)?\.png$/, '');
    const palette = colors[name] ?? colors[name.replace(/\.back$/, '')];
    if (!palette) throw new Error(`Missing shiny palette for ${name}`);

    const canvas = document.createElement('canvas');
    canvas.width = img.width;
    canvas.height = img.height;
    const ctx = canvas.getContext('2d');
    ctx.drawImage(img, 0, 0);
    const pixels = ctx.getImageData(0, 0, canvas.width, canvas.height);
    const data = pixels.data;
    for (let i = 0; i < data.length; i += 4) {
      if (data[i + 3] === 0) continue;
      const rgb555 = (data[i] >> 3) | ((data[i + 1] >> 3) << 5) | ((data[i + 2] >> 3) << 10);
      const replacement = palette[rgb555];
      if (replacement) data.set(replacement, i);
    }
    ctx.putImageData(pixels, 0, 0);
    return canvas.toDataURL('image/png');
  }

  function shinySource(src) {
    if (!shinySources.has(src)) {
      shinySources.set(src, recolorSprite(src).catch(error => {
        shinySources.delete(src);
        throw error;
      }));
    }
    return shinySources.get(src);
  }

  function sliceSheet(url, size, count, useShiny) {
    const key = `${url}:${useShiny}`;
    if (sheets.has(key)) return sheets.get(key);
    const job = (async () => {
      const img = await loadImage(useShiny ? await shinySource(url) : url);
      const canvas = document.createElement('canvas');
      canvas.width = size;
      canvas.height = size;
      const ctx = canvas.getContext('2d');
      ctx.imageSmoothingEnabled = false;
      const frames = [];
      for (let i = 0; i < count; i++) {
        ctx.clearRect(0, 0, size, size);
        ctx.drawImage(img, 0, i * size, size, size, 0, 0, size, size);
        frames.push(canvas.toDataURL('image/png'));
      }
      // Decode every frame up front so the first swap cannot flicker.
      await Promise.all(frames.map(src => {
        const frame = new Image();
        frame.src = src;
        return frame.decode ? frame.decode().catch(() => {}) : Promise.resolve();
      }));
      return frames;
    })().catch(error => {
      sheets.delete(key);
      throw error;
    });
    sheets.set(key, job);
    return job;
  }

  const wait = ms => new Promise(r => setTimeout(r, ms));

  async function play(img) {
    const size = +img.dataset.animSize;
    const count = +img.dataset.animFrames;
    const url = img.dataset.animSheet;
    if (!url || !size || !count) return;

    const main = parseSeq(img.dataset.animMain);
    const idle = parseSeq(img.dataset.animIdle);
    const gap = +img.dataset.animGap || 0;
    if (!main.length && !idle.length) return;

    const still = playing.get(img)?.still ?? img.getAttribute('src');
    const token = { still };
    playing.set(img, token);

    let frames;
    try {
      frames = await sliceSheet(url, size, count, shiny);
    } catch {
      if (playing.get(img) === token) playing.delete(img);
      return; // sheet missing; leave the static sprite alone
    }
    if (playing.get(img) !== token) return;

    const show = i => { if (frames[i]) img.setAttribute('src', frames[i]); };

    // Schedule against a running deadline so long frames don't drift.
    let due = performance.now();
    const hold = units => {
      due += units * GB_FRAME_MS;
      return wait(Math.max(0, due - performance.now()));
    };

    try {
      for (const [f, d] of main) {
        show(f);
        await hold(d);
        if (playing.get(img) !== token) return;
      }
      if (gap) {
        show(0);
        await hold(gap);
        if (playing.get(img) !== token) return;
      }
      for (const [f, d] of idle) {
        show(f);
        await hold(d);
        if (playing.get(img) !== token) return;
      }
    } finally {
      if (playing.get(img) === token) {
        img.setAttribute('src', still);
        playing.delete(img);
      }
    }
  }

  function initPaletteToggle() {
    const images = [...document.querySelectorAll('.monhero .sprite-pair img.big')];
    const normalSources = images.map(img => img.getAttribute('src'));
    const label = document.createElement('label');
    label.className = 'shiny-toggle';
    const toggle = document.createElement('input');
    toggle.type = 'checkbox';
    label.append(toggle, 'Shiny');
    const anchor = document.querySelector('main > .form-toggle') ?? document.querySelector('main > .back');
    anchor?.after(label);

    let change = 0;
    toggle.addEventListener('change', async () => {
      const request = ++change;
      const showShiny = toggle.checked;
      try {
        const sources = showShiny ? await Promise.all(normalSources.map(shinySource)) : normalSources;
        if (request !== change) return;
        shiny = showShiny;
        images.forEach((img, index) => {
          playing.delete(img);
          img.setAttribute('src', sources[index]);
        });
      } catch {
        if (request === change) toggle.checked = shiny;
      }
    });
  }

  function init() {
    const sprites = document.querySelectorAll('.monhero .sprite-pair img.big:not(.back-sprite)');
    if (!sprites.length) return;
    initPaletteToggle();

    sprites.forEach(img => {
      const filename = img.dataset.cry ?? new URL(img.src).pathname.split('/').pop().replace(/\.png$/, '.wav');
      const cry = new Audio();
      cry.preload = 'auto';
      cry.src = new URL(`../cries/${filename}`, img.src).href;

      const actions = img.dataset.animSheet ? 'animation and cry' : 'cry';
      const name = img.closest('.monhero').querySelector('h1').textContent.trim();
      img.classList.add('animatable');
      img.title = `Click to play ${actions}`;
      img.tabIndex = 0;
      img.setAttribute('role', 'button');
      img.setAttribute('aria-label', `Play ${name}'s ${actions}`);
      img.addEventListener('click', () => {
        if (activeCry && activeCry !== cry) activeCry.pause();
        activeCry = cry;
        cry.currentTime = 0;
        cry.play().catch(() => {});
        play(img);
      });
      img.addEventListener('keydown', event => {
        if (event.key !== 'Enter' && event.key !== ' ') return;
        event.preventDefault();
        if (!event.repeat) img.click();
      });
    });

    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    // The initial animation is silent. Cries play only on activation.
    const first = [...sprites].find(img => img.dataset.animSheet && !img.closest('[hidden]'));
    if (first) play(first);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
