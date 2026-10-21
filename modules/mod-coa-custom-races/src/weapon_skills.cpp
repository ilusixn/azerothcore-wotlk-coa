#include "CoACustomRaces.h"
#include "Player.h"
#include "ScriptMgr.h"
#include <algorithm>
#include <array>

namespace
{
    struct WeaponSkill
    {
        uint32 classMask;
        uint16 skill;
    };

    constexpr std::array<WeaponSkill, 5> WeaponSkills =
    {{
        { 1u << (CLASS_HUNTER - 1), 45 },
        { 1u << (CLASS_HUNTER - 1), 46 },
        { 1u << (CLASS_HUNTER - 1), 226 },
        { (1u << (CLASS_WARRIOR - 1)) | (1u << (CLASS_PALADIN - 1)), 160 },
        { (1u << (CLASS_WARRIOR - 1)) | (1u << (CLASS_HUNTER - 1)) | (1u << (CLASS_ROGUE - 1)) |
            (1u << (CLASS_WARLOCK - 1)) | (1u << (CLASS_DRUID - 1)), 173 },
    }};
}

class CoACustomRaceWeaponSkills : public PlayerScript
{
public:
    CoACustomRaceWeaponSkills() : PlayerScript("CoACustomRaceWeaponSkills", { PLAYERHOOK_ON_LOGIN }) { }

    void OnPlayerLogin(Player* player) override
    {
        if (CoACustomRaces::IsStockRace(player->getRace(true)))
            return;

        uint16 const value = uint16(std::min<uint32>(player->GetLevel() * 5, 400));
        for (WeaponSkill const& weapon : WeaponSkills)
            if ((weapon.classMask & player->getClassMask()) && !player->HasSkill(weapon.skill))
                player->SetSkill(weapon.skill, 0, value, value);
    }
};

void AddCoACustomRaceWeaponSkillScripts()
{
    if (CoACustomRaces::IsEnabled())
        new CoACustomRaceWeaponSkills();
}
