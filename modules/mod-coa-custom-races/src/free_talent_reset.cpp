#include "Chat.h"
#include "CoACustomRaces.h"
#include "CommandScript.h"
#include "Pet.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "SpellScript.h"

using namespace Acore::ChatCommands;

namespace
{
    constexpr uint32 SPELL_FREE_TALENT_RESET = 14009999;
    constexpr uint32 RBAC_PERM_RESET_TALENTS_SELF = 6001;
    constexpr char const* RESET_REQUEST = "COA_RESET_TALENTS";

    void ResetTalentsForFree(Player* player)
    {
        if (!player)
            return;

        player->resetTalents(true);
        player->SendTalentsInfoData(false);
        Pet* pet = player->GetPet();
        Pet::resetTalentsForAllPetsOf(player, pet);
        if (pet)
            player->SendTalentsInfoData(true);
    }
}

class spell_coa_free_talent_reset : public SpellScript
{
    PrepareSpellScript(spell_coa_free_talent_reset);

    void HandleDummy(SpellEffIndex /*effIndex*/)
    {
        ResetTalentsForFree(GetCaster()->ToPlayer());
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_coa_free_talent_reset::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
    }
};

class CoAFreeTalentResetPlayer : public PlayerScript
{
public:
    CoAFreeTalentResetPlayer() : PlayerScript("CoAFreeTalentResetPlayer", { PLAYERHOOK_ON_LOGIN, PLAYERHOOK_ON_CHAT, PLAYERHOOK_ON_CHAT_WITH_RECEIVER }) { }

    void OnPlayerLogin(Player* player) override
    {
        if (!player->HasSpell(SPELL_FREE_TALENT_RESET))
            player->learnSpell(SPELL_FREE_TALENT_RESET);
    }

    bool OnPlayerCanUseChat(Player* player, uint32 /*type*/, uint32 /*language*/, std::string& msg) override
    {
        if (msg != RESET_REQUEST)
            return true;
        ResetTalentsForFree(player);
        return false;
    }

    bool OnPlayerCanUseChat(Player* player, uint32 /*type*/, uint32 /*language*/, std::string& msg, Player* /*receiver*/) override
    {
        if (msg != RESET_REQUEST)
            return true;
        ResetTalentsForFree(player);
        return false;
    }
};

class CoAFreeTalentResetCommand : public CommandScript
{
public:
    CoAFreeTalentResetCommand() : CommandScript("CoAFreeTalentResetCommand") { }

    ChatCommandTable GetCommands() const override
    {
        static ChatCommandTable commandTable =
        {
            { "resettalents", HandleResetTalents, RBAC_PERM_RESET_TALENTS_SELF, Console::No },
        };
        return commandTable;
    }

    static bool HandleResetTalents(ChatHandler* handler)
    {
        Player* player = handler->GetSession() ? handler->GetSession()->GetPlayer() : nullptr;
        if (!player)
            return false;

        ResetTalentsForFree(player);
        handler->SendSysMessage(LANG_RESET_TALENTS);
        return true;
    }
};

void AddCoAFreeTalentResetScripts()
{
    RegisterSpellScript(spell_coa_free_talent_reset);
    if (!CoACustomRaces::IsEnabled())
        return;

    new CoAFreeTalentResetPlayer();
    new CoAFreeTalentResetCommand();
}
