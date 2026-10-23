'use strict';
const $ = id => document.getElementById(id);
const esc = value => String(value ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const title = key => key.replaceAll('_',' ');
const pct = value => value == null ? '—' : `${(value * 100).toFixed(1)}%`;
let data, token, runs = [], selectedRun, battleOffset = 0, quickRun, polling = false, runActive = false;
const builds = {};
async function api(path, body) {
  const response = await fetch(path, body === undefined ? {} : {method:'POST',headers:{'Content-Type':'application/json','X-Lab-Token':token},body:JSON.stringify(body)});
  const result = await response.json();
  if (!response.ok) throw Error(result.error || response.statusText);
  return result;
}
function notice(message, error=false) {
  $('notice').hidden = false; $('notice').textContent = message; $('notice').classList.toggle('error', error);
}
function action(fn) { return async event => { const button=event?.currentTarget; if(button)button.disabled=true; try { await fn(event); } catch(error) { notice(error.message,true); } finally { if(button)button.disabled=false; } }; }
function tab(name) {
  document.querySelectorAll('.page').forEach(e=>e.classList.toggle('active',e.id===name));
  document.querySelectorAll('.nav').forEach(e=>e.classList.toggle('active',e.dataset.tab===name));
  $('page-title').textContent = {laboratory:'Laboratory',dex:'Pokédex',experiments:'Experiments',method:'Methods & accuracy'}[name];
  if(name==='experiments')loadRuns().catch(e=>notice(e.message,true));
}
document.querySelectorAll('.nav').forEach(e=>e.onclick=()=>tab(e.dataset.tab));
function options(entries, selected) {return entries.map(([key,label])=>`<option value="${esc(key)}" ${key===selected?'selected':''}>${esc(label)}</option>`).join('');}
function types(s) {return s.types.map(t=>`<span class="type">${esc(t)}</span>`).join('');}
function statstrip(s) {return `<div class="stat-strip">${Object.entries(s.stats).map(([k,v])=>`<div><small>${{hp:'HP',attack:'ATK',defense:'DEF',speed:'SPE',sp_attack:'SPA',sp_defense:'SPD'}[k]}</small><strong>${v}</strong></div>`).join('')}</div>`;}
function pool(key, level, seen=new Set()) {
  if(seen.has(key))return new Set(); seen.add(key);
  const s=data.species[key], moves=new Set([...s.level_moves.filter(([lv])=>lv<=level).map(([,m])=>m),...s.tm_moves,...s.egg_moves,...s.tutor_moves]);
  for(const parent of s.parents)for(const move of pool(parent,level,new Set(seen)))moves.add(move);
  if(key==='SMEARGLE')for(const donor of Object.values(data.species))for(const m of [...donor.level_moves.filter(([lv])=>lv<=level).map(([,m])=>m),...donor.tm_moves,...donor.egg_moves,...donor.tutor_moves])if(!['SKETCH','STRUGGLE'].includes(m))moves.add(m);
  return moves;
}
function renderBuild(side) {
  const b=builds[side], s=data.species[b.species], container=$(`${side}-build`);
  container.classList.toggle('enemy',side==='enemy');
  const speciesEntries=Object.entries(data.species).map(([k,s])=>[k,`${s.name} · #${s.id}`]);
  const abilities=[...new Set(s.abilities.filter(a=>a!=='NO_ABILITY'))]; if(!abilities.length)abilities.push('NO_ABILITY');
  const items=Object.entries(data.items).filter(([,i])=>i.selectable).map(([k,i])=>[k,i.name]);
  const moveEntries=[['','— Empty slot —'],...[...pool(b.species,b.level||100)].sort().map(k=>[k,`${data.moves[k].name} · ${['EFFECT_LOW_KICK','EFFECT_HEAVY_SLAM'].includes(data.moves[k].effect)?'weight':data.moves[k].power || 'status'} · ${data.moves[k].type}`])];
  container.innerHTML=`<div class="build-heading"><span>${side==='player'?'01 / PLAYER BUILD':'02 / OPPONENT BUILD'}</span><span>#${String(s.id).padStart(3,'0')}</span></div><div class="build-top"><label>SPECIES<select data-field="species">${options(speciesEntries,b.species)}</select></label><label>LEVEL<input data-field="level" type="number" min="2" max="100" value="${b.level||100}"></label></div><h3>${esc(s.name)}</h3><div class="type-row">${types(s)}<span class="weight-label">${s.weight_kg} kg</span></div><div class="build-meta"><label>ABILITY<select data-field="ability">${options(abilities.map(k=>[k,data.abilities[k].name]),b.ability)}</select></label><label>HELD ITEM<select data-field="item">${options(items,b.item||'NO_ITEM')}</select></label></div><div class="move-grid">${[0,1,2,3].map(i=>`<label>MOVE ${i+1}<select data-move="${i}">${options(moveEntries,b.moves[i]||'')}</select></label>`).join('')}</div>${statstrip(s)}`;
  container.querySelectorAll('[data-field]').forEach(e=>e.onchange=action(async()=>{
    const field=e.dataset.field;
    if(field==='species'){const proposals=await api(`/api/candidates?species=${encodeURIComponent(e.value)}&level=${b.level||100}`);builds[side]=proposals[0];renderBuild(side);}
    else if(field==='level'){b.level=Number(e.value);const allowed=pool(b.species,b.level);b.moves=b.moves.filter(m=>allowed.has(m));renderBuild(side);}
    else b[field]=e.value;
  }));
  container.querySelectorAll('[data-move]').forEach(e=>e.onchange=()=>{const selected=[...container.querySelectorAll('[data-move]')].map(x=>x.value).filter(Boolean);b.moves=selected;});
}
function currentScenario(){return {name:`${builds.player.species} vs ${builds.enemy.species}`,seed:Number($('seed').value),max_turns:Number($('turn-limit').value),player:builds.player,enemy:builds.enemy,policies:[$('player-policy').value,$('enemy-policy').value]};}
async function launch(config, jobs=1, quick=false) {
  const run=await api('/api/start',{config,jobs}); selectedRun=run.id; battleOffset=0;
  if(quick)quickRun=run.id;
  notice(`Experiment queued: ${run.total} battles. Results are saved after each battle.`);
  await loadRuns(); return run;
}
$('simulate').onclick=action(async()=>launch({name:currentScenario().name,mode:'scenarios',scenarios:[currentScenario()],repetitions:1,seed:Number($('seed').value)},1,true));
$('sync-json').onclick=()=>{$('scenario-json').value=JSON.stringify(currentScenario(),null,2);};
$('run-json').onclick=action(async()=>{const s=JSON.parse($('scenario-json').value);await launch({name:s.name||'Custom scenario',mode:'scenarios',scenarios:[s],repetitions:1,seed:s.seed||1},1,true);});
$('compare-abilities').onclick=action(async()=>{
  const subject=builds.player, abilities=[...new Set(data.species[subject.species].abilities.filter(a=>a!=='NO_ABILITY'))];
  if(abilities.length<2)throw Error('Choose a Pokémon with at least two available abilities.');
  await launch({name:`${subject.species} / controlled ability comparison`,mode:'cross-pool',subject_count:abilities.length,
    builds:[...abilities.map(ability=>({...subject,ability})),builds.enemy],repetitions:Number($('ability-reps').value),seed:Number($('seed').value),max_turns:Number($('turn-limit').value),policies:[$('player-policy').value,$('enemy-policy').value]},Number($('batch-jobs').value));
  $('rank-group').value='build';tab('experiments');
});
function renderDex(){
  const search=$('dex-search').value.toUpperCase(),type=$('dex-type').value;
  const entries=Object.entries(data.species).filter(([key,s])=>(key.includes(search)||s.name.includes(search))&&(!type||s.types.includes(type))&&(!$('dex-evolved').checked||s.fully_evolved));
  $('dex-count').textContent=`${entries.length} species`;
  $('dex-list').innerHTML=entries.map(([key,s])=>`<button class="dex-card" data-species="${esc(key)}"><small>#${String(s.id).padStart(3,'0')} · ${s.weight_kg} KG</small><strong>${esc(s.name)}</strong><span>${esc(s.types.join(' / '))}</span></button>`).join('');
  $('dex-list').querySelectorAll('[data-species]').forEach(e=>e.onclick=()=>dexDetail(e.dataset.species));
}
function dexDetail(key){
  const s=data.species[key],moveKeys=Object.keys(s.legal_moves);
  $('dex-detail').innerHTML=`<div class="eyebrow">#${String(s.id).padStart(3,'0')} · ${s.fully_evolved?'FULLY EVOLVED':'CAN EVOLVE'}</div><h2>${esc(s.name)}</h2><div class="type-row">${types(s)}</div><p>Weight <strong>${s.weight_kg} kg</strong> · ${s.weight_hg} hectograms</p>${statstrip(s)}<h3>Available abilities</h3><ul>${s.abilities.map((a,i)=>`<li>${i===2?'Hidden':`Slot ${i+1}`}: ${esc(data.abilities[a].name)}</li>`).join('')}</ul><p>${moveKeys.length} available moves at level 100</p><details><summary>Moves & acquisition paths</summary><ul>${moveKeys.map(m=>`<li><strong>${esc(data.moves[m].name)}</strong><small>${esc(s.legal_moves[m].join('; '))}</small></li>`).join('')}</ul></details><p class="subtle">Source: ${esc(s.source)}<br>Weight: ${esc(s.weight_source)}</p><button id="use-dex-build" class="primary">Use in workbench →</button>`;
  $('use-dex-build').onclick=action(async()=>{builds.player=(await api(`/api/candidates?species=${key}`))[0];renderBuild('player');tab('laboratory');});
}
['dex-search','dex-type','dex-evolved'].forEach(id=>$(id).oninput=renderDex);
$('all-evolved').onclick=()=>{$('batch-species').value='fully-evolved';estimate();};
function estimate(){const raw=$('batch-species').value.trim();const n=raw==='fully-evolved'?Object.values(data.species).filter(s=>s.fully_evolved).length:raw.split(',').filter(s=>s.trim()).length;const total=n*(n-1)*Number($('batch-reps').value);$('batch-estimate').textContent=`${n} species · ${total.toLocaleString()} battles with both orientations. Generated starting builds; use CLI optimization for stronger candidates.`;}
['batch-species','batch-reps'].forEach(id=>$(id).oninput=estimate);
$('run-batch').onclick=action(async()=>{const raw=$('batch-species').value.trim();await launch({name:raw==='fully-evolved'?'Fully evolved baseline':`${raw} / baseline`,species:raw==='fully-evolved'?raw:raw.toUpperCase().split(',').map(s=>s.trim()).filter(Boolean),repetitions:Number($('batch-reps').value),seed:Number($('seed').value),level:100,policies:['tactical','tactical'],max_turns:100},Number($('batch-jobs').value));});
async function loadRuns(){
  runs=await api('/api/runs');
  const runOptions=runs.map(r=>[r.id,`${r.name} · ${r.completed}/${r.total}`]);
  if(!selectedRun&&runs.length)selectedRun=runs[0].id;
  $('run-select').innerHTML=options(runOptions,selectedRun);
  const first=$('compare-first').value,second=$('compare-second').value;
  $('compare-first').innerHTML=options(runOptions,first||runs[0]?.id);$('compare-second').innerHTML=options(runOptions,second||runs[1]?.id);
  if(selectedRun)await renderRun();else $('ranking-body').innerHTML='<tr><td colspan="8" class="empty">Run your first experiment to see battle-based rankings.</td></tr>';
}
async function renderRun(){
  const requestedRun=selectedRun;
  const run=await api(`/api/run?id=${requestedRun}&group=${$('rank-group').value}&offset=${battleOffset}`);
  if(selectedRun!==requestedRun)return;
  runActive=run.active||(!run.paused&&Boolean(run.counts.pending));
  $('run-info').innerHTML=`<div class="panel"><div class="section-title"><div><h2>${esc(run.name)}</h2><p>${run.completed.toLocaleString()} / ${run.total.toLocaleString()} battles · ${run.active?'running':run.paused?'paused':run.counts.pending?'ready to resume':'finished'}</p></div><span class="pill">${esc(run.id)}</span></div><progress class="progress" max="${run.total||1}" value="${run.completed}" aria-label="Experiment progress"></progress><p class="subtle">${esc(Object.entries(run.counts).map(([k,v])=>`${v} ${k}`).join(' · '))}<br>ROM ${esc(run.rom_sha256?.slice(0,16))} · Source ${esc(run.source_sha256.slice(0,16))}</p>${run.exit_code?`<p>Worker exited with code ${run.exit_code}. Inspect output/logs/${esc(run.id)}.log.</p>`:''}</div>`;
  const filtered=run.rankings.filter(r=>!$('rank-type').value||r.name.split('+').some(s=>data.species[s]?.types.includes($('rank-type').value)));
  $('ranking-body').innerHTML=filtered.map((r,i)=>`<tr><td>${i+1}</td><td><strong>${esc(title(r.name))}</strong><small class="build-info">${r.format} · ${r.opponent_count} opponents · ${r.resolved} resolved</small>${r.build?`<small class="build-info">${esc(r.build.map(b=>`${b.ability} / ${b.item} / ${b.moves.join(', ')}`).join(' | '))}</small>`:''}</td><td class="score">${pct(r.score)}</td><td>${r.score_ci95?r.score_ci95.map(pct).join('–'):'Need more seeds'}</td><td>${r.wins} / ${r.losses} / ${r.draws}</td><td>${r.unresolved} / ${r.errors+r.assertion_failures}</td><td>${pct(r.offense_per_turn)}</td><td>${pct(r.remaining_hp_fraction)}</td></tr>`).join('')||'<tr><td colspan="8" class="empty">No resolved battles yet. Results will appear here as they finish.</td></tr>';
  $('export-csv').href=`/api/export?run=${selectedRun}&format=csv`; $('export-csv').download=`${selectedRun}.csv`;
  $('export-json').href=`/api/export?run=${selectedRun}&format=json`; $('export-json').download=`${selectedRun}.json`;
  $('battle-list').innerHTML=run.battles.map(b=>`<button class="battle-record" data-battle="${b.id}">${esc(b.name)}<span>${esc(b.status)} ↗</span></button>`).join('');
  $('battle-list').querySelectorAll('[data-battle]').forEach(e=>e.onclick=action(async()=>showBattle((await api(`/api/battle?run=${selectedRun}&id=${e.dataset.battle}`)).result,'battle-detail')));
  if(quickRun===selectedRun&&!run.active&&!run.counts.pending&&run.battles.length){const record=await api(`/api/battle?run=${selectedRun}&id=${run.battles[0].id}`);showBattle(record.result,'quick-result');quickRun=null;}
}
function showBattle(result,target){
  if(!result){$(target).innerHTML='<p class="empty">This battle is still queued.</p>';return;}
  if(result.failures.length&&result.status!=='error')result={...result,status:'assertion-failed'};
  $(target).innerHTML=`<article class="panel"><div class="section-title"><div><div class="eyebrow">BATTLE RECORD · ${esc(result.format)}</div><h2>${esc(result.winner==='unresolved'?result.status:`${result.winner} wins`)}</h2><p>${result.turns} turns · ${result.seconds}s · seed ${result.scenario.seed}</p></div><span class="pill">${esc(result.status)}</span></div>${result.error?`<pre>${esc(result.error)}</pre>`:''}${result.failures.length?`<pre>${esc(JSON.stringify(result.failures,null,2))}</pre>`:''}<div class="battle-log">${result.log.map(t=>`<div class="turn"><h3>${t.turn===0?'ENTRY STATE':`TURN ${t.turn}`}</h3><div class="hp-pair"><span>${esc(t.player.species)} · ${t.player.hp}/${t.player.maxhp} HP · ${t.player.weight_hg/10} kg</span><span>${esc(t.enemy.species)} · ${t.enemy.hp}/${t.enemy.maxhp} HP · ${t.enemy.weight_hg/10} kg</span></div>${(t.actions||[]).map(a=>`<p>${esc(a.side)} used <strong>${esc(title(a.move))}</strong>${a.damage_attempts?.length?' · '+a.damage_attempts.map(d=>`${d.base_power==null?'special damage rule':d.base_power+' BP'} / ${d.missed?'missed':`${d.damage} calculated damage`}${d.critical?' / critical':''}`).join(', '):''}</p>`).join('')}<details><summary class="subtle">Full checkpoint</summary><pre>${esc(JSON.stringify(t,null,2))}</pre></details></div>`).join('')}</div></article>`;
}
$('run-select').onchange=()=>{selectedRun=$('run-select').value;battleOffset=0;renderRun().catch(e=>notice(e.message,true));};
['rank-group','rank-type'].forEach(id=>$(id).onchange=()=>selectedRun&&renderRun().catch(e=>notice(e.message,true)));
$('reload-runs').onclick=action(loadRuns);
$('pause-run').onclick=action(async()=>{if(selectedRun){await api('/api/pause',{id:selectedRun});await renderRun();}});
$('resume-run').onclick=action(async()=>{if(selectedRun){await api('/api/resume',{id:selectedRun,jobs:Number($('batch-jobs').value)});await renderRun();}});
$('previous-battles').onclick=action(async()=>{battleOffset=Math.max(0,battleOffset-100);if(selectedRun)await renderRun();});
$('next-battles').onclick=action(async()=>{battleOffset+=100;if(selectedRun)await renderRun();});
$('compare-runs').onclick=action(async()=>{$('run-diff').textContent=JSON.stringify(await api(`/api/compare?first=${$('compare-first').value}&second=${$('compare-second').value}`),null,2);});
$('refresh-data').onclick=action(async()=>{const result=await api('/api/refresh',{});data=result.data;renderBuild('player');renderBuild('enemy');renderDex();notice('Current source and compiled ROM records agree. New experiments will use the refreshed data.');});
async function init(){
  const response=await api('/api/catalogue');data=response.data;token=response.token;
  $('metrics').innerHTML=[[Object.keys(data.species).length,'SPECIES','Actual stats & typings'],[Object.keys(data.moves).length,'MOVES','Custom effects included'],[Object.keys(data.abilities).length-1,'ABILITIES','Native activation routines'],['4','WEIGHT MOVES','Coded weight & power scaling']].map(([v,label,sub])=>`<div class="metric"><small>${label}</small><strong>${v}</strong><span>${sub}</span></div>`).join('');
  const typeEntries=[...new Set(Object.values(data.species).flatMap(s=>s.types))].sort().map(k=>[k,title(k)]);
  $('rank-type').innerHTML=options([['','All types'],...typeEntries],'');
  $('dex-type').innerHTML=options([['','All types'],...typeEntries],'');
  builds.player=(await api('/api/candidates?species=GENGAR'))[0];builds.enemy=(await api('/api/candidates?species=MACHAMP'))[0];
  renderBuild('player');renderBuild('enemy');renderDex();dexDetail('GENGAR');estimate();
  $('scenario-json').value=JSON.stringify(currentScenario(),null,2);$('data-version').textContent=`DATA ${data.data_sha256.slice(0,12).toUpperCase()}`;
  await loadRuns();
  setInterval(async()=>{if(polling||!selectedRun||(!runActive&&!quickRun))return;polling=true;try{await renderRun();}catch(error){notice(error.message,true);}finally{polling=false;}},3000);
}
init().catch(error=>notice(error.message,true));
