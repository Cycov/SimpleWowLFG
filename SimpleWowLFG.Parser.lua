if SimpleWowLFG == nil then
    SimpleWowLFG = CreateFrame("Frame", "SimpleWowLFGFrame");
end

if SimpleWowLFG.Parser == nil then
    SimpleWowLFG.Parser = {}
end

SimpleWowLFG.Parser.Tags = {
    lfg = {
        'lfg'
    },
    lfm = {
        "lfm",
        "lf3m",
        "lf2m",
        "lf1m",
        "looking for more"
    }
}

function SimpleWowLFG.Parser:FindLFTag(text)
    local found
    for _, tag in pairs(SimpleWowLFG.Parser.Tags.lfm) do
        if (string.find(text, tag)) then
            found = true
            break
        end
    end
    if found then
        return SimpleWowLFG.Parser.Tags.lfm
    else
        for _, tag in pairs(SimpleWowLFG.Parser.Tags.lfg) do
            if (string.find(text, tag)) then
                found = true
                break
            end
        end
    end
    if found then
        return SimpleWowLFG.Parser.Tags.lfg
    else
        return nil
    end    
end

function SimpleWowLFG.Parser:FindDungeon(text)
    local found
    for name,value in pairs(SimpleWowLFG.Constants.Dungeons) do
        if string.find(text, string.lower(name)) then
            found = value
        end
    end
    
    if found == nil then
        for name,value in pairs(SimpleWowLFG.Constants.Dungeons) do
            for _, abbr in pairs(value.Abbreviations) do
               if string.find(text, abbr) then
                    found = value
               end
            end            
        end
    end

    for key, dungeon in pairs(ClassicLFG.DungeonManager.Dungeons) do
        for _, abbreviation in pairs(dungeon.Abbreviations) do
            if (ClassicLFG:ArrayContainsValue(message:SplitString(" "), abbreviation)) then
                return dungeon
            end
        end
    end
    return found
end

function SimpleWowLFG.Parser:Parse(message)
    local parsed = {
        original = message
    }
    message = string.lower(message)
end