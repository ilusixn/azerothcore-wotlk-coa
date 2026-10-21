#include "CoACustomRaces.h"
#include "racials/CoaCustomRacials.h"
#include "Config.h"
#include "Log.h"
#include "ScriptMgr.h"
#include "StringConvert.h"
#include "Tokenize.h"
#include <unordered_set>

namespace
{
    std::unordered_set<uint8> DisabledRaces;

    void LoadDisabledRaces()
    {
        DisabledRaces.clear();
        std::string const list = sConfigMgr->GetOption<std::string>("CoACustomRaces.DisabledRaces", "");
        for (std::string_view token : Acore::Tokenize(list, ',', false))
            if (Optional<uint8> race = Acore::StringTo<uint8>(token))
                DisabledRaces.insert(*race);
    }

    bool HasOwnRacials(uint8 race)
    {
        return GetCoaCustomRacial(race) != nullptr;
    }

    void AppendRacialSpells(uint8 race, std::vector<uint32>& spells)
    {
        if (CoaCustomRacial const* racial = GetCoaCustomRacial(race))
            for (uint32 spell : racial->Spells)
                if (spell)
                    spells.push_back(spell);
    }
}

class CoACustomRacesAccount : public AccountScript
{
public:
    CoACustomRacesAccount() : AccountScript("CoACustomRacesAccount", { ACCOUNTHOOK_CAN_ACCOUNT_CREATE_CHARACTER }) { }

    bool CanAccountCreateCharacter(uint32 /*accountId*/, uint8 race, uint8 /*charClass*/) override
    {
        if (CoACustomRaces::IsStockRace(race))
            return true;
        return CoACustomRaces::IsEnabled() && !DisabledRaces.count(race);
    }
};

void AddCoACustomRaceDisplayScripts();
void AddCoACustomRaceWeaponSkillScripts();
void AddCoAFreeTalentResetScripts();
void AddCoAHideArmorScripts();
void AddSC_CoaEsteriaRacials();

void Addmod_coa_custom_racesScripts()
{
    CoACustomRaces::Hooks& hooks = CoACustomRaces::GetHooks();
    hooks.HasOwnRacials = HasOwnRacials;
    hooks.AppendRacialSpells = AppendRacialSpells;
    hooks.IsVanillaRacialSkill = IsCoaVanillaRacialSkill;

    LoadDisabledRaces();
    LOG_INFO("server.loading", "CoA Custom Races: {}", CoACustomRaces::IsEnabled() ? "enabled" : "disabled");

    new CoACustomRacesAccount();
    AddCoACustomRaceDisplayScripts();
    AddCoACustomRaceWeaponSkillScripts();
    AddCoAFreeTalentResetScripts();
    AddCoAHideArmorScripts();
    AddSC_CoaEsteriaRacials();
}
