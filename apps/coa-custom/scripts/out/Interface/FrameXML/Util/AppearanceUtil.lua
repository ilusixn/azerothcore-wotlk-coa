AppearanceUtil = {}

local SLOT_TO_CATEGORY = {
    [INVSLOT_HEAD] = 1,
    [INVSLOT_SHOULDER] = 2,
    [INVSLOT_BODY] = 6,
    [INVSLOT_CHEST] = 4,
    [INVSLOT_WAIST] = 9,
    [INVSLOT_LEGS] = 10,
    [INVSLOT_FEET] = 11,
    [INVSLOT_WRIST] = 7,
    [INVSLOT_HAND] = 8,
    [INVSLOT_BACK] = 3,
    [INVSLOT_MAINHAND] = 13,
    [INVSLOT_OFFHAND] = 14,
    [INVSLOT_RANGED] = 12,
    [INVSLOT_TABARD] = 5,
}
local CATEGORY_TO_SLOT = table.invert(SLOT_TO_CATEGORY)

local ILLUSION_SLOT_TO_CATEGORY = {
    [INVSLOT_MAINHAND] = 15,
    [INVSLOT_OFFHAND] = 16,
}
local ILLUSION_CATEGORY_TO_SLOT = table.invert(ILLUSION_SLOT_TO_CATEGORY)

local CATEGORIES_WITH_ILLUSIONS = {
    [13] = 15,
    [14] = 16,
}

function AppearanceUtil.GetSlotCategoryID(slotID)
    return slotID and SLOT_TO_CATEGORY[slotID]
end

function AppearanceUtil.GetIllusionSlotCategoryID(slotID)
    return slotID and ILLUSION_SLOT_TO_CATEGORY[slotID]
end

function AppearanceUtil.GetCategorySlotID(categoryID)
    return categoryID and CATEGORY_TO_SLOT[categoryID]
end

function AppearanceUtil.GetIllusionCategorySlotID(categoryID)
    return categoryID and ILLUSION_CATEGORY_TO_SLOT[categoryID]
end

function AppearanceUtil.GetCategoryIllusionCategoryID(categoryID)
    return CATEGORIES_WITH_ILLUSIONS[categoryID]
end

function AppearanceUtil.GetCategoryDisplayID(categoryID)
    local appearanceID = C_Appearance.GetPendingAppearance(categoryID) or C_Appearance.GetAppearanceForCategory(categoryID)
    local _, displayID = C_Appearance.GetAppearanceDisplayInfo(appearanceID)
    return displayID
end

function AppearanceUtil.GetCategoryDisplayInfo(categoryID)
    local appearanceID = C_Appearance.GetPendingAppearance(categoryID) or C_Appearance.GetAppearanceForCategory(categoryID)
    return C_Appearance.GetAppearanceDisplayInfo(appearanceID)
end


function AppearanceUtil.GetCategoryAppearanceID(categoryID)
    return C_Appearance.GetPendingAppearance(categoryID) or C_Appearance.GetAppearanceForCategory(categoryID)
end

function AppearanceUtil.GetSlotDisplayID(slotID)
    local categoryID = AppearanceUtil.GetSlotCategoryID(slotID)
    local displayID = AppearanceUtil.GetCategoryDisplayID(categoryID)
    return displayID or GetInventoryItemTrueID("player", slotID)
end

function AppearanceUtil.GetSlotIllusionDisplayID(slotID)
    local categoryID = AppearanceUtil.GetIllusionSlotCategoryID(slotID)
    local displayID = AppearanceUtil.GetCategoryDisplayID(categoryID)
    if displayID then
        return displayID
    else
        local itemLink = GetInventoryItemLink("player", slotID)
        if itemLink then
            local illusionID = tonumber(itemLink:match("item:%d+:(%d+)"))
            if illusionID then
                return illusionID
            end
        end
    end
end

-- Custom races: backgrounds exist only for the stock races; the others use a base race's.
DRESSUP_RACE_FALLBACK = DRESSUP_RACE_FALLBACK or {
    Goblin = "Orc", ["Zandalari Troll"] = "Troll", Worgen = "Human", Tuskarr = "Dwarf", KulTiran = "Human",
    Taunka = "Tauren", Vrykul = "Human", Vulpera = "Orc", Pandaren = "Dwarf", Naga_ = "Troll", Broken = "Draenei",
    FelOrc = "Orc", ForestTroll = "Troll", IceTroll = "Troll", Skeleton = "Scourge", Npc_Earthen = "Dwarf",
    DrakkariTroll = "Troll", Troglodyte = "Gnome",
}
-- every race added later (Eunoia, Esteria, Jinyu, ...): any name without its own background uses Human's
DRESSUP_STOCK_RACES = { Human = true, Orc = true, Dwarf = true, NightElf = true, Scourge = true, Tauren = true,
    Gnome = true, Troll = true, BloodElf = true, Draenei = true }
function GetDressUpRaceFileName(fileName)
    if not fileName then
        return fileName
    end
    if DRESSUP_RACE_FALLBACK[fileName] then
        return DRESSUP_RACE_FALLBACK[fileName]
    end
    return DRESSUP_STOCK_RACES[fileName] and fileName or "Human"
end

function AppearanceUtil.GetBackgroundAtlas()
    local _, race = UnitRace("player")
    return "transmog-background-race-" .. GetDressUpRaceFileName(race):lower()
end

function AppearanceUtil.GetAppearanceLink(appearanceID)
    if appearanceID then
        local _, _, _, displayName = C_Appearance.GetAppearanceDisplayInfo(appearanceID)
        if displayName then
            return TRANSMOG_UNLOCK_COLOR:WrapText("|Happearance:" .. appearanceID .. "|h[" .. displayName .. "]|h")
        end
    end
end