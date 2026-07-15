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
