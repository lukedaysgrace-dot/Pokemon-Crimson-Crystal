#!/usr/bin/env python3
"""Work out who says each line in the map scripts, so that a character with an
overworld trainer portrait shows it every time they speak - whether you talked
to them, they spotted you, or a cutscene walked them over to you - and so that
the portrait goes away when somebody else speaks.

Writes data/maps/portrait_texts.asm (included by data/maps/map_data.asm, so it
can name the map files' own labels and object constants), a table of

	dba TextLabel
	db  who          ; 0: nobody with a portrait
	                 ; PORTRAIT_*: that portrait
	                 ; $80 | object: whatever portrait that map object's
	                 ;   current sprite has (so sprite variables still work)

How the speaker of each `writetext`/`jumptext`/`trainertext` is decided, in
order:

  1. OVERRIDES below, for anything the rules get wrong.
  2. Narration ("<PLAYER> received …", "<RIVAL> used …"): nobody.
  3. A "NAME:" prefix on the first line (ELM:, PROF.OAK:, ELDER:, …): that
     character if they have a portrait, otherwise nobody.
  4. Otherwise the script is followed the way the game runs it, from every
     object (you talked to it), trainer header, coord event, scene script,
     callback and sign. Talking to an object starts with it as the speaker;
     `applymovement`, `turnobject`, `showemote`, `faceobject`, `follow`,
     `setlasttalked`, `appear` on another object hand it over (anything aimed
     at PLAYER is ignored); `faceplayer` and LAST_TALKED mean the object that
     was talked to.

Only maps that have a portrait character in them are listed. Unlisted text
never shows a portrait. Ambiguous speakers are errors; settle them in
OVERRIDES before generating the table.

Usage:
  trainer_portrait_texts.py data/maps/portrait_texts.asm
  trainer_portrait_texts.py --report      every decision, for checking by eye
"""

import glob
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def read_lines(path):
	with open(path, encoding='utf-8') as source:
		return source.readlines()

# Maps where a sprite variable stands for a portrait character: the engine
# then shows whatever portrait that object's sprite has at the time.
VARIABLE_SPEAKERS = {
	('OlivineCity', 'SPRITE_OLIVINE_RIVAL'),  # Silver bumping into you
	('AzaleaTown', 'SPRITE_AZALEA_ROCKET'),   # a Rocket, then Silver after Slowpoke Well
}

# Text label -> "NAME" (a PORTRAIT_* suffix) or None (nobody with a portrait).
OVERRIDES = {
	# The Azalea Town Rocket grunts share the sprite variable Silver uses later.
	'AzaleaTownRocket1Text': None,
	'AzaleaTownRocket2Text': None,
	# Ariana (the executive) speaks for the pair when they corner you.
	'UnknownText_0x6d2ad': 'ARIANA',
	'UnknownText_0x6d2c3': 'ARIANA',
	# Clair, lost for words after the Elder's scolding.
	'DragonShrineSpeechlessText': 'CLAIR',
	# Jasmine, while the emote is on Amphy.
	'JasmineAmphyHangOnText': 'JASMINE',
	# Mr. Pokemon, not Oak.
	'MrPokemonText_ImDependingOnYou': None,
	# This text repeats while EVENT_MADE_WHITNEY_CRY is set. The stopped-
	# crying branch uses her regular portrait, including the badge dialogue.
	'WhitneyYouMeanieText': 'WHITNEY_CRYING',
	# Proton is furious after losing at the Well and the Radio Tower.
	'TrainerGruntM1WhenTalkText': 'PROTON_MAD',
	'Executivem2AfterBattleText': 'PROTON_MAD',
}

# "NAME:" prefixes that mean a portrait character, beyond the portrait names.
NAME_ALIASES = {
	'PROF.ELM': 'ELM',
	'PROF.OAK': 'OAK',
	'OAK': 'OAK',
	'ELM': 'ELM',
}

# Oak also speaks through a special (PrintText rather than writetext) while
# rating the Pokedex in his lab. The completion statistics are UI text;
# only his actual assessment has his portrait.
SHARED_SPEAKERS = {f'OakRating{i:02}': 'OAK' for i in range(1, 20)}

# Crystal's in-person Cape dialogue is in a separate bank, reached through
# farwritetext. Her phone texts are deliberately not portrait speakers.
SHARED_SPEAKERS.update({label: 'CRYSTAL' for label in (
	'Route25CrystalBeforeText',
	'Route25CrystalAfterText',
	'Route25CrystalGoCatchItText',
	'Route25CrystalMewCaughtText',
	'Route25CrystalMewEscapedText',
)})

# Whitney starts crying in her battle-loss speech, before returning to the
# map. These are printed by PrintWinLossText rather than map text commands.
SHARED_SPEAKERS.update({label: 'WHITNEY_CRYING' for label in (
	'WhitneyShouldntBeSoSeriousText',
	'WhitneyRematchWinText',
)})

# Proton's defeat lines are printed in battle by PrintWinLossText, before
# his post-battle map dialogue. Both encounters switch to the mad portrait.
SHARED_SPEAKERS.update({label: 'PROTON_MAD' for label in (
	'GruntM1BeatenText',
	'Executivem2BeatenText',
)})

SPEAKER_FIRST = {
	'applymovement', 'setlasttalked', 'appear', 'follow', 'follownotexact',
}
# Turning is usually somebody turning to *listen* (the Elder turning to Clair
# before she speaks), so it only picks a speaker when there is none yet.
SPEAKER_IF_NONE = {'turnobject'}
TEXT_CMDS = {'writetext', 'jumptext', 'jumptextfaceplayer', 'farwritetext', 'farjumptext'}
BRANCH_LAST = {'iftrue', 'iffalse', 'ifequal', 'ifnotequal', 'ifgreater', 'ifless'}
STOP = {
	'end', 'endall', 'return', 'reloadandreturn', 'jumptext', 'jumptextfaceplayer',
	'farjumptext', 'jumpstd', 'scripttalkafter', 'farsjump', 'memjump', 'stopandsjump',
}


def load_portraits():
	path = os.path.join(ROOT, 'engine/events/trainer_portraits.asm')
	sprites = {}
	names = set()
	inside = False
	for line in read_lines(os.path.join(ROOT, 'constants/gfx_constants.asm')):
		m = re.match(r'\s*const\s+PORTRAIT_(\w+)', line)
		if m:
			names.add(m.group(1))
	for line in read_lines(path):
		if line.startswith('SpritePortraits:'):
			inside = True
			continue
		if inside:
			m = re.match(r'\s*db\s+(SPRITE_\w+)\s*,\s*PORTRAIT_(\w+)', line)
			if m:
				sprites[m.group(1)] = m.group(2)
			elif re.match(r'\s*db\s+-1', line):
				break
	return sprites, names


def strip(line):
	out = []
	quoted = False
	for ch in line:
		if ch == '"':
			quoted = not quoted
		if ch == ';' and not quoted:
			break
		out.append(ch)
	return ''.join(out).rstrip()


# Global labels need a colon; local ones (.foo) may leave it off.
LABEL_RE = re.compile(r'^(\.[A-Za-z_]\w*|[A-Za-z_][\w.]*(?=::?))(?::{0,2})')


class MapFile:
	def __init__(self, path, sprite_portraits):
		self.path = path
		self.name = os.path.basename(path)[:-4]
		self.sprite_portraits = sprite_portraits
		self.lines = [strip(l) for l in read_lines(path)]
		self.parse()

	def parse(self):
		self.consts = []
		self.objects = []  # (const, sprite, type, script label)
		self.entries = []  # (label, kind)
		self.labels = {}
		self.scope_of_line = []
		self.variable = {}
		in_consts = False
		scope = None
		for i, line in enumerate(self.lines):
			s = line.strip()
			m = LABEL_RE.match(line)
			if m and not m.group(1).startswith('.'):
				scope = m.group(1)
			self.scope_of_line.append(scope)
			if m:
				self.labels[self.resolve(m.group(1), scope)] = i
			if s.startswith('object_const_def'):
				in_consts = True
				continue
			if in_consts:
				mc = re.match(r'const\s+(\w+)', s)
				if mc:
					self.consts.append(mc.group(1))
					continue
				if s:
					in_consts = False
			args = None
			mo = re.match(r'(object_event|coord_event|bg_event|scene_script|callback|variablesprite)\s+(.*)', s)
			if not mo:
				continue
			kind = mo.group(1)
			args = [a.strip() for a in mo.group(2).split(',')]
			if kind == 'object_event':
				n = len(self.objects)
				const = self.consts[n] if n < len(self.consts) else None
				self.objects.append((const, args[2], args[9], self.resolve(args[11], scope)))
			elif kind == 'coord_event':
				self.entries.append((self.resolve(args[-1], scope), 'coord'))
			elif kind == 'bg_event':
				self.entries.append((self.resolve(args[-1], scope), 'sign'))
			elif kind == 'scene_script':
				self.entries.append((self.resolve(args[0], scope), 'scene'))
			elif kind == 'callback':
				self.entries.append((self.resolve(args[-1], scope), 'callback'))
			elif kind == 'variablesprite':
				self.variable.setdefault(args[0], set()).add(args[1])

	@staticmethod
	def resolve(name, scope):
		if name.startswith('.'):
			return (scope or '') + name
		return name

	def object_index(self, const):
		"""The engine's map object index (hLastTalked numbering)."""
		return self.consts.index(const) + 1

	def sprite_of(self, const):
		for c, sprite, _, _ in self.objects:
			if c == const:
				return sprite
		return None

	def is_variable(self, sprite):
		return sprite is not None and sprite.startswith('SPRITE_') and sprite in VARIABLE_SPRITE_NAMES

	def static_portrait(self, sprite):
		return self.sprite_portraits.get(sprite)

	def has_portrait_character(self):
		for _, sprite, _, _ in self.objects:
			if self.static_portrait(sprite):
				return True
			values = self.variable.get(sprite, set()) | VARIABLE_SPRITE_DEFAULTS.get(sprite, set())
			if self.is_variable(sprite) and any(self.static_portrait(v) for v in values):
				return True
		return False

	def text_lines(self, label):
		i = self.labels.get(label)
		if i is None:
			return []
		out = []
		for line in self.lines[i:]:
			if line != self.lines[i] and LABEL_RE.match(line):
				break
			m = re.search(r'\b(text|line|cont|para|next)\s+"(.*)"', line)
			if m:
				out.append(m.group(2))
			if re.match(r'\s*(done|prompt|text_end)(?:\s|$)', line) and out:
				break
		return out


VARIABLE_SPRITE_NAMES = set()
# Objects that never speak (items, furniture, Pokemon). Talking to one starts
# with no speaker, so the first person turned towards the player is picked.
THING_SPRITES = {
	'SPRITE_POKE_BALL', 'SPRITE_POKEDEX', 'SPRITE_PAPER', 'SPRITE_FOSSIL', 'SPRITE_ROCK',
	'SPRITE_BOULDER', 'SPRITE_FRUIT_TREE', 'SPRITE_GOLD_TROPHY', 'SPRITE_SILVER_TROPHY',
	'SPRITE_N64', 'SPRITE_SNES', 'SPRITE_FAMICOM', 'SPRITE_VIRTUAL_BOY', 'SPRITE_CONSOLE',
	'SPRITE_DOLL_1', 'SPRITE_DOLL_2', 'SPRITE_BIG_DOLL', 'SPRITE_APPLE', 'SPRITE_WEIRD_TREE',
	'SPRITE_BIG_SNORLAX', 'SPRITE_BIG_LAPRAS', 'SPRITE_BIG_ONIX', 'SPRITE_SURFING_PIKACHU',
	'SPRITE_MONSTER', 'SPRITE_FAIRY', 'SPRITE_BIRD', 'SPRITE_DRAGON', 'SPRITE_AMPY_SICK',
	'SPRITE_SLOWPOKE_NOTAIL', 'SPRITE_ENTEI_NPC', 'SPRITE_RAIKOU_NPC', 'SPRITE_SUICUNE_NPC',
	'SPRITE_MEW', 'SPRITE_FINIZEN', 'SPRITE_POLIWRATH_NPC', 'SPRITE_FARFETCH_D_NPC',
	'SPRITE_SLOWBRO_NPC', 'SPRITE_RATTATA_UP',
}
VARIABLE_SPRITE_DEFAULTS = {}  # set when a new game starts (std_scripts.asm)


def load_variable_sprites():
	path = os.path.join(ROOT, 'constants/sprite_constants.asm')
	inside = False
	for line in read_lines(path):
		if line.startswith('SPRITE_VARS'):
			inside = True
			continue
		if inside:
			m = re.match(r'\s*const\s+(SPRITE_\w+)', line)
			if m:
				VARIABLE_SPRITE_NAMES.add(m.group(1))
	pokemon = False
	for line in read_lines(path):
		if line.startswith('SPRITE_POKEMON'):
			pokemon = True
			continue
		if line.startswith('SPRITE_VARS'):
			break
		m = re.match(r'\s*const\s+(SPRITE_\w+)', line)
		if pokemon and m:
			THING_SPRITES.add(m.group(1))
	for path2 in glob.glob(os.path.join(ROOT, 'maps/*.asm')):
		for line in read_lines(path2):
			m = re.match(r'\s*variablesprite\s+(SPRITE_\w+)\s*,\s*(SPRITE_\w+)', line)
			if m:
				VARIABLE_SPRITE_DEFAULTS.setdefault(m.group(1), set()).add(m.group(2))
	for line in read_lines(os.path.join(ROOT, 'engine/events/std_scripts.asm')):
		m = re.match(r'\s*variablesprite\s+(SPRITE_\w+)\s*,\s*(SPRITE_\w+)', line)
		if m:
			VARIABLE_SPRITE_DEFAULTS.setdefault(m.group(1), set()).add(m.group(2))


def walk_map(mf, record):
	seen = set()

	def walk(start, speaker, talker, entry):
		stack = [(start, speaker)]
		while stack:
			i, spk = stack.pop()
			if (i, spk, talker) in seen:
				continue
			seen.add((i, spk, talker))
			while i < len(mf.lines):
				line = mf.lines[i]
				scope = mf.scope_of_line[i]
				i += 1
				s = line.strip()
				m = LABEL_RE.match(s)
				if m:
					s = s[m.end():].strip()
				if not s:
					continue
				parts = s.split(None, 1)
				cmd = parts[0]
				args = [a.strip() for a in parts[1].split(',')] if len(parts) > 1 else []
				if cmd in ('db', 'dw', 'text', 'line', 'para', 'cont', 'done', 'prompt', 'step_end', 'step',
						'text_far', 'text_end', 'trainer'):
					break  # ran into data

				def obj(a):
					if a == 'PLAYER':
						return 'PLAYER'
					if a == 'LAST_TALKED':
						return talker
					return a

				if cmd in SPEAKER_FIRST and args:
					o = obj(args[0])
					if o and o != 'PLAYER':
						spk = o
				elif cmd in SPEAKER_IF_NONE and args and spk is None:
					o = obj(args[0])
					if o and o != 'PLAYER':
						spk = o
				elif cmd == 'showemote' and len(args) >= 2:
					o = obj(args[1])
					if o and o != 'PLAYER':
						spk = o
				elif cmd == 'faceobject' and len(args) >= 2:
					a, b = obj(args[0]), obj(args[1])
					if a and a != 'PLAYER':
						spk = a
					elif b and b != 'PLAYER':
						spk = b
				elif cmd in ('faceplayer', 'applymovementlasttalked'):
					if talker:
						spk = talker
				elif cmd == 'disappear' and args:
					# They've left; whoever speaks next isn't them.
					if obj(args[0]) == spk:
						spk = None
				if cmd in TEXT_CMDS and args:
					who = talker if cmd == 'jumptextfaceplayer' else spk
					record(mf, mf.resolve(args[-1], scope), who, entry, i - 1)
				if cmd in BRANCH_LAST and args:
					target = mf.resolve(args[-1], scope)
					if target in mf.labels:
						stack.append((mf.labels[target], spk))
				elif cmd in ('scall', 'prioritysjump', 'sjump'):
					target = mf.resolve(args[0], scope)
					if target in mf.labels:
						stack.append((mf.labels[target], spk))
					if cmd == 'sjump':
						break
				if cmd in STOP:
					break

	for const, sprite, otype, script in mf.objects:
		if script not in mf.labels:
			continue
		if otype == 'OBJECTTYPE_SCRIPT':
			walk(mf.labels[script], None if sprite in THING_SPRITES else const, const, 'talk')
		elif otype == 'OBJECTTYPE_TRAINER':
			i = mf.labels[script]
			for j in range(i, min(i + 3, len(mf.lines))):
				m = re.match(r'\s*trainer\s+(.*)', mf.lines[j])
				if m:
					args = [a.strip() for a in m.group(1).split(',')]
					scope = mf.scope_of_line[j]
					record(mf, mf.resolve(args[3], scope), const, 'trainer', j)
					after = mf.resolve(args[6], scope)
					if after in mf.labels:
						walk(mf.labels[after], const, const, 'talk')
					break
	for label, kind in mf.entries:
		if label in mf.labels:
			walk(mf.labels[label], None, None, kind)


def decide(mf, label, speaker, portrait_names):
	"""-> ('none',) | ('portrait', NAME) | ('object', const), plus a reason."""
	if label in OVERRIDES:
		v = OVERRIDES[label]
		return (('portrait', v) if v else ('none',)), 'override'
	lines = mf.text_lines(label)
	first = lines[0] if lines else ''
	if re.match(r'^<(PLAYER|RIVAL)> ', first):
		return ('none',), 'narration'
	m = re.match(r'^([A-Z][A-Z.#&\']*[A-Z])\s*:', first)
	if m:
		name = m.group(1)
		name = NAME_ALIASES.get(name, name)
		if name in portrait_names:
			return ('portrait', name), 'prefix'
		return ('none',), 'prefix'
	if speaker is None:
		return ('none',), 'no speaker'
	sprite = mf.sprite_of(speaker)
	if mf.is_variable(sprite):
		# A sprite variable only means a portrait character where it really is
		# one; elsewhere it's a disguise (the Fuchsia Gym Janines) or a
		# stand-in (the Route 40/41 swimmers use SPRITE_OLIVINE_RIVAL).
		if (mf.name, sprite) in VARIABLE_SPEAKERS:
			return ('object', speaker), 'variable sprite'
		return ('none',), 'variable sprite'
	p = mf.static_portrait(sprite)
	if p:
		return ('portrait', p), 'speaker'
	return ('none',), 'speaker'


def main():
	report = '--report' in sys.argv
	load_variable_sprites()
	sprite_portraits, portrait_names = load_portraits()
	maps = [MapFile(p, sprite_portraits) for p in sorted(glob.glob(os.path.join(ROOT, 'maps/*.asm')))]

	uses = {}  # (map, label) -> list of (speaker, entry)
	use_lines = {}  # (map, label) -> lines of the commands that print it

	def record(mf, label, speaker, entry, line=None):
		if label not in mf.labels:
			return  # defined elsewhere (shared text); the engine falls back for those
		uses.setdefault((mf.name, label), []).append((speaker, entry))
		if line is not None:
			use_lines.setdefault((mf.name, label), set()).add(line)

	by_name = {}
	for mf in maps:
		if mf.has_portrait_character():
			by_name[mf.name] = mf
			walk_map(mf, record)

	rows = []
	conflicts = []
	for (mapname, label), speakers in sorted(uses.items()):
		mf = by_name[mapname]
		if all(e == 'sign' for _, e in speakers):
			rows.append((mapname, label, ('none',), {(None, 'sign')}))
			continue
		decisions = {}
		for spk, entry in speakers:
			d, why = decide(mf, label, spk, portrait_names)
			decisions.setdefault(d, set()).add((spk, why))
		if len(decisions) > 1:
			conflicts.append((mapname, label, decisions))
			continue
		d, how = next(iter(decisions.items()))
		rows.append((mapname, label, d, how))

	def show(mf, d):
		if d[0] == 'none':
			return '-'
		if d[0] == 'portrait':
			return d[1]
		sprite = mf.sprite_of(d[1])
		return mf.static_portrait(sprite) or sprite

	if '--review' in sys.argv:
		# Everything a portrait could be shown for, with the script around it.
		for mapname, label, d, how in rows:
			mf = by_name[mapname]
			entries = {e for (mn, lb), sp in uses.items() if (mn, lb) == (mapname, label) for _, e in sp}
			trivial = d[0] == 'none' and all(w in ('speaker',) for _, w in how) and \
				not any(mf.static_portrait(mf.sprite_of(sp)) for sp, _ in how if sp)
			if d[0] == 'none' and ('narration' in {w for _, w in how}):
				continue
			if trivial and entries <= {'talk', 'trainer'}:
				continue
			print('=' * 78)
			print(f'{show(mf, d)}  {mapname}  {label}  ({",".join(sorted({w for _, w in how}))}; {",".join(sorted(entries))})')
			for ln in sorted(use_lines.get((mapname, label), ())):
				ctx = [l.strip() for l in mf.lines[max(0, ln - 6):ln + 1] if l.strip()]
				print('   > ' + ' | '.join(ctx))
			print('   ' + ' / '.join(mf.text_lines(label)))
		return

	if report:
		for mapname, label, d, how in rows:
			mf = by_name[mapname]
			why = ','.join(sorted({w for _, w in how}))
			who = ','.join(sorted({str(s) for s, _ in how}))
			print(f'{show(mf, d):14} {mapname:26} {label:42} {why:15} [{who}] | {" / ".join(mf.text_lines(label)[:2])}')
		for mapname, label, decisions in conflicts:
			mf = by_name[mapname]
			print(f'CONFLICT       {mapname:26} {label:42} {[(show(mf, d), sorted(map(str, v))) for d, v in decisions.items()]} | {" / ".join(mf.text_lines(label)[:2])}')
		return

	if conflicts:
		for mapname, label, decisions in conflicts:
			print(f'error: {mapname}: {label} has more than one speaker; add it to OVERRIDES', file=sys.stderr)
		raise SystemExit(1)
	out = sys.argv[1]
	with open(out, 'w') as f:
		f.write('; Generated by tools/trainer_portrait_texts.py from maps/*.asm - do not edit.\n')
		f.write('; Corrections go in OVERRIDES in that script.\n\n')
		f.write('PortraitTexts:\n')
		f.write('; text, who (0: nobody / PORTRAIT_*: that portrait / $80 | map object)\n')
		current = None
		for mapname, label, d, how in rows:
			mf = by_name[mapname]
			if mapname != current:
				f.write(f'; {mapname}\n')
				current = mapname
			if d[0] == 'none':
				who = '0'
			elif d[0] == 'portrait':
				who = f'PORTRAIT_{d[1]}'
			else:
				who = f'$80 | {mf.object_index(d[1])} ; {d[1]}'
			f.write(f'\tdba {label}\n\tdb {who}\n')
		f.write('; Shared dialogue printed by specials or farwritetext\n')
		for label, who in sorted(SHARED_SPEAKERS.items()):
			f.write(f'\tdba {label}\n\tdb PORTRAIT_{who}\n')
		f.write('\tdb -1 ; end\n')
	for mapname, label, decisions in conflicts:
		print(f'{out}: warning: {mapname}: {label} has more than one speaker; add it to OVERRIDES', file=sys.stderr)


if __name__ == '__main__':
	main()
