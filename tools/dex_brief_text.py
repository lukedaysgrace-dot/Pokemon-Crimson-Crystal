"""
Curated two-page Pokédex blurbs (hack-added species).
Each line ≤42 chars so Crystal fits 3×17-char lines cleanly.
"""

from __future__ import annotations

BRIEF_DEX: dict[str, tuple[str, str]] = {
    "gurdurr": (
        "It swings steel beams to train each day.",
        "Rivals flex iron bars to boast strength.",
    ),
    "deino": (
        "It bites whatever it meets when upset.",
        "Blind, it snaps at sounds and motion.",
    ),
    "farigiraf": (
        "One head fights while the other watches.",
        "Both heads stay alert day and night.",
    ),
    "golett": (
        "Clay dust guards ruins by old orders.",
        "Magic keeps its sturdy frame walking.",
    ),
    "tangrowth": (
        "Vines snag prey that stray too close.",
        "Torn vines grow back thick overnight.",
    ),
    "baxcalibur": (
        "Icy breath flash-freezes any threat.",
        "It rumbles like a mountain in snow.",
    ),
    "venipede": (
        "Bites pump venom that stuns its prey.",
        "It rolls as a spiky living wheel.",
    ),
    "porygon_z": (
        "Strange code made its mind unstable.",
        "It drifts in data and glitches out.",
    ),
    "glaceon": (
        "It chills air to form snow and ice.",
        "Foes freeze solid on direct contact.",
    ),
    "dusknoir": (
        "It leads lost spirits past the veil.",
        "Its head picks up faraway voices.",
    ),
    "arctibax": (
        "It freezes prey with frigid breath.",
        "It hides on cliffs and strikes below.",
    ),
    "gliscor": (
        "Silent wings glide it toward prey.",
        "It hangs beneath cliffs and waits.",
    ),
    "volcarona": (
        "Scattered sparks mimic rays of sun.",
        "Old murals hailed its blazing wings.",
    ),
    "leafeon": (
        "Fresh leaf scent hangs near its fur.",
        "It feeds on sunlight like a plant.",
    ),
    "frigibax": (
        "It nibbles ice to cool its hot blood.",
        "Cold rivers hide its snowy patrol.",
    ),
    "salamence": (
        "Wings grew from long dreams of flight.",
        "It dives from clouds with cruel joy.",
    ),
    "impidimp": (
        "It steals shiny things from quiet rooms.",
        "It eats spite when folks lose cool.",
    ),
    "larvesta": (
        "Its horns roast foes like live coals.",
        "Old tribes kept warm cocoons sacred.",
    ),
    "ralts": (
        "Its horn senses moods all around.",
        "It hides when rage fills nearby hearts.",
    ),
    "electivire": (
        "Electric cords crackle on its limbs.",
        "It jams live wires against bulky foes.",
    ),
    "tinkatuff": (
        "It swings a junk forge hammer hard.",
        "It fixes scrap while smashing rivals.",
    ),
    "cradily": (
        "It mimicked weeds on ancient seabeds.",
        "Curious prey vanished among fronds.",
    ),
    "ceruledge": (
        "Ghost flames lace both sword arms.",
        "Armor bears an oath of dark revenge.",
    ),
    "ursaluna": (
        "Moon fog hides this peat bog giant.",
        "It claws frozen roots from hard soil.",
    ),
    "annihilape": (
        "Pure rage fuels punch after punch.",
        "Its temper shakes dirt underfoot.",
    ),
    "dusclops": (
        "Its round body drinks stray matter.",
        "One red eye tracks foes through fog.",
    ),
    "grimmsnarl": (
        "Hair limbs swipe like heavy clubs.",
        "It cheats then brawls rough up close.",
    ),
    "lickilicky": (
        "Sticky spit traps foes on contact.",
        "It tongues new stuff with messy joy.",
    ),
    "yanmega": (
        "Huge wings whip gusts that shear bark.",
        "It snaps birds mid-air with swift jaws.",
    ),
    "armarogue": (
        "Armor fused with cannon-fire pride.",
        "It fires bursts taught by old codes.",
    ),
    "sylveon": (
        "Ribbon feelers soothe foes with calm.",
        "Galar tales praise ribbon charms.",
    ),
    "weavile": (
        "Packs hunt prey down with sharp claws.",
        "Scratch marks guide allies through snow.",
    ),
    "lileep": (
        "It feigned kelp on shallow sea rocks.",
        "Tides rocked bait till prey drew near.",
    ),
    "dreepy": (
        "This dart wants someone to shoot it.",
        "It rides ally shots like tiny ammo.",
    ),
    "duskull": (
        "It glides dark woods hunting souls.",
        "Its hollow eye pierces stone walls.",
    ),
    "tinkaton": (
        "Hammer blows punch holes through steel.",
        "It steals tools and pounds foes flat.",
    ),
    "timburr": (
        "It lifts lumber like gym weights.",
        "Sites echo steady training swings.",
    ),
    "morgrem": (
        "Hair legs trip foes during a brawl.",
        "It hoards loot and hates to lose cash.",
    ),
    "shelgon": (
        "Stone armor hides slow wing growth.",
        "It waits alone for sky-born dreams.",
    ),
    "charcadet": (
        "A tiny knight trains inner spirit.",
        "Armor waits for a worthy hero.",
    ),
    "magmortar": (
        "Blast arms roast foes from afar.",
        "Magma heat fills its wide round gut.",
    ),
    "wyrdeer": (
        "Bright antlers sense paths in snow.",
        "Herds follow when storms blind trails.",
    ),
    "mamoswine": (
        "Ice tusks once carved glacier paths.",
        "It charges drifts to crush intruders.",
    ),
    "mismagius": (
        "Its spells cause aches and odd luck.",
        "Night sparkles when it spins its hex.",
    ),
    "golurk": (
        "Ancient seals lock power in clay.",
        "Hidden jets vault it across ruins.",
    ),
    "drakloak": (
        "It stores Dreepy ammo in its gut.",
        "It fires allies like guided shots.",
    ),
    "whirlipede": (
        "Rolling downhill faster than most birds.",
        "Poison rows spin around its shell.",
    ),
    "kirlia": (
        "It dances when its Trainer feels joy.",
        "Bright moods boost psychic talent.",
    ),
    "hydreigon": (
        "Three heads feud while it wrecks land.",
        "It eats every scrap that still moves.",
    ),
    "ambipom": (
        "Its tails act like fast clever hands.",
        "Branches blur when it swings away.",
    ),
    "conkeldurr": (
        "It swings huge pillars like toy bats.",
        "Work zones shake from booming swings.",
    ),
    "tinkatink": (
        "It pounds ore till a hammer forms.",
        "Shy, it hides scrap behind boulders.",
    ),
    "bagon": (
        "Iron skull bashes rock as it leaps.",
        "It wants to fly but grows no wings yet.",
    ),
    "scolipede": (
        "It runs prey down with fierce poison.",
        "Horns stab first; venom ends the fight.",
    ),
    "gardevoir": (
        "It shields allies by warping space.",
        "Loyal hearts unleash psychic power.",
    ),
    "armaldo": (
        "Plates once shielded old sea hunters.",
        "Claws cut prey caught on sea rocks.",
    ),
    "zweilous": (
        "Two heads brawl over every meal.",
        "It eats until the wild goes quiet.",
    ),
    "dragapult": (
        "It fires hidden Dreepy like darts.",
        "Kids nap in pods till fights begin.",
    ),
    "magnezone": (
        "Magnets float it while radar scans.",
        "Three eyes pulse strange sky signals.",
    ),
    "rhyperior": (
        "Rock drills launch from both thick arms.",
        "Armor shrugs off blunt heavy blows.",
    ),
    "togekiss": (
        "It visits calm lands with soft luck.",
        "It shuns regions torn by cruel war.",
    ),
}
