/*
 * mod-skinshifter - the Skinshifter class entry (class 33) in the server's data.
 *
 * Runs before the DBC stores and player data load (OnAfterConfigLoad) and keeps three rows in the world database:
 *   chrclasses_dbc      class 33 itself (name, file name, mana as its power),
 *   player_class_stats  its level stats, copied from a source class (Druid by default: a hybrid with mana),
 *   playercreateinfo    a start position for every race in Skinshifter.Class.Races, copied from that race's Rogue
 *                       (or its first class when it has no Rogue).
 * Every table and column is checked in information_schema first, so a database with another layout gets an error
 * in the log instead of a crash. A core without skinshifter-core.patch (MAX_CLASSES of 33) cannot hold class 33, so
 * there the rows are removed again.
 *
 * This code is released under the GNU AGPL v3 like AzerothCore.
 */

#include "AscensionCoAConfig.h"
#include "CommandScript.h"
#include "Config.h"
#include "DBCStores.h"
#include "Chat.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "Opcodes.h"
#include "WorldPacket.h"
#include "WorldSession.h"
#include "WorldSessionMgr.h"
#include "SpellMgr.h"
#include "DatabaseEnv.h"
#include "Log.h"
#include "TemporarySummon.h"
#include "Pet.h"
#include <algorithm>
#include "ScriptMgr.h"
#include "SharedDefines.h"
#include "SkinshifterSpells.h"
#include "StringConvert.h"
#include "StringFormat.h"
#include "Tokenize.h"

using namespace Acore::ChatCommands;

#include <array>
#include <cstring>
#include <fstream>
#include <iterator>
#include <initializer_list>
#include <string>
#include <vector>

namespace
{
constexpr uint32 SkinshifterClassId = 33;
constexpr uint32 ChrClassesColumns = 60;

bool HasColumns(char const* table, std::initializer_list<char const*> columns)
{
    for (char const* column : columns)
    {
        if (!WorldDatabase.Query("SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() "
            "AND TABLE_NAME = '{}' AND COLUMN_NAME = '{}'", table, column))
        {
            LOG_ERROR("module", "Skinshifter: `{}` has no column `{}`; the class entry is not installed.", table, column);
            return false;
        }
    }
    return true;
}

uint32 ColumnCount(char const* table)
{
    QueryResult result = WorldDatabase.Query("SELECT COUNT(*) FROM information_schema.COLUMNS WHERE "
        "TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '{}'", table);
    return result ? result->Fetch()[0].Get<uint32>() : 0;
}

bool LayoutKnown()
{
    if (ColumnCount("chrclasses_dbc") != ChrClassesColumns)
    {
        LOG_ERROR("module", "Skinshifter: `chrclasses_dbc` does not have the {} columns of ChrClasses.dbc; the class "
            "entry is not installed.", ChrClassesColumns);
        return false;
    }
    return HasColumns("chrclasses_dbc", { "ID", "Field01", "DisplayPower", "PetNameToken", "Name_Lang_enUS",
               "Name_Lang_Mask", "Name_Female_Lang_Mask", "Name_Male_Lang_Mask", "Filename", "SpellClassSet", "Flags",
               "CinematicSequenceID", "Required_Expansion" }) &&
        HasColumns("player_class_stats", { "Class", "Level", "BaseHP", "BaseMana", "Strength", "Agility", "Stamina",
               "Intellect", "Spirit" }) &&
        HasColumns("playercreateinfo", { "race", "class", "map", "zone", "position_x", "position_y", "position_z",
               "orientation" });
}

struct GameTable
{
    char const* file;
    char const* sqlTable;
    uint32 rowsPerClass;
    uint32 firstIndex;
};

// The class-indexed stat tables: index = firstIndex + (class - 1) * rowsPerClass + row.
constexpr std::array<GameTable, 8> GameTables =
{{
    { "gtChanceToMeleeCrit.dbc",          "gtchancetomeleecrit_dbc",          100, 0 },
    { "gtChanceToMeleeCritBase.dbc",      "gtchancetomeleecritbase_dbc",      1,   0 },
    { "gtChanceToSpellCrit.dbc",          "gtchancetospellcrit_dbc",          100, 0 },
    { "gtChanceToSpellCritBase.dbc",      "gtchancetospellcritbase_dbc",      1,   0 },
    { "gtOCTRegenHP.dbc",                 "gtoctregenhp_dbc",                 100, 0 },
    { "gtRegenHPPerSpt.dbc",              "gtregenhpperspt_dbc",              100, 0 },
    { "gtRegenMPPerSpt.dbc",              "gtregenmpperspt_dbc",              100, 0 },
    { "gtOCTClassCombatRatingScalar.dbc", "gtoctclasscombatratingscalar_dbc", 32,  1 },
}};

uint32 ClassBlockStart(GameTable const& table, uint32 classId)
{
    return table.firstIndex + (classId - 1) * table.rowsPerClass;
}

std::vector<float> ReadGameTable(std::string const& path)
{
    std::ifstream file(path, std::ios::binary);
    std::vector<char> data((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
    if (data.size() < 20 || std::memcmp(data.data(), "WDBC", 4) != 0)
        return {};
    uint32 header[4];
    std::memcpy(header, data.data() + 4, sizeof(header));
    uint32 const count = header[0];
    uint32 const fields = header[1];
    uint32 const size = header[2];
    if ((fields != 1 && fields != 2) || size != fields * 4 || data.size() < 20 + std::size_t(count) * size)
        return {};
    // One-field tables are indexed by row; two-field tables carry the index as their first field.
    std::vector<float> values;
    for (uint32 row = 0; row < count; ++row)
    {
        char const* record = data.data() + 20 + std::size_t(row) * size;
        uint32 index = row;
        if (fields == 2)
            std::memcpy(&index, record, sizeof(index));
        if (index >= values.size())
            values.resize(index + 1, 0.0f);
        std::memcpy(&values[index], record + (fields - 1) * 4, sizeof(float));
    }
    return values;
}

void RemoveGameTableRows()
{
    for (GameTable const& table : GameTables)
        if (HasColumns(table.sqlTable, { "ID", "Data" }))
            WorldDatabase.DirectExecute("DELETE FROM `{}` WHERE `ID` >= {} AND `ID` < {}", table.sqlTable,
                ClassBlockStart(table, SkinshifterClassId), ClassBlockStart(table, SkinshifterClassId + 1));
}

void InstallGameTableRows(uint32 statsFrom)
{
    std::string dataDir = sConfigMgr->GetOption<std::string>("DataDir", "./");
    if (!dataDir.empty() && dataDir.back() != '/' && dataDir.back() != '\\')
        dataDir += '/';

    uint32 installed = 0;
    for (GameTable const& table : GameTables)
    {
        if (ColumnCount(table.sqlTable) != 2 || !HasColumns(table.sqlTable, { "ID", "Data" }))
            continue;
        std::vector<float> const values = ReadGameTable(dataDir + "dbc/" + table.file);
        uint32 const from = ClassBlockStart(table, statsFrom);
        if (values.size() < from + table.rowsPerClass)
        {
            LOG_ERROR("module", "Skinshifter: could not read class {} from {}dbc/{}.", statsFrom, dataDir, table.file);
            continue;
        }
        uint32 const to = ClassBlockStart(table, SkinshifterClassId);
        std::string rows;
        for (uint32 row = 0; row < table.rowsPerClass; ++row)
            rows += Acore::StringFormat("{}({}, {})", row ? ", " : "", to + row, values[from + row]);
        WorldDatabase.DirectExecute("REPLACE INTO `{}` (`ID`, `Data`) VALUES {}", table.sqlTable, rows);
        ++installed;
    }
    LOG_INFO("module", "Skinshifter: class {} stat tables installed ({} of {}).", SkinshifterClassId, installed,
        GameTables.size());
}

// Steed Shift's passenger seat (vehicle_dbc and vehicleseat_dbc are read with the DBC files, after this): copies of
// the Mechano-hog's vehicle (318, one passenger) and the X-53 Touring Rocket's passenger seat (7770, riding pose),
// the seat on the mount model's rider point and without the vehicle's own enter and exit animations. A seat's
// attachment is an index into the client's seat table: 21 is model attachment 0, where a normal rider sits (index
// 0 is attachment 20, which most mounts lack: the passenger sat on the head or the neck). Skinshifter.SteedShift.
// SeatOffset moves the passenger from that point (the client patch reads the same option). The whole body rides
// (flag 0x4, upper anim Mount too): with the lower body alone the hands hung by the sides, off the reins.
constexpr uint32 SteedSeatAttachment = 21;  // the client's seat table: model attachment 0

void InstallSteedSeat()
{
    using namespace SkinshifterSpells;
    std::array<float, 3> offset = { 0.0f, 0.0f, 0.0f };
    std::string const text = sConfigMgr->GetOption<std::string>("Skinshifter.SteedShift.SeatOffset", "0 0 0");
    std::vector<std::string_view> const parts = Acore::Tokenize(text, ' ', false);
    for (size_t index = 0; index < parts.size() && index < offset.size(); ++index)
        if (Optional<float> value = Acore::StringTo<float>(parts[index]))
            offset[index] = *value;
    WorldDatabase.DirectExecute("REPLACE INTO `vehicle_dbc` VALUES ({}, 1073741824, 3.142, 3.142, 0, 0, 0, {}, 0, 0, "
        "0, 0, 0, 0, 0, 1, 1.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', 0, 0, 0, 224, 0, 0, 0)",
        SteedVehicleId, SteedSeatId);
    WorldDatabase.DirectExecute("REPLACE INTO `vehicleseat_dbc` VALUES ({}, {}, {}, {}, {}, {}, 0, 10, 19.290001, 0.75, "
        "1.5, 1, 3, 37, 38, -1, 91, -1, 91, 0, 10, 19.290001, 0.5, 1, 1, 4, 37, 38, 39, 0, 0, 0, -1, 226, 107, 158, "
        "1, 1, 1, 0, 0, 1, 0, 0, 0, 1073741872, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)", SteedSeatId, int32(0xDA00800F),
        SteedSeatAttachment, offset[0], offset[1], offset[2]);
}

void RemoveSteedSeat()
{
    WorldDatabase.DirectExecute("DELETE FROM `vehicle_dbc` WHERE `ID` = {}", SkinshifterSpells::SteedVehicleId);
    WorldDatabase.DirectExecute("DELETE FROM `vehicleseat_dbc` WHERE `ID` = {}", SkinshifterSpells::SteedSeatId);
}

void RemoveClassRows()
{
    RemoveSteedSeat();
    RemoveGameTableRows();
    WorldDatabase.DirectExecute("DELETE FROM `chrclasses_dbc` WHERE `ID` = {}", SkinshifterClassId);
    WorldDatabase.DirectExecute("DELETE FROM `player_class_stats` WHERE `Class` = {}", SkinshifterClassId);
    WorldDatabase.DirectExecute("DELETE FROM `playercreateinfo` WHERE `class` = {}", SkinshifterClassId);
}

std::vector<uint32> ConfiguredRaces()
{
    std::vector<uint32> races;
    std::string const list = sConfigMgr->GetOption<std::string>("Skinshifter.Class.Races", "59,87,90,93,103,104,106,109");
    if (list == "all" || list.empty())
    {
        // Every race with a start position for some other class, as every CoA class is open to every race.
        if (QueryResult result = WorldDatabase.Query("SELECT DISTINCT `race` FROM `playercreateinfo` WHERE `class` <> {} "
            "ORDER BY `race`", SkinshifterClassId))
        {
            do
                races.push_back(result->Fetch()[0].Get<uint32>());
            while (result->NextRow());
        }
        return races;
    }
    for (std::string_view token : Acore::Tokenize(list, ',', false))
        if (Optional<uint32> race = Acore::StringTo<uint32>(token))
            races.push_back(*race);
    return races;
}

void InstallClassRows()
{
    std::string const name = sConfigMgr->GetOption<std::string>("Skinshifter.Class.Name", "Skinshifter");
    uint32 const statsFrom = sConfigMgr->GetOption<uint32>("Skinshifter.Class.StatsFromClass", CLASS_DRUID);

    WorldDatabase.DirectExecute("DELETE FROM `chrclasses_dbc` WHERE `ID` = {}", SkinshifterClassId);
    WorldDatabase.DirectExecute(
        "INSERT INTO `chrclasses_dbc` (`ID`, `Field01`, `DisplayPower`, `PetNameToken`, `Name_Lang_enUS`, "
        "`Name_Lang_Mask`, `Name_Female_Lang_Mask`, `Name_Male_Lang_Mask`, `Filename`, `SpellClassSet`, `Flags`, "
        "`CinematicSequenceID`, `Required_Expansion`) VALUES ({}, 1, {}, 1, '{}', 16712191, 16712172, 16712172, "
        "'SKINSHIFTER', {}, 2, 0, 0)", SkinshifterClassId, uint32(POWER_MANA), name,
        SkinshifterSpells::SkinshifterFamily);

    WorldDatabase.DirectExecute("DELETE FROM `player_class_stats` WHERE `Class` = {}", SkinshifterClassId);
    WorldDatabase.DirectExecute(
        "INSERT INTO `player_class_stats` (`Class`, `Level`, `BaseHP`, `BaseMana`, `Strength`, `Agility`, `Stamina`, "
        "`Intellect`, `Spirit`) SELECT {}, `Level`, `BaseHP`, `BaseMana`, `Strength`, `Agility`, `Stamina`, `Intellect`, "
        "`Spirit` FROM `player_class_stats` WHERE `Class` = {}", SkinshifterClassId, statsFrom);

    InstallGameTableRows(statsFrom);

    WorldDatabase.DirectExecute("DELETE FROM `playercreateinfo` WHERE `class` = {}", SkinshifterClassId);
    uint32 races = 0;
    for (uint32 race : ConfiguredRaces())
    {
        QueryResult source = WorldDatabase.Query("SELECT `class` FROM `playercreateinfo` WHERE `race` = {} AND "
            "`class` <> {} ORDER BY (`class` = {}) DESC, `class` LIMIT 1", race, SkinshifterClassId, uint32(CLASS_ROGUE));
        if (!source)
        {
            LOG_WARN("module", "Skinshifter: race {} has no start position to copy; it cannot be a Skinshifter.", race);
            continue;
        }
        WorldDatabase.DirectExecute(
            "INSERT INTO `playercreateinfo` (`race`, `class`, `map`, `zone`, `position_x`, `position_y`, `position_z`, "
            "`orientation`) SELECT `race`, {}, `map`, `zone`, `position_x`, `position_y`, `position_z`, `orientation` "
            "FROM `playercreateinfo` WHERE `race` = {} AND `class` = {}", SkinshifterClassId, race,
            source->Fetch()[0].Get<uint32>());
        ++races;
    }
    LOG_INFO("module", "Skinshifter: class {} ({}) installed for {} races, stats from class {}.", SkinshifterClassId,
        name, races, statsFrom);
}

// Weapon and armour skills a Skinshifter starts with: the Rogue's family plus staves and cloth for the caster side.
constexpr std::array<uint32, 7> StartSkillSpells =
{
    9078,  // Cloth
    9077,  // Leather
    1180,  // Daggers
    201,   // One-Handed Swords
    15590, // Fist Weapons
    227,   // Staves
    203    // Unarmed
};

struct KitItem
{
    uint32 itemId;
    uint32 count;
};

// Skinshifter's own starter pack, the same for every race: the CharStartOutfit table on the server only covers the
// first 20 races.
constexpr std::array<KitItem, 8> StarterKit =
{{
    { 49,   1 },  // Footpad's Shirt
    { 48,   1 },  // Footpad's Pants
    { 47,   1 },  // Footpad's Shoes
    { 2092, 1 },  // Worn Dagger
    { 35,   1 },  // Bent Staff, for the caster side
    { 4540, 4 },  // Tough Hunk of Bread
    { 159,  2 },  // Refreshing Spring Water
    { 6948, 1 },  // Hearthstone
}};

void GiveStarterSpells(Player* player);

// Passives every Skinshifter has; learned each login so existing characters get them too.
// (Dual Wield comes with the Beastskin specialization: SkinshifterSpec.cpp.)
constexpr std::array<uint32, 1> ClassPassives =
{
    3127, // Parry (only Hero has it in SkillLineAbility, so a class 33 never got it)
};

// Racial abilities of the stock races are learned with the class mask, which class 33 does not have (0): every
// racial row lists classes. A Skinshifter learns its race's abilities as class 14 does, the one class whose bit is
// in the generic racial mask and in the custom-class variants (Blood Fury, Arcane Torrent). Custom races get theirs
// from CoA's racial sync already.
constexpr uint32 RacialProxyClassMask = 1u << (14 - 1);

void LearnRacials(Player* player)
{
    uint32 const raceMask = player->getRaceMask();
    for (uint32 row = 0; row < sSkillLineAbilityStore.GetNumRows(); ++row)
    {
        SkillLineAbilityEntry const* ability = sSkillLineAbilityStore.LookupEntry(row);
        if (!ability || ability->AcquireMethod != SKILL_LINE_ABILITY_LEARNED_ON_SKILL_LEARN || !ability->RaceMask ||
            !(ability->RaceMask & raceMask) || (ability->ClassMask && !(ability->ClassMask & RacialProxyClassMask)))
            continue;
        if (player->HasSkill(ability->SkillLine) && !player->HasSpell(ability->Spell) &&
            sSpellMgr->GetSpellInfo(ability->Spell))
            player->learnSpell(ability->Spell);
    }
}

// The Rogue create skills also bring the empty Rogue class lines; a Skinshifter has its own tabs.
constexpr std::array<uint16, 3> LeftoverRogueSkills = { 38, 39, 253 };

void GiveClassBasics(Player* player)
{
    player->LearnDefaultSkills();
    for (uint16 skill : LeftoverRogueSkills)
        if (player->HasSkill(skill))
            player->SetSkill(skill, 0, 0, 0);
    for (uint32 spellId : ClassPassives)
        if (!player->HasSpell(spellId) && sSpellMgr->GetSpellInfo(spellId))
            player->learnSpell(spellId);
    LearnRacials(player);
    SkinshifterSpells::LearnSkillLines(player);
    GiveStarterSpells(player);
    SkinshifterSpells::ApplySpec(player);
}

// The Skinshifter's spells reach the client through CoA's spell stream, which goes out only once the client reports
// it is ready (CMSG_EXTENSION_INITIALIZED) or after a fallback delay - after the login spell list. A client that was
// just started drops spell ids it does not know yet, so the spell list and the action bars are sent again after the
// stream. (A relog without restarting the client kept the stream rows, which is why the spells came and went.)
constexpr uint16 CmsgExtensionInitialized = 0x0561;

void ResendSpellbook(Player* player)
{
    GiveClassBasics(player);
    player->SendInitialSpells();
    player->SendActionButtons(1);
    // Level 10 or more without a specialization: the window opens (the addon is listening by now).
    if (player->GetLevel() >= SkinshifterSpells::SpecLevel && !SkinshifterSpells::CurrentSpec(player))
        SkinshifterSpells::SendSpecState(player, true);
    LOG_INFO("module", "Skinshifter: spell list and action bars sent again to {} after the client spell stream.",
        player->GetName());
}

bool KitGiven(Player* player)
{
    return bool(CharacterDatabase.Query("SELECT 1 FROM `skinshifter_kit` WHERE `guid` = {}", player->GetGUID().GetCounter()));
}

// The starter spells, learned and put on the first action bar (only into empty buttons).
void GiveStarterSpells(Player* player)
{
    uint8 button = 0;
    bool placed = false;
    // A Possessor has Possess and Release instead of Steal Form and Shed Skin (and the other way round if the race
    // list changed): swap the spell and every action button that holds it.
    bool const possessor = SkinshifterSpells::IsPossessorRace(player->getRace());
    for (auto const& [skinshifterSpell, possessorSpell] : SkinshifterSpells::PossessorSwaps())
    {
        uint32 const wrong = possessor ? skinshifterSpell : possessorSpell;
        uint32 const right = possessor ? possessorSpell : skinshifterSpell;
        if (!player->HasSpell(wrong) || !sSpellMgr->GetSpellInfo(right))
            continue;
        player->removeSpell(wrong, SPEC_MASK_ALL, false);
        player->learnSpell(right);
        for (uint8 slot = 0; slot < MAX_ACTION_BUTTONS; ++slot)
            if (ActionButton const* action = player->GetActionButton(slot))
                if (action->GetType() == ACTION_BUTTON_SPELL && action->GetAction() == wrong)
                {
                    player->addActionButton(slot, right, ACTION_BUTTON_SPELL);
                    placed = true;
                }
    }
    // Spells that left the starter kit go, unless the character stole them from a creature since.
    for (uint32 spellId : SkinshifterSpells::FormerStarterSpells())
    {
        if (!player->HasSpell(spellId) || CharacterDatabase.Query("SELECT 1 FROM `skinshifter_grimoire` WHERE "
            "`guid` = {} AND `spell` = {}", player->GetGUID().GetCounter(), spellId))
            continue;
        player->removeSpell(spellId, SPEC_MASK_ALL, false);
        for (uint8 slot = 0; slot < MAX_ACTION_BUTTONS; ++slot)
            if (ActionButton const* action = player->GetActionButton(slot))
                if (action->GetType() == ACTION_BUTTON_SPELL && action->GetAction() == spellId)
                {
                    player->removeActionButton(slot);
                    placed = true;
                }
    }
    for (uint32 spellId : SkinshifterSpells::StarterSpells(player->getRace(), player->GetLevel()))
    {
        if (!sSpellMgr->GetSpellInfo(spellId))
            continue;
        bool const newlyLearned = !player->HasSpell(spellId);
        // Known but not active: the server's cast handler drops every cast of it without an answer (the client
        // lights the button and waits). Learned again, it is active.
        bool const inactive = !newlyLearned && !player->HasActiveSpell(spellId);
        if (inactive)
            player->removeSpell(spellId, SPEC_MASK_ALL, false);
        if (newlyLearned || inactive)
            player->learnSpell(spellId);
        LOG_INFO("module", "Skinshifter: {} starter spell {}: {}", player->GetName(), spellId,
            inactive ? (player->HasActiveSpell(spellId) ? "known but not active: learned again" :
                "known but not active, and learning it again FAILED") :
            !newlyLearned ? "already known" : player->HasSpell(spellId) ? "learned" : "learning it FAILED");
        // On the bar if it is nowhere on it yet (also for spells known before, whose buttons the client dropped).
        // Only one button of it: a new character got Root Walk twice.
        bool onBar = false;
        for (uint8 slot = 0; slot < MAX_ACTION_BUTTONS; ++slot)
            if (ActionButton const* action = player->GetActionButton(slot))
                if (action->GetType() == ACTION_BUTTON_SPELL && action->GetAction() == spellId)
                {
                    if (onBar)
                    {
                        player->removeActionButton(slot);
                        placed = true;
                    }
                    onBar = true;
                }
        while (button < 12 && player->GetActionButton(button))
            ++button;
        if (!onBar && button < 12)
        {
            player->addActionButton(button++, spellId, ACTION_BUTTON_SPELL);
            placed = true;
        }
    }
    if (placed)
        player->SendActionButtons(1);
}

void GiveStarterKit(Player* player)
{
    for (uint32 spellId : StartSkillSpells)
        if (!player->HasSpell(spellId))
            player->learnSpell(spellId);
    for (KitItem const& item : StarterKit)
        if (sObjectMgr->GetItemTemplate(item.itemId) && !player->HasItemCount(item.itemId, 1, true))
            player->StoreNewItemInBestSlots(item.itemId, item.count);
    CharacterDatabase.Execute("REPLACE INTO `skinshifter_kit` (`guid`) VALUES ({})", player->GetGUID().GetCounter());
    ChatHandler(player->GetSession()).SendSysMessage("You receive the Skinshifter's starter pack.");
}

class SkinshifterClassPlayerScript : public PlayerScript
{
public:
    SkinshifterClassPlayerScript() : PlayerScript("SkinshifterClassPlayerScript",
        { PLAYERHOOK_ON_LOGIN, PLAYERHOOK_ON_DELETE, PLAYERHOOK_ON_FORGOT_SPELL,
          PLAYERHOOK_ON_AFTER_UPDATE_ATTACK_POWER_AND_DAMAGE, PLAYERHOOK_ON_LEVEL_CHANGED, PLAYERHOOK_ON_LOGOUT,
          PLAYERHOOK_ON_PLAYER_IS_CLASS, PLAYERHOOK_ON_CALCULATE_TALENTS_POINTS, PLAYERHOOK_CAN_LEARN_TALENT,
          PLAYERHOOK_ON_BEFORE_GUARDIAN_INIT_STATS_FOR_LEVEL }) { }

    // Armour and shield rules ask for a legacy class; class 33 matched none, so it counted as a cloth wearer (it
    // could not Need on leather in group loot). It wears leather like a Druid, which also allows spell power leather
    // for the caster specs and no shields.
    Optional<bool> OnPlayerIsClass(Player const* player, Classes playerClass, ClassContext context) override
    {
        if (player->getClass() != SkinshifterClassId)
            return std::nullopt;
        if (context == CLASS_CONTEXT_EQUIP_ARMOR_CLASS || context == CLASS_CONTEXT_EQUIP_SHIELDS)
            return playerClass == CLASS_DRUID;
        return std::nullopt;
    }

    // Class 33 has no bit in the 32-bit class masks: 1 << 32 comes out as 1 on x64, the Warrior bit, so the stock
    // talent check would accept the Warrior trees. The Skinshifter's trees are its own: no stock talent points, and
    // no stock talent can be learned.
    void OnPlayerCalculateTalentsPoints(Player const* player, uint32& talentPointsForLevel) override
    {
        if (player->getClass() == SkinshifterClassId)
            talentPointsForLevel = 0;
    }

    bool OnPlayerCanLearnTalent(Player* player, TalentEntry const* /*talent*/, uint32 /*rank*/) override
    {
        return player->getClass() != SkinshifterClassId;
    }

    // A pet summoned by class 33 got no pet type ("Unknown type pet") and skipped the summon set-up.
    void OnPlayerBeforeGuardianInitStatsForLevel(Player* player, Guardian* guardian, CreatureTemplate const* /*cinfo*/,
        PetType& petType) override
    {
        if (player->getClass() == SkinshifterClassId && guardian->IsPet() && petType == MAX_PET_TYPE)
            petType = SUMMON_PET;
    }

    void OnPlayerLevelChanged(Player* player, uint8 oldLevel) override
    {
        if (player->getClass() != SkinshifterClassId)
            return;
        SkinshifterSpells::OnSkinshifterLevel(player, oldLevel);
        if (oldLevel < SkinshifterSpells::TakeoverLevel() && player->GetLevel() >= SkinshifterSpells::TakeoverLevel())
        {
            GiveStarterSpells(player);  // the takeovers
            ChatHandler(player->GetSession()).SendSysMessage(SkinshifterSpells::IsPossessorRace(player->getRace()) ?
                "You can take over creatures now: Hostile Takeover and Willing Host." :
                "You can take over creatures now: Turnskin and Kindred Skin.");
        }
    }

    void OnPlayerLogout(Player* player) override
    {
        SkinshifterSpells::ForgetSpec(player->GetGUID().GetCounter());
    }

    // AC works out attack power per class and class 33 is in none of its cases: melee had none at all, ranged the
    // generic Agility - 10. A Skinshifter gets the Rogue's: melee 2 per level + Strength + Agility - 20, ranged
    // + 1 per level.
    void OnPlayerAfterUpdateAttackPowerAndDamage(Player* player, float& level, float& baseAttackPower,
        float& /*attackPowerMod*/, float& /*attackPowerMultiplier*/, bool ranged) override
    {
        if (player->getClass() != SkinshifterClassId)
            return;
        if (ranged)  // the generic ranged formula gives Agility - 10; a Rogue also gets 1 per level
        {
            baseAttackPower += level;
            return;
        }
        float const classPower = level * 2.0f + player->GetStat(STAT_STRENGTH) + player->GetStat(STAT_AGILITY) - 20.0f;
        baseAttackPower += std::max(0.0f, classPower);
    }

    // Diagnostics: which of the Skinshifter's own spells a character loses, and when.
    void OnPlayerForgotSpell(Player* player, uint32 spellId) override
    {
        if (spellId >= SkinshifterSpells::StealForm && spellId < SkinshifterSpells::StealForm + 1000)
            LOG_INFO("module", "Skinshifter: {} lost spell {} (in world: {}, level {}).", player->GetName(), spellId,
                player->IsInWorld(), uint32(player->GetLevel()));
    }

    // Every login: add missing default skills (languages, armour), and the starter pack once per character, so
    // characters made before these existed are completed too.
    void OnPlayerLogin(Player* player) override
    {
        if (player->getClass() != SkinshifterClassId)
            return;
        SkinshifterSpells::LoadSpec(player);
        GiveClassBasics(player);
        if (!KitGiven(player))
            GiveStarterKit(player);
        // A new character's first login is followed by CoA's own first-login setup, which takes the abilities away
        // again; the same check a moment later, after all of it, gives back what is missing.
        player->m_Events.AddEventAtOffset([player]()
        {
            LOG_INFO("module", "Skinshifter: {} checked again 2 s after login.", player->GetName());
            GiveClassBasics(player);
        }, 2s);
        player->m_Events.AddEventAtOffset([player]() { SkinshifterSpells::RefundBrokenTrees(player); }, 1s);
        // CoA's fallback stream goes out 5 s after login when the client never reports ready.
        player->m_Events.AddEventAtOffset([player]() { ResendSpellbook(player); }, 7s);
    }

    void OnPlayerDelete(ObjectGuid guid, uint32 /*accountId*/) override
    {
        CharacterDatabase.Execute("DELETE FROM `skinshifter_kit` WHERE `guid` = {}", guid.GetCounter());
        CharacterDatabase.Execute("DELETE FROM `skinshifter_spec` WHERE `guid` = {}", guid.GetCounter());
    }
};

}

// Diagnostics: a cast of one of the Skinshifter's own spells as the client sends it, with what the server's cast
// handler drops without a word (a spell it does not count as known, a queued cast, possessing a unit).
void LogOwnCast(WorldSession* session, WorldPacket const& packet)
{
    Player* player = session ? session->GetPlayer() : nullptr;
    if (!player || player->getClass() != SkinshifterClassId || packet.size() < 5)
        return;
    uint32 spellId = 0;
    std::memcpy(&spellId, packet.contents() + 1, sizeof(spellId));
    if (spellId < SkinshifterSpells::StealForm || spellId >= SkinshifterSpells::StealForm + 1000)
        return;
    LOG_INFO("module", "Skinshifter: {} client casts spell {} (known and active: {}, in spell list: {}, queued casts: "
        "{}, possessing: {}, spell loaded: {}).", player->GetName(), spellId, player->HasActiveSpell(spellId),
        player->HasSpell(spellId), player->SpellQueue.size(), player->isPossessing(),
        sSpellMgr->GetSpellInfo(spellId) != nullptr);
}

class SkinshifterClientReadyScript : public ServerScript
{
public:
    SkinshifterClientReadyScript() : ServerScript("SkinshifterClientReadyScript", { SERVERHOOK_CAN_PACKET_RECEIVE }) { }

    bool CanPacketReceive(WorldSession* session, WorldPacket const& packet) override
    {
        if (session && packet.GetOpcode() == CMSG_CHAR_ENUM)
            SendAscensionCoAConfig(session);
        if (packet.GetOpcode() == CMSG_CAST_SPELL)
        {
            LogOwnCast(session, packet);
            return true;
        }
        // The possess bar's cancel button while inside a creature: the takeover ends (the hold is not a buff the
        // server would let you cancel).
        if (packet.GetOpcode() == CMSG_CANCEL_AURA && packet.size() >= 4)
        {
            uint32 spellId = 0;
            std::memcpy(&spellId, packet.contents(), sizeof(spellId));
            Player* player = session ? session->GetPlayer() : nullptr;
            if (player && SkinshifterSpells::HandleTakeoverCancel(player, spellId))
                return false;
            return true;
        }
        if (packet.GetOpcode() != CmsgExtensionInitialized)
            return true;
        Player* player = session ? session->GetPlayer() : nullptr;
        if (player && player->getClass() == SkinshifterClassId)
            player->m_Events.AddEventAtOffset([player]() { ResendSpellbook(player); }, 1500ms);
        return true;
    }

    bool CanPacketReceive(WorldSession* session, WorldPacket& packet) override
    {
        return CanPacketReceive(session, static_cast<WorldPacket const&>(packet));
    }
};

class SkinshifterClassWorldScript : public WorldScript
{
public:
    SkinshifterClassWorldScript() : WorldScript("SkinshifterClassWorldScript", { WORLDHOOK_ON_AFTER_CONFIG_LOAD }) { }

    void OnAfterConfigLoad(bool reload) override
    {
        if (reload)
            return;
        CharacterDatabase.DirectExecute("CREATE TABLE IF NOT EXISTS `skinshifter_kit` (`guid` INT UNSIGNED NOT NULL, "
            "PRIMARY KEY (`guid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
        CharacterDatabase.DirectExecute("CREATE TABLE IF NOT EXISTS `skinshifter_spec` (`guid` INT UNSIGNED NOT NULL, "
            "`spec` TINYINT UNSIGNED NOT NULL, PRIMARY KEY (`guid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
        if (!LayoutKnown())
            return;

        if constexpr (MAX_CLASSES <= SkinshifterClassId)
        {
            LOG_WARN("module", "Skinshifter: this worldserver was built without skinshifter-core.patch; class {} "
                "is removed from the database.", SkinshifterClassId);
            RemoveClassRows();
            SkinshifterSpells::Remove();
            return;
        }

        // Off keeps the class rows. Deleting them drops existing Skinshifters off the character list.
        bool const offered = sConfigMgr->GetOption<bool>("Skinshifter.Enable", true) &&
            sConfigMgr->GetOption<bool>("Skinshifter.Class.Enable", true);
        InstallClassRows();
        if (sConfigMgr->GetOption<bool>("Skinshifter.SteedShift.Passenger", true))
            InstallSteedSeat();
        else
            RemoveSteedSeat();
        if (offered)
            SkinshifterSpells::Install();
        else
            SkinshifterSpells::Remove();
    }
};

namespace
{
bool ReplaceConfValues(std::string const& path, std::vector<std::pair<std::string, bool>> const& values)
{
    std::ifstream input(path);
    if (!input)
        return false;
    std::string out;
    std::string line;
    std::vector<bool> found(values.size(), false);
    while (std::getline(input, line))
    {
        if (!line.empty() && line.back() == '\r')
            line.pop_back();
        for (size_t index = 0; index < values.size(); ++index)
        {
            std::string const& key = values[index].first;
            if (line.rfind(key, 0) == 0 && line.size() > key.size() &&
                (line[key.size()] == ' ' || line[key.size()] == '='))
            {
                line = key + " = " + (values[index].second ? "1" : "0");
                found[index] = true;
            }
        }
        out += line + '\n';
    }
    if (std::find(found.begin(), found.end(), false) != found.end())
        return false;
    std::ofstream output(path, std::ios::trunc);
    if (!output)
        return false;
    output << out;
    return static_cast<bool>(output);
}

void TellFeatureClients()
{
    WorldPacket packet = BuildAscensionCoAConfig();
    for (auto const& session : sWorldSessionMgr->GetAllSessions())
        if (session.second)
            session.second->SendPacket(&packet);
}

bool ApplyFeature(ChatHandler* handler, bool skinshifter, bool on)
{
    bool const wrote = skinshifter
        ? ReplaceConfValues("configs/modules/skinshifter.conf",
            { { "Skinshifter.Enable", on }, { "Skinshifter.Class.Enable", on } })
        : ReplaceConfValues("configs/modules/mod_subclass.conf",
            { { "Subclass.Enable", on }, { "Subclass.TwoPlayers.Enable", on } });
    if (!wrote)
    {
        handler->SendSysMessage("Could not save the switch. The config file was left as it was.");
        handler->SetSentErrorMessage(true);
        return false;
    }
    if (!sConfigMgr->Reload())
    {
        handler->SendSysMessage("The switch was saved, but the server could not reload it. Restart the world.");
        handler->SetSentErrorMessage(true);
        return false;
    }
    if (skinshifter)
    {
        if (on)
        {
            InstallClassRows();
            if (sConfigMgr->GetOption<bool>("Skinshifter.SteedShift.Passenger", true))
                InstallSteedSeat();
            else
                RemoveSteedSeat();
            SkinshifterSpells::Install();
        }
        else
            SkinshifterSpells::Remove();
    }
    TellFeatureClients();
    handler->PSendSysMessage("{} is now {}. The character creation screen {} it. People who already have a character keep it.",
        skinshifter ? "Skinshifter" : "Subclass", on ? "on" : "off", on ? "shows" : "hides");
    return true;
}
}

void PushFeatureConfig(AscensionClientConfig& config)
{
    config.Booleans.emplace_back("CONFIG_SKINSHIFTER_ENABLED",
        sConfigMgr->GetOption<bool>("Skinshifter.Enable", true) &&
        sConfigMgr->GetOption<bool>("Skinshifter.Class.Enable", true));
    config.Booleans.emplace_back("CONFIG_SUBCLASS_ENABLED",
        sConfigMgr->GetOption<bool>("Subclass.Enable", true) &&
        sConfigMgr->GetOption<bool>("Subclass.TwoPlayers.Enable", true));
}

struct FeatureConfigRegistration
{
    FeatureConfigRegistration() { RegisterAscensionClientConfig(&PushFeatureConfig); }
};

FeatureConfigRegistration const featureConfigRegistration;

class SkinshifterFeatureCommandScript : public CommandScript
{
public:
    SkinshifterFeatureCommandScript() : CommandScript("SkinshifterFeatureCommandScript") { }

    static bool HandleDisableSkinshifter(ChatHandler* handler) { return ApplyFeature(handler, true, false); }
    static bool HandleDisableSubclass(ChatHandler* handler) { return ApplyFeature(handler, false, false); }
    static bool HandleEnableSkinshifter(ChatHandler* handler) { return ApplyFeature(handler, true, true); }
    static bool HandleEnableSubclass(ChatHandler* handler) { return ApplyFeature(handler, false, true); }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable disableTable =
        {
            { "skinshifter", HandleDisableSkinshifter, SEC_ADMINISTRATOR, Console::Yes },
            { "subclass", HandleDisableSubclass, SEC_ADMINISTRATOR, Console::Yes },
        };
        static ChatCommandTable enableTable =
        {
            { "skinshifter", HandleEnableSkinshifter, SEC_ADMINISTRATOR, Console::Yes },
            { "subclass", HandleEnableSubclass, SEC_ADMINISTRATOR, Console::Yes },
        };
        static ChatCommandTable commandTable =
        {
            { "disable", disableTable },
            { "enable", enableTable },
        };
        return commandTable;
    }
};

void AddSC_skinshifter_class()
{
    new SkinshifterClassWorldScript();
    new SkinshifterClassPlayerScript();
    new SkinshifterClientReadyScript();
    new SkinshifterFeatureCommandScript();
}
