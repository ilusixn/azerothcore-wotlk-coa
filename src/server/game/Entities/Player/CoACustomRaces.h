/* Copyright (C) 2016+ AzerothCore, GNU AGPL v3. */

#ifndef COA_CUSTOM_RACES_H
#define COA_CUSTOM_RACES_H

#include "Define.h"
#include <string>
#include <vector>

class Player;

namespace CoACustomRaces
{
    inline constexpr bool IsStockRace(uint32 race)
    {
        return race >= 1 && race <= 11 && race != 9;
    }

    inline constexpr bool UsesExtendedAppearance(uint32 race)
    {
        return race == 66 || race == 68 || race == 69;
    }

    inline constexpr bool UsesHaranirAppearance(uint32 race)
    {
        return race == 70 || race == 71;
    }

    struct Hooks
    {
        uint32 (*CustomDisplay)(Player const* player) = nullptr;
        bool (*HasCustomDisplay)(uint8 race, uint8 gender) = nullptr;
        void (*AppendRacialSpells)(uint8 race, std::vector<uint32>& spells) = nullptr;
        bool (*HasOwnRacials)(uint8 race) = nullptr;
        bool (*IsVanillaRacialSkill)(uint32 skill) = nullptr;
    };

    bool IsEnabled();
    std::string const& DbcDirectory();
    Hooks& GetHooks();

    bool UsesExtraAppearance(uint32 race);
    bool HasOwnRacials(uint8 race);
    bool IsVanillaRacialSkill(uint32 skill);
    bool HasCustomDisplay(uint8 race, uint8 gender);
    uint32 CustomDisplay(Player const* player);
    void AppendRacialSpells(uint8 race, std::vector<uint32>& spells);
}

#endif
