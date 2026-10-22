/* Copyright (C) 2016+ AzerothCore, GNU AGPL v3. */

#include "CoACustomRaces.h"
#include "Config.h"

namespace CoACustomRaces
{
    bool IsEnabled()
    {
        static bool const enabled = sConfigMgr->GetOption<bool>("CoACustomRaces.Enable", false);
        return enabled;
    }

    std::string const& DbcDirectory()
    {
        static std::string const directory = sConfigMgr->GetOption<std::string>("CoACustomRaces.DbcDirectory", "dbc_races");
        return directory;
    }

    Hooks& GetHooks()
    {
        static Hooks hooks;
        return hooks;
    }

    bool UsesExtraAppearance(uint32 race)
    {
        return IsEnabled() && (UsesExtendedAppearance(race) || UsesHaranirAppearance(race));
    }

    bool HasOwnRacials(uint8 race)
    {
        Hooks const& hooks = GetHooks();
        return IsEnabled() && hooks.HasOwnRacials && hooks.HasOwnRacials(race);
    }

    bool IsVanillaRacialSkill(uint32 skill)
    {
        Hooks const& hooks = GetHooks();
        return IsEnabled() && hooks.IsVanillaRacialSkill && hooks.IsVanillaRacialSkill(skill);
    }

    bool HasCustomDisplay(uint8 race, uint8 gender)
    {
        Hooks const& hooks = GetHooks();
        return IsEnabled() && hooks.HasCustomDisplay && hooks.HasCustomDisplay(race, gender);
    }

    uint32 CustomDisplay(Player const* player)
    {
        Hooks const& hooks = GetHooks();
        return IsEnabled() && hooks.CustomDisplay ? hooks.CustomDisplay(player) : 0;
    }

    void AppendRacialSpells(uint8 race, std::vector<uint32>& spells)
    {
        Hooks const& hooks = GetHooks();
        if (IsEnabled() && hooks.AppendRacialSpells)
            hooks.AppendRacialSpells(race, spells);
    }

    bool ChooseBotRace(BotCreation& bot)
    {
        Hooks const& hooks = GetHooks();
        return !IsEnabled() || !hooks.ChooseBotRace || hooks.ChooseBotRace(bot);
    }
}
