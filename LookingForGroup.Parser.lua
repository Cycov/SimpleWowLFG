if LookingForGroup == nil then
    LookingForGroup = CreateFrame("Frame", "LookingForGroupFrame");
end

if LookingForGroup.Parser == nil then
    LookingForGroup.Parser = {}
end

LookingForGroup.Parser.Tags = {
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

function LookingForGroup.Parser:FindLFTag(text)
    local found
    for _, tag in pairs(LookingForGroup.Parser.Tags.lfm) do
        if (string.find(text, tag)) then
            found = true
            break
        end
    end
    if found then
        return LookingForGroup.Parser.Tags.lfm
    else
        for _, tag in pairs(LookingForGroup.Parser.Tags.lfg) do
            if (string.find(text, tag)) then
                found = true
                break
            end
        end
    end
    if found then
        return LookingForGroup.Parser.Tags.lfg
    else
        return nil
    end    
end

function LookingForGroup.Parser:FindDungeon(text)
    local found
    for name,value in pairs(LookingForGroup.Constants.Dungeons) do
        if string.find(text, string.lower(name)) then
            found = value
        end
    end
    if found == nil then
        for name,value in pairs(LookingForGroup.Constants.Dungeons) do
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
    end
    return found
end

function LookingForGroup.Parser:Parse(message)
    local parsed = {
        original = message
    }
    message = string.lower(message)

end