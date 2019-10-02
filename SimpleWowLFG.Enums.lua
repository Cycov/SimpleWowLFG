if SimpleWowLFG == nil then
    SimpleWowLFG = CreateFrame("Frame", "SimpleWowLFGFrame");
end

if SimpleWowLFG.E == nil then
    SimpleWowLFG.E = {
        Faction = {
            HORDE = -1,
            ALLIANCE = 1,
            BOTH = 0,
            NONE = 2
        }
    }
end