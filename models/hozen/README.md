# Hozen custom models for CoA (3.3.5a client)

Natural, lore-friendly recolors of the Hozen (Wowhead NPC 144261, retail DisplayID 41083 -> CreatureModelData 4178 -> `creature/hozu/hozumonkey.m2`).

**No Blizzard retail files are stored here.** `fetch_retail.py` downloads them from wago.tools by FileDataID into `retail_source/` (git-ignored).

## Contents
- `png/`, `blp/` – 4 variants (jungle, highland, mahogany, snowy): fur (`hozumonkey_*`, 1024²), armor (`hozuarmor_*`, 1024²), helm (`helmhozuarmor_*`, 512²). BLPs are BLP2 256-colour palette, no mipmaps (re-save as DXT5 with mips via BLPConverter if distant rendering looks off).
- `preview.png` – contact sheet.
- `gen.py` – regenerates png/blp from retail textures: `python3 fetch_retail.py --textures-only && python3 gen.py [path/to/creature/hozu]` (run from this folder).
- `fetch_retail.py` – fetch model/skin/anim/textures (68 files).

## Install / conversion (Windows)
1. `python3 fetch_retail.py`
2. Convert `retail_source/creature/hozu/hozumonkey.m2` (with .skin/.anim beside it) to WotLK using MultiConverter (github.com/Adspartan/MultiConverter). Output: 3.3.5 `hozumonkey.m2` + `hozumonkey00.skin`. Particles/ribbons may need manual fixes.
3. Build tree `Creature\Hozu\` with the converted m2/skin + the `blp/*.blp` files.
4. Pack with Ladik's MPQ Editor into a patch MPQ (e.g. `patch-H.MPQ`, unused letter) in the client `Data` folder. The server must also send these display IDs (server-side DBC/DB rows).

## DBC rows (3.3.5 layout)
CreatureModelData: ID=4178 (or free), ModelName=`Creature\Hozu\hozumonkey.mdx`, BloodID=3, FootprintTextureID=4, FootprintTextureLength=18, FootprintTextureWidth=12, FootprintParticleScale=1, CollisionWidth=0.611, CollisionHeight=2.031, GeoBox (-1.131,-0.852,-0.015)/(0.824,0.929,1.312), ModelScale=1.

CreatureDisplayInfo (ModelID = row above, Alpha 255):
| ID | Scale | Tex1 (fur) | Tex2 (armor) | Tex3 (helm) | Look |
|---|---|---|---|---|---|
| 900001 | 1.1 | hozumonkey_jungle | hozuarmor_jungle | helmhozuarmor_jungle | golden-tan fur, worn leather |
| 900002 | 1.3 | hozumonkey_highland | hozuarmor_highland | helmhozuarmor_highland | ash-grey fur, tarnished bronze |
| 900003 | 1.2 | hozumonkey_mahogany | hozuarmor_mahogany | helmhozuarmor_mahogany | dark red-brown, faded red cloth |
| 900004 | 1.0 | hozumonkey_snowy | hozuarmor_snowy | helmhozuarmor_snowy | off-white (Kun-Lai), faded green cloth |
