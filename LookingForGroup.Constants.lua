if LookingForGroup == nil then
    LookingForGroup = CreateFrame("Frame", "LookingForGroupFrame");
end

function LookingForGroup:InitTables(force)
    --******This table must modified accordingly*******--
    if LookingForGroup.Constants == nil or force == true then
        LookingForGroup.Constants = {
            Name = "LookingForGroup",
            DisplayName = "Looking For Group",
            Author = {
                Name = "Cidra",
                Email = "circadragos@yahoo.com",
                AltName = "",
            },
            SLASH1 = "/lfg",
            SLASH2 = "/lookingforgroup",
            Version = {
                Major = 0,
                Minor = 9,
                GetVersion = function() return LookingForGroup.Constants.Version.Major.."."..LookingForGroup.Constants.Version.Minor; end,
            },
            MainFrame = {
                Name = "MainFrame",
                Title = "Looking For Group",
                Height = 140,
                Width = 230,
                FrameStrata = "MEDIUM",
                Help = true,
            },
        }
    end
end

function LookingForGroup:AddDungeon(name, size, minLevel, maxLevel, location, abbreviation, abbreviations, faction, background)
    LookingForGroup:InitTables(false)

    if LookingForGroup.Constants.Dungeons == nil then
        LookingForGroup.Constants.Dungeons = {}
    end

    if LookingForGroup.Constants.Dungeons.count == nil then
        LookingForGroup.Constants.Dungeons.count = 0
    end

    LookingForGroup.Constants.Dungeons[name] = {
        Name = name,
        MinLevel = minLevel,
        MaxLevel = maxLevel,
        Location = location,
        Faction = faction,
        Abbreviation = abbreviation,
        Abbreviations = abbreviations,
        Background = background,
        Size = size,
        GetColor = function()
            local lvl = UnitLevel("player")
            local minLvl, maxLvl = self.MinLevel - 2, self.MaxLevel + 2
            local int = (self.MaxLevel - self.MinLevel) / 3
            if lvl < minLvl then
                return '|cffff0000'
            elseif minLvl < lvl and lvl < minLvl + int then
                return '|cffeb8f34'                
            elseif minLvl + int < lvl and lvl < minLvl + int * 2 then
                return '|cfffff53d'                 
            elseif minLvl + int * 2 < lvl and lvl < maxLvl then
                return '|cff26c71e'                
            elseif maxLvl < lvl then
                return '|cff9c9c9c'
            end
        end
    }
    LookingForGroup.Constants.Dungeons.count = LookingForGroup.Constants.Dungeons.count + 1
end

LookingForGroup:AddDungeon("Ragefire Chasm", 5, 12, 21, "Orgrimmar", "rfc", {"rfc", "ragefire"}, ClassicLFG.Faction.HORDE, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAGEFIRECHASM")
LookingForGroup:AddDungeon("Wailing Caverns", 5, 15, 25, "Barrens", "wc", {"wc"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-WAILINGCAVERNS")
LookingForGroup:AddDungeon("The Deadmines", 5, 14, 24, "Westfall", "vc", {"dm", "vc", "deadmines"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-DEADMINES")
LookingForGroup:AddDungeon("Shadowfang Keep", 5, 16, 27, "Silverpine Forest", "sfk", {"sfk", "shadowfang"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SHADOWFANGKEEP")
LookingForGroup:AddDungeon("Blackfathom Deeps", 5, 20, 30, "Ashenvale", "bfd", {"bfd"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKFATHOMDEEPS")
LookingForGroup:AddDungeon("The Stockades", 5, 21, 30, "Stormwind", "stockades", {"stockades", "stocks"}, ClassicLFG.Faction.ALLIANCE, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-STORMWINDSTOCKADES")
LookingForGroup:AddDungeon("Gnomeregan", 5, 25, 35, "Dun Morogh", "gnomergan", {"gnomeregan", "gnomer"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-GNOMEREGAN")
LookingForGroup:AddDungeon("Razorfen Kraul", 5, 22, 32, "Barrens", "rfk", {"rfk", "kraul"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAZORFENKRAUL")
LookingForGroup:AddDungeon("The Scarlet Monastery: Graveyard", 5, 25, 35, "Tirisfal Glades", "sm graveyard", {"sm", "SM GY"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
LookingForGroup:AddDungeon("The Scarlet Monastery: Library", 5, 29, 39, "Tirisfal Glades", "sm library", {"sm"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
LookingForGroup:AddDungeon("The Scarlet Monastery: Armory", 5, 32, 42, "Tirisfal Glades", "sm armory", {"sm"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
LookingForGroup:AddDungeon("The Scarlet Monastery: Cathedral", 5, 34, 44, "Tirisfal Glades", "sm cathedral", {"sm"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCARLETMONASTERY")
LookingForGroup:AddDungeon("Razorfen Downs", 5, 33, 43, "Barrens", "rfd", {"rfd"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RAZORFENDOWNS")
LookingForGroup:AddDungeon("Uldaman", 5, 35, 45, "Badlands", "ulda", {"ulda"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-ULDAMAN")
LookingForGroup:AddDungeon("Zul'Farak", 5, 40, 50, "Tanaris", "zf", {"zf"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-ZULFARAK")
LookingForGroup:AddDungeon("Maraudon", 5, 44, 54, "Desolace", "maraudon", {"maraudon", "mara"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-MARAUDON")
LookingForGroup:AddDungeon("Temple of Atal'Hakkar", 5, 47, 60, "Swamp of Sorrows", "st", {"st", "toa", "atal", "sunken temple"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SUNKENTEMPLE")
LookingForGroup:AddDungeon("Blackrock Depths", 5, 49, 60, "Blackrock Mountain", "brd", {"brd"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKDEPTHS")
LookingForGroup:AddDungeon("Lower Blackrock Spire", 10, 55, 60, "Blackrock Mountain", "lbrs", {"lbrs"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKSPIRE")
LookingForGroup:AddDungeon("Upper Blackrock Spire", 10, 55, 60, "Blackrock Mountain", "ubrs", {"ubrs"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKROCKSPIRE")
LookingForGroup:AddDungeon("Stratholme", 5, 56, 60, "Eastern Plaguelands", "strat", {"strat"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-STRATHOLME")
LookingForGroup:AddDungeon("Scholomance", 5, 56, 60, "Eastern Plaguelands", "scholo", {"scholo"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-SCHOLOMANCE")
LookingForGroup:AddDungeon("Molten Core", 40, 60, 60, "Blackrock Depths", "mc", {"mc"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-MOLTENCORE")
LookingForGroup:AddDungeon("Onyxia's Lair", 40, 60, 60, "Dustwallow Marsh", "ony", {"ony", "onyxia"}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\LFGIcon-OnyxiaEncounter")
LookingForGroup:AddDungeon("Custom", 40, 1, 120, "Everywhere", "", {}, ClassicLFG.Faction.BOTH, "Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BREW")

