if SimpleWowLFG == nil then
    SimpleWowLFG = CreateFrame("Frame", "SimpleWowLFGFrame");
end

function SimpleWowLFG:InitTables(force)
    --******This table must modified accordingly*******--
    if SimpleWowLFG.Constants == nil or force == true then
        SimpleWowLFG.Constants = {
            Name = "SimpleWowLFG",
            DisplayName = "Simple Wow LFG",
            Author = {
                Name = "Cidra",
                Email = "circadragos@yahoo.com",
                AltName = "",
            },
            SLASH1 = "/lfg",
            SLASH2 = "/simplewowlfg",
            Version = {
                Major = 0,
                Minor = 9,
                GetVersion = function() return SimpleWowLFG.Constants.Version.Major.."."..SimpleWowLFG.Constants.Version.Minor; end,
            },
            MainFrame = {
                Name = "MainFrame",
                Title = "Simple Wow LFG",
                Height = 140,
                Width = 230,
                FrameStrata = "MEDIUM",
                Help = true,
            },
        }
    end
end

function SimpleWowLFG:AddDungeon(name, size, minLevel, maxLevel, location, abbreviation, abbreviations, faction, background)
    SimpleWowLFG:InitTables(false)

    if SimpleWowLFG.Constants.Dungeons == nil then
        SimpleWowLFG.Constants.Dungeons = {}
    end

    if SimpleWowLFG.Constants.DungeonsCount == nil then
        SimpleWowLFG.Constants.DungeonsCount = 0
    end

    SimpleWowLFG.Constants.Dungeons[name] = {
        Name = name,
        MinLevel = minLevel,
        MaxLevel = maxLevel,
        Location = location,
        Faction = faction,
        Abbreviation = abbreviation,
        Abbreviations = abbreviations,
        Background = background,
        Size = size,
        GetColor = function(self)
            local lvl = UnitLevel("player")
            local minLvl, maxLvl = self.MinLevel - 2, self.MaxLevel + 2
            local int = (self.MaxLevel - self.MinLevel) / 3
            if lvl < minLvl then --red
                return '|cffff0000'
            elseif minLvl < lvl and lvl < minLvl + int then -- orange
                return '|cffeb8f34'
            elseif minLvl + int < lvl and lvl <= minLvl + int * 2 then -- yellow
                return '|cfffff53d'
            elseif minLvl + int * 2 < lvl and lvl < maxLvl then -- green
                return '|cff26c71e'
            elseif maxLvl < lvl then -- gray
                return '|cff9c9c9c'
            else -- white
                return '|cffffffff'
            end
        end
    }
    SimpleWowLFG.Constants.DungeonsCount = SimpleWowLFG.Constants.DungeonsCount + 1
end

function SimpleWowLFG:GetDungeonsSorted()
    local dungeons = {}
    for _,v in pairs(SimpleWowLFG.Constants.Dungeons) do
        table.insert( dungeons,v)
    end

    table.sort(dungeons, function(a,b)
        return a.MinLevel < b.MinLevel
    end)
    return dungeons
end

SimpleWowLFG:AddDungeon("Ragefire Chasm", 5, 13, 18, "Orgrimmar", "rfc", {"rfc", "ragefire"}, SimpleWowLFG.E.Faction.HORDE, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAGEFIRECHASM")
SimpleWowLFG:AddDungeon("Wailing Caverns", 5, 17, 24, "Barrens", "wc", {"wc"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-WAILINGCAVERNS")
SimpleWowLFG:AddDungeon("The Deadmines", 5, 15, 25, "Westfall", "vc", {"dm", "vc", "deadmines"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-DEADMINES")
SimpleWowLFG:AddDungeon("Shadowfang Keep", 5, 22, 30, "Silverpine Forest", "sfk", {"sfk", "shadowfang"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SHADOWFANGKEEP")
SimpleWowLFG:AddDungeon("Blackfathom Deeps", 5, 24, 32, "Ashenvale", "bfd", {"bfd"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKFATHOMDEEPS")
SimpleWowLFG:AddDungeon("The Stockades", 5, 22, 32, "Stormwind", "stockades", {"stockades", "stocks"}, SimpleWowLFG.E.Faction.ALLIANCE, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-STORMWINDSTOCKADES")
SimpleWowLFG:AddDungeon("Gnomeregan", 5, 29, 38, "Dun Morogh", "gnomergan", {"gnomeregan", "gnomer"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-GNOMEREGAN")
SimpleWowLFG:AddDungeon("Razorfen Kraul", 5, 28, 38, "Barrens", "rfk", {"rfk", "kraul"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAZORFENKRAUL")
SimpleWowLFG:AddDungeon("The Scarlet Monastery: Graveyard", 5, 24, 34, "Tirisfal Glades", "sm graveyard", {"sm", "SM GY"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
SimpleWowLFG:AddDungeon("The Scarlet Monastery: Library", 5, 29, 39, "Tirisfal Glades", "sm library", {"sm"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
SimpleWowLFG:AddDungeon("The Scarlet Monastery: Armory", 5, 32, 42, "Tirisfal Glades", "sm armory", {"sm"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
SimpleWowLFG:AddDungeon("The Scarlet Monastery: Cathedral", 5, 34, 44, "Tirisfal Glades", "sm cathedral", {"sm"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
SimpleWowLFG:AddDungeon("Razorfen Downs", 5, 33, 43, "Barrens", "rfd", {"rfd"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAZORFENDOWNS")
SimpleWowLFG:AddDungeon("Uldaman", 5, 42, 52, "Badlands", "ulda", {"ulda"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-ULDAMAN")
SimpleWowLFG:AddDungeon("Zul'Farak", 5, 40, 48, "Tanaris", "zf", {"zf"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-ZULFARAK")
SimpleWowLFG:AddDungeon("Maraudon", 5, 46, 55, "Desolace", "maraudon", {"maraudon", "mara"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-MARAUDON")
SimpleWowLFG:AddDungeon("Temple of Atal'Hakkar", 5, 49, 58, "Swamp of Sorrows", "st", {"st", "toa", "atal", "sunken temple"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SUNKENTEMPLE")
SimpleWowLFG:AddDungeon("Blackrock Depths", 5, 52, 60, "Blackrock Mountain", "brd", {"brd"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKDEPTHS")
SimpleWowLFG:AddDungeon("Lower Blackrock Spire", 10, 56, 60, "Blackrock Mountain", "lbrs", {"lbrs"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKSPIRE")
SimpleWowLFG:AddDungeon("Upper Blackrock Spire", 10, 56, 60, "Blackrock Mountain", "ubrs", {"ubrs"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKSPIRE")
SimpleWowLFG:AddDungeon("Stratholme", 5, 56, 60, "Eastern Plaguelands", "strat", {"strat"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-STRATHOLME")
SimpleWowLFG:AddDungeon("Scholomance", 5, 56, 60, "Eastern Plaguelands", "scholo", {"scholo"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCHOLOMANCE")
SimpleWowLFG:AddDungeon("Molten Core", 40, 60, 60, "Blackrock Depths", "mc", {"mc"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-MOLTENCORE")
SimpleWowLFG:AddDungeon("Onyxia's Lair", 40, 60, 60, "Dustwallow Marsh", "ony", {"ony", "onyxia"}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\LFGIcon-OnyxiaEncounter")
-- SimpleWowLFG:AddDungeon("Custom", 40, 1, 120, "Everywhere", "", {}, SimpleWowLFG.E.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BREW")

