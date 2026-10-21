#include "CoACustomRaces.h"
#include "DatabaseEnv.h"
#include "Log.h"
#include "Player.h"
#include "ScriptMgr.h"
#include <iterator>
#include <map>
#include <unordered_map>

namespace
{
    std::unordered_map<uint32, std::map<uint32, uint32>> CustomRaceDisplays;

    uint32 DisplayKey(uint8 race, uint8 gender)
    {
        return (uint32(race) << 8) | gender;
    }

    void LoadCustomRaceDisplays()
    {
        CustomRaceDisplays.clear();
        QueryResult result = WorldDatabase.Query("SELECT race, gender, idx, displayId FROM custom_race_display");
        if (!result)
            return;

        uint32 count = 0;
        do
        {
            Field* fields = result->Fetch();
            CustomRaceDisplays[DisplayKey(fields[0].Get<uint8>(), fields[1].Get<uint8>())][fields[2].Get<uint32>()] = fields[3].Get<uint32>();
            ++count;
        } while (result->NextRow());
        LOG_INFO("server.loading", ">> Loaded {} custom race looks", count);
    }

    bool HasCustomDisplay(uint8 race, uint8 gender)
    {
        auto const itr = CustomRaceDisplays.find(DisplayKey(race, gender));
        return itr != CustomRaceDisplays.end() && !itr->second.empty();
    }

    uint32 CustomDisplay(Player const* player)
    {
        if (!player)
            return 0;

        auto const itr = CustomRaceDisplays.find(DisplayKey(player->getRace(true), player->getGender()));
        if (itr == CustomRaceDisplays.end() || itr->second.empty())
            return 0;

        std::map<uint32, uint32> const& looks = itr->second;
        uint32 const skin = player->GetByteValue(PLAYER_BYTES, 0);
        uint32 const hairStyle = player->GetByteValue(PLAYER_BYTES, 2);
        if (auto const look = looks.find(hairStyle * 32 + skin); look != looks.end())
            return look->second;
        if (auto const bySkin = looks.find(skin); bySkin != looks.end())
            return bySkin->second;
        return std::next(looks.begin(), skin % looks.size())->second;
    }
}

class CoACustomRaceDisplayWorld : public WorldScript
{
public:
    CoACustomRaceDisplayWorld() : WorldScript("CoACustomRaceDisplayWorld", { WORLDHOOK_ON_STARTUP }) { }

    void OnStartup() override
    {
        LoadCustomRaceDisplays();
    }
};

void AddCoACustomRaceDisplayScripts()
{
    if (!CoACustomRaces::IsEnabled())
        return;

    CoACustomRaces::Hooks& hooks = CoACustomRaces::GetHooks();
    hooks.HasCustomDisplay = HasCustomDisplay;
    hooks.CustomDisplay = CustomDisplay;
    new CoACustomRaceDisplayWorld();
}
