CHAR_CREATE_HELP_NEXT_BUTTON = CHAR_CREATE_HELP_NEXT_BUTTON or "You can go to the next step\n\nYou can change these choices at any time"
CHAR_CREATE_CUSTOMIZE_YOUR_APPEARANCE = CHAR_CREATE_CUSTOMIZE_YOUR_APPEARANCE or "Customize Your Appearance "
CHAR_CREATE_CHANGE_ANY_TIME = CHAR_CREATE_CHANGE_ANY_TIME or "You can change these choices at any time!"
CHAR_CREATE_HELP_CHOOSE_CLASS = CHAR_CREATE_HELP_CHOOSE_CLASS or "Help Me Choose"
CLASS_GUIDE_ROLE_SELECT_TEXT = CLASS_GUIDE_ROLE_SELECT_TEXT or "Select Role"
CLASS_GUIDE_CATEGORY_SELECT_TEXT = CLASS_GUIDE_CATEGORY_SELECT_TEXT or "Select Category"
CLASS_GUIDE_CLASS_SELECT_TEXT = CLASS_GUIDE_CLASS_SELECT_TEXT or "Select Class"
CLASS_GUIDE_ROLE_SELECTED_TEXT = CLASS_GUIDE_ROLE_SELECTED_TEXT or "Selected Role:\n%s"
CLASS_GUIDE_CATEGORY_SELECTED_TEXT = CLASS_GUIDE_CATEGORY_SELECTED_TEXT or "Selected Category:\n%s"
CLASS_GUIDE_CLASS_SELECTED_TEXT = CLASS_GUIDE_CLASS_SELECTED_TEXT or "Selected Class:\n%s"

function C_CharacterCreate.CanCreateArchetype()
	return GetRealmName() == "Area 52 - Free-Pick" and C_Config.GetBoolConfig("CONFIG_CHARACTER_CREATION_ARCHETYPES_ENABLED")
end

CHARACTER_FACING_INCREMENT = 2;
MAX_RACES = 128;

-- racials shown for the extra races: those of the base race they borrow (same rule as the server)
CHAR_CREATE_EXTRA_RACE_RACIALS = {
	["WORGEN"] = "NIGHTELF", ["GOBLIN"] = "ORC", ["TUSKARR"] = "DWARF", ["KULTIRAN"] = "HUMAN", ["TAUNKA"] = "TAUREN",
	["VRYKUL"] = "HUMAN", ["VULPERA"] = "TROLL", ["NAGA_"] = "SCOURGE", ["BROKEN"] = "DRAENEI", ["FELORC"] = "ORC",
	["FORESTTROLL"] = "TROLL", ["ICETROLL"] = "TROLL", ["SKELETON"] = "SCOURGE", ["NPC_EARTHEN"] = "DWARF",
	["DRAKKARITROLL"] = "TROLL", ["ZANDALARI TROLL"] = "TROLL", ["PANDAREN"] = "DRAENEI", ["TROGLODYTE"] = "SCOURGE",
}
CHAR_CREATE_EXTRA_RACE_RACIALS_HORDE = { ["PANDAREN"] = "TAUREN", ["TROGLODYTE"] = "SCOURGE" }
CHAR_CREATE_EXTRA_RACE_INFO = {
	["WORGEN"] = "Cursed Gilneans who learned to master the beast within. Worgen fight with the speed and stealth of the Night Elves.",
	["GOBLIN"] = "Cunning merchants and inventors from Kezan, as tough as any Orc when the profit is right.",
	["TUSKARR"] = "Hardy fisher-folk of Northrend's coasts, as stubborn and cold-resistant as the Dwarves.",
	["KULTIRAN"] = "Proud sailors from the island kingdom of Kul Tiras, sharing the human spirit of their cousins.",
	["TAUNKA"] = "Northern kin of the Tauren, forged by the harsh winters of the Borean Tundra.",
	["VRYKUL"] = "Towering warriors of Northrend, distant ancestors of humanity.",
	["VULPERA"] = "Nimble desert scavengers from Vol'dun who survive with troll-like resilience.",
	["PANDAREN"] = "Wandering monks and brewers of Pandaria. Alliance Pandaren share the gifts of the Draenei, Horde Pandaren those of the Tauren.",
	["NAGA_"] = "Serpentine children of the deep, as unyielding as the Forsaken.",
	["BROKEN"] = "Draenei twisted by the fel, who still carry the Light of the Naaru.",
	["FELORC"] = "Orcs corrupted by demon blood, stronger and angrier than their brothers.",
	["FORESTTROLL"] = "Trolls of the Hinterlands and Eversong, regenerating and ferocious.",
	["ICETROLL"] = "Trolls of the frozen north, hardened by ice and hunger.",
	["SKELETON"] = "Restless dead risen once more, bound by the will of the Forsaken.",
	["NPC_EARTHEN"] = "Titan-forged guardians of stone, kin to the Dwarves.",
	["DRAKKARITROLL"] = "Trolls of the fallen Drakkari empire of Zul'Drak.",
	["ZANDALARI TROLL"] = "Proud trolls of Zandalar, eldest and wisest of their kind.",
	["TROGLODYTE"] = "Murlocs! Mrglglgl! Creatures of the shallows who breathe underwater, sharing the gifts of the Forsaken.",
}

-- signature racial borrowed from another race (server: playercreateinfo_spell_custom "racial combo")
CHAR_CREATE_EXTRA_RACE_SIGNATURE = {
	["WORGEN"] = {"TROLL", "Berserking"}, ["GOBLIN"] = {"GNOME", "Escape Artist"}, ["TUSKARR"] = {"TAUREN", "War Stomp"},
	["KULTIRAN"] = {"DWARF", "Stoneform"}, ["TAUNKA"] = {"DWARF", "Frost Resistance"}, ["VRYKUL"] = {"ORC", "Blood Fury"},
	["VULPERA"] = {"GNOME", "Escape Artist"}, ["NAGA_"] = {"BLOODELF", "Arcane Torrent"}, ["BROKEN"] = {"SCOURGE", "Will of the Forsaken"},
	["FELORC"] = {"BLOODELF", "Arcane Torrent"}, ["FORESTTROLL"] = {"NIGHTELF", "Shadowmeld"}, ["ICETROLL"] = {"DWARF", "Stoneform"},
	["SKELETON"] = {"DWARF", "Stoneform"}, ["NPC_EARTHEN"] = {"TAUREN", "War Stomp"}, ["DRAKKARITROLL"] = {"ORC", "Blood Fury"},
	["ZANDALARI TROLL"] = {"DRAENEI", "Gift of the Naaru"}, ["PANDAREN"] = {"TAUREN", "War Stomp"}, ["TROGLODYTE"] = {"NIGHTELF", "Shadowmeld"},
}
CHAR_CREATE_EXTRA_RACE_SIGNATURE_HORDE = { ["PANDAREN"] = {"DRAENEI", "Gift of the Naaru"}, ["TROGLODYTE"] = {"GNOME", "Escape Artist"} }

function CharacterCreate_AliasExtraRacials(faction)
	for race, base in pairs(CHAR_CREATE_EXTRA_RACE_RACIALS) do
		if faction == "Horde" and CHAR_CREATE_EXTRA_RACE_RACIALS_HORDE[race] then
			base = CHAR_CREATE_EXTRA_RACE_RACIALS_HORDE[race]
		end
		for i = 1, 10 do
			_G["ABILITY_INFO_"..race..i] = _G["ABILITY_INFO_"..base..i]
		end
		local passives = CHAR_CREATE_PASSIVES and CHAR_CREATE_PASSIVES[base]
		local count = 0
		while _G["ABILITY_INFO_"..race..(count + 1)] do
			count = count + 1
		end
		local signature = (faction == "Horde" and CHAR_CREATE_EXTRA_RACE_SIGNATURE_HORDE[race]) or CHAR_CREATE_EXTRA_RACE_SIGNATURE[race]
		local signaturePassive
		if signature then
			for i = 1, 10 do
				local text = _G["ABILITY_INFO_"..signature[1]..i]
				if text and string.find(text, signature[2], 1, true) then
					count = count + 1
					_G["ABILITY_INFO_"..race..count] = text
					signaturePassive = CHAR_CREATE_PASSIVES and CHAR_CREATE_PASSIVES[signature[1]] and CHAR_CREATE_PASSIVES[signature[1]][i]
					break
				end
			end
			for i = count + 1, 10 do
				_G["ABILITY_INFO_"..race..i] = nil
			end
		end
		if CHAR_CREATE_PASSIVES then
			local list = {}
			for i, spell in ipairs(passives or {}) do
				list[i] = spell
			end
			if signaturePassive then
				list[count] = signaturePassive
			end
			CHAR_CREATE_PASSIVES[race] = list
		end
		if not _G["RACE_INFO_"..race] then
			_G["RACE_INFO_"..race] = CHAR_CREATE_EXTRA_RACE_INFO[race]
		end
	end
end

CHAR_CREATE_EXTRA_RACE_ICONS = {
	["Worgen"] = "Interface\\Icons\\_BeastTaming_Worgen",
	["Goblin"] = "Interface\\Icons\\INV_Gizmo_GoblinBoomBox_01",
	["High Elf"] = "Interface\\Icons\\_HighElf_01",
	["Tuskarr"] = "Interface\\Icons\\INV_Misc_Head_Tuskarr",
	["Kul Tiran"] = "Interface\\Icons\\achievement_alliedrace_kultiranhuman",
	["Taunka"] = "Interface\\Icons\\INV_Misc_Head_Tauren_02",
	["Vrykul"] = "Interface\\Icons\\INV_Misc_Head_Vrykul",
	["Vulpera"] = "Interface\\Icons\\achievement_alliedrace_vulpera",
	["Pandaren"] = "Interface\\Icons\\achievement_character_pandaren_female",
	["Naga"] = "Interface\\Icons\\achievement_boss_elitenagamale",
	["Broken"] = "Interface\\Icons\\Achievement_Character_Draenei_Male",
	["Fel Orc"] = "Interface\\Icons\\achievement_character_orc_male_brn",
	["Forest Troll"] = "Interface\\Icons\\INV_Misc_Head_Troll_01",
	["Ice Troll"] = "Interface\\Icons\\INV_Misc_Head_Troll_02",
	["Skeleton"] = "Interface\\Icons\\SkeletonPowerful",
	["Earthen"] = "Interface\\Icons\\ability_earthen_titanwroughtframe",
	["Drakkari Troll"] = "Interface\\Icons\\Achievement_Character_Troll_Male",
	["Zandalari Troll"] = "Interface\\Icons\\achievement_alliedrace_zandalaritroll",
	["Murloc"] = "Interface\\Icons\\INV_Misc_Head_Murloc_01",
}

-- Local server: extra playable races. Buttons beyond the 11 of the XML are created on demand
-- and laid out in columns, Alliance on the left and Horde on the right.
function CharacterCreate_EnsureRaceButtons()
	for i = 1, MAX_RACES do
		if not _G["CharCreateRaceButton"..i] then
			local button = CreateFrame("CheckButton", "CharCreateRaceButton"..i, CharCreateRaceButtonsFrame, "CharCreateRaceButtonTemplate")
			button:SetID(i)
			button:Hide()
		end
	end
end

function CharacterCreate_LayoutRaceButtons(numRaces)
	local perColumn, columnWidth, rowHeight, scale = 10, 150, 45, 0.7
	local count = { Alliance = 0, Horde = 0 }
	for i = 1, numRaces do
		local button = _G["CharCreateRaceButton"..i]
		local ok, _, faction = pcall(GetFactionForRace, i)
		if not ok or faction ~= "Horde" then
			faction = "Alliance"
		end
		local k = count[faction]
		count[faction] = k + 1
		local column, row = math.floor(k / perColumn), k % perColumn
		button:SetScale(scale)
		button:ClearAllPoints()
		if faction == "Alliance" then
			button:SetPoint("TOPLEFT", CharCreateRaceButtonsFrame, "TOPLEFT", (28 + column * columnWidth) / scale, (-62 - row * rowHeight) / scale)
		else
			button:SetPoint("TOPRIGHT", CharCreateRaceButtonsFrame, "TOPRIGHT", (-28 - column * columnWidth) / scale, (-62 - row * rowHeight) / scale)
		end
		button:SetFaction(faction)
		button:Show()
	end
end
MAX_CLASSES_PER_RACE = 32;
NUM_CHAR_CUSTOMIZATIONS = 5;
MIN_CHAR_NAME_LENGTH = 2;
CHARACTER_CREATE_ROTATION_START_X = nil;
CHARACTER_CREATE_INITIAL_FACING = nil;
NUM_PREVIEW_FRAMES = 14;

CUSTOM_CLASSES_START_INDEX = 12
HERO_CLASS_ID = 10

-- Local server: let the classic (vanilla) classes be created next to the CoA classes.
local VANILLA_CLASS_IDS = {[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[11]=true}
function CharacterCreate_EnableVanillaClasses()
	if not C_CharacterCreate or C_CharacterCreate.vanillaClassesEnabled then
		return
	end
	local origCanCreateClass = C_CharacterCreate.CanCreateClass
	C_CharacterCreate.CanCreateClass = function(classID, ...)
		if VANILLA_CLASS_IDS[classID] then
			return true
		end
		return origCanCreateClass(classID, ...)
	end
	C_CharacterCreate.CanCreateWCR = function() return true end
	-- CharBaseInfo.dbc holds at most 30 classes per race in this client, so Death Knight
	-- is left out of it; accept it here, the server validates the real combination.
	local origIsRaceClassValid = IsRaceClassValid
	IsRaceClassValid = function(race, classID, ...)
		if classID == 6 then
			return true
		end
		return origIsRaceClassValid(race, classID, ...)
	end
	C_CharacterCreate.vanillaClassesEnabled = true
end
CharacterCreate_EnableVanillaClasses()

IS_ZOOMED = false
local featureIndex = 1
local FeatureType = 1

PAID_CHARACTER_CUSTOMIZATION = 1;
PAID_RACE_CHANGE = 3;
PAID_FACTION_CHANGE = 2;
PAID_SERVICE_CHARACTER_ID = nil;
PAID_SERVICE_TYPE = nil;

PREVIEW_FRAME_HEIGHT = 130;
PREVIEW_FRAME_X_OFFSET = 19;
PREVIEW_FRAME_Y_OFFSET = -7;

FACTION_SHADOW_COLORS = {
	Horde = CreateColor(0.90, 0.05, 0.07),
	Alliance = CreateColor(0.29, 0.33, 0.91),
	Player = CreateColor(1, 1, 1),
}

FACTION_BACKDROP_COLOR_TABLE = {
	["Alliance"] = {0.5, 0.5, 0.5, 0.09, 0.09, 0.19, 0, 0, 0.2, 0.29, 0.33, 0.91},
	["Horde"] = {0.5, 0.2, 0.2, 0.19, 0.05, 0.05, 0.2, 0, 0, 0.90, 0.05, 0.07},
	["Player"] = {0.2, 0.5, 0.2, 0.05, 0.2, 0.05, 0.05, 0.2, 0.05, 1, 1, 1},
};

FRAMES_TO_BACKDROP_COLOR = {
	"CharacterCreateCharacterRace",
	"CharacterCreateCharacterClass",
--	"CharacterCreateCharacterFaction",
	"CharacterCreateNameEdit",
};

BANNER_DEFAULT_TEXTURE_COORDS = {0.109375, 0.890625, 0.201171875, 0.80078125};
BANNER_DEFAULT_SIZE = {200, 308};

CHAR_CUSTOMIZE_HAIR_COLOR = 4;

COA_CLASS_ORDER = {
	"NECROMANCER",
	"PYROMANCER",
	"CULTIST",
	"STARCALLER",
	"SUNCLERIC",
	"TINKER",
	"SPIRITMAGE",
	"WILDWALKER",
	"REAPER",
	"PROPHET",
	"CHRONOMANCER",
	"SONOFARUGAL",
	"GUARDIAN",
	"STORMBRINGER",
	"DEMONHUNTER",
	"BARBARIAN",
	"WITCHDOCTOR",
	"WITCHHUNTER",
	"FLESHWARDEN",
	"MONK",
	"RANGER",
}

CLASSIC_CLASS_ORDER = {
	"WARRIOR",
	"PALADIN",
	"HUNTER",
	"ROGUE",
	"PRIEST",
	"DEATHKNIGHT",
	"SHAMAN",
	"MAGE",
	"WARLOCK",
	"DRUID",
	"HERO"
}

--
-- Character create steps:
--

CHAR_CREATE_STEPS_DEFAULT = {
	Enum.CharCreateSteps.ClassRace,
	Enum.CharCreateSteps.Customization,
}

CHAR_CREATE_STEPS_CLASS_GUIDE = {
	Enum.CharCreateSteps.ClassRace,
	Enum.CharCreateSteps.NameEdit,
}

CHAR_CREATE_STEPS_EXTEND = {
	Enum.CharCreateSteps.ClassRace,
	Enum.CharCreateSteps.Customization,
	Enum.CharCreateSteps.Role,
	Enum.CharCreateSteps.Subrole,
	Enum.CharCreateSteps.Archetype,
	Enum.CharCreateSteps.NameEdit,
}

CHAR_CREATE_CAMERA_ZOOM_IN = {
	["Human"] = HD_PATCH_ENABLED and 3 or 1.5,
	["Orc"] = 1.5,
	["Troll"] = 2.5,
	["Scourge"] = 1,
	["BloodElf"] = 2.5,
	["Tauren"] = 1.5,
}

CHAR_CREATE_ZOOM = 2

--
-- Zoom/model change
--
local ZoomController = CreateFrame("FRAME")
ZoomController.zoom = 0

ZoomController:SetScript("OnUpdate", function(self, elapsed)
	local _, fileString = GetNameForRace()
	local zoomInValue = self.manualZoomIn or CHAR_CREATE_CAMERA_ZOOM_IN[fileString] or CHAR_CREATE_ZOOM
	local zoomOutValue = self.manualZoomOut or 0 

	if IS_ZOOMED and (self.zoom < zoomInValue) then
		local step = (zoomInValue-self.zoom)*0.02
		C_CharacterCreate.ZoomIn(step)
		self.zoom = self.zoom + step

		if math.NearlyEquals(self.zoom, zoomInValue, 0.1) then
			self:Hide()
		end
	elseif not(IS_ZOOMED) and (self.zoom > zoomOutValue) then
		local step = self.zoom*0.02
		C_CharacterCreate.ZoomOut(step)
		self.zoom = self.zoom - step

		if math.NearlyEquals(self.zoom, 0, 0.1) then
			self:Hide()
		end
	else
		self:Hide()
	end
end)

ZoomController:Hide()

local function CharCreate_ResetCamera()
	C_CharacterCreate.ResetCameraPosition()
	ZoomController.zoom = 0
	ZoomController.manualZoomIn = nil
	ZoomController.manualZoomOut = nil
	ZoomController:Hide()
	IS_ZOOMED = false
end

local CLASS_GUIDE_CHOICE_BUTTON_WIDTH = 96
local CLASS_GUIDE_CHOICE_BUTTON_HEIGHT = 128
local CLASS_GUIDE_CHOICE_BUTTON_SPACING = 56
local CLASS_GUIDE_CHOICE_BUTTON_Y_OFFSET = -28
local CLASS_GUIDE_FALLBACK_ATLAS = "ExperienceIconAscension"
local CLASS_GUIDE_COMBAT_HEALER_ATLAS = "ExperienceIconBattleHeal"
local CLASS_GUIDE_COMBAT_HEALER_TOOLTIP_TITLE = "Combat Healer"
local CLASS_GUIDE_COMBAT_HEALER_TOOLTIP_TEXT = "Restores allies by actively fighting and weaving offensive abilities in between healing casts."
local CLASS_GUIDE_ROLE_ATLAS = {
	TANK = "ExperienceIconTank",
	HEALER = "ExperienceIconHeal",
	DAMAGE = "ExperienceIconDamage",
	SUPPORT = "ExperienceIconFreepick",
}
local CLASS_GUIDE_SUBROLE_ATLAS = {
	MELEE_DPS = "ExperienceIconMeleeDD",
	RANGED_DPS = "ExperienceIconRanged",
	CASTER_DPS = "ExperienceIconMagic",
	HYBRID = "ExperienceIconHybridDD",
	TANK = "ExperienceIconTank",
	PURE_HEALER = "ExperienceIconSuperHeal",
	HEALER = "ExperienceIconHeal",
	COMBAT_HEALER = "ExperienceIconBattleHeal",
	SUPPORT = "ExperienceIconFreepick",
}
local CLASS_GUIDE_COMBAT_HEALER_CLASS_FILES = {
	CULTIST = true,
	STARCALLER = true,
}

local function CharacterCreate_CreateClassGuideButton(parent)
	local button = CreateFrame("CheckButton", nil, parent, "CharacterCreateArchetypeCoiceButtonTemplate")
	button:SetSize(CLASS_GUIDE_CHOICE_BUTTON_WIDTH, CLASS_GUIDE_CHOICE_BUTTON_HEIGHT)

	return button
end

local function CharacterCreate_LayoutClassGuideButtons(buttons, count, yOffset)
	local width = CLASS_GUIDE_CHOICE_BUTTON_WIDTH
	local spacing = CLASS_GUIDE_CHOICE_BUTTON_SPACING
	local totalWidth = count * width + math.max(count - 1, 0) * spacing
	local startX = -totalWidth / 2 + width / 2

	for i = 1, count do
		local button = buttons[i]
		button:ClearAllPoints()
		button:SetPoint("TOP", CharCreateClassGuideFrame, "TOP", startX + (i - 1) * (width + spacing), yOffset)
		button:Show()
	end
end

local function CharacterCreate_HideClassGuide()
	if CharCreateClassGuideFrame then
		CharCreateClassGuideFrame:Hide()
	end
end

local function CharacterCreate_HasClassGuideAPI()
	return C_CharacterCreate.GetClassGuideRoles
		and C_CharacterCreate.GetClassGuideRoleInfo
		and C_CharacterCreate.GetClassGuideSubroles
		and C_CharacterCreate.GetClassGuideSubroleInfo
		and C_CharacterCreate.GetClassGuideSubroleClasses
end

local function CharacterCreate_SetClassGuideEntryShown(shown)
	if CharCreateClassGuideEntryButton then
		CharCreateClassGuideEntryButton:SetEnabled(CharacterCreate_HasClassGuideAPI() and true or false)
		CharCreateClassGuideEntryButton:SetShown(shown)
	end
end

local function CharacterCreate_HasClassGuideData()
	if not CharacterCreate_HasClassGuideAPI() then
		return false
	end

	local roles = C_CharacterCreate.GetClassGuideRoles()
	return roles and #roles > 0
end

local function CharacterCreate_SetClassGuideRaceLocked(locked)
	for i = 1, MAX_RACES do
		local button = _G["CharCreateRaceButton"..i]
		if button then
			button:EnableMouse(not locked)
		end
	end
end

local function CharacterCreate_ClassMatchesGuideSubrole(classID, classFileName, subroleID)
	if not subroleID or not C_CharacterCreate.GetClassGuideSubroleInfo then
		return true
	end

	local _, _, classRoleKey = C_CharacterCreate.GetClassGuideSubroleInfo(subroleID)
	if not classRoleKey then
		return false
	end

	if C_CharacterCreate.GetClassGuideSubroleClasses then
		local classes = C_CharacterCreate.GetClassGuideSubroleClasses(subroleID)
		if classes and #classes > 0 then
			for _, guideClassID in ipairs(classes) do
				if guideClassID == classID then
					return true
				end
			end

			return false
		end
	end

	if classRoleKey == "Hybrid" then
		if not C_CharacterCreate.GetClassGuideSubroleClasses then
			return false
		end

		local classes = C_CharacterCreate.GetClassGuideSubroleClasses(subroleID)
		for _, guideClassID in ipairs(classes) do
			if guideClassID == classID then
				return true
			end
		end

		return false
	end

	local roles = ClassInfoUtil.GetClassRoles(classFileName)
	return roles and roles[classRoleKey]
end

local function CharacterCreate_ClassPassesGuideFilter(classID, classFileName)
	if not CharacterCreate.classGuideActive then
		return true
	end

	if CharacterCreate.selectedClassGuideSubroleID then
		return CharacterCreate_ClassMatchesGuideSubrole(classID, classFileName, CharacterCreate.selectedClassGuideSubroleID)
	end

	return false
end

local function CharacterCreate_IsClassGuideHealerSubrole(subroleID)
	if not CharacterCreate.selectedClassGuideRoleID
		or not subroleID
		or not C_CharacterCreate.GetClassGuideRoleInfo
		or not C_CharacterCreate.GetClassGuideSubroleInfo then
		return false
	end

	local roleKey = C_CharacterCreate.GetClassGuideRoleInfo(CharacterCreate.selectedClassGuideRoleID)
	if roleKey ~= "HEALER" then
		return false
	end

	local _, subroleKey = C_CharacterCreate.GetClassGuideSubroleInfo(subroleID)
	return subroleKey == "HEALER" or subroleKey == "PURE_HEALER"
end

local function CharacterCreate_IsClassGuideCombatHealer(classFileName)
	return CLASS_GUIDE_COMBAT_HEALER_CLASS_FILES[classFileName] and true or false
end

local function CharacterCreate_ClassGuideClassIsAvailableForRace(classID, raceID)
	if not classID or not CharacterCreate.selectedClassGuideSubroleID then
		return false
	end

	if not C_CharacterCreate.CanCreateClass(classID)
		or not CharacterCreateUtil.IsRaceClassEnabledAndValid(raceID or CharacterCreate.selectedRace, classID) then
		return false
	end

	local _, classFileName = GetClassInfo(classID)
	return classFileName and CharacterCreate_ClassMatchesGuideSubrole(classID, classFileName, CharacterCreate.selectedClassGuideSubroleID)
end

local function CharacterCreate_GetFirstAvailableClassGuideClassForRace(raceID)
	if not CharacterCreate.selectedClassGuideSubroleID then
		return nil
	end

	for i = 1, 21 do
		local classID = Enum.Class[COA_CLASS_ORDER[i]]
		if CharacterCreate_ClassGuideClassIsAvailableForRace(classID, raceID) then
			return classID
		end
	end
end

local function CharacterCreate_GetSingleClassGuideSubrole(roleID)
	if not roleID or not C_CharacterCreate.GetClassGuideSubroles or not C_CharacterCreate.GetClassGuideSubroleInfo then
		return nil
	end

	local singleSubroleID
	local subroleCount = 0
	local subroles = C_CharacterCreate.GetClassGuideSubroles(roleID)
	for _, subroleID in ipairs(subroles) do
		local _, _, _, _, name = C_CharacterCreate.GetClassGuideSubroleInfo(subroleID)
		if name then
			subroleCount = subroleCount + 1
			singleSubroleID = subroleID
		end
	end

	if subroleCount == 1 then
		return singleSubroleID
	end
end

local function CharacterCreate_SelectClassGuideRole(roleID)
	CharacterCreate.selectedClassGuideRoleID = roleID
	CharacterCreate.selectedClassGuideSubroleID = CharacterCreate_GetSingleClassGuideSubrole(roleID)
	CharacterCreate.selectedClassGuideClassID = nil
	CharCreateOkayButton:Disable()
	CharacterCreate_RefreshClassButtons(CharacterCreate)
end

local function CharacterCreate_SelectClassGuideSubrole(subroleID)
	CharacterCreate.selectedClassGuideSubroleID = subroleID
	CharacterCreate.selectedClassGuideClassID = nil
	CharCreateOkayButton:Disable()
	CharacterCreate_RefreshClassButtons(CharacterCreate)
end

local function CharacterCreate_OpenClassGuide()
	if not CharacterCreate_HasClassGuideData() then
		return
	end

	CharacterCreate.classGuideActive = true
	CharacterCreate.selectedClassGuideRoleID = nil
	CharacterCreate.selectedClassGuideSubroleID = nil
	CharacterCreate.selectedClassGuideClassID = nil
	CharCreateOkayButton:SetText(CONTINUE)
	CharCreateOkayButton:Disable()
	CharacterCreate_SetClassGuideRaceLocked(true)
	CharacterCreate_RefreshClassButtons(CharacterCreate)
end

local function CharacterCreate_CloseClassGuide()
	CharacterCreate.classGuideActive = false
	CharacterCreate.selectedClassGuideRoleID = nil
	CharacterCreate.selectedClassGuideSubroleID = nil
	CharacterCreate.selectedClassGuideClassID = nil
	CharCreateOkayButton:SetText(CUSTOMIZE)
	CharCreate_EnableNextButton(true)
	CharacterCreate_SetClassGuideRaceLocked(false)
	if CharacterCreateFrame.state == Enum.CharCreateSteps.ClassRace and CharacterCreate_LoadNavigation then
		CharacterCreate_LoadNavigation(CHAR_CREATE_STEPS_DEFAULT)
		CharacterCreateNavigationFrame:GoToIndex(Enum.CharCreateSteps.ClassRace, true)
	end
	CharacterCreate_RefreshClassButtons(CharacterCreate)
end

local function CharacterCreate_ClassGuideBack()
	if CharacterCreate.selectedClassGuideSubroleID then
		CharacterCreate.selectedClassGuideSubroleID = nil
		CharacterCreate.selectedClassGuideClassID = nil
		if CharacterCreate_GetSingleClassGuideSubrole(CharacterCreate.selectedClassGuideRoleID) then
			CharacterCreate.selectedClassGuideRoleID = nil
		end
	elseif CharacterCreate.selectedClassGuideRoleID then
		CharacterCreate.selectedClassGuideRoleID = nil
	else
		CharacterCreate_CloseClassGuide()
		return
	end

	CharCreateOkayButton:Disable()
	CharacterCreate_RefreshClassButtons(CharacterCreate)
end

local function CharacterCreate_CreateClassGuideFrame()
	if not CharCreateClassGuideEntryButton then
		CharCreateClassGuideEntryButton = CreateFrame("Button", "CharCreateClassGuideEntryButton", CharacterCreateFrame, "CharCreateNavButtonTemplate")
		CharCreateClassGuideEntryButton:SetSize(150, 50)
		CharCreateClassGuideEntryButton:SetPoint("BOTTOM", CharCreateBackButton, "TOP", 0, 8)
		CharCreateClassGuideEntryButton:SetText(CHAR_CREATE_HELP_CHOOSE_CLASS)
		CharCreateClassGuideEntryButton:SetScript("OnClick", CharacterCreate_OpenClassGuide)
		CharCreateClassGuideEntryButton:Hide()
	end

	if not CharCreateClassGuideFrame then
		CharCreateClassGuideFrame = CreateFrame("Frame", "CharCreateClassGuideFrame", CharCreateClassFrame)
		CharCreateClassGuideFrame:SetSize(760, 184)
		CharCreateClassGuideFrame:SetPoint("CENTER", CharCreateClassFrame, "CENTER", 0, 0)
		CharCreateClassGuideFrame.roleButtons = {}
		CharCreateClassGuideFrame.subroleButtons = {}

		CharCreateClassGuideFrame.BackButton = CreateFrame("Button", nil, CharCreateClassGuideFrame, "CharCreateNavButtonTemplate")
		CharCreateClassGuideFrame.BackButton:SetSize(150, 50)
		CharCreateClassGuideFrame.BackButton:SetPoint("BOTTOMLEFT", CharCreateClassGuideFrame, "TOPLEFT", 0, 8)
		CharCreateClassGuideFrame.BackButton:SetText(BACK)
		CharCreateClassGuideFrame.BackButton:SetScript("OnClick", CharacterCreate_ClassGuideBack)
		CharCreateClassGuideFrame.BackButton:Hide()
		CharCreateClassGuideFrame:Hide()
	end
end

local function CharacterCreate_GetClassGuideAtlas(atlas)
	if atlas and AtlasUtil:AtlasExists(atlas) then
		return atlas
	end

	return CLASS_GUIDE_FALLBACK_ATLAS
end

local function CharacterCreate_SetClassGuideButton(button, id, text, atlas, description, onClick)
	local normalAtlas = CharacterCreate_GetClassGuideAtlas(atlas)

	button:SetID(id)
	button.step = id
	button:Enable()
	button:SetChecked(false)
	button:SetIconNormal(normalAtlas)
	button:SetIconHighlighted(normalAtlas)
	button.Highlight:Hide()
	button.Checked:Hide()

	button:UpdateText(text, "")
	button:SetScript("OnClick", onClick)
	button:SetScript("OnEnter", function(self)
		self.NameFrame.Text:SetFontObject(self.highlightFontObject or GameFontHighlightOutlineLarge)
		if text then
			GlueTooltip:SetOwner(self, "ANCHOR_TOP")
			GlueTooltip:AddLine(text, 1, 1, 1, 1, true)
			if description and description ~= "" then
				GlueTooltip:AddLine(description, 1, 0.82, 0, 1, true)
			end
			GlueTooltip:Show()
		end
	end)
	button:SetScript("OnLeave", function(self)
		self.Highlight:Hide()
		self:SetIconNormal()
		self.NameFrame.Text:SetFontObject(self.normalFontObject or GameFontNormalOutlineLarge)
		GlueTooltip:Hide()
	end)
end

local function CharacterCreate_HideClassGuideButtons(buttons)
	for _, button in ipairs(buttons) do
		button:Hide()
	end
end

local function CharacterCreate_UpdateClassGuideFrame()
	if not CharacterCreate.classGuideActive or not CharCreateClassGuideFrame or not CharacterCreate_HasClassGuideData() then
		CharacterCreate_HideClassGuide()
		return
	end

	local roles = C_CharacterCreate.GetClassGuideRoles()
	CharCreateClassGuideFrame:Show()
	if CharCreateClassGuideFrame.BackButton then
		CharCreateClassGuideFrame.BackButton:Hide()
	end

	if CharacterCreate.selectedClassGuideSubroleID then
		CharacterCreate_SetClassGuideRaceLocked(false)
		CharacterCreate_HideClassGuideButtons(CharCreateClassGuideFrame.roleButtons)
		CharacterCreate_HideClassGuideButtons(CharCreateClassGuideFrame.subroleButtons)
		return
	end

	CharacterCreate_SetClassGuideRaceLocked(true)

	local roleCount = 0
	if not CharacterCreate.selectedClassGuideRoleID then
		for _, roleID in ipairs(roles) do
			local roleKey, atlas, name, description = C_CharacterCreate.GetClassGuideRoleInfo(roleID)
			if name then
				roleCount = roleCount + 1
				local button = CharCreateClassGuideFrame.roleButtons[roleCount]
				if not button then
					button = CharacterCreate_CreateClassGuideButton(CharCreateClassGuideFrame)
					CharCreateClassGuideFrame.roleButtons[roleCount] = button
				end

				CharacterCreate_SetClassGuideButton(button, roleID, name, CLASS_GUIDE_ROLE_ATLAS[roleKey] or atlas, description, function(self)
					CharacterCreate_SelectClassGuideRole(self:GetID())
				end)
			end
		end
	end

	for i = roleCount + 1, #CharCreateClassGuideFrame.roleButtons do
		CharCreateClassGuideFrame.roleButtons[i]:Hide()
	end

	if roleCount > 0 then
		CharacterCreate_LayoutClassGuideButtons(CharCreateClassGuideFrame.roleButtons, roleCount, CLASS_GUIDE_CHOICE_BUTTON_Y_OFFSET)
	end

	local subroleCount = 0
	if CharacterCreate.selectedClassGuideRoleID and C_CharacterCreate.GetClassGuideSubroles then
		local subroles = C_CharacterCreate.GetClassGuideSubroles(CharacterCreate.selectedClassGuideRoleID)
		for _, subroleID in ipairs(subroles) do
			local _, subroleKey, _, atlas, name, description = C_CharacterCreate.GetClassGuideSubroleInfo(subroleID)
			if name then
				subroleCount = subroleCount + 1
				local button = CharCreateClassGuideFrame.subroleButtons[subroleCount]
				if not button then
					button = CharacterCreate_CreateClassGuideButton(CharCreateClassGuideFrame)
					CharCreateClassGuideFrame.subroleButtons[subroleCount] = button
				end

				CharacterCreate_SetClassGuideButton(button, subroleID, name, CLASS_GUIDE_SUBROLE_ATLAS[subroleKey] or atlas, description, function(self)
					CharacterCreate_SelectClassGuideSubrole(self:GetID())
				end)
			end
		end
	end

	for i = subroleCount + 1, #CharCreateClassGuideFrame.subroleButtons do
		CharCreateClassGuideFrame.subroleButtons[i]:Hide()
	end

	if subroleCount > 0 then
		CharacterCreate_LayoutClassGuideButtons(CharCreateClassGuideFrame.subroleButtons, subroleCount, CLASS_GUIDE_CHOICE_BUTTON_Y_OFFSET)
	end
end

local function CharacterCreate_SetGuideClassButtonPoint(button, index, rowCount, yOffset)
	local width = 52
	local spacing = 36
	local totalWidth = rowCount * width + math.max(rowCount - 1, 0) * spacing
	local startX = -totalWidth / 2 + width / 2

	button:ClearAllPoints()
	button:SetPoint("TOP", CharCreateClassGuideFrame, "TOP", startX + (index - 1) * (width + spacing), yOffset)
end

local function CharacterCreate_UpdateClassGuideClassButtonSelection(self)
	if not self or not self.classButtonPool then
		return
	end

	for button in self.classButtonPool:EnumerateActive() do
		button:SetSelected(button:GetID() == CharacterCreate.selectedClassGuideClassID)
	end
end

local function CharacterCreate_GetClassGuideExplicitClassOrder(subroleID)
	local classOrder = {}
	if C_CharacterCreate.GetClassGuideSubroleClasses then
		local classes = C_CharacterCreate.GetClassGuideSubroleClasses(subroleID)
		if classes then
			for index, classID in ipairs(classes) do
				classOrder[classID] = index
			end
		end
	end

	return classOrder
end

local function CharacterCreate_ShowClassGuideClasses(self)
	if not CharacterCreate.selectedClassGuideSubroleID then
		return
	end

	local pool = self.classButtonPool
	local classes = {}
	local selectedClassIsAvailable = false
	local explicitClassOrder = CharacterCreate_GetClassGuideExplicitClassOrder(CharacterCreate.selectedClassGuideSubroleID)
	local isHealerSubrole = CharacterCreate_IsClassGuideHealerSubrole(CharacterCreate.selectedClassGuideSubroleID)

	for i = 1, 21 do
		local classID = Enum.Class[COA_CLASS_ORDER[i]]
		if classID
			and C_CharacterCreate.CanCreateClass(classID) then
			local className, classFile = GetClassInfo(classID)
			if className
				and classFile
				and CharacterCreate_ClassPassesGuideFilter(classID, classFile) then
				if CharacterCreateUtil.IsRaceClassEnabledAndValid(CharacterCreate.selectedRace, classID) then
					classes[#classes + 1] = {
						id = classID,
						name = className,
						file = classFile,
						order = explicitClassOrder[classID] or i,
						isCombatHealer = isHealerSubrole and CharacterCreate_IsClassGuideCombatHealer(classFile),
					}
					if classID == CharacterCreate.selectedClassGuideClassID then
						selectedClassIsAvailable = true
					end
				end
			end
		end
	end

	if CharacterCreate.selectedClassGuideClassID and not selectedClassIsAvailable then
		CharacterCreate.selectedClassGuideClassID = nil
	end

	CharCreate_EnableNextButton(CharacterCreate.selectedClassGuideClassID and true or false)
	table.sort(classes, function(left, right)
		if left.isCombatHealer ~= right.isCombatHealer then
			return not left.isCombatHealer
		end

		if left.order ~= right.order then
			return left.order < right.order
		end

		return left.id < right.id
	end)

	local firstRowCount = math.min(#classes, 10)
	local secondRowCount = math.max(#classes - firstRowCount, 0)
	for index, classInfo in ipairs(classes) do
		local button = pool:Acquire()
		button:SetID(classInfo.id)
		button:SetParent(CharCreateClassGuideFrame)
		button:SetClass(classInfo.name, classInfo.file, true)
		button:SetClassGuideCombatHealer(classInfo.isCombatHealer)
		button:SetSelected(classInfo.id == CharacterCreate.selectedClassGuideClassID)
		button:Show()

		if index <= firstRowCount then
			CharacterCreate_SetGuideClassButtonPoint(button, index, firstRowCount, -124)
		else
			CharacterCreate_SetGuideClassButtonPoint(button, index - firstRowCount, secondRowCount, -182)
		end
	end

	CharacterCreate_UpdateClassGuideClassButtonSelection(self)
end

local function CharacterCreate_IsCustomizationOptionLocked(customizationId)
	if not C_CharacterCustomizationUnlocks or not C_CharacterCustomizationUnlocks.GetCurrentOptionInfo then
		return false
	end

	local hasRequirement, isUnlocked = C_CharacterCustomizationUnlocks.GetCurrentOptionInfo(customizationId)
	return hasRequirement and not isUnlocked
end

local function HandleFactionBackground()
	local name, faction = GetFactionForRace(CharacterCreate.selectedRace);

	if not C_CharacterCreate.CanCreateCoA() then
		faction = faction.."REGULAR"
	end

	SetBackgroundModel(CharacterCreate, string.upper(faction));
	IS_ZOOMED = false
	--SetBackgroundModel(CharacterCreate, string.upper(faction));
end

local function SetFaceCustomizeCamera(flag)
	ZoomController.manualZoomIn = nil 
	ZoomController.manualZoomOut = nil
	if (flag) and not(IS_ZOOMED) then
		ZoomController:Show()
		IS_ZOOMED = true
	elseif not(flag) and (IS_ZOOMED) then
		ZoomController:Show()
		IS_ZOOMED = false
	end
end

local function CharacterCreate_UndressCustomizationHeadSlot()
	if CharacterCreateFrame.state ~= Enum.CharCreateSteps.Customization
		and not (CharacterCreate.classGuideActive and CharacterCreateFrame.state == Enum.CharCreateSteps.NameEdit) then
		return
	end

	if not CharCreateShowEquipmentToggle or not CharCreateShowEquipmentToggle:GetChecked() then
		return
	end

	if not CharacterCreate or type(CharacterCreate.UndressSlot) ~= "function" then
		return
	end

	pcall(CharacterCreate.UndressSlot, CharacterCreate, INVSLOT_HEAD)
end

function CharacterCreate_UpdateCustomizationEquipment()
	if CharacterCreateFrame.state ~= Enum.CharCreateSteps.Customization
		and not (CharacterCreate.classGuideActive and CharacterCreateFrame.state == Enum.CharCreateSteps.NameEdit) then
		return
	end

	if CharCreateShowEquipmentToggle and CharCreateShowEquipmentToggle:GetChecked() then
		C_CharacterCreate.Dress()
	else
		C_CharacterCreate.Undress()
	end

	CharacterCreate_UndressCustomizationHeadSlot()
end

function CharCreate_ZoomOutArchetypes()
	local x, y, z = C_CharacterCreate.GetCameraPosition()

	local shiftX, shiftY, shiftZ

	local _, fileString = GetNameForRace()
	local zoomData = CHAR_CREATE_CAMERA_ZOOM_OUTS[fileString]

	if HD_PATCH_ENABLED and fileString == "Human" then -- in HD patch don't change human camera
		zoomData = nil
	end

	if zoomData then
		C_CharacterCreate.SetCameraPosition(unpack(zoomData))
	end

	CHAR_CREATE_ZOOMED_OUT = true
end

--
-- Navigation logic
--
function CharacterCreate_LoadStep()
	CharCreateRoleSelectFrame:Hide()
	CharCreateSubroleSelectFrame:Hide()
	CharCreateArchetypeSelectFrame:Hide()

	CharCreateArchetypeFrame:Hide()
	CharCreateCustomizationFrame:Hide();
	CharCreatePreviewFrame:Hide();
	CharacterCreateNameEdit:Hide();
	CharacterCreateRandomName:Hide();
	CustomizationBG:Hide()
	CharCreateRandomizeButton:Hide()
	CharCreateClassFrame:Hide();
	CharCreateRaceFrame:Hide();
	CharCreateSwapClassesButton:Hide()
	CharacterTemplateConfirmDialog:Hide();
	CharCreateMaleButton:Hide()
	CharCreateFemaleButton:Hide()
	CustomizationLogoAlliance:Hide()
	CustomizationTextAlliance:Hide()
	CustomizationLogoHorde:Hide()
	CustomizationTextHorde:Hide()
	CharCreateDescriptionFrame:Hide()
	CharacterCreateNavigationFrame:Hide()
	CharCreateOkayButton:SetText(CONTINUE)
	CharCreateOkayButton:Enable()

	CharacterCreateFrame.StepName:Show()
	CharacterCreateFrame.StepSubText:Show()
	
	CharCreateMovieFrame:StopMovie()
	if CharCreateMovieFrame:IsShown() then
		CharCreateMovieFrame:Hide()
	end

	CharCreateDescriptionFrame:ClearAndSetPoint("TOPRIGHT", -32, -64)
	CharCreateDescriptionFrame:SetHeight(545)
	C_CharacterCreate.Dress()
	
	CharCreate_ResetCamera()
	local _, classFileName = GetSelectedClass()
	local isHero = classFileName == "HERO"

	if CharacterCreateFrame.state == Enum.CharCreateSteps.ClassRace then
		CharacterCreateFrame.StepName:Hide()
		CharacterCreateFrame.StepSubText:Hide()

		CharCreateClassFrame:Show();
		CharCreateRaceFrame:Show();
		CharCreateMaleButton:Show()
		CharCreateFemaleButton:SetShown(not CharacterCreate_IsMaleOnlyRace())
		CharCreateOkayButton:SetText(CUSTOMIZE);
		CustomizationLogoAlliance:Show()
		CustomizationTextAlliance:Show()
		CustomizationLogoHorde:Show()
		CustomizationTextHorde:Show()
		if CharacterCreate.classGuideActive then
			CharCreateOkayButton:SetText(CONTINUE)
			CharacterCreate_RefreshClassButtons(CharacterCreate)
			CharCreate_EnableNextButton(CharacterCreate.selectedClassGuideClassID and true or false)
			CharacterCreate_SetClassGuideRaceLocked(not CharacterCreate.selectedClassGuideSubroleID)
		else
			CharacterCreate_RefreshClassButtons(CharacterCreate)
			CharCreate_EnableNextButton(true)
		end
		if isHero then
			C_CharacterCreate.ClearClassPreview()
			C_CharacterCreate.SetSelectedArchetype(0, 0, 0)
		else
			C_CharacterCreate.PreviewClassOutfit(classFileName)
		end
	elseif ( CharacterCreateFrame.state == Enum.CharCreateSteps.Customization ) then
		CharacterCreateFrame.StepName:SetText(CHAR_CREATE_CUSTOMIZE_YOUR_APPEARANCE)

		CharacterCreateNavigationFrame:Show()
		CharCreateCustomizationFrame:Show();
		CharacterCreate_UpdateHairCustomization()
		CharCreate_PrepPreviewModels();
		if ( CharacterCreateFrame.customizationType ) then
			CharCreate_ResetFeaturesDisplay();
		else
			CharCreateSelectCustomizationType(1);
		end

		if not CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.NameEdit) then
			CharacterCreateNameEdit:Show()
			if ( ALLOW_RANDOM_NAME_BUTTON ) then
				CharacterCreateRandomName:Show();
			end
		end
		
		CustomizationBG:Show()
		CharCreateRandomizeButton:Show()
		CharCreate_EnableNextButton(true)
		CHAR_CREATE_ZOOMED_OUT = false

		C_CharacterCreate.SetSelectedArchetype(0, 0, 0)
		CharacterCreate_UpdateCustomizationEquipment()
	elseif ( CharacterCreateFrame.state == Enum.CharCreateSteps.Role ) then
		if CharacterCreate.classGuideActive then
			CharacterCreateFrame.StepName:SetText(CLASS_GUIDE_ROLE_SELECT_TEXT)

			CharacterCreateNavigationFrame:Show()
			CharCreateClassFrame:Show()
			CharCreateClassContainer:Hide()
			CharacterCreate_SetClassGuideEntryShown(false)
			CharacterCreate_UpdateClassGuideFrame()
			CharCreateOkayButton:Disable()
		else
			CharacterCreateFrame.StepName:SetText(ROLE_SELECT_TEXT)

			CharacterCreateNavigationFrame:Show()
			CharCreateRoleSelectFrame:Show()

			local roleID = CharCreateRoleSelectFrame:GetCurrentIndex()

			if not roleID then
				CharCreateDescriptionFrame:Hide()
				CharCreateOkayButton:Disable()
			else
				C_CharacterCreate.SetSelectedArchetype(roleID, 0, 0)
				CharCreateDescriptionFrame:SetRole(roleID)
				CharCreateDescriptionFrame:Show()
				CharCreate_EnableNextButton(true)
			end
		end

		CharCreate_ZoomOutArchetypes()
	elseif ( CharacterCreateFrame.state == Enum.CharCreateSteps.Subrole ) then
		if CharacterCreate.classGuideActive then
			CharacterCreateFrame.StepName:SetText(CLASS_GUIDE_CATEGORY_SELECT_TEXT)

			CharacterCreateNavigationFrame:Show()
			CharCreateClassFrame:Show()
			CharCreateClassContainer:Hide()
			CharacterCreate_SetClassGuideEntryShown(false)
			CharacterCreate_UpdateClassGuideFrame()
			CharCreateOkayButton:Disable()
		else
			CharacterCreateFrame.StepName:SetText(SUBROLE_SELECT_TEXT)

			CharacterCreateNavigationFrame:Show()
			CharCreateSubroleSelectFrame:Show()

			local categoryID = CharCreateSubroleSelectFrame:GetCurrentIndex()
			if not categoryID then
				CharCreateDescriptionFrame:Hide()
				CharCreateOkayButton:Disable()
			else
				CharCreateDescriptionFrame:SetCategory(categoryID)
				CharCreateDescriptionFrame:Show()
				CharCreate_EnableNextButton(true)

				local roleID = CharCreateRoleSelectFrame:GetCurrentIndex()
				C_CharacterCreate.SetSelectedArchetype(roleID, categoryID, 0)
			end
		end

		CharCreate_ZoomOutArchetypes()
	elseif ( CharacterCreateFrame.state == Enum.CharCreateSteps.Archetype ) then
		if CharacterCreate.classGuideActive then
			CharacterCreateFrame.StepName:SetText(CLASS_GUIDE_CLASS_SELECT_TEXT)

			CharacterCreateNavigationFrame:Show()
			CharCreateClassFrame:Show()
			CharCreateClassContainer:Hide()
			CharacterCreate_SetClassGuideRaceLocked(false)
			CharacterCreate_SetClassGuideEntryShown(false)
			CharacterCreate_UpdateClassGuideFrame()
			CharacterCreate.classButtonPool:ReleaseAll()
			CharacterCreate_ShowClassGuideClasses(CharacterCreate)
			CharCreate_EnableNextButton(CharacterCreate.selectedClassGuideClassID and true or false)
		else
			CharacterCreateFrame.StepName:SetText(ARCHETYPE_SELECT_TEXT)

			CharacterCreateNavigationFrame:Show()
			CharCreateArchetypeSelectFrame:Show()

			local archetypeID = CharCreateArchetypeSelectFrame:GetCurrentIndex()

			if not archetypeID then
				CharCreateDescriptionFrame:Hide()
				CharCreateOkayButton:Disable()
			else
				CharacterCreate_OnSelectArchetype(nil, archetypeID)
				CharCreate_EnableNextButton(true)
			end
		end

		CharCreate_ZoomOutArchetypes()
	elseif CharacterCreateFrame.state == Enum.CharCreateSteps.NameEdit then
		CharacterCreateNavigationFrame:Show()
		CharacterCreateNameEdit:Show()
		if ( ALLOW_RANDOM_NAME_BUTTON ) then
			CharacterCreateRandomName:Show();
		end

		if CharacterCreate.classGuideActive then
			CharCreateCustomizationFrame:Show()
			CharacterCreate_UpdateHairCustomization()
			CharCreate_PrepPreviewModels();
			if ( CharacterCreateFrame.customizationType ) then
				CharCreate_ResetFeaturesDisplay();
			else
				CharCreateSelectCustomizationType(1);
			end

			CustomizationBG:Show()
			CharCreateRandomizeButton:Show()
			CharCreate_EnableNextButton(true)
			CHAR_CREATE_ZOOMED_OUT = false
			CharacterCreate_UpdateCustomizationEquipment()
		else
			if not isHero then
				C_CharacterCreate.PreviewClassOutfit(classFileName)
			else
				C_CharacterCreate.ClearClassPreview()
			end
			CharCreate_ZoomOutArchetypes()
		end
	end

	CharacterCreate_UndressCustomizationHeadSlot()

	if not CharacterCreateNavigationFrame:GetNextIndex() then
		CharCreateOkayButton:SetText(FINISH)
	end
end

function CharCreate_CheckExtraSteps()
	if CharacterCreate.classGuideActive then
		return
	end

	local rolesButton = CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Role)
	local subRolesButton = CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Subrole)
	local archeTypeButton = CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Archetype)
	local nameButton = CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.NameEdit)

	if rolesButton and not(CharCreateRoleSelectFrame:GetCurrentIndex()) then
		rolesButton:SetText(ROLE_SELECT_TEXT)

		if subRolesButton then
			subRolesButton:Disable()
		end

		rolesButton.IconAdd:SetAtlas("ExperienceIconBeginner", Const.TextureKit.IgnoreAtlasSize)
	end

	if subRolesButton and not(CharCreateSubroleSelectFrame:GetCurrentIndex()) then
		subRolesButton:SetText(SUBROLE_SELECT_TEXT)

		if archeTypeButton then
			archeTypeButton:Disable()
		end

		subRolesButton.IconAdd:SetAtlas("ExperienceIconBeginner", Const.TextureKit.IgnoreAtlasSize)
	end

	if archeTypeButton and not(CharCreateArchetypeSelectFrame:GetCurrentIndex()) then
		archeTypeButton:SetText(ARCHETYPE_SELECT_TEXT)

		if nameButton then
			nameButton:Disable()
		end

		archeTypeButton:SetUp()
	end
end

function CharacterCreate_UpdateNavigtationRaceButton()
	local button = _G["CharCreateRaceButton"..CharacterCreate.selectedRace]

	if button then
		local raceButton = CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.ClassRace)
		if not raceButton then
			return
		end

		raceButton.IconAdd:Hide()

		raceButton:SetText(string.format(RACE_SELECTED_TEXT, button.Text:GetText() or ""))

		local texture = button:GetNormalTexture():GetTexture()
		local ULx,ULy,LLx,LLy,URx,URy,LRx,LRy = button:GetNormalTexture():GetTexCoord()

		raceButton.Icon:SetTexture(texture)
		raceButton.Icon:SetTexCoord(ULx,ULy,LLx,LLy,URx,URy,LRx,LRy)
	end
end

function CharacterCreate_LoadNavigation(steps)
	CharacterCreateNavigationFrame:ClearAll()

	for i = 1, #steps do
		CharacterCreateNavigationFrame:AddIndex(steps[i])
	end

	CharacterCreate_UpdateNavigtationRaceButton()

	local customizationButton = CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Customization)
	if customizationButton then
		customizationButton.IconAdd:SetSize(56, 56)
		customizationButton.IconAdd:SetTexture("interface\\glues\\charactercreate\\CharacterCreate")
		customizationButton.IconAdd:SetTexCoord(0.29150390625, 0.357421875, 0.7880859375, 0.919921875)
		customizationButton:SetText(CUSTOMIZE)
	end

	local nameEditButton = CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.NameEdit)

	if nameEditButton then
		nameEditButton.IconAdd:SetSize(56, 56)
		nameEditButton.IconAdd:SetTexture("interface\\glues\\charactercreate\\CharacterCreate")
		nameEditButton.IconAdd:SetTexCoord(0.42431640625, 0.47314453125, 0.8408203125, 0.94140625)
		nameEditButton:SetText(CHARACTER_NAME)
	end

	CharCreateRoleSelectFrame:ClearSelected()
	CharCreateSubroleSelectFrame:ClearAll()
	CharCreateArchetypeSelectFrame:ClearAll()

	CharCreate_CheckExtraSteps()
end

function CharacterCreate_OnStepChanged(_, step, isForced)
	print("CharacterCreate_OnStepChanged "..step)
	if CharacterCreateFrame.state == Enum.CharCreateSteps.Archetype then
		CharCreateMovieFrame:StopMovie()
		if CharCreateMovieFrame:IsShown() then
			CharCreateMovieFrame:Hide()
		end
	end

	CharacterCreateFrame.state = step

	if (step == Enum.CharCreateSteps.NameEdit) or isForced then -- don't flash light for name edit
		CharacterCreate_LoadStep()
		return
	end

	GlueFrameFadeIn(CharacterCreateFrameFade, 0.3, function()
		if step == Enum.CharCreateSteps.ClassRace then
			HandleFactionBackground()
		else
			local race, fileString = GetNameForRace()
			SetBackgroundModel(CharacterCreate, string.upper(fileString))
		end

		GlueFrameFadeOut(CharacterCreateFrameFade, 0.25)
		CharacterCreate_LoadStep()
	end)
end

function CharacterCreate_OnArchetypeBaseChanged(_, archetypeChoice)
	if archetypeChoice == Enum.CharCreateArchetypeBases.Freepick then
		CharacterCreate_LoadNavigation(CHAR_CREATE_STEPS_DEFAULT)
	elseif archetypeChoice == Enum.CharCreateArchetypeBases.UseArchetype then
		CharacterCreate_LoadNavigation(CHAR_CREATE_STEPS_EXTEND)
	end

	if not CharacterCreateNavigationFrame:GetCurrentIndex() or (CharacterCreateNavigationFrame:GetCurrentIndex() ~= CHAR_CREATE_STEPS_DEFAULT[1]) then
		CharacterCreateNavigationFrame:GoToIndex(CHAR_CREATE_STEPS_DEFAULT[1], true)
	end
end

function CharacterCreate_OnSelectRole(self, roleID)
	if not roleID then
		return
	end

	-- clear subrole/architect 
	CharCreateSubroleSelectFrame:ClearSelected()
	CharCreateArchetypeSelectFrame:ClearSelected()
	CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Archetype):Disable()

	CharCreateSubroleSelectFrame:LoadSubroles(roleID)
	CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Subrole):Enable()

	if (CharCreateOkayButton:IsEnabled() == 0) then
		CharCreate_EnableNextButton(true)
	end

	local artwork, name = C_CharacterCreate.GetArchetypeRoleInfo(roleID)
	CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Role).IconAdd:SetAtlas(artwork)
	CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Role):SetText(string.format(ROLE_SELECTED_TEXT, name))

	CharCreateDescriptionFrame:SetRole(roleID)
	CharCreateDescriptionFrame:Show()

	CharCreate_CheckExtraSteps()

	C_CharacterCreate.SetSelectedArchetype(roleID, 0, 0)
end

function CharacterCreate_OnSelectCategory(self, categoryID)
	CharCreateArchetypeSelectFrame:ClearSelected()

	CharCreateArchetypeSelectFrame:LoadArchetypes(categoryID)
	CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Archetype):Enable()

	if (CharCreateOkayButton:IsEnabled() == 0) then
		CharCreate_EnableNextButton(true)
	end

	local iconArtwork, _, name = C_CharacterCreate.GetArchetypeCategoryInfo(categoryID)
	CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Subrole).IconAdd:SetAtlas(iconArtwork)
	CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Subrole):SetText(string.format(SUBROLE_SELECTED_TEXT, name))

	CharCreateDescriptionFrame:SetCategory(categoryID)
	CharCreateDescriptionFrame:Show()

	CharCreate_CheckExtraSteps()

	C_CharacterCreate.SetSelectedArchetype(CharCreateRoleSelectFrame:GetCurrentIndex(), categoryID, 0)
end

function CharacterCreate_OnSelectArchetype(_, archetypeID)
	CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.NameEdit):Enable()

	if (CharCreateOkayButton:IsEnabled() == 0) then
		CharCreate_EnableNextButton(true)
	end

	local _, _, _, _, _, icon, _, _, _, name = C_CharacterCreate.GetArchetypeInfo(archetypeID)
	local archetypeButton = CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Archetype)

	if name and archetypeButton then
		archetypeButton.IconAdd:Hide()
		archetypeButton:SetText(string.format(ARCHETYPE_SELECTED_TEXT, name))
		archetypeButton.Icon:SetPortraitTexture("Interface\\Icons\\"..icon)
		archetypeButton.Icon:SetTexCoord(0, 1, 0, 1)
	end

	CharCreateDescriptionFrame:ClearAndSetPoint("TOP", CharCreateMovieFrame, "BOTTOM", 0, -16)
	CharCreateDescriptionFrame:SetHeight(361)
	CharCreateDescriptionFrame:SetArchetype(archetypeID)
	CharCreateDescriptionFrame:Show()

	-- @andrew Disabled because the videos just crash the game for a bunch of people.
	--[[CharCreateMovieFrame:Show()
	CharCreateMovieFrame:StartMovieForArchetype(archetypeID)]]

	C_CharacterCreate.SetSelectedArchetype(CharCreateRoleSelectFrame:GetCurrentIndex(), CharCreateSubroleSelectFrame:GetCurrentIndex(), archetypeID)
end

function CharacterCreate_OnLoad(self)
	self.classButtonPool = CreateFramePool("CheckButton", CharCreateClassFrame, "CharCreateClassButtonTemplate")
	CharacterCreate_CreateClassGuideFrame()
	self:RegisterEvent("RANDOM_CHARACTER_NAME_RESULT");
	self:RegisterEvent("GLUE_UPDATE_EXPANSION_LEVEL");

	self:SetSequence(0);
	self:SetCamera(0);

	CharacterCreate.numRaces = 0;
	CharacterCreate.selectedRace = 0;
	CharacterCreate.numClasses = 0;
	CharacterCreate.selectedClass = 0;
	CharacterCreate.selectedGender = 0;

	SetCharCustomizeFrame("CharacterCreate");

	for i=1, NUM_CHAR_CUSTOMIZATIONS, 1 do
		_G["CharCreateCustomizationButton"..i].text:SetText(_G["CHAR_CUSTOMIZATION"..i.."_DESC"]);
	end

	CharacterCreateRandomName:SetParent(CharacterCreateNameEdit)

	-- Color edit box backdrop
	local backdropColor = FACTION_BACKDROP_COLOR_TABLE["Alliance"];
	CharacterCreateNameEdit:SetBackdropBorderColor(backdropColor[1], backdropColor[2], backdropColor[3]);
	CoACharacterNames.InitCreation()
	CharacterCreateNameEdit:SetBackdropColor(backdropColor[4], backdropColor[5], backdropColor[6]);
	CharacterCreateSecondNameEdit:SetBackdropColor(backdropColor[4], backdropColor[5], backdropColor[6]);
	--[[CharacterCreateNameEdit:SetParent(CharacterCreateFrame)
	CharacterCreateNameEdit:SetPoint("TOPLEFT", CharacterCreateFrame, 635, -30)]]--
	CharCreateCustomizationFrame:SetPoint("RIGHT", CharacterCreateFrame, -50, -10)

	-- load navigation
	CharacterCreateNavigationFrame:RegisterCallback("OnIndexSelected", CharacterCreate_OnStepChanged, self)
	CharacterCreateNavigationFrame:Hide()
	CharCreateArchetypeFrame:RegisterCallback("OnIndexSelected", CharacterCreate_OnArchetypeBaseChanged, self)

	-- set up extra menus
	CharCreateRoleSelectFrame:RegisterCallback("OnIndexSelected", CharacterCreate_OnSelectRole, self)
	CharCreateSubroleSelectFrame:RegisterCallback("OnIndexSelected", CharacterCreate_OnSelectCategory, self)
	CharCreateArchetypeSelectFrame:RegisterCallback("OnIndexSelected", CharacterCreate_OnSelectArchetype, self)

	CharCreatePreviewFrame.previews = { };

	-- custom Lua
	_G["CharCreateMaleButtonNormalTexture"]:SetDrawLayer("BACKGROUND")
	_G["CharCreateFemaleButtonNormalTexture"]:SetDrawLayer("BACKGROUND")
	_G["CharCreateMaleButtonPushedTexture"]:SetDrawLayer("BACKGROUND")
	_G["CharCreateFemaleButtonPushedTexture"]:SetDrawLayer("BACKGROUND")
	_G["CharCreateRandomizeButtonNormalTexture"]:SetDrawLayer("BACKGROUND")
	_G["CharacterCreateRandomNameNormalTexture"]:SetDrawLayer("BACKGROUND")
	_G["CharCreateRandomizeButtonPushedTexture"]:SetDrawLayer("BACKGROUND")
	_G["CharacterCreateRandomNamePushedTexture"]:SetDrawLayer("BACKGROUND")
	--CharCreateMaleButton:Hide()
	--CharCreateFemaleButton:Hide()

	CustomizationBG = CharacterCreateFrame:CreateTexture("CustomizationBG", "BACKGROUND")
	CustomizationBG:SetSize(512, GlueParent:GetHeight())
    CustomizationBG:SetTexture("Interface\\Glues\\CharacterCreate\\Shadowv")
    CustomizationBG:SetPoint("RIGHT")
    CustomizationBG:Hide()

    CharacterCreateFrameFade = CreateFrame("FRAME", "CharacterCreateFrameFade", CharacterCreateFrame)
    CharacterCreateFrameFade:SetPoint("CENTER", 0, 0)
    CharacterCreateFrameFade:SetSize(GlueParent:GetWidth(), GlueParent:GetHeight())
    CharacterCreateFrameFade:SetFrameStrata("DIALOG")
    CharacterCreateFrameFade:SetFrameLevel(10)
    --CharacterCreateFrameFade:Hide()

    --[[CharacterCreateTopNavi = CreateFrame("FRAME", "CharacterCreateTopNavi", CharacterCreateFrame)
    CharacterCreateTopNavi:SetPoint("BOTTOM", 0, 4)
    CharacterCreateTopNavi:SetSize(GlueParent:GetWidth(), 128)

    CharCreateBackButton:Hide()
	CharCreateOkayButton:Hide()

	CharCreateBackButtonTopNavi = CreateFrame("Button", "CharCreateBackButtonTopNavi", CharacterCreateTopNavi, "CharCreateNavButtonTemplate")
	CharCreateBackButtonTopNavi:SetPoint("BOTTOMLEFT", 54, -6)
	CharCreateBackButtonTopNavi:SetText(BACK)
	CharCreateBackButtonTopNavi:SetScript("OnClick", function(self)
		CharCreateBackButton:GetScript("OnClick")(CharCreateBackButton)
	end)

	CharCreateOkayButtonTopNavi = CreateFrame("Button", "CharCreateOkayButtonTopNavi", CharacterCreateTopNavi, "CharCreateNavButtonTemplate")
	CharCreateOkayButtonTopNavi:SetPoint("BOTTOMRIGHT", -52, -6)
	CharCreateOkayButtonTopNavi:SetText("Customize")
	CharCreateOkayButtonTopNavi:SetScript("OnClick", function(self)
		CharCreateOkayButton:GetScript("OnClick")(CharCreateOkayButton)
	end)

	CharacterCreateTopNaviBG = CharacterCreateTopNavi:CreateTexture("CharacterCreateTopNaviBG", "BACKGROUND")
	CharacterCreateTopNaviBG:SetSize(1360, 85)
    CharacterCreateTopNaviBG:SetTexture("Interface\\Glues\\CharacterCreate\\TopNavi")
    CharacterCreateTopNaviBG:SetPoint("BOTTOM")
    CharacterCreateTopNaviBG:SetTexCoord(1,0,1,0)

	CharacterCreateTopNavi.Text = CharacterCreateTopNavi:CreateFontString("CharacterCreateTopNavi.Text", "OVERLAY")
    CharacterCreateTopNavi.Text:SetFontObject(GlueFontNormal)
    CharacterCreateTopNavi.Text:SetFont("Fonts\\FRIZQT__.TTF", 16)
    CharacterCreateTopNavi.Text:SetText("CHARACTER CREATION - |cffFFFFFFSELECT RACE/CLASS|r")
    CharacterCreateTopNavi.Text:SetPoint("BOTTOM", 0, 8)]]--

    --CharacterCreateTopNavi:SetFrameStrata("DIALOG")
    --CharacterCreateTopNavi:SetFrameLevel(10)

	CustomizationBG2 = CharacterCreateFrame:CreateTexture("CustomizationBG2", "BACKGROUND")
	CustomizationBG2:SetSize(GlueParent:GetWidth(), GlueParent:GetHeight())
    CustomizationBG2:SetTexture("Interface\\Glues\\CharacterCreate\\MainShadow")
    CustomizationBG2:SetPoint("CENTER")
    CustomizationBG2:SetAlpha(1)

    CustomizationBGAddRight = CharacterCreateFrame:CreateTexture("CustomizationBGAddRight", "BACKGROUND")
	CustomizationBGAddRight:SetSize(300, GlueParent:GetHeight())
    CustomizationBGAddRight:SetTexture("Interface\\Glues\\CharacterCreate\\Shadowv")
    CustomizationBGAddRight:SetPoint("RIGHT")
    CustomizationBGAddRight:SetAlpha(1)

    CustomizationBGAddRight = CharacterCreateFrame:CreateTexture("CustomizationBGAddRight2", "BACKGROUND")
	CustomizationBGAddRight:SetSize(300, GlueParent:GetHeight())
    CustomizationBGAddRight:SetTexture("Interface\\Glues\\CharacterCreate\\Shadowv")
    CustomizationBGAddRight:SetPoint("RIGHT")
    CustomizationBGAddRight:SetAlpha(1)

    CustomizationBGAddLeft = CharacterCreateFrame:CreateTexture("CustomizationBGAddLeft", "BACKGROUND")
	CustomizationBGAddLeft:SetSize(300, GlueParent:GetHeight())
    CustomizationBGAddLeft:SetTexture("Interface\\Glues\\CharacterCreate\\Shadowv")
    CustomizationBGAddLeft:SetPoint("LEFT")
    CustomizationBGAddLeft:SetTexCoord(1, 0, 1, 0)
    CustomizationBGAddLeft:SetAlpha(1)

	CharacterCreateFrameFadeBG = CharacterCreateFrameFade:CreateTexture("CharacterCreateFrameFadeBG", "OVERLAY")
	CharacterCreateFrameFadeBG:SetSize(GlueParent:GetWidth(), GlueParent:GetHeight())
    CharacterCreateFrameFadeBG:SetTexture("Interface\\Glues\\CharacterCreate\\Black")
    CharacterCreateFrameFadeBG:SetPoint("CENTER")

	CustomizationLogoAlliance = CharacterCreateFrame:CreateTexture("CustomizationLogoAlliance", "ARTWORK")
	CustomizationLogoAlliance:SetSize(100, 100)
    CustomizationLogoAlliance:SetTexture("Interface\\Glues\\CharacterCreate\\AllianceLogo")
    CustomizationLogoAlliance:SetPoint("TOPLEFT", -16, 16)

	CustomizationTextAlliance = CharacterCreateFrame:CreateFontString("CustomizationTextAlliance", "OVERLAY")
    CustomizationTextAlliance:SetFontObject(GlueFontNormal)
    CustomizationTextAlliance:SetFont("Fonts\\FRIZQT__.TTF", 16)
    CustomizationTextAlliance:SetText(string.upper(ALLIANCE))
    CustomizationTextAlliance:SetPoint("LEFT", CustomizationLogoAlliance, "RIGHT", -24, 0)

	CustomizationLogoHorde = CharacterCreateFrame:CreateTexture("CustomizationLogoHorde", "ARTWORK")
	CustomizationLogoHorde:SetSize(100, 100)
    CustomizationLogoHorde:SetTexture("Interface\\Glues\\CharacterCreate\\HordeLogo")
    CustomizationLogoHorde:SetPoint("TOPRIGHT", 16, 16)

	CustomizationTextHorde = CharacterCreateFrame:CreateFontString("CustomizationTextHorde", "OVERLAY")
    CustomizationTextHorde:SetFontObject(GlueFontNormal)
    CustomizationTextHorde:SetFont("Fonts\\FRIZQT__.TTF", 16)
    CustomizationTextHorde:SetText(string.upper(HORDE))
    CustomizationTextHorde:SetPoint("RIGHT", CustomizationLogoHorde, "LEFT", 24, 0)

	CharCreateMaleButton.nameFrame.text:SetText(MALE)
	CharCreateMaleButton.nameFrame:Show()

	CharCreateFemaleButton.nameFrame.text:SetText(FEMALE)
	CharCreateFemaleButton.nameFrame:Show()

	--[[CustomizationLogoClass = CharacterCreateFrame:CreateTexture("CustomizationLogoClass", "ARTWORK")
	CustomizationLogoClass:SetSize(100, 100)
    --CustomizationLogoClass:SetTexture("Interface\\Glues\\CharacterCreate\\ClassLogo")
    CustomizationLogoClass:SetPoint("TOP", -16, 16)

	CustomizationTextClass = CharacterCreateFrame:CreateFontString("CustomizationTextClass", "OVERLAY")
    CustomizationTextClass:SetFontObject(GlueFontHighlight)
    CustomizationTextClass:SetFont("Fonts\\FRIZQT__.TTF", 16)
    CustomizationTextClass:SetText(string.upper("class"))
    CustomizationTextClass:SetPoint("CENTER", CustomizationLogoClass, "RIGHT", -24, 0)]]--

	CustomizationLineBottom = CharacterCreateFrame:CreateTexture("CustomizationLineBottom", "ARTWORK")
	CustomizationLineBottom:SetSize(GlueParent:GetWidth(), 96)
    CustomizationLineBottom:SetTexture("Interface\\Glues\\CharacterCreate\\bottomline")
    CustomizationLineBottom:SetPoint("BOTTOM", 0, 0)

	CustomizationLineTop = CharacterCreateFrame:CreateTexture("CustomizationLineTop", "ARTWORK")
	CustomizationLineTop:SetSize(GlueParent:GetWidth(), 96)
    CustomizationLineTop:SetTexture("Interface\\Glues\\CharacterCreate\\bottomline")
    CustomizationLineTop:SetPoint("TOP", 0, 0)
    CustomizationLineTop:SetTexCoord(1,0,1,0)

    --CharacterCreateNameEdit:SetScript("OnTextChanged", CharCreationNameCheck)
    --GlueFrameFadeOut(CharacterCreateFrameFade, 0.5)
end

function CharCustomizeButtonClick(id, button)
	if (button == 'LeftButton') then
		for i = 1, math.random(1, 5) do
			CharacterCustomization_Left(id)
		end
	elseif (button == 'RightButton') then
		for i = 1, math.random(1, 5) do
			CharacterCustomization_Right(id)
		end
	end

	if (id > 1) then
		SetFaceCustomizeCamera(true)
	else
		SetFaceCustomizeCamera(false)
	end

	-- CycleCharCustomization(id, 1);
	--[[FeatureType = id
	for i=1,5 do
		_G["CharCreateCustomizationButton"..i]:SetChecked(0);
	end
	_G["CharCreateCustomizationButton"..id]:SetChecked(1);]]

end

function CharacterCreate_RefreshClassButtons(self)
	CharacterCreate_EnableVanillaClasses()
	local isCoA = C_CharacterCreate.CanCreateCoA()
	local isClassicClass = C_CharacterCreate.CanCreateWCR()
	local canCreateHero = C_CharacterCreate.CanCreateHero()

	CharCreateSwapClassesButton:SetShown(isCoA and isClassicClass)

	if isCoA and isClassicClass then
		local _, _, classIndex = GetSelectedClass()

		if (classIndex == Enum.Class.HERO) then
			CharacterCreate_ShowFreepickClasses(self)
		elseif classIndex >= Enum.Class.CustomStart then
			CharacterCreate_ShowCoAClasses(self)
		else
			CharacterCreate_ShowRegularClasses(self)
		end
	elseif isCoA then
		CharacterCreate_ShowCoAClasses(self)
	elseif isClassicClass then
		CharacterCreate_ShowRegularClasses(self)
	elseif canCreateHero then
		CharacterCreate_ShowFreepickClasses(self)
	end
end

function RefreshSelectedClass()
	local classID = select(3, GetSelectedClass())
	if not CharacterCreateUtil.IsRaceClassEnabledAndValid(CharacterCreate.selectedRace, classID) then
		classID = CharacterCreateUtil.GetRandomAvailableClassForRace(CharacterCreate.selectedRace)
		SetSelectedClass(classID)
		SetCharacterClass(classID)
	end
    
	--CharacterCreate_RefreshClassButtons(CharacterCreate) -- TODO: Review, causes crash?
end

function CharacterCreate_OnShow()
	NewCharacterSetupUtil.ClearPendingData()
	CharacterCreate_EnsureRaceButtons()
	for i=1, MAX_RACES, 1 do
		local button = _G["CharCreateRaceButton"..i]
		button:EnableMouse(true)
		button:Enable()
		SetButtonDesaturated(button, false)
	end

	if ( PAID_SERVICE_TYPE ) then
		CustomizeExistingCharacter( PAID_SERVICE_CHARACTER_ID );
		CoACharacterNames.SetCreationName(PaidChange_GetName());
		CharCreateArchetypeFrame:GoToIndex(Enum.CharCreateArchetypeBases.Freepick)
	else
		NewCharacterSetupUtil.SetPendingKeyValue("enableTransmog", true)
        NewCharacterSetupUtil.SetPendingKeyValue("enableLevelScaling", true)
		--randomly selects a combination
		ResetCharCustomize();
		CoACharacterNames.SetCreationName("");
		CharCreateRandomizeButton:Show();
	end

	CharCreateShowEquipmentToggle:SetChecked(true)

	if not CharCreateArchetypeFrame:GetCurrentIndex() or (CharCreateArchetypeFrame:GetCurrentIndex() ~= Enum.CharCreateArchetypeBases.Freepick) then
		CharCreateArchetypeFrame:GoToIndex(Enum.CharCreateArchetypeBases.Freepick)
	end

	CharacterCreateEnumerateRaces(GetAvailableRaces());
	SetCharacterRace(GetSelectedRace());
	HandleFactionBackground()
	GlueFrameFadeOut(CharacterCreateFrameFade, 0.5)

	CharacterCreate_RefreshClassButtons(CharacterCreate)

	if C_CharacterCreate.CanCreateHero() then
		SetSelectedClass(HERO_CLASS_ID)
		SetCharacterClass(HERO_CLASS_ID)

		if not PAID_SERVICE_TYPE then
			if C_CharacterCreate.CanCreateArchetype() then
				CharCreateArchetypeFrame:GoToIndex(Enum.CharCreateArchetypeBases.UseArchetype)
			else
				CharCreateArchetypeFrame:GoToIndex(Enum.CharCreateArchetypeBases.Freepick)
			end
		end
	else
		local _,_,index = GetSelectedClass()
		SetCharacterClass(index)
	end

	SetCharacterGender(GetSelectedSex());
	--end

	-- Hair customization stuff
	CharacterCreate_UpdateHairCustomization();
	SetCharacterCreateFacing(-15);
	
	CharacterChangeFixup(); -- this will fix class if druid is a wrong class for this realm

	CharCreateRoleSelectFrame:ClearSelected()
	CharCreateSubroleSelectFrame:ClearAll()
	CharCreateArchetypeSelectFrame:ClearAll()

	if CharacterCreateFrame.state and (CharacterCreateFrame.state ~= CHAR_CREATE_STEPS_DEFAULT[1]) then
		CharacterCreateNavigationFrame:GoToIndex(CHAR_CREATE_STEPS_DEFAULT[1])
	end
end

function CharacterCreate_OnHide()
	PAID_SERVICE_CHARACTER_ID = nil;
	PAID_SERVICE_TYPE = nil;
	if ( CharacterCreateFrame.state == "CUSTOMIZATION" ) then
		CharacterCreate_Back();
	end
	-- character previews will need to be redone if coming back to character create. One reason is all the memory used for
	-- tracking the frames (on the c side) will get released if the user returns to the login screen
	CharCreatePreviewFrame.rebuildPreviews = true;
	CharCreate_ResetCamera()
end

function CharacterCreate_OnEvent(event, arg1, arg2, arg3)
	if ( event == "RANDOM_CHARACTER_NAME_RESULT" ) then
		if ( arg1 == 0 ) then
			-- Failed.  Generate a random name locally.
			CharacterCreateNameEdit:SetText(GenerateRandomName());
		else
			-- Succeeded.  Use what the server sent.
			CharacterCreateNameEdit:SetText(arg2);
		end
		CharacterCreateRandomName:Enable();
		CharCreateOkayButton:Enable();
		PlaySound("gsCharacterCreationLook");
	elseif ( event == "GLUE_UPDATE_EXPANSION_LEVEL" ) then
		-- Expansion level changed while online, so enable buttons as needed
		if ( CharacterCreateFrame:IsShown() ) then
			CharacterCreateEnumerateRaces(GetAvailableRaces());
			CharacterCreate_RefreshClassButtons(CharacterCreate)
		end
	end
end

function CharacterCreateFrame_OnMouseWheel(delta)
	if CharacterCreateFrame.state ~= Enum.CharCreateSteps.Customization then
		return
	end

	local _, fileString = GetNameForRace()
	local zoomInValue = math.abs(ZoomController.zoom - (CHAR_CREATE_CAMERA_ZOOM_IN[fileString] or CHAR_CREATE_ZOOM))*0.5
	local zoomOutValue = ZoomController.zoom*0.5

	if delta > 0 then
		ZoomController.manualZoomOut = nil
		ZoomController.manualZoomIn = ZoomController.zoom + zoomInValue
		IS_ZOOMED = true
	else
		ZoomController.manualZoomIn = nil 
		ZoomController.manualZoomOut = math.max(0, ZoomController.zoom - zoomOutValue)
		IS_ZOOMED = false
	end
	
	ZoomController:Show()
end

function CharacterCreateFrame_OnMouseDown(button)
	if ( button == "LeftButton" ) then
		CHARACTER_CREATE_ROTATION_START_X = GetCursorPosition();
		CHARACTER_CREATE_INITIAL_FACING = GetCharacterCreateFacing();
	end
end

function CharacterCreateFrame_OnMouseUp(button)
	if ( button == "LeftButton" ) then
		CHARACTER_CREATE_ROTATION_START_X = nil
	end
end

function CharacterCreateFrame_OnUpdate(self, elapsed)
	if ( CHARACTER_CREATE_ROTATION_START_X ) then
		local x = GetCursorPosition();
		local diff = (x - CHARACTER_CREATE_ROTATION_START_X) * CHARACTER_ROTATION_CONSTANT;
		CHARACTER_CREATE_ROTATION_START_X = GetCursorPosition();
		SetCharacterCreateFacing(GetCharacterCreateFacing() + diff);
		CharCreate_RotatePreviews();
	end
	CharacterCreateWhileMouseDown_Update(elapsed);
end

function CharacterCreateEnumerateRaces(...)
	CharacterCreate.numRaces = select("#", ...)/3;
	if ( CharacterCreate.numRaces > MAX_RACES ) then
		message("Too many races!  Update MAX_RACES");
		return;
	end
	local button, gender;
	local index = 1;
	local selectedSex = GetSelectedSex();
	if ( selectedSex == SEX_MALE ) then
		gender = "MALE";
	else
		gender = "FEMALE";
	end

	for i=1, select("#", ...), 3 do
		local raceName, raceEnglishName, enabled = select(i, ...)
		enabled = toboolean(enabled)
		raceEnglishName = raceEnglishName:upper()
		button = _G["CharCreateRaceButton"..index]
		local okFaction, _, buttonFaction = pcall(GetFactionForRace, index)
		CharacterCreate_AliasExtraRacials(okFaction and buttonFaction or "Alliance")
		
		button:SetRace(raceName, raceEnglishName, gender, enabled)
		index = index + 1
	end

	for i = CharacterCreate.numRaces + 1, MAX_RACES, 1 do
		_G["CharCreateRaceButton"..i]:Hide()
	end
	CharacterCreate_LayoutRaceButtons(CharacterCreate.numRaces)
end

function CharacterCreate_ShowRegularClasses(self)
	CharCreateClassFrame:Show()
	CharCreateArchetypeFrame:Hide()
	CharacterCreate.classGuideActive = false
	CharacterCreate_SetClassGuideEntryShown(false)
	CharacterCreate_HideClassGuide()
	CharCreateClassContainer:Show()

	local pool = self.classButtonPool
	pool:ReleaseAll()

	CharCreateClassContainer.Row2:Hide()

	local layoutIndex = 0
	local classID, button, className, classFile, enabled
	for i = 1, 11 do
		classID = Enum.Class[CLASSIC_CLASS_ORDER[i]]
		if classID ~= 6 and C_CharacterCreate.CanCreateClass(classID) then
			layoutIndex = layoutIndex + 1
			button = pool:Acquire()
			button:SetID(classID)
			button.layoutIndex = layoutIndex
			button:SetParent(CharCreateClassContainer.Row1)
			button:Show()
			className, classFile = GetClassInfo(classID)
			button:SetClass(className, classFile, true)
		end
	end
	
	CharCreateClassContainer.Row1:MarkDirty()
	CharCreateClassContainer.Row2:MarkDirty()
	CharCreateClassContainer:MarkDirty()

	CharacterCreate.classesVisible = "REGULAR"
	CharCreateSwapClassesButton:SetText("CoA Classes")
end

function CharacterCreate_ShowCoAClasses(self)
	CharCreateClassFrame:Show()
	CharCreateArchetypeFrame:Hide()

	local pool = self.classButtonPool
	pool:ReleaseAll()

	if CharacterCreate.classGuideActive and CharacterCreate_HasClassGuideData() then
		CharacterCreate_SetClassGuideEntryShown(false)
		CharCreateClassContainer:Hide()
		CharacterCreate_UpdateClassGuideFrame()
		CharacterCreate_ShowClassGuideClasses(self)
		self.classesVisible = "COA"
		return
	end

	CharacterCreate.classGuideActive = false
	CharacterCreate_SetClassGuideEntryShown(true)
	CharacterCreate_HideClassGuide()
	CharCreateClassContainer:Show()

	CharCreateClassContainer.Row2:Show()

	local numInRow1 = 10
	local layoutIndex = 0
	local classID, row, button, className, classFile, enabled
	for i = 1, 21 do
		classID = Enum.Class[COA_CLASS_ORDER[i]]
		if classID and C_CharacterCreate.CanCreateClass(classID) then
			className, classFile, enabled = GetClassInfo(classID)
			if className and classFile then
				layoutIndex = layoutIndex + 1
				button = pool:Acquire()
				if numInRow1 > 0 then
					row = CharCreateClassContainer.Row1
					numInRow1 = numInRow1 - 1
					button.layoutIndex = layoutIndex
				else
					row = CharCreateClassContainer.Row2
					button.layoutIndex = layoutIndex - 10
				end
				button:SetID(classID)
				button:SetParent(row)
				button:Show()
				button:SetClass(className, classFile, enabled)
			end
		end
	end

	CharCreateClassContainer.Row1:MarkDirty()
	CharCreateClassContainer.Row2:MarkDirty()
	CharCreateClassContainer:MarkDirty()

	self.classesVisible = "COA"
	CharCreateSwapClassesButton:SetText("Classic Classes")
end

function CharacterCreate_ShowFreepickClasses(self)
	CharCreateClassFrame:Hide()
	CharacterCreate.classGuideActive = false
	CharacterCreate_SetClassGuideEntryShown(false)
	CharacterCreate_HideClassGuide()
	
	if C_CharacterCreate.CanCreateArchetype() then
		CharCreateArchetypeFrame:Show()
	else
		CharCreateArchetypeFrame:Hide()
	end

	CharacterCreate.classesVisible = "FREEPICK"
end

function CharacterCreate_SwapClasses()
	if (CharacterCreate.classesVisible == "REGULAR") then
		CharacterCreate_ShowCoAClasses(CharacterCreate)
	else
		CharacterCreate_ShowRegularClasses(CharacterCreate)
	end
end

CHAR_CREATE_MALE_ONLY_RACES = {
	["Tuskarr"] = true, ["Taunka"] = true, ["Vrykul"] = true, ["Forest Troll"] = true, ["Ice Troll"] = true,
	["Fel Orc"] = true, ["Skeleton"] = true, -- Murloc: male = Whim murloc, female = classic murloc
}

function CharacterCreate_IsMaleOnlyRace(id)
	local button = _G["CharCreateRaceButton"..(id or CharacterCreate.selectedRace or 0)]
	local name = button and button.Text and button.Text:GetText()
	return name and CHAR_CREATE_MALE_ONLY_RACES[name] or false
end

function SetCharacterRace(id)

	CharacterCreate.selectedRace = id;
	for i=1, CharacterCreate.numRaces, 1 do
		local button = _G["CharCreateRaceButton"..i];
		if ( i == id ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
	end

	if CharacterCreate_IsMaleOnlyRace(id) then
		CharCreateFemaleButton:Hide()
		if GetSelectedSex() ~= SEX_MALE then
			SetCharacterGender(SEX_MALE)
			return
		end
	elseif CharCreateMaleButton:IsShown() then
		CharCreateFemaleButton:Show()
	end

	local name, faction = GetFactionForRace(CharacterCreate.selectedRace);

	if faction == nil then
		faction = "Alliance";
	end
	CharacterCreate_AliasExtraRacials(faction)

	-- Set background

	--HandleFactionBackground()

	-- Set backdrop colors based on faction
	local backdropColor = FACTION_BACKDROP_COLOR_TABLE[faction];
	--CharCreateRaceFrame.factionBg:SetGradient("VERTICAL", 0, 0, 0, backdropColor[7], backdropColor[8], backdropColor[9]);
	--CharCreateClassFrame.factionBg:SetGradient("VERTICAL", 0, 0, 0, backdropColor[7], backdropColor[8], backdropColor[9]);
	--CharCreateCustomizationFrame.factionBg:SetGradient("VERTICAL", 0, 0, 0, backdropColor[7], backdropColor[8], backdropColor[9]);
	--harCreatePreviewFrame.factionBg:SetGradient("VERTICAL", 0, 0, 0, backdropColor[7], backdropColor[8], backdropColor[9]);
	CharCreateCustomizationFrameBanner:SetVertexColor(backdropColor[10], backdropColor[11], backdropColor[12]);
	CharacterCreateNameEdit:SetBackdropColor(backdropColor[4], backdropColor[5], backdropColor[6]);
	CharacterCreateSecondNameEdit:SetBackdropColor(backdropColor[4], backdropColor[5], backdropColor[6]);
	--CharCreateRaceInfoFrame.factionBg:SetGradient("VERTICAL", 0, 0, 0, backdropColor[7], backdropColor[8], backdropColor[9]);
	--CharCreateClassInfoFrame.factionBg:SetGradient("VERTICAL", 0, 0, 0, backdropColor[7], backdropColor[8], backdropColor[9]);

	-- race info
	local frame = CharCreateRaceInfoFrame;
	local race, fileString = GetNameForRace();
	frame.title:SetText(race);
	fileString = strupper(fileString);
	local gender;
	if ( GetSelectedSex() == SEX_MALE ) then
		gender = "MALE";
	else
		gender = "FEMALE";
	end
	local raceText = _G["RACE_INFO_"..fileString];
	local abilityIndex = 1;
	local tempText = _G["ABILITY_INFO_"..fileString..abilityIndex];
	abilityText = "";
	while ( tempText ) do
		abilityText = abilityText..tempText.."\n\n";
		abilityIndex = abilityIndex + 1;
		tempText = _G["ABILITY_INFO_"..fileString..abilityIndex];
	end
	CharCreateRaceInfoFrameScrollFrameScrollBar:SetValue(0);
	local text
	text = GetFlavorText("RACE_INFO_"..strupper(fileString), GetSelectedSex())
	if not text then
		text = "Not in GlueXML."
	end
	CharCreateRaceInfoFrame.scrollFrame.scrollChild.infoText:SetText(text.."|n|n");
	if ( abilityText and abilityText ~= "" ) then
		CharCreateRaceInfoFrame.scrollFrame.scrollChild.bulletText:SetText(abilityText);
	else
		CharCreateRaceInfoFrame.scrollFrame.scrollChild.bulletText:SetText("");
	end

	CharacterCreate_UpdateNavigtationRaceButton()
end

function SetCharacterClass(id)
	CharacterCreate.selectedClass = id;
	EventRegistry:TriggerEvent("CharacterCreate.ClassChanged", id)

	-- class info
	local frame = CharCreateClassInfoFrame;
	local className, classFileName, classIndex, tank, healer, damage = GetSelectedClass();
	local abilityIndex = 0;
	if not classFileName then
		classFileName = "WARRIOR"
	end
	if classFileName ~= "HERO" then
		C_CharacterCreate.PreviewClassOutfit(classFileName)
	else
		C_CharacterCreate.ClearClassPreview()
	end
	local tempText = _G["CLASS_INFO_"..classFileName..abilityIndex];
	abilityText = "";
	while ( tempText ) do
		abilityText = abilityText..tempText.."\n\n";
		abilityIndex = abilityIndex + 1;
		tempText = _G["CLASS_INFO_"..classFileName..abilityIndex];
	end
	CharCreateClassInfoFrame.title:SetText(className);
	CharCreateClassInfoFrame.scrollFrame.scrollChild.bulletText:SetText(abilityText);
	CharCreateClassInfoFrame.scrollFrame.scrollChild.infoText:SetText(GetFlavorText("CLASS_"..strupper(classFileName), GetSelectedSex()).."|n|n");
	CharCreateClassInfoFrameScrollFrameScrollBar:SetValue(0);

	if (classIndex ~= Enum.Class.HERO) then
		CharCreateArchetypeFrame:GoToIndex(Enum.CharCreateArchetypeBases.Freepick)
	end
end

function CharacterCreate_OnChar()
end

function CharacterCreate_OnKeyDown(key)
	if ( key == "ESCAPE" ) then
		CharacterCreate_Back();
	elseif ( key == "ENTER" ) then
		CharacterCreate_Forward();
	elseif ( key == "PRINTSCREEN" ) then
		Screenshot();
	end
end

function CharacterCreate_UpdateModel(self)
	UpdateCustomizationScene();
	self:AdvanceTime();
end

function CharacterCreate_Finish()
	PlaySound("gsCharacterCreationCreateChar");

	-- If something disabled this button, ignore this message.
	-- This can happen if you press enter while it's disabled, for example.
	if ( not CharCreateOkayButton:IsEnabled() ) then
		return;
	end

	if ( PAID_SERVICE_TYPE ) then
		GlueDialog_Show("CONFIRM_PAID_SERVICE");
	else
		-- if using templates, pandaren must pick a faction
		--local _, faction = GetFactionForRace(CharacterCreate.selectedRace);

		CoACharacterNames.CreateCharacter();

		TutorialExperienceEventListener:Show()
		
		local archetypeID = CharCreateArchetypeSelectFrame:GetCurrentIndex()

		if archetypeID then
			local buildID = C_CharacterCreate.GetArchetypeInfo(archetypeID)
			if buildID then
				NewCharacterSetupUtil.SetPendingKeyValue("archetypeBuildID", buildID)
			end
		end
	end
end

function CharacterCreate_Back()
	local prevStep = CharacterCreateNavigationFrame:GetPrevIndex()

	if CharacterCreate.classGuideActive and CharacterCreateFrame.state == Enum.CharCreateSteps.NameEdit and not prevStep then
		PlaySound("gsCharacterCreationCancel");
		CharacterCreateNavigationFrame:GoToIndex(Enum.CharCreateSteps.ClassRace)
		return;
	end

	if CharacterCreate.classGuideActive and CharacterCreateFrame.state == Enum.CharCreateSteps.ClassRace then
		PlaySound("gsCharacterCreationCancel");
		CharacterCreate_ClassGuideBack()
		return;
	end

	if (prevStep) then
		PlaySound("gsCharacterCreationCancel");
		CharacterCreateNavigationFrame:GoToIndex(prevStep)
		return;
	end

	PlaySound("gsCharacterCreationCancel");
	CHARACTER_SELECT_BACK_FROM_CREATE = true;
	NewCharacterSetupUtil.ClearPendingData()
	SetGlueScreen("charselect");
end

function CharacterCreate_UpdateFacialHairCustomization()
	if ( GetFacialHairCustomization() == "NONE" ) then
		CharacterCustomizationButtonFrame5:Hide();
		--CharCreateRandomizeButton:SetPoint("TOP", "CharacterCustomizationButtonFrame5", "BOTTOM", 0, -5);
	else
		CharacterCustomizationButtonFrame5Text:SetText(_G["FACIAL_HAIR_"..GetFacialHairCustomization()]);
		CharacterCustomizationButtonFrame5:Show();
		--CharCreateRandomizeButton:SetPoint("TOP", "CharacterCustomizationButtonFrame5", "BOTTOM", 0, -5);
	end
end

function CharacterCreate_UpdateHairCustomization()
	if not _G["HAIR_"..GetHairCustomization().."_STYLE"] or _G["HAIR_"..GetHairCustomization().."_STYLE"] == "" then
		CharCreateCustomizationButton3:Hide()
		CharCreateCustomizationButton4:SetPoint("TOP", CharCreateCustomizationButton2, "BOTTOM", 0, -20)
	else
		CharCreateCustomizationButton3:Show()
		CharCreateCustomizationButton3.text:SetText(_G["HAIR_"..GetHairCustomization().."_STYLE"])
		--CharCreateCustomizationButton4:SetPoint("TOP", CharCreateCustomizationButton3, "BOTTOM", 0, -20)
	end

	if not _G["HAIR_"..GetHairCustomization().."_COLOR"] or _G["HAIR_"..GetHairCustomization().."_COLOR"] == "" then
		CharCreateCustomizationButton4:Hide()
		if CharCreateCustomizationButton3:IsShown() then
			CharCreateCustomizationButton5:SetPoint("TOP", CharCreateCustomizationButton4, "BOTTOM", 0, 0)
		else
			CharCreateCustomizationButton5:SetPoint("TOP", CharCreateCustomizationButton3, "BOTTOM", 0, 0)
		end
	else
		CharCreateCustomizationButton4:Show()
		CharCreateCustomizationButton4.text:SetText(_G["HAIR_"..GetHairCustomization().."_COLOR"])
		CharCreateCustomizationButton5:SetPoint("TOP", CharCreateCustomizationButton4, "BOTTOM", 0, 0)
	end

	if not _G["FACIAL_HAIR_"..GetFacialHairCustomization()] or _G["FACIAL_HAIR_"..GetFacialHairCustomization()] == "" then
		CharCreateCustomizationButton5:Hide()
	else
		CharCreateCustomizationButton5:Show()
		CharCreateCustomizationButton5.text:SetText(_G["FACIAL_HAIR_"..GetFacialHairCustomization()])
	end

end

function CharacterCreate_Forward()
	local nextStep = CharacterCreateNavigationFrame:GetNextIndex()

	if CharCreateOkayButton:IsEnabled() == 0 then
		return
	end

	if CharacterCreate.classGuideActive and CharacterCreateFrame.state == Enum.CharCreateSteps.ClassRace then
		if not CharacterCreate.selectedClassGuideClassID then
			return
		end

		PlaySound("gsCharacterSelectionCreateNew");
		CharCreateOkayButton:Disable()
		CharacterCreate_LoadNavigation(CHAR_CREATE_STEPS_CLASS_GUIDE)
		CharacterCreateNavigationFrame:GoToIndex(Enum.CharCreateSteps.NameEdit)
		return
	end

	if (nextStep) then
		PlaySound("gsCharacterSelectionCreateNew");
		CharCreateOkayButton:Disable()
		CharacterCreateNavigationFrame:GoToIndex(nextStep)
		return;
	end

	CharacterCreate_Finish()
end

function CharCreateCustomizationFrame_OnShow ()
	-- reset size/tex coord to default to facilitate switching between genders for Pandaren
	CharCreateCustomizationFrameBanner:SetSize(BANNER_DEFAULT_SIZE[1], BANNER_DEFAULT_SIZE[2]);
	CharCreateCustomizationFrameBanner:SetTexCoord(BANNER_DEFAULT_TEXTURE_COORDS[1], BANNER_DEFAULT_TEXTURE_COORDS[2], BANNER_DEFAULT_TEXTURE_COORDS[3], BANNER_DEFAULT_TEXTURE_COORDS[4]);

	-- check each button and hide it if there are no values select
	local resize = 0;
	local lastGood = 0;
	local isSkinVariantHair = false --GetSkinVariationIsHairColor(CharacterCreate.selectedRace);
	local isDefaultSet = 0;
	local checkedButton = 1;

	-- check if this was set, if not, default to 1
	if ( CharacterCreateFrame.customizationType == 0 or CharacterCreateFrame.customizationType == nil ) then
		CharacterCreateFrame.customizationType = 1;
	end
	for i=1, NUM_CHAR_CUSTOMIZATIONS, 1 do
		if ( ( --[[GetNumFeatureVariationsForType(i)]]5 <= 1 ) or ( isSkinVariantHair and i == CHAR_CUSTOMIZE_HAIR_COLOR ) ) then
			resize = resize + 1;
			_G["CharCreateCustomizationButton"..i]:Hide();
		else
			_G["CharCreateCustomizationButton"..i]:Show();
			--_G["CharCreateCustomizationButton"..i]:SetChecked(0); -- we will handle default selection
			-- this must be done since a selected button can 'disappear' when swapping genders
			if ( isDefaultSet == 0 and CharacterCreateFrame.customizationType == i) then
				isDefaultSet = 1;
				checkedButton = i;
			end
			-- set your anchor to be the last good, this currently means button 1 HAS to be shown
			if (i > 1) then
				_G["CharCreateCustomizationButton"..i]:SetPoint( "TOP",_G["CharCreateCustomizationButton"..lastGood]:GetName() , "BOTTOM");
			end
			lastGood = i;
		end
	end

	if (isDefaultSet == 0) then
		CharacterCreateFrame.customizationType = lastGood;
		checkedButton = lastGood;
	end
	--_G["CharCreateCustomizationButton"..checkedButton]:SetChecked(1);

	if (resize > 0) then
	-- we need to resize and remap the banner texture
		local buttonx, buttony = CharCreateCustomizationButton1:GetSize()
		local screenamount = resize*buttony;
		print(screenamount);
		local frameX, frameY = CharCreateCustomizationFrameBanner:GetSize();
		local pctShrink = .2*resize;
		local uvXDefaultSize = BANNER_DEFAULT_TEXTURE_COORDS[2] - BANNER_DEFAULT_TEXTURE_COORDS[1];
		local uvYDefaultSize = BANNER_DEFAULT_TEXTURE_COORDS[4] - BANNER_DEFAULT_TEXTURE_COORDS[3];
		local newYUV = pctShrink*uvYDefaultSize + BANNER_DEFAULT_TEXTURE_COORDS[3];
		-- end coord stay the same
		CharCreateCustomizationFrameBanner:SetTexCoord(BANNER_DEFAULT_TEXTURE_COORDS[1], BANNER_DEFAULT_TEXTURE_COORDS[2], newYUV, BANNER_DEFAULT_TEXTURE_COORDS[4]);
		print(pctShrink);
		CharCreateCustomizationFrameBanner:SetSize(frameX, frameY - screenamount);
		print(CharCreateCustomizationFrameBanner:GetTexCoord());
	end

	--CharCreateRandomizeButton:SetPoint("TOP", _G["CharCreateCustomizationButton"..lastGood]:GetName(), "BOTTOM", 0, 0);
end

function CharacterClass_OnClick(self, id)
	if( self:IsEnabled() ) then
		PlaySound("gsCharacterCreationClass");
		local _,_,currClass = GetSelectedClass();
		if ( currClass ~= id ) then
			SetSelectedClass(id);
			SetCharacterClass(id);
			SetCharacterRace(GetSelectedRace());
			CharacterChangeFixup();
		else
			self:SetChecked(1);
		end
	else
		self:SetChecked(0);
	end
end

function CharacterRace_OnClick(self, id, forceSelect)
	if( self:IsEnabled() == 1 ) then
		PlaySound("gsCharacterCreationClass");
		if ( GetSelectedRace() ~= id or forceSelect ) then
			local isClassGuideClassSelection = C_CharacterCreate.CanCreateCoA()
				and CharacterCreate.classGuideActive
				and CharacterCreate.selectedClassGuideSubroleID
				and (CharacterCreateFrame.state == Enum.CharCreateSteps.ClassRace
					or CharacterCreateFrame.state == Enum.CharCreateSteps.Archetype)
			local selectedGuideClassID = CharacterCreate.selectedClassGuideClassID

			SetSelectedRace(id);
			SetCharacterRace(id);
			if isClassGuideClassSelection then
				CharacterCreateEnumerateRaces(GetAvailableRaces());
				SetCharacterRace(GetSelectedRace());
				SetCharacterCreateFacing(-15);

				if selectedGuideClassID and CharacterCreate_ClassGuideClassIsAvailableForRace(selectedGuideClassID, CharacterCreate.selectedRace) then
					CharacterCreate.selectedClassGuideClassID = selectedGuideClassID
					SetSelectedClass(selectedGuideClassID)
					SetCharacterClass(selectedGuideClassID)
					CharCreate_EnableNextButton(true)
				else
					local fallbackClassID = CharacterCreate_GetFirstAvailableClassGuideClassForRace(CharacterCreate.selectedRace)
					CharacterCreate.selectedClassGuideClassID = fallbackClassID
					if fallbackClassID then
						SetSelectedClass(fallbackClassID)
						SetCharacterClass(fallbackClassID)
						CharCreate_EnableNextButton(true)
					else
						local _,_,classIndex = GetSelectedClass();
						SetCharacterClass(classIndex)
						CharCreateOkayButton:Disable()
					end
				end

				CharacterCreate_RefreshClassButtons(CharacterCreate)
				CharacterCreate_UpdateHairCustomization();
				CharacterChangeFixup();
				return
			end

			SetCharacterGender(GetSelectedSex());
			SetCharacterCreateFacing(-15);
			CharacterCreate_RefreshClassButtons(CharacterCreate)
			local _,_,classIndex = GetSelectedClass();
			if ( PAID_SERVICE_TYPE ) then
				classIndex = PaidChange_GetCurrentClassIndex();
				SetSelectedClass(classIndex);	-- selecting a race would have changed class to default
			end
			SetCharacterClass(classIndex);

			-- Hair customization stuff
			CharacterCreate_UpdateHairCustomization();

			CharacterChangeFixup();
		else
			self:SetChecked(1);
		end
	else
		self:SetChecked(0);
	end
end

function SetCharacterGender(sex)
	local gender;

	if ( sex == SEX_MALE ) then
		CharCreateMaleButton:SetChecked(1);
		CharCreateFemaleButton:SetChecked(0);
	else
		CharCreateMaleButton:SetChecked(0);
		CharCreateFemaleButton:SetChecked(1);
	end
	SetSelectedSex(sex);

	-- Update race images to reflect gender
	CharacterCreateEnumerateRaces(GetAvailableRaces());
	CharacterCreate_RefreshClassButtons(CharacterCreate)
 	SetCharacterRace(GetSelectedRace());

	local _,_,classIndex = GetSelectedClass();
	if ( PAID_SERVICE_TYPE ) then
		classIndex = PaidChange_GetCurrentClassIndex();
		-- PandarenFactionButtons_SetTextures();
	end
	SetCharacterClass(classIndex);

	CharacterCreate_UpdateHairCustomization();
	CharacterChangeFixup();

	-- Update preview models if on customization step
	if ( CharCreatePreviewFrame:IsShown() ) then
		CharCreateCustomizationFrame_OnShow(); -- buttons may need to reset for dirty Pandarens
		CharCreate_PrepPreviewModels();
		CharCreate_ResetFeaturesDisplay();
	end
end

local function CharacterCustomization_Cycle(id, direction)
	C_CharacterCreate.CycleCustomizationSkipLocked(id, direction)
end

function CharacterCustomization_Left(id)
	PlaySound("gsCharacterCreationLook");
	CharacterCustomization_Cycle(id, -1);
	CharacterCreate_UndressCustomizationHeadSlot()
	if (id > 1) then
		SetFaceCustomizeCamera(true)
	else
		SetFaceCustomizeCamera(false)
	end
end

function CharacterCustomization_Right(id)
	PlaySound("gsCharacterCreationLook");
	CharacterCustomization_Cycle(id, 1);
	CharacterCreate_UndressCustomizationHeadSlot()
	if (id > 1) then
		SetFaceCustomizeCamera(true)
	else
		SetFaceCustomizeCamera(false)
	end
end

function CharacterCreate_GenerateRandomName(button)
	CharacterCreateNameEdit:SetText(GetRandomName());
end

function CharacterCreate_Randomize()
	PlaySound("gsCharacterCreationLook");
	RandomizeCharCustomization();
	CharCreate_ResetFeaturesDisplay();
	CharacterCreate_UpdateCustomizationEquipment();
end

function CharacterCreateRotateRight_OnUpdate(self)
	if ( self:GetButtonState() == "PUSHED" ) then
		SetCharacterCreateFacing(GetCharacterCreateFacing() + CHARACTER_FACING_INCREMENT);
		CharCreate_RotatePreviews();
	end
end

function CharacterCreateRotateLeft_OnUpdate(self)
	if ( self:GetButtonState() == "PUSHED" ) then
		SetCharacterCreateFacing(GetCharacterCreateFacing() - CHARACTER_FACING_INCREMENT);
		CharCreate_RotatePreviews();
	end
end

function SetButtonDesaturated(button, desaturated)
	if ( not button ) then
		return;
	end
	local icon = button:GetNormalTexture();
	if ( not icon ) then
		return;
	end

	icon:SetDesaturated(desaturated);
end

function GetFlavorText(tagname, sex)
	local primary, secondary;
	if ( sex == SEX_MALE ) then
		primary = "";
		secondary = "_FEMALE";
	else
		primary = "_FEMALE";
		secondary = "";
	end
	local text = _G[tagname..primary];
	if ( (text == nil) or (text == "") ) then
		text = _G[tagname..secondary];
	end
	return text;
end

function CharacterChangeFixup()
	if ( PAID_SERVICE_TYPE ) then
		-- no class changing as a paid service
		EventRegistry:TriggerEvent("CharacterCreate.PaidServiceActive")
		for i=1, MAX_RACES, 1 do
			local allow = false;
			if ( PAID_SERVICE_TYPE == PAID_FACTION_CHANGE ) then
				local faction = GetFactionForRace(PaidChange_GetCurrentRaceIndex());
				if ( (i == PaidChange_GetCurrentRaceIndex()) or ((GetFactionForRace(i) ~= faction) and (IsRaceClassValid(i,CharacterCreate.selectedClass))) ) then
					allow = true;
				end
			elseif ( PAID_SERVICE_TYPE == PAID_RACE_CHANGE ) then
				local faction = GetFactionForRace(PaidChange_GetCurrentRaceIndex());
				if ( (i == PaidChange_GetCurrentRaceIndex()) or ((GetFactionForRace(i) == faction) and (IsRaceClassValid(i,CharacterCreate.selectedClass))) ) then
					allow = true
				end
			elseif ( PAID_SERVICE_TYPE == PAID_CHARACTER_CUSTOMIZATION ) then
				if ( i == CharacterCreate.selectedRace ) then
					allow = true
				end
			end

			if (not allow) then
				local button = _G["CharCreateRaceButton"..i];
				button:Disable();
				SetButtonDesaturated(button, true)
			end
		end
	end

	RefreshSelectedClass()
end

function CharCreateSelectCustomizationType(newType)
	-- deselect previous type selection
	if ( CharacterCreateFrame.customizationType and CharacterCreateFrame.customizationType ~= newType ) then
		--_G["CharCreateCustomizationButton"..CharacterCreateFrame.customizationType]:SetChecked(0);
	end
	--_G["CharCreateCustomizationButton"..newType]:SetChecked(1);
	CharacterCreateFrame.customizationType = newType;
	CharCreate_ResetFeaturesDisplay();

	--[[if (newType > 1) then
		SetFaceCustomizeCamera(true);
	else
		SetFaceCustomizeCamera(false);
	end]]
end

function CharCreate_ResetFeaturesDisplay()
	--SetPreviewFramesFeature(CharacterCreateFrame.customizationType);
	-- set the previews scrollframe container height
	-- since the first and the last previews need to be in the center position when scrolled all the way
	-- to the top or to the bottom, there will be gaps of height equal to 2 previews on each side
	local numTotalButtons = 4--GetNumFeatureVariations() + 4;
	CharCreatePreviewFrame.scrollFrame.container:SetHeight(numTotalButtons * PREVIEW_FRAME_HEIGHT - PREVIEW_FRAME_Y_OFFSET);

	for _, previewFrame in pairs(CharCreatePreviewFrame.previews) do
		previewFrame.featureType = 0;
	end

	CharCreate_DisplayPreviewModels();
end

function CharCreate_PrepPreviewModels(reloadModels)
	local displayFrame = CharCreatePreviewFrame;

	-- clear models if rebuildPreviews got flagged
	local rebuildPreviews = displayFrame.rebuildPreviews;
	displayFrame.rebuildPreviews = nil;

	-- need to reload models class was swapped to or from DK
	local classSwap = false;
	local _, class = GetSelectedClass();
	--[[if ( class == "DEATHKNIGHT" or displayFrame.lastClass == "DEATHKNIGHT" ) and ( class ~= displayFrame.lastClass ) then
		classSwap = true;
	end]]

	-- always clear the featureType
	for index, previewFrame in pairs(displayFrame.previews) do
		previewFrame.featureType = 0;
		-- force model reload if class changed
		if ( classSwap ) then
			previewFrame.race = nil;
			previewFrame.gender = nil;
		end
		if ( rebuildPreviews ) then
			--SetPreviewFrame(previewFrame.model:GetName(), index);
		end
	end
end

function CharCreate_DisplayPreviewModels(selectionIndex)
	if ( not selectionIndex ) then
		selectionIndex = featureIndex--GetSelectedFeatureVariation();
	end

	local displayFrame = CharCreatePreviewFrame;
	local previews = displayFrame.previews;
	local numVariations = 8--GetNumFeatureVariations();
	local currentFeatureType = CharacterCreateFrame.customizationType;

	local race = GetSelectedRace();
	local gender = GetSelectedSex();

	-- selection index is the center preview
	-- there are 2 previews above and 2 below, and will pad it out to 1 more on each side, for a total of 7 previews to set up
	for index = selectionIndex - 3, selectionIndex + 3 do
		-- there is empty space both at the beginning and at end of the list, each gap the height of 2 previews
		if ( index > 0 and index <= numVariations ) then
			local previewFrame = previews[index];
			-- create button if we don't have it yet
			if ( not previewFrame ) then
				previewFrame = CreateFrame("BUTTON", "PreviewFrame"..index, displayFrame.scrollFrame.container, "CharCreatePreviewFrameTemplate");
				-- index + 1 because of 2 gaps at the top and -1 for the current preview
				previewFrame:SetPoint("TOPLEFT", PREVIEW_FRAME_X_OFFSET, (index + 1) * -PREVIEW_FRAME_HEIGHT + PREVIEW_FRAME_Y_OFFSET);
				previewFrame.button.index = index;
				previews[index] = previewFrame;
				--SetPreviewFrame(previewFrame.model:GetName(), index);
				-- no texture as of yet
				--previewFrame:SetNormalTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			end
			-- load model if needed, may have been cleared by different race/gender selection
			if ( previewFrame.race ~= race or previewFrame.gender ~= gender ) then
				--SetPreviewFrameModel(index);
				previewFrame.race = race;
				previewFrame.gender = gender;
				-- apply settings
				local model = previewFrame.model;
				--model:SetCustomCamera(cameraID);
				local scale = 1--model:GetWorldScale();
				--model:SetCameraTarget(config.tx * scale, config.ty * scale, config.tz * scale);
				--model:SetCameraDistance(config.distance * scale);
				local cx, cy, cz = model:GetPosition();
				-- model:SetPosition(cx-15, cy, cz)
				--model:SetCameraPosition(cx, cy, config.cz * scale);
				previewFrame.model:SetLight(1, 0, 0, 0, 0, 1, 1.0, 1.0, 1.0);
			end
			-- need to reset the model if it was last used to preview a different feature
			if ( previewFrame.featureType ~= currentFeatureType ) then
				--ResetPreviewFrameModel(index);
				--ShowPreviewFrameVariation(index);
				previewFrame.featureType = currentFeatureType;
			end
			previewFrame:Show();
		else
			-- need to hide tail previews when going to features with fewer styles
			if ( previews[index] ) then
				previews[index]:Hide();
			end
		end
	end
	displayFrame.border.number:SetText("Option "..selectionIndex.."                     ");
	displayFrame.selectionIndex = selectionIndex;
	CharCreate_RotatePreviews();
	CharCreatePreviewFrame_UpdateStyleButtons();
	-- scroll to center the selection
	if ( not displayFrame.animating ) then
		displayFrame.scrollFrame:SetVerticalScroll((selectionIndex - 1) * PREVIEW_FRAME_HEIGHT);
	end
end


function CharCreate_RotatePreviews()
	if ( CharCreatePreviewFrame:IsShown() ) then
		local facing = ((GetCharacterCreateFacing())/ -180) * math.pi;
		local previews = CharCreatePreviewFrame.previews;
		--CharCreatePreviewFrame.selectionIndex = 0;
		for index = CharCreatePreviewFrame.selectionIndex - 3, CharCreatePreviewFrame.selectionIndex + 3 do
			local previewFrame = previews[index];
			if ( previewFrame ) then -- and previewFrame.model:HasCustomCamera()
				--previewFrame.model:SetCameraFacing(facing);
			end
		end
	end
end

function CharCreate_ChangeFeatureVariation(delta)
	local numVariations = 8--GetNumFeatureVariations();
	local startIndex = featureIndex--GetSelectedFeatureVariation();
	local endIndex = startIndex + delta;
	if ( endIndex < 1 or endIndex > numVariations ) then
		return;
	end
	PlaySound("gsCharacterCreationClass");
	featureIndex = endIndex
	CharCreatePreviewFrame_SelectFeatureVariation(endIndex);
end

function CharCreatePreviewFrameButton_OnClick(self)
	PlaySound("gsCharacterCreationClass");
	CharCreatePreviewFrame_SelectFeatureVariation(self.index);
end

function CharCreatePreviewFrame_SelectFeatureVariation(endIndex)
	local self = CharCreatePreviewFrame;
	if ( self.animating ) then
		if ( not self.queuedIndex ) then
			self.queuedIndex = endIndex;
		end
	else
		local startIndex = featureIndex--GetSelectedFeatureVariation();
		--SelectFeatureVariation(endIndex);
		for i=1,endIndex do
			CycleCharCustomization(FeatureType, 1);
		end
		CharacterCreate_UndressCustomizationHeadSlot()
		CharCreatePreviewFrame_UpdateStyleButtons();
		featureIndex = endIndex
		CharCreatePreviewFrame_StartAnimating(startIndex, endIndex);
	end
end

function CharCreatePreviewFrame_StartAnimating(startIndex, endIndex)
	local self = CharCreatePreviewFrame;
	if ( self.animating ) then
		return;
	else
		self.startIndex = startIndex;
		self.currentIndex = startIndex;
		self.endIndex = endIndex;
		self.queuedIndex = nil;
		self.direction = 1;
		if ( self.startIndex > self.endIndex ) then
			self.direction = -1;
		end
		self.movedTotal = 0;
		self.moveUntilUpdate = PREVIEW_FRAME_HEIGHT;
		self.animating = true;
	end
end

function CharCreatePreviewFrame_StopAnimating()
	local self = CharCreatePreviewFrame;
	if ( self.animating ) then
		self.animating = false;
	end
end

local ANIMATION_SPEED = 5;
function CharCreatePreviewFrame_OnUpdate(self, elapsed)
	if ( self.animating ) then
		local moveIncrement = PREVIEW_FRAME_HEIGHT * elapsed * ANIMATION_SPEED;
		self.movedTotal = self.movedTotal + moveIncrement;
		self.scrollFrame:SetVerticalScroll((self.startIndex - 1) * PREVIEW_FRAME_HEIGHT + self.movedTotal * self.direction);
		self.moveUntilUpdate = self.moveUntilUpdate - moveIncrement;
		if ( self.moveUntilUpdate <= 0 ) then
			self.currentIndex = self.currentIndex + self.direction;
			self.moveUntilUpdate = PREVIEW_FRAME_HEIGHT;
			-- reset movedTotal to account for rounding errors
			self.movedTotal = abs(self.startIndex - self.currentIndex) * PREVIEW_FRAME_HEIGHT;
			CharCreate_DisplayPreviewModels(self.currentIndex);
		end
		if ( self.currentIndex == self.endIndex ) then
			self.animating = false;
			CharCreate_DisplayPreviewModels();
			if ( self.queuedIndex ) then
				local newIndex = self.queuedIndex;
				self.queuedIndex = nil;
				--SelectFeatureVariation(newIndex);
				featureIndex = newIndex
				CycleCharCustomization(FeatureType, featureIndex);
				CharacterCreate_UndressCustomizationHeadSlot()
				CharCreatePreviewFrame_UpdateStyleButtons();
				CharCreatePreviewFrame_StartAnimating(self.endIndex, newIndex);
			end
		end
	end
end

function CharCreatePreviewFrame_UpdateStyleButtons()
	local selectionIndex = math.random(1,5)--GetSelectedFeatureVariation();
	local numVariations = 8--GetNumFeatureVariations();
	if ( selectionIndex == 1 ) then
		CharCreateStyleUpButton:Enable();
		CharCreateStyleUpButton.arrow:SetDesaturated(true);
	else
		CharCreateStyleUpButton:Enable();
		CharCreateStyleUpButton.arrow:SetDesaturated(false);
	end
	if ( selectionIndex == numVariations ) then
		CharCreateStyleDownButton:Disable();
		CharCreateStyleDownButton.arrow:SetDesaturated(true);
	else
		CharCreateStyleDownButton:Disable(true);
		CharCreateStyleDownButton.arrow:SetDesaturated(false);
	end
end

local TotalTime = 0;
local KeepScrolling = nil;
local TIME_TO_SCROLL = 0.5;
function CharacterCreateWhileMouseDown_OnMouseDown(direction)
	TIME_TO_SCROLL = 0.5;
	TotalTime = 0;
	KeepScrolling = direction;
end
function CharacterCreateWhileMouseDown_OnMouseUp()
	KeepScrolling = nil;
end
function CharacterCreateWhileMouseDown_Update(elapsed)
	if ( KeepScrolling ) then
		TotalTime = TotalTime + elapsed;
		if ( TotalTime >= TIME_TO_SCROLL ) then
			CharCreate_ChangeFeatureVariation(KeepScrolling);
			TIME_TO_SCROLL = 0.25;
			TotalTime = 0;
		end
	end
end

function CharCreate_EnableNextButton(enabled)
	local button = CharCreateOkayButton;
	if enabled then
		button:Enable();
	else
		button:Disable();
	end
	button.arrow:SetDesaturated(not enabled);

	--[[if enabled then
		button.TopGlow:Hide();
		button.BottomGlow:Hide();
	else
		button.TopGlow:Show();
		button.BottomGlow:Show();
	end]]--
end

CharCreateButtonMixin = {}

function CharCreateButtonMixin:OnEnter()
	GlueTooltip_GenericTooltip(self)
end

function CharCreateButtonMixin:OnLeave()
	GlueTooltip:Hide()
end

CharCreateRaceButtonMixin = CreateFromMixins(CharCreateButtonMixin)

function CharCreateRaceButtonMixin:OnLoad()
	self:GetNormalTexture():SetDrawLayer("BACKGROUND")
	self:GetPushedTexture():SetDrawLayer("BACKGROUND")

	local faction
	if self:GetID() > 0 then
		local ok, _, f = pcall(GetFactionForRace, self:GetID())
		faction = ok and f or nil
	end

	if faction == nil then
		faction = "Alliance"
	end
	
	self:SetFaction(faction)
end

function CharCreateRaceButtonMixin:OnClick()
	local _, factionSelected = GetFactionForRace(CharacterCreate.selectedRace)

	local _, faction = GetFactionForRace(self:GetID())

	if (factionSelected ~= faction) then
		if not C_CharacterCreate.CanCreateCoA() then
			faction = faction.."REGULAR"
		end
		GlueFrameFadeIn(CharacterCreateFrameFade, 0.3, function()
			SetBackgroundModel(CharacterCreate, string.upper(faction));
			CharacterRace_OnClick(self, self:GetID());
			GlueFrameFadeOut(CharacterCreateFrameFade, 0.5)
		end);
	else
		CharacterRace_OnClick(self, self:GetID());
	end
end

function CharCreateRaceButtonMixin:OnEnable()
	self.Text:SetFontObject("GameFontNormal")
end

function CharCreateRaceButtonMixin:OnDisable()
	self.Text:SetFontObject("GameFontDisable")
end

function CharCreateRaceButtonMixin:OnEnter()
	GlueTooltip_GenericTooltip(self, "ANCHOR_NONE")
	if self.faction == "Alliance" then
		GlueTooltip:SetPoint("LEFT", self, "RIGHT", 0, 0)
	else
		GlueTooltip:SetPoint("RIGHT", self, "LEFT", 0, 0)
	end
end

function CharCreateRaceButtonMixin:SetFaction(faction)
	self.faction = faction
	local backdropColor = FACTION_SHADOW_COLORS[faction]
	self.Shadow:SetVertexColor(backdropColor:GetRGB())

	if (faction == "Alliance") then
		self.Shadow:SetTexCoord(0, 1, 0, 1)
		self.Shadow:ClearAndSetPoint("LEFT", self, "RIGHT", -8, -8)
		self.Text:ClearAndSetPoint("LEFT", self, "RIGHT", 16, 0)
	else
		self.Shadow:SetTexCoord(1, 0, 0, 1)
		self.Shadow:ClearAndSetPoint("RIGHT", self, "LEFT", 8, -8)
		self.Text:ClearAndSetPoint("RIGHT", self, "LEFT", -16, 0)
	end
end

function CharCreateRaceButtonMixin:SetRace(raceName, raceEnglishName, gender, enabled)
	local coords = RACE_ICON_TCOORDS[raceEnglishName.."_"..gender] or RACE_ICON_TCOORDS["HUMAN_"..gender] or {0, 1, 0, 1}

	local iconFile = CHAR_CREATE_EXTRA_RACE_ICONS[raceName]
	if iconFile then
		if SetPortraitToTexture then
			-- crop the square icon to a circle like the built-in race icons
			SetPortraitToTexture(self:GetNormalTexture(), iconFile)
			SetPortraitToTexture(self:GetPushedTexture(), iconFile)
			coords = {0, 1, 0, 1}
		else
			self:SetNormalTexture(iconFile)
			self:SetPushedTexture(iconFile)
			self:GetNormalTexture():SetSize(40, 40)
			self:GetPushedTexture():SetSize(40, 40)
			coords = {0.1, 0.9, 0.1, 0.9}
		end
	else
		self:SetNormalTexture("Interface\\Glues\\CharacterCreate\\UI-CHARACTERCREATE-RACES_Round")
		self:SetPushedTexture("Interface\\Glues\\CharacterCreate\\UI-CHARACTERCREATE-RACES_Round")
	end
	self:GetNormalTexture():SetTexCoord(unpack(coords))
	self:GetPushedTexture():SetTexCoord(unpack(coords))

	self:SetText(raceName)
	self.tooltipText = {}

	self:SetEnabled(enabled)
	SetButtonDesaturated(self, not enabled)

	self.tooltipTitle = raceName
	if not enabled then
		local disabledReason = _G[raceEnglishName.."_".."DISABLED"]
		if disabledReason then
			tinsert(self.tooltipText, disabledReason)
		else
			self.tooltipTitle = nil
			self.tooltipText = nil
		end
	end

	local abilityIndex = 1
	local text = GetRealmSpecificGlobalString("ABILITY_INFO_"..raceEnglishName..abilityIndex)
	local spell = CHAR_CREATE_PASSIVES[raceEnglishName] and CHAR_CREATE_PASSIVES[raceEnglishName][abilityIndex]

	if text and spell then
		local _, _, spellIconPath = GetSpellData(spell, false, true)
		text = "|T"..spellIconPath..":24:24:0:0|t"..text.."\n"
	end

	while text do
		tinsert(self.tooltipText, text)
		abilityIndex = abilityIndex + 1
        
		text = GetRealmSpecificGlobalString("ABILITY_INFO_"..raceEnglishName..abilityIndex)
		spell = CHAR_CREATE_PASSIVES[raceEnglishName] and CHAR_CREATE_PASSIVES[raceEnglishName][abilityIndex]

		if text and spell then
			local _, _, spellIconPath = GetSpellData(spell, false, true)
			text = "|T"..spellIconPath..":24:24:0:0|t"..text.."\n"
		end
	end

	tinsert(self.tooltipText, 1, (GetFlavorText("RACE_INFO_"..raceEnglishName, gender) or raceName).."\n\n")
end

function CharCreateRaceButtonMixin:SetText(text)
	self.Text:SetText(text)
end

CharCreateClassButtonMixin = CreateFromMixins(CharCreateButtonMixin)

function CharCreateClassButtonMixin:OnLoad()
	self:GetNormalTexture():SetDrawLayer("BACKGROUND")
	self:GetPushedTexture():SetDrawLayer("BACKGROUND")
	EventRegistry:RegisterCallback("CharacterCreate.PaidServiceActive", self.RefreshEnabled, self)
	EventRegistry:RegisterCallback("CharacterCreate.ClassChanged", function(self, classID)
		self:SetSelected(classID == self:GetID())
	end, self)

end

function CharCreateClassButtonMixin:RefreshEnabled()
	self:SetEnabled(not PAID_SERVICE_TYPE)
end

function CharCreateClassButtonMixin:OnEnable()
	self.Text:SetFontObject("GameFontNormal")
	self.Border:SetVertexColor(1, 1, 1, 1)
	self:GetNormalTexture():SetVertexColor(1, 1, 1, 1)
end

function CharCreateClassButtonMixin:OnDisable()
	self.Text:SetFontObject("GameFontDisable")
	self.Border:SetVertexColor(0.5, 0.5, 0.5, 1)
	self:GetNormalTexture():SetVertexColor(0.5, 0.5, 0.5, 1)
end

function CharCreateClassButtonMixin:SetClassGuideCombatHealer(isCombatHealer)
	self.classGuideCombatHealer = isCombatHealer and true or false

	if not self.ClassGuideCombatHealerBadge then
		local badge = CreateFrame("Button", nil, self)
		badge:SetSize(38, 38)
		badge:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 11, -11)
		badge:SetFrameLevel(self:GetFrameLevel() + 3)
		badge:SetScript("OnClick", function(badgeSelf)
			badgeSelf:GetParent():Click()
		end)
		badge:SetScript("OnEnter", function(badgeSelf)
			GlueTooltip:SetOwner(badgeSelf, "ANCHOR_TOP")
			GlueTooltip:AddLine(CLASS_GUIDE_COMBAT_HEALER_TOOLTIP_TITLE, 1, 1, 1, 1, true)
			GlueTooltip:AddLine(CLASS_GUIDE_COMBAT_HEALER_TOOLTIP_TEXT, 1, 0.82, 0, 1, true)
			GlueTooltip:Show()
		end)
		badge:SetScript("OnLeave", function()
			GlueTooltip:Hide()
		end)

		local icon = badge:CreateTexture(nil, "OVERLAY")
		icon:SetAllPoints()
		icon:SetAtlas(CharacterCreate_GetClassGuideAtlas(CLASS_GUIDE_COMBAT_HEALER_ATLAS))
		badge.Icon = icon
		self.ClassGuideCombatHealerBadge = badge
	end

	self.ClassGuideCombatHealerBadge:SetShown(self.classGuideCombatHealer)
end

function CharCreateClassButtonMixin:OnClick()
	CharacterClass_OnClick(self, self:GetID())

	if CharacterCreate.classGuideActive then
		CharacterCreate.selectedClassGuideClassID = self:GetID()
		CharCreate_EnableNextButton(true)
		CharacterCreate_UpdateClassGuideClassButtonSelection(CharacterCreate)
	end
end

local function WrapResourceTooltipText(resource, text)
	local color = POWER_COLORS and POWER_COLORS[resource]
	if color then
		return color:WrapText(text)
	end

	return text
end

function CharCreateClassButtonMixin:OnEnter()
	GlueTooltip:SetOwner(self, "ANCHOR_TOP")
	GlueTooltip:SetText(self.tooltipTitle)
	GlueTooltip:SetMinWidth(340)

	-- Role
	do
		local roles = ClassInfoUtil.GetClassRoles(self.class)

		if roles.MeleeDPS then
			GlueTooltip:AddLine(ROLE_TEXT_WITH_ICON.MELEE_DAMAGER)
		end

		if roles.RangedDPS then
			GlueTooltip:AddLine(ROLE_TEXT_WITH_ICON.RANGED_DAMAGER)
		end

		if roles.CasterDPS then
			GlueTooltip:AddLine(ROLE_TEXT_WITH_ICON.CASTER_DAMAGER)
		end

		if roles.Tank then
			GlueTooltip:AddLine(ROLE_TEXT_WITH_ICON.TANK)
		end

		if roles.Healer then
			GlueTooltip:AddLine(ROLE_TEXT_WITH_ICON.HEALER)
		end

		if roles.Support then
			GlueTooltip:AddLine(ROLE_TEXT_WITH_ICON.SUPPORT)
		end

		GlueTooltip:AddLine(" ")
	end

	if self.classGuideCombatHealer then
		GlueTooltip:AddLine(CLASS_GUIDE_COMBAT_HEALER_TOOLTIP_TITLE, 1, 0.82, 0, 1, true)
		GlueTooltip:AddLine(CLASS_GUIDE_COMBAT_HEALER_TOOLTIP_TEXT, 1, 1, 1, 1, true)
		GlueTooltip:AddLine(" ")
	end

	-- Primary
	local hasResource = false
	do
		local resources = ClassInfoUtil.GetClassPrimaryResources(self.class)
		local string
		for _, resource in ipairs(resources) do
			local text = _G[resource]
			if text then
				if string then
					string = string.." / "
				else
					string = ""
				end
				text = WrapResourceTooltipText(resource, text)
				string = string..text
			end
		end

		if string then
			hasResource = true
			GlueTooltip:AddLine(PRIMARY_RESOURCE:format(string), 1, 0.82, 0, 1, true)
		end
	end

	-- Secondary
	do
		local resources = ClassInfoUtil.GetClassSecondaryResources(self.class)
		local string
		for _, resource in ipairs(resources) do
			local text = _G[resource]
			if text then
				if string then
					string = string.." / "
				else
					string = ""
				end
				text = WrapResourceTooltipText(resource, text)
				string = string..text
			end
		end

		if string then
			hasResource = true
			GlueTooltip:AddLine(SECONDARY_RESOURCE:format(string), 1, 0.82, 0, 1, true)
		end
	end

	-- Special Perks
	do
		local combined
		local i = 1
		while true do
			local perk = _G["CLASS_SPECIAL_PERKS_"..self.class..i]
			if not perk then
				break
			end
			if combined then
				combined = combined..", "..perk
			else
				combined = perk
			end
			i = i + 1
		end

		if combined then
			hasResource = true
			GlueTooltip:AddLine(CLASS_SPECIAL_PERKS:format(combined), 1, 1, 1, 1, true)
		end
	end

	if hasResource then
		GlueTooltip:AddLine(" ")
	end

	-- Armor Proficiency
	do
		local armorTypes = ClassInfoUtil.GetClassArmorProficiency(self.class)

		if armorTypes.Plate then
			GlueTooltip:AddLine(ARMOR_TYPE_WITH_ICON.PLATE, 1, 1, 1, 1, true)
		end

		if armorTypes.Mail then
			GlueTooltip:AddLine(ARMOR_TYPE_WITH_ICON.MAIL, 1, 1, 1, 1, true)
		end

		if armorTypes.Leather then
			GlueTooltip:AddLine(ARMOR_TYPE_WITH_ICON.LEATHER, 1, 1, 1, 1, true)
		end

		if armorTypes.Cloth then
			GlueTooltip:AddLine(ARMOR_TYPE_WITH_ICON.CLOTH, 1, 1, 1, 1, true)
		end

		GlueTooltip:AddLine(" ")
	end

	-- Combat Style
	do
		local text = _G["CLASS_COMBAT_STYLE_"..self.class.."0"]
		if text then
			GlueTooltip:AddLine(COMBAT_STYLE, 1, 0.82, 0)

			local i = 0
			while text do
				GlueTooltip:AddLine("- " .. text, 1, 1, 1, 1, true)
				i = i + 1
				text = _G["CLASS_COMBAT_STYLE_"..self.class..i]
			end
		end
	end

	GlueTooltip:AddLine(" ")
	GlueTooltip:AddLine(GetFlavorText("CLASS_"..self.class, "MALE"), 1, 0.82, 0, 1, true)
	GlueTooltip:Show()
	
	self:HighlightValidRaces()
end

function CharCreateClassButtonMixin:OnLeave()
	CharCreateButtonMixin.OnLeave(self)
	self:StopHighlightingRaces()
end

function CharCreateClassButtonMixin:HighlightValidRaces()
	for i = 1, 10 do
		local button = _G["CharCreateRaceButton"..i]
		if button:IsEnabled() then
			if IsRaceClassValid(button:GetID(), self:GetID()) then
				button.Glow.Anim:Play()
			else
				button.Glow.Anim:Stop()
			end
		end
	end
end

function CharCreateClassButtonMixin:StopHighlightingRaces()
	for i = 1, 10 do
		local button = _G["CharCreateRaceButton"..i]
		button.Glow.Anim:Stop()
	end
end

function CharCreateClassButtonMixin:SetText(text)
	self.Text:SetText(text)
end

function CharCreateClassButtonMixin:SetSelected(selected)
	self:SetChecked(selected)
end

function CharCreateClassButtonMixin:SetClass(className, classFileName, enabled)
	self.class = classFileName
	local coords = CLASS_ICON_TCOORDS_ROUND[classFileName]
	local classColor = RAID_CLASS_COLORS[classFileName] or HIGHLIGHT_FONT_COLOR
	
	enabled = enabled and CharacterCreateUtil.IsRaceClassEnabledAndValid(CharacterCreate.selectedRace, self:GetID()) and not PAID_SERVICE_TYPE

	self:GetNormalTexture():SetTexCoord(unpack(coords))
	self:GetPushedTexture():SetTexCoord(unpack(coords))
	
	self:SetText(className:gsub(" ([^ ]*)$", "\n%1", 1))
	local textColor = enabled and NORMAL_FONT_COLOR or DISABLED_FONT_COLOR
	self.Text:SetTextColor(textColor:GetRGB())

	self.tooltipTitle = classColor:WrapText(className)

	self:SetEnabled(enabled)
	SetButtonDesaturated(self, not enabled)
	self.DisableTexture:SetShown(not enabled)
	self:SetClassGuideCombatHealer(false)
	self:SetSelected(CharacterCreate.selectedClass == self:GetID())
end

-- Local server: the Murloc is always shown undressed (armor is painted with the human body layout).
local function CharacterCreate_IsMurlocSelected()
	local _, fileString = GetNameForRace()
	return fileString == "Troglodyte"
end
do
	local dress, previewClassOutfit = C_CharacterCreate.Dress, C_CharacterCreate.PreviewClassOutfit
	C_CharacterCreate.Dress = function(...)
		if CharacterCreate_IsMurlocSelected() then return C_CharacterCreate.Undress() end
		return dress(...)
	end
	C_CharacterCreate.PreviewClassOutfit = function(...)
		if CharacterCreate_IsMurlocSelected() then return C_CharacterCreate.Undress() end
		return previewClassOutfit(...)
	end
	local raceOnClick = CharacterRace_OnClick
	function CharacterRace_OnClick(...)
		raceOnClick(...)
		if CharacterCreate_IsMurlocSelected() then C_CharacterCreate.Undress() end
	end
end

-- Local server: Murloc armor option
HAIR_MURLOCARMOR_STYLE = "Armor"
do
	local updateHair = CharacterCreate_UpdateHairCustomization
	function CharacterCreate_UpdateHairCustomization(...)
		updateHair(...)
		if CharacterCreate_IsMurlocSelected() and GetSelectedSex() ~= SEX_MALE then
			CharCreateCustomizationButton3:Hide()
		end
	end
end

-- Local server: bonus racial of the extra races (race id = {source race, ability index, spell name})
CHAR_CREATE_EXTRA_RACE_SIGNATURE, CHAR_CREATE_EXTRA_RACE_SIGNATURE_HORDE = {}, {}
CHAR_CREATE_RACE_BONUS = {
	[9] = {"GNOME", 1, "Escape Artist"}, [12] = {"DRAENEI", 2, "Gift of the Naaru"}, [13] = {"TROLL", 1, "Berserking"},
	[14] = {"HUMAN", 5, "Every Man for Himself"}, [15] = {"TAUREN", 1, "War Stomp"}, [16] = {"DWARF", 1, "Stoneform"},
	[17] = {"DWARF", 3, "Frost Resistance"}, [18] = {"ORC", 1, "Blood Fury"}, [19] = {"GNOME", 1, "Escape Artist"},
	[20] = {"DRAENEI", 2, "Gift of the Naaru"}, [21] = {"BLOODELF", 3, "Arcane Torrent"}, [22] = {"SCOURGE", 1, "Will of the Forsaken"},
	[23] = {"BLOODELF", 3, "Arcane Torrent"}, [24] = {"NIGHTELF", 1, "Shadowmeld"}, [25] = {"DWARF", 1, "Stoneform"},
	[26] = {"DWARF", 1, "Stoneform"}, [27] = {"TAUREN", 1, "War Stomp"}, [28] = {"ORC", 1, "Blood Fury"},
	[29] = {"TAUREN", 1, "War Stomp"}, [30] = {"NIGHTELF", 1, "Shadowmeld"}, [31] = {"GNOME", 1, "Escape Artist"},
}
-- The buttons are numbered by their place in GetAvailableRaces(), which is not the race id (CoA Bots 1.8 lists the
-- Alliance races first), so each button finds its race id by name. Pandaren and Murloc exist twice: the Alliance one
-- (Pandaren 29, Murloc 30) comes first.
CHAR_CREATE_RACE_IDS = {
	["Human"] = {1}, ["Orc"] = {2}, ["Dwarf"] = {3}, ["Night Elf"] = {4}, ["Undead"] = {5}, ["Tauren"] = {6},
	["Gnome"] = {7}, ["Troll"] = {8}, ["Goblin"] = {9}, ["Blood Elf"] = {10}, ["Draenei"] = {11},
	["Zandalari Troll"] = {12}, ["Worgen"] = {13}, ["High Elf"] = {14}, ["Tuskarr"] = {15}, ["Kul Tiran"] = {16},
	["Taunka"] = {17}, ["Vrykul"] = {18}, ["Vulpera"] = {19}, ["Pandaren"] = {29, 20}, ["Naga"] = {21},
	["Broken"] = {22}, ["Fel Orc"] = {23}, ["Forest Troll"] = {24}, ["Ice Troll"] = {25}, ["Skeleton"] = {26},
	["Earthen"] = {27}, ["Drakkari Troll"] = {28}, ["Murloc"] = {30, 31},
}
CHAR_CREATE_RACE_BONUS_FROM = {
	GNOME = "Gnome", DRAENEI = "Draenei", TROLL = "Troll", HUMAN = "Human", TAUREN = "Tauren", DWARF = "Dwarf",
	ORC = "Orc", BLOODELF = "Blood Elf", SCOURGE = "Undead", NIGHTELF = "Night Elf",
}

function CharacterCreate_RaceBonusText(raceID, withIcon)
	local bonus = raceID and CHAR_CREATE_RACE_BONUS[raceID]
	if not bonus then
		return nil
	end
	local source, index, name = bonus[1], bonus[2], bonus[3]
	local text = "|cff00ff96Bonus racial (" .. (CHAR_CREATE_RACE_BONUS_FROM[source] or source) .. "): " .. name .. "|r"
	local description = _G["ABILITY_INFO_" .. source .. index]
	if description then
		text = text .. "|n" .. description
	end
	local spell = CHAR_CREATE_PASSIVES and CHAR_CREATE_PASSIVES[source] and CHAR_CREATE_PASSIVES[source][index]
	if withIcon and spell and GetSpellData then
		local ok, _, _, icon = pcall(GetSpellData, spell, false, true)
		if ok and icon then
			text = "|T" .. icon .. ":24:24:0:0|t" .. text
		end
	end
	return text
end

do
	local setRace = CharCreateRaceButtonMixin.SetRace
	function CharCreateRaceButtonMixin:SetRace(...)
		setRace(self, ...)
		local raceName = ...
		if self:GetID() == 1 then
			CharacterCreate.bonusRaceSeen = {}
		end
		local seen = CharacterCreate.bonusRaceSeen or {}
		CharacterCreate.bonusRaceSeen = seen
		local ids = raceName and CHAR_CREATE_RACE_IDS[raceName]
		seen[raceName or ""] = (seen[raceName or ""] or 0) + 1
		self.bonusRaceID = ids and ids[seen[raceName]]
		local text = CharacterCreate_RaceBonusText(self.bonusRaceID, true)
		if text and self.tooltipText then
			tinsert(self.tooltipText, text .. "\n")
		end
	end
	local setCharacterRace = SetCharacterRace
	function SetCharacterRace(id, ...)
		setCharacterRace(id, ...)
		local button = _G["CharCreateRaceButton" .. (id or CharacterCreate.selectedRace or 0)]
		local text = CharacterCreate_RaceBonusText(button and button.bonusRaceID)
		local bullets = CharCreateRaceInfoFrame and CharCreateRaceInfoFrame.scrollFrame.scrollChild.bulletText
		if text and bullets then
			bullets:SetText((bullets:GetText() or "") .. text .. "\n\n")
		end
	end
end

-- Local server: Eunoia races: icons of the new race names
for name, icon in pairs({
	["Dracthyr"] = "Interface\\Icons\\INV_Misc_Head_Dragon_Bronze",
	["Ogre"] = "Interface\\Icons\\Achievement_Boss_GruulTheDragonkiller",
	["Dark Iron Dwarf"] = "Interface\\Icons\\INV_Misc_Head_Dwarf_01",
	["Illidari Night Elf"] = "Interface\\Icons\\Achievement_Boss_Illidan",
	["Illidari Blood Elf"] = "Interface\\Icons\\Achievement_Boss_Illidan",
	["Lightforged Draenei"] = "Interface\\Icons\\Spell_Holy_SurgeOfLight",
	["Void Elf"] = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
	["Eredar"] = "Interface\\Icons\\Achievement_Boss_Archimonde",
	["Nightborne"] = "Interface\\Icons\\Spell_Arcane_StarFire",
}) do
	if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS[name] = icon end
end

-- Local server: extra races
CHAR_CREATE_RACE_IDS["Alpha Worgen"] = {47}
CHAR_CREATE_RACE_IDS["Alpha Goblin"] = {57}
CHAR_CREATE_RACE_IDS["Furbolg"] = {50}
if CHAR_CREATE_EXTRA_RACE_ICONS then
	CHAR_CREATE_EXTRA_RACE_ICONS["Alpha Worgen"] = "Interface\\Icons\\Ability_Mount_WhiteDireWolf"
	CHAR_CREATE_EXTRA_RACE_ICONS["Alpha Goblin"] = "Interface\\Icons\\INV_Misc_Bomb_04"
	CHAR_CREATE_EXTRA_RACE_ICONS["Furbolg"] = "Interface\\Icons\\Ability_Racial_BearForm"
end

-- Local server: extra races (2)
CHAR_CREATE_RACE_IDS["Alpha Worgen"] = {47}
CHAR_CREATE_RACE_IDS["Alpha Goblin"] = {57}
CHAR_CREATE_RACE_IDS["Furbolg"] = {50}
CHAR_CREATE_RACE_IDS["Thin Human"] = {59}
if CHAR_CREATE_MALE_ONLY_RACES then CHAR_CREATE_MALE_ONLY_RACES["Thin Human"] = true end
if CHAR_CREATE_EXTRA_RACE_ICONS then
	CHAR_CREATE_EXTRA_RACE_ICONS["Alpha Worgen"] = "Interface\\Icons\\Ability_Mount_WhiteDireWolf"
	CHAR_CREATE_EXTRA_RACE_ICONS["Alpha Goblin"] = "Interface\\Icons\\INV_Misc_Bomb_04"
	CHAR_CREATE_EXTRA_RACE_ICONS["Furbolg"] = "Interface\\Icons\\Ability_Racial_BearForm"
	CHAR_CREATE_EXTRA_RACE_ICONS["Thin Human"] = "Interface\\Icons\\Achievement_Character_Human_Male"
end

-- Local server: extra races (3)
CHAR_CREATE_RACE_IDS["Alpha Worgen"] = {47}
CHAR_CREATE_RACE_IDS["Alpha Goblin"] = {57}
CHAR_CREATE_RACE_IDS["Furbolg"] = {50}
CHAR_CREATE_RACE_IDS["Thin Human"] = {32}
if CHAR_CREATE_MALE_ONLY_RACES then CHAR_CREATE_MALE_ONLY_RACES["Thin Human"] = true end
if CHAR_CREATE_EXTRA_RACE_ICONS then
	CHAR_CREATE_EXTRA_RACE_ICONS["Alpha Worgen"] = "Interface\\Icons\\Ability_Mount_WhiteDireWolf"
	CHAR_CREATE_EXTRA_RACE_ICONS["Alpha Goblin"] = "Interface\\Icons\\INV_Misc_Bomb_04"
	CHAR_CREATE_EXTRA_RACE_ICONS["Furbolg"] = "Interface\\Icons\\Ability_Racial_BearForm"
	CHAR_CREATE_EXTRA_RACE_ICONS["Thin Human"] = "Interface\\Icons\\Achievement_Character_Human_Male"
end

-- Local server: recomposite the head once the textures are loaded
COA_RECOMPOSE = { timer = nil, shots = 0 }
do
	local frame = CreateFrame("Frame")
	frame:SetScript("OnUpdate", function(self, elapsed)
		local r = COA_RECOMPOSE
		if not r.timer then return end
		r.timer = r.timer - elapsed
		if r.timer > 0 then return end
		if r.shots > 0 then
			r.shots = r.shots - 1
			r.timer = (r.shots > 0) and 0.9 or nil
			if CharacterCreateFrame and CharacterCreateFrame:IsShown() and C_CharacterCreate and C_CharacterCreate.CycleCustomizationSkipLocked then
				pcall(function()
					C_CharacterCreate.CycleCustomizationSkipLocked(1, 1)
					C_CharacterCreate.CycleCustomizationSkipLocked(1, -1)
				end)
			end
		else
			r.timer = nil
		end
	end)
	local function arm()
		COA_RECOMPOSE.timer = 0.5
		COA_RECOMPOSE.shots = 3
	end
	local oldRace = SetCharacterRace
	function SetCharacterRace(...)
		local a, b, c, d, e = oldRace(...)
		arm()
		return a, b, c, d, e
	end
	local oldSex = SetSelectedSex
	if oldSex then
		function SetSelectedSex(...)
			local a, b, c = oldSex(...)
			arm()
			return a, b, c
		end
	end
end

-- Local server: Medviten races
CHAR_CREATE_RACE_IDS["Dark Iron Dwarf"] = {48}
CHAR_CREATE_RACE_IDS["Mag'har Orc"] = {49}
CHAR_CREATE_RACE_IDS["Ogre"] = {53}
if CHAR_CREATE_EXTRA_RACE_ICONS then
	CHAR_CREATE_EXTRA_RACE_ICONS["Dark Iron Dwarf"] = "Interface\\Icons\\INV_Misc_Head_Dwarf_01"
	CHAR_CREATE_EXTRA_RACE_ICONS["Mag'har Orc"] = "Interface\\Icons\\Achievement_Character_Orc_Male"
	CHAR_CREATE_EXTRA_RACE_ICONS["Ogre"] = "Interface\\Icons\\Achievement_Boss_GruulTheDragonkiller"
end

-- Local server: camera for oversized races
CHAR_CREATE_BIG_RACES = { ["Vrykul"] = 1.8 }
do
	local f = CreateFrame("Frame")
	local pending
	f:SetScript("OnUpdate", function(self, elapsed)
		if not pending then return end
		pending = pending - elapsed
		if pending > 0 then return end
		pending = nil
		local ok, _, fileString = pcall(GetNameForRace)
		local k = ok and fileString and CHAR_CREATE_BIG_RACES[fileString]
		if k and C_CharacterCreate and C_CharacterCreate.GetCameraPosition then
			pcall(function()
				local x, y, z = C_CharacterCreate.GetCameraPosition()
				C_CharacterCreate.SetCameraPosition(x * k, y * k, z * (1 + (k - 1) * 0.6))
			end)
		end
	end)
	local old = SetCharacterRace
	function SetCharacterRace(...)
		local a, b, c, d, e = old(...)
		pending = 0.6
		return a, b, c, d, e
	end
end

-- Local server: Undead Gnome
CHAR_CREATE_RACE_IDS["Undead Gnome"] = {51}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Undead Gnome"] = "Interface\\Icons\\Achievement_Character_Gnome_Male" end

-- Local server: creature races
CHAR_CREATE_RACE_IDS["Vampyr"] = {54}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Vampyr"] = "Interface\\Icons\\Spell_Shadow_VampiricAura" end
CHAR_CREATE_RACE_IDS["Eredar"] = {55}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Eredar"] = "Interface\\Icons\\Spell_Fire_FelFlameRing" end
CHAR_CREATE_RACE_IDS["Harpy"] = {56}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Harpy"] = "Interface\\Icons\\INV_Feather_04" end

-- Local server: Eunoia races (back)
CHAR_CREATE_RACE_IDS["Dracthyr"] = {54, 58}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Dracthyr"] = "Interface\\Icons\\INV_Misc_Head_Dragon_Bronze" end
CHAR_CREATE_RACE_IDS["Void Elf"] = {59}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Void Elf"] = "Interface\\Icons\\Spell_Shadow_ShadowWordPain" end
CHAR_CREATE_RACE_IDS["Illidari Night Elf"] = {61}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Illidari Night Elf"] = "Interface\\Icons\\Achievement_Boss_Illidan" end
CHAR_CREATE_RACE_IDS["Illidari Blood Elf"] = {60}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Illidari Blood Elf"] = "Interface\\Icons\\Achievement_Boss_Illidan" end
CHAR_CREATE_RACE_IDS["Lightforged Draenei"] = {62}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Lightforged Draenei"] = "Interface\\Icons\\Spell_Holy_SurgeOfLight" end
CHAR_CREATE_RACE_IDS["Nightborne"] = {63}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Nightborne"] = "Interface\\Icons\\Spell_Arcane_StarFire" end

-- Local server: race ids above 63 (test)
CHAR_CREATE_RACE_IDS["Test Race"] = {65}

-- Local server: Esteria races

-- Local server: Esteria races (2)
CHAR_CREATE_RACE_IDS["Mechagnome"] = {67}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Mechagnome"] = "Interface\\Icons\\INV_Misc_Gear_08" end

-- Local server: Esteria native races
CHAR_CREATE_RACE_IDS["Highmountain Tauren"] = {66}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Highmountain Tauren"] = "Interface\\Icons\\Achievement_Character_Tauren_Male" end
CHAR_CREATE_RACE_IDS["Earthen"] = {68, 69}
CHAR_CREATE_RACE_IDS["Haranir"] = {71, 70}
if CHAR_CREATE_EXTRA_RACE_ICONS then CHAR_CREATE_EXTRA_RACE_ICONS["Haranir"] = "Interface\\Icons\\INV_Misc_Herb_19" end
CHAR_CREATE_RACE_IDS["Vulpera"] = {74}





























































































































































-- Local server: bonus racial of the races above 32
if CHAR_CREATE_RACE_BONUS then
	CHAR_CREATE_RACE_BONUS[32] = {"NIGHTELF", 1, "Shadowmeld"}
	CHAR_CREATE_RACE_BONUS[47] = {"ORC", 1, "Blood Fury"}
	CHAR_CREATE_RACE_BONUS[48] = {"ORC", 1, "Blood Fury"}
	CHAR_CREATE_RACE_BONUS[49] = {"TROLL", 1, "Berserking"}
	CHAR_CREATE_RACE_BONUS[50] = {"NIGHTELF", 1, "Shadowmeld"}
	CHAR_CREATE_RACE_BONUS[51] = {"GNOME", 1, "Escape Artist"}
	CHAR_CREATE_RACE_BONUS[53] = {"TAUREN", 1, "War Stomp"}
	CHAR_CREATE_RACE_BONUS[54] = {"TAUREN", 1, "War Stomp"}
	CHAR_CREATE_RACE_BONUS[55] = {"BLOODELF", 3, "Arcane Torrent"}
	CHAR_CREATE_RACE_BONUS[56] = {"GNOME", 1, "Escape Artist"}
	CHAR_CREATE_RACE_BONUS[57] = {"GNOME", 1, "Escape Artist"}
	CHAR_CREATE_RACE_BONUS[58] = {"TAUREN", 1, "War Stomp"}
	CHAR_CREATE_RACE_BONUS[59] = {"NIGHTELF", 1, "Shadowmeld"}
	CHAR_CREATE_RACE_BONUS[60] = {"TROLL", 1, "Berserking"}
	CHAR_CREATE_RACE_BONUS[61] = {"BLOODELF", 3, "Arcane Torrent"}
	CHAR_CREATE_RACE_BONUS[62] = {"HUMAN", 5, "Every Man for Himself"}
	CHAR_CREATE_RACE_BONUS[63] = {"BLOODELF", 3, "Arcane Torrent"}
	CHAR_CREATE_RACE_BONUS[66] = {"DWARF", 1, "Stoneform"}
	CHAR_CREATE_RACE_BONUS[67] = {"DWARF", 1, "Stoneform"}
	CHAR_CREATE_RACE_BONUS[68] = {"TAUREN", 1, "War Stomp"}
	CHAR_CREATE_RACE_BONUS[69] = {"TAUREN", 1, "War Stomp"}
	CHAR_CREATE_RACE_BONUS[70] = {"TROLL", 1, "Berserking"}
	CHAR_CREATE_RACE_BONUS[71] = {"TROLL", 1, "Berserking"}
	CHAR_CREATE_RACE_BONUS[74] = {"GNOME", 1, "Escape Artist"}
end
-- end bonus racial of the races above 32

-- Local server: CoA racials of the added races
-- CHAR_CREATE_COA_RACIALS (gen_coa_racials.py): race id -> { {name, icon, "active"/"passive", text} x4 }.
-- The racial list of an added race (12 and up) shows its four CoA racials instead of the borrowed ones.
-- The race buttons get their functions copied when they are made (before this runs), so hooking the button mixin
-- did nothing: the tooltips are filled from here instead, by race name (twin races share their racials).
CHAR_CREATE_COA_RACIALS = {
	[12] = {{"Embrace of the Loa", "ability_racial_embracetheloa", "active", "The Zandalari call on their loa, as every Witch Doctor of the empire learns to. Heals the target over time."}, {"Pterrordax Swoop", "ability_racial_pterrordaxswoop", "active", "A pterrordax carries the Zandalari out of any snare. Escapes any immobilization or movement slowing effect."}, {"City of Gold", "ability_racial_cityofgold", "passive", "The riches of Zuldazar heal what the jungle breaks. Health regeneration increased; part of it continues in combat."}, {"Da Voodoo Shuffle", "ability_racial_wardoftheloa", "passive", "Troll feet never stay rooted for long. Movement impairing effects last 15% less."}},
	[13] = {{"Darkflight", "ability_worgen_darkflight", "active", "The worgen curse frees those who embrace the beast, as Rangers and Reapers know. Escapes any immobilization or movement slowing effect."}, {"Two Forms", "ability_racial_twoforms", "active", "Between the man and the beast, fear finds no hold. Removes Charm, Fear and Sleep effects."}, {"Viciousness", "ability_racial_viciousness", "passive", "Gilneas hunts with the instincts of the wolf. Increases chance to hit by 1%."}, {"Aberration", "ability_racial_runningwild", "passive", "The curse hardens body and blood. Reduces Nature damage taken by 4%."}},
	[14] = {{"Quel'dorei Torrent", "ability_racial_arcaneaffinity", "active", "The High Elves still draw on the Sunwell's legacy, the first lesson of every Starcaller. Silences nearby enemies and restores mana."}, {"Farstrider's Step", "ability_hunter_pet_raptor", "active", "Rangers of Quel'Thalas never stay pinned. Escapes any immobilization or movement slowing effect."}, {"Arcane Acuity", "ability_racial_cantrips", "passive", "Silvermoon's exiles keep their sharp minds. Intellect increased by 5%."}, {"Magic Resistance", "ability_racial_magicalresistance", "passive", "Elven blood turns aside the arcane. Reduces Arcane damage taken by 4%."}},
	[15] = {{"Harpoon Charge", "inv_misc_head_tuskarr", "active", "Tuskarr hunters bring down their prey in one charge. Stuns nearby enemies."}, {"Rime of the Ancient Mariner", "ability_racial_rimeoftheancientmariner", "passive", "Born on the frozen shores of Northrend. Reduces Frost damage taken by 4%."}, {"Fisherman's Patience", "inv_misc_head_tuskarr", "passive", "A tuskarr can wait all day for the catch. Spirit increased by 3%."}, {"Harpooner", "inv_misc_head_tuskarr", "passive", "Thrown spears never miss their mark. Critical strike chance with throwing weapons increased by 1%."}},
	[16] = {{"Haymaker", "ability_racial_haymaker", "active", "Kul Tiran sailors settle things with their fists, a habit Barbarians admire. Stuns nearby enemies."}, {"Brush It Off", "ability_racial_brushitoff", "passive", "A Kul Tiran shrugs off what would drop anyone else. Base health increased by 5%."}, {"Child of the Sea", "ability_racial_childofthesea", "passive", "Raised on the waves of Boralus. Breath lasts much longer underwater."}, {"Rime of the Ancient Mariner", "ability_racial_rimeoftheancientmariner", "passive", "Cold salt spray never bothers them. Reduces Frost damage taken by 4%."}},
	[17] = {{"Thunderhoof", "ability_racial_bullrush", "active", "The Taunka shake the tundra like their southern cousins. Stuns nearby enemies."}, {"Hardened by Northrend", "spell_frost_frostward", "passive", "Generations of ice and wind. Reduces Frost damage taken by 4%."}, {"Taunka Endurance", "ability_racial_bullrush", "passive", "Built to survive the Borean winter. Base health increased by 5%."}, {"Hunter of the Tundra", "ability_hunter_pet_bear", "passive", "The beasts of Northrend are their prey. Damage against beasts increased by 5%."}},
	[18] = {{"Fury of the Val'kyr", "inv_misc_head_vrykul", "active", "The Vrykul fight with the rage of their titan forebears, as their Barbarians do. Increases attack power and spell power for a short time."}, {"Titan Blood", "ability_racial_avatar", "passive", "Giants among men. Base health increased by 5%."}, {"Born in the Cold", "spell_frost_frostward", "passive", "Northrend is their home. Reduces Frost damage taken by 4%."}, {"Axe of the Fjord", "inv_misc_head_vrykul", "passive", "Every Vrykul grows up with an axe. Expertise with axes and fist weapons increased."}},
	[20] = {{"Quaking Palm", "ability_monk_paralysis", "active", "Pandaren masters strike the nerve points, as their monks have for ages. Stuns nearby enemies."}, {"Inner Peace", "_monkspecialattack_dodgepandaren", "passive", "A calm spirit recovers faster. Spirit increased by 3%."}, {"Bouncy", "_monkspecialattack_dodgepandaren", "passive", "A pandaren rolls with the blows. Increases dodge chance by 2%."}, {"Gourmand", "_pandaren_01", "passive", "A full belly is a strong body. Base health increased by 5%."}},
	[21] = {{"Tidal Surge", "spell_frost_summonwaterelemental", "active", "The Naga slip from any hold like the tide. Escapes any immobilization or movement slowing effect."}, {"Siren Song", "achievement_boss_elitenagamale", "active", "Azshara's children silence their foes with a song of the deep. Silences nearby enemies and restores mana."}, {"Serpent Scales", "ability_racial_childofthesea", "passive", "Hardened scales from the depths of Nazjatar. Reduces Nature damage taken by 4%."}, {"Gills", "spell_frost_summonwaterelemental", "passive", "Born under the waves. Breath lasts much longer underwater."}},
	[22] = {{"Shattered Light", "spell_holy_holyprotection", "active", "The Broken still hold a spark of the Naaru's light, as their Sun Clerics remember. Heals the target over time."}, {"Exile's Will", "spell_shadow_antishadow", "active", "The fel broke their bodies, not their minds. Removes Charm, Fear and Sleep effects."}, {"Exile's Resolve", "ability_racial_holyresistance", "passive", "What is left of them resists the dark. Reduces Shadow damage taken by 4%."}, {"Shamanic Bond", "spell_nature_bloodlust", "passive", "The Broken kept the old shamanic ways alive. Spirit increased by 3%."}},
	[23] = {{"Fel Rage", "spell_shadow_demonform", "active", "Fel blood burns in their veins, a fire every Felsworn knows. Increases attack power and spell power for a short time."}, {"Demonic Endurance", "spell_shadow_ritualofsacrifice", "passive", "Fel-forged bodies shrug off blows that stun others. Stun effects last 15% less."}, {"Fel-Hardened", "ability_racial_demonbane", "passive", "The fel already took what it could. Reduces Shadow damage taken by 4%."}, {"Axe of the Horde", "achievement_boss_hellfire_felorccouncil", "passive", "The Fel Horde fights with axes. Expertise with axes and fist weapons increased."}},
	[24] = {{"Headhunter's Frenzy", "ability_racial_bloodrage", "active", "The Amani fight in a blood frenzy. Increases attack and casting speed for a short time."}, {"Jungle Stalker", "ability_racial_shadowmeld", "passive", "Forest Trolls vanish among the trees. Increases dodge chance by 2%."}, {"Troll Regeneration", "ability_racial_wardoftheloa", "passive", "Troll flesh mends itself. Health regeneration increased; part of it continues in combat."}, {"Headhunter", "inv_misc_head_troll_01", "passive", "An Amani axe thrown never misses. Critical strike chance with throwing weapons increased by 1%."}},
	[25] = {{"Frostmane Frenzy", "spell_frost_frostward", "active", "The trolls of the frozen north fight hot-blooded. Increases attack and casting speed for a short time."}, {"Winter's Blood", "ability_racial_rimeoftheancientmariner", "passive", "Born in the snows of Zul'Drak. Reduces Frost damage taken by 4%."}, {"Troll Regeneration", "ability_racial_wardoftheloafrost", "passive", "Troll flesh mends itself. Health regeneration increased; part of it continues in combat."}, {"Ice Hunter", "inv_misc_head_troll_01", "passive", "The beasts of the north are their prey. Damage against beasts increased by 5%."}},
	[26] = {{"Bone Shield", "ability_racial_skeletonpinkie", "active", "No mind left to frighten, as every Necromancer intends. Removes Charm, Fear and Sleep effects."}, {"Bone Pile", "spell_shadow_raisedead", "active", "A skeleton lying still is just another pile of bones. Slip into the shadows, dropping out of combat."}, {"Unliving", "spell_shadow_antishadow", "passive", "Death holds no more terror. Reduces Shadow damage taken by 4%."}, {"No Lungs", "spell_shadow_raisedead", "passive", "Bones have nothing to drown. Breath lasts much longer underwater."}},
	[28] = {{"Blood of the Gods", "ability_racial_bloodrage", "active", "The Drakkari drink the blood of their gods, a rite their Witch Doctors kept. Increases attack and casting speed for a short time."}, {"Drakkari Regeneration", "ability_racial_wardoftheloa", "passive", "Troll flesh mends itself. Health regeneration increased; part of it continues in combat."}, {"Frozen Empire", "ability_racial_wardoftheloafrost", "passive", "Zul'Drak never thaws. Reduces Frost damage taken by 4%."}, {"Da Voodoo Shuffle", "inv_misc_head_troll_01", "passive", "Troll feet never stay rooted for long. Movement impairing effects last 15% less."}},
	[29] = {{"Quaking Palm", "ability_monk_paralysis", "active", "Pandaren masters strike the nerve points, as their monks have for ages. Stuns nearby enemies."}, {"Inner Peace", "_monkspecialattack_dodgepandaren", "passive", "A calm spirit recovers faster. Spirit increased by 3%."}, {"Bouncy", "_monkspecialattack_dodgepandaren", "passive", "A pandaren rolls with the blows. Increases dodge chance by 2%."}, {"Gourmand", "_pandaren_01", "passive", "A full belly is a strong body. Base health increased by 5%."}},
	[30] = {{"Mrgglrrgl!", "inv_misc_head_murloc_01", "active", "Nothing holds a slippery murloc for long. Escapes any immobilization or movement slowing effect."}, {"Murloc Swarm", "achievement_reputation_murlocoracle", "active", "Where there is one murloc, there are ten. Increases attack and casting speed for a short time."}, {"Amphibious", "ability_racial_childofthesea", "passive", "Quick and hard to catch. Increases dodge chance by 2%."}, {"Born in the Shallows", "inv_misc_head_murloc_01", "passive", "The sea is home. Breath lasts much longer underwater."}},
	[31] = {{"Mrgglrrgl!", "inv_misc_head_murloc_01", "active", "Nothing holds a slippery murloc for long. Escapes any immobilization or movement slowing effect."}, {"Murloc Swarm", "achievement_reputation_murlocoracle", "active", "Where there is one murloc, there are ten. Increases attack and casting speed for a short time."}, {"Amphibious", "ability_racial_childofthesea", "passive", "Quick and hard to catch. Increases dodge chance by 2%."}, {"Born in the Shallows", "inv_misc_head_murloc_01", "passive", "The sea is home. Breath lasts much longer underwater."}},
	[32] = {{"Survivor's Will", "achievement_character_human_male", "active", "Lean, hungry and hard to keep down. Removes all stuns and movement impairing effects."}, {"Light Step", "ability_rogue_sprint", "passive", "A thin frame dodges blows. Increases dodge chance by 2%."}, {"Human Spirit", "achievement_character_human_male", "passive", "The resolve of Stormwind's streets. Spirit increased by 3%."}, {"Diplomacy", "ability_racial_jackofalltrades", "passive", "A friendly face everywhere. Reputation gains increased by 10%."}},
	[47] = {{"Pack Howl", "ability_racial_runningwild", "active", "The alpha leads the pack into battle. Increases attack power and spell power for a short time."}, {"Alpha Instinct", "ability_racial_twoforms", "passive", "Nothing escapes the alpha's senses. Increases stealth detection."}, {"Viciousness", "ability_racial_viciousness", "passive", "An alpha never misses its prey. Increases chance to hit by 1%."}, {"Thick Pelt", "ability_worgen_darkflight", "passive", "The wild hardened them. Reduces Nature damage taken by 4%."}},
	[48] = {{"Fireblood", "ability_racial_fireblood", "active", "The Dark Iron burn away what ails them, as their Pyromancers taught. Removes poison, disease and bleed effects and reduces damage taken for a short time."}, {"Forged in Flames", "ability_racial_foregedinflames", "passive", "Shadowforge steel and stubborn skulls. Stun effects last 15% less."}, {"Mole Machine", "ability_racial_dungeondelver", "passive", "Dark Iron engineering is the finest under the mountain. Engineering skill increased by 15."}, {"Mace of the Forge", "ability_racial_mastercraft", "passive", "The hammer is a Dark Iron's first tool. Expertise with maces increased."}},
	[49] = {{"Ancestral Call", "ability_racial_ancestralcall", "active", "The Mag'har call on the spirits of Draenor, as their Primalists do. Increases attack power and spell power for a short time."}, {"Open Skies", "ability_racial_openskies", "passive", "Untainted by the fel, their strikes fly true. Increases chance to hit by 1%."}, {"Savage Blood", "ability_racial_pureblood", "passive", "Pure orcish blood shrugs off a stun. Stun effects last 15% less."}, {"Command", "achievement_alliedrace_magharorc", "passive", "Wolves and beasts follow the Mag'har. Pet damage increased by 5%."}},
	[50] = {{"Ursine Fury", "ability_racial_bearform", "active", "The Furbolg fight with the strength of the bear. Increases attack and casting speed for a short time."}, {"Thick Fur", "inv_cape_special_furbolg_d_01", "passive", "Children of the wild, at home in nature. Reduces Nature damage taken by 4%."}, {"Furbolg Endurance", "ability_racial_bearform", "passive", "Big, and hard to bring down. Base health increased by 5%."}, {"Gift of the Grove", "inv_cape_special_furbolg_d_01", "passive", "The forests of Ashenvale share their herbs. Herbalism skill increased by 15."}},
	[51] = {{"Gnomish Defiance", "spell_shadow_raisedead", "active", "Death did not dull a gnome's stubborn mind, the first rule of any undead Tinker. Removes Charm, Fear and Sleep effects."}, {"Cannibalize", "ability_racial_cannibalize", "active", "Undeath has its appetites. Regenerates health while eating the dead."}, {"Necrotic Intellect", "ability_racial_betterlivingthroughchemistry", "passive", "Brilliance outlives the body. Intellect increased by 5%."}, {"Undead Engineering", "inv_misc_head_clockworkgnome_01", "passive", "A gnome tinkers even after death. Engineering skill increased by 15."}},
	[53] = {{"Ogre Slam", "achievement_boss_gruul", "active", "One slam is usually enough, as every ogre Barbarian knows. Stuns nearby enemies."}, {"Two Heads Are Better", "achievement_boss_gruulthedragonkiller", "passive", "Ogres are built to last. Base health increased by 5%."}, {"Thick Skull", "achievement_boss_gruul", "passive", "Hard to stun a head that thick. Stun effects last 15% less."}, {"Club Mastery", "achievement_reputation_ogre", "passive", "Big club, big hit. Expertise with maces increased."}},
	[54] = {{"Wing Buffet", "inv_misc_head_dragon_bronze", "active", "Dracthyr scatter their foes with a beat of their wings, as their Chronomancers favor. Stuns nearby enemies."}, {"Soar", "inv_misc_head_dragon_01", "active", "No snare holds a dragon. Escapes any immobilization or movement slowing effect."}, {"Draconic Mind", "inv_misc_head_dragon_black", "passive", "The aspects' knowledge runs in their blood. Intellect increased by 5%."}, {"Scales of the Aspects", "inv_misc_head_dragon_blue", "passive", "Dragon scales turn aside magic. Reduces magic damage taken by 2%."}},
	[55] = {{"Fel Torrent", "achievement_boss_argus_maleeredar", "active", "The Eredar unleash a torrent of fel, the gift every Felsworn craves. Silences nearby enemies and restores mana."}, {"Sargeras' Gift", "spell_shadow_demonform", "active", "The Burning Legion empowers its chosen. Increases attack power and spell power for a short time."}, {"Man'ari Mind", "spell_shadow_demonicpact", "passive", "Ancient Argus minds, sharp as ever. Intellect increased by 5%."}, {"Demonic Hide", "ability_racial_demonbane", "passive", "The fel runs deep. Reduces Shadow damage taken by 4%."}},
	[56] = {{"Wing Gust", "inv_feather_04", "active", "Harpies take to the air to escape any snare. Escapes any immobilization or movement slowing effect."}, {"Screech", "ability_hunter_pet_raptor", "active", "A harpy's shriek leaves foes reeling. Stuns nearby enemies."}, {"Swift Talons", "ability_hunter_pet_raptor", "passive", "Hard to catch, quick to strike. Increases dodge chance by 2%."}, {"Keen Eyes", "inv_feather_04", "passive", "Nothing hides from a harpy circling above. Increases stealth detection."}},
	[57] = {{"Rocket Jump", "ability_racial_rocketjump", "active", "Every goblin carries a rocket for emergencies, a Tinker's favorite. Escapes any immobilization or movement slowing effect."}, {"Rocket Barrage", "ability_racial_rocketbarrage", "active", "When in doubt, fire everything. Increases attack and casting speed for a short time."}, {"Time is Money", "ability_racial_timeismoney", "passive", "A goblin never wastes a swing. Increases chance to hit by 1%."}, {"Best Deals Anywhere", "ability_racial_bestdealsanywhere", "passive", "Every faction is a customer. Reputation gains increased by 10%."}},
	[58] = {{"Wing Buffet", "inv_misc_head_dragon_bronze", "active", "Dracthyr scatter their foes with a beat of their wings, as their Chronomancers favor. Stuns nearby enemies."}, {"Soar", "inv_misc_head_dragon_01", "active", "No snare holds a dragon. Escapes any immobilization or movement slowing effect."}, {"Draconic Mind", "inv_misc_head_dragon_black", "passive", "The aspects' knowledge runs in their blood. Intellect increased by 5%."}, {"Scales of the Aspects", "inv_misc_head_dragon_blue", "passive", "Dragon scales turn aside magic. Reduces magic damage taken by 2%."}},
	[59] = {{"Spatial Rift", "ability_racial_spatialrift", "active", "Void Elves slip between the shadows, as their Cultists learned from the Void. Slip into the shadows, dropping out of combat."}, {"Void Torrent", "ability_racial_chillofnight", "active", "The Void silences those who stare into it. Silences nearby enemies and restores mana."}, {"Entropic Embrace", "ability_racial_entropicembrace", "passive", "The Void protects its own. Reduces Shadow damage taken by 4%."}, {"Ethereal Connection", "ability_racial_etherealconnection", "passive", "Whispers from beyond sharpen the mind. Intellect increased by 5%."}},
	[60] = {{"Spectral Sight", "ability_demonhunter_spectralsight", "active", "Illidari eyes see what hides. Greatly increases stealth detection for a short time."}, {"Fel Rush", "ability_demonhunter_illidansgrasp", "active", "The Illidari dash through any trap. Escapes any immobilization or movement slowing effect."}, {"Demon Hunter's Resolve", "ability_racial_demonbane", "passive", "Trained by Illidan to endure. Stun effects last 15% less."}, {"Felblood", "spell_shadow_demonform", "passive", "The fel they consumed protects them. Reduces Shadow damage taken by 4%."}},
	[61] = {{"Mana Break", "achievement_boss_illidan", "active", "The Illidari tear the magic from their foes. Silences nearby enemies and restores mana."}, {"Illidari Shadows", "ability_racial_shadowmeld", "active", "Hunters of the night, like their kaldorei kin. Slip into the shadows, dropping out of combat."}, {"Demonbane", "ability_racial_demonbane", "passive", "Sworn enemies of the Legion. Reduces Shadow damage taken by 4%."}, {"Demonic Senses", "ability_demonhunter_spectralsight", "passive", "No demon hides from them. Increases stealth detection."}},
	[62] = {{"Light's Reckoning", "ability_racial_finalverdict", "active", "The Lightforged carry the Naaru's light, as their Templars and Sun Clerics do. Heals the target over time."}, {"Forge of Light", "ability_racial_forgeoflight", "passive", "The Light renews them. Spirit increased by 3%."}, {"Holy Resistance", "ability_racial_holyresistance", "passive", "The Light shields its chosen. Reduces magic damage taken by 2%."}, {"Lightforged Resolve", "ability_racial_forceshield", "passive", "Forged in Light, they stand firm. Stun effects last 15% less."}},
	[63] = {{"Arcane Pulse", "ability_mage_arcanebarrage_nightborne", "active", "The Nightborne master the arcane of Suramar, a Starcaller's dream. Silences nearby enemies and restores mana."}, {"Cantrips", "ability_racial_cantrips", "active", "A Nightborne illusion hides them in plain sight. Slip into the shadows, dropping out of combat."}, {"Ancient History", "achievement_alliedrace_nightborne", "passive", "Ten thousand years of study. Intellect increased by 5%."}, {"Magical Affinity", "ability_racial_magicalresistance", "passive", "The Nightwell flows in their veins. Reduces magic damage taken by 2%."}},
	[66] = {{"Bull Rush", "ability_racial_bullrush", "active", "Highmountain charge like the great moose. Stuns nearby enemies."}, {"Mountaineer", "ability_racial_mountaineer", "passive", "Raised on the peaks of Highmountain. Base health increased by 5%."}, {"Pride of Ironhorn", "ability_racial_prideofironhorn", "passive", "Hard as the mountain. Stun effects last 15% less."}, {"Rugged Tenacity", "achievements_zone_highmountain", "passive", "The wilds of Highmountain toughen them. Reduces Nature damage taken by 4%."}},
	[67] = {{"Combat Analysis", "ability_racial_combatanalysis", "active", "Mechagnome processors read the fight, a Tinker's dream. Increases attack and casting speed for a short time."}, {"Emergency Failsafe", "ability_racial_rearm", "active", "Built-in protocols reboot a stunned mechagnome. Removes all stuns and movement impairing effects."}, {"Re-Origination", "ability_racial_hyperorganiclightoriginator", "passive", "Optimized servos react faster. Increases dodge chance by 2%."}, {"Mechanical Mastery", "ability_racial_massproduction", "passive", "Built by engineers, for engineers. Engineering skill increased by 15."}},
	[68] = {{"Azerite Surge", "ability_earthenfury_giftofearth", "active", "The Earthen are made of living stone, as their Runemasters remember. Removes poison, disease and bleed effects and reduces damage taken for a short time."}, {"Titan-Forged", "ability_earthen_pillar", "passive", "Stone does not stagger. Stun effects last 15% less."}, {"Stoneskin", "ability_earthenfury_giftofearth", "passive", "Living rock is hard to break. Base health increased by 5%."}, {"Gemcutting", "ability_earthen_pillar", "passive", "The Earthen know every gem of the deep. Jewelcrafting skill increased by 5."}},
	[69] = {{"Azerite Surge", "ability_earthenfury_giftofearth", "active", "The Earthen are made of living stone, as their Runemasters remember. Removes poison, disease and bleed effects and reduces damage taken for a short time."}, {"Titan-Forged", "ability_earthen_pillar", "passive", "Stone does not stagger. Stun effects last 15% less."}, {"Stoneskin", "ability_earthenfury_giftofearth", "passive", "Living rock is hard to break. Base health increased by 5%."}, {"Gemcutting", "ability_earthen_pillar", "passive", "The Earthen know every gem of the deep. Jewelcrafting skill increased by 5."}},
	[70] = {{"Rootkin Mending", "spell_nature_healingtouch", "active", "The Haranir draw life from the roots of the world, as their Primalists do. Heals the target over time."}, {"Root Step", "spell_nature_stoneclawtotem", "active", "Roots part to let them through. Escapes any immobilization or movement slowing effect."}, {"Barkskin Hide", "spell_nature_stoneclawtotem", "passive", "Bark and leaf protect them. Reduces Nature damage taken by 4%."}, {"Gift of the Roots", "spell_nature_healingtouch", "passive", "Every herb answers a Haranir. Herbalism skill increased by 15."}},
	[71] = {{"Rootkin Mending", "spell_nature_healingtouch", "active", "The Haranir draw life from the roots of the world, as their Primalists do. Heals the target over time."}, {"Root Step", "spell_nature_stoneclawtotem", "active", "Roots part to let them through. Escapes any immobilization or movement slowing effect."}, {"Barkskin Hide", "spell_nature_stoneclawtotem", "passive", "Bark and leaf protect them. Reduces Nature damage taken by 4%."}, {"Gift of the Roots", "spell_nature_healingtouch", "passive", "Every herb answers a Haranir. Herbalism skill increased by 15."}},
	[74] = {{"Bag of Tricks", "ability_racial_makecamp", "active", "A Vulpera always has something in the bag. Escapes any immobilization or movement slowing effect."}, {"Make Camp", "ability_racial_returntocamp", "active", "A short rest at camp mends any wound. Regenerates health while eating the dead."}, {"Nose for Trouble", "ability_racial_returntocamp", "passive", "Desert scavengers dodge danger. Increases dodge chance by 2%."}, {"Desert Hardened", "ability_racial_makecamp", "passive", "The sands of Vol'dun forge tough hides. Reduces Nature damage taken by 4%."}},
	[78] = {{"Waterspeaker's Blessing", "spell_shaman_tidalwaves", "active", "Jinyu waterspeakers hear the river's will and mend with it, as every Sun Cleric of the shore learns. Heals the target over time."}, {"Riptide Escape", "ability_shaman_watershield", "active", "No net or snare holds a river-born for long. Escapes any immobilization or movement slowing effect."}, {"Gift of the River", "spell_frost_summonwaterelemental", "passive", "The Jinyu breathe the waters they came from. Breath lasts much longer underwater."}, {"Cold Currents", "spell_frost_frostward", "passive", "Mountain springs harden scale against the cold. Reduces Frost damage taken by 4%."}},
	[80] = {{"Blood Siphon", "spell_shadow_lifedrain02", "active", "The Darkfallen drink the strength of the living, as every Bloodmage of Icecrown learns. Increases attack power and spell power for a short time."}, {"Mist Form", "ability_rogue_shadowstep", "active", "A vampire fades into the dark mist. Slip into the shadows, dropping out of combat."}, {"Undying Hunger", "spell_shadow_vampiricaura", "passive", "Stolen blood mends their wounds. Health regeneration increased; part of it continues in combat."}, {"Grave Chill", "spell_shadow_soulleech_3", "passive", "Death itself flows in their veins. Reduces Shadow damage taken by 4%."}},
	[81] = {{"Blood Siphon", "spell_shadow_lifedrain02", "active", "The Darkfallen drink the strength of the living, as every Bloodmage of Icecrown learns. Increases attack power and spell power for a short time."}, {"Mist Form", "ability_rogue_shadowstep", "active", "A vampire fades into the dark mist. Slip into the shadows, dropping out of combat."}, {"Undying Hunger", "spell_shadow_vampiricaura", "passive", "Stolen blood mends their wounds. Health regeneration increased; part of it continues in combat."}, {"Grave Chill", "spell_shadow_soulleech_3", "passive", "Death itself flows in their veins. Reduces Shadow damage taken by 4%."}},
	[82] = {{"Serpent's Escape", "inv_misc_monsterscales_15", "active", "The Sethrak slither out of any hold, a trick every Venomancer of Vol'dun knows. Escapes any immobilization or movement slowing effect."}, {"Venom Blood", "spell_nature_nullifypoison", "passive", "Poison runs cold through their own veins. Reduces Nature damage taken by 4%."}, {"Desert Scales", "spell_nature_poisoncleansingtotem", "passive", "Sand-hardened scales turn blows aside. Increases dodge chance by 2%."}, {"Coiled Strength", "inv_misc_monsterscales_15", "passive", "Long serpent bodies carry great endurance. Base health increased by 5%."}},
	[83] = {{"Pack Howl", "ability_hunter_pet_hyena", "active", "Gnolls fight in a frenzy when the pack howls, as their Barbarians know. Increases attack and casting speed for a short time."}, {"Bone Gnaw", "inv_misc_bone_01", "active", "A gnoll eats what it kills. Regenerates health while eating the dead."}, {"Scavenger", "ability_racial_bloodrage", "active", "Gnolls sniff out every scrap worth taking. Senses nearby treasure."}, {"Thick Hide", "ability_hunter_pet_hyena", "passive", "Mangy, but hard to kill. Base health increased by 5%."}},
	[97] = {{"Pounce", "ability_druid_supriseattack", "active", "Saberon strike from the brush, the way Draenor's Rangers hunt. Stuns nearby enemies."}, {"Feline Grace", "ability_druid_catform", "passive", "Cat-quick reflexes slip past the blade. Increases dodge chance by 2%."}, {"Predator", "ability_hunter_pet_cat", "passive", "Saberon were born to hunt beasts. Damage against beasts increased by 5%."}, {"Shadow Prowl", "ability_mount_jungletiger", "passive", "A saberon in the shadows is seldom seen. Harder to detect while hidden."}},
}
if CHAR_CREATE_EXTRA_RACE_ICONS then
	CHAR_CREATE_EXTRA_RACE_ICONS["Alpha Goblin"] = "Interface\\Icons\\CoA_Race_AlphaGoblin"
	CHAR_CREATE_EXTRA_RACE_ICONS["Alpha Worgen"] = "Interface\\Icons\\CoA_Race_AlphaWorgen"
	CHAR_CREATE_EXTRA_RACE_ICONS["Broken"] = "Interface\\Icons\\CoA_Race_Broken"
	CHAR_CREATE_EXTRA_RACE_ICONS["Dark Iron Dwarf"] = "Interface\\Icons\\CoA_Race_DarkIronDwarf"
	CHAR_CREATE_EXTRA_RACE_ICONS["Darkfallen"] = "Interface\\Icons\\CoA_Race_Darkfallen"
	CHAR_CREATE_EXTRA_RACE_ICONS["Dracthyr"] = "Interface\\Icons\\CoA_Race_Dracthyr"
	CHAR_CREATE_EXTRA_RACE_ICONS["Drakkari Troll"] = "Interface\\Icons\\CoA_Race_DrakkariTroll"
	CHAR_CREATE_EXTRA_RACE_ICONS["Earthen"] = "Interface\\Icons\\CoA_Race_Earthen"
	CHAR_CREATE_EXTRA_RACE_ICONS["Eredar"] = "Interface\\Icons\\CoA_Race_Eredar"
	CHAR_CREATE_EXTRA_RACE_ICONS["Fel Orc"] = "Interface\\Icons\\CoA_Race_FelOrc"
	CHAR_CREATE_EXTRA_RACE_ICONS["Forest Troll"] = "Interface\\Icons\\CoA_Race_ForestTroll"
	CHAR_CREATE_EXTRA_RACE_ICONS["Furbolg"] = "Interface\\Icons\\CoA_Race_Furbolg"
	CHAR_CREATE_EXTRA_RACE_ICONS["Gnoll"] = "Interface\\Icons\\CoA_Race_Gnoll"
	CHAR_CREATE_EXTRA_RACE_ICONS["Haranir"] = "Interface\\Icons\\CoA_Race_Haranir"
	CHAR_CREATE_EXTRA_RACE_ICONS["Harpy"] = "Interface\\Icons\\CoA_Race_Harpy"
	CHAR_CREATE_EXTRA_RACE_ICONS["High Elf"] = "Interface\\Icons\\CoA_Race_HighElf"
	CHAR_CREATE_EXTRA_RACE_ICONS["Highmountain Tauren"] = "Interface\\Icons\\CoA_Race_HighmountainTauren"
	CHAR_CREATE_EXTRA_RACE_ICONS["Ice Troll"] = "Interface\\Icons\\CoA_Race_IceTroll"
	CHAR_CREATE_EXTRA_RACE_ICONS["Illidari Blood Elf"] = "Interface\\Icons\\CoA_Race_IllidariBloodElf"
	CHAR_CREATE_EXTRA_RACE_ICONS["Illidari Night Elf"] = "Interface\\Icons\\CoA_Race_IllidariNightElf"
	CHAR_CREATE_EXTRA_RACE_ICONS["Jinyu"] = "Interface\\Icons\\CoA_Race_Jinyu"
	CHAR_CREATE_EXTRA_RACE_ICONS["Kul Tiran"] = "Interface\\Icons\\CoA_Race_KulTiran"
	CHAR_CREATE_EXTRA_RACE_ICONS["Lightforged Draenei"] = "Interface\\Icons\\CoA_Race_LightforgedDraenei"
	CHAR_CREATE_EXTRA_RACE_ICONS["Mag'har Orc"] = "Interface\\Icons\\CoA_Race_MagHarOrc"
	CHAR_CREATE_EXTRA_RACE_ICONS["Mechagnome"] = "Interface\\Icons\\CoA_Race_Mechagnome"
	CHAR_CREATE_EXTRA_RACE_ICONS["Murloc"] = "Interface\\Icons\\CoA_Race_Murloc"
	CHAR_CREATE_EXTRA_RACE_ICONS["Naga"] = "Interface\\Icons\\CoA_Race_Naga"
	CHAR_CREATE_EXTRA_RACE_ICONS["Nightborne"] = "Interface\\Icons\\CoA_Race_Nightborne"
	CHAR_CREATE_EXTRA_RACE_ICONS["Ogre"] = "Interface\\Icons\\CoA_Race_Ogre"
	CHAR_CREATE_EXTRA_RACE_ICONS["Pandaren"] = "Interface\\Icons\\CoA_Race_Pandaren"
	CHAR_CREATE_EXTRA_RACE_ICONS["Saberon"] = "Interface\\Icons\\CoA_Race_Saberon"
	CHAR_CREATE_EXTRA_RACE_ICONS["Sethrak"] = "Interface\\Icons\\CoA_Race_Sethrak"
	CHAR_CREATE_EXTRA_RACE_ICONS["Skeleton"] = "Interface\\Icons\\CoA_Race_Skeleton"
	CHAR_CREATE_EXTRA_RACE_ICONS["Taunka"] = "Interface\\Icons\\CoA_Race_Taunka"
	CHAR_CREATE_EXTRA_RACE_ICONS["Thin Human"] = "Interface\\Icons\\CoA_Race_ThinHuman"
	CHAR_CREATE_EXTRA_RACE_ICONS["Tuskarr"] = "Interface\\Icons\\CoA_Race_Tuskarr"
	CHAR_CREATE_EXTRA_RACE_ICONS["Undead Gnome"] = "Interface\\Icons\\CoA_Race_UndeadGnome"
	CHAR_CREATE_EXTRA_RACE_ICONS["Void Elf"] = "Interface\\Icons\\CoA_Race_VoidElf"
	CHAR_CREATE_EXTRA_RACE_ICONS["Vrykul"] = "Interface\\Icons\\CoA_Race_Vrykul"
	CHAR_CREATE_EXTRA_RACE_ICONS["Vulpera"] = "Interface\\Icons\\CoA_Race_Vulpera"
	CHAR_CREATE_EXTRA_RACE_ICONS["Worgen"] = "Interface\\Icons\\CoA_Race_Worgen"
	CHAR_CREATE_EXTRA_RACE_ICONS["Zandalari Troll"] = "Interface\\Icons\\CoA_Race_ZandalariTroll"
end
do
	local function RaceRacials(name)
		local ids = name and CHAR_CREATE_RACE_IDS and CHAR_CREATE_RACE_IDS[name]
		return ids and CHAR_CREATE_COA_RACIALS and CHAR_CREATE_COA_RACIALS[ids[1]]
	end

	local function RacialLines(racials)
		local text = ""
		for _, racial in ipairs(racials) do
			text = text .. "|TInterface\\Icons\\" .. racial[2] .. ":24:24:0:0|t |cffffd100" .. racial[1] .. "|r |cff9d9d9d(" ..
				racial[3] .. ")|r|n" .. racial[4] .. "|n|n"
		end
		return text
	end

	if CHAR_CREATE_RACE_BONUS then
		for raceID in pairs(CHAR_CREATE_COA_RACIALS or {}) do
			CHAR_CREATE_RACE_BONUS[raceID] = nil              -- the old borrowed racial line
		end
	end

	-- race button tooltips: flavor line + the four CoA racials (redone whenever the button rebuilds its tooltip)
	local function PatchButtons()
		for i = 1, 128 do
			local button = _G["CharCreateRaceButton" .. i]
			if button and button.tooltipText and button.coaTip ~= button.tooltipText then
				button.coaTip = button.tooltipText
				local racials = RaceRacials(button.tooltipTitle)
				if racials then
					local flavor = button.tooltipText[1]
					for k = #button.tooltipText, 1, -1 do
						button.tooltipText[k] = nil
					end
					if flavor then
						tinsert(button.tooltipText, flavor)
					end
					for _, racial in ipairs(racials) do
						tinsert(button.tooltipText, "|TInterface\\Icons\\" .. racial[2] .. ":24:24:0:0|t|cffffd100" ..
							racial[1] .. "|r |cff9d9d9d(" .. racial[3] .. ")|r|n" .. racial[4] .. "\n")
					end
				end
			end
		end
	end
	local ticker = CreateFrame("Frame")
	ticker:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed > 0.3 then
			self.elapsed = 0
			if CharacterCreate and CharacterCreate:IsShown() then
				local ok, err = pcall(PatchButtons)
				if not ok then COA_UI_ERROR = "racials: " .. tostring(err) end
			end
		end
	end)

	-- "Selected Race" step button: the added races' face portrait (their button texture is painted with
	-- SetPortraitToTexture, so copying it gave a broken icon)
	if CharacterCreate_UpdateNavigtationRaceButton then
		local updateNav = CharacterCreate_UpdateNavigtationRaceButton
		function CharacterCreate_UpdateNavigtationRaceButton(...)
			updateNav(...)
			pcall(function()
				local button = _G["CharCreateRaceButton" .. CharacterCreate.selectedRace]
				local name = button and (button.tooltipTitle or (button.Text and button.Text:GetText()))
				local icon = name and CHAR_CREATE_EXTRA_RACE_ICONS and CHAR_CREATE_EXTRA_RACE_ICONS[name]
				local nav = icon and CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.ClassRace)
				if nav and nav.Icon then
					if SetPortraitToTexture then
						SetPortraitToTexture(nav.Icon, icon)
					else
						nav.Icon:SetTexture(icon)
					end
					nav.Icon:SetTexCoord(0, 1, 0, 1)
				end
			end)
		end
	end

	-- the race info panel of the selected race
	local setCharacterRace = SetCharacterRace
	function SetCharacterRace(id, ...)
		local a, b, c, d, e = setCharacterRace(id, ...)
		local ok, name = pcall(GetNameForRace)
		local racials = ok and RaceRacials(name)
		local bullets = CharCreateRaceInfoFrame and CharCreateRaceInfoFrame.scrollFrame.scrollChild.bulletText
		if racials and bullets then
			bullets:SetText(RacialLines(racials))
		end
		return a, b, c, d, e
	end
end
-- end CoA racials of the added races

-- Local server: Esteria native appearance controls
-- The retail options of the Esteria races (our ids 66+: Highmountain, Mechagnome, Earthen, Haranir, Vulpera) come
-- from EsteriaAppearance.dll ("EA_" calls of CycleCharCustomization). Ascension's creation screen has its own rows
-- (CharCreateCustomizationButton1-5, CharCreateCustomizationFrame), so the extra options get rows of their own built
-- from the same template, six per page, in place of the stock rows while "Extra Customization" is on (the toggle
-- under the Customize step button). Every other race keeps the stock screen untouched.
do
	local BY_FILE = {HIGHMOUNTAINTAUREN = 46, MECHAGNOME = 47, EARTHEN = 48, EARTHENHORDE = 49, HARANIR = 50,
		HARANIRHORDE = 51, VULPERAESTERIA = 20, SETHRAKALLIANCE = 62, GNOLLHORDE = 63, SABERONHORDE = 64}
	local NAMED = {[20] = true, [46] = true, [48] = true, [49] = true, [50] = true, [51] = true}
	local LABELS = {"Skin Color", "Face", "Hair Style", "Hair Color", "Eye Color", "Eyebrow Style",
		"Feathers", "Feather Color", "Facial Hair", "Ears"}
	local MECH_LABELS = {"Skin Color", "Face", "Hair Style", "Hair Color", "Facial Hair", "Arm Upgrade", "Leg Upgrade",
		"Modification", "Eye Color", "Paint", "Eyesight", "Eye Style"}
	local MAX, PER_PAGE, SPACING = 29, 6, 52
	local extraOn, page, active = true, 1, false
	local rows, pager, toggle = {}, nil, nil

	-- the race file name, asked from the game only when the selected race or sex changes (asking it several times a
	-- second crashed the client after a few minutes inside Extensions.dll)
	local cachedKey, cachedFile
	local function RaceFile()
		if not (CharacterCreate and CharacterCreate.selectedRace) then
			return nil
		end
		local key = CharacterCreate.selectedRace .. ":" .. (CharacterCreate.selectedGender or 0)
		if key ~= cachedKey then
			cachedKey = key
			local ok, _, file = pcall(GetNameForRace)
			cachedFile = ok and file or nil
		end
		return cachedFile
	end
	local function EsteriaRace()
		local file = RaceFile()
		return file and BY_FILE[strupper(file)]
	end
	COA_EsteriaRace = function()        -- the choice list (coa_picker.lua): Esteria options only while they are shown
		return active and EsteriaRace()
	end

	local function Get(i)
		local ok, value, count, label = pcall(CycleCharCustomization, "EA_GET", i)
		if ok then
			return value, count, label
		end
	end

	local function Options()
		local list = {}
		for i = 1, MAX do
			local _, count = Get(i)
			if count and count > 1 then
				list[#list + 1] = i
			end
		end
		return list
	end

	local function Stock(show)
		for i = 1, 5 do
			local row = _G["CharCreateCustomizationButton" .. i]
			if row then
				if show then row:Show() else row:Hide() end
			end
		end
		if show and CharacterCreate_UpdateHairCustomization then
			pcall(CharacterCreate_UpdateHairCustomization)  -- the stock screen decides which of its rows to show
		end
	end

	local function Row(i)
		if not rows[i] then
			local parent = CharCreateCustomizationFrame
			local row = CreateFrame("CheckButton", "CoACustomizationRow" .. i, parent, "CharCreateCustomizationButtonTemplate")
			row:SetPoint("TOP", parent, "TOP", 0, -15 - (i - 1) * SPACING)
			row:SetFrameLevel((_G.CharCreateCustomizationButton1 or parent):GetFrameLevel())
			rows[i] = row
		end
		return rows[i]
	end

	local function Pager()
		if not pager then
			local parent = CharCreateCustomizationFrame
			pager = CreateFrame("Frame", "CoACustomizationPager", parent)
			pager:SetSize(190, 24)
			pager:SetPoint("BOTTOM", parent, "TOP", 0, 8)
			pager.text = pager:CreateFontString(nil, "ARTWORK", "GlueFontNormalSmall")
			pager.text:SetPoint("CENTER")
			for _, side in ipairs({"Prev", "Next"}) do
				local b = CreateFrame("Button", nil, pager)
				b:SetSize(28, 28)
				b:SetPoint(side == "Prev" and "LEFT" or "RIGHT")
				b:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-" .. side .. "Page-Up")
				b:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-" .. side .. "Page-Down")
				b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
				b:SetScript("OnClick", function()
					page = page + (side == "Prev" and -1 or 1)
					PlaySound("igMainMenuOptionCheckBoxOn")
					COA_EsteriaRefresh()
				end)
				pager[side] = b
			end
		end
		return pager
	end

	local function HideOurs()
		for _, row in pairs(rows) do
			row:Hide()
		end
		if pager then
			pager:Hide()
		end
	end

	-- draws the current page of Esteria options (or gives the stock rows back)
	function COA_EsteriaRefresh()
		local race = EsteriaRace()
		local panel = CharCreateCustomizationFrame
		local options = race and extraOn and panel and panel:IsVisible() and Options() or {}
		if #options == 0 then
			if active then
				active = false
				HideOurs()
				Stock(true)
			end
			return
		end
		active = true
		Stock(false)
		local pages = math.ceil(#options / PER_PAGE)
		page = math.max(1, math.min(page, pages))
		for slot = 1, PER_PAGE do
			local option = options[(page - 1) * PER_PAGE + slot]
			local row = Row(slot)
			if option then
				local value, count, label = Get(option)
				row:SetID(option)
				local name = (label and label ~= "" and label) or (race == 47 and MECH_LABELS[option])
					or (not NAMED[race] and LABELS[option]) or ("Option " .. option)
				if (race == 48 or race == 49) and label == "Belt" then
					row.text:SetText(name .. "  " .. (value == 0 and "None" or "Gem"))
				else
					row.text:SetText(name .. "  " .. ((value or 0) + 1) .. "/" .. (count or 0))
				end
				row:Show()
			else
				row:Hide()
			end
		end
		local p = Pager()
		if pages > 1 then
			p.text:SetText("Page " .. page .. " / " .. pages)
			if page > 1 then p.Prev:Show() else p.Prev:Hide() end
			if page < pages then p.Next:Show() else p.Next:Hide() end
			p:Show()
		else
			p:Hide()
		end
	end

	-- "Extra Customization" toggle, under the Customize step button
	local function Toggle()
		if not toggle then
			local anchor = CharacterCreateNavigationFrame and Enum and Enum.CharCreateSteps
				and CharacterCreateNavigationFrame:GetButtonByIndex(Enum.CharCreateSteps.Customization)
			toggle = CreateFrame("Button", "CoAExtraCustomizationButton", CharacterCreateFrame or CharacterCreate)
			toggle:SetSize(260, 48)
			if anchor then
				toggle:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -16)
			else
				toggle:SetPoint("TOPLEFT", CharacterCreateFrame or CharacterCreate, "TOPLEFT", 45, -330)
			end
			toggle.icon = toggle:CreateTexture(nil, "ARTWORK")
			toggle.icon:SetSize(44, 44)
			toggle.icon:SetPoint("LEFT")
			toggle.icon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")
			toggle.text = toggle:CreateFontString(nil, "ARTWORK", "GlueFontNormalSmall")
			toggle.text:SetPoint("LEFT", toggle.icon, "RIGHT", 12, 0)
			toggle.text:SetJustifyH("LEFT")
			toggle:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			toggle:SetScript("OnClick", function()
				extraOn = not extraOn
				page = 1
				PlaySound("gsCharacterCreationLook")
				COA_EsteriaRefresh()
			end)
		end
		return toggle
	end
	local function UpdateToggle()
		local race = EsteriaRace()
		local panel = CharCreateCustomizationFrame
		if not (race and panel and panel:IsVisible()) then
			if toggle then toggle:Hide() end
			return
		end
		local t = Toggle()
		if extraOn then
			t.text:SetText("|cff00ff00Extra Customization: ON|r|nClick for the basic options")
		else
			t.text:SetText("Extra Customization: OFF|n|cffffd100Click for all retail options|r")
		end
		t:Show()
	end

	-- the arrows of our rows (their ids are option numbers) cycle the Esteria option
	local left, right, randomize = CharacterCustomization_Left, CharacterCustomization_Right, CharacterCreate_Randomize
	function CharacterCustomization_Left(id)
		if active then
			PlaySound("gsCharacterCreationLook")
			pcall(CycleCharCustomization, "EA_CYCLE", id, -1)
			COA_EsteriaRefresh()
		else
			left(id)
		end
	end
	function CharacterCustomization_Right(id)
		if active then
			PlaySound("gsCharacterCreationLook")
			pcall(CycleCharCustomization, "EA_CYCLE", id, 1)
			COA_EsteriaRefresh()
		else
			right(id)
		end
	end
	function CharacterCreate_Randomize(...)
		if active then
			PlaySound("gsCharacterCreationLook")
			pcall(CycleCharCustomization, "EA_RANDOM", 1)
			COA_EsteriaRefresh()
		else
			return randomize(...)
		end
	end

	-- Highmountain keeps its real size: the Customize camera (set again on every option) steps back for it
	local ZOOM = {[46] = 1.6}
	local zoomAt
	if SetFaceCustomizeCamera then
		local setFace = SetFaceCustomizeCamera
		function SetFaceCustomizeCamera(...)
			local a, b, c = setFace(...)
			if ZOOM[EsteriaRace() or 0] then
				zoomAt = 0.35
			end
			return a, b, c
		end
	end
	local function Zoom(elapsed)
		if not zoomAt then
			return
		end
		zoomAt = zoomAt - elapsed
		if zoomAt > 0 then
			return
		end
		zoomAt = nil
		local k = ZOOM[EsteriaRace() or 0]
		if k and C_CharacterCreate and C_CharacterCreate.GetCameraPosition then
			pcall(function()
				local x, y, z = C_CharacterCreate.GetCameraPosition()
				C_CharacterCreate.SetCameraPosition(x * k, y * k, z * (1 + (k - 1) * 0.6))
			end)
		end
	end

	-- only when something changed (race, sex, step, toggle) and once a second while our rows are up:
	-- asking the DLL every frame ran the 32-bit client out of memory
	local ticker = CreateFrame("Frame")
	ticker:SetScript("OnUpdate", function(self, elapsed)
		Zoom(elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed < 0.25 or not (CharacterCreate and CharacterCreate:IsShown()) then
			return
		end
		self.elapsed = 0
		local file = RaceFile()
		local panel = CharCreateCustomizationFrame
		local key = (file or "") .. ":" .. (CharacterCreate.selectedGender or 0) .. ":" ..
			tostring(panel and panel:IsVisible()) .. ":" .. tostring(extraOn)
		if key ~= self.key and self.file ~= file then
			page = 1
			self.file = file
		end
		if key ~= self.key and panel and panel:IsVisible() and ZOOM[EsteriaRace() or 0] then
			zoomAt = 0.35                       -- Highmountain: step back once the Customize camera is set
		end
		self.slow = (self.slow or 0) + 1
		if key ~= self.key or (active and self.slow >= 4) then
			self.key, self.slow = key, 0
			local okRun, err = pcall(function()
				COA_EsteriaRefresh()
				UpdateToggle()
			end)
			if not okRun then
				COA_UI_ERROR = tostring(err)
			end
			if COA_UI_ERROR then                -- only shown when something failed (a screenshot tells what)
				if not self.status then
					self.status = (CharacterCreateFrame or CharacterCreate):CreateFontString(nil, "OVERLAY", "GlueFontNormalSmall")
					self.status:SetPoint("BOTTOMLEFT", CharacterCreateFrame or CharacterCreate, "BOTTOMLEFT", 70, 120)
				end
				self.status:SetText("|cffff4040CoA UI error: " .. COA_UI_ERROR .. "|r")
			end
		end
	end)
end
-- end Esteria native appearance controls

-- Local server: customization choice list
-- Click the name of a customization row: a list of every valid choice opens, click one to wear it. The arrows only
-- step through the choices that fit the current look (and the Esteria rows through their own encoding), so many
-- looks were only reachable through Randomize. Esteria races (66+) use the DLL's own options (EA_CHOICES / EA_SET);
-- every other race the stock rows 1-5 (EA_STOCK_CHOICES, applied by stepping the row to the value).
-- Needs the Esteria-patched Ascension.exe (CycleCharCustomization "EA_*"); without it nothing opens.
do
	local VISIBLE, ROW_HEIGHT = 12, 22
	-- Ascension's rows (CharCreateCustomizationButton1-5) and the Esteria option rows (esteria_options.lua)
	local ROWS = {"CharCreateCustomizationButton1", "CharCreateCustomizationButton2", "CharCreateCustomizationButton3",
		"CharCreateCustomizationButton4", "CharCreateCustomizationButton5", "CoACustomizationRow1", "CoACustomizationRow2",
		"CoACustomizationRow3", "CoACustomizationRow4", "CoACustomizationRow5", "CoACustomizationRow6"}
	local picker

	local function Esteria()
		return COA_EsteriaRace and COA_EsteriaRace()
	end

	local function State(frame)
		local ok, value, count, label
		if Esteria() then
			ok, value, count, label = pcall(CycleCharCustomization, "EA_GET", frame:GetID())
		elseif not frame.coaEsteria and frame:GetID() >= 1 and frame:GetID() <= 5 then
			ok, value, count = pcall(CycleCharCustomization, "EA_STOCK_GET", frame:GetID())
		end
		if ok and value and count then
			return value, count, label
		end
	end

	local function Choices(frame)
		local ok, encoded = pcall(CycleCharCustomization, Esteria() and "EA_CHOICES" or "EA_STOCK_CHOICES", frame:GetID())
		local list = {}
		if ok and type(encoded) == "string" then
			for choice in string.gmatch(encoded, "%d+") do
				list[#list + 1] = tonumber(choice)
			end
		end
		return list
	end

	local function Apply(frame, target)
		local id = frame:GetID()
		local value, count = State(frame)
		if not value or value == target then
			return
		end
		if Esteria() then
			pcall(CycleCharCustomization, "EA_SET", id, target)
		else
			for i = 1, count do                   -- stock rows: step until the row shows the wanted value
				local before = value
				CycleCharCustomization(id, 1)
				value = State(frame)
				if not value or value == target or value == before then
					break
				end
			end
		end
		if Esteria() and COA_EsteriaRefresh then
			pcall(COA_EsteriaRefresh)
		elseif CharacterCreate_UpdateHairCustomization then
			pcall(CharacterCreate_UpdateHairCustomization)
		end
	end

	local function Signature()
		return tostring(CharacterCreate.selectedRace) .. ":" .. tostring(CharacterCreate.selectedGender)
	end

	local function Refresh()
		for i, row in ipairs(picker.rows) do
			local choice = picker.choices[picker.offset + i]
			if choice then
				row.choice = choice
				row:SetText((picker.label ~= "" and picker.label .. " " or "") .. (choice + 1) ..
					(choice == picker.selected and "  |cffffd100<|r" or ""))
				row:Show()
			else
				row:Hide()
			end
		end
	end

	local function Scroll(_, delta)
		local top = math.max(0, #picker.choices - VISIBLE)
		picker.offset = math.min(top, math.max(0, picker.offset - delta))
		Refresh()
	end

	local function Build()
		picker = CreateFrame("Frame", "CoACustomizationChoiceMenu", CharacterCreateFrame or CharacterCreate)
		picker:SetFrameStrata("TOOLTIP")
		picker:SetClampedToScreen(true)
		picker:EnableMouse(true)
		picker:EnableMouseWheel(true)
		picker:SetScript("OnMouseWheel", Scroll)
		picker:SetBackdrop({bgFile = "Interface\\Glues\\Common\\Glue-Tooltip-Background",
			edgeFile = "Interface\\Glues\\Common\\Glue-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16,
			insets = {left = 5, right = 5, top = 5, bottom = 5}})
		picker.rows = {}
		for i = 1, VISIBLE do
			local row = CreateFrame("Button", nil, picker)
			row:SetSize(200, ROW_HEIGHT)
			row:SetPoint("TOPLEFT", 10, -8 - (i - 1) * ROW_HEIGHT)
			row:SetNormalFontObject(GlueFontNormalSmall)
			row:SetHighlightFontObject(GlueFontHighlightSmall)
			row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			row:EnableMouseWheel(true)
			row:SetScript("OnMouseWheel", Scroll)
			row:SetScript("OnClick", function(self)
				local owner = picker.owner
				picker:Hide()
				PlaySound("gsCharacterCreationLook")
				Apply(owner, self.choice)
			end)
			picker.rows[i] = row
		end
		picker:SetScript("OnUpdate", function(self, elapsed)
			self.elapsed = (self.elapsed or 0) + elapsed
			if self.elapsed > 0.2 then
				self.elapsed = 0
				if not self.owner:IsVisible() or Signature() ~= self.signature then
					self:Hide()
				end
			end
		end)
		picker:Hide()
	end

	local function Open(frame)
		if picker and picker:IsShown() then
			local same = picker.owner == frame
			picker:Hide()
			if same then
				return
			end
		end
		local value, count, label = State(frame)
		local choices = Choices(frame)
		if not value or #choices < 2 then
			return
		end
		if not picker then
			Build()
		end
		local text = frame.text or _G[frame:GetName() .. "Text"]
		label = label or (text and text:GetText() or "")
		label = label:gsub("%s+%d+/%d+$", ""):gsub("%s+None$", ""):gsub("%s+Gem$", "")
		picker.owner, picker.label, picker.choices, picker.selected = frame, label, choices, value
		picker.signature = Signature()
		local selectedRow = 1
		for i, choice in ipairs(choices) do
			if choice == value then
				selectedRow = i
			end
		end
		picker.offset = math.min(math.max(0, selectedRow - 6), math.max(0, #choices - VISIBLE))
		picker:ClearAllPoints()
		picker:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -2)
		picker:SetSize(220, 16 + math.min(VISIBLE, #choices) * ROW_HEIGHT)
		Refresh()
		picker:Show()
	end

	-- a click area over the name of every row (the stock template has none)
	local function Overlay(frame)
		if frame.coaPick then
			return
		end
		local text = frame.text or _G[frame:GetName() .. "Text"]
		local button = CreateFrame("Button", nil, frame)
		button:SetSize(170, 26)
		button:SetPoint("CENTER", text or frame, "CENTER", 0, 0)
		button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		button:SetScript("OnClick", function() Open(frame) end)
		button:SetScript("OnEnter", function(self)
			GlueTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GlueTooltip:SetText("Click: choose from the list", 1, 1, 1)
			GlueTooltip:Show()
		end)
		button:SetScript("OnLeave", function() GlueTooltip:Hide() end)
		frame.coaPick = button
	end

	local ticker = CreateFrame("Frame")
	ticker:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed < 0.5 then
			return
		end
		self.elapsed = 0
		for _, name in ipairs(ROWS) do
			local frame = _G[name]
			if frame then
				frame.coaEsteria = name:find("CoA") and true or nil
				Overlay(frame)
			end
		end
	end)

	local randomize = CharacterCreate_Randomize
	function CharacterCreate_Randomize(...)
		if picker then
			picker:Hide()
		end
		return randomize(...)
	end
end
-- end customization choice list

-- Local server: Jinyu id
CHAR_CREATE_RACE_IDS["Jinyu"] = {78}

-- Local server: Esteria package races
CHAR_CREATE_RACE_IDS["Darkfallen"] = {80, 81}
CHAR_CREATE_RACE_IDS["Sethrak"] = {82}
CHAR_CREATE_RACE_IDS["Gnoll"] = {83}
CHAR_CREATE_RACE_IDS["Saberon"] = {97}
if CHAR_CREATE_MALE_ONLY_RACES then CHAR_CREATE_MALE_ONLY_RACES["Gnoll"] = true; CHAR_CREATE_MALE_ONLY_RACES["Saberon"] = true end

-- Local server: Naga (race 21) hair customization. Its GetHairCustomization()/GetFacialHairCustomization() come
-- back empty for every non-stock race id (the native call only knows the original 1-11), which hides the Hair
-- Style / Hair Color / Facial Hair buttons entirely - not a DBC labeling issue, the ChrRaces string fields are
-- never read for a custom race id. Naga does have its own CharHairGeosets.dbc rows (10, confirmed) but no
-- CharacterFacialHairStyles.dbc catalog, so only Hair Style/Color are forced on here; Facial Hair is left as-is
-- (forcing a style selector with no catalog behind it risks cycling garbage). This overrides the two globals the
-- same way esteria_options.lua already overrides CharacterCustomization_Left/_Right for its own races.
if not COA_NAGA_HAIR_PATCHED then
	COA_NAGA_HAIR_PATCHED = true
	local realGetHairCustomization = GetHairCustomization
	function GetHairCustomization()
		if CharacterCreate and CharacterCreate.selectedRace == 21 then
			return "NORMAL"
		end
		return realGetHairCustomization()
	end
end
