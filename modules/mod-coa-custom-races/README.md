# mod-coa-custom-races

Server side of **CoA Custom**: extra playable races for Conquest of Azeroth (AzerothCore CoA). With
`CoACustomRaces.Enable = 0` (default) the server behaves like the upstream core. With `1` the races listed in
`races-list.json` can be created and played with the matching client (`races-core-<version>`, the CoA Custom client zip).

## Switches

| Key | Default | File |
|---|---|---|
| `CoACustomRaces.Enable` | `0` | `mod_coa_custom_races.conf` |
| `CoACustomRaces.DbcDirectory` | `"dbc_races"` | relative to `DataDir` |
| `CoACustomRaces.BotsEnable` | `0` | `0` = bots only get the base races |
| `CoACustomRaces.DisabledRaces` | `""` | race ids kept unavailable while enabled (players and bots) |
| `CoACustomRaces.RacesList` | `""` | path of `races-list.json`; empty = `DataDir/../Races/races-list.json`, `../../Races/races-list.json`, `Races/races-list.json` |

`Enable` is read once at startup, before the DBC files load.

## What is gated

Behind `CoACustomRaces::IsEnabled()` (core header `src/server/game/Entities/Player/CoACustomRaces.h`):

* character creation of a race above 11 (and race 9), refused when disabled or listed in `DisabledRaces`;
* the Esteria appearance extension: the sixth appearance byte (Highmountain, Earthen), the 64-bit Haranir appearance,
  the `HXE1` / `HXE2` blocks of the character list, their storage in `characters.extraAppearance`
  (read and written by separate queries, so the stock character queries are untouched);
* custom race looks (`custom_race_display`), weapon-only character list for the races that wear an NPC look;
* racials (`src/racials`: the table `CoaCustomRacials.h`, the Esteria racial scripts, the login sync that gives each
  race exactly its own racials and strips the borrowed vanilla racial lines);
* start data, class availability and stats rows of the custom races (`playercreateinfo*`, `player_race_stats`,
  `ascension_custom_class_race`): the loaders skip them without a message when disabled;
* weapon skills hunters, warriors, paladins, rogues, warlocks and druids of the custom races were missing;
* `.hidearmor` and the free talent reset (`COA_RESET_TALENTS` chat request, spell `14009999`, `.resettalents`);
* the server DBC overrides in `dbc_races/`.

Not gated, and harmless for races 1-11 (race ids above 32 share a mask bit, `1u << ((race - 1) & 31)`):
`Unit::getRaceMask`, `RaceMgr`, `GetSkillRaceClassInfo`, `GetBaseReputationOf`, the `playercreateinfo_*` mask loops,
and the 32-bit display ids of `PlayerInfo` (custom display ids go above 65535).

## SQL

`data/sql/db-world`, `db-characters`, `db-auth`: small, re-runnable (`DELETE` of exactly the keys, then `INSERT`),
no database names. They only add rows for races above 11, spells `14000000-14009999` and `110000-111999`,
`custom_race_display`, helper creatures and objects, Realm First criteria, the `characters.extraAppearance` column,
`coa_hide_armor` and the RBAC permission. No file changes an upstream row. Every file is safe to run twice; a new change
is a new file (`YYYY_MM_DD_NN_description.sql`), a published file is never edited.

Known, for upstream: the Mechagnome racial Mastercraft summons gameobject `184911` under the player, and upstream's
`go_flames` script on it burns whoever stands in it (it killed Mechagnomes). The fix is one upstream row
(`UPDATE gameobject_template SET ScriptName = '' WHERE entry = 184911 AND ScriptName = 'go_flames'`); it was removed from
this pack and has to come from the core's own data.

Permissions (RBAC ids 6000-6099 only): `6001` Command: resettalents.

## DBC files

`dbc_races/` holds the server DBC files the custom races need (copy or point `DataDir` so that
`DataDir/<DbcDirectory>` exists). A file found there replaces the one in `DataDir/dbc`. They match the CoA Custom
client `1.8.2`. `dbc_races/clientset/CreatureDisplayInfo.dbc` is the unpatched client copy the CoA display-patch
stream compares with: with `CoACustomRaces.Enable = 1` and an empty `CoA.ClientDbcDirectory`, the core uses
`<DataDir>/<DbcDirectory>/clientset` by itself (logged once at start).

## races-list.json

One entry per race id the server accepts (`id`, `name`, `faction`, `sexes`, `playable`, `botsOk`, `clientCrash`,
`notes`, `client`). The server reads it for random bots: when `Player::Create` is called by a bot session, a race that is
not `playable` / `botsOk`, is `clientCrash`, is in `DisabledRaces`, or any custom race while `BotsEnable = 0`, is replaced
by an allowed race of the same faction that exists for the class (new face and hair drawn), and a sex the entry does not
list is switched. It logs once `CoACustomRaces: N races allowed for bots (M blocked: ids)`. No change in mod-playerbots is
needed. Without the file no custom race goes to bots.
The `clientCrash` and `botsOk` values come from reports on client 1.7 and were not tested again with 1.8.2.

## Left out on purpose

Not race work, so not in this module: the vanilla classes on Character Advancement (Bronzebeard spell copies, the
Book trainer, unified `coa wcr` class advancement), Wardrobe incarnations of forms and pets (the core has its own
`OnPlayerGetShapeshiftModel` hook now), weapon-only skill maxing, the `UsesProjectileAmmo` change.

## Credits

* **Kalibros** - Esteria races and the Esteria appearance runtime.
* **Uncle Snowzo** (SnowzoCraft) - Jinyu.
* **Dex** - Drakkin (female). **Kalibros** - Drakkin (male) and Drakonid. **Westen** - race lore texts.
* **Furioz, Corruption and the Eunoia team** - Eunoia races.
* **SQUID / Zyth45** - CoA playerbots. **Corfirean** - CoA Server Manager. **jealous-sound** - the Conquest of Azeroth core.
* **ilusixn** - CoA Custom.
