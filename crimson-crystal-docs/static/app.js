document.addEventListener('DOMContentLoaded',()=>{const s=document.querySelector('#search'),t=document.querySelector('#typeFilter');function f(){const q=(s?.value||'').toLowerCase(),ty=t?.value||'';document.querySelectorAll('.card').forEach(x=>x.style.display=((x.dataset.search||'').includes(q)&&(!ty||(x.dataset.type||'').split(' ').includes(ty)))?'':'none')}s?.addEventListener('input',f);t?.addEventListener('change',f);const ts=document.querySelector('#tableSearch');ts?.addEventListener('input',()=>{const q=ts.value.toLowerCase();document.querySelectorAll('.table .searchable').forEach(x=>x.style.display=(x.dataset.search||'').includes(q)?'':'none')})});

document.querySelectorAll('.form-toggle').forEach(toggle => {
  toggle.addEventListener('click', event => {
    const button = event.target.closest('button[data-form]');
    if (!button) return;
    const form = button.dataset.form;
    toggle.querySelectorAll('button').forEach(b => b.classList.toggle('active', b === button));
    document.querySelectorAll('[data-form-view]').forEach(view => {
      view.hidden = view.dataset.formView !== form;
    });
  });
});

/* ------------------------------------------------------------------ *
 * Front-pic animation player.
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

  const parseSeq = s => (s || '')
    .split(',')
    .filter(Boolean)
    .map(pair => pair.split(':').map(Number))
    .filter(([f, d]) => Number.isFinite(f) && Number.isFinite(d) && d > 0);

  function sliceSheet(url, size, count) {
    if (sheets.has(url)) return sheets.get(url);
    const job = new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => {
        const out = [];
        for (let i = 0; i < count; i++) {
          const c = document.createElement('canvas');
          c.width = size; c.height = size;
          const ctx = c.getContext('2d');
          ctx.imageSmoothingEnabled = false;
          ctx.drawImage(img, 0, i * size, size, size, 0, 0, size, size);
          out.push(c.toDataURL('image/png'));
        }
        // Decode every frame up front so the first swap cannot flicker.
        Promise.all(out.map(src => {
          const p = new Image();
          p.src = src;
          return p.decode ? p.decode().catch(() => {}) : Promise.resolve();
        })).then(() => resolve(out), () => resolve(out));
      };
      img.onerror = reject;
      img.src = url;
    });
    sheets.set(url, job);
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

    const token = {};
    playing.set(img, token);

    let frames;
    try {
      frames = await sliceSheet(url, size, count);
    } catch {
      return; // sheet missing; leave the static sprite alone
    }
    if (playing.get(img) !== token) return;

    const still = img.getAttribute('src');
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

  function init() {
    const sprites = document.querySelectorAll('img[data-anim-sheet]');
    if (!sprites.length) return;
    const still = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    sprites.forEach(img => {
      img.classList.add('animatable');
      img.title = 'Click to play animation';
      img.addEventListener('click', () => play(img));
    });

    if (still) return;
    // Opening a Pokémon page plays the animation once, the way the stats
    // screen does when you open it. Clicking the sprite replays it.
    const first = document.querySelector('.form-view:not([hidden]) img[data-anim-sheet]')
      || sprites[0];
    if (first) play(first);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
