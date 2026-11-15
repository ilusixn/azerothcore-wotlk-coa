
function DressUpItemLink(link, undress)
	if not link then
		return;
	end

	local itemID = GetItemInfoFromHyperlink(link)
	local vanityData = VanityCollectionUtil.GetItem(itemID)
	if vanityData then
		local preview = vanityData.creaturePreview
		if preview and preview > 0 then
			if not DressUpFrame:IsShown() then
				ShowUIPanel(DressUpFrame);
			end
			DressUpModel:SetDisplayInfo(preview)
			DressUpModel:ResetValues()
			DressUpModel.isCreature = true
			return
		end
		
		preview = vanityData.spellPreview
		if preview and preview > 0 then
			if not DressUpFrame:IsShown() then
				ShowUIPanel(DressUpFrame);
				DressUpModel:SetUnit("player")
			end

			if DressUpModel.isCreature then
				DressUpModel:SetUnit("player")
				DressUpModel:ResetValues()
				DressUpModel.isCreature = false
			end
			DressUpModel:SetSpell(preview)
			DressUpModel:RefreshValues()
			return
		end
		
		if vanityData.contentsPreview and #vanityData.contentsPreview > 0 then
			if not DressUpFrame:IsShown() then
				ShowUIPanel(DressUpFrame)
				DressUpModel:SetUnit("player")
			end

			if DressUpModel.isCreature then
				DressUpModel:SetUnit("player")
				DressUpModel:ResetValues()
				DressUpModel.isCreature = false
			end

			if undress then
				DressUpModel:Undress()
			end

			for _, contentItemID in ipairs(vanityData.contentsPreview) do
				DressUpModel:TryOn(contentItemID)
			end

			DressUpModel:RefreshValues()
			return
		end
	end

    if not IsDressableItem(link) then
        return
    end

	if ( not DressUpFrame:IsShown() ) then
		ShowUIPanel(DressUpFrame);
        DressUpModel:SetUnit("player");
	end

    if DressUpModel.isCreature then
        DressUpModel:SetUnit("player")
        DressUpModel:ResetValues()
        DressUpModel.isCreature = false
    end

	if undress then
		DressUpModel:Undress()
	end
	DressUpModel:TryOn(link);
    DressUpModel:RefreshValues()
end

function DressUpCreature(creatureID)
	if not creatureID or creatureID == 0 then return end
	if not DressUpFrame:IsShown() then
		ShowUIPanel(DressUpFrame)
	end
	DressUpModel:SetDisplayInfo(creatureID)
	DressUpModel:ResetValues()
	DressUpModel.isCreature = true
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

function DressUpTexturePath(fileName, atlas)
	if not fileName then
		fileName = select(2, UnitRace("player"))
	end
	fileName = GetDressUpRaceFileName(fileName)

	if ( not fileName ) then
		fileName = "Orc";
	end
	
	if atlas then
		return "DressUpBackground-"..fileName
	end

	return "Interface\\DressUpFrame\\DressUpBackground-"..fileName;
end

function SetDressUpBackground()
	local texture = DressUpTexturePath();
	DressUpBackgroundTopLeft:SetTexture(texture..1);
	DressUpBackgroundTopRight:SetTexture(texture..2);
	DressUpBackgroundBotLeft:SetTexture(texture..3);
	DressUpBackgroundBotRight:SetTexture(texture..4);
end


-- ---------------------------------------------------------------------------
-- Descension: Hintergrund des Anprobefensters
--
-- Statt vier Dateien je Rasse eine Kachel aus DressUpAtlas.blp. Die Kachel ist
-- 318x332, die vier Flaechen der XML zusammen 318x383 - waagerecht passt es
-- also genau, senkrecht wird gestreckt.
-- ---------------------------------------------------------------------------
local DESCENSION_ATLAS = [[Interface\DressUpFrame\DressUpAtlas]]

-- Kachelkanten im Blatt (2048x1024), als Anteil.
local DESCENSION_KACHEL = {
    Alliance = { l = 960 / 2048, r = 1278 / 2048, o = 0 / 1024,   u = 332 / 1024 },
    Horde    = { l = 640 / 2048, r = 958 / 2048,  o = 333 / 1024, u = 665 / 1024 },
}

-- Die XML macht den Hintergrund 383 hoch (255 oben + 128 unten), das Modell
-- ist aber nur 331 hoch und beginnt bei derselben Kante. Der Hintergrund ragte
-- also 52 Pixel darunter hinaus, sichtbar unter dem Modellrahmen. Die unteren
-- beiden Flaechen kommen deshalb auf 76 statt 128: 255 + 76 = 331.
local DESCENSION_UNTEN = 76
local DESCENSION_HOEHE = 255 + DESCENSION_UNTEN

-- Die Trennlinien der vier Flaechen: links 256 von 318 breit, oben 255 von 331.
local DESCENSION_X = 256 / 318
local DESCENSION_Y = 255 / DESCENSION_HOEHE

function SetDressUpBackground()
    local seite = UnitFactionGroup("player")
    local k = DESCENSION_KACHEL[seite] or DESCENSION_KACHEL.Alliance

    local xm = k.l + (k.r - k.l) * DESCENSION_X
    local ym = k.o + (k.u - k.o) * DESCENSION_Y

    local flaechen = {
        { DressUpBackgroundTopLeft,  k.l, xm,  k.o, ym  },
        { DressUpBackgroundTopRight, xm,  k.r, k.o, ym  },
        { DressUpBackgroundBotLeft,  k.l, xm,  ym,  k.u },
        { DressUpBackgroundBotRight, xm,  k.r, ym,  k.u },
    }

    for _, f in ipairs(flaechen) do
        local textur = f[1]
        if textur then
            textur:SetTexture(DESCENSION_ATLAS)
            textur:SetTexCoord(f[2], f[3], f[4], f[5])
        end
    end

    if DressUpBackgroundBotLeft then
        DressUpBackgroundBotLeft:SetHeight(DESCENSION_UNTEN)
    end
    if DressUpBackgroundBotRight then
        DressUpBackgroundBotRight:SetHeight(DESCENSION_UNTEN)
    end
end

-- Die XML ruft SetDressUpBackground nur im OnLoad auf. Zu dem Zeitpunkt kennt
-- UnitFactionGroup die Seite oft noch nicht, deshalb zusaetzlich bei jedem
-- Oeffnen - das kostet nichts und faengt auch einen Fraktionswechsel ab.
local descension_wache = CreateFrame("Frame")
descension_wache:RegisterEvent("PLAYER_ENTERING_WORLD")
descension_wache:SetScript("OnEvent", function(self)
    if DressUpFrame and not self.verbunden then
        self.verbunden = true
        DressUpFrame:HookScript("OnShow", SetDressUpBackground)
    end
    SetDressUpBackground()
end)
