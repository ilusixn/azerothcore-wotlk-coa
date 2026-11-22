# mod-coa-devmenu: Dev Menu (made by ilusixn)

An in-game dev menu for **AzerothCore (WotLK 3.3.5a)** with a client addon for **any 3.3.5a (12340) client**.
GM accounts browse every NPC, preview it in 3D, spawn it and edit everything about it from inside the game.
Changes are saved to the world database and applied live: you don't need to restart or use `.reload`.

It's a plain module. It doesn't need core patches or a SQL install, and it only talks over addon whisper messages (prefix `CDEV`).

## Install

1. **Server:** copy this folder into `azerothcore/modules/`, re-run CMake and build `worldserver`.
   Optional: copy `conf/mod_coa_devmenu.conf.dist` next to your other module confs as `mod_coa_devmenu.conf`.
2. **Client:** copy `client/CoA_DevMenu` into `World of Warcraft/Interface/AddOns/`.
3. Log in on a GM account and type `/dev`.

| Config | Default | Meaning |
|---|---|---|
| `DevMenu.Enable` | 1 | Turn the module on or off |
| `DevMenu.MinSecurity` | 2 | Lowest account level allowed (2 = GM, 3 = admin) |

## What it does

- **Browse:** search every creature template by name, title or entry. Filters: friendly, hostile, neutral, critters, services, custom (entry 9 900 000+).
  - **Ctrl+Click or double-click:** opens the 3D preview (drag to rotate, wheel to zoom).
  - **Right-click:** opens a menu with preview, spawn, favourites, save to a category, duplicate as a new NPC, rename the NPC type, copy the entry id, and turn the selected spawn into this NPC.
- **Categories:** your own folders of NPCs plus Favourites. They're stored in the addon's SavedVariables, account-wide.
- **Spawn:** saved at your position and facing, or a 5-minute preview copy.
- **Selected NPC:**
  - **Placement:** move to me, face me, and a nudge pad (forward/back/left/right/up/down/turn) relative to where you face.
  - **Movement & actions:** stand still, wander with a radius, or walk a path. Choose a looping emote (work, mining, sit, dance, ready…) or play an emote once to test it.
  - **Role & faction:** services (vendor, repair, trainer, innkeeper, banker, auctioneer, flight master, stable master…), shop items, guard behaviour and faction.
  - **Identity:** name and title, level, model (display id), change which NPC a spawn is, and make a spawn unique.
  - **Advanced:** level, faction, rank (elite/boss/rare), health/damage/armor/mana/XP multipliers, respawn time, aggro range, walk/run speed, attack speed, gold, loot id, gossip menu, creature type, family and class.
    - **Flags:** PvP, can't be attacked by players, ignores NPCs, not selectable, pacified, rooted, civilian, gives no XP, health regen.
    - **Kill reputation:** faction, amount and the standing it stops at.
- **Path editor:** walk around and press *Add point here* (or `/dev point`); a marker shows each point. Choose loop or back-and-forth, walk or run, and a wait at the ends, then save. You can also show, edit or remove an existing path.
- **Nearby spawns:** saved spawns around you, sorted by distance.

- **Services** (Selected NPC tab): shop items (stock, restock, extended cost); trainers (type, greeting, spells with cost, level and skill); talk menus with greeting text, options, service presets and submenus.
- **Quests:** create a quest given by the selected NPC and edit its text, objectives, rewards, rules and chain. Choose which NPCs give and finish it, and turn it into an escort: the NPC walks a path recorded in the Path editor.
  - **AI helper:** builds a prompt from your idea and the current quest. Paste it into any AI chat, paste the answer back, and Apply fills every field.
- **Objects & assets:** search object types or every object model, 3D preview, spawn at your feet, nearby list.
  - **Editing a placed object:** move, nudge relative to you or on world axes, rotate (facing, tilt forward, tilt sideways), duplicate and delete.
  - **Raw models:** spawning one creates a decoration object type for it automatically (entries 9 980 001+).
- **Emotes:** search every emote in Emotes.dbc (the addon ships it as `EmoteData.lua`).

| Table | Ids created by the menu |
|---|---|
| quest_template | 9 990 001 – 9 999 999 |
| npc_text | 16 000 001+ |
| gossip_menu | 9 998 001 – 9 998 999 |
| trainer | 9 980 001+ |
| waypoints (escort) | 99 800 000 + quest id |

## Notes

- Name, level, look, faction, flags and the fields in Advanced belong to the NPC **type** (creature_template), so every spawn of that type shares them.
  - Tick *Only this spawn* to copy the type first. Copies use entries 9 980 001–9 989 999.
  - *Duplicate as new NPC* makes a fresh type the same way.
- **Copied NPCs' equipment:** the held weapons and items load after the next restart.
- **Kill reputation:** for an NPC that had none before, it works after the next restart. Changes to an existing one apply immediately.
- **Saved paths:** use waypoint path id = spawn guid × 10, the usual AzerothCore convention.
- **Other players:** they see renamed NPCs once their creature cache refreshes. That happens on relog, or straight away if they delete `Cache/WDB`.
