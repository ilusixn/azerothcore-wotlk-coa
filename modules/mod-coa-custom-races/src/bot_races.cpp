#include "CoACustomRaces.h"
#include "Config.h"
#include "DBCEnums.h"
#include "DBCStores.h"
#include "Log.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "RaceMgr.h"
#include "Random.h"
#include "World.h"
#include <boost/property_tree/json_parser.hpp>
#include <filesystem>
#include <map>
#include <set>
#include <string>
#include <unordered_set>
#include <vector>

// Random bots (mod-playerbots) only get the races the races list allows: playable, botsOk, not clientCrash, not in
// CoACustomRaces.DisabledRaces, and only with CoACustomRaces.BotsEnable = 1. The sex has to be one listed in "sexes".
// The core calls ChooseBotRace from Player::Create when the session is a bot's, so no change in the bots module is needed.
namespace
{
    struct ListedRace
    {
        TeamId team = TEAM_ALLIANCE;
        bool maleOk = true;
        bool femaleOk = true;
        bool allowed = false;
    };

    std::map<uint8, ListedRace> Listed;
    bool BotsEnabled = false;

    bool IsBaseRace(uint8 race)
    {
        return race >= 1 && race <= 11 && race != 9;
    }

    std::string FindListFile()
    {
        std::string const configured = sConfigMgr->GetOption<std::string>("CoACustomRaces.RacesList", "");
        std::vector<std::filesystem::path> candidates;
        if (!configured.empty())
            candidates.emplace_back(configured);
        candidates.push_back(std::filesystem::path(sWorld->GetDataPath()) / ".." / "Races" / "races-list.json");
        candidates.emplace_back("../../Races/races-list.json");
        candidates.emplace_back("Races/races-list.json");
        for (std::filesystem::path const& path : candidates)
        {
            std::error_code error;
            if (std::filesystem::is_regular_file(path, error))
                return path.string();
        }
        return {};
    }

    void LoadRacesList(std::unordered_set<uint8> const& disabled)
    {
        Listed.clear();
        BotsEnabled = sConfigMgr->GetOption<bool>("CoACustomRaces.BotsEnable", false);

        std::string const file = FindListFile();
        if (file.empty())
            LOG_ERROR("server.loading", "CoACustomRaces: races-list.json not found (set CoACustomRaces.RacesList): no added race for bots");
        else
        {
            try
            {
                boost::property_tree::ptree tree;
                boost::property_tree::read_json(file, tree);
                for (auto const& item : tree)
                {
                    boost::property_tree::ptree const& entry = item.second;
                    uint8 const id = entry.get<uint8>("id", 0);
                    if (!id)
                        continue;

                    ListedRace race;
                    race.team = entry.get<std::string>("faction", "alliance") == "horde" ? TEAM_HORDE : TEAM_ALLIANCE;
                    race.maleOk = race.femaleOk = false;
                    if (auto sexes = entry.get_child_optional("sexes"))
                        for (auto const& sex : *sexes)
                        {
                            if (sex.second.data() == "male")
                                race.maleOk = true;
                            else if (sex.second.data() == "female")
                                race.femaleOk = true;
                        }

                    race.allowed = BotsEnabled && entry.get<bool>("playable", false) && entry.get<bool>("botsOk", false) &&
                                   !entry.get<bool>("clientCrash", false) && !disabled.count(id) && (race.maleOk || race.femaleOk);
                    Listed[id] = race;
                }
            }
            catch (std::exception const& error)
            {
                LOG_ERROR("server.loading", "CoACustomRaces: cannot read {}: {} - no added race for bots", file, error.what());
                Listed.clear();
            }
        }

        uint32 allowed = 0;
        std::string blocked;
        for (auto const& [id, race] : Listed)
        {
            if (race.allowed)
                ++allowed;
            else
                blocked += (blocked.empty() ? "" : ", ") + std::to_string(id);
        }
        LOG_INFO("server.loading", "CoACustomRaces: {} races allowed for bots ({} blocked: {}){}", allowed,
            Listed.size() - allowed, blocked.empty() ? "none" : blocked, BotsEnabled ? "" : " - CoACustomRaces.BotsEnable = 0");
    }

    bool RaceAllowed(uint8 race)
    {
        if (IsBaseRace(race))
            return true;
        auto const itr = Listed.find(race);
        return itr != Listed.end() && itr->second.allowed;
    }

    bool SexAllowed(uint8 race, uint8 gender)
    {
        if (IsBaseRace(race))
            return true;
        auto const itr = Listed.find(race);
        if (itr == Listed.end())
            return false;
        return gender == GENDER_MALE ? itr->second.maleOk : itr->second.femaleOk;
    }

    // Same draw as mod-playerbots: a face, a hair style and a facial hair out of the character sections of the race.
    void DrawLook(CoACustomRaces::BotCreation& bot)
    {
        std::vector<uint8> facialHairTypes;
        std::vector<std::pair<uint8, uint8>> faces, hairs;
        for (CharSectionsEntry const* section : sCharSectionsStore)
        {
            if (section->Race != bot.race || section->Gender != bot.gender)
                continue;
            if (section->Flags & SECTION_FLAG_DEATH_KNIGHT)
                continue;

            switch (section->GenType)
            {
                case SECTION_TYPE_FACE:
                    faces.emplace_back(section->Type, section->Color);
                    break;
                case SECTION_TYPE_FACIAL_HAIR:
                    facialHairTypes.push_back(section->Type);
                    break;
                case SECTION_TYPE_HAIR:
                    hairs.emplace_back(section->Type, section->Color);
                    break;
            }
        }

        if (faces.empty())
            faces.emplace_back(0, 0);
        if (hairs.empty())
            hairs.emplace_back(0, 0);

        std::pair<uint8, uint8> const face = faces[urand(0, faces.size() - 1)];
        std::pair<uint8, uint8> const hair = hairs[urand(0, hairs.size() - 1)];
        bool const noFacialHair = bot.gender != GENDER_MALE || bot.race == RACE_TAUREN || bot.race == RACE_DRAENEI || facialHairTypes.empty();
        bot.skin = face.second;
        bot.face = face.first;
        bot.hairStyle = hair.first;
        bot.hairColor = hair.second;
        bot.facialHair = noFacialHair ? 0 : facialHairTypes[urand(0, facialHairTypes.size() - 1)];
    }

    bool ChooseBotRace(CoACustomRaces::BotCreation& bot)
    {
        if (RaceAllowed(bot.race))
        {
            if (SexAllowed(bot.race, bot.gender))
                return true;

            // a sex the race does not have (male-only, female-only): the other one
            uint8 const other = bot.gender == GENDER_MALE ? GENDER_FEMALE : GENDER_MALE;
            if (SexAllowed(bot.race, other))
            {
                bot.gender = other;
                DrawLook(bot);
                return true;
            }
        }

        // A blocked race: another allowed race of the same faction that exists for the class
        TeamId const team = Player::TeamIdForRace(bot.race);
        std::vector<uint8> options;
        for (uint8 race = 1; race < sRaceMgr->GetMaxRaces(); ++race)
            if (RaceAllowed(race) && Player::TeamIdForRace(race) == team && sObjectMgr->GetPlayerInfo(race, bot.charClass) &&
                (SexAllowed(race, GENDER_MALE) || SexAllowed(race, GENDER_FEMALE)))
                options.push_back(race);

        if (options.empty())
            return false;

        bot.race = options[urand(0, options.size() - 1)];
        if (!SexAllowed(bot.race, bot.gender))
            bot.gender = bot.gender == GENDER_MALE ? GENDER_FEMALE : GENDER_MALE;
        DrawLook(bot);
        return true;
    }
}

void LoadCoACustomRaceBotList(std::unordered_set<uint8> const& disabled)
{
    LoadRacesList(disabled);
    CoACustomRaces::GetHooks().ChooseBotRace = ChooseBotRace;
}
